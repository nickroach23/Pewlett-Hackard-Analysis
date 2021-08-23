# Queries 
SELECT * FROM departments;
SELECT * FROM employees;19
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM titles;









SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'


-- Retirement eligibility 
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Retirement eligibility 
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');



SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;



-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
	

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


-- 7.3.5 (Employees Info)
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s on (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de on (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- 7.3.5 (Management)
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
		
-- 7.3.5 (Department Retirees)
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de on (ce.emp_no = de.emp_no)
INNER JOIN departments as d on (de.dept_no = d.dept_no);



SELECT e.first_name, e.last_name, e.dept_id
From employees as e 



-- 7.3.6 Skill Drill #1
SELECT de.emp_no, ce.first_name, ce.last_name, d.dept_name
from dept_emp as de
INNER JOIN current_emp as ce
ON (de.emp_no = ce.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE dept_name ='Sales';

-- 7.3.6 Skill Drill #2
SELECT de.emp_no, ce.first_name, ce.last_name, d.dept_name
from dept_emp as de
INNER JOIN current_emp as ce
ON (de.emp_no = ce.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE dept_name IN ('Sales' , 'Development');



--Challenge 
-- Number of Retiring Employees by Title 
SELECT em.emp_no, 
        em.first_name, 
        em.last_name,
	    ti.title, 
        ti.from_date, 
        ti.to_date
	INTO retiring_emp_by_title
	FROM employees AS em
	LEFT JOIN titles as ti
	ON (em.emp_no = ti.emp_no)
	WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY em.emp_no;
select * from retiring_emp_by_title;


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, 
	first_name, 
    last_name, 
    title
INTO unique_titles
FROM retiring_emp_by_title
ORDER BY emp_no ASC, to_date DESC;
select * from unique_titles;


--retrieving the number of employees by most recent job titles.
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;
select * from retiring_titles;

-- query to create a Mentorship Eligibility table that holds the employees who are eligible to participate in a mentorship program.
SELECT DISTINCT ON (em.emp_no) em.emp_no, em.first_name, em.last_name, em.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship_elegible 
FROM employees AS em
LEFT JOIN dept_emp AS de
ON em.emp_no = de.emp_no
LEFT JOIN titles AS ti
ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no;
select * from mentorship_elegible
