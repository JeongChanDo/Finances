<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*" %>
<script>
	$(function(){
		$("#searchResultDiv").hide();
		$("#search").on("keyup",function(){//search에서 키를 때면
			var keyword = $(this).val();
			var param = "keyword="+encodeURIComponent(keyword);
			$.ajax({
				type:"post",
				url:"ajax/autoComplete",
				data:param,
				success:function(data,status,xhr){
					$("#searchResult").html(data);
					
					$("#searchResult #headerIncludeDiv").css("display","none");
	
					$("#searchResultDiv").show();
					
				},
				error:function(xhr,status){
					/* alert(xhr.readyState+" : " + xhr.status); */
				}
				
			})
		
		})
		
		$("*").on("click",function(){//search에서 포커스가 풀리면..
			
			
			if($(this)==$("#searchResult li a")){
				
			}else{
				$("#searchResult").empty();
				$("#searchResultDiv").hide();
				
			}
		})
		
		
	})

</script>
<style>
	.searched{
 		color:#c8c8c8;
		text-decoration:none;
		display:inline-block;
		width:100%;
		padding-left:10px;
		padding-top:2px;
		padding-bottom:2px;
	}
	.searched:hover{
		background:#ededed;
	}
	
	#searchResult .bodyIncludeDiv{
		margin:0px !important;
	}
	
	.stockTableDiv a{
		text-decoration:none;
		color:#0066CC;
	}
	
	#stockDiv a:hover{
		color:black;
	}
	@media all and (min-width:900px){
		.stockTableDiv{
			width:47%;
			float:left;
		}
		
	}

	.stockTableDiv{
		margin-right:10px;
	}
	
	
</style>
<!-- <link href="css/stock.css" rel="stylesheet"/> -->
<div id="stockDiv" style="padding:10px;	">
	<ul style="list-style:none;">
		<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">STOCK</span></li>
	</ul>
	<div id="stockListDiv">
		<div  id="stock">
		
			<div id="searchDiv">
				<input id="search" type="text" name="keyword" placeholder="검색" 
					style="width: 100%;height:30px; padding-left:5px;border: none;color: #a6a6a6;margin-top:20px;
					margin-bottom:10px;"/>
			</div>
			<div id="searchResultDiv" >
				<ul id="searchResult"  style="list-style:none;">
			
				</ul>
			</div>
			<br/>
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
		</c:if>
		<c:if test="${ isOpen == false}">
			<div  style="font-size:20px;"><i>마감 주가</i></div>
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
		</c:if>
		</div>
	</div>
</div>