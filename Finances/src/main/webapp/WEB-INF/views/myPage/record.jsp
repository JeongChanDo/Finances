<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,java.sql.*" %>
<%
	if(session.getAttribute("loginMember")==null){
		%>
		<script>
		alert("잘못된 접근 입니다.");
		window.location.href('loginForm.do');
		</script>
		<%
	}

%>
<style>
	#list{
		width:100%;
		border-collapse:collapse;
	}
	
	#list th,#list td{
		border-collapse:collapse;
		width:20%;
		padding-top:5px;
		padding-bottom:5px;
	}
	
	#list th{
		border-bottom:1px solid #dddddd;
		text-align:center;
	}
	
	#list td{
		text-align:center;
	}
</style>


	<ul style="list-style:none;">
		<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">내역</span></li>
	</ul>
<div id="myPageDiv" >
	<div style="margin-top:20px;padding:10px;">
		<c:if test="${empty hList }">
			거래한 내역이 없습니다.
		</c:if>
		<c:if test="${not empty hList}">
			<table id="list" class="table">
				<tr>
					<th>분류</th>
					<th>시간</th>
					<th>이름</th>
					<th>가격<br/>/수량</th>
					<th>총액</th>
				</tr>
				<c:forEach var="h" items="${hList}">
					<tr>
						<td>${h.sort == 'sell'?'매도':'매수' }</td>
						<td>
							<% 
								Timestamp t = ((TradeHistoryBean)pageContext.getAttribute("h")).getTime();
							
							%>
							<%=t.toString().substring(0,t.toString().length()-2) %>
						</td>
						<td>
							<a href="mStockInfo.do?code=${h.code}" style="text-decoration:none;" rel="external"  >${h.name}</a>
						</td>
						<td>
							<fmt:formatNumber value="${h.price }" type="number"/>
							<br/>/<fmt:formatNumber value="${h.volume}" type="number"/>
						</td>
			
						
						<td>
							<fmt:formatNumber value="${h.totalPrice}" type="number"/>
						</td>
						
					</tr>
				</c:forEach>
			</table>
		</c:if>
	</div>
</div>
