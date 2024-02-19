package com.company.service;

import java.util.List;
import java.util.Map;

import com.company.dto.GeminiIntent;
import com.company.dto.MovieDto;
import com.company.dto.ScheduleDto;
import com.company.dto.ScheduleResultDto;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

public interface SchService {
	public List<TheaterDto> theaterList();

	public String theaterDetail(TheaterDto dto);

	public String scheduleList(Map<String, Object> map);

	// 관리자
	public List<ScheduleResultDto> scheduleListAdmin(Map<String, Object> map);

	public List<MovieDto> getMovieList();

	public List<ScreenDto> getScreenList(ScreenDto dto);

	public int insertScheduleAction(ScheduleDto dto);

	public int deleteSchedule(ScheduleDto dto);

	public TheaterDto getTheaterHours(TheaterDto dto);

	public Map<String,Object> GeminiInsertScheduleAction(GeminiIntent geminiIntent);
	
	public Map<String, Object> GeminiDeleteScheduleAction(GeminiIntent geminiIntent);

}
