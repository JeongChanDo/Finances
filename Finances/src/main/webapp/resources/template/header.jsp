<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	*{
		font-family:'나눔고딕';
		margin:0px;
		padding:0px;
	}
	
	#header{
		width:200px;
		height:100%;
		background:#f9f9f9;
		border-right: 1px solid #dddddd; 
		text-align: center;
	}
	
	#header a{
		color: black;
		text-decoration: none;
		font-size: 35px;
		font-weight:100;
	}
	
	.menu{
		padding:5px;
	}
	.menu_inside{
	/* 		border-top:1px solid #ededed; */
	/* 		border-bottom:1px solid #ededed; */
	}
	
	.menu li{
		height: 60px;
		line-height:60px;
	}
	
	.menu li a{
		width:100%;
		height:100%;
		display:inline-block;
	}
	
	.menu li:hover{
		background:#f2f2f2;
	}
	
	#account li{
		float:left;
		width:50%;
		display:inline-block;
	}
	
	#account li a{
		font-size: 20px;
	/* 	border-top:1px solid #ededed; */
	/* 	border-bottom:1px solid #ededed; */
	}
	
	
</style>
<link href="resources/css/nanumgothic.css" rel="stylesheet">

<div id="header">
	<div style="padding-top:20px;padding-bottom:20px;
		border-bottom:1px solid #ededed;margin-bottom:120px;">
		<a href="index" style="font-size:50px;">
			Finance
		</a>
	</div>
	<div class="menu">
		<div id="account" >
			<%
				if(session.getAttribute("loginMember") == null){
			%>
			<ul>
				<li><a href="loginForm">LOGIN</a></li>
				<li><a href="signInForm">SIGN IN</a></li>	
			</ul>
			<%
				}else{
			%>
			<ul>
				<li style="width:100%;"><a href="logout">LOG OUT</a></li>
	<!-- 			<li><a href="signInForm">SIGN IN</a></li>	 -->
			</ul>	
			<%
				}
			%>
		</div>
	</div>
	
	<div style="clear:both;height:50px;"></div>
	<div class="menu">
		<div class="menu_inside">
			<ul>
				<li><a href="news?pageNo=1">NEWS</a></li>
				<li><a href="stock">STOCK</a></li>
				<li><a href="community?boardNo=1&pageNo=1" style="font-size:25px;">COMMUNITY</a></li>
				<%
					if(session.getAttribute("loginMember") == null){
				%>
				<li><a href="loginForm" onclick="return loginCheck()">MY PAGE</a></li>
				<%
					}else{
				%>
				<li><a href="myPage">MY PAGE</a></li>
				<%
					}
				%>
				<li><a href="http://djc4223.cafe24.com/Finance/mIndex.do">MOBILE</a></li>
			</ul>
		</div>
	</div>
</div>
<script>
	function loginCheck(){
		var check = confirm("로그인 해야합니다.\n로그인 하시겠습니까?");
		return check;
	}
</script>

<div style="clear:both;"></div>
