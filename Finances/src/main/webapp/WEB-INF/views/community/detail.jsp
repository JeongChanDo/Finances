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
	String no = request.getParameter("no");
	MemberBean loginMember = (MemberBean)session.getAttribute("loginMember");
	ArticleBean article = (ArticleBean)request.getAttribute("article");
	boolean isLogin = false;
	if(loginMember != null){
		isLogin = true;
	}
%>

<script src="ckeditor1/ckeditor.js"></script>
<script src="js/mobile/community/mDetail.js"></script>
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
	


	#btn1 a{
		float:right;
		color:black;
		text-decoration:none;
		margin-left:10px;
	}
	
	#btn1 a:hover{
		color:blue;
	}
	
	#btn1 a:active{
		color:red;
	}
	
	#commentBtn:hover,#commentSubmitBtn:hover{
		color:blue;
		cursor:pointer;
	}
	
	#commentBtn:active,#commentSubmitBtn:active{
		color:red;
	}
	
	
	@media all and (min-width:900px){
		#detailDiv{
			min-width:721px;
			width:60%;
			padding-top:10px;
			height:95%;
		}
	}
	
</style>
<script>
	$(function(){
		$("#commentDiv").hide();
		var boardNo = <%=Integer.parseInt(boardNo)-1%>;
		var $navbarli = $("#nav li");
		$navbarli.removeClass("active");
		$navbarli.eq(boardNo).addClass("active");
		
		/* 
		$("#commentSubmitBtn").on("click",function(){
			alert($("#commentContent").text());
			if($("#commentContent").text().length == 0){
				alert("댓글을 입력하세요");
				return false;
			}
			return false;
		})
		*/
		
		var isLogin = <%=isLogin%>
		
		$("#commentBtn").on("click",function(){
			if(!isLogin){
				var i = confirm('로그인 하시겠습니까?');
				if(i){
					window.location.href = 'loginForm';
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
<div id="detailDiv">
	<div id="detailBodyDiv">
		
		<div id="btn1">
			<a href="community?boardNo=<%=boardNo %>&pageNo=<%=pageNo %>" >리스트</a>
			<c:if test="${not empty loginMember }">				
				 	<%
				 		if(loginMember.getId().equals(article.getWriter())){//로그인이 된 회원이고 글쓴이와 작성자가 일치하면 보여줌 			
				
				 	%>		
				 	
				 				<a href="deleteArticle?boardNo=<%=boardNo%>&pageNo=<%=pageNo%>&no=${article.no}" onclick="return deleteCheck()">삭제</a>
								<a href="editForm?boardNo=<%=boardNo%>&pageNo=<%=pageNo%>&no=${article.no}" onclick="return editCheck()">수정</a>
							
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
								<td style="padding-right:10px;border-right:1px solid #DDDDDD;"><a href="userPage?id=${article.writer}">${article.nickname }</a></td>
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
				<form action="commentWrite" method="post" >
					<div id="commentDiv"  style="margin-top:10px;">
						<h5 style="margin-top:13px; margin-bottom:10px;">댓글</h5>
						<input type="hidden" name="boardNo" value="${article.boardNo }"/>
						<input type="hidden" name="pageNo" value="<%=pageNo%>"/>
						<input type="hidden" name="no" value="${article.no}"/>
						<input type="hidden" name="ref" value="${article.ref}"/>
						<input type="hidden" name="writer" value="${loginMember.id}"/>
						<input type="hidden" name="nickname" value="${loginMember.nickname}"/>
						<textarea name="commentContent"  id="commentContent" style="min-height:53px !important;width:100%;border:none;padding:10px;" placeholder="댓글을 입력해 주세요."></textarea>
						<input type="submit"  id="commentSubmitBtn" style="background:#ededed;margin-top:10px;background:none;border:none;float:right;" value="입력"/>

					</div>
				</form>
		</c:if>
		<div style="margin-bottom:50px;"></div>	
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
							<tr>
								<td>	
							<%
								if(loginMember != null){
									
									if(loginMember.getId().equals(((ArticleBean)pageContext.getAttribute("c")).getWriter())){
							%>
									<a href="deleteComment?boardNo=<%=boardNo %>&pageNo=<%=pageNo%>&no=<%=no%>&commentNo=${c.no }" style="color:black;text-decoration:none;float:right;">삭제</a>		
							<%
									}
								}
							%>
								</td>
							</tr>
						</table>
						</div>
				</c:forEach>
		
		</c:if>
		</div>
		
	</div>
</div>


