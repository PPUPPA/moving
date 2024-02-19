package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
	private int user_no;
	private int usertp_no;
	private String user_id;
	private String user_name;
	private String user_pass;
	private String user_nick;
	private String user_mail;
	private String user_age;
	private String user_phone;
	private String user_kakao;
	private String user_crtdate;
	private String user_ip;
	private String user_naver;
	/*
	user_no	int	NO	PRI auto_increment
	usertp_no	int	YES	MUL
	user_id	varchar(255)	YES
	user_name	varchar(255)	YES
	user_pass	varchar(255)	YES
	user_nick	varchar(255)	YES
	user_mail	varchar(255)	YES
	user_age	date	YES			
	user_phone	varchar(255)	YES
	user_kakao	varchar(255)	YES
	user_crtdate	datetime	YES			
	user_ip	varchar(255)	YES	
	*/		
}
