package com.company.service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.BoardDao;
import com.company.dao.MovieDao;
import com.company.util.PagingDto;

@Service
public class PagingServiceImpl implements PagingService {
    @Autowired private MovieDao movieDao;
    @Autowired private BoardDao boardDao;

    // 10개씩 리스트
    @SuppressWarnings("unchecked")
	@Override public <T> List<T> listCnt(Map<String, T> param) {
    	String type = String.valueOf(param.get("type"));
    	
        if (param.get("type").equals("board")) {
            return (List<T>) boardDao.b_listCnt(param);
        } else if (param.get("type").equals("live")) {
            return (List<T>) movieDao.mv_cntLive(param);
        } else if (param.get("type").equals("unLive")) {
        	return (List<T>) movieDao.mv_cntUnlive(param);
        }
        return null;
    }

    // 페이징
    @Override public PagingDto paging(int pstartno, String type) {
        if (type.equals("board")) {
            return new PagingDto(boardDao.b_total(), pstartno);
        } else if (type.equals("live")) {
            return new PagingDto(movieDao.mv_totalLive(), pstartno);
        } else if (type.equals("unLive")) {
        	return new PagingDto(movieDao.mv_totalUnlive(), pstartno);
        }
        return null;
    }
    
    // 페이징
    @Override
    public PagingDto paging(int pstartno, String type, String searchType, String searchKey) {
        if (type.equals("board")) {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("searchType", searchType);
            paramMap.put("searchKey", searchKey);
            
            int totalBoard;
            if (searchType != null && searchKey != null) {
            	totalBoard = boardDao.b_totalSearch(paramMap);
            } else {
            	totalBoard = boardDao.b_total();
            }
            return new PagingDto(totalBoard, pstartno, searchType, searchKey);
        } else if (type.equals("live")) {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("searchType", searchType);
            paramMap.put("searchKey", searchKey);
            
            int totalLive;
            if (searchType != null && searchKey != null) {
                totalLive = movieDao.mv_totalLiveSearch(paramMap);
            } else {
                totalLive = movieDao.mv_totalLive();
            }
            return new PagingDto(totalLive, pstartno, searchType, searchKey);
        } else if (type.equals("unLive")) {
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("searchType", searchType);
            paramMap.put("searchKey", searchKey);
            
            int totalUnlive;
            if (searchType != null && searchKey != null) {
                totalUnlive = movieDao.mv_totalUnliveSearch(paramMap);
            } else {
                totalUnlive = movieDao.mv_totalUnlive();
            }
            return new PagingDto(totalUnlive, pstartno, searchType, searchKey);
        }
        return null;
    }
    
    @Override 
    public Map<String, Object> getPagedData(int pstartno, String type) {
        Map<String, Object> result = new HashMap<>();
        
        Map<String, Object> params = new HashMap<>();
        params.put("pstartno", pstartno);
        params.put("onepagelimit", 10);
        params.put("type", type);
        
        result.put("list", listCnt(params));
        result.put("paging", paging(pstartno, type));
        return result;
    }

    @Override
    public Map<String, Object> getPagedData(int pstartno, String type, String searchType, String searchKey) {
        Map<String, Object> result = new HashMap<>();
        
        Map<String, Object> params = new HashMap<>();
        params.put("pstartno", pstartno);
        params.put("onepagelimit", 10);
        params.put("type", type);
        params.put("searchType", searchType);
        params.put("searchKey", searchKey);
        
        result.put("list", listCnt(params));
        result.put("paging", paging(pstartno, type, searchType, searchKey));

        return result;
    }
}