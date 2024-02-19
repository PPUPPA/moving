package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScreenStateDto {
	private int scrstate_no;
	private String scrstate_state;
	
//	mysql> desc screenstate;
//	+----------------+--------------+------+-----+---------+----------------+
//	| Field          | Type         | Null | Key | Default | Extra          |
//	+----------------+--------------+------+-----+---------+----------------+
//	| scrstate_no    | int          | NO   | PRI | NULL    | auto_increment |
//	| scrstate_state | varchar(255) | YES  |     | NULL    |                |
//	+----------------+--------------+------+-----+---------+----------------+
}
