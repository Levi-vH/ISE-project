/* =====================================================================
   Author: Bart
   Create date: 26-11-2018
   Description: here you can find all the tSQLt tests for 
   the constraints that are used in the database 'SBBWorkshopOmgeving'
   --------------------------------
   Modified by:
   Modifications made by :
   ==================================================================== */

USE [UnitTesting SBB]

-- all tests are sorted per table. You can find the table name and the function of the constraint
-- that is being tested for every constraint

EXEC tSQLt.NewTestClass 'testWorkshop';
EXEC tSQLt.NewTestClass 'testDeelnemer';
EXEC tSQLt.NewTestClass 'testModuleVanGroep';

EXEC tSQLt.run 'testWorkshop'
EXEC tSQLt.run 'testDeelnemer'
EXEC tSQLt.run 'testModuleVanGroep'

-- the select statement can be used to drop all tables in the tSQLt database
/*
SELECT  'DROP TABLE ' + TABLE_SCHEMA + '.' + TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_SCHEMA LIKE ('dbo%')

*/

--==============================================
-- all tests for the workshop table constraints
--==============================================

--=======================================================
-- tests for the check on the automatic update on status
--=======================================================

-- test with type = 'afgehandeld'
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 1]
AS
BEGIN
	IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]


	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
	[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
	[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
END;
GO

-- test with workhop_id = 1 and workshopleider_ID = '1'
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 2]
AS
BEGIN
	IF OBJECT_ID('[testWorkshopStateTrigger2]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger2]


	SELECT * 
	INTO testWorkshopStateTrigger2
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger2([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bevestigd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 


	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger2', @Actual='dbo.WORKSHOP'
END;
GO

-- test with workhop_id = 1, workshopleider_ID = '1' and type = 'afgehandeld'
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 3]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 3]
AS
BEGIN
	IF OBJECT_ID('[testWorkshopStateTrigger3]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger3]


	SELECT * 
	INTO testWorkshopStateTrigger3
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger3([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 


	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);  

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger3', @Actual='dbo.WORKSHOP'
END;
GO

-- test with workhop_id = 1
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 4]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 4]
AS
BEGIN
	IF OBJECT_ID('[testWorkshopStateTrigger4]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger4]


	SELECT * 
	INTO testWorkshopStateTrigger4
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger4([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 


	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger4', @Actual='dbo.WORKSHOP'
END;
GO

--==================================================
-- tests for the check on advisors in INC workshops
--==================================================

-- test for advisor = 1 and type = COM
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for advisor in INC workshops 1]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_advisor';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for advisor in INC workshops 2]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_advisor';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = NULL and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 3]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for advisor in INC workshops 3]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_advisor';

	EXEC tSQLt.ExpectException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 4]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for advisor in INC workshops 4]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_advisor';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--======================================
-- tests for the check on workshop date
--======================================

-- test for workshopdate = 20 seconds after getdate
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopdate 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopdate 1]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_date';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(m, 2, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for workshopdate = 20 seconds before getdate
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopdate 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopdate 2]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_date';

	EXEC tSQLt.ExpectException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--========================================================================================
-- tests if the workshopstatus is 'uitgezet', 'bevestigd', 'geannuleerd' or 'afgehandeld'
--========================================================================================

-- test for status is uitgezet
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopstatus 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopstatus 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_state';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uitgezet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for status is aaaaa
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopstatus 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopstatus 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_state';

	EXEC tSQLt.ExpectException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'aaaaa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--==========================================================
-- tests if the workshop endtime is after the starting time
--==========================================================

-- test for starttime is getdate and endtime is getdate + 30 sec 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopEndtime 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopEndtime 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_state';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, 30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for starttime is getdate and endtime is getdate - 30 sec 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopEndtime 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopEndtime 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_state';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, -30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--==============================================================================================================================
-- Tests if a workshop that received VERWERKT_BREIN, DEELNEMER_GEGEGEVENS_ONTVANGEN, OVK_BEVESTIGING, PRESENTIELIJST_VERSTUURD,
-- PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL has status 'afgehandeld'
--==============================================================================================================================

-- test for status is bevestigd with all columns NOT NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopConcluded 1]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bevestigd', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_concluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
	END
GO

-- test for status is bevestigd with one column on NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopConcluded 2]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL, NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_concluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
END
GO

-- test for status is afgehandeld with all columns NOT NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 3]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopConcluded 3]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TR_workshop_concluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'END
GO

--====================================================================
-- Tests when workshop_type isn't IND, then SECTOR has te be NOT NULL
--====================================================================

-- test for type is IND and sector is NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopTypeAndSector 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_type_and_sector';

	EXEC tSQLt.ExpectnoException

	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IND', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is INC and sector is NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopTypeAndSector 2]
