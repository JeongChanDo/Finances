package com.dos.finances.service;


import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dos.finances.bean.BuyStockBean;
import com.dos.finances.bean.MemberBean;
import com.dos.finances.bean.StockBean2;
import com.dos.finances.bean.StockBean4;
import com.dos.finances.dao.MemberDao;
import com.dos.finances.dao.StockDao;


@Service
public class StockService {

	@Autowired
	private StockDao dao;
	
	
	@Autowired
	private MemberDao memberDao;
	
	public void stock(HttpServletRequest request){

	//	ServletContext ctx = request.getServletContext();
		
		//boolean isOpen = (boolean)ctx.getAttribute("isOpen");
		
		//System.out.println(isOpen?"장이 열렸습니다.":"장이 닫혔습니다.");
		
		List<StockBean4> yList =dao.getYesterdayStockList();
		List<StockBean4> yList1 = new ArrayList<StockBean4>();
		List<StockBean4> yList2 = new ArrayList<StockBean4>();
		

		for(int i = 0; i < yList.size()/2+1;i++){
			
			yList1.add(yList.get(i));
			
		}
		for(int i = yList.size()/2+1 ; i < yList.size(); i++){
			yList2.add(yList.get(i));
		}
		
		
		request.setAttribute("yList1",yList1);
		request.setAttribute("yList2",yList2);
		
	}
	
	public void stockForIndex(HttpServletRequest request){

		//	ServletContext ctx = request.getServletContext();
			
			//boolean isOpen = (boolean)ctx.getAttribute("isOpen");
			
			//System.out.println(isOpen?"장이 열렸습니다.":"장이 닫혔습니다.");
			
			List<StockBean4> yList =dao.getYesterdayStockList();
			List<StockBean4> yList1 = new ArrayList<StockBean4>();
			List<StockBean4> yList2 = new ArrayList<StockBean4>();
			

			Set<StockBean4> set = new HashSet<StockBean4>();
			
			set.addAll(yList);
			
			Iterator<StockBean4> iter = set.iterator();
			
			int i = 0;
			while(iter.hasNext()){
				StockBean4 s = iter.next();
				
				// 0 1 2
				if(i >= 0 && i < 3){
					
					
					yList1.add(s);
					
				// 3 4 5	
				}else if(i >=3 && i <6){
					
					yList2.add(s);
				}else if(i == 6){
				//i가 6이면 반복문 종료	
					break;
				}
				
				i++;
			}
			
		
			
			
			request.setAttribute("yList1",yList1);
			request.setAttribute("yList2",yList2);
			
		}
	
