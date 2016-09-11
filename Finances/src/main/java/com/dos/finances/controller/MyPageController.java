package com.dos.finances.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.dos.finances.bean.MemberBean;
import com.dos.finances.bean.MessageBean;
import com.dos.finances.service.ArticleService;
import com.dos.finances.service.MemberService;
import com.dos.finances.service.MyPageService;


@Controller
public class MyPageController {

	@Autowired
	MyPageService service;
	
	@Autowired
	ArticleService articleService;
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping("/myPage")
	public String myPage(HttpServletRequest request){
		
		service.userInfo(request);
		
		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();
		request.setAttribute("latestArticleList", articleService.getLatestArticleListById(id));
		request.setAttribute("latestCommentList", articleService.getLatestCommentListById(id));
		
		return "myPage/myPage";
	}
	
	@RequestMapping("deleteFriend")
	public String deleteFriend(HttpServletRequest request){
		
		memberService.deleteFriend(request);
		
		return "redirect:friend";
	}
	
	@RequestMapping("/friend")
	public String friendList(HttpServletRequest request){
		memberService.friendList(request);
		return "myPage/friend";
	}
	
	
	@RequestMapping("/myStock")
	public String myStock(HttpServletRequest request){
		
		service.stock(request);
		
		return "myPage/myStock";
	}
	
	@RequestMapping("/record")
	public String record(HttpServletRequest request){
		
		service.record(request);
		
		return "myPage/record";
	}
	
	@RequestMapping("/interest")
	public String interest(HttpServletRequest request){
		
		service.interest(request);
		
		return "myPage/interest";
	}
	
	@RequestMapping(value="/sendMessage",method = RequestMethod.POST)
	public String sendMessage(MessageBean message){
		service.sendMessageProcess(message);
		return "redirect:message";
	}
	
	@RequestMapping("messageDetail")
	public String messageDetail(HttpServletRequest request,String no){
		HttpSession session = request.getSession();
		String id = ((MemberBean)session.getAttribute("loginMember")).getId();
		MessageBean m = service.getMessageBean(Integer.parseInt(no));
		request.setAttribute("m", m);
		memberService.messageOpen(id,Integer.parseInt(no));
		
		
		return "myPage/messageDetail";
	}
}
