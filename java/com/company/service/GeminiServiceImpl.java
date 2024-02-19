package com.company.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.company.util.JsonWriterAndReader;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;


//@Service
public class GeminiServiceImpl implements AIApiService {
	private final String GEMINI_API_KEY = "AIzaSyDUZmC5MeUSB4QBjc6CK0Hq6MbQfzhr4Zo";
	private final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="
			+ GEMINI_API_KEY;

	@Override
	public String generateContent(String prompt, String jsonFilePath) {
		//System.out.println("..... 제미니");
		try {
			JsonWriterAndReader jsonWriterAndReader = new JsonWriterAndReader();
			jsonWriterAndReader.updateJson(jsonFilePath, prompt);

			JsonNode jsonNode = jsonWriterAndReader.readJson(jsonFilePath);

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
			HttpEntity<String> entity = new HttpEntity<>(jsonNode.toString(), headers);

			// Gemini API 호출
			ResponseEntity<String> responseEntity = new RestTemplate().exchange(GEMINI_API_URL, HttpMethod.POST, entity,
					String.class);

			String extractedText = "";

			if (responseEntity.getStatusCode().is2xxSuccessful()) {

				try {
					ObjectMapper objectMapper = new ObjectMapper();
					jsonNode = objectMapper.readTree(responseEntity.getBody());

					JsonNode textNode = jsonNode.at("/candidates/0/content/parts/0/text");
					extractedText = textNode.asText();
				} catch (Exception e) {
					e.printStackTrace();
				}

				return extractedText;
			} else {
				//System.out.println("Gemini API 호출에 실패했습니다. HTTP 상태 코드: " + responseEntity.getStatusCode());
				//System.out.println("응답 내용: " + responseEntity.getBody());
				return "Gemini API 호출에 실패했습니다.";
			}
		} catch (RestClientException e) {
			//System.out.println("Gemini API 호출 중 오류가 발생했습니다.");
			e.printStackTrace();
			return "Gemini API 호출 중 오류가 발생했습니다.";
		}
	}

}
