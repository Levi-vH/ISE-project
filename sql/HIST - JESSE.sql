use SBBWorkshopOmgeving
go

DROP PROCEDURE IF EXISTS SP_Create_HIST_Trigger
GO

CREATE PROC SP_Create_HIST_Trigger
	@Table_Name		SYSNAME
AS
BEGIN 
	DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3))
	DECLARE @startTrancount INT = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint 

		----------------------------------------
	    DECLARE @columns NVARCHAR(MAX) = ''
		SELECT @columns =  @columns + column_name + ', '
		FROM INFORMATION_SCHEMA.columns
		WHERE TABLE_NAME = @Table_Name

		DECLARE @Trigger_string  VARCHAR(MAX)  = 
		
		        'CREATE TRIGGER Trg_HIST_' + @Table_Name + 
		        '
				ON ' + @Table_Name + 
				' AFTER UPDATE, DELETE
				AS 
				BEGIN
					DECLARE @ROWSAFFECTED INT
					SELECT @ROWSAFFECTED = @@ROWCOUNT
					IF @ROWSAFFECTED = 0 RETURN
					SET NOCOUNT ON
					BEGIN TRY
						IF EXISTS(SELECT * FROM deleted)
							BEGIN
								INSERT INTO HIST_' +  @Table_Name + '( ' + @columns  +  'timestamp) 
								SELECT ' + @columns +  'GETDATE()
								FROM deleted
							END 
					END TRY
				    BEGIN CATCH
				        THROW 
				    END CATCH
				END
				GO'

			PRINT @Trigger_string 

		----------------------------------------

		COMMIT TRANSACTION
	END TRY	  
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0
			ROLLBACK TRANSACTION
		ELSE IF XACT_STATE() = 1 
			BEGIN
				ROLLBACK TRANSACTION @savepoint
				COMMIT TRANSACTION 
			END
			DECLARE @errormessage VARCHAR(2000) 
			SET @errormessage =	'Een fout is opgetreden in procedure ''' + object_name(@@procid) + '''.Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1) 
	END CATCH
END
GO

DROP PROCEDURE IF EXISTS SP_Create_All_HIST_Trigger
GO

CREATE PROC SP_Create_All_HIST_Trigger
AS
BEGIN 
	DECLARE @savepoint VARCHAR(128) = CAST(OBJECT_NAME(@@PROCID) AS VARCHAR(125)) + CAST(@@NESTLEVEL AS VARCHAR(3))
	DECLARE @startTrancount INT = @@TRANCOUNT;
	BEGIN TRY
		BEGIN TRANSACTION
		SAVE TRANSACTION @savepoint 

		----------------------------------------
     
		SELECT 'Exec SP_Create_HIST_Trigger ''' + TABLE_NAME + '''' 
		FROM INFORMATION_SCHEMA.TABLES 
		WHERE TABLE_SCHEMA = 'dbo' and
			  TABLE_NAME not like 'HIST_%'
								
		----------------------------------------

		COMMIT TRANSACTION
	END TRY	  
	BEGIN CATCH
		IF XACT_STATE() = -1 and @startTrancount = 0
			ROLLBACK TRANSACTION
		ELSE IF XACT_STATE() = 1 
			BEGIN
				ROLLBACK TRANSACTION @savepoint
				COMMIT TRANSACTION 
			END
			DECLARE @errormessage VARCHAR(2000) 
			SET @errormessage =	'Een fout is opgetreden in procedure ''' + OBJECT_NAME(@@PROCID) + '''.Originele boodschap: ''' + ERROR_MESSAGE() + ''''
			RAISERROR(@errormessage, 16, 1) 
	END CATCH
END
GO

/*===============================
	AANMAKEN TRIGGERS
===============================*/
-- Alle SP_Create_HIST_Triggers maken
Exec SP_Create_All_HIST_Trigger
GO