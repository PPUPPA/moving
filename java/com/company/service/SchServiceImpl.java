package com.company.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.ScheduleDao;
import com.company.dto.GeminiIntent;
import com.company.dto.MovieDto;
import com.company.dto.ScheduleDto;
import com.company.dto.ScheduleResultDto;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;
import com.google.gson.Gson;

@Service("schService")
public class SchServiceImpl implements SchService {

	@Autowired
	ScheduleDao dao;

	@Override
	public List<TheaterDto> theaterList() {
		return dao.theaterList();
	}

	@Override
	public String theaterDetail(TheaterDto dto) {
		String json = "";
		Gson gson = new Gson();
		json = gson.toJson(dao.theaterDetail(dto));
		//System.out.println(json);
		return json;
	}

	@Override
	public String scheduleList(Map<String, Object> map) {
		//
		int result = dao.updateScheduleState();
		//System.out.println(result);

		List<ScheduleResultDto> list = dao.scheduleList(map);
		//System.out.println(list);
		List<MovieDto> movieNameList = dao.scheduleMovieList(map);

		//
		List<Map<String, Object>> convertedData = new ArrayList<>();
		for (MovieDto movie : movieNameList) {
			Map<String, Object> movieMap = new HashMap<>();
			movieMap.put("title", movie.getMv_ktitle());
			movieMap.put("mv_cert", movie.getMv_cert());

			List<Map<String, Object>> schedules = new ArrayList<>();
			for (ScheduleResultDto scheduleResultDto : list) {
				if (movie.getMv_ktitle().equals(scheduleResultDto.getMv_ktitle())) {
					Map<String, Object> schedule = new HashMap<>();
					schedule.put("section", scheduleResultDto.getScr_name());

					//
					SimpleDateFormat inputFormat = new SimpleDateFormat("HH:mm:ss");
					SimpleDateFormat outputFormat = new SimpleDateFormat("HH:mm");

					try {
						Date startTime = inputFormat.parse(scheduleResultDto.getSch_start());
						Date endTime = inputFormat.parse(scheduleResultDto.getSch_end());

						schedule.put("time", outputFormat.format(startTime));
						schedule.put("endTime", outputFormat.format(endTime));
					} catch (ParseException e) {
						e.printStackTrace();
					}

					schedule.put("totalSeats", scheduleResultDto.getScr_st_cnt());
					schedule.put("availableSeats", scheduleResultDto.getSch_cnt());
					schedule.put("scheduleNo", scheduleResultDto.getSch_no());
					schedules.add(schedule);
				}
			}

			movieMap.put("schedules", schedules);
			convertedData.add(movieMap);
		}
		Gson gson = new Gson();
		String json = gson.toJson(convertedData);
		return json;
	}

	//
	@Override
	public List<ScheduleResultDto> scheduleListAdmin(Map<String, Object> map) {
		int result = dao.updateScheduleState();
		return dao.scheduleListAdmin(map);
	}

	@Override
	public int insertScheduleAction(ScheduleDto dto) {
		int result = -1;

		if (dao.isValidDataForInsert(dto) == 0) {
			dto.setSch_cnt(dto.getSch_cnt() - dao.brokenSeatCnt(dto.getScr_no())); //

			result = dao.insertSchedule(dto);
		}

		return result;
	}

	@Override
	public int deleteSchedule(ScheduleDto dto) {
		int result = 0;
		try {
			result = dao.deleteSchedule(dto);
		} catch (Exception e) {
			result = -1;
		}

		return result;
	}

	@Override
	public List<MovieDto> getMovieList() {
		return dao.movieListAll();
	}

	@Override
	public List<ScreenDto> getScreenList(ScreenDto dto) {
		return dao.screenList(dto);
	}

	@Override
	public TheaterDto getTheaterHours(TheaterDto dto) {
		return dao.getTheaterHours(dto);
	}