	public void stockInfo(HttpServletRequest request){

		String code = request.getParameter("code");
		boolean isLogin = false;
		boolean isInterested = false;
		MemberBean loginMember = null;
		
		//로그인 안되있으면
		if((request.getSession().getAttribute("loginMember")) ==null){
			dao.recordStock(code, 1);
		}else{//로그인이면
			String loginId =((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();
			dao.recordStock(code, loginId,1);
			isLogin = true;
			
			loginMember = (MemberBean) (request.getSession().getAttribute("loginMember"));
			isInterested = memberDao.checkInterestStock(loginMember.getId(), code);

		}
		request.setAttribute("loginMember",loginMember);
		request.setAttribute("isLogin",isLogin);
		request.setAttribute("isInterested", isInterested);

		
		
		//finance_stock_price_day 에서 해당 주식의 최신 정보를 가져와서 stockInfoPage에 뿌려준다.
		StockBean2 stock = dao.getStockBean2(code);
		
		request.setAttribute("sTime",stock.getTime());
		request.setAttribute("sCode",stock.getCode());
		request.setAttribute("sName",stock.getName());
		request.setAttribute("sPrice",stock.getPrice());
		/*
		boolean isOpen = (boolean)request.getServletContext().getAttribute("isOpen");
		//개장이 아니면 최근 하루간 정보들을 가져온다.
		*/
		List<String> datas = null;

		datas = dao.getStockListForGraph(code);

		
		
		
		//request.setAttribute("datas",datas);
		
		String times = datas.get(0);
		String prices = datas.get(1);
		String min = datas.get(2);
		String max = datas.get(3);
		String interval =datas.get(4);
		
		request.setAttribute("times",times);
		request.setAttribute("prices",prices);
		request.setAttribute("min",min);
		request.setAttribute("max",max);
		request.setAttribute("interval",interval);
	
		
		dao.stockholderProcess(request);
		
		
		
	}
	
	
	public void stockBuyProcess(HttpServletRequest request,HttpServletResponse response) throws IOException{
		HttpSession session = request.getSession();
		
		
		String code = request.getParameter("code");
		System.out.println("name : " + request.getParameter("name"));

		String name = request.getParameter("name");
		System.out.println("name : " + name);
		int volume = Integer.parseInt(request.getParameter("volume"));
		
		StockBean2 stock = dao.getStockBean2(code);
		
		int totalPrice = stock.getPrice()*volume;
		MemberBean member = (MemberBean)session.getAttribute("loginMember");
		
		int balance = member.getMoney()-totalPrice;
		
	
		

		//로그인 안되있으면
		if((request.getSession().getAttribute("loginMember")) ==null){
			dao.recordStock(code, 2);
		}else{//로그인이면
			String loginId =((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();
			dao.recordStock(code, loginId,2);
		}
		
		
		
		

		if(balance>=0){//잔액이 0보다 크고 장이 열려있어야 한다.
			dao.buyProcess(volume,stock.getPrice(),totalPrice,balance,code,member.getId(),name);
			MemberBean m =  memberDao.getMemberBean(member.getId());
			session.setAttribute("loginMember", m);
			//업데이트된 membreBean을 다시 session에 등록하자
		}else{
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('잔액이 부족합니다.')");
			out.println("</script>");
		}
	}
	
	
	public void stockSellProcess(HttpServletRequest request){
		try {
			request.setCharacterEncoding("utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		HttpSession session = request.getSession();
	
		String time = request.getParameter("time").trim();
		String code = request.getParameter("code");
		String id = request.getParameter("id");
		
		

		BuyStockBean b = dao.getBuyStockBean(code, id, time);
		String name = b.getName();

		
		//로그인 안되있으면
		if((request.getSession().getAttribute("loginMember")) ==null){
			dao.recordStock(code, 3);
		}else{//로그인이면
			String loginId =((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();
			dao.recordStock(code, loginId,3);
		}
		
		//매도량
		int volume = Integer.parseInt(request.getParameter("volume"));
		
		//보유량
		int remain = b.getVolume();
		
		//현재 주가정보로 처리된다.
		StockBean2 stock = dao.getStockBean2(code);
		
		int totalPrice = stock.getPrice()*volume;
		MemberBean member = (MemberBean)session.getAttribute("loginMember");
		
		int balance = member.getMoney()+totalPrice;
	
		dao.sellProcess(time,remain,volume,stock.getPrice(),totalPrice,balance,code,member.getId(),name);
		MemberBean m =  memberDao.getMemberBean(member.getId());
		session.setAttribute("loginMember", m);
	}
	
	public void stockSell(HttpServletRequest request, String code){
		

		StockBean2 stock = dao.getStockBean2(code);
		request.setAttribute("dao", dao);
		request.setAttribute("stock",stock);

	}
	
	public void stockBuy(HttpServletRequest request,String code){
		
		StockBean2 stock = dao.getStockBean2(code);
		
		request.setAttribute("stock",stock);

	}
	
	public void bookmarkProcess(HttpServletRequest request){
		String code = request.getParameter("code");
		String id  = ((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();
		
		dao.insertBookmark(id, code);
	}
	
	public void deleteBookmarkProcess(HttpServletRequest request){
		String code = request.getParameter("code");
		String id  = ((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();
		
		dao.deleteBookmark(id, code);
	}
}
