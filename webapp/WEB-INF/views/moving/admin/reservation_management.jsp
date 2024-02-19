<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include  file="../../inc/admin_header.jsp" %>
<style>
	.ks .title{margin-top: 80px;}
	.ks h4{font-size: 25px; font-weight: bold;}
	.row {height: 950px;}
	.reservation_management{width: 100%;}
	.rcon .table-bordered{border:none;}
	.rmcontent{background-color: white; padding:10px; margin-top: 80px; border-radius: 10px;}
	.rmcontent p{font-size: 16px; font-weight: bold;}
	.inner_search .form-control {display:inline-block; width: auto; margin:0;}
	
</style>

<!-- main -->
<main id="content" class="main">
	<h2 class="blind">관리자 예매 관리</h2>	
		<div class="ks reservation_management">
			<div class="title"><h4>전체 예매 목록</h4></div>
			<div class="sub_content">
				<p>
			총 예매 - <span>${paging.listTotal }건</span>
		</p>
		
			<form action="admin_reservationCancel.admin" method="post" id="admin_reservationCancelForm">
			<fieldset>
			<div class="rcon">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th scope="col">예매번호</th>
						<th scope="col">유저이름</th>
						<th scope="col">영화이름</th>
						<th scope="col">극장</th>
						<th scope="col">상영관</th>
						<th scope="col">날짜</th>
						<th scope="col">시간</th>
						<th scope="col">가격</th>
						<th scope="col">상태</th>
						<th scope="col">선택</th>
					</tr>
				</thead>
				<tbody style="text-align: center;" class="tbody">
					<c:forEach var="i" items="${paging.rvlist10 }" varStatus="status">
						<tr>
							<td>${i.r_no }</td>
							<td class="user_name">${i.user_name }</td>
							<td class="mv_ktitle">${i.mv_ktitle }</td>
							<td class="tt_name">${i.tt_name }</td>
							<td>${i.scr_name }</td>
							<td>${i.sch_date }</td>
							<td>${i.sch_start }~${i.sch_end }</td>
							<td>${i.r_price }</td>
							<td>${i.rstate_state }</td>
							<td>
							<input type="checkbox" name="r_no" value="${i.r_no }" class="r_no" 
							
								<c:if test="${i.rstate_state=='취소됨' }">disabled</c:if>
								<c:if test="${i.rstate_state=='상영완료' }">disabled</c:if>
							>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div style="text-align: center;">
				<ul class="pagination">
					<c:choose>
						<c:when test="${paging.startBtn!=1 }">
							<li><a
								href="reservation_management.admin?user_name=${param.user_name }&mv_ktitle=${param.mv_ktitle }&tt_name=${param.tt_name }&pstartno=
								${(paging.startBtn-(paging.onepagelimit+1))*paging.onepagelimit }">previous</a></li>
						</c:when>
					</c:choose>
					<c:forEach var="i" begin="${paging.startBtn }"
						end="${paging.endBtn }" step="1" varStatus="status">
						<li class="<c:if test='${i==paging.currentBtn}'>active</c:if>"><a
							href="reservation_management.admin?<c:choose>
							<c:when test="${param.user_name!=null }">user_name=${param.user_name}</c:when>
							<c:when test="${param.mv_ktitle!=null }">mv_ktitle=${param.mv_ktitle}</c:when>
							<c:when test="${param.tt_name!=null }">tt_name=${param.tt_name}</c:when>
							</c:choose>&pstartno=${(i-1)*paging.onepagelimit }">${i}</a></li>
					</c:forEach>
					<c:choose>
						<c:when test="${paging.endBtn!=paging.pageAll }">
							<li><a href="reservation_management.admin?user_name=${param.user_name }&mv_ktitle=${param.mv_ktitle }&tt_name=${param.tt_name }&pstartno=${paging.endBtn*paging.onepagelimit }">Next</a></li>
						</c:when>
					</c:choose>
				</ul>
			</div>
			</div>
			<input type="submit" value="예매 취소" title="예매 취소" style="float: right;" class="btn btn-danger" />
			</fieldset>
			</form>
			
			 
			<div class="inner_search" style="text-align:center; " >		
					<select id="searchOption" class="form-control">
						<option value="user_name">이름</option>
						<option value="mv_ktitle">영화제목</option>
						<option value="tt_name">극장</option>
					</select>
			  		<input class="form-control" type="text" id="query" title="검색어를 입력해주세요" placeholder="검색어를 입력해주세요">
			  		<input class="btn" type="button" value="검색" id="search">  
			</div>
			</div>
		</div>
	
	<script>
		$(function(){
			

			$("#admin_reservationCancelForm").on("submit",function(){
				let cnt=0;
				let checkbox=document.querySelectorAll(".tbody input[type='checkbox']");
				for(let i=0;i<checkbox.length;i++){
					if(checkbox[i].checked){cnt+=1;}
				}
				
				if(cnt==0){alert("취소할 예매를 선택해주세요"); return false;}
				else{let result = confirm('예매를 취소하시겠습니까?');
					if(result!=true){return false;}
				}
				
				
			});
			$("#search").on("click",function(){
				let query=$("#query").val();
				let search=$("#searchOption option:selected").val();
				if(search=='user_name'){location.href=('reservation_management.admin?user_name='+query);}
				else if(search=='mv_ktitle'){location.href=('reservation_management.admin?mv_ktitle='+query);}
				else if(search=='tt_name'){location.href=('reservation_management.admin?tt_name='+query);}			
			});
			$("#query").on("keyup",function(key){
				if(key.keyCode==13){
				let query=$("#query").val();
				let search=$("#searchOption option:selected").val();
				if(search=='user_name'){location.href=('reservation_management.admin?user_name='+query);}
				else if(search=='mv_ktitle'){location.href=('reservation_management.admin?mv_ktitle='+query);}
				else if(search=='tt_name'){location.href=('reservation_management.admin?tt_name='+query);}	
				}
			});
			
		});
	</script>
</main>

<%@ include  file="../../inc/admin_footer.jsp" %>