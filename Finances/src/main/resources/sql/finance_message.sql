create table finance_message(
  message_code int primary key AUTO_INCREMENT,
  time timestamp not null,
  sender varchar(100) not null,
  title varchar(100) not null,
  receiver varchar(100) not null,
  content varchar(5000) not null,
  checked boolean not null
);