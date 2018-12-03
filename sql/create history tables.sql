-- while loop met #temp tabel die de TOP 1 kolom pakt en die toevoegt aan de tabel

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
ON IC.TABLE_NAME = IT.TABLE_NAME
WHERE COLUMN_NAME IN (
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE COLUMNPROPERTY(object_id(IC.TABLE_SCHEMA+'.'+IC.TABLE_NAME), IC.COLUMN_NAME, 'IsIdentity') = 1)
AND CONSTRAINT_TYPE = 'PRIMARY KEY'

;WITH asdf AS
(SELECT DISTINCT(COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
ON IC.TABLE_NAME = IT.TABLE_NAME
WHERE IC.TABLE_NAME = 'ADVISEUR')
SELECT * INTO #testtabel FROM asdf WHERE 1=0 
SELECT * FROM #testtabel

SELECT DISTINCT(COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
ON IC.TABLE_NAME = IT.TABLE_NAME
WHERE IC.TABLE_NAME = 'ADVISEUR'


DROP PROCEDURE IF EXISTS SP_createhistorytable

GO
CREATE PROCEDURE SP_createHistoryTable
@tablename	VARCHAR(256)
AS
BEGIN

	DECLARE @tableSchema VARCHAR(256)
	DECLARE @IDcolumnName VARCHAR(256)
	DECLARE @query VARCHAR(1000)
	DECLARE @dataType VARCHAR(100)
	DECLARE @firstRun BIT

	SET @firstRun = 0

	SELECT	COLUMN_NAME
	INTO	#TempCreate
	FROM	INFORMATION_SCHEMA.COLUMNS
	WHERE	TABLE_NAME = @tablename
	AND		COLUMN_NAME NOT IN (SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
		ON IC.TABLE_NAME = IT.TABLE_NAME
		WHERE COLUMN_NAME IN (
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE COLUMNPROPERTY(object_id(IC.TABLE_SCHEMA+'.'+IC.TABLE_NAME), IC.COLUMN_NAME, 'IsIdentity') = 1)
		AND CONSTRAINT_TYPE = 'PRIMARY KEY')

	-- select the ID column from the table that as an identity on it.
	SET @IDcolumnName = (SELECT IC.COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
	ON IC.TABLE_NAME = IT.TABLE_NAME
	WHERE COLUMN_NAME IN (
	SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE COLUMNPROPERTY(object_id(IC.TABLE_SCHEMA+'.'+IC.TABLE_NAME), IC.COLUMN_NAME, 'IsIdentity') = 1)
	AND CONSTRAINT_TYPE = 'PRIMARY KEY'
	AND IC.TABLE_NAME = @tablename)

	--WHILE EXISTS (SELECT * FROM #TempCreate)
	--	BEGIN

		-- select the datatype of the ID column
		SET @dataType = (SELECT IC.DATA_TYPE
		FROM INFORMATION_SCHEMA.COLUMNS IC INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS IT
		ON IC.TABLE_NAME = IT.TABLE_NAME
		WHERE COLUMN_NAME IN (
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE COLUMNPROPERTY(object_id(IC.TABLE_SCHEMA+'.'+IC.TABLE_NAME), IC.COLUMN_NAME, 'IsIdentity') = 1)
		AND CONSTRAINT_TYPE = 'PRIMARY KEY'
		AND IC.TABLE_NAME = @tablename)

		SET @TableSchema = (SELECT TABLE_SCHEMA
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = @tablename)

		-- create a history table with every column a table has except for the ID column
		SET @query = ('SELECT * 
		INTO History_' + @tablename +
		' FROM (SELECT *
				FROM ' + @tablename + ' 
				EXCEPT 
				SELECT ' + @IDcolumnName +
				' FROM ' + @tablename + ')')

		EXECUTE (@query)

		IF (@IDcolumnName IS NOT NULL)
		BEGIN
			SET @query = (SELECT 'ALTER TALBE History_' + @tablename + ' ADD ' + @IDcolumnName + ' ' + @dataType + ' )')
		END
		/*
		IF (@firstRun = 0)
		BEGIN
			SET @query = (SELECT 'CREATE TABLE History_' + @tablename + '( ' + @columnName + ' ' + @dataType + ' )') 
			SET @firstRun = 1
		END
		ELSE
			SET @columnName = (SELECT TOP 1 FROM #TempCreate)
			SET @query = (SELECT 'ALTER TALBE History_' + @tablename + ' ADD ' + @columnName + ' ' + @dataType + ' )')
		EXECUTE (@query)
	END
	*/
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
						SELECT *, ''I'', GETDATE()
						FROM inserted
					END

				ELSE -- If an Delete has been made D etc..
					IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
						BEGIN
							INSERT INTO History_' + @tablename + '
							SELECT *, ''D'', GETDATE()
							FROM deleted
						END
		
					ELSE -- If an update has been made U etc...
						BEGIN
							INSERT INTO History_' + @tablename + '
							SELECT *, ''U'', GETDATE()
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

	--		SET IDENTITY_INSERT SBBWorkshopOmgeving.dbo.ADVISEUR ON
	--IF (EXISTS (SELECT * 
   --              FROM INFORMATION_SCHEMA.TABLES 
   --              WHERE TABLE_NAME LIKE 'History_' + @tablenameTemp))
	--BEGIN
    --SET IDENTITY_INSERT SBBWorkshopOmgeving.[dbo].[History_+@tablenametemp] ON
	--END

			SET @tablenameTemp = (SELECT TOP 1 TABLE_NAME FROM #Temp)

			EXEC SP_createHistoryTable @tablename = @tablenameTemp

			EXEC  ('ALTER TABLE History_' + @tablenameTemp + ' 
					ADD action	VARCHAR(2)	NOT NULL,
					timestamp	DATETIME	NOT NULL')

			PRINT @tablenameTemp
			EXEC SP_createHistoryTableTrigger @tablename = @tablenameTemp

			DELETE FROM #Temp WHERE TABLE_NAME = @tablenameTemp
		END
END
GO


			EXEC SP_createHistoryTable @tablename = 'ADVISEUR'

			ALTER TABLE ADVISEUR DROP CONSTRAINT PK_ADVISEUR

			ALTER TABLE WORKSHOP DROP CONSTRAINT FK_WORKSHOP_ref_ADVISEUR
			ALTER TABLE AANVRAAG DROP CONSTRAINT FK_AANVRAAG_ref_ADVISEUR

			ALTER TABLE ADVISEUR
			DROP COLUMN ADVISEUR_ID

			DECLARE @test VARCHAR(20) = 'ADVISEUR'
			SELECT 'History_' + @test
		

			EXEC  ('ALTER TABLE History_' + 'ADVISEUR' + ' 
					ADD action	VARCHAR(2)	NOT NULL,
					timestamp	DATETIME	NOT NULL')


			SET IDENTITY_INSERT SBBWorkshopOmgeving.[dbo].[History_ADVISEUR] ON
			EXEC SP_createHistoryTableTrigger @tablename = 'ADVISEUR'

			DROP TRIGGER TRG_ADVISEUR_History

GO
		CREATE TRIGGER TRG_ADVISEUR_History
		ON dbo.ADVISEUR
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
						INSERT INTO History_ADVISEUR
						SELECT *, 'I', GETDATE()
						FROM inserted
					END

				ELSE -- If an Delete has been made D etc..
					IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
						BEGIN
							INSERT INTO History_ADVISEUR
							SELECT *, 'D', GETDATE()
							FROM deleted
						END
		
					ELSE -- If an update has been made U etc...
						BEGIN
							INSERT INTO History_ADVISEUR
							SELECT *, 'U', GETDATE()
							FROM deleted 	
						END
			END TRY
			BEGIN CATCH
				THROW
			END CATCH
		END


EXEC SP_executeCreateHistoryTableProcedures

-- creating a drop table query for each history table
/*
SELECT  'DROP TABLE ' + TABLE_SCHEMA + '.' + TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE'
AND		TABLE_NAME LIKE ('History_%')

DROP TABLE dbo.History_AANVRAAG
DROP TABLE dbo.History_ADVISEUR
DROP TABLE dbo.History_BESCHIKBAARHEID
DROP TABLE dbo.History_CONTACTPERSOON
DROP TABLE dbo.History_DEELNEMER
DROP TABLE dbo.History_DEELNEMER_IN_WORKSHOP
DROP TABLE dbo.History_MODULE
DROP TABLE dbo.History_ORGANISATIE
DROP TABLE dbo.History_SECTOR
DROP TABLE dbo.History_WORKSHOP
DROP TABLE dbo.History_WORKSHOPLEIDER

*/

