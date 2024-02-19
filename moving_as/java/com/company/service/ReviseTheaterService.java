package com.company.service;

import java.util.List;

import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

public interface ReviseTheaterService {
	public TheaterDto theaterRead(int tt_no);
	
	public List<ScreenDto> screenReadAll2(int tt_no);
	
	public ScreenDto screenRead(ScreenDto dto); 
	
	public int theaterUpdate(TheaterDto dto);
	
	public int screenUpdate(ScreenDto dto);
	

}
