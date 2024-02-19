package com.company.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.TheaterManageDao;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;

@Service
public class AddTheaterServiceImpl implements AddTheaterService {
	@Autowired
	TheaterManageDao dao;

	@Override
	public int ttInsert(TheaterDto dto) {
		return dao.ttInsert(dto);
	}

	@Override
	public TheaterDto readTT(TheaterDto dto) {
		return dao.readTT(dto);
	}

	@Override
	public int scrInsert(ScreenDto dto) {
		return dao.scrInsert(dto);
	}

	public int ttAndscrInsert(TheaterDto dto) {
		int result = 0; //
		char startRow = 'A';
		int startColumn = 1;

		dto.setTt_scrcnt(dto.getScreenList().size());

		// 1. 영화관 추가
		result = dao.ttInsert(dto);

		if (result > 0) {
			for (ScreenDto scr : dto.getScreenList()) {
				// 방금 추가된 영화관 tt_no가져온 걸 scrDto의 tt_no에다 넣기
				scr.setTt_no(dao.insertNowTheater());

				char endRow = scr.getScr_st_row();
				int endColumn = scr.getScr_st_col();
				int rowCount = endRow - startRow + 1;
				int columnCount = endColumn - startColumn + 1;
				System.out.println(rowCount * columnCount); // 총 좌석 수

				scr.setScr_st_cnt(rowCount * columnCount);

				result = dao.scrInsert(scr);
			}
		}

		return result;
	}

}
