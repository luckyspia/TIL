-- 질의 1: 대한민국에서 거주하는 고객의 이름과 도서를 주문한 고객의 이름을 검색하세요.
SELECT name FROM Customer WHERE address LIKE '대한민국%' -- 대한민국에서 거주하는 고객의 이름 검색
UNION
SELECT name FROM Customer WHERE custid IN (SELECT custid FROM Orders); -- 도서를 주문한 고객 이름 검색

SELECT name FROM Customer WHERE address LIKE '대한민국%'
UNION ALL -- 겹치는 내용 제거 X
SELECT name FROM Customer WHERE custid IN (SELECT custid FROM Orders);

-- 질의 2: 대한민국에서 거주하는 고객의 이름에서 도서를 주문한 고객의 이름을 빼고 검색하세요.
SELECT name FROM Customer WHERE address LIKE '대한민국%'
							    AND name NOT IN (SELECT name FROM Customer WHERE custid IN (SELECT custid FROM Orders));

-- 질의 3: 대한민국에서 거주하는 고객 중 도서를 주문한 고객의 이름을 검색하세요.
SELECT name FROM Customer WHERE address LIKE '대한민국%'
							    AND name IN (SELECT name FROM Customer WHERE custid IN (SELECT custid FROM Orders));

-- 질의 4: 주문이 있는 고객의 이름과 주소를 검색하세요.
SELECT name, address FROM customer WHERE custid IN (SELECT custid FROM Orders);
SELECT name, address FROM customer cs WHERE EXISTS (SELECT * FROM Orders od WHERE cs.custid=od.custid);
SELECT name, address FROM customer cs WHERE NOT EXISTS (SELECT * FROM Orders od WHERE cs.custid=od.custid); -- 반대의 경우
-- 작동은 동일하지만, 상관질의를 사용할 경우, 특정 열을 지정하고 해당 열이 테이블에 존재해야만 하는 위와 달리 EXISTS의 사용이 유용하다. (열에 대한 정보가 없을 때)

/* 질의 5: NewBook 테이블을 생성
         - bookid(도서번호) : INTEGER
	     - bookname(도서이름) : VARCHAR(20)
         - publisher(출판사) : VARCHAR(20)
         - price(가격) : INTERGER */
CREATE TABLE NewBook (
    bookid 		INTEGER,
    bookname 	VARCHAR(20),
    publisher   VARCHAR(20),
    price       INTEGER); -- primary key 없이도 생성 가능 (참조 불가)
SELECT * FROM Newbook;

/* 질의 6: NewCustomer 테이블을 생성
         - custid(고객번호) : INTEGER, 기본키
	     - name(이름) : VARCHAR(40)
         - address(주소) : VARCHAR(40)
         - phone(전화번호) : VARCHAR(30) */
CREATE TABLE NewCustomer (
    custid      INTEGER PRIMARY KEY,
    name		VARCHAR(40),
    address     VARCHAR(40),
    phone		VARCHAR(30));

CREATE TABLE NewCustomer (
    custid		INTEGER,
    name		VARCHAR(40),
    address		VARCHAR(40),
    phone		VARCHAR(30),
    PRIMARY KEY (custid));

/* 질의 8: NewOrders 테이블 생성
    - orderid(주문번호) : INTEGER, 기본키
	- custid(고객번호) : INTEGER , NOT NULL , 외래키(Newcustomer.custid, CASCADE)
    - bookid(도서번호) : INTEGER , NOT NULL -- Newbook 형성 시 기본키 지정을 안 했으므로 참조 불가
    - saleprice(판매가격) : INTEGER
	- orderdate(판매일자) : DATE */
CREATE TABLE NewOrders(
    orderid		INTEGER,
    custid		INTEGER 	NOT NULL,
    bookid		INTEGER		NOT NULL,
    saleprice	INTEGER,
    orderdate	DATE,
    PRIMARY KEY (orderid),
    FOREIGN KEY (custid) REFERENCES NewCustomer(custid) ON DELETE CASCADE); -- FOREGIN KEY가 여러 개 일 경우, 추가 옵션 지정 가능

-- 질의 9: NewBook 테이블에 VARCHAR(13)의 자료형을 가진 isbn속성을 추가하세요.
ALTER TABLE NewBook ADD isbn VARCHAR(13); -- 원래 테이블에 데이터가 존재할 경우, 추가의 경우 결측치로 입력되기 때문에, NOT NULL option 등을 미리 지정하지 않는다

-- 질의 10: NewBook 테이블의 isbn 속성의 데이터 타입을 INTEGER로 변경하세요.
ALTER TABLE NewBook MODIFY isbn INTEGER;

