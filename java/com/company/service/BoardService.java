package com.company.service;

import java.util.List;

import com.company.dto.BoardDto;

public interface BoardService {
	public int b_insert(BoardDto dto);
	public int b_update(BoardDto dto);
	public int b_delete(BoardDto dto);
	
	public BoardDto b_readDetail(int board_no);
	public BoardDto b_updateView(int board_no);
	
	public List<BoardDto> b_readAll();
}
