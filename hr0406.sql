SELECT * FROM EMPLOYEES;

-- 직원번호가 100인 사람을 출력
SELECT * FROM employees WHERE employee_id = 100;

-- king 직원 출력
SELECT * FROM employees WHERE Last_name = 'King';

-- 월급순 내림차순으로 직원정보를 출력
SELECT EMPLOYEE_ID, first_name, Last_name, salary FROM employees ORDER BY salary DESC;

-- 월급이 5000이상   순서 -> select > from > where > order by
SELECT EMPLOYEE_ID, first_name, Last_name, salary FROM employees WHERE salary >= 5000 ORDER BY salary DESC;

-- 전화번호에 010이 포함된 직원
SELECT employee_id, first_name, last_name, phone_number FROM employees WHERE phone_number like '%010%' ORDER BY employee_id ASC;

-- 50번 부서의 직원을 출력 || > + // 사번 : ALIAS, 별칭, 별명 // 띄어쓰기는 "" 붙여야함
SELECT employee_id "사 번", first_name||' '||last_name 이름, department_id 부서번호 FROM employees where department_id = 50
order by first_name||' '||last_name ASC; -- order by first_name asc, last name asc;

-- 부서가 없는 직원을 출력



