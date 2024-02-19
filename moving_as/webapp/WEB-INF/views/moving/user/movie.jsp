<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include  file="../../inc/header.jsp" %>

    <!-- main -->
    <main id="main" class="main">
      <h2 class="blind">영화 리스트</h2>
      <div id="container" class="container">
        <div class="as_movie-list">
          <div class="tabs1 type2">
            <span class="tabs1__item is-active">일반영화</span>

            <div class="search">
              <input type="text" id="srchMovie" class="inp-mv" placeholder="영화명을 입력해주세요.">
              <button class="btn-del" style="display: none;">삭제</button>
              <button class="btn-srch">검색</button>
            </div>
          </div>

          <div class="sorting">
            <button type="button" class="is-active" data-sort="byPopular">인기순</button>
            <button type="button" data-sort="byTitle">가나다순</button>
          </div>

          <div class="movie-list slider-type1">
           	<c:choose>
			   <c:when test="${list.size() > 0}">
			   <ul>
				   <c:forEach var="dto" items="${list}" varStatus="status">
		              <li>
		                <div class="item">
		                  <figure class="thumb__wrap">
		                  	<div class="thumb">
			                    <div class="thumb__img">
			                      <img src="https://image.tmdb.org/t/p/w500${dto.mv_img}" alt="${dto.mv_ktitle} 포스터">
			                      <span class="target"><i class="age${empty dto.mv_cert || dto.mv_cert eq 'All' ? 'all' : dto.mv_cert}"></i></span>
			                    </div>
			                    <div class="btns">
			                      <a href="movieDetail.as?mv_cd=${dto.mv_cd}" class="b1">영화정보</a>
			                      <a href="reservation_view.ks?mv_cd=${dto.mv_cd}" class="b2<c:if test="${user_no == null}"> noLoginReservationAccess</c:if>">예매하기</a>
			                    </div>
		                    </div>
			                <figcaption class="info">
			                	<span class="blind popularity">${dto.mv_popularity}</span>
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
      </div>
    </main>
    <!-- //main -->
    
    <script>
	const movieList = $(".movie-list ul");
	const movieItems = movieList.children("li");
	let originalMovieList = movieList.clone();
	
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
    	
      	$(".sorting button").on("click", function(){
      		let sortBy = $(this).attr("data-sort");
      		$(".sorting button").removeClass("is-active");
      		$(this).addClass("is-active");
      		
      		sortMovie(sortBy);
      		originalMovieList = movieList.clone();
      	});
      	
      	$("#srchMovie").on("input", function(){
      		let keyword = $(this).val().toLowerCase();
      		
      		if (keyword.trim() === "") {
                movieList.html(originalMovieList.html());
            } else {
                // 검색어가 있는 경우, 해당 검색어로 필터링
                let schList = $();

                movieItems.each(function() {
                    const subj = $(this).find('.subj').text().toLowerCase();
                    if (subj.indexOf(keyword) > -1) {
                        schList = schList.add($(this));
                    }
                });

                movieList.html(schList);
            }

            movieList.html(schList);
      	});
    });
    
    function sortMovie(sortType) {
    	
    	switch (sortType) {
    	case 'byPopular':
    		movieItems.sort((a,b) => {
    			const popularA = parseFloat($(a).find('.popularity').text());
    			const popularB = parseFloat($(b).find('.popularity').text());
    			return popularB - popularA;
    		});
    		break;
    	case 'byTitle':
    		movieItems.sort((a,b) => {
    			const titleA = $(a).find('.subj').text();
    			const titleB = $(b).find('.subj').text();
    			return titleA.localeCompare(titleB);
    		});
    		break;
    	}
    	
    	movieList.html(movieItems);
    }
    </script>

<%@ include  file="../../inc/footer.jsp" %>
