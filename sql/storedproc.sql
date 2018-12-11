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
@orderby		NVARCHAR(40) = NULL,
@orderdirection	NVARCHAR(4) = NULL,
@where			INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		W.WORKSHOP_ID,
							W.TYPE,W.DATUM,
							STARTTIJD,
							EINDTIJD,
							W.ADRES,
							W.POSTCODE,
							W.PLAATSNAAM,
							STATUS,
							OPMERKING,
							VERWERKT_BREIN,
							DEELNEMER_GEGEVENS_ONTVANGEN,
							OVK_BEVESTIGING,
							PRESENTIELIJST_VERSTUURD,
							PRESENTIELIJST_ONTVANGEN,
							BEWIJS_DEELNAME_MAIL_SBB_WSL,
							O.ORGANISATIENAAM,
							M.MODULENAAM,
							M.MODULENUMMER,
							WL.VOORNAAM AS WORKSHOPLEIDER_VOORNAAM,
							WL.ACHTERNAAM AS WORKSHOPLEIDER_ACHTERNAAM,
							WL.TOEVOEGING,
							A.VOORNAAM AS ADVISEUR_VOORNAAM,
							A.ACHTERNAAM AS ADVISEUR_ACHTERNAAM,
							A.TELEFOONNUMMER AS ADVISEUR_TELEFOON_NUMMER,
							A.EMAIL AS ADVISEUR_EMAIL,
							C.VOORNAAM AS CONTACTPERSOON_VOORNAAM,
							C.ACHTERNAAM AS CONTACTPERSOON_ACHTERNAAM,
							C.TELEFOONNUMMER AS CONTACTPERSON_TELEFOONNUMMER,
							C.EMAIL AS CONTACTPERSOON_EMAIL,
							(SELECT COUNT(*) FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = W.WORKSHOP_ID) AS AANTAL_DEELNEMERS,
							(SELECT COUNT(*) FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = W.WORKSHOP_ID AND IS_GOEDGEKEURD = 1) AS AANTAL_GOEDGEKEURDE_DEELNEMERS
				FROM		WORKSHOP W INNER JOIN
							ORGANISATIE O ON W.ORGANISATIENUMMER = O.ORGANISATIENUMMER INNER JOIN
							MODULE M ON W.MODULENUMMER = M.MODULENUMMER LEFT JOIN
							WORKSHOPLEIDER WL ON W.WORKSHOPLEIDER_ID = WL.WORKSHOPLEIDER_ID INNER JOIN
							ADVISEUR A ON W.ADVISEUR_ID = A.ADVISEUR_ID INNER JOIN
							CONTACTPERSOON C ON W.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
				'
	IF(@where IS NOT NULL)
		BEGIN
			SET @sql += 'WHERE W.WORKSHOP_ID = @where'
		END
	SET @sql += 'ORDER BY @orderby + @orderdirection'
	IF(@orderby IS NULL)
		BEGIN
			SET @orderby = 'W.WORKSHOP_ID'
		END
	IF(@orderdirection IS NULL)
		BEGIN
			SET @orderdirection = 'ASC'
		END
	EXEC sp_executesql @sql, N'@orderby NVARCHAR(40), @orderdirection NVARCHAR(4), @where INT', @orderby, @orderdirection, @where
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
	SET @sql =	N'
				SELECT	AANVRAAG_ID,
						C.VOORNAAM AS CONTACTPERSOONVOORNAAM,
						C.ACHTERNAAM AS CONTACTPERSOONACHTERNAAM,
						AD.VOORNAAM AS ADVISEURVOORNAAM,
						AD.ACHTERNAAM AS ADVISEURACHTERNAAM,
						A.AANVRAAG_DATUM,
						O.ORGANISATIENAAM,
						ISNULL((SELECT COUNT(*) FROM GROEP G WHERE G.AANVRAAG_ID = A.AANVRAAG_ID GROUP BY AANVRAAG_ID), 0) AS AANTAL_GROEPEN
				FROM	AANVRAAG A INNER JOIN
						ORGANISATIE O ON A.ORGANISATIENUMMER = O.ORGANISATIENUMMER INNER JOIN
						CONTACTPERSOON C ON A.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID INNER JOIN
						ADVISEUR AD ON A.ADVISEUR_ID = AD.ADVISEUR_ID
				'
	IF(@aanvraag_id IS NOT NULL)
		BEGIN
			SET @sql +=	N'WHERE A.AANVRAAG_ID = @aanvraag_id'
		END
	EXEC sp_executesql @sql, N'@aanvraag_id INT', @aanvraag_id
