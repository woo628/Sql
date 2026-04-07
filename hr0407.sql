SELECT * FROM tab; -- 테이블 목록 조회

--SELECT 칼럼명1 별칭1, 칼럼명2 별칭2 ...
--FROM 테이블명
--WHERE 조건
--ORDER BY 정렬할칼럼1 ASC, 정렬할칼럼2 DESC;

-- 직원이름

SELECT first_name, last_name, 
       first_name||' '||last_name EMPNAME
FROM employees
ORDER BY first_name; --ASC 생략가능
--       EMPNAME
--       3             3번째 칼럼

-- 부서번호 60인 직원정보(번호 이름 이메일 부서번호)
-- 조건(where) : =, !=, >, <, >=, <= 
--               not, and, or
SELECT employee_id 번호, first_name||' '||last_name 이름, email 이메일, department_id 부서번호
FROM employees
WHERE department_id = 60;

-- 부서번호 90인 
SELECT employee_id 번호, first_name||' '||last_name 이름, email 이메일, department_id 부서번호
FROM employees
WHERE department_id = 90;

-- 부서번호 60 ,90
SELECT employee_id 번호, first_name||' '||last_name 이름, email 이메일, department_id 부서번호
FROM employees
WHERE department_id = 60 or department_id = 90
--    department_id IN (60,90);
ORDER BY 번호; -- 번호같을때 이름순 정렬은 (, 이름) 추가

-- 월급 12000이상 번호 이름 이메일 월급을 월급순
SELECT employee_id 번호, first_name||' '||last_name 이름, email 이메일, salary 월급
FROM employees
WHERE salary >= 12000
ORDER BY 월급 DESC;

-- 월급 10000~15000
SELECT employee_id 번호, first_name||' '||last_name 이름, salary 월급
FROM employees
WHERE salary >=10000 and salary <= 15000
--    salary BETWEEN 10000 AND 15000
ORDER BY 월급 DESC;

-- 직업 id IT_PROG
SELECT employee_id 번호, first_name||' '||last_name 이름, job_id 직업ID
FROM employees
WHERE job_id LIKE '%IT_PROG%';
-- job id = 'IT_PROG'
-- 'it_prog'  일때는 UPPER()[대문자] LOWER()[소문자] INITCAP()[첫글자만]

-- 직원이름 GRANT
SELECT employee_id 번호, first_name||' '||last_name 이름
FROM employees
WHERE UPPER(first_name) = 'GTANT' OR UPPER(last_name) = 'GRANT';

-- 사번 월급, 10% 인상한 월급
SELECT employee_id 번호, first_name||' '||last_name 이름, salary 월급, salary * 1.1 월급2 
FROM employees
ORDER BY 월급 DESC;

-- 50번 부서의 직원 명단 월급 부서번호
SELECT employee_id 번호, first_name||' '||last_name 이름, salary 월급, department_id 부서번호
FROM employees
WHERE department_id = 50;

-- 20, 80 60, 90  부서번호
SELECT employee_id 번호, first_name||' '||last_name 이름, salary 월급, department_id 부서번호
FROM employees
WHERE department_id in (20,80,60,90);

-- 전체 자료수 row의 카운트
SELECT COUNT(*)
FROM employees;

-- 오늘 날짜 (한줄만 찍을 땐 dual 사용) 
SELECT sysdate
FROM dual;

-- 새로운 데이터 추가
INSERT INTO employees
VALUES (207,'보검','박','BOKUM','1.515.555.8888',SYSDATE,'IT_PROG',null,null,null,null);

INSERT INTO employees
VALUES (208,'리나','카','RINA','1.515.555.9999',SYSDATE,'IT_PROG',null,null,null,null);

-- 수정사항 
UPDATE employees
SET email = 'KRINA', phone_number = '010-1234-5678'
WHERE employee_id = 208;
--------------------------------------------------------------------------------
COMMIT; -- 데이터에도 추가 (insert delete update) 최종상태일때만 하는거 추천
ROLLBACK; -- 이전단계로 
--------------------------------------------------------------------------------
-- 보너스 없는 직원 명단
SELECT *
FROM employees
WHERE commission_pct IS null;
--          받는 사람 IS NOT null

