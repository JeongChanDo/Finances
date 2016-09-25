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
<style>
	@media all and (min-width:1100px){
		#messageDiv div{
			width:48%;
			margin-right:10px;
			float:left;
		}
	}
</style>
<div id="messageDiv">
	<a href="writeMessage" class="btn btn-info" role="button">메시지 쓰기</a>
	<br/>
	<br/>
	<div id="latesestSendMassages">
		<h3>보낸 메시지</h3>
		<table class="table">
			<tr>
				<td>시간</td>
				<td>받는이</td>
				<td>제목</td>
				<td>확인여부</td>
			</tr>
			<c:if test="${not empty sendMessages}">
				<c:forEach var="s" items="${sendMessages}">
					<tr>
						<td>${s.time.toString().substring(0,s.time.toString().length()-2)}</td>
						<td>${s.receiver}</td>
						<td>
							<a href="#"  onclick="openMessage(${s.messageCode})">
								${s.title }
							</a>
						</td>
						<td>${(s.checked == true?"확인":"미확인")}</td>
					</tr>
				</c:forEach>
					<tr>
						<td colspan="4" style="text-align:center;"><a href="messageList?list=1&pageNo=1">메시지 더 보기</a></td>
					</tr>
			</c:if>
			<c:if test="${empty sendMessages}">
				<tr>
					<td colspan="4">
						보낸 메시지가 존재하지 않습니다.
					</td>
				</tr>
			</c:if>
		</table>
	</div>
	<div id="latestReceiveMessages">
		<h3>받은 메시지</h3>
		<table class="table">
			<tr>
				<td>시간</td>
				<td>보낸이</td>
				<td>제목</td>
				<td>확인여부</td>
			</tr>
			<c:if test="${not empty receiveMessages}">
				<c:forEach var="r" items="${receiveMessages}">
					<tr>
						<td>${r.time.toString().substring(0,r.time.toString().length()-2)}</td>
						<td>${r.sender }</td>
						<td><a href="#"  onclick="openMessage(${r.messageCode})">${r.title}</a></td>
						<td>${(r.checked == true?"확인":"미확인")}</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="4" style="text-align:center;"><a href="messageList?list=2&pageNo=1">메시지 더 보기</a></td>
				</tr>
			</c:if>
			<c:if test="${empty receiveMessages}">
				<tr>
					<td colspan="4">
						받은 메시지가 존재하지 않습니다.
					</td>
				</tr>
			</c:if>
		</table>
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
