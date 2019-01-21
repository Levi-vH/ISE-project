CREATE OR ALTER PROC SP_alter_workshop
(
@workshop_id					INT,
@workshopdate					NVARCHAR(10),
@workshopContact				INT,
@workshopsector					NVARCHAR(20),
@workshopstarttime				NVARCHAR(10),
@workshopendtime				NVARCHAR(10),
@workshopaddress				NVARCHAR(60),
@workshoppostcode				NVARCHAR(7),
@workshopcity					NVARCHAR(60),
@workshopleader					INT,
@workshopnote					NVARCHAR(255),
@BREIN_date						DATE,
@received_participantsinfo		DATE,
@OVK_received					DATE,
@attendance_list_send			DATE,
@attendance_list_received		DATE,
@evidence_participation_mail	DATE,
@contactperson_name				NVARCHAR(80),
@contactperson_email			NVARCHAR(100),
@contactperson_phonenumber		NVARCHAR(12)
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @confirmed BIT = 0

	IF(@workshopleader = 0)
	BEGIN
		SET @workshopleader = NULL
	END

	DECLARE @BREIN_date_existing DATE = (SELECT VERWERKT_BREIN FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
	DECLARE @received_participantsinfo_existing DATE = (SELECT DEELNEMER_GEGEVENS_ONTVANGEN FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
	DECLARE @OVK_received_existing DATE = (SELECT OVK_BEVESTIGING FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
	DECLARE @attendance_list_send_existing DATE = (SELECT PRESENTIELIJST_VERSTUURD FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
	DECLARE @attendance_list_received_existing DATE = (SELECT BEWIJS_DEELNAME_MAIL_SBB_WSL FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)
	DECLARE @evidence_participation_mail_existing DATE = (SELECT PRESENTIELIJST_ONTVANGEN FROM WORKSHOP WHERE WORKSHOP_ID = @workshop_id)

	IF @BREIN_date IS NOT NULL OR @BREIN_date_existing IS NOT NULL AND 
	@received_participantsinfo IS NOT NULL OR @received_participantsinfo_existing IS NOT NULL AND 
	@OVK_received IS NOT NULL OR @OVK_received_existing IS NOT NULL AND
	@attendance_list_send IS NOT NULL OR @attendance_list_send_existing IS NOT NULL AND 
	@attendance_list_received IS NOT NULL OR @attendance_list_received_existing IS NOT NULL AND 
	@evidence_participation_mail IS NOT NULL OR @evidence_participation_mail_existing IS NOT NULL
		BEGIN
			SET @confirmed = 1
		END

	IF @confirmed = 1
		BEGIN
		DECLARE @sql_confirmed NVARCHAR(4000)
		SET @sql_confirmed = N'
			UPDATE WORKSHOP
			SET STATUS = ''afgehandeld''
			WHERE WORKSHOP_ID = @workshop_id'

		EXEC sp_executesql @sql_confirmed,	
		N' @workshoptype NVARCHAR(3)', @workshop_id
		END
					
	DECLARE @sql NVARCHAR(4000)
	SET @sql =  N'
				UPDATE	WORKSHOP
				SET		DATUM = @workshopdate,
						CONTACTPERSOON_ID = @workshopContact,
						SECTORNAAM = @workshopsector,
						STARTTIJD = @workshopstarttime,
						EINDTIJD = @workshopendtime,
						ADRES = @workshopaddress,
						POSTCODE = @workshoppostcode,
						PLAATSNAAM = @workshopcity,
						WORKSHOPLEIDER_ID = @workshopleader,
						OPMERKING = @workshopnote,
						VERWERKT_BREIN = @BREIN_date,
						DEELNEMER_GEGEVENS_ONTVANGEN = @received_participantsinfo,
						OVK_BEVESTIGING = @OVK_received,
						PRESENTIELIJST_VERSTUURD = @attendance_list_send,
						PRESENTIELIJST_ONTVANGEN = @attendance_list_send,
						BEWIJS_DEELNAME_MAIL_SBB_WSL = @evidence_participation_mail,
						CONTACTPERSOON_NAAM = @contactperson_name,
						CONTACTPERSOON_EMAIL = @contactperson_email,
						CONTACTPERSOON_TELEFOONNUMMER = @contactperson_phonenumber
				WHERE	WORKSHOP_ID = @workshop_id
				'
	EXEC sp_executesql @sql,	N'
								@workshopdate NVARCHAR(10),
								@workshopContact INT,
								@workshopsector NVARCHAR(20),
								@workshopstarttime NVARCHAR(10),
								@workshopendtime NVARCHAR(10),
								@workshopaddress NVARCHAR(60),
								@workshoppostcode NVARCHAR(7),
								@workshopcity NVARCHAR(60),
								@workshopleader INT,
								@workshopnote NVARCHAR(255),
								@BREIN_date	DATE,
								@received_participantsinfo DATE,
								@OVK_received DATE,
								@attendance_list_send DATE,
								@attendance_list_received DATE,
								@evidence_participation_mail DATE,
								@contactperson_name	NVARCHAR(80),	
								@contactperson_email NVARCHAR(100),
								@contactperson_phonenumber NVARCHAR(12),
								@workshop_id INT
								',
								@workshopdate,
								@workshopContact,
								@workshopsector,
								@workshopstarttime,
								@workshopendtime,
								@workshopaddress,
								@workshoppostcode,
								@workshopcity,
								@workshopleader,
								@workshopnote,
								@BREIN_date,	
								@received_participantsinfo,
								@OVK_received,
								@attendance_list_send,		
								@attendance_list_received,	
								@evidence_participation_mail,
								@contactperson_name,
								@contactperson_email,		
								@contactperson_phonenumber,	
								@workshop_id
END
GO

select *
from workshop


EXEC SP_alter_workshop

@workshop_id					= 5,
@workshopdate					= '2021-08-30',
@workshopContact				= 476,
@workshopsector					= ICTCI,
@workshopstarttime				= '11:58',
@workshopendtime				= '16:35',
@workshopaddress				= 'Logan Court 54',
@workshoppostcode				= '7681SA',
@workshopcity					= 'Chula Vista',
@workshopleader					= null,
@workshopnote					= null,
@BREIN_date						= null,
@received_participantsinfo		= null,
@OVK_received					= null,
@attendance_list_send			= null,
@attendance_list_received		= null,
@evidence_participation_mail	= null,
@contactperson_name				= null,
@contactperson_email			= 'dthomas@hotmail.com',
@contactperson_phonenumber		= null

SELECT *
FROM WORKSHOP
WHERE WORKSHOP_ID = 5
