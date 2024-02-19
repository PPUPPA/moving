package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.company.dto.BoardDto;
import com.company.dto.MovieDto;
import com.company.service.BoardService;
import com.company.service.MovieService;
import com.company.service.PagingService;

@Controller
public class AsFrontController {
	@Autowired MovieService mv_service;
	@Autowired BoardService b_service;
	@Autowired PagingService p_service;
	
	/* USER - MOVIE */
	@RequestMapping(value="movie.as", method=RequestMethod.GET)
	public void movie(Model model) {
		model.addAttribute("list", mv_service.mv_readLive());
	}
	
	@RequestMapping(value="movieDetail.as", method=RequestMethod.GET)
	public void movieDetail(int mv_cd, Model model) {
		model.addAttribute("dto", mv_service.mv_read(mv_cd));
	}
	
	/* USER - NOTICE */
	@RequestMapping(value="notice.as", method=RequestMethod.GET)
	public void notice(@RequestParam(value="pstartno", defaultValue="0") int pstartno, Model model, @Param("searchType") String searchType, @Param("searchKey") String searchKey) {
		Map<String, Object> pagedData;

		if (searchKey == null) {
			pagedData = p_service.getPagedData(pstartno, "board");
	    } else {
	    	pagedData = p_service.getPagedData(pstartno, "board", searchType, searchKey);
	    }

        model.addAttribute("list", pagedData.get("list"));
        model.addAttribute("paging", pagedData.get("paging"));
	}
	
	@RequestMapping(value="noticeDetail.as", method=RequestMethod.GET)
	public void noticeDetail(int board_no, Model model) {
		model.addAttribute("dto", b_service.b_readDetail(board_no));
	}
	
	/* ADMIN - MOVIE */
	@RequestMapping(value="movie.admin", method=RequestMethod.GET)
	public void adminMovie(@RequestParam(value="pstartno", defaultValue="0") int pstartno, Model model, @Param("searchType") String searchType, @Param("searchKey") String searchKey) {
		Map<String, Object> livePagedData;
		Map<String, Object> unLivePagedData;
		
		if (searchKey == null) {
			livePagedData = p_service.getPagedData(pstartno, "live");
			unLivePagedData = p_service.getPagedData(pstartno, "unLive");
	    } else {
	    	livePagedData = p_service.getPagedData(pstartno, "live", searchType, searchKey);
	    	unLivePagedData = p_service.getPagedData(pstartno, "unLive", searchType, searchKey);
	    }
		
		model.addAttribute("liveList", livePagedData.get("list"));
		model.addAttribute("livePaging", livePagedData.get("paging"));
		
		model.addAttribute("unLiveList", unLivePagedData.get("list"));
		model.addAttribute("unLivePaging", unLivePagedData.get("paging"));

	}
	
