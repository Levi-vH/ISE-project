USE [SBBWorkshopOmgeving]
GO

ALTER TABLE WORKSHOP
DROP CONSTRAINT IF EXISTS CK_WorkshopTypes
GO

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopTypes	CHECK(TYPE IN ('INC', 'IND', 'COM', 'ROC', 'LA'))



USE [UnitTesting SBB]

EXEC tSQLt.NewTestClass 'testWorkshop';

GO
ALTER PROCEDURE [testWorkshop].[test op workshop types]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.WORKSHOP'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.WORKSHOP', @ConstraintName = 'CK_WorkshopTypes';

	EXEC tSQLt.ExpectNoException
	--actie
	insert into WORKSHOP([WORKSHOP_ID], [WORKSHOPLEIDER_ID], [CONTACTPERSOON_ID], [ORGANISATIENUMMER],
	 [MODULE_NUMMER], [ADVISEUR_ID], [SECTOR_NAAM], [DATUM], [STARTTIJD], [EINDTIJD], [HUISNUMMER], [STRAATNAAM],
	  [POSTCODE], [PLAATSNAAM], [STATUS], [OPMERKING], [TYPE], [VERWERKT_BREIN], [DEELNEMER_GEGEGEVENS_ONTVANGEN],
	   [OVK_BEVESTIGING], [PRESENTIELIJST_VERSTUURD], [PRESENTIELIJST_ONTVANGEN], [BEWIJS_DEELNAME_MAIL_SBB_WSL])
	values(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'INC', NULL, NULL, NULL, NULL, NULL, NULL); 
END
GO

EXEC [tSQLt].[Run] '[testWorkshop].[test op workshop types]'

USE [UnitTesting COURSE]

GO
CREATE PROCEDURE [testEmployeeCheckConstraints].[test op president met zijn salaris2]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.emp'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.emp', @ConstraintName = 'CK_emp_President_Salary';

	EXEC tSQLt.ExpectNoException
	--actie
	insert into emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	values(null,null,'PRESIDENT',null,null,null,10001,null,null); 
END
GO

EXEC [tSQLt].[Run] '[testEmployeeCheckConstraints].[test op president met zijn salaris2]'


USE [UnitTesting COURSE]

GO
CREATE PROCEDURE [testEmployeeCheckConstraints].[test op president met zijn salaris3]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.emp'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.emp', @ConstraintName = 'CK_emp_President_Salary';

	EXEC tSQLt.ExpectException
	--actie
	insert into emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	values(null,null,'PRESIDENT',null,null,null,10000,null,null); 
END
GO

EXEC [tSQLt].[Run] '[testEmployeeCheckConstraints].[test op president met zijn salaris3]'


GO
CREATE PROCEDURE [testEmployeeCheckConstraints].[test op president met zijn salaris4]
AS
BEGIN
	--voorbereiden
		--faken van de tabel, strippen van alle constraints, lege tabel
	EXEC tSQLt.FakeTable @Tablename = 'dbo.emp'; --dbo is het default schema igv create table 
	--nu de te testen constraint er weer opzetten, deze bestaat namelijk al
	EXEC tSQLt.ApplyConstraint @Tablename = 'dbo.emp', @ConstraintName = 'CK_emp_President_Salary';

	EXEC tSQLt.ExpectException
	--actie
	insert into emp(empno,ename,job,born,hired,sgrade,msal,username,deptno)
	values(null,null,'PRESIDENT',null,null,null,9999,null,null); 
END
GO


EXEC [tSQLt].[Run] '[testEmployeeCheckConstraints].[test op president met zijn salaris4]'


