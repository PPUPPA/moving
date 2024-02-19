<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../inc/admin_header.jsp" %>

<main id="content">
<div class="page">
   <h2>공지사항 상세</h2>
   <div class="sub_content">
	<div class="as_inner inner">
	   <div class="as_board-detail">
	      <table class="table as_table as_detail-table">
	         <colgroup>
	            <col class="col8">
	            <col class="col8">
	            <col class="col4">
	            <col class="col16">
	            <col class="col4">
	            <col class="col16">
	            <col class="col4">
	            <col class="col16">
	            <col class="col4">
	            <col class="col20">
	         </colgroup>
	         <tbody>
	         	<tr>
	         		<th scope="row">게시글 ID</th>
	         		<td>${dto.board_no}</td>
	         		<th scope="row">작성자</th>
	         		<td>관리자</td>
	         		<th scope="row">작성일</th>
	         		<td>${dto.b_crtdate}</td>
	         		<th scope="row">조회수</th>
	         		<td>${dto.b_hit}</td>
	         		<th scope="row">IP</th>
	         		<td>${dto.b_ip}</td>
	         	</tr>
	         	<tr>
	         		<th scope="row">제목</th>
	         		<td colspan="9">${dto.b_title}</td>
	         	</tr>
	           	<tr>
	           		<th scope="col" colspan="10">내용</th>
	           	</tr>
	         	<tr>
	         		<td colspan="10" class="as_b-content">
	          		<pre>${dto.b_content}</pre>
		   			 </td>
	         	</tr>
	         </tbody>
	      </table>
	
	    <div class="as_inner-footer">
	       <div class="btns">
	          <a href="noticeUpdate.admin?board_no=${dto.board_no}" class="btn btn-danger">글 수정</a>
	          <a href="notice.admin" class="btn btn-primary">목록으로</a>
	       </div>
	    </div>
	   </div>
	</div>
	</div>
	</div>
</main>

<%@ include file="../../inc/admin_footer.jsp" %>