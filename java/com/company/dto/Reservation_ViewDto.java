package com.company.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Reservation_ViewDto {
	private String tt_name;
	private String mv_img;
	private String mv_start;
	private int tt_no;
	private String mv_ktitle;
	private int mv_cd;
	private String sch_date;
	private int sch_no;
	private String scr_name;
	private String sch_start;
	private String sch_end;
	private int sch_cnt;
	private int scr_st_cnt;
	private int scr_price;
	
	private int user_no;
	private String user_name;
	private String seat[];
	private String rd_st_name;
	private int adult;
	private int aprice;
	private int child;
	private int kprice;
	private int r_no;
	private int r_price;
	private int rstate_no;
	private String rstate_state;
	private int pstartno;
	/*
	 * select mv.mv_ktitle, r.r_no, tt.tt_name, scr.scr_name, sch.sch_date,sch.sch_start,sch.sch_end,r.r_price
from reservation r join theater tt join screen scr join schedule sch join movie mv join schedulestate sst
on(r.sch_no=sch.sch_no and scr.scr_no=sch.scr_no and scr.tt_no=tt.tt_no 
and sch.schstate_no=sst.schstate_no and sch.mv_cd=mv.mv_cd) where r_no=1 and r.rstate_no=1;
	String seat[]=request.getParameter("seat").split(",");
		int sch_no=Integer.parseInt(request.getParameter("sch_no"));
		int adult=Integer.parseInt(request.getParameter("adult"));
		int aprice=Integer.parseInt(request.getParameter("aprice"));
		int child=Integer.parseInt(request.getParameter("child"));
		int cprice=Integer.parseInt(request.getParameter("cprice"));								*/
}
