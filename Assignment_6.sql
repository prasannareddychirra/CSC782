ALTER TABLE Employee DROP CONSTRAINT chk_min_sal;
ALTER TABLE Department DROP CONSTRAINT MIDFkey;

drop table Employee;
drop table Department;
-----------------------------------------------------------
create table Employee (
ID NUMBER PRIMARY KEY,
name VARCHAR2(20),
salary NUMBER,
deptName VARCHAR2(20) NULL,
CONSTRAINT chk_min_sal CHECK (deptName <> 'HR' OR salary >= 20000)
);
------------------------------------------------------------------
create table Department (
name VARCHAR2(20) PRIMARY KEY,
managerID NUMBER NULL,
CONSTRAINT MIDFkey FOREIGN KEY (managerID) references Employee(ID)
ON DELETE SET NULL
);
-------------------------------------------------------------------
insert into Employee values ('123', 'jOhn','56000','RD');
insert into Employee values ('578', 'Robert','37500','HR');
insert into Employee values ('666', 'Jenny','46000','HR');
insert into Employee values ('222', 'Christ','39000','SALES');
insert into Employee values ('888', 'Bill','50000','RD');
insert into Employee values ('101', 'Susan','67500','RD');

insert into Department values ('HR', '');
insert into Department values ('RD', '');
insert into Department values ('SALES', '');
insert into Department values ('HR', '');
insert into Department values ('RD', '');
insert into Department values ('SALES', '');
----------------------------------------------------------------------------
SELECT * FROM Department;
SELECT * FROM Employee;
----------------------------------------------------------------------------
UPDATE Department SET managerID=666 WHERE name ='HR';
UPDATE Department SET managerID=888 WHERE name ='RD';
UPDATE Department SET managerID=222 WHERE name ='SALES';
-----------------------------------------------------------------------------
--Should declare all constraints (e.g., triggers, foreign key constraints, check constraints) before any data change on the tables happens. The purpose of declaring #constraints (including constraints implemented by triggers) is to make sure no data in the database violates any constraint. If we insert/update data into the #database before declaring constraints, there is no way to guarantee that the data is valid and satisfy the constraints
ALTER TABLE Employee ADD CONSTRAINT fkeydeptName FOREIGN KEY (deptName) references Department(name)
ON DELETE SET NULL;
--Trigger
create trigger nameUpdate_department_trigger1
after update on Department
referencing 
 new as newname
 old as oldname
for each row when (newname.name<>oldname.name)
 begin
 update employee set deptname=:newname.name where deptname=:oldname.name;
 end;
/
update Department set name='RESEARCH' where name='RD';
SELECT * FROM Employee;
SELECT * FROM Department;
---------------------------------2ND Question-----------------------------------
insert into Employee values ('777', 'MIKE','18000','HR');
---It will throw error as HR salary is not greater than equal to 20000, which is mentioned in the question and row will not be inserted
--- People who work in the HR department always earn at least 20,000 dollars.
SELECT * FROM Employee;
--- Confirming by checking the employee table 
------------------------3RD Question--------------------------------------------
DELETE FROM Department Where name ='SALES';
SELECT * FROM Department;
SELECT * FROM Employee;
--It will delete the row from the department and make the deptname in employee as null value for that record where dept name is SALES.
--This is because the contsraint fkeydeptName key is created where dept_name in employee table refer name in the department table.
--------------------------4TH Question------------------------------------------
DELETE FROM Employee where ID= 666;
SELECT * FROM Employee;
SELECT * FROM Department;
--It will delete the row from the employee and make manager ID null value in department table
--this is because the contsraint MIDFkey key is created where manager ID in DEPARTMENT table refer or points to ID in the EMPLOYEE table.