<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.sql.*"%>
<%@ include file="../../inc/admin_header.jsp"%>
<style>
td.text-center { border: none; }
button#deleteSelected { margin-right: 10px; }
</style>
<main id="content">
<div class="page">
    <h2>회원 관리</h2>
    <div class="sub_content">
        <div class="ih_adminUser">
            <div class="panel-warning">
                <form id="deleteForm" action="adminDeleteUser.admin" method="POST" style="overflow:auto; height:800px;">
                    <div class="cm_btns">
                        <button id="deleteSelected" class="btn btn-danger" type="button">선택 삭제</button>
                    </div>
                    <table class="table table-striped usertable" style="margin: 50px auto;">
                        <thead>
                            <tr>
 				<th scope="col">번호</th>
				<th scope="col">등급</th>
				<th scope="col">ID</th>
				<th scope="col">이름</th>
				<th scope="col">별명</th>
				<th scope="col">이메일</th>
				<th scope="col">생년월일</th>
				<th scope="col">전화번호</th>
				<th scope="col">카카오코드</th>
				<th scope="col">네이버코드</th>
				<th scope="col">가입날짜</th>
				<th scope="col">가입IP</th>
				<th scope="col">유저탈퇴</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach  var="dto"  items="${list}"  varStatus="status">
				<tr>
					<td>${paging.listtotal-paging.pstartno-status.index}</td>
					<td>${dto.usertp_no}</td>
					<td><a href='MyUpdatePageView.ih?user_no=${dto.user_no}'>${dto.user_id}</a></td>
					<td>${dto.user_name}</td>
					<td>${dto.user_nick}</td>
					<td>${dto.user_mail}</td>
					<td>${dto.user_age}</td>
					<td>${dto.user_phone}</td>
					<td>${dto.user_kakao}</td>
					<td>${dto.user_naver}</td>
					<td>${dto.user_crtdate}</td>
					<td>${dto.user_ip}</td>
					<td><input type='checkbox' name='user_id' value='${dto.user_id}'></td>
					
				</tr>
			</c:forEach>
		</tbody>
 			<tfoot>
 				<tr>
 					<td  colspan="13"  class="text-center">
 						<ul  class="pagination">
							<!-- 이전( 90)    11(100)  -->
							<!-- 이전(190)    21(200)    25   28 -->
							  <c:if test="${paging.startPage>= paging.bottomlimit}" > 
							  <li>
								<a href="${pageContext.request.contextPath}/adminPage.admin?pstartno=
											       ${(paging.start-2)*paging.onepagelimit}">이전</a>
							  </li>
							  </c:if> 
							 			
							<!-- 1(0) 2(10) 3(20) 4 5 6 7 8 9 10 -->
							<c:forEach  begin="${paging.startPage}"  end="${paging.endPage}"  var="i">
								<li  <c:if test="${paging.currentPage==i}" > class="active"</c:if> >
									<a href="${pageContext.request.contextPath}/adminPage.admin?pstartno=
											${(i-1)*paging.onepagelimit}">${i}</a>
								</li>
							</c:forEach>
							<!-- 다음 -->
							<!--   1 2 3 4 5 6 7 8 9 10(90)   다음(100) -->
							<!-- 11 12 13 14 15 16 17 18 19 20(190)   다음(200) -->
							  <c:if test="${paging.endPage  < paging.pagetotal}" > 
							  <li>
								<a href="${pageContext.request.contextPath}/adminPage.admin?pstartno=
											       ${paging.endPage*paging.onepagelimit}">다음</a>
							  </li>
							  </c:if>
 						</ul>
 					</td>
 				</tr>
 			</tfoot>
 		</table>
</form>
</div>
</div>
</div>
</div>
</main>
<script>
$(document).ready(function() {
    $("#deleteSelected").click(function() {
        let userIds = [];
        $("input[name='user_id']:checked").each(function() {
            userIds.push($(this).val());
        });

        let data = JSON.stringify({ "userIds": userIds });

        $.ajax({
            url: "adminDeleteUser.admin",
            type: "POST",
            contentType: "application/json",
            data: data,
            success: function(response) {
            	alert("선택한 회원이 탁퇴처리 되었습니다.");
                location.reload();
            },
            error: function(xhr, status, error) {
                alert("Error: " + error);
            }
        });
    });
});
</script>
<%@ include file="../../inc/admin_footer.jsp"%>