<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.bean.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String boardNo = request.getParameter("boardNo");
	if(boardNo == null){
		boardNo = "1";
		response.sendRedirect("community?boardNo=1&pageNo=1");
	}
	
	if(request.getParameter("pageNo")==null){
		response.sendRedirect("community?boardNo=1&pageNo=1");
	}
	String pageNo = request.getParameter("pageNo");
	MemberBean loginMember = (MemberBean)session.getAttribute("loginMember");
	ArticleBean article = (ArticleBean)request.getAttribute("article");
	boolean isLogin = false;
	if(loginMember != null){
		isLogin = true;
	}
%>
 -->
 <style>	
	#nav ul{
		display:block;
		margin:0px;
		padding:0px;
	}
	#nav li{
		float:left;
		list-style:none;
		border:1px solid black;
		display:block;
		box-sizing:border-box;
		width:25%;
		text-align:center;
		background:#373737;
		padding:7px;
	}
	
	#nav a{
		color:white;
		text-decoration:none;
	}
	
	.active{
		background:#22AADD !important;
	}
	
	#detailDiv{
		padding-top:10px;
		min-width:721px;
		width:60%;
		height:95%;
	}
	
	#detailBodyDiv{
		border-right:1px solid #ededed;
		padding:10px;
		height:100%;
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
</style>
<script>
	$(function(){
		$("#commentDiv").hide();
		var boardNo = <%=Integer.parseInt(boardNo)-1%>;
		var $navbarli = $("#nav li");
		$navbarli.removeClass("active");
		$navbarli.eq(boardNo).addClass("active");
		
		
		var isLogin = <%=isLogin%>
		
		$("#commentBtn").on("click",function(){
			if(!isLogin){
				var i = confirm('로그인 하시겠습니까?');
				if(i){
					window.location.href = 'mLoginForm.do';
				}else{
					return false;
				}
				return false;
			}
			commentToggle();
		})
		
	})
	
	function deleteCheck(){
	var check = confirm('삭제 하시겠습니까?');
	
	return check;
		
	}
	
	function editCheck(){
		var check = confirm('수정 하시겠습니까?');
		
		return check;
	}
	
	function commentToggle(){
		$("#commentDiv textarea").css("min-height","53px");
		$("#commentDiv").slideToggle(1000);
	}
 </script>
		<link href="resources/css/myPageNav.css" rel="stylesheet"/>
		<div id="myPageNav">
			<div id="myPageNavInside">
				<ul>
						<li class="story"><a href="community?boardNo=1&pageNo=1">이야기</a></li>
						<li class="question"><a href="community?boardNo=2&pageNo=1" >Q&A</a></li>
						<li class="column"><a href="community?boardNo=3&pageNo=1">컬럼</a></li>
						<li class="news"><a href="community?boardNo=4&pageNo=1">소식</a></li>
				</ul>
			</div>
		</div>
		<div style="clear:both;"></div>
<div id="detailDiv" style="min-width:721px !important;width:60% !important;">
	<div id="detailBodyDiv">
		
		<div id="btn1">
			<a href="community?boardNo=<%=boardNo %>&pageNo=<%=pageNo %>" >list</a>
			<c:if test="${not empty loginMember }">				
				 	<%
				 		if(loginMember.getId().equals(article.getWriter())){//로그인이 된 회원이고 글쓴이와 작성자가 일치하면 보여줌 			
				
				 	%>		
				 	
				 				<a href="delete?boardNo=<%=boardNo%>&pageNo=<%=pageNo%>&no=${article.no}" onclick="return deleteCheck()">delete</a>
								<a href="editForm?boardNo=<%=boardNo%>&pageNo=<%=pageNo%>&no=${article.no}" onclick="return editCheck()">modify</a>
							
					<%
				 		}
					%>		
				</c:if>
		</div>
		<div style="margin-top:50px;">
			<table style="width:100%;">				
				<tr style="margin-bottom:10px;">
					<td style="padding-top:10px;padding-bottom:10px;font-weight:bold;border-bottom:1px solid #DDDDDD"><h3>${article.title }</h3></td>
				</tr>
				<tr>
					<td style="padding-top:10px;padding-bottom:10px;">
						<table>
							<tr>
								<td style="padding-right:10px;border-right:1px solid #DDDDDD;">${article.nickname }</td>
								<td style="float:right;padding-left:10px;"><fmt:formatDate pattern="yyyy-MM-dd aa hh:mm" value="${article.day}"/></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td style="padding-top:15px;min-height:100px;border-top:1px solid #DDDDDD;">${article.content }</td>
				</tr>
			</table>
		</div>
		
		
		
	
		<div style="padding:20px;">
		
			<div style="margin-top:30px;" id="btn2" align="right">
				<a  id="commentBtn">댓글 작성</a>
			</div>
			
				
			 <c:if test="${not empty loginMember }">		
					<form action="mComment.do" method="post" data-ajax="false">
						<div id="commentDiv" class="ui-body ui-body-a" style="margin-bottom:20px;margin-top:10px;">
							<button type="submit" data-role="button" data-iconpos="notext" data-icon="check" class="ui-btn-right"></button>
							<h5 style="margin-top:13px; margin-bottom:10px;">댓글</h5>
							<input type="hidden" name="boardNo" value="${article.boardNo }"/>
							<input type="hidden" name="pageNo" value="<%=pageNo%>"/>
							<input type="hidden" name="no" value="${article.no}"/>
							<input type="hidden" name="ref" value="${article.ref}"/>
							<input type="hidden" name="writer" value="${loginMember.id}"/>
							<input type="hidden" name="nickname" value="${loginMember.nickname}"/>
							<textarea name="commentContent" style="min-height:53px !important;" placeholder="댓글을 입력해 주세요."></textarea>
						</div>
					</form>
			</c:if>
			<div>
			
			<c:if test="${empty cList }">
				<table style="width:100%;">				
					<tr>
						<td style="border-top:1px solid #ededed;padding-top:10px;">댓글이 존재하지 않습니다.</td>
					</tr>
				</table>
		
			</c:if>
		
		
			<c:if test="${not empty cList }">	
				<c:forEach var="c" items="${cList }">
						<div style="border-top:1px solid #ededed;">
						<table style="width:100%;">				
							<tr>
								<td style="padding-top:10px;padding-bottom:10px;">
									<table>
										<tr>
											<td style="padding-right:10px;border-right:1px solid #DDDDDD;">${c.nickname }</td>
											<td style="float:right;padding-left:10px;"><fmt:formatDate pattern="yyyy-MM-dd aa hh:mm" value="${c.day}"/></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td style="padding-top:15px;min-height:60px;padding-bottom:15px;border-top:1px solid #DDDDDD;">${c.content }</td>
							</tr>
						</table>
						</div>
				</c:forEach>
			</c:if>
			
			</div>
		</div>
</div>
</div>
