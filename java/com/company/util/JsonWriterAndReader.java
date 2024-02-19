package com.company.util;

import java.io.File;
import java.io.IOException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import lombok.extern.log4j.Log4j;

@Log4j
public class JsonWriterAndReader {

	public void updateGPTJson(String jsonFilePath, String userInput) {
		try {
			// JSON 파일 읽기
			ObjectMapper objectMapper = new ObjectMapper();
			File jsonFile = new File(jsonFilePath);
			JsonNode rootNode = objectMapper.readTree(jsonFile);

			// "messages" 배열의 마지막 요소의 "role" 값이 "user"인 경우에만 업데이트
			JsonNode messagesNode = rootNode.get("messages");
			if (messagesNode != null && messagesNode.isArray() && messagesNode.size() > 0) {
				JsonNode lastMessageNode = messagesNode.get(messagesNode.size() - 1);
				if (lastMessageNode.has("role") && lastMessageNode.get("role").asText().equals("user")) {
					((ObjectNode) lastMessageNode).put("content", userInput);
				}
			}

			// 업데이트된 JSON 파일 저장
			objectMapper.writeValue(jsonFile, rootNode);

			// System.out.println("JSON 파일이 성공적으로 업데이트되었습니다.");
		} catch (IOException e) {
			log.error("JSON 파일 업데이트 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	public void updateJson(String jsonFilePath, String userInput) {
		try {
			// JSON 파일 읽기
			ObjectMapper objectMapper = new ObjectMapper();
			File jsonFile = new File(jsonFilePath);
			JsonNode rootNode = objectMapper.readTree(jsonFile);

			// "contents" 배열의 마지막 요소의 "text" 값을 사용자 입력으로 업데이트
			JsonNode contentsNode = rootNode.get("contents");
			if (contentsNode.isArray() && contentsNode.size() > 0) {
				JsonNode lastContentNode = contentsNode.get(contentsNode.size() - 1);
				if (lastContentNode.has("parts")) {
					JsonNode partsNode = lastContentNode.get("parts");
					if (partsNode.isArray() && partsNode.size() > 0) {
						((ObjectNode) partsNode.get(0)).put("text", userInput);
					}
				}
			}

			// 업데이트된 JSON 파일 저장
			objectMapper.writeValue(jsonFile, rootNode);

			// System.out.println("JSON 파일이 성공적으로 업데이트되었습니다.");
		} catch (IOException e) {
			log.error("JSON 파일 업데이트 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	public JsonNode readJson(String jsonFilePath) {
		ObjectMapper objectMapper = new ObjectMapper();
		JsonNode jsonNode = null;

		try {
			// JSON 파일을 읽어와 JsonNode로 변환
			jsonNode = objectMapper.readTree(new File(jsonFilePath));
		} catch (IOException e) {
			e.printStackTrace();
		}

		return jsonNode;
	}

}
