<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*" %>
<style>
	.bookmark:hover{
		cursor:pointer
	}
</style>
<script src="resources/js/jquery-1.12.4.min.js"></script>
<script src="resources/js/highcharts.js"></script>
<%
	String code = request.getParameter("code");

	boolean isInterested = false;
	MemberBean loginMember = null;
	
	boolean isLogin = (boolean)request.getAttribute("isLogin");
	
	if(session.getAttribute("loginMember") !=null){
		loginMember = (MemberBean)request.getAttribute("loginMember");
		isInterested = (boolean)request.getAttribute("isInterested");
	}
	
	
	System.out.println("isInterestd : "+isInterested);
	pageContext.setAttribute("isLogin",isLogin);
%>
<script>
	function buy(){
	
		<% if(isLogin == false){%>
			var idCheck = confirm("매입 하려면 로그인 해야 합니다.\n로그인 하시겠습니까?");
			if(idCheck){
				window.location.href("loginForm");
			}else{
				return false;
			}
		<%}else{%>
			
	
			var check = confirm("매입 하시겠습니까?");
			if(check){
				window.location.href('stockBuy?code=<%=code%>');
			}else{
				return false;
			}	
		<%}%>
		
	}
</script>

<style>
	#myStockInfo{
		font-weight:100;
	}
</style>


<ul  style="list-style:none;">
	<li style="margin-bottom:20px;padding-top:29px;"><span style="font-size:30px;padding-left:20px;">STOCK INFO</span></li>
</ul>
<div id="myStockInfo">
	<div style="margin-top:30px;">
		
		
		<%
			if(isInterested == true){
				%>
					<button class="bookmark" data-role="none" onclick="bookmark()" style="float:right;border:none;margin-bottom:15px;background:#f9f9f9;" ><img src="resources/img/bookmark-on.png" width="20" height="20"/></button>
					<script>
				
					function bookmark(){
						var isLogin = ${isLogin};
						
						var check = confirm("북마크를 취소 하시겠습니까?");
						if(check){
							window.location.href('deleteBookmarkProcess?code=<%=code%>');
						}else{
							return false;
						}
				
					}
					
					</script>
					
				<%
			}else{
				%>
				<button class="bookmark" data-role="none" onclick="bookmark()" style="float:right;border:none;margin-bottom:15px;background:#f9f9f9;"><img src="resources/img/bookmark-off.png" width="20" height="20"/></button>
				
				<script>
				
				function bookmark(){
				
					<% if(isLogin == false){%>
						var idCheck = confirm("북마크 하려면 로그인 해야 합니다.\n로그인 하시겠습니까?");
						if(idCheck){
							window.location.href("loginForm");
						}else{
							return false;
						}
					<%}else{%>
						
				
						var check = confirm("북마크를 하시겠습니까?");
						if(check){
							window.location.href('bookmarkProcess?code=<%=code%>');
						}else{
							return false;
						}	
					<%}%>
			
				}
				
				
				</script>
				<%
				
			}
		%>
			<div><p style="font-size:30px;">${sName }<span style="color:#333333;">&nbsp;&nbsp;&nbsp;(${sCode })</span></p></div>
			
			<div>
				<div style="padding-left:0px;">
					<p style="font-size:26px;"><fmt:formatNumber value="${sPrice }" type="currency"/></p>
				</div>
				<div style="text-align:right;padding-right:0px;"> 
					<fmt:formatDate value="${sTime }" pattern="yyyy-MM-dd" /> 
					<%
						boolean isOpen = (boolean)request.getServletContext().getAttribute("isOpen");
					%> 
					<%=isOpen?"개장":"마감" %>
				</div>
				
			</div>
			
			<br/>
			<div class="ui-body ui-body-a">
			<div id="container" style="border:1px solid #ededed;width: 80%; height: 200px; margin: 0 auto"></div>
				<script>
				$(function () {
					var name = "${sName}";
					
				
					var times = ${times};
					
					var prices= ${prices};
					
					var min = ${min};
					var max = ${max};
					var interval = ${interval};
					
				    $('#container').highcharts({
				    	
				        chart: {
				            type: 'areaspline'
				        },
				        title: {
				            text: ''
				        },
				        xAxis: {
				            categories: times
				            	/* [		                         		  
								'09:00','09:30' ,'10:00','10:30' ,
								'11:00','11:30' ,'12:00','12:30' ,
								'13:00','13:30','14:00','14:30','15:00'
				            ] */
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
			</div>
			<br/>
			<div class="ui-body ui-body-a" style="text-align:center;padding:15px;">
			<%
				if(isOpen){
			%>
				장이 열려있습니다. 
				<%
					if(isLogin==true){
				%>
				<a href="stockBuy?code=<%=code%>" class="btn btn-info" onclick="return buy()" >매입</a>
				<%
					}else{
				%>
				<a href="loginForm" onclick="return buy()">매입</a>
				<%
					}
				%>
				
			<%
				}else{	
			%>	
			<%-- 	<a href="mStockBuy.do?code=<%=code%>" onclick="return buy()" rel="external" class="ui-btn">매입</a> --%>
				장이 마감 되었습니다.
			<%
				}
			%>
			</div>		
		
		</div>
		<c:if test="${not empty stockholderData }">
			<div id="stockholder" style="width:50%;float:left;margin-right:10px;">
				<div id="stockholderGraph" style="border:1px solid #ededed;width:100%; height: 280px; margin: 0 auto"></div>
			</div>
			<script>
				$(function(){
					
					$('#stockholderGraph').highcharts({
			            chart: {
			                plotBackgroundColor: null,
			                plotBorderWidth: null,
			                plotShadow: false,
			                type: 'pie'
			            },
			            title: {
			                text: '지분'
			            },
			            tooltip: {
			                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
			            },
			            plotOptions: {
			                pie: {
			                    allowPointSelect: true,
			                    cursor: 'pointer',
			                    dataLabels: {
			                        enabled: false
			                    },
			                    showInLegend: true
			                }
			            },
			            series: [{
			                name: '소유량',
			                colorByPoint: true,
			                data: ${stockholderData}
			            }]
			        });
					
				})
			</script>
			
			<div id="stockholderListDiv" style="width:40%;float:left;">
				<table class="table" id="stockholderList">
					<tr>
						<td>주주</td>
						<td>소유량</td>
						<td></td>
					</tr>
				</table>
			</div>
			<script>
				$(function(){
					var jsonArray = ${stockholderData};
					


					
					
					$.each(jsonArray,function(index,item){
						var json = item;
						var name = json.name;
						var volume = json.y;
						
						if(name=='기타'){
							$("#stockholderList").append("<tr><td>"+name+"</td><td>"+volume+"주<td/></tr>");
						}else{
							$("#stockholderList").append("<tr><td><a href='userPage?id="+name+"'>"+name+"</a></td><td>"+volume+"주<td/></tr>");
						}
					
					})
				})
			</script>
		</c:if>
		<div style="clear:both;"></div>
	</div>
