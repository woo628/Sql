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
-- DATA 만 추가 DATA 추가할때는 커밋필수
  INSERT INTO EMP4
    SELECT * FROM HR.EMPLOYEES;
    COMMIT;
-- 5. 일부칼럼만 복사해서 새로운 테이블 생성
CREATE TABLE EMP5
    AS
      SELECT EMPLOYEE_ID EMPID,
             FIRST_NAME||' '||LAST_NAME ENAME,
             SALARY SAL,
             SALARY * COMMISSION_PCT BONUS,
             MANAGER_ID MGR,
             DEPARTMENT_ID DEPTID
      FROM HR.EMPLOYEES;
--------------------------------------------------------------------------------      
-- SQLDEVELOPER 메뉴에서 TABLE 생성
-- SKY 계정 -> 테이블 메뉴 -> 새 테이블 
-- 칼럼 설정, 기본키 설정 

-- SCRIPT로 생성
CREATE TABLE EMP7
(
  EMPID NUMBER(8,2) NOT NULL 
, ENAME VARCHAR2(46) NOT NULL
, TEL VARCHAR2(20) 
, EMAIL VARCHAR2(320) 
, CONSTRAINT EMP7_PK PRIMARY KEY 
  (
    EMPID 
  )
  ENABLE 
);

--------------------------------------------------------------------------------
-- 테이블 제거(DROP) - 영구적으로 구조와 데이터가 제거
-- 1. DROP TABLE 테이블명;
--    DROP 되는 테이블이 부모테이블인 경우 자식을 먼저 지워야 제거가능
--    단, CASCADE 를 사용하면 부모자식관계의 데이터를 전체 삭제
--------------------------------------------------------------------------------
-- 테이블 변경(ALTER)
-- 1. 칼럼 추가 - 추가된 칼럼은 NULL
ALTER TABLE EMP5 
    ADD (LOC VARCHAR2(6)); 
-- 2. 칼럼 제거
ALTER TABLE EMP5
    DROP COLUMN LOC;
-- 3. 테이블 이름 변경 - ORACLE 전용
RENAME EMP5 TO NEWEMP;
-- 4. 칼럼 속성 변경 - 데이터 크기 수정
ALTER TABLE EMP5 
    MODIFY (ENAME VARCHAR2(60)); -- 46 -> 60 / 데이터를 줄일 땐 조심 날아감
--------------------------------------------------------------------------------
-- 데이터가져와서 테이블 생성
-- ZIPCODE, SIDO, GUGUN, DONG, BUNJI, SEQ
-- 우편번호 시도  구군  읍면동  번지 일련번호

CREATE TABLE ZIPCODE
(
ZIPCODE VARCHAR2(7),
SIDO VARCHAR2(6),
GUGUN VARCHAR2(26),
DONG VARCHAR2(78),
BUNJI VARCHAR2(26),
SEQ NUMBER(5) PRIMARY KEY
);

-- ZIPCODE 선택후 데이터 임포트 

SELECT * FROM ZIPCODE;
SELECT COUNT(*) FROM ZIPCODE;

SELECT COUNT(*) FROM ZIPCODE
WHERE SIDO = '부산';

-- 시도별 우편번호 갯수
SELECT SIDO 시도,
       COUNT(ZIPCODE) 우편번호갯수
FROM ZIPCODE
GROUP BY SIDO;

SELECT COUNT(ZIPCODE), COUNT(DISTINCT ZIPCODE)
FROM ZIPCODE;

SELECT '['||ZIPCODE||']'||
        SIDO||' '||
        GUGUN||' '||
        DONG||' '||
        BUNJI  AS ADDRESS
FROM ZIPCODE
WHERE DONG LIKE '%부전2동%'
ORDER BY SEQ;








      
      
      
      
      
      
      
      