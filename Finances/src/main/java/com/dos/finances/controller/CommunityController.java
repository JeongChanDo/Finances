package com.dos.finances.controller;

import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dos.finances.bean.ArticleBean;
import com.dos.finances.service.ArticleService;

@Controller
public class CommunityController {

	@Autowired
	private ArticleService service;
	
	@RequestMapping("community")
	public String community(HttpServletRequest request){
		
		service.getArticleList(request);
	
		return "community";
	}
	
	@RequestMapping("detail")
	public String detail(HttpServletRequest request){
		
		service.detail(request);
	
		return "community/detail";
	}
	
	@RequestMapping("writeForm")
	public String writeForm(HttpServletRequest request){
		
		
		return "community/writeForm";
	}
	
	@RequestMapping(value="write",method=RequestMethod.POST)
	public String write(HttpServletRequest request) throws UnsupportedEncodingException{
		request.setCharacterEncoding("utf-8");
		String boardNo = request.getParameter("boardNo");
		
		service.write(request);
		
		return "redirect:community?boardNo="+boardNo;
	}
	
	@RequestMapping("deleteArticle")
	public String delete(String boardNo, String pageNo, String no){
		
		service.delete(Integer.parseInt(no));
		
		return "redirect:community?boardNo="+boardNo;
	}
	
	@RequestMapping("deleteComment")
	public String delete(String boardNo, String pageNo, String no, String commentNo){
		
		service.delete(Integer.parseInt(commentNo));
		
		return "redirect:detail?boardNo="+boardNo+"&pageNo="+pageNo+"&no="+no;
	}
	
	@RequestMapping("editForm")
	public String editForm(HttpServletRequest request){
		String boardNo = request.getParameter("boardNo");
		String pageNo = request.getParameter("pageNo");
		String no = request.getParameter("no");
		ArticleBean article = service.getArticle(Integer.parseInt(no));
		request.setAttribute("article",article );
		request.setAttribute("pageNo",pageNo);
		return "community/editForm";
	}
	
	@RequestMapping(value="edit",method=RequestMethod.POST)
	public String edit(HttpServletRequest request) throws UnsupportedEncodingException{
		request.setCharacterEncoding("utf-8");
		String boardNo = request.getParameter("boardNo");
		String pageNo = request.getParameter("pageNo");
		String no = request.getParameter("no");
		
	
		return "detail?boardNo="+boardNo+"&pageNo="+pageNo+"&no="+no;
	}
	
	
	@RequestMapping(value="commentWrite",method=RequestMethod.POST)
	public String commentWrite(HttpServletRequest request) throws UnsupportedEncodingException{
		request.setCharacterEncoding("utf-8");
		String boardNo = request.getParameter("boardNo");
		String pageNo = request.getParameter("pageNo");
		String no = request.getParameter("no");
		
		service.writeComment(request);
		
		return "redirect:detail?boardNo="+boardNo+"&pageNo="+pageNo+"&no="+no;
	}
}
