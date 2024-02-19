package com.company.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.TheaterManageDao;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

@Service
public class ReviseTheaterServiceImpl implements ReviseTheaterService{
	@Autowired TheaterManageDao dao;
	
	@Override
	public TheaterDto theaterRead(int tt_no) {
		return dao.theaterRead(tt_no);
	}

	@Override
	public List<ScreenDto> screenReadAll2(int tt_no){
		return dao.screenReadAll2(tt_no);
	}

	@Override
	public ScreenDto screenRead(ScreenDto dto) {
		return dao.screenRead(dto);
	}

	@Override
	public int theaterUpdate(TheaterDto dto) {
		return dao.theaterUpdate(dto);
	}

	@Override
	public int screenUpdate(ScreenDto dto) {
		return dao.screenUpdate(dto);
	};
	
	
	
	
	
	
	
	
}
