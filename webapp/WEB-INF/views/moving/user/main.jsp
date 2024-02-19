<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include  file="../../inc/header.jsp" %>
<style>
.mic {
	width: 60px;
	height: 60px;
	
	position: fixed;
	right: 5%;
	bottom: 5%;
}
.mic.selected img{
	border: 2px solid red;
	border-radius:100%;
}
.mic:hover{
	cursor: pointer;
}
.mic img {
	width: 60px;
	height: 60px;
	border: 2px solid black;
	border-radius:100%;
}
</style>

    <!-- main -->
    <main id="main" class="main">
      <h2 class="blind">메인 컨텐츠</h2>
      <div id="container" class="container">

        <div class="as_main-visual">
          <c:choose>
          <c:when test="${randomMovie != null}">
	          <a href="movieDetail.as?mv_cd=${randomMovie.mv_cd}" title="영화 상세 페이지로 이동">
	            <figure class="as_main-visual__video-wrap">
	            	<c:choose>
	            		<c:when test="${not empty randomMovie.mv_stilcut}">
			              <img src="https://image.tmdb.org/t/p/original${firstImageUrl}" alt="" class="as_main-visual__img" />            		
	            		</c:when>
	            		<c:otherwise>
			              <img src="https://image.tmdb.org/t/p/original${randomMovie.mv_img}" alt="" class="as_main-visual__img" />            		
	            		</c:otherwise>
	            	</c:choose>
	            	<div id="main-visual_video-wrap" class="as_video-wrap">
	                    <div id="main-visual_video" class="as_main-visual__video"></div>
					</div>
	              <figcaption class="blind">${randomMovie.mv_ktitle} 트레일러</figcaption>
	            </figure>
	          </a>
          </c:when>
          <c:otherwise>
          	<div class="is-empty">
          		<p>상영중인 영화가 없어 트레일러를 제공할 수 없습니다.</p>
          	</div>
          </c:otherwise>
          </c:choose>
        </div>

        <div class="as_top10">
          <h2 class="as_top10__title">
            영화 TOP10
            <a href="movie.as" class="btn-more"><span class="blind">더보기</span></a>
          </h2>
          <div class="movie-list slider-type1">
			<c:choose>
				<c:when test="${list.size() > 0}">
	            <ul>
				  <c:forEach var="dto" items="${list}" end="9" varStatus="status">
		              <li>
		                <div class="item">
		                  <figure class="thumb__wrap">
		                  	<div class="thumb">
			                    <div class="thumb__img">
			                      <img src="https://image.tmdb.org/t/p/w500${dto.mv_img}" alt="${dto.mv_ktitle} 포스터">
			                      <span class="target"><i class="age${empty dto.mv_cert || dto.mv_cert eq 'All' ? 'all' : dto.mv_cert}"></i></span>
			                      <span class="rank rank${status.index+1}"></span>
			                    </div>
			                    <div class="btns">
			                      <a href="movieDetail.as?mv_cd=${dto.mv_cd}" class="b1">영화정보</a>
			                      <a href="reservation_view.ks?mv_cd=${dto.mv_cd}" class="b2<c:if test="${user_no == null}"> noLoginReservationAccess</c:if>">예매하기</a>
			                    </div>
		                    </div>
			                <figcaption class="info">
			                  <div class="subj">${dto.mv_ktitle}</div>
			                </figcaption>
		                  </figure>
		                </div>
		              </li>
	               </c:forEach>
	            </ul>
				</c:when>
				<c:otherwise>
					<div class="is-empty">
						<p>상영중인 영화가 없습니다.</p>
					</div>
				</c:otherwise>
			</c:choose>
          </div>
        </div>

        <div class="as_weather">
          <div class="as_weater__header">
	          <h2 class="as_weather__title">
	             <i class="as_weather__icon"></i>
				 <span class="as_weather__msg"><span>🎞</span>오늘, 이런 영화 어때요?<span class='is-unknown'>(날씨 권한 허용 시, 날씨에 따른 장르가 추천됩니다!)</span></span>
	          </h2>
          </div>
          <div class="movie-list slider-type1">
			<div class="is-empty">
				<p>날씨 권한이 없습니다.</p>
			</div>
          </div>
        </div>

      </div>
    </main>
    <!-- //main -->
    
<div class="mic">
	<img
		src="${pageContext.request.contextPath}/resources/assets/images/common/mic.jpg"
		alt="음성인식" />
