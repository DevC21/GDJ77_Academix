<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>


<jsp:include page="${contextPath}/WEB-INF/views/layout/header.jsp">
   <jsp:param value="전자결재" name="title"/>
 </jsp:include>

<style>

.title h1 {
    margin: 0;
}

.title-right {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
}

.title-right span {
    font-weight: bold;
    margin-bottom: 5px;
}

.dept-approval {
    border: 1px solid #000;
    padding: 5px 10px;
}

.form-row {
    display: flex;
    gap: 15px;
}

.form-group {
    flex: 1;
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
}

.form-group label {
    flex: 1;
    margin-right: 10px;
    text-align: right;
    line-height: 2.5;
    font-size: 16px; /* 라벨 글자 크기 */
}

.form-group input,
.form-group select {
    flex: 3;
    padding: 5px;
     border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 16px; /* 입력 필드 글자 크기 */
    width: 100%;
}

.reason {
    flex: 1;
}

.reason input {
    width: 100%;
    height: 100px; /* 사유 입력란의 높이를 키웁니다. */
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

.btn-all{
 display:flex;
}

#btn-submit {
    display: block;
    width: 50%;
    padding: 10px;
    background-color: #007BFF;
    color: #fff;
    border: none;
    cursor: pointer;
    border-radius: 10px;
    margin-right: 10px;
}

#btn-remove{
 	display: block;
    width: 50%;
    padding: 10px;
    background-color: gray;
    color: #fff;
    border: none;
    cursor: pointer;
    border-radius: 10px;
}

button:hover {
    background-color: #0056b3;
}

#option1 {
    display: none;
}

.title-right {
    width: 30%;
    margin: auto;
}

.dept-approval {
    width: 50%;
}

.stamp-box {
    width: 50%;
    border: 1px solid black;
}

#files {
    border-radius: 10px;
}

.form-container {
    display: flex;
    border: 1px solid #000;
    width: 100%;
    height: 150px; /* 원하는 높이로 조절하세요 */
}

.form-title {
    flex: 2;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    font-weight: bold;
    border-right: 1px solid #000;
}

.form-approval {
    flex: 1;
    display: flex;
    flex-direction: column;
    border-left: 1px solid #000;
}

.form-approval div {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #000;
    font-weight: bold;
}

.form-approval div:last-child {
    border-bottom: none;
}

.form-stamp {
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: bold;
    border-top: 1px solid #000;
    height: 50%;
}

#option2{
 width:95%;
 height: 1000px;
 background-color: white;
  
}
.content-main {
    height:500px;
    justify-content: center;
    width: 80%; /* 원하는 너비로 조절 */
    margin: 0 auto; /* 중앙 정렬 */
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 10px;
    background-color: #f9f9f9;
}

   .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: none;
    justify-content: center;
    align-items: center;
}

/* 모달 내용 스타일 */
.modal-content {
    
    height: auto;
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
}

/* 닫기 버튼 스타일 */
.close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
}    

#attach-file {
 width: 381px;
 height: 45px;
 border: 1px, solid gray;
 background-color: white;
 border-radius: 5px;
}

#rejectReason2{
 width: 381px;
 height: 45px;
}

#btn-reject{
 border-radius: 5px;
}
#btn-approval{
border-radius: 5px;
}
 
