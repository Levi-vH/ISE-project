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

-- creating domain types for all the columns in the database
DROP TYPE IF EXISTS Workshop_ID
CREATE TYPE Workshop_ID FROM INT

DROP TYPE IF EXISTS Deelnemer_ID
CREATE TYPE Deelnemer_ID FROM INT

DROP TYPE IF EXISTS Adviseur_ID
CREATE TYPE Adviseur_ID FROM INT

DROP TYPE IF EXISTS WorkshopLeider_ID
CREATE TYPE WorkshopLeider_ID FROM INT

DROP TYPE IF EXISTS Contactpersoon_ID
CREATE TYPE Contactpersoon_ID FROM INT

DROP TYPE IF EXISTS Organisatienummer
CREATE TYPE Organisatienummer FROM VARCHAR(15)

DROP TYPE IF EXISTS Organisatienaam
CREATE TYPE Organisatienaam FROM VARCHAR(60)

DROP TYPE IF EXISTS Datum
CREATE TYPE Datum FROM DATE

DROP TYPE IF EXISTS Starttijd
CREATE TYPE Starttijd FROM TIME

DROP TYPE IF EXISTS Eindtijd
CREATE TYPE Eindtijd FROM TIME
 
DROP TYPE IF EXISTS Adres
CREATE TYPE Adres FROM VARCHAR(60)

DROP TYPE IF EXISTS Postcode
CREATE TYPE Postcode FROM VARCHAR(20)

DROP TYPE IF EXISTS Plaatsnaam
CREATE TYPE Plaatsnaam FROM VARCHAR(60)

DROP TYPE IF EXISTS [Status]
CREATE TYPE [Status] FROM VARCHAR(20)

DROP TYPE IF EXISTS Opmerking
CREATE TYPE Opmerking FROM VARCHAR(255)

DROP TYPE IF EXISTS [Type]
CREATE TYPE [Type] FROM VARCHAR(3)

DROP TYPE IF EXISTS Voornaam
CREATE TYPE Voornaam FROM VARCHAR(30)

DROP TYPE IF EXISTS Achternaam
CREATE TYPE Achternaam FROM VARCHAR(50)

DROP TYPE IF EXISTS Naam
CREATE TYPE Naam FROM VARCHAR(52)

DROP TYPE IF EXISTS Kwartaal
CREATE TYPE Kwartaal FROM CHAR(1)

DROP TYPE IF EXISTS Jaar
CREATE TYPE Jaar FROM SMALLINT

DROP TYPE IF EXISTS AantalUur
CREATE TYPE AantalUur FROM SMALLINT

DROP TYPE IF EXISTS Aanhef
CREATE TYPE Aanhef FROM VARCHAR(7)

DROP TYPE IF EXISTS Geboortedatum
CREATE TYPE Geboortedatum FROM DATE

DROP TYPE IF EXISTS Email
CREATE TYPE Email FROM VARCHAR(100) 

DROP TYPE IF EXISTS Telefoonnummer
CREATE TYPE Telefoonnummer FROM VARCHAR(12)

DROP TYPE IF EXISTS Opleidinsniveau
CREATE TYPE Opleidinsniveau FROM VARCHAR(100)

DROP TYPE IF EXISTS GewenstBegeleidingsniveau
CREATE TYPE GewenstBegeleidingsniveau FROM VARCHAR(100)

DROP TYPE IF EXISTS Sectornaam
CREATE TYPE Sectornaam FROM VARCHAR(20)

DROP TYPE IF EXISTS Toevoeging
CREATE TYPE Toevoeging FROM TINYINT
--
DROP TYPE IF EXISTS IsOpenInschrijving
CREATE TYPE IsOpenInschrijving FROM BIT

DROP TYPE IF EXISTS FunctieNaam
CREATE TYPE FunctieNaam	FROM VARCHAR(50)

DROP TYPE IF EXISTS ModuleNummer
CREATE TYPE ModuleNummer FROM INT

DROP TYPE IF EXISTS ModuleNaam
CREATE TYPE ModuleNaam FROM VARCHAR(75)

DROP TYPE IF EXISTS Volgnummer
CREATE TYPE Volgnummer FROM INT

