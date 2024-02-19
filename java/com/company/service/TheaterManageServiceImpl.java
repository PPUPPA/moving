package com.company.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.TheaterManageDao;
import com.company.dto.BrokenSeatDto;
import com.company.dto.TTandScrDto;
import com.company.dto.TheaterDto;

@Service
public class TheaterManageServiceImpl implements TheaterManageService {
	@Autowired
	TheaterManageDao dao;

	@Override
	public List<TheaterDto> theaterReadAll() {
		return dao.theaterReadAll();
	}

	@Override
	public int theaterDelete(int tt_no) {
		dao.screenDelete(tt_no);
		return dao.theaterDelete(tt_no);
	}

	@Override
	public TTandScrDto ttandscrRead(int scr_no) {
		TTandScrDto result = dao.ttandscrRead(scr_no);

		result.setBk_st_cnt(result.getBkCnt());

		return result;
	}

	@Override
	public int scrstateUpdate(Map<String, Integer> parameterMap) {
		return dao.scrstateUpdate(parameterMap);
	};

	@Override
	public TTandScrDto scrseat(int scr_no) {
		List<Character> list = new ArrayList();
		TTandScrDto resultDto = dao.ttandscrRead(scr_no);

		for (char i = 'A'; i <= resultDto.getScr_st_row(); i++) {
			list.add(i);
		}
		// System.out.println("list : " +list);
		resultDto.setList(list);

		resultDto.setSt_row(Integer.valueOf(resultDto.getScr_st_row() - 65));

		// System.out.println("문자열 숫자로변환 : " +resultDto.getSt_row());
		return resultDto;
	}

	@Override
	public int bkSeatInsert(BrokenSeatDto dto) {
		// System.out.println("bklist" +bkList);
		//System.out.println("bkSeatInsert 호출됨 - seatName: " + dto.getBk_st_name());
		return dao.bkSeatInsert(dto);
	}
	
	@Override
	public int bkSeatDelete(BrokenSeatDto dto) {
		
		return dao.bkSeatDelete(dto);
	}

	@Override
	public List<String> bkSeatReadAction(int scr_no) {
		//dao.bkSeatRead(scr_no);   //[BrokenSeatDto(bk_st_no=0, scr_no=0, bk_st_name=C2), BrokenSeatDto(bk_st_no=0, scr_no=0, bk_st_name=E4)]
		//System.out.println("bkSeatReadAction 도착~~");
		List<String> bkList = new ArrayList<>();
		TTandScrDto dto = new TTandScrDto();
		
		for(int i=0; i<dao.bkSeatRead(scr_no).size(); i++) {
			bkList.add(dao.bkSeatRead(scr_no).get(i).getBk_st_name());
		}

		//System.out.println("bkList : " + bkList);   // //bkList : [C2, E4]
		//System.out.println(bkList.get(0));

		dto.setBkStList(bkList);  
		//System.out.println(dto.getBkStList());

		return dto.getBkStList();
	}
	
	@Override
	public List<BrokenSeatDto> bkSeatRead(int scr_no){
		return dao.bkSeatRead(scr_no);
	}
	
	@Override
	public List<String> bkSeatReadAll(int scr_no){
		List<String> bkSeatLists = new ArrayList<>();
		List<BrokenSeatDto> bkSeat = bkSeatRead(scr_no);
		for(int i=0; i<bkSeat.size(); i++) {
			bkSeatLists.add(bkSeat.get(i).getBk_st_name());
		}
		
		return bkSeatLists;
	}
	
	
	

}
