<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	.stockTableDiv a{
		text-decoration:none;
		color:#0066CC;
	}
	
	#stockDiv a:hover{
		color:black;
	}

	@media all and (min-width:1100px){
		.stockTableDiv{
			width:47%;
			float:left;
		}
		
	}

	.stockTableDiv{
		margin-right:10px;
	}
	
	#interestDiv ul{
		list-style:none;
	}

	#interestDiv a{
		text-decoration:none;
		color:#0066CC;
	}
	
	#interestDiv a:hover{
		color:black;
	}
</style>


<ul style="list-style:none;">
	<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">관심주</span></li>
</ul>
<div id="interestDiv" >
	<div style="margin-top:30px;padding:10px;">
		<ul>
			<c:if test="${empty yList1}">
				<li>관심 주가 존재하지 않습니다.</li>
			</c:if>
			
			<c:if test="${not empty yList1}">
				<c:if test="${ isOpen == true}">
					<div  style="font-size:20px;"><i>현재 주가</i></div>
						<br/>
						<div style="padding:0px;">
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
									<table  class="table">
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
								<table  class="table">
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
				</c:if>
				<c:if test="${ isOpen == false}">
					<div  style="font-size:20px;"><i>마감 주가</i></div>
					<br/>
					<div style="padding:0px;">
						<c:if test="${empty yList1}">
							<table  class="table">
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
							
						<div class="stockTableDiv">
							<c:if test="${not empty yList1 }">
									<table  class="table">
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
								<table  class="table">
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
				</c:if>
			</c:if>
		</ul>
	</div>
</div>
