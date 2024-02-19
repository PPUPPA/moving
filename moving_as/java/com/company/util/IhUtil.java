package com.company.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.function.Function;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import com.company.dto.UserDto;

@Component
public class IhUtil {
	// 공통 로직을 처리하는 메서드
	public void checkDuplicate(HttpServletRequest request, HttpServletResponse response, String input, Function<UserDto, Integer> checkFunction, String inputType) throws ServletException, IOException {
	    request.setCharacterEncoding("UTF-8");
	    response.setContentType("text/html; charset=UTF-8");
	    PrintWriter out = response.getWriter();
	    String result = "<span style='color:blue'></span>";
	    int cnt = -1;

	    if (input.equals("")) {
	        result = "<span style='color:red'>" + inputType + "를 입력해주세요.</span>";
	        out.print(result);
	    } else {
	        UserDto dto = new UserDto();
	        cnt = checkFunction.apply(dto);
	        if (cnt == 0) {
	            result = "<span style='color:blue'>중복되지 않는 " + inputType + "입니다.</span>";
	        } else if (cnt >= 1) {
	            result = "<span style='color:red'>중복된 " + inputType + "입니다.</span>";
	        }
	        out.print(result);
	    }
	}
}
