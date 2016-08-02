drop table finance_article;

create table finance_article(
	no int primary key auto_increment,
    title varchar(50) not null,
    writer varchar(25) not null,
    nickname varchar(25) not null,
    content text not null,
    boardNo int not null,
	day timestamp not null,
	ref int not null,
    seq int not null
);

select * from finance_article;

insert into finance_article(title,writer,nickname,content,boardNo,day,req,seq)
values('가가가','wgqwq','ddd','가나다라마',1,now(),(select count(*) from finance_article)+1,0);
select count(*) from finance_article;