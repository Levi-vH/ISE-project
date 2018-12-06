/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     26-11-2018 10:42:20                          */
/*==============================================================*/

USE master
GO

DROP DATABASE IF EXISTS SBBWorkshopOmgeving
GO

CREATE DATABASE SBBWorkshopOmgeving
GO

USE SBBWorkshopOmgeving
GO

/* ONDERSTAANDE IS WELLICHT NIET COMPLEET, DROP DATABASE DOET HETZELFDE, MAAR HET ONDERSTAANDE IS MISSCHIEN BETER?
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ADVISEUR') and o.name = 'FK_ADVISEUR_ref_ORGANISATIE')
alter table ADVISEUR
   drop constraint FK_ADVISEUR_ref_ORGANISATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESCHIKBAARHEID') and o.name = 'FK_BESCHIKBAARHEID_ref_WORKSHOPLEIDER')
alter table BESCHIKBAARHEID
   drop constraint FK_BESCHIKBAARHEID_ref_WORKSHOPLEIDER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CONTACTPERSOON') and o.name = 'FK_CONTACTPERSOON_ref_ORGANISATIE')
alter table CONTACTPERSOON
   drop constraint FK_CONTACTPERSOON_ref_ORGANISATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER') and o.name = 'FK_DEELNEMER_ref_ORGANISATIE')
alter table DEELNEMER
   drop constraint FK_DEELNEMER_ref_ORGANISATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER') and o.name = 'FK_DEELNEMER_ref_SECTOR')
alter table DEELNEMER
   drop constraint FK_DEELNEMER_ref_SECTOR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_WORKSHOP') and o.name = 'FK_DEELNEMER_IN_WORKSHOP_ref_DEELNEMER')
alter table DEELNEMER_IN_WORKSHOP
   drop constraint FK_DEELNEMER_IN_WORKSHOP_ref_DEELNEMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_WORKSHOP') and o.name = 'FK_DEELNEMER_IN_WORKSHOP_ref_WORKSHOP')
alter table DEELNEMER_IN_WORKSHOP
   drop constraint FK_DEELNEMER_IN_WORKSHOP_ref_WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_ADVISEUR')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_ADVISEUR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_CONTACTPERSOON')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_CONTACTPERSOON
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_MODULE')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_MODULE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_ORGANISATIE')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_ORGANISATIE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_WORKSHOPLEIDER')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_WORKSHOPLEIDER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ref_SECTOR')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ref_SECTOR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AANVRAAG') and o.name = 'FK_AANVRAAG_ref_CONTACTPERSOON')
alter table AANVRAAG
   drop constraint FK_AANVRAAG_ref_CONTACTPERSOON
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AANVRAAG') and o.name = 'FK_AANVRAAG_ref_ADVISEUR')
alter table AANVRAAG
   drop constraint FK_AANVRAAG_ref_ADVISEUR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ADVISEUR')
            and   type = 'U')
   drop table ADVISEUR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BESCHIKBAARHEID')
            and   type = 'U')
   drop table BESCHIKBAARHEID
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTACTPERSOON')
            and   type = 'U')
   drop table CONTACTPERSOON
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DEELNEMER')
            and   type = 'U')
   drop table DEELNEMER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DEELNEMER_IN_WORKSHOP')
            and   type = 'U')
   drop table DEELNEMER_IN_WORKSHOP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MODULE')
            and   type = 'U')
   drop table MODULE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ORGANISATIE')
            and   type = 'U')
   drop table ORGANISATIE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SECTOR')
            and   type = 'U')
   drop table SECTOR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WORKSHOP')
            and   type = 'U')
   drop table WORKSHOP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('WORKSHOPLEIDER')
            and   type = 'U')
   drop table WORKSHOPLEIDER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AANVRAAG')
            and   type = 'U')
   drop table AANVRAAG
go
*/

/*==============================================================*/
/* Table: PLANNER                                                */
/*==============================================================*/
CREATE TABLE PLANNER (
	NAAM	VARCHAR(52)		NOT NULL,

	CONSTRAINT PK_PLANNER PRIMARY KEY (NAAM)
)
GO

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
CREATE TABLE SECTOR (
   SECTORNAAM          VARCHAR(20)         NOT NULL,
   CONSTRAINT PK_SECTOR PRIMARY KEY (SECTORNAAM)
)
GO

