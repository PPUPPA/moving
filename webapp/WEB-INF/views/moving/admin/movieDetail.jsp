<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../inc/admin_header.jsp" %>

<c:set var="totalMinutes" value="${dto.mv_runtime}" />
<c:set var="hours" value="${Math.floor(totalMinutes/60).intValue()}" />
<c:set var="minutes" value="${totalMinutes%60}" />
<c:set var="cert" value="${empty dto.mv_cert || dto.mv_cert eq 'All' ? '전체관람가' : dto.mv_cert}" />
<c:set var="liveState" value="${dto.mv_live?'상영중':'상영 중지'}" />

<main id="content">
<div class="page">
   <h2>영화 상세</h2>
   <div class="sub_content">
	<div class="as_inner inner">
	   <div class="as_movie-list">
	        <h3 class="blind">${dto.mv_ktitle} 상세 정보</h3>
	        <table class="table as_detail-table">
	           <colgroup>
	              <col class="col8">
	              <col class="col16">
	              <col class="col8">
	              <col class="col12">
	              <col class="col8">
	              <col class="col12">
	              <col class="col8">
	              <col class="col12">
	              <col class="col8">
	              <col class="col8">
	           </colgroup>
	           <tbody>
	           	<tr>
	           		<th scope="row">영화 제목</th>
	           		<td colspan="9">${dto.mv_ktitle}</td>
	           	</tr>
	           	<tr>
	           		<th scope="row">원제</th>
	           		<td colspan="9">${dto.mv_etitle}</td>
	           	</tr>
	           	<tr>
	           		<th scope="row">국가</th>
	           		<td>${dto.mv_nation}</td>
	           		<th scope="row">감독</th>
	           		<td>${dto.mv_dname}</td>
	           		<th scope="row">장르</th>
	           		<td>${dto.movie_genre}</td>
	           		<th scope="row">관람등급</th>
	           		<td>
	           			<c:choose>
	           				<c:when test="${cert eq dto.mv_cert}">
	           					${cert}세이상관람가
	           				</c:when>
	           				<c:otherwise>
	           					${cert}
	           				</c:otherwise>
	           			</c:choose>
	           		</td>
	           		<th scope="row">개봉일</th>
	           		<td>${dto.mv_start}</td>
	           	</tr>
	           	<tr>
	           		<th scope="row">상영 시간</th>
	           		<td>${hours}시간 ${minutes}분</td>
	           		<th scope="row">인기도</th>
	           		<td>${dto.mv_popularity}</td>
	           		<th scope="row">상영 상태</th>
	           		<td>${liveState}</td>
	           		<th scope="row">배급사</th>
	           		<td colspan="3">${dto.mv_company}</td>
	           	</tr>
	           	<tr>
	           		<th scope="row">출연 배우</th>
	           		<td colspan="9">${dto.mv_aname}</td>
	           	</tr>
	           	<tr>
	           		<th scope="col" colspan="10">줄거리</th>
	           	</tr>
	           	<tr>
	           		<td colspan="10" class="as_plot">
	            		<pre>${dto.mv_plot}</pre>
				    </td>
	           	</tr>
	           	<tr>
	           		<th scope="row">포스터</th>
	           		<td>
	           			<c:choose>
	           				<c:when test="${dto.mv_img==null}">
	            				없음
	            			</c:when>
	            			<c:otherwise>
		            			<a href="https://image.tmdb.org/t/p/original${dto.mv_img}" target="_blank" title="새창에서 보기">🔗poster</a>
	            			</c:otherwise>
	           			</c:choose>
	           		</td>
	           		<th scope="row">영상</th>
	           		<td>
	           			<c:choose>
	           				<c:when test="${dto.mv_video==null}">
	            				없음
	            			</c:when>
	            			<c:otherwise>
		            			<a href="https://www.youtube.com/watch?v=${dto.mv_video}" target="_blank" title="새창에서 보기">🔗video</a>
	            			</c:otherwise>
	           			</c:choose>
	           		</td>
	           		<th scope="row">스틸컷</th>
	           		<td colspan="5">
	           			<c:choose>
	           				<c:when test="${empty dto.mv_stilcut}">
	            				없음
	            			</c:when>
	            			<c:otherwise>
		            			<c:forEach var="stilcut" items="${dto.mv_stilcut}" varStatus="status">
		                  		<c:set var="trimmedStilcut" value="${stilcut.trim()}"/>
								    <a href="https://image.tmdb.org/t/p/original${trimmedStilcut}" target="_blank" title="새창에서 보기">🔗stil${status.index + 1}</a>
								</c:forEach>
	            			</c:otherwise>
	           			</c:choose>
	       			</td>
	           	</tr>
	           </tbody>
	        </table>
	
	      <div class="as_inner-footer">
	         <div class="btns">
	            <a href="movieUpdate.admin?mv_cd=${dto.mv_cd}" class="btn btn-danger">내용 수정</a>
	            <a href="movie.admin" class="btn btn-primary">목록으로</a>
	         </div>
	      </div>
	   </div>
	</div>
</div>
</div>
</main>

<%@ include file="../../inc/admin_footer.jsp" %>