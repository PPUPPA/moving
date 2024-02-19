<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../inc/admin_header.jsp"%>



<main id="content">
	<!-- 영화관 삭제 페이지 -->
	<div id="delete-theater" class="page">
		<h2>영화관 관리</h2>
		<div class="sub_content">
			<h3>영화관 삭제</h3>
			<table class="hy_table">
				<thead>
					<tr>
						<th scope="row"></th>
						<th scope="row">상영관 개수</th>
						<th scope="row">영화관 주소</th>
						<th scope="row">영화관 번호</th>
						<th scope="row">영업시간</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="dto" items="${list}" varStatus="status">
					<tr>
						<td data-tt_name="${dto.tt_name}"><a href="#" class="deleteBtn" data-tt_no="${dto.tt_no}">
						${dto.tt_name}</a></td>
						<td>${dto.tt_scrcnt}</td>
						<td>${dto.tt_address}</td>
						<td>${dto.tt_tel}</td>
						<td>${dto.tt_start} - ${dto.tt_close}</td> 
					</tr>
				</c:forEach>
				</tbody>
			</table>
			

			

		</div>
	</div>
</main>

<script>
$(document).ready(function(){
	$(".deleteBtn").on("click", function(){
		//console.log($(this).data("tt_no"));
		let name = $(this).closest('td').data("tt_name");
		let conf = window.confirm("해당 '"+name +"'을 삭제하시겠습니까?");
		
		if(conf){ //삭제 '확인' 버튼 눌렀을 때 
			$.ajax({
	    		url:"delete-theater.admin",
	    		type:"POST",
	    		dataType: "json", 
	    		data: {tt_no : $(this).data("tt_no")},
	    		error:function(xhr, status, msg){
    			alert("에러 : 영화관 삭제가 불가능합니다.");
    			},
	    		success: deleteResult		
	    	});
		}
		else { //삭제 '취소' 버튼 눌렀을 때 
			alert("영화관 삭제를 취소합니다.");
		}
		

		function deleteResult(result){
			if( result.result == 1){
				alert("해당 '" +name+ "' 삭제가 완료되었습니다. ");
				location.href="delete-theater-view.admin";
			}
			else {
				alert("영화관 삭제가 불가능합니다.");
			}
		} // end deleteResult()
	
	});
});


</script>



<%@ include file="../../inc/admin_footer.jsp"%>