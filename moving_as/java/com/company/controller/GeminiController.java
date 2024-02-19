package com.company.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.company.dto.GeminiIntent;
import com.company.dto.ScheduleDto;
import com.company.service.AIApiService;
import com.company.service.GeminiServiceImpl;
import com.company.service.GptServiceImpl;
import com.company.service.SchService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class GeminiController {
	@Autowired
	SchService service;

	@Autowired
	ResourceLoader resourceLoader;

	@RequestMapping(value = "/getGeminiResponse.admin", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String getGeminiResponse(String prompt) throws IOException {
		//System.out.println("..... 제미니 도착");

		// 클래스패스 상의 리소스를 로드
		String result = "";
		AIApiService aiApiService = null;

		aiApiService = new GeminiServiceImpl();
		Resource resource = resourceLoader.getResource("classpath:config/gemini-schedule-mapper.json");
		String jsonFilePath = resource.getFile().getPath();
		result = aiApiService.generateContent(prompt, jsonFilePath);
		System.out.println(result);

		if (result.contains("실패") || result.contains("오류")) {
			// Gemini api 오류시 Gpt api 이용하여 서비스 대체
			aiApiService = new GptServiceImpl();
			resource = resourceLoader.getResource("classpath:config/gpt-schedule-mapper.json");
			jsonFilePath = resource.getFile().getPath();
			result = aiApiService.generateContent(prompt, jsonFilePath);
		}
		
		return result;
	}

	@RequestMapping(value = "/add_showtime.admin", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String, Object> addShowTime(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		//System.out.println(".... add 도착 ");
		ObjectMapper objectMapper = new ObjectMapper();
		GeminiIntent gemini = objectMapper.readValue(param, GeminiIntent.class);

		return service.GeminiInsertScheduleAction(gemini);
	}

	@RequestMapping(value = "/delete_showtime.admin", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String, Object> deleteShowTime(@RequestBody String param)
			throws JsonParseException, JsonMappingException, IOException {
		//System.out.println(".... delete 도착 ");
		ObjectMapper objectMapper = new ObjectMapper();
		GeminiIntent gemini = objectMapper.readValue(param, GeminiIntent.class);

		return service.GeminiDeleteScheduleAction(gemini);
	}

}
