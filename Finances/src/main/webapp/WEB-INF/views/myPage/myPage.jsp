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

	<ul style="list-style:none;">
		<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">유저 정보</span></li>
	</ul>
<div id="myPageDiv">
	<div style="margin-top:50px;">
	<style>
		#userInfoTable td{
			padding-bottom:10px;
		}
		#userInfoTable tr td:nth-child(1){
			padding-right:15px;
		}
		
		#userInfoTable tr td:nth-child(2){
			padding-left:25px;
			border-left:1px solid #ededed;
		}
	</style>
		<div>
			<table class="table" id="userInfoTable">	
				<tr>
					<td>아이디</td>
					<td>${m.id}</td>
				</tr>
			
				<tr>
					<td>별명</td>
					<td>${m.nickname}</td>
				</tr>
				
				<tr>
					<td>자산</td>
					<td><fmt:formatNumber type="currency" value="${total }"/> (현금 : <fmt:formatNumber type="currency" value="${m.money }"/>)</td>
				</tr>
				
				<tr>
					<td>성별</td>
					<td>${m.gender }</td>
				</tr>
				
				<tr>
					<td>연락처</td>
					<td>${m.phone }</td>
				</tr>
				
				<tr>
					<td>우편번호</td>
					<td>${m.zip_code }</td>
				</tr>
				
				<tr>
					<td>주소</td>
					<td>${m.address1 } &nbsp;&nbsp;${m.address2 }</td>
				</tr>
			</table>
		</div>
		
		<div id="userLatesestArticleListDiv">
			<h4>최근 작성글</h4>
			<table class="table" id="uesrLatesestArticleListTable">
				<tr>
					<td>작성일</td>
					<td>제목</td>
					<td>내용</td>
				</tr>
				<c:if test="${not empty latestArticleList }">
					<c:forEach var="a" items="${latestArticleList}">
						<tr>
							<td>${a.day.toString().substring(0,a.day.toString().length()-2)}</td>
							<td><a href="detail?boardNo=${a.boardNo}&no=${a.no}">${a.title.length()>10?a.title.substring(0,10):a.title}</a></td>
							<td>${a.content.length() > 6 ? a.content.substring(0,6) : a.content}</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty latestArticleList }">
					<tr>
						<td colspan="3">작성 글이 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</table>
		</div>
		
		<div id="userLatesestCommentListDiv">
			<h4>최근 덧글</h4>
			<table class="table" id="uesrLatesestCommentListTable">
				<tr>
					<td>작성일</td>
					<td>내용</td>
				</tr>
				<c:if test="${not empty latestCommentList }">
					<c:forEach var="c" items="${latestCommentList}">
						<tr>
							<td>${c.day.toString().substring(0,c.day.toString().length()-2)}</td>
							<td>${c.content.length() > 10 ? c.content.substring(0,10) : c.content}</td>
						</tr>
					</c:forEach>
				</c:if>
				<c:if test="${empty latestCommentList }">
					<tr>
						<td colspan="3">작성된 덧글이 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</table>
		</div>
		
		<div id="totalStockList">
			<h4>소유한 주식</h4>
			<table class="table">
				<tr>
					<td>기업</td>
					<td>소유량</td>
				</tr>
				<c:if test="${empty totalStockList}">
					<tr>
						<td colspan="2">보유한 주식이 없습니다.</td>
					</tr>
				</c:if>
				<c:if test="${not empty totalStockList}">
					<c:forEach var="s" items="${totalStockList}">
						<tr>
							<td>${s.key }</td>
							<td>${s.value}</td>
						</tr>
					</c:forEach>
				</c:if>
				
				
			</table>
		</div>
	</div>
</div>
