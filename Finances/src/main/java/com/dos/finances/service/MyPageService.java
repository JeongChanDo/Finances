package com.dos.finances.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dos.finances.bean.BuyStockBean;
import com.dos.finances.bean.MemberBean;
import com.dos.finances.bean.MessageBean;
import com.dos.finances.bean.StockBean4;
import com.dos.finances.bean.TradeHistoryBean;
import com.dos.finances.dao.ETCDao;
import com.dos.finances.dao.MemberDao;
import com.dos.finances.dao.StockDao;

@Service
public class MyPageService {

	@Autowired
	StockDao stockDao;
	
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	ETCDao etcDao;
	
	public MemberBean getLoginMember(HttpServletRequest request){
		return (MemberBean)request.getSession().getAttribute("loginMember");
	}
	
	public void getFriendList(HttpServletRequest request){
		memberDao.getFriendList(request);
	}
	
	
	public void sendMessageProcess(MessageBean message){
		message.setTime(new Timestamp(System.currentTimeMillis()));
		
		memberDao.sendMessageProcess(message);
		
	}
	
	public MessageBean getMessageBean(int no){
		
		return memberDao.getMessageBean(no);
	}
	
	public void userInfo(HttpServletRequest request){
		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();
		MemberBean m =memberDao.getMemberBean(id);
		int total = stockDao.getTotalStockSum(m.getId())+m.getMoney();
		
		request.setAttribute("total",total);
		request.setAttribute("m", m);
		request.setAttribute("totalStockList", stockDao.getTotalStockNameAndVolumeAboutId(id));
	}
	
	public void stock(HttpServletRequest request){
		String id = ((MemberBean)request.getSession().getAttribute("loginMember")).getId();

		List<BuyStockBean> buyList = stockDao.getBuyStockList(id);
		
		request.setAttribute("bList",buyList);

	}
	
	public void record(HttpServletRequest request){
		String id =((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();

		List<TradeHistoryBean> hList = etcDao.getTradeHistoryBeanList(id);
		
		request.setAttribute("hList",hList);
		
	}
	
	public void interest(HttpServletRequest request){
		String id =((MemberBean)(request.getSession().getAttribute("loginMember"))).getId();

	
		
		List<StockBean4> yList =stockDao.getInterestedStockList(id);
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
	
}
