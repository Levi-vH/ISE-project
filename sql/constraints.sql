USE [SBBWorkshopOmgeving]
GO


--=========================================================================
-- check if workshopstate = 'bevestigd' when WORKSHOPLEIDER_ID is not null
-- ik denk dat het fout gaat omdat de update in de trigger dezelfde trigger nog een keer aanroept 
-- en dan heeft status wel een waarde waardoor de raiserror 2 altijd voorkomt
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

	--IF EXISTS	(SELECT STATUS FROM inserted)
	--RETURN

	SELECT *
	FROM INSERTED

	SELECT *
	FROM DELETED

	IF EXISTS  (SELECT WORKSHOPLEIDER_ID
				FROM DELETED)
	RAISERROR ('WORKSHOP status was not changed to bevestigd automatically1', 16,1)

	IF NOT EXISTS  (SELECT WORKSHOPLEIDER_ID
					FROM DELETED)
	BEGIN
	
	IF EXISTS (SELECT STATUS FROM INSERTED)
	RAISERROR ('WORKSHOP status was not changed to bevestigd automatically2', 16,1)

	IF EXISTS  (SELECT STATUS FROM DELETED)
	RAISERROR ('WORKSHOP status was not changed to bevestigd automatically3', 16,1)
	END

	IF UPDATE(WORKSHOPLEIDER_ID)
	BEGIN 
		IF NOT EXISTS  (SELECT WORKSHOPLEIDER_ID
						FROM DELETED)
		BEGIN TRY
			UPDATE WORKSHOP
			SET STATUS = 'bevestigd'
			FROM WORKSHOP W INNER JOIN inserted i
			ON W.WORKSHOP_ID = i.WORKSHOP_ID AND i.WORKSHOPLEIDER_ID IS NOT NULL

			SELECT *
			FROM WORKSHOP
		END TRY

		BEGIN CATCH
		THROW;
		END CATCH

	END
	ELSE RAISERROR ('WORKSHOP status was not changed to bevestigd automatically4', 16,1)
END
GO


--==============================================
-- check if workshop type = INC, IND etc.
--==============================================
ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopTypes
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopTypes	CHECK(TYPE IN ('INC', 'IND', 'COM', 'ROC', 'LA'))

--===============================================
-- check if adviseur is not null when type = INC
--===============================================

ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopAdvisor
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopAdvisor CHECK(ADVISEUR_ID IS NOT NULL OR TYPE != 'INC')

--========================================================================
-- check if the workshopdate is later than the date the workshop is added
--========================================================================

ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopDate
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopDate CHECK(DATUM > GETDATE())

--========================================================================================
-- check if the workshopstatus is 'uitgezet', 'bevestigd', 'geannuleerd' or 'afgehandeld'
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
-- check if the e-mail contains a '@' and a '.'
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

