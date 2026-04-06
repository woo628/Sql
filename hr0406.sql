SELECT * FROM EMPLOYEES;

-- 직원번호가 100인 사람을 출력
SELECT * FROM employees WHERE employee_id = 100;

-- king 직원 출력
SELECT * FROM employees WHERE Last_name = 'King';

-- 월급순 내림차순으로 직원정보를 출력
SELECT EMPLOYEE_ID, first_name, Last_name, salary FROM employees ORDER BY salary DESC;

-- 월급이 5000이상   순서 -> select > from > where > order by
SELECT EMPLOYEE_ID, first_name, Last_name, salary FROM employees WHERE salary >= 5000 ORDER BY salary DESC;

-- 전화번호에 100이 포함된 직원
SELECT *FROM employees WHERE phone_number ORDER BY 

-- 50번 부서의 직원을 출력

-- 부서가 없는 직원을 출력