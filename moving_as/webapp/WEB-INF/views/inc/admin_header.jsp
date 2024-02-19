<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    
	<link rel="icon" href="${pageContext.request.contextPath}/resources/assets/images/common/favicon.ico">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/reset.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/admin.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/as_common.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/movie.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/board.css" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/admin_assets/css/admin_shj.css" />
    
    
    <script src="${pageContext.request.contextPath}/resources/admin_assets/js/admin.js"></script>
    <title>관리자 페이지</title>
</head>

<body>
    <div class="container-fluid">
    	<h1 class="blind">관리자 페이지</h1>
        <div class="row">
            <nav id="sidebar" class="col-3">
    			<h2 class="blind">관리자 주메뉴</h2>
                <div class="position-sticky">
                    <div class="icon">
                        <p><img src="${pageContext.request.contextPath}/resources/admin_assets/images/admin-icon.png" alt=""></p>
                        <p>관리자</p>
                        <hr>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="adminPage.admin">
                                회원 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="movie.admin">
                                영화 관리
                            </a>
                            <ul class="nav-submenu">
                                <li><a href="movie.admin">영화 목록</a></li>
                                <li><a href="movieAdd.admin">영화 추가</a></li>
                            </ul> 
                        </li>
                        <li class="nav-item" id="theater-management-item">
                            <a class="nav-link" href="theater-list.admin">
                                영화관 관리
                            </a>
                            <ul class="nav-submenu">
                                <li><a href="add-theater.admin">영화관 추가</a></li>
                                <li><a href="delete-theater-view.admin">영화관 삭제</a></li>
                                <li><a href="schedule-management.admin">상영시간표 관리</a></li>
                            </ul> 
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="reservation_management.admin">
                                예매 관리
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="notice.admin">
                                게시판 관리
                            </a>
                            <ul class="nav-submenu">
                                <li><a href="notice.admin">공지사항 관리</a></li>
                            </ul> 
                        </li>
<!--                         <li class="nav-item"> -->
<!--                             <a class="nav-link" href="#product-management"> -->
<!--                                 상품 관리 -->
<!--                             </a> -->
<!--                         </li> -->
                    </ul>
                    
                    <div class="btns">
                    	<a href="main.ks" target="_blank" class="btn">홈페이지 바로가기</a>
                    </div>
                </div>
            </nav>