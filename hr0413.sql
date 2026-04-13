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
-- 파라미터는 IN_EMPID IN NUMBER : 괄호, 숫자 X
-- 내부변수는 V_NAME VARCHAR2(46); : 괄호 숫자 필요
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
      
-- 테스트
SET SERVEROUTPUT ON; --  DBMS_OUTPUT.PUT_LINE 화면 출력
CALL GET_EMPSAL(107);

-- 부서번호입력, 해당부서의 최고월급자의 이름, 월급
CREATE OR REPLACE PROCEDURE GET_NAME_MAXSAL (
        IN_DEPTID IN NUMBER, 
        O_NAME OUT VARCHAR2,
        O_SAL OUT NUMBER)
    IS
     V_MAXSAL NUMBER(8,2);
    BEGIN
    SELECT MAX(SALARY)
           INTO V_MAXSAL
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = IN_DEPTID;
    
    SELECT FIRST_NAME||' '||LAST_NAME, SALARY
        INTO O_NAME, O_SAL
    FROM EMPLOYEES
    WHERE SALARY = V_MAXSAL
    AND DEPARTMENT_ID = IN_DEPTID;
    DBMS_OUTPUT.PUT_LINE(O_NAME);
    DBMS_OUTPUT.PUT_LINE(O_SAL);
    END;
/
-- 변수가 한명분이라 공통값은 처리 X 결과 하나
SET SERVEROUTPUT ON;
VAR O_NAME VARCHAR2;
VAR O_SAL NUMBER;
CALL GET_NAME_MAXSAL(60, :O_NAME, :O_SAL);
PRINT O_NAME;
PRINT O_SAL;
--> JAVA에서 호출해서 쓴다
--------------------------------------------------------------------------------
-- 결과 여러개
-- 90번 부서번호입력, 직원들출력
CREATE OR REPLACE PROCEDURE GETEMPLIST(
        IN_DEPTID NUMBER)
    IS
     V_EMPID NUMBER(6);
     V_FNAME VARCHAR2(20);
     V_LNAME VARCHAR2(25);
     V_PHONE VARCHAR2(20);
    BEGIN
     SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER 
        INTO V_EMPID, V_FNAME, V_LNAME, V_PHONE
     FROM employees
     WHERE DEPARTMENT_ID = IN_DEPTID;
     
     DBMS_OUTPUT.PUT_LINE(V_EMPID);
    END;
/

SET SERVEROUTPUT ON;
EXECUTE GETEMPLIST(90);
-- 결과가 3줄인데 1번만 출력
-- SELECT INTO 는 결과가 한줄일때만 사용가능

-- 여러줄일때 CURSOR 사용  이 문법은 JAVA에서 읽기위해서
CREATE OR REPLACE PROCEDURE GET_EMPLIST(
        IN_DEPTID IN NUMBER,
        O_CUR OUT SYS_REFCURSOR)
    IS
    BEGIN
     OPEN O_CUR FOR
      SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER   
      FROM employees
      WHERE DEPARTMENT_ID = IN_DEPTID;  
    END;
/

VARIABLE O_CUR REFCURSOR;
EXECUTE GET_EMPLIST(50, :O_CUR)
PRINT O_CUR;






























