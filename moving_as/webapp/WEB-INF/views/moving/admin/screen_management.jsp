<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include  file="../../inc/admin_header.jsp" %>


			<!-- 상영관 관리 페이지 -->
			<main id="content">
                <div id="screen-management" class="page">
                    <h2>상영관 관리</h2>
                    <div class="sub_content">
                        <h4 data-tt_name="${dto.tt_name}">${dto.tt_name}</h4>
                        <hr>

                        <table class="hy_table" id="sm" data-scr_no="${dto.scr_no}" data-scrstate_no="${dto.scrstate_no}">
                        	<tr>
                        		<th></th> 
                        		<th id="data2" data-scr_name="${dto.scr_name}" >${dto.scr_name}</th>
                            </tr>
                            
                            <tr>
                            	<th>상영관 상태</th>
                            	<td>${dto.scrstate_state}</td>
                            	<td id="btnArea"> </td>
                            </tr>
                            <tr>
                            	<th>좌석 수</th>
                            	<td>총  ${dto.scr_st_cnt}석</td>
                            </tr>
                            <tr>
                            	<th>보류중인 좌석 </th>
                            	<td>총   ${dto.bk_st_cnt}석</td>
                            	<td><input type="button" value="좌석 관리" id="change-seat-btn"></td>      
                            </tr>  
                        </table>
                
                        <section style="min-height: 300px;"></section>
                    </div>
                    
                </div>
            </main>

<script>
	$(document).ready(function(){
		let scrStateNo = $("#sm").data("scrstate_no");
		let ttName = $(".sub_content h4").data("tt_name");
		let scrName = $("#data2").data("scr_name");
		let scrNo = $("#sm").data("scr_no");
		
		<!-- 상영관이 '영업중' 상태일 때 -->
		if(scrStateNo == 1){
			let btn = "<input type='button' value='상영관 중지' id='change-scr-btn'>";
			$("#btnArea").append(btn);
		}
		<!-- 상영관이 '영업중지' 상태일 때 -->
		else if (scrStateNo == 2) {
			let btn = "<input type='button' value='상영관 활성화' id='active-scr-btn'>";
			$("#btnArea").append(btn);
		}
		
		<!-- 상영관 상태 변경 -->
		$("#change-scr-btn").on("click", function(){
			let con = 
				window.confirm("선택하신 '"+ttName+"의 " +scrName+"'을 사용 중단시키겠습니까?");
			
			if(con){
				alert("상영관이 일시적으로 중단되었습니다.");
				location.href="revise-screen.admin?scr_no="+scrNo+"&scrstate_no="+scrStateNo;
			
			}
			else{
				location.href="screen-manage.admin?scr_no="+scrNo;
			}
			
		});
		
		$("#active-scr-btn").on("click", function(){
			let con = 
				window.confirm("선택하신 '"+ttName+"의 " +scrName+"'을 활성화시키겠습니까?");
			
			if(con){
				alert("상영관 활성화가 완료되었습니다.");
				location.href="revise-screen.admin?scr_no="+scrNo+"&scrstate_no="+scrStateNo;
			
			}
			else{
				location.href="screen-manage.admin?scr_no="+scrNo;
			}
			
		});
		
		
		<!-- 상영관 좌석 관리 페이지로 이동 -->
		$("#change-seat-btn").on("click", function(){
			if(scrStateNo == 1){
				location.href="seat-manage.admin?scr_no="+scrNo;
			}
			else{
				alert("현재 상영관이 사용 중단 상태입니다.");
			}	
		});
		
	
	});
</script>

<%@ include  file="../../inc/admin_footer.jsp" %>