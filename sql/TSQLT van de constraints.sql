USE [UnitTesting SBB]

--==============================================================
-- all tests for the workshop table constraints
--==============================================================

EXEC tSQLt.NewTestClass 'testWorkshop';
EXEC tSQLt.NewTestClass 'testDeelnemer';


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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COB', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, 20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'uitgezet', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for status is uitgezet
DROP PROCEDURE IF EXISTS [testWorkshop].[test for workshopstatus 2]
GO

CREATE PROCEDURE [testWorkshop].[test for workshopstatus 2]
AS
BEGIN

	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; 
	
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopState';

	EXEC tSQLt.ExpectnoException
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, 30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, GETDATE(), DATEADD(s, -30, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	INSERT INTO DEELNEMER ([DEELNEMER_ID], [SECTORNAAM], [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
						   [GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [ORGANISATIE_VESTIGINGSPLAATS],
						   [IS_OPEN_INSCHRIJVING], [GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'henkpieter.nl', NULL, NULL, NULL, NULL, NULL, NULL);  
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
	
	INSERT INTO DEELNEMER ([DEELNEMER_ID], [SECTORNAAM], [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
						   [GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [ORGANISATIE_VESTIGINGSPLAATS],
						   [IS_OPEN_INSCHRIJVING], [GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'henk@pieternl', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	INSERT INTO DEELNEMER ([DEELNEMER_ID], [SECTORNAAM], [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
						   [GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [ORGANISATIE_VESTIGINGSPLAATS],
						   [IS_OPEN_INSCHRIJVING], [GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'henk@pieter.nl', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	INSERT INTO DEELNEMER ([DEELNEMER_ID], [SECTORNAAM], [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
						   [GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [ORGANISATIE_VESTIGINGSPLAATS],
						   [IS_OPEN_INSCHRIJVING], [GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, 20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
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
	
	INSERT INTO DEELNEMER ([DEELNEMER_ID], [SECTORNAAM], [ORGANISATIENUMMER], [AANHEF], [VOORNAAM], [ACHTERNAAM],
						   [GEBOORTEDATUM], [EMAIL], [TELEFOONNUMMER], [OPLEIDINGSNIVEAU], [ORGANISATIE_VESTIGINGSPLAATS],
						   [IS_OPEN_INSCHRIJVING], [GEWENST_BEGELEIDINGSNIVEAU], [FUNCTIENAAM])
	VALUES(NULL, NULL, NULL, NULL, NULL, NULL, DATEADD(s, -20, GETDATE()), NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

EXEC [tSQLt].[Run] '[testWorkshop]'

EXEC [tSQLt].[Run] '[testDeelnemer]'