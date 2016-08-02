<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.bean.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="member" class="com.dos.finances.bean.MemberBean" scope="request"/>
<jsp:setProperty name="member" property="*"/>
<%
	MemberBean m = (MemberBean)request.getAttribute("member");
	m.printMemberInfo();
	
	pageContext.forward("signIn"); 
/* 	pageContext.forward("signIn.do"); */
%>