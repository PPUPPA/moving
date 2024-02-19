// $(document).ready(function () {
//     // 기본으로 보이는 메뉴 항목을 제외한 모든 내용 섹션을 숨깁니다.
//     $(".page").hide();

//     // 내비게이션 링크에 대한 클릭 이벤트 핸들러를 추가합니다.
//     $(".nav-link").click(function () {
//         // 모든 내용 섹션을 숨깁니다.
//         $(".page").hide();

//         // 클릭한 링크의 href 속성에서 대상 내용 ID를 가져옵니다.
//         var targetContentID = $(this).attr("href");

//         // 선택한 내용 섹션만 표시합니다.
//         $(targetContentID).show();
//     });

      
// });

$(function(){
     // 2depth 
     $(".nav-submenu").hide();
     
     // hover 시 하위 메뉴가 나타나도록 스타일 조정
     $(".nav-item").mouseover(function(){
     	$(this).addClass("is-open");
     	$(this).find(".nav-submenu").stop().slideDown();
     }).mouseout(function(){
     	$(this).removeClass("is-open");
     	$(this).find(".nav-submenu").stop().slideUp();
     });

//     $("#theater-management-item").mouseover(function(){
//        $(this).children("#theater-submenu").stop().slideDown();
//     }).mouseout(function(){
//         $(this).children("#theater-submenu").stop().slideUp();
//     });  
})


/* 영화관 수정 - 상영관 수정 클릭하면 상영관 정보들 show */
$(function() {
    let cnt = 1;
    // '+ 상영관 수정' 버튼과 상영관 선택 div 태그를 가져옴
    $('#revise-scr-btn').click(function() {
        addTheaterSelection();
    });
  
    // function addTheaterSelection() {
    //     // AJAX를 사용하여 서버에서 상영관 선택 영역을 가져오기
    //     $.ajax({
    //       url: 'revise_theater.html', // 실제 서버 URL로 대체해야 함
    //       type: 'GET',
    //       success: function(response) {
    //         // 서버에서 가져온 HTML을 새로운 상영관 선택 영역으로 추가
    //         const uniqueId = 'select-screen-' + cnt;
    //         $('#theater-list-container').append(`<div class="list-revise-theater" id="${uniqueId}">${response}</div>`);
    //     cnt++;
    //       },
    //       error: function(error) {
    //         console.error('Error fetching theater selection:', error);
    //       }
    //     });
    // }

});