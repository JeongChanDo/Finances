create table finance_stock_count(
	time timestamp,
	code varchar(10) not null,
	sort int not null,
	id varchar(30)
);

--sort 종류 : 1: '조회' 2- '매수' 3- '매도'