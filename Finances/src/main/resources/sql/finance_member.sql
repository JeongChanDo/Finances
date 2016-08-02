
create table finance_member(
	id varchar(30) primary key,
	password varchar(40) not null,
	gender varchar(4) not null,
	nickname varchar(25) not null,
	phone varchar(11) not null,
	zip_code varchar(7) not null,
	address1 varchar(60) not null,
	address2 varchar(30) not null,
	money Int
);

insert into finance_member values('djc4223','5706','남성','DOS','01042235706','35267','서울시 영등포구 신길 6동','늘푸른 고시원',99999999);

select * from finance_member;