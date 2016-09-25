<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.dos.finances.bean.*" %>
<%
	if(session.getAttribute("loginMember") != null){
		%>
			<script>
				alert('이미 로그인 되어있습니다.');
				window.location.href('index');
			</script>
		<%
	}
%>

<script>
	$(function(){
		$("#loginCheck1").hide();
		$("#loginCheck2").hide();
		
		
		$("#loginForm").on("submit",function(){
			var result = false;
			if($("#id").val().length == 0 || $("#pass").val().length==0){
				$("#loginCheck1").show();
				$("#loginCheck2").hide();
				return false;
			}
			
			var params = $("#loginForm").serialize();
	
			$.ajax({
				url:"ajax/loginProcess",
				type:"post",
				data:params,
				dataType:"text",
				async:false,//동기식은 false 비동기는 true
				success:function(responseData,statusText,xhr){
					result = responseData;
					var find = $(result).find("#result").text();
					$("#loginResult").val(find);
				}
			})
			if($("#loginResult").val()!="true"){
				$("#loginCheck1").hide();
				$("#loginCheck2").show();
				return false;
			}else{
				return true;
			}
			
		})
		
		
	}) 
	

</script>
<style>
	.form{
		width:200px;height:25px;
		border:none;
		margin-bottom:5px;
		padding:5px;
	}
</style>
<div style="width:100%;height:100%;">
	<div style="padding-top: 250px;margin: auto auto;width: 400px;height: 100px;">
		<div style="border:1px solid #ededed;height:240px; padding:30px;">
			<p style="font-size:60px;font-weight:100;margin-bottom:10px;">Login</p>
			<form method="post" id="loginForm" name="loginForm"  action="login">
				<div style="float:left;width:200px; margin-right:10px;">
					<input type="text" class="form" name="id" id="id" placeholder="아이디"/><br/>
					<input type="password"  class="form" name="pass" id="pass" placeholder="비밀번호"/><br/>
				</div>
				<input type="submit" style="background:#ededed;width:57px;height:57px;border:none;" value="로그인" >
				<div style="display:none;"><input type="text" name="loginResult" id="loginResult" value="false"/></div><br/><br/>
				<span id="loginCheck1" style="color:red;">아이디 또는 비밀번호를 입력해 주세요.</span>
				<span id="loginCheck2" style="color:red;">아이디 또는 비밀번호를 확인해 주세요.</span>		
			</form>
		</div>
	</div>
	
</div>