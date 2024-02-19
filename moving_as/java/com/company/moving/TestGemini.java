package com.company.moving;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.company.dao.ScheduleDao;
import com.company.dto.GeminiIntent;
import com.company.dto.MovieDto;
import com.company.dto.ScheduleDto;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;
import com.company.service.AIApiService;
import com.company.service.SchService;
import com.company.util.JsonWriterAndReader;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

import com.fasterxml.jackson.core.type.TypeReference;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/**/root-context.xml")
@Log4j
public class TestGemini {
	@Autowired
	ApplicationContext context;

	@Autowired
	AIApiService service;

	@Autowired
	ScheduleDao dao;

	@Autowired
	SchService schService;

	@Test
	@Ignore
	public void test() {
		System.out.println(context);
	}

	@Test
	@Ignore
	public void test1() {
		String jsonFilePath = "src/main/resources/config/gemini-schedule-mapper.json";

		String result = service.generateContent("강남영화관에 2024년 1월 25일에 상영시간표 추가", jsonFilePath);
		System.out.println(result);
	}

	@Test
	@Ignore
	public void testJsonUpdate() {
		String jsonFilePath = "src/main/resources/config/gemini-schedule-mapper.json";
//        String userInput = "사용자 입력 내용";
//
		JsonWriterAndReader jsonUpdater = new JsonWriterAndReader();
//        jsonUpdater.updateJson(jsonFilePath, userInput);

		JsonNode jsonNode = jsonUpdater.readJson(jsonFilePath);

		// 반환된 JsonNode를 사용하여 원하는 작업 수행
		if (jsonNode != null) {
			System.out.println(jsonNode.toString());
		} else {
			System.out.println("JSON 파일을 읽을 수 없습니다.");
		}

	}

	@Test
	@Ignore
	public void jsonParsing() throws JsonParseException, JsonMappingException, IOException {
		// 뷰 단에서 gemini 호출
		String jsonFilePath = "src/main/resources/config/gemini-schedule-mapper.json";
		String result = service.generateContent("2월 3일 종로 메가박스 1관 9시에 웡카 추가하고싶어", jsonFilePath);

		// 추가 요청 controller 파트
		ObjectMapper objectMapper = new ObjectMapper();
		// JSON 문자열을 GeminiIntent 객체로 매핑
		GeminiIntent geminiIntent = objectMapper.readValue(result, GeminiIntent.class);
		System.out.println(geminiIntent);
		
		ScheduleDto schDto = new ScheduleDto();

		// 매핑된 객체에서 필요한 정보 추출
		String intent = geminiIntent.getIntent();
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
		log.info("....... sch_end : " + sch_end);

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
			// 상영 종료 시간이 영화관 운영 종료 시간을 넘어감
			System.out.println("상영 종료 시간이 영화관 운영 종료 시간을 넘어갑니다.");
		} else {
			// 상영 종료 시간이 영화관 운영 종료 시간을 넘어가지 않음
			System.out.println("상영 종료 시간이 영화관 운영 종료 시간을 넘어가지 않습니다.");
			
			schService.insertScheduleAction(schDto);
		}

	}

	@Test
	@Ignore
	public void responseParsing() {
		ScheduleDto schDto = new ScheduleDto();
		MovieDto mvDto = dao.getMvCdAndRuntime("웡카");
		Map<String, String> param = new HashMap<>();
		param.put("tt_name", "종로 메가박스");
		param.put("scr_name", "1관");

		ScreenDto scrDto = dao.getScrNoAndSeats(param);
		schDto.setMv_cd(mvDto.getMv_cd());
		schDto.setScr_no(scrDto.getScr_no());
		schDto.setSch_cnt(scrDto.getScr_st_cnt());

	}

	@Test
	@Ignore
	public void testAddTime() {
		String sch_start = "23:00"; // 시작 시간
		int mv_runtime = 120; // 영화 런타임 (분)

		// 시작 시간을 LocalTime으로 파싱
		LocalTime startTime = LocalTime.parse(sch_start, DateTimeFormatter.ofPattern("H:mm"));

		// mv_runtime을 더한 후 sch_end 계산
		LocalTime endTime = startTime.plusMinutes(mv_runtime);

		// sch_end 출력
		String sch_end = endTime.format(DateTimeFormatter.ofPattern("H:mm"));
		System.out.println("sch_end: " + sch_end); // 결과: 11:00
	}
	
	@Test
	public void testDao() {
		Map<String, Object> param2 = new HashMap<>();
		param2.put("date", "2024-02-05");
		param2.put("scrNo", 2);
		param2.put("schStart", "12:00");
		System.out.println("1 : "+dao.scheduleListAdmin(param2));
		System.out.println("2 : "+dao.scheduleListAdmin(param2).get(0));
	}

}
