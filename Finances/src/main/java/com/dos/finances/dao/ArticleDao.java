package com.dos.finances.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import com.dos.finances.bean.ArticleBean;

@Repository
public class ArticleDao {
	
	String sql;
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	@Autowired
	private NamedParameterJdbcTemplate namedParamJdbcTemplate;
	
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<ArticleBean> getLatestArticleBeanListById(String id){
		
		sql = "select * from finance_article where writer = '"+id+"' order by day desc limit 5";
		
		return jdbcTemplate.query(sql, new ArticleBeanRowMapper2());
	}
	
	public List<ArticleBean> getLatestCommentBeanListById(String id){
		
		sql = "select * from finance_article where seq != 0 and writer = '"+id+"' order by day desc limit 5";
		
		return jdbcTemplate.query(sql, new ArticleBeanRowMapper2());
	}
	
	//게시글 리스트를 가져오는 메소드
	public List<ArticleBean> getArticleList(int boardNo, int startNo, int endNo){
		System.out.println("\ngetArticleList 메소드에 들어왔습니다.");
		System.out.println("boardNo : " + boardNo);
		System.out.println("startNo : " + startNo);
		System.out.println("endNo : " + endNo);
		
		
		sql = "select e.no, e.title, e.writer, e.nickname, e.content, e.boardNo, "
				+ "e.day, e.seq from (select @RN:=@RN+1 as rowno, e.* from  "
				+ "(select * from finance_article where boardNo = :boardNo and seq = 0 "
				+ "order by no desc) e, (SELECT @RN:=0) AS R) e where e.rowno"
				+ " between :startNo and :endNo";
		
		SqlParameterSource namedParam = new MapSqlParameterSource()
				.addValue("startNo", startNo).addValue("endNo",endNo).addValue("boardNo",boardNo);
		
		return namedParamJdbcTemplate.query(sql,namedParam, new ArticleBeanRowMapper1());
		
		
		/*
		ArticleBeanMapper mapper = sqlSessionTemplate.getMapper(ArticleBeanMapper.class);
		
		
		return mapper.getArticleList(boardNo, startNo, endNo);
		
		*/
		
/*
		
		
		String statement = "mappers.ArticleBeanMapper.selectAllSpecificArticle";
		return sqlSessionTemplate.selectList(statement,boardNo);
		*/
		/*
		String statement = "mappers.ArticleBeanMapper.selectAllArticle";
		return sqlSessionTemplate.selectList(statement);
		
		*/
	}
	
	//해당 게시판 게시글 갯수 구하기
	public int getNumOfArticleByBoardNo(int boardNo){
		sql = "select count(*) from finance_article where boardNo = "+boardNo+" and seq = 0";
		
		return jdbcTemplate.queryForObject(sql, Integer.class);
	}
	
	public void insertArticle(ArticleBean article){
		int ref = getNumberOfArticle();
		
		sql = "insert into finance_article"
				+ "(title,writer,nickname,content,boardNo,day,ref,seq)"
				+ " values(:title,:writer,:nickname,:content,:boardNo,:day,"+ref+",0)";
		
		SqlParameterSource beanParam = new BeanPropertySqlParameterSource(article);
		

		namedParamJdbcTemplate.update(sql, beanParam);
	}
	
	
	//게시글을 가져오는 메소드
	public ArticleBean getArticle(int no){
		sql = "select * from finance_article where no = "+no;
		
		//ref도 가져온다.
		return jdbcTemplate.query(sql,new ResultSetExtractor<ArticleBean>(){

			@Override
			public ArticleBean extractData(ResultSet rs) throws SQLException, DataAccessException {
				ArticleBean article = new ArticleBean();
			
				if(rs.next()){
					article.setNo(rs.getInt(1));
					article.setTitle(rs.getString(2));
					article.setWriter(rs.getString(3));
					article.setNickname(rs.getString(4));
					article.setContent(rs.getString(5));
					article.setBoardNo(rs.getInt(6));
					article.setDay(rs.getTimestamp(7));
					article.setRef(rs.getInt(8));	
					article.setSeq(rs.getInt(9));	
				}
				return article;
			}
			
		});
	}
	
