package com.dos.finances.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.dos.finances.bean.NewsBean;

@Repository
public class NewsDao {
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	private NamedParameterJdbcTemplate namedParamJdbcTemplate;
	
	
	String sql;
	
	//뉴스리스트 가져오는 메소드
	public List<NewsBean> getNewsList(){
		
		sql = "select * from finance_news order by day desc";
	
		
		return jdbcTemplate.query(sql, new NewsBeanRowMapper());
	}
	
	//뉴스vo를 가져오는 메소드 페이징 처리
	public List<NewsBean> getNewsList(int startNo, int endNo){
		
		sql = "select n.day, n.title, n.link, n.content from"
				+ " (select @RN:=@RN+1 as num, n.* from"
				+ " (select * from finance_news order by day desc) n"
				+ ", (SELECT @RN:=0) AS R) n where n.num between :startNo and :endNo";
		
		SqlParameterSource param =
				new MapSqlParameterSource().addValue("startNo",startNo).addValue("endNo", endNo);
		
		
		return namedParamJdbcTemplate.query(sql,
				param,
				new NewsBeanRowMapper());
				

	}
	
	
	public List<NewsBean> getLatestNewsList(){
		sql = "select * from finance_news order by day desc limit 0,3";
		
		return jdbcTemplate.query(sql, new NewsBeanRowMapper());
	}
	
	//뉴스 갯수를 가져오는 메소드
	public int getNumOfNews(){
		sql = "select count(*) from finance_news";
		
		return jdbcTemplate.queryForObject(sql, Integer.class);
	}
	
	//뉴스 갯수를 가져오는 메소드
	public int getNumOfSearchedNews(String keyword){
		sql = "select count(*) from finance_news where title like :per :keyword :per";
		
		SqlParameterSource namedParam
			= new MapSqlParameterSource().addValue("per","%").addValue("keyword",keyword);
		
		return namedParamJdbcTemplate.queryForObject(sql, namedParam,Integer.class);
	}
	
	
	//뉴스 기사 검색
	public List<NewsBean> getNewsListByKeyword(String keyword, int startNo, int endNo){
	
		sql = "select n.title, n.day, n.link, n.content from "
				+ "(select n.* from (select @RN:=@RN+1 as num, n.* from "
				+ "(select * from finance_news where title like :per :keyword :per order by day desc) n,"
				+ " (SELECT @RN:=0) AS R) n where n.num between :startNo and :endNo) n;";
		
		SqlParameterSource namedParam
		= new MapSqlParameterSource().addValue("per","%").addValue("keyword",keyword)
			.addValue("startNo",startNo).addValue("endNo",endNo);
	
			

	
		return namedParamJdbcTemplate.query(sql, namedParam,new NewsBeanRowMapper());
		
	}
	
	
	class NewsBeanRowMapper implements RowMapper<NewsBean>{

		@Override
		public NewsBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			NewsBean news = new NewsBean();
			news.setTitle(rs.getString("title"));
			news.setDay(rs.getDate("day").toString());
			news.setLink(rs.getString("link"));
			news.setContent(rs.getString("content"));
			
			return news;
		}
		
	}
}
