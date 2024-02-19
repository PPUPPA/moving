package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScheduleStateDto {
	private int schstate_no;
	private String schstate_state;
	
//	mysql> desc schedulestate;
//	+----------------+--------------+------+-----+---------+----------------+
//	| Field          | Type         | Null | Key | Default | Extra          |
//	+----------------+--------------+------+-----+---------+----------------+
//	| schstate_no    | int          | NO   | PRI | NULL    | auto_increment |
//	| schstate_state | varchar(255) | YES  |     | NULL    |                |
//	+----------------+--------------+------+-----+---------+----------------+
}
