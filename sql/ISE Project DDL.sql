/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014                    */
/* Created on:     26-11-2018 10:26:28                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ADVISEUR') and o.name = 'FK_ADVISEUR_ADVISEUR__ORGANISA')
alter table ADVISEUR
   drop constraint FK_ADVISEUR_ADVISEUR__ORGANISA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BESCHIKBAARHEID') and o.name = 'FK_BESCHIKB_BESCHIKBB_WORKSHOP')
alter table BESCHIKBAARHEID
   drop constraint FK_BESCHIKB_BESCHIKBB_WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CONTACTPERSOON') and o.name = 'FK_CONTACTP_CONTACTPE_ORGANISA')
alter table CONTACTPERSOON
   drop constraint FK_CONTACTP_CONTACTPE_ORGANISA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER') and o.name = 'FK_DEELNEME_DEELNEMER_ORGANISA')
alter table DEELNEMER
   drop constraint FK_DEELNEME_DEELNEMER_ORGANISA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER') and o.name = 'FK_DEELNEME_SECTOR_VA_SECTOR')
alter table DEELNEMER
   drop constraint FK_DEELNEME_SECTOR_VA_SECTOR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_WORKSHOP') and o.name = 'FK_DEELNEME_DEELNEMER_DEELNEME')
alter table DEELNEMER_IN_WORKSHOP
   drop constraint FK_DEELNEME_DEELNEMER_DEELNEME
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('DEELNEMER_IN_WORKSHOP') and o.name = 'FK_DEELNEME_WORKSHOP__WORKSHOP')
alter table DEELNEMER_IN_WORKSHOP
   drop constraint FK_DEELNEME_WORKSHOP__WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ADVISEUR__ADVISEUR')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ADVISEUR__ADVISEUR
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_CONTACTPE_CONTACTP')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_CONTACTPE_CONTACTP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_MODULE_VA_MODULE')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_MODULE_VA_MODULE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_ORGANISAT_ORGANISA')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_ORGANISAT_ORGANISA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_WORKSHOPL_WORKSHOP')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_WORKSHOPL_WORKSHOP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('WORKSHOP') and o.name = 'FK_WORKSHOP_WORKSHOP__SECTOR')
alter table WORKSHOP
   drop constraint FK_WORKSHOP_WORKSHOP__SECTOR
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ADVISEUR')
            and   name  = 'ADVISEUR_VAN_ORGANISATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index ADVISEUR.ADVISEUR_VAN_ORGANISATIE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ADVISEUR')
            and   type = 'U')
   drop table ADVISEUR
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BESCHIKBAARHEID')
            and   name  = 'BESCHIKBBAARHEID_VAN_WORKSHOPLEIDER_FK'
            and   indid > 0
            and   indid < 255)
   drop index BESCHIKBAARHEID.BESCHIKBBAARHEID_VAN_WORKSHOPLEIDER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BESCHIKBAARHEID')
            and   type = 'U')
   drop table BESCHIKBAARHEID
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CONTACTPERSOON')
            and   name  = 'CONTACTPERSOON_VAN_ORGANISATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index CONTACTPERSOON.CONTACTPERSOON_VAN_ORGANISATIE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTACTPERSOON')
            and   type = 'U')
   drop table CONTACTPERSOON
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER')
            and   name  = 'SECTOR_VAN_OPEN_INSCHRIJVING_DEELNEMER_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER.SECTOR_VAN_OPEN_INSCHRIJVING_DEELNEMER_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER')
            and   name  = 'DEELNEMER_VAN_ORGANISATIE_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER.DEELNEMER_VAN_ORGANISATIE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DEELNEMER')
            and   type = 'U')
   drop table DEELNEMER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER_IN_WORKSHOP')
            and   name  = 'DEELNEMER_IN_DEELNEMER_IN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER_IN_WORKSHOP.DEELNEMER_IN_DEELNEMER_IN_WORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('DEELNEMER_IN_WORKSHOP')
            and   name  = 'WORKSHOP_IN_DEELNEMER_IN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index DEELNEMER_IN_WORKSHOP.WORKSHOP_IN_DEELNEMER_IN_WORKSHOP_FK
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
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'ADVISEUR_VAN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.ADVISEUR_VAN_WORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'CONTACTPERSOON_VAN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.CONTACTPERSOON_VAN_WORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'ORGANISATIE_VAN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.ORGANISATIE_VAN_WORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'MODULE_VAN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.MODULE_VAN_WORKSHOP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'WORKSHOP_IN_SECTOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.WORKSHOP_IN_SECTOR_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('WORKSHOP')
            and   name  = 'WORKSHOPLEIDER_VAN_WORKSHOP_FK'
            and   indid > 0
            and   indid < 255)
   drop index WORKSHOP.WORKSHOPLEIDER_VAN_WORKSHOP_FK
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

if exists(select 1 from systypes where name='AANHEF')
   drop type AANHEF
go

if exists(select 1 from systypes where name='AANTAL_UUR')
   drop type AANTAL_UUR
go

if exists(select 1 from systypes where name='ACHTERNAAM')
   drop type ACHTERNAAM
go

if exists(select 1 from systypes where name='ADVISEUR_ID')
   drop type ADVISEUR_ID
go

if exists(select 1 from systypes where name='CONTATPERSOON_ID')
   drop type CONTATPERSOON_ID
go

if exists(select 1 from systypes where name='DATUM')
   drop type DATUM
go

if exists(select 1 from systypes where name='DEELNEMER_ID')
   drop type DEELNEMER_ID
go

if exists(select 1 from systypes where name='EINDTIJD')
   drop type EINDTIJD
go

if exists(select 1 from systypes where name='EMAIL')
   drop type EMAIL
go

if exists(select 1 from systypes where name='FUNCTIENAAM')
   drop type FUNCTIENAAM
go

if exists(select 1 from systypes where name='GEBOORTEDATUM')
   drop type GEBOORTEDATUM
go

if exists(select 1 from systypes where name='GEWENST_BEGELEIDINGSNIVEAU')
   drop type GEWENST_BEGELEIDINGSNIVEAU
go

if exists(select 1 from systypes where name='HUISNUMMER')
   drop type HUISNUMMER
go

if exists(select 1 from systypes where name='IS_GOEDGEKEURD')
   drop type IS_GOEDGEKEURD
go

if exists(select 1 from systypes where name='JAARTAL')
   drop type JAARTAL
go

if exists(select 1 from systypes where name='KWARTAAL')
   drop type KWARTAAL
go

if exists(select 1 from systypes where name='MODULE_ID')
   drop type MODULE_ID
go

if exists(select 1 from systypes where name='MODULE_NAAM')
   drop type MODULE_NAAM
go

if exists(select 1 from systypes where name='OPEN_INSCHRIJVING_')
   drop type OPEN_INSCHRIJVING_
go

if exists(select 1 from systypes where name='OPLEIDINGSNIVEAU')
   drop type OPLEIDINGSNIVEAU
go

if exists(select 1 from systypes where name='OPMERKING')
   drop type OPMERKING
go

if exists(select 1 from systypes where name='ORGANISATIENAAM')
   drop type ORGANISATIENAAM
go

if exists(select 1 from systypes where name='ORGANISATIENUMMER')
   drop type ORGANISATIENUMMER
go

if exists(select 1 from systypes where name='PLAATSNAAM')
   drop type PLAATSNAAM
go

if exists(select 1 from systypes where name='POSTCODE')
   drop type POSTCODE
go

if exists(select 1 from systypes where name='SECTOR_NAAM')
   drop type SECTOR_NAAM
go

if exists(select 1 from systypes where name='STARTTIJD')
   drop type STARTTIJD
go

if exists(select 1 from systypes where name='STATUS')
   drop type STATUS
go

if exists(select 1 from systypes where name='STRAATNAAM')
   drop type STRAATNAAM
go

if exists(select 1 from systypes where name='TELEFOONNUMMER')
   drop type TELEFOONNUMMER
go

if exists(select 1 from systypes where name='TYPE')
   drop type TYPE
go

if exists(select 1 from systypes where name='VOLGNUMMER')
   drop type VOLGNUMMER
go

if exists(select 1 from systypes where name='VOORNAAM')
   drop type VOORNAAM
go

if exists(select 1 from systypes where name='WORKSHOPLEIDER_ID')
   drop type WORKSHOPLEIDER_ID
go

if exists(select 1 from systypes where name='WORKSHOP_ID')
   drop type WORKSHOP_ID
go

/*==============================================================*/
/* Domain: AANHEF                                               */
/*==============================================================*/
create type AANHEF
   from varchar(4)
