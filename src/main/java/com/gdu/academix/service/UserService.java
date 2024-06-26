package com.gdu.academix.service;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;

import com.gdu.academix.dto.EmployeesDto;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public interface UserService {

  // 가입 및 탈퇴
  ResponseEntity<Map<String, Object>> checkEmail(Map<String, Object> params);
  ResponseEntity<Map<String, Object>> sendCode(Map<String, Object> params);
  void signup(HttpServletRequest request, HttpServletResponse response);  
  void leave(HttpServletRequest request, HttpServletResponse response);

  // 로그인 및 로그아웃
  String getRedirectURLAfterSignin(HttpServletRequest request);  
  void signin(HttpServletRequest request, HttpServletResponse response);
  void signout(HttpServletRequest request, HttpServletResponse response);
  
  // 오채원 - 추가(24/05/28)
  ResponseEntity<Map<String, Object>> getUserList();
  EmployeesDto getUserProfileByNo(int employeeNo);
  ResponseEntity<Map<String, Object>> getUserProfileListByNo(List<Integer> employeeNoList);
  
  // 네이버 로그인
  //String getNaverLoginURL(HttpServletRequest request);
  //String getNaverLoginAccessToken(HttpServletRequest request);
 // UserDto getNaverLoginProfile(String accessToken);
  //boolean hasUser(UserDto user);
  //void naverSignin(HttpServletRequest request, UserDto naverUser);
  
  
  
}