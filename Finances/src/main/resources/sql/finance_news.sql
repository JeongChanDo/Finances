drop table finance_news;
select day, title, link, content from 
(select rownum num, n.* from (select * from finance_news order by day desc) n)
where num between 1 and 10;


select max(day) from finance_news;

select * from finance_news order by day desc;

desc finance_news;
select * from finance_news;


create table finance_news(
	day date not null,
	title varchar(200) not null,
	link varchar(200) not null,
	content varchar(400) not null
);

insert into finance_news values('2015-07-09','[리포트+] 김치 없인 못 살아? 6년째 수입국인데…','http://m.news.naver.com/rankingRead.nhn?oid=055&aid=0000428629&sid1=101&date=20160709&ntype=RANKING','6년째 적자를 보는 게 있습니다. 우리가 종주국인데도 말입니다. 바로 ‘김치’입니다.김치 수입이 수출을 앞선 것은 2010년부터입니다. ');
insert into finance_news values('2015-07-09','집단대출 규제 1주일 청약자 4만명 vs 0명…깊어진 양극화 골','http://m.news.naver.com/rankingRead.nhn?oid=008&aid=0003708831&sid1=101&date=20160709&ntype=RANKING','[머니투데이 김사무엘 기자] [미사강변 호반 써밋플레이스에 4만명 청약 vs 지방엔 청약자 0명 사업장도…"집단대출 규제 실효성 의문"]');
insert into finance_news values('2015-07-09','한국몫  AIIB 부총재 날린 홍기택…정부 책임론 불가피','http://m.news.naver.com/rankingRead.nhn?oid=001&aid=0008529902&sid1=101&date=20160709&ntype=RANKING','AIIB 새분야 부총재 신설…홍 부총재 맡던 보직은 강등해 공모막대한 분담금 내고도 부총재직 선임은 당분간 못 맡을 듯 (세종=연합뉴스) 민경락 기자 = 아시아인프라투자은행(AIIB)이 홍기택 리스크 담당 부총재');
insert into finance_news values('2015-07-09','내가 부자가 될 가능성은 얼마?…알아보는 공식법','http://m.news.naver.com/rankingRead.nhn?oid=055&aid=0000428654&sid1=101&date=20160709&ntype=RANKING','나도 나중엔 부자가 될 수 있을까 하는 생각 많이들 해보실 겁니다. 오늘(9일) 경제 돋보기에선 여러분이 부자가 될 가능성을 미국의 한 대학교수가 만든 부자 지수 공식에 따라 계산해보겠습니다.');
insert into finance_news values('2015-07-09','[단독]4조원 짜리 AIIB 부총재직 날아갔다','http://m.news.naver.com/rankingRead.nhn?oid=008&aid=0003708792&sid1=101&date=20160709&ntype=RANKING','[머니투데이 세종=조성훈 기자] [AIIB 8일 공고내고 재무담당 부총재직 신설...홍기택 부총재 자리 CRO는 국장급으로 강등]');