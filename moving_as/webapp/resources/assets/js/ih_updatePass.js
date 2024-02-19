 window.addEventListener('load', function(){   
    document.getElementById('myUpdatePass').addEventListener('submit', function(event) {
		///////////////////공백검사 유효성검사/////////////////////////
        let updatePassword = document.getElementById("updatePassword");
        let updatePasswordConfirm = document.getElementById('updatePasswordConfirm');
        let pwcriteria = /^(?:(?=.*[A-Za-z])(?=.*\d)|(?=.*[A-Za-z])(?=.*[^A-Za-z0-9])|(?=.*\d)(?=.*[^A-Za-z0-9]))[A-Za-z\d\W_]{8,16}$/;
	///////////////////공백검사 유효성검사/////////////////////////
        // 비밀번호 유효성 검사
        if (!pwcriteria.test(updatePassword.value)) {
            alert("비밀번호가 요구 사항을 충족하지 않습니다.");
            updatePassword.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 공백검사
        if(updatePassword.value == ""){
            alert("비밀번호를 입력하세요");
            updatePassword.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 확인 공백검사
        if(updatePasswordConfirm.value == ""){
            alert("비밀번호확인을 입력하세요");
            updatePasswordConfirm.focus();
            event.preventDefault();
            return false;
        }
        // 비밀번호 일치 검사
        if (updatePassword.value !== updatePasswordConfirm.value) {
            alert("비밀번호가 일치하지 않습니다.");
            updatePasswordConfirm.focus();
            event.preventDefault();
            return false;
        }
	///////////////////공백검사 유효성검사/////////////////////////
	});
});
$(document).ready(function() {

    // 비밀번호 유효성 검사
    $("#updatePassword").on("keyup", function() {
        var password = $(this).val();
        var regex = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-]|.*[0-9]).{8,16}$/;
        validateField(password, regex, $("#passwordCriteria"));
    });

    // 필드 유효성 검사 함수
    function validateField(value, regex, criteriaElement) {
        if (regex.test(value)) {
            criteriaElement.css("color", "blue").text("위 조건을 만족합니다.");
        } else {
            criteriaElement.css("color", "red").text("위 조건을 만족하지않습니다.");
        }
    }
    
    // 비밀번호 일치 검사
    $("#updatePasswordConfirm").on("keyup", function() {
        let password = $("#updatePassword").val();
        let confirmPassword = $(this).val();
        let passduplication = $("#passduplication");
        
        if (password === confirmPassword) {
            passduplication.css("color", "blue").text("비밀번호가 일치합니다.");
        } else {
            passduplication.css("color", "red").text("비밀번호가 일치하지 않습니다.");
        }
    });
    
});