SELECT * FROM TAB;

-- IT 부서의 직원정보를 출력하시오
SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'IT';

SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호
FROM   employees
WHERE  department_id = 60;

-- SUBQUERY : SQL문 안에 SQL문을 넣어서 실행한 방법
--            반드시 ()안에 있어야 한다
--            ()안에 ORDER BY 사용 X
--            WHERE 조건에 맞도록 작성
--            쿼리를 싱행하는 순서가 필요할때
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호
FROM   employees
WHERE  department_id = (
    SELECT DEPARTMENT_ID 부서번호
    FROM departments
    WHERE DEPARTMENT_NAME = 'IT');


-- 평균 월급보다 많은 월급을 받는 사람의 명단
-- 평균월급
SELECT AVG(SALARY) 월급
FROM employees;

-- 월급보다 많은
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       SALARY 월급
FROM employees
WHERE SALARY >= -- 6461.831775700934579439252336448598130841;
                (SELECT AVG(SALARY) FROM employees);
                
-- 60번 부서의 평균월급보다 많은 월급을 받는사람의 명단
-- 1) 60
SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'IT';
-- 2) 5760
SELECT AVG(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = 60;
-- 3) 명단
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호,
       SALARY 월급
FROM   employees
WHERE  SALARY >= 5760;
-- 1) + 2)
SELECT AVG(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'IT');

-- 1) + 2) + 3)
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호,
       SALARY 월급
FROM   employees
WHERE  SALARY >= (SELECT AVG(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'IT'));

-- 50 번 부서의 최고 월급자의 이름 출력
SELECT MAX(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = 50;
 
SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호,
       SALARY 월급
FROM   employees
WHERE  SALARY = (SELECT MAX(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = 50
 ) AND DEPARTMENT_ID = 50;
 
-- SALES 부서의 평균월급보다 많은 월급을 받는 사람의 명단
SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'Sales';

SELECT AVG(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'Sales'
);

SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호,
       SALARY 월급
FROM   employees
WHERE SALARY >= (SELECT AVG(SALARY) 월급
FROM employees
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'Sales'
));

-- SHIPPING 부서의 직원명단
SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE UPPER(DEPARTMENT_NAME) = 'SHIPPING';

SELECT EMPLOYEE_ID 사번,
       FIRST_NAME ||' '|| LAST_NAME 이름,
       DEPARTMENT_ID 부서번호,
       SALARY 월급
FROM   employees
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE UPPER(DEPARTMENT_NAME) = 'SHIPPING');

-- 다중 열 서브쿼리
-- employees 테이블에서 job_id별로 가장 낮은 salary가 얼마인지 찾아보고 
-- 찾아낸 job_id별 salary에 해당하는 직원이 누구인지 
SELECT *
FROM employees A
WHERE (A.job_id, A.salary) IN (
                               SELECT job_id, MIN(salary) 그룹별급여
                               FROM employees
                               GROUP BY job_id                              )
ORDER BY A.salary DESC;

-- 상관 서브 쿼리 
SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1
                      FROM job_history b
                     WHERE a.department_id = b.department_id );
--------------------------------------------------------------------------------
-- JOIN
-- ORCALE OLD 문법
-- 1) 109 * 27  = 2943  = CROSS JOIN 조건 X
SELECT FIRST_NAME ||' '|| LAST_NAME 직원이름,
       DEPARTMENT_NAME 부서명
FROM employees, departments;
-- 2) 106 (NULL 제외) = INNER JOIN
SELECT employees.FIRST_NAME ||' '|| employees.LAST_NAME 직원이름,
       departments.DEPARTMENT_NAME 부서명
FROM employees, departments
WHERE employees.department_id = departments.department_id;
-- 3) 단축
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E, departments D
WHERE E.department_id = D.department_id;

-- 4) 모든 직원 NULL 포함 109줄 = LEFT OUTER JOIN
-- (+) : 기준(직원)이 되는 조건의 반대 방향에 붙인다 (NULL이 출력될곳)
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E, departments D
WHERE E.department_id = D.department_id(+);

-- 5) 모든 부서 NULL 포함 122줄 = RIGHT OUTER HOIN
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E, departments D
WHERE E.department_id(+) = D.department_id;

-- 6) 모든 직원,부서 = FULL OUTER JOIN 새문법에만 적용

-------------------------------------------------------------------------------
표준 SQL 문법
1. CROSS JOIN : 2943
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E
CROSS JOIN departments D;

2. INNER JOIN : INNER 생략가능
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E
INNER JOIN departments D
    ON (E.department_id = D.department_id);

3. OUTER JOIN : OUTER 생략가능
 1) LEFT OUTER JOIN
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E
LEFT JOIN departments D
    ON (E.department_id = D.department_id);
    
 2) RIGHT OUTER JOIN
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E
RIGHT JOIN departments D
    ON (E.department_id = D.department_id); 
    
 3) FULL OUTER JOIN
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명
FROM employees E 
FULL OUTER JOIN departments D 
    ON (E.department_id = D.department_id);
 