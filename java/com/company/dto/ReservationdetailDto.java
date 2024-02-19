package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReservationdetailDto {
	private int rd_no;
	private int r_no;
	private String rd_st_name;
	private char as_code;
	private int rd_price;
	/*
	  
rd_no	int	NO	PRI		auto_increment
r_no	int	YES	MUL		
rd_st_name	varchar(255)	YES			
as_code	char(1)	YES	MUL		
rd_price	int	YES											*/
}
