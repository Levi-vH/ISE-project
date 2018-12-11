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

CREATE OR ALTER PROC proc_get_workshops
(
@orderby		VARCHAR(40) = NULL,
@orderdirection	VARCHAR(4) = NULL,
@where			INT = NULL
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
	PRESENTIELIJST_VERSTUURD, PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL, O.ORGANISATIENAAM, M.MODULENAAM,M.MODULENUMMER, WL.VOORNAAM AS WORKSHOPLEIDER_VOORNAAM
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

CREATE OR ALTER PROC proc_get_workshoprequests
(
@aanvraag_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @aanvraag_id2 INT
	SET @sql =	N'
				SELECT	(C.VOORNAAM + C.ACHTERNAAM) AS CONTACTPERSOONNAAM,
						(AD.VOORNAAM + AD.ACHTERNAAM) AS ADVISEURNAAM,
						AANVRAAG_DATUM
				FROM	AANVRAAG A INNER JOIN
						ORGANISATIE O ON A.ORGANISATIENUMMER = O.ORGANISATIENUMMER INNER JOIN
						CONTACTPERSOON C ON A.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID INNER JOIN
						ADVISEUR AD ON A.ADVISEUR_ID = AD.ADVISEUR_ID
				WHERE	AANVRAAG_ID = @aanvraag_id2
				'
	SET @aanvraag_id2 = @aanvraag_id
	EXEC sp_executesql @sql, N'@aanvraag_id2 INT', @aanvraag_id2
END
GO

CREATE OR ALTER PROC proc_request_groups
(
@aanvraag_id	INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @query VARCHAR(400)

	SET @query = 'SELECT *, ISNULL((
							SELECT COUNT(*)
							FROM DEELNEMER_IN_AANVRAAG DA
							WHERE DA.AANVRAAG_ID = G.AANVRAAG_ID
							GROUP BY DEELNEMER_ID
							), 0) AS AANTAL_DEELNEMERS
	FROM GROEP G
	INNER JOIN CONTACTPERSOON C ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
	'

	IF(@aanvraag_id IS NOT NULL)
		BEGIN
			SET @query = @query + 'WHERE AANVRAAG_ID = ' + CAST(@aanvraag_id AS varchar(10))
		END

	EXEC(@query)
END
GO

CREATE OR ALTER PROC proc_request_approved_workshop_participants -- reference number M1
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

CREATE OR ALTER PROC proc_request_approved_workshop_participants_reservelist -- reference number M2
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

CREATE OR ALTER PROC proc_request_not_approved_workshop_participants -- reference number M3
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

CREATE OR ALTER PROC proc_request_deelnemer_in_aanvraag
(
@aanvraag_id INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT		D.DEELNEMER_ID, VOORNAAM, ACHTERNAAM
	FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN DEELNEMER D
	ON			DA.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE		AANVRAAG_ID = @aanvraag_id
END
GO

CREATE OR ALTER PROC proc_request_deelnemer_in_groep
(
@aanvraag_id	INT,
@groep_id		INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT		D.DEELNEMER_ID, VOORNAAM, ACHTERNAAM
	FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN DEELNEMER D
	ON			DA.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE		AANVRAAG_ID = @aanvraag_id
	AND			GROEP_ID = @groep_id
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
@contactpersoon_ID  INT,
@adviseur_ID		INT,
@organisatienummer	INT,
@workshopsector		VARCHAR(20),
@workshopstarttime	varchar(10),
@workshopendtime	varchar(10),
@workshopaddress	varchar(60),
@workshoppostcode	VARCHAR(7),
@workshopcity		VARCHAR(60),
@workshopleader		VARCHAR(100),
@workshopNote		VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	-- Create a workshop based on the given parameters

	DECLARE @status VARCHAR(40) = 'uitgezet'

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
	VALUES	(@workshopleader,@contactpersoon_ID,@organisatienummer
			,@modulenummer,@adviseur_ID,@workshopsector, @workshopdate,@workshopstarttime,
			@workshopendtime, @workshopaddress,@workshoppostcode,
			@workshopcity,@status,
			@workshopNote, @workshoptype, NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag
(
@organisatienummer	INT,
@contactpersoon_ID	INT,
@adviseur_ID		INT,
@plannernaam		VARCHAR(52)
)
AS
BEGIN

	INSERT INTO AANVRAAG ([ORGANISATIENUMMER],[CONTACTPERSOON_ID],[ADVISEUR_ID],[PLANNERNAAM]) VALUES (@organisatienummer, @contactpersoon_ID, @adviseur_ID, @plannernaam)

END
GO

CREATE OR ALTER PROC proc_insert_aanvraag_groepen
(
@aanvraag_ID INT,
@Module1 INT,
@Module2 INT,
@Module3 INT,
@Voorkeur1 VARCHAR(20),
@Voorkeur2 VARCHAR(20),
@Voorkeur3 VARCHAR(20),
@adress VARCHAR(60),
@contactperson INT
)
AS
BEGIN

INSERT INTO GROEP(AANVRAAG_ID, CONTACTPERSOON_ID, ADRES)
VALUES (@aanvraag_ID, @contactperson, @adress)

Declare @groepsID INT = (SELECT IDENT_CURRENT('GROEP'))


INSERT MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
VALUES(@groepsID, @Module1, @VOORKEUR1),
	  (@groepsID, @Module2, @VOORKEUR2),
	  (@groepsID, @Module3, @VOORKEUR3)
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag_deelnemers
(
@aanvraag_id		INT,
@voornaam			VARCHAR(30),
@achternaam			VARCHAR(50),
@geboortedatum		DATE,
@email				VARCHAR(100),
@telefoonnummer		VARCHAR(12),
@organisatienummer	INT,
@opleidingsniveau	VARCHAR(100)
)
AS
BEGIN
	INSERT INTO DEELNEMER (VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, TELEFOONNUMMER, OPLEIDINGSNIVEAU, ORGANISATIENUMMER, IS_OPEN_INSCHRIJVING)
		VALUES	(
				@voornaam,
				@achternaam,
				@geboortedatum,
				@email,
				@telefoonnummer,
				@opleidingsniveau,
				@organisatienummer,
				0
				)

	DECLARE @deelnemer_id INT = (SELECT TOP 1 DEELNEMER_ID FROM DEELNEMER ORDER BY DEELNEMER_ID DESC)

	INSERT INTO DEELNEMER_IN_AANVRAAG (AANVRAAG_ID, DEELNEMER_ID)
		VALUES	(
				@aanvraag_id,
				@deelnemer_id
				)
END
GO

/*
CREATE OR ALTER PROC proc_insert_incompany_participants
(
@workshop_id		INT,
@voornaam			VARCHAR(30),
@achternaam			VARCHAR(50),
@geboortedatum		DATE,
@email				VARCHAR(100),
@telefoonnummer		VARCHAR(12),
@organisatienummer	INT,
@opleidingsniveau	VARCHAR(100)
)
AS
BEGIN
	INSERT INTO DEELNEMER (VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, TELEFOONNUMMER, OPLEIDINGSNIVEAU, ORGANISATIENUMMER, IS_OPEN_INSCHRIJVING)
		VALUES	(
				@voornaam,
				@achternaam,
				@geboortedatum,
				@email,
				@telefoonnummer,
				@opleidingsniveau,
				@organisatienummer,
				0
				)

	DECLARE @deelnemer_id INT = (SELECT DEELNEMER_ID FROM inserted)
	DECLARE @volgnummer INT
	IF NOT EXISTS (SELECT * FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
		BEGIN
			SET @volgnummer = 1
		END
	ELSE
		BEGIN
			SET @volgnummer = (SELECT TOP 1 VOLGNUMMER FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = @workshop_id ORDER BY VOLGNUMMER DESC) + 1
		END

	INSERT INTO DEELNEMER_IN_WORKSHOP (WORKSHOP_ID, DEELNEMER_ID, VOLGNUMMER, IS_GOEDGEKEURD)
		VALUES	(
				@workshop_id,
				@deelnemer_id,
				@volgnummer,
				1
				)
END
GO
*/

/*==============================================================*/
/* SP Type: UPDATE                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_approve_workshop_participants -- reference number M4
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

CREATE OR ALTER PROC proc_update_workshop -- reference number M5
(
@workshop_id		INT,
@workshoptype		VARCHAR(3),
@workshopdate		VARCHAR(10),
@modulenummer		INT,
@organisatienummer	INT,
@workshopsector		VARCHAR(20),
@workshopstarttime	VARCHAR(10),
@workshopendtime	VARCHAR(10),
@workshopaddress	VARCHAR(60),
@workshoppostcode	VARCHAR(7),
@workshopcity		VARCHAR(60),
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

CREATE OR ALTER PROC proc_add_groep_deelnemers
(
@aanvraag_id	INT,
@groep_id		INT,
@deelnemer_id	INT
)
AS
BEGIN
	UPDATE DEELNEMER_IN_AANVRAAG SET GROEP_ID = @groep_id WHERE AANVRAAG_ID = @aanvraag_ID AND DEELNEMER_ID = @deelnemer_id
END
GO

CREATE OR ALTER PROC proc_remove_groep_deelnemers
(
@aanvraag_id	INT,
@groep_id		INT,
@deelnemer_id	INT
)
AS
BEGIN
	UPDATE DEELNEMER_IN_AANVRAAG SET GROEP_ID = NULL WHERE AANVRAAG_ID = @aanvraag_id AND DEELNEMER_ID = @deelnemer_id
END
GO

/*==============================================================*/
/* SP Type: DELETE                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_disapprove_workshop_participants -- reference number M6
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

CREATE OR ALTER PROC proc_delete_aanvraag_deelnemers
(
@aanvraag_id	INT,
@deelnemer_id	INT
)
AS
BEGIN
	DELETE FROM DEELNEMER_IN_AANVRAAG WHERE AANVRAAG_ID = @aanvraag_id AND DEELNEMER_ID = @deelnemer_id
END
GO