-- 질의 11: NewBook 테이블의 isbn 속성을 삭제하세요.
ALTER TABLE NewBook DROP COLUMN isbn; -- 속성이 아닌 열에 대한 드랍이므로 DROP COLUMN 사용 (데이터도 함께 삭제)

-- 질의 12: NewBook 테이블의 bookid 속성에 NOT NULL 제약조건을 적용하세요.
ALTER TABLE NewBook MODIFY bookid INTEGER NOT NULL; -- 기존 도메인 조건 또한 명시

-- 질의 13: NewBook 테이블의 bookid 속성을 기본키로 변경하세요.
-- 기존에 없는 상태이기 때문에 수정이 아닌 추가로 코드 구성
ALTER TABLE NewBook ADD PRIMARY KEY(bookid);
ALTER TABLE NewBook MODIFY booid INTEGER PRIMARY KEY; -- 위의 코드가 실행되며 먼저 기본키가 지정되었기 때문에 실행 불가
ALTER TABLE NewBook DROP PRIMARY KEY; -- 위의 코드를 실행시키기 위해 우선 실행해야 하는 코드 (새로 지정을 위해, 기본키 설정을 취소해야 함)

-- 질의 14: NewBook 테이블을 삭제
DROP TABLE NewBook

-- 질의 15: NewCustomer 테이블을 삭제
DROP TABLE NewCustomer; -- NewOrders와 참조 관계에 의해 삭제되지 않음, 삭제를 위해 FOREIGN KEY 를 DROP 시켜줘야 함

-- 질의 16: Book 테이블에 스포츠 의학 도서를 삽입, 한솔의학서적에서 출간, 가격은 90,000원
INSERT INTO Book(bookid, bookname, publisher, price)
		VALUES (11, '스포츠의학', '한솔의학서적', 90000); -- 속성의 도메인 제약 조건에 만족해야함
INSERT INTO Book
		VALUES (11, '스포츠의학', '한솔의학서적', 90000); -- 기본키가 중복되므로 이번엔 실행되지 않음; bookid를 변경하면 실행 가능
INSERT INTO Book
		VALUES (13, '스포츠의학', '한솔의학서적', '90000원'); -- 도메인 제약조건 위반으로 실행 불가
INSERT INTO Book(bookname, publisher, price, bookid)
		VALUES ('스포츠의학','한솔의학서적',90000, 13); -- 속성의 순서를 변경해도 실행 가능

-- 질의 17: Book 테이블에 '스포츠의학'을 삽입, 출판사는 한솔의학서적, 가격은 미정
INSERT INTO Book(publisher, bookname)
		VALUES ('한솔의학서적','스포츠의학'); -- 기본키는 반드시 지정해야 하므로, NOT NULL 이기 때문에 실행 불가
INSERT INTO Book(publisher, bookname, bookid)
		VALUES ('한솔의학서적','스포츠의학', 14);  -- 가격은 결측치로서 입력

-- 질의 18: Imported Book을 Book 테이블에 삽입
SELECT * FROM IMported_book;

INSERT INTO Book(bookid, bookname, publisher, price)
		SELECT bookid, bookname, publisher, price FROM Imported_book; -- Bulk INSERT

SELECT * FROM Book; -- 테이블 간 결합에서 자주 사용 (Bulk INSERT)

-- 질의 19: Customer 테이블에서 고객번호가 5인 고객의 주소를 '대한민국 부산'으로 변경하세요.
SET SQL_SAFE_UPDATES=0; -- SAFE UPDATE 옵션을 임시로 해제
SELECT * FROM Customer;

UPDATE Customer
SET address='대한민국 부산'
WHERE custid=5; -- 테이블의 해당 되는 속성값을 모두 바꾸기 때문에 WHERE 절을 필수적으로 사용해야 함

-- 질의 20: Book 테이블에서 14번 '스포츠의학'의 출판사를 Imported_book 테이블의 21번 책의 출판사와 동일하게 변경
SELECT publisher FROM Imported_book WHERE bookid=21;

UPDATE Book SET publisher=(SELECT publisher FROM Imported_book WHERE bookid=21)
			WHERE bookid=14;
	
-- 질의 21: Book 테이블에서 도서번호가 11, 12, 13, 14인 도서를 삭제하시오.
DELETE FROM Book WHERE bookid='11';

SELECT * FROM Book WHERE bookid in (11, 12, 13, 14);
DELETE FROM Book WHERE bookid in (11, 12, 13, 14);

SELECT * FROM Book;

DELETE FROM Customer; -- 데이터가 모두 삭제됨