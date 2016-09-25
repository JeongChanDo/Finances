package com.dos.finances.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.dos.finances.bean.MemberBean;
import com.dos.finances.dao.StockDao;
import com.dos.finances.service.ArticleService;
import com.dos.finances.service.MemberService;

@Controller
public class MemberController {

	String redirectIndex = "redirect:index";
	
	@RequestMapping("login")
	public String login(){
		
		return redirectIndex;
	}
	
	@Autowired
	private MemberService service;
	
	@Autowired
	private ArticleService articleService;
	
	@Autowired
	private StockDao stockDao;
	/*
	@RequestMapping(value = "loginProcess",
			method = RequestMethod.POST,produces="application/json")
	@ResponseBody
	public boolean login(String id, String pass) throws Exception {
		
		boolean result = service.loginCheck(id, pass);
	
		return result;
		
	}
	*/

	
	@RequestMapping(value="messageSearch",method=RequestMethod.GET)
	public ModelAndView messageSearch(HttpServletRequest request){
		
		ModelAndView modelAndView = new ModelAndView();
		String viewName = "myPage/messageList";
		
		modelAndView.setViewName(viewName);
		
		Map<String,Object> modelMap = new HashMap<String,Object>();
		service.messageSearchService(request);
		
		modelAndView.addAllObjects(modelMap);
		
		
		
		return modelAndView;
	}
	
	
	@RequestMapping(value="messageList",method = RequestMethod.GET)
	public ModelAndView messageList(HttpServletRequest request){
		ModelAndView modelAndView = new ModelAndView();
		String viewName = "myPage/messageList";
		
		modelAndView.setViewName(viewName);
		
		Map<String,Object> modelMap = new HashMap<String,Object>();
		
		service.messageListService(request);
		
		
		
		modelAndView.addAllObjects(modelMap);
		
		
		
		return modelAndView;
	}
	
	@RequestMapping("message")
	public String message(HttpServletRequest request){
		service.messageService(request);
		return "myPage/message";
	}
	

	@RequestMapping(value = "login", method = RequestMethod.POST)
	public String login(String id, HttpServletRequest request) throws Exception {
		
	
	
		MemberBean member = service.getMemberBean(id);
		
		request.getSession().setAttribute("loginMember", member);
		
		return redirectIndex;
		
	}
	
	@RequestMapping("signIn")
	public String signIn(HttpServletRequest request){
		service.signIn(request);
		return "sign/cong";
	}
	
	@RequestMapping("logout")
	public String logout(HttpServletRequest request){
		request.getSession().invalidate();
		return redirectIndex;
	}
	
	@RequestMapping("userPage")
	public ModelAndView userPage(String id,HttpSession session){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("userPage/userPage");
		Map<String,Object> modelMap = new HashMap<String,Object>();
		
		MemberBean user = service.getMemberBean(id);
		int total = stockDao.getTotalStockSum(id)+user.getMoney();

		modelMap.put("user",user);
		modelMap.put("total",total);
		
		modelMap.put("isFriend", false);

		if(session.getAttribute("loginMember") != null){
			
			
			
			
			System.out.println("친구여부 체크합니다.");
			MemberBean m = (MemberBean)session.getAttribute("loginMember");
			
			if(m.getId().equals(id)){
				modelAndView.setViewName("redirect:myPage");
			}
			
			modelMap.put("isFriend",service.friendCheck(m.getId(), id));
			
		}
		
		modelMap.put("totalStockList", stockDao.getTotalStockNameAndVolumeAboutId(id));
		modelMap.put("latestArticleList", articleService.getLatestArticleListById(id));
		modelMap.put("latestCommentList", articleService.getLatestCommentListById(id));
		
		
		
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}
	
	@RequestMapping("addFriendProcess")
	public ModelAndView addFriendProcess(HttpServletRequest request,String id,HttpSession session){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("redirect:userPage?id="+id);
		Map<String,Object> modelMap = new HashMap<String,Object>();
		

			
		MemberBean m = (MemberBean)session.getAttribute("loginMember");
		
		service.addFriend(m.getId(),id);
		
		service.addFriendMessage(request);
	
		
		modelAndView.addAllObjects(modelMap);
		return modelAndView;
	}

}
