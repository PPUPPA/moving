<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../inc/header.jsp"%>
<style>
	.seatList .seatBtn{border: none;}
	.seatBtn.broken{background-color: crimson; color:white;}
	.seatState{margin-left: 20px;font-size: 18px;}
	.seatState .able{color:white;}
	.seatState .reserved{color: gainsboro;}
	.seatState .broken{color:crimson;}
	
</style>
<!-- main -->
<main id="main" class="main">
	<h2 class="blind">좌석 인원 선택</h2>

	<form action="pay_view.ks" method="post" id="seatForm">
	<input type="text" class="blind" id="sch_no" name="sch_no" value="${param.sch_no}">
	<input type="text" class="blind" id="sch_no" name="adult" value="0">
	<input type="text" class="blind" id="sch_no" name="child" value="0">
		<div id="seat" class="ks reservation "style="height: 720px">
			<div class="title">
				<h4>영화 예매</h4>
			</div>
			<div class="content">
				<div class="people">
					<div>
						<h5>인원 선택</h5>
						<p>최대 각각 8명까지 선택 가능</p>
						
					</div>
					<div class="choice">
						<p>일반</p>
						<ul class="pul">
					<li class="selected"><input type="button" class="adult" value="0" 
						id="adult0"></li>
					<li><input type="button" class="adult" value="1" 
						id="adult1"></li>
					<li><input type="button" class="adult" value="2" 
						id="adult2"></li>
					<li><input type="button" class="adult" value="3" 
						id="adult3"></li>
					<li><input type="button" class="adult" value="4" 
						id="adult4"></li>
					<li><input type="button" class="adult" value="5" 
						id="adult5"></li>
					<li><input type="button" class="adult" value="6" 
						id="adult6"></li>
					<li><input type="button" class="adult" value="7" 
						id="adult7"></li>
					<li><input type="button" class="adult" value="8" 
						id="adult7"></li>	
				
				</ul>
					</div >
					<c:if test="${param.mv_cert!='18' }">
					<div class="choice">
						<p>청소년</p>
						<ul class="pul">
					<li class="selected"><input type="button" class="child" value="0" 
						id="child0"></li>
					<li><input type="button" class="child" value="1" 
						id="child1"></li>
					<li><input type="button" class="child" value="2" 
						id="child2"></li>
					<li><input type="button" class="child" value="3" 
						id="child3"></li>
					<li><input type="button" class="child" value="4" 
						id="child4"></li>
					<li><input type="button" class="child" value="5"
						id="child5"></li>
					<li><input type="button" class="child" value="6" 
						id="child6"></li>
					<li><input type="button" class="child" value="7"
						id="child7"></li>
					<li><input type="button" class="child" value="8"
						id="child8"></li>	
				</ul>
					</div>
					</c:if>
				</div>
				<div class="seat">
					<div class="stitle">
						<h5>좌석 선택</h5>									
					</div>
					<div class="screen">
						<h5>SCREEN</h5>									
					</div>
					<div class="seatList">
						<c:forEach var="i" begin="0" end="${row }" step="1" >
							<ul class="sul">
							<c:forEach var="j" begin="1" end="${col }" step="1" >
								
								<li>
								<label for="${list[i] }${j}" class="seatBtn">${list[i] }${j}</label>
								<input type="checkbox" class="blind checkbox" value="${list[i] }${j}" id="${list[i] }${j}" name="seat_name">
								</li>
							</c:forEach>
							</ul>
						</c:forEach>
					</div>
					<div class="seatState">
						<ul>
							<li class="able">■ : 예매 가능</li>
							<li class="reserved">■ : 예매된 좌석</li>
							<li class="broken">■ : 고장난 좌석</li>
						</ul>
						 
					</div>
				</div>
			</div>
			
			<div class="before">
				<input type="button" class="beforeBtn" value="&lt&lt  이전 화면으로" onclick="history.back();">
				<input type="submit" class="submitBtn" value="결제하러가기">
			</div>
			<c:forEach var="k" items="${brokenSeatList }">
				<script>
				
				$("#${k.bk_st_name }").attr("disabled",true);
				$("#${k.bk_st_name }").prev().addClass("broken");
				$("#${k.bk_st_name }").prev().css({"cursor":"no-drop","pointer-events": "none"})
				
				
				</script>
			</c:forEach>
			  
			<c:forEach var="l" items="${reservedSeatList }">
				<script>
				
				$("#${l.rd_st_name }").attr("disabled",true);
				$("#${l.rd_st_name }").prev().addClass("unable");
				$("#${l.rd_st_name }").prev().css({"pointer-events": "none","cursor":"no-drop"})
				
				
				</script>
			</c:forEach>
			
			<script>
				$(function(){
					
					
					
					
					$(".adult").on("click", function() {
						
						if ($(this).parent().attr("class") == "selected") {
							
						} else {
							$(this).parents("ul").find("li").removeClass("selected");
							$(this).parent().addClass("selected");
						}
						let adult=$(".selected .adult").val();
						let child=$(".selected .child").val();
						let sum=Number(adult)+Number(child);
						let cnt=$(".selected .seatBtn").length;
						$(".seatBtn").parents("ul").find("li").removeClass("selected");
						let checkbox=document.querySelectorAll(".checkbox");
						for(let i=0;i<checkbox.length;i++){
							$(checkbox[i]).prop("checked",false);
						}	
						
						$("input[name='adult']").attr("value",$(this).val());
					});
					$(".child").on("click", function() {
						
						if ($(this).parent().attr("class") == "selected") {
							
							
						} else {
							$(this).parents("ul").find("li").removeClass("selected");
							$(this).parent().addClass("selected");
							$(this).next().prop("checked",true);
						}
						let adult=$(".selected .adult").val();
						let child=0;
						if(${mc_cert!=18}){child=$(".selected .child").val();}
						
						let sum=Number(adult)+Number(child);
						let cnt=$(".selected .seatBtn").length;
						$(".seatBtn").parents("ul").find("li").removeClass("selected");
						let checkbox=document.querySelectorAll(".checkbox");
						for(let i=0;i<checkbox.length;i++){
							$(checkbox[i]).prop("checked",false);
						}
						
						$("input[name='child']").attr("value",$(this).val());
					});
					$(".seatBtn").on("click", function() {
						
						
						if ($(this).parent().attr("class") == "selected") {
							$(this).parent().removeClass("selected");
						} else {						
							$(this).parent().addClass("selected");			
						}
						let adult=$(".selected .adult").val();
						let child=0;
						if($(".selected .child").val()!=null){child=$(".selected .child").val();}
						let sum=Number(adult)+Number(child);
						let cnt=$(".selected .seatBtn").length;
						
						if(adult+child==0){
							alert("인원 수를 선택해주세요.");
							$(this).parent().removeClass("selected");
							$(this).next().prop("checked",true);
							
						}
						
						else if(cnt>sum){
							alert("좌석을 더 많이 고르셨습니다.");
							$(this).parent().removeClass("selected");
							$(this).next().prop("checked",true);
						}
					});
					
					$("#seatForm").on("submit",function(){
						let adult=$(".selected .adult").val();
						let child=0;
						if($(".selected .child").val()!=null){child=$(".selected .child").val();}
						let sum=Number(adult)+Number(child);
						let cnt=$(".selected .seatBtn").length;
						
						
						if(adult+child==0){
							alert("인원 수를 선택해주세요");
							return false;
						}
						if(cnt!=sum){
							alert("좌석을 선택해주세요");
							return false;
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