</div>
<script>
$(function(){
	// session check
	let noLoginAccessLink = $('.noLoginReservationAccess');
	if (noLoginAccessLink) {
	    noLoginAccessLink.on('click', function(e) {
	    	sesseionCheck(e);
	    });
	};
	
	$("#main-visual_video").YTPlayer({
		videoURL:"${randomMovie.mv_video}",
		containment:'#main-visual_video-wrap',
		autoPlay:false,
		mute:true,
		startAt:0,
		opacity:1,
		loop:true,
		showControls:false,
		useOnMobile:true,
		stopMovieOnBlur:false,
		abundance: 0,
		showYTLogo: false
	});

	// main visual
	$(".as_main-visual__video-wrap").on("mouseover", function(){
		$(this).addClass("is-play");
		$(".as_main-visual__img").stop().hide();
		$("#main-visual_video").YTPPlay();
	});
	$(".as_main-visual__video-wrap").on("mouseout", function(){
		$(this).removeClass("is-play");
		$(".as_main-visual__img").stop().show();
		$("#main-visual_video").YTPPause();
	});
	
	// weater
	const API_KEY = "77372593c64fd4bc7644ca522fef0878";
    let weather = "<span>🎞</span>";
    let weatherMsg = "오늘, 이런 영화 어때요?";

	function onGeoOk(position) {
	  const lat = position.coords.latitude;
	  const lon = position.coords.longitude;
	  const url = "https://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&appid="+API_KEY+"&lang=kr&units=metric";
	
	  $.ajax({
	    url: url,
	    method: 'GET',
	    dataType: 'json',
	    success: function (data) {
	      const iconSrc = "https://openweathermap.org/img/wn/"+data.weather[0].icon+"@2x.png";
	      const weatherDesc = data.weather[0].description;
	      const id = data.weather[0].id;
	      const idCategory = Math.floor(id / 100);
	      let recGenre = ["액션", "모험", "애니메이션", "코미디", "가족", "음악"];
		  let weatherGenre = {weatherId: id, genres: recGenre};

	      if (id === 800) {
	    	// 800: Clear
	    	weatherMsg = "햇살 쨍쨍 맑은 "+weatherMsg;
	    	recGenre = ["액션", "모험", "애니메이션", "코미디", "가족", "음악"];
	      } else if (idCategory === 2) {
	        // 2xx: Thunderstorm
	    	weatherMsg = "천둥 치는 "+weatherMsg;
	    	recGenre = ["범죄", "액션", "공포", "스릴러", "미스터리", "전쟁"];
	      } else if (idCategory === 3) {
	        // 3xx: Drizzle
	    	weatherMsg = "이슬비 내리는 "+weatherMsg;
	    	recGenre = ["판타지", "애니메이션", "범죄", "드라마", "역사", "음악"];
	      } else if (idCategory === 5) {
	        // 5xx: Rain
	    	weatherMsg = "추적추적 비 내리는 "+weatherMsg;
	    	recGenre = ["공포", "범죄", "스릴러", "미스터리", "액션", "다큐멘터리"];
	      } else if (idCategory === 6) {
	        // 6xx: Snow
	    	weatherMsg = "눈 내리는 "+weatherMsg;
	    	recGenre = ["애니메이션", "드라마", "로맨스", "음악", "판타지", "다큐멘터리"];
	      } else if (idCategory === 7) {
	        // 7xx: Atmosphere
	    	weatherMsg = "뿌연 안개 낀 "+weatherMsg;
	    	recGenre = ["미스터리", "판타지", "역사", "SF", "TV 영화", "서부"];
	      } else if (idCategory === 8) {
	        // 8xx: Clouds
	    	weatherMsg = "구름 많은 "+weatherMsg;
	    	recGenre = ["스릴러", "미스터리", "범죄", "역사", "SF", "음악"];
	      }

	      weatherGenre.genres = recGenre;

	      $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "${pageContext.request.contextPath}/sendWeatherGenre.as",
            data: JSON.stringify(weatherGenre),
            dataType: "json",
            success: function(data) {
            	let container = $('.as_weather .movie-list');
            	
            	container.empty();
		        if (data.length > 0) {
		            let movieListHtml = '<ul>';
		            $.each(data, function(index, dto) {
		                movieListHtml += '<li><div class="item"><figure class="thumb__wrap"><div class="thumb"><div class="thumb__img">';
		                movieListHtml += '<img src="https://image.tmdb.org/t/p/w500' + dto.mv_img + '" alt="' + dto.mv_ktitle + ' 포스터">';
		                movieListHtml += '<span class="target"><i class="age' + (dto.mv_cert == null || dto.mv_cert == 'All' ? 'all' : dto.mv_cert) + '"></i></span></div>';
		                movieListHtml += '<div class="btns"><a href="movieDetail.as?mv_cd=' + dto.mv_cd + '" class="b1">영화정보</a>';
		                movieListHtml += '<button type="button" onclick="weaterSessionCheck(this);" data-mvID="' + dto.mv_cd + '" class="b2 as_weather_btn--reservation">예매하기</a></div></div>';
		                movieListHtml += '<figcaption class="info"><div class="subj">' + dto.mv_ktitle + '</div></figcaption></figure></div></li>';
		            });
		            movieListHtml += '</ul>';
		            
		            container.html(movieListHtml);
		        } else {
		        	container.html('<div class="is-empty"><p>상영중인 영화가 없습니다.</p></div>');
		        }
            },
            error: function(xhr, status, error) {
              console.error("Failed to send weather data to server:", error);
            }
          });
	      
		  weather="<img class='icon' src='"+iconSrc+"' alt='"+weatherDesc+"' />";		  
		  $(".as_weather__icon").append(weather);
    	  $(".as_weather__msg").text(weatherMsg);
	    },
	    error: function () {
    	  $(".as_weather__icon").append(weather);
    	  $(".as_weather__msg").text(weatherMsg);
	    }
	  });
	}
	
	function onGeoError() {
		$(".as_weather__icon, .as_weather .is-unknown").remove();
		$(".as_weather__icon").append(weather);
		$(".as_weather__title").append("<span class='is-unknown'>(날씨 권한 허용 시, 날씨에 따른 장르가 추천됩니다!)</span>")
	}
	
	navigator.geolocation.getCurrentPosition(onGeoOk, onGeoError);
	
	// 음성인식
	 let audioRecorder;

     function recordStart() {
         // getUserMedia로 오디오 스트림(나의 음성) 가져오기
         navigator.mediaDevices.getUserMedia({ audio: true })
             .then(function (stream) {

                 // 오디오 스트림을 녹음하기 위한 RecordRTC 객체 생성
                 audioRecorder = RecordRTC(stream, {
                     type: 'audio',
                     mimeType: 'audio/raw',
                     recorderType: StereoAudioRecorder,
                     // mono
                     numberOfAudioChannels: 1,
                     desiredSampRate: 16000,
                     bufferSize: 16384,
                 });

                 // 녹음 시작
                 audioRecorder.startRecording();
             })
             .catch(function (error) {
                 console.error('getUserMedia error:', error);
             });
     }

     function recordStop() {
         audioRecorder.stopRecording(function () {
             let audioBlob = audioRecorder.getBlob();
             let file=new File([audioBlob], "file", {type: audioBlob.type});
             const formData = new FormData();
			  formData.append('file', file);
             $
				.ajax({
					type : "POST",
					url : "stt.ks",
					data : formData,
					dataType : 'json',
					contentType: false,
					//contentType: false,
					processData: false,
					async : false,
					success : function(data) {
						console.log(data);
						let result = data.return_object.recognized;
						if (result.includes("예매")) {
							if(${user_no!=null}){location.href='reservation_view.ks';}
							else{
								let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
		         	            if (userResponse) {
		         	            	location.href='loginPage.ih';
		         	            }
							}
							
						} else if (result.includes("영화관")) {
							location.href='theater_user_view.shj';			
						} else if (result.includes("영화")) {				
							location.href='movie.as';			
						}  else if (result.includes("공지사항")) {
							location.href='notice.as';			
						} else if (result.includes("로그인")) {
							location.href='loginPage.ih';			
						} else if (result.includes("회원 가입")) {
							location.href='joinForm.ih';			
						} else if (result.includes("로그아웃")) {
							location.href='logout.ih';			
						}
						else {
							alert("다시 말해주세요");
						}
					},
					error : function(request, status, error) {
						console.log("code: " + request.status)
						console.log("message: " + request.responseText)
						console.log("error: " + error);
					}
				});
         });
     }
	
	// 음성인식
	$(".mic").on("click", function() {
		if($(this).attr("class")=="mic"){
			$(this).addClass("selected");
			recordStart();
		}
		else{
			$(this).removeClass("selected");
			recordStop();
		}
		
		
		/*
		$.ajax({
			type : "GET",
			url : "stt.ks",
			dataType : 'json',
			async : false,
			success : function(data) {
				
				let result = data.return_object.recognized;

				if (result.includes("예매")) {
					if(${user_no!=null}){location.href='reservation_view.ks';}
					else{
						let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
         	            if (userResponse) {
         	            	location.href='loginPage.ih';
         	            }
					}
					
				} else if (result.includes("영화관")) {
					location.href='theater_user_view.shj';			
				} else if (result.includes("영화")) {				
					location.href='movie.as';			
				}  else if (result.includes("공지사항")) {
					location.href='notice.as';			
				} else if (result.includes("로그인")) {
					location.href='loginPage.ih';			
				} else if (result.includes("회원 가입")) {
					location.href='joinForm.ih';			
				} else if (result.includes("로그아웃")) {
					location.href='logout.ih';			
				}
				else {
					alert("다시 말해주세요");
				}

			},
			error : function(request, status, error) {
				console.log("code: " + request.status)
				console.log("message: " + request.responseText)
				console.log("error: " + error);
			}
		});
		*/
	});
});

function sesseionCheck(e){
    e.preventDefault();
    let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
    if (userResponse) {
        location.href = "loginPage.ih";
    }
}

function weaterSessionCheck(e){
	const userId = "<%=(String)session.getAttribute("user_id")%>";
	const mvId = $(e).attr('data-mvID');
	if(userId == "null") {
		let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
	    if (userResponse) {
	        location.href = "loginPage.ih";
	    }
	} else {
		location.href="reservation_view.ks?mv_cd=" + mvId;
	}
}
</script>
    
<%@ include  file="../../inc/footer.jsp" %>
