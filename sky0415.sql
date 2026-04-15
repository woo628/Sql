-- 시퀀스(SEQUENCE) : 번호자동증가
-- 번호칼럼에 자동으로 번호를 증가

CREATE TABLE TABLE1 (
    ID NUMBER(6) PRIMARY KEY,
    TITLE VARCHAR2(400),
    MEMO VARCHAR2(4000)
);

--INSERT INTO TABLE1 VALUES (1,'A','AAAA');
--INSERT INTO TABLE1 VALUES (2,'B','ㅋㅋㅋㅋ');
--INSERT INTO TABLE1 VALUES (3,'A','ㅇㅇ');

CREATE SEQUENCE SEQ_ID;
-- SEQ_ID.NEXTVAL 시퀀스의 새로운 번호 발급
-- SEQ_ID.CURRVAL 시퀀스의 현재번호 
-- 중간에 데이터의 삭제가 되면 빈 번호공간이 생긴다
-- 대체방안 
-- INSERT INTO TABLE1 VALUES ((SELECT NVL(MAX(ID),0)+1 FROM TABLE1)),'A','AAAA');
-- 대신 데이터가 없으면 오류나니깐 NVL 사용

INSERT INTO TABLE1 VALUES (seq_id.nextval,'A','AAAA');
INSERT INTO TABLE1 VALUES (seq_id.nextval,'B','ㅋㅋㅋㅋ');
INSERT INTO TABLE1 VALUES (seq_id.nextval,'A','ㅇㅇ');

-- 번호자동증가
-- MSSQL : IDENTITIY, SEQUENCE
-- CREATE TABLE A(
--  ID INT IDENTITIY (1,1)) 1부터 시작해서 1씩증가  

-- MYSQL, MARIADB
-- CREATE TABLE A(
--  ID INT AUTO_INCREMENT )

--------------------------------------------------------------------------------
UPDATE TABLE1 SET ID = 1 WHERE ID = 4; -- PRIMARY KEY UPDATE 가능

-- 외래키 조건 위배(자식테이블과 겹치는 데이터 존재)
UPDATE STUDENT SET STID = 7 WHERE STID = 1; 
--------------------------------------------------------------------------------
-- 인덱스(INDEX) 찾아보기 표
-- 검색할때 해당칼럼에 인덱스를 사용하면 검색이 빨라진다
-- 단, INSERT,DELETE,UPDATE를 사용할때 새로 인덱스를 고쳐야하므로
--   추가, 수정같은 작업이 많으면 더 느려질 수 있다
-- WHERE, JOIN ON 에 사용하는 칼럼에 설정
-- PRIMARY KEY, UNIQUE -> 자동으로 인덱스 생성 
-- 검색을 자주하는 칼럼에 적용

CREATE TABLE emp_big AS
SELECT
    e.employee_id + (lv * 100000) AS employee_id,
    e.first_name,
    e.last_name,
    e.email || lv AS email,
    e.phone_number,
    e.hire_date,
    e.job_id,
    e.salary,
    e.commission_pct,
    e.manager_id,
    e.department_id
FROM hr.employees e
CROSS JOIN (
    SELECT LEVEL AS lv
    FROM dual
    CONNECT BY LEVEL <= 10000
);

SELECT COUNT(*) FROM EMP_BIG; -- 1090000

-- 인덱스가 지정된 칼럼으로 조건을 걸어서 검색할때
SET TIMING ON;
SELECT *
FROM EMP_BIG
WHERE EMAIL = 'SKING5000';

-- 인덱스 생성
CREATE INDEX IDX_EMAIL
 ON EMP_BIG(EMAIL);

--------------------------------------------------------------------------------
-- 트리거 TRIGGER 방아쇠
-- 회원정보가 추가되면 로그에 기록을 남기는 작업을 해야할 때
-- 단점: 로직추적하기 어려워 수정이어렵다
-- 회원정보와 로그기록을 두번실행해야할때
-- 자동화 회원정보 -> 트리거 -> 로그기록

-- BEFORE TRIGGER
-- AFTER TRIGGER -> INSTEAD OF

CREATE OR REPLACE TRIGGER TRG_EMP
AFTER INSERT ON EMP_BIG 
FOR EACH ROW
 BEGIN
    INSERT 로그
 END;
/
--------------------------------------------------------------------------------
-- 트랜잭션 TRANSACTION
-- 송금
-- 내계좌에서 금액 -
-- 상대계좌에서 금액 +

UPDATE MTABLE SET 내계좌 = 내계좌 - 100
UPDATE MTABLE SET 내계좌 = 내계좌 + 100

-- 위에 명령실행중 문제가 생기면 안되니 하나의 작업으로 처리
BEGIN TRAN
  UPDATE MTABLE SET 내계좌 = 내계좌 - 100  
  UPDATE MTABLE SET 내계좌 = 내계좌 + 100
  COMMIT;
 EXCEPTION
  ROLLBACK;
END;
--------------------------------------------------------------------------------
-- LOCK : DB잠김 상태
INSERT INTO TABLE1 VALUES (7,'C','ㅎㅎ');
SELECT * FROM TABLE1;
-- CMD > SQLPLUS SKY/1234 > INSERT INTO TABLE1 VALUES (7,'C','ㅎㅎ');
-- 아무반응없음 RECORD LOCK 걸린 상태
COMMIT;
-- COMMIT 후에 해당 오류 발생 











