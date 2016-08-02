<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.dao.*,java.util.*,com.dos.finances.bean.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String keyword = request.getParameter("keyword");
	
	List<StockBean3> rList = (List<StockBean3>)request.getAttribute("rList");
	
	
	Iterator<StockBean3> iter = rList.iterator();
	
	if(rList.size() == 0||keyword==null||keyword.equals("")||keyword.equals(" ")){
		out.print("<li class='searched' style='background:white;'>검색 결과가 존재하지 않습니다.</li>");
		
	}else{
		System.out.println("검색결과 갯수 : " + rList.size());
		while(iter.hasNext()){
			int i = 1;
			StockBean3 bean = iter.next();
			
			out.print("<li style='background:white;'><a class='searched' href='stockInfo?code="+bean.getCode()+"' >"+ bean.getCode()+"  -  " + bean.getName()+"</a></li>");
			if(i==5){
				break;
			}
		}
		
	}
	
	

%>