/* =================================================================
   Author: Bart
   Create date: 26-11-2018
   Description: this script is used to create the constraints
   for the 'SBBWorkshopOmgeving' database
   --------------------------------
   Modified by:
   Modifications made by :
   ================================================================ */

-- Constraints with a ** have no tests 

USE [SBBWorkshopOmgeving]
GO

--=========================================================================
-- WORKSHOP constraints
--=========================================================================

--=========================================================================
-- IR1 / C1 / BR1
-- Check if workshopstate = 'bevestigd' when WORKSHOPLEIDER_ID is not null
--=========================================================================
DROP TRIGGER IF EXISTS dbo.TR_workshop_state_bevestigd
GO

CREATE TRIGGER TR_workshop_state_bevestigd
ON WORKSHOP
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @RECORDSAFFECTED INT = @@ROWCOUNT
	IF @RECORDSAFFECTED = 0
		RETURN

	SET NOCOUNT ON

	BEGIN TRY
		IF UPDATE(WORKSHOPLEIDER_ID)
			BEGIN
				UPDATE WORKSHOP
				SET STATUS = 'bevestigd'
				FROM WORKSHOP W INNER JOIN inserted i
				ON W.WORKSHOP_ID = i.WORKSHOP_ID 
				LEFT JOIN deleted d 
				ON W.WORKSHOP_ID = d.WORKSHOP_ID 
				WHERE i.WORKSHOPLEIDER_ID IS NOT NULL
				AND d.WORKSHOPLEIDER_ID IS NULL
				AND i.STATUS IS NULL 
			END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO

--=====================================================================================================================
-- IR2 / C2 / BR2
-- A workshop that received VERWERKT_BREIN, DEELNEMER_GEGEGEVENS_ONTVANGEN, OVK_BEVESTIGING, PRESENTIELIJST_VERSTUURD,
-- PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL has to have status 'afgehandeld'
--=====================================================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_concluded
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_concluded CHECK((VERWERKT_BREIN IS NULL AND DEELNEMER_GEGEVENS_ONTVANGEN IS NULL AND OVK_BEVESTIGING IS NULL AND
PRESENTIELIJST_VERSTUURD IS NULL AND BEWIJS_DEELNAME_MAIL_SBB_WSL IS NULL AND PRESENTIELIJST_ONTVANGEN IS NULL) OR STATUS = 'afgehandeld')
GO

DROP TRIGGER IF EXISTS dbo.TR_workshop_concluded
GO

CREATE TRIGGER TR_workshop_concluded
ON WORKSHOP
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @RECORDSAFFECTED INT = @@ROWCOUNT
	IF @RECORDSAFFECTED = 0
		RETURN

	SET NOCOUNT ON

	BEGIN TRY
		IF (UPDATE(VERWERKT_BREIN) OR UPDATE(DEELNEMER_GEGEVENS_ONTVANGEN) OR UPDATE(OVK_BEVESTIGING)
			OR UPDATE(PRESENTIELIJST_VERSTUURD) OR UPDATE(BEWIJS_DEELNAME_MAIL_SBB_WSL) OR UPDATE(PRESENTIELIJST_ONTVANGEN))
			BEGIN
				UPDATE WORKSHOP
				SET STATUS = 'bevestigd'
				FROM WORKSHOP W INNER JOIN inserted i
				ON W.WORKSHOP_ID = i.WORKSHOP_ID 
				LEFT JOIN deleted d 
				ON W.WORKSHOP_ID = d.WORKSHOP_ID 
				WHERE (W.VERWERKT_BREIN IS NOT NULL OR i.VERWERKT_BREIN IS NOT NULL)
				AND (W.DEELNEMER_GEGEVENS_ONTVANGEN IS NOT NULL OR i.DEELNEMER_GEGEVENS_ONTVANGEN iS NOT NULL)
				AND (W.OVK_BEVESTIGING IS NOT NULL OR i.OVK_BEVESTIGING iS NOT NULL)
				AND	(W.PRESENTIELIJST_VERSTUURD IS NOT NULL OR i.PRESENTIELIJST_VERSTUURD iS NOT NULL)
				AND (W.BEWIJS_DEELNAME_MAIL_SBB_WSL IS NOT NULL OR i.BEWIJS_DEELNAME_MAIL_SBB_WSL iS NOT NULL)
				AND (W.PRESENTIELIJST_ONTVANGEN IS NOT NULL OR i.PRESENTIELIJST_ONTVANGEN iS NOT NULL)
				AND i.STATUS IS NULL
			END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO

