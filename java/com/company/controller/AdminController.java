package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.company.dao.TheaterManageDao;
import com.company.dto.BrokenSeatDto;
import com.company.dto.Reservation_ViewDto;
import com.company.dto.ScreenDto;
import com.company.dto.TheaterDto;
import com.company.service.AddTheaterService;
import com.company.service.ReservationService;
import com.company.service.ReviseTheaterService;
import com.company.service.TheaterManageService;
import com.google.gson.Gson;

@Controller
public class AdminController {
	@Autowired
	ReservationService r_service;
	@Autowired
	TheaterManageDao dao;

	@Autowired
	AddTheaterService ATservice;

	@Autowired
	ReviseTheaterService RTservice;

	@Autowired
	TheaterManageService service;

	@GetMapping("/main.admin")
	public String main() {
		return "ih_adminUser";
	}

	@GetMapping("/reservation_management.admin")
	public String reservation_management(Model model, HttpServletRequest request, Reservation_ViewDto dto) {

		dto.setPstartno(0);

		if (request.getParameter("pstartno") != null) {
			System.out.println("pstartno : " + request.getParameter("pstartno"));
			dto.setPstartno(Integer.parseInt(request.getParameter("pstartno")));
		}
		r_service.paging(dto, model);
		return "reservation_management";
	}

