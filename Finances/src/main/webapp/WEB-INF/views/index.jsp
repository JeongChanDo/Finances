<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,java.sql.*" %>
<%
	Timestamp today = new Timestamp(System.currentTimeMillis());
%>

<link href="resources/css/index.css" rel="stylesheet"/>


	<div id="indexBody" style="margin-left:20px;padding-top:100px;">
<div  id="stock">
		
		<!-- 
		
			뉴스 파트
		 -->
		
	
		<div id="newsDivTable" style="margin-bottom:30px;margin-right:60px;width:83%;">
			<table class="table">
					<tr>
						<th>NEWS</th>
					</tr>
				<c:forEach var="n" items="${nList }">
					<tr>
						<td>
							<a href="${n.link}">${n.title}</a>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		
		
		<!-- 
		
			주가 파트
		 -->
		
		<div style="padding:0px;">
				<div style="text-align:left;padding-right:0px;"> 
					<%
						Timestamp t = new Timestamp(System.currentTimeMillis());
						boolean isOpen = (boolean)request.getServletContext().getAttribute("isOpen");
					%> 
					<%=t.toString().substring(0,10) %>&nbsp;&nbsp;
					<%=isOpen?"개장":"마감" %>
				</div>
				<c:if test="${empty yList1}">
					<table class="table">
						<tr>
							<th>종목</th>
							<th>시세</th>
							<th>전일비</th>
						</tr>
						<tr>
							<td colspan="3">주가 정보가 존재하지 않습니다.</td>
						</tr>
					</table>
				</c:if>
					
				<div class="stockTableDiv" >
					<c:if test="${not empty yList1 }">
							<table class="table">
								<tr>
									<th>종목</th>
									<th>시세</th>
									<th>전일비</th>
								</tr>
								<c:forEach var="s" items="${yList1}">
									<tr>
										<td><a href="stockInfo?code=${s.code}" >${s.name }</a></td>
										<td><fmt:formatNumber value="${s.price }" type="currency"/></td>
										<td>
											<c:if test="${s.price2 > 0}">
												<span style="color:green;"><img src="resources/img/sUp.png" width="10" height="10" />${s.price2}</span>
											</c:if>
											<c:if test="${s.price2 == 0}">
												<span>${s.price2}</span>
											</c:if>
											<c:if test="${s.price2 < 0}">
												<span style="color:red;"><img src="resources/img/sDown.png" width="10" height="10"/>${s.price2}</span>
											</c:if>
										</td>
							
							
									</tr>
								</c:forEach>
							</table>

					</c:if>	
				</div>
				
				
				<div class="stockTableDiv">
					<c:if test="${not empty yList2 }">
						<table class="table">
							<tr>
								<th>종목</th>
								<th>시세</th>
								<th>전일비</th>
							</tr>
							<c:forEach var="s" items="${yList2}">
								<tr>
									<td><a href="stockInfo?code=${s.code}" >${s.name }</a></td>
									<td><fmt:formatNumber value="${s.price }" type="currency"/></td>
									<td>
										<c:if test="${s.price2 > 0}">
											<span style="color:green;"><img src="resources/img/sUp.png" width="10" height="10" />${s.price2}</span>
										</c:if>
										<c:if test="${s.price2 == 0}">
											<span>${s.price2}</span>
										</c:if>
										<c:if test="${s.price2 < 0}">
											<span style="color:red;"><img src="resources/img/sDown.png" width="10" height="10"/>${s.price2}</span>
										</c:if>
									</td>
						
						
								</tr>
							</c:forEach>
						</table>
					</c:if>
				</div>
				
				
				<div class="clear_line"></div>
			</div>
		
		</div>
			
		<br/>
		<div style="clear:both"></div>
		<br/>
		<br/>
		
		
		
		
		<div style="padding:0px;">
	
					
				<div class="stockTableDiv" >
					<table class="table">
						<tr>
							<th>이야기</th>
						</tr>
						<c:forEach var="s" items="${aList1}">
							<tr>
								<td><a href="detail?boardNo=${s.boardNo }&pageNo=1&no=${s.no}">${s.title}</a></td>	
							</tr>
						</c:forEach>
					</table>
				</div>
				
				
				<div class="stockTableDiv" >
					<table class="table">
						<tr>
							<th>Q&A</th>
						</tr>
						<c:forEach var="a" items="${aList2}">
							<tr>
								<td><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}">${a.title}</a></td>	
							</tr>
						</c:forEach>
					</table>
				</div>
				
				
				<div class="clear_line"></div>
				
				<div class="stockTableDiv" >
					<table class="table">
						<tr>
							<th>칼럼</th>
						</tr>
						<c:forEach var="a" items="${aList3}">
							<tr>
								<td><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}">${a.title}</a></td>	
							</tr>
						</c:forEach>
					</table>
				</div>
				
				
				<div class="stockTableDiv" >
					<table class="table">
						<tr>
							<th>소식</th>
						</tr>
						<c:forEach var="a" items="${aList4}">
							<tr>
								<td><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}">${a.title}</a></td>	
							</tr>
						</c:forEach>
					</table>
				</div>
				
				
				<div class="clear_line"></div>
			</div>
		
		</div>
			
		<br/>
		<div style="clear:both"></div>
		<br/>
		<br/>
		
		
		
		
	</div>