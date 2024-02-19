<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.security.SecureRandom"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/header.jsp"%>
<main id="main" class="main">
      <h2 class="blind">메인 컨텐츠</h2>
      <div id="container" class="container">
<div class="ih__loginPage">
	<form action="loginBtn.ih" method="post" id="loginForm">
		<h2 class="h2">회원로그인</h2>
		<fieldset>
		
			<div class="inputType">
				<label for="id">아이디</label>
				<input type="text" name="id" id="id" placeholder="아이디를 입력해주세요." <c:if test="${not empty id}">value="${id}"</c:if> />
			</div>
			
			<div class="inputType">
				<label for="password">비밀번호</label>
				<input type="password" name="password" id="password" class="#" placeholder="비밀번호를 입력해주세요." />
				<p id="userCheckResult"></p>
			</div>
			
			<div class="remember">
				<input type="checkbox" name="remember" id="remember" <c:if test="${rememberId != ''}">checked</c:if> />
				<label for="remember">아이디저장</label>
			</div>
			
			<input type="submit" value="로그인" class="loginBtn" />
			
			<div class="find">
				<a href="findIdView.ih">ID/PW찾기</a>
				<a href="joinForm.ih">회원가입</a>
			</div>
			
			<div class="socialLogin">
				<p class="tit"><strong>간편로그인</strong></p>
				<%
				String contextPath = request.getContextPath();
				StringBuffer requestUrl = request.getRequestURL();
				String baseUrl = requestUrl.substring(0, requestUrl.indexOf(contextPath) + contextPath.length());
				    // 네이버) 클라이언트 ID와 리디렉션 URI를 설정
				    String NaverClientId = "HA45SpjNLNnGrNT2Hw0w";
//				    String NaverClientId = "F2zq0tBcOIWZ8IJInXGy";	//호스팅전용
				    String NaverRedirectURI = URLEncoder.encode(baseUrl+"/prepareLogin.ih", "UTF-8");
				    SecureRandom random = new SecureRandom();
				    String NaverState = new BigInteger(130, random).toString(32);
				    session.setAttribute("state", NaverState);
					
				    // 카카오) 클라이언트 ID와 리디렉션 URI를 설정
					String KakaoClientId = "3d769a0fec3ae6e8966e62f3a2e7456b";
					String KakaoRedirectURI = URLEncoder.encode(baseUrl+"/kakaoLogin.ih", "UTF-8");
				    
				    // 네이버) 로그인 URL을 생성
				    String naverAuthURL = 
				          "https://nid.naver.com/oauth2.0/authorize?response_type=code"
				        + "&client_id=" + NaverClientId
				        + "&redirect_uri=" + NaverRedirectURI
				        + "&state=" + NaverState +"&scope=profile_nickname";
				    
				    // 카카오) 로그인 URL을 생성
					String kakaoAuthURL = 
							"https://kauth.kakao.com/oauth/authorize?response_type=code"
							+ "&client_id=" + KakaoClientId
							+ "&redirect_uri=" + KakaoRedirectURI;
				%>
				<!-- 카카오 -->
				<a href="<%= kakaoAuthURL %>" title="KAKAO LOGIN"> <img src="${pageContext.request.contextPath}/resources/assets/images/ih/kakao_0.png" alt="login" style="width:52px; height: 52px;" alt="카카오 로그인 버튼"/></a>
				<!-- 네이버 로그인 버튼 -->
				<a href="<%= naverAuthURL %>" title="NAVER LOGIN"> <img src="${pageContext.request.contextPath}/resources/assets/images/ih/naver_0.png" style="width:52px; height: 52px; margin-left:40px;" alt="네이버 로그인 버튼"/> </a>
			</div>
				
			<div class="under">
				<p>회원가입후 SNS계정을 연동한 경우에만 <span>간편로그인</span>이 가능합니다. <br/>
				   <span>마이페이지 > 개인정보수정</span> 에서 진행해주세요.
				</p>
			</div>
		</fieldset>
	</form>
</div>
</div>
</main>
<%@include file="../../inc/footer.jsp"%>
<script>
$(function() {
	
	<c:if test="${not empty joinSuccess}"> alert("${joinSuccess}"); </c:if>
	<c:if test="${not empty noIntegrationUser}"> alert("${noIntegrationUser}"); </c:if>
	//로그인검증아작스
    var form = $("#loginForm");
    form.on("submit", function(event) {
        event.preventDefault();
        $.ajax({
            url: "userCheck.ih",
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
    //소셜로그인 버튼 클릭시 소셜로그인을 완료하고, 해당 소셜로그인고유ID를 갖고 있는 계정테이블이 있는지 확인(없으면 alert=해당SNS계정과 연동된 계정이없습니다.)
    
});
</script>