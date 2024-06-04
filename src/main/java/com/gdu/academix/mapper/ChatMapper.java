package com.gdu.academix.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.gdu.academix.dto.ChatroomDto;
import com.gdu.academix.dto.ChatroomParticipateDto;
import com.gdu.academix.dto.MessageDto;

@Mapper
public interface ChatMapper {
  
  // 1:1 채팅방 조회
  ChatroomDto isOneToOneChatroomExits(Map<String, Object> map);
  
  // 1:1 채팅방 생성
  int insertNewOneToOneChatroom(ChatroomDto chatroom);
  int insertNewOneToOneParticipate(ChatroomParticipateDto participate);
  
  // 메시지 데이터 넣기
  int insertChatMessage(MessageDto message);
  
  // 채팅 내역 가져오기
  List<MessageDto> getChatMessageList(Map<String, Object> map);
  // 채팅 메시지 개수 가져오기
  int getChatMessageCount(int chatroomNo);
  // 채팅방 목록 가져오기
  List<ChatroomDto> getChatList(int employeeNo);
  // 채팅방 참여자 수 가져오기
  int getChatroomParticipantCount(int chatroomNo);
  // 채팅방 참여자 번호 리스트
  List<ChatroomParticipateDto> getChatroomParticipantList(int chatroomNo);
  
  // 채팅방 번호 - 채팅방 데이터 가져오기
  ChatroomDto getChatroomByChatroomNo(int chatroomNo);
  
  
}