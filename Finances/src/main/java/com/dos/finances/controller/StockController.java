package com.dos.finances.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dos.finances.service.StockService;

@Controller
public class StockController {

	@Autowired
	private StockService service;
	
	@RequestMapping("/stock")
	public String stock(HttpServletRequest request){
		service.stock(request);
		return "stock/stock";
	}
	
	
	@RequestMapping("/stockInfo")
	public String stockInfo(HttpServletRequest request,String code){
		
		service.stockInfo(request);
		
		return "stock/stockInfo";
	}
	
	
	@RequestMapping("stockBuy")
	public String stockBuy(HttpServletRequest request,String code){
		
		service.stockBuy(request,code);
		
		return "stock/stockBuy";
	}
	
	
	@RequestMapping("stockSell")
	public String stockSell(HttpServletRequest request,String code){
		
		service.stockSell(request,code);
		
		return "stock/stockSell";
	}
	
	@RequestMapping("trade")
	public String tradeList(HttpServletRequest request){
		service.tradeList(request);
		return "userPage/trade";
	}
	
	
	
	@RequestMapping("stockBuyProcess")
	public String stockBuyProcess(HttpServletRequest request,String code,HttpServletResponse response) throws IOException{
		request.setCharacterEncoding("utf-8");
		System.out.println("name : " + request.getParameter("name"));

		service.stockBuyProcess(request,response);
		
		return "redirect:stockInfo?code="+code;
	}
	
	
	@RequestMapping("stockSellProcess")
	public String stockSellProcess(HttpServletRequest request) throws UnsupportedEncodingException{

		request.setCharacterEncoding("utf-8");
		
		service.stockSellProcess(request);
		
		return "redirect:myStock";
	}
	
	@RequestMapping("/bookmarkProcess")
	public String bookmark(HttpServletRequest request){
		String code = request.getParameter("code");
		service.bookmarkProcess(request);
		return "redirect:stockInfo?code="+code;
	}
	
	@RequestMapping("/deleteBookmarkProcess")
	public String deleteBookmarkProcess(HttpServletRequest request){
		
		String code = request.getParameter("code");
		service.deleteBookmarkProcess(request);
		return "redirect:stockInfo?code="+code;
	}
	
	
}
