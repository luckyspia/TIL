-- 질의1: 마당서점의 고객별 판마액을 보이세요.(고객이름과 고객별 판매액을 출력)
SELECT * FROM orders;
SELECT custid, SUM(saleprice) AS 'total' FROM orders GROUP BY custid; -- 고객 이름을 출력하기 위해 customer table에서 가져와야 함
SELECT (SELECT name FROM Customer AS cs WHERE cs.custid=od.custid) AS name, SUM(saleprice) AS 'total' 
FROM orders AS od GROUP BY od.custid; -- 스칼라 부속질의면서 상관 부속질의

-- 질의2: Orders 테이블에 각 주문에 맞는 도서이름을 입력하세요.(UPDATE)
SELECT * FROM Orders;
ALTER TABLE Orders ADD bname VARCHAR(40); -- bookname이 들어갈 자리를 우선해서 마련alter

UPDATE Orders
SET bname = (SELECT bookname FROM Book WHERE Book.bookid=Orders.bookid);

-- 질의3: 고객번호가 2 이하인 고객의 판매액을 보이세요. (고객이름과 고객별 판매액을 출력)
SELECT cs.name, SUM(od.saleprice) 'total'
FROM Customer AS cs, Orders AS od
WHERE cs.custid=od.custid AND cs.custid <= 2
GROUP BY cs.custid; -- 기존에 진행하던 형태

SELECT cs.name, SUM(od.saleprice) 'total'
FROM (SELECT * FROM Customer WHERE custid <= 2) AS cs, Orders AS od
WHERE cs.custid=od.custid
GROUP BY cs.custid; -- 인라인 뷰 (inline view)

-- 질의4: 평균 주문금액 이하의 주문에 대해서 주문번호와 금액을 보이세요.
SELECT AVG(saleprice) FROM Orders; -- 단일행, 단일열 출력 (비교 연산자 사용 가능)

SELECT orderid, saleprice FROM Orders
WHERE saleprice <= (SELECT AVG(saleprice) FROM Orders);

-- 질의5: 각 고객의 평균 주문금액보다 큰 금액의 주문에 대해 주문번호, 고객번호, 금액을 보이세요.
SELECT orderid, custid, saleprice FROM Orders AS md
WHERE saleprice > (SELECT AVG(saleprice) FROM Orders AS so WHERE md.custid=so.custid); -- 중첩질의 (nested subquery); 고객별로 GROUP BY한 것과 같은 효과

-- 질의6: 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액을 구하세요.
SELECT custid FROM Customer WHERE address LIKE '%대한민국%'; -- IN과 NOT IN은 단일 열, 다중 행 필요

SELECT SUM(saleprice) AS 'total' FROM Orders
WHERE custid IN (SELECT custid FROM Customer WHERE address LIKE '%대한민국%');

-- 질의7: 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 주문번호와 금액을 보이세요.
SELECT saleprice FROM Orders WHERE custid=3; -- MAX()를 사용해도 최고 금액 구할 수 있음

SELECT orderid, saleprice FROM Orders
WHERE saleprice > ALL (SELECT saleprice FROM Orders WHERE custid=3); -- ALL은 제시하는 조건의 모든 것과 성립해야함 (최대값과 유사해짐)

SELECT orderid, saleprice FROM Orders
WHERE saleprice > SOME (SELECT saleprice FROM Orders WHERE custid=3); -- SOME은 조건 중 하나만 참이여도 성립 (최소값과 유사해짐)

-- 질의8: 대한민국에 거주하는 고객에게 판매한 도서의 총 판매액을 구하세요. (EXIST 사용)
SELECT * FROM Customer AS cs WHERE address LIKE '%대한민국%';

SELECT SUM(saleprice) AS 'total' FROM Orders od
WHERE EXISTS (SELECT * FROM Customer AS cs WHERE address LIKE '%대한민국%' AND cs.custid=od.custid);

-- 질의9: 주소에 대한민국을 포함하는 고객들로 구성된 뷰를 만드세요. 뷰의 이름은 vw_Customer
CREATE VIEW vw_Customer
AS SELECT * FROM Customer WHERE address LIKE '%대한민국%';

SELECT * FROM vw_Customer;

-- 질의10: Orders 테이블의 고객이름과 도서이름을 바로 확인할 수 있는 뷰를 생성하세요.
CREATE VIEW vw_Orders (orderid, custid, name, bookid, bookname, saleprice, orderdate)
AS SELECT od.orderid, od.custid, cs.name, od.bookid, bk.bookname, od.saleprice, od.orderdate
FROM Orders od, Customer cs, Book bk 
WHERE od.custid=cs.custid AND od.bookid=bk.bookid;

SELECT * FROM vw_Orders;

SELECT orderid, bookname, saleprice FROM vw_Orders WHERE name='김연아';

-- 질의11: vw_customer를 영국을 주소로 가진 고객으로 변경, phone은 제외
SELECT * FROM vw_Customer;

CREATE OR REPLACE VIEW vw_Customer (custid, name, address)
AS SELECT custid, name, address FROM Customer WHERE address LIKE '%영국%';

-- 질의12: vw_customer를 삭제하세요
DROP VIEW vw_Customer;

-- 질의13: 시스템 뷰
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_schema like '%madang%';

SHOW TABLES;