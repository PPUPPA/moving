<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../inc/admin_header.jsp"%>

<main id="content">
    <!-- 영화관 추가 페이지 -->
    <div id="add-theater" class="page">
        <h2>영화관 관리</h2>
        <div class="sub_content">
            <h3>영화관 추가</h3>
            <form action="add-theater.admin" method="post" id="add-theater-list">
                <div>
                    <p><strong class="required">＊</strong>추가할 영화관 이름 ></p>
                    <input type="text" id="tt_name" name="tt_name" placeholder="지역이름을 포함해주세요.">
                </div>

                <div>
                    <input type="button" id="add_screen_btn" value="상영관 추가">
                </div>

                <div id="scrArea">
                    <!-- 상영관 입력 폼 -->
                    <div class="scrContents">
                        <div class="list_src_name">
                            <p><strong class="required">＊</strong>추가할 상영관 이름 ></p>
                            <input type="text" class="scr_name" name="screenList[0].scr_name" placeholder="상영관 이름을 설정해주세요.">
                        </div>
                        <div class="list_src_price">
                            <p><strong class="required">＊</strong>해당 상영관 가격 ></p>
                            <input type="number" class="scr_price" name="screenList[0].scr_price" placeholder="상영관 가격을 설정해주세요.">
                        </div>
                        <div class="seat_capacity">
                            <p><strong class="required">＊</strong>해당 상영관 수용 좌석 개수 ></p>
                            <label for="seat_st_row">좌석 행 : </label>
                            <select class="seat_st_row" name="screenList[0].scr_st_row">
                                <option value="A">A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                                <option value="E">E</option>
                                <option value="F">F</option>
                                <option value="G">G</option>
                                <option value="H">H</option>
                                <option value="I">I</option>
                                <option value="J">J</option>
                            </select>
                            <label for="seat_st_column">좌석 열 : </label>
                            <select name="screenList[0].scr_st_col" class="seat_st_column">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                            </select>
                        </div>
                        <!-- 나머지 필드들 -->
                        <input type="button" value="취소" class="cancel_scr_btn">
                        
                    </div>
                    <!-- end scrContents -->
                </div>

                <div id="list_tt_img">
                    <label for="tt_img" class="lists"><strong class="required">＊</strong>이미지 업로드 ></label>
                    <input type="text" id="tt_img" name="tt_img" placeholder="영화관 사진을 업로드해주세요.">
                </div>

                <div>
                    <label for="tt_address" class="lists"><strong class="required">＊</strong>영화관 주소 ></label>
                    <input type="text" id="tt_address" name="tt_address" placeholder="영화관 주소를 입력해주세요.">
                </div>

                <div>
                    <label for="tt_tel" class="lists"><strong class="required">＊</strong>전화번호 ></label>
                    <input type="text" id="tt_tel" name="tt_tel" placeholder="(-)를 포함해서 전화번호를 입력해주세요.">
                </div>

                <div>
                    <p><strong class="required">＊</strong>영업시간 ></p>
                    <input type="time" id="tt_start" name="tt_start">
                    <input type="time" id="tt_close" name="tt_close">
                </div>

				<div class="cm_btns">
                <input type="button" value="추가하기" id="add-theater-btn">
                </div>
            </form>
        </div>
    </div>
</main>

<script>
    $(function () {
       $("#add-theater-btn").on("click", function (event) {
            event.preventDefault();

            if($("#tt_name").val()==""){
				alert("영화관 이름을 입력해주세요.");
				$("#tt_name").focus();
				return false;
			}
            
            if($(".scr_name").val()==""){
				alert("추가할 상영관의 이름을 입력해주세요.");
				$(".scr_name").focus();
				return false;
			}
            if($(".scr_price").val()==""){
				alert("추가할 상영관의 가격을 입력해주세요.");
				$(".scr_price").focus();
				return false;
			}
           
            if($("#tt_img").val()==""){
				alert("추가할 영화관의 이미지를 업로드해주세요.");
				$("#tt_img").focus();
				return false;
			}
            if($("#tt_address").val()==""){
				alert("추가할 영화관의 주소를 입력해주세요.");
				$("#tt_address").focus();
				return false;
			}
            if($("#tt_tel").val()==""){
				alert("추가할 영화관의 전화번호를 입력해주세요.");
				$("#tt_tel").focus();
				return false;
			}
            

            if ( $("#tt_start").val() === "" || $("#tt_close").val() === "") {
                alert("영업시간을 모두 입력해주세요.");
                $("#tt_start").focus();
                return;
            }
            

         	// Form 데이터 전송
            $("#add-theater-list").submit();
         	
        }); 
        


        $("#add_screen_btn").on("click", function () {
            let newIndex = $(".scrContents").length;
            let newScreen = $(".scrContents:first").clone().appendTo("#scrArea");
            newScreen.attr("id", "scrContents_" + newIndex); // ID 수정
            newScreen.find(".scr_name").attr("name", "screenList[" + newIndex + "].scr_name");
            newScreen.find(".scr_price").attr("name", "screenList[" + newIndex + "].scr_price");
            newScreen.find(".seat_st_row").attr("name", "screenList[" + newIndex + "].scr_st_row");
            newScreen.find(".seat_st_column").attr("name", "screenList[" + newIndex + "].scr_st_col");
            newScreen.find(".cancel_scr_btn").off("click").on("click", function () {
                $(this).closest(".scrContents").remove();
                cancelPrevAction();
            });
        });
        
        $("#scrArea").on("click", ".cancel_scr_btn", function () {
            let pId = $(this).closest(".scrContents").attr("id");

            if (pId && pId.startsWith("scrContents")) {
                $(this).closest(".scrContents").remove();
            }
        });

        function cancelPrevAction() {
            $("#scrArea .cancel_scr_btn:first").on("click", function () {
                alert("\n최소 한개 이상의 상영관을 추가해주세요.");
            });
        }

        cancelPrevAction();
        
  
      	
        
    });
    
</script>

<%@ include file="../../inc/admin_footer.jsp"%>