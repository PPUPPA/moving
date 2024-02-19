package com.company.dao;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import com.company.dto.*;


@MyDao
public interface ReservationDao {
	public int age_check(int user_no);
	public List<TheaterDto> getAllTheaterList();
	public List<TheaterDto> getTheaterList(Reservation_ViewDto dto);
	public List<MovieDto> getAllMovieList();
	public List<MovieDto> getMovieList(Reservation_ViewDto dto);
	public List<ScheduleDto> getDateList(Reservation_ViewDto dto);
	public Reservation_ViewDto allClick(Reservation_ViewDto dto);
	public List<Reservation_ViewDto> getScheduleList(Reservation_ViewDto dto);
	public ScreenDto getSeatList(ScheduleDto dto);
	public List<BrokenSeatDto> getBrokenSeatList(ScheduleDto dto);
	public List<ReservationdetailDto> getReservedSeatList(ScheduleDto dto);
	public void seat_view(Model model,ScheduleDto dto);
	public Reservation_ViewDto getPayList(ScheduleDto dto);
	public void kakaoPay(HttpServletRequest request,HttpServletResponse response,Reservation_ViewDto dto) throws IOException;
	public void success(HttpServletRequest request,HttpServletResponse response) throws Exception;
	public Integer getRno();
	public int insertReservation(Reservation_ViewDto dto);
	public int updateScheduleCnt(Reservation_ViewDto dto);
	public int insertReservationDetailA(Reservation_ViewDto dto);
	public int insertReservationDetailC(Reservation_ViewDto dto);
	public void my_reservation_view(Reservation_ViewDto dto,Model model);
	public List<ReservationdetailDto> getMyReservationView_1(Reservation_ViewDto dto);
	public List<ReservationdetailDto> getMyReservationView_2(Reservation_ViewDto dto);
	public int reservationcancel(Reservation_ViewDto dto);
	public void reservationcancelCnt(Reservation_ViewDto dto);
	public List<ReservationdetailDto> getMycanceledReservationView(Reservation_ViewDto dto);
	public List<ReservationdetailDto> getAllReservationList();
	
	public void paging(Reservation_ViewDto dto);
	public int rvcount(Reservation_ViewDto dto);
	public List<Reservation_ViewDto> rvlist10(Reservation_ViewDto dto);
	public int admin_reservationcancel(int r_no);
	public int admin_reservationcancelCnt(int r_no);
	
	
}
