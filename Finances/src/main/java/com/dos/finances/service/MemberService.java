package com.dos.finances.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dos.finances.bean.MemberBean;
import com.dos.finances.dao.MemberDao;

@Service
public class MemberService {

	
	@Autowired
	private MemberDao dao;
	
	
	
	public void addFriendMessage(HttpServletRequest request){
		dao.addFriendMessage(request);	
	}
	
	public void messageOpen(String id,int no){
		dao.messageOpen(id,no);
	}
	
	public void friendList(HttpServletRequest request){
		dao.getFriendList(request);
	}
	
	public void messageService(HttpServletRequest request){
		dao.messageService(request);
	}
	
	
	public void messageSearchService(HttpServletRequest request){
		dao.messageSearchService(request);
	}
	
	public void messageListService(HttpServletRequest request){
		dao.messageListService(request);
		
	}
	
	public boolean loginCheck(String id,String pass){
		
		return dao.loginCheck(id, pass);
	}
	
	public void insertMember(MemberBean member){
		
		dao.insertMember(member);
	}
	
	
	public MemberBean getMemberBean(String id){
		
		return dao.getMemberBean(id);
	}
	
	
	public boolean idCheck(String id){
		

		return dao.idCheck(id);
	}
	

	public boolean checkInterestStock(String id,String code){
		
	
		return dao.checkInterestStock(id, code);
	}
	
	
	
	public void signIn(HttpServletRequest request){

		MemberBean member = (MemberBean)request.getAttribute("member");
		member.printMemberInfo();
		dao.insertMember(member);
	}
	
	public boolean friendCheck(String myId,String id){
		return dao.friendCheck(myId,id);
	}
	
	public void addFriend(String me, String friend){
		dao.addFriend(me,friend);
	}
	
	
}