DROP TYPE IF EXISTS IsGoedgekeurd
CREATE TYPE IsGoedgekeurd FROM BIT

DROP TYPE IF EXISTS Aanvraag_ID
CREATE TYPE Aanvraag_ID FROM INT

DROP TYPE IF EXISTS AanvraagDatum
CREATE TYPE AanvraagDatum FROM DATETIME

DROP TYPE IF EXISTS Groep_ID
CREATE TYPE Groep_ID FROM INT

DROP TYPE IF EXISTS Voorkeur
CREATE TYPE Voorkeur FROM VARCHAR(20)


GO
/*==============================================================*/
/* Table: PLANNER                                                */
/*==============================================================*/
CREATE TABLE PLANNER (
	PLANNERNAAM		Naam		NOT NULL,
	CONSTRAINT PK_PLANNER PRIMARY KEY (PLANNERNAAM)
)
GO

/*==============================================================*/
/* Table: SECTOR                                                */
/*==============================================================*/
CREATE TABLE SECTOR (
   SECTORNAAM          Sectornaam	         NOT NULL,
   CONSTRAINT PK_SECTOR PRIMARY KEY (SECTORNAAM)
)
GO

/*==============================================================*/
/* Table: ORGANISATIE                                           */
/*==============================================================*/
CREATE TABLE ORGANISATIE (
   ORGANISATIENUMMER     Organisatienummer   NOT NULL,
   ORGANISATIENAAM       Organisatienaam     NOT NULL,
   ADRES				 Adres		         NOT NULL,
   POSTCODE				 Postcode	         NOT NULL,
   PLAATSNAAM			 Plaatsnaam	         NOT NULL,
   CONSTRAINT PK_ORGANISATIE PRIMARY KEY (ORGANISATIENUMMER)
)
GO

/*==============================================================*/
/* Table: ADVISEUR                                              */
/*==============================================================*/
CREATE TABLE ADVISEUR (
   ADVISEUR_ID          Adviseur_ID IDENTITY    NOT NULL,
   ORGANISATIENUMMER    Organisatienummer		NOT NULL,
   SECTORNAAM			Sectornaam				NOT NULL,
   VOORNAAM				Voornaam			    NOT NULL,
   ACHTERNAAM			Achternaam				NOT NULL,
   TELEFOONNUMMER       Telefoonnummer			NULL,
   EMAIL                Email					NULL,
   CONSTRAINT PK_ADVISEUR PRIMARY KEY (ADVISEUR_ID)
)
GO

/*==============================================================*/
/* Table: CONTACTPERSOON                                        */
/*==============================================================*/
CREATE TABLE CONTACTPERSOON (
   CONTACTPERSOON_ID    Contactpersoon_ID IDENTITY  NOT NULL,
   ORGANISATIENUMMER    Organisatienummer			NOT NULL,
   VOORNAAM             Voornaam					NOT NULL,
   ACHTERNAAM           Achternaam					NOT NULL,
   TELEFOONNUMMER       Telefoonnummer				NULL,
   EMAIL                Email						NULL,
   CONSTRAINT PK_CONTACTPERSOON PRIMARY KEY (CONTACTPERSOON_ID)
)
GO

/*==============================================================*/
/* Table: WORKSHOPLEIDER                                        */
/*==============================================================*/
CREATE TABLE WORKSHOPLEIDER (
   WORKSHOPLEIDER_ID    WorkshopLeider_ID IDENTITY  NOT NULL,
   VOORNAAM				Voornaam			        NOT NULL,
   ACHTERNAAM			Achternaam					NOT NULL,
   TOEVOEGING			Toevoeging					NULL,
   CONSTRAINT PK_WORKSHOPLEIDER PRIMARY KEY (WORKSHOPLEIDER_ID)
)
GO

/*==============================================================*/
/* Table: BESCHIKBAARHEID                                       */
/*==============================================================*/
CREATE TABLE BESCHIKBAARHEID (
   WORKSHOPLEIDER_ID    WorkshopLeider_ID			         NOT NULL,
   KWARTAAL             Kwartaal             NOT NULL,
   JAAR                 Jaar	             NOT NULL,
   AANTAL_UUR           AantalUur            NOT NULL,
   CONSTRAINT PK_BESCHIKBAARHEID PRIMARY KEY (WORKSHOPLEIDER_ID, KWARTAAL, JAAR, AANTAL_UUR)
)
GO

