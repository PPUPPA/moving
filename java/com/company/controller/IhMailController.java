package com.company.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.company.dto.UserDto;
import com.company.service.IhService;
import com.company.service.RandomCode;

@Controller
public class IhMailController {
    @Autowired
    IhService service;

    // 공통 메일 전송 로직
    private void sendMail(String to, String subject, String content) throws MessagingException {
        // 네이버 SMTP 서버 정보 설정
        String host = "smtp.naver.com";
        String user = "u1h@naver.com";
        String password = "qpwoei12!";

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", host);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getDefaultInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(user));
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject(subject);
        message.setContent(content, "text/html; charset=euc-kr");

        Transport.send(message);
    }

    // 회원가입 시 인증 코드 전송
    @RequestMapping(value="/sendCode.ih", method=RequestMethod.POST)
    public void sendCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String randomCode = RandomCode.generateRandomCode();
        String subject = "안녕하세요. 무빙입니다.";
        String content = buildContentForCode(randomCode);

        try {
            sendMail(email, subject, content);
            writeResponse(response, randomCode);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // 비밀번호 찾기 시 임시 비밀번호 전송
    @RequestMapping(value="/sendPass.ih", method=RequestMethod.POST)
    public void sendPass(HttpServletRequest request, HttpServletResponse response, UserDto dto) throws ServletException, IOException {
        String email = request.getParameter("email");
        String randomPass = RandomCode.generateRandomCode();
        String subject = "안녕하세요. 무빙입니다.";
        String content = buildContentForPassword(request, randomPass);

	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    String hashedPassword = passwordEncoder.encode(randomPass);
	    
        // 임시 비밀번호를 사용자 정보에 업데이트
        dto.setUser_mail(email);
        dto.setUser_pass(hashedPassword);
        service.findPassSendMail(dto);

        try {
            sendMail(email, subject, content);
            writeResponse(response, randomPass);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // 메일 본문 생성 메서드 (인증 코드 용)
    private String buildContentForCode(String code) {
        return "<html><body><div>" +
               "<h1>안녕하세요 moving입니다.</h1><p>인증코드는 " + code + "입니다.</p>" +
        	   "<img src='' alt=''> " +
               "</div></body></html>";
    }

    // 메일 본문 생성 메서드 (임시 비밀번호 용)
    private String buildContentForPassword(HttpServletRequest request, String password) {
        String contextPath = request.getContextPath();
        return "<html><body><div>" +
               "<h1>안녕하세요 moving입니다.</h1><p>임시비밀번호는 " + password + "입니다.</p>" +
               "<img src='" + contextPath + "/resources/assets/images/common/logo.svg' alt='' /> " +
               "</div></body></html>";
    }

    // HTTP 응답 작성 메서드
    private void writeResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(message);
        out.flush();
        out.close();
    }
}
