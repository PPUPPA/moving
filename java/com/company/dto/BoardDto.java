package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDto {
	private int board_no;
	private int user_no;
	private String b_title;
	private String b_content;
	private int b_hit;
	private String b_crtdate;
	private String b_ip;
}
