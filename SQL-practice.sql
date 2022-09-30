--------------------------------------------------------------------------------
--------- CREATE TABLES -----------------


--INT             -- Whole number
--DECIMAL(10, 4)   -- Decimal Numbers - exact values
--VARCHAR(100)    -- String of text of length 100
--BLOB            -- Binary Large Object, Store large data
--DATE            -- YYYY-MM-DD
--TIMESTAMP       -- YYYY-MM-DD HH:MM:SS


-- Creating data table
CREATE TABLE student (
    student_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL, -- not null for name
    major VARCHAR(20) DEFAULT 'undecided', -- unique major
    PRIMARY KEY(student_id)
);

DESCRIBE student;
DROP TABLE student;
ALTER TABLE student ADD gpa DECIMAL(3, 2); -- decimal with 3 digits, 2 after decimals

-- select all
SELECT * FROM student;

-- primary key has to be unique
-- no more ID since auto increment
-- INSERT INTO student(student_id, name, major) VALUES(1, 'Amelia Tran', 'Daydreaming');
INSERT INTO student(name, major) VALUES('Amelia Tran', 'Daydreaming');
INSERT INTO student(name, major) VALUES('Taylor Swift', 'Songwriting');
INSERT INTO student(name, major) VALUES('Karlie Kloss', 'Modeling');
INSERT INTO student(name, major) VALUES('Doug Schaubel', 'Survival Analysis');
INSERT INTO student(name, major) VALUES('Katherine LeGouis', 'French');
INSERT INTO student(name) VALUES('Margaret Robinson'); -- undecided

-- cannot run since NOT NULL
-- INSERT INTO student VALUES(7, NULL, 'Number Theory'); 

-- cannot run since UNIQUE
-- INSERT INTO student VALUES(7, 'Number theorist', 'Number Theory');

--------------------------------------------------------------------------------
------------- UPDATE and DELETE TABLES -----------------

CREATE TABLE student (
    student_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL, -- not null for name
    major VARCHAR(20) DEFAULT 'undecided', -- unique major
    PRIMARY KEY(student_id)
);

INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Kate', 'Sociology');
INSERT INTO student(name, major) VALUES('Claire', 'Chemistry');
INSERT INTO student(name, major) VALUES('Jacek', 'Computer Science');

SELECT * FROM student;
DROP TABLE student;

UPDATE student
-- SET major = 'undecided'; -- affects all students in the table
SET major = 'Biochemistry'
WHERE major = 'Biology' OR major = 'Chemistry';
-- SET major = 'Comp Sci'
-- WHERE student_id = 4;
-- WHERE major = 'Computer Science'

DELETE FROM student; -- delete all students
WHERE major = 'Biology' OR major = 'Chemistry';


--------------------------------------------------------------------------------
------------- BASIC QUERIES -----------------
-- SELECT name, major
SELECT * -- select all 
-- can also do student.name, student.major
FROM student
WHERE name <> 'Kate' -- name not equal to Jack 
AND name IN ('Jacek', 'Kate')
-- ORDER BY name DESC; -- alphabetical order by name, descending
ORDER BY major, student_id DESC
LIMIT 2
;

-- <. >, <=, >=, =, <>, AND, OR
-- WHERE student_id <= 3 and name <> 'Jack' 

-- -----------------------------------------------------------------------------
------------- COMPANY DATABSE -----------------
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40), 
    last_name VARCHAR(40), 
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);

CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_adte DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
    -- foreign key is manager ID, add ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE Works_With (
    emp_id INT, 
    client_id INT, 
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
    branch_id INT, 
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);
    
--------------------------------------------------------------------------------
-- Corporate: NULL for branch_id first, start branch, then update employee
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SELECT * FROM employee;
SELECT * FROM branch;
SELECT * FROM client;
SELECT * FROM Works_With;
SELECT * FROM branch_supplier;

-- Find all employees
SELECT * FROM employee;

-- Find all clients
SELECT * FROM client;

-- Find all employees ordered by salary
SELECT * 
FROM employee
ORDER BY salary;

-- Find all employees ordered by sex and name
SELECT * 
FROM employee
ORDER BY sex, first_name, last_name;

-- Find first 5 employees
SELECT * 
FROM employee
LIMIT 5;

-- Get first and last names
SELECT first_name, last_name 
FROM employee;

-- Rename first and last name column
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Find out different genders M and F
SELECT DISTINCT sex
FROM employee;

--------------------------------------------------------------------------------
---------- FUNCTIONS ------------------
-- Find number of employees
SELECT COUNT(emp_id)
FROM employee;

