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
		-SP_insert_workshoprequest 
		-SP_insert_group_of_workshoprequest
		-SP_add_date_and_time_to_request_from_group
		-SP_grant_large_account
		-SP_ungrant_large_account
		-SP_confirm_workshoprequest

		procedures modified:
		-

   Modifications made by Mark:
		procedures made:
		-SP_get_row_numbers_of_group_ids
		-SP_get_groups
		-SP_get_list_of_approved_workshop_participants
		-SP_get_reservelist_of_approved_workshop_participants
		-SP_get_list_of_to_approve_workshop_participants
		-SP_get_participants_of_workshoprequest
		-SP_get_participants_of_workshoprequest_without_group
		-SP_get_participants_of_group
		-SP_insert_deelnemer_in_workshop
		-SP_insert_participant_of_workshop
		-SP_insert_workshoprequest
		-SP_insert_participant_of_workshoprequest
		-SP_insert_sector
		-SP_approve_participant_of_workshop
		-SP_add_participant_to_group
		-SP_remove_participant_from_group
		-SP_disapprove_participant_of_workshop
		-SP_remove_participant_from_workshoprequest
		-SP_delete_workshoprequest

		procedures modified:
		-SP_get_workshops
		-SP_get_workshoprequests
		-SP_insert_participant_in_workshop
		-SP_insert_group_of_workshoprequest
		-SP_insert_workshop
		-SP_confirm_workshoprequest
		-SP_confirm_workshop_details
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
-- SP_get_where_and_when: returns all locations and times for all workshops for 1 module                                              
--============================================================================================

