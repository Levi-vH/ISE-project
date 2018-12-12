-- Constraints with a ** have no tests 

USE [SBBWorkshopOmgeving]
GO

--=========================================================================
-- WORKSHOP constraints
--=========================================================================

--=========================================================================
-- Check if workshopstate = 'bevestigd' when WORKSHOPLEIDER_ID is not null
--=========================================================================
DROP TRIGGER IF EXISTS dbo.TRG_workshop_state_bevestigd
GO

CREATE TRIGGER TRG_workshop_state_bevestigd
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
-- A workshop that received VERWERKT_BREIN, DEELNEMER_GEGEGEVENS_ONTVANGEN, OVK_BEVESTIGING, PRESENTIELIJST_VERSTUURD,
-- PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL has to have status 'afgehandeld'
--=====================================================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopConcluded
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopConcluded CHECK((VERWERKT_BREIN IS NULL AND DEELNEMER_GEGEVENS_ONTVANGEN IS NULL AND OVK_BEVESTIGING IS NULL AND
PRESENTIELIJST_VERSTUURD IS NULL AND BEWIJS_DEELNAME_MAIL_SBB_WSL IS NULL AND PRESENTIELIJST_ONTVANGEN IS NULL) OR STATUS = 'afgehandeld')

DROP TRIGGER IF EXISTS dbo.TRG_WorkshopConcluded
GO

CREATE TRIGGER TRG_WorkshopConcluded
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

--==============================================
-- Check if workshop type = INC, IND etc.
--==============================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopTypes
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopTypes	CHECK(TYPE IN ('INC', 'IND', 'COM', 'ROC', 'LA'))

--===============================================
-- Check if adviseur is not null when type = INC
--===============================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopAdvisor
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopAdvisor CHECK(ADVISEUR_ID IS NOT NULL OR TYPE != 'INC')

--========================================================================
-- Check if the workshopdate is later than the date the workshop is added
--========================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopDate
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopDate CHECK(DATUM > GETDATE())

--========================================================================================
-- Check if the workshopstatus is 'uitgezet', 'bevestigd', 'geannuleerd' or 'afgehandeld'
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopState
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopState CHECK (STATUS IN ('uitgezet', 'bevestigd', 'geannuleerd', 'afgehandeld'))

--========================================================================================
-- The ending time of a workshop has to be after the starting time
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopEndtime
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopEndtime CHECK (STARTTIJD < EINDTIJD)

--========================================================================================
-- If workshop_type isn't IND, then SECTOR has to be NOT NULL
--========================================================================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopTypeAndSector
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopTypeAndSector CHECK(SECTORNAAM IS NOT NULL OR TYPE = 'IND')

--=========================================================================
-- DEELNEMER constraints
--=========================================================================

--========================================================================================
-- Check if the e-mail contains a '@' and a '.'
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_DeelnemerEmail
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_DeelnemerEmail CHECK (EMAIL LIKE '%@%.%')

--========================================================================================
-- The date of birth can't be higher than the current date
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_DeelnemerBirthdate
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_DeelnemerBirthdate CHECK (GEBOORTEDATUM < GETDATE())

--========================================================================================
-- If IS_OPEN_INSCHRIJVING is 1 then GEWENST_BEGELEIDINGSNIVEAU, FUNCTIENAAM 
-- and SECTORNAAM have to be NOT NULL
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_OpenInschrijvingValues
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_OpenInschrijvingValues CHECK (IS_OPEN_INSCHRIJVING != 1 OR (GEWENST_BEGELEIDINGSNIVEAU IS NOT NULL
AND FUNCTIENAAM IS NOT NULL AND SECTORNAAM IS NOT NULL))

--========================================================================================
-- AANHEF has to be 'mevrouw' or 'meneer' **
--========================================================================================
ALTER TABLE DEELNEMER
DROP CONSTRAINT IF EXISTS CK_OpenInschrijvingValues
GO

ALTER TABLE DEELNEMER
ADD CONSTRAINT CK_OpenInschrijvingValues CHECK (AANHEF = 'mevrouw' OR AANHEF = 'meneer')

--=========================================================================
-- BESCHIKBAARHEID constraints
--=========================================================================

--========================================================================================
-- KWARTAAL has to be 1, 2, 3 or 4 **
--========================================================================================
ALTER TABLE BESCHIKBAARHEID
DROP CONSTRAINT IF EXISTS CK_Kwartaal

ALTER TABLE BESCHIKBAARHEID
ADD CONSTRAINT CK_Kwartaal CHECK (KWARTAAL IN (1, 2, 3, 4))

--========================================================================================
-- JAAR has to be between 1900 and 2200 **
--========================================================================================
ALTER TABLE BESCHIKBAARHEID
DROP CONSTRAINT IF EXISTS CK_Jaar

ALTER TABLE BESCHIKBAARHEID
ADD CONSTRAINT CK_Jaar CHECK (JAAR BETWEEN 1900 AND 2200)

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