<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<div class="ih__findId2">
		<div class="head">
			<a href="findIdView.ih" id="first">아이디찾기</a>
			<a href="findPassView.ih" id="second">비밀번호찾기</a>
		</div>
		<pre><br>
			고객님의 ID는 [${id}] 입니다.
		</pre>
		<div class="button-class">
			<a href="loginPage.ih" class="btn" >로그인</a>
		</div>
</div>
<%@include file="../../inc/footer.jsp"%>