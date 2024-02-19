package com.company.service;

import java.util.Map;

public interface TheaterMapService {
	
	public String getMap(String query);
	
	public Map<String, Object> map(String address); 
}
