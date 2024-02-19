package com.company.service;

import java.util.List;
import java.util.Map;

import com.company.util.PagingDto;

public interface PagingService {
    public <T> List<T> listCnt(Map<String, T> param);
    public PagingDto paging(int pstartno, String type);
    public PagingDto paging(int pstartno, String type, String searchType, String searchKey);
    public Map<String, Object> getPagedData(int pstartno, String type);
    public Map<String, Object> getPagedData(int pstartno, String type, String searchType, String searchKey);
}