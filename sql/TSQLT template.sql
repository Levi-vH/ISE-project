
-- TEMPLATE VOOR TSQLT

USE [UnitTesting SBB]

EXEC tSQLt.NewTestClass 'testWorkshop'; -- aanmaken van een class waarin tests komen handig lijkt 
										-- me een class per tabel dus nu is er een testworkshop class

GO
ALTER PROCEDURE [testWorkshop].[test op workshop types]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo. TABELNAAM waar je iets gaat inserten

	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes'; -- 

	EXEC tSQLt.ExpectNoException -- deze gebruiken als je geen error verwacht uit je insert

	EXEC tSQLt.ExpectException -- deze gebruiken als je wel een error verwacht uit je insert

	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

EXEC [tSQLt].[Run] '[testWorkshop].[test op workshop types]' -- het uitvoeren van de test

EXEC [tSQLt].[Run] '[testWorkshop]' -- het uivoeren van alle test in de class die eerder is aangemaakt
