<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%
	String boardNo = request.getParameter("boardNo");
	if(boardNo == null){
		boardNo = "1";
		response.sendRedirect("community?boardNo=1&pageNo=1");
	}
	String pageNo = request.getParameter("pageNo");
	
	if(session.getAttribute("loginMember")==null){
		%>
		<script>
		alert("잘못된 접근 입니다.");
		window.location.href('loginForm');
		</script>
		<%
	}

%>

<!-- <script src="//cdn.ckeditor.com/4.5.9/basic/ckeditor.js"></script> -->
<script src="resources/ckeditor1/ckeditor.js"></script>
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
	

	
	#inputTitle{
	    width: 100%;
	    border: none;
	    height: 40px;
	    padding: 10px;
	    font-size: 20px;
	}
	
	#inputSubmit{
	    float: right;
	    width: 100px;
	    height: 50px;
	    border: none;
	    font-size:20px;
	}

	
	
	.cke_chrome{
		border:none !important; 
	}
	
	.cke_top{
		border:none;
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
	
<script>
	$(function(){
		
		$("#inputSubmit").on("click",function(){
			var value = true;
			
			if($("#inputTitle").val().length == 0){
				alert("재목을 입력해 주세요");
				
				value = false;
			}
			
			
			return value;
			
		})
		
	})
 </script>
 
<div style="clear:both;"></div>

<div id="communityDiv" >
	<ul style="list-style:none;">
		<li style="margin-bottom:20px;margin-top:20px;"><span style="font-size:30px;padding-left:20px;">글쓰기</span></li>
	</ul>
	<br/>
	<div id="communityListBody">
		<form method="post" action="write" >
        	<input type="hidden" name="boardNo" value="<%=boardNo %>"/>
        	<input id="inputTitle" type="text" name="title" maxlength="30" placeholder="제목"/>
            <br/><br/>
            <textarea name="editor1" id="editor1" rows="10" cols="80">
    
            </textarea>
            <script>
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace( 'editor1' );
            </script>
            <br/>
            <input type="submit"  id="inputSubmit" value="저장"/>
        </form>
	</div>
	
</div>
