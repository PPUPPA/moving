<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <link rel="icon" href="${pageContext.request.contextPath}/resources/assets/images/common/favicon.ico">
  
  <!-- lib -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script src="https://www.WebRTC-Experiment.com/RecordRTC.js"></script>
  <script type="text/javascript"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery.mb.YTPlayer/3.3.8/css/jquery.mb.YTPlayer.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mb.YTPlayer/3.3.8/jquery.mb.YTPlayer.min.js"></script>

  <!-- base -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/font.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/reset.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/component.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/layout.css">
  
  <script src="${pageContext.request.contextPath}/resources/assets/js/common.js"></script>
 
  <!-- page -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/ih.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/reservation.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/movie.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/theater_shj.css">
  <title>무빙</title>
</head>
<body>
   <header id="header" class="header">
     <div class="header__inner">
       <h1 class="logo"><a href="main.ks" class="logo__img" title="메인으로 이동"><span class="blind">무빙</span></a></h1>
	
		<!-- GNB ACTIVE SETTING -->
		<%
		String requestURI = request.getRequestURI();
		boolean isActiveResulvation = requestURI.endsWith("/reservation.jsp") || requestURI.endsWith("/seat.jsp") || requestURI.endsWith("/pay.jsp");
		boolean isActiveMovie = requestURI.endsWith("/movie.jsp") || requestURI.endsWith("/movieDetail.jsp");
		boolean isActiveTheater = requestURI.endsWith("/theater_user_view.jsp");
		boolean isActiveBoard = requestURI.endsWith("/notice.jsp") || requestURI.endsWith("/noticeDetail.jsp");
		boolean isActiveMyResulvation = requestURI.endsWith("/my_reservation.jsp") || requestURI.endsWith("/my_canceld_reservation.jsp");
		boolean isActiveUser = requestURI.endsWith("/ih_preMyUpdatePage.jsp") || requestURI.endsWith("/ih_myUpdatePage.jsp") || requestURI.endsWith("/ih_myUpdatePass.jsp");
		boolean isActiveMy = isActiveMyResulvation || isActiveUser;
		%>
		<!-- GNB ACTIVE SETTING -->
		
       <nav class="gnb__wrap">
         <h2 class="blind">주메뉴</h2>
         <ul id="gnb" class="gnb">
           <!-- 링크 -> a / 2뎁스 버튼 -> button:button -->
           <li class="gnb__item reservation_view<%= isActiveResulvation ? " is-active" : "" %>">
             <c:choose>
             <c:when test="${user_no!=null }"><a href="reservation_view.ks" class="gnb__link"><span>예매</span>
             </a></c:when>
             <c:when test="${user_no==null }"><a href="#" class="gnb__link" id="res"><span>예매</span>
             </a></c:when>
             </c:choose>
           </li>
           <li class="gnb__item<%= isActiveMovie ? " is-active" : "" %>"><a href="movie.as" class="gnb__link">
             <span>영화</span>
           </a></li>
           <li class="gnb__item<%= isActiveTheater ? " is-active" : "" %>"><a href="theater_user_view.shj" class="gnb__link">
             <span>영화관</span>
           </a></li>
           <li class="gnb__item<%= isActiveBoard ? " is-active" : "" %>"><a href="notice.as" class="gnb__link">
             <span>공지사항</span>
           </a></li>
           <li class="gnb__item<%= isActiveMy ? " is-active" : "" %>">
             <button type="button" class="gnb__link">
               <span>마이페이지</span>
             </button>
             <ul class="gnb__2depth">
               <li class="gnb__2depth-item<%= isActiveMyResulvation ? " is-active" : "" %>">
               <c:choose>
             <c:when test="${user_no!=null }"><a href="my_reservation.ks?user_no=${user_no }" class="gnb__2depth-link">
                   <span>예매/취소 내역</span>
                 </a></c:when>
             <c:when test="${user_no==null }">
             	   <a href="loginPage.ih" class="gnb__2depth-link" id="noLoginReservationAccess">
                   <span>예매/취소 내역</span>
                 </a></c:when>
             </c:choose>
                 <script>
	                 document.addEventListener('DOMContentLoaded', function() {
	             	    let noLoginAccessLink = document.getElementById('noLoginReservationAccess');
	             	    if (noLoginAccessLink) {
	             	        noLoginAccessLink.addEventListener('click', function(e) {
	             	            e.preventDefault();
	             	            let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
	             	            if (userResponse) {
	             	                window.location.href = noLoginAccessLink.getAttribute('href');
	             	            }
	             	        });
	             	    }
				        let nologintoMyUpdate = document.getElementById('nologintoMyUpdate');
				        if (nologintoMyUpdate) {
				        	nologintoMyUpdate.addEventListener('click', function(e) {
				                e.preventDefault();
				                let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
				                if (userResponse) {
				                    window.location.href = nologintoMyUpdate.getAttribute('href');
				                }
				            });
				        }
	             	    $("#res").on("click",function(){
	             	    	let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
             	            if (userResponse) {
             	            	location.href='loginPage.ih';
             	            }
	             	    });
	             	});
                 </script>
               </li>
              <li class="gnb__2depth-item<%= isActiveUser ? " is-active" : "" %>">
                  <c:choose>
	              <c:when test="${user_no!=null }">
	                  <a href="preMyUpdatePage.ih?user_id=${user_id}" class="gnb__2depth-link"> <span>회원정보수정</span> </a>
	              </c:when>
	              <c:when test="${user_no==null }">
	                  <a href="loginPage.ih" class="gnb__2depth-link" id="nologintoMyUpdate"> <span>회원정보수정</span> </a>
	              </c:when>    
	              </c:choose>
                </li>
              </ul>
            </li>
          </ul>
        </nav>

        <div class="header-util">
			<ul class="header-util__list">
			    <c:if test="${usertp_name == '삭제된회원'}">
			        <script>
			            alert("탈퇴한 회원입니다.");
			            window.location.href = "logout.ih"; // 로그아웃 처리 URL로 이동
			        </script>
			    </c:if>
			
			    <!-- 관리자인 경우 관리자 페이지와 로그아웃 링크 표시 -->
			    <c:if test="${usertp_name == '관리자'}">
			        <li>${usertp_name} 님 환영합니다!</li>
			        <li class="header-util__item">
			            <a href="adminPage.admin">관리자페이지</a>
			        </li>
			        <li class="header-util__item">
			            <a href="logout.ih">로그아웃</a>
			        </li>
			    </c:if>
			
			    <!-- 로그인하지 않은 경우 로그인과 회원가입 링크 표시 -->
			    <c:if test="${user_id == null && user_naver == null && user_kakao == null}">
			        <li class="header-util__item">
			            <a href="loginPage.ih" class="header-util__link">로그인</a>
			        </li>
			        <li class="header-util__item">
			            <a href="joinForm.ih" class="header-util__link">회원가입</a>
			        </li>
			    </c:if>
			
			    <!-- 일반 사용자인 경우 로그아웃 링크만 표시 -->
				<c:if test="${(user_id != null || user_naver != null || user_kakao != null) && 
				             usertp_name != '관리자' && usertp_name != '삭제된회원'}">
				    <li>${user_nick}님 환영합니다!</li>
				    <li class="header-util__item">
				        <a href="logout.ih">로그아웃</a>
				    </li>
				</c:if>
          </ul>
        </div>
      </div>
    </header>
