<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../inc/header.jsp"%>

<style>
.main{overflow: auto;}
.my_reservation {
	width: 1200px;
	height: 600px;
	margin: auto;
	padding-left: 60px;
	padding-right: 60px;
	
	margin-top: 80px;
}

.my_reservation ul {
	border-bottom: 1px solid #eaeaea;
}

.my_reservation li {
	display: inline-block;
	margin-right: 20px;
}

.my_reservation_Btn {
	border: none;
	background-color: white;
	width: 70px;
	height: 50px;
	font-size: 20px;
	font-weight: bold;
}

.my_reservation .selected {
	background-color: white;
	border-bottom: 3px solid #40dfd0;
}

.selected .my_reservation_Btn {
	background: none;
	border: none;
}



.mscontent{
	margin-top: 40px;
}

.my_reservation_info {
	margin:auto;
	margin-top:40px;
	background-color: #fafafa;
	width:980px;
	height: 350px;
	border: 2px solid #eaeaea;
}

.mscount {
	font-size: 16px;
}

.movie_image img {
	width: 200px;
	height: 300px;
	margin-left: 20px;
	margin-top: 20px;
}

.movie_image, .movie_info, .price_info {
	float: left;
	height: 300px;
}

.movie_info {
	padding-left: 30px;
}

.movie_info h6 {
	font-size: 20px;
	margin-bottom: 40px;
	font-weight: bold;
	margin-top: 20px;
}

.my_reservation dt, .my_reservation dd {
	display: inline-block;
	font-size: 16px;
}

.my_reservation dt {
	width: 80px;
	margin-bottom: 30px;
	font-size: 16px;
}

.my_reservation dd {
	width: 150px;
	height: 50px;
}
.price_info > dl{padding-left: 20px;padding-right: 20px;}
.price_info {
	width: 257px;
	height: 348px;
	border-left: 1px solid #eaeaea;
	padding-top: 20px;
}
.price_info dd{
	width: 120px;
}
.price_info .price_result{
	margin-top: 160px;
	padding-top: 5px;
	border-top: 2px solid black;
	margin-left: 5px;
	margin-right: 5px;
}

.reservation_cancel{height: 56px;width: 257px;}
.reservation_cancel .cancelBtn{border: none;background-color:#40dfd0; width: 100%; height: 100%; text-align: center;
font-size: 18px;font-weight: bold;}
</style>



<!-- main -->
<main id="main" class="main">
	<h2 class="blind">예매/취소 내역</h2>
		<div id="my_reservation" class="ks my_reservation">
			<div>
				<ul>
					<li class="selected"><input type="button" value="예매내역"
						class="my_reservation_Btn" onclick="location.href='my_reservation.ks?user_no=${user_no}'"></li>
					<li><input type="button" value="취소내역"
						class="my_reservation_Btn" onclick="location.href='my_canceled_reservation.ks?user_no=${user_no}'"></li>
				</ul>
			</div>
			<div class="mscontent">
				<div class="mscount">${user_nick}님의 관람 가능 내역이 ${list1.size() }건 있습니다.</div>
		

				<c:forEach var="i" items="${list1 }" varStatus="status">
				<div class="my_reservation_info m${status.index }">
					<div class="movie_image">
						<img
							src="https://image.tmdb.org/t/p/w500${i.mv_img}">
					</div>
					<div class="movie_info">
						<h6>${i.mv_ktitle }</h6>
						<dl>
							<dt>예매번호</dt>
							<dd>${i.r_no }</dd>
						</dl>
						<dl>
							<dt>극장</dt>
							<dd>${i.tt_name }</dd>
							<dt>상영관</dt>
							<dd>${i.scr_name }</dd>
						</dl>
						<dl>
							<dt>날짜</dt>
							<dd>${i.sch_date }</dd>
							<dt>시간</dt>
							<dd>${i.sch_start }~${i.sch_end }</dd>
						</dl>
						<dl>
							<dt>인원</dt>
							<dd class="people${status.index }">인원</dd>
							<dt>좌석</dt>
							<dd class="seat${status.index }">좌석</dd>
						</dl>
						<dl>

						</dl>
					</div>
					<div class="price_info">
						
							<dl>
								<dt>티켓 총 개수</dt>
								<dd class="cnt${status.index }">매</dd>
							</dl>
							
							
							
							
							<dl class="price_result">
								<dt>총 결제금액</dt>
								<dd>${i.r_price }원</dd>
							</dl>
							<div class="reservation_cancel">
							
							<input type="button" class="cancelBtn" data-r_no="${i.r_no}" value="예매취소">
						</div>
					</div>
					<script>
						$(function(){
							
							$
							.ajax({
								type : "GET",
								url : "getMyReservationView_2.ks",
								data : {
									r_no : ${i.r_no}
									
								},
								dataType : 'json',
								async : false,
								success : function(data) {
									
									
									let seat="";
									let a=0;
									let k=0;
									let aprice=10000;
									let kprice=5000;
									
									for(let j=0;j<data.length;j++){
										if(data[j].as_code=='A'){a+=1;}
										else if(data[j].as_code=='K'){k+=1;}
										
										
										
									}
									for(let j=0;j<data.length;j++){
										j==0?seat+=data[j].rd_st_name:seat+=", "+data[j].rd_st_name;
										
										
										
									}
									
								
									$(".people${status.index }").html("성인:"+a+"명 "+"청소년:"+k+"명");
									$(".cnt${status.index }").html(data.length+"매");
									$(".seat${status.index }").html(seat);
								},
								error : function(request, status, error) {
									console.log("code: " + request.status)
									console.log("message: " + request.responseText)
									console.log("error: " + error);
								}
							});
							
						
						});
					</script>	
					
				</div>
				</c:forEach>
			</div>


		</div>
	
	<script>
		$(function(){
			$(".cancelBtn").on("click",function(){	
					let result = confirm('예매를 취소하시겠습니까?');
					if(result==true){location.href='reservationcancel.ks?r_no='+$(this).data("r_no")}
					
			});
		});
	</script>
</main>
<!-- //main -->
<%@ include file="../../inc/footer.jsp"%>