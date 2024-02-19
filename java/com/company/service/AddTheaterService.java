package com.company.service;

import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

public interface AddTheaterService {
	public int ttInsert(TheaterDto dto);
	
	public TheaterDto readTT(TheaterDto dto);
	
	public int scrInsert(ScreenDto dto);
	
	public int ttAndscrInsert(TheaterDto dto);
}
