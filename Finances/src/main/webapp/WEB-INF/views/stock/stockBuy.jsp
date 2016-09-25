<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*" %>
<script src="resources/js/jquery-1.12.4.min.js"></script>
<script src="resources/js/jquery.number.min.js"></script>
<script src="resources/js/numbertokorean.js"></script>

<%
	StockBean2 stock = (StockBean2)request.getAttribute("stock");
	MemberBean member = (MemberBean)session.getAttribute("loginMember");
	
	//기존 코드
	//boolean isOpen = (boolean)application.getAttribute("isOpen");
	
	
	//잠시 오픈용
	boolean isOpen = true;

	if(!isOpen){
%>
	<script>
	
	$(function(){
		alert("장이 마감되었습니다.");
		window.location.href('index');
	})
	
	</script>
<%
	}
%>
<div data-role="content">
	<div class="ui-bar ui-bar-a"><h2>${stock.name }<span style="color:#333333;">&nbsp;&nbsp;&nbsp;(${stock.code })</span></h2></div>
	<div class="ui-body ui-body-a">
		<div class="ui-bar" style="padding-left:0px;"><h2>
			<fmt:formatNumber value="${stock.price }" type="currency"/></h2>
		</div>
		<div class="ui-bar" style="text-align:right;padding-right:0px;"> 
			<fmt:formatDate value="${stock.time }" pattern="yyyy-MM-dd" /> 
		
			<%=isOpen?"개장":"마감" %>
		</div>
	</div>
	<br/>
	<form action="stockBuyProcess" method="post">
		<input type="hidden" name="code" value="${stock.code}"/>
		<input type="hidden" name="name" value="${stock.name}"/>
	<table class="table">
		<tr>
			<td>
				<label for="money">보유 현금</label>
			</td>
			<td>
				<span style="min-height:2.2em;display:inline-block;line-height:2.2em;"><fmt:formatNumber type="currency" value="${loginMember.money}"/>원</span>
			</td>
		</tr>
		<tr>
			<td>
				<label for="volume">매입량</label>
			</td>
			<td>
				<input type="number" id="volume" class="form-control" value="0" name="volume" />
			</td>
		</tr>
		<tr>
			<td style="text-align:right;" colspan="2">
				<span id="here3" style="font-weight:bold;font-size:1.1em;"></span>
			</td>
		</tr>
		<tr>
			<td>
				<label for="totalPrice">가격</label>
			</td>
			<td>
				<span id="totalPrice" style="min-height:2.2em;display:inline-block;line-height:2.2em;"><span id="here">0</span>원</span><br/>
			</td>
		</tr>
		<tr>
			<td style="text-align:right;" colspan="2">
				<span id="here2" style="font-weight:bold;font-size:1.1em;"></span>
			</td>
		</tr>
		<tr>
			<td>
				<label for="balance">잔액</label>
			</td>
			<td>
				<span id="balance" style="min-height:2.2em;display:inline-block;line-height:2.2em;"><span id="here5">0</span>원</span><br/>
			</td>
		</tr>
		<tr>
			<td style="text-align:right;" colspan="2">
				<span id="here4" style="font-weight:bold;font-size:1.1em;"></span>
			</td>
		</tr>
	</table>
		
		
	<script>
			$(function(){
				var price = ${stock.price};
				
				$("#volume").on("keyup",function(){
					var num = $(this).val()*price;
					$("#here").text($.number(num));	
					
					$("#here2").text(viewKorean(""+num)+"원");
					$("#here3").text(viewKorean(""+$(this).val())+"주");
					
					var balance = ${loginMember.money}-num;
					
					if(balance <0){
						alert("현금이 부족합니다.");
						location.reload();
					}else{
					$("#here4").text(viewKorean(""+balance)+"원");
					
					$("#here5").text($.number(balance));
					}
				})
			})
			
			function check(){
				var ask = confirm("매입 하시겠습니까?");
				if(!ask){//매입안하면..
					return false;
				}
				
				if($("#volume").val()==0){
					alert("매입량을 입력해 주세요.");
					return false;
				}
				
				
			}
			
		</script>
	<button type="submit" class="form-control" onclick="return check()">매입</button>
	</form>
</div>