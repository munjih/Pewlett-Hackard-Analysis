-- Generate table with titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	ti.title,
	ti.from_date,
	ti.to_date,
	s.salary
INTO retiring_titles
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no);

-- Table with most recent titles
SELECT emp_no, first_name, last_name, birth_date, title, from_date, to_date, salary 
INTO recent_titles
FROM
	(SELECT emp_no, first_name, last_name, birth_date, title, from_date, to_date, salary, ROW_NUMBER()
	 OVER
	(PARTITION BY emp_no ORDER BY from_date DESC) rn
	 FROM retiring_titles) tmp 
	 WHERE rn =1;

-- Generate mentor list
SELECT rt.emp_no, rt.first_name, rt.last_name, rt.title, rt.from_date, rt.to_date
INTO mentor_list
FROM recent_titles as rt
WHERE (rt.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (rt.to_date = '9999-01-01');