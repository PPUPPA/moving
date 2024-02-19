package com.company.service;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sound.sampled.AudioFileFormat;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.TargetDataLine;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.NoTransactionException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.company.dao.ReservationDao;
import com.company.dto.*;
import com.company.util.MicrophoneRecorder;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import lombok.Data;

@Service("reservationService")
public class ReservationServiceImpl implements ReservationService {

	@Autowired
	ReservationDao dao;

	@Override
	public void reservation_view(HttpServletRequest request,HttpServletResponse response) throws IOException{
		HttpSession session=request.getSession();
		
		request.setAttribute("movieList",dao.getAllMovieList());
		request.setAttribute("theaterList",dao.getAllTheaterList());
		request.setAttribute("age_check",  dao.age_check((int)session.getAttribute("user_no")));
	}
	
	@Override
	public List<TheaterDto> getAllTheaterList() {
		return dao.getAllTheaterList();
	}

	@Override
	public List<TheaterDto> getTheaterList(Reservation_ViewDto dto) {
		return dao.getTheaterList(dto);
	}

	@Override
	public Reservation_ViewDto allClick(Reservation_ViewDto dto) {
		return dao.allClick(dto);
	}

	@Override
	public List<MovieDto> getMovieList(Reservation_ViewDto dto) {
		return dao.getMovieList(dto);
	}

	@Override
	public List<MovieDto> getAllMovieList() {
		// TODO Auto-generated method stub
		return dao.getAllMovieList();
	}

	@Override
	public List<ScheduleDto> getDateList(Reservation_ViewDto dto) {
		return dao.getDateList(dto);
	}

	@Override
	public List<Reservation_ViewDto> getScheduleList(Reservation_ViewDto dto) {
		return dao.getScheduleList(dto);
	}

	@Override
	public ScreenDto getSeatList(ScheduleDto dto) {

		return dao.getSeatList(dto);
	}

	@Override
	public List<BrokenSeatDto> getBrokenSeatList(ScheduleDto dto) {

		return dao.getBrokenSeatList(dto);
	}

	@Override
	public Reservation_ViewDto getPayList(ScheduleDto dto) {
		// TODO Auto-generated method stub
		return dao.getPayList(dto);
	}

