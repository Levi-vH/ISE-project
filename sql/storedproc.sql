USE SBBWorkshopOmgeving
GO

/*
Procedure order:
- SELECT procedures
- INSERT procedures
- UPDATE procedures
- DELETE procedures
*/

/*==============================================================*/
/* SP Type: SELECT                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_getWorkshops
(
@orderby		VARCHAR(40) = null,
@orderdirection	VARCHAR(4) = null,
@where			INT = null
)
AS
BEGIN
	SET NOCOUNT ON

	IF(@orderby IS NULL)
		BEGIN
			SET @orderby = 'W.WORKSHOP_ID'
		END

	IF(@orderdirection IS NULL)
		BEGIN
			SET @orderdirection = 'ASC'
		END


	DECLARE @query VARCHAR(2040)
	SET @query = '
	SELECT W.WORKSHOP_ID, W.TYPE,W.DATUM, STARTTIJD, EINDTIJD, W.ADRES, W.POSTCODE, W.PLAATSNAAM, STATUS, OPMERKING, VERWERKT_BREIN,DEELNEMER_GEGEVENS_ONTVANGEN,OVK_BEVESTIGING,
	PRESENTIELIJST_VERSTUURD, PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL, O.ORGANISATIENAAM, M.MODULENAAM, WL.VOORNAAM AS WORKSHOPLEIDER_VOORNAAM
	, WL.ACHTERNAAM AS WORKSHOPLEIDER_ACHTERNAAM, WL.TOEVOEGING,
	A.VOORNAAM AS ADVISEUR_VOORNAAM, A.ACHTERNAAM AS ADVISEUR_ACHTERNAAM, A.TELEFOONNUMMER AS ADVISEUR_TELEFOON_NUMMER, A.EMAIL AS ADVISEUR_EMAIL,
	C.VOORNAAM AS CONTACTPERSOON_VOORNAAM, C.ACHTERNAAM AS CONTACTPERSOON_ACHTERNAAM, C.TELEFOONNUMMER AS CONTACTPERSON_TELEFOONNUMMER,
	C.EMAIL AS CONTACTPERSOON_EMAIL, (SELECT COUNT(*) FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = W.WORKSHOP_ID) AS AANTAL_DEELNEMER_AANVRAAG,
	(SELECT COUNT(*) FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = W.WORKSHOP_ID AND IS_GOEDGEKEURD = 1) AS AANTAL_GOEDGEKEURDE_DEELNEMERS FROM WORKSHOP W
	INNER JOIN ORGANISATIE O ON W.ORGANISATIENUMMER = O.ORGANISATIENUMMER
	INNER JOIN MODULE M ON W.MODULENUMMER = M.MODULENUMMER
	LEFT JOIN WORKSHOPLEIDER WL ON  W.WORKSHOPLEIDER_ID = WL.WORKSHOPLEIDER_ID
	INNER JOIN ADVISEUR A ON W.ADVISEUR_ID = A.ADVISEUR_ID
	INNER JOIN CONTACTPERSOON C ON W.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID'

	IF(@where IS NOT null)
	BEGIN
		SET @query = @query + ' WHERE WORKSHOP_ID =' + CAST(@where AS VARCHAR(5))
	END


	SET @query = @query + ' ORDER BY ' + @orderby + ' ' + @orderdirection

	EXEC(@query)

END
GO

CREATE OR ALTER PROC proc_getWorkshopRequest
(
@aanvrag_id INT = NULL
)
AS
BEGIN

DECLARE @query VARCHAR(400)

SET @query = 'SELECT * FROM AANVRAAG A
INNER JOIN ORGANISATIE O ON A.ORGANISATIE_ID = O.ORGANISATIENUMMER
INNER JOIN CONTACTPERSOON C ON A.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
INNER JOIN ADVISEUR AD ON A.ADVISEUR_ID = AD.ADVISEUR_ID
'

IF(@aanvrag_id IS NOT NULL)
	BEGIN
		SET @query = @query + 'WHERE AANVRAAG_ID = ' + CAST(@aanvrag_id AS varchar(10))
	END

PRINT @query

EXEC(@query)

END
GO

CREATE OR ALTER PROC proc_request_approved_workshop_participants
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT TOP 16	D.DEELNEMER_ID, VOORNAAM, ACHTERNAAM
	FROM			DEELNEMER_IN_WORKSHOP DW INNER JOIN DEELNEMER D
	ON				DW.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE			WORKSHOP_ID = @workshop_id
	AND				IS_GOEDGEKEURD = 1
	ORDER BY		VOLGNUMMER
END
GO

CREATE OR ALTER PROC proc_request_approved_workshop_participants_reservelist
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT		D.DEELNEMER_ID, VOORNAAM, ACHTERNAAM
	FROM		DEELNEMER_IN_WORKSHOP DW INNER JOIN DEELNEMER D
	ON			DW.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE		WORKSHOP_ID = @workshop_id
	AND			IS_GOEDGEKEURD = 1
	AND			VOLGNUMMER NOT IN	(
									SELECT TOP 16	VOLGNUMMER
									FROM			DEELNEMER_IN_WORKSHOP DW INNER JOIN DEELNEMER D
									ON				DW.DEELNEMER_ID = D.DEELNEMER_ID
									WHERE			WORKSHOP_ID = @workshop_id
									AND				IS_GOEDGEKEURD = 1
									)
	ORDER BY	VOLGNUMMER
END
GO

CREATE OR ALTER PROC proc_request_not_approved_workshop_participants
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT		D.DEELNEMER_ID, VOORNAAM, ACHTERNAAM
	FROM		DEELNEMER_IN_WORKSHOP DW INNER JOIN DEELNEMER D
	ON			DW.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE		WORKSHOP_ID = @workshop_id
	AND			IS_GOEDGEKEURD = 0
	ORDER BY	VOLGNUMMER
END
GO

/*==============================================================*/
/* SP Type: INSERT                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_create_workshop
(
@workshoptype		VARCHAR(3),
@workshopdate		varchar(10),
@modulenummer		INT,
@organisatienummer	VARCHAR(15),
@workshopsector		VARCHAR(255),
@workshopstarttime	varchar(10),
@workshopendtime	varchar(10),
@workshopaddress	varchar(10),
@workshoppostcode	VARCHAR(12),
@workshopcity		VARCHAR(255),
@workshopleader		VARCHAR(100),
@workshopNote		VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON
	/*

	Create a workshop based on the given parameters

	*/

	DECLARE @status VARCHAR(40)
	SET @status = 'uitgezet'

	IF(@workshopleader IS NOT NULL)
		BEGIN
			SET @status = 'bevestigd'
		END

	-- If a workshop is NOT from IND, the workshopsector MUST be filled in

	IF( @workshoptype != 'IND' AND @workshopsector IS NULL )
		BEGIN
			RAISERROR('Een workshop met type IND MOET een workshopsector hebben',16,1)
		END

	INSERT INTO WORKSHOP
	VALUES	(@workshopleader,
			(SELECT CONTACTPERSOON_ID FROM CONTACTPERSOON WHERE ORGANISATIENUMMER = @organisatienummer)
			,@organisatienummer,@modulenummer
			,(SELECT ADVISEUR_ID FROM ADVISEUR WHERE ORGANISATIENUMMER = @organisatienummer),
			@workshopsector, @workshopdate,@workshopstarttime,
			@workshopendtime, @workshopaddress,@workshoppostcode,
			@workshopcity,@status,
			@workshopNote, @workshoptype ,null,null,null,null,null,null)
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag
(
@organisatie_ID INT,
@contactpersoon_ID INT,
@adviseur_ID INT,
@SBB_planner VARCHAR(50),
@aantal_groepen INT
)
AS
BEGIN

	INSERT INTO AANVRAAG VALUES (@organisatie_ID, @contactpersoon_ID,@adviseur_ID,@SBB_planner,@aantal_groepen)

