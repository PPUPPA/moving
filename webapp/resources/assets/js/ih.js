window.addEventListener('load', function() {
//////////////////////// 돌아가기버튼 ////////////////////////
document.getElementById('backButton').addEventListener('click', function() {
	history.back();
});
//////////////////////// 돌아가기버튼 ////////////////////////

	////////////////// 회원가입 동의 부분 펼치기////////////////////
		var btnFlips = document.querySelectorAll('.btn-flip');
		var btnFlip1 = btnFlips[0];
		var btnFlip2 = btnFlips[1];
		btnFlip1.addEventListener('click', function() {
		    var serviceDiv = document.querySelector('.service');
		    serviceDiv.classList.toggle('active');
		    btnFlip1.classList.toggle('btn-flip__rotate');
		});
		btnFlip2.addEventListener('click', function() {
		    var privacyDiv = document.querySelector('.privacy');
		    privacyDiv.classList.toggle('active');
		    btnFlip2.classList.toggle('btn-flip__rotate');
		});
	///////////////// 회원가입 동의 부분 펼치기 //////////////////////
	//////////////// 모든 약관에동의하기 누르면 두체크박스 선택 //////////
	document.getElementById('chk3').addEventListener('change', function() {
	    var chk1 = document.getElementById('chk1');
	    var chk2 = document.getElementById('chk2');
	    var chk3 = document.getElementById('chk3');
	
	    chk1.checked = chk3.checked;
	    chk2.checked = chk3.checked;
	});
	//////////////// 모든 약관에동의하기 누르면 두체크박스 선택 //////////
	
	
	
////// 이메일 코드 보내기 클릭 이벤트 리스너/////////////////////////////
	let sendCode = document.getElementById('sendCode');
	sendCode.addEventListener('click', function() {
	    let email = document.getElementById('email').value;
	    let emailcriteria = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
	
	    // 이메일 공백검사
	    if (email == "") {
	        alert("이메일을 입력하세요");
	        email.focus();
	        return false;
	    }
	
	    // 이메일 유효성 검사
	    if (!emailcriteria.test(email)) {
	        alert("이메일형식이 올바르지 않습니다.");
	        email.focus();
	        return false;
	    }
	
	    // 이메일 중복검사
	    $.ajax({
	        url: "emailCheck.ih",
	        type: "get",
	        dataType: "text",
	        data: { "email": email },
	        success: function(checkResult) {
	            $("#emailResult").html(checkResult);
	
	            // 중복되지 않는 이메일인 경우에만 인증 코드 보내기
	            if (checkResult.includes("중복되지않는 이메일입니다.")) {
	                // 3분 카운트다운 시작
	                var threeMinutes = 60 * 3,
	                    display = $('#timeLimit');
	                startCountdown(threeMinutes, display);
	
	                // 인증코드 보내기 AJAX 요청
	                $.ajax({
	                    url: 'sendCode.ih',
	                    type: 'POST',
	                    dataType: "text",
	                    data: { email: email },
	                    success: function(codeData) {
	                        alert('인증코드를 전송했습니다.\n이메일을 확인해주세요.');
	                        $("#emailCode").val(codeData);
	                        setTimeout(function() {
	                            $("#emailCode").val("");
	                        }, 180000); // 3분 후 코드 값 비우기
	                    },
	                    error: function(xhr, status, error) {
	                        alert('오류가 발생했습니다');
	                    }
	                });
	            } else {
	                alert("중복된 이메일입니다.");
	                email.focus();
	            }
	        },
	        error: function(xhr, textStatus, errorThrown) {
	            $("#emailResult").html(textStatus + "(HTTP-" + xhr.status + ")");
	        }
	    });
	});
	
	// 카운트다운 함수
	function startCountdown(duration, display) {
	    var timer = duration, minutes, seconds;
	    var countdown = setInterval(function() {
	        minutes = parseInt(timer / 60, 10);
	        seconds = parseInt(timer % 60, 10);
	
	        minutes = minutes < 10 ? "0" + minutes : minutes;
	        seconds = seconds < 10 ? "0" + seconds : seconds;
	
	        display.val(minutes + ":" + seconds);
	
	        if (--timer < 0) {
	            clearInterval(countdown);
	            display.val("00:00");
	        }
	    }, 1000);
	}

    document.getElementById('join').addEventListener('submit', function(event) {
		///////////////////공백검사 유효성검사/////////////////////////
        let name = document.getElementById("name");
        let id = document.getElementById("id");
        let password = document.getElementById("password");
        let password2 = document.getElementById('password2');
        let nickname = document.getElementById("nickname");
        let inputEmail = document.getElementById("inputEmail");
        let emailCode = document.getElementById("emailCode");
        let age = document.getElementById("age");
        let phonenumber = document.getElementById("phonenumber");
        let idcriteria = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,12}$/;
        let pwcriteria = /^(?:(?=.*[A-Za-z])(?=.*\d)|(?=.*[A-Za-z])(?=.*[^A-Za-z0-9])|(?=.*\d)(?=.*[^A-Za-z0-9]))[A-Za-z\d\W_]{8,16}$/;
        let nickcriteria = /^[가-힣a-zA-Z0-9]{2,8}$/;
        let agecriteria = /^(19|20)\d\d([0-1][0-9])([0-3][0-9])$/;
        let phonenumbercriteria = /^010\d{8}$/;
	    // 아이디 공백검사
        if(name.value == ""){
            alert("이름을 입력하세요");
            name.focus();
            event.preventDefault();
            return false;
        }
	    // 아이디 공백검사
        if(id.value == ""){
            alert("아이디를 입력하세요");
            id.focus();
            event.preventDefault();
            return false;
        }
        // 아이디 유효성 검사
        if (!idcriteria.test(id.value)) {
            alert("아이디가 요구 사항을 충족하지 않습니다.");
            id.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 공백검사
        if(password.value == ""){
            alert("비밀번호를 입력하세요");
            password.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 유효성 검사
        if (!pwcriteria.test(password.value)) {
            alert("비밀번호가 요구 사항을 충족하지 않습니다.");
            password.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 확인 공백검사
        if(password2.value == ""){
            alert("비밀번호확인을 입력하세요");
            password2.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 일치 검사
        if (password.value !== password2.value) {
            alert("비밀번호가 일치하지 않습니다.");
            password2.focus();
            event.preventDefault();
            return false;
        }
        // 닉네임공백검사
        if(nickname.value == ""){
            alert("닉네임을 입력하세요");
            nickname.focus();
            event.preventDefault();
            return false;
        }
        // 닉네임 유효성 검사
        if (!nickcriteria.test(nickname.value)) {
            alert("닉네임이 요구 사항을 충족하지 않습니다.");
            nickname.focus();
            event.preventDefault();
            return false;
        }
        // 이메일 인증코드 공백검사
        if(inputEmail.value == ""){
            alert("이메일인증코드를 입력하세요");
            inputEmail.focus();
            event.preventDefault();
            return false;
        }
		// 이메일 인증코드 일치검사
        if(inputEmail.value != emailCode.value){
            alert("이메일인증코드를 정확하게 입력하세요");
            inputEmail.focus();
            event.preventDefault();
            return false;
        }
        // 휴대폰번호 공백검사
        if(phonenumber.value == ""){
            alert("휴대폰번호를 입력하세요");
            phonenumber.focus();
            event.preventDefault();
            return false;
        }
        // 휴대폰번호 유효성 검사
        if (!phonenumbercriteria.test(phonenumber.value)) {
            alert("휴대폰번호 형식이 올바르지 않습니다.");
            phonenumber.focus();
			event.preventDefault();
            return false;
        }
        // 나이 공백검사
        if(age.value == ""){
            alert("생년월일을 입력하세요");
            age.focus();
            event.preventDefault();
            return false;
        }        
        // 나이 유효성 검사
        if (!agecriteria.test(age.value)) {
            alert("생년월일 형식이 올바르지 않습니다.");
            age.focus();
            event.preventDefault();
            return false;
        }
		///////////////////공백검사 유효성검사/////////////////////////

		/////////////// 모든 약관에 동의했는지 확인 ////////////
	    var chk1 = document.getElementById('chk1').checked;
	    var chk2 = document.getElementById('chk2').checked;
	    if (!chk1 || !chk2) {
	        alert('모든 약관에 동의해야 합니다.');
	        event.preventDefault();
	        return false;
	    }
		/////////////// 모든 약관에 동의했는지 확인 ////////////
		
		////////////// 모든 중복검사를 통과했는지 //////////////
		let checkid = $('#idResult span').css('color');
		let checknickname = $('#nicknameResult span').css('color');
		let checkemail = $('#emailResult span').css('color');
		
		if(checkid!="rgb(0, 0, 255)"||checknickname!="rgb(0, 0, 255)"||checkemail!="rgb(0, 0, 255)"){
			alert('중복된 부분을 변경해주세요');
			event.preventDefault();
			return false;
		}
	    ////////////// 모든 중복검사를 통과했는지 //////////////

	});
});

//////////////////// 중복검사 ajax /////////////////////
$(function() {
	// 회원가입중 아이디 중복검사
	$("#id").on( "blur", function() {
			$.ajax({
			url : "idCheck.ih",
			type : "GET",
			dataType : "text",
			data : { "id" : $("#id").val() },
			success : function(data) { $("#idResult").html(data) },
			error : function(xhr, textStatus, errorThrown) {
				$("#idResult").html( textStatus + "(HTTP-" + xhr.status + ")")
			}
		}); // end ajax
	}); // end blur

	// 회원가입중 닉네임 중복검사
	$("#nickname").on( "blur", function() {
			$.ajax({
			url : "nicknameCheck.ih",
			type : "get",
			dataType : "text",
			data : { "nickname" : $("#nickname").val() },
			success : function(data) { $("#nicknameResult").html(data) },
			error : function(xhr, textStatus, errorThrown) {
				$("#nicknameResult").html( textStatus + "(HTTP-" + xhr.status + ")")
			}
		}); // end ajax
	}); // end blur
}); // end $

