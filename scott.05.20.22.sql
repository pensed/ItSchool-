SELECT * FROM TAB;
SELECT * FROM PARENT_T;
SELECT * FROM CHILD_T;

INSERT INTO PARENT_T VALUES('A');
INSERT INTO PARENT_T VALUES('B');
INSERT INTO CHILD_T VALUES('a', 'A');
INSERT INTO CHILD_T VALUES('b', 'B');


--부모의 데이터를 먼저 삭제
DELETE FROM PARENT_T WHERE P_ID = 'A';
--오루가 발생했다. 이유는?
--CHILD_T의 FOREIGN KEY가 소멸하기 때문이다. => 자식테이블이 참조하고 있기 때문 
--이는 무결성 제약조건에 위배된다.
--해결방법
--1. 외래키를 끊고 제거한다. 
--2. 외래키를 먼저 제거하고 다음으로 제거한다.

--외래키 제약 조건을 삭제할 때 DROP을 쓴다.
ALTER TABLE CHILD_T DROP CONSTRAINT C_FK;

ALTER TABLE CHILD_T ADD CONSTRAINT C_FK FOREIGN KEY(P_ID)
REFERENCES PARENT_T(P_ID) ON DELETE CASCADE;

CREATE TABLE JAVAWEB (
                        JAVAWEB_ID VARCHAR2(10) PRIMARY KEY, -- 기본키(UNIQUE + NOTNULL)
                        WEB_NM VARCHAR2(4) UNIQUE,
                        PRODUCT VARCHAR2(4) NOT NULL
                        );

INSERT INTO JAVAWEB VALUES('NAVER.COM', '네이버', '후라보노');

--동등 조인
SELECT ENAME,LOC
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO;

--AND 조건 추가
SELECT ENAME, LOC, JOB
FROM EMP, DEPT
WHERE DEPT.LOC = 'DALLAS' AND EMP.JOB = 'ANALYST';

--오류나는 이유 : DEPTNO가 어떤 테이블 DEPTNO인지 컴파일러는 알지 못한다.
SELECT ENAME, LOC, JOB, DEPTNO
FROM EMP, DEPT;

--수정 후
--중복되는 속성이 없어도 될 수 있으면 해당 테이블을 명시해 주어야 한다.
SELECT A.ENAME, B.LOC, A.JOB
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO AND A.JOB='ANALYST';

--NON EQUI JOIN
--EQUI JOIN 처럼 동일한 칼럼은 없지만, 비슷한 컬럼이 있을 때 사용한다

DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
(GRADE NUMBER(10),
LOSAL NUMBER(10),
HISAL NUMBER(10));

INSERT INTO SALGRADE VALUES(1,700,1200);
INSERT INTO SALGRADE VALUES(2,1201,1400);
INSERT INTO SALGRADE VALUES(3,1401,2000);
INSERT INTO SALGRADE VALUES(4,2001,3000);
INSERT INTO SALGRADE VALUES(5,3001,9999);

COMMIT;
SELECT * FROM SALGRADE;

--사원 테이블(EMP)과 급여 테이블(SALGRAD) JOIN을 사용하여 이름, 월급, 급여 등급을 출력
--동일한 컬럼이 업서서 동등 조인을 할 수 없다.
--비슷한 컬럼을 이용하여 조인을 한다.

SELECT E.ENAME, E.SAL, S.GRADE -- 3
FROM EMP E, SALGRADE S -- 1
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL; -- 2

SELECT * FROM EMP;

--OUTER JOIN
--부족하지 않은 부분도 모두 표현한다.
--부족한 쪽은 (+)를 넣으면 된다.
SELECT E.ENAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;

--SELF JOIN
--사원 테이블 자기 자신의 테이블과 조인하여 이름, 직업, 해당사원의 
--관리자의 직업을 출력하시오.
--직업은 'SALESMAN'
SELECT * FROM EMP;
SELECT A.ENAME, A.JOB, B.ENAME, B.JOB
FROM EMP A, EMP B
WHERE A.MGR = B.EMPNO AND A.JOB = 'SALESMAN'
ORDER BY A.EMPNO;

--오라클 조인과 표준(ANSI, ISO,...) 조인들
SELECT E.ENAME, D.LOC
FROM EMP E JOIN DEPT D
ON(E.DEPTNO=D.DEPTNO);
-- ↑오라클 조인들
-- ↓표준 조인들
SELECT E.ENAME, D.LOC
FROM EMP E JOIN DEPT D  --JOIN ON을 사용한다.
ON(E.DEPTNO=D.DEPTNO); 

