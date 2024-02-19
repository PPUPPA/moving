<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<script src="${pageContext.request.contextPath}/resources/assets/js/ih_update.js"></script>
<div class="ih__myUpdatePage">
<form action="myUpdateGo.ih" method="post" class="update" id="update">
	<div class="title"> <h2>회원정보</h2> </div>
		<fieldset>
			<div class="form-class">
				<label for="id" >아이디</label> 
				<input type="text" id="id" name="id" value="${dto.user_id}" readonly />
			</div>
			<div class="form-class">
				<label for="name">이름</label>
				<input type="text" id="name" name="name" value="${dto.user_name}" readonly />
			</div>
			<div class="form-class">
				<label for="nickname">닉네임</label> 
            	<input type="text" id="nickname" name="nickname" value="${dto.user_nick}" readonly />
            <div class="form-class">
            </div>
            	<label for="nickname2" class="blind">닉네임</label> 
            	<input type="text" id="nickname2" name="nickname2" placeholder="변경할 닉네임을 적어주세요" />
            	<p id="nicknameCriteria"></p>
				<p id="nicknameResult" class="checkedResult"> 2~8자 이내 한글,영문대소문자,숫자 사용가능<br/></p>
				
			</div>
			<div class="form-class">
				<label for="email">이메일</label>
            	<input type="email" id="email" name="email" value="${dto.user_mail}" readonly />
            </div>
            <div class="form-class">
            	<label for="email" class="blind">변경할 이메일</label>
            	<input type="email" id="email2" name="email2" placeholder="변경할 이메일을 적어주세요"/>
				<input type="button" class="btn btn-success" id="sendCode" value="코드발송" />
				<p id="emailResult" class="checkedResult"> </p>
			</div>
			<div class="form-class">
				<label for="inputEmail" class="myhidden">인증코드입력</label>
				<input type="text" id="inputEmail" class="inputEmail" placeholder="인증코드를 입력해주세요." />
				<input type="text" id="timeLimit" style="color:red;" readonly/>
				<input type="text" id="emailCode" class="blind" value="" />
				<input type="button" class="btn btn-success" id="btnCheckCode" value="코드확인">
			</div>
			<div class="form-class">
				<label for="phonenumber">휴대폰번호</label>
				<input type="tel" id="phonenumber" name="phonenumber" value="${dto.user_phone}" readonly />
            <div class="form-class">
            </div> 
            	<label for="phonenumber2" class="blind">변경할 번호</label>
				<input type="tel" id="phonenumber2" name="phonenumber2" placeholder="변경할 휴대폰번호를 적어주세요(-제외)"/>
			</div>
			<div class="form-class">
				<label for="age">생년월일</label>
				<input type="text" id="age" name="age" value="${dto.user_age}" disabled />
			</div>
			<div class="form-class">
				<label>SNS계정 연동관리</label>
				<ul>
					<li class="socialIntegration">
					<button onclick="kakaoPopup()">
						<img alt="카카오 연동" src="${pageContext.request.contextPath}/resources/assets/images/ih/kakao_0.png">
							<span>카카오톡</span>
							<p id="kakaoIntegrationResult"></p>
					</button>
					</li>
					<li class="socialIntegration">
					<button onclick="naverPopup()">
						<img alt="네이버 연동" src="${pageContext.request.contextPath}/resources/assets/images/ih/naver_0.png">
							<span>네이버</span>
							<p id="naverIntegrationResult"></p>
					</button>
					</li>
				</ul>			
			</div>
			<a href="MyUpdatePassView.ih" class="btn btn-info" id="changePass">비밀번호변경</a>
			<button id="goDeleteAndCancleBtn" class="deleteAndCancleBtn">
			<c:if test="${dto.usertp_no != '4'}">
			회원탈퇴요청하기
			</c:if>
			<c:if test="${dto.usertp_no == '4'}">
			회원탈퇴요청취소하기
			</c:if>
			</button>
		</fieldset>
			<div class="button-class">
				<a href="javascript:history.go(-2);" class="btn btn-danger">돌아가기</a>
				<input type="submit" class="btn btn-primary" value="정보수정" />
			</div>
	</form>	
<!-- 	<div id="receivedData"></div>  -->
<!--	<div id="receivedDataNaver"></div> -->
	<input class="blind" Type="text" id="kakaoCodeField" value = ""/>
	<input class="blind" Type="text" id="naverCodeField" value = ""/>
<!-- 탈퇴신청을안한 회원 -->
<c:if test="${dto.usertp_no != '4'}">
    <form action="myDelete.ih?user_id=${dto.user_id}" method="GET">
    	<input type="text" name="user_id" value="${dto.user_id}" class="blind">
        <input type="submit" class="blind blindbtn" id="request" value="회원탈퇴">
    </form>
</c:if>

<!-- 탈퇴신청을한 회원 -->
<c:if test="${dto.usertp_no == '4'}">
    <form action="myDeleteCancle.ih?user_id=${dto.user_id}" method="GET">
    	<input type="text" name="user_id" value="${dto.user_id}" class="blind">
        <input type="submit" class="blind blindbtn" id="response" value="회원탈퇴취소">
    </form>