-- 전화번호가 010으로 시작하는
-- pattern mactching - ㅣㅑㅏㄷ
-- % : 0자 이상의 모든 숫자글자
-- _ : 1자의 모든 숫자글자
SELECT *
FROM employees
WHERE phone_number like '010%'; -- 010으로 시작하는 starts with
                -- like '%010%'    010을 포함 contains               
                -- like '%010'     010으로 끝나는 ends with 
                
-- last _name 3,4번째 글자가 LL인거
SELECT * 
FROM employees 
WHERE last_name LIKE '__ll%';

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
-- 날짜 26/04/07 : 표현법이 틀림
-- 2026-04-07 : ANSI 표준
-- 04/07/06   : 미국식 월일년
-- 07/04/26   : 영국식 일월년
SELECT sysdate FROM dual; -- 26/04/07
SELECT 7/2 FROM dual;  -- 3.5
SELECT 0/2 FROM dual;  -- 0
SELECT 2.0/0.0 FROM dual;  --  2/0 = 제수가 0입니다 
SELECT systimestamp FROM dual; -- 26/04/07 15:38:00.148000000 +09:00

SELECT sysdate -7  "일주일전날짜"
      ,sysdate     "오늘 날짜"
      ,sysdate +7  "일주일 후 날짜"
FROM dual;
-- 날짜 + n, 날짜 - : 몇 일 전 후 n
-- 날짜1 - 날짜2    : 두 날짜 사이의 차이
-- 날짜1 + 날짜2    : 오류 잘못된 표현 - 의미없음

SELECT TO_DATE('26/12/25') - sysdate FROM dual;  

-- 소수 이하 3자리로 반올림 ROUND(VAL,3)
-- 소수 이하 3자리로 절삭 TRUNC(VAL,3)
-- 15일을 기준으로 반올림한 날짜 ROUND(sysdate,'month')
-- 해당달의 첫번째 날짜 TRUNC(sysdate,'month')  
SELECT sysdate, ROUND(sysdate,'month'),TRUNC(sysdate,'month')
FROM dual;

SELECT next_day(sysdate,'월요일') FROM dual; -- 4/13 : 다음 월요일
SELECT last_day(sysdate) FROM dual;          -- 4/30 : 해당월의 마지막 날
SELECT TRUNC(sysdate,'month') FROM dual;     -- 4/1 : 해당월의 첫번째 날

-- 입사년월이 17년 2월
SELECT *
FROM employees
WHERE hire_date BETWEEN '2017-02-01' AND last_day('2017-02-01');


-- 17/02/07, 12/06/07 입사한사람
SELECT *
FROM employees
WHERE hire_date = '2017/02/07' or hire_date = '2012/06/07';

-- 오늘 '26/04/07' 입사한사람
SELECT *
FROM employees
-- WHERE hire_date like SYSDATE > 좋은 방법은 아님
              --  = '24/04/07'  안됨 비교를 24/04/07 00:00:00
WHERE '2026-04-07 00:00:00' <= hire_date and hire_date <= '2026-04-07 23:59:59';
--    TRUNC(hire_date) = '2026-04-07 00:00:00'

-- Type 변환
-- TO_DATE(문자) -> 날짜
-- TO_NUMBER(문자) -> 숫자
-- TO_CHAR(숫자,'포맷') -> 글자
-- TO_CHAR(날짜,'포맷') -> 날짜 형태의 문자
-- 포맷 : YYYY-MM-DD HH24:MI:SS DAY AM
-- YYYY : 연도
-- MM : 월
-- DD : 일
-- HH24 : 시
-- MI : 분
-- SS : 초
-- DAY : 요일 (월요일,화요일...)
-- DY : 일 (월,화...)
-- AM : 오전/오후

SELECT employee_id 사번, first_name||' '||last_name 이름, hire_date 입사일
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY-MM') = '2017-02';


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

-- 2026년 04월 07일 17시 16분 04초 오후 화요일 / 한자로출력
SELECT TO_CHAR(sysdate,'YYYY-MM-DD HH24:MI:SS am day','NLS_DATE_LANGUAGE=JAPANESE')
FROM dual;


