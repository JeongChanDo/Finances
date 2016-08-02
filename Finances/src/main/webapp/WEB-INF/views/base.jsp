<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html">
<html style="background:#f9f9f9;">
<head>
<meta http-equiv="X-UA-compatible" content="IE=Edge,chrome=1">
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="resources/js/jquery-1.12.4.min.js"></script>
<%

	String queryString = request.getQueryString();
	int start = queryString.indexOf("=")+1;
	int end = 0;
	if(queryString.contains("/")){
		end = queryString.indexOf("/");
	}else{
		end = queryString.indexOf(".");
	}

	queryString = queryString.substring(start,end);
	
	System.out.println("query : " +queryString);
	pageContext.setAttribute("uri", queryString);
%>


<link href="resources/lumino/css/bootstrap.min.css" rel="stylesheet">
<link href="resources/lumino/css/datepicker3.css" rel="stylesheet">
<link href="resources/lumino/css/styles.css" rel="stylesheet">

</head>
<body>
	<div id="headerAndSidebar">
		<%@include file="/resources/template/headerAndSidebar.jsp" %>
	</div>


	
	
	<div class="col-sm-9 col-sm-offset-3 col-lg-10 col-lg-offset-2 main">			
	
		<%-- 	<jsp:include page="/resources/template/nav.jsp"/> --%>
		<div class="bodyIncludeDiv">
			<jsp:include page="${param.body }"/>
		</div>
			
		
	</div>	<!--/.main-->
	
	

	<script src="resources/lumino/js/bootstrap.min.js"></script>
	<script src="resources/lumino/js/bootstrap-datepicker.js"></script>
	
	<script>
		$(function(){
			$("li").removeClass("active");
			var uri = "${uri}";
			var id = "#indexLi";
			
			if(uri=="news"){
				id="#newsLi";
			}else if(uri== "community"){
				id="#communityLi";
			}else if(uri == "myPage"){
				id="#myPageLi";
				$("#sub-item-2").addClass("in");

				
			}else if(uri =="stock"){
				id="#stockLi";
			}
			$(id).addClass("active");
			
		})
	</script>
</body>
</html>