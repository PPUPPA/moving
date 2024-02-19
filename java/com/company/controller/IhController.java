package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;


import java.net.Inet4Address;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.company.dto.IhResultDto;
import com.company.dto.UserDto;
import com.company.dto.UserDtoXml;
import com.company.dto.UsertypeDto;
import com.company.service.IhService;

@Controller
public class IhController {
    @Autowired IhService service;
    
////////////////////////  회원가입페이지  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// 회원가입페이지로
	@RequestMapping(value="/joinForm.ih" , method=RequestMethod.GET)
	public String joinForm() {  return "ih_joinForm"; }
	
	//회원가입페이지에서 submit버튼누르면
		@RequestMapping(value="/submitJoinForm.ih", method=RequestMethod.POST)
		public String login(HttpServletResponse response, HttpServletRequest request, RedirectAttributes rttr) throws IOException, ParseException {
		    response.setContentType("text/html; charset=UTF-8");
		    // Map으로 데이터 받기
		    Map<String, String> map = new HashMap<>();
		    map.put("id", request.getParameter("id"));
		    map.put("name", request.getParameter("name"));
		    map.put("password", request.getParameter("password"));
		    map.put("nickname", request.getParameter("nickname"));
		    map.put("email", request.getParameter("email"));
		    map.put("phonenumber", request.getParameter("phonenumber"));
		    map.put("IP", Inet4Address.getLocalHost().getHostAddress());
		    map.put("age", request.getParameter("age"));
		    
		    // 나이 형식 변환
		    SimpleDateFormat inputType = new SimpleDateFormat("yyyyMMdd");
		    SimpleDateFormat tableType = new SimpleDateFormat("yyyy-MM-dd");
		    Date date = inputType.parse(map.get("age"));
		    String tableTypeAge = tableType.format(date);
		    map.put("age", tableTypeAge);
		    
		    // 비밀번호 해싱
		    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		    String hashedPassword = passwordEncoder.encode(map.get("password"));
		    map.put("password", hashedPassword);
		    
		    // DTO 설정
		    UserDto dto = new UserDto();
		    dto.setUser_id(map.get("id"));
		    dto.setUser_name(map.get("name"));
		    dto.setUser_pass(map.get("password"));
		    dto.setUser_nick(map.get("nickname"));
		    dto.setUser_mail(map.get("email"));
		    dto.setUser_phone(map.get("phonenumber"));
		    dto.setUser_age(map.get("age"));
		    dto.setUser_ip(map.get("IP"));
		    
		    // 회원가입 서비스 호출
		    int result = service.join(dto);
		    if (result == 1) {
		        rttr.addFlashAttribute("joinSuccess", "회원가입을 성공했습니다.");
		        return "redirect:/loginPage.ih";
		    } else {
		        System.out.println("가입실패");
		        rttr.addFlashAttribute("joinFail", "관리자에게 문의해주세요.");
		        return "redirect:/joinForm.ih";
		    }
		}
	
	//아이디 중복검사
	@RequestMapping(value="/idCheck.ih", method=RequestMethod.GET)
	public void idCheck(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out =response.getWriter();
		String result ="<span style='color:blue'></span>";
		int cnt = -1; 
		
		String id = request.getParameter("id");
		if(id.equals("")) {
			result="<span style='color:red'>아이디를 입력해주세요.</span>";
			out.print(result);
		}else {
			dto.setUser_id(id);
			cnt = service.idCheck(dto);
			if(cnt==0) {
				result ="<span style='color:blue'>중복되지않는 아이디입니다.</span>";
				out.print(result);
			}else if(cnt>=1) {
				result ="<span style='color:red'>중복된 아이디입니다.</span>";
				out.print(result);
			}
		}
	}
	