/*==============================================================*/
/* Table: DEELNEMER                                             */
/*==============================================================*/
CREATE TABLE DEELNEMER (
   DEELNEMER_ID					Deelnemer_ID IDENTITY		NOT NULL,
   ORGANISATIENUMMER			Organisatienummer			NOT NULL,
   AANHEF						Aanhef						NULL,
   VOORNAAM						Voornaam					NOT NULL,
   ACHTERNAAM					Achternaam					NOT NULL,
   GEBOORTEDATUM				Geboortedatum				NOT NULL,
   EMAIL						Email						NULL,
   TELEFOONNUMMER				telefoonnummer				NULL,
   OPLEIDINGSNIVEAU				Opleidinsniveau				NOT NULL,
   IS_OPEN_INSCHRIJVING         IsOpenInschrijving		NOT NULL,
   GEWENST_BEGELEIDINGSNIVEAU	GewenstBegeleidingsniveau	NULL,
   FUNCTIENAAM					Functienaam					NULL,
   SECTORNAAM					Sectornaam					NULL,
   CONSTRAINT PK_DEELNEMER PRIMARY KEY (DEELNEMER_ID)
)
GO

/*==============================================================*/
/* Table: MODULE                                                */
/*==============================================================*/
CREATE TABLE MODULE (
   MODULENUMMER       ModuleNummer       NOT NULL,
   MODULENAAM         ModuleNaam         NOT NULL,
   CONSTRAINT PK_MODULE PRIMARY KEY (MODULENUMMER)
)
GO

/*==============================================================*/
/* Table: WORKSHOP                                              */
/*==============================================================*/
CREATE TABLE WORKSHOP (
   WORKSHOP_ID						Workshop_ID IDENTITY NOT NULL,
   WORKSHOPLEIDER_ID				WorkshopLeider_ID    NULL,
   CONTACTPERSOON_ID				Contactpersoon_ID    NULL,
   ORGANISATIENUMMER				Organisatienummer    NULL,
   MODULENUMMER						ModuleNummer         NULL,
   ADVISEUR_ID						Adviseur_ID          NULL,
   SECTORNAAM						Sectornaam           NULL,
   DATUM							Datum	             NULL,
   STARTTIJD						Starttijd            NULL,
   EINDTIJD							Eindtijd             NULL,
   ADRES							Adres		         NULL,
   POSTCODE							Postcode             NULL,
   PLAATSNAAM						Plaatsnaam           NULL,
   [STATUS]							[Status]             NULL,
   OPMERKING						Opmerking	         NULL,
   [TYPE]							[Type]	             NULL,
   VERWERKT_BREIN					Datum	             NULL,
   DEELNEMER_GEGEVENS_ONTVANGEN		Datum	             NULL,
   OVK_BEVESTIGING					Datum	             NULL,
   PRESENTIELIJST_VERSTUURD			Datum	             NULL,
   PRESENTIELIJST_ONTVANGEN			Datum	             NULL,
   BEWIJS_DEELNAME_MAIL_SBB_WSL		Datum	             NULL,
   CONSTRAINT PK_WORKSHOP PRIMARY KEY (WORKSHOP_ID)
)
GO

/*==============================================================*/
/* Table: DEELNEMER_IN_WORKSHOP                                 */
/*==============================================================*/
CREATE TABLE DEELNEMER_IN_WORKSHOP (
   WORKSHOP_ID          Workshop_ID			 NOT NULL,
   DEELNEMER_ID         Deelnemer_ID         NOT NULL,
   VOLGNUMMER           Volgnummer           NOT NULL,
   IS_GOEDGEKEURD       IsGoedgekeurd        NOT NULL,
   CONSTRAINT PK_DEELNEMER_IN_WORKSHOP PRIMARY KEY (WORKSHOP_ID, DEELNEMER_ID)
)
GO

