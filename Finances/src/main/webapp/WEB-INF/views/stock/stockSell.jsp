<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="com.dos.finances.dao.*,com.dos.finances.bean.*" %>
<script src="resources/js/jquery.number.min.js"></script>
<script src="resources/js/numbertokorean.js"></script>
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
	}
	
	#list td{
		text-align:center;
	}
</style>
<%
	//파라미터 체크
	if(request.getParameter("id")==null||request.getParameter("code")==null
		||request.getParameter("time")==null ){
		
		%>
		<script>
			alert('잘못된 접근 입니다.');
			window.location.href('index');
		</script>
		<%
		
	}

	if(session.getAttribute("loginMember")==null){
		%>
		<script>
			alert('로그인 상태가 아닙니다.');
			window.location.href('index');
		</script>
		<%
	}
	if(session.getAttribute("loginMember")!=null&&!(((MemberBean)session.getAttribute("loginMember")).getId().equals(request.getParameter("id")))){
		System.out.println(((MemberBean)session.getAttribute("loginMember")).getId()+"\n"+request.getParameter("id"));
		%>
		<script>
			alert('해당 회원이 아닙니다.');
			window.location.href('index');
		</script>
		<%
	}
	
	StockDao dao = (StockDao)request.getAttribute("dao");
	String id = request.getParameter("id");
	String code = request.getParameter("code");
	String time = request.getParameter("time");
	BuyStockBean b = dao.getBuyStockBean(code, id, time);
	pageContext.setAttribute("b",b);
	
	//없는 데이터인지 체크
	if(b == null){
		%>
		alert('데이터가 존재하지 않습니다.');
		<%
		response.sendRedirect("index");
	}
	
	StockBean2 stock = (StockBean2)request.getAttribute("stock");
	MemberBean member = (MemberBean)session.getAttribute("loginMember");
	
	boolean isOpen = (boolean)application.getAttribute("isOpen");
	if(!isOpen){
%>
	<script>
	/* 
	$(function(){
		alert("장이 마감되었습니다.");
		window.location.href('mStock.do');
	})
	 */
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
	
	<div class="ui-body ui-body-a">
	<table id="list">
		<tr>
			<th>시간</th>
			<th>이름</th>
			<th>매수가<br/>/현재가</th>
			<th>수량</th>
			<th>차익</th>
		</tr>
		<tr>
			<td>
				<%		
					int profit = b.getCurrentPrice()-b.getPrice();
					pageContext.setAttribute("profit",profit);
				%>
				<%=time %>
			</td>
			<td>
				${b.name}
				<span style="display:none;">${b.code }</span>
			</td>
			<td>
				<fmt:formatNumber value="${b.price }" type="number"/><br/>/<fmt:formatNumber value="${b.currentPrice}" type="number"/>
			</td>

			<td>
				<fmt:formatNumber value="${b.volume}" type="number"/>
			</td>
		
			<td>
				<c:if test="${profit > 0}">
					<span style="color:green;"><img src="img/sUp.png" width="10" height="10" /><fmt:formatNumber value="${profit}" type="number"/></span>
				</c:if>
				<c:if test="${profit == 0}">
					<span>0</span>
				</c:if>
				<c:if test="${profit < 0}">
					<span style="color:red;"><img src="img/sDown.png" width="10" height="10"/><fmt:formatNumber value="${-profit}" type="number"/></span>
				</c:if>
			</td>
		</tr>
	</table>
	</div>
	<br/>
	<form action="stockSellProcess"  method="post">
		<input type="hidden" name="code" value="${b.code }"/>
		<input type="hidden" name="id" value="${b.id }"/>
		<input type="hidden" name="time" value="${b.time}"/>
		
	<div class="ui-body ui-body-a">
		<div class="ui-field-contain">
			<label for="money">보유현금</label>
			<span style="min-height:2.2em;display:inline-block;line-height:2.2em;"><fmt:formatNumber type="currency" value="${loginMember.money}"/>원</span>
			
		</div>
		<div class="ui-field-contain">
			<label for="volume">보유량</label>
			<span style="min-height:2.2em;display:inline-block;line-height:2.2em;">${b.volume} 주</span>
			
		</div>
		<div class="ui-field-contain">
			<label for="volume">매도량</label>
			<input type="number" id="volume" value="0" name="volume" />
		</div>
		<div class="ui-field-contain" style="text-align:right;">
			<span id="here3" style="font-weight:bold;font-size:1.1em;"></span>
		</div>
		<script>
			$(function(){
				var price = ${stock.price};
				
				$("#volume").on("blur",function(){
					var max = ${b.volume};
					var input = $(this).val();
					var num = $(this).val()*price;
					$("#here").text($.number(num));	
					
					$("#here2").text(viewKorean(""+num)+"원");
					$("#here3").text(viewKorean(""+$(this).val())+"주");
					
					var balance = ${loginMember.money}+num;
					
					if(max < input){
						alert("보유량을 초과하였습니다.");
						location.reload();
					}else{
					$("#here4").text(viewKorean(""+balance)+"원");
					
					$("#here5").text($.number(balance));
					}
				})
			})
			
			function check(){
				var ask = confirm("매도 하시겠습니까?");
				if(!ask){//매입안하면..
					return false;
				}
				
				if($("#volume").val()==0){
					alert("매도량을 입력해 주세요.");
					return false;
				}
				
				
			}
			
		</script>
		<div class="ui-field-contain">
			<label for="totalPrice">금액</label>
			<span id="totalPrice" style="min-height:2.2em;display:inline-block;line-height:2.2em;"><span id="here">0</span>원</span><br/>
		</div>
		<div class="ui-field-contain" style="text-align:right;min-height:1.9em">
			<span id="here2" style="font-weight:bold;font-size:1.1em;"></span>
		</div>
		<div class="ui-field-contain">
			<label for="balance">잔액</label>
			<span id="balance" style="min-height:2.2em;display:inline-block;line-height:2.2em;"><span id="here5">0</span>원</span><br/>
		</div>
		<div class="ui-field-contain" style="text-align:right;min-height:1.9em">
			<span id="here4" style="font-weight:bold;font-size:1.1em;"></span>
		</div>
	</div>
	<button type="submit" onclick="return check()">매도</button>
	</form>
</div>