	// 닉네임 중복검사
	@RequestMapping(value="/nicknameCheck.ih", method=RequestMethod.GET)
	public void nicknameCheck(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out =response.getWriter();
		String result ="<span style='color:blue'></span>";
		int cnt = -1; 
		
		String nickname = request.getParameter("nickname");
		if(nickname.equals("")) {
			result="<span style='color:red'>닉네임을 입력해주세요.</span>";
			out.print(result);
		}else {
			dto.setUser_nick(nickname);
			cnt = service.nicknameCheck(dto);
			if(cnt==0) {
				result ="<span style='color:blue'>중복되지않는 닉네임입니다.</span>";
				out.print(result);
			}else if(cnt>=1) {
				result ="<span style='color:red'>중복된 닉네임입니다.</span>";
				out.print(result);
			}
		}
	}
	
	// 이메일 중복검사
	@RequestMapping(value="/emailCheck.ih", method=RequestMethod.GET)
	public void emailCheck(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out =response.getWriter();
		String result ="<span style='color:blue'></span>";
		int cnt = -1; 
		
		String email = request.getParameter("email");
		if(email.equals("")) {
			result="<span style='color:red'>이메일을 입력해주세요.</span>";
			out.print(result);
		}else {
			dto.setUser_mail(email);
			cnt = service.emailCheck(dto);
			if(cnt==0) {
				result ="<span style='color:blue'>중복되지않는 이메일입니다.</span>";
				out.print(result);
			}else if(cnt>=1) {
				result ="<span style='color:red'>중복된 이메일입니다.</span>";
				out.print(result);
			}
		}
	}
////////////////////////  회원가입페이지  ////////////////////////////////////

////////////////////////  로그인페이지  /////////////////////////////////////
	
	// 로그인뷰
	@RequestMapping(value="/loginPage.ih" , method=RequestMethod.GET)
	public String loginPage(
			Model model, 
			@CookieValue(value = "rememberId", defaultValue = "") String rememberId) {
		model.addAttribute("id", rememberId);
		return "ih_loginPage"; 
	}
	
    // 로그인 시도 시 아이디와 비밀번호 검사
	@RequestMapping(value="/userCheck.ih", method=RequestMethod.POST)
	public void userCheck(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    String result = "pass";
	    
	    String user_id = request.getParameter("id");
	    String user_pass = request.getParameter("password");
	    System.out.println("dddddd");
	    dto.setUser_id(user_id);
	    
	    // 데이터베이스에서 사용자의 해싱된 비밀번호를 가져옵니다.
	    String hashedPassword = service.getHashedPassword(dto);
	    System.out.println(hashedPassword);
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    boolean isPasswordMatch = passwordEncoder.matches(user_pass, hashedPassword);
	    if(!isPasswordMatch) {
	        result = "<span style='color:red'>아이디와 비밀번호를 확인해주세요.</span>";
	        out.print(result);
	    } else {
	        out.print(result);
	    }
	}
	
	// 로그인 submit
	@PostMapping(value="/loginBtn.ih")
	public String goLogin(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, UserDto dto, RedirectAttributes rttr) throws ServletException, IOException {
	    String id = request.getParameter("id");
	    String remember = request.getParameter("remember");
	    dto.setUser_id(id);

	    IhResultDto loginResult = service.login(dto);

	    if (loginResult != null) {
	        dto = loginResult.getUser();
	        UsertypeDto tdto = loginResult.getUsertype();

	        session.setAttribute("user_id", dto.getUser_id());
	        session.setAttribute("user_no", dto.getUser_no());
	        session.setAttribute("user_nick", dto.getUser_nick());
	        session.setAttribute("user_age", dto.getUser_age());
	        session.setAttribute("user_name", dto.getUser_name());
	        session.setAttribute("user_mail", dto.getUser_mail());
	        session.setAttribute("user_phone", dto.getUser_phone());
	        session.setAttribute("usertp_name", tdto.getUsertp_name());

	        if ("on".equals(remember)) {
	            Cookie cookie = new Cookie("rememberId", id);
	            cookie.setPath("/");
	            cookie.setMaxAge(60 * 60 * 24 * 30);
	            response.addCookie(cookie);
	        } else {
	            Cookie cookie = new Cookie("rememberId", null);
	            cookie.setPath("/");
	            cookie.setMaxAge(0);
	            response.addCookie(cookie);
	        }
	        return "redirect:/main.ks";
	    } else {
	        rttr.addFlashAttribute("loginError", "아이디와 비밀번호를 확인해주세요.");
	        return "redirect:/main.ks";
	    }
	}

	
	// 로그아웃
	@RequestMapping(value="/logout.ih" , method=RequestMethod.GET)
	public String logout(HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        session.invalidate();
	    }
	    
