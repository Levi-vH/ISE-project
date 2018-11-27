USE SBBWorkshopOmgeving
GO

/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
INSERT INTO	[SBBWorkshopOmgeving].[dbo].[ORGANISATIE] (ORGANISATIENUMMER, ORGANISATIENAAM)
SELECT ROW_NUMBER() OVER (ORDER BY S.Name) AS [ORGANISATIENUMMER], S.Name AS [ORGANISATIENAAM]
FROM [AdventureWorks2014].[Sales].[Store] S
go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[ORGANISATIE]
ORDER BY ORGANISATIENAAM
*/

/*==============================================================*/
/* Table: ADVISEUR                                              */
/*==============================================================*/
WITH orgnum AS -- organizationnumber/organisatienummer
(
SELECT TOP 300 ORGANISATIENUMMER, ROW_NUMBER() OVER (ORDER BY NEWID()) AS id
FROM [SBBWorkshopOmgeving].[dbo].[ORGANISATIE]
),
fname AS -- firstname/voornaam
(
SELECT TOP 300 FirstName, ROW_NUMBER() OVER (ORDER BY NEWID()) AS id
FROM [AdventureWorksDW2014].[dbo].[DimCustomer]
),
lname_email AS -- lastname + email/achternaam + email
(
SELECT TOP 300 LastName, CAST(RAND(CHECKSUM(NEWID()))*2 AS INT) randomemail, ROW_NUMBER() OVER (ORDER BY NEWID()) AS id
FROM [AdventureWorksDW2014].[dbo].[DimCustomer]
),
phonenum AS -- phonenumber/telefoonnummer
(
SELECT 1 AS id, '0' + CAST(CAST(FLOOR((RAND(CHECKSUM(NEWID()))+6)*100000000) AS INT) AS VARCHAR(9)) AS phonenumber
UNION ALL
SELECT id + 1, '0' + CAST(CAST(FLOOR((RAND(CHECKSUM(NEWID()))+6)*100000000) AS INT) AS VARCHAR(9)) AS phonenumber
FROM phonenum
WHERE id < 300 -- amount of rows/hoeveelheid rijen
)
INSERT INTO	[SBBWorkshopOmgeving].[dbo].[ADVISEUR] (ORGANISATIENUMMER, VOORNAAM, ACHTERNAAM, TELEFOONNUMMER, EMAIL)
SELECT ORGANISATIENUMMER, FirstName, LastName, phonenumber,
email =
CASE
	when randomemail = 0 then 
	lower(left(FirstName,1)+[LastName])+'@hotmail.com'
	else 
	lower(left(FirstName,1)+[LastName])+'@gmail.com'
END
FROM orgnum o, fname f, lname_email le, phonenum p
WHERE o.id = f.id
AND o.id = le.id
AND o.id = p.id
OPTION(MAXRECURSION 0)
go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[ADVISEUR]
*/

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[CONTACTPERSOON]
*/

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[WORKSHOPLEIDER]
*/

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[BESCHIKBAARHEID]
*/

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
INSERT INTO [SBBWorkshopOmgeving].[dbo].[SECTOR] (SECTORNAAM)
VALUES	('ICTCI'),
		('MTLM'),
		('SV'),
		('TGO'),
		('VGG'),
		('ZDV'),
		('ZWS'),
		('Handel')
go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[SECTOR]
*/

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[DEELNEMER]
*/

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[MODULE]
*/

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[WORKSHOP]
*/

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/

go
/*
SELECT *
FROM [SBBWorkshopOmgeving].[dbo].[DEELNEMER_IN_WORKSHOP]
*/