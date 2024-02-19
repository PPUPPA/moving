<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../inc/header.jsp"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<main id="container" class="container" style="padding-top: 5%">
	<!-- 영화관 선택 -->
	<div id="theater-selection">
		<div class="theater-list">
			<!-- 좌측 화살표 -->
			<div id="left-arrow" class="arrow">&lt;</div>

			<c:forEach var="the" items="${theaterList}" varStatus="status">
				<div class="theater" data-no="${the.tt_no}"
					data-address="${the.tt_address}" data-tt_name="${the.tt_name}">
					<p>${the.tt_name}</p>
				</div>
			</c:forEach>

			<!-- 우측 화살표 -->
			<div id="right-arrow" class="arrow">&gt;</div>
		</div>
	</div>

	<!-- 영화관 상세 정보 -->
	<div id="theater-info">
		<h2 class="theater-title">
			<!-- 영화관 이름 -->
		</h2>
		<div id="theater-detail">
			<!-- 선택된 영화관의 상세 정보가 여기에 표시됨 -->
			<div class="wrap-theaterinfo">
				<div class="box-image">
					<div id="theater_img_container" class="thumb-image">
						<img src="" alt="">
						<!-- 영화관 이미지 src 추가 영화관 이름 alt 추가-->
					</div>
				</div>

				<div class="box-contents">
					<div class="theater-info">
						<span class="txt-info"> <em> <!-- 영화관 주소 -->
						</em> <em> <!-- 영화관 전화번호 -->
						</em> <em> <!-- 영화관 상영관 갯수 -->
						</em> <em> <!-- 영화관 총좌석 수 -->
						</em>
						</span>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 지도 맵 api -->
	<div id="map" style="width: 80%; height: 350px; margin-left: 120px;"></div>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=36bace44888fe4c171a31d158db75235"></script>

	<script>
		$(document).ready(function(){
			/* 페이지 로드하자마자 제일 첫번째 상영관 지도 보여주기  */
			let firstTT = $('.theater').first();
			let firstAddress = firstTT.data('address');
			let firstTT_name = firstTT.data('tt_name');
			
			$.ajax({
    			url:"ttLocation.hy",
    			type:"POST",
    			dataType: "json", 
    			data: {tt_address : firstAddress},
    			error:function(xhr, status, msg){
				alert("에러");
				},
    			success: function(data){
    				//console.log(data); //{x: '126.941917689273', y: '37.563674036531'}
    				let xValue = data.x;
    		    	let yValue = data.y;
				
    		    	theaterLocation(xValue, yValue, firstTT_name);
    			}
    		}); 
			
			/* 영화관 클릭하면 해당 지도 띄우기 */
			$(".theater").on("click", function(){
				let address = $(this).data('address');
				let tt_name = $(this).data('tt_name');
				//console.log(address);
		
		     	$.ajax({
	    			url:"ttLocation.hy",
	    			type:"POST",
	    			dataType: "json", 
	    			data: {tt_address : address},
	    			error:function(xhr, status, msg){
    				alert("에러");
    				},
	    			success: function(data){
	    				//console.log(data); //{x: '126.941917689273', y: '37.563674036531'}
	    				let xValue = data.x;
	    		    	let yValue = data.y;
						console.log(xValue, yValue);
					
	    		    	theaterLocation(xValue, yValue, tt_name);
	    			}
	    		}); 
			});
		});
		
		function theaterLocation(x, y, theaterName) {
		let mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(y, x), // 지도의 중심좌표
			level : 3
		// 지도의 확대 레벨
		};

		let map = new kakao.maps.Map(mapContainer, mapOption);

		// 마커가 표시될 위치입니다 
		let markerPosition = new kakao.maps.LatLng(y, x);  //# 영화관 y, x

		// 마커를 생성합니다
		let marker = new kakao.maps.Marker({
			position : markerPosition
		});

		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);

		let iwContent = '<div style="text-align:center; font-size:17px">' +theaterName +'<br><a href="https://map.kakao.com/link/to/'+theaterName+',33.450701,126.570667" style="color:red" target="_blank">가는 길 찾기</a></div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
		iwPosition = new kakao.maps.LatLng(y, x); //인포윈도우 표시 위치입니다

		// 인포윈도우를 생성합니다
		let infowindow = new kakao.maps.InfoWindow({
			position : iwPosition,
			content : iwContent
		});

		// 마커 위에 인포윈도우를 표시합니다. 두번째 파라미터인 marker를 넣어주지 않으면 지도 위에 표시됩니다
		infowindow.open(map, marker);
		}
		
	</script>





	<!-- 상영시간표 -->
	<div id="main-schedule">
		<div class="inner">
			<h3 class="h3-sc">상영시간표</h3>
			<!-- 날짜 선택 -->
			<div id="date-list" class="schedule-slider">
				<!-- 7일 동안의 날짜를 나타내는 버튼들이 여기에 표시됨 -->
			</div>

			<div id="movie-schedule" class="schedule-list2">
				<!-- 상영시간표가 여기에 동적으로 추가됨 -->
			</div>
		</div>
	</div>