	    return "redirect:/main.ks";
	}

////////////////////////  마이페이지입장  /////////////////////////////////////
	//회원정보수정누르면 - 비번입력페이지로
	@RequestMapping(value="/preMyUpdatePage.ih", method=RequestMethod.GET)
	public String preMyUpdatePage(HttpServletRequest request, RedirectAttributes rttr) throws UnsupportedEncodingException {
	    HttpSession session = request.getSession(false);
	    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;

	    if (user_no == 0) { return "redirect:/loginPage.ih"; }
	    return "redirect:/preMyUpdatePageView.ih?user_no=" + user_no;
	}
	
	@RequestMapping(value="/preMyUpdatePageView.ih" , method=RequestMethod.GET)
	public String preMyUpdate() { return "ih_preMyUpdatePage"; }
////////////////////////마이페이지입장  /////////////////////////////////////	
	
////////////////////////마이페이지  /////////////////////////////////////
	
    // 로그인 시도 시 아이디와 비밀번호 검사
	@RequestMapping(value="/userCheckBeforeUpdate.ih", method=RequestMethod.POST)
	public void userCheckBeforeUpdate(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    String result = "pass";
	    
	    String user_id = request.getParameter("id");
	    String user_pass = request.getParameter("password");
	    dto.setUser_id(user_id);
	    
	    // 데이터베이스에서 사용자의 해싱된 비밀번호를 가져옵니다.
	    String hashedPassword = service.getHashedPassword(dto);
	    System.out.println(hashedPassword);
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    boolean isPasswordMatch = passwordEncoder.matches(user_pass, hashedPassword);
	    if(!isPasswordMatch) {
	        result = "<span style='color:red'>비밀번호를 확인해주세요.</span>";
	        out.print(result);
	    } else {
	        out.print(result);
	    }
	}
	//ih_preMyUpdatePage에서 서밋하면 비번검증처리컨트롤러로
	@RequestMapping(value="/checkpass.ih", method=RequestMethod.POST)
	public String checkpass(Model model,HttpServletResponse response, HttpServletRequest request, UserDto dto, RedirectAttributes rttr) throws IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");

	    String user_pass = request.getParameter("password");
	    String hashedPassword = service.getHashedPassword(dto);
	    
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    boolean isPasswordMatch = passwordEncoder.matches(user_pass, hashedPassword);
	    
		if (!isPasswordMatch) {// 비번 틀리면
			return "redirect:/preMyUpdatePageView.ih?user_id=" + dto.getUser_id();
		} else {// 비번맞으면
		    HttpSession session = request.getSession(false);
		    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;
			return "redirect:/MyUpdatePageView.ih?user_no=" + user_no;
		}
	}

	// 수정페이지view
	@RequestMapping(value="/MyUpdatePageView.ih", method=RequestMethod.GET)
	public String myUpdateId(HttpServletRequest request, Model model, UserDto dto) throws IOException {
	    model.addAttribute("dto", service.selectedUserPage(dto));
	    return "ih_myUpdatePage";
	}
	// 비번업데이트페이지 View
	@RequestMapping(value="/MyUpdatePassView.ih", method=RequestMethod.GET)
	public String myUpdatePassView(HttpServletRequest request, Model model, UserDto dto) throws IOException {
	    String user_id = request.getParameter("user_id");
	    dto.setUser_id(user_id);
	    dto = service.selectedUserPage(dto);
	    model.addAttribute("user", dto);

	    return "ih_myUpdatePass";
	}
	// 비번없데이트
	@RequestMapping(value="/myUpdatePass.ih", method=RequestMethod.POST)
	public String updatePassword(UserDto dto,HttpServletRequest request, RedirectAttributes rttr) {
	    String user_id = request.getParameter("id");
	    String user_pass = request.getParameter("updatePassword");
	    dto.setUser_id(user_id);

	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    String hashedPassword = passwordEncoder.encode(user_pass);
	    dto.setUser_pass(hashedPassword);
	    
	    HttpSession session = request.getSession(false);
	    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;
	    
	    // 데이터베이스에서 사용자의 해싱된 비밀번호를 가져옵니다.
	    System.out.println(hashedPassword);
	    int result = service.changePass(dto);
	    
	    rttr.addFlashAttribute("updatePassSuccess", "비밀번호가 변경되었습니다.");
	    
        return "redirect:/MyUpdatePageView.ih?user_no=" + user_no;

	}

	//수정버튼누르면
	@RequestMapping(value="/myUpdateGo.ih", method=RequestMethod.POST)
	public String myUpdateId(HttpServletRequest request, UserDto dto, RedirectAttributes rttr, Model model, HttpSession session) throws UnsupportedEncodingException {
	    String user_id = request.getParameter("id");
	    String nickname = request.getParameter("nickname");
	    String nickname2 = request.getParameter("nickname2");
	    String phone = request.getParameter("phonenumber");
	    String phone2 = request.getParameter("phonenumber2");
	    String email = request.getParameter("email");
	    String email2 = request.getParameter("email2");
	    
	    String finalNickname = (nickname2 == ""? nickname : nickname2);
	    String finalPhone = (phone2 == ""? phone : phone2);
	    String finalEmail = (email2 == ""? email : email2);
	    dto.setUser_id(user_id);
	    dto.setUser_mail(finalEmail);
	    dto.setUser_nick(finalNickname);
	    dto.setUser_phone(finalPhone);
	    
	    session = request.getSession(false);
	    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;
	    
	    int result = service.userUpdate(dto);
	    if(result == 1) {
	        rttr.addFlashAttribute("updateSuccess", "정보가 수정되었습니다.");
	        model.addAttribute("user_id", user_id);
	        return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
	    } else {
	        rttr.addFlashAttribute("updateFail", "정보수정이 실패했습니다.");
	        return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
	    }
	}
	
