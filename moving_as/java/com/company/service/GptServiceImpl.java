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
public class GptServiceImpl implements AIApiService {

	private final String GPT_API_KEY = "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";
	private final String GPT_API_URL = "https://api.openai.com/v1/chat/completions";

	@Override
	public String generateContent(String prompt, String jsonFilePath) {
		System.out.println("..... 지피티");
		try {
			JsonWriterAndReader jsonWriterAndReader = new JsonWriterAndReader();
			jsonWriterAndReader.updateGPTJson(jsonFilePath, prompt);

			JsonNode jsonNode = jsonWriterAndReader.readJson(jsonFilePath);

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
			headers.set("Authorization", "Bearer " + GPT_API_KEY);
			HttpEntity<String> entity = new HttpEntity<>(jsonNode.toString(), headers);

			// Gemini API 호출
			ResponseEntity<String> responseEntity = new RestTemplate().exchange(GPT_API_URL, HttpMethod.POST, entity,
					String.class);

			String extractedText = "";

			if (responseEntity.getStatusCode().is2xxSuccessful()) {

				try {
					System.out.println(responseEntity.getBody());

					// JSON 문자열을 파싱하여 JsonNode 객체로 변환
					ObjectMapper objectMapper = new ObjectMapper();
					JsonNode rootNode = objectMapper
							.readTree(new String(responseEntity.getBody().getBytes("ISO-8859-1"), "UTF-8"));

					// "content" 필드의 값을 추출
					JsonNode choicesNode = rootNode.get("choices");
					if (choicesNode.isArray() && choicesNode.size() > 0) {
						JsonNode contentNode = choicesNode.get(0).get("message").get("content");
						extractedText = contentNode.asText();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				return extractedText;
			} else {
				System.out.println("GPT API 호출에 실패했습니다. HTTP 상태 코드: " + responseEntity.getStatusCode());
				System.out.println("응답 내용: " + responseEntity.getBody());
				return "GPT API 호출에 실패했습니다.";
			}
		} catch (RestClientException e) {
			System.out.println("GPT API 호출 중 오류가 발생했습니다.");
			e.printStackTrace();
			return "GPT API 호출 중 오류가 발생했습니다.";
		}
	}

}
