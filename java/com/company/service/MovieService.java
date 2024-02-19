package com.company.service;

import java.util.List;

import com.company.dto.MovieDto;

public interface MovieService {
	public int mv_insert(MovieDto dto);
	public int mv_update(MovieDto dto);
	public int mv_changeState(MovieDto dto);
	
	public MovieDto mv_read(int mv_cd);
	public List<MovieDto> mv_readLive();
	public List<MovieDto> mv_readUnlive();
	
	public List<MovieDto> mv_readGenreLive(List<String> genres);
}
