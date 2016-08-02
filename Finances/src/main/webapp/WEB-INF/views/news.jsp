<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	int pageNo;
	if(request.getParameter("pageNo")==null){
		pageNo = 1;
	}else{
		pageNo = Integer.parseInt(request.getParameter("pageNo"));

	}
	
	String keyword = null;
	if(request.getParameter("keyword")!=null){
		
		keyword = request.getParameter("keyword");
	}

	
	
	int numOfNews = (int)request.getAttribute("numOfNews");
	int numOfPage = (int)request.getAttribute("numOfPage");
	int numOfPageGroup = (int)request.getAttribute("numOfPageGroup");
	int currentPageGroup = (int)request.getAttribute("currentPageGroup");
	int pageGroup = (int)request.getAttribute("pageGroup");
	int startPage = (int)request.getAttribute("startPage");
	int endPage = (int)request.getAttribute("endPage");
	/* 
	System.out.println("");
	System.out.println("numOfNews : " +numOfNews);
	System.out.println("numOfPage : " + numOfPage);
	System.out.println("numOfPageGroup : " + numOfPageGroup);
	System.out.println("currentPageGroup : " + currentPageGroup);
	System.out.println("pageGroup : " + pageGroup);
	System.out.println("startPage : " + startPage);
	System.out.println("endPage : " + endPage);
	 */
%>
<style>
	#searchDiv{
		width: 250px;
    	padding: 10px 5px;
    	float:right;
	}
	
	#search{
    	width: 100%;
    	border: none;
    	color: #a6a6a6;
	}
	
	#newsDiv a{
		color:black;
		text-decoration:none;
	}
	
	#newsDiv ul{
		list-style:none;
	}
	
	
	.title{
		font-weight:bold;
	}
	
</style>
	<div id="newsDiv" style="padding:10px;">
			<ul >
				<li style="margin-bottom:50px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">NEWS</span></li>
			</ul>
		<div id="newsList">
			<c:forEach var="n" items="${nList }">
				<a href="${n.link }" style="display:block" >
					<table style="margin-bottom:5px;">
						<tr>
							<td><p class="title">${n.title }</p></td>
						</tr>
						<tr>
							<td><p>${n.content } ...</p></td>
						</tr>
						<tr>
							<td><p><i>${n.day }</i></p></td>
						</tr>
					</table>
				</a>
			
			</c:forEach>
		
		
		<style>
			#pagination li{
				float:left;
				padding:5px;
			}
			
			#pageActive{
				font-size:20px;
			}
		</style>
			<ul id="pagination">
			
			<%
				if(keyword ==null){
					
					if(currentPageGroup != 1){
						%>
						<li><a href="news?pageNo=<%=startPage-5%>" >←</a></li>
						<%
					}
				
					for(int i = startPage;i <= endPage;i++){
						if(i==pageNo){
							%>
							<li><a href="news?pageNo=<%=i%>" id="pageActive"><%=i %></a></li>
							<%
						}else{
							
						%>
						<li><a href="news?pageNo=<%=i%>" ><%=i %></a></li>
						<%
						}
					}
				
					if(numOfPage>currentPageGroup*pageGroup){
						%>
						<li><a href="news?pageNo=<%=endPage+1%>">→</a></li>
						<%
					}
				}else{
					
					if(currentPageGroup != 1){
						%>
						<li><a href="newsSearch?pageNo=<%=startPage-5%>&keyword=<%=keyword %>" >←</a></li>
						<%
					}
				
					for(int i = startPage;i <= endPage;i++){
						if(i==pageNo){
							%>
							<li><a href="newsSearch?pageNo=<%=i%>&keyword=<%=keyword %>" class="active"><%=i %></a></li>
							<%
						}else{
							
						%>
						<li><a href="newsSearch?pageNo=<%=i%>&keyword=<%=keyword %>" ><%=i %></a></li>
						<%
						}
					}
				
					if(numOfPage>currentPageGroup*pageGroup){
						%>
						<li><a href="news?pageNo=<%=endPage+1%>&keyword=<%=keyword %>" >→</a></li>
						<%
					}
					
				}
			%>
				
			</ul> 
					<br/>
			
			<div id="searchDiv" >
				<form action="newsSearch" onsubmit="return searchCheck()" style="margin:0px;" >
					<input id="search" name="keyword" type="text" placeholder="검색" style="margin-top:20px;margin-bottom:10px;font-size:20px;padding:5px;padding-left:10px; margin-bottom:60px;"/>
				</form>
				<script>
					function searchCheck(){
						if($("#search").val() == 0){
							alert("검색어를 입력해 주세요.");
							return false;
						}else{
							return true;
						}
						
					}
				</script>
			</div>
		</div>
	</div>