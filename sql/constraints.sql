USE [UnitTesting SBB]
GO

SELECT *
FROM WORKSHOP
WHERE TYPE = 'INC'

ALTER TABLE WORKSHOP
ADD CONSTRAINT CK_WorkshopTypes	CHECK(TYPE IN ('INC', 'IND', 'COM', 'ROC', 'LA'))



USE [UnitTesting COURSE]

EXEC tSQLt.NewTestClass 'testWorkshop';

GO
ALTER PROCEDURE [testEmployeeCheckConstraint].[test op president met zijn salaris]
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
	values(null,null,'MANAGER',null,null,null,null,null,null); 
END
GO

EXEC [tSQLt].[Run] '[testEmployeeCheckConstraints].[test op president met zijn salaris]'

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