////////////////////////회원탈퇴  //////////////////////////////////////
	// 회원 탈퇴 요청 처리
	@RequestMapping(value="/myDelete.ih", method = RequestMethod.GET)
	public String preDeleteMember(HttpServletRequest request, RedirectAttributes rttr,HttpSession session, UserDto dto) {
		String user_id = request.getParameter("user_id");
		System.out.println("탈퇴신청한사람"+user_id);
		dto.setUser_id(user_id);
	    session = request.getSession(false);
	    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;
	int result = service.preDeleteUser(dto);
	if(result==1) {
        rttr.addFlashAttribute("myDeleteSuccess", "회원 탈퇴 요청이 접수되었습니다. 자정 후 탈퇴 처리됩니다.");
			return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
		}
		else {
			return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
		}
	}
////////////////////////회원탈퇴  ////////////////////////////////////////
	
////////////////////////회원탈퇴취소  //////////////////////////////////////
	@RequestMapping(value="/myDeleteCancle.ih", method = RequestMethod.GET)
	public String preDeleteMemberCancle(HttpServletRequest request, RedirectAttributes rttr,HttpSession session,UserDto dto) {
	String user_id = request.getParameter("user_id");
	System.out.println("탈퇴신청취소한사람"+user_id);
	dto.setUser_id(user_id);
    session = request.getSession(false);
    int user_no = (session != null) ? (int) session.getAttribute("user_no") : null;
	int result = service.myDeleteUserCancle(dto);
	if(result==1) {
        rttr.addFlashAttribute("myDeleteUserCancleSuccess", "회원 탈퇴 요청이 취소되었습니다.");
			return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
		}
		else {
			return "redirect:/MyUpdatePageView.ih?user_no="+user_no;
		}
	}
