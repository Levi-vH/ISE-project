USE SBBWorkshopOmgeving
GO


/*==============================================================*/
/* Table: PLANNER_History                                       */
/*==============================================================*/
CREATE TABLE History_PLANNER (
	NAAM VARCHAR(50) NOT NULL,
)
go

/*==============================================================*/
/* Table: SECTOR_History                                        */
/*==============================================================*/
create table History_SECTOR (
   SECTORNAAM          varchar(255)         not null,
)
go

/*==============================================================*/
/* Table: ORGANISATIE_History                                   */
/*==============================================================*/
create table History_ORGANISATIE (
   ORGANISATIENUMMER     varchar(15)          not null,
   ORGANISATIENAAM       varchar(255)         null,
   ADRES				 varchar(255)         null,
   POSTCODE				 varchar(12)          null,
   PLAATSNAAM			 varchar(255)         null,
)
go

/*==============================================================*/
/* Table: ADVISEUR_History                                      */
/*==============================================================*/
create table History_ADVISEUR (
   ADVISEUR_ID          int			         not null,
   ORGANISATIENUMMER    varchar(15)          not null,
   SECTORNAAM			varchar(255)         not null,
   VOORNAAM				varchar(255)         not null,
   ACHTERNAAM			varchar(255)         not null,
   TELEFOONNUMMER       varchar(255)         null,
   EMAIL                varchar(255)         null,
)
go

/*==============================================================*/
/* Table: CONTACTPERSOON_History                                */
/*==============================================================*/
create table History_CONTACTPERSOON (
   CONTACTPERSOON_ID    int			         not null,
   ORGANISATIENUMMER    varchar(15)          not null,
   VOORNAAM             varchar(255)         not null,
   ACHTERNAAM           varchar(255)         not null,
   TELEFOONNUMMER       varchar(255)         null,
   EMAIL                varchar(255)         null,
)
go

/*==============================================================*/
/* Table: WORKSHOPLEIDER_History                                */
/*==============================================================*/
create table History_WORKSHOPLEIDER (
   WORKSHOPLEIDER_ID    int			         not null,
   VOORNAAM				varchar(255)         not null,
   ACHTERNAAM			varchar(255)         not null,
   TOEVOEGING			tinyint				 null,
)
go

/*==============================================================*/
/* Table: BESCHIKBAARHEID_History                               */
/*==============================================================*/
create table History_BESCHIKBAARHEID (
   WORKSHOPLEIDER_ID    int			         not null,
   KWARTAAL             char(1)              not null,
   JAAR                 smallint             not null,
   AANTAL_UUR           smallint             not null,
)
go

/*==============================================================*/
/* Table: DEELNEMER_History                                     */
/*==============================================================*/
create table History_DEELNEMER (
   DEELNEMER_ID					int			         not null,
   SECTORNAAM					varchar(255)         not null,
   ORGANISATIENUMMER			varchar(15)          null,
   AANHEF						varchar(7)           not null,
   VOORNAAM						varchar(255)         not null,
   ACHTERNAAM					varchar(255)         not null,
   GEBOORTEDATUM				date	             not null,
   EMAIL						varchar(255)         not null,
   TELEFOONNUMMER				varchar(255)         not null,
   OPLEIDINGSNIVEAU				varchar(11)          not null,
   ORGANISATIE_VESTIGINGSPLAATS	varchar(255)         not null,
   IS_OPEN_INSCHRIJVING         bit                  not null,
   GEWENST_BEGELEIDINGSNIVEAU	varchar(255)         null,
   FUNCTIENAAM					varchar(255)         null,
)
go

/*==============================================================*/
/* Table: MODULE_History                                        */
/*==============================================================*/
create table History_MODULE (
   MODULENUMMER       int                  not null,
   MODULENAAM         varchar(255)         not null,
)
go

