<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../inc/admin_header.jsp" %>

<main id="content">
	<h2 class="blind">본문</h2>
	<div class="as_inner inner">
	   <h3>공지사항 작성</h3>
	   <div class="as_board-list">
		   <form action="noticeWrite.admin" method="post" id="noticeWrite">
		      <fieldset>
		         <legend class="blind">공지사항 작성 폼</legend>
			      <table class="table as_table as_detail-table">
			         <colgroup>
			            <col class="col4">
			            <col class="colA">
			         </colgroup>
			         <tbody>
			         	<tr>
			         		<th scope="row"><label for="b_title">제목</label></th>
			         		<td><input class="form-control" type="text" id="b_title" name="b_title" value=""></td>
			         	</tr>
			           	<tr>
			           		<th colspan="2" scope="col"><label for="b_content">내용</label></th>
			           	</tr>
			         	<tr>
			         		<td colspan="2" class="as_b-content">
			         		<textarea class="form-control" id="b_content" name="b_content"></textarea>
				   			 </td>
			         	</tr>
			         </tbody>
			      </table>
			
				    <div class="as_inner-footer">
				       <div class="btns">
				           <button type="button" class="btn btn-danger btn-write-cancel">작성 취소</button>
				           <button type="submit" class="btn btn-primary">작성 완료</button>
				       </div>
				    </div>
		      </fieldset>
	      </form>
	   </div>
	</div>
</main>

<script>
$(function(){
	$(".btn-write-cancel").on("click", function(){
		let result = confirm("작성을 취소하고 게시글 목록으로 돌아가시겠습니까?");
		if(result){
			location.href="${pageContext.request.contextPath}/notice.admin";
		}
	})
});
</script>

<%@ include file="../../inc/admin_footer.jsp" %>