go

/*==============================================================*/
/* Domain: AANTAL_UUR                                           */
/*==============================================================*/
create type AANTAL_UUR
   from smallint
go

/*==============================================================*/
/* Domain: ACHTERNAAM                                           */
/*==============================================================*/
create type ACHTERNAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: ADVISEUR_ID                                          */
/*==============================================================*/
create type ADVISEUR_ID
   from int
go

/*==============================================================*/
/* Domain: CONTATPERSOON_ID                                     */
/*==============================================================*/
create type CONTATPERSOON_ID
   from int
go

/*==============================================================*/
/* Domain: DATUM                                                */
/*==============================================================*/
create type DATUM
   from datetime
go

/*==============================================================*/
/* Domain: DEELNEMER_ID                                         */
/*==============================================================*/
create type DEELNEMER_ID
   from int
go

/*==============================================================*/
/* Domain: EINDTIJD                                             */
/*==============================================================*/
create type EINDTIJD
   from datetime
go

/*==============================================================*/
/* Domain: EMAIL                                                */
/*==============================================================*/
create type EMAIL
   from varchar(256)
go

/*==============================================================*/
/* Domain: FUNCTIENAAM                                          */
/*==============================================================*/
create type FUNCTIENAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: GEBOORTEDATUM                                        */
/*==============================================================*/
create type GEBOORTEDATUM
   from datetime
