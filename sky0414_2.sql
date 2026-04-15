-- 성적처리 테이블
업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
--------------------------------------------------------------------------------

CREATE TABLE STUDENT (
    STID NUMBER(6) PRIMARY KEY
    ,STNAME VARCHAR2(30) NOT NULL
    ,PHONE VARCHAR2(20) UNIQUE
    ,INDATE DATE DEFAULT SYSDATE );

CREATE TABLE SCORES (
    SCID NUMBER(7) NOT NULL
    ,SUBJECT VARCHAR2(60) NOT NULL
    ,SCORE NUMBER(3) CHECK(SCORE BETWEEN 0 AND 100)
    ,STID NUMBER(6)
    ,CONSTRAINT SCID_PK PRIMARY KEY (SCID,SUBJECT)
    ,CONSTRAINT STID_FK FOREIGN KEY (STID) 
     REFERENCES STUDENT(STID)
    );
    
-- 학생정보
INSERT INTO STUDENT (STID,STNAME,PHONE,INDATE)
             VALUES (1, '가나', '010', SYSDATE);
INSERT INTO STUDENT 
            VALUES (2, '나나', '011', SYSDATE); -- 타입과 개수가 맞으면 생략가능            
INSERT INTO STUDENT (STID,STNAME,PHONE)
            VALUES (3, '다나', '012');            
INSERT INTO STUDENT (STID,STNAME,PHONE)
            VALUES (4, '라나', '013');            
INSERT INTO STUDENT (STID,STNAME,PHONE)
            VALUES (5, '라나', '014');            
INSERT INTO STUDENT (STID,STNAME,PHONE)
            VALUES (6, '하나', '019');
COMMIT;
-- (NULL,'사나','015'), (5,'라나','014'), (6, '하나', '014'), (7,'NULL','018')
--      NOT NULL         기본키중복 X          PHONE 중복        NOT NULL

-- 성적정보
INSERT INTO SCORES (SCID,SUBJECT,SCORE,STID)
            VALUES (1, '국어', 100, 1);
INSERT INTO SCORES VALUES (2, '영어', 100, 1);
INSERT INTO SCORES VALUES (3, '수학', 100, 1);
INSERT INTO SCORES VALUES (4, '국어', 100, 2);
INSERT INTO SCORES VALUES (5, '수학', 80, 2);
INSERT INTO SCORES VALUES (6, '국어', 70, 4);
INSERT INTO SCORES VALUES (7, '영어', 80, 4);
INSERT INTO SCORES VALUES (8, '수학', 85, 4);
INSERT INTO SCORES VALUES (9, '국어', 805, 5); -- 체크제약위반
INSERT INTO SCORES VALUES (10, '영어', 100, 8); -- 8번학생의 데이터없음(부모키X)
--------------------------------------------------------------------------------
-- DML 추가 수정 삭제 : COMMIT 필수
-- INSERT - 줄(DATA)단위 추가
-- 1. INSERT INTO 테이블명() VALUES ();
-- 2. INSERT INTO 테이블명 SELECT * FROM 테이블명; - 여러줄 추가
-- 3. 신규문법 여러줄 추가
--    INSERT ALL 
--       INTO 테이블명() VALUES()
--       INTO 테이블명() VALUES()
--       INTO 테이블명() VALUES()
--       SELECT * FROM DUAL;

-- DELETE - 줄(DATA)단위 삭제, 기본적으로 여러줄 대상  WHERE 없으면 전체 대상
-- 1. DELETE FROM 테이블명 WHERE 조건;
-- 해당하는 자식레코드 있으면 부모 레코드 삭제 못함

