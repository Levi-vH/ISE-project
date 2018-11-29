USE SBBWorkshopOmgeving
GO

/*==============================================================*/
/* SP Type: SELECT                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_request_workshop_participants
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT		VOLGNUMMER, VOORNAAM, ACHTERNAAM
	FROM		DEELNEMER_IN_WORKSHOP DW INNER JOIN DEELNEMER D
	ON			DW.DEELNEMER_ID = D.DEELNEMER_ID
	WHERE		WORKSHOP_ID = 5--@workshop_id
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