go

/*==============================================================*/
/* Domain: GEWENST_BEGELEIDINGSNIVEAU                           */
/*==============================================================*/
create type GEWENST_BEGELEIDINGSNIVEAU
   from varchar(256)
go

/*==============================================================*/
/* Domain: HUISNUMMER                                           */
/*==============================================================*/
create type HUISNUMMER
   from varchar(8)
go

/*==============================================================*/
/* Domain: IS_GOEDGEKEURD                                       */
/*==============================================================*/
create type IS_GOEDGEKEURD
   from bit
go

/*==============================================================*/
/* Domain: JAARTAL                                              */
/*==============================================================*/
create type JAARTAL
   from smallint
go

/*==============================================================*/
/* Domain: KWARTAAL                                             */
/*==============================================================*/
create type KWARTAAL
   from char(1)
go

/*==============================================================*/
/* Domain: MODULE_ID                                            */
/*==============================================================*/
create type MODULE_ID
   from int
go

/*==============================================================*/
/* Domain: MODULE_NAAM                                          */
/*==============================================================*/
create type MODULE_NAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: OPEN_INSCHRIJVING_                                   */
/*==============================================================*/
create type OPEN_INSCHRIJVING_
   from bit
go

/*==============================================================*/
/* Domain: OPLEIDINGSNIVEAU                                     */
/*==============================================================*/
create type OPLEIDINGSNIVEAU
   from varchar(11)
go

/*==============================================================*/
/* Domain: OPMERKING                                            */
/*==============================================================*/
create type OPMERKING
   from varchar(255)
go

/*==============================================================*/
/* Domain: ORGANISATIENAAM                                      */
/*==============================================================*/
create type ORGANISATIENAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: ORGANISATIENUMMER                                    */
/*==============================================================*/
create type ORGANISATIENUMMER
   from varchar(15)
go

/*==============================================================*/
/* Domain: PLAATSNAAM                                           */
/*==============================================================*/
create type PLAATSNAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: POSTCODE                                             */
/*==============================================================*/
create type POSTCODE
   from varchar(12)
go

/*==============================================================*/
/* Domain: SECTOR_NAAM                                          */
/*==============================================================*/
create type SECTOR_NAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: STARTTIJD                                            */
/*==============================================================*/
create type STARTTIJD
   from datetime
go

/*==============================================================*/
/* Domain: STATUS                                               */
/*==============================================================*/
create type STATUS
   from varchar(256)
go

