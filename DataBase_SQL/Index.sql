-- 질의 1: bookname 열을 대상으로 ix_book 인덱스를 생성하시오.
CREATE INDEX ix_book ON Book(bookname); -- PRIMARY KEY 가 클러스터 인덱스로 설정되어 있음

-- 질의 2: publisher, price 열을 대상으로 ix_book2 인덱스를 생성
SELECT * FROM Book WHERE publisher='대한미디어' AND price>=3000; -- Execution Plan 확인 시, query cost 확인 가능 (index 설정 X 이므로, Full Table Scan)

CREATE INDEX ix_book2 ON Book(publisher, price);
SELECT * FROM Book WHERE publisher='대한미디어' AND price>=3000; -- Query cost가 낮아지고, Index Range Scan 으로 변경

-- 질의3: Book테이블의 인덱스를 최적화
ANALYZE TABLE Book;

-- 질의4: ix_book, ix_book2를 삭제하세요.
DROP INDEX ix_book, ix_book2 ON Book; -- 동시에 2개는 지울 수 없음
DROP INDEX ix_book ON Book;
DROP INDEX ix_book2 ON Book;