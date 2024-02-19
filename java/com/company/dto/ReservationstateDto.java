package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReservationstateDto {
	private int rstate_no;
	private String rstate_state;
	/*
	  
rstate_no	int	NO	PRI		auto_increment
rstate_state	varchar(255)	YES							*/
}
