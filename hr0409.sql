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


-- 직원이름, 담당업무 JOB TITLE
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       J.JOB_TITLE 담당업무
FROM employees E
JOIN JOBS J
    ON (E.JOB_ID = J.JOB_ID);

-- 직원명 부서명 부서위치 CITY STREE_ADDRESS
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명,
       L.CITY 도시,
       L.STREET_ADDRESS 부서위치
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D   -- LEFT 모든 JOIN에  NULL까지 표시할려면
    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
LEFT JOIN LOCATIONS L
    ON (D.LOCATION_ID = L.LOCATION_ID);

-- 직원명 부서명 국가 부서위치
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명,
       C.COUNTRY_NAME 국가,
       L.CITY||' - '||L.STREET_ADDRESS 부서위치
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
JOIN LOCATIONS L
    ON (D.LOCATION_ID = L.LOCATION_ID)
JOIN COUNTRIES C
    ON (L.COUNTRY_ID = C.COUNTRY_ID)
ORDER BY 직원이름;
    
-- 부서명 국가 모든 부서 27줄이상
SELECT D.DEPARTMENT_NAME 부서명,
       C.COUNTRY_NAME 국가
FROM DEPARTMENTS D
RIGHT JOIN LOCATIONS L
    ON (D.LOCATION_ID = L.LOCATION_ID)
RIGHT JOIN COUNTRIES C
    ON (L.COUNTRY_ID = C.COUNTRY_ID)
ORDER BY 부서명;

-- 직원명 부서위치 IT부서만
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       D.DEPARTMENT_NAME 부서명,
       L.STATE_PROVINCE||', '||L.CITY||', '||L.STREET_ADDRESS 부서위치
FROM EMPLOYEES E
JOIN DEPARTMENTS D 
    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
    AND D.DEPARTMENT_NAME = 'IT'       
JOIN LOCATIONS L
    ON (D.LOCATION_ID = L.LOCATION_ID);
    
-- 부서명별 월급평균
SELECT D.DEPARTMENT_NAME 부서명,
        ROUND(AVG(SALARY)) 평균월급
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME;

-- 모든부서 
-- NULL 대신 직원없음
SELECT D.DEPARTMENT_NAME 부서명,
--        NVL(ROUND(AVG(SALARY)),'직원없음') 평균월급 = 안됨 NVL은 숫자비교
       DECODE (AVG(E.SALARY),NULL,'직원없음',ROUND(AVG(E.SALARY))) 평균월급
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME
ORDER BY 부서명;

-- 직원의 근무연수
-- MONTHS_BETWEEN (날짜1, 날짜2) : 날짜1 - 날짜 2 (월단위로) 
-- ADD_MONTH(날짜,N) : 날짜 + N개월 / 날짜 - N개월
SELECT FIRST_NAME ||' '|| LAST_NAME 직원명,
       TO_CHAR(HIRE_DATE,'YYYY-MM-DD') 입사일,
       TO_CHAR(TRUNC(HIRE_DATE,'MONTH'),'YYYY-MM-DD') 입사월의첫번째날,
       TO_CHAR(LAST_DAY(HIRE_DATE),'YYYY-MM-DD') 입사월의마지막날,
       TRUNC(SYSDATE - HIRE_DATE) 근무일수,
       TRUNC((SYSDATE - HIRE_DATE) / 365.22) 근무연수, -- 365.22 윤년고려
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) 근무연수
FROM EMPLOYEES;
        
 -- 60번 부서 최소월급과 같은 월급자의 명단출력
SELECT FIRST_NAME ||' '|| LAST_NAME 직원이름,
       SALARY 월급
FROM EMPLOYEES 
WHERE SALARY = (SELECT MIN(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 부서번호
FROM departments
WHERE DEPARTMENT_NAME = 'IT'));
 
 -- 부서명,부서장의 이름
SELECT D.DEPARTMENT_NAME 부서명,
       E.FIRST_NAME ||' '|| E.LAST_NAME 부서장
FROM DEPARTMENTS D
JOIN EMPLOYEES E
    ON (D.MANAGER_ID = E.EMPLOYEE_ID);
--    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
--WHERE (E.DEPARTMENT_ID, E.SALARY) 
--IN (SELECT DEPARTMENT_ID 부서명,
--    MAX(SALARY)
--    FROM EMPLOYEES E
--    GROUP BY DEPARTMENT_ID);

-- 모든부서
SELECT D.DEPARTMENT_NAME 부서명,
       E.FIRST_NAME ||' '|| E.LAST_NAME 부서장
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E 
    ON (D.MANAGER_ID = E.EMPLOYEE_ID);
    
-------------------------------------------------------------------------------
결합연산자 - 줄 단위 결합
 조건 -- 두테이블의 칸수와 타입이 동일해야한다
 1) UNION 중복제거
 2) UNION ALL 중복포함
 3) INTERSECT 교집합
 4) MINUS 차집합 

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80; -- 34
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 45

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80 
UNION
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 79

-- 칼럼수와 칼럼들의 TYPE이 같으면 합쳐진다 (주의할것)
SELECT EMPLOYEE_ID, FIRST_NAME FROM EMPLOYEES
UNION  
SELECT DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS;

 -- 직원정보, 담당업무
 SELECT FIRST_NAME ||' '|| LAST_NAME 직원이름,
        D.DEPARTMENT_NAME 부서이름,
        J.JOB_ID 담당업무
 FROM EMPLOYEES E
 JOIN DEPARTMENTS D
    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
 JOIN JOBS J 
    ON (E.JOB_ID = J.JOB_ID);
 
 -- 사번 업무시작일, 업무종료일, 담당업무, 부서번호
 SELECT E.EMPLOYEE_ID 사번,
        H.START_DATE 업무시작일,
        H.END_DATE 엄무종료일,
        J.JOB_ID 담당업무,
        E.DEPARTMENT_ID 부서번호
 FROM EMPLOYEES E
 JOIN JOB_HISTORY H
    ON (E.EMPLOYEE_ID = H.EMPLOYEE_ID) 
 JOIN JOBS J 
    ON (E.JOB_ID = J.JOB_ID);
-----------------------------------------------------
 SELECT EMPLOYEE_ID, JOB_ID FROM EMPLOYEES
 UNION ALL
 SELECT EMPLOYEE_ID, JOB_ID FROM JOB_HISTORY
 ORDER BY EMPLOYEE_ID;