/*==============================================================*/
/* Domain: STRAATNAAM                                           */
/*==============================================================*/
create type STRAATNAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: TELEFOONNUMMER                                       */
/*==============================================================*/
create type TELEFOONNUMMER
   from varchar(256)
go

/*==============================================================*/
/* Domain: TYPE                                                 */
/*==============================================================*/
create type TYPE
   from varchar(3)
go

/*==============================================================*/
/* Domain: VOLGNUMMER                                           */
/*==============================================================*/
create type VOLGNUMMER
   from int
go

/*==============================================================*/
/* Domain: VOORNAAM                                             */
/*==============================================================*/
create type VOORNAAM
   from varchar(256)
go

/*==============================================================*/
/* Domain: WORKSHOPLEIDER_ID                                    */
/*==============================================================*/
create type WORKSHOPLEIDER_ID
   from int
go

/*==============================================================*/
/* Domain: WORKSHOP_ID                                          */
/*==============================================================*/
create type WORKSHOP_ID
   from int
go

/*==============================================================*/
/* Table: ADVISEUR                                              */
/*==============================================================*/
create table ADVISEUR (
   ADVISEUR_ID          ADVISEUR_ID          not null,
   ORGANISATIENUMMER    ORGANISATIENUMMER    not null,
   ATTRIBUTE_13         VOORNAAM             not null,
   ATTRIBUTE_14         ACHTERNAAM           not null,
   TELEFOONNUMMER       TELEFOONNUMMER       null,
   EMAIL                EMAIL                null,
   constraint PK_ADVISEUR primary key (ADVISEUR_ID)
)
go

/*==============================================================*/
/* Index: ADVISEUR_VAN_ORGANISATIE_FK                           */
/*==============================================================*/




create nonclustered index ADVISEUR_VAN_ORGANISATIE_FK on ADVISEUR (ORGANISATIENUMMER ASC)
go

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/
create table BESCHIKBAARHEID (
   WORKSHOPLEIDER_ID    WORKSHOPLEIDER_ID    not null,
   KWARTAAL             KWARTAAL             not null,
   JAAR                 JAARTAL              not null,
   AANTAL_UUR           AANTAL_UUR           not null,
   constraint PK_BESCHIKBAARHEID primary key (WORKSHOPLEIDER_ID, KWARTAAL, JAAR, AANTAL_UUR)
)
go

/*==============================================================*/
/* Index: BESCHIKBBAARHEID_VAN_WORKSHOPLEIDER_FK                */
/*==============================================================*/




create nonclustered index BESCHIKBBAARHEID_VAN_WORKSHOPLEIDER_FK on BESCHIKBAARHEID (WORKSHOPLEIDER_ID ASC)
go

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/
create table CONTACTPERSOON (
   CONTACTPERSOON_ID    CONTATPERSOON_ID     not null,
   ORGANISATIENUMMER    ORGANISATIENUMMER    not null,
   VOORNAAM             VOORNAAM             not null,
   ACHTERNAAM           ACHTERNAAM           not null,
   TELEFOONNUMMER       TELEFOONNUMMER       null,
   EMAIL                EMAIL                null,
   constraint PK_CONTACTPERSOON primary key (CONTACTPERSOON_ID)
)
go

/*==============================================================*/
/* Index: CONTACTPERSOON_VAN_ORGANISATIE_FK                     */
/*==============================================================*/




create nonclustered index CONTACTPERSOON_VAN_ORGANISATIE_FK on CONTACTPERSOON (ORGANISATIENUMMER ASC)
go

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/
create table DEELNEMER (
   DEELNEMER_ID         DEELNEMER_ID         not null,
   SECTOR_NAAM          SECTOR_NAAM          not null,
   ORGANISATIENUMMER    ORGANISATIENUMMER    null,
   AANHEF               AANHEF               not null,
   ATTRIBUTE_25         VOORNAAM             not null,
   ATTRIBUTE_26         ACHTERNAAM           not null,
   GEBOORTEDATUM        GEBOORTEDATUM        not null,
   EMAIL                EMAIL                not null,
   TELEFOONNUMMER       TELEFOONNUMMER       not null,
   OPLEIDINGSNIVEAU     OPLEIDINGSNIVEAU     not null,
   ORGANISATIE_VESTIGINGSPLAATS PLAATSNAAM           not null,
   ATTRIBUTE_58         OPEN_INSCHRIJVING_   not null,
   GEWENST_BEGELEIDINGSNIVEAU GEWENST_BEGELEIDINGSNIVEAU null,
   FUNCTIENAAM          FUNCTIENAAM          null,
   constraint PK_DEELNEMER primary key (DEELNEMER_ID)
)
go

