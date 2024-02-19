package com.company.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.dao.IhDao;
import com.company.dto.IhResultDto;
import com.company.dto.UserDto;
import com.company.util.PagingDto;

@Service
public class IhServiceImple implements IhService{
	@Autowired IhDao dao;
	//①로그인
	@Override
	public IhResultDto login(UserDto dto) {
		return dao.login(dto);
	}

	//③회원가입할때씀
	@Override
	public int join(UserDto dto) {
		return dao.join(dto);
	}

	//④아이디 찾기
	@Override
	public String findId(UserDto dto) {
		return dao.findId(dto);
	}
	
	//⑤비번찾기
	//비번찾기안에 아이디와 일치하는 이메일찾기
	@Override
	public UserDto findPassFindMail (UserDto dto) {
		return dao.findPassFindMail(dto);
	}
	//이메일찾았으면 업데이트된 임시비밀번호 보내기
	@Override
	public int findPassSendMail (UserDto dto) {
		return dao.findPassSendMail(dto);
	}

	//⑥회원정보수정안에서 비밀번호변경
	@Override
	public int changePass (UserDto dto) {
		return dao.changePass(dto);
	}

	//⑦마이페이지의 회원정보수정 입장
	@Override
	public UserDto goToUpdateTab (UserDto dto) {
		return dao.goToUpdateTab(dto);
	}
	
	//⑧회원정보수정
	@Override
	public int userUpdate (UserDto dto) {
		return dao.userUpdate(dto);
	}

	//⑩탈퇴시도 이메일로 코드발송
	@Override
	public UserDto SendMailForDeleteUser (UserDto dto) {
		return dao.SendMailForDeleteUser(dto);
	}

	//⑪관리자의 회원관리페이지테이블
	@Override public List<UserDto> readTotalUser(Map<String, Integer> para) { 
		return dao.readTotalUser(para); 
	} 
	// 페이징
	@Override public PagingDto paging(int pstartno) {
		return new PagingDto(dao.listtotal() ,pstartno );
	}
	
	//⑫관리자가 들어가는 [ 회원의 마이페이지 ]
	@Override
	public UserDto selectedUserPage (UserDto dto) {
		return dao.selectedUserPage(dto);
	}

    //⑬ 관리자가 탈퇴시키는 회원은 5등급으로
	@Override
	public int deleteUser (UserDto dto) {
		return dao.deleteUser (dto);
	}
	
	//② 사용자가 탈퇴시도하면 4등급 24시간유지
	public int preDeleteUser (UserDto dto) {
		return dao.preDeleteUser (dto);
	}
	//  24시간후 탈퇴처리
		public int myDeleteUser() {
			return dao.myDeleteUser();
		}
		//  탈퇴취소
		public int myDeleteUserCancle(UserDto dto) {
			return dao.myDeleteUserCancle(dto);
		}
	//⑭아이디 중복체크
	@Override
	public int idCheck (UserDto dto) {
		return dao.idCheck (dto);
	}
	
	//⑮닉네임 중복체크
	@Override
	public int nicknameCheck (UserDto dto) {
		return dao.nicknameCheck (dto);
	}
	//⑨이메일 중복체크
	@Override
	public int emailCheck (UserDto dto) {
		return dao.emailCheck (dto);
	}
	
	//16. 비밀번호변경 페이지의 현재비밀번호 검증 ajax
	public int originalPasswordCheck (UserDto dto) {
		return dao.originalPasswordCheck (dto);
	}
	
	//네이버 계정과 연동된 무빙계정이 있는지
	public UserDto naverJoin(UserDto dto) {
		return dao.naverJoin(dto);
	}
	
	//18. 네이버회원가입직후 user_no 세션에저장하기위해 가져오기
	public UserDto selectUserNoNaverAfterJoin(UserDto dto) {
		return dao.selectUserNoNaverAfterJoin(dto);
	}
	
	//카카오 계정과 연동된 무빙계정이 있는지
	public UserDto kakaoJoin(UserDto dto) {
		return dao.kakaoJoin(dto);
	}
	
	//카카오 로그인
	public IhResultDto kakaoLogin(UserDto dto) {
		return dao.kakaoLogin(dto);
	}
	
	//카카오 코드가있는 계정은 카카오 코드를 삭제 = 연동끊기
	public int deleteKakaoCode(UserDto dto) {
		return dao.deleteKakaoCode(dto);
	}
	
	//카카오 코드가 없는 계정은 카카오 코드를 삽입 = 연동하기
	public int updateKakaoCode(UserDto dto) {
		return dao.updateKakaoCode(dto);
	}
	//22. 마이페이지 입장시 카카오 게정이 null인지 확인
	public UserDto confirmKakaoIntegration(UserDto dto) {
		return dao.confirmKakaoIntegration(dto);
	}
	
	//23.네이버 코드가있는 계정은 카카오 코드를 삭제 = 연동끊기
	public int deleteNaverCode(UserDto dto) {
		return dao.deleteNaverCode(dto);
	}
	//24. 네이버 코드가 없는 계정은 카카오 코드를 삽입 = 연동하기
	public int updateNaverCode(UserDto dto) {
		return dao.updateNaverCode(dto);
	}
	//25. 사용자 해싱된 비밀번호 조회
	public String getHashedPassword(UserDto dto) {
		return dao.getHashedPassword(dto);
	}
}
