<%@page import="org.apache.catalina.core.ApplicationContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<style>
		.bookmark:hover{
			cursor:pointer
		}
		
		.ajax_div{
			width:80%;
			margin:0px auto;
		}
</style>

<%@ page import="com.dos.finances.dao.*,java.util.*,com.dos.finances.bean.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String code = (String)request.getParameter("code");


	
	StockBean2 stock = (StockBean2)request.getAttribute("stockBean2");
	
	request.setAttribute("sTime",stock.getTime());
	request.setAttribute("sCode",stock.getCode());
	request.setAttribute("sName",stock.getName());
	request.setAttribute("sPrice",stock.getPrice());
	
	boolean isOpen = (boolean)request.getServletContext().getAttribute("isOpen");
	//개장이 아니면 최근 하루간 정보들을 가져온다.
	
	List<String> datas = null;
	
	datas = (List<String>)request.getAttribute("datas");
	
	//request.setAttribute("datas",datas);
	
	String times = datas.get(0);
	String prices = datas.get(1);
	String min = datas.get(2);
	String max = datas.get(3);
	String interval =datas.get(4);
	
	pageContext.setAttribute("times",times);
	pageContext.setAttribute("prices",prices);
	pageContext.setAttribute("min",min);
	pageContext.setAttribute("max",max);
	pageContext.setAttribute("interval",interval);
	
	List<String> datas2 = (List<String>)request.getAttribute("datas2");
	
	
	String times2 = datas2.get(0);
	String prices2 = datas2.get(1);
	String min2 = datas2.get(2);
	String max2 = datas2.get(3);
	String interval2 =datas2.get(4);
	
	pageContext.setAttribute("times2",times2);
	pageContext.setAttribute("prices2",prices2);
	pageContext.setAttribute("min2",min2);
	pageContext.setAttribute("max2",max2);
	pageContext.setAttribute("interval2",interval2);

%>
<div id="result1" class="ajax_div">
	<br/>
	<div>
	${sName }  (${sCode})
	</div>
	<div style="background:white;">
	<fmt:formatNumber value="${sPrice }" type="currency"/>
	</div>
	<br/>
	<div >
		<a href="#" id="aDay" style="color:black;font-weight:none;">1일</a>
		<a href="#" id="aMonth" style="color:black;font-weight:none;">1개월</a>
	</div>
	<script>
		$(function(){
			
			
			$("#aMonth").on("click",function(){
				$("#container").hide();
				$("#container2").show();
			})
			
			$("#aDay").on("click",function(){
				$("#container2").hide();
				$("#container").show();
			})
		})
		
	</script>
	<div style="background:white;">
		<div id="container" style="width: 100%; height: 200px; margin: 0 auto"></div>
			<script>
				$(function () {
					var name = "${sName}";
					
				
					var times = ${times};
					
					var prices= ${prices};
					
					var min = ${min};
					var max = ${max};
					var interval = ${interval};
					var chart1 = new Highcharts.Chart({
				    	
				        chart: {
				        	renderTo: 'container',
				            type: 'areaspline'
				        },
				        title: {
				            text: ''
				        },
				        xAxis: {
				            categories: times
			
				        },
				        yAxis: {
				            min: min,
				            max: max,
				            gridLineWidth: 0,
				            tickInterval: interval,
				            title: {
				                text: ''
				            }
				        },
				        tooltip: {
				            shared: true,
				            valueSuffix: ' 원'
				        },
				        credits: {
				            enabled: false
				        },
				        plotOptions: {
				            areaspline: {
				                fillOpacity: 0.5
				            }
				        },
				        series: [{
				            name: name,
				            data: prices 
		
				        }]
				    });
					
					
				});
			</script>
			
			
			<div id="container2" style="width: 100%; height: 200px; margin: 0 auto;"></div>
			<script>
				$(function () {
					var name2 = "${sName}";
					
				
					var times2 = ${times2};
					
					var prices2= ${prices2};
					
					var min2 = ${min2};
					var max2 = ${max2};
					var interval2 = ${interval2};
					
					var chart2 = new Highcharts.Chart({
				    	
				        chart: {
				        	renderTo: 'container2',
				            type: 'areaspline'
				        },
				        title: {
				            text: ''
				        },
				        xAxis: {
				            categories: times2
			
				        },
				        yAxis: {
				            min: min2,
				            max: max2,
				            gridLineWidth: 0,
				            tickInterval: interval2,
				            title: {
				                text: ''
				            }
				        },
				        tooltip: {
				            shared: true,
				            valueSuffix: ' 원'
				        },
				        credits: {
				            enabled: false
				        },
				        plotOptions: {
				            areaspline: {
				                fillOpacity: 0.5
				            }
				        },
				        series: [{
				            name: name2,
				            data: prices2
		
				        }]
				    });
				    $('#container2').append(chart2);
				});
			</script>
	</div>
	<br/>
		<%
			if(isOpen){
		%>
			<form data-ajax="false" action='stockSell'>
				<input type="hidden" name="code" value='${sCode}' />
				<input type="hidden" name="id" value="${loginMember.id }"/>
				<input type="hidden" id="time" name="time" />
				
				<input type="submit" data-role="none" class="ui-btn" style="width:100%" value="매도"/>
			</form>		
		<%
			}else{	
		%>	
		
		<div class="ui-body ui-body-a ajax_div" style="text-align:center;padding:15px;">
			
			장이 마감 되었습니다.
		</div>		
		<%
		
			}
		%>
</div>
