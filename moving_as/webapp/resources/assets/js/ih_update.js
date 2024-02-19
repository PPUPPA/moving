$(function() {
$("#nickname2").on("blur", function() {
    $.ajax({
        url: "nicknameCheck.ih",
        type: "get",
        dataType: "text",
        data: { "nickname": $("#nickname2").val() },
        success: function(data) {
            $("#nicknameResult").html(data);
        },
        error: function(xhr, textStatus, errorThrown) {
            $("#nicknameResult").html(textStatus + "(HTTP-" + xhr.status + ")");
        }
    });
});
}); // end $

window.addEventListener('load', function() {
    // 이메일 코드 보내기 클릭 이벤트 리스너
    let sendCode = document.getElementById('sendCode');
    sendCode.addEventListener('click', function() {
        let email = document.getElementById('email2').value;
        if (!email) {
            email = document.getElementById('email').value;
        }
        let emailcriteria = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        // 이메일 공백검사
        if (email == "") {
            alert("이메일을 입력하세요");
            document.getElementById('email2').focus();
            return false;
        }

        // 이메일 유효성 검사
        if (!emailcriteria.test(email)) {
            alert("이메일형식이 올바르지 않습니다.");
            document.getElementById('email2').focus();
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
                    	let checkCodeButton = document.getElementById('btnCheckCode');
						checkCodeButton.addEventListener('click', function() {
						    let enteredCode = document.getElementById('inputEmail').value;
						    let sentCode = document.getElementById('emailCode').value;
						    let timeLimitDisplay = document.getElementById('timeLimit');
						
						    if (enteredCode === sentCode) {
						        clearInterval(countdownTimer); // 타이머 멈추기
						        timeLimitDisplay.style.color = 'blue';
						        timeLimitDisplay.value = "인증완료"; // "인증완료" 메시지 표시
						    } else {
						        alert('입력하신 코드가 올바르지 않습니다.');
						    }
						});
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
var countdownTimer;

function startCountdown(duration, display) {
    var timer = duration, minutes, seconds;
    countdownTimer = setInterval(function() {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.val(minutes + ":" + seconds);

        if (--timer < 0) {
            clearInterval(countdownTimer);
            display.val("00:00");
        }
    }, 1000);
}

document.getElementById('update').addEventListener('submit', function(event) {
    // 기존 값 또는 새로 입력된 값 사용
    let nickname = document.getElementById("nickname2").value || document.getElementById("nickname").value;
    let email = document.getElementById("email2").value || document.getElementById("email").value;
    let phonenumber = document.getElementById("phonenumber2").value || document.getElementById("phonenumber").value;
    let inputEmail = document.getElementById("inputEmail").value;
    let emailCode = document.getElementById("emailCode").value;
    // 유효성 검사를 위한 정규 표현식
    let nickcriteria = /^[가-힣a-zA-Z0-9]{2,8}$/;
    let phonenumbercriteria = /^010\d{8}$/;

    // 닉네임 유효성 검사 (닉네임 변경 시에만)
    if (document.getElementById("nickname2").value && !nickcriteria.test(nickname)) {
        alert("닉네임이 요구 사항을 충족하지 않습니다.");
        document.getElementById("nickname2").focus();
        event.preventDefault();
        return false;
    }

    // 이메일 인증코드 일치 검사 (이메일 변경 시에만)
    if (document.getElementById("email2").value && inputEmail !== emailCode) {
        alert("이메일인증코드를 정확하게 입력하세요");
        document.getElementById("inputEmail").focus();
        event.preventDefault();
        return false;
    }

    // 휴대폰번호 유효성 검사 (휴대폰 번호 변경 시에만)
    if (document.getElementById("phonenumber2").value && !phonenumbercriteria.test(phonenumber)) {
        alert("휴대폰번호 형식이 올바르지 않습니다.");
        document.getElementById("phonenumber2").focus();
        event.preventDefault();
        return false;
    }

    // 중복 검사 결과 확인
    let checknickname = $('#nicknameResult span').css('color');
    let checkemail = $('#emailResult span').css('color');
    if ((checknickname == "rgb(255, 0, 0)" || checkemail == "rgb(255, 0, 0)") && document.getElementById("nickname2").value) {
        alert('중복된 부분을 변경해주세요');
        event.preventDefault();
        return false;
    }
    
});
document.addEventListener('DOMContentLoaded', function() {
	    let deleteButton = document.getElementById('MyDeleteView');
	    if (deleteButton) {
	        deleteButton.addEventListener('click', function(event) {
	            if (confirm('회원탈퇴하시겠습니까?')) {
	                window.location.href = 'delete.ih'; // 회원탈퇴 처리 페이지로 이동
	            }
	        });
	    }
	});
});