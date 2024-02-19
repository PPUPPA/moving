package com.company.service;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.BoardDao;
import com.company.dto.BoardDto;

@Service
public class BoardServiceImpl implements BoardService {
	@Autowired BoardDao dao;
	
	@Override public int b_insert(BoardDto dto) {
		try { dto.setB_ip(InetAddress.getLocalHost().getHostAddress());
		} catch (UnknownHostException e) { e.printStackTrace();
		} return dao.b_insert(dto);
	}

	@Override public int b_update(BoardDto dto) { return dao.b_update(dto); }
	@Override public int b_delete(BoardDto dto) { return dao.b_delete(dto); }

	@Override public BoardDto b_readDetail(int board_no) {
		dao.b_update_hit(board_no);
		return dao.b_read(board_no);
	}

	@Override public BoardDto b_updateView(int board_no) { return dao.b_read(board_no); }
	@Override public List<BoardDto> b_readAll() { return dao.b_readAll(); }
}