	@PostMapping("/admin_reservationCancel.admin")
	public void admin_reservationcancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		int result = r_service.admin_reservationcancel(request, response);
		PrintWriter out = response.getWriter();
		if (result > 0) {
			out.print("<script>alert('예매를 취소했습니다.');location.href='reservation_management.admin'</script>");
		} else {
			out.print("<script>alert('오류가 발생했습니다.');location.href='reservation_management.admin'</script>");
		}

	}

	@RequestMapping(value = "/theater-list.admin", method = RequestMethod.GET)
	public String theaterList(Model model) {
		model.addAttribute("theaterList", dao.theaterReadAll());

		return "theater_management";
	}

	// 영화관 목록 - 상영관 리스트 ajax로 받아옴
	@RequestMapping(value = "/screen-list.admin", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String screenList(@RequestParam("tt_no") int tt_no) {
		System.out.println(".... list ajax");

		Gson gson = new Gson();
		String json = gson.toJson(dao.screenReadAll2(tt_no));

		// List<ScreenDto> result = dao.screenReadAll2(tt_no);

		// System.out.println("상영관 list 값 " + json);

		return json;

	}

	@RequestMapping(value = "/add-theater.admin", method = RequestMethod.GET)
	public String addTheaterView() {
		return "add_theater";
	}

	@RequestMapping(value = "/add-theater.admin", method = RequestMethod.POST)
	public String addTheater(@ModelAttribute TheaterDto dto, RedirectAttributes redirectAttributes) {
		// System.out.println(dto);

		int isSuccess = ATservice.ttAndscrInsert(dto);
		// System.out.println(isSuccess);
		redirectAttributes.addFlashAttribute("isSuccess", isSuccess);

		return "redirect:theater-list.admin";
	}

	@RequestMapping(value = "/revise-theater.admin", method = RequestMethod.GET)
	public String reviseTheaterView(Model model, @RequestParam int tt_no) {
		model.addAttribute("dto", RTservice.theaterRead(tt_no));
		model.addAttribute("sdtoList", RTservice.screenReadAll2(tt_no));
		// System.out.println(RTservice.sreenRead(tt_no));
		return "revise_theater";
	}

	@RequestMapping(value = "/screen-info.admin", method = RequestMethod.GET, produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String screenInfo(ScreenDto sdto) {
		// System.out.println(sdto);
		// System.out.println(".... ajax2");
		System.out.println(sdto);

		Gson gson = new Gson();
		String json = gson.toJson(RTservice.screenRead(sdto));
		// System.out.println(json);

		return json;
	}

	@RequestMapping(value = "/revise-theater.admin", method = RequestMethod.POST)
	public String reviseTheater(TheaterDto dto, ScreenDto sdto, RedirectAttributes redirectAttributes) {
		// System.out.println("수정 영화관 "+dto);
		// System.out.println("수정 상영관 "+sdto);

		int tt = RTservice.theaterUpdate(dto);
		int scr = RTservice.screenUpdate(sdto);
		if (tt == 1 && scr == 1) {
			redirectAttributes.addFlashAttribute("isSuccess2", tt);
		}

		// System.out.println(RTservice.theaterUpdate(dto));
		// System.out.println(RTservice.screenUpdate(sdto));

		return "redirect:theater-list.admin";
	}

	@RequestMapping(value = "/delete-theater-view.admin", method = RequestMethod.GET)
	public String deleteTheaterView(Model model) {
		model.addAttribute("list", service.theaterReadAll());
		// System.out.println( service.theaterReadAll());
		return "delete_theater";
	}

	@RequestMapping(value = "/delete-theater.admin", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Integer> deleteTheater(@RequestParam("tt_no") int tt_no) {
		// System.out.println("tt_no : " +tt_no);
		int re = service.theaterDelete(tt_no);
		// System.out.println(re);
		Map<String, Integer> result = new HashMap<>();
		result.put("result", re);
		return result;
	}

	@RequestMapping(value = "/screen-manage.admin", method = RequestMethod.GET)
	public String screenManage(Model model, @RequestParam("scr_no") int scr_no) {
		// System.out.println("scr_no 값 : "+scr_no);
		// System.out.println(service.ttandscrRead(scr_no));
		model.addAttribute("dto", service.ttandscrRead(scr_no));

		return "screen_management";
	}

	@RequestMapping(value = "/revise-screen.admin", method = RequestMethod.GET)
	public String reviseStopScreen(@RequestParam("scr_no") int scr_no, @RequestParam("scrstate_no") int scrstate_no) {
		Map<String, Integer> parameterMap = new HashMap<>();
		parameterMap.put("scr_no", scr_no);
		parameterMap.put("scrstate_no", scrstate_no);
		// System.out.println(scr_no);
		// System.out.println(scrstate_no);
		// System.out.println(parameterMap);
		service.scrstateUpdate(parameterMap);

		return "redirect:screen-manage.admin?scr_no=" + scr_no;
	}

	@RequestMapping(value = "/seat-manage.admin", method = RequestMethod.GET)
	public String seatManage(Model model, @RequestParam("scr_no") int scr_no) {

		// 고장난 좌석 리스트 보내기
		// model.addAttribute("bkSeatLists", service.bkSeatReadAction(scr_no));
		// model.addAttribute("bkLists", service.bkSeatReadAction(scr_no));

		// System.out.println("scr_no 값 : "+scr_no);
		// System.out.println(service.scrseat(scr_no));
		/**
		 * scr_no로 해당 broken_seat 애들 리스트로 다 불러서 css background-color 처리 해줌
		 **/
		model.addAttribute("bkSeatLists", service.bkSeatReadAll(scr_no));

		model.addAttribute("dto", service.scrseat(scr_no));

		return "seat_management";
	}

	@RequestMapping(value = "/seat-manage.admin", method = RequestMethod.POST)
	@ResponseBody
	public int seatManageAction(Model model, @RequestParam("scr_no") int scr_no, @RequestParam String bkList,
			@RequestParam String ActiveSTList) {
		int result = 1;

		System.out.println("체크된 보류될 좌석들  : " + bkList);
		System.out.println("체크된 활성화될 좌석들 : " + ActiveSTList);

		BrokenSeatDto InsertBkDto = new BrokenSeatDto();
		BrokenSeatDto DeleteBkDto = new BrokenSeatDto();
		InsertBkDto.setScr_no(scr_no);
		DeleteBkDto.setScr_no(scr_no);

		// 좌석 목록을 배열로 변환
		List<String> seatBkNames = Arrays.asList(bkList.replace("[", "").replace("]", "").split(","));
		List<String> ActiveSTNames = Arrays.asList(ActiveSTList.replace("[", "").replace("]", "").split(","));
		// System.out.println("체크된 활성화될 좌석들22 : " + ActiveSTNames);

		
		// 보류좌석 추가 기능 실행  seatBkNames가 비어있지 않은 경우에만 작동
		if (seatBkNames.stream().anyMatch(name -> !name.trim().isEmpty())) { // seatBkNames:[] 빈 문자열로 인식
			// seatBkNames 보류 좌석들 처리
			for (String seatName : seatBkNames) {
			
				// 좌석 값에서 "" 제거
				seatName = seatName.replace("\"", "");
				// 좌석 정보를 개별적으로 추가
				InsertBkDto.setBk_st_name(seatName);

				service.bkSeatInsert(InsertBkDto);
				System.out.println("insertBKDto" + InsertBkDto);

			}
			

		}
		// 활성화될 좌석 기능 실행  ActiveSTNames가 비어있지 않은 경우에만 작동
		if (ActiveSTNames.stream().anyMatch(name -> !name.trim().isEmpty())) {
			// ActiveSTNames 활성화될 좌석들 처리
			for (String seatName2 : ActiveSTNames) {
				// 좌석 값에서 "" 제거
				seatName2 = seatName2.replace("\"", "");
				// 좌석 정보를 개별적으로 추가
				DeleteBkDto.setBk_st_name(seatName2); 

				service.bkSeatDelete(DeleteBkDto);
				System.out.println("deleteBKDto : " + DeleteBkDto);

			}
		} 
		else if (!seatBkNames.stream().anyMatch(name -> !name.trim().isEmpty())
				&& !ActiveSTNames.stream().anyMatch(name -> !name.trim().isEmpty())) { // seatBkNames:[] 일 때 result=2로 설정.
			result = 2;
		}
		// System.out.println(result);

		return result;
	}

}