AS
BEGIN
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_type_and_sector';

	EXEC tSQLt.ExpectException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is INC and sector is NOT NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 3]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopTypeAndSector 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_type_and_sector';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'SECTOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is IND and sector is NOT NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 4]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for workshopTypeAndSector 4]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_workshop_type_and_sector';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
						[MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [PLANNERNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES],
						[POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
						[OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL],
						[CONTACTPERSOON_NAAM], [CONTACTPERSOON_EMAIL], [CONTACTPERSOON_TELEFOONNUMMER])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'SECTOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IND', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

--=========================================================
-- test when workshopleader isn't with a workshop anymore,
-- he/she gets the available hours back
--=========================================================


--======================================
-- tests for the module_van_groep table
--======================================

--======================================================
-- test when workshopleader isn't with a group anymore,
-- he/she gets the available hours back
--======================================================


--===============================
-- tests for the deelnemer table
--===============================

--=============================================
-- test if the e-mail contains a '@' and a '.'
--=============================================

-- test for emails without a '@'
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer emails 1]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for deelnemer emails 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_deelnemer_email';

	EXEC tSQLt.ExpectException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'henkpieter.nl', NULL, NULL, NULL, NULL, NULL, NULL);  
END
GO

-- test for emails without a '.'
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer emails 2]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for deelnemer emails 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_deelnemer_email';

	EXEC tSQLt.ExpectException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'henk@pieternl', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for emails with a '@' and a '.'
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer emails 3]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for deelnemer emails 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_deelnemer_email';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'henk@pieter.nl', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--=================================================================
-- Test if the date of birth can't be higher than the current date
--=================================================================

-- Test for date of birth is current date +20 sec
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer birthdates 1]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for deelnemer birthdates 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_deelnemer_birthdate';

	EXEC tSQLt.ExpectException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, DATEADD(m, 2, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- Test for date of birth is current date -20 sec
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer birthdates 2]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for deelnemer birthdates 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_deelnemer_birthdate';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--======================================================================================
-- Test for when IS_OPEN_INSCHRIJVING is 1 then GEWENST_BEGELEIDINGSNIVEAU 
-- and FUNCTIENAAM have to be NOT NULL
--======================================================================================

-- Test for IS_OPEN_INSCHRIJVING is 1 AND the rest is NOT NULL 
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 1]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for open inschrvijving 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_open_inschrijving_values';

	EXEC tSQLt.ExpectnoException

	INSERT INTO DEELNEMER ( [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'niveau', 'functienaam', NULL); 
END
GO

-- Test for IS_OPEN_INSCHRIJVING is 0 AND the rest is NOT NULL 
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 2]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for open inschrvijving 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_open_inschrijving_values';

	EXEC tSQLt.ExpectnoException

	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'niveau', 'functienaam', NULL); 
END
GO

-- Test for IS_OPEN_INSCHRIJVING is 1 AND FUNCTIENAAM is NULL 
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 3]
GO

CREATE OR ALTER PROCEDURE [testDeelnemer].[test for open inschrvijving 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_open_inschrijving_values';

	EXEC tSQLt.ExpectException

	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'niveau', NULL, NULL); 
END
GO

--======================================================================================
-- Test for when TYPE is 'IND' then CONTACTPERSOON_NAAM, CONTACTPERSOON_EMAIL
-- and CONTACTPERSOON_TELEFOONUMMER have to be NOT NULL
--======================================================================================

-- Test for TYPE is 'IND' and the rest is not NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for type ind 1]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for type ind 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_ind_workshop_values';

	EXEC tSQLt.ExpectnoException

	INSERT INTO WORKSHOP ([TYPE], CONTACTPERSOON_NAAM, CONTACTPERSOON_EMAIL, CONTACTPERSOON_TELEFOONNUMMER)
	VALUES('IND', 'naam1', 'email@hotmail.com', '0612345678'); 
END
GO

-- Test for TYPE is not 'IND' and the rest is not NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for type ind 2]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for type ind 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_ind_workshop_values';

	EXEC tSQLt.ExpectnoException

	INSERT INTO WORKSHOP ([TYPE], CONTACTPERSOON_NAAM, CONTACTPERSOON_EMAIL, CONTACTPERSOON_TELEFOONNUMMER)
	VALUES('INC', 'naam2', 'email@hotmail.com', '0612345678');
END
GO

-- Test for TYPE is 'IND' and CONTACTPERSOON_EMAIL is NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for type ind 3]
GO

CREATE OR ALTER PROCEDURE [testWorkshop].[test for type ind 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_ind_workshop_values';

	EXEC tSQLt.ExpectException

	INSERT INTO WORKSHOP ([TYPE], CONTACTPERSOON_NAAM, CONTACTPERSOON_EMAIL, CONTACTPERSOON_TELEFOONNUMMER)
	VALUES('IND', 'naam3', NULL, '0612345678');
END
GO