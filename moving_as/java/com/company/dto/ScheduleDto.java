package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScheduleDto {
	private int sch_no;
	private int scr_no;
	private int mv_cd;
	private String sch_date;
	private String sch_start;
	private String sch_end;
	private String sch_crtdate;
	private int schstate_no;
	private int sch_cnt;
	
//	mysql> desc schedule;
//	+-------------+----------+------+-----+---------+----------------+
//	| Field       | Type     | Null | Key | Default | Extra          |
//	+-------------+----------+------+-----+---------+----------------+
//	| sch_no      | int      | NO   | PRI | NULL    | auto_increment |
//	| scr_no      | int      | YES  | MUL | NULL    |                |
//	| mv_cd       | int      | YES  | MUL | NULL    |                |
//	| sch_date    | date     | YES  |     | NULL    |                |
//	| sch_start   | time     | YES  |     | NULL    |                |
//	| sch_end     | time     | YES  |     | NULL    |                |
//	| sch_period  | int      | YES  |     | NULL    |                |
//	| sch_crtdate | datetime | YES  |     | NULL    |                |
//	| schstate_no | int      | YES  | MUL | NULL    |                |
//	| sch_cnt     | int      | YES  |     | NULL    |                |
//	+-------------+----------+------+-----+---------+----------------+
}
