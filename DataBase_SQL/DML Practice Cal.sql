-- 질의 1: 고객이 주문한 도서의 총 판매액을 구하세요.
SELECT * FROM orders;
SELECT SUM(saleprice) FROM orders;
SELECT SUM(saleprice) AS "총매출" FROM orders;
SELECT SUM(saleprice) "총매출" FROM orders;

-- 질의 2: 김연아 고객이 주문한 도서의 총 판매액을 구하세요.
SELECT * FROM orders;
SELECT SUM(saleprice) AS "총매출" FROM orders WHERE custid=2;

-- 질의 3: 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를  구하세요.
SELECT SUM(saleprice) AS "총 판매액", 
	   AVG(saleprice) AS "평균값", 
	   MIN(saleprice) AS "최저가", 
       MAX(saleprice) AS "최고가"
FROM orders;

-- 질의 4: 마당서점의 도서 판매 건수를 구하세요.
SELECT COUNT(*) FROM orders;

-- 질의 5: 고객별로 주문한 도서의 총 수량과 총 판매액을 구하세요.
SELECT custid, COUNT(*) AS "도서수량", SUM(saleprice) AS "총판매액"
FROM orders
GROUP BY custid;

-- 질의 6: 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하세요. 단, 두 권이상 구매한 고객만 구한다.
SELECT custid, COUNT(*) AS "도서수량" 
FROM orders
WHERE saleprice >= 8000
GROUP BY custid
HAVING COUNT(*) >= 2;

-- 연습문제: 도서번호가 1인 도서의 이름
SELECT bookname FROM Book WHERE bookid=1;
-- 연습문제: 2014년 7월 4일~7월 7일 사이에 주문 받은 도서의 주문 번호
SELECT * FROM orders;
SELECT orderid FROM orders WHERE orderdate BETWEEN '2014-07-04' AND '2014-07-07';
-- 연습문제: 주문 금액의 총액과 주문의 평균 금액
SELECT * FROM orders;
SELECT SUM(saleprice), AVG(saleprice) FROM orders;

-- Cartesian Product
SELECT * FROM customer;
SELECT * FROM orders;
SELECT * FROM customer, orders;

-- 질의 1: 고객과 고객의 주문에 대한 데이터를 모두 보이시오. (equi join, inner join)
SELECT * FROM customer, orders WHERE customer.custid=orders.custid;

-- 질의 2: 고객과 고객의 주문에 대한 데이터를 고객번호 순으로 정렬하세요.
SELECT * FROM customer, orders WHERE customer.custid=orders.custid ORDER BY customer.custid;

-- 질의 3: 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하세요.
SELECT name, saleprice FROM customer, orders WHERE customer.custid=orders.custid;

-- 질의 4: 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객이름 순으로 정렬하세요.
SELECT name, SUM(saleprice) AS "총 판매액" FROM customer, orders WHERE customer.custid=orders.custid 
GROUP BY customer.custid ORDER BY customer.name;

-- 질의 5: 고객의 이름과 고객이 주문한 도서의 이름을 구하세요.
SELECT customer.name, book.bookname
FROM customer, orders, book
WHERE customer.custid=orders.custid AND orders.bookid=book.bookid;

-- 질의 6: 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하세요.
SELECT customer.name, book.bookname
FROM customer, orders, book
WHERE customer.custid=orders.custid AND orders.bookid=book.bookid
      AND book.price=20000;

-- 질의 7: Self Join; 사원 "BLAKE"가 관리하는 부하 사원의 이름과 직급을 출력하세요.
SELECT * FROM emp;
SELECT STAFF.ENAME, STAFF.JOB FROM emp AS STAFF, emp AS MANAGER
WHERE STAFF.MGR=MANAGER.EMPNO
      AND MANAGER.ENAME="BLAKE";

-- 질의 8: 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하세요.
SELECT * FROM customer;
SELECT * FROM orders;
SELECT customer.name, orders.saleprice
FROM customer LEFT OUTER JOIN orders
     ON customer.custid=orders.custid;
     
-- 질의 1: 가장 비싼 도서의 이름을 검색하세요
SELECT MAX(price) FROM book;
SELECT * FROM book WHERE price=35000;

SELECT bookname FROM book WHERE price=(SELECT MAX(price) FROM book);

-- 질의 2: 도서를 구매한 적이 있는 고객의 이름을 검색하세요
SELECT name From customer WHERE custid IN (SELECT DISTINCT custid FROM orders);

-- 질의 3: 대한미디어에서 출판한 도서를 구매한 고객의 이름을 검색하세요
SELECT * FROM book;
SELECT bookid FROM book WHERE publisher="대한미디어";
SELECT custid FROM Orders WHERE bookid IN (SELECT bookid FROM book WHERE publisher="대한미디어");
SELECT name FROM customer WHERE custid IN 
							    (SELECT custid FROM Orders WHERE bookid IN 
																	   (SELECT bookid FROM book WHERE publisher="대한미디어"));
SELECT name FROM Book, orders, customer
WHERE Book.bookid=orders.bookid AND customer.custid=orders.custid
     AND Book.publisher="대한미디어";
     
-- 질의 4: 출판사별로 출판사의 평균 도서가격보다 비싼 도서를 구하세요.
SELECT publisher, AVG(price) FROM Book GROUP BY publisher;
SELECT bookname FROM Book b1 WHERE b1.price>(SELECT AVG(b2.price) FROM Book b2 WHERE b1.publisher=b2.publisher);