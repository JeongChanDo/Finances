<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.bean.*" %>
<c:if test="${not empty loginMember }">
	<c:if test="${uncheckedMessageCount != 0 }">
	
<style>
	#uncheckedMessageCount{
	    margin-right: 20px;
	    border: 2px solid white;
	    border-radius: 3px;
	    font-size: 15px;
	}
	
	#messageAlarm{
		position:absolute;
		display:inline-block;
		top:35px;
		left:-152px;
		color:white;
		background:#222222;
		padding:10px;
		width:240px;
	}
</style>
<script>
	$(function(){
		$("#uncheckedMessageCount").on("mouseenter",function(){
			$("#messageAlarm").show();
			
		})
		
		$("#uncheckedMessageCount").on("mouseleave",function(){
			$("#messageAlarm").hide();
			
		})
		
	})
</script>

	</c:if>
</c:if>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#sidebar-collapse">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="index">Finance</a>
				<ul class="user-menu">
					<li class="dropdown pull-right">
						<c:if test="${empty loginMember }">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown"><svg class="glyph stroked male-user"><use xlink:href="#stroked-male-user"></use></svg> User <span class="caret"></span></a>
							<ul class="dropdown-menu" role="menu">
								<li><a href="loginForm">Login</a></li>
								<li><a href="signInForm">Sign in</a></li>
							</ul>
						</c:if>
						<c:if test="${not empty loginMember }">
							<c:if test="${uncheckedMessageCount != 0 }">
								<a id="uncheckedMessageCount" href="message">${uncheckedMessageCount}</a>
								<span id="messageAlarm" style="display:none;">읽지 않은 메시지가 존재합니다.</span>
							</c:if>
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">${loginMember.id }<span class="caret"></span></a>
							<ul class="dropdown-menu" role="menu">
								<li><a href="myPage">MyPage</a></li>
								<li><a href="message">Message</a></li>
								<li><a href="logout">Logout</a></li>
							</ul>
						</c:if>
					</li>
				</ul>
			</div>
							
		</div><!-- /.container-fluid -->
	</nav>

	
	
	
	<div id="sidebar-collapse" class="col-sm-3 col-lg-2 sidebar">
		<form role="search">
			<div class="form-group">
				<input type="text" class="form-control" placeholder="Search">
			</div>
		</form>
		<ul class="nav menu">
			<li id="indexLi"><a href="index">HOME</a></li>
			<li id="newsLi"><a href="news">NEWS</a></li>
			<li id="stockLi"><a href="stock">STOCK</a></li>
			<li id="communityLi" class="parent">
		 		<a href="#">
					<span data-toggle="collapse" href="#sub-item-1">COMMUNITY</span>
				</a>
				<ul class="children collapse" id="sub-item-1">
					<li>
						<a class="" href="community?boardNo=1&pageNo=1">
							이야기
						</a>
					</li>
					<li>
						<a class="" href="community?boardNo=2&pageNo=1">
							Q&A
						</a>
					</li>
					<li>
						<a class="" href="community?boardNo=3&pageNo=1">
							칼럼
						</a>
					</li>
					<li>
						<a class="" href="community?boardNo=4&pageNo=1">
							소식
						</a>
					</li>
				</ul>
			</li>			
			
			<li role="presentation" class="divider"></li>
			<c:if test="${not empty loginMember }">
				<li id="myPageLi" class="parent">
					<a href="#">
						<span data-toggle="collapse" href="#sub-item-2">MY PAGE</span>
					</a>
					<ul class="children collapse" id="sub-item-2">
						<li>
							<a class="" href="myPage">
								유저정보
							</a>
						</li>
						<li>
							<a class="" href="myStock">
								보유주식
							</a>
						</li>
						<li>
							<a class="" href="record">
								내역
							</a>
						</li>
						<li>
							<a class="" href="interest">
								관심주
							</a>
						</li>
						<li>
							<a href="message">메시지</a>
						</li>
						<li>
							<a href="friend">친구목록</a>
						</li>
					</ul>	
				
				</li>			
			
			</c:if>

		</ul>

	</div><!--/.sidebar-->