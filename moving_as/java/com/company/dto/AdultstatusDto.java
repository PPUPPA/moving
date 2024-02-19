package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AdultstatusDto {
	private char as_code;
	private String as_title;
	/*
	  
as_code	char(1)	NO	PRI		
as_title	varchar(255)	YES										*/
}
