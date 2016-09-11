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

<div id="tradeDiv">
	<h3>${param.id}님의 보유 주식리스트</h3>
	<table class="table">
		<tr>
			<td>매입시기</td>
			<td>이름</td>
			<td>매입가&nbsp;/현재가</td>
			<td>수량</td>
			<td></td>
		</tr>
		<c:if test="${not empty sList}">
			<c:forEach var="s" items="${sList}">
				<tr>
					<td>${s.time.toString().substring(0,s.time.toString().length()-2)}</td>
					<td><a href="stockInfo?code=${s.code}">${s.name}</a></td>
					<td>${s.price} &nbsp;/${s.currentPrice }</td>
					<td>${s.volume}</td>
					<td>
						<a href="tradeAction?id=${s.id}&code=${s.code}&time=${s.time}">거래</a>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty sList}">
			<tr>
				<td colspan="5">보유한 주식이 없습니다.</td>
			</tr>
		</c:if>
	</table>
</div>