	@Override
	public void kakaoPay(HttpServletRequest request, HttpServletResponse response, Reservation_ViewDto dto)
			throws IOException {
		String contextPath = request.getContextPath();
        
        // 전체 URL에서 컨텍스트 경로를 제거하여 필요한 부분 가져오기
        StringBuffer requestUrl = request.getRequestURL();
        String baseUrl = requestUrl.substring(0, requestUrl.indexOf(contextPath) + contextPath.length());
 
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		HttpSession session = request.getSession();
		PrintWriter pw = response.getWriter();
		int adult = Integer.parseInt(request.getParameter("adult"));
		int aprice = Integer.parseInt(request.getParameter("aprice"));
		int child = Integer.parseInt(request.getParameter("child"));

		int kprice = Integer.parseInt(request.getParameter("kprice"));
		int sum = adult * aprice + child * kprice;
		session.setAttribute("dto", dto);
		String result = "";
		try {
			URL address = new URL("https://kapi.kakao.com/v1/payment/ready");

			HttpURLConnection conn = (HttpURLConnection) address.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Authorization", "KakaoAK 5d9ce1efc233ae9f69560560f923966b");
			conn.setRequestProperty("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true); 
			String parameter = "cid=TC0ONETIME" + 
					"&partner_order_id=partner_order_id" + 
					"&partner_user_id=partner_user_id" + 
					"&item_name=Moving" + 
					"&quantity=1" + 
					"&total_amount=" + sum + 
					"&vat_amount=300" + // 
					"&tax_free_amount=0" + 
					"&approval_url="+baseUrl+"/success.ks" +
					"&fail_url="+baseUrl+"/fail.ks" + 
					"&cancel_url="+baseUrl+"/cancel.ks"; 
			DataOutputStream out = new DataOutputStream(conn.getOutputStream());
			out.writeBytes(parameter);
			out.close();

			BufferedReader br = null;
			StringBuffer sb = new StringBuffer();
			String line = "";

			if (conn.getResponseCode() == 200) {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			result = sb.toString();

			JsonParser parser = new JsonParser();
			JsonObject job = (JsonObject) parser.parse(result);
			result = job.get("next_redirect_pc_url").getAsString();
			System.out.println("result : " + result);
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		pw.print("<script>location.href='" + result + "'</script>");

	}

	@Override
	public Integer getRno() {
		return dao.getRno();
	}

	@Override
	public int insertReservation(Reservation_ViewDto dto) {
		return dao.insertReservation(dto);
	}

	@Override
	public int insertReservationDetailA(Reservation_ViewDto dto) {
		return dao.insertReservationDetailA(dto);
	}

	@Override
	public int insertReservationDetailC(Reservation_ViewDto dto) {
		return dao.insertReservationDetailC(dto);
	}

	@Override
	@Transactional
	public void success(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		HttpSession session = request.getSession();
		PrintWriter pw = response.getWriter();
		Reservation_ViewDto dto = new Reservation_ViewDto();
		int result = 0;
		dto = (Reservation_ViewDto) session.getAttribute("dto");

		dto.setUser_no((int)session.getAttribute("user_no"));
		dto.setScr_price(dto.getAdult() * dto.getAprice() + dto.getChild() * dto.getKprice());
		if (dao.getRno() == null) {
			dto.setR_no(1);
		} else {
			dto.setR_no(dao.getRno());
		}

		try {

			dao.insertReservation(dto);

			if (dto.getAdult() != 0) {
				for (int i = 0; i < dto.getAdult(); i++) {
					dto.setRd_st_name(dto.getSeat()[i]);
					dao.insertReservationDetailA(dto);
					dao.updateScheduleCnt(dto);
				}
			}

			if (dto.getChild() != 0) {
				for (int i = 0; i < dto.getChild(); i++) {
					dto.setRd_st_name(dto.getSeat()[i + dto.getAdult()]);
					dao.insertReservationDetailC(dto);
					dao.updateScheduleCnt(dto);
				}
			}
			result = 1;
		}

		catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

		}
		session.removeAttribute("dto");
		if (result == 1) {
			pw.print("<script>alert('예매를 완료했습니다.');location.href='my_reservation.ks';</script>");
		} else {
			pw.print("<script>alert('예매를 실패했습니다. 관리자에게 문의해주세요.');location.href='main.ks';</script>");
		}

	}
	@Override
	public void fail(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter pw = response.getWriter();
		pw.print("<script>alert('결제에 실패했습니다. 관리자에게 문의해주세요.');location.href='main.ks';</script>");
	}

	@Override
	public void cancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter pw = response.getWriter();
		pw.print("<script>alert('결제를 취소했습니다.');location.href='main.ks';</script>");
	}

	@Override
	public void seat_view(Model model, ScheduleDto dto) {
		ScreenDto screenDto = new ScreenDto();
		screenDto = dao.getSeatList(dto);
		char row = screenDto.getScr_st_row();
		List<String> list = new ArrayList<>();
		for (char ch = 'A'; ch <= row; ch++) {
			list.add(String.valueOf(ch));
		}
		model.addAttribute("row", row - 65);
		model.addAttribute("col", screenDto.getScr_st_col());
		model.addAttribute("list", list);
		model.addAttribute("brokenSeatList", dao.getBrokenSeatList(dto));
		model.addAttribute("reservedSeatList", dao.getReservedSeatList(dto));
	}

	@Override
	public void my_reservation_view(Reservation_ViewDto dto, Model model,HttpServletRequest request) throws IOException{
		HttpSession session = request.getSession();
		dto.setUser_no((int)session.getAttribute("user_no"));
		model.addAttribute("list1", dao.getMyReservationView_1(dto));

	}

	@Override
	public List<ReservationdetailDto> getMyReservationView_2(Reservation_ViewDto dto) {
		return dao.getMyReservationView_2(dto);
	}

	@Override
	@Transactional
	public void reservationcancel(Reservation_ViewDto dto, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter pw = response.getWriter();
		int result = 0;

		try {

			dao.reservationcancel(dto);
			dao.reservationcancelCnt(dto);

			result = 1;
		}

		catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			request.getRequestDispatcher("success.ks");
		}

		if (result == 1) {
			pw.print("<script>alert('예매를 취소했습니다.');location.href='my_canceled_reservation.ks';</script>");
		} else {
			pw.print("<script>alert('실패했습니다. 관리자에게 문의해주세요.');location.href='main.ks';</script>");
		}
	}

	@Override
	public void my_canceled_reservation_view(Reservation_ViewDto dto, Model model,HttpServletRequest request) throws IOException {
		HttpSession session = request.getSession();
		dto.setUser_no((int)session.getAttribute("user_no"));
		model.addAttribute("list1", dao.getMycanceledReservationView(dto));

	}

	@Data
	public class PagingUtil {

		List<Reservation_ViewDto> rvlist10;

		// 1. 전체 게시판 개수 = 196
		int listTotal;
		// 2. 한 페이지당 보여줄(레코드-튜플-줄) 갯수 : 10 #
		int onepagelimit;
		// 3. 하단 전체페이지 : 196/10+1
		int pageAll;
		// 1(0) 2(10) 3(20) 4(30) 5(40) 6(50) 7(60) 8(70) 9(80) 10(90) 다음
		// 이전 11 12 13 14 15 16 17 18 19 20 다음
		// 4. 시작번호
		int pstartno;
		// 5. 하단 네비게이션 (보여줄 갯수)
		int bottomnav;
		// 6. 현재 네비게이션번호 #
		int currentBtn;
		// 7. 현재 네비게이션번호의 시작번호
		int startBtn;
		// 8. 현재 네비게이션번호의 끝번호
		int endBtn;

