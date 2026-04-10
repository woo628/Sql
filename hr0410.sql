 --함수
 --숫자
1. ABS() 
2. CEIL(N) 과 FLOOR(N) -> 정수형
   
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
      FROM DUAL; -- CEIL  : 무조건 올림
      
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001)
      FROM DUAL; -- FLOOR : 버림
 
SELECT FLOOR(-10.123), FLOOR(-10.541), FLOOR(-11.001)
      FROM DUAL; -- -11, -11, -12  항상 더 작은 정수 쪽으로 이동

SELECT TRUNC(-10.123), TRUNC(-10.541), TRUNC(-11.001)
      FROM DUAL; --  -10, -10, -11 소수점 버림
 
 3. ROUND(n, i)와 TRUNC(n1, n2)
 
SELECT ROUND(10.154, 1), ROUND(10.154, 2), ROUND(10.154, 3)
      FROM DUAL;  --   10.2           10.15          10.154
      
SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.155, -2)
      FROM DUAL;  -- 0                120               100
 
SELECT TRUNC(115.155), TRUNC(115.155, 1), TRUNC(115.155, 2), TRUNC(115.155, -2)
      FROM DUAL;  -- 115            115.1           115.15                100
      
 4.  POWER(n2, n1)와 SQRT(n)
POWER: n2를 n1 제곱한 결과를 반환 n1은 정수와 실수 모두 올 수 있는데
       n2가 음수일 때 n1은 정수만 올 수 있다
SQRT: n의 제곱근을 반환

SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.0001)
      FROM DUAL; --  9        27       27.0029664

SELECT SQRT(2), SQRT(5)
      FROM DUAL; -- 1.41421356     2.23606798
 
 5. MOD(n2, n1)와 REMAINDER(n2, n1)
MOD n2를 n1으로 나눈 나머지 값을 반환 / MOD → n2 - n1 * FLOOR (n2/n1)
REMAINDER n2를 n1으로 나눈 나머지 값을 반환 / REMAINDER → n2 - n1 * ROUND (n2/n1)

SELECT MOD(19,4), MOD(19.123, 4.2)
      FROM DUAL; --  3           2.323
      
SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2)
      FROM DUAL; -- -1                -1.877

 6. EXP(n), LN(n) 그리고 LOG(n2, n1)
EXP 지수 함수 e(e=2.71828183…)의 n제곱 값을 반환
LN  자연 로그 함수로 밑수가 e인 로그 함수
LOG n2를 밑수로 하는 n1의 로그 값을 반환

SELECT EXP(2), LN(2.713), LOG(10, 100)
      FROM DUAL; --  7.3890561  0.998055034           2
      
 7. SIN(), COS(), TAN() : DEGREE(도) -> RADIAN (원주율/100 * 각도)

-- 문자
1. INITCAP(char) 첫대나머지소, LOWER(char) 소, UPPER(char) 대

2. CONCAT(char1, char2), SUBSTR(char, pos, len), SUBSTRB(char, pos, len)
--                       음수는 맨끝                                                       

3. LTRIM(char, set), RTRIM(char, set)
-- set으로 지정된 문자열을 왼쪽, 오른쪽 끝에서 제거
-- 보통 LTRIM과 RTRIM은 주어진 문자열에서 좌측 혹은 우측의 공백을 제거할 때 많이 사용
-- 공백 제거는 그냥 TRIM 사용

4. LPAD(expr1, n, expr2), RPAD(expr1, n, expr2)
-- 매개변수로 들어온 expr2 문자열(생략할 때 디폴트는 공백 한 문자)을
-- n자리만큼 왼쪽, 오른쪽부터 채워 expr1을 반환하는 함수
-- 은행에서 주로 사용
-- 실제 데이터는 그대로 UPDATE 해야함

5. REPLACE(char, search_str, replace_str), TRANSLATE(expr, FROM_str, to_str)
-- 글자 변환 TRANSLATE 는 한글자씩 바꿈

6. INSTR(str, substr, pos, occur), LENGTH(chr), LENGTHB(chr)
-- = INDEX OF

-- 날짜
1. SYSDATE, SYSTIMESTAMP
2. ADD_MONTHS (date, integer)
3. MONTHS_BETWEEN(date1, date2)
4. LAST_DAY(date)
5. ROUND(date, format), TRUNC(date, format)
6. NEXT_DAY (date, char)

-- 변환함수
1. TO_CHAR (숫자 혹은 날짜, format)
--                        ($, L, 자리보다 더많을 때0은 0을채우고, 9는 없앤다)
--          123.45678, '99,990.000' = 소수이하자동반올림 3자리로
2. TO_NUMBER(expr, format)
3. TO_DATE(char, format), TO_TIMESTAMP(char, format)

