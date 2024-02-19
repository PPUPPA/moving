<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<div class="ih__findPass">
	<form action="#" method="post">
		<div class="head">
			<a href="findIdView.ih" id="first">아이디찾기</a>
			<a href="findPassView.ih" id="second">비밀번호찾기</a>
		</div>
		<fieldset>
			<div class="inputType">
				<label for="name">아이디</label>
				<input type="text" name="name" id="name" placeholder="아이디를 입력해주세요." />
			</div>
			<div class="form-class">
				<label for="email">이메일</label> 
				<input type="email" id="email" name="email" class="email" placeholder="이메일 입력" />
				<input type="button" class="btn btn-success" id="sendPass" value="임시비밀번호 발송" />
			</div>

			<div class="button-class">
				<a href="loginPage.ih" class="btn btn-primary" >로그인</a>
			</div>
		</fieldset>
	</form>
</div>
<script type="text/javascript">
// 이메일 코드 보내기 클릭 이벤트 리스너
let sendPass = document.getElementById('sendPass');
sendPass.addEventListener('click', function() {
    let email = document.getElementById('email').value;
    let emailcriteria = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

    // 이메일 공백검사
    if (email == "") {
        alert("이메일을 입력하세요");
        email.focus();
        return false;
    }

    // 이메일 유효성 검사
    if (!emailcriteria.test(email)) {
        alert("이메일형식이 올바르지 않습니다.");
        email.focus();
        return false;
    }

    // 인증코드 보내기 AJAX 요청
    $.ajax({
        url: 'sendPass.ih',
        type: 'POST',
        dataType: "text",
        data: { email: email },
        success: function(codeData) {
            alert('임시비밀번호를 전송했습니다.\n이메일을 확인해주세요.');
        },
        error: function(xhr, status, error) {
            alert('오류가 발생했습니다');
        }
    });
});
</script>
<%@include file="../../inc/footer.jsp"%>