/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
CREATE TABLE ORGANISATIE (
   ORGANISATIENUMMER     INT		         NOT NULL,
   ORGANISATIENAAM       VARCHAR(60)         NOT NULL,
   ADRES				 VARCHAR(60)         NOT NULL,
   POSTCODE				 VARCHAR(20)         NOT NULL,
   PLAATSNAAM			 VARCHAR(60)         NOT NULL,
   CONSTRAINT PK_ORGANISATIE PRIMARY KEY (ORGANISATIENUMMER)
)
GO

/*==============================================================*/
/* Table: ADVISEUR                                              */
/*==============================================================*/
CREATE TABLE ADVISEUR (
   ADVISEUR_ID          INT IDENTITY         NOT NULL,
   ORGANISATIENUMMER    INT			         NOT NULL,
   SECTORNAAM			VARCHAR(20)	         NOT NULL,
   VOORNAAM				VARCHAR(30)          NOT NULL,
   ACHTERNAAM			VARCHAR(50)	         NOT NULL,
   TELEFOONNUMMER       VARCHAR(12)          NULL,
   EMAIL                VARCHAR(100)         NULL,
   CONSTRAINT PK_ADVISEUR PRIMARY KEY (ADVISEUR_ID)
)
GO

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/
CREATE TABLE CONTACTPERSOON (
   CONTACTPERSOON_ID    INT IDENTITY         NOT NULL,
   ORGANISATIENUMMER    INT			         NOT NULL,
   VOORNAAM             VARCHAR(30)          NOT NULL,
   ACHTERNAAM           VARCHAR(50)          NOT NULL,
   TELEFOONNUMMER       VARCHAR(12)          NULL,
   EMAIL                VARCHAR(100)         NULL,
   CONSTRAINT PK_CONTACTPERSOON PRIMARY KEY (CONTACTPERSOON_ID)
)
GO

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/
CREATE TABLE WORKSHOPLEIDER (
   WORKSHOPLEIDER_ID    INT IDENTITY         NOT NULL,
   VOORNAAM				VARCHAR(30)          NOT NULL,
   ACHTERNAAM			VARCHAR(50)          NOT NULL,
   TOEVOEGING			TINYINT				 NULL,
   CONSTRAINT PK_WORKSHOPLEIDER PRIMARY KEY (WORKSHOPLEIDER_ID)
)
GO

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/
CREATE TABLE BESCHIKBAARHEID (
   WORKSHOPLEIDER_ID    INT			         NOT NULL,
   KWARTAAL             CHAR(1)              NOT NULL,
   JAAR                 SMALLINT             NOT NULL,
   AANTAL_UUR           SMALLINT             NOT NULL,
   CONSTRAINT PK_BESCHIKBAARHEID PRIMARY KEY (WORKSHOPLEIDER_ID, KWARTAAL, JAAR, AANTAL_UUR)
)
GO

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/
CREATE TABLE DEELNEMER (
   DEELNEMER_ID					INT IDENTITY         NOT NULL,
   SECTORNAAM					VARCHAR(20)          NULL,
   ORGANISATIENUMMER			INT			         NOT NULL,
   AANHEF						VARCHAR(7)           NOT NULL,
   VOORNAAM						VARCHAR(30)          NOT NULL,
   ACHTERNAAM					VARCHAR(50)          NOT NULL,
   GEBOORTEDATUM				DATE	             NOT NULL,
   EMAIL						VARCHAR(100)         NULL,
   TELEFOONNUMMER				VARCHAR(12)          NULL,
   OPLEIDINGSNIVEAU				VARCHAR(100)         NOT NULL,
   ORGANISATIE_VESTIGINGSPLAATS	VARCHAR(60)          NOT NULL,
   IS_OPEN_INSCHRIJVING         BIT                  NOT NULL,
   GEWENST_BEGELEIDINGSNIVEAU	VARCHAR(100)         NULL,
   FUNCTIENAAM					VARCHAR(100)         NULL,
   CONSTRAINT PK_DEELNEMER PRIMARY KEY (DEELNEMER_ID)
)
GO

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/
CREATE TABLE MODULE (
   MODULENUMMER       INT                  NOT NULL,
   MODULENAAM         VARCHAR(100)         NOT NULL,
   CONSTRAINT PK_MODULE PRIMARY KEY (MODULENUMMER)
)
GO

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/
CREATE TABLE WORKSHOP (
   WORKSHOP_ID						INT IDENTITY         NOT NULL,
   WORKSHOPLEIDER_ID				INT                  NULL,
   CONTACTPERSOON_ID				INT                  NULL,
   ORGANISATIENUMMER				INT			         NULL,
   MODULENUMMER						INT                  NULL,
   ADVISEUR_ID						INT                  NULL,
   SECTORNAAM						VARCHAR(20)          NULL,
   DATUM							DATE	             NULL,
   STARTTIJD						TIME	             NULL,
   EINDTIJD							TIME	             NULL,
   ADRES							VARCHAR(60)          NULL,
   POSTCODE							VARCHAR(7)           NULL,
   PLAATSNAAM						VARCHAR(60)          NULL,
   [STATUS]							VARCHAR(20)          NULL,
   OPMERKING						VARCHAR(255)         NULL,
   [TYPE]							VARCHAR(3)           NULL,
   VERWERKT_BREIN					DATE	             NULL,
   DEELNEMER_GEGEVENS_ONTVANGEN		DATE	             NULL,
   OVK_BEVESTIGING					DATE	             NULL,
   PRESENTIELIJST_VERSTUURD			DATE	             NULL,
   PRESENTIELIJST_ONTVANGEN			DATE	             NULL,
   BEWIJS_DEELNAME_MAIL_SBB_WSL		DATE	             NULL,
   CONSTRAINT PK_WORKSHOP PRIMARY KEY (WORKSHOP_ID)
)
GO

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/
CREATE TABLE DEELNEMER_IN_WORKSHOP (
   WORKSHOP_ID          INT			         NOT NULL,
   DEELNEMER_ID         INT                  NOT NULL,
   VOLGNUMMER           INT                  NOT NULL,
   IS_GOEDGEKEURD       BIT                  NOT NULL,
   CONSTRAINT PK_DEELNEMER_IN_WORKSHOP PRIMARY KEY (WORKSHOP_ID, DEELNEMER_ID, VOLGNUMMER)
)
GO