	//글삭제 메소드
	public void deleteArticle(int no){
		sql = "delete from finance_article where no = "+no;
		jdbcTemplate.update(sql);
	}
	
	//글 수정 메소드
	public void editArticle(ArticleBean article){
		sql = "update finance_article set title = '"+article.getTitle()+"', content = '"+article.getContent()+"' where no = "+article.getNo();
		jdbcTemplate.update(sql);
	}
	
	
	//코멘트를 입력하는 메소드
	public void insertComment(ArticleBean article){
		sql = "insert into finance_article(title,writer,nickname,content,boardNo,day,ref,seq) values("
				+ ":title,:writer,:nickname,:content,:boardNo,:day,:ref,:seq)";
		
		SqlParameterSource beanParam = new BeanPropertySqlParameterSource(article);
		
		namedParamJdbcTemplate.update(sql,beanParam);
	}
	
	//해당 글그룹의 글 갯수를 가져오는 메소드
	public int getCommentCount(int ref){
		
		sql ="select count(*) from finance_article where ref = "+ref+" and seq >= 1";
		
		return jdbcTemplate.queryForObject(sql,Integer.class);

	}
	
	//해당 글그룹의 코멘트들을 가져오는 메소드
	public List<ArticleBean> getCommentList(int ref){
		ArrayList<ArticleBean> cList = new ArrayList<ArticleBean>();
		ArticleBean comment = null;
		sql="select * from finance_article where ref = "+ref+" and seq >=1 order by seq";
		
				
		return jdbcTemplate.query(sql, new RowMapper<ArticleBean>(){

			@Override
			public ArticleBean mapRow(ResultSet rs, int rowNum) throws SQLException {
				ArticleBean comment = new ArticleBean();
				comment.setNo(rs.getInt("no"));
				comment.setWriter(rs.getString("writer"));
				comment.setNickname(rs.getString("nickname"));
				comment.setContent(rs.getString("content").replaceAll("\r\n", "<br/>"));
				comment.setDay(rs.getTimestamp("day"));
				return comment;
			}});
	}
	
	//다음 seq를 구하는 메소드
	public int getNextSeq(int ref){
	
		sql = "select max(seq) from finance_article where ref = "+ref;
		return jdbcTemplate.queryForObject(sql,Integer.class);

	}
	
	//모든 원본 글 갯수를 가지고 오는 메소드 -ref로 하기위함
	public int getNumberOfArticle(){
		sql = "select count(*) from finance_article where seq = 0";
		return jdbcTemplate.queryForObject(sql,Integer.class);

	}
	
	public List<ArticleBean> getLatestArticleList(int boardNo){
		
		sql = "select * from finance_article where boardNo = ? and seq = 0 order by day desc limit 0,5";
		return jdbcTemplate.query(sql, new ArticleBeanRowMapper1(),boardNo);
	}
	
	
	//ref를 포함하지 않는 RowMapper
	class ArticleBeanRowMapper1 implements RowMapper<ArticleBean>{

		@Override
		public ArticleBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			
			ArticleBean article = new ArticleBean();
			article.setNo(rs.getInt(1));
			article.setTitle(rs.getString(2));
			article.setWriter(rs.getString(3));
			article.setNickname(rs.getString(4));
			article.setContent(rs.getString(5));
			article.setBoardNo(rs.getInt(6));
			article.setDay(rs.getTimestamp(7));
			article.setSeq(rs.getInt(8));	
			return article;
			
		}
		
		
	}
	
	//ref를 포함하는 RowMapper
	class ArticleBeanRowMapper2 implements RowMapper<ArticleBean>{

		@Override
		public ArticleBean mapRow(ResultSet rs, int rowNum) throws SQLException {
			
			ArticleBean article = new ArticleBean();
			article.setNo(rs.getInt(1));
			article.setTitle(rs.getString(2));
			article.setWriter(rs.getString(3));
			article.setNickname(rs.getString(4));
			article.setContent(rs.getString(5));
			article.setBoardNo(rs.getInt(6));
			article.setDay(rs.getTimestamp(7));
			article.setRef(rs.getInt(8));	
			article.setSeq(rs.getInt(9));	
			return article;
			
		}
	}
}
