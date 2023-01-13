Error; --to prevent running entire query

--Drop Tables if necessary

Drop Table If Exists Salaries;
Drop Table If Exists Department_Managers;
Drop Table If Exists Department_Employees;
Drop Table If Exists Employees;
Drop Table If Exists Departments;
Drop Table If Exists Titles;

--Create Tables in order considering Foreign Keys

Create Table Titles (
	title_id VARCHAR (5) NOT NULL PRIMARY KEY,
	title VARCHAR (25) NOT NULL
);

Create Table Departments (
	dept_no VARCHAR (4) NOT NULL PRIMARY KEY,
	dept_name VARCHAR (25)
);

Create Table Employees (
	emp_no INT NOT NULL PRIMARY KEY,
	emp_title_id VARCHAR (5) NOT NULL,
	birth_date VARCHAR (10),
	first_name VARCHAR (25),
	last_name VARCHAR (25),
	sex VARCHAR (10),
	hire_date VARCHAR (10),
	FOREIGN KEY (emp_title_id) REFERENCES Titles(title_id)
);

Create Table Department_Employees (
	emp_no INT NOT NULL,
	dept_no VARCHAR (4) NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no)
);

Create Table Department_Managers (
	dept_no VARCHAR (4) NOT NULL,
	emp_no INT NOT NULL PRIMARY KEY,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES Departments(dept_no)
);

Create Table Salaries (
	emp_no INT NOT NULL PRIMARY KEY,
	salary INT,
	FOREIGN KEY (emp_no) REFERENCES Employees(emp_no)
);

-------

----------Data Analysis-----------

--List [emp_no, last_name, first_name, sex, salary] of each employee

select emp.emp_no, emp.last_name, emp.first_name, emp.sex, sal.salary
from Employees emp
join Salaries sal
on emp.emp_no = sal.emp_no
order by emp.emp_no;

--List [first_name, last_name, hire_date] for employees hired in 1986

select first_name, last_name, hire_date
from employees
where hire_date like '%1986';

--List [dept_no, dept_name, emp_no, last_name, first_name] for the managers of each department

select dept.dept_no, dept.dept_name, emp.emp_no, emp.last_name, emp.first_name
from employees emp
join department_managers dept_mgr
on emp.emp_no = dept_mgr.emp_no
join departments dept
on dept.dept_no = dept_mgr.dept_no
order by emp_no;

--List [dept_no, emp_no, last_name, first_name, dept_name] for each employee

select dept.dept_no, emp.emp_no, emp.last_name, emp.first_name, dept.dept_name
from employees emp
join department_employees dept_emp
on emp.emp_no = dept_emp.emp_no
join departments dept
on dept.dept_no = dept_emp.dept_no
order by emp_no;

--List [first_name, last_name, sex] of employees named like 'Hercules B%'

select first_name, last_name, sex
from employees
where first_name = 'Hercules'
and last_name like 'B%'
order by last_name;

--List [emp_no, last_name, first_name] for employees in Sales Department

select emp_no, last_name, first_name
from employees
where emp_no in (
	select emp_no
	from department_employees
	where dept_no in (
		select dept_no
		from departments
		where dept_name = 'Sales'
	)
)
order by emp_no;

--List [emp_no, last_name, first_name, dept_name] for employees in either Sales or Development

select emp.emp_no, emp.last_name, emp.first_name, dept.dept_name
from employees emp
join department_employees dept_emp
on emp.emp_no = dept_emp.emp_no
join departments dept
on dept.dept_no = dept_emp.dept_no
where emp.emp_no in (
	select emp_no
	from department_employees
	where dept_no in (
		select dept_no
		from departments
		where dept_name = 'Sales'
		or dept_name = 'Development'
	)
)
order by emp.emp_no;

--Count frequency of Last Names

select last_name, count(last_name) as "Name Count"
from employees
group by last_name
order by "Name Count" desc;

---END OF EXERCISE---