/*==============================================================*/
/* Table: AANVRAAG		                                        */
/*==============================================================*/
CREATE TABLE AANVRAAG (
   AANVRAAG_ID		    Aanvraag_ID IDENTITY NOT NULL,
   ORGANISATIENUMMER	Organisatienummer	 NOT NULL,
   CONTACTPERSOON_ID	Contactpersoon_ID    NOT NULL,
   ADVISEUR_ID			Adviseur_ID	         NOT NULL,
   PLANNERNAAM			Naam				 NOT NULL,
   AANVRAAG_DATUM		AanvraagDatum		 DEFAULT GETDATE(),
   CONSTRAINT PK_AANVRAAG PRIMARY KEY (AANVRAAG_ID)
)
GO

/*==============================================================*/
/* Table: GROEP													*/
/*==============================================================*/
CREATE TABLE GROEP (
   GROEP_ID				Groep_ID IDENTITY		 NOT NULL,
   AANVRAAG_ID			Aanvraag_ID				 NOT NULL,
   CONTACTPERSOON_ID	Contactpersoon_ID		 NOT NULL,
   ADRES				Adres					 NOT NULL,
   CONSTRAINT PK_GROEP PRIMARY KEY (GROEP_ID)
)
GO

/*==============================================================*/
/* Table: DEELNEMER_IN_AANVRAAG                                 */
/*==============================================================*/
CREATE TABLE DEELNEMER_IN_AANVRAAG (
   AANVRAAG_ID          Aanvraag_ID	         NOT NULL,
   DEELNEMER_ID         Deelnemer_ID         NOT NULL,
   GROEP_ID				Groep_ID			 NULL
   CONSTRAINT PK_DEELNEMER_IN_AANVRAAG PRIMARY KEY (AANVRAAG_ID, DEELNEMER_ID)
)
GO

/*==============================================================*/
/* Table: MODULE_VAN_GROEP		                                */
/*==============================================================*/
CREATE TABLE MODULE_VAN_GROEP (
   GROEP_ID				Groep_ID			 NOT NULL,
   MODULENUMMER			ModuleNummer		 NOT NULL,
   VOORKEUR				Voorkeur			 NOT NULL, -- VOORKEUR_DAGDEEL
   VOORKEUR_DATUM		Voorkeur			 NOT NULL,
   STARTTIJD			Starttijd			 NULL,
   EINDTIJD				Eindtijd			 NULL
   CONSTRAINT PK_MODULE_VAN_GROEP PRIMARY KEY (GROEP_ID, MODULENUMMER)
)
GO

-- creating all the foreign key relations
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

ALTER TABLE GROEP
   ADD CONSTRAINT FK_GROEP_ref_AANVRAAG FOREIGN KEY (AANVRAAG_ID)
      REFERENCES AANVRAAG (AANVRAAG_ID)
GO

ALTER TABLE GROEP
   ADD CONSTRAINT FK_GROEP_ref_CONTACTPERSOON FOREIGN KEY (CONTACTPERSOON_ID)
      REFERENCES CONTACTPERSOON (CONTACTPERSOON_ID)
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
	ADD CONSTRAINT FK_AANVRAAG_ref_PLANNER FOREIGN KEY (PLANNERNAAM) 
	REFERENCES PLANNER(PLANNERNAAM)
GO

ALTER TABLE AANVRAAG
	ADD CONSTRAINT FK_AANVRAAG_ref_ORGANISATIE FOREIGN KEY (ORGANISATIENUMMER) 
	REFERENCES ORGANISATIE(ORGANISATIENUMMER)
GO

ALTER TABLE DEELNEMER_IN_AANVRAAG
	ADD CONSTRAINT FK_DEELNEMER_IN_AANVRAAG_ref_AANVRAAG FOREIGN KEY (AANVRAAG_ID) 
	REFERENCES AANVRAAG(AANVRAAG_ID)
GO

ALTER TABLE DEELNEMER_IN_AANVRAAG
	ADD CONSTRAINT FK_DEELNEMER_IN_AANVRAAG_ref_DEELNEMER FOREIGN KEY (DEELNEMER_ID) 
	REFERENCES DEELNEMER(DEELNEMER_ID)
GO

ALTER TABLE DEELNEMER_IN_AANVRAAG
	ADD CONSTRAINT FK_DEELNEMER_IN_AANVRAAG_ref_GROEP FOREIGN KEY (GROEP_ID) 
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