--===============================================
-- IR3 / C3 / BR3
-- Check if adviseur is not null when type = INC
--===============================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_advisor
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_advisor CHECK(ADVISEUR_ID IS NOT NULL OR TYPE != 'INC')
GO

--========================================================================
-- BR5 / C5 / IR5
-- Check if the workshopdate is later than the date the workshop is added
--========================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_date
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_date CHECK(DATUM > GETDATE())
GO

--========================================================================================
-- IR7 / C7 / BR7
-- If workshop_type isn't IND, then SECTOR has to be NOT NULL
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_type_and_sector
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_type_and_sector CHECK(SECTORNAAM IS NOT NULL OR TYPE = 'IND')
GO

--========================================================================================
-- IR9 / C9 / BR9
-- Check if the workshopstatus is 'uitgezet', 'bevestigd', 'geannuleerd' or 'afgehandeld'
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_state
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_state CHECK (STATUS IN ('uitgezet', 'bevestigd', 'geannuleerd', 'afgehandeld'))
GO

--========================================================================================
-- IR15 / C15 / BR15
-- The ending time of a workshop has to be after the starting time
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_workshop_endtime
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_workshop_endtime CHECK (STARTTIJD < EINDTIJD)
GO

--=========================================================================
-- DEELNEMER constraints
--=========================================================================

--========================================================================================
-- IR4 / C4 / BR4
-- AANHEF has to be 'mevrouw' or 'meneer' **
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_salutation
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_salutation CHECK (AANHEF = 'mevrouw' OR AANHEF = 'meneer')
GO

--========================================================================================
-- IR13 / C13 / BR13
-- Check if the e-mail contains a '@' and a '.'
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_deelnemer_email
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_deelnemer_email CHECK (EMAIL LIKE '%@%.%')
GO

--========================================================================================
-- IR14 / C14 / BR14
-- The date of birth can't be higher than the current date
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_deelnemer_birthdate
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_deelnemer_birthdate CHECK (GEBOORTEDATUM < GETDATE())
GO

--========================================================================================
-- IR? / C? / BR?
-- If IS_OPEN_INSCHRIJVING is 1 then GEWENST_BEGELEIDINGSNIVEAU, FUNCTIENAAM 
-- and SECTORNAAM have to be NOT NULL
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_open_inschrijving_values
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_open_inschrijving_values CHECK (IS_OPEN_INSCHRIJVING != 1 OR (GEWENST_BEGELEIDINGSNIVEAU IS NOT NULL
AND FUNCTIENAAM IS NOT NULL AND SECTORNAAM IS NOT NULL))
GO

--=========================================================================
-- BESCHIKBAARHEID constraints
--=========================================================================

--========================================================================================
-- IR? / C? / BR?
-- KWARTAAL has to be 1, 2, 3 or 4 **
--========================================================================================
ALTER TABLE BESCHIKBAARHEID
DROP CONSTRAINT IF EXISTS CK_kwartaal
GO

ALTER TABLE BESCHIKBAARHEID
ADD CONSTRAINT CK_kwartaal CHECK (KWARTAAL IN (1, 2, 3, 4))
GO

--========================================================================================
-- IR? / C? / BR?
-- JAAR has to be between 1900 and 2200 **
--========================================================================================
ALTER TABLE BESCHIKBAARHEID
DROP CONSTRAINT IF EXISTS CK_jaar
GO

ALTER TABLE BESCHIKBAARHEID
ADD CONSTRAINT CK_jaar CHECK (JAAR BETWEEN 1900 AND 2200)
GO

-- Deze code wordt gebruikt om de eerste 2 triggers te testen, aangezien deze vaak kapot gaan hou ik
-- de test code nog even hier.
/*
SELECT *
INTO #tempWorkshop
FROM workshop
where 1=0

INSERT INTO #tempWorkshop (WORKSHOPLEIDER_ID) VALUES(1)

SELECT *
FROM #tempWorkshop

SELECT *
FROM #tempWorkshop1

SELECT *
FROM WORKSHOP W INNER JOIN #tempWorkshop i
ON W.WORKSHOP_ID = i.WORKSHOP_ID 
LEFT JOIN #tempWorkshop1 d 
ON W.WORKSHOP_ID = d.WORKSHOP_ID 
WHERE i.WORKSHOPLEIDER_ID IS NOT NULL
AND d.WORKSHOPLEIDER_ID IS NULL
AND i.STATUS IS NULL 

SELECT *
FROM WORKSHOP W LEFT JOIN #tempWorkshop i
ON W.WORKSHOP_ID = i.WORKSHOP_ID 
WHERE i.WORKSHOPLEIDER_ID IS NOT NULL
AND i.STATUS IS NULL 
*/