</style>

 <div class="content-wrapper">
   <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        근태조정서
        <small>Control panel</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">근태조정서</li>
      </ol>
    </section>
  
  <!-- Main content -->
  <section class="content"> 
	   <div id="option2">
	   
		 <form id="requestForm"
		       method="POST"
		       enctype="multipart/form-data">
	   	  <c:if test="${sessionScope.user.depart.departmentNo == 2}">
			  <button type="submit" class="state bg-green-active color-palette" id="btn-approval" onclick="submitForm('approval')">승인</button>
		      <button type="button" class="state bg-red-active color-palette" id="btn-reject" onclick="openModal()">반려</button>
		   </c:if>   
		  <div class="content-main">
		   <div class="header-wrapper">
	                <div class="form-container">
				        <div class="form-title">근무조정 신청서</div>
				        <div class="form-approval">
			              <div>결재:인사과</div>
			              <div class="form-stamp">
			                <c:choose>
	                       <c:when test="${attendance.requests.requestStatus eq '0'}">
	                        미결재
						  </c:when>
	                       <c:when test="${attendance.requests.requestStatus eq '1'}">
	                        <img src="/images/approved.png" style="width:100px;">
						  </c:when>
	                       <c:when test="${attendance.requests.requestStatus eq '2'}">
	                        <img src="/images/rejected.png" style="width:100px;">
						   </c:when>
	                      </c:choose>
			              </div>
	                     </div>
	               </div>
	            </div>
		   <div class="form-row">
		    <div class="form-group">
		      <label for="departName">부서명</label>
		      <input type="text" name="departName" id="departName" readonly>
		      </div>
		      <div class="form-group">
		        <label for="name">성명</label>
		        <input type="text" name="name" id="name" value="${attendance.requests.employees.name}" readonly>
		      </div>
		    </div>  
		    <div class="form-row">
		      <div class="form-group">
		         <label for="rankTitle">직책</label>
		         <input type="text" name="rankTitle" id="rankTitle" readonly>
		      </div>   
			  <div class="form-group">
			    <label for="adjustmentDate">변경신청날짜</label>
			    <input type="date" name="adjustmentDate" id="adjustmentDate" >
			  </div>
		    </div> 
		    <div class="form-row">
			  <div class="form-group">
			    <label for="timeIn">변경요청출근시간</label>
			    <input type="time" name="timeIn" id="timeIn" >
			  </div>
			  <div class="form-group">
			    <label for="timeIn">변경요청퇴근시간</label>
			    <input type="time" name="timeOut" id="timeOut">
			  </div>
		   </div>
		   <div class="form-row">
			  <div class="form-group">
			    <label for="reason">사유</label>
			    <input type="text" name="reason" id="reason" value="${attendance.requests.reason}">
			  </div> 
			  <div class="form-group">
				<label for="files">첨부</label>
				<input type="file" name="files" id="files" multiple>
			</div>	
				<input type="hidden" name="employeeNo" id="employeeNo"  value="${attendance.requests.employees.employeeNo}">
				<input type="hidden" name="requestStatus" id="requestStatus" value="0">
				<input type="hidden" name="picNo" value="0">
				<input type="hidden" name="requestSort" value="0">
				<input type="hidden" name="requestNo" id="requestNo" value="${attendance.requests.requestNo}">
		  </div>
		  <div class="form-row">
		   <div class="form-group">
		    <label for="attach-file">첨부된파일</label>
		    <div data-attach-no="${attendance.attach.attachNo}" id="attach-file">${attendance.attach.originalFileName}</div>
		   </div>
		   <div class="form-group">
		     <label for="rejectReason2">반려사유</label>
		     <textarea id="rejectReason2">${attendance.requests.rejectReason}</textarea>
		   </div>
		  </div>
		  <div class="btn-all">
		  
		   <c:choose>
			    <c:when test="${sessionScope.user.employeeNo == attendance.requests.employees.employeeNo}">
			        <button type="button" id="btn-submit" onclick="submitForm('modify')">수정하기</button>
			    </c:when>
			    <c:otherwise>
			        <button type="button" id="btn-submit" disabled>수정하기</button>
			    </c:otherwise>
	      </c:choose>
		  <c:choose>
		    <c:when test="${sessionScope.user.employeeNo == attendance.requests.employees.employeeNo}">
			        <button type="button" id="btn-remove">삭제</button>
		    </c:when>
		    <c:otherwise>
		     <button type="button" id="btn-remove" disabled>삭제</button>
		    </c:otherwise>
		     
		   </c:choose>
		  </div>
		 </div> 
		 </form> 
		</div> 
	 
	 
	 <div id="myModal" class="modal">
	   <form action="${contextPath}/requests/reject.do"
	   		 method="POST" id="frm-reject">
	     <div class="modal-content">
	        <!-- 닫기 버튼 -->
	        <span class="close" onclick="closeModal()">&times;</span>
	        <!-- 사유 입력란 -->
	        <label for="rejectReason">사유:</label>
	        <textarea id="rejectReason" name="rejectReason" rows="4" cols="50"></textarea>
	        <input type="hidden" name="requestNo" id="requestNo" value="${attendance.requests.requestNo}">
	        <input type="hidden" name="employeeNo" id="employeeNo" value="${sessionScope.user.employeeNo}">
	        <input type="hidden" name="requestStatus" id="requestStatus" value="2">   
	         <input type="hidden" name="picNo" id="picNo" value="1">
	        <br>
	        <!-- 반려 버튼 -->
	        <button onclick="submit">반려하기</button>
	        <button onclick="closeModal()">취소</button>
	    </div>
	   </form>
	</div>
 
 </section>
 </div>
  
  
