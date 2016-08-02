<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.dos.finances.bean.*,com.dos.finances.dao.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	if(session.getAttribute("loginMember")==null){
		%>
		<script>
		alert("잘못된 접근 입니다.");
		window.location.href('loginForm');
		</script>
		<%
	}
	
	String id = null;
	if(request.getParameter("id") != null){
		id = request.getParameter("id");
		
		pageContext.setAttribute("receiver", id);
	}
%>
<div id="writeMessageDiv">
	<h3>메시지 보내기</h3>
	<form action="sendMessage" method="post">
		<input type="hidden" name="sender" value="${loginMember.id}"/>
		<c:if test="${not empty receiver }">
			<input type="hidden" id="idCheck" value="true"/>
		</c:if>
		<c:if test="${empty receiver }">
			<input type="hidden" id="idCheck" value="false"/>
		</c:if>
		<table class="table">
			<tr>
				<td>
					받는이
				</td>
				<td>
				
				<c:if test="${not empty receiver }">
					<input class="form-control" id="receiver" name="receiver" value="${receiver}" type="text"/>
				</c:if>
				
				<c:if test="${empty receiver }">
					<input class="form-control" id="receiver" name="receiver" type="text"/>
				</c:if>
					<span id="alert" style="color:red;display:none;">존재하지 않는 회원 입니다.</span>
				</td>
			</tr>
			<tr>
				<td>
					제목
				</td>
				<td>
					<input class="form-control" id="title" name="title" type="text"/>
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea class="form-control" name="content" rows="10" cols="30"></textarea>
				</td>
			</tr>
		</table>
		<input class="form-control" type="submit" id="send" value="보내기"/>
	</form>
</div>
<script>
	$(function(){
		$("#send").on("click",function(){
			var result = false;
			
			var check = $("#idCheck").val();

			if(check == false || check == "false"){
				alert("해당 아이디는 존재하지 않습니다.");
			}else if(check == true || check == "true"){
				result = true;
			}
			
			
			return result;
		})
		
		$("#receiver").on("keyup",function(){
			
			var input = $("#receiver").val();
			var param = {id:input};
			
		
			$.ajax({
				type:"post",
				url:"ajax/sendMessageCheck",
				contentType:"application/json",
				dataType:"json",
				data:JSON.stringify(param),
				processData:false,
				async:false,
				timeout:300,
				success:function(responseData){
					var jsonResult = responseData.result;
					if(jsonResult == "true"){
						$("#idCheck").val(true);
						$("#alert").hide();
					}else{
						$("#idCheck").val(false);			
						$("#alert").show();

					}
				}
				
			});
			
		});
		
	})
</script>