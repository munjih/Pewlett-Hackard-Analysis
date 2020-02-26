-- Generate potential retirees table with titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	s.salary
INTO retiring_titles
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- Keep the most recent titles from the retiree table
SELECT emp_no, first_name, last_name, title, from_date, salary 
INTO recent_titles
FROM
	(SELECT emp_no, first_name, last_name, title, from_date, salary, ROW_NUMBER()
	 OVER
	(PARTITION BY emp_no ORDER BY from_date DESC) rn
	 FROM retiring_titles) tmp 
	 WHERE rn =1;
-- Count title frequency among retirees
SELECT title, count(*) 
INTO title_counts
FROM recent_titles
GROUP BY title;

-- Generate mentor list 
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO mentor_list
FROM employees as e
RIGHT JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (ti.to_date = '9999-01-01');