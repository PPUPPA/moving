package com.company.dao;

import java.util.List;
import java.util.Map;

import com.company.dto.BrokenSeatDto;
import com.company.dto.ScreenDto;
import com.company.dto.TTandScrDto;
import com.company.dto.TheaterDto;

@MyDao
public interface TheaterManageDao {
	//영화관 목록 
	public List<TheaterDto> theaterReadAll();
	
	public List<ScreenDto> screenReadAll();
	
	//영화관 추가
	public int ttInsert(TheaterDto dto);
	
	public TheaterDto readTT(TheaterDto dto);
	
	public int scrInsert(ScreenDto dto);
	
	public Integer insertNowTheater();
	
	//영화관 수정
	public TheaterDto theaterRead(int tt_no);
	
	public List<ScreenDto> screenReadAll2(int tt_no);
	
	public ScreenDto screenRead(ScreenDto dto); 
	
	public int theaterUpdate(TheaterDto dto);
	
	public int screenUpdate(ScreenDto dto);
	
	//영화관 삭제
	public int theaterDelete(int tt_no);
	
	public int screenDelete(int tt_no);
	
	
	
	//상영관 관리
	public TTandScrDto ttandscrRead(int scr_no); 
	
	public int scrstateUpdate(Map<String, Integer> parameterMap);

	//상영관 좌석 관리
	public int bkSeatInsert(BrokenSeatDto dto);
	
	public int bkSeatDelete(BrokenSeatDto dto);
	
	public List<BrokenSeatDto> bkSeatRead(int scr_no);
	
	
	
	
	
	

}
