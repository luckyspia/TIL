-- 질의 1: -78과 +78의 절대값을 구하세요.
SELECT ABS(-78), ABS(78);
SELECT ABS(-78), ABS(78) FROM Dual; -- Oracle 에선 Dual 이라는 가상 테이블을 반드시 사용해줘야 출력 가능

-- 질의 2: 4.875를 소수점 둘째자리에서 반올림한 값을 구하세요.
SELECT ROUND(4.875, 1) as '반올림값'; -- 둘째자리 반올림으로 첫째자리로 만드므로, 기준점을 1로 지정

-- 질의 3: 고객별 평균 주문 금액을 백원 단위로 반올림한 값을 구하세요.
SELECT custid AS '고객번호', ROUND(AVG(saleprice),-2) AS '평균주문금액' FROM Orders GROUP BY custid;

-- 질의 4: 도서제목에 야구가 포함된 도서를 농구로 변경한 후에 도서 목록을 검색하세요.
SELECT bookid, REPLACE(bookname,'야구','농구') FROM Book; -- 원래 데이터는 변하지 않음 (SELECT)

-- 질의 5: 굿스포츠에서 출판한 도서의 제목과 제목의 글자수를 확인하세요.
SELECT bookname AS '도서제목', CHAR_LENGTH(bookname) AS '문자수', LENGTH(bookname) AS '바이트수'
FROM Book WHERE publisher LIKE '%굿스포츠%'; -- 오차나 공백을 방지하기 위해 = 보단 LIKE와 % 활용이 좋음
										   -- 영어의 경우, 글자 당 1바이트이므로 글자수와 바이트수가 동일함

-- 질의 6: 마당서점의 고객중에서 같은 성을 가진 사람이 몇 명이나 되는지 성씨별 인원수를 구하세요.
SELECT SUBSTR(name, 1, 1) AS '성씨', COUNT(*) AS '인원' FROM Customer GROUP BY SUBSTR(name, 1, 1);

-- 질의 7: 마당서점이 2014년 7월 7일에 주문받은 도서의 주문번호, 고객번호, 도서번호, 주문일을 보이세요. 단, 주문일은 '%Y-%m-%d'의 형태로 표시
SELECT * FROM Orders WHERE orderdate='2014-07-07'; -- date를 문자열처럼 비교할 수 있음

SELECT orderid, custid, bookid, orderdate, DATE_FORMAT(orderdate, '%Y년 %j일') -- 1년 중 며칠에 해당하는지 확인 
FROM Orders WHERE orderdate=STR_TO_DATE('2014년 7월 7일', '%Y년 %m월 %d일');

SELECT orderid, custid, bookid, orderdate, DATE_FORMAT(orderdate, '%Y년 %W') -- 요일 확인 
FROM Orders WHERE orderdate=STR_TO_DATE('2014년 7월 7일', '%Y년 %m월 %d일');
-- SCHEMAS를 통해 orderdate의 형태가 이미 date 형식임을 확인

-- 질의 8: 마당서점은 주문일로부터 25일후에 매출을 확정한다. 각 주문의 확정일자를 구하세요.
SELECT orderid AS '주문번호', orderdate AS '주문일', orderdate + 25 FROM Orders; -- 이런 식으로 계산 시, 숫자처럼 취급하여 계산해 월을 정확히 계산하지 못함
SELECT orderid AS '주문번호', orderdate AS '주문일', ADDDATE(orderdate, INTERVAL 25 DAY) AS '확정일자' FROM Orders; -- 1 MONTH; 한 달 뒤

-- 질의 9: 날짜 차이 계산하기
SELECT DATEDIFF('2021-01-01', '2021-05-05'); -- MySQL에선 ''안에 위와 같은 형식으로 지정해주면 문자가 아니라 날짜처럼 계산해줌
SELECT DATEDIFF(STR_TO_DATE('2021-01-01', '%Y-%m-%d'), STR_TO_DATE('2021-05-05', '%Y-%m-%d')); -- 정석

-- 질의 10: NULL값 처리
SELECT price + 100 FROM Book WHERE bookid=2; -- 정상 출력
SELECT price + 100 FROM Book WHERE bookid=15; -- NULL + 숫자 = NULL
SELECT SUM(price), AVG(price), COUNT(*), COUNT(price) FROM Book;
SELECT SUM(price), AVG(price), COUNT(*), COUNT(price) FROM Book WHERE bookid=15; -- NULL인 경우의 집계함수의 연산 결과 (COUNT는 0으로 나옴)

SELECT * FROM Customer; -- 박세리의 Phone 결측치 有
SELECT * FROM Customer WHERE phone IS NULL; -- WHERE절은 *을 사용할 수 없으며, phone 이 NULL인 행을 출력
SELECT * FROM Customer WHERE phone IS NOT NULL;
SELECT * FROM Customer WHERE phone=''; -- 이러한 방식으로 NULL 값을 탐색할 수 없음 (결측치와 공백은 다른 의미)

-- 질의 11: 이름, 전화번호가 포함된 고객 목록을 보이세요. 단, 전화번호가 없는 고객은 '연락처없음'으로 표시하세요.
SELECT name AS '이름', IFNULL(phone, '연락처없음') AS '전화번호' FROM Customer;

-- 질의 12: 고객목록에서 고객번호, 이름, 전화번호를 앞의 두 명만 보이세요.
SELECT custid, name, phone FROM Customer;
SET @seq:=0; -- 변수 선언
SELECT (@seq:=@seq+1) AS '순번', custid, name, phone FROM customer WHERE @seq<2; -- 자기 값에 +1 하여 업데이트
SELECT @seq; -- 위 과정 끝에 seq의 값은 5, 지속적으로 위의 코드를 실행하면 seq가 지속적으로 커짐

-- 질의 13: saleprice가 10,000원 이상인 주문을 출력하세요. 단, 앞의 두건만 검색하세요.
SET @seq:=0;
SELECT (@seq:=@seq+1), orderid FROM Orders WHERE saleprice>=10000 AND @seq<2;