END
GO

CREATE OR ALTER PROC proc_request_groups
(
@aanvraag_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT	C.VOORNAAM,
						C.ACHTERNAAM,
						G.ADRES,
						ISNULL(	(
								SELECT	COUNT(*)
								FROM	DEELNEMER_IN_AANVRAAG DA
								WHERE	DA.AANVRAAG_ID = G.AANVRAAG_ID
								GROUP BY DEELNEMER_ID
								), 0) AS AANTAL_DEELNEMERS
				FROM	GROEP G INNER JOIN
						CONTACTPERSOON C ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
				WHERE	G.AANVRAAG_ID = @aanvraag_id
				'
	EXEC sp_executesql @sql, N'@aanvraag_id INT', @aanvraag_id
END
GO

CREATE OR ALTER PROC proc_request_approved_workshop_participants -- reference number M1
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT TOP 16	D.DEELNEMER_ID,
								D.VOORNAAM,
								D.ACHTERNAAM
				FROM			DEELNEMER_IN_WORKSHOP DW INNER JOIN
								DEELNEMER D ON DW.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE			DW.WORKSHOP_ID = @workshop_id
				AND				IS_GOEDGEKEURD = 1
				ORDER BY		DW.VOLGNUMMER
				'
	EXEC sp_executesql @sql, N'@workshop_id INT', @workshop_id
END
GO

CREATE OR ALTER PROC proc_request_approved_workshop_participants_reservelist -- reference number M2
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		D.DEELNEMER_ID,
							D.VOORNAAM,
							D.ACHTERNAAM
				FROM		DEELNEMER_IN_WORKSHOP DW INNER JOIN
							DEELNEMER D ON DW.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DW.WORKSHOP_ID = @workshop_id
				AND			IS_GOEDGEKEURD = 1
				AND			VOLGNUMMER NOT IN	(
												SELECT TOP 16	DW2.VOLGNUMMER
												FROM			DEELNEMER_IN_WORKSHOP DW2 INNER JOIN
																DEELNEMER D2 ON DW2.DEELNEMER_ID = D2.DEELNEMER_ID
												WHERE			DW2.WORKSHOP_ID = @workshop_id
												AND				IS_GOEDGEKEURD = 1
												)
				ORDER BY	DW.VOLGNUMMER
				'
	EXEC sp_executesql @sql, N'@workshop_id INT', @workshop_id
END
GO

CREATE OR ALTER PROC proc_request_not_approved_workshop_participants -- reference number M3
(
@workshop_id INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		D.DEELNEMER_ID,
							D.VOORNAAM,
							D.ACHTERNAAM
				FROM		DEELNEMER_IN_WORKSHOP DW INNER JOIN
							DEELNEMER D ON DW.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DW.WORKSHOP_ID = @workshop_id
				AND			IS_GOEDGEKEURD = 0
				ORDER BY	DW.VOLGNUMMER
				'
	EXEC sp_executesql @sql, N'@workshop_id INT', @workshop_id
END
GO

CREATE OR ALTER PROC proc_request_deelnemers_in_aanvraag
(
@aanvraag_id INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		D.DEELNEMER_ID,
							D.VOORNAAM,
							D.ACHTERNAAM,
							D.GEBOORTEDATUM,
							D.OPLEIDINGSNIVEAU,
							D.EMAIL,
							D.TELEFOONNUMMER
				FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN
							DEELNEMER D ON DA.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DA.AANVRAAG_ID = @aanvraag_id
				'
	EXEC sp_executesql @sql, N'@aanvraag_id INT', @aanvraag_id
END
GO

CREATE OR ALTER PROC proc_request_deelnemers_van_groep
(
@aanvraag_id	INT,
@groep_id		INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		D.DEELNEMER_ID,
							D.VOORNAAM,
							D.ACHTERNAAM
				FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN
							DEELNEMER D ON DA.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DA.AANVRAAG_ID = @aanvraag_id
				AND			DA.GROEP_ID = @groep_id
				'
	EXEC sp_executesql @sql, N'@aanvraag_id INT, @groep_id INT', @aanvraag_id, @groep_id
END
GO

/*==============================================================*/
/* SP Type: INSERT                                              */
/*==============================================================*/

CREATE OR ALTER PROC proc_create_workshop
(
@workshoptype		NVARCHAR(3),
@workshopdate		NVARCHAR(10),
@modulenummer		INT,
@contactpersoon_ID  INT,
@adviseur_ID		INT,
@organisatienummer	INT,
@workshopsector		NVARCHAR(20),
@workshopstarttime	NVARCHAR(10),
@workshopendtime	NVARCHAR(10),
@workshopaddress	NVARCHAR(60),
@workshoppostcode	NVARCHAR(7),
@workshopcity		NVARCHAR(60),
@workshopleader		NVARCHAR(100),
@workshopnote		NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	-- Create a workshop based on the given parameters

	DECLARE @sql NVARCHAR(4000)
	DECLARE @status NVARCHAR(40) = 'uitgezet'

	IF(@workshopleader IS NOT NULL)
		BEGIN
			SET @status = 'bevestigd'
		END

	-- If a workshop is NOT from IND, the workshopsector MUST be filled in

	IF( @workshoptype != 'IND' AND @workshopsector IS NULL )
		BEGIN
			RAISERROR('Een workshop met type IND MOET een workshopsector hebben',16,1)
		END
	SET @sql =	N'
				INSERT INTO	WORKSHOP
				VALUES		(
							@workshopleader,
							@contactpersoon_ID,
							@organisatienummer,
							@modulenummer,
							@adviseur_ID,
							@workshopsector,
							@workshopdate,
							@workshopstarttime,
							@workshopendtime,
							@workshopaddress,
							@workshoppostcode,
							@workshopcity,
							@status,
							@workshopnote,
							@workshoptype,
							NULL, NULL, NULL, NULL, NULL, NULL
							)
				'
	EXEC sp_executesql @sql,	N'
								@workshopleader		NVARCHAR(100),
								@contactpersoon_ID	INT,
								@organisatienummer	INT,
								@modulenummer		INT,
								@adviseur_ID		INT,
								@workshopsector		NVARCHAR(20),
								@workshopdate		NVARCHAR(10),
								@workshopstarttime	NVARCHAR(10),
								@workshopendtime	NVARCHAR(10),
								@workshopaddress	NVARCHAR(60),
								@workshoppostcode	NVARCHAR(7),
								@workshopcity		NVARCHAR(60),
								@status				NVARCHAR(40),
								@workshopnote		NVARCHAR(255),
								@workshoptype		NVARCHAR(3)
								',
								@workshopleader,
								@contactpersoon_ID,
								@organisatienummer,
								@modulenummer,
								@adviseur_ID,
								@workshopsector,
								@workshopdate,
								@workshopstarttime,
								@workshopendtime,
								@workshopaddress,
								@workshoppostcode,
								@workshopcity,
								@status,
								@workshopnote,
								@workshoptype
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag
(
@organisatienummer	INT,
@contactpersoon_ID	INT,
@adviseur_ID		INT,
@plannernaam		NVARCHAR(52)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	AANVRAAG(ORGANISATIENUMMER, CONTACTPERSOON_ID, ADVISEUR_ID, PLANNERNAAM)
				VALUES		(
							@organisatienummer,
							@contactpersoon_ID,
							@adviseur_ID,
							@plannernaam
							)
				'
	EXEC sp_executesql @sql,	N'@organisatienummer INT, @contactpersoon_ID INT, @adviseur_ID INT, @plannernaam NVARCHAR(52)',
								@organisatienummer, @contactpersoon_ID, @adviseur_ID, @plannernaam
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag_groepen
(
@aanvraag_id	INT,
@module1		INT,
@module2		INT,
@module3		INT,
@voorkeur1		NVARCHAR(20),
@voorkeur2		NVARCHAR(20),
@voorkeur3		NVARCHAR(20),
@address		NVARCHAR(60),
@contactpersoon	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql2 NVARCHAR(4000)
	DECLARE @sql3 NVARCHAR(4000)
	DECLARE @sql4 NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO GROEP(AANVRAAG_ID, CONTACTPERSOON_ID, ADRES)
				VALUES (@aanvraag_ID, @contactpersoon, @address)
				'
	EXEC sp_executesql @sql, N'@aanvraag_ID INT, @contactpersoon INT, @address NVARCHAR(60)', @aanvraag_ID, @contactpersoon, @address
	DECLARE @groep_ID INT = (SELECT IDENT_CURRENT('GROEP'))
	IF ((@module1 IS NOT NULL) AND (@voorkeur1 IS NOT NULL))
	BEGIN
		SET @sql2 =	N'
					INSERT INTO MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
					VALUES (@groep_ID, @module1, @voorkeur1)
					'	
		EXEC sp_executesql @sql2,	N'
									@groep_ID INT,
									@module1 INT,
									@voorkeur1 NVARCHAR(20),
									',
									@groep_ID,
									@module1,
									@voorkeur1
	END
	IF ((@module2 IS NOT NULL) AND (@voorkeur2 IS NOT NULL))
	BEGIN
		SET @sql3 =	N'
				INSERT INTO MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
				VALUES (@groep_ID, @module2, @voorkeur2)
				'	
		EXEC sp_executesql @sql3,	N'
									@groep_ID INT,
									@module2 INT,
									@voorkeur2 NVARCHAR(20),
									',
									@groep_ID,
									@module2,
									@voorkeur2
	END
	IF ((@module3 IS NOT NULL) AND (@voorkeur3 IS NOT NULL))
	BEGIN
		SET @sql4 =	N'
					INSERT INTO MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
					VALUES (@groep_ID, @module3, @voorkeur3)
					'	
		EXEC sp_executesql @sql4,	N'
									@groep_ID INT,
									@module3 INT,
									@voorkeur3 NVARCHAR(20),
									',
									@groep_ID,
									@module3,
									@voorkeur3
	END
END
GO

CREATE OR ALTER PROC proc_insert_aanvraag_deelnemers
(
@aanvraag_id		INT,
@voornaam			NVARCHAR(30),
@achternaam			NVARCHAR(50),
@geboortedatum		DATE,
@email				NVARCHAR(100),
@telefoonnummer		NVARCHAR(12),
@opleidingsniveau	NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql2 NVARCHAR(4000)
	DECLARE @organisatienummer INT = (SELECT ORGANISATIENUMMER FROM AANVRAAG WHERE AANVRAAG_ID = @aanvraag_id)
	SET @sql =	N'
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
				'
	EXEC sp_executesql @sql,	N'
								@voornaam NVARCHAR(30),
								@achternaam NVARCHAR(50),
								@geboortedatum DATE,
								@email NVARCHAR(100),
								@telefoonnummer NVARCHAR(12),
								@opleidingsniveau NVARCHAR(100),
								@organisatienummer INT
								',
								@voornaam,
								@achternaam,
								@geboortedatum,
								@email,
								@telefoonnummer,
								@opleidingsniveau,
								@organisatienummer
	DECLARE @deelnemer_id INT = (SELECT IDENT_CURRENT('DEELNEMER'))
	SET @sql2 =	N'
				INSERT INTO DEELNEMER_IN_AANVRAAG (AANVRAAG_ID, DEELNEMER_ID)
				VALUES (@aanvraag_id, @deelnemer_id)
				'
	EXEC sp_executesql @sql2, N'@aanvraag_id INT, @deelnemer_id INT', @aanvraag_id, @deelnemer_id
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
	SET NOCOUNT ON
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
	SET NOCOUNT ON
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
SET NOCOUNT ON
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
	SET NOCOUNT ON
	DELETE FROM DEELNEMER_IN_AANVRAAG WHERE AANVRAAG_ID = @aanvraag_id AND DEELNEMER_ID = @deelnemer_id
END
GO