package com.company.service;

import java.util.List;
import java.util.Map;

import com.company.dto.IhResultDto;
import com.company.util.PagingDto;
import com.company.dto.UserDto;

public interface IhService {
	//①로그인
	public IhResultDto login(UserDto dto);

	//③회원가입할때씀
	public int join(UserDto dto);

	//④아이디 찾기 
	public String findId(UserDto dto);
	
	//⑤비번찾기
	//비번찾기안에 아이디와 일치하는 이메일찾기
	public UserDto findPassFindMail (UserDto dto);
	
	//이메일찾았으면 업데이트된 임시비밀번호 보내기
	public int findPassSendMail (UserDto dto);

	//⑥회원정보수정안에서 비밀번호변경
	public int changePass (UserDto dto);

	//⑦마이페이지의 회원정보수정 입장
	public UserDto goToUpdateTab (UserDto dto);
	
	//⑧회원정보수정
	public int userUpdate (UserDto dto);	

	//⑩탈퇴시도 이메일로 코드발송
	public UserDto SendMailForDeleteUser (UserDto dto);

	//⑪관리자의 회원관리페이지테이블
	public List<UserDto>  readTotalUser(Map<String,Integer> para);
	// paging
	public PagingDto  paging(int pstartno);
	
	//⑫관리자가 들어가는 [ 회원의 마이페이지 ]
	public UserDto selectedUserPage (UserDto dto);

	//⑬관리자가 탈퇴시키는 회원
	public int deleteUser (UserDto dto);

	//② 사용자가 탈퇴시도하면 4등급 24시간유지
	public int preDeleteUser (UserDto dto);
	//  24시간후 탈퇴처리
		public int myDeleteUser();
		//  탈퇴취소
		public int myDeleteUserCancle(UserDto dto);
	//⑭아이디 중복체크
	public int idCheck (UserDto dto);
	
	//⑮닉네임 중복체크
	public int nicknameCheck (UserDto dto);
	
	//⑨이메일 중복체크
	public int emailCheck (UserDto dto);
	
	//비밀번호변경 페이지의 현재비밀번호 검증 ajax
	public int originalPasswordCheck (UserDto dto);
	
	//네이버 계정과 연동된 무빙계정이 있는지
	public UserDto naverJoin(UserDto dto);
	
	//네이버회원가입직후 user_no 세션에저장하기위해 가져오기
	public UserDto selectUserNoNaverAfterJoin(UserDto dto);
	
	//카카오 계정과 연동된 무빙계정이 있는지
	public UserDto kakaoJoin(UserDto dto);
	
	//카카오 로그인
	public IhResultDto kakaoLogin(UserDto dto);
	
	//카카오 코드가있는 계정은 카카오 코드를 삭제 = 연동끊기
	public int deleteKakaoCode(UserDto dto);
	
	//카카오 코드가 없는 계정은 카카오 코드를 삽입 = 연동하기
	public int updateKakaoCode(UserDto dto);
	
	//22. 마이페이지 입장시 카카오 게정이 null인지 확인
	public UserDto confirmKakaoIntegration(UserDto dto);
	
	//23.네이버 코드가있는 계정은 카카오 코드를 삭제 = 연동끊기
	public int deleteNaverCode(UserDto dto);
	
	//24. 네이버 코드가 없는 계정은 카카오 코드를 삽입 = 연동하기
	public int updateNaverCode(UserDto dto);
	
	//25. 사용자 해싱된 비밀번호 조회
	public String getHashedPassword(UserDto dto);
}
