package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UsertypeDto {
	private int usertp_no;
	private String usertp_name;
	
	/*
	  
	 usertp_no	int	NO	PRI		auto_increment
	usertp_name	varchar(255)	YES			*/
}
