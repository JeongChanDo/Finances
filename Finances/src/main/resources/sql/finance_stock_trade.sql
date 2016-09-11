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


select * from finance_stock_trade_buy where id = 'djc4223' order by time desc;

select t1.time,t1.id, t1.code,t1.name,t1.price,
				t1.totalprice, t1.volume, t2.price 
				from finance_stock_trade_buy t1, 
				(select * from finance_stock_price_day
				 where time = (select max(time) from finance_stock_price_day)) t2
				 where t1.code = t2.code and t1.id = 'djc4223' order by time desc