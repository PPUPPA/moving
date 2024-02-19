package com.company.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.MovieDao;
import com.company.dto.MovieDto;

@Service
public class MovieServiceImpl implements MovieService {
	@Autowired MovieDao dao;
	
	@Override public int mv_insert(MovieDto dto) { return dao.mv_insert(dto); }
	@Override public int mv_update(MovieDto dto) { return dao.mv_update(dto); }
	@Override public int mv_changeState(MovieDto dto) { return dao.mv_changeState(dto); }
	@Override public MovieDto mv_read(int mv_cd) { return dao.mv_read(mv_cd); }
	@Override public List<MovieDto> mv_readLive() { return dao.mv_readLive(); }
	@Override public List<MovieDto> mv_readUnlive() { return dao.mv_readUnlive(); }
	@Override public List<MovieDto> mv_readGenreLive(List<String> genres) { return dao.mv_readGenreLive(genres); }
}
