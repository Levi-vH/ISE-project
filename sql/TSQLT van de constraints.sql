USE [UnitTesting SBB]

-- all tests are sorted per table. You can find the table name and the function of the constraint
-- that is being testen for every constraints


EXEC tSQLt.NewTestClass 'testWorkshop';
EXEC tSQLt.NewTestClass 'testDeelnemer';

-- the select statement can be used to drop all tables in the tSQLt database
/*
SELECT  'DROP TABLE ' + TABLE_SCHEMA + '.' + TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_SCHEMA LIKE ('dbo%')

DROP TABLE dbo.ADVISEUR
DROP TABLE dbo.BESCHIKBAARHEID
DROP TABLE dbo.CONTACTPERSOON
DROP TABLE dbo.DEELNEMER
DROP TABLE dbo.DEELNEMER_IN_WORKSHOP
DROP TABLE dbo.PLANNER
DROP TABLE dbo.MODULE
DROP TABLE dbo.ORGANISATIE
DROP TABLE dbo.SECTOR
DROP TABLE dbo.WORKSHOP
DROP TABLE dbo.WORKSHOPLEIDER
DROP TABLE dbo.AANVRAAG
DROP TABLE dbo.GROEP
DROP TABLE dbo.AANVRAAG_VAN_GROEP
DROP TABLE dbo.MODULE_VAN_GROEP

*/

--==============================================================
-- all tests for the workshop table constraints
--==============================================================

--==============================================================
-- tests for the check on the automatic update on status
--==============================================================
--test with type = 'afgehandeld'

DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 1]
GO
CREATE PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 1]
AS
BEGIN
	IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]


	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
END;
GO

--test with workhop_id = 1 and workshopleider_ID = '1'
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 2]
GO

CREATE PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 2]
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

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger2', @Actual='dbo.WORKSHOP'
END;
GO

--test with workhop_id = 1, workshopleider_ID = '1' and type = 'afgehandeld'
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 3]
GO

CREATE PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 3]
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

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);  

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger3', @Actual='dbo.WORKSHOP'
END;
GO

--test with workhop_id = 1
DROP PROCEDURE IF EXISTS [testWorkshop].[test for the automatic change to the bevestigd state 4]
GO

CREATE PROCEDURE [testWorkshop].[test for the automatic change to the bevestigd state 4]
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

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_workshop_state_bevestigd'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger4', @Actual='dbo.WORKSHOP'
END;
GO

--==============================================================
-- tests for the check on workshop types
--==============================================================

-- test for type = INC 
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types INC]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types INC]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectNoException
	
	INSERT INTO WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for type = COM
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types COM]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types COM]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectNoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for type = COB
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types COB]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types COB]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COB', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--==============================================================
-- tests for the check on advisors in INC workshops
--==============================================================

-- test for advisor = 1 and type = COM
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 1]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 1]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 2]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 2]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = NULL and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 3]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 3]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 4]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 4]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--==============================================================
-- tests for the check on workshop date
--==============================================================
-- test for workshopdate = 20 seconds after getdate
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopdate 1]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopdate 1]
AS
BEGIN
		
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopDate';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(m, 2, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for workshopdate = 20 seconds before getdate
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopdate 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopdate 2]
AS
BEGIN
	
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopDate';

	EXEC tSQLt.ExpectException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--========================================================================================
-- tests if the workshopstatus is 'uitgezet', 'bevestigd', 'geannuleerd' or 'afgehandeld'
--========================================================================================

-- test for status is uitgezet
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopstatus 1]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopstatus 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopState';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uitgezet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for status is aaaaa
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopstatus 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopstatus 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopState';

	EXEC tSQLt.ExpectException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'aaaaa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--========================================================================================
-- tests if the workshop endtime is after the starting time
--========================================================================================

-- test for starttime is getdate and endtime is getdate + 30 sec 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopEndtime 1]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopEndtime 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopState';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, 30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for starttime is getdate and endtime is getdate - 30 sec 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopEndtime 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopEndtime 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopState';

	EXEC tSQLt.ExpectnoException
	
	INSERT into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, -30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--=====================================================================================================================
-- Tests if a workshop that received VERWERKT_BREIN, DEELNEMER_GEGEGEVENS_ONTVANGEN, OVK_BEVESTIGING, PRESENTIELIJST_VERSTUURD,
-- PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL has status 'afgehandeld'
--=====================================================================================================================
-- test for status is bevestigd with all columns NOT NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 1]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopConcluded 1]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'bevestigd', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06'); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_WorkshopConcluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06'); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
	END
GO

-- test for status is bevestigd with one column on NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopConcluded 2]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_WorkshopConcluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', NULL); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'
END
GO

