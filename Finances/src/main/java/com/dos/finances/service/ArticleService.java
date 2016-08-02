package com.dos.finances.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dos.finances.bean.ArticleBean;
import com.dos.finances.bean.MemberBean;
import com.dos.finances.dao.ArticleDao;

@Service
public class ArticleService {
	
	private final int PAGE_SIZE = 10;
	private final int PAGE_GROUP = 5;
	
	@Autowired
	private ArticleDao articleDao;
	
	
	public List<ArticleBean> getLatestArticleListById(String id){
		return articleDao.getLatestArticleBeanListById(id);
	}
	
	public List<ArticleBean> getLatestCommentListById(String id){
		return articleDao.getLatestCommentBeanListById(id);
	}
	
	public List<ArticleBean> getArticleList(HttpServletRequest request){
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		int pageNo = 1;
		if(request.getParameter("pageNo") != null){
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
		}
		
		//만약 pageNo가 1 이다. -> rownum은 1~10
		
		
		int endNo = pageNo*PAGE_SIZE;// pageNo = 3 --> endNo = 30;
		int startNo = endNo - (PAGE_SIZE-1); //endNo = 30 --> startNo =21;
		
		
		int numberOfArticle = articleDao.getNumOfArticleByBoardNo(boardNo);
		
		int numberOfPage = numberOfArticle%PAGE_SIZE == 0? 
				numberOfArticle/PAGE_SIZE :  //나머지가 0이면.. 
					numberOfArticle/PAGE_SIZE + 1;  //나머지가 0이 아니면
		//게시글 갯수가 33개 -> 페이지갯수 4
		// 30개 -> 3
		
		
		System.out.println("boardNo : " + boardNo);
		System.out.println("startNo : " + startNo);
		System.out.println("endNo : " + endNo);
		
		List<ArticleBean> aList = articleDao.getArticleList(boardNo, startNo, endNo);
		
		//pageNo가 12 -> 11   20 -->11		10	->	1	5->	1
		int startPage = pageNo%PAGE_GROUP == 0
				?PAGE_GROUP*(pageNo/PAGE_GROUP-1)+1
						:PAGE_GROUP*(pageNo/PAGE_GROUP)+1;
		int endPage = numberOfPage > startPage+(PAGE_GROUP-1)?startPage+(PAGE_GROUP-1)	//33	21~30  31~33
				:numberOfPage;	//페이지 갯수가 35개  시작 페이지가 31 endPage는 35
				//40 > 40 -> false endPage는 40
		
		
		int numberOfPageGroup = numberOfPage%PAGE_GROUP ==0?
					numberOfPage/PAGE_GROUP:
						numberOfPage/PAGE_GROUP+1;
		//패이지 갯수 14 -> 페이지그룹갯수 2
		// 10 -> 페이지그룹 1
		
		int currentPageGroup = pageNo%PAGE_GROUP == 0 ?pageNo/PAGE_GROUP:pageNo/PAGE_GROUP+1 ;
		//pageNo가 3 -> 1
		//15 ->2
		//10 ->1
		//42 -> 5
	
		request.setAttribute("aList", aList);
		request.setAttribute("boardNo", boardNo);
		request.setAttribute("pageNo", pageNo);
		request.setAttribute("numberOfArticle", numberOfArticle);
		request.setAttribute("numberOfPage", numberOfPage);
		request.setAttribute("numberOfPageGroup",numberOfPageGroup);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);
		request.setAttribute("currentPageGroup",currentPageGroup);
		request.setAttribute("pageGroup",PAGE_GROUP);
		
		return aList;
	}
	
	
	public void detail(HttpServletRequest request){
		String boardNo = request.getParameter("boardNo");
		int no = Integer.parseInt(request.getParameter("no"));
		
		ArticleBean article = articleDao.getArticle(no);
		
		if(articleDao.getCommentCount(article.getRef())>=1){
			System.out.println("댓글이 존재합니다.");
			List<ArticleBean> cList = articleDao.getCommentList(article.getRef());
			request.setAttribute("cList",cList);
		}
		
		request.setAttribute("article",article);
		
		
	}
	
	public void write(HttpServletRequest request){
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		
		String title = request.getParameter("title");
		String content = request.getParameter("editor1");
		
		
		ArticleBean article = new ArticleBean();
		article.setBoardNo(boardNo);
		article.setTitle(title);
		article.setContent(content);
		
		HttpSession session = request.getSession();
		
		MemberBean member = (MemberBean)session.getAttribute("loginMember");
		
		article.setNickname(member.getNickname());
		article.setWriter(member.getId());
		article.setDay(new Timestamp(System.currentTimeMillis()));
		
		
		

		articleDao.insertArticle(article);
	}
	
	public void delete(int no){
	
		articleDao.deleteArticle(no);
	}
	
	public void writeComment(HttpServletRequest request){
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		int no = Integer.parseInt(request.getParameter("no"));
		
		String writer = request.getParameter("writer");
		String nickname = request.getParameter("nickname");
		
		String title = "comment";
		String content = request.getParameter("commentContent");
		int ref = Integer.parseInt(request.getParameter("ref"));
		ArticleBean article = new ArticleBean();
		article.setNo(no);
		article.setBoardNo(boardNo);
		article.setTitle(title);
		article.setContent(content);
		article.setWriter(writer);
		article.setNickname(nickname);
		article.setRef(ref);
		article.setDay(new Timestamp(System.currentTimeMillis()));
		
		
		HttpSession session = request.getSession();
		
		MemberBean member = (MemberBean)session.getAttribute("loginMember");
		
		article.setNickname(member.getNickname());
		article.setWriter(member.getId());
		article.setDay(new Timestamp(System.currentTimeMillis()));
		
		
		int seq = articleDao.getNextSeq(ref)+1;
		System.out.println("입력할 seq : " + seq);
				
		article.setSeq(seq);
				
		articleDao.insertComment(article);
	}
	
	public ArticleBean getArticle(int no){
		return articleDao.getArticle(no);
	}
	
	public void edit(HttpServletRequest request){
		ArticleBean article = new ArticleBean();
		String no = request.getParameter("no");
		String title = request.getParameter("title");
		String content = request.getParameter("editor1");
		
		article.setNo(Integer.parseInt(no));
		article.setTitle(title);
		article.setContent(content);
		
		articleDao.editArticle(article);
		
	}
	
	public void getLatestArticles(HttpServletRequest request){
		
		List<ArticleBean> list1 = articleDao.getLatestArticleList(1);
		List<ArticleBean> list2 = articleDao.getLatestArticleList(2);
		List<ArticleBean> list3 = articleDao.getLatestArticleList(3);
		List<ArticleBean> list4 = articleDao.getLatestArticleList(4);

		
		
		request.setAttribute("aList1", list1);
		request.setAttribute("aList2", list2);
		request.setAttribute("aList3", list3);
		request.setAttribute("aList4", list4);
	}
}