--USING절을 사용한 조인
SELECT E.ENAME, D.LOC
FROM EMP E JOIN DEPT D
USING (DEPTNO); -- ()는 필수

--USING 절을 이용한 조인 방법으로 이름, 직업, 월급, 부서 위치를 출력하세요
SELECT E.NAME, E.JOB, E.SAL, D.LOC
FROM EMP E JOIN DEPT D
USING(DEPTNO);

SELECT * FROM EMP;

SELECT E.ENAME, E.JOB, E.SAL, D.LOC
FROM EMP E JOIN DEPT D
USING (DEPTNO)
WHERE E.JOB = 'SALESMAN' AND D.LOC = 'CHICAGO'
ORDER BY E.EMPNO;

--NOATURAL JOIN
--여러 테이블의 데이터를 조인하여 출력한다.
--EMP와 DEPT 사이에 NATRAL JOIN을 하겠다고 기술하면 JOIN이 된다.
--둘 다 존재하는 동일한 컬럼인 DEPTNO를 오라클이 알아서 찾아서 JOIN한다.
SELECT E.ENAME 이름, E.JOB 직업, E.SAL 월급, D.LOC 부서위치
FROM EMP E NATURAL JOIN DEPT D
WHERE E.JOB = 'SALESMAN';

--OUTER JOIN
--ORACLE
SELECT E.ENAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
--ANSI
SELECT E.ENAME, D.LOC
FROM EMP E RIGHT OUTER JOIN DEPT D
--RIGHT: 오른쪽을 기준으로 붙인다.
ON(E.DEPTNO = D.DEPTNO);
--LEFT를 사용하기위해 새로 행을 추가한다.
INSERT INTO EMP(EMPNO, ENAME, SAL, JOB, DEPTNO)
        VALUES(8282, 'JACK', 300, 'ANALYST', 50);
COMMIT;
--LEFT를 사용한다.
SELECT E.ENAME, D.LOC
FROM EMP E LEFT OUTER JOIN DEPT D
--RIGHT: 오른쪽을 기준으로 붙인다.
ON(E.DEPTNO = D.DEPTNO);

--FULL OUTER JOIN
SELECT E.ENAME 이름, E.JOB 직업, E.SAL 월급, D.LOC 부서위치
FROM EMP E FULL OUTER JOIN DEPT D --FULL = LETF + RIGHT
ON(E.DEPTNO = D.DEPTNO);

--서브쿼리 (SUBQUERY)
SELECT ENAME, SAL -- 7
FROM EMP -- 4
WHERE SAL > ( -- 5
            SELECT SAL  -- 3
            FROM EMP  -- 1
            WHERE ENAME = 'JONES') -- 2
AND ENAME != 'SCOTT'; -- 6

--다중행 서브쿼리
--JOB이 SALESMAN인 사원들과 같은 SAL을 받는 사원들의 ENAME와 SAL을 출력하시오
--IN, NOTIN, ALL, >ALL, <ALL, >ANY, <ANY
SELECT ENAME, SAL
FROM EMP
WHERE SAL IN (
            SELECT SAL
            FROM EMP 
            WHERE JOB = 'SALESMAN');
            
SELECT ENAME, SAL, JOB
FROM EMP
WHERE EMPNO NOT IN (SELECT MGR
                    FROM EMP
                    WHERE MGR IS NOT NULL);

--EXITS, NOT EXISTS   =>    존재유무
--EMP.DEPTNO와 DEPT.DEPTNO, DEPT.LOC를 출력하시오
SELECT *
FROM DEPT D
WHERE EXISTS (
            SELECT *
            FROM EMP E
            WHERE E.DEPTNO = D.DEPTNO);
SELECT *
FROM DEPT D
WHERE NOT EXISTS (
            SELECT *
            FROM EMP E
            WHERE E.DEPTNO = D.DEPTNO);

--HAVING SUB QUERY
--JOB와 TOTAL(SAL)를 출력, JOB = 'SALESMAN'이상만
SELECT JOB, SUM(SAL)
FROM EMP 
GROUP BY JOB
HAVING SUM(SAL) > (SELECT SUM(SAL)
                    FROM EMP
                    WHERE JOB IN 'SALESMAN'
                    );
                    
--FROM SUB QUERY
SELECT V.ENAME, V.SAL, V.순위
FROM (SELECT ENAME, SAL, RANK() OVER (ORDER BY SAL DESC) 순위
FROM EMP) V
WHERE V.순위 = 1;