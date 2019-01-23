/* =================================================================
   Author: Bart
   Create date: 29-11-2018
   Description: this script is used to automatically create 
   history tables for SBBWorkshopOmgeving
   --------------------------------
   Modified by: Lars
   Modifications made by Lars: made 'proc_generate_history_table'
   ================================================================ */

USE SBBWorkshopOmgeving
GO

/*
Select all the tables that can are not history tables and prefix the execution of the stored procedure / drop trigger or drop table

SELECT  'EXEC proc_generate_history_table ' + TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_NAME NOT LIKE ('History_%')

SELECT  'DROP TRIGGER IF EXISTS TRG_' + TABLE_NAME + '_History'
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_NAME NOT LIKE ('History_%')

SELECT  'DROP TABLE IF EXISTS dbo.HISTORY_' + TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_NAME NOT LIKE ('History_%')


*/

/*==============================================================*/
/* Create history tables based on given parameter               */
/*==============================================================*/
GO
CREATE OR ALTER PROC proc_generate_history_table
(@name VARCHAR(50)
)
AS
BEGIN
DECLARE @query VARCHAR(3000)
DECLARE @firstColumn VARCHAR(60)
DECLARE @columns VARCHAR(800)
SELECT @columns =
CASE  DATA_TYPE
	WHEN  'varchar'
	THEN COALESCE(@columns + ' ' + COLUMN_NAME + ' ' + DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(50)) + ') NULL ,', '')
	WHEN  'char'
	THEN COLUMN_NAME + ' ' + DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(50)) + ') NULL ,'
	ELSE COALESCE(@columns + ' ' + COLUMN_NAME + ' ' + DATA_TYPE + ' NULL ,', '')
END
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @name

SET @firstColumn = (SELECT
					CASE  DATA_TYPE
						WHEN  'varchar'
						THEN COLUMN_NAME + ' ' + DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(50)) + ') NULL ,'
						WHEN  'char'
						THEN COLUMN_NAME + ' ' + DATA_TYPE + '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(50)) + ') NULL ,'
						ELSE COLUMN_NAME + ' ' + DATA_TYPE + ' NULL ,'
					END
					FROM INFORMATION_SCHEMA.COLUMNS 
					WHERE TABLE_NAME = @name 
					AND ORDINAL_POSITION = '1')

SET @columns = + @firstColumn + ' ' + @columns

SET @columns = SUBSTRING(@columns, 1, (len(@columns) - 1))



SET @query = 'CREATE TABLE HISTORY_' + @name + '(
' + @columns + ')'
EXEC(@query)
END
GO

DROP PROCEDURE IF EXISTS SP_createHistoryTableTrigger
GO

CREATE PROCEDURE SP_createHistoryTableTrigger
@tablename	VARCHAR(256)
AS
BEGIN
	DECLARE @sql nvarchar(max)
	DECLARE @statement nvarchar(max)

	SET @statement = '
		CREATE TRIGGER TRG_' + @tablename + '_History
		ON dbo.' + @tablename + '
		AFTER INSERT, UPDATE, DELETE
		AS
		BEGIN
			IF @@ROWCOUNT = 0
				RETURN
			SET NOCOUNT ON

			BEGIN TRY
				--If an Insert has been made I etc....
				IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
					BEGIN
						INSERT INTO History_' + @tablename + '
						SELECT *, ''I'', CURRENT_TIMESTAMP
						FROM inserted
					END

				ELSE -- If an Delete has been made D etc..
					IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
						BEGIN
							INSERT INTO History_' + @tablename + '
							SELECT *, ''D'', CURRENT_TIMESTAMP
							FROM deleted
						END
		
					ELSE -- If an update has been made U etc...
						BEGIN
							INSERT INTO History_' + @tablename + '
							SELECT *, ''U'', CURRENT_TIMESTAMP
							FROM deleted 	
						END
			END TRY
			BEGIN CATCH
				THROW
			END CATCH
		END
		'
	

	SET @sql = 
		'EXEC SBBWorkshopOmgeving.sys.sp_executesql 
					  N''EXEC(@statement)''
					, N''@statement nvarchar(max)''
					, @statement;'

	EXEC sp_executeSQL @sql, N'@statement nvarchar(max)', @statement
END
GO



DROP PROCEDURE IF EXISTS SP_executeCreateHistoryTableProcedures
GO

