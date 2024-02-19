package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScheduleResultDto {
	private int sch_no;
	private String mv_ktitle;
	private String mv_rating;
	private String sch_date;
	private String sch_start;
	private String sch_end;
	private String tt_name;
	private int scr_no;
	private String scr_name;
	private int sch_cnt;
	private int scr_st_cnt;
	private String schstate_state;
	private int available_seats;
	private String mv_cert;

}
