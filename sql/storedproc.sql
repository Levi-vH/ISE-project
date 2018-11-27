USE SBBWorkshopOmgeving
GO


CREATE OR ALTER PROC proc_create_workshop
  (
    @organisatienummer VARCHAR(15),
    @workshoptype VARCHAR(3),
    @workshopdate DATETIME,
    @modulenummer INT,
    @workshopstarttime DATETIME,
    @workshopendtime DATETIME,
    @workshopaddress DATETIME,
    @workshoppostcode VARCHAR(12),
    @workshopcity VARCHAR(255),
    @workshopleader VARCHAR(100),
    @workshopNote VARCHAR(255),
    @workshopsector VARCHAR(255)
  )
AS
  BEGIN

	  /*

		Create a workshop based on the given parameters

      */

    DECLARE @status VARCHAR(40)
    SET @status = 'uitgezet'

    IF(@workshopleader IS NOT NULL)
      BEGIN
        SET @status = 'bevestigd'
      END

    -- If a workshop is NOT from IND, the workshopsector MUST be filled in

    IF( @workshoptype != 'IND' AND @workshopsector IS NULL )
      BEGIN
        RAISERROR('Een workshop met type IND MOET een workshopsector hebben',16,1)
      END

    INSERT INTO WORKSHOP
    VALUES(@workshopleader,
      (SELECT CONTACTPERSOON_ID FROM CONTACTPERSOON WHERE ORGANISATIENUMMER = @organisatienummer)
      ,@organisatienummer,@modulenummer
      ,(SELECT ADVISEUR_ID FROM ADVISEUR WHERE ORGANISATIENUMMER = @organisatienummer),
      @workshopsector, @workshopdate,@workshopstarttime,
      @workshopendtime, @workshopaddress,@workshoppostcode,
      @workshopcity,@status,
      @workshopNote, @workshoptype ,null,null,null,null,null,null)

  END
GO