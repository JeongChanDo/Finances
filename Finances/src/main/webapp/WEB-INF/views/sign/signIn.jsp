<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script> 
<!-- <script src="js/formcheck.js"></script> -->
<script>
	$(function(){
		$("#formCheck").hide();
		$("#formCheck2").hide();
		
		
		$("#passCheck").hide();
		$("#passCheck2").hide();
		
		$("#idCheck1").hide();
		$("#idCheck2").hide();
		$("#idCheck3").hide();
		$("#idCheck4").hide();
		
		$("#idCheck").val("false");//false면 중복 true면중복아님
		$("#passwordSuccess").val("false");
		
		
		$("#id").on("blur",function(){
			if($("#id").val().length==0){
				$("#idCheck1").hide();
				$("#idCheck2").hide();
				$("#idCheck3").hide();
				$("#idCheck4").show();
			}else{
				var param = "id="+$("#id").val();
				$.get(
					"ajax/idCheck",
					param,
					function(responseData,statusText,xhr){
						var result = responseData;
						var r = $(result).find("#check").text();
						$("#idCheck").val(r);
					}
				)
				
				if($("#idCheck").val()=="true"){//중복되지 않은 아이디
					$("#idCheck1").hide();
					$("#idCheck2").show();
				}else{//중복된 아이디
					$("#idCheck1").show();
					$("#idCheck2").hide();

				}
				$("#idCheck3").hide();
				$("#idCheck4").hide();
			}
		})
		
		$("#id").keydown(inputIdCheck);
		

		
		
		$("*").on("click",function(){
			if($("#id").val().length!=0){
				if($("#idCheck").val()=="true"){//중복되지 않은 아이디
					$("#idCheck1").hide();
					$("#idCheck2").show();
				}else{//중복된 아이디
					$("#idCheck1").show();
					$("#idCheck2").hide();
				}
				$("#idCheck3").hide();
				$("#idCheck4").hide();
			}else{
				$("#idCheck1").hide();
				$("#idCheck2").hide();
				$("#idCheck3").hide();
				$("#idCheck4").show();
			}
		})
		
		
		$("#password").on("blur",function(){
			
			if($("#password").val().length > 0 &&$("#password").val() == $("#passwordCheck").val()){
				$("#passwordSuccess").val("true");
				$("#passCheck").hide();
				$("#passCheck2").show();
			}else{
				$("#passwordSuccess").val("false");
				$("#passCheck").show();
				$("#passCheck2").hide();
			}
			
			
			if($("#password").val().length == 0 && $("#passwordCheck").val().length==0){
				$("#passCheck").hide();
				$("#passCheck2").hide();
			}
		
		})
		
		$("#passwordCheck").on("blur",function(){
			if($("#passwordCheck").val().length > 0 && $("#password").val() == $("#passwordCheck").val()){
				$("#passwordSuccess").val("true");
				$("#passCheck").hide();
				$("#passCheck2").show();
			}else{
				$("#passwordSuccess").val("false");
				$("#passCheck").show();
				$("#passCheck2").hide();
			}
			
			
			
			if($("#password").val().length == 0 && $("#passwordCheck").val().length==0){
				$("#passCheck").hide();
				$("#passCheck2").hide();
			}

		})
		
		$("button[type=submit]").on("click",function(){
			return formCheck();
		})
	})
</script>
<style>
	#signInTable input{
		border:none;
		padding:10px;
	}
	
	#signInTable td{
		padding-bottom:5px;
	}
	
	#signInTable tr td:nth-child(2){
		padding-left:25px;
	}
	
	#signInTable select{
	    border: none;
	    width: 153px;
	    font-size: 25px;
	    font-weight: 100;
	}
	
	#submit:hover{
		shadow:10px 10px 10px gray;
		pointer:cursor;
	}
