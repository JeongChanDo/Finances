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
<div id="messageDiv">
	<a href="writeMessage" class="btn btn-info" role="button">메시지 쓰기</a>
	<br/>
	<br/>
	<div id="searchDiv" class="form-group form-inline">
		<form action="messageSearch">
			<input type="hidden" name="list" value="${param.list}"/>
			<input type="hidden" name="pageNo" value="1"/>
			<input class="form-control" name="keyword" type="text" />
			<select name="option" class="form-control selectpicker remove-example">
				<option value="1">제목</option>
				
				<c:if test="${param.list == '1'}">
					<option value="1">받는이</option>
				</c:if>
				<c:if test="${param.list == '2'}">
					<option value="2">보낸이</option>
				</c:if>
			</select>
		</form>
	</div>
	
	<div id="latesestSendMassages">
		<h3>${(param.list == "1" ? "보낸 메시지" : "받은 메시지")}</h3>
		<table class="table">
			<tr>
				<td>시간</td>
				<td>${(param.list == "1" ? "받는이" : "보낸이")}</td>
				<td>제목</td>
				<td>확인여부</td>
			</tr>
			<c:if test="${not empty messages}">
				<c:forEach var="m" items="${messages}">
					<tr>
						<td>${m.time.toString().substring(0,m.time.toString().length()-2)}</td>
						<td>${param.list=="1"?m.receiver:m.sender}</td>
						<td>
							<a href="#"  onclick="openMessage(${m.messageCode})">
								${m.title }
							</a>
						</td>
						<td>${(m.checked == true?"확인":"미확인")}</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty messages}">
				<tr>
					<td colspan="4">메시지가 존재하지 않습니다.</td>
				</tr>
			</c:if>
		</table>
		<%
			int pageNo = Integer.parseInt(request.getParameter("pageNo"));
		%>
		<c:if test="${empty param.option }">
			<c:if test="${param.pageNo != '1' }">
				<a href="messageList?list=${param.list}&pageNo=<%=pageNo-1%>">이전</a>
			</c:if>
			<c:if test="${nextPageExist == true}">
				<a href="messageList?list=${param.list}&pageNo=<%=pageNo+1%>">다음</a>
			</c:if>
		</c:if>
		<c:if test="${not empty param.option }">
			<c:if test="${param.pageNo != '1' }">
				<a href="messageSearch?list=${param.list}&pageNo=<%=pageNo-1%>&option=${param.option}&keyword=${param.keyword}">이전</a>
			</c:if>
			<c:if test="${nextPageExist == true}">
				<a href="messageSearch?list=${param.list}&pageNo=<%=pageNo+1%>&option=${param.option}&keyword=${param.keyword}">다음</a>
			</c:if>
		</c:if>
	</div>
</div>
<script>
	function openMessage(messageCode){
		window.open(
				'messageDetail?no='+messageCode,'메시지','width=400px,height=400px'
			);
		return false;
	}
</script>