CREATE PROCEDURE SP_executeCreateHistoryTableProcedures
AS
BEGIN
	SELECT	TABLE_NAME
	INTO	#Temp
	FROM	INFORMATION_SCHEMA.TABLES
	WHERE	TABLE_TYPE = 'BASE TABLE'
	AND		TABLE_NAME NOT LIKE 'History_%'

	DECLARE @tablenameTemp VARCHAR(256)

	WHILE EXISTS (SELECT * FROM #Temp)
		BEGIN

			SET @tablenameTemp = (SELECT TOP 1 TABLE_NAME FROM #Temp)

			EXEC  ('ALTER TABLE History_' + @tablenameTemp + ' 
					ADD action	VARCHAR(2)	NOT NULL,
					timestamp	DATETIME DEFAULT CURRENT_TIMESTAMP')

			PRINT @tablenameTemp
			EXEC SP_createHistoryTableTrigger @tablename = @tablenameTemp

			DELETE FROM #Temp WHERE TABLE_NAME = @tablenameTemp
		END
END
GO


DROP TRIGGER IF EXISTS TRG_WORKSHOPTYPE_History
DROP TRIGGER IF EXISTS TRG_PLANNER_History
DROP TRIGGER IF EXISTS TRG_SECTOR_History
DROP TRIGGER IF EXISTS TRG_ORGANISATIE_History
DROP TRIGGER IF EXISTS TRG_ADVISEUR_History
DROP TRIGGER IF EXISTS TRG_CONTACTPERSOON_History
DROP TRIGGER IF EXISTS TRG_WORKSHOPLEIDER_History
DROP TRIGGER IF EXISTS TRG_BESCHIKBAARHEID_History
DROP TRIGGER IF EXISTS TRG_DEELNEMER_History
DROP TRIGGER IF EXISTS TRG_MODULE_History
DROP TRIGGER IF EXISTS TRG_WORKSHOP_History
DROP TRIGGER IF EXISTS TRG_DEELNEMER_IN_WORKSHOP_History
DROP TRIGGER IF EXISTS TRG_AANVRAAG_History
DROP TRIGGER IF EXISTS TRG_GROEP_History
DROP TRIGGER IF EXISTS TRG_DEELNEMER_IN_AANVRAAG_History
DROP TRIGGER IF EXISTS TRG_MODULE_VAN_GROEP_History

DROP TABLE IF EXISTS dbo.HISTORY_WORKSHOPTYPE
DROP TABLE IF EXISTS dbo.HISTORY_PLANNER
DROP TABLE IF EXISTS dbo.HISTORY_SECTOR
DROP TABLE IF EXISTS dbo.HISTORY_ORGANISATIE
DROP TABLE IF EXISTS dbo.HISTORY_ADVISEUR
DROP TABLE IF EXISTS dbo.HISTORY_CONTACTPERSOON
DROP TABLE IF EXISTS dbo.HISTORY_WORKSHOPLEIDER
DROP TABLE IF EXISTS dbo.HISTORY_BESCHIKBAARHEID
DROP TABLE IF EXISTS dbo.HISTORY_DEELNEMER
DROP TABLE IF EXISTS dbo.HISTORY_MODULE
DROP TABLE IF EXISTS dbo.HISTORY_WORKSHOP
DROP TABLE IF EXISTS dbo.HISTORY_DEELNEMER_IN_WORKSHOP
DROP TABLE IF EXISTS dbo.HISTORY_AANVRAAG
DROP TABLE IF EXISTS dbo.HISTORY_GROEP
DROP TABLE IF EXISTS dbo.HISTORY_DEELNEMER_IN_AANVRAAG
DROP TABLE IF EXISTS dbo.HISTORY_MODULE_VAN_GROEP

EXEC proc_generate_history_table WORKSHOPTYPE
EXEC proc_generate_history_table PLANNER
EXEC proc_generate_history_table SECTOR
EXEC proc_generate_history_table ORGANISATIE
EXEC proc_generate_history_table ADVISEUR
EXEC proc_generate_history_table CONTACTPERSOON
EXEC proc_generate_history_table WORKSHOPLEIDER
EXEC proc_generate_history_table BESCHIKBAARHEID
EXEC proc_generate_history_table DEELNEMER
EXEC proc_generate_history_table MODULE
EXEC proc_generate_history_table WORKSHOP
EXEC proc_generate_history_table DEELNEMER_IN_WORKSHOP
EXEC proc_generate_history_table AANVRAAG
EXEC proc_generate_history_table GROEP
EXEC proc_generate_history_table DEELNEMER_IN_AANVRAAG
EXEC proc_generate_history_table MODULE_VAN_GROEP



EXEC SP_executeCreateHistoryTableProcedures
