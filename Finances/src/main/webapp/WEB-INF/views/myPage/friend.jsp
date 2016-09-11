<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,com.dos.finances.dao.*,java.sql.*" %>
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
<!-- <style>
	@media all and (min-width:1100px){
		#messageDiv div{
			width:48%;
			margin-right:10px;
			float:left;
		}
	}
</style> -->
<div id="friendListDiv">
	<h3>친구 목록</h3>
	<table class="table">
		<tr>
			<td>등록일</td>
			<td>아이디</td>
			<td></td>

		</tr>
		<c:if test="${empty fList}">
			<tr>
				<td colspan=5>등록된 친구가 존재하지 않습니다.</td>
			</tr>
		</c:if>
		<c:if test="${not empty fList}">
			<c:forEach var="f" items="${fList}">
				<tr>
					<td>${f.time.toString().substring(0,f.time.toString().length()-2)}</td>
					<td>${f.friend}</td>
					<td>
						<a href="writeMessage?id=${f.friend}">메시지</a>
						&nbsp;<a href="trade?id=${f.friend}">거래</a>
						&nbsp;<a href="deleteFriend?id=${f.friend}" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
					</td>

				</tr>
			</c:forEach>
		</c:if>
	</table>
</div>