	@Override
	public Map<String, Object> GeminiInsertScheduleAction(GeminiIntent geminiIntent) {
		Map<String, Object> result = new HashMap<>();
		ScheduleDto schDto = new ScheduleDto();

		// 매핑된 객체에서 필요한 정보 추출
		String mv_ktitle = geminiIntent.getParameters().get("mv_ktitle");
		String tt_name = geminiIntent.getParameters().get("tt_name");
		String scr_name = geminiIntent.getParameters().get("scr_name");
		String sch_date = geminiIntent.getParameters().get("sch_date");
		String sch_start = geminiIntent.getParameters().get("sch_start");

		schDto.setSch_date(sch_date);
		schDto.setSch_start(sch_start);

		// mv_cd 찾기
		MovieDto mvDto = dao.getMvCdAndRuntime(mv_ktitle);
		schDto.setMv_cd(mvDto.getMv_cd());

		// scr_no,scr_st_cnt,tt_no 찾기
		Map<String, String> param = new HashMap<>();
		param.put("tt_name", tt_name);
		param.put("scr_name", scr_name);
		ScreenDto scrDto = dao.getScrNoAndSeats(param);
		schDto.setScr_no(scrDto.getScr_no());
		schDto.setSch_cnt(scrDto.getScr_st_cnt());

		// sch_start 에 mv_runtime 더해서 sch_end 계산 그 다음 sch_end 가 tt_close 보다 작아야 함
		// 시작 시간을 LocalTime으로 파싱
		LocalTime startTime = LocalTime.parse(sch_start, DateTimeFormatter.ofPattern("H:mm"));

		// mv_runtime을 더한 후 sch_end 계산
		// 영화의 상영 종료 시간 계산
		LocalDateTime endTime = LocalDateTime.of(LocalDate.parse(sch_date), startTime)
				.plusMinutes(mvDto.getMv_runtime());
		// sch_end 출력
		String sch_end = endTime.format(DateTimeFormatter.ofPattern("H:mm")); // 10:00
		schDto.setSch_end(sch_end);

		// 영화관 close 시간 출력
		TheaterDto ttDto = new TheaterDto();
		ttDto.setTt_no(scrDto.getTt_no());
		String tt_close = dao.getTheaterHours(ttDto).getTt_close(); // 23:00:00

		// sch_end와 tt_end를 LocalTime으로 변환
		LocalTime ttEndTime = LocalTime.parse(tt_close, DateTimeFormatter.ofPattern("H:mm:ss"));
		// 영화관 운영 종료 일시
		LocalDateTime theaterCloseDateTime = LocalDateTime.of(LocalDate.parse(sch_date), ttEndTime);

		// 영화의 상영 종료 시간이 영화관 운영 종료 시간을 넘어가는지 확인
		if (endTime.isAfter(theaterCloseDateTime)) {
			result.put("message", "상영 종료 시간은 영화관 종료 시간 이전이어야 합니다.\n다른 시간대를 선택해주세요.");
		} else {
			// 상영 시간표 추가 액션 실행 및 결과 메시지 생성
			int insertResult = insertScheduleAction(schDto);
			String message = "";
			if (insertResult == 1) {
				message = "상영 시간표가 성공적으로 추가되었습니다.\n";
				// 상영 시간표 정보 추가
				message += "영화 제목: " + mv_ktitle + "\n";
				message += "상영 일자: " + sch_date + "\n";
				message += "상영 시작 시간: " + sch_start + "\n";
				message += "상영 종료 시간: " + sch_end + "\n";
				message += "영화관 이름: " + tt_name + "\n";
				message += "상영관 이름: " + scr_name + "\n";
			} else {
				message = "이미 해당 시간대에 다른 상영 일정이 예약되어 있습니다.\n상영 일정을 확인해주세요.";
			}
			result.put("message", message);
		}

		return result;
	}

	@Override
	public Map<String, Object> GeminiDeleteScheduleAction(GeminiIntent geminiIntent) {
		Map<String, Object> result = new HashMap<>();
		String tt_name = geminiIntent.getParameters().get("tt_name");
		String scr_name = geminiIntent.getParameters().get("scr_name");
		String sch_date = geminiIntent.getParameters().get("sch_date");
		String sch_start = geminiIntent.getParameters().get("sch_start");

		// scr_no, scr_st_cnt, tt_no 찾기
		Map<String, String> param = new HashMap<>();
		param.put("tt_name", tt_name);
		param.put("scr_name", scr_name);
		ScreenDto scrDto = dao.getScrNoAndSeats(param);

		Map<String, Object> param2 = new HashMap<>();
		param2.put("date", sch_date);
		param2.put("scrNo", scrDto.getScr_no());
		param2.put("schStart", sch_start);

		ScheduleDto schDto = new ScheduleDto();

		List<ScheduleResultDto> schedules = dao.scheduleListAdmin(param2);

		if (schedules != null && !schedules.isEmpty()) {
			int sch_no = schedules.get(0).getSch_no();
			schDto.setSch_no(sch_no);

			if (dao.deleteSchedule(schDto) > 0) {
				result.put("message", schDto.getSch_no() + "번 상영시간표 삭제에 성공하였습니다.");
			} else {
				result.put("message", "상영시간표 삭제에 실패하였습니다.");
			}
		} else {
			// 요청한 정보와 함께 에러 메시지 반환
			String errorMessage = "요청하신 상영 일정은 존재하지 않습니다.\n";
			errorMessage += "영화관 이름: " + tt_name + "\n";
			errorMessage += "상영관 이름: " + scr_name + "\n";
			errorMessage += "상영 일자: " + sch_date + "\n";
			errorMessage += "상영 시작 시간: " + sch_start + "\n";
			errorMessage += "다시 상영 일정을 확인해주세요.";
			result.put("message", errorMessage);
		}

		return result;
	}
}