</style>
<div style="width:100%;">
	<div id="signInDiv" style="width:700px;padding-top:10%;margin:auto auto;">
		<div style="padding:20px; border:1px solid #ededed;">
			<form method="post" name="joinForm" id="joinForm" action="signInProcess.jsp" onsubmit="return formCheck()">
				<p style="font-size:40px;font-weight:120">SIGN IN</p>
				<br/><br/>
				<table id="signInTable">
					<tr>
						<td>ID</td>
						<td><input type="text" name="id" maxlength="15" id="id" placeholder="id"/></td>
					</tr>
					<tr>
						<td><div style="display:none;"><input type="text" name="idCheck" id="idCheck" readonly/></div></td>
						<td>
							<span id="idCheck1" style="color:red;">아이디가 중복되었습니다.<br/></span>
							<span id="idCheck2" style="color:green;">사용할 수 있는 아이디 입니다.<br/></span>
							<span id="idCheck3" style="color:red;">영어 또는 숫자만 입력가능합니다.<br/></span>
							<span id="idCheck4" style="color:red;">아이디를 입력하세요<br/></span>
						</td>
					</tr>
					<tr>
						<td>PASSWORD</td>
						<td><input type="password" name="password" maxlength="15" id="password" placeholder="password"/></td>
					</tr>
					<tr>
						<td>PASSWORD CHECK</td>
						<td><input type="password" name="passwordCheck" maxlength="15"  id="passwordCheck" placeholder="password check"/></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="hidden" readonly name="passwordSuccess" id="passwordSuccess" />
							<div id="passCheck" class="ui-block"><span style="color:red;">비밀번호가 일치하지 않습니다.</span></div>
							<span id="passCheck2" style="color:green;">비밀번호 확인 완료</span>
						</td>
					</tr>
					
					<tr>
						<td>GENDER</td>
						<td>
							<select name="gender" id="gender" >
								<option value="남성">남성</option>
								<option value="여성">여성</option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td>NICKNAME</td>
						<td><input type="text" name="nickname" maxlength="15" id="nickname" placeholder="nickname"/></td>
					</tr>
					<tr>
						<td>PHONE</td>
						<td><input type="text" name="phone" maxlength="11" id="phone" placeholder="- 없이 입력해 주세요."/></td>
					</tr>
					
					
					<tr>
						<td>ZIP CODE</td>
						<td>
							<input type="text" name="zip_code" id="zipcode" size="6" 
								maxlength="5" readonly id="zipcode" placeholder="우편번호"
								value="${ sessionScope.member.zipcode }" style="width:100px;"/>
							
							<input type="button" class="ui-btn ui-btn-a ui-shadow ui-btn-corner-all" 
								onclick="findZipcode()" value="우편번호 검색"  id="btnZipcode" 
								style="width:130px;"/>
						</td>
					</tr>
					
					<tr>
						<td>ADDRESS1</td>
						<td>
							<input type="text" name="address1" size="60" readonly id="address1" 
							placeholder="자택주소" value="${ sessionScope.member.address1 }"/>
						</td>
					</tr>
					
					<tr>
						<td>ADDRESS2</td>
						<td>
							<div class="memberInputText">
								<input type="text" name="address2" size="60" id="address2" 
								placeholder="상세주소" value="${ sessionScope.member.address2 }"/>
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div id="formCheck" class="ui-block"><span style="color:red;">빈칸을 채워주세요</span></div>
							<div id="formCheck2" class="ui-block"><span style="color:red;">아이디 또는 비밀번호를 확인해 주세요</span></div>				
						</td>
					</tr>
				</table>
				
				
			<%-- 	
				<div class="memberInputText">
					<input type="text" name="zip_code" id="zipcode" size="6" 
						maxlength="5" readonly id="zipcode" placeholder="우편번호     아래의 우편번호 검색을 클릭해 주세요."
						value="${ sessionScope.member.zipcode }"/>
					<input type="button" class="ui-btn ui-btn-a ui-shadow ui-btn-corner-all" data-role="none" onclick="findZipcode()" value="우편번호 검색" id="btnZipcode" style="width:100%"/>
				</div>
						
		
				<div class="memberInputText">
					<input type="text" name="address1" size="60" readonly id="address1" 
						placeholder="자택주소" value="${ sessionScope.member.address1 }"/>
				</div>
				<div class="memberInputText">
					<input type="text" name="address2" size="60" id="address2" 
							placeholder="상세주소" value="${ sessionScope.member.address2 }"/>
				</div>
				<div id="formCheck" class="ui-block"><span style="color:red;">빈칸을 채워주세요</span></div>
				<div id="formCheck2" class="ui-block"><span style="color:red;">아이디 또는 비밀번호를 확인해 주세요</span></div>
				 --%>
				<!-- 
					<input type="text" name="id" maxlength="15" id="id" placeholder="id"/><br/>
						<span id="idCheck1" style="color:red;">아이디가 중복되었습니다.<br/></span>
						<span id="idCheck2" style="color:green;">사용할 수 있는 아이디 입니다.<br/></span>
						<span id="idCheck3" style="color:red;">영어 또는 숫자만 입력가능합니다.<br/></span>
						<span id="idCheck4" style="color:red;">아이디를 입력하세요<br/></span>
						
					<div style="display:none;"><input type="text" name="idCheck" id="idCheck" readonly/></div>
					
					<input type="password" name="password" maxlength="15" id="password" placeholder="password"/>
					<br/>
					
					<input type="password" name="passwordCheck" maxlength="15"  id="passwordCheck" placeholder="password check"/>
					<br/>
					
					<input type="hidden" readonly name="passwordSuccess" id="passwordSuccess" />
					<br/>
					<div id="passCheck" class="ui-block"><span style="color:red;">비밀번호가 일치하지 않습니다.</span></div>
					<span id="passCheck2" style="color:green;">비밀번호 확인 완료</span>
 				-->
 				
 				<!-- 
					<label for="gender">gender</label>
					<select name="gender" id="gender">
						<option value="남성">남성</option>
						<option value="여성">여성</option>
					</select>
					<input type="text" name="nickname" maxlength="15" id="nickname" placeholder="nickname"/>
					<input type="text" name="phone" maxlength="11" id="phone" placeholder="연락처    - 없이 입력해 주세요."/>
					
				 -->
			<br/><br/><br/>
				
				<button type="submit" id="submit" style="border:none;width:100px;padding:10px;float:right;font-weight:100;">SIGN IN</button>
				<br/><br/><br/>
			</form>
		</div>
	</div>
