-- 접속 계정(같이 공유 // 서버인 사람의 계정)
-- insert & commit
-- 호스트 이름: 접속할 ip 주소
-- 포트: 1521 (방화벽 인바운드,아웃바운드 1521 추가)
-- SID : ex

INSERT INTO myclass VALUES (13,'최영우','010-3321-0495','duddn2500@naver.com',SYSDATE);
COMMIt;

SELECT * FROM myclass ORDER BY 번호 ASC;