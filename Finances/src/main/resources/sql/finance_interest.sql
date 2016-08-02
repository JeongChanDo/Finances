
create table finance_interest(
	id varchar(30) not null,
	code varchar(10) not null
);

--회원이 북마크 해둔 주식 코드들을 등록함

--북마크 주식 리스트를 볼때 이 테이블과 최신 가격 테이블을 조인하여
--id code name price를 출력 할 예정

select * from finance_interest;

select count(*) from finance_interest where id = 'djc4223' and code = '000270';


delete from finance_interest where id = 'djc4223' and code = '000270';
