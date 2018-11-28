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
/* Table: ADVISEUR                                              */
/*==============================================================*/
create table ADVISEUR (
   ADVISEUR_ID          int IDENTITY         not null,
   ORGANISATIENUMMER    varchar(15)          not null,
   SECTORNAAM			varchar(255)         not null,
   VOORNAAM				varchar(255)         not null,
   ACHTERNAAM			varchar(255)         not null,
   TELEFOONNUMMER       varchar(255)         null,
   EMAIL                varchar(255)         null,
   constraint PK_ADVISEUR primary key (ADVISEUR_ID)
)
go

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/
create table BESCHIKBAARHEID (
   WORKSHOPLEIDER_ID    int			         not null,
   KWARTAAL             char(1)              not null,
   JAAR                 smallint             not null,
   AANTAL_UUR           smallint             not null,
   constraint PK_BESCHIKBAARHEID primary key (WORKSHOPLEIDER_ID, KWARTAAL, JAAR, AANTAL_UUR)
)
go

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/
create table CONTACTPERSOON (
   CONTACTPERSOON_ID    int IDENTITY         not null,
   ORGANISATIENUMMER    varchar(15)          not null,
   VOORNAAM             varchar(255)         not null,
   ACHTERNAAM           varchar(255)         not null,
   TELEFOONNUMMER       varchar(255)         null,
   EMAIL                varchar(255)         null,
   constraint PK_CONTACTPERSOON primary key (CONTACTPERSOON_ID)
)
go

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/
create table DEELNEMER (
   DEELNEMER_ID					int IDENTITY         not null,
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
   constraint PK_DEELNEMER primary key (DEELNEMER_ID)
)
go

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/
create table DEELNEMER_IN_WORKSHOP (
   WORKSHOP_ID          int			         not null,
   DEELNEMER_ID         int                  not null,
   VOLGNUMMER           int                  not null,
   IS_GOEDGEKEURD       bit                  not null	DEFAULT 0,
   constraint PK_DEELNEMER_IN_WORKSHOP primary key (WORKSHOP_ID, DEELNEMER_ID)
)
go

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/
create table MODULE (
   MODULENUMMER       int                  not null,
   MODULENAAM         varchar(255)         not null,
   constraint PK_MODULE primary key (MODULENUMMER)
)
go

/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
create table ORGANISATIE (
   ORGANISATIENUMMER     varchar(15)          not null,
   ORGANISATIENAAM       varchar(255)         null,
   constraint PK_ORGANISATIE primary key (ORGANISATIENUMMER)
)
go

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
create table SECTOR (
   SECTORNAAM          varchar(255)         not null,
   constraint PK_SECTOR primary key (SECTORNAAM)
)
go

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/
create table WORKSHOP (
   WORKSHOP_ID						int IDENTITY         not null,
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
   STATUS							varchar(255)         null,
   OPMERKING						varchar(255)         null,
   TYPE								varchar(3)           null,
   VERWERKT_BREIN					date	             null,
   DEELNEMER_GEGEVENS_ONTVANGEN		date	             null,
   OVK_BEVESTIGING					date	             null,
   PRESENTIELIJST_VERSTUURD			date	             null,
   PRESENTIELIJST_ONTVANGEN			date	             null,
   BEWIJS_DEELNAME_MAIL_SBB_WSL		date	             null,
   constraint PK_WORKSHOP primary key (WORKSHOP_ID)
)
go

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/
create table WORKSHOPLEIDER (
   WORKSHOPLEIDER_ID    int IDENTITY         not null,
   VOORNAAM				varchar(255)         not null,
   ACHTERNAAM			varchar(255)         not null,
   TOEVOEGING			tinyint				 null,
   constraint PK_WORKSHOPLEIDER primary key (WORKSHOPLEIDER_ID)
)
go

/*==============================================================*/
/* Table: AANVRAAG		                                        */
/*==============================================================*/
create table AANVRAAG (
   AANVRAAG_ID		    int IDENTITY         not null,
   CONTACTPERSOON_ID	int			         not null,
   ADVISEUR_ID			int			         not null,
   AANTAL_GROEPEN		tinyint				 not null,
   constraint PK_AANVRAAG primary key (AANVRAAG_ID)
)
go

alter table ADVISEUR
   add constraint FK_ADVISEUR_ref_ORGANISATIE foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table ADVISEUR
   add constraint FK_ADVISEUR_ref_SECTOR foreign key (SECTORNAAM)
      references SECTOR (SECTORNAAM)
go

alter table BESCHIKBAARHEID
   add constraint FK_BESCHIKBAARHEID_ref_WORKSHOPLEIDER foreign key (WORKSHOPLEIDER_ID)
      references WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
go

alter table CONTACTPERSOON
   add constraint FK_CONTACTPERSOON_ref_ORGANISATIE foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table DEELNEMER
   add constraint FK_DEELNEMER_ref_ORGANISATIE foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table DEELNEMER
   add constraint FK_DEELNEMER_ref_SECTOR foreign key (SECTORNAAM)
      references SECTOR (SECTORNAAM)
go

alter table DEELNEMER_IN_WORKSHOP
   add constraint FK_DEELNEMER_IN_WORKSHOP_ref_DEELNEMER foreign key (DEELNEMER_ID)
      references DEELNEMER (DEELNEMER_ID)
go

alter table DEELNEMER_IN_WORKSHOP
   add constraint FK_DEELNEMER_IN_WORKSHOP_ref_WORKSHOP foreign key (WORKSHOP_ID)
      references WORKSHOP (WORKSHOP_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_ADVISEUR foreign key (ADVISEUR_ID)
      references ADVISEUR (ADVISEUR_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_CONTACTPERSOON foreign key (CONTACTPERSOON_ID)
      references CONTACTPERSOON (CONTACTPERSOON_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_MODULE foreign key (MODULENUMMER)
      references MODULE (MODULENUMMER)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_ORGANISATIE foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_WORKSHOPLEIDER foreign key (WORKSHOPLEIDER_ID)
      references WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ref_SECTOR foreign key (SECTORNAAM)
      references SECTOR (SECTORNAAM)
go

alter table AANVRAAG
   add constraint FK_AANVRAAG_ref_CONTACTPERSOON foreign key (CONTACTPERSOON_ID)
      references CONTACTPERSOON (CONTACTPERSOON_ID)
go

alter table AANVRAAG
   add constraint FK_AANVRAAG_ref_ADVISEUR foreign key (ADVISEUR_ID)
      references ADVISEUR (ADVISEUR_ID)
go