////////////////////////회원탈퇴취소  //////////////////////////////////////
	
////////////////////////  마이페이지끝  //////////////////////////////////////
	
////////////////////////  아이디찾기시작  /////////////////////////////////////
	//아이디찾기 view
	@RequestMapping(value="/findIdView.ih" , method=RequestMethod.GET)
	public String findIdView() { 
		return "ih_findId"; 
	}
	//뷰에서 처리하는 컨트롤러
	@RequestMapping(value="/findId.ih" , method=RequestMethod.POST)
	public String findId(Model model, UserDto dto,RedirectAttributes rttr, HttpServletRequest request) throws ParseException { 
	    String name = request.getParameter("name");
	    String getage = request.getParameter("age");
	    String email = request.getParameter("email");

        SimpleDateFormat inputType = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat tableType = new SimpleDateFormat("yyyy-MM-dd");

        Date date = inputType.parse(getage);
        String tableTypeAge = tableType.format(date);
        
	    dto.setUser_name(name);
	    dto.setUser_mail(email);
	    dto.setUser_age(tableTypeAge);

	    String result = service.findId(dto);
	    if (result != null) {
	        return "redirect:/findIdResultView.ih?id=" + result; 
	    } else {
	        rttr.addFlashAttribute("joinFail", "관리자에게 문의해주세요.");
	        return "redirect:/findIdView.ih";
	    }
	}
	//아이디찾기 결과창
	@RequestMapping(value="/findIdResultView.ih" , method=RequestMethod.GET)
	public String findIdResult(HttpServletRequest request , Model model) { 
	    String id = request.getParameter("id");
	    model.addAttribute("id", id);
	    return "ih_findId2"; 
	}
////////////////////////  아이디찾기끝  /////////////////////////////////////
	
////////////////////////  비번찾기시작  /////////////////////////////////////
	//비번찾기VIEW
	@RequestMapping(value="/findPassView.ih" , method=RequestMethod.GET)
	public String findPassView() { return "ih_findPassView"; }
////////////////////////  비번찾기끝  /////////////////////////////////////

	
////////////////////////  관리자 회원목록  //////////////////////////////////////
	@RequestMapping(value="/adminPage.admin" , method=RequestMethod.GET)
	public String list(@RequestParam(value="pstartno", defaultValue="0")int pstartno  
																		, Model model) {
	    Map<String, Integer>  para = new HashMap<>();
		para.put("pstartno", pstartno);
		para.put("onepagelimit", 10);  //5   10   20
		model.addAttribute("list"   , service.readTotalUser(para));
		model.addAttribute("paging" , service.paging(pstartno));
		return "ih_adminUser";
	}
////////////////////////  관리자 회원목록  //////////////////////////////////////
	
////////////////////////  관리자 회원삭제  //////////////////////////////////////
	@RequestMapping(value = "/adminDeleteUser.admin", method = RequestMethod.POST)
	@ResponseBody
	public void adminDeleteUser(@RequestBody Map<String, List<String>> payload, HttpServletResponse response) throws IOException {
	    List<String> userIds = payload.get("userIds");
	    PrintWriter out = response.getWriter();
	    if (userIds != null) {
	        for (String userId : userIds) {
	            UserDto dto = new UserDto();
	            dto.setUser_id(userId);
	            service.deleteUser(dto);
	        }
	        out.print("response");
	    } else {
	        out.print("error");
	    }
	}
////////////////////////  관리자 회원삭제  //////////////////////////////////////	

}
