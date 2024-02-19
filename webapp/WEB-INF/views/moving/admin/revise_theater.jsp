<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../inc/admin_header.jsp"%>


<main id="content">
	<!-- 영화관 수정 페이지 -->
	<div id="revise-theater" class="page">
		<h2>영화관 관리</h2>
		<div class="sub_content">
			<h3>영화관 수정</h3>
			<p id="exp">
				<strong class="required">**</strong> 변경사항을 새로 작성해주세요.
			</p>
			<form
				action="${pageContext.request.contextPath}/revise-theater.admin?tt_no=${dto.tt_no}"
				method="post" id="revise-theater-form">
				<div class="list-revise-theater">
					<p>영화관 이름 ></p>
					<input type="text" id="tt_name" name="tt_name"
						value="${dto.tt_name}">
				</div>
				<!-- 상영관 수정 pt. -->
				
				<div>
					<div class="list-revise-theater">
						<P>상영관 선택</p>
						<select name="scr_no">
							<!-- 보유 상영관 드랍다운으로 다 보여주기  -->
							<c:forEach var="sdto" items="${sdtoList}" varStatus="status">
								<option value="${sdto.scr_no}">${sdto.scr_name}</option>
							</c:forEach>
						</select>
					</div>
					<div class="list-revise-theater">
						<p>상영관 이름 ></p>
						<input type="text" id="scr_name" name="scr_name" value="${sdto.scr_name}">
					</div>
					<div class="list-revise-theater">
						<p>상영관 가격 ></p>
						<input type="number" id="scr_price" name="scr_price" value="${sdto.scr_price}">
					</div>
				</div>

				<div id="" class="list-revise-theater">
					<p>전화번호 ></p>
					<input type=text id="tt_tel" name="tt_tel" value="${dto.tt_tel}">
				</div>

				<div id="" class="list-revise-theater">
					<p>영업시간 ></p>
					<input type="time" id="tt_start" name="tt_start"
						value="${dto.tt_start}"> <input type="time" id="tt_close"
						name="tt_close" value="${dto.tt_close}">
				</div>

				<input type="submit" value="변경하기" id="revise-theater-btn">
			</form>

		</div>
	</div>
</main>

<script>
	$(document).ready(function() {
		/* 페이지 로드될 때 제일 첫번째 상영관 정보부터 보여주기 */
		let firstScrNo = $("select[name='scr_no']").first().val();
		//console.log(firstScr);
		$.ajax({
				url : "screen-info.admin", // 서버에서 정보를 가져올 URL
				type : "GET",
				data : {
					scr_no : firstScrNo
				}, // 선택한 상영관의 이름을 서버에 전달
				dataType : "json",
				success : function(response) {
					// 서버에서 받은 정보로 값을 업데이트
					$("#scr_name").val(response.scr_name);
					$("#scr_price").val(response.scr_price);
				},
				error : function() {
					// 에러 처리
					console.error("Failed to get screen information");
				}
			});
		
		/* '상영관 선택' 셀렉트 박스가 변경될 때 이벤트 발생 */
		$("select[name='scr_no']").change(function() {
			// 선택한 상영관의 값 
			let selectedScrNo = $(this).val();

			$.ajax({
				url : "screen-info.admin", // 서버에서 정보를 가져올 URL
				type : "GET",
				data : {
					scr_no : selectedScrNo
				}, // 선택한 상영관의 이름을 서버에 전달
				dataType : "json",
				success : function(response) {
					// 서버에서 받은 정보로 값을 업데이트
					$("#scr_name").val(response.scr_name);
					$("#scr_price").val(response.scr_price);
					
				},
				error : function() {
					// 에러 처리
					console.error("Failed to get screen information");
				}
			});
		});
	});
</script> 



<%@ include file="../../inc/admin_footer.jsp"%>