--모든 회원들의 매수 매도 기록이 담기는 테이블 지워지지 않는다.
create table finance_stock_trade_history(
	time timestamp not null,
	id varchar(30) not null,
	code varchar(10) not null,
	name varchar(40) not null,
	price int not null,
	totalprice int not null,
	volume int not null,
	sort varchar(6) not null
);
drop table finance_stock_trade_history;
select * from finance_stock_trade_history;