-- test for status is afgehandeld with all columns NOT NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopConcluded 3]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopConcluded 3]
AS
BEGIN
IF OBJECT_ID('[testWorkshopStateTrigger]','Table') IS NOT NULL
	DROP TABLE [testWorkshopStateTrigger]

	SELECT * 
	INTO testWorkshopStateTrigger
	FROM dbo.WORKSHOP
	WHERE 1=0

	INSERT INTO testWorkshopStateTrigger([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06'); 

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 

	EXEC [tSQLt].[ApplyTrigger] @tablename = 'dbo.WORKSHOP', @triggername = 'TRG_WorkshopConcluded'
	
	INSERT INTO WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
 [MODULENUMMER], [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD],[ADRES],
  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN],
    [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'afgehandeld', NULL, NULL, '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06', '2018-12-06'); 

	EXEC [tSQLt].[AssertEqualsTable] @Expected='testWorkshopStateTrigger', @Actual='dbo.WORKSHOP'END
GO

--=====================================================================================================================
-- Tests when workshop_type isn't IND, then SECTOR has te be NOT NULL
--=====================================================================================================================

-- test for type is IND and sector is NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 1]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopTypeAndSector 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypeAndSector';

	EXEC tSQLt.ExpectnoException

	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER], [MODULENUMMER],
	 [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES], [POSTCODE], [PLAATSNAAM],
	  [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN], [OVK_BEVESTIGING],
	   [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IND', NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is INC and sector is NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopTypeAndSector 2]
AS
BEGIN
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypeAndSector';

	EXEC tSQLt.ExpectException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER], [MODULENUMMER],
	 [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES], [POSTCODE], [PLAATSNAAM],
	  [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN], [OVK_BEVESTIGING],
	   [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is INC and sector is NOT NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 3]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopTypeAndSector 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypeAndSector';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER], [MODULENUMMER],
	 [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES], [POSTCODE], [PLAATSNAAM],
	  [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN], [OVK_BEVESTIGING],
	   [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'SECTOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL)
END
GO

-- test for type is IND and sector is NOT NULL 
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopTypeAndSector 4]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopTypeAndSector 4]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypeAndSector';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER], [MODULENUMMER],
	 [ADVISEUR_ID], [SECTORNAAM], [DATUM], [STARTTIJD], [EINDTIJD], [ADRES], [POSTCODE], [PLAATSNAAM],
	  [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEVENS_ONTVANGEN], [OVK_BEVESTIGING],
	   [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'SECTOR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IND', NULL, NULL, NULL, NULL, NULL, NULL)
END
GO
--========================================================================================
-- tests for the deelnemer table
--========================================================================================

--========================================================================================
-- test if the e-mail contains a '@' and a '.'
--========================================================================================

-- test for emails without a '@'
DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer emails 1]
GO

CREATE PROCEDURE [testDeelnemer].[test for deelnemer emails 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_DeelnemerEmail';

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

CREATE PROCEDURE [testDeelnemer].[test for deelnemer emails 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_DeelnemerEmail';

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

CREATE PROCEDURE [testDeelnemer].[test for deelnemer emails 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_DeelnemerEmail';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, 'henk@pieter.nl', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--======================================================================
-- Test if the date of birth can't be higher than the current date
--======================================================================

-- Test for date of birth is current date +20 sec

DROP PROCEDURE IF EXISTS [testDeelnemer].[test for deelnemer birthdates 1]
GO

CREATE PROCEDURE [testDeelnemer].[test for deelnemer birthdates 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_DeelnemerBirthdate';

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

CREATE PROCEDURE [testDeelnemer].[test for deelnemer birthdates 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_DeelnemerBirthdate';

	EXEC tSQLt.ExpectnoException
	
	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

--======================================================================
-- Test for when IS_OPEN_INSCHRIJVING is 1 then GEWENST_BEGELEIDINGSNIVEAU, FUNCTIENAAM 
-- and SECTORNAAM have to be NOT NULL
--======================================================================

-- Test for IS_OPEN_INSCHRIJVING is 1 AND the rest is NOT NULL 

DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 1]
GO

CREATE PROCEDURE [testDeelnemer].[test for open inschrvijving 1]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_OpenInschrijvingValues';

	EXEC tSQLt.ExpectnoException

	INSERT INTO DEELNEMER ( [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'niveau', 'functienaam', 'sector'); 
END
GO

-- Test for IS_OPEN_INSCHRIJVING is 0 AND the rest is NOT NULL 

DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 2]
GO

CREATE PROCEDURE [testDeelnemer].[test for open inschrvijving 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_OpenInschrijvingValues';

	EXEC tSQLt.ExpectnoException

	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'niveau', 'functienaam', 'sector'); 
END
GO

-- Test for IS_OPEN_INSCHRIJVING is 1 AND FUNCTIENAAM is NULL 

DROP PROCEDURE IF EXISTS [testDeelnemer].[test for open inschrvijving 3]
GO

CREATE PROCEDURE [testDeelnemer].[test for open inschrvijving 3]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.DEELNEMER';  
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.DEELNEMER', @ConstraintName = 'CK_OpenInschrijvingValues';

	EXEC tSQLt.ExpectException

	INSERT INTO DEELNEMER ([ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
							[GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [IS_OPEN_INSCHRIJVING],
							[GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM], [SECTORNAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'niveau', NULL, 'sector'); 
END
GO

--EXEC [tSQLt].[Run] '[testWorkshop]'

--EXEC [tSQLt].[Run] '[testDeelnemer]'