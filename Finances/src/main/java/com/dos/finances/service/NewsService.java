package com.dos.finances.service;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dos.finances.bean.NewsBean;
import com.dos.finances.dao.NewsDao;

@Service
public class NewsService {
	
	final int PAGE_SIZE = 10;
	final int PAGE_GROUP = 5;
	
	@Autowired
	private NewsDao dao;
	
	public List<NewsBean> getNewsList(HttpServletRequest request, String pageNo1){
		
		int pageNo = Integer.parseInt(pageNo1);
		
		int endNo = PAGE_SIZE*pageNo;	//pageNo =1  --> endNo = 10		10 		-> endNo 50 
		
		int startNo = endNo-(PAGE_SIZE-1);	//endNo=40 ->startNo = 31		10	->	9
		
		
		int numOfNews = dao.getNumOfNews();
		int numOfPage = numOfNews%PAGE_SIZE==0?numOfNews/PAGE_SIZE:numOfNews/PAGE_SIZE+1;
		//31개 --> 4페이지		130	-->	13페이지
		
		
		int numOfPageGroup = numOfPage%PAGE_GROUP==0?numOfPage/PAGE_GROUP:numOfPage/PAGE_GROUP+1;
		//11페이지	-> 2그룹			30페이지 -> 3그룹
		
		int currentPageGroup = pageNo%PAGE_GROUP==0?pageNo/PAGE_GROUP:pageNo/PAGE_GROUP+1;
		//14페이지 -> 3번째 그룹	 15페이지 ->3번째 그룹	25페이지	->5번째 그룹
		
		
		int startPage = currentPageGroup*PAGE_GROUP-(PAGE_GROUP-1);
		//3번그룹		->		15-4 = 11
		
		int endPage = currentPageGroup==numOfPageGroup?numOfPage:currentPageGroup*PAGE_GROUP; 
		// 현재  3번그룹	그룹수 3그룹 ->  페이지갯수 13-> 마지막페이지는 13페이지
		//현재 1번그룹	그룹수 3그룹	->	1-5
		
		
		request.setAttribute("startNo",startNo);
		request.setAttribute("numOfNews",numOfNews);
		request.setAttribute("numOfPage",numOfPage);
		request.setAttribute("numOfPageGroup",numOfPageGroup);
		request.setAttribute("currentPageGroup",currentPageGroup);

		request.setAttribute("startPage",startPage);
		request.setAttribute("endPage",endPage);
		request.setAttribute("pageGroup",PAGE_GROUP);
		
		
		List<NewsBean> nList = dao.getNewsList(startNo,endNo);
		
		request.setAttribute("nList", nList);
		
		return nList;
	}
	
	public List<NewsBean> getNewsList(HttpServletRequest request, String pageNo1, String keyword1){
		
		String keyword = keyword1;
		
		
		int pageNo = Integer.parseInt(pageNo1==null?"1":pageNo1);
		
		
		int endNo = PAGE_SIZE*pageNo;	//pageNo =1  --> endNo = 10		10 		-> endNo 50 
		int startNo = endNo-(PAGE_SIZE-1);	//endNo=40 ->startNo = 31		10	->	9
		
		
		int numOfNews = dao.getNumOfSearchedNews(keyword);
		int numOfPage = numOfNews%PAGE_SIZE==0?numOfNews/PAGE_SIZE:numOfNews/PAGE_SIZE+1;
		//31개 --> 4페이지		130	-->	13페이지
		
		
		int numOfPageGroup = numOfPage%PAGE_GROUP==0?numOfPage/PAGE_GROUP:numOfPage/PAGE_GROUP+1;
		//11페이지	-> 2그룹			30페이지 -> 3그룹
		
		int currentPageGroup = pageNo%PAGE_GROUP==0?numOfPage/PAGE_GROUP:pageNo/PAGE_GROUP+1;
		//14페이지 -> 3번째 그룹		25페이지	->5번째 그룹
		
		
		int startPage = currentPageGroup*PAGE_GROUP-(PAGE_GROUP-1);
		//3번그룹		->		15-4 = 11
		
		int endPage = currentPageGroup==numOfPageGroup?numOfPage:currentPageGroup*PAGE_GROUP; 
		// 현재  3번그룹	그룹수 3그룹 ->  페이지갯수 13-> 마지막페이지는 13페이지
		//현재 1번그룹	그룹수 3그룹	->	1-5
		
		request.setAttribute("keyword",keyword);
		request.setAttribute("startNo",startNo);
		request.setAttribute("numOfNews",numOfNews);
		request.setAttribute("numOfPage",numOfPage);
		request.setAttribute("numOfPageGroup",numOfPageGroup);
		request.setAttribute("currentPageGroup",currentPageGroup);
		
		request.setAttribute("startPage",startPage);
		request.setAttribute("endPage",endPage);
		request.setAttribute("pageGroup",PAGE_GROUP);
		
		
		
		
		
		
		List<NewsBean> nList = dao.getNewsListByKeyword(keyword,startNo,endNo);
		
		request.setAttribute("nList",nList);
		
		return nList;
	}
	
	
	public void getLatestNewsList(HttpServletRequest request){
		
		List<NewsBean> nList= dao.getLatestNewsList();
		request.setAttribute("nList",nList);
		
	}
	
}