CREATE OR ALTER PROC SP_get_where_and_when
(
@modulenummer INT = NULL,
@workshop_ID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT WORKSHOP_ID, (''Op '' + CAST(FORMAT(DATUM, ''d'', ''nl-nl'') AS VARCHAR(20)) + '' van '' + CAST(FORMAT(STARTTIJD, N''hh\:mm'') AS VARCHAR(20))
				+ '' tot '' + CAST(FORMAT(EINDTIJD, N''hh\:mm'') AS VARCHAR(20)) + '' in '' + CAST(PLAATSNAAM AS VARCHAR(60))) AS waar_en_wanneer
				FROM WORKSHOP '
		IF(@modulenummer IS NOT NULL)
			BEGIN
				SET @sql += ' WHERE MODULENUMMER = @modulenummer '
			END
		IF(@workshop_ID IS NOT NULL)
			BEGIN
				SET @sql += ' WHERE WORKSHOP_ID = @workshop_ID '
			END
	SET @sql +=	' AND TYPE = ''IND''
				ORDER BY DATUM, STARTTIJD'
	 EXEC sp_executesql @sql, N'@modulenummer INT, @workshop_ID INT', @modulenummer, @workshop_ID
END
GO

--============================================================================================
-- SP_get_workshops: returns all workshops with the filters added                                        
--============================================================================================

CREATE OR ALTER PROC SP_get_workshops_filtered
(
@workshop_type		 NVARCHAR(6),
@modulenaam			 NVARCHAR(50),
@workshopleider_ID	 NVARCHAR(10),
@company_name		 NVARCHAR(60),
@firstname			 NVARCHAR(30),
@lastname			 NVARCHAR(50),
@status				 NVARCHAR(20)
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
							W.STATUS,
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
							C.CONTACTPERSOON_ID,
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

							WHERE WORKSHOP_ID IN (SELECT W.WORKSHOP_ID FROM WORKSHOP W
							LEFT JOIN DEELNEMER_IN_WORKSHOP DIW ON DIW.WORKSHOP_ID = W.WORKSHOP_ID
							LEFT JOIN DEELNEMER D ON DIW.DEELNEMER_ID = D.DEELNEMER_ID'

							IF (@firstname != '%%' OR @lastname != '%%')
								BEGIN
									SET @sql += ' WHERE D.VOORNAAM LIKE @firstname AND D.ACHTERNAAM LIKE @lastname)'
								END
							ELSE
								BEGIN
									SET @sql += ' WHERE D.VOORNAAM IS NULL AND D.ACHTERNAAM IS NULL)'
								END
							
				SET @sql += ' AND W.TYPE LIKE @workshop_type AND MODULENAAM LIKE @modulenaam AND WL.WORKSHOPLEIDER_ID LIKE @workshopleider_ID
							AND  O.ORGANISATIENAAM LIKE @company_name
							AND	 W.STATUS LIKE @status'

	EXEC sp_executesql @sql, N'@workshop_type NVARCHAR(6), @modulenaam NVARCHAR(50), @workshopleider_ID NVARCHAR(10), @company_name NVARCHAR(60),
	 @firstname NVARCHAR(30), @lastname NVARCHAR(50), @status NVARCHAR(20)', @workshop_type, @modulenaam, @workshopleider_ID, @company_name, @firstname, @lastname, @status

END  
GO

--============================================================================================
-- SP_get_workshops: returns all workshops with their data for the workshop overview page                                              
--============================================================================================

CREATE OR ALTER PROC SP_get_workshops
(
@order_by		 NVARCHAR(40) = NULL,
@order_direction NVARCHAR(4) = NULL,
@where			 NVARCHAR(40) = NULL,
@where_column	 NVARCHAR(40) = 'W.WORKSHOP_ID'
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
							C.CONTACTPERSOON_ID,
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
				FROM		WORKSHOP W LEFT JOIN
							ORGANISATIE O ON W.ORGANISATIENUMMER = O.ORGANISATIENUMMER LEFT JOIN
							MODULE M ON W.MODULENUMMER = M.MODULENUMMER LEFT JOIN
							WORKSHOPLEIDER WL ON W.WORKSHOPLEIDER_ID = WL.WORKSHOPLEIDER_ID LEFT JOIN
							ADVISEUR A ON W.ADVISEUR_ID = A.ADVISEUR_ID LEFT JOIN
							CONTACTPERSOON C ON W.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID'
	IF(@where IS NOT NULL OR @where != 'NULL') -- if the procedure was executed with an where statement, add the where statement to the select query
		BEGIN
			SET @sql += ' WHERE ' + @where_column + ' = @where'
		END
	IF(@order_by IS NULL OR @order_by != 'NULL')
		BEGIN
			SET @order_by = 'W.WORKSHOP_ID' -- if no order by statement was given with the execute, order by workshop_id's
		END
	IF(@order_direction IS NULL OR @order_direction != 'NULL')
		BEGIN
			SET @order_direction = 'ASC' -- if no order by direction was given, order by ascending
		END
	SET @sql += ' ORDER BY ' + @order_by + ' ' + @order_direction -- add an order by statement to the query
	EXEC sp_executesql @sql, N'@order_by NVARCHAR(40), @order_direction NVARCHAR(4), @where NVARCHAR(40), @where_column NVARCHAR(40)', @order_by, @order_direction, @where, @where_column
END
GO

--============================================================================================
-- SP_get_workshoprequests: returns all workshops that are requested                                        
--============================================================================================

CREATE OR ALTER PROC SP_get_workshoprequests
(
@where			 NVARCHAR(40) = NULL,
@where_column	 NVARCHAR(40) = 'A.AANVRAAG_ID'
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
		IF(@where IS NOT NULL and @where_column IS NOT NULL )
		BEGIN
				SET @sql += ' WHERE ' + @where_column + ' = @where'
		END
	EXEC sp_executesql @sql, N'@where NVARCHAR(40), @where_column NVARCHAR(40)', @where, @where_column
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
					SELECT MG.VOORKEUR, MG.DATUM, MG.STARTTIJD, MG.EINDTIJD, MG.WORKSHOPLEIDER, W.VOORNAAM, W.ACHTERNAAM, MG.BEVESTIGING_DATUM_SBB, MG.BEVESTIGING_WORKSHOPLEIDER,  MG.BEVESTIGING_DATUM_LEERBEDRIJF 	 	
					FROM MODULE_VAN_GROEP MG LEFT JOIN WORKSHOPLEIDER W
						ON MG.WORKSHOPLEIDER = W.WORKSHOPLEIDER_ID
					WHERE MG.GROEP_ID = @group_id
					AND MG.MODULENUMMER = @modulenumber
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
						,(
							SELECT COUNT(G.GROEP_ID) FROM GROEP G
							INNER JOIN MODULE_VAN_GROEP MVG ON MVG.GROEP_ID = G.GROEP_ID
							WHERE BEVESTIGING_DATUM_SBB IS NOT NULL
							AND BEVESTIGING_WORKSHOPLEIDER IS NOT NULL
							AND BEVESTIGING_DATUM_LEERBEDRIJF IS NOT NULL
							AND G.GROEP_ID = @group_ID
							) AS AantalGoedGekeurdeModules
						FROM GROEP G 
						INNER JOIN CONTACTPERSOON C ON G.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID
						WHERE G.GROEP_ID = @group_ID
						GROUP BY C.VOORNAAM, C.ACHTERNAAM, C.EMAIL, C.TELEFOONNUMMER, G.ADRES
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

CREATE OR ALTER PROC SP_get_list_of_approved_workshop_participants
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
								D.ACHTERNAAM,
								D.GEBOORTEDATUM,
								D.OPLEIDINGSNIVEAU,
								D.EMAIL,
								D.TELEFOONNUMMER
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

CREATE OR ALTER PROC SP_get_reservelist_of_approved_workshop_participants
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

--===================================================================================================================================================
-- SP_get_workshopleader_first_and_lastname: returns the firstname, lastname of a workshopleader                                    
--===================================================================================================================================================

CREATE OR ALTER PROC SP_get_workshopleader_first_and_lastname
(
@workshopleader_id NVARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT VOORNAAM, ACHTERNAAM, TOEVOEGING
				FROM WORKSHOPLEIDER
				WHERE WORKSHOPLEIDER_ID LIKE @workshopleader_id
				'
	 EXEC sp_executesql @sql, N'@workshopleader_id NVARCHAR(10)', @workshopleader_id
END
GO


--===================================================================================================================
-- SP_get_list_of_to_approve_workshop_participants: returns all participants of a workshop that are not approved                                 
--===================================================================================================================

CREATE OR ALTER PROC SP_get_list_of_to_approve_workshop_participants
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

--=========================================================================================
-- SP_get_workshops_for_workshopleader: returns all workshops for workshopleader                              
--=========================================================================================

CREATE OR ALTER PROC SP_get_workshops_for_workshopleader
(
@workshopleader_id			INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		*
				FROM		WORKSHOP
				WHERE		WORKSHOPLEIDER_ID = @workshopleader_id
				'
	EXEC sp_executesql @sql, N'@workshopleader_id INT', @workshopleader_id
END
GO


--=========================================================================================
-- SP_get_workshops_for_sector: returns all workshops for that sector                              
--=========================================================================================

CREATE OR ALTER PROC SP_get_workshops_for_sector
(
@sectornaam			NVARCHAR(10)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		*
				FROM		WORKSHOP
				WHERE		SECTORNAAM = @sectornaam
				'
	EXEC sp_executesql @sql, N'@sectornaam NVARCHAR(10)', @sectornaam
END
GO
--=========================================================================================
-- SP_get_cancelled_workshops: returns all cancelled workshops                              
--=========================================================================================

CREATE OR ALTER PROC SP_get_cancelled_workshops
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		*
				FROM		WORKSHOP
				WHERE		STATUS = ''geannuleerd''
				'
	EXEC sp_executesql @sql
END
GO

--=========================================================================================
-- SP_get_count_workshoptypes: returns all workshopstypes with their numbers                              
--=========================================================================================
CREATE OR ALTER PROC SP_get_count_workshoptypes
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT		TYPE, COUNT(TYPE) AS AANTAL
				FROM		WORKSHOP
				GROUP BY	TYPE
				'
	EXEC sp_executesql @sql
END
GO

--=========================================================================================
-- SP_get_participant_workshops: returns all workshops where the participant is signed in                              
--=========================================================================================
CREATE OR ALTER PROC SP_get_participant_workshops 
(
@participant_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				select DW.WORKSHOP_ID, TYPE, DATUM, MODULENAAM, ORGANISATIENAAM from DEELNEMER_IN_WORKSHOP DW JOIN WORKSHOP W
				ON DW.WORKSHOP_ID = W.WORKSHOP_ID JOIN MODULE M ON 
				W.MODULENUMMER = M.MODULENUMMER JOIN ORGANISATIE O ON
				W.ORGANISATIENUMMER = O.ORGANISATIENUMMER
				WHERE DEELNEMER_ID = @participant_id
				'
	EXEC sp_executesql @sql, N'@participant_id INT', @participant_id
END
GO

--=================================================================================
-- SP_get_participant_code: Gets the logincode of a participant based on given ID                           
--=================================================================================

CREATE OR ALTER PROC SP_get_participant_code
(
@participant_id INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				SELECT INLOGCODE 
				FROM DEELNEMER
				WHERE DEELNEMER_ID = @participant_id
				'
	 EXEC sp_executesql @sql, N'@participant_id INT', @participant_id
END
GO

/*==============================================================*/
/* SP Type: INSERT                                              */
/*==============================================================*/

--=================================================================================
-- SP_insert_workshopleader_availability: inserts the availability for a workshopleader                          
--=================================================================================
CREATE OR ALTER PROC SP_insert_workshopleader_availability
(
@workshopleader_id	INT,
@quarter			NCHAR(1),
@year				SMALLINT,
@amount_of_hours	SMALLINT
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	BESCHIKBAARHEID (WORKSHOPLEIDER_ID, KWARTAAL, JAAR, AANTAL_UUR)
				VALUES		(@workshopleader_id, @quarter, @year, @amount_of_hours)
				'
	EXEC sp_executesql @sql,	N'
								@workshopleader_id	INT,
								@quarter			NCHAR(1),
								@year				SMALLINT,
								@amount_of_hours	SMALLINT
								',
								@workshopleader_id, @quarter, @year, @amount_of_hours
END
GO

--=================================================================================
-- SP_insert_participant_in_workshop: inserts a deelnemer and put's him in his IND workshop                            
--=================================================================================

CREATE OR ALTER PROC SP_insert_participant_in_workshop
(
@companyNumber			NVARCHAR(15),
@salutation				NVARCHAR(7),
@firstname				NVARCHAR(30),
@lastname				NVARCHAR(50),
@birthdate				DATE,
@email					NVARCHAR(100),
@inlogcode              NVARCHAR(8),
@phonenumber			NVARCHAR(12),
@education				NVARCHAR(100),
@education_students		NVARCHAR(100) = NULL,
@sector					NVARCHAR(20) = NULL,
@function				NVARCHAR(50) = NULL,
@workshop_id			INT
)
AS
BEGIN
	SET NOCOUNT ON

	-- Create a deelnemer based on the given parameters

	DECLARE @sql NVARCHAR(4000)
	DECLARE @is_open_registration BIT
	DECLARE @participant_id INT
	DECLARE @organisationnumber NVARCHAR(15)

	IF ((SELECT [TYPE] FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id) = 'IND')
		BEGIN
			SET @is_open_registration = 1
		END
	ELSE
		BEGIN
			SET @is_open_registration = 0
		END

			IF ((@is_open_registration) = 0) AND 
				 NOT EXISTS	( -- Check if there is already an participant in the database with the same email, name and company
					SELECT * --		  if there is, don't insert the participant.
					FROM DEELNEMER
					WHERE VOORNAAM = @firstname
					AND ACHTERNAAM = @lastname
					AND EMAIL = @email
					AND ORGANISATIENUMMER = @companyNumber
					AND IS_OPEN_INSCHRIJVING = 0
				)
				BEGIN
					SET @sql =	N'
								INSERT INTO	DEELNEMER (ORGANISATIENUMMER, AANHEF, VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, INLOGCODE, TELEFOONNUMMER, OPLEIDINGSNIVEAU, IS_OPEN_INSCHRIJVING)
								VALUES	(
										@companyNumber,
										@salutation,
										@firstname,
										@lastname,
										@birthdate,
										@email,
										@inlogcode,
										@phonenumber,
										@education,
										@is_open_registration
										)
								'

								EXEC sp_executesql @sql,	N'
												@companyNumber			NVARCHAR(15),
												@salutation				NVARCHAR(7),
												@firstname				NVARCHAR(30),
												@lastname				NVARCHAR(50),
												@birthdate				DATE,
												@email					NVARCHAR(100),
												@inlogcode              NVARCHAR(8),
												@phonenumber			NVARCHAR(12),
												@education				NVARCHAR(100),
												@is_open_registration   BIT
												',
												@companyNumber,
												@salutation,	
												@firstname,	
												@lastname,	
												@birthdate,	
												@email,		
												@phonenumber,
												@education,
												@is_open_registration
				END
			ELSE IF ((@is_open_registration) = 1) AND 
					 NOT EXISTS	( -- Check if there is already an participant in the database with the same email, name and company
					SELECT * --		  if there is, don't insert the participant.
					FROM DEELNEMER
					WHERE VOORNAAM = @firstname
					AND ACHTERNAAM = @lastname
					AND EMAIL = @email
					AND ORGANISATIENUMMER = @companyNumber
					AND IS_OPEN_INSCHRIJVING = 1
				)
				BEGIN
					SET @sql =	N'
								INSERT INTO	DEELNEMER (ORGANISATIENUMMER, AANHEF, VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, INLOGCODE, TELEFOONNUMMER, OPLEIDINGSNIVEAU, GEWENST_BEGELEIDINGSNIVEAU, SECTORNAAM, FUNCTIENAAM, IS_OPEN_INSCHRIJVING)
								VALUES	(
										@companyNumber,
										@salutation,
										@firstname,
										@lastname,
										@birthdate,
										@email,
										@inlogcode,
										@phonenumber,
										@education,
										@education_students,
										@sector,
										@function,
										@is_open_registration
										)
								'
								EXEC sp_executesql @sql,	N'
												@companyNumber			NVARCHAR(15),
												@salutation				NVARCHAR(7),
												@firstname				NVARCHAR(30),
												@lastname				NVARCHAR(50),
												@birthdate				DATE,
												@email					NVARCHAR(100),
												@inlogcode              NVARCHAR(8),
												@phonenumber			NVARCHAR(12),
												@education				NVARCHAR(100),
												@education_students		NVARCHAR(100),
												@sector					NVARCHAR(20),
												@function				NVARCHAR(50),
												@is_open_registration   BIT
												',
												@companyNumber,
												@salutation,	
												@firstname,	
												@lastname,	
												@birthdate,	
												@email,		
												@inlogcode,
												@phonenumber,
												@education,
												@education_students,
												@sector,
												@function,	
												@is_open_registration
				END
			ELSE 
				BEGIN 
					SET @sql = N' UPDATE DEELNEMER
								  SET INLOGCODE = @INLOGCODE
								  WHERE VOORNAAM = @firstname
										AND ACHTERNAAM = @lastname
										AND EMAIL = @email
										AND ORGANISATIENUMMER = @companyNumber'
					EXEC sp_executesql @sql,	N'
												@companyNumber			NVARCHAR(15),
												@firstname				NVARCHAR(30),
												@lastname				NVARCHAR(50),
												@email					NVARCHAR(100),
												@inlogcode              NVARCHAR(8)
												',
												@companyNumber,
												@firstname,	
												@lastname,	
				
												@email,		
												@inlogcode
				END


			SET @participant_id =	(
									SELECT DEELNEMER_ID 
									FROM DEELNEMER 
									WHERE VOORNAAM = @firstname
											AND ACHTERNAAM = @lastname
											AND EMAIL = @email
											AND ORGANISATIENUMMER = @companyNumber
											AND IS_OPEN_INSCHRIJVING = @is_open_registration
									) 


	EXEC SP_insert_deelnemer_in_workshop @workshop_id, @participant_id
END
GO

--=========================================================================
-- SP_insert_deelnemer_in_workshop: inserts a deelnemer in a IND workshop                            
--=========================================================================

CREATE OR ALTER PROC SP_insert_deelnemer_in_workshop
(
@workshop_id				INT,
@deelnemer_id				INT
)

AS
BEGIN
	SET NOCOUNT ON
	IF NOT EXISTS (SELECT * FROM DEELNEMER_IN_WORKSHOP WHERE DEELNEMER_ID = @deelnemer_id AND WORKSHOP_ID = @workshop_id)
		BEGIN
		-- Create a deelnemer based on the given parameters
	
		DECLARE @sql NVARCHAR(4000)
		DECLARE @volgnummer INT = (SELECT MAX(VOLGNUMMER + 1) FROM DEELNEMER_IN_WORKSHOP WHERE workshop_id = @workshop_id)
	
		IF @volgnummer IS NULL
		BEGIN
			SET @volgnummer = 1
		END
	
		SET @sql =	N'
					INSERT INTO	DEELNEMER_IN_WORKSHOP
					VALUES		(
								@workshop_id,
								@deelnemer_id,
								@volgnummer,
								0
								)
					'
		EXEC sp_executesql @sql,	N'
									@workshop_id	INT,
									@deelnemer_id	INT,
									@volgnummer		INT 
									',
									@workshop_id,
									@deelnemer_id,
									@volgnummer
	
	END
END
GO

--=================================================
-- SP_insert_workshop: inserts a new workshop                              
--=================================================
CREATE OR ALTER PROC SP_insert_workshop
(
@workshopdate				NVARCHAR(10),
@plannername				NVARCHAR(52),
@modulenumber				INT,
@workshopsector				NVARCHAR(20),
@workshopstarttime			NVARCHAR(10),
@workshopendtime			NVARCHAR(10),
@workshopaddress			NVARCHAR(60),
@workshopcity				NVARCHAR(60),
@workshoppostcode			NVARCHAR(7),
@workshopleader				INT,
@workshopnote				NVARCHAR(255),
@contactperson_name			NVARCHAR(80),
@contactperson_email		NVARCHAR(100),
@contactperson_phonenumber	NVARCHAR(12)
)
AS
BEGIN
	SET NOCOUNT ON

	-- Create a workshop based on the given parameters

	DECLARE @organisationnumber NVARCHAR(15) = (SELECT ORGANISATIENUMMER FROM ORGANISATIE WHERE ORGANISATIENAAM LIKE 'SBB')
	DECLARE @sql NVARCHAR(4000)
	DECLARE @status NVARCHAR(40) = 'uitgezet'

	IF(@workshopleader IS NOT NULL)
		BEGIN
			SET @status = 'bevestigd'
		END

	SET @sql =	N'
				INSERT INTO	WORKSHOP(DATUM, PLANNERNAAM, MODULENUMMER, SECTORNAAM, STARTTIJD, EINDTIJD, ADRES, PLAATSNAAM, POSTCODE, WORKSHOPLEIDER_ID, OPMERKING, CONTACTPERSOON_NAAM, CONTACTPERSOON_EMAIL, CONTACTPERSOON_TELEFOONNUMMER, TYPE, ORGANISATIENUMMER)
				VALUES		(
							@workshopdate,				
							@plannername,			
							@modulenumber,				
							@workshopsector,			
							@workshopstarttime,			
							@workshopendtime,			
							@workshopaddress,			
							@workshopcity,				
							@workshoppostcode,			
							@workshopleader,			
							@workshopnote,				
							@contactperson_name,		
							@contactperson_email,		
							@contactperson_phonenumber,
							''IND'',
							@organisationnumber
							)
				'
	EXEC sp_executesql @sql,	N'
								@workshopdate				NVARCHAR(10),
								@plannername				NVARCHAR(52),
								@modulenumber				INT,
								@workshopsector				NVARCHAR(20),
								@workshopstarttime			NVARCHAR(10),
								@workshopendtime			NVARCHAR(10),
								@workshopaddress			NVARCHAR(60),
								@workshopcity				NVARCHAR(60),
								@workshoppostcode			NVARCHAR(7),
								@workshopleader				INT,
								@workshopnote				NVARCHAR(255),
								@contactperson_name			NVARCHAR(80),
								@contactperson_email		NVARCHAR(100),
								@contactperson_phonenumber	NVARCHAR(12),
								@organisationnumber			NVARCHAR(15)
								',
								@workshopdate,				
								@plannername,			
								@modulenumber,				
								@workshopsector,				
								@workshopstarttime,			
								@workshopendtime,			
								@workshopaddress,			
								@workshopcity,				
								@workshoppostcode,			
								@workshopleader,				
								@workshopnote,				
								@contactperson_name,			
								@contactperson_email,		
								@contactperson_phonenumber,
								@organisationnumber	
END
GO

--=================================================
-- SP_insert_workshop: inserts a new sector                              
--=================================================
CREATE OR ALTER PROC SP_insert_sector
(
@sectorname	NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	SECTOR (SECTORNAAM)
				VALUES		(@sectorname)
				'
	EXEC sp_executesql @sql, N'@sectorname NVARCHAR(20)', @sectorname
END
GO

--=======================================================================
-- SP_insert_participants_of_workshop: inserts participants of a workshop                      
--=======================================================================

CREATE OR ALTER PROC SP_insert_participant_of_workshop
(
@workshop_id		INT,
@firstname			NVARCHAR(30),
@lastname			NVARCHAR(50),
@birthdate			DATE,
@email				NVARCHAR(100),
@phonenumber		NVARCHAR(12),
@education			NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql2 NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	DEELNEMER (VOORNAAM, ACHTERNAAM, GEBOORTEDATUM, EMAIL, TELEFOONNUMMER, OPLEIDINGSNIVEAU, IS_OPEN_INSCHRIJVING)
				VALUES		(
							@firstname,
							@lastname,
							@birthdate,
							@email,
							@phonenumber,
							@education,
							0
							)
				'
	EXEC sp_executesql @sql,	N'
								@firstname NVARCHAR(30),
								@lastname NVARCHAR(50),
								@birthdate DATE,
								@email NVARCHAR(100),
								@phonenumber NVARCHAR(12),
								@education NVARCHAR(100)
								',
								@firstname,
								@lastname,
								@birthdate,
								@email,
								@phonenumber,
								@education
	DECLARE @participant_id INT = (SELECT IDENT_CURRENT('DEELNEMER'))
	SET @sql2 =	N'
				INSERT INTO	DEELNEMER_IN_WORKSHOP (WORKSHOP_ID, DEELNEMER_ID)
				VALUES		(@workshop_id, @participant_id)
				'
	EXEC sp_executesql @sql2, N'@workshop_id INT, @participant_id INT', @workshop_id, @participant_id
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
@plannername		NVARCHAR(52),
@sectornaam		NVARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO	AANVRAAG(ORGANISATIENUMMER, CONTACTPERSOON_ID, ADVISEUR_ID, PLANNERNAAM, SECTORNAAM)
				VALUES		(
							@organisationnumber,
							@contactperson_id,
							@advisor_id,
							@plannername,
							@sectornaam
							)
				'
	EXEC sp_executesql @sql,	N'@organisationnumber INT, @contactperson_id INT, @advisor_id INT, @plannername NVARCHAR(52), @sectornaam NVARCHAR(20)',
								@organisationnumber, @contactperson_id, @advisor_id, @plannername, @sectornaam
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
@postcode			NVARCHAR(20),
@placename			NVARCHAR(60),
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
				INSERT INTO	GROEP(AANVRAAG_ID, CONTACTPERSOON_ID, ADRES, POSTCODE, PLAATSNAAM)
				VALUES		(@request_id, @contactperson_id, @address, @postcode, @placename)	 
				'
	EXEC sp_executesql @sql, N'@request_id INT, @contactperson_id INT, @address NVARCHAR(60), @postcode	NVARCHAR(20), @placename NVARCHAR(60)', @request_id, @contactperson_id, @address, @postcode, @placename
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
	IF	(
		SELECT		COUNT(*)
		FROM		GROEP
		WHERE		AANVRAAG_ID = @request_id
		) = 1
		BEGIN
			DECLARE @sql3 NVARCHAR(4000)
			DECLARE @group_id INT = (SELECT GROEP_ID FROM GROEP WHERE AANVRAAG_ID = @request_id)
			SET @sql3 =	N'
						UPDATE	DEELNEMER_IN_AANVRAAG
						SET		GROEP_ID = @group_id
						WHERE	AANVRAAG_ID = @request_id
						'
			EXEC sp_executesql @sql3, N'@request_id INT, @group_id INT', @request_id, @group_id
		END
END
GO

--=======================================================================
-- SP_confirm_workshoprequest: turns request into workshop                       
--=======================================================================

CREATE OR ALTER PROC SP_confirm_workshoprequest
(
@request_id		INT,
@group_id		INT,
@modulenumber	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @sql1 NVARCHAR(2000)
	DECLARE @sql2 NVARCHAR(2000)
	DECLARE @sql3 NVARCHAR(2000)
	DECLARE @sql4 NVARCHAR(2000)
	DECLARE @sql5 NVARCHAR(4000)
	DECLARE @sql6 NVARCHAR(4000)
	DECLARE @type NVARCHAR(3)
	
	IF((SELECT COUNT(GROEP_ID)
		FROM GROEP
		WHERE AANVRAAG_ID = @request_id) > 3)
		BEGIN
			SET @type = 'LA'
		END
	ELSE
		BEGIN
			SET @type = 'INC'
		END

	SET @sql =	N'
				INSERT INTO	WORKSHOP(WORKSHOPLEIDER_ID, CONTACTPERSOON_ID, ORGANISATIENUMMER, MODULENUMMER, ADVISEUR_ID, DATUM, STARTTIJD, EINDTIJD, ADRES, POSTCODE, PLAATSNAAM, TYPE)
				SELECT	MG.WORKSHOPLEIDER, G.CONTACTPERSOON_ID, A.ORGANISATIENUMMER, MG.MODULENUMMER, A.ADVISEUR_ID, MG.DATUM, MG.STARTTIJD, MG.EINDTIJD, G.ADRES, G.POSTCODE, G.PLAATSNAAM, @type
				FROM	AANVRAAG A INNER JOIN
						GROEP G ON A.AANVRAAG_ID = G.AANVRAAG_ID INNER JOIN
						MODULE_VAN_GROEP MG
						ON G.GROEP_ID = MG.GROEP_ID
				WHERE	A.AANVRAAG_ID = @request_id
				AND		MG.GROEP_ID = @group_id
				AND		MG.MODULENUMMER = @modulenumber
				'

	DECLARE @workshop_id INT 
	SET @workshop_id = (SELECT IDENT_CURRENT('WORKSHOP'))

	SET @sql5 =	N'
				INSERT INTO DEELNEMER_IN_WORKSHOP (WORKSHOP_ID, DEELNEMER_ID, VOLGNUMMER, IS_GOEDGEKEURD)
				SELECT	@workshop_id, DEELNEMER_ID, 1, 1
				FROM	DEELNEMER_IN_AANVRAAG DIA INNER JOIN
						MODULE_VAN_GROEP MG ON DIA.GROEP_ID = MG.GROEP_ID
				WHERE	DIA.AANVRAAG_ID = @request_id
				AND		DIA.GROEP_ID = @group_id
				AND		MG.MODULENUMMER = @modulenumber
				'

	SET @sql1 = N'DELETE MVG
					FROM AANVRAAG A
					INNER JOIN GROEP G ON G.AANVRAAG_ID = A.AANVRAAG_ID
					INNER JOIN MODULE_VAN_GROEP MVG ON MVG.GROEP_ID = G.GROEP_ID
					WHERE A.AANVRAAG_ID = @request_id
					AND G.GROEP_ID = @group_id
					AND MVG.MODULENUMMER = @modulenumber'
/*
	SET @sql2 = N'DELETE G
					FROM AANVRAAG A
					INNER JOIN GROEP G ON G.AANVRAAG_ID = A.AANVRAAG_ID
					WHERE A.AANVRAAG_ID = @request_id'

	SET @sql3 = N'DELETE A
					FROM AANVRAAG A
					WHERE A.AANVRAAG_ID = @request_id'

	SET @sql4 = N'DELETE FROM DEELNEMER_IN_AANVRAAG WHERE AANVRAAG_ID = @request_id'
	*/


	EXEC sp_executesql @sql,	N'@request_id INT, @type NVARCHAR(3), @group_id INT, @modulenumber INT', @request_id, @type, @group_id, @modulenumber
	EXEC sp_executesql @sql5,	N'@request_id INT, @group_id INT, @modulenumber INT, @workshop_id INT', @request_id, @group_id, @modulenumber, @workshop_id
	EXEC sp_executesql @sql1,	N'@request_id INT, @group_id INT, @modulenumber INT', @request_id, @group_id, @modulenumber
	/*
	EXEC sp_executesql @sql4,	N'@request_id INT', @request_id
	EXEC sp_executesql @sql2,	N'@request_id INT', @request_id
	EXEC sp_executesql @sql3,	N'@request_id INT', @request_id
	*/

	IF NOT EXISTS	(
					SELECT	*
					FROM	MODULE_VAN_GROEP MVG INNER JOIN
							GROEP G ON MVG.GROEP_ID = G.GROEP_ID
					WHERE	G.AANVRAAG_ID = @request_id
					--AND		G.GROEP_ID = @group_id
					)
	BEGIN
		EXEC SP_delete_workshoprequest @request_id
	END

END
GO

--=======================================================================================
-- SP SP_create_organisation: create a organisation                    
--=======================================================================================

CREATE OR ALTER PROC SP_create_organisation
(
@organisationName	VARCHAR(60),
@adres				VARCHAR(60),
@postcode			VARCHAR(20),
@location			VARCHAR(60),
@LargeAccount		BIT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				INSERT INTO ORGANISATIE
				(ORGANISATIENUMMER,ORGANISATIENAAM,ADRES,POSTCODE,PLAATSNAAM,LARGE_ACCOUNTS)
				VALUES
				((SELECT MAX(CAST(ORGANISATIENUMMER AS INT) + 1) FROM ORGANISATIE), @organisationName, @adres, @postcode, @location, @LargeAccount)
				'
	EXEC sp_executesql @sql, N'@organisationName VARCHAR(60), @adres VARCHAR(60), @postcode VARCHAR(20), @location VARCHAR(60), @LargeAccount BIT',  @organisationName, @adres, @postcode, @location, @LargeAccount 
END
GO
/*==============================================================*/
/* SP Type: UPDATE                                              */
/*==============================================================*/

--=======================================================================================
-- SP SP_approve_participant_of_workshop: updates participants of a workshop to approved                       
--=======================================================================================

CREATE OR ALTER PROC SP_approve_participant_of_workshop
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
CREATE OR ALTER PROC SP_alter_workshop
(
@workshop_id		INT,
@workshoptype		NVARCHAR(3),
@workshopdate		NVARCHAR(10),
@workshopContact	INT,
@modulenumber		INT,
@organisationnumber	VARCHAR(15),
@workshopsector		NVARCHAR(20),
@workshopstarttime	NVARCHAR(10),
@workshopendtime	NVARCHAR(10),
@workshopaddress	NVARCHAR(60),
@workshoppostcode	NVARCHAR(7),
@workshopcity		NVARCHAR(60),
@workshopleader		INT,
@workshopnote		NVARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON

	IF(@workshopleader = 0)
	BEGIN
		SET @workshopleader = null
	END

	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	WORKSHOP
				SET		[TYPE] = @workshoptype,
						DATUM = @workshopdate,
						MODULENUMMER = @modulenumber,
						CONTACTPERSOON_ID = @workshopContact,
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
								@workshopContact INT,
								@organisationnumber NVARCHAR(15),
								@workshopsector NVARCHAR(20),
								@workshopstarttime NVARCHAR(10),
								@workshopendtime NVARCHAR(10),
								@workshopaddress NVARCHAR(60),
								@workshoppostcode NVARCHAR(7),
								@workshopcity NVARCHAR(60),
								@workshopleader INT,
								@workshopnote NVARCHAR(255),
								@workshop_id INT
								',
								@workshoptype,
								@workshopdate,
								@modulenumber,
								@workshopContact,
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

--===========================================================
-- SP_add_date_and_time_and_workshopleader_to_request_from_group                    
--===========================================================


CREATE OR ALTER PROC SP_add_date_and_time_and_workshopleader_to_request_from_group
(
@Groupsnumber INT,
@Modulenumber INT,
@Groep_Module_Date DATE = NULL,
@Groep_Module_Starttime TIME = NULL,
@Groep_Module_Endtime TIME = NULL,
@Groep_Module_workshopleader INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	MODULE_VAN_GROEP
				SET		DATUM = @Groep_Module_Date,
						STARTTIJD = @Groep_Module_Starttime,
					    EINDTIJD = @Groep_Module_Endtime'
				IF(@Groep_Module_workshopleader IS NOT NULL)
					BEGIN
					SET @sql = @sql + ',
						WORKSHOPLEIDER = @Groep_Module_workshopleader
					'
					END

		SET @sql = @sql + '	WHERE GROEP_ID = @Groupsnumber
				AND		MODULENUMMER = @Modulenumber
				'

	EXEC sp_executesql @sql,	N'@Groupsnumber INT,
								  @Modulenumber INT,
								  @Groep_Module_Date DATE,
								  @Groep_Module_Starttime TIME,
								  @Groep_Module_Endtime TIME,
								  @Groep_Module_workshopleader INT',
								  @Groupsnumber,
								  @Modulenumber,
								  @Groep_Module_Date,
								  @Groep_Module_Starttime,
								  @Groep_Module_Endtime,
								  @Groep_Module_workshopleader
END
GO

--=======================================================================================
-- SP SP_grant_large_account: grant organisation to request large account                       
--=======================================================================================

CREATE OR ALTER PROC SP_grant_large_account
(
@organisation	VARCHAR(15)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	ORGANISATIE
				SET		LARGE_ACCOUNTS = 1
				WHERE	ORGANISATIENUMMER = @organisation'
	EXEC sp_executesql @sql, N'@organisation NVARCHAR(15)', @organisation
END
GO

--=======================================================================================
-- SP SP_ungrant_large_account: ungrant organisation to request large account                       
--=======================================================================================

CREATE OR ALTER PROC SP_ungrant_large_account
(
@organisation	VARCHAR(15)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	ORGANISATIE
				SET		LARGE_ACCOUNTS = 0
				WHERE	ORGANISATIENUMMER = @organisation'
	EXEC sp_executesql @sql, N'@organisation NVARCHAR(15)', @organisation
END
GO

--=============================================================================================================================
-- SP SP_confirm_Workshop_Details: Confirm workshopleader / date on sbb's side or the contactperson's side based on parameters                     
--=============================================================================================================================
CREATE OR ALTER PROC SP_confirm_Workshop_Details
(
@detailToConfirm NVARCHAR(400),
@groep_id INT,
@modulenummer INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	DECLARE @column NVARCHAR(60)
	SET @column = CASE @detailToConfirm
					WHEN 'dateSBB' THEN 'BEVESTIGING_DATUM_SBB'
					WHEN 'workshopleader' THEN 'BEVESTIGING_WORKSHOPLEIDER'
					WHEN 'dateContact' THEN 'BEVESTIGING_DATUM_LEERBEDRIJF'
				END

	SET @sql =  N'UPDATE MODULE_VAN_GROEP
					SET ' + @column + ' = 1
					WHERE GROEP_ID = @groep_id
					AND MODULENUMMER = @modulenummer'
	EXEC sp_executesql @sql, N'@groep_id INT, @modulenummer INT', @groep_id, @modulenummer

	IF @column = 'BEVESTIGING_WORKSHOPLEIDER'
		BEGIN
			DECLARE @workshopleader_ID INT = (SELECT WORKSHOPLEIDER FROM MODULE_VAN_GROEP WHERE GROEP_ID = @groep_id)
			DECLARE @start_workshop TIME(7) = (SELECT STARTTIJD FROM MODULE_VAN_GROEP WHERE GROEP_ID = @groep_id)
			DECLARE @end_workshop TIME(7) = (SELECT EINDTIJD FROM MODULE_VAN_GROEP WHERE GROEP_ID = @groep_id)
			DECLARE @year SMALLINT = (SELECT CAST(YEAR(DATUM) AS SMALLINT) FROM MODULE_VAN_GROEP WHERE GROEP_ID = @groep_id)
			DECLARE @quarter CHAR(1) = (SELECT CAST(DATEPART(QUARTER, DATUM) AS CHAR(1)) FROM MODULE_VAN_GROEP WHERE GROEP_ID = @groep_id)

			UPDATE	BESCHIKBAARHEID
			SET		AANTAL_UUR = (AANTAL_UUR - (CAST(DATEDIFF(minute, @start_workshop , @end_workshop) AS NUMERIC(5,2)) / 60.00))
			WHERE	WORKSHOPLEIDER_ID = @workshopleader_ID
			AND		JAAR = @year
			AND		KWARTAAL = @quarter
		END
END
GO

--=============================================================================================================================
-- SP SP_cancel_workshop: Cancels a workshop                    
--=============================================================================================================================

CREATE OR ALTER PROC SP_cancel_workshop
(
@workshop_id	INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(4000)
	SET @sql =	N'
				UPDATE	WORKSHOP
				SET		STATUS = ''geannuleerd''
				WHERE	WORKSHOP_ID = ' + CAST(@workshop_id AS varchar(7)) + ''
	EXEC sp_executesql @sql, N'@workshop_id INT', @workshop_id
END
GO

/*==============================================================*/
/* SP Type: DELETE                                              */
/*==============================================================*/

CREATE OR ALTER PROC SP_disapprove_participant_of_workshop
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

CREATE OR ALTER PROC SP_delete_workshoprequest
(
@request_id	INT
)
AS
BEGIN
	SET NOCOUNT ON

	DELETE
	FROM	DEELNEMER_IN_AANVRAAG
	WHERE	AANVRAAG_ID = @request_id

	DELETE
	FROM	GROEP
	WHERE	AANVRAAG_ID = @request_id

	DELETE
	FROM	AANVRAAG
	WHERE	AANVRAAG_ID = @request_id
END