USE [UnitTesting SBB]

--==============================================================
-- all tests for the workshop table constraints
--==============================================================

EXEC tSQLt.NewTestClass 'testWorkshop';


--==============================================================
-- tests for the check on workshop types
--==============================================================

-- test for type = INC 
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types INC]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types INC]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectNoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for type = COM
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types COM]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types COM]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectNoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for type = COB
DROP PROCEDURE IF EXISTS [testWorkshop].[test on workshop types COB]
GO

CREATE PROCEDURE [testWorkshop].[test on workshop types COB]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COB', NULL, NULL, NULL, NULL, NULL, NULL); 
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
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'COM', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = NULL
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 2]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 2]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = NULL and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 3]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 3]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

-- test for advisor = 1 and type = INC
DROP PROCEDURE IF EXISTS [testWorkshop].[test for advisor in INC workshops 4]
GO

CREATE PROCEDURE [testWorkshop].[test for advisor in INC workshops 4]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopAdvisor';

	EXEC tSQLt.ExpectnoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO


EXEC [tSQLt].[Run] '[testWorkshop]'