-- NULL 함수
1. NVL(expr1, expr2), NVL2((expr1, expr2, expr3)
2. COALESCE (expr1, expr2, …)
3. LNNVL(조건식)
4. NULLIF (expr1, expr2)

-- 기타함수
1. GREATEST(expr1, expr2, …), LEAST(expr1, expr2, …)
--     가장큰값                 가장작은값
2. DECODE (expr, search1, result1, search2, result2, …, default)

--------------------------------------------------------------------------------
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
    
-- 직원번호, 담당업무, 담당업무 히스토리
 SELECT EMPLOYEE_ID, JOB_ID FROM EMPLOYEES
 UNION 
 SELECT EMPLOYEE_ID, JOB_ID FROM JOB_HISTORY
 
 SELECT *
 FROM (SELECT EMPLOYEE_ID, JOB_ID FROM EMPLOYEES
 UNION 
 SELECT EMPLOYEE_ID, JOB_ID FROM JOB_HISTORY) -- INLINE VIEW
 ORDER BY EMPLOYEE_ID;
 
  -- 사번 업무시작일, 업무종료일, 담당업무, 부서번호
SELECT E.FIRST_NAME ||' '|| E.LAST_NAME 직원이름,
       A.*
FROM
(SELECT EMPLOYEE_ID 사번,
        TO_CHAR(HIRE_DATE,'YYYY-MM-DD') 업무시작일,
        '재직중' 업무종료일,
        JOB_ID 담당업무,
        DEPARTMENT_ID 부서번호
FROM EMPLOYEES
UNION
SELECT  EMPLOYEE_ID 사번,
        TO_CHAR(START_DATE,'YYYY-MM-DD') 업무시작일,
        TO_CHAR(END_DATE,'YYYY-MM-DD') 업무종료일,
        JOB_ID 담당업무,
        DEPARTMENT_ID 부서번호
FROM JOB_HISTORY) A
JOIN EMPLOYEES E 
    ON (E.EMPLOYEE_ID = A.사번)
ORDER BY 사번, 업무시작일; 

--------------------------------------------------------------------------------
VIEW : 뷰 -- SQL문을 저장해놓고 TABLE 처럼 호출해서 사용하는 객체
1) INLINE VIEW -> SELECT 할때만 VIEW로 작동 : 임시존재

SELECT *
FROM (
    SELECT  EMPLOYEE_ID 사번,
            FIRST_NAME||' '||LAST_NAME 이름, 
            EMAIL ||'@GREEN.COM' 이메일,
            PHONE_NUMBER 전화
    FROM EMPLOYEES
    ORDER BY 이름) T
WHERE T.사번 IN (100,101,102);

SELECT *
FROM (
    SELECT  DEPARTMENT_ID DEPT_ID,
            COUNT(SALARY) CNT_SAL, 
            SUM(SALARY) SUM_SAL,
            ROUND(AVG(SALARY)) AVG_SAL
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
    ORDER BY DEPT_ID) T
WHERE T.AVG_SAL >= 4000;

2) 일반적인 VIEW -> 영구저장된 객체
-- OR REPLACE 계속 만듬 수정용?
CREATE OR REPLACE VIEW "HR"."VIEW_EMP"("사번","이름","이메일","전화") 
AS
SELECT  EMPLOYEE_ID 사번,
        FIRST_NAME||' '||LAST_NAME 이름, 
        EMAIL ||'@GREEN.COM' 이메일,
        PHONE_NUMBER 전화
    FROM EMPLOYEES
    ORDER BY 이름;
    
--------------------------------------------------------------------------------
SELECT * FROM VIEW_EMP
WHERE UPPER(이름) LIKE '%KING%';

--------------------------------------------------------------------------------
-- WITH : 가상의 테이블
 
 WITH A ("사번","이름","이메일","전화")
    AS (
    SELECT  EMPLOYEE_ID 사번,
            FIRST_NAME||' '||LAST_NAME 이름, 
            EMAIL ||'@GREEN.COM' 이메일,
            PHONE_NUMBER 전화
    FROM EMPLOYEES
    ORDER BY 이름)

SELECT * FROM A;

--------------------------------------------------------------------------------
SELF JOIN
-- 직원번호, 직속상사번호
SELECT EMPLOYEE_ID 직원번호,
       MANAGER_ID 직속상사번호
FROM EMPLOYEES;

-- 직원이름, 직속상사이름 // 상사정보 E1 부하정보 E2
SELECT E2.FIRST_NAME||' '||E2.LAST_NAME 부하이름, 
       E1.FIRST_NAME||' '||E1.LAST_NAME 상사이름
FROM EMPLOYEES E1,
     EMPLOYEES E2
WHERE E1.EMPLOYEE_ID = E2.MANAGER_ID
ORDER BY E1.EMPLOYEE_ID; -- 사장 출력 X

SELECT E2.EMPLOYEE_ID 사번,
       E2.FIRST_NAME||' '||E2.LAST_NAME 부하이름, 
       E1.FIRST_NAME||' '||E1.LAST_NAME 상사이름
FROM EMPLOYEES E1
RIGHT JOIN EMPLOYEES E2
    ON (E1.EMPLOYEE_ID = E2.MANAGER_ID)
ORDER BY 사번;

-------------------------------------------------------------------------------
-- 계층형 쿼리 (Hierarchical Query)
-- LEVEL : 예약어, 계층레벨

SELECT E.EMPLOYEE_ID 직원번호,
       LPAD(' ' , 3 * (LEVEL-1))||E.FIRST_NAME||' '||E.LAST_NAME 이름,
       LEVEL,
       D.DEPARTMENT_NAME 부서명
