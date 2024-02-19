package com.company.service;

import java.util.List;
import java.util.Map;

import com.company.dto.BrokenSeatDto;
import com.company.dto.TTandScrDto;
import com.company.dto.TheaterDto;

public interface TheaterManageService {
	public List<TheaterDto> theaterReadAll();
	
	public int theaterDelete(int tt_no);
	
	public TTandScrDto ttandscrRead(int scr_no);

	public int scrstateUpdate(Map<String, Integer> parameterMap);

	public TTandScrDto scrseat(int scr_no);

	public int bkSeatInsert(BrokenSeatDto dto);
	
	public int bkSeatDelete(BrokenSeatDto dto);
	
	public List<String> bkSeatReadAction(int scr_no);
	
	public List<BrokenSeatDto> bkSeatRead(int scr_no);
	
	public List<String> bkSeatReadAll(int scr_no);
}
