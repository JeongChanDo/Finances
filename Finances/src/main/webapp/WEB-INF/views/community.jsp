<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.dao.*,java.sql.*,com.dos.finances.bean.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	int boardNo = (int)request.getAttribute("boardNo");
	int pageNo = (int)request.getAttribute("pageNo");

	int numberOfArticle = (int)request.getAttribute("numberOfArticle");
	int numberOfPage = (int)request.getAttribute("numberOfPage");
	int numberOfPageGroup = (int)request.getAttribute("numberOfPageGroup");
	
	int startPage = (int)request.getAttribute("startPage");
	int endPage = (int)request.getAttribute("endPage");
	int currentPageGroup = (int)request.getAttribute("currentPageGroup");
	int pageGroup = (int)request.getAttribute("pageGroup");
	
	Timestamp today = new Timestamp(System.currentTimeMillis());
%>

		
<style>


	#communityDiv a{
		color:black;
		text-decoration:none;
	}

	 
	 ul{
	 	list-style:none;
	 }
	 
	 #pagination li{
		float:left;
		padding:5px;
	}
	
	#pageActive{
		font-size:20px;
	}
	
	#communityList li{
		margin-bottom:10px;
	}
	
	#communityList a{
	
		display:inline-block;
		width:100%;
	}
	
	#communityList a:hover{
		background:#f6f6f6;
	}
	
	#communityListBody{
	    margin-top: 50px;
	    min-height:716px;
	}

	#btn1 a{
		float:right;
		color:black;
		text-decoration:none;
	}
	
	#btn1 a:hover{
		color:blue;
	}
	
	#btn1 a:active{
		color:red;
	}
	
	#pagination li{
		float:left;
		padding:5px;
	}
	
	#pageActive{
		font-size:20px;
	}
	
	@media all and (min-width:900px){
		
		#communityDiv {
			min-width:700px;
			width:60%;
	
		    padding: 10px;
		    margin-top: 10px;
		    height: 90%;
		    border-right: 1px solid #ededed;
		}
	}
	
	
	
</style>
<div style="clear:both;"></div>


<div id="communityDiv" >
<script>
	$(function(){
		var boardNo = <%=boardNo-1%>;
		var $navbarli = $("#nav li");
		$navbarli.removeClass("active");
		$navbarli.eq(boardNo).addClass("active");
	})
</script>
	
	<div style="height:39px;padding:0px;" id="btn1">
		<c:if test="${not empty loginMember }">
			<a href="writeForm?boardNo=<%=boardNo%>" >쓰기</a>
		</c:if>
		<c:if test="${empty loginMember }">
			<a href="loginForm"  onclick="return loginCheck()">쓰기</a>
			<script>
				function loginCheck(){
					var check = confirm('글 작성하려면 로그인 해야 합니다.\n로그인 하시겠습니까?');
					return check;
				}
			</script>
		</c:if>
	</div>
	
	<div id="communityListBody">
		<ul id="communityList">
		<c:if test="${empty aList}">
			<li> 게시글이 존재하지 않습니다.</li>
		</c:if>
		
		<c:if test="${not empty aList }">
			<c:forEach var="a" items="${aList }">
			
			
				<li><a href="detail?boardNo=<%=boardNo%>&pageNo=<%=pageNo%>&no=${a.no}" >
					<p style="font-size:30px;margin:6px 0px;">${a.title }</p>
				
					<small>${a.nickname }&nbsp;&nbsp;&nbsp;
				
					
					<%
						ArticleBean a = (ArticleBean)pageContext.getAttribute("a");
						String aDate = a.getDay().toString().substring(0,10);
	
						if(today.toString().substring(0,10).equals(aDate)){
							%>
								<fmt:formatDate value="${a.day }" pattern="aa hh:mm"/>
							<%
						}else{
							
							%>
							<fmt:formatDate value="${a.day }" pattern="yyyy-MM-dd"/>
							<%
						}
					%>
					
					</small>
				</a></li>
			</c:forEach>
		</c:if>
		</ul>
		<div style="clear:both;"></div>
	</div>
	
	<ul id="pagination">
		
		<%
			if(currentPageGroup != 1){
				%>
				<li><a href="community?boardNo=<%=boardNo%>&pageNo=<%=startPage-1%>">«</a></li>
				<%
			}
		
			for(int i = startPage;i <= endPage;i++){
				if(i==pageNo){
					%>
					<li><a href="community?boardNo=<%=boardNo%>&pageNo=<%=i%>"  id="pageActive"><%=i %></a></li>
					<%
				}else{
					
				%>
				<li><a href="community?boardNo=<%=boardNo%>&pageNo=<%=i%>" ><%=i %></a></li>
				<%
				}
			}
		
			if(numberOfPage>currentPageGroup*pageGroup){
				%>
				<li><a href="community?boardNo=<%=boardNo%>&pageNo=<%=endPage+1%>" >»</a></li>
				<%
			}
		%>
			
	</ul>
</div>