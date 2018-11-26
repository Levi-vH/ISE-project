USE [UnitTesting SBB]

EXEC tSQLt.NewTestClass 'testWorkshop';

DROP PROCEDURE IF EXISTS [testWorkshop].[test op workshop types INC]
GO

CREATE PROCEDURE [testWorkshop].[test op workshop types INC]
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

DROP PROCEDURE IF EXISTS [testWorkshop].[test op workshop types COM]
GO

CREATE PROCEDURE [testWorkshop].[test op workshop types COM]
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

DROP PROCEDURE IF EXISTS [testWorkshop].[test op workshop types COB]
GO

CREATE PROCEDURE [testWorkshop].[test op workshop types COB]
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

EXEC [tSQLt].[Run] '[testWorkshop]'