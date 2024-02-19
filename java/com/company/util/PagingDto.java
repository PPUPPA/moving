package com.company.util;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Component
public class PagingDto {
	private int listtotal;
	private int onepagelimit;
	private int pagetotal;
	private int bottomlimit; // 하단 페이지 노출 수
	private int pstartno;
	private int currentPage;
	private int startPage;
	private int endPage;
	private String searchType;
	private String searchKey;
	
	// private List<Object> list;
	public PagingDto(int listtotal, int pstartno) {
		super();
		this.listtotal = listtotal;
		this.onepagelimit = 10;
		this.pagetotal = (int)Math.ceil(listtotal/(double)onepagelimit);
		this.bottomlimit = 5;
		this.pstartno = pstartno;
		
		this.currentPage = (int) (Math.ceil(pstartno+1)/(double)onepagelimit)+1;
		this.startPage = ((int)(Math.floor((this.currentPage-1)/(double)bottomlimit)))*bottomlimit+1;
		this.endPage = this.startPage+bottomlimit-1;
		if(pagetotal<endPage) {this.endPage=pagetotal;}
	}
	
	public PagingDto(int listtotal, int pstartno, String searchType, String searchKey) {
		super();
		this.listtotal = listtotal;
		this.onepagelimit = 10;
		this.pagetotal = (int)Math.ceil(listtotal/(double)onepagelimit);
		this.bottomlimit = 5;
		this.pstartno = pstartno;
		this.searchType = searchType;
		this.searchKey = searchKey;
		
		this.currentPage = (int) (Math.ceil(pstartno+1)/(double)onepagelimit)+1;
		this.startPage = ((int)(Math.floor((this.currentPage-1)/(double)bottomlimit)))*bottomlimit+1;
		this.endPage = this.startPage+bottomlimit-1;
		if(pagetotal<endPage) {this.endPage=pagetotal;}
	}
}