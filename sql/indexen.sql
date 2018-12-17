/* =================================================================
   Author: Mark
   Create date: 17-12-2018
   Description: this script is used to create indexes for the
   'SBBWorkshopOmgeving' database
   --------------------------------
   Modified by:
   Modifications made by :
   ================================================================ */

USE SBBWorkshopOmgeving
GO

/*==============================================================*/
/* SP Type: SELECT                                              */
/*==============================================================*/

-- index(es) for SP_get_workshops
CREATE NONCLUSTERED INDEX ID_get_workshops_ON_ORGANISATIE
ON ORGANISATIE (ORGANISATIENUMMER)
INCLUDE (ORGANISATIENAAM)

-- index(es) for SP_get_workshoprequests
CREATE NONCLUSTERED INDEX ID_get_workshopsrequests_ON_ORGANISATIE
ON ORGANISATIE (ORGANISATIENUMMER)
INCLUDE (ORGANISATIENAAM)

-- index(es) for SP_get_group_ids
CREATE NONCLUSTERED INDEX ID_get_groups_ON_GROEP
ON GROEP (AANVRAAG_ID)
INCLUDE (GROEP_ID)

-- index(es) for SP_get_row_numbers_of_group_ids
/*
index 'ID_get_group_ids_ON_GROEP' can be used for this SP
*/

-- index(es) for SP_get_groups
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_get_module_information_of_group
CREATE NONCLUSTERED INDEX ID_get_module_information_of_group_ON_MODULE_VAN_GROEP
ON MODULE_VAN_GROEP (GROEP_ID, MODULENUMMER)
INCLUDE (VOORKEUR, DATUM, STARTTIJD, EINDTIJD)

-- index(es) for SP_get_information_of_group
CREATE NONCLUSTERED INDEX ID_get_information_of_group_ON_MODULE_VAN_GROEP
ON MODULE_VAN_GROEP (GROEP_ID)

-- index(es) for SP_get_modulenumbers
CREATE NONCLUSTERED INDEX ID_get_modulenumbers_ON_MODULE_VAN_GROEP
ON MODULE_VAN_GROEP (GROEP_ID)
INCLUDE (MODULENUMMER)

-- index(es) for SP_get_list_of_approved_workshop_participants
CREATE NONCLUSTERED INDEX ID_get_list_of_approved_workshop_participants_ON_DEELNEMER
ON DEELNEMER (DEELNEMER_ID)
INCLUDE (VOORNAAM, ACHTERNAAM)

CREATE NONCLUSTERED INDEX ID_get_list_of_approved_workshop_participants_ON_DEELNEMER_IN_WORKSHOP
ON DEELNEMER_IN_WORKSHOP (IS_GOEDGEKEURD, WORKSHOP_ID)
INCLUDE (VOLGNUMMER)

-- index(es) for SP_get_reservelist_of_approved_workshop_participants
/*
indexes 'ID_get_list_of_approved_workshop_participants_ON_DEELNEMER'
and 'ID_get_list_of_approved_workshop_participants_ON_DEELNEMER_IN_WORKSHOP'
can be used for this SP
*/

-- index(es) for SP_get_list_of_to_approve_workshop_participants
/*
indexes 'ID_get_list_of_approved_workshop_participants_ON_DEELNEMER'
and 'ID_get_list_of_approved_workshop_participants_ON_DEELNEMER_IN_WORKSHOP'
can be used for this SP
*/

-- index(es) for SP_get_participants_of_workshoprequest
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_get_participants_of_workshoprequest_without_group
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_get_participants_of_group
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_get_workshops_for_workshopleader
CREATE NONCLUSTERED INDEX ID_get_workshops_for_workshopleader_ON_WORKSHOP
ON WORKSHOP (WORKSHOPLEIDER_ID)
INCLUDE (WORKSHOP_ID)

-- index(es) for SP_get_workshops_for_sector
CREATE NONCLUSTERED INDEX ID_get_workshops_for_sector_ON_WORKSHOP
ON WORKSHOP (SECTORNAAM)
INCLUDE (WORKSHOP_ID)

-- index(es) for SP_get_cancelled_workshops
CREATE NONCLUSTERED INDEX ID_get_cancelled_workshops_ON_WORKSHOP
ON WORKSHOP ([STATUS])
INCLUDE (WORKSHOP_ID)

/*==============================================================*/
/* SP Type: UPDATE                                              */
/*==============================================================*/

-- index(es) for SP_approve_participant_of_workshop
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_alter_workshop
CREATE NONCLUSTERED INDEX ID_alter_workshop_ON_WORKSHOP
ON WORKSHOP (WORKSHOP_ID)
INCLUDE	(
		[TYPE],
		DATUM,
		MODULENUMMER,
		ORGANISATIENUMMER,
		SECTORNAAM,
		STARTTIJD,
		EINDTIJD,
		ADRES,
		POSTCODE,
		PLAATSNAAM,
		WORKSHOPLEIDER_ID,
		OPMERKING
		)

-- index(es) for SP_add_participant_to_group
/*
no indexes are necessary for this SP
*/

-- index(es) for SP_remove_participant_from_group
/*
no indexes are necessary for this SP
*/