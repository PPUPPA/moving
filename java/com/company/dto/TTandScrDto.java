package com.company.dto;

import java.util.List;

import lombok.Data;

@Data
public class TTandScrDto {
	/* 영화관 */
	private int tt_no;
	private String tt_name;
	private String tt_tel;
	private String tt_start;
	private String tt_close;
	private int tt_scrcnt;
	private String tt_img;
	private String tt_address;
	private String tt_crtdate;
	/* 상영관 */
	private int scr_no;
	private String scr_name;
	private int scr_st_cnt;
	private String scr_crtdate;
	private int scr_price;
	private char scr_st_row;
	private int scr_st_col;
	private int scrstate_no;
	private int bk_st_cnt;
	
	
	private int bkCnt;
	private int st_row;
	private List<Character> list;
	private String bkSeat;
	
	private List<String> bkStList; 

	
	
	private String scrstate_state;

}
