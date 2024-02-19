<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<div class="ih_preMyUpdatePage">
	<form action="checkpass.ih" method="post" id="preUpdate">		
	    <div class="head">
			<img alt="lock" src="${pageContext.request.contextPath}/resources/assets/images/ih/lock.png">
			<pre>회원님의 정보를 안전하게 보호하기 위해<br/>비밀번호를 다시 한번 확인해주세요</pre>
		</div>
		<div class="blind">
			<label for="user_id">아이디</label>
			<input type="text" id="user_id" name="user_id" value="${user_id}" readonly/>
		</div>
		<div class="input-group">
			<label for="password">비밀번호</label>
			<input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요" required>
			<p id="userCheckResult"></p>
		</div>
		<div class="btn-group">
			<input type="button" class="btn btn-danger" value="&nbsp돌아가기" id="backButton" />
			<button type="submit" class="submitBtn">확인&nbsp&nbsp&nbsp&nbsp</button>
		</div>
	</form>

<script>
$(function() {
	//비밀번호검증아작스
    var form = $("#preUpdate");
    form.on("submit", function(event) {
        event.preventDefault();
        $.ajax({
            url: "userCheckBeforeUpdate.ih",
            type: "POST",
            dataType: "text",
            data: {
                "id": $("#user_id").val(),
                "password": $("#password").val()
            },
            success: function(data) {
                if (data === "pass") {
                    form[0].submit();
                } else {
                    $("#userCheckResult").html(data);
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                $("#userCheckResult").html(textStatus + "(HTTP-" + xhr.status + ")");
            }
        });
    });
    //소셜로그인 버튼 클릭시 소셜로그인을 완료하고, 해당 소셜로그인고유ID를 갖고 있는 계정테이블이 있는지 확인(없으면 alert=해당SNS계정과 연동된 계정이없습니다.)
    
});
document.getElementById('backButton').addEventListener('click', function() {
	history.back();
});
</script>
</div>
<%@include file="../../inc/footer.jsp"%>