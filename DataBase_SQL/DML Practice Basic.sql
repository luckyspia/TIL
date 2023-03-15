-- 질의 1: 모든 도서의 가격과 이름을 검색하세요
SELECT bookname, price FROM Book;
SELECT price, bookname FROM Book;
-- 질의 2: 모든 도서의 도서번호, 도서이름, 출판사, 가격을 검색하세요
SELECT bookid, bookname, publisher, price FROM Book; 
-- 전체 열을 다 가져올 시, 실제 값은 아니지만 전체 값을 다 가져왔다는 뜻으로 맨 밑에 NULL 생성
SELECT * FROM Book;
-- * ; 테이블의 모든 값 호출

-- 질의 3: 도서 테이블에 있는 모든 출판사를 검색하세요.
SELECT DISTINCT publisher FROM Book;

-- 질의 4: 가격이 20,000 미만인 도서를 검색하세요.
SELECT * FROM Book WHERE price<20000;

-- 질의 5: 가격이 10,000원 이상 20,000원 이하인 도서를 검색하세요.
SELECT * FROM Book WHERE (price >= 10000) AND (price <= 20000);
SELECT * FROM Book WHERE price BETWEEN 10000 AND 20000;

-- 질의 6: 출판사가 '굿스포츠' 또는 '대한미디어'인 도서를 검색하세요.
SELECT * FROM Book WHERE (publisher='굿스포츠') OR (publisher='대한미디어');
SELECT * FROM Book WHERE publisher IN ('굿스포츠','대한미디어');
SELECT * FROM Book WHERE publisher NOT IN ('굿스포츠','대한미디어');

-- 질의 7: '축구의 역사'를 출간한 출판사를 검색하세요.
SELECT publisher FROM Book WHERE bookname='축구의 역사';
SELECT publisher FROM Book WHERE bookname IN ('축구의 역사');
SELECT publisher FROM Book WHERE bookname LIKE '축구의 역사';

-- 질의 8: 도서이름에 '축구'가 포함된 출판사를 검색하세요.
SELECT bookname, publisher FROM Book WHERE bookname LIKE '%축구%';

-- 질의 9: 도서이름의 두 번째 위치에 '구'라는 문자열을 갖는 도서를 검색하세요.
SELECT * FROM Book WHERE bookname LIKE '_구%';
SELECT * FROM Book WHERE bookname LIKE '__의%';

-- LIKE 응용 ; LIKE 를 작성하면 값이 정수여도 문자열처럼 판단하기 때문에 다양한 응용 가능
SELECT * FROM Book WHERE price LIKE '%500';
SELECT * FROM BOOK WHERE bookname LIKE '%기술';

-- 질의 10: 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하세요.
SELECT * FROM Book WHERE (price >= 20000) AND (bookname LIKE '%축구%');

-- 질의 11: 출판사가 '굿스포츠' 또는 '대한미디어'인 도서를 검색하세요.
SELECT * FROM Book WHERE (publisher='굿스포츠') OR (publisher='대한미디어');

-- 질의 12: 영문으로 되어 있는 도서명을 검색하세요.
SELECT * FROM Book WHERE bookname REGEXP '^[A-z]';
SELECT * FROM Book WHERE bookname REGEXP '^[ㄱ-힣]';
SELECT * FROM Book WHERE bookname REGEXP '^[0-9]';

-- 질의 13: 도서를 이름순으로 검색하세요.
SELECT * FROM Book ORDER BY bookname;
SELECT * FROM Book ORDER BY price;

-- 질의 14: 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색하세요.
SELECT * FROM Book ORDER BY price, bookname;

-- 질의 15: 도서를 가격의 내림차순으로 검색하세요. 만약, 가격이 같다면 출판사의 오름차순으로 검색하세요.
SELECT * FROM Book ORDER BY price DESC, publisher ASC;