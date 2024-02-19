<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../inc/admin_header.jsp" %>

<main id="content">
	<div class="page">
   <h2>공지사항 수정</h2>
   <div class="sub_content">
	<div class="as_inner inner">
	   <div class="as_board-detail">
		   <form action="noticeUpdate.admin?board_no=${dto.board_no}" method="post" id="noticeUpdate">
		      <fieldset>
		         <legend class="blind">${dto.b_title} 상세 수정</legend>
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
			         		<td>${dto.user_no==0?"관리자":"Unknown"}</td>
			         		<th scope="row">작성일</th>
			         		<td>${dto.b_crtdate}</td>
			         		<th scope="row">조회수</th>
			         		<td>${dto.b_hit}</td>
			         		<th scope="row">IP</th>
			         		<td>${dto.b_ip}</td>
			         	</tr>
			         	<tr>
			         		<th scope="row"><label for="b_title">제목</label></th>
			         		<td colspan="9"><input class="form-control" type="text" id="b_title" name="b_title" value="${dto.b_title}"></td>
			         	</tr>
			           	<tr>
			           		<th scope="col" colspan="10"><label for="b_content">내용</label></th>
			           	</tr>
			         	<tr>
			         		<td colspan="10" class="as_b-content">
			         		<textarea class="form-control" id="b_content" name="b_content">${dto.b_content}</textarea>
				   			 </td>
			         	</tr>
			         </tbody>
			      </table>
			
				    <div class="as_inner-footer">
				       <div class="btns">
				           <button type="button" class="btn btn-danger btn-modify-cancel">수정 취소</button>
				           <button type="submit" class="btn btn-primary">수정 완료</button>
				       </div>
				    </div>
		      </fieldset>
	      </form>
	   </div>
	</div>
	</div>
	</div>
</main>

<script>
$(function(){
	$(".btn-modify-cancel").on("click", function(){
		let result = confirm("수정을 취소하고 상세 페이지로 돌아가시겠습니까?");
		if(result){
			location.href="${pageContext.request.contextPath}/noticeDetail.admin?board_no=${dto.board_no}";
		}
	})
});
</script>

<%@ include file="../../inc/admin_footer.jsp" %>