package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReservationDto {
	private int r_no;
	private int user_no;
	private int sch_no;
	private int rstate_no;
	private String r_crtdate;
	/*
	  
r_no	int	NO	PRI		auto_increment
user_no	int	YES	MUL		
sch_no	int	YES	MUL		
r_price	int	YES			
rstate_no	int	YES	MUL		
r_crtdate	datetime	YES									*/
}
