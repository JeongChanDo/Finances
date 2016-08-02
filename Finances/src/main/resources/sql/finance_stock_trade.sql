--주식 매수, 매도 정보가 담겨진 테이블
drop table finance_stock_trade_buy;
create table finance_stock_trade_buy(
	time timestamp not null,
	id varchar(30) not null,
	code varchar(10) not null,
	name varchar(40) not null,
	price int not null,
	totalprice int not null,
	volume int not null
);

drop table finance_stock_trade_sell;
create table finance_stock_trade_sell(
	time timestamp not null,
	id varchar(30) not null,
	code varchar(10) not null,
	name varchar(40) not null,
	price int not null,
	totalprice int not null,
	volume int not null
);