/*==============================================================*/
/* Index: DEELNEMER_VAN_ORGANISATIE_FK                          */
/*==============================================================*/




create nonclustered index DEELNEMER_VAN_ORGANISATIE_FK on DEELNEMER (ORGANISATIENUMMER ASC)
go

/*==============================================================*/
/* Index: SECTOR_VAN_OPEN_INSCHRIJVING_DEELNEMER_FK             */
/*==============================================================*/




create nonclustered index SECTOR_VAN_OPEN_INSCHRIJVING_DEELNEMER_FK on DEELNEMER (SECTOR_NAAM ASC)
go

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/
create table DEELNEMER_IN_WORKSHOP (
   WORKSHOP_ID          WORKSHOP_ID          not null,
   DEELNEMER_ID         DEELNEMER_ID         not null,
   VOLGNUMMER           VOLGNUMMER           not null,
   IS_GOEDGEKEURD       IS_GOEDGEKEURD       not null,
   constraint PK_DEELNEMER_IN_WORKSHOP primary key (WORKSHOP_ID, DEELNEMER_ID)
)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_DEELNEMER_IN_WORKSHOP_FK                  */
/*==============================================================*/




create nonclustered index WORKSHOP_IN_DEELNEMER_IN_WORKSHOP_FK on DEELNEMER_IN_WORKSHOP (WORKSHOP_ID ASC)
go

/*==============================================================*/
/* Index: DEELNEMER_IN_DEELNEMER_IN_WORKSHOP_FK                 */
/*==============================================================*/




create nonclustered index DEELNEMER_IN_DEELNEMER_IN_WORKSHOP_FK on DEELNEMER_IN_WORKSHOP (DEELNEMER_ID ASC)
go

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/
create table MODULE (
   MODULE_NUMMER        MODULE_ID            not null,
   ATTRIBUTE_48         MODULE_NAAM          not null,
   constraint PK_MODULE primary key (MODULE_NUMMER)
)
go

/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
create table ORGANISATIE (
   ORGANISATIENUMMER    ORGANISATIENUMMER    not null,
   ORGANIATIENAAM       ORGANISATIENAAM      null,
   constraint PK_ORGANISATIE primary key (ORGANISATIENUMMER)
)
go

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
create table SECTOR (
   SECTOR_NAAM          SECTOR_NAAM          not null,
   constraint PK_SECTOR primary key (SECTOR_NAAM)
)
go

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/
create table WORKSHOP (
   WORKSHOP_ID          WORKSHOP_ID          not null,
   WORKSHOPLEIDER_ID    WORKSHOPLEIDER_ID    null,
   CONTACTPERSOON_ID    CONTATPERSOON_ID     null,
   ORGANISATIENUMMER    ORGANISATIENUMMER    null,
   MODULE_NUMMER        MODULE_ID            null,
   ADVISEUR_ID          ADVISEUR_ID          null,
   SECTOR_NAAM          SECTOR_NAAM          null,
   DATUM                DATUM                null,
   STARTTIJD            STARTTIJD            null,
   EINDTIJD             EINDTIJD             null,
   HUISNUMMER           HUISNUMMER           null,
   STRAATNAAM           STRAATNAAM           null,
   POSTCODE             POSTCODE             null,
   PLAATSNAAM           PLAATSNAAM           null,
   STATUS               STATUS               null,
   OPMERKING            OPMERKING            null,
   TYPE                 TYPE                 null,
   VERWERKT_BREIN       DATUM                null,
   DEELNEMER_GEGEGEVENS_ONTVANGEN DATUM                null,
   OVK_BEVESTIGING      DATUM                null,
   PRESENTIELIJST_VERSTUURD DATUM                null,
   PRESENTIELIJST_ONTVANGEN DATUM                null,
   BEWIJS_DEELNAME_MAIL_SBB_WSL DATUM                null,
   constraint PK_WORKSHOP primary key (WORKSHOP_ID)
)
go

