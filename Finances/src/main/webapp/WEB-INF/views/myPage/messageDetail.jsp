<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,com.dos.finances.dao.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	if(session.getAttribute("loginMember")==null){
		%>
		<script>
		alert("잘못된 접근 입니다.");
		window.location.href('loginForm');
		</script>
		<%
	}
	
%>
<div id="messageDetailDiv" >
	<h3>메시지</h3>
	<table class="table table-condensed">
		<tr>
			<td>시간</td>
			<td>${m.time.toString().substring(0,m.time.toString().length()-2)}</td>
		</tr>
		<tr>
			<td>보낸이</td>
			<td><a href="userPage?id=${m.sender}" target="_blank">${m.sender}</a></td>
		</tr>
		<tr>
			<td>
				받는이
			</td>
			<td>
				${m.receiver}
			</td>
		</tr>
		<tr>
			<td>
				제목
			</td>
			<td>
				${m.title}
			</td>
		</tr>
		<tr>
			<td>내용</td>
			<td>
				${m.content}
			</td>
		</tr>
	</table>
	<a href="writeMessage?id=${m.sender}" class="btn btn-info" role="btn" target="_blank">답장 보내기</a>
</div>
<style>
	#headerAndSidebar{
		display:none;
	}
</style>