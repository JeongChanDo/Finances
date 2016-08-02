package com.dos.finances.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dos.finances.service.ArticleService;
import com.dos.finances.service.NewsService;
import com.dos.finances.service.StockService;

@Controller
public class FinancesController{
	
	@Autowired
	ArticleService articleService;
	
	@Autowired
	NewsService newsService;
	
	@Autowired
	StockService stockService;
	
	@RequestMapping({"/","index"})
	public String index(HttpServletRequest request){
		
		articleService.getLatestArticles(request);
		newsService.getLatestNewsList(request);
		
		stockService.stockForIndex(request);

		return "index";
	}
	

}
