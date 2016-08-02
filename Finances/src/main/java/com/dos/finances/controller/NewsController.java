package com.dos.finances.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.dos.finances.service.NewsService;

@Controller
public class NewsController {
	
	@Autowired
	private NewsService service;
	
	@RequestMapping(value = "/news", method = RequestMethod.GET)
	public String news(HttpServletRequest request,
			@RequestParam(value="pageNo",required=false,defaultValue="1") String pageNo){
	
		service.getNewsList(request, pageNo);
		
		return "news";
	}
	
	@RequestMapping("/newsSearch")
	public String news(HttpServletRequest request,String pageNo,String keyword){
		
		service.getNewsList(request, pageNo,keyword);

		return "news";
	}
	
}