FROM EMPLOYEES E
JOIN DEPARTMENTS D
    ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
START WITH E.MANAGER_ID IS NULL
CONNECT BY PRIOR E.EMPLOYEE_ID = E.MANAGER_ID ;
       
--------------------------------------------------------------------------------
-- 등가조인(EQUI JOIN) : 조인조건이 = 인 것들
-- 비등가조인(NON-EQUI JOIN) : 조인조건이 = 이 아닌것들

SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급,
       CASE
       WHEN SALARY > 20000 THEN 'S'
       WHEN SALARY BETWEEN 15001 AND 20000 THEN 'A'
       WHEN SALARY BETWEEN 10001 AND 15000 THEN 'B'
       WHEN SALARY BETWEEN 5001 AND 10000 THEN 'C'
       WHEN SALARY BETWEEN 3001 AND 5000 THEN 'D'
       WHEN SALARY BETWEEN 0 AND 3000 THEN 'E'
       ELSE '등급없음'
       END 등급
FROM EMPLOYEES;

-- 등급테이블
DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
( GRADE VARCHAR2(1) PRIMARY KEY,
  LOSAL NUMBER(11),
  HISAL NUMBER(11) );

INSERT INTO SALGRADE VALUES ('S',20001,99999999999);
INSERT INTO SALGRADE VALUES ('A',15001,20000);
INSERT INTO SALGRADE VALUES ('B',10001,15000);
INSERT INTO SALGRADE VALUES ('C',5001,10000);
INSERT INTO SALGRADE VALUES ('D',3001,5000);
INSERT INTO SALGRADE VALUES ('E',0,3000);
COMMIT;

SELECT E.EMPLOYEE_ID 직원번호,
       E.FIRST_NAME||' '||E.LAST_NAME 직원명,
       E.SALARY 월급,
       NVL(G.GRADE,'등급없음') 등급
FROM EMPLOYEES E
LEFT JOIN SALGRADE G
    ON (E.SALARY BETWEEN G.LOSAL AND G.HISAL)
ORDER BY 직원번호;   

--------------------------------------------------------------------------------
-- 분석함수 , WINDOW 함수
-- ROW_NUMBER() : 줄번호 (1,2,3,4,5....)
-- RANK() : 석차 (1,2,2,4,5,5,7....)
-- DENSE_RANK() : 석차 (1,2,2,3,4,5,5,6....)
-- NTILE() : 그룹으로 분류
-- LIST_AGG() 

-- ROW_NUMBER
SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급
FROM EMPLOYEES
ORDER BY 월급 DESC NULLS LAST; -- NULL 맨밑

-- 자료 10개 출력(페이징 기술)
-- 1. OLD 문법 ROWNUM (의사칼럼) 비추
SELECT ROWNUM,
       EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급
FROM EMPLOYEES
WHERE ROWNUM BETWEEN 1 AND 10;
-- 정렬하기엔 좋지않다 번잡하다

-- 2. ANSI(NEW) 문법 : ROW_NUMBER 
SELECT *
FROM(
SELECT ROW_NUMBER() OVER (ORDER BY SALARY DESC NULLS LAST) RN,
       EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급
FROM EMPLOYEES) T
WHERE T.RN BETWEEN 1 AND 10;

-- 3. OFFSET  (ORACLE 12부터)
SELECT * 
FROM EMPLOYEES
ORDER BY SALARY DESC NULLS LAST
OFFSET 11 ROWS FETCH NEXT 10 ROWS ONLY;
-- 11 부터 10개 : ROW_NUMBER보다 속도가 빠르다

--------------------------------------------------------------------------------
-- RANK()
SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급,
       RANK() OVER (ORDER BY SALARY DESC NULLS LAST) 석차
FROM EMPLOYEES;

-- 1 ~ 10등
SELECT * FROM 
(SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급,
       RANK() OVER (ORDER BY SALARY DESC NULLS LAST) 석차
FROM EMPLOYEES) T
WHERE T.석차 BETWEEN 1 AND 10;

-- DENSE_RANK()
SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급,
       DENSE_RANK() OVER (ORDER BY SALARY DESC NULLS LAST) 석차
FROM EMPLOYEES;

-- 1 ~ 11등
SELECT * FROM 
(SELECT EMPLOYEE_ID 직원번호,
       FIRST_NAME||' '||LAST_NAME 직원명,
       SALARY 월급,
       DENSE_RANK() OVER (ORDER BY SALARY DESC NULLS LAST) 석차
FROM EMPLOYEES) T
WHERE T.석차 BETWEEN 1 AND 10;
--------------------------------------------------------------------------------
-- LISTAGG() 여러줄을 한줄짜리 문자열로 변경 세로-> 가로
SELECT DEPARTMENT_ID FROM EMPLOYEES;
SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES;

SELECT LISTAGG(DISTINCT DEPARTMENT_ID,',') 
    WITHIN GROUP(ORDER BY DEPARTMENT_ID DESC) -- 정렬할때
FROM EMPLOYEES;
--------------------------------------------------------------------------------















