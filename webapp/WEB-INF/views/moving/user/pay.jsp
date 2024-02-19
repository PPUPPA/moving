<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../inc/header.jsp"%>
<style>
.info,.result{width: 299px;float: left;border: 1px solid #eaeaea; background-color: #f2f2f2;}
.method{width: 600px;float: left;border: 1px solid #eaeaea;background-color: #f2f2f2;}

.icontent h6{font-size: 18px; margin-bottom: 40px;}
.icontent, .mcontent{padding-top: 20px; padding-left: 20px;background-color: white;height: 540px;}
.icontent{height: 480px}
.rcontent{background-color: white;height: 540px;padding-top: 20px;}
.payment{height: 60px}
.icontent dt, .icontent dd{display: inline-block;}
.icontent dt{width:50px; margin-top: 10px}
.btn-payks{width: 100px; height: 100px; border: 1px solid #e1e1e1;}
.mcontent .selected{border:2px solid #35baad; background-color: white !important;}
.icontent img{width: 120px;height: 180px;}
.price{height: 460px; padding-left: 20px;padding-right: 20px;}
.price dt{font-size: 16px;}
.price dd{font-size: 16px; margin-bottom: 10px;}
.resultPrice dt{border-top: 2px solid #eee; padding-top: 10px }
.payBtn{width: 100%; height: 100%; border: 1px solid #eaeaea; background-color: black; color: white; text-align: center !important;
font-size: 20px;}
.resultPrice{margin-top: 30px;}

.
</style>
<!-- main -->
<main id="main" class="main">
	<h2 class="blind">좌석 인원 선택</h2>
	<fmt:parseNumber var="childprice" value="${dto.scr_price/2}" integerOnly="true" />	
	<fmt:parseNumber var="childResult" value="${dto.scr_price*param.child/2}" integerOnly="true" />
	<form action="kakaoPay.ks" method="post" id="payForm">
	<input type="text" class="blind" name="sch_no" value="${param.sch_no}">
	<input type="text" class="blind" name="adult" value="${param.adult}">
	<input type="text" class="blind" name="aprice" value="${dto.scr_price}">
	<input type="text" class="blind" name="child" value="${param.child}">
	<input type="text" class="blind" name="kprice" value="${childprice}">
	<input type="text" class="blind" name="seat" value="<c:forEach var="i" items="${seatList }" varStatus="status">${i },</c:forEach>">
		<div id="pay" class="ks reservation">
			<div class="title">
				<h4>영화 예매</h4>
			</div>
			<div class="content">
				<div class="info">
					<div class="ititle">
						<h5>예매정보</h5>						
					</div>
					<div class="icontent">
						
						<p><img alt="" src="https://image.tmdb.org/t/p/w500${dto.mv_img}"></p>
						<h6>${dto.mv_ktitle }</h6>
						<dl>
							<dt>개봉일</dt>
							<dd>${dto.mv_start }</dd>
						</dl>
						<dl>
							<dt>극장</dt>
							<dd>${dto.tt_name }</dd>
						</dl>
						<dl>
							<dt>인원</dt>
						<c:choose>
						
							
								<c:when test="${param.adult!=0 and param.child==0}">
								<dd>성인 ${param.adult}명</dd>
								</c:when>
								<c:when test="${param.adult==0 and param.child!=0}">
								<dd>청소년 ${param.adult}명</dd>
								</c:when>
								<c:when test="${param.adult!=0 and param.child!=0}">
								<dd>성인 ${param.adult}명, 청소년 ${param.child }명</dd>
								</c:when>
							
							
						
						</c:choose>
						</dl>
						<dl>
							<dt>상영관</dt>
							<dd>${dto.scr_name }</dd>
						</dl>
						<dl>
							<dt>시간</dt>
							<dd>${dto.sch_start }~${dto.sch_end }</dd>
						</dl>
						<dl>
							<dt>좌석</dt>
							<dd>
								<c:forEach var="i" items="${seatList }" varStatus="status">
									<c:choose>
										<c:when test="${status.index==0 }">${i }</c:when>								
									<c:otherwise>,${i }</c:otherwise>
									</c:choose>
								</c:forEach>
							</dd>
						</dl>
						
								
					</div>
					<div>
						<input type="button" class="beforeBtn" value="&lt&lt  이전 화면으로" onclick="history.back();" style="width: 298px">
					</div>
				</div>
				<div class="method">
					<div class="mtitle">
						<h5>결제수단</h5>									
					</div>
					<div class="mcontent">
						<button type="button" class="btn-payks" data-cd="kakaopay" data-msg="">
						<p><img src="https://img.dtryx.com/payment/2022/01/kakaopay.small.png"></p>
						<p>카카오페이</p>
						</button>
					</div>
				</div>
				<div class="result">
					<div class="rtitle">
						<h5>최종결제</h5>									
					</div>
					<div class="rcontent">
						<div class="price">
							
							<c:if test="${param.adult!=0}">
							<dl>
								<dt>성인(${param.adult}명)</dt>
								<dd>${dto.scr_price}원*${param.adult}=${dto.scr_price*param.adult}원</dd>
							</dl>
							</c:if>
							<c:if test="${param.child!=0}">
							<dl>
								<dt>청소년(${param.child}명)</dt>
								<dd>${childprice}원*${param.child}=${childResult}원</dd>
							</dl>
							</c:if>
							<dl class="resultPrice">
								<dt>총 결제금액</dt>
								<dd>${childResult+dto.scr_price*param.adult}원</dd>
							</dl>
						</div>
						<div class="payment">
							
							<input type="submit" class="payBtn" value="결제하기">
						</div>
					</div>
				</div>
				
				
			</div>
			
			
			<script>
			$(function(){
				let seat;
				
				for(let i=0;i<=${fn:length(seatList)};i++){
					console.log("${seatList[i]}");
				}
			
				$(".btn-payks").on("click", function() {
											
						$(this).addClass("selected");
						$("#payForm").attr("action","kakaoPay.ks");
						
						
					
				});
				$("#payForm").on("submit", function() {
					
					
					if($(".btn-payks").attr("class")!="btn-payks selected"){
						alert("결제 수단을 선택해주세요"); return false;
						
					}
					
					
					
				
				});
				
				
				
				
			});
			
			</script>
			


		</div>
	</form>
	<script>
		
	</script>
</main>
<!-- //main -->
<%@ include file="../../inc/footer.jsp"%>