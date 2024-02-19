package com.company.service;



import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class TheaterMapServiceImpl implements TheaterMapService {
	private String rest_api_key = "c58c19ade079896c9555aee9161dc4b1";
	private String kakao_map_url ="https://dapi.kakao.com/v2/local/search/address.json";

	@Override
	public String getMap(String query) {
		 String apiUrl = kakao_map_url + "?query=" + query;

	     HttpHeaders httpHeader = new HttpHeaders();
	     httpHeader.set("Authorization", "KakaoAK "+rest_api_key); 
	

	     HttpEntity<String> entity = new HttpEntity<String>("parameter", httpHeader);
	     
	     RestTemplate restTemplate = new RestTemplate();
	     
	     ResponseEntity<String> response = restTemplate.exchange(apiUrl, HttpMethod.GET, entity, String.class);

	     return response.getBody();

	}
	
	@Override
	public Map<String, Object> map(String address) {
		//String address="서울특별시 송파구 올림픽로 300 롯데월드타워 27층";
		String jsonResult = getMap(address);
		System.out.println(jsonResult);
		Map<String, Object> result = new HashMap<>();
		try {
            JSONObject jsonObject = new JSONObject(jsonResult);
            JSONArray documentsArray = jsonObject.getJSONArray("documents");
            JSONObject firstDocument = documentsArray.getJSONObject(0);

            String xValue = firstDocument.getString("x");
            String yValue = firstDocument.getString("y");

            //System.out.println("x: " + xValue);
            //System.out.println("y: " + yValue);
            result.put("x", xValue);
            result.put("y", yValue);

            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
		return result;
		
	} 

}
