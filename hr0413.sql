-- 부프로그램 : 프로시저, 함수
-- 1. 프로시저 PROEDURE - 함수보다 많이 사용
--   : 함수의 리턴값이 0개 이상
--     STORED PROCEDURE : 저장 프로시저
-- 2. 함수 FUNCTION
--   : 함수의 리턴값이 반드시 1개
-- 함수를 만든다, 사용자 정의 함수 (USER DEFINE FUNCTION)
--------------------------------------------------------------------------------
-- 107번 직원의 이름과 월급 조회
SELECT FIRST_NAME||' '||LAST_NAME 이름,
       SALARY 월급
FROM employees
WHERE EMPLOYEE_ID = 107;

-- 익명 프로시저
SET SERVEROUTPUT ON;
DECLARE V_NAME VARCHAR2(46); V_SAL NUMBER(8,2);
BEGIN V_NAME := '카리나'; V_SAL := 10000;
      DBMS_OUTPUT.PUT_LINE(V_NAME);
      DBMS_OUTPUT.PUT_LINE(V_SAL);
      IF V_SAL >= 1000 THEN
      DBMS_OUTPUT.PUT_LINE('GOOD');
      ELSE
      DBMS_OUTPUT.PUT_LINE('NOT GOOD');
      END IF;
END;
/

-- 저장 프로시저 IN: INPUT, OUT: OUTPUT, INOUT: INPUTOUT
CREATE PROCEDURE GET_EMPSAL (IN_EMPID IN NUMBER)
      IS
       V_NAME VARCHAR2(46);
       V_SAL NUMBER(8,2);
      BEGIN
       SELECT FIRST_NAME||' '||LAST_NAME, SALARY
            INTO V_NAME, V_SAL
       FROM employees
       WHERE EMPLOYEE_ID = IN_EMPID;
       DBMS_OUTPUT.PUT_LINE('이름:'|| V_NAME);
       DBMS_OUTPUT.PUT_LINE('월급:'|| V_SAL);
      END;
         
-- 부서번호입력, 해당부서의 최고월급자의 이름, 월급
SELECT FIRST_NAME||' '||LAST_NAME 이름,
       MAX(SALARY) 월급,
       DEPARTMENT_ID 부서번호
FROM employees
GROUP BY FIRST_NAME||' '||LAST_NAME,DEPARTMENT_ID;


-- 90번 부서번호입력, 직원들출력
SELECT FIRST_NAME||' '||LAST_NAME 이름,
       DEPARTMENT_ID 부서번호
FROM employees
WHERE DEPARTMENT_ID = 90;