-- Find number of employees
SELECT COUNT(super_id)
FROM employee;

-- Find number of female employees born after 1970
-- select -> from -> where
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day >= '1971-01-01';

-- Find average of employee's salary
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- AVG, COUNT, SUM 

-- Find how many males and females Aggregate GROUP_BY
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;

SELECT * FROM employee;

--------------------------------------------------------------------------------
---------- WILDCARDS ------------------
-- % = any # characters, _ = one character

-- Find any clients who are an LLC
SELECT * 
FROM client
WHERE client_name LIKE '%LLC'; -- any characters ending with LLC

-- Find any branch suppliers who are in the Label business
-- label in the supplier name
SELECT * 
FROM branch_supplier
WHERE supplier_name LIKE '%Label%'; -- the world label is in it

-- Find any client whose birthday is in October
SELECT * 
FROM employee
WHERE birth_day LIKE '____-10%'; -- underscore _ represents ANY single character

-- Find any clients who are schools
SELECT * 
FROM client
WHERE client_name LIKE '%school%'; 

--------------------------------------------------------------------------------
---------- UNION ------------------

-- Find a list of employee and branch names
-- 1. Same number of columns; 2. Same data types

SELECT first_name
FROM employee;

SELECT branch_name
FROM branch;

-- Combine different statements
-- Rule 1: Same number of columns getting from each statement
-- Rule 2: Similar data types

SELECT first_name AS Company_Names -- change column name
FROM employee
UNION 
SELECT branch_name
FROM branch
UNION 
SELECT client_name
FROM client;

-- Find a list of all clients and suppliers names 
SELECT client_name, client.branch_id
FROM client
UNION 
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- Find a list of all money spent or earned by the company
SELECT total_sales
FROM works_with
UNION 
SELECT salary
FROM employee;

--------------------------------------------------------------------------------
---------- JOIN ------------------

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- Combining different tables into a single results based on relationships between tables
-- Find all branches with the name of their managers
-- grab a column from branch table as well
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch -- INNER join
ON employee.emp_id = branch.mgr_id;


SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch -- includes all rows from the left table (employee)
ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch -- includes all from the branch table
ON employee.emp_id = branch.mgr_id;

-- FULL OUTER JOIN: grabs all rows in the left and right tables

--------------------------------------------------------------------------------
---------- NESTED QUERIES ------------------

---------- IN () ---------------------------

-- Find names of all employees who have
-- sold over 30,000 to a single client

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);

-- Find all clients who are handled by the branch (check brand ID)
-- that Michael Score manages
-- Assume you know Michael's ID

SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102   
    LIMIT 1 -- should use for equality
);


--------------------------------------------------------------------------------
---------- ON DELETE ------------------

-- Delete Michael Scott manager ID 102
-- ON DELETE SET NULL --
-- if delete one employee, all associated set to NULL
CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_adte DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
    -- foreign key is manager ID, add ON DELETE SET NULL
);

DELETE FROM employee
WHERE emp_id = 102;

SELECT * from branch;
SELECT * from employee;

--------------------------------------------------------------------------------
-- ON DELETE CASCADE --
-- if delete one employee, all associated also DELETED

CREATE TABLE branch_supplier (
    branch_id INT, 
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

DELETE FROM branch
WHERE branch_id = 2;

SELECT * from branch_supplier;


-- Branch Table: ON DELETE SET NULL --
-- Manager ID on Branch Table is FOREIGN KEY, not primary -- not essential
-- Branch SUPPLIER Table: ON DELETE CASCADE --
-- Branch ID is primary key, delete entirely


--------------------------------------------------------------------------------
---------- TRIGGER ------------------
-- delimiter defined on Terminal
-- need to change DELIMITER on terminal: mysql -u root -p 
-- this part inserted into terminal
DELIMITER $$ -- change delimiter to $$
CREATE  
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES('added male');
        ELSE 
            INSERT INTO trigger_test VALUES('added other employee');
        END IF;
        INSERT INTO trigger_test VALUES('added new employee'); -- use semi colon 
        -- access new thing being added
        INSERT INTO trigger_test VALUES(NEW.first_name); -- use semi colon 
    END $$ -- use a DIFFERENT DELIMITER from a semi colon
DELIMITER ; -- change DEMILITER back to semi colon ; 

-- delimiter is now $$
SELECT * FROM employee;

INSERT INTO employee
VALUES(100, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

-- everytime something inserted into employee
-- statement inserted into trigger_test as well
-- new message: added new employee
SELECT * FROM trigger_test;