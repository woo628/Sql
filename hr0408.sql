SELECT sysdate FROM dual;

-- 세션 적용전
SELECT employee_id, hire_date
FROM employees
WHERE hire_date = '15/09/21';
-- 세션
ALTER SESSION SET NLS_DATE_FORMAT = "YYYY-MM-DD HH24:MI:SS";
-- 세션 적용 후
SELECT employee_id, hire_date
FROM employees
WHERE hire_date = '2014/02/17';

-----------------------------------------------------------------------------
-- 날짜 형식 통일
SELECT employee_id, TO_CHAR(hire_date,'YYYY-MM-DD')
FROM employees
WHERE TO_CHAR(hire_date,'YYYY-MM-DD') = '2026-04-07';



-- 입사후 일주일 이내인 직원명단
SELECT *
FROM employees
WHERE hire_date >= sysdate - 7;

-- 화요일 입사자 출력
SELECT employee_id 사번, first_name||' '||last_name 이름, TO_CHAR(hire_date, 'YYYY-MM-DD') 입사일, TO_CHAR(hire_date, 'DAY')
FROM employees
WHERE TO_CHAR(hire_date, 'DY') = '화'
ORDER BY 입사일;

-- 08월 입사자의 사번 이름 입사일을 입사일 순으로
SELECT employee_id 사번, first_name||' '||last_name 이름, hire_date 입사일
FROM employees
WHERE TO_CHAR(hire_date, 'MM') = '08'
ORDER BY 입사일 ;

-- 부서번호 80이 아닌 직원
SELECT *
FROM employees
WHERE department_id != 80;
--------------------------------------------------------------------------------
-- 2026년 04월 07일 17시 16분 04초 오후 화요일 / 한자로출력
SELECT TO_CHAR(sysdate,'YYYY"年" MM"月" DD"日" HH24"時" MI"分" SS"秒" am day','NLS_DATE_LANGUAGE=JAPANESE')
FROM dual;

-- 1. TO_CHAR 
SELECT TO_CHAR(sysdate,'YYYY"年" MM"月" DD"日" HH24"時" MI"分" SS"秒" am day')
FROM dual;

SELECT TO_CHAR(sysdate,'am'),
       decode( TO_CHAR(sysdate,'am'), '오전', '午前', '午後')
FROM dual;

SELECT TO_CHAR(sysdate,'YYYY') || '年'
    || TO_CHAR(sysdate,'MM') || '月'
    || TO_CHAR(sysdate,'DD') || '日'
    || TO_CHAR(sysdate,'HH24') || '時'
    || TO_CHAR(sysdate,'MI') || '分'
    || TO_CHAR(sysdate,'SS') || '秒'
    || CASE TO_CHAR(sysdate,'DY') 
        WHEN '일' THEN '日'
        WHEN '월' THEN '月'
        WHEN '화' THEN '火'
        WHEN '수' THEN '水'
        WHEN '목' THEN '木'
        WHEN '금' THEN '金'
        WHEN '토' THEN '土'
        END                  || '曜日'
    || DECODE(TO_CHAR(sysdate,'AM'),'오전','午前', '午後') 
FROM dual;
-- 2. IF  
-- 2-1 NVL(),NVL2() : null value
-- 사번, 이름, 월급, 보너스(null이면 0으로 출력)
SELECT employee_id 사번, first_name||' '||last_name 이름, salary 월급, 
       NVL(commission_pct, 0) 보너스, NVL2(commission_pct, salary+(salary*commission_pct),salary) 총금액 
FROM employees;
-- 2-2 NULLIF() expr1,expr2
-- 둘을 비교해서 같으면 null, 같지 않으면 expr1

-- 2-3 DECODE() : ORACLE
-- DECODE (expr, / search1, result1, / default)
--               / search2, result2, /
-- DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을, 같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고,
-- 이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다.
-- 사번, 부서번호 (부서번호가 null이면 '부서없음')
SELECT employee_id 사번, first_name||' '||last_name 이름, 
       decode(department_id, null, '부서없음', department_id) 부서번호
FROM employees;

-- 사번, 이름, 부서명
SELECT department_id 사번, first_name||' '||last_name 이름, 
       decode(department_id, 60, 'IT', 
                             90, 'Executive ',
                             80, 'Sales',      '그 외') 부서명
FROM employees;

SELECT employee_id 사번, first_name||' '||last_name 이름, 
       decode(department_id, 10,'Administration',
                             20,'Marketing',
                             30,'Purchasing',
                             40,'Human Resources',
                             50,'Shipping',
                             60,'IT',
                             70,'Public Relations',
                             80,'Sales',
                             90,'Executive',
                             100,'Finance',
                             110,'Accounting',
                             null,'부서없음',
                                               '그 외') 부서명
