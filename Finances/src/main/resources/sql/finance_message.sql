create table finance_message(
  message_code int primary key AUTO_INCREMENT,
  time timestamp not null,
  sender varchar(100) not null,
  title varchar(100) not null,
  receiver varchar(100) not null,
  content varchar(5000) not null,
  checked boolean not null
);

select * from finance_message;
select * from finance_message where sender = '5555' and title like '%메시지%' order by time desc limit 1, 10;
select count(*) from finance_message where receiver = 'djc4223' and sender like '%5555%' order by time desc;