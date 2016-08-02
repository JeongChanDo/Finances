<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.dao.*,java.util.*,com.dos.finances.bean.*" %>
<%

	boolean result = (boolean)request.getAttribute("result");

	System.out.println("중복 체크 결과 : "+result+"  / "+(!result?"중복된 아이디 입니다.":"중복되지 않은 아이디 입니다."));
%>
<%="<p id='check'>"+result+"</p>"%>


