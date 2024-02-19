package com.company.dao;

import java.util.List;
import java.util.Map;

import com.company.dto.MovieDto;

@MyDao
public interface MovieDao {
	public int mv_insert(MovieDto dto);
	public int mv_update(MovieDto dto);
	public int mv_changeState(MovieDto dto);
	
	public MovieDto mv_read(int mv_cd);
	public List<MovieDto> mv_readLive();
	public List<MovieDto> mv_readUnlive();
	
	public int mv_totalLive(); // 상영중 영화 전체 갯수
	public int mv_totalUnlive(); // 상영 중지 영화 전체 갯수
	public <T> List<MovieDto> mv_cntLive(Map<String, T> param);
	public <T> List<MovieDto> mv_cntUnlive(Map<String, T> param);
	
	public int mv_totalLiveSearch(Map<String, Object> paramMap);
	public int mv_totalUnliveSearch(Map<String, Object> paramMap);
	
	public List<MovieDto> mv_readGenreLive(List<String> genres);
}
