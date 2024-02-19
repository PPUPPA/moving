<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../inc/admin_header.jsp" %>

<main id="content">
<div class="page">
   <h2>영화 추가</h2>
   <div class="sub_content">
		<div class="as_inner inner">
		   <div class="as_movie-add">
		      <h3 class="blind">영화 목록</h3>
		      <div class="btns">
		         <button type="button" class="btn btn-success" data-api="loadMovie">국내 상영 영화 전체 불러오기</button>
		      </div>
		
		      <table class="table table-hover as_table as_list-table">
		         <colgroup>
		            <col class="col4">
		            <col class="col4">
		            <col class="col12">
		            <col class="col12">
		            <col class="col8">
		            <col class="col12">
		            <col class="colA">
		         </colgroup>
		         <thead>
		            <tr>
		               <th scope="col"><label><input type="checkbox" value="allChk" class="all-check"></label></th>
		               <th scope="col">No</th>
		               <th scope="col">영화 제목</th>
		               <th scope="col">원제</th>
		               <th scope="col">개봉일</th>
		               <th scope="col">장르</th>
		               <th scope="col">줄거리</th>
		            </tr>
		         </thead>
		         <tbody>
		            <tr>
		               <td colspan="8" class="is-empty">
		                  <p>[국내 상영 영화 전체 불러오기] 버튼을 눌러 현재 상영중인 영화 목록을 불러와주세요.</p>
		               </td>
		            </tr>
		         </tbody>
		      </table>
		
		      <div class="as_inner-footer">
		         <div class="pagination-container"></div>
		
		         <div class="btns">
		            <a href="movie.admin" class="btn btn-danger">영화 목록 페이지로</a>
		            <button type="button" class="btn btn-primary" data-api="addMovie">영화 추가</button>
		         </div>
		      </div>
		   </div>
		</div>
	</div>
</div>
</main>