/*==============================================================*/
/* Table: WORKSHOP_History                                      */
/*==============================================================*/
create table History_WORKSHOP (
   WORKSHOP_ID						int			         not null,
   WORKSHOPLEIDER_ID				int                  null,
   CONTACTPERSOON_ID				int                  null,
   ORGANISATIENUMMER				varchar(15)          null,
   MODULENUMMER						int                  null,
   ADVISEUR_ID						int                  null,
   SECTORNAAM						varchar(255)         null,
   DATUM							date	             null,
   STARTTIJD						time	             null,
   EINDTIJD							time	             null,
   ADRES							varchar(255)         null,
   POSTCODE							varchar(12)          null,
   PLAATSNAAM						varchar(255)         null,
   [STATUS]							varchar(255)         null,
   OPMERKING						varchar(255)         null,
   [TYPE]							varchar(3)           null,
   VERWERKT_BREIN					date	             null,
   DEELNEMER_GEGEVENS_ONTVANGEN		date	             null,
   OVK_BEVESTIGING					date	             null,
   PRESENTIELIJST_VERSTUURD			date	             null,
   PRESENTIELIJST_ONTVANGEN			date	             null,
   BEWIJS_DEELNAME_MAIL_SBB_WSL		date	             null,
)
go

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP_History                         */
/*==============================================================*/
create table History_DEELNEMER_IN_WORKSHOP (
   WORKSHOP_ID          int			         not null,
   DEELNEMER_ID         int                  not null,
   VOLGNUMMER           int                  not null,
   IS_GOEDGEKEURD       bit                  not null,
)
go

/*==============================================================*/
/* Table: AANVRAAG_History                                      */
/*==============================================================*/
create table History_AANVRAAG (
   AANVRAAG_ID		    int			         not null,
   ORGANISATIE_ID		int					 not null,
   CONTACTPERSOON_ID	int			         not null,
   ADVISEUR_ID			int			         not null,
   SBB_PLANNER			VARCHAR(50)			 not null,
   AANVRAAG_DATUM		DATETIME			 not null,
)
go

/*==============================================================*/
/* Table: GROEP_History 										*/
/*==============================================================*/
create table History_GROEP (
   GROEP_ID		    int						 not null,
   ADRES			VARCHAR(255)			 not null,
   TELEFOONNUMMER	VARCHAR(255)			 not null,
   EMAIL			VARCHAR(255)		     not null,
)
go

/*==============================================================*/
/* Table: AANVRAAG_VAN_GROEP_History                            */
/*==============================================================*/
create table History_AANVRAAG_VAN_GROEP (
   AANVRAAG_ID		    int 				 not null,
   GROEP_ID				int					 not null,
)
go

/*==============================================================*/
/* Table: MODULE_VAN_GROEP_History                              */
/*==============================================================*/
create table History_MODULE_VAN_GROEP (
   GROEP_ID				int					 not null,
   MODULENUMMER			int					 not null,
   VOORKEUR				VARCHAR(50)			 not null,
)
go


/*
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

	/*
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
		*/

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

		PRINT 'TSET'

		-- create a history table with every column a table has except for the ID column
		SET @query = ('SELECT * 
		INTO History_' + @tablename +
		' FROM ' + @tablename +
		' WHERE 1= 0')

		PRINT 'TEST 2'
		
		EXECUTE (@query)

		PRINT 'DEZE QUERY'
		IF (@IDcolumnName IS NOT NULL)
		BEGIN
			SET @query = ('ALTER TABLE History_' + @tablename +
						  ' DROP COLUMN ' + @IDcolumnName)

			EXECUTE (@query)

			PRINT 'TSET 3'
			SET @query = (SELECT 'ALTER TABLE History_' + @tablename + ' ADD ' + @IDcolumnName + ' ' + @dataType)

			EXECUTE (@query)
			PRINT 'TEST 4'
		END
		 


		/*
		SELECT * 
		INTO History_ADVISEUR 
		 FROM (SELECT *
				FROM   ADVISEUR 
				EXCEPT 
				SELECT   ADVISEUR_ID
				 FROM   ADVISEUR ) t */


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

*/
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

			SET @tablenameTemp = (SELECT TOP 1 TABLE_NAME FROM #Temp)

			EXEC  ('ALTER TABLE History_' + @tablenameTemp + ' 
					ADD action	VARCHAR(2)	NOT NULL,
					timestamp	DATETIME	NOT NULL')

			PRINT @tablenameTemp
			EXEC SP_createHistoryTableTrigger @tablename = @tablenameTemp

			DELETE FROM #Temp WHERE TABLE_NAME = @tablenameTemp
		END
END
GO




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

BEGIN TRAN
INSERT INTO ADVISEUR([ORGANISATIENUMMER], [SECTORNAAM], [VOORNAAM], [ACHTERNAAM], [TELEFOONNUMMER], [EMAIL])
VALUES (1, 'naam', 'bart', 'polman', 0612345678, 'BartPolman@live.nl')
SELECT *
FROM ADVISEUR

UPDATE ADVISEUR
SET VOORNAAM = 'Mark'
WHERE ADVISEUR_ID = 14

SELECT *
FROM History_ADVISEUR

select * FROM ADVISEUR
ROLLBACK TRAN