END
GO

/*==============================================================*/
/* SP Type: UPDATE                                              */
/*==============================================================*/
CREATE OR ALTER PROC proc_approve_workshop_participants
(
@workshop_id	INT,
@deelnemer_id	INT
)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE DEELNEMER_IN_WORKSHOP
	SET IS_GOEDGEKEURD = 1
	WHERE WORKSHOP_ID = @workshop_id
	AND DEELNEMER_ID = @deelnemer_id
END
GO

CREATE OR ALTER PROC proc_update_workshop
(
@workshop_id		INT,
@workshoptype		VARCHAR(3),
@workshopdate		varchar(10),
@modulenummer		INT,
@organisatienummer	VARCHAR(15),
@workshopsector		VARCHAR(255),
@workshopstarttime	varchar(10),
@workshopendtime	varchar(10),
@workshopaddress	varchar(10),
@workshoppostcode	VARCHAR(12),
@workshopcity		VARCHAR(255),
@workshopleader		VARCHAR(100),
@workshopNote		VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	UPDATE WORKSHOP
	SET	[TYPE] = @workshoptype,		
		DATUM = @workshopdate,		
		MODULENUMMER = @modulenummer,		
		ORGANISATIENUMMER = @organisatienummer,	
		SECTORNAAM = @workshopsector,		
		STARTTIJD = @workshopstarttime,	
		EINDTIJD = @workshopendtime,	
		ADRES = @workshopaddress,	
		POSTCODE = @workshoppostcode,	
		PLAATSNAAM = @workshopcity,		
		WORKSHOPLEIDER_ID = @workshopleader,		
		OPMERKING = @workshopNote		
		WHERE WORKSHOP_ID = @workshop_id
END
GO

/*==============================================================*/
/* SP Type: DELETE                                              */
/*==============================================================*/
CREATE OR ALTER PROC proc_disapprove_workshop_participants
(
@workshop_id	INT,
@deelnemer_id	INT
)
AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM DEELNEMER_IN_WORKSHOP
	WHERE WORKSHOP_ID = @workshop_id
	AND DEELNEMER_ID = @deelnemer_id
END
GO