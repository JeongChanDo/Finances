<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.bean.*" %>
<%
	MemberBean m = (MemberBean)request.getAttribute("member");
%>

<div style="padding-top:100px;padding-left:20px;">
	<h1 style="font-weight:100">환영합니다. <%=m.getNickname() %>님!!!</h1><br/>
	<a href="index" style="text-decoration:none;color:blue;font-weight:100;">메인으로 가기</a>
	
</div>