</c:if>

<script>
function kakaoPopup() {event.preventDefault(); window.open('kakaoLoginResult.ih', 'kakao', 'width=600,height=400,left=200,top=200'); }
function naverPopup() {event.preventDefault(); window.open('naverLoginResult.ih', 'naver', 'width=600,height=400,left=200,top=200'); }
function receiveKakaoCode(userKakao) {
    console.log("Received kakao code: " + userKakao);
    document.getElementById("kakaoCodeField").value = userKakao;
    $.ajax({
        url: "updateKakaoCode.ih",
        type: "GET",
        dataType: "text",
        data: { "id": $("#id").val(),
        		"user_kakao": $("#kakaoCodeField").val()
        	},
        success: function(data) {
        	console.log("업데이트!");
        		$("#kakaoIntegrationResult").html(data);
        		$("#kakaoCodeField").html();
        	},
        error: function(xhr, status, error) { console.error("Error: " + status + " - " + error); }
    });
}
function receiveNaverCode(userNaver) {
    console.log("Received naver code: " + userNaver);
    document.getElementById("naverCodeField").value = userNaver;
    $.ajax({
        url: "updateNaverCode.ih",
        type: "GET",
        dataType: "text",
        data: { "id": $("#id").val(),
        		"user_naver": $("#naverCodeField").val()
        	},
        success: function(data) {
        	console.log("업데이트!");
        		$("#naverIntegrationResult").html(data);
        		$("#naverCodeField").html();
        	},
        error: function(xhr, status, error) { console.error("Error: " + status + " - " + error); }
    });
}







$(document).ready(function() {
	// 마이페이지 입장시 카카오 연동여부 검사
    $.ajax({
        url: "confirmKakaoIntegration.ih",
        type: "POST",
        dataType: "text",
        data: { "id": $("#id").val() }, 
        success: function(data) {
        	console.log("delete!");
        	$("#kakaoIntegrationResult").html(data);
        	},
        error: function(xhr, status, error) { console.error("Error: " + status + " - " + error); }
    });
	// 마이페이지 입장시 네이버 연동여부 검사
    $.ajax({
        url: "confirmNaverIntegration.ih",
        type: "POST",
        dataType: "text",
        data: { "id": $("#id").val() }, 
        success: function(data) {
        	console.log("delete!");
        	$("#naverIntegrationResult").html(data);
        	},
        error: function(xhr, status, error) { console.error("Error: " + status + " - " + error); }
    });
    // 닉네임 유효성 검사
    $("#nickname2").on("keyup", function() {
        var nickname = $(this).val();
        var regex = /^[a-zA-Z0-9가-힣]{2,8}$/;
        validateField(nickname, regex, $("#nicknameCriteria"));
    });

    // 필드 유효성 검사 함수
    function validateField(value, regex, criteriaElement) {
        if (regex.test(value)) {
            criteriaElement.css("color", "blue").text("위 조건을 만족합니다.");
        } else {
            criteriaElement.css("color", "red").text("위 조건을 만족하지않습니다.");
        }
    }
});

window.onload = function() {
	//탈퇴신청성공
    <c:if test="${not empty myDeleteSuccess}"> alert("${myDeleteSuccess}"); </c:if>
    //탈퇴신청취소성공
    <c:if test="${not empty myDeleteUserCancleSuccess}"> alert("${myDeleteUserCancleSuccess}"); </c:if>
    //개인정보변경성공
    <c:if test="${not empty updateSuccess}"> alert("${updateSuccess}"); </c:if>
    //개인정보변경실패
    <c:if test="${not empty updateFail}"> alert("${updateFail}"); </c:if>
    //비밀번호변경성공
    <c:if test="${not empty updatePassSuccess}"> alert("${updatePassSuccess}"); </c:if>
    
    var goDeleteAndCancleBtn = document.getElementById('goDeleteAndCancleBtn');

    if (goDeleteAndCancleBtn) {
        goDeleteAndCancleBtn.addEventListener('click', function(e) {
            e.preventDefault(); // 기본 동작 방지

            var requestBtn = document.getElementById('request');
            var responseBtn = document.getElementById('response');

            if (requestBtn) {
                requestBtn.click();
            }

            if (responseBtn) {
                responseBtn.click();
            }
        });
    }
    
    var deleteButton = document.getElementById('request');
    if (deleteButton) {
        deleteButton.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('회원 탈퇴하시겠습니까?')) {
                e.target.form.submit();
            }
        });
    }

    var cancelDeleteButton = document.getElementById('response');
    if (cancelDeleteButton) {
        cancelDeleteButton.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('회원 탈퇴를 취소하시겠습니까?')) {
                e.target.form.submit();
            }
        });
    }
};
</script>

</div>
<c:set var="myDeleteSuccess" value="${myDeleteSuccess}" />
<c:set var="updateSuccess" value="${updateSuccess}" />
<c:set var="updateFail" value="${updateFail}" />
<c:set var="myDeleteUserCancleSuccess" value="${myDeleteUserCancleSuccess}" />

<%@include file="../../inc/footer.jsp"%>