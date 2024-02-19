<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../../inc/admin_header.jsp" %>

<main id="content">
   <div class="page">
   <h2>공지사항 목록</h2>
   <div class="sub_content">
	<div class="as_inner inner">
	   <div class="as_board-list">
		   <div class="search-box">
		      <p class="table-summary">
		         ${param.searchKey!=null?"검색된":"등록된"} 게시글 총 ${paging.listtotal}개
		      </p>
		      
		      <div class="search-group">
                 <label>
                    <select id="as_sch-type" class="form-control" name="searchType">
                  	  <option value="b_title" ${param.searchType == 'b_title' ? 'selected' : ''}>제목</option>
                  	  <option value="b_content" ${param.searchType == 'b_content' ? 'selected' : ''}>내용</option>
                  	  <option value="b_all" ${param.searchType == 'b_all' ? 'selected' : ''}>제목+내용</option>
                    </select>
                 </label>
		         <label>
		            <input type="text" class="form-control" id="as_sch-key" value="${param.searchKey}" name="searchKey" placeholder="검색어를 입력해주세요.">
                 	<button type="button" class="btn-del"><span class="blind">입력 내용 삭제</span></button>
		         </label>
		         <button type="button" class="btn btn-primary" id="search">검색</button>
		      </div>
		   </div>
		   
		   <table class="table table-hover as_table as_list-table">
		      <colgroup>
		         <col class="col4">
		         <col class="col4">
		         <col class="colA">
		         <col class="col4">
		         <col class="col12">
		         <col class="col4">
		      </colgroup>
		      <thead>
		         <tr>
	         	    <th scope="col"><label><input type="checkbox" value="allChk" class="all-check"></label></th>
		            <th scope="col">No</th>
		            <th scope="col">제목</th>
		            <th scope="col">작성자</th>
		            <th scope="col">작성일</th>
		            <th scope="col">조회수</th>
		         </tr>
		      </thead>
		      <tbody>
				<c:choose>
					<c:when test="${list.size() > 0}">
						<c:forEach var="dto" items="${list}" varStatus="status">
						<tr>
							<td><label><input type="checkbox" value="${dto.board_no}"></label></td>
		                    <td>${paging.listtotal-paging.pstartno-status.index}</td>
							<td><a href="${pageContext.request.contextPath}/noticeDetail.admin?board_no=${dto.board_no}">${dto.b_title}</a></td>
							<td>관리자</td>
							<td>${dto.b_crtdate.split(' ')[0]}</td>
							<td>${dto.b_hit}</td>
						</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
						   <td colspan="8" class="is-empty">
						      <p>${param.searchKey!=null?"검색된":"등록된"} 게시글이 없습니다.</p>
						   </td>
						</tr>
					</c:otherwise>
				</c:choose>
		      </tbody>
		   </table>
		
		 <div class="as_inner-footer">
		    <div class="pagination-container">
				<ul class="pagination">
					<c:if test="${paging.startPage>=paging.bottomlimit}">
						<li class="previous">
							<a href="${pageContext.request.contextPath}/notice.admin?pstartno=${(paging.startPage-2)*paging.onepagelimit}">이전</a>
						</li>
					</c:if>
					<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
						<li <c:if test="${paging.currentPage == i}">class="active"</c:if>>
							<a href="${pageContext.request.contextPath}/notice.admin?pstartno=${(i-1)*paging.onepagelimit}">${i}</a>
						</li>
					</c:forEach>
					<c:if test="${paging.endPage<paging.pagetotal}">
						<li class="next">
							<a href="${pageContext.request.contextPath}/notice.admin?pstartno=${paging.endPage*paging.onepagelimit}">다음</a>
						</li>
					</c:if>
				</ul>
		    </div>
		
		    <div class="btns">
		       <button type="button" class="btn btn-danger btn-delete">선택 삭제</button>
		       <a href="${pageContext.request.contextPath}/noticeWrite.admin" class="btn btn-primary">글 작성</a>
		    </div>
		 </div>
		</div>
	</div>
	</div>
	</div>
</main>

<script>
$(function(){
	$(".btn-delete").on("click", function(){
		deleteNotice();
	});
	
    // checkbox
    $(document).on("change", ".as_list-table input[type='checkbox']", function () {
       let totalCheckboxes = $('.as_list-table input[type="checkbox"]:not(.all-check)').length;
       let checkedCheckboxes = $('.as_list-table input[type="checkbox"]:checked:not(.all-check)').length;

       // 모든 하위 체크박스가 체크되어 있으면 .all-check도 체크
       $('.as_list-table .all-check').prop('checked', totalCheckboxes === checkedCheckboxes);

       saveSelectedNotice(); // 체크박스 상태가 변할 때마다 호출
    });

    // allchk
    $('.as_list-table .all-check').change(function () {
       let isChecked = $(this).prop('checked');

       // .as_list-table 내 하위 체크박스 상태를 .all-check 와 맞춤
       $('.as_list-table input[type="checkbox"]').prop('checked', isChecked);
    });
    
    // 검색
	$("#search").on("click",function(){	
		searchList();
	});
    
	$("#as_sch-key").on("keyup",function(key){
		if(key.keyCode==13){
			searchList();
		}
	});
	
	$("#as_sch-key").on("focus", function(){
		$(".btn-del").stop().show();
	})
	
	$(".btn-del").on("click", function(){
		$("#as_sch-key").val('');
		searchList();
	});
});

//검색 함수
function searchList(){
	let search = $("#as_sch-type").val();
	let query = $("#as_sch-key").val();
	if(query != ''){		
		location.href=('notice.admin?searchType='+search+'&searchKey='+query);
	} else {
		location.href=('notice.admin');
	}
}

// 선택한 게시글을 저장하는 함수
function saveSelectedNotice() {
	selectedNotices = [];

   $(".as_list-table input[type='checkbox']:checked").each(function () {
      let value = $(this).val();

      if (value == 'allChk') {
         return;
      } else {
    	  selectedNotices.push(parseInt(value, 10));
      }
   });
}

// 게시글 삭제
function deleteNotice() {
    if (selectedNotices.length > 0) {
        $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "${pageContext.request.contextPath}/noticeDelete.admin",
            data: JSON.stringify(selectedNotices),
            dataType: "text",
            success: function (data) {
                if (data === "success") {
                	let restult = confirm("선택한 게시글을 삭제하시겠습니까?");
                    if(restult) {
                    	alert("게시글이 삭제되었습니다.");
                    	location.reload();
                   	}
                } else {
                    alert("게시글 삭제 중 오류가 발생했습니다.");
                }
            },
            error: function (xhr, status, msg) {
                alert(status + "/" + msg);
            }
        });
    } else {
        alert("삭제할 게시글를 선택해주세요!");
    }
}
</script>

<%@ include file="../../inc/admin_footer.jsp" %>