package com.company.dao;

import java.util.List;
import java.util.Map;

import com.company.dto.MovieDto;
import com.company.dto.ScheduleDto;
import com.company.dto.ScheduleResultDto;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

@MyDao
public interface ScheduleDao {
	public List<TheaterDto> theaterList();

	public TheaterDto theaterDetail(TheaterDto dto);

	public List<ScheduleResultDto> scheduleList(Map<String, Object> map); 

	public List<MovieDto> scheduleMovieList(Map<String, Object> map); 

	public int updateScheduleState(); // 상영시간표 출력전 현재 시간에 따라 상영시간표 상태 업데이트 - 트리거로 대체 가능해보임 

	// 관리자
	
	public List<ScheduleResultDto> scheduleListAdmin(Map<String, Object> map); 

	public List<ScreenDto> screenList(ScreenDto dto); 

	public List<MovieDto> movieListAll(); 

	public Integer isValidDataForInsert(ScheduleDto dto); 

	public int insertSchedule(ScheduleDto dto); 

	public int deleteSchedule(ScheduleDto dto); 

	public TheaterDto getTheaterHours(TheaterDto dto); 

	public Integer brokenSeatCnt(int scr_no); 
	
	// 제미니
	public MovieDto getMvCdAndRuntime(String mv_ktitle);
	
	public ScreenDto getScrNoAndSeats(Map<String, String> param);

}
