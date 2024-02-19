package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MovieDto {
	private int mv_cd;
	private String mv_ktitle;
	private String mv_etitle;
	private int mv_runtime;
	private String mv_plot;
	private String mv_dname;
	private String movie_genre;
	private String mv_aname;
	private String mv_rating;
	private String mv_nation;
	private String mv_company;
	private String mv_img;
	private String mv_start;
	private String mv_crtdate;
	private String mv_stilcut; 
	private String mv_video; 
	private int mv_popularity; 
	private String mv_cert;
	private boolean mv_live;
	/*
	  
	mv_cd	int	NO	PRI		auto_increment
mv_ktitle	varchar(255)	YES			
mv_etitle	varchar(255)	YES			
mv_runtime	int	YES			
mv_plot	text	YES			
mv_dname	varchar(255)	YES			
movie_genre	varchar(255)	YES			
mv_aname	varchar(255)	YES			
mv_rating	varchar(255)	YES			
mv_nation	varchar(255)	YES			
mv_company	varchar(255)	YES			
mv_img	varchar(255)	YES			
mv_start	date	YES			
mv_crtdate	datetime	YES
mv_stilcut  varchar(255) YES
mv_video    varchar(255) YES
mv_popularity int        YES 0
mv_cert     varchar(10)  YES
mv_live		tinyint(1)	NO	1	*/
}
