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
	IF @@ROWCOUNT = 0
		RETURN

	SELECT *
	FROM INSERTED

	SELECT *
	FROM DELETED

	IF UPDATE(WORKSHOPLEIDER_ID)
	BEGIN 
		BEGIN TRY
			UPDATE WORKSHOP
			SET STATUS = 'bevestigd'
			FROM WORKSHOP W INNER JOIN inserted i
			ON W.WORKSHOP_ID = i.WORKSHOP_ID 
			LEFT JOIN deleted d 
			ON W.WORKSHOP_ID = d.WORKSHOP_ID 
			WHERE i.WORKSHOPLEIDER_ID IS NOT NULL
			AND d.WORKSHOPLEIDER_ID IS NULL
			AND i.STATUS IS NULL 

			SELECT *
			FROM WORKSHOP
		END TRY

		BEGIN CATCH
		THROW;
		END CATCH

	END
	ELSE RETURN
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
ADD CONSTRAINT CK_WorkshopConcluded CHECK((VERWERKT_BREIN IS NOT NULL AND DEELNEMER_GEGEVENS_ONTVANGEN IS NOT NULL AND OVK_BEVESTIGING IS NOT NULL AND
PRESENTIELIJST_VERSTUURD IS NOT NULL AND BEWIJS_DEELNAME_MAIL_SBB_WSL IS NOT NULL) OR STATUS != 'afgehandeld')
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


DELETE FROM WORKSHOP WHERE WORKSHOP_ID = 1


