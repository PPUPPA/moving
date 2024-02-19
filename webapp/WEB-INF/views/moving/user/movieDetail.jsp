<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include  file="../../inc/header.jsp" %>

<c:set var="totalMinutes" value="${dto.mv_runtime}" />
<c:set var="hours" value="${Math.floor(totalMinutes/60).intValue()}" />
<c:set var="minutes" value="${totalMinutes%60}" />
<c:set var="cert" value="${empty dto.mv_cert || dto.mv_cert eq 'All' ? '전체관람가' : dto.mv_cert}" />

    <!-- main -->
    <main id="main" class="main">
      <h2 class="blind">영화 상세 정보</h2>
      <div id="container" class="container is-fullwidth">
        <!-- as_movie-detail -->
        <div class="as_movie-detail">
          <div class="as_movie-detail__summary">
            <div class="inner">
              <div class="as_movie-detail__info">
                <i class="age${empty dto.mv_cert || dto.mv_cert eq 'All' ? 'all' : dto.mv_cert}"></i>
                <h3 class="as_movie-detail__title">${dto.mv_ktitle}</h3>
                <h4 class="as_movie-detail__etitle">${dto.mv_etitle}</h4>
                <div class="etc">
                  <span>
                  <c:choose>
       				<c:when test="${cert eq dto.mv_cert}">
       					${cert}세이상관람가
       				</c:when>
       				<c:otherwise>
       					${cert}
       				</c:otherwise>
      			  </c:choose>
                  </span>
                  <span>${dto.mv_start}</span>
                  <span>${dto.movie_genre}</span>
                  <span>${hours}시간 ${minutes}분</span>
                </div>
              </div>

              <div class="btns">
                <a href="reservation_view.ks?mv_cd=${dto.mv_cd}" class="btn-type0<c:if test="${user_no == null}"> noLoginReservationAccess</c:if>">
                  예매하기
                </a>
              </div>

              <div class="poster">
                <img src="https://image.tmdb.org/t/p/w500${dto.mv_img}" alt="${dto.mv_ktitle} 포스터">
              </div>
            </div>
          </div>

          <div class="as_movie-detail__contents">
            <div class="inner">
              <div class="as_movie-detail__item">
                <div class="col2">
                  <div class="col">
                    <div class="as_movie-detail__name">줄거리</div>
                    <div class="txt as_plot">
                      <pre>${dto.mv_plot}</pre>
                    </div>
                  </div>
                  <div class="col">
                    <div class="as_movie-detail__name">배우/제작진</div>
                    <div class="txt">
                      <dl>
                        <dt>감독</dt>
                        <dd>${dto.mv_dname}</dd>
                      </dl>
                      <dl>
                        <dt>배우</dt>
                        <dd>${dto.mv_aname}</dd>
                      </dl>
                      <dl>
                        <dt>배급사</dt>
                        <dd>${dto.mv_company}</dd>
                      </dl>
                    </div>
                  </div>
                </div>
              </div>

           	  <c:if test="${not empty dto.mv_stilcut}">
	              <div class="as_movie-detail__item">
	                <div class="as_movie-detail__name">스틸컷</div>
	                <div id="stillcut" class="carousel slide" data-ride="carousel">
	                  <!-- Wrapper for slides -->
	                  <div class="carousel-inner">
	                  	<c:forEach var="stilcut" items="${dto.mv_stilcut}" varStatus="status">
	                  	<c:set var="trimmedStilcut" value="${stilcut.trim()}"/>
		                    <div class="item ${status.first?'active':''}">
		                      <img src="https://image.tmdb.org/t/p/w1280${trimmedStilcut}" alt="" />
		                    </div>
						</c:forEach>
	                  </div>
	
	                  <!-- Indicators -->
	                  <ol class="carousel-indicators">
	                  	<c:forEach var="stilcut" items="${dto.mv_stilcut}" varStatus="status">
	                    	<li data-target="#stillcut" data-slide-to="${status.index}" <c:if test="${status.first}">class="active"</c:if>></li>
						</c:forEach>
	                  </ol>
	
	                  <!-- Left and right controls -->
	                  <a class="left carousel-control" href="#stillcut" data-slide="prev">
	                    <span class="glyphicon glyphicon-chevron-left"></span>
	                    <span class="sr-only">이전</span>
	                  </a>
	                  <a class="right carousel-control" href="#stillcut" data-slide="next">
	                    <span class="glyphicon glyphicon-chevron-right"></span>
	                    <span class="sr-only">다음</span>
	                  </a>
	                </div>
	              </div>
	              <!-- // 스틸컷 -->
           	  </c:if>

           	  <c:if test="${not empty dto.mv_video}">
	              <div class="as_movie-detail__item">
	                <div class="as_movie-detail__name">예고편</div>
	
	                <div id="trailer" class="carousel slide" data-ride="carousel">
	                  <!-- Wrapper for slides -->
	                  <div class="carousel-inner">
	                    <div class="item active">
		                    <div class="as_video-wrap">
			                    <iframe frameborder="0" 
								src="https://www.youtube.com/embed/${dto.mv_video}?rel=0&showinfo=0" allow="encrypted-media" allowfullscreen>
								</iframe>
							</div>
	                    </div>
	                  </div>
	                </div>
	              </div>
	              <!-- // 예고편 -->
           	  </c:if>
            </div>
          </div>
        </div>
      </div>
      <!-- // as_movie-detail -->
    </main>
    <!-- //main -->
    
<script>
$(function(){
	// session check
	let noLoginAccessLink = $('.noLoginReservationAccess');
	if (noLoginAccessLink) {
	    noLoginAccessLink.on('click', function(e) {
	        e.preventDefault();
	        let userResponse = confirm('로그인이 필요한 페이지입니다. 로그인하시겠습니까?');
	        if (userResponse) {
	            location.href = "loginPage.ih";
	        }
	    });
	}
});
</script>
<%@ include  file="../../inc/footer.jsp" %>
