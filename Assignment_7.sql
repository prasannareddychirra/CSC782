--------------------Droping the Tables if already existed---------------------------------
drop table CoursesSpring2021;
drop table CoursesDescription;

------------------------------------- 1st Question-----------------------------------------
--- Creating Tables
--- 1st Table - CoursesDescription table
CREATE TABLE CoursesDescription (
  cno VARCHAR(10) PRIMARY KEY,
  title VARCHAR(50), 
  dept VARCHAR(20) NOT NULL,
  credits NUMBER,
  prereq VARCHAR(20),
  Constraint CreditChk CHECK (credits IN (1,2,3,4)),
  Constraint PREREQFkey foreign key (prereq) REFERENCES CoursesDescription(cno) on delete set null
);

---- 2nd Table---- CoursesSpring2021 table
CREATE TABLE CoursesSpring2021 (
  crn NUMBER PRIMARY KEY,
  cno VARCHAR(20) NOT NULL, 
  Constraint cnoFkey foreign key (cno) REFERENCES CoursesDescription(cno) ON DELETE CASCADE,
  seatCapacity NUMBER DEFAULT 24,
  seatTaken NUMBER NOT NULL,
  Constraint SeatcapCHK CHECK (seatTaken <= seatCapacity)
);

INSERT INTO CoursesDescription (cno,title,dept,credits) VALUES ('aso110','academic orientation','csc',1);
INSERT INTO CoursesDescription(cno,title,dept,credits) values ('mat307','linear algebra','MAT',3);
INSERT INTO CoursesDescription (cno,title,dept,credits) VALUES ('che120','introduction to chemistry','CHE',4);
INSERT INTO CoursesDescription(cno,title,dept,credits) values ('inf100','msoffice','csc',2);
INSERT INTO CoursesDescription(cno,title,dept,credits) values ('csc185','dicrete structures','csc',3);
INSERT INTO CoursesDescription(cno,title,dept,credits,prereq) values ('csc190','javaI','csc',3,'csc185');
INSERT INTO CoursesDescription(cno,title,dept,credits,prereq) values ('csc191','javaII','csc',4,'csc190');
INSERT INTO CoursesDescription(cno,title,dept,credits,prereq) values ('csc195','discrete structures II','csc',4,'csc190');

INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (11111,'csc190',24,17);
INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (12222,'csc191',24,13);
INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (13333,'aso110',24,10);
INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (14444,'csc185',24,20);
INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (15555,'csc190',24,15);
INSERT INTO CoursesSpring2021(crn,cno,seatCapacity,seatTaken) values (10000,'mat307',24,18);


--------- 2nd Question--------------------------
SELECT c.cno, c.credits
FROM CoursesDescription c 
WHERE c.prereq IS NOT NULL;


--------------- 3rd Question ------------------------
SELECT COUNT(c.cno) as No_of_courses 
From CoursesDescription c 
where c.cno like 'csc%';

--------------- 4th Question -------------------------
SELECT crn, cno, seatTaken
FROM CoursesSpring2021 
ORDER BY cno 
DESC, seatTaken ASC;

--------------- 5th Question -------------------------
SELECT cno, MIN(seatTaken) AS LOWESTENROLLMENT
FROM CoursesSpring2021
WHERE cno = 'csc190'
GROUP BY cno;


--------------- 6th Question -------------------------
SELECT SUM(seatTaken) AS CSCENROLLMENT 
FROM CoursesSpring2021 
WHERE cno IN (SELECT cno FROM CoursesDescription WHERE dept = 'csc');

set serveroutput on;

--------------- 7th Question -------------------------
CREATE OR REPLACE procedure update_seat_capacity(x Number) 
IS
BEGIN
  -- Increase the seat capacity to 50 for all 100-level courses
  UPDATE CoursesSpring2021 SET seatCapacity= x WHERE cno LIKE '___1__';

END;
/
---Update Seat Capacity
BEGIN
 update_seat_capacity(50);
END;
/
 
CREATE OR REPLACE FUNCTION avgEnrollment RETURN NUMBER IS
  avgEnrollmentOUTPUT NUMBER;
BEGIN
   SELECT AVG(seatTaken) INTO avgEnrollmentOUTPUT FROM CoursesSpring2021 WHERE cno LIKE '___1__';
   RETURN avgEnrollmentOUTPUT;
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('The average enrollment of 100-level courses is: ' || avgEnrollment);
END;
/
