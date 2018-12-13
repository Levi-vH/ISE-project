/* =====================================================================
   Author: Lars
   Create date: 26-11-2018
   Description: this is a script to create random testdata for the
   'SBBWorkshopOmgeving' database
   --------------------------------
   Modified by: Bart, Jesse, Mark
   Modifications made by Bart:
		procedures made:
		-

		procedures modified:
		-

   Modifications made by Jesse:
		procedures made:
		-

		procedures modified:
		-

   Modifications made by Mark:
		procedures made:
		-

		procedures modified:
		-
   ==================================================================== */

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

--============================================================================================
-- SP_get_workshops: returns all workshops with their data for the workshop overview page                                              
--============================================================================================

CREATE OR ALTER PROC SP_get_workshops
(
@order_by		NVARCHAR(40) = NULL,
@order_direction	NVARCHAR(4) = NULL,
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
							W.SECTORNAAM,
							W.WORKSHOPLEIDER_ID,
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
							ISNULL(	(
									SELECT	COUNT(*)
									FROM	DEELNEMER_IN_WORKSHOP
									WHERE	WORKSHOP_ID = W.WORKSHOP_ID
									), 0) AS AANTAL_DEELNEMERS,
							ISNULL(	(
									SELECT	COUNT(*)
									FROM	DEELNEMER_IN_WORKSHOP
									WHERE	WORKSHOP_ID = W.WORKSHOP_ID
									AND		IS_GOEDGEKEURD = 1
									), 0) AS AANTAL_GOEDGEKEURDE_DEELNEMERS
				FROM		WORKSHOP W INNER JOIN
							ORGANISATIE O ON W.ORGANISATIENUMMER = O.ORGANISATIENUMMER INNER JOIN
							MODULE M ON W.MODULENUMMER = M.MODULENUMMER LEFT JOIN
							WORKSHOPLEIDER WL ON W.WORKSHOPLEIDER_ID = WL.WORKSHOPLEIDER_ID INNER JOIN
							ADVISEUR A ON W.ADVISEUR_ID = A.ADVISEUR_ID INNER JOIN
							CONTACTPERSOON C ON W.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
				'
	IF(@where IS NOT NULL) -- if the procedure was executed with an where statement, add the where statement to the select query
		BEGIN
			SET @sql += ' WHERE W.WORKSHOP_ID = @where'
		END
	SET @sql += ' ORDER BY @order_by + @order_direction' -- add an order by statement to the query
	IF(@order_by IS NULL)
		BEGIN
			SET @order_by = 'W.WORKSHOP_ID' -- if no order by statement was given with the execute, order by workshop_id's
		END
	IF(@order_direction IS NULL)
		BEGIN
			SET @order_direction = 'ASC' -- if no order by direction was given, order by ascending
		END
	EXEC sp_executesql @sql, N'@order_by NVARCHAR(40), @order_direction NVARCHAR(4), @where INT', @order_by, @order_direction, @where
END
GO

--============================================================================================
-- SP_get_workshoprequests: returns all workshops that are requested                                        
--============================================================================================

CREATE OR ALTER PROC SP_get_workshoprequests
(
@request_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT	AANVRAAG_ID,
						C.VOORNAAM AS CONTACTPERSOONVOORNAAM,
						C.ACHTERNAAM AS CONTACTPERSOONACHTERNAAM,
						C.TELEFOONNUMMER AS CONTACTPERSOONTELEFOONNUMMER,
						C.EMAIL AS CONTACTPERSOONEMAIL,
						AD.VOORNAAM AS ADVISEURVOORNAAM,
						AD.ACHTERNAAM AS ADVISEURACHTERNAAM,
						AD.TELEFOONNUMMER AS ADVISEURTELEFOONNUMMER,
						AD.EMAIL AS ADVISEUREMAIL,
						A.AANVRAAG_DATUM,
						O.ORGANISATIENAAM,
						ISNULL(	(
								SELECT		COUNT(*)
								FROM		GROEP G
								WHERE		G.AANVRAAG_ID = A.AANVRAAG_ID
								GROUP BY	AANVRAAG_ID
								), 0) AS AANTAL_GROEPEN,
						P.PLANNERNAAM
				FROM	AANVRAAG A INNER JOIN
						ORGANISATIE O ON A.ORGANISATIENUMMER = O.ORGANISATIENUMMER INNER JOIN
						CONTACTPERSOON C ON A.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID INNER JOIN
						ADVISEUR AD ON A.ADVISEUR_ID = AD.ADVISEUR_ID INNER JOIN
						PLANNER P ON A.PLANNERNAAM = P.PLANNERNAAM
				'
	IF(@request_id IS NOT NULL)
		BEGIN
			SET @sql +=	N'WHERE A.AANVRAAG_ID = @request_id'
		END
	EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO

--============================================================================================
-- SP_group_ids: returns all group ID's of a request                                      
--============================================================================================

CREATE OR ALTER PROC SP_get_group_ids
(
@request_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT	GROEP_ID
				FROM	GROEP
				WHERE	AANVRAAG_ID = @request_id
				'
	 EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO

--==============================================================================================
-- SP_get_row_numbers_of_group_ids: returns the row numbers of the group ID's list of a request                                      
--==============================================================================================

CREATE OR ALTER PROC SP_get_row_numbers_of_group_ids
(
@request_id INT = NULL,
@group_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				;WITH row_number AS
				(
				SELECT	ROW_NUMBER() OVER (ORDER BY GROEP_ID) AS row_number_group, GROEP_ID
				FROM	GROEP
				WHERE	AANVRAAG_ID = @request_id
				)
				SELECT	row_number_group
				FROM	row_number
				WHERE	GROEP_ID = @group_id
				'
	 EXEC sp_executesql @sql, N'@request_id INT, @group_id INT', @request_id, @group_id
END
GO

--============================================================================================
-- SP_get_groups: returns all groups from requests                                       
--============================================================================================

CREATE OR ALTER PROC SP_get_groups
(
@request_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT	C.VOORNAAM,
						C.ACHTERNAAM,
						C.TELEFOONNUMMER,
						C.EMAIL,
						G.ADRES,
						ISNULL(	(
								SELECT		COUNT(DEELNEMER_ID)
								FROM		DEELNEMER_IN_AANVRAAG DA
								WHERE		DA.AANVRAAG_ID = G.AANVRAAG_ID
								AND			DA.GROEP_ID = G.GROEP_ID
								GROUP BY	GROEP_ID
								), 0) AS AANTAL_DEELNEMERS,
						G.GROEP_ID
				FROM	GROEP G INNER JOIN
						CONTACTPERSOON C ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
				WHERE	G.AANVRAAG_ID = @request_id
				'
	EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO

--============================================================================================
-- SP_get_module_information_of_group: returns module information for a single group                                      
--============================================================================================
-- van de groep en module dan wil je de module informatie: de opgegeven voorkeur datum startijd eindtijd
-- voorkeur, datum, starttijd, einddtijd 
CREATE OR ALTER PROC SP_get_module_information_of_group
(
@group_id INT,
@modulenumber INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
					SELECT VOORKEUR, DATUM, STARTTIJD, EINDTIJD
					FROM MODULE_VAN_GROEP
					WHERE GROEP_ID = @group_id
					AND MODULENUMMER = @modulenumber
				'
	EXEC sp_executesql @sql, N'@group_id INT, @modulenumber INT', @group_id, @modulenumber
END
GO

--============================================================================================
-- SP_get_information_of_group: returns information for a single group                                      
--============================================================================================
-- van de groep en module dan wil je de module informatie: de opgegeven voorkeur datum startijd eindtijd
-- voorkeur, datum, starttijd, einddtijd 
CREATE OR ALTER PROC SP_get_information_of_group
(
@group_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
					SELECT C.VOORNAAM, C.ACHTERNAAM, C.EMAIL, C.TELEFOONNUMMER, G.ADRES,
								ISNULL(	(
								SELECT		COUNT(GROEP_ID)
								FROM		MODULE_VAN_GROEP MG
								WHERE		MG.GROEP_ID = @group_ID
								GROUP BY	GROEP_ID
								), 0) AS AANTAL_MODULES
					FROM GROEP G INNER JOIN CONTACTPERSOON C
					ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
					WHERE GROEP_ID = @group_ID
				'
	EXEC sp_executesql @sql, N'@group_ID INT', @group_ID
END
GO

--============================================================================================================
-- SP_get_modulenumbers: returns the id's for all the modules
--===========================================================================================================

CREATE OR ALTER PROC SP_get_modulenumbers
(
@group_ID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT	MG.MODULENUMMER, MODULENAAM
				FROM	MODULE_VAN_GROEP MG INNER JOIN MODULE M
				ON		MG.MODULENUMMER = M.MODULENUMMER
				WHERE	GROEP_ID = @group_ID
	 '
	 EXEC sp_executesql @sql, N'@group_ID INT', @group_ID
END
GO
--============================================================================================================
-- SP_get_list_of_approved_workshop_participants: returns all approved workshop participants for a workshop                                      
--===========================================================================================================

CREATE OR ALTER PROC SP_get_list_of_approved_workshop_participants -- reference number M1
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

--===================================================================================================================================================
-- SP_get_reservelist_of_approved_workshop_participants: returns all approved workshop participants for a workshop that are on the reservelist                                      
--===================================================================================================================================================

CREATE OR ALTER PROC SP_get_reservelist_of_approved_workshop_participants -- reference number M2
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

--===================================================================================================================
-- SP_get_list_of_to_approve_workshop_participants: returns all participants of a workshop that are not approved                                 
--===================================================================================================================

CREATE OR ALTER PROC SP_get_list_of_to_approve_workshop_participants -- reference number M3
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

--=========================================================================================
-- SP_get_participants_in_workshoprequest: returns all participants that are in a request                                
--=========================================================================================

CREATE OR ALTER PROC SP_get_participants_of_workshoprequest
(
@request_id INT
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
							D.TELEFOONNUMMER,
							DA.GROEP_ID
				FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN
							DEELNEMER D ON DA.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DA.AANVRAAG_ID = @request_id
				'
	EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO

--=========================================================================================
-- SP_get_participants_of_workshoprequest_without_group: returns all participants that are in a request,
-- but not in a group
--=========================================================================================

CREATE OR ALTER PROC SP_get_participants_of_workshoprequest_without_group
(
@request_id INT
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
				WHERE		DA.AANVRAAG_ID = @request_id
				AND			DA.GROEP_ID IS NULL
				'
	EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO

--=========================================================================================
-- SP_get_participants_of_group: returns all participants that are in a group                              
--=========================================================================================

CREATE OR ALTER PROC SP_get_participants_of_group
(
@request_id	INT,
@group_id		INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		D.DEELNEMER_ID,
							D.VOORNAAM,
							D.ACHTERNAAM,
							D.OPLEIDINGSNIVEAU,
							D.GEBOORTEDATUM
				FROM		DEELNEMER_IN_AANVRAAG DA INNER JOIN
							DEELNEMER D ON DA.DEELNEMER_ID = D.DEELNEMER_ID
				WHERE		DA.AANVRAAG_ID = @request_id
				AND			DA.GROEP_ID = @group_id
				'
	EXEC sp_executesql @sql, N'@request_id INT, @group_id INT', @request_id, @group_id
END
GO

--============================================================================================
-- SP_get_information_of_group: returns the information of a group                                       
--============================================================================================
/*
CREATE OR ALTER PROC SP_get_information_of_group
(
@request_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	--SET @sql =	N'
				SELECT	C.VOORNAAM,
						C.ACHTERNAAM,
						G.ADRES,
						ISNULL(	(
								SELECT		COUNT(GROEP_ID)
								FROM		DEELNEMER_IN_AANVRAAG DA
								WHERE		DA.AANVRAAG_ID = G.AANVRAAG_ID
								GROUP BY	GROEP_ID
								), 0) AS AANTAL_DEELNEMERS,
						G.GROEP_ID
				FROM	GROEP G INNER JOIN
						CONTACTPERSOON C ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
				WHERE	G.AANVRAAG_ID = @request_id
	--			'
	EXEC sp_executesql @sql, N'@request_id INT', @request_id
END
GO
*/

-- groep meegeven adres naam telefoon contactpersoon aantal modules namen modules

/*==============================================================*/
/* SP Type: INSERT                                              */
/*==============================================================*/

--=================================================
-- SP_insert_workshop: inserts a new workshop                              
--=================================================
CREATE OR ALTER PROC SP_insert_workshop
(
@workshoptype		NVARCHAR(3),
@workshopdate		NVARCHAR(10),
@modulenumber		INT,
@contactperson_id  INT,
@advisor_id		INT,
@organisationnumber	INT,
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
							@contactperson_id,
							@organisationnumber,
							@modulenumber,
							@advisor_id,
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
								@contactperson_id	INT,
								@organisationnumber	INT,
								@modulenumber		INT,
								@advisor_id		INT,
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
								@contactperson_id,
								@organisationnumber,
								@modulenumber,
								@advisor_id,
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

--=================================================
-- SP_insert_workshoprequest: inserts a new request                              
--=================================================

CREATE OR ALTER PROC SP_insert_workshoprequest
(
@organisationnumber	INT,
@contactperson_id	INT,
@advisor_id		INT,
@plannername		NVARCHAR(52)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	AANVRAAG(ORGANISATIENUMMER, CONTACTPERSOON_ID, ADVISEUR_ID, PLANNERNAAM)
				VALUES		(
							@organisationnumber,
							@contactperson_id,
							@advisor_id,
							@plannername
							)
				'
	EXEC sp_executesql @sql,	N'@organisationnumber INT, @contactperson_id INT, @advisor_id INT, @plannername NVARCHAR(52)',
								@organisationnumber, @contactperson_id, @advisor_id, @plannername
END
GO

--=======================================================================
-- SP_insert_groups_of_workshoprequest: inserts the groups of a new request                        
--=======================================================================

CREATE OR ALTER PROC SP_insert_group_of_workshoprequest
(
@request_id			INT,
@module1			INT,
@module2			INT,
@module3			INT,
@preference1		NVARCHAR(20),
@preference2		NVARCHAR(20),
@preference3		NVARCHAR(20),
@address			NVARCHAR(60),
@contactperson_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql2 NVARCHAR(4000)
	DECLARE @sql3 NVARCHAR(4000)
	DECLARE @sql4 NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	GROEP(AANVRAAG_ID, CONTACTPERSOON_ID, ADRES)
				VALUES		(@request_id, @contactperson_id, @address)
				'
	EXEC sp_executesql @sql, N'@request_id INT, @contactperson_id INT, @address NVARCHAR(60)', @request_id, @contactperson_id, @address
	DECLARE @group_id INT = (SELECT IDENT_CURRENT('GROEP'))
	IF ((@module1 IS NOT NULL) AND (@preference1 IS NOT NULL))
	BEGIN
		SET @sql2 =	N'
					INSERT INTO	MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
					VALUES		(@group_id, @module1, @preference1)
					'	
		EXEC sp_executesql @sql2,	N'
									@group_id INT,
									@module1 INT,
									@preference1 NVARCHAR(20)
									',
									@group_id,
									@module1,
									@preference1
	END
	IF ((@module2 IS NOT NULL) AND (@preference2 IS NOT NULL))
	BEGIN
		SET @sql3 =	N'
				INSERT INTO	MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
				VALUES		(@group_id, @module2, @preference2)
				'	
		EXEC sp_executesql @sql3,	N'
									@group_id INT,
									@module2 INT,
									@preference2 NVARCHAR(20)
									',
									@group_id,
									@module2,
									@preference2
	END
	IF ((@module3 IS NOT NULL) AND (@preference3 IS NOT NULL))
	BEGIN
		SET @sql4 =	N'
					INSERT INTO	MODULE_VAN_GROEP(GROEP_ID, MODULENUMMER, VOORKEUR)
					VALUES		(@group_id, @module3, @preference3)
					'	
		EXEC sp_executesql @sql4,	N'
									@group_id INT,
									@module3 INT,
									@preference3 NVARCHAR(20)
									',
									@group_id,
									@module3,
									@preference3
	END
END
GO

--=======================================================================
-- SP_insert_participants_of_workshoprequest: inserts participants of a request                       
--=======================================================================

CREATE OR ALTER PROC SP_insert_participant_of_workshoprequest
(
@request_id		INT,
@firstname			NVARCHAR(30),
@lastname			NVARCHAR(50),
@birthdate		DATE,
@email				NVARCHAR(100),
@phonenumber		NVARCHAR(12),
@education	NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql2 NVARCHAR(4000)
	DECLARE @organisationnumber INT = (SELECT ORGANISATIENUMMER FROM AANVRAAG WHERE AANVRAAG_ID = @request_id)
	SET @sql =	N'
				INSERT INTO	DEELNEMER (VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, TELEFOONNUMMER, OPLEIDINGSNIVEAU, ORGANISATIENUMMER, IS_OPEN_INSCHRIJVING)
				VALUES		(
							@firstname,
							@lastname,
							@birthdate,
							@email,
							@phonenumber,
							@education,
							@organisationnumber,
							0
							)
				'
	EXEC sp_executesql @sql,	N'
								@firstname NVARCHAR(30),
								@lastname NVARCHAR(50),
								@birthdate DATE,
								@email NVARCHAR(100),
								@phonenumber NVARCHAR(12),
								@education NVARCHAR(100),
								@organisationnumber INT
								',
								@firstname,
								@lastname,
								@birthdate,
								@email,
								@phonenumber,
								@education,
								@organisationnumber
	DECLARE @participant_id INT = (SELECT IDENT_CURRENT('DEELNEMER'))
	SET @sql2 =	N'
				INSERT INTO	DEELNEMER_IN_AANVRAAG (AANVRAAG_ID, DEELNEMER_ID)
				VALUES		(@request_id, @participant_id)
				'
	EXEC sp_executesql @sql2, N'@request_id INT, @participant_id INT', @request_id, @participant_id
END
GO

/*
CREATE OR ALTER PROC SP_insert_participant_of_incompany_workshop
(
@workshop_id		INT,
@firstname			NVARCHAR(30),
@lastname			NVARCHAR(50),
@birthdate		DATE,
@email				NVARCHAR(100),
@phonenumber		NVARCHAR(12),
@organisationnumber	INT,
@education	NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO DEELNEMER (VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, TELEFOONNUMMER, OPLEIDINGSNIVEAU, ORGANISATIENUMMER, IS_OPEN_INSCHRIJVING)
		VALUES	(
				@firstname,
				@lastname,
				@birthdate,
				@email,
				@phonenumber,
				@education,
				@organisationnumber,
				0
				)

	DECLARE @participant_id INT = (SELECT DEELNEMER_ID FROM inserted)
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
				@participant_id,
				@volgnummer,
				1
				)
END
GO
*/

/*==============================================================*/
/* SP Type: UPDATE                                              */
/*==============================================================*/

--=======================================================================================
-- SP SP_approve_participant_of_workshop: updates participants of a workshop to approved                       
--=======================================================================================

CREATE OR ALTER PROC SP_approve_participant_of_workshop -- reference number M4
(
@workshop_id	INT,
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	DEELNEMER_IN_WORKSHOP
				SET		IS_GOEDGEKEURD = 1
				WHERE	WORKSHOP_ID = @workshop_id
				AND		DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql, N'@workshop_id INT, @participant_id INT',
							@workshop_id, @participant_id
END
GO

--===========================================================
-- SP_alter_workshop: updates the values of a workshop                    
--===========================================================

CREATE OR ALTER PROC SP_alter_workshop -- reference number M5
(
@workshop_id		INT,
@workshoptype		NVARCHAR(3),
@workshopdate		NVARCHAR(10),
@modulenumber		INT,
@organisationnumber	INT,
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
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	WORKSHOP
				SET		[TYPE] = @workshoptype,
						DATUM = @workshopdate,
						MODULENUMMER = @modulenumber,
						ORGANISATIENUMMER = @organisationnumber,
						SECTORNAAM = @workshopsector,
						STARTTIJD = @workshopstarttime,
						EINDTIJD = @workshopendtime,
						ADRES = @workshopaddress,
						POSTCODE = @workshoppostcode,
						PLAATSNAAM = @workshopcity,
						WORKSHOPLEIDER_ID = @workshopleader,
						OPMERKING = @workshopnote
				WHERE	WORKSHOP_ID = @workshop_id
				'
	EXEC sp_executesql @sql,	N'
								@workshoptype NVARCHAR(3),
								@workshopdate NVARCHAR(10),
								@modulenumber INT,
								@organisationnumber INT,
								@workshopsector NVARCHAR(20),
								@workshopstarttime NVARCHAR(10),
								@workshopendtime NVARCHAR(10),
								@workshopaddress NVARCHAR(60),
								@workshoppostcode NVARCHAR(7),
								@workshopcity NVARCHAR(60),
								@workshopleader NVARCHAR(100),
								@workshopnote NVARCHAR(255),
								@workshop_id INT
								',
								@workshoptype,
								@workshopdate,
								@modulenumber,
								@organisationnumber,
								@workshopsector,
								@workshopstarttime,
								@workshopendtime,
								@workshopaddress,
								@workshoppostcode,
								@workshopcity,
								@workshopleader,
								@workshopnote,
								@workshop_id
END
GO

--===========================================================
-- SP_add_participant_to_group: adds a participant to a group                
--===========================================================

--select *
--from DEELNEMER_IN_AANVRAAG

CREATE OR ALTER PROC SP_add_participant_to_group
(
@request_id	INT,
@group_id		INT,
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	IF	(
		SELECT		COUNT(DEELNEMER_ID)
		FROM		DEELNEMER_IN_AANVRAAG
		WHERE		AANVRAAG_ID = @request_id
		AND			GROEP_ID = @group_id
		) >= 16
		BEGIN
			RETURN
		END
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	DEELNEMER_IN_AANVRAAG
				SET		GROEP_ID = @group_id
				WHERE	AANVRAAG_ID = @request_id
				AND		DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql,	N'@request_id INT, @group_id INT, @participant_id INT',
								@request_id, @group_id, @participant_id
END
GO

--===========================================================
-- SP_remove_participant_from_group: removes a participant from a group                    
--===========================================================

CREATE OR ALTER PROC SP_remove_participant_from_group
(
@request_id	INT,
@group_id		INT,
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	DEELNEMER_IN_AANVRAAG
				SET		GROEP_ID = NULL
				WHERE	AANVRAAG_ID = @request_id
				AND		DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql,	N'@request_id INT, @group_id INT, @participant_id INT',
								@request_id, @group_id, @participant_id
END
GO

/*==============================================================*/
/* SP Type: DELETE                                              */
/*==============================================================*/

CREATE OR ALTER PROC SP_disapprove_participant_of_workshop -- reference number M6
(
@workshop_id	INT,
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				DELETE FROM	DEELNEMER_IN_WORKSHOP
				WHERE		WORKSHOP_ID = @workshop_id
				AND			DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql, N'@workshop_id INT, @participant_id INT', @workshop_id, @participant_id
END
GO

CREATE OR ALTER PROC SP_remove_participant_from_workshoprequest
(
@request_id	INT,
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				DELETE FROM	DEELNEMER_IN_AANVRAAG
				WHERE		AANVRAAG_ID = @request_id
				AND			DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql, N'@request_id INT, @participant_id INT', @request_id, @participant_id
END
GO