FROM employees;

-- 직원 사번, 직원의 월급, 보너스 출력 연봉출력
SELECT employee_id 사번, first_name||' '||last_name 직원명단, salary 월급, 
       NVL(salary+(salary*commission_pct),0) 보너스,
 --    (salary + (salary*NVL2(commission_pct,commission_pct,0)))*12 연봉,
 --    salary * 12 + (salary*NVL2(commission_pct,commission_pct,0)) 연봉,
       salary * 12 + NVL(salary+(salary*commission_pct),0) 연봉
FROM employees;

-- 3. CASE WHEN THEN END
-- when score between 99 and 100 then 'A'
-- when 90 <= score and score <= 100 then 'A'

-- 사번, 이름, 부서명
SELECT employee_id 사번, first_name||' '||last_name 이름,
       CASE department_id
        when 60 then 'IT'
-- department_id = 60 
        when 80 then 'Sales'
        when 90 then 'Executive'
        else         '그외'
        end           부서명
FROM employees;

--------------------------------------------------------------------------------
-- 집계함수 : AGGREGATE 
-- 모든 집계함수는 NULL 값을 포함하지 않는다
-- SUM() AVG() MIN() MAX() COUNT() STDDEV() VARIANCE()
-- 합계  평균  최소  최대   줄수   표쥰편차   분산
-- 그루핑 : GROUP BY  ~별 인원수
SELECT * FROM employees;
SELECT COUNT(*) FROM employees; -- 줄수
SELECT COUNT(EMPLOYEE_ID) FROM employees;  -- 109
SELECT COUNT(DEPARTMENT_ID) FROM employees; -- 106 NULL 값 제외

SELECT EMPLOYEE_ID FROM employees
WHERE department_id IS NULL;

SELECT COUNT(EMPLOYEE_ID) FROM employees
WHERE department_id IS NULL;

-- 전체직원의 월급 합 : 세로합, NULL 제외
SELECT COUNT(SALARY) FROM employees; -- 107
SELECT SUM(SALARY) FROM employees; -- 691416
SELECT AVG(SALARY) FROM employees; -- 6461.83177....
SELECT MAX(SALARY) FROM employees; -- 24000
SELECT MIN(SALARY) FROM employees; -- 2100

SELECT SUM(SALARY) / COUNT(SALARY) FROM employees; -- 6461.83177....
SELECT SUM(SALARY) / COUNT(*) FROM employees; -- 6343.266.... SALARY를 못받은 사람 때문 즉, NULL 때문

-- 60번 부서의 평균 월급
SELECT AVG(SALARY)
FROM employees
WHERE department_id = 60;

-- EMPLOYEES 테이블의 부서 수
SELECT COUNT(DEPARTMENT_ID) FROM employees; -- 직원수랑 동일 그래서 중복을 제거해줘야함

-- 중복을 제거한 부서의 리스트  / NULL 출력됨
SELECT DISTINCT DEPARTMENT_ID FROM employees;
-- 중복을 제거한 부서의 수      / NULL 포함 X
SELECT COUNT(DISTINCT DEPARTMENT_ID) FROM employees;

-- 직원이 근무하는 부서의 수 부서장이 있는 부서수 : DEPARTMENTS
SELECT COUNT(DEPARTMENT_ID) FROM departments -- 총부서수
WHERE manager_id IS NOT NULL;  -- 근무하는 부서 수

-- 직원 수 월급합 월급평균 최대월급 최소월급
SELECT COUNT(DEPARTMENT_ID) 직원수,
       SUM(SALARY) 월급합,
       ROUND(AVG(SALARY),3) 월급평균,
       MAX(SALARY) 최대월급,
       MIN(SALARY) 최소월급
FROM employees; 


-- SQL문 실행순서
-- 1. FROM
-- 2. WHERE
-- 3. SELECT
-- 4. ORDER BY
-- 60번 부서 인원수 월급합 월급평균
SELECT COUNT(DEPARTMENT_ID) 인원수,
       SUM(SALARY) 월급합,
       AVG(SALARY)월급평균
FROM employees
WHERE department_id = 60;

-- 부서 50,60,80 부서가 아닌 인원수 월급합 월급평균
SELECT COUNT(DEPARTMENT_ID) 인원수,
       SUM(SALARY) 월급합,
       ROUND(AVG(SALARY),2)월급평균
FROM employees 
WHERE department_id NOT IN (50,60,80);

--------------------------------------------------------------------------------













