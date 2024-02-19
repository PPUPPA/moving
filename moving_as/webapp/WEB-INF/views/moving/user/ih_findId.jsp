<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<div class="ih__findId">
	<form action="findId.ih" method="post">
		<div class="head">
			<a href="findIdView.ih" id="first">아이디찾기</a>
			<a href="findPassView.ih" id="second">비밀번호찾기</a>
		</div>
		<fieldset>
			<div class="inputType">
				<label for="name">이름</label>
				<input type="text" name="name" id="name" placeholder="이름을 입력해주세요." />
			</div>
			<div class="inputType">
				<label for="age">생년월일</label>
				<input type="text" name="age" id="age" placeholder="생년월일 8자리 ex) 19810101" />
			</div>
			<div class="inputType">
				<label for="email">이메일</label>
				<input type="email" name="email" id="email" placeholder="비밀번호를 입력해주세요." />
			</div>
			<input type="submit" class="btn" value="아이디찾기">
		</fieldset>
	</form>
</div>
<%@include file="../../inc/footer.jsp"%>