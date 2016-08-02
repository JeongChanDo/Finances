<%@page import="java.util.logging.SimpleFormatter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,java.sql.Timestamp" %>
<script src="resources/js/highcharts.js"></script>
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
	
	#backgroundLayer{
		display:none;
		position:fixed;
		left:0;
		top:0;
		height:100%;
		width:100%;
		background:black;
		filter:alpha(opacity=60);
		opacity:0.60;
		z-index:3;
	}
	
	#stockLayer{
		display:none;
		position:fixed;
		top:50%;
		left:50%;
		z-index:4;
		background:#f9f9f9;
		margin:0px auto;
		height:450px;
		margin-top:-225px;
	}
	@media(max-width:420px){
		#stockLayer{
			width:300px;
			/* height:450px; */
			margin-left:-150px;
			margin-top:-225px;
		}
	}
	@media(min-width:421px) and (max-width:799px){
		#stockLayer{
			width:400px;
/* 			height:600px;
 */			margin-left:-200px;
		/* 	margin-top:-300px; */
			
		}
	}
	
	@media(min-width:800px){
		#stockLayer{
			width:780px;
			margin-left:-390px;
		/* 	margin-top:-300px; */
		}
	}
	
	#stockLayer #header{
		display:none;
	}
	
	#stockLayer .bodyIncludeDiv{
		margin:0px !important;
	}
	
</style>
<script>

	$(function(){
		var code;
		var name;
		var time;
		$("#stockLayer").empty();
		$("#backgroundLayer").on("click",function(){
			$("#stockLayer").empty();
			$("#backgroundLayer").fadeOut(300);		
			$("#stockLayer").fadeOut(300);
		})
		
		$(".name").on("click",function(){
			$("#stockLayer").empty();
			code = 'code='+$(this).attr("class").split(' ')[1];
			name = $(this).text();
			time = $.trim($(this).parent().prev().text());
			var result;
			$.ajax({
				type:"POST",
				url:"ajax/myStockAjax",
				data:code,
				success:function(responseData,status,xhr){
					result = responseData;
					/* 
					alert(result);
					var find = $(result).find("#result1").text();
					alert(find);
					 */
					$("#stockLayer").append(result);
				 	$("#container2").fadeOut(200);
					$("#time").val(time);
				},
				error:function(xhr,statusText,error){
					/* alert("error : " + statusText +"."+xhr.status); */
				}
				
			});
			
			$("#backgroundLayer").fadeIn(300);
			$("#stockLayer").fadeIn(300);
			return false;
			
		})
	})
</script>
<div id="backgroundLayer"></div>
<div id="stockLayer"></div>
	<ul style="list-style:none;">
		<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">보유주</span></li>
	</ul>
<div id="myPageDiv" >
	<div style="margin-top:20px;padding:10px;">
		<c:if test="${empty bList}">
			구입한 주식이 없습니다.
		</c:if>	
		<c:if test="${not empty bList}">
			<table id="list" class="table">
				<tr>
					<th>시간</th>
					<th>이름</th>
					<th>매수가<br/>/현재가</th>
					<th>수량<br/>/차익</th>
				</tr>
			<c:forEach var="b" items="${bList }">
				<tr>
					<td>
						<% 
							Timestamp t = ((BuyStockBean)pageContext.getAttribute("b")).getTime();
				
							BuyStockBean b = (BuyStockBean)pageContext.getAttribute("b");
							int profit = b.getCurrentPrice()-b.getPrice();
							pageContext.setAttribute("profit",profit);
							String code = b.getCode();
						%>
						${b.time.toString().substring(0,b.time.toString().length()-2)}
					</td>
					<td>
						<a class="name ${b.code }" style="text-decoration:none;" rel="external" href="#" >${b.name}</a>
						<span style="display:none;">${b.code }</span>
					</td>
					<td>
						<fmt:formatNumber value="${b.price }" type="number"/><br/>/<fmt:formatNumber value="${b.currentPrice}" type="number"/>
					</td>
		
					<td>
						<fmt:formatNumber value="${b.volume}" type="number"/>
						<br/>
						<c:if test="${profit > 0}">
							<span style="color:green;"><img src="resources/img/sUp.png" width="10" height="10" /><fmt:formatNumber value="${profit}" type="number"/></span>
						</c:if>
						<c:if test="${profit == 0}">
							<span>0</span>
						</c:if>
						<c:if test="${profit < 0}">
							<span style="color:red;"><img src="resources/img/sDown.png" width="10" height="10"/><fmt:formatNumber value="${-profit}" type="number"/></span>
						</c:if>
					</td>
				
					
				</tr>
			</c:forEach>
			</table>
		</c:if>
	</div>
</div>


