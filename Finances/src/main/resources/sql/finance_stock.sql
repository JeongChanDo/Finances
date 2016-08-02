--테이블 크기 보는 쿼리문 

select SEGMENT_NAME, BYTES/1024||'kb' from USER_SEGMENTS where segment_name LIKE 'FINANCE%';

select count(*) from finance_stock_price_total order by time desc;
select * from finance_stock_price_day order by time desc;





drop table finance_stock_list;
select count(*) from finance_stock_list;
select * from finance_stock_list order by name desc;
select * from FINANCE_STOCK_LIST where name like '삼성%';

create table finance_stock_list(
	code varchar(10) primary key,
	name varchar(30) not null
);

drop table finance_stock_price_day;

--당일 주가 정보가 담김
create table finance_stock_price_day(
	time timestamp not null,
	code varchar(10) not null,
	name varchar(30) not null,
	price int not null
);
insert into finance_stock_price_day values(now(),'000810','나도몰라',14200);
delete from finance_stock_price_day where code = '000810';

select * from finance_stock_price_day where code = '000810' order by time desc;
select * from finance_stock_price_day order by time desc;

drop table finance_stock_price_month;


delete from finance_stock_price_day where time like (select t.* from (select concat(substr(min(time),1,10),'%') time from finance_stock_price_day) t)

delete from finance_stock_price_day where time like 
(select t.* from (select concat(substr(min(time),1,10),'%') time
from finance_stock_price_day) t);

select t.* from (select concat(substr(min(time),1,10),'%') time
from finance_stock_price_day) t;

--마감 가 입력
create table finance_stock_price_month(
	day date not null,
	code varchar(10) not null,
	name varchar(30) not null,
	price int not null
);


--전체 데이터가 입력됨
create table finance_stock_price_total(
	time timestamp not null,
	code varchar(10) not null,
	name varchar(30) not null,
	price int not null
);

insert into finance_stock_price_total select * from finance_stock_price_day where time like (select concat(substr(max(time),1,10),'%') from finance_stock_price_day) order by time desc;


select * from finance_stock_price_total;

select concat(substr(max(time),1,10),'%') from finance_stock_price_day;

select max(time) from finance_stock_price_day;

delete from finance_stock_price_total;


select * from finance_stock_price_month order by day desc;

insert into finance_stock_list values('005930','삼성전자');
insert into finance_stock_list values('015760','한국전력');
insert into finance_stock_list values('005380','현대차');
insert into finance_stock_list values('005935','삼성전자우');
insert into finance_stock_list values('012330','현대모비스');
insert into finance_stock_list values('035420','네이버');
insert into finance_stock_list values('090430','아모레퍼시픽');
insert into finance_stock_list values('028260','삼성물산');
insert into finance_stock_list values('000660','SK하이닉스');
insert into finance_stock_list values('032830','삼성생명');

insert into finance_stock_list values('005490','POSCO');
insert into finance_stock_list values('055550','신한지주');
insert into finance_stock_list values('033780','KT&G');
insert into finance_stock_list values('017670','SK텔레콤');
insert into finance_stock_list values('051900','LG생활건강');

insert into finance_stock_list values('000270','기아차');
insert into finance_stock_list values('051910','LG화학');
insert into finance_stock_list values('034730','SK');
insert into finance_stock_list values('096770','SK이노베이션');
insert into finance_stock_list values('000810','삼성화재');

insert into finance_stock_list values('105560','KB금융');
insert into finance_stock_list values('002790','아모레G');
insert into finance_stock_list values('003550','LG');
insert into finance_stock_list values('018260','삼성에스디에스');
insert into finance_stock_list values('010130','고려아연');

insert into finance_stock_list values('034220','LG디스플레이');
insert into finance_stock_list values('011170','롯데케미칼');
insert into finance_stock_list values('008930','한미사이언스');
insert into finance_stock_list values('066570','LG전자');
insert into finance_stock_list values('010950','S-Oil');