<!-- jQuery 2.2.3 -->
<script src="/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="/bootstrap/js/bootstrap.min.js"></script>
<!-- Slimscroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="/dist/js/app.min.js"></script>
  
  <script>
  

  const departmentMap = {
		    0: '대표실',
		    1: '행정부',
		    2: '인사팀',
		    3: '운영팀',
		    4: '강사'
		};

		// 직급명과 번호 매핑
		const rankMap = {
		    0: '대표이사',
		    1: '수석',
		    2: '책임',
		    3: '주임',
		    4: '사원',
		    5: '강사'
		};

		function formFill() {
			document.getElementById('departName').value = departmentMap[${attendance.requests.employees.depart.departmentNo}];
		   	document.getElementById('rankTitle').value = rankMap[${attendance.requests.employees.rank.rankNo}];
		}
		formFill();
// Moment.js를 사용하여 adjustmentDate 값을 포맷팅하여 반환하는 함수
function formatDateWithout(dateTimeString) {
    if (!dateTimeString) return ''; // dateTimeString이 없을 경우 빈 문자열 반환
    
    // Moment.js를 사용하여 dateTimeString을 Date 객체로 변환하고, yyyy-MM-dd 형식으로 포맷팅
    return moment(dateTimeString).format('YYYY-MM-DD');
}
function formatDateWithoutTime(timeString) {
    if (!timeString) return ''; // dateTimeString이 없을 경우 빈 문자열 반환
    
    // Moment.js를 사용하여 dateTimeString을 Date 객체로 변환하고, yyyy-MM-dd 형식으로 포맷팅
    return moment(timeString).format('HH:mm');
}
function formatDateWithoutTime2(timeString) {
    if (!timeString) return ''; // dateTimeString이 없을 경우 빈 문자열 반환
    
    // Moment.js를 사용하여 dateTimeString을 Date 객체로 변환하고, yyyy-MM-dd 형식으로 포맷팅
    return moment(timeString).format('HH:mm');
}
// 예시: 서버에서 받아온 adjustmentDate 값
const adjustmentDateValue = "${attendance.adjustmentDate}";
document.getElementById("adjustmentDate").value = formatDateWithout(adjustmentDateValue);

const adjustmentTimeInDateValue = "${attendance.timeIn}";
document.getElementById("timeIn").value = formatDateWithoutTime(adjustmentTimeInDateValue);

const adjustmentTimeOutDateValue = "${attendance.timeOut}";
document.getElementById("timeOut").value = formatDateWithoutTime(adjustmentTimeOutDateValue);




 function rejectRequest() {
    // requestStatus 필드의 값을 2로 변경
    document.getElementById("requestStatus").value = "2";
    document.getElementById("picNo").value = "${sessionScope.user.employeeNo}";
    document.getElementById("frm-requests-approval").submit();
}

 function submitForm(action) {
     const form = document.getElementById('requestForm');
     if (action === 'approval') {
         form.action = "${contextPath}/requests/requestApproval.do";
         document.getElementById("requestStatus").value = "1";
         document.getElementById("picNo").value = "${sessionScope.user.employeeNo}"
     } else if (action === 'modify') {
         form.action = "${contextPath}/requests/attendanceModify.do";
     } else if (action === 'reject') {
    	 
     }
     form.submit();
 }

//모달 열기 함수
 function openModal() {
     var modal = document.getElementById('myModal');
     modal.style.display = 'flex';
 }

 // 모달 닫기 함수
 function closeModal() {
     var modal = document.getElementById('myModal');
     modal.style.display = 'none';
 }
 
 const fnDownload = () => {
	 var attachNo = document.getElementById('attach-file').dataset.attachNo;
	  $('#attach-file').on('click', (evt) => {
	    if(confirm('해당 첨부 파일을 다운로드 할까요?')) {
	      location.href = '${contextPath}/requests/download.do?attachNo=' +attachNo;
	    }
	  })
	} 

 const fnRemoveAttendance = () => {
	 document.getElementById('btn-remove').addEventListener('click', (evt)=>{
		 if(confirm('근무조정서를 삭제할까요?')){
		 let requestNo = document.getElementById('requestNo').value;
		 let employeeNo = document.getElementById('employeeNo').value
		 location.href = '${contextPath}/requests/removeAttendance.do?requestNo=' + requestNo + '&employeeNo=' + employeeNo;
			 
		 }
	 })
 }
 

 

 
 fnDownload();
 fnRemoveAttendance();
 
 

</script>


<jsp:include page="${contextPath}/WEB-INF/views/layout/footer.jsp" />