</main>

<%@ include file="../../inc/footer.jsp"%>

<script>
	$(document)
			.ready(
					function() {
						// 영화관 선택
						let theaters = $('.theater');
						let currentIndex = 0;
						let maxVisibleTheaters = 5;

						// 처음에는 처음 5개의 영화관만 보이도록 설정
						theaters.slice(currentIndex,
								currentIndex + maxVisibleTheaters).show();

						// 왼쪽 화살표 클릭 시 이벤트 처리
						$('#left-arrow').on(
								'click',
								function() {
									if (currentIndex > 0) {
										currentIndex--;
										theaters.hide();
										theaters.slice(
												currentIndex,
												currentIndex
														+ maxVisibleTheaters)
												.show();
									}
								});

						// 오른쪽 화살표 클릭 시 이벤트 처리
						$('#right-arrow').on(
								'click',
								function() {
									if (currentIndex < theaters.length
											- maxVisibleTheaters) {
										currentIndex++;
										theaters.hide();
										theaters.slice(
												currentIndex,
												currentIndex
														+ maxVisibleTheaters)
												.show();
									}
								});

						// 초기에는 첫 번째 영화관을 선택된 상태로 설정
						let selectedTheaterNo = $('.theater').first()
								.data('no');
						updateTheaterDetail(selectedTheaterNo);
						$('.theater').first().addClass('selected');

						// 영화관 선택
						$('.theater').on(
								'click',
								function() {
									/////여기서 지도 보여주기??
									// 기존에 선택된 영화관에서 selected 클래스 제거
									$('.theater.selected').removeClass(
											'selected');

									// 현재 클릭한 영화관에 selected 클래스 추가
									$(this).addClass('selected');

									selectedTheaterNo = $(this).data('no');
									// 영화관 번호를 이용하여 상세 정보 업데이트
									updateTheaterDetail(selectedTheaterNo);

									let selectedDate = $('.date-btn.selected')
											.data('date');
									// 선택된 날짜에 따라 상영시간표 업데이트
									updateMovieSchedule(selectedTheaterNo,
											selectedDate);
								});

						// 날짜 선택
						let dateList = $('#date-list');
						let currentDate = new Date(); // 현재 날짜를 기준으로 설정
						for (let i = 0; i < 7; i++) {
							let date = new Date(currentDate);
							date.setDate(currentDate.getDate() + i);
							let dateString = (date.getMonth() + 1).toString()
									.padStart(2, '0')
									+ '/'
									+ date.getDate().toString()
											.padStart(2, '0');

							// 요일을 가져오는 함수 추가
							function getDayDisplay(dayIndex) {
								if (dayIndex === currentDate.getDay()
										&& i === 0) {
									return '오늘';
								} else {
									let daysOfWeek = [ '일', '월', '화', '수', '목',
											'금', '토' ];
									return daysOfWeek[dayIndex];
								}
							}

							let dayOfWeek = getDayDisplay(date.getDay());

							let button = $('<button class="date-btn">'
									+ dateString + '<br>' + dayOfWeek
									+ '</button>'); // 요일 추가

							if (date.toISOString().split('T')[0] === getCurrentDate()) {
								button.addClass('today');
							}

							if (date.getDay() === 0) {
								button.addClass('sunday');
							} else if (date.getDay() === 6) {
								button.addClass('saturday');
							}
							let dateFormatted = date.getFullYear()
									+ '-'
									+ (date.getMonth() + 1).toString()
											.padStart(2, '0')
									+ '-'
									+ date.getDate().toString()
											.padStart(2, '0');

							button.data('date', dateFormatted); // 2024-01-29
							dateList.append(button);
						}
						// 초기 날짜 설정
						$('.date-btn').first().addClass('selected');

						// 날짜 버튼 클릭 시 이벤트 처리
						dateList.on('click', '.date-btn',
								function() {
									// 기존에 선택된 날짜에서 selected 클래스 제거
									$('.date-btn.selected').removeClass(
											'selected');

									// 현재 클릭한 날짜에 selected 클래스 추가
									$(this).addClass('selected');

									let selectedDate = $(this).data('date');

									// 선택된 날짜에 따라 상영시간표 업데이트
									updateMovieSchedule(selectedTheaterNo,
											selectedDate);
								});

						// 함수 정의: 현재 날짜를 ISO 형식으로 반환
						function getCurrentDate() {
							let currentDate = new Date();
							return currentDate.toISOString().split('T')[0];
						}

						// 초기 상영시간표 업데이트
						updateMovieSchedule(selectedTheaterNo, getCurrentDate());

						// 함수 정의: 선택된 영화관의 상세 정보 업데이트
						function updateTheaterDetail(theaterNo) {
							// 선택된 영화관에 따라 상세 정보를 서버에서 가져와 업데이트하는 로직을 추가
							$
									.ajax({
										url : 'theaterDetail.shj',
										method : 'POST',
										data : {
											tt_no : theaterNo
										},
										dataType : 'json',
										success : function(data) {
											// 서버에서 가져온 데이터를 이용하여 상세 정보 업데이트
											$('#theater-info .theater-title')
													.text(data.tt_name);
											$('#theater_img_container img')
													.attr('src', data.tt_img);
											$('#theater_img_container img')
													.attr('alt', data.tt_name);
											$('.txt-info em:nth-child(1)')
													.text(
															"위치 : "
																	+ data.tt_address);
											$('.txt-info em:nth-child(2)')
													.text(
															"전화번호 : "
																	+ data.tt_tel);
											$('.txt-info em:nth-child(3)')
													.text(
															"상영관 갯수 : "
																	+ data.tt_scrcnt
																	+ "관");
											$('.txt-info em:nth-child(4)')
													.text(
															"총 좌석수 : "
																	+ data.total_st_cnt
																	+ "석");

										},
										error : function(error) {
											console
													.error(
															'Failed to fetch theater information:',
															error);
										}
									});
						}

						// 함수 정의: 상영시간표 업데이트
						function updateMovieSchedule(theaterNo, selectedDate) {
							// 선택된 영화관과 날짜에 따라 상영시간표를 서버에서 가져와 업데이트하는 로직을 추가
							$
									.ajax({
										url : 'scheduleList.shj',
										method : 'GET',
										data : {
											theaterNo : theaterNo,
											date : selectedDate
										},
										dataType : 'json',
										success : function(data) {
											let movieSchedules = data;

											if (movieSchedules.length === 0) {
												// 상영시간표가 없는 경우 메시지를 표시할 영역에 내용을 추가
												$('#movie-schedule')
														.html(
																'<h3 class="no-schedule-message">상영시간표가 없습니다.</h3>');
											} else {
												let scheduleContent = '';

												// 각 영화에 대한 상영일정 생성
												movieSchedules
														.forEach(function(movie) {
															let rating = '';
															if (movie.mv_cert == '12') {
																rating = 'age12';
															} else if (movie.mv_cert == '15') {
																rating = 'age15';
															} else if (movie.mv_cert == '19') {
																rating = 'age19';
															} else if (movie.mv_cert == 'All') {
																rating = 'ageall';
															} else {
																rating = 'agelimit';
															}

															// 영화 제목을 왼쪽에 배치
															scheduleContent += '<div class="section">';
															scheduleContent += '<h3><span><i class="' + rating + '"></i>'
																	+ movie.title
																	+ '</span></h3>';
															scheduleContent += '<div class="article">';

															// 각 상영관에 대한 일정 생성
															let sections = {};
															movie.schedules
																	.forEach(function(
																			schedule) {
																		if (!sections[schedule.section]) {
																			sections[schedule.section] = [];
																		}
																		sections[schedule.section]
																				.push(schedule);
																	});

															// 각 섹션에 대한 일정 생성
															for ( let section in sections) {
																scheduleContent += '<h4>'
																		+ section
																		+ '</h4>';
																scheduleContent += '<ul>';
																sections[section]
																		.forEach(function(
																				schedule) {
																			scheduleContent += '<li>';
																			scheduleContent += '<a href="reservation_view.ks?sch_no='
																					+ schedule.scheduleNo
																					+ '" class="btnTime" >';
																			scheduleContent += '<div class="time"><span>'
																					+ schedule.time
																					+ '</span>~'
																					+ schedule.endTime
																					+ '</div>';
																			scheduleContent += '<div class="length">';
																			scheduleContent += '<p><span>'
																					+ schedule.availableSeats
																					+ '</span>/'
																					+ schedule.totalSeats
																					+ '석</p>';
																			scheduleContent += '</div>';
																			scheduleContent += '</a>';
																			scheduleContent += '</li>';
																		});
																scheduleContent += '</ul>';
															}

															scheduleContent += '</div>';
															scheduleContent += '</div>';
														});

												$('#movie-schedule').html(
														scheduleContent);
											}
										},
										error : function(error) {
											console
													.error(
															'Failed to fetch movie schedule:',
															error);
										}
									});
						}

						// 상영시간표 클릭 시 이벤트 처리
						$('#movie-schedule')
								.on(
										'click',
										'.btnTime',
										function(e) {
											// 세션에서 사용자 번호를 확인
											let userNo = '${sessionScope.user_no}';

											// 사용자 번호가 없는 경우
											if (!userNo) {
												// 확인 창 띄우기
												let confirmed = confirm('로그인이 필요한 페이지입니다. 로그인 하시겠습니까?');
												// 확인 버튼 클릭한 경우
												if (confirmed) {
													// 로그인 페이지로 이동
													window.location.href = 'loginPage.ih'; // 로그인 페이지 URL로 변경
												}
												// 이벤트 중단
												e.preventDefault();
											}
										});
					});
</script>