	@RequestMapping(value="movieStatusChange.admin", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String changeMovieState(@RequestBody List<Integer> mv_cdList) {
        try {
            for (Integer mv_cd : mv_cdList) {
                MovieDto dto = mv_service.mv_read(mv_cd);
                dto.setMv_live(!dto.isMv_live());
                mv_service.mv_changeState(dto);
            }
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
	
	@RequestMapping(value="movieDetail.admin", method=RequestMethod.GET)
	public void adminMovieDetail(int mv_cd, Model model) {
		model.addAttribute("dto", mv_service.mv_read(mv_cd));
	}
	
	@RequestMapping(value="movieUpdate.admin", method=RequestMethod.GET)
	public void adminMovieUpdateView(int mv_cd, Model model) {
		model.addAttribute("dto", mv_service.mv_read(mv_cd));
	}

	@RequestMapping(value = "movieUpdate.admin", method = RequestMethod.POST)
	@ResponseBody
	public void adminMovieUpdate(@ModelAttribute MovieDto mv_dto, HttpServletResponse response, HttpServletRequest request) throws IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();

	    try {
	        if (mv_service.mv_update(mv_dto) > 0) {
	            out.println("<script>alert('영화 정보가 수정되었습니다.');location.href='" + request.getContextPath() + "/movieDetail.admin?mv_cd=" + mv_dto.getMv_cd() + "';</script>");
	        } else {
	            out.println("<script>alert('영화 정보 수정에 실패했습니다.');</script>");
	        }
	    } catch (Exception e) {
	        out.println("<script>alert('영화 정보 수정 중 오류가 발생했습니다.');</script>");
	        e.printStackTrace();
	    }
	}
	
	@RequestMapping(value="movieAdd.admin", method=RequestMethod.GET)
	public void adminMovieAdd() {}
	
	@RequestMapping(value="apiMovieAdd.admin", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
    public ResponseEntity<String> handleAddRequest(@RequestBody MovieDto mv_dto) {
        try {
            mv_service.mv_insert(mv_dto);

            return ResponseEntity.ok("Movie data added successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error adding movie data.");
        }
    }
	
	@GetMapping("apiCheckMvCd.admin")
	public ResponseEntity<Boolean> checkMvCd(@RequestParam int mv_cd) {
	    boolean mvCdExists = mv_service.mv_readLive().stream().anyMatch(movie -> movie.getMv_cd() == mv_cd) || mv_service.mv_readUnlive().stream().anyMatch(movie -> movie.getMv_cd() == mv_cd);
	    return ResponseEntity.ok(mvCdExists);
	}
	
	/* ADMIN - NOTICE */
	@RequestMapping(value="notice.admin", method=RequestMethod.GET)
	public void adminNotice(@RequestParam(value="pstartno", defaultValue="0") int pstartno, Model model, @Param("searchType") String searchType, @Param("searchKey") String searchKey) {
		Map<String, Object> pagedData;

		if (searchKey == null) {
			pagedData = p_service.getPagedData(pstartno, "board");
	    } else {
	    	pagedData = p_service.getPagedData(pstartno, "board", searchType, searchKey);
	    }
		
        model.addAttribute("list", pagedData.get("list"));
        model.addAttribute("paging", pagedData.get("paging"));
	}

	@RequestMapping(value="/noticeWrite.admin" , method=RequestMethod.GET)
	public void adminNoticeWrite() {}
	
	@RequestMapping(value="/noticeWrite.admin" , method=RequestMethod.POST)
	public void insert(BoardDto b_dto, HttpServletResponse response, HttpServletRequest request) throws IOException {  
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		b_dto.setB_ip(InetAddress.getLocalHost().getHostAddress());
		
		if(b_service.b_insert(b_dto) > 0) {
			out.println("<script>alert('게시글이 등록되었습니다.');location.href='" + request.getContextPath() + "/notice.admin';</script>");
		}else {
			out.println("<script>alert('게시글 등록에 실패했습니다.');history.go(-1);</script>");
		}
	}
	
	@RequestMapping(value="noticeDelete.admin", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public String adminDeleteNotice(@RequestBody List<Integer> board_noList) {
        try {
            for (Integer board_no : board_noList) {
                BoardDto dto = b_service.b_readDetail(board_no);
                b_service.b_delete(dto);
            }
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

	@RequestMapping(value="/noticeDetail.admin" , method=RequestMethod.GET)
	public void adminNoticeDetail(int board_no, Model model) {
		model.addAttribute("dto", b_service.b_readDetail(board_no));
	}
	
	@RequestMapping(value="/noticeUpdate.admin" , method=RequestMethod.GET)
	public void adminNoticeUpdateView(int board_no, Model model) {
		model.addAttribute("dto", b_service.b_updateView(board_no));
	}

	@RequestMapping(value="/noticeUpdate.admin" , method=RequestMethod.POST)
	public void adminNoticeUpdate(@ModelAttribute BoardDto b_dto, HttpServletResponse response, HttpServletRequest request) throws IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();

	    try {
	        if (b_service.b_update(b_dto) > 0) {
	            out.println("<script>alert('게시글이 수정되었습니다.');location.href='" + request.getContextPath() + "/noticeDetail.admin?board_no=" + b_dto.getBoard_no() + "';</script>");
	        } else {
	            out.println("<script>alert('게시글 수정에 실패했습니다.');</script>");
	        }
	    } catch (Exception e) {
	        out.println("<script>alert('게시글 수정 중 오류가 발생했습니다.');</script>");
	        System.out.println(b_dto);
	        e.printStackTrace();
	    }
	}	
}
