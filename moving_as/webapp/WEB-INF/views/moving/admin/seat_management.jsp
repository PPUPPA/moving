<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../inc/admin_header.jsp"%>

<main id="content">
	<!-- 좌석 관리 페이지 -->
	<div id="seat-management" class="page">
		<h2>좌석 관리</h2>
		<div class="sub_content">
			<h4>${dto.tt_name}</h4>
			<hr>

			<div id="seat" data-bkLists="${bkLists}">
				<!-- 열 반복 -->
				<c:forEach var="row" begin="0" end="${dto.st_row}" step="1" >
					<!-- 행 반복 -->
					<p data-scr_no="${dto.scr_no}">
						<c:forEach var="col" begin="1" end="${dto.scr_st_col}" step="1">
							<div class="eachSeat">
								<input type="checkbox" class="${dto.list[row]}${col} hidden"
									data-bkSeat="${dto.list[row]}${col}" /> <label
									for="${dto.list[row]}${col}">${dto.list[row]}${col}</label>
							</div>
						</c:forEach>
					</p>
				</c:forEach>
				
				<div class="seatColorInfo" >
					<p id="blueSeat"></p> 
					<p>사용 가능한 좌석</p>
				</div>
				<div class="seatColorInfo">
					<p id="greySeat"></p> 
					<p>보류중인 좌석</p>
				</div>
				<div class="seatColorInfo" >
					<p id="redSeat"></p> 
					<p>보류 좌석으로 선택할 좌석</p>
				</div>
				<div class="seatColorInfo" >
					<p id="yellowgreenSeat"></p> 
					<p>사용 가능으로 선택할 좌석</p>
				</div>
			</div>


			<input type="button" value="좌석 수정하기" id="revise-seats-btn" />

		</div>

	</div>
</main>

<script>
	$(document).ready(function(){
		/* 고장난 좌석 다른배경색으로 구분 */
		let bkSeatLists = "${bkSeatLists}";   //고장난 좌석 리스트 
		console.log(bkSeatLists);  //[B6, B7]

		//모든 좌석을 읽으면서 고장난 좌석의 이름과 일치하는 지 확인
		$(".eachSeat input").each(function() {
		    let seatValue = $(this).attr("data-bkSeat");// 현재 좌석의 값
		    //console.log(seatValue);
		    
		    if (bkSeatLists.includes(seatValue)) {
	            // 일치하는 경우의 동작 수행
	            $(this).next('label').addClass('brokenSeat'); 
	        }   
		});
		
    	let bkList = [];
    	let ActiveSTList = [];
		/* 보류좌석으로 변경 */
		$("#seat label").on("click", function(){
			let checkbox = $(this).closest('div').find('input');
			console.log(checkbox);
			let index = bkList.indexOf($(this).closest('.eachSeat').find('input').attr("data-bkSeat"));
			let index2 = ActiveSTList.indexOf($(this).closest('.eachSeat').find('input').attr("data-bkSeat"));
			<!-- 클릭한 label과 연결된 가장 가까운 div 요소 찾고, 그 안의 input 요소 checked 속성을 토글시킴 -->
			checkbox.prop('checked', function(i, currentValue) {
				return !currentValue;
			});
			

			<!-- 클릭한 좌석 class='check' 넣고 클릭된 좌석 색깔 변경 -->
			if (checkbox.prop('checked') && !$(this).hasClass('brokenSeat')) {  // 클릭한 좌석이 brokenSeat 클래스를 가지지 않은(이미 고장난 좌석) 경우에만 실행!!
				$(this).addClass('check');
				bkList.push($(this).closest('.eachSeat').find('input').attr("data-bkSeat"));
				
			} 
			else {
				$(this).removeClass('check');
			    // 체크 해제된 경우 해당 값의 인덱스를 찾아서 제거!! 좌석 계속 누적 안되게하기. 
			    if (index !== -1) {
			        bkList.splice(index, 1);
			    }
			}
			<!-- 고장난 좌석 체크하면 changeToAct 클래스 주기  -->
			if (checkbox.prop('checked') && $(this).hasClass('brokenSeat')) {  
				$(this).addClass('changeToAct');
				ActiveSTList.push($(this).closest('.eachSeat').find('input').attr("data-bkSeat"));
		
			}
			else if(!checkbox.prop('checked') && $(this).hasClass('brokenSeat')){
				$(this).removeClass('changeToAct');
				if (index2 !== -1) {
					ActiveSTList.splice(index2, 1);

			    }
				
			}
			/* if($(this).hasClass('changeToAct')){
				ActiveSTList.push($(this).closest('.eachSeat').find('input').attr("data-bkSeat"));
			} */
			console.log("bkList: "+bkList);
			console.log("ActiveSTList : " + ActiveSTList);
			
			
			console.log("chageToAct: "+$(".changeToAct"));
			//console.log("Checkbox checked status: " + checkbox.prop('checked'));  //Checkbox checked status: true/false	
		}); 
		
				
		
		
		/* 좌석수정 처리 */
		scrNo = $("#seat p").data("scr_no");
		$("#revise-seats-btn").on("click", function(){

			$.ajax({
    			url:"seat-manage.admin",
    			type:"POST",
    			dataType: "json", 
    		    data: {
    		        scr_no: scrNo,
    		        bkList: JSON.stringify(bkList),
    		        ActiveSTList : JSON.stringify(ActiveSTList)
    		    },
    			error:function(xhr, status, msg){
					alert("에러");
				},
    			success: function(result){
    				if(result==1){
    					alert("좌석 수정이 완료되었습니다. ");
        				location.href="screen-manage.admin?scr_no="+scrNo;
    				}
    				else if(result==2){
    					alert("수정된 좌석이 없습니다. ");
        				location.href="screen-manage.admin?scr_no="+scrNo;
    				}
    				else{
    					alert("좌석 수정을 성공적으로 처리하지 못하였습니다. ");
    				}
    				
    			}	
    		});//end ajax
		}); 
		
		
});
	</script>



<%@ include file="../../inc/admin_footer.jsp"%>