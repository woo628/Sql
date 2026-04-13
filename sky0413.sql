-- DDL : DATA DEFINITION LANGUAGE
-- 구조를 생성, 변경, 제거
-- CREATE / ALTER / DROP

-- 새로운 계정
-- ID : SKY 
-- PASSWORD: 1234
--SQLPLUS /NOLOG
--SQL> conn /as sysdba
--SQL> alter session set "_ORACLE_SCRIPT"=true;
--SQL> create user SKY identified by 1234;
--SQL> GRANT CONNECT, RESOURCE TO SKY;
--SQL> ALTER USER SKY DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--SQL> CONN SKY/1234

-- SKY 에서 HR 계정의 DATA 가져오기
-- SQLPLUS 에서 작업
-- 1. HR로 로그인
--    SQLPLUS HR/1234
-- 2. HR에서 다른계정인 SKY에게 SELECT 할 수 있는 권한을 부여
--    SQL> GRANT SELECT ON EMPLOYEES TO SKY;
-- 3. SKY로 로그인
--    SQL> CONN SKY/1234
-- 4. SKY에서 HR계정의 EMPLOYEES 조회
--    SQL> SELECT * FROM HR.EMPLOYEES;
--------------------------------------------------------------------------------
-- ORACLE의 TABLE 복사
-- HR의 EMPLOYEES TABLE 복사해서 SKY로 가져오기
-- 1) 테이블생성
--  1. 테이블 복사 (대상: 테이블 구조, 데이터(제약조건의 일부(NULL 관련))
CREATE TABLE EMP1 
    AS
      SELECT * FROM HR.EMPLOYEES;
--  2. 50,80 부서만 
CREATE TABLE EMP2 
    AS
      SELECT * FROM HR.EMPLOYEES
      WHERE DEPARTMENT_ID IN (50,80);
-- 3. DATA빼고 구조만
CREATE TABLE EMP3 
    AS
      SELECT * FROM HR.EMPLOYEES
      WHERE 1 = 0;
-- 4. 구조만 복사된 TABLE(EMP3)에 DATA만 추가
CREATE TABLE EMP4 
    AS
      SELECT * FROM HR.EMPLOYEES
      WHERE 1 = 0;    
-- DATA 만 추가
  INSERT INTO EMP4
    SELECT * FROM HR.EMPLOYEES;
    COMMIT;
      
      
      
      
      
      
      
      
      
      
      
      
      