/*==============================================================*/
/* Index: WORKSHOPLEIDER_VAN_WORKSHOP_FK                        */
/*==============================================================*/




create nonclustered index WORKSHOPLEIDER_VAN_WORKSHOP_FK on WORKSHOP (WORKSHOPLEIDER_ID ASC)
go

/*==============================================================*/
/* Index: WORKSHOP_IN_SECTOR_FK                                 */
/*==============================================================*/




create nonclustered index WORKSHOP_IN_SECTOR_FK on WORKSHOP (SECTOR_NAAM ASC)
go

/*==============================================================*/
/* Index: MODULE_VAN_WORKSHOP_FK                                */
/*==============================================================*/




create nonclustered index MODULE_VAN_WORKSHOP_FK on WORKSHOP (MODULE_NUMMER ASC)
go

/*==============================================================*/
/* Index: ORGANISATIE_VAN_WORKSHOP_FK                           */
/*==============================================================*/




create nonclustered index ORGANISATIE_VAN_WORKSHOP_FK on WORKSHOP (ORGANISATIENUMMER ASC)
go

/*==============================================================*/
/* Index: CONTACTPERSOON_VAN_WORKSHOP_FK                        */
/*==============================================================*/




create nonclustered index CONTACTPERSOON_VAN_WORKSHOP_FK on WORKSHOP (CONTACTPERSOON_ID ASC)
go

/*==============================================================*/
/* Index: ADVISEUR_VAN_WORKSHOP_FK                              */
/*==============================================================*/




create nonclustered index ADVISEUR_VAN_WORKSHOP_FK on WORKSHOP (ADVISEUR_ID ASC)
go

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/
create table WORKSHOPLEIDER (
   WORKSHOPLEIDER_ID    WORKSHOPLEIDER_ID    not null,
   ATTRIBUTE_8          VOORNAAM             not null,
   AVOORNAAMTTRIBUTE_9  ACHTERNAAM           not null,
   constraint PK_WORKSHOPLEIDER primary key (WORKSHOPLEIDER_ID)
)
go

alter table ADVISEUR
   add constraint FK_ADVISEUR_ADVISEUR__ORGANISA foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table BESCHIKBAARHEID
   add constraint FK_BESCHIKB_BESCHIKBB_WORKSHOP foreign key (WORKSHOPLEIDER_ID)
      references WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
go

alter table CONTACTPERSOON
   add constraint FK_CONTACTP_CONTACTPE_ORGANISA foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table DEELNEMER
   add constraint FK_DEELNEME_DEELNEMER_ORGANISA foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table DEELNEMER
   add constraint FK_DEELNEME_SECTOR_VA_SECTOR foreign key (SECTOR_NAAM)
      references SECTOR (SECTOR_NAAM)
go

alter table DEELNEMER_IN_WORKSHOP
   add constraint FK_DEELNEME_DEELNEMER_DEELNEME foreign key (DEELNEMER_ID)
      references DEELNEMER (DEELNEMER_ID)
go

alter table DEELNEMER_IN_WORKSHOP
   add constraint FK_DEELNEME_WORKSHOP__WORKSHOP foreign key (WORKSHOP_ID)
      references WORKSHOP (WORKSHOP_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ADVISEUR__ADVISEUR foreign key (ADVISEUR_ID)
      references ADVISEUR (ADVISEUR_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_CONTACTPE_CONTACTP foreign key (CONTACTPERSOON_ID)
      references CONTACTPERSOON (CONTACTPERSOON_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_MODULE_VA_MODULE foreign key (MODULE_NUMMER)
      references MODULE (MODULE_NUMMER)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_ORGANISAT_ORGANISA foreign key (ORGANISATIENUMMER)
      references ORGANISATIE (ORGANISATIENUMMER)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_WORKSHOPL_WORKSHOP foreign key (WORKSHOPLEIDER_ID)
      references WORKSHOPLEIDER (WORKSHOPLEIDER_ID)
go

alter table WORKSHOP
   add constraint FK_WORKSHOP_WORKSHOP__SECTOR foreign key (SECTOR_NAAM)
      references SECTOR (SECTOR_NAAM)
go