-- UPDATE - 줄에 변화는 없고 칸에 있는 정보만 수정, WHERE 없으면 전체 대상
-- 1. UPDATE 테이블명 SET 칼럼1 = 고칠값1 WHERE 조건;
--------------------------------------------------------------------------------
-- DATA 제거
-- 1. DROP TABLE 테이블명; - 구조(테이블), DATA 모두삭제 복구불가
-- 2. TRUNCATE TABLE 테이블명; - 구조 남기고 DATA만 삭제 속도 빠름
-- 3. DELETE FROM 테이블명; - 구조 남기고 DATA만 삭제 속도 느림
--------------------------------------------------------------------------------
-- SET TIMING ON; - SQL 쿼리 수행 시간을 측정
--------------------------------------------------------------------------------
-- 학생정보처리
-- 학번, 이름, 점수(국어)
SELECT A.STID 학번,
       A.STNAME 이름,
       B.SCORE 점수
FROM STUDENT A
JOIN SCORES B
    ON (A.STID = B.STID)
WHERE B.SUBJECT = '국어';

-- 모든 학생의 학번 이름 총점 평균
SELECT A.STID  학번,
       A.STNAME 이름,
       SUM(B.SCORE) 총점,
       ROUND(AVG(B.SCORE)) 평균
FROM STUDENT A
LEFT JOIN SCORES B
    ON (A.STID = B.STID)
GROUP BY A.STID, A.STNAME
ORDER BY 학번;

-- 점수가 NULL 인 학생은 '미응시'
SELECT A.STID 학번,
       A.STNAME 이름,
       DECODE(SUM(B.SCORE),NULL,'미응시',SUM(B.SCORE)) 총점,
       DECODE(ROUND(AVG(B.SCORE)),NULL,'미응시',ROUND(AVG(B.SCORE))) 평균