<script>
   let selectedMovies = [];
   const apiKey = "ce60b5b1079d38fc7f5e7be2b8fdbb7b";
   const accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjZTYwYjViMTA3OWQzOGZjN2Y1ZTdiZTJiOGZkYmI3YiIsInN1YiI6IjY1YTBiZDkwYjY4NmI5MDEzMDZjMjM0ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8MThVHBTPWL6eygKm971SKaug9OSj5OZ1ABbrHKT_IY";

   $(function () {
      // 국내 상영 영화 전체 불러오기
      $("button[data-api='loadMovie']").on("click", function () {
         loadMovies(1); // 첫 번째 페이지 로딩
         $(this).attr("disabled", "disabled");
      });

      // 선택한 영화 저장하기
      $("button[data-api='addMovie']").on("click", function () {
         if (selectedMovies.length > 0) {
            // Promise 배열 생성
            let apiPromises = selectedMovies.map(mv_cd => fetchAndProcessData(mv_cd));

            // Promise.all로 모든 API 호출이 완료될 때까지 기다림
            Promise.all(apiPromises)
               .then(combinedDataArray => {
                  // 모든 데이터를 DB에 저장
                  combinedDataArray.forEach(combinedData => {
                     saveToDatabase(combinedData);
                  });
               })
               .then(() => {
                  alert("선택한 영화를 목록에 추가하였습니다!");
                  $(".as_list-table input[type='checkbox']").prop("checked", false);
                  $("body").scrollTop(0);
               })
               .catch(error => {
                  console.error("Error:", error);
                  alert("API 호출 중 오류가 발생했습니다.");
               });
         } else {
            alert("추가할 영화를 선택해주세요!");
         }
      });

      // 각 API 호출을 Promise로 감싸서 반환하는 함수
      function fetchAndProcessData(mv_cd) {
         return new Promise((resolve, reject) => {
            let movieData, movieReleaseData, movieImagesData, movieVideosData, movieCreditsData;
            const apiUrlBase = "https://api.themoviedb.org/3/movie/";

            // detail api
            let detailApiUrl = apiUrlBase + mv_cd + "?language=ko";
            fetchApi(detailApiUrl, function (detailData) {
               movieData = {
                  mv_cd: detailData.id,
                  mv_ktitle: detailData.title,
                  mv_etitle: detailData.original_title,
                  mv_runtime: detailData.runtime,
                  mv_plot: detailData.overview,
                  movie_genre: detailData.genres.slice(0, 2).map(genre => genre.name).join(", "),
                  mv_nation: detailData.production_countries.map(country => country.name).join(", "),
                  mv_company: detailData.production_companies.slice(0, 4).map(company => company.name).join(", "),
                  mv_img: detailData.poster_path,
                  mv_popularity: detailData.popularity,
               };

               // release date api
               let releaseApiUrl = apiUrlBase + mv_cd + "/release_dates";
               fetchApi(releaseApiUrl, function (releaseData) {
                  let movieInfo = releaseData.results.find(item => item.iso_3166_1 === "KR");
                  movieReleaseData = {};

                  if (movieInfo) {
                     let releaseInfo = movieInfo.release_dates.find(item => item.certification !== "");
                     if (releaseInfo) {
                        movieReleaseData.mv_cert = releaseInfo.certification;
                        movieReleaseData.mv_start = releaseInfo.release_date.split('T')[0];
                     }
                  }

                  // images api
                  let imagesApiUrl = apiUrlBase + mv_cd + "/images?include_image_language=ko%2Cnull";
                  const maxImages = 7;
                  fetchApi(imagesApiUrl, function (imagesData) {
                     movieImagesData = {
                        mv_stilcut: imagesData.backdrops.slice(0, maxImages).map(img => img.file_path).join(","),
                     };

                     // videos api
                     let videosApiUrl = apiUrlBase + mv_cd + "/videos?language=ko";
                     fetchApi(videosApiUrl, function (videosData) {
                        let videoInfo = videosData.results.find(item => item.site == "YouTube" && (item.type == "Trailer" || item.type == "Teaser"));
                        movieVideosData = {};

                        if (videoInfo) {
                           movieVideosData.mv_video = videoInfo.key;
                        }

                        // credits api
                        let creditsApiUrl = apiUrlBase + mv_cd + "/credits?language=ko";
                        fetchApi(creditsApiUrl, function (creditsData) {
                           const director = creditsData.crew.find(item => item.job === "Director");
                           movieCreditsData = {
                              mv_aname: creditsData.cast.filter(item => item.known_for_department === "Acting").slice(0, 4).map(actor => actor.name).join(", ") + " 外",
                              mv_dname: director ? director.name : null
                           };

                           // 결과를 합쳐서 resolve로 반환
                           let combinedData = {
                              ...movieData,
                              ...movieReleaseData,
                              ...movieImagesData,
                              ...movieVideosData,
                              ...movieCreditsData,
                           };
                           resolve(combinedData);
                        });
                     });
                  });
               });
            });
         });
      }

      // 각 API 호출 함수
      function fetchApi(apiUrl, processData) {
         return $.ajax({
            type: "GET",
            url: apiUrl,
            data: {
               api_key: apiKey,
               // language: "ko",
               region: "kr",
            },
            beforeSend: function (xhr) {
               xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
               xhr.setRequestHeader("Authorization", "Bearer " + accessToken);
               xhr.setRequestHeader("accept", "application/json");
            },
            async: true,
            error: function (xhr, status, msg) {
               reject(status + "/" + msg);
            },
            dataType: "json",
            success: processData, // 결과 처리 콜백 함수
         });
      }

      // 이미 저장된 mv_cd 값인지 확인하는 함수
      function isMvCdExists(mv_cd) {
         return $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/apiCheckMvCd.admin",
            data: {
               mv_cd: mv_cd
            },
            dataType: "json",
            success: function (result) {
               return result;
            },
            error: function (xhr, status, msg) {
               console.log(status + "/" + msg);
            }
         });
      }

      // DB에 저장
      async function saveToDatabase(movieData) {
         // 이미 저장된 mv_cd 값인지 확인
         const isExists = await isMvCdExists(movieData.mv_cd);

         if (isExists) {
            console.log(movieData.mv_ktitle + "은 이미 추가된 영화입니다. 수정이 필요한 경우 [영화 목록]-[상세]에서 수정해주세요.");
            return;
         }

         $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "${pageContext.request.contextPath}/apiMovieAdd.admin",
            data: JSON.stringify(movieData),
            success: function (data) {
               console.log('Success:', data);
            },
            error: function (xhr, status, msg) {
               alert(status + "/" + msg);
            }
         });
      }

      // checkbox
      $(document).on("change", ".as_list-table input[type='checkbox']", function () {
         let totalCheckboxes = $('.as_list-table input[type="checkbox"]:not(.all-check)').length;
         let checkedCheckboxes = $('.as_list-table input[type="checkbox"]:checked:not(.all-check)').length;

         // 모든 하위 체크박스가 체크되어 있으면 .all-check도 체크
         $('.as_list-table .all-check').prop('checked', totalCheckboxes === checkedCheckboxes);

         updateSelectedMovies(); // 체크박스 상태가 변할 때마다 호출
      });

      // allchk
      $('.as_list-table .all-check').change(function () {
         let isChecked = $(this).prop('checked');

         // .as_list-table 내 하위 체크박스 상태를 .all-check 와 맞춤
         $('.as_list-table input[type="checkbox"]').prop('checked', isChecked);
      });
   });

   // 국내 상영 영화 전체 불러오기
   function loadMovies(page) {
      let apiUrl = "https://api.themoviedb.org/3/movie/now_playing?language=ko&region=kr";
      let itemsPerPage = 20;

      $("body").scrollTop(0);
      $('.as_list-table .all-check').prop('checked', false);

      // API 호출 함수
      function fetchMovies() {
         return $.ajax({
            type: "GET",
            url: apiUrl,
            data: {
               api_key: apiKey,
               page: page,
            },
            beforeSend: function (xhr) {
               xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
               xhr.setRequestHeader("Authorization", "Bearer " + accessToken);
               xhr.setRequestHeader("accept", "application/json");
            },
            async: true,
            error: function (xhr, status, msg) {
               alert(status + "/" + msg);
            },
            dataType: "json"
         });
      }

      fetchMovies().done(function (data) {
         let totalPages = data.total_pages;
         let movies = data.results.slice(0, itemsPerPage); // 한 페이지에 표시할 개수만큼 잘라냄
         displayMovies(movies, page, itemsPerPage);

         // 페이징 처리
         if (totalPages > 1) {
            addPagination(totalPages, page);
         }
      });
   }

   // 장르 정보 매핑
   function mapGenre(genreIds) {
      const genreMap = {
         28: "액션",
         12: "모험",
         16: "애니메이션",
         35: "코미디",
         80: "범죄",
         99: "다큐멘터리",
         18: "드라마",
         10751: "가족",
         14: "판타지",
         36: "역사",
         27: "공포",
         10402: "음악",
         9648: "미스터리",
         10749: "로맨스",
         878: "SF",
         10770: "TV 영화",
         53: "스릴러",
         10752: "전쟁",
         37: "서부"
      };

      return genreIds.map(id => genreMap[id]).join(", ");
   }

   // 영화 목록 출력
   function displayMovies(movies, page, itemsPerPage) {
      $(".as_list-table tbody").empty();

      $.each(movies, function (index, movie) {
         let mv_cd = movie.id;
         let mv_ktitle = movie.title;
         let mv_etitle = movie.original_title;
         let mv_start = movie.release_date;
         let movie_genre = mapGenre(movie.genre_ids); // 배열을 문자열로 변환
         let mv_plot = movie.overview;

         let chkbox = "<label><input type='checkbox' value='" + mv_cd + "'></label>";

         let displayIndex = (page - 1) * itemsPerPage + index + 1;

         $("<tr>")
            .append($("<td>").html(chkbox))
            .append($("<td>").html(displayIndex))
            .append($("<td>").html(mv_ktitle))
            .append($("<td>").html(mv_etitle))
            .append($("<td>").html(mv_start))
            .append($("<td>").html(movie_genre))
            .append($("<td class='as_plot'>").html(mv_plot))
            .appendTo(".as_list-table tbody");
      });

      // 현재 페이지의 체크박스 상태를 전역 변수에 저장
      updateSelectedMovies();
   }

   // 선택한 영화들을 저장하는 함수
   function updateSelectedMovies() {
      selectedMovies = [];

      $(".as_list-table input[type='checkbox']:checked").each(function () {
         let value = $(this).val();

         if (value == 'allChk') {
            return;
         } else {
            selectedMovies.push(value);
         }
      });
   }

   // 페이징
   function addPagination(totalPages, currentPage) {
      let paginationHtml = "<ul class='pagination'>";
      for (let i = 1; i <= totalPages; i++) {
         let activeClass = (i === currentPage) ? "active" : "";
         paginationHtml += "<li class='page-item " + activeClass + "'><a class='page-link' href='javascript:void(0)' onclick='loadMovies(" + i + ")'>" + i + "</a></li>";
      }
      paginationHtml += "</ul>";

      $(".pagination-container").html(paginationHtml);
   }
</script>

<%@ include file="../../inc/admin_footer.jsp" %>