		public PagingUtil() {
		}

		public void rvPaging(Reservation_ViewDto dto) {
			// 1. 전체 게시판 개수
			listTotal = dao.rvcount(dto);
			// 2. 한 페이지당 보여줄(레코드-튜플-줄) 갯수
			onepagelimit = 10;
			// 3. 하단 전체페이지
			pageAll = (int) Math.ceil(listTotal / (double) onepagelimit);
			// 1(0) 2(10) 3(20) 4(30) 5(40) 6(50) 7(60) 8(70) 9(80) 10(90) 다음
			// 이전 11(100) 12 13 14 15 16 17 18 19 20 다음
			// 이전 21(200) 12 13 14 15 16 17 18 19 20 다음

			// 1(0~9) 2(10~19) 3(20~29) 4(30) 5(40) 6(50) 7(60) 8(70) 9(80) 10(90) 다음
			// 이전 11(100~109) 12 13 14 15 16 17 18 19 20 다음
			// 4. 시작번호
			// 5. 하단 네비게이션 (보여줄 갯수)
			bottomnav = 10;
			// 6. 현재 네비게이션번호 #
			currentBtn = (int) Math.ceil((pstartno + 1) / (double) onepagelimit);
			// 7. 현재 네비게이션번호의 시작번호
			startBtn = currentBtn == 1 ? ((currentBtn) / bottomnav) * 10 + 1 : ((currentBtn - 1) / bottomnav) * 10 + 1;
			// 8. 현재 네비게이션번호의 끝번호
			endBtn = startBtn + (bottomnav - 1);
			if (pageAll < endBtn) {
				endBtn = pageAll;
			}
			rvlist10 = dao.rvlist10(dto);
		}

	}

	@Override
	public void paging(Reservation_ViewDto dto, Model model) {
		PagingUtil paging = new PagingUtil();
		paging.setPstartno(dto.getPstartno());
		paging.rvPaging(dto);
		model.addAttribute("paging", paging);
	}

	@Override
	@Transactional
	public int admin_reservationcancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String r_no[] = request.getParameterValues("r_no");

		int cnt = 0;

		try {
			for (int i = 0; i < r_no.length; i++) {
				dao.admin_reservationcancelCnt(Integer.parseInt(r_no[i]));
				if (dao.admin_reservationcancel(Integer.parseInt(r_no[i])) > 0) {
					cnt += 1;
				}

			}

		}

		catch (Exception e) {
			e.printStackTrace();
			cnt = 0;
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

		}

		return cnt;
	}
	
	
	@Override
	public String stt(@RequestParam MultipartFile file,HttpServletRequest request,HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String save = file.getOriginalFilename()+".wav"; // 파일 이름 설정
		String rootPath=request.getSession().getServletContext().getRealPath("/");
		rootPath+="resources/upload";

		File target = new File(rootPath, save);
		
		try {
			FileCopyUtils.copy(file.getBytes(), target); // 파일 업로드

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String openApiURL = "http://aiopen.etri.re.kr:8000/WiseASR/Recognition";
		String accessKey = "5ce3c9a0-4748-4ec6-b128-1ed3a9a4ac3b"; // 발급받은 API Key
		String languageCode = "korean"; // 언어 코드
		String audioFilePath = rootPath+"/file.wav"; // 녹음된 음성 파일 경로
		String audioContents = null;

		Gson gson = new Gson();

		Map<String, Object> ApiRequest = new HashMap<>();
		Map<String, String> argument = new HashMap<>();

		try {

			Path path = Paths.get(audioFilePath);
			byte[] audioBytes = Files.readAllBytes(path);
			audioContents = Base64.getEncoder().encodeToString(audioBytes);
		} catch (IOException e) {
			e.printStackTrace();
		}

		argument.put("language_code", languageCode);
		argument.put("audio", audioContents);

		ApiRequest.put("argument", argument);

		URL url;
		Integer responseCode = null;
		String responBody = null;
		DataOutputStream wr = null;
		try {
			url = new URL(openApiURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("POST");
			con.setDoOutput(true);
			con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			con.setRequestProperty("Authorization", accessKey);

			wr = new DataOutputStream(con.getOutputStream());
			wr.write(gson.toJson(ApiRequest).getBytes("UTF-8"));

			wr.flush();
			wr.close();

			responseCode = con.getResponseCode();
			InputStream is = con.getInputStream();
			byte[] buffer = new byte[is.available()];
			int byteRead = is.read(buffer);
			responBody = new String(buffer);
			
			System.out.println("rootPath : "+rootPath);
			System.out.println("[responseCode] " + responseCode);
			System.out.println("[responBody]");

			System.out.println(responBody);

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println(e);
		}

		return responBody;
	}



	
	

}
