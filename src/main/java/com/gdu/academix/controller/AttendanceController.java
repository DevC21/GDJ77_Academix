package com.gdu.academix.controller;

import java.text.ParseException;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gdu.academix.service.AttendanceService;

@RequestMapping("/attendance")
@Controller
public class AttendanceController {

		
  private final AttendanceService attendanceService;
	
  public AttendanceController(AttendanceService attendanceService) { 
  	super();
  	this.attendanceService = attendanceService; 
  }
		
  @GetMapping("/commute.page")
  public String commutePage() {
    return "attendance/commute";
  }
  
  @GetMapping("/annualLeave.page")
  public String annualLeavePage() {
  	return "attendance/annualLeave";
  }
  

  @PostMapping(value="commute/registerAttendanceRecord.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> registerAttendanceRecord(@RequestBody Map<String, Object> params) throws ParseException {
    int insertCount = attendanceService.registerAttendanceRecord(params);
    return ResponseEntity.ok(Map.of("insertResult", insertCount == 1 ? "정상 처리되었습니다." : "정상 처리되지 않았습니다."));
  }

  @PostMapping(value="commute/updateAttendanceRecord.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> updateAttendanceRecord(@RequestBody Map<String, Object> params) throws ParseException {
    int insertCount = attendanceService.updateAttendanceRecord(params);
    return ResponseEntity.ok(Map.of("insertResult", insertCount == 1 ? "정상 처리되었습니다." : "정상 처리되지 않았습니다."));
  }
//  
//  @PostMapping(value="/removeEvent.do", produces="application/json")
//  public ResponseEntity<Map<String, Object>> removeEvent(@RequestBody int eventNo, RedirectAttributes redirectAttributes) {
//    int removeCount = calendearService.removeEvent(eventNo);
//    return ResponseEntity.ok(Map.of("removeCount", removeCount == 1 ? "일정이 삭제되었습니다." : "일정이 삭제되지 않았습니다."));
//  }
  
  @GetMapping(value="commute/getAttendanceRecords.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> getAttendanceRecords(@RequestParam int employeeNo) {
    return attendanceService.getAttendanceRecord(employeeNo);
  }
  
}
