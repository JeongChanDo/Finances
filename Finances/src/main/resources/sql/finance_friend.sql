drop table finance_friend;

create table finance_friend(
  time timestamp not null,
  me varchar(30) not null,
  friend varchar(30) not null
);

select * from finance_friend where me = 'djc4223';

select * from finance_friend;

select * from finance_message order by time desc;

delete from finance_message where message_code = 19;