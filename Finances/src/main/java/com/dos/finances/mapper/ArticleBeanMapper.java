package com.dos.finances.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.dos.finances.bean.ArticleBean;

public interface ArticleBeanMapper {
/*
	@Select({
		"select e.no, e.title, e.writer, e.nickname, e.content, e.boardNo, "
				+ "e.day, e.seq "
				+ "from ("
				+          "select @RN:=@RN+1 as rowno, e.* "
				+ "         from  ("
				+ "                  select * "
				+ "                  from finance_article "
				+ "                  where boardNo = #{boardNo} and seq = 0 "
				+ "         order by no desc) e, ("
				+ "                                     SELECT @RN:=0) AS R) e "
				+ "                                     where e.rowno"
				+ " between #{startNo} and #{endNo}"
	})
	*/
	
	@Select(
				/*"select @RN:=@RN+1 as rowno, e.* "
				+ "         from  ("
				+ "                  select * "
				+ "                  from finance_article "
				+ "                  where boardNo = #{boardNo} and seq = 0 "
				+ "         order by no desc) e, (SELECT @RN:=0) AS R "*/

		
			"select * from finance_article where boardNo = #{boardNo}"
	)
	
	
	/*
	@Select({
		"select e.no, e.title, e.writer, e.nickname, e.content, e.boardNo, "
				+ "e.day, e.seq "
				+ "from  finance_article e "
	})
	*/
	
	/*
	@Select({
		"select * from finance_article"
	})
	*/
	
	public List<ArticleBean> getArticleList(int boardNo, int startNo, int endNo);
}
