/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
INSERT INTO	[SBBWorkshopOmgeving].[dbo].[ORGANISATIE]
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

go

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/

go

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/

go

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/

go

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/

go

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/

go

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/

go

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/

go

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/

go