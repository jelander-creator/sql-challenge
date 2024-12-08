-- Create the departments table
CREATE TABLE departments (
    dept_no VARCHAR(10) PRIMARY KEY,    
    dept_name VARCHAR(100) NOT NULL     -- Department name
);
--Copy departments CSV
COPY departments(dept_no, dept_name)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\departments.csv'
DELIMITER ',' 
CSV HEADER;

--Create the dept_emp table
CREATE TABLE dept_emp (
    emp_no INT,                     -- Employee number 
    dept_no VARCHAR(10),             -- Department number
    PRIMARY KEY (emp_no, dept_no),   
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,  -- Foreign key to employees
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE  -- Foreign key to departments
);
--Copy dept_emp CSV
COPY dept_emp(emp_no, dept_no)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\dept_emp.csv'
DELIMITER ',' 
CSV HEADER;

--Create dept_manager table
CREATE TABLE dept_manager (
    dept_no VARCHAR(10),             -- Department number 
    emp_no INT,                      -- Employee number
    PRIMARY KEY (dept_no, emp_no),   
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,   -- Foreign key to employees
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE  -- Foreign key to departments
);
--Copy dept_manager CSV
COPY dept_manager(dept_no, emp_no)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\dept_manager.csv'
DELIMITER ',' 
CSV HEADER;

--Create employees table(no foreign keys needed)
CREATE TABLE employees (
    emp_no INT PRIMARY KEY,              -- Employee number 
    emp_title_id VARCHAR(10),            -- Employee's title ID
    birth_date DATE,                     -- Employee's birth date
    first_name VARCHAR(100),             -- Employee's first name
    last_name VARCHAR(100),              -- Employee's last name
    sex CHAR(1),                         -- Employee's sex (M or F)
    hire_date DATE                       -- Employee's hire date
);
--Copy employees CSV
COPY employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\employees.csv'
DELIMITER ','
CSV HEADER;

--Create salaries table
CREATE TABLE salaries (
    emp_no INT,                         -- Employee number (foreign key)
    salary INT,                          -- Employee's salary
    from_date DATE,                      -- Starting date of the salary
    to_date DATE,                        -- Ending date of the salary 
    PRIMARY KEY (emp_no, from_date),     
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE  -- Foreign key to employees
);
--Copy salaries CSV
COPY salaries (emp_no, salary, from_date, to_date)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\salaries.csv'
DELIMITER ','
CSV HEADER;

--Create titles table
CREATE TABLE titles (
    title_id VARCHAR(10) PRIMARY KEY   
);
--Copy titles CSV
COPY titles (title_id, title)
FROM 'C:\\Users\\JamesElander\\sql-challenge\\EmployeeSQL\\Starter_Code\\data\\titles.csv'
DELIMITER ','
CSV HEADER;

--Data Analysis
--1
SELECT 
    e.emp_no, 
    e.last_name, 
    e.first_name, 
    e.sex, 
    s.salary
FROM 
    employees e
JOIN 
    salaries s ON e.emp_no = s.emp_no;
--2
SELECT 
    first_name, 
    last_name, 
    hire_date
FROM 
    employees
WHERE 
    EXTRACT(YEAR FROM hire_date) = 1986;
--3
SELECT 
    d.dept_no, 
    d.dept_name, 
    e.emp_no, 
    e.last_name, 
    e.first_name
FROM 
    dept_manager dm
JOIN 
    departments d ON dm.dept_no = d.dept_no
JOIN 
    employees e ON dm.emp_no = e.emp_no;
--4
SELECT 
    de.dept_no, 
    e.emp_no, 
    e.last_name, 
    e.first_name, 
    d.dept_name
FROM 
    dept_emp de
JOIN 
    employees e ON de.emp_no = e.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no;
--5
SELECT 
    first_name, 
    last_name, 
    sex
FROM 
    employees
WHERE 
    first_name = 'Hercules'
    AND last_name LIKE 'B%';
--6
SELECT 
    e.emp_no, 
    e.last_name, 
    e.first_name
FROM 
    dept_emp de
JOIN 
    employees e ON de.emp_no = e.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    d.dept_name = 'Sales';
--7
SELECT 
    e.emp_no, 
    e.last_name, 
    e.first_name, 
    d.dept_name
FROM 
    dept_emp de
JOIN 
    employees e ON de.emp_no = e.emp_no
JOIN 
    departments d ON de.dept_no = d.dept_no
WHERE 
    d.dept_name IN ('Sales', 'Development');
--8
SELECT 
    last_name, 
    COUNT(*) AS frequency
FROM 
    employees
GROUP BY 
    last_name
ORDER BY 
    frequency DESC;