/*==============================================================*/
/* Table: AANVRAAG		                                        */
/*==============================================================*/
CREATE TABLE AANVRAAG (
   AANVRAAG_ID		    INT IDENTITY         NOT NULL,
   ORGANISATIE_ID		INT					 NOT NULL,
   CONTACTPERSOON_ID	INT			         NOT NULL,
   ADVISEUR_ID			INT			         NOT NULL,
   SBB_PLANNER			VARCHAR(52)			 NOT NULL,
   AANVRAAG_DATUM		DATETIME			 DEFAULT GETDATE(),
   CONSTRAINT PK_AANVRAAG PRIMARY KEY (AANVRAAG_ID)
)
GO

/*==============================================================*/
/* Table: GROEP													*/
/*==============================================================*/
CREATE TABLE GROEP (
   GROEP_ID		    INT IDENTITY			 NOT NULL,
   ADRES			VARCHAR(60)				 NOT NULL,
   TELEFOONNUMMER	VARCHAR(12)				 NOT NULL,
   EMAIL			VARCHAR(100)			 NOT NULL,
   CONSTRAINT PK_GROEP PRIMARY KEY (GROEP_ID)
)
GO

/*==============================================================*/
/* Table: AANVRAAG_VAN_GROEP		                            */
/*==============================================================*/
CREATE TABLE AANVRAAG_VAN_GROEP (
   AANVRAAG_ID		    INT 				 NOT NULL,
   GROEP_ID				INT					 NOT NULL,
   CONSTRAINT PK_AANVRAAG_VAN_GROEP PRIMARY KEY (AANVRAAG_ID, GROEP_ID)
)
GO

/*==============================================================*/
/* Table: MODULE_VAN_GROEP		                                */
/*==============================================================*/
CREATE TABLE MODULE_VAN_GROEP (
   GROEP_ID				INT					 NOT NULL,
   MODULENUMMER			INT					 NOT NULL,
   VOORKEUR				VARCHAR(20)			 NOT NULL,
   CONSTRAINT PK_MODULE_VAN_GROEP PRIMARY KEY (GROEP_ID, MODULENUMMER)
)
GO


ALTER TABLE ADVISEUR
   ADD CONSTRAINT FK_ADVISEUR_ref_ORGANISATIE FOREIGN KEY (ORGANISATIENUMMER)
      REFERENCES ORGANISATIE (ORGANISATIENUMMER)
GO

ALTER TABLE ADVISEUR
   ADD CONSTRAINT FK_ADVISEUR_ref_SECTOR FOREIGN KEY (SECTORNAAM)
      REFERENCES SECTOR (SECTORNAAM)
GO

