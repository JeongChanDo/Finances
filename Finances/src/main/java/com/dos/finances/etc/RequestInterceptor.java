package com.dos.finances.etc;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.dos.finances.bean.MemberBean;
import com.dos.finances.dao.MemberDao;

@Service
public class RequestInterceptor implements HandlerInterceptor {

	
	@Autowired
	MemberDao memberDao;
	
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		System.out.println("인터셉터에 들어왔습니다. 요청 : " + request.getRequestURI());
		if(request.getSession().getAttribute("loginMember") != null){
			//로그인된 상태에서
			
			
			//해당 아이디가 읽지않은 메시지 갯수를 가지고온다.
			int uncheckedMessageCount 
				= memberDao.getUncheckedMessageCount(
						((MemberBean)request.getSession().getAttribute("loginMember")).getId());
			
			request.setAttribute("uncheckedMessageCount", uncheckedMessageCount);
			System.out.println("안읽은 메시지 수 : " + uncheckedMessageCount);
			
		}
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {

	}

}