--     CASE WHEN ROUND(AVG(B.SCORE) IS NULL THEN '미응시' 
--           ELSE TO_CHAR(AVG(B.SCORE),'990.00') END 평균        
FROM STUDENT A
LEFT JOIN SCORES B
    ON (A.STID = B.STID)
GROUP BY A.STID, A.STNAME
ORDER BY 학번;

-- 모든 학생의 학번 이름 총점 평균 등급 석차
SELECT A.STID 학번,
       A.STNAME 이름,
       DECODE(SUM(SCORE),NULL,'미응시',SUM(SCORE)) 총점,
       DECODE(ROUND(AVG(SCORE)),NULL,'미응시',ROUND(AVG(SCORE))) 평균,
       CASE
       WHEN ROUND(AVG(SCORE)) >= 90 THEN 'A'
       WHEN ROUND(AVG(SCORE)) >= 80 THEN 'B'
       WHEN ROUND(AVG(SCORE)) >= 70 THEN 'C'
       WHEN ROUND(AVG(SCORE)) >= 60 THEN 'D'
       WHEN ROUND(AVG(SCORE)) >= 50 THEN 'E'
       ELSE 'F'                       END 등급,
       RANK() OVER (ORDER BY ROUND(AVG(SCORE)) DESC NULLS LAST) 석차
FROM STUDENT A
LEFT JOIN SCORES B
    ON (A.STID = B.STID)
GROUP BY A.STID, A.STNAME;

-- 모든 학생의 학번 이름 국어 영어 수학 총점 평균 등급 석차
SELECT A.STID 학번,
       A.STNAME 이름,
       DECODE(MAX(CASE WHEN B.SUBJECT = '국어' THEN B.SCORE END),NULL,'미응시',MAX(CASE WHEN B.SUBJECT = '국어' THEN B.SCORE END)) 국어,
       DECODE(MAX(CASE WHEN B.SUBJECT = '영어' THEN B.SCORE END),NULL,'미응시',MAX(CASE WHEN B.SUBJECT = '영어' THEN B.SCORE END)) 영어,
       DECODE(MAX(CASE WHEN B.SUBJECT = '수학' THEN B.SCORE END),NULL,'미응시',MAX(CASE WHEN B.SUBJECT = '수학' THEN B.SCORE END)) 수학,
       DECODE(SUM(B.SCORE),NULL,'미응시',SUM(B.SCORE)) 총점,
       DECODE(ROUND(AVG(B.SCORE)),NULL,'미응시',ROUND(AVG(B.SCORE))) 평균,
       CASE
       WHEN ROUND(AVG(B.SCORE)) >= 90 THEN 'A'
       WHEN ROUND(AVG(B.SCORE)) >= 80 THEN 'B'
       WHEN ROUND(AVG(B.SCORE)) >= 70 THEN 'C'
       WHEN ROUND(AVG(B.SCORE)) >= 60 THEN 'D'
       WHEN ROUND(AVG(B.SCORE)) >= 50 THEN 'E'
       ELSE 'F'                       END 등급,
       RANK() OVER (ORDER BY ROUND(AVG(B.SCORE)) DESC NULLS LAST) 석차
FROM STUDENT A
LEFT JOIN SCORES B
    ON (A.STID = B.STID)
GROUP BY A.STID, A.STNAME;

-- 비등가 조인
CREATE TABLE SCOREGRADE(
    GRADE VARCHAR2(1) PRIMARY KEY,
    LOSCORE NUMBER(6,2),
    HISCORE NUMBER(6,2)
);
INSERT INTO SCOREGRADE VALUES ('A',90,100);
INSERT INTO SCOREGRADE VALUES ('B',80,89.99);
INSERT INTO SCOREGRADE VALUES ('C',70,79.99);
INSERT INTO SCOREGRADE VALUES ('D',60,69.99);
INSERT INTO SCOREGRADE VALUES ('F',0,59.99);
COMMIT;

--
SELECT  T.학번, T.이름,
        DECODE(T.국어,NULL,'미응시',T.국어) 국어,
        DECODE(T.영어,NULL,'미응시',T.영어) 영어,
        DECODE(T.수학,NULL,'미응시',T.수학) 수학,
        DECODE(T.총점,NULL,'미응시',T.총점) 총점,
        DECODE(T.평균,NULL,'미응시',T.수학) 평균,
        DECODE(SG.GRADE,NULL,'미응시',SG.GRADE) 등급,
        RANK() OVER (ORDER BY T.총점 DESC NULLS LAST) 석차
FROM
(SELECT A.STID 학번,
        A.STNAME 이름,
        SUM(DECODE(B.SUBJECT,'국어',B.SCORE)) 국어,
        SUM(DECODE(B.SUBJECT,'영어',B.SCORE)) 영어,
        SUM(DECODE(B.SUBJECT,'수학',B.SCORE)) 수학,
        SUM(SCORE) 총점,
        ROUND(AVG(SCORE),2) 평균
FROM STUDENT A
LEFT JOIN SCORES B
    ON (A.STID = B.STID)
GROUP BY A.STID, A.STNAME ) T
LEFT JOIN SCOREGRADE SG
    ON (T.평균 BETWEEN SG.LOSCORE AND SG.HISCORE);

--------------------------------------------------------------------------------
-- PIVOT 사용 (통계를 생성, 집계함수 사용)
-- 학번 국어 영어 수학
SELECT * FROM (
    SELECT STID,SUBJECT,SCORE
    FROM SCORES )
PIVOT (
    SUM(SCORE)
    FOR SUBJECT
        IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
);
-- 학번 이름 국어 영어 수학 총점 평균 등급 석차
SELECT ST.STID 학번,
       ST.STNAME 이름,
       T.국어,
       T.영어,
       T.수학,
       (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) 총점,
       (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0))/3 평균,
       SG.GRADE 등급,
       RANK() OVER(ORDER BY (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) 
                   DESC NULLS LAST) 석차
FROM(
    SELECT * FROM (
        SELECT STID,SUBJECT,SCORE
        FROM SCORES )
    PIVOT (
        SUM(SCORE)
        FOR SUBJECT
            IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
    )) T
RIGHT JOIN STUDENT ST
    ON (T.STID = ST.STID)
LEFT JOIN SCOREGRADE SG
    ON ((NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0))/3 
          BETWEEN SG.LOSCORE AND SG.HISCORE);



