ALTER TABLE BESCHIKBAARHEID
   ADD CONSTRAINT FK_BESCHIKBAARHEID_ref_WORKSHOPLEIDER FOREIGN KEY (WORKSHOPLEIDER_ID)
      REFERENCES WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
GO

ALTER TABLE CONTACTPERSOON
   ADD CONSTRAINT FK_CONTACTPERSOON_ref_ORGANISATIE FOREIGN KEY (ORGANISATIENUMMER)
      REFERENCES ORGANISATIE (ORGANISATIENUMMER)
GO

ALTER TABLE DEELNEMER
   ADD CONSTRAINT FK_DEELNEMER_ref_ORGANISATIE FOREIGN KEY (ORGANISATIENUMMER)
      REFERENCES ORGANISATIE (ORGANISATIENUMMER)
GO

ALTER TABLE DEELNEMER
   ADD CONSTRAINT FK_DEELNEMER_ref_SECTOR FOREIGN KEY (SECTORNAAM)
      REFERENCES SECTOR (SECTORNAAM)
GO

ALTER TABLE DEELNEMER_IN_WORKSHOP
   ADD CONSTRAINT FK_DEELNEMER_IN_WORKSHOP_ref_DEELNEMER FOREIGN KEY (DEELNEMER_ID)
      REFERENCES DEELNEMER (DEELNEMER_ID)
GO

ALTER TABLE DEELNEMER_IN_WORKSHOP
   ADD CONSTRAINT FK_DEELNEMER_IN_WORKSHOP_ref_WORKSHOP FOREIGN KEY (WORKSHOP_ID)
      REFERENCES WORKSHOP (WORKSHOP_ID)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_ADVISEUR FOREIGN KEY (ADVISEUR_ID)
      REFERENCES ADVISEUR (ADVISEUR_ID)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_CONTACTPERSOON FOREIGN KEY (CONTACTPERSOON_ID)
      REFERENCES CONTACTPERSOON (CONTACTPERSOON_ID)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_MODULE FOREIGN KEY (MODULENUMMER)
      REFERENCES MODULE (MODULENUMMER)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_ORGANISATIE FOREIGN KEY (ORGANISATIENUMMER)
      REFERENCES ORGANISATIE (ORGANISATIENUMMER)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_WORKSHOPLEIDER FOREIGN KEY (WORKSHOPLEIDER_ID)
      REFERENCES WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
GO

ALTER TABLE WORKSHOP
   ADD CONSTRAINT FK_WORKSHOP_ref_SECTOR FOREIGN KEY (SECTORNAAM)
      REFERENCES SECTOR (SECTORNAAM)
GO

ALTER TABLE AANVRAAG
   ADD CONSTRAINT FK_AANVRAAG_ref_CONTACTPERSOON FOREIGN KEY (CONTACTPERSOON_ID)
      REFERENCES CONTACTPERSOON (CONTACTPERSOON_ID)
GO

ALTER TABLE AANVRAAG
   ADD CONSTRAINT FK_AANVRAAG_ref_ADVISEUR FOREIGN KEY (ADVISEUR_ID)
      REFERENCES ADVISEUR (ADVISEUR_ID)
GO

ALTER TABLE AANVRAAG
	ADD CONSTRAINT FK_AANVRAAG_ref_PLANNER FOREIGN KEY (SBB_PLANNER) 
	REFERENCES PLANNER(NAAM)
GO

ALTER TABLE AANVRAAG_VAN_GROEP
	ADD CONSTRAINT FK_AANVRAAG_VAN_GROEP_ref_AANVRAAG FOREIGN KEY (AANVRAAG_ID) 
	REFERENCES AANVRAAG(AANVRAAG_ID)
GO

ALTER TABLE AANVRAAG_VAN_GROEP
	ADD CONSTRAINT FK_AANVRAAG_VAN_GROEP_ref_GROEP FOREIGN KEY (GROEP_ID) 
	REFERENCES GROEP(GROEP_ID)
GO

ALTER TABLE MODULE_VAN_GROEP
	ADD CONSTRAINT FK_MODULE_VAN_GROEP_ref_MODULE FOREIGN KEY (MODULENUMMER) 
	REFERENCES MODULE(MODULENUMMER)
GO

ALTER TABLE MODULE_VAN_GROEP
	ADD CONSTRAINT FK_MODULE_VAN_GROEP_ref_GROEP FOREIGN KEY (GROEP_ID) 
	REFERENCES GROEP(GROEP_ID)
GO