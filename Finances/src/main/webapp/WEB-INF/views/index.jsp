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
		
		<div id="newsDiv" style="padding:10px;margin-bottom:30px;margin-right:60px;width:83%;font-weight:100;border:1px solid #ededed;">
			<p style="font-size:20px;margin-bottom:5px;">NEWS</p>
			<div id="newsBody"  style="border-top:1px solid #ededed;padding-top:5px;">
				<ul style="list-style:none;" id="newsList">
					<c:forEach var="n" items="${nList }">
						<li><a href="${n.link}">${n.title}</a></li>
					</c:forEach>
				</ul>
			</div>
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
		
		
		
		<div id="boardList">
			
			<div id="aList1" class="aListDiv">
				<div class="communityListBody">
					<ul class="communityList">
						<li style="font-size:20px;font-weight:100;border-bottom:1px solid #ededed;"><a href="community?boardNo=1&pageNo=1">이야기</a></li>
					
					<c:if test="${not empty aList1 }">
						<c:forEach var="a" items="${aList1 }">
						<%
							String title = ((ArticleBean)pageContext.getAttribute("a")).getTitle();
						%>	
						
							<li><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}" >
								<p class="aTitle"><%=title.length() >= 18 ? title.substring(0,18)+"...":title %></p>
								<p class="aTime">
								<%
									ArticleBean a = (ArticleBean)pageContext.getAttribute("a");
									String aDate = a.getDay().toString().substring(0,10);
				
									if(today.toString().substring(0,10).equals(aDate)){
										%>
											<fmt:formatDate value="${a.day }" pattern="aa hh:mm"/>
										<%
									}else{
										
										%>
										<fmt:formatDate value="${a.day }" pattern="yyyy-MM-dd"/>
										<%
									}
								%>
								</p>
							</a>
							</li>
						</c:forEach>
					</c:if>
					</ul>
					<div style="clear:both;"></div>
				</div>
			</div>
			
			<div id="aList2" class="aListDiv">
				<div class="communityListBody">
					<ul class="communityList">
						<li style="font-size:20px;font-weight:100;border-bottom:1px solid #ededed;"><a href="community?boardNo=3&pageNo=1">Q&A</a></li>
					
					
					<c:if test="${not empty aList2 }">
						<c:forEach var="a" items="${aList2 }">
						<%
							String title = ((ArticleBean)pageContext.getAttribute("a")).getTitle();
						%>	
						
							<li><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}" >
								<p class="aTitle"><%=title.length() >= 18 ? title.substring(0,18)+"...":title %></p>
								<p class="aTime">
								<%
									ArticleBean a = (ArticleBean)pageContext.getAttribute("a");
									String aDate = a.getDay().toString().substring(0,10);
				
									if(today.toString().substring(0,10).equals(aDate)){
										%>
											<fmt:formatDate value="${a.day }" pattern="aa hh:mm"/>
										<%
									}else{
										
										%>
										<fmt:formatDate value="${a.day }" pattern="yyyy-MM-dd"/>
										<%
									}
								%>
								</p>
							</a></li>
						</c:forEach>
					</c:if>
					</ul>
					<div style="clear:both;"></div>
				</div>
			</div>
			<div id="aList1" class="aListDiv">
				<div class="communityListBody">
					<ul class="communityList">
						
						<li style="font-size:20px;font-weight:100;border-bottom:1px solid #ededed;"><a href="community?boardNo=3&pageNo=1">컬럼</a></li>			
					
					<c:if test="${not empty aList3 }">
						<c:forEach var="a" items="${aList3 }">
						<%
							String title = ((ArticleBean)pageContext.getAttribute("a")).getTitle();
						%>	
						
							<li><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}" >
								<p class="aTitle"><%=title.length() >= 18 ? title.substring(0,18)+"...":title %></p>
								<p class="aTime">
								<%
									ArticleBean a = (ArticleBean)pageContext.getAttribute("a");
									String aDate = a.getDay().toString().substring(0,10);
				
									if(today.toString().substring(0,10).equals(aDate)){
										%>
											<fmt:formatDate value="${a.day }" pattern="aa hh:mm"/>
										<%
									}else{
										
										%>
										<fmt:formatDate value="${a.day }" pattern="yyyy-MM-dd"/>
										<%
									}
								%>
								</p>
							</a>
							</li>
						</c:forEach>
					</c:if>
					</ul>
					<div style="clear:both;"></div>
				</div>
			</div>

	
			<div id="aList2" class="aListDiv">
				<div class="communityListBody">
					<ul class="communityList">
					
						<li style="font-size:20px;font-weight:100;border-bottom:1px solid #ededed;"><a href="community?boardNo=4&pageNo=1">소식</a></li>
					
					<c:if test="${not empty aList4 }">
						<c:forEach var="a" items="${aList4 }">
						<%
							String title = ((ArticleBean)pageContext.getAttribute("a")).getTitle();
						%>	
						
							<li><a href="detail?boardNo=${a.boardNo }&pageNo=1&no=${a.no}" >
								<p class="aTitle"><%=title.length() >= 18 ? title.substring(0,18)+"...":title %></p>
								<p class="aTime">
								<%
									ArticleBean a = (ArticleBean)pageContext.getAttribute("a");
									String aDate = a.getDay().toString().substring(0,10);
				
									if(today.toString().substring(0,10).equals(aDate)){
										%>
											<fmt:formatDate value="${a.day }" pattern="aa hh:mm"/>
										<%
									}else{
										
										%>
										<fmt:formatDate value="${a.day }" pattern="yyyy-MM-dd"/>
										<%
									}
								%>
								</p>
							</a></li>
						</c:forEach>
					</c:if>
					</ul>
					<div style="clear:both;"></div>
				</div>
			</div>
		
		</div>
		
	</div>