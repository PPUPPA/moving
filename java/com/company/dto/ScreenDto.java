package com.company.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScreenDto {
	private int scr_no;
	private int tt_no;
	private String scr_name;
	private int scr_st_cnt;
	private String scr_crtdate;
	private int scr_price;
	private char scr_st_row;
	private int scr_st_col;
	private int scrstate_no;
	private int bk_st_cnt;
	
	private List<ScreenDto> result;
	

	

}
