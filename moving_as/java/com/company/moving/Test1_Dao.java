package com.company.moving;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.company.dao.IhDao;
import com.company.dao.TestDao;
import com.company.dto.IhResultDto;
import com.company.dto.UserDto;

import lombok.extern.java.Log;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/spring/**/root-context.xml")
@Log
public class Test1_Dao {
	@Autowired ApplicationContext context;
	@Autowired TestDao dao;
	@Autowired IhDao ihdao;
	@Test @Ignore public void test0() { log.info("컨텍스트는 "+context); }
	@Test @Ignore public void test1() { System.out.println(dao.readTime()); }	//완료
	@Test  public void test2() { 
		UserDto dto = new UserDto();
		
		
		dto.setUser_id("123"); dto.setUser_kakao("333");
		System.out.println(ihdao.updateKakaoCode(dto));
		
//		dto.setUser_kakao("3327423296");
//		System.out.println(ihdao.deleteKakaoCode(dto));
		//네이버회원가입직후 user_no 세션에저장하기위해 가져오기
//		dto.setUser_naver("GFa0qCCTxipnEjiq0YdJIwltC6s_Jh6oVstPV1gq8XY");
//		System.out.println(ihdao.selectUserNoNaverAfterJoin(dto)); 
		//11 관리자페이지 모든회원 불러오기
//		log.info("모든회원 불러오기"+ihdao.readTotalUser());
		//12 관리자가 들어가는 회원의 마이페이지
//		dto.setUser_id("user15"); dto.setUser_pass("123");
//		log.info("회원의 마이페이지"+ihdao.selectedUserPage(dto));
		//13 탈퇴=5등급
//		log.info(""+ihdao.deleteUser (dto));
		//10 탈퇴 이메일 코드발송
//		dto.setUser_mail("admin@gmail.com");
//		log.info("탈퇴 이메일 코드발송 "+ihdao.SendMailForDeleteUser(dto));
		//7. 회원정보수정 탭 입장
//		log.info("회원정보수정 탭 입장 "+ihdao.goToUpdateTab(dto));
		//5. 비번찾기 메일찾기 & 메일보내기(비번변경)
//		dto.setUser_id("admin");
//		dto.setUser_mail("admin@gmail.com"); dto.setUser_pass("1111");
//		log.info("아이디와일치하는 메일찾기"+ihdao.findPassFindMail(dto));
//		log.info("메일과일치하는 비번 업데이트하기"+ihdao.findPassSendMail(dto));	완료
		
		//4. 아이디 찾기 
//		dto.setUser_age("1995-11-01"); dto.setUser_name("관리자"); dto.setUser_pass("1234");
//		log.info("나이와 메일과 일치하는 아디찾기"+ihdao.findId(dto));
				
		//6. 비밀번호변경
//		log.info("비밀번호변경"+ihdao.changePass(dto));						
		
		
//		dto.setUser_phone("010-1234-1234");
		//8 회원정보수정
//		log.info("아이디받고 메일과 전번바꾸기"+ihdao.userUpdate(dto));			완료	
		
		//1. 로그인
//		dto.setUser_id("123"); dto.setUser_pass("123");				
//		log.info("로그인아디 비번입력"+ihdao.login(dto));
		
		// 탈퇴취소
//		log.info("아디입력"+ihdao.myDeleteUserCancle(dto));
		
		//14. 아이디체크
//		dto.setUser_id("asdf"); 
//		log.info("중복아이디 갯수 "+ihdao.idCheck(dto));		완료
		
		//15. 닉네임체크
//		dto.setUser_nick("이한");
//		log.info("중복닉네임갯수 "+ihdao.nicknameCheck(dto));	완료
		
		//9. 이메일체크
//		dto.setUser_mail("u1h@naver.com");
//		log.info("중복이메일갯수 "+ihdao.emailCheck(dto));		완료
		
	}
	
	
}



