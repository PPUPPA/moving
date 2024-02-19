package com.company.moving;

import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import com.company.service.TheaterMapService;


import lombok.extern.java.Log;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/**/root-context.xml")
@Log
public class MapApi {
	@Autowired ApplicationContext context;
	
	@Autowired
	TheaterMapService mapApi;
	
	@Test @Ignore
	public void test0() { log.info("컨텍스트는 "+context); }
	
	@Test 
	public void map() {
		String query="서울 강서구 강서로 111번길 67";
		String jsonResult = mapApi.getMap(query);
		System.out.println(jsonResult);
		
		try {
            JSONObject jsonObject = new JSONObject(jsonResult);
            JSONArray documentsArray = jsonObject.getJSONArray("documents");
            JSONObject firstDocument = documentsArray.getJSONObject(0);

            String xValue = firstDocument.getString("x");
            String yValue = firstDocument.getString("y");

            System.out.println("x: " + xValue);
            System.out.println("y: " + yValue);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		
	}  //end test Map

}
