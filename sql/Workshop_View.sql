USE SBBWorkshopOmgeving
GO

CREATE VIEW vw_workshops
AS
SELECT W.TYPE,W.DATUM, STARTTIJD, EINDTIJD, W.ADRES, W.POSTCODE, W.PLAATSNAAM, STATUS, OPMERKING, VERWERKT_BREIN,DEELNEMER_GEGEGEVENS_ONTVANGEN,OVK_BEVESTIGING,
PRESENTIELIJST_VERSTUURD, PRESENTIELIJST_ONTVANGEN, BEWIJS_DEELNAME_MAIL_SBB_WSL, O.ORGANISATIENAAM, M.MODULENAAM, WL.VOORNAAM AS WORKSHOPLEIDER_VOORNAAM
, WL.ACHTERNAAM AS WORKSHOPLEIDER_ACHTERNAAM, WL.TOEVOEGING,
A.VOORNAAM AS ADVISEUR_VOORNAAM, A.ACHTERNAAM AS ADVISEUR_ACHTERNAAM, A.TELEFOONNUMMER AS ADVISEUR_TELEFOON_NUMMER, A.EMAIL AS ADVISEUR_EMAIL,
C.VOORNAAM AS CONTACTPERSOON_VOORNAAM, C.ACHTERNAAM AS CONTACTPERSOON_ACHTERNAAM, C.TELEFOONNUMMER AS CONTACTPERSON_TELEFOONNUMMER,
C.EMAIL AS CONTACTPERSOON_EMAIL, (SELECT COUNT(*) FROM DEELNEMER_IN_WORKSHOP WHERE WORKSHOP_ID = W.WORKSHOP_ID) AS AANTAL_DEELNEMERS FROM WORKSHOP W
INNER JOIN ORGANISATIE O ON W.ORGANISATIENUMMER = O.ORGANISATIENUMMER
INNER JOIN MODULE M ON W.MODULENUMMER = M.MODULENUMMER
INNER JOIN WORKSHOPLEIDER WL ON  W.WORKSHOPLEIDER_ID = WL.WORKSHOPLEIDER_ID
INNER JOIN ADVISEUR A ON W.ADVISEUR_ID = A.ADVISEUR_ID
INNER JOIN CONTACTPERSOON C ON W.CONTACTPERSOON_ID = C.CONTACTPERSOON_ID

GO

SELECT * FROM DEELNEMER

INSERT INTO WORKSHOP VALUES (1,1,1,1,1,'Handel', GETDATE() , '12:00:00', '14:00:00', 'Wegstraat 1','5123 XD', 'Nijmegen', 'uitgezet', null, 'INC', null,null,null,null,null,null)

SELECT * FROM DEELNEMER_IN_WORKSHOP

INSERT INTO DEELNEMER_IN_WORKSHOP
			VALUES
			(1,2,1,1),
			(1,5,2,1),
			(1,151,3,1),
			(1,65,4,1),
			(1,213,5,1),
			(1,88,6,1)