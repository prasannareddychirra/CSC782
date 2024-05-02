---8(a): Select employees with salaries greater than 40000 or those who are managers
SELECT *
FROM Employees
WHERE salary > 40000
   OR id IN (SELECT managerID FROM Departments);

---8(b): Calculate the average salary for each department
SELECT dept, AVG(salary) AS avg_salary
FROM Employees
GROUP BY dept;

---8(c): Raise the salary of the new manager by 10% whenever the managerID in the Departments table is updated

CREATE OR REPLACE TRIGGER RaiseManagerSalary
AFTER UPDATE OF managerID ON Departments
FOR EACH ROW
BEGIN
    IF :new.managerID IS NOT NULL THEN
        UPDATE Employees
        SET salary = salary * 1.1
        WHERE id = :new.managerID;
    END IF;
END;
/
---8(d): Raise salaries by the specified percent for eligible employees and return the number of employees who benefited from the increase

CREATE OR REPLACE FUNCTION raiseSalaries(upperBound IN Employees.salary%type, percent IN NUMBER)
RETURN NUMBER IS
    numEmployee NUMBER;
BEGIN
    UPDATE Employees
    SET salary = salary * (1 + percent)
    WHERE salary <= upperBound;
    numEmployee := SQL%ROWCOUNT;
    RETURN numEmployee;
END;
/

DECLARE
    numEmployee NUMBER;
BEGIN
    numEmployee := raiseSalaries(50000, 0.03);
    DBMS_OUTPUT.PUT_LINE('Number of employees who got a salary increase: ' || numEmployee);
END;
/
