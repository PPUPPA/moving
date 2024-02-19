<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<div class="ih__myUpdatePass">
	<form action="myUpdatePass.ih" method="post" id="myUpdatePass">
		<h2>비밀번호변경</h2>
		<fieldset>
			<div class="blind">
				<label for="id">아이디</label>
				<input type="text" name="id" id="id" value="${user_id}" readonly/>
			</div>
			<div class="inputType">
				<label for="password">현재비밀번호</label>
				<input type="password" name="password" id="password" placeholder="현재 비밀번호를 입력해주세요." />
				<p id="userCheckResult"></p>
			</div>
			<div class="inputType">
				<label for="updatePassword">변경할 비밀번호</label>
				<input type="password" name="updatePassword" id="updatePassword" placeholder="변경할 비밀번호를 입력해주세요." />
				<p>영문, 숫자, 특수문자 중 2가지 이상 조합하여 8-16글자</p>
				<p id="passwordCriteria"></p>
			</div>
			<div class="inputType">
				<label for="updatePasswordConfirm">변경할 비밀번호 확인</label>
				<input type="password" name="updatePasswordConfirm" id="updatePasswordConfirm" placeholder="변경할 비밀번호를 다시 입력해주세요." />
				<p id="passduplication"></p>
			</div>
			<div class="button-class">
				<a href="javascript:history.go(-1);" class="btn btn-danger">돌아가기</a>
				<input type="submit" class="btn btn-primary" value="변경">
			</div>
		</fieldset>
	</form>
</div>
<script type="text/javascript">
$(function() {
	//비밀번호검증아작스
    var form = $("#myUpdatePass");
    form.on("submit", function(event) {
        event.preventDefault();
        $.ajax({
            url: "userCheckBeforeUpdate.ih",
            type: "POST",
            dataType: "text",
            data: {
                "id": $("#id").val(),
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
});
</script>
<script src="${pageContext.request.contextPath}/resources/assets/js/ih_updatePass.js"></script>

<%@include file="../../inc/footer.jsp"%>