</div>
<script>

function findZipcode() {	
	new daum.Postcode({
		oncomplete: function(data) {
			var fullAddr = ""; // 최종 주소 변수
			var extraAddr = ""; // 조합형 주소 변수
			
			// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if(data.userSelectedType === "R") { // 사용자가 도로명 주소를 선택했을 경우
				fullAddr = data.roadAddress;
				
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				// 모두 도로명 주소를 적용했다.
				fullAddr = data.roadAddress;
				//fullAddr = data.jibunAddress;
			}
			
			// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
			if(data.userSelectedType === "R") {
				//법정동명이 있을 경우 추가한다.
				if(data.bname !== "") {
					extraAddr += data.bname;
				}
				
				// 건물명이 있을 경우 추가한다.
				if(data.buildingName != "") {
					extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
				}
				
				// 조합형 주소가 있으면 조합형 주소를 ()로 묶어서 최종 주소에 추가한다.
				fullAddr += (extraAddr !== "" ? "(" + extraAddr + ")" : "");
			}
			
			// 우편번호와 주소 정보를 해당 입력상자에 출력한다.
			$("#zipcode").val(data.zonecode);
			$("#address1").val(fullAddr);
			
			// 커서를 상세주소 입력상자로 이동한다.
			$("#address2").focus();
			
		}
	}).open();
}

function formCheck(){
	var idCheck = $("#idCheck").val();
	var id = document.joinForm.id.value;
	var password1 = document.joinForm.password.value;
	var password2 = document.joinForm.passwordCheck.value;
	
	var passwordSuccess = document.joinForm.passwordSuccess.value;
	var nickname = document.joinForm.nickname;
	var phone = document.joinForm.phone;
	var zip_code = document.joinForm.zip_code;
	var address1 = document.joinForm.address1;
	var address2 = document.joinForm.address2;
	
	
	//빈칸은 없지만 id 또는 비밀번호 채크가 실패면..
	if((idCheck == "false" ||passwordSuccess == "false")&&!(id.length == 0 ||password1.length == 0
			||password2.length==0||nickname.length==0||phone.length==0||zip_code.length==0
			||address1.length==0||address2.length==0)){

	$("#formCheck2").show();
	$("#formCheck").hide();
	return false;
	}
	
	
	
	//빈칸이 존재한다면
	if(id.length==0 ||password1.length == 0|| password2.length==0||nickname.length==0
			||phone.length==0||zip_code.length==0||address1.length==0||address2.length==0){
	$("#formCheck2").hide();
	$("#formCheck").show();
	return false;
	}
	
	
}


function inputIdCheck() {
	
	/* 회원 정보 입력(수정) 폼의 아이디 입력란에 onkeypress="inputIdCheck()"로
	 * 이벤트 처리를 연결했다. 고전 이벤트 모델의 인라인 이벤트 모델로 이벤트를 처리할 경우
	 * 이벤트 핸들러 안에서 window 객체의 event 속성으로 접근할 수 있다.
	 * 여기서는 onkeypress 이벤트 속성에 inputIdCheck() 함수를 등록했기 때문에
	 * window 객체의 event 속성으로 KeyBoardEvent 객체를 구할 수 있고 
	 * 이 객체의 keyCode 속성으로 어떤 키가 눌렸는지 알아낼 수 있다.
	 **/	
	if(! (event.keyCode >= 48 && event.keyCode <= 57 ||
			event.keyCode >= 65 && event.keyCode <= 90 ||
			event.keyCode >= 97 && event.keyCode <= 122)) {
		
		$("#id").val("");

		$("#idCheck1").hide();
		$("#idCheck2").hide();
		$("#idCheck3").show();
		$("#idCheck4").hide();
	}
	
	
}

</script>  