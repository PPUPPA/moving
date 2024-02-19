package com.company.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TheaterDto {
	private int tt_no;
	private String tt_name;
	private String tt_tel;
	private String tt_start;
	private String tt_close;
	private int tt_scrcnt;
	private String tt_img;
	private String tt_address;
	private String tt_crtdate;
	private int total_st_cnt;
	
	List<ScreenDto> screenList;
	
}
