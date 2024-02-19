package com.company.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;

import com.company.dto.UserDto;
import com.company.service.IhService;

public class IhScheduler {
    @Autowired
    private IhService service;

    @Scheduled(cron = "0 0 0 * * *")
    public void processPendingDeletes() {
        // 24시간이 지난 탈퇴 대기 사용자를 실제 탈퇴 처리
        service.myDeleteUser();
    }
}
