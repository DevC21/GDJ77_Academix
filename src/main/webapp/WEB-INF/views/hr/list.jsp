<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<Host appBase="webapps" autoDeploy="true" name="localhost" unpackWARs="true">
	<Context docBase="kssfbiz" path="/" reloadable="true" source="org.eclipse.jst.jee.server:kssfbiz"/>
	<Context docBase="D:/FileUpload/kssfbiz/" path="/kssfbiz/upload" reloadable="true" />
</Host>
<jsp:include page="${contextPath}/WEB-INF/views/layout/header.jsp">
   <jsp:param value="채팅" name="title"/>
 </jsp:include>


<!-- Font Awesome 5.15.4 (unchanged as it's already the latest stable version for this specific major version) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

<!-- jsTree 3.3.12 (unchanged as it's the latest stable version) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/themes/default/style.min.css" />




<!-- jQuery 3.6.0 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- jQuery UI 1.12.1 (latest stable version) -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

<!-- jsTree 3.3.12 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.12/jstree.min.js"></script>

<!-- sockjs-client 1.6.1 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js" integrity="sha512-1QvjE7BtotQjkq8PxLeF6P46gEpBRXuskzIVgjFpekzFVF4yjRgrQvTG1MTOJ3yQgvTteKAcO7DSZI92+u/yZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- stomp.js 2.3.3 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>  
  
<script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>  
  
  <style>
  .chat-content {
      height: 110vh;
      width: 100%;
      display: flex;
    }
    
    .member-box {
      height: 100%;
      width: 30%;
      border-top-color: #3c8dbc;
      overflow: auto;
    }
    
    /* 직원 목록 - 검색창 */
		.searchInput {
		    border: none;
		    background-color: #E6F1F6;
		    border-radius: 4px;
		    padding: 5px;
		    width: 100%;
		}
		
		.searchInput:focus {
		  outline: none;
		}
    
    .chat-box {
	    margin-left: 1.5%;
	    height: 100%;
	    border-top-color: #3c8dbc;
    }
    
    /* 화면 너비가 768px 이하일 때 */
   	@media screen and (max-width: 768px) {
      .chat-box {
        width: 100%;
      }
    }

    /* 화면 너비가 425px 이하일 때 */
    @media screen and (max-width: 425px) {
      .chat-box {
        width: 100%;
      }
    }    
    
    .chat-member {
	  	height: 80%;
    }
    
    .box-title-choice {
      margin-left: 3%;
      font-size: 18px;
    }
    
    .box-title-choice > i {
	    margin-right: 3%;
		}
		
		.remove-box i {
		  font-size: 15px;
		}
    
    .box-tools {
      display: flex;
      justify-content: center;
      align-items: center;
    }
    
    .chat-box-dropdown {
      width: 35vh;
    }
    
    table {
      width: 100%;
    }
    .title-row td {
	    font-size: 18px;
	    font-weight: bold;
	    padding: 10px 20px;
    }
    .employee-table {
      margin: 20% 10%;
    }
    .employee-row td {
	    font-weight: 500;
      padding: 10px 20px;
    }
    
    .employee-row td:first-child {
      font-size: 15px;
    }
    
    .status {
	    font-size: 12px;
	    text-align: end;
    }
    .online {
      color: green;
    }
    .offline {
      color: red;
    }
    
    .leave-chat {
      color: black;
    }
    
    
    
    
 .empList {
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    width: 50%;
    position: fixed;
    
    right: 0;
 }

  .profile-container {
    display: flex;
    flex-direction: column;
    width: 1000px;
    padding: 10px;
    border: 1px solid #ccc;
     margin: 10px;
  }
  .profile-container div {
    margin-bottom: 10px;
 }
 
 .list-container{
   width:1500px;
   height:1500px;
 }		
		
		
	
  </style>
  
  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->


    <!-- Main content -->
    <section class="content chat-content">

			<!-- 목록 화면 - 직원, 채팅목록 -->
      <!-- Default box -->
      <div class="box member-box">
         <div class="box-header with-border">
	         <div class="box-title-choice">
	           <i class="fa fa-user"></i>
	           <i class="fa fa-commenting"></i>
	         </div>

         
         	 <!-- 닫기 버튼이랑 메뉴 버튼 -->
	         <div class="box-tools pull-right">
	           <button type="button" class="btn btn-box-tool" data-widget="collapse" data-toggle="tooltip" title="Collapse">
	             <i class="fa fa-minus"></i>
	           </button>
	         </div>
          </div>
          <p class="chat-member-title">직원목록</p>
<!--           <div class="searchInput-cover">
            <input type="text" class="searchInput" placeholder="직원 검색">
          </div> -->
        <div class="box-body chat-member"></div> 
   			<div class="addChatroomBtn-cover">
	       <a href="${contextPath}/hr/employeeRegister.page"><button type="button" class="btn btn-block btn-primary addChatRoomBtn">+ 직원 및 강사 등록</button></a>
	      </div>
      </div>


	   <div class="empList" style="display: none;">
       
       </div> 
       
       
      
          
      
         
        
         
         
      </section>
          
         
        
     
  
  
  
  
  <script>
  

	
  // 직원 리스트 가져오기
  const fnGetChatUserList = () => {
	  
 	  // 새로운 태그 추가
    //$('.chat-member').append('<p class="chat-member-title">직원 목록</p>');
 	  $('.chat-member-title').after('<div class="searchInput-cover"></div>');
    $('.searchInput-cover').append('<input type="text" class="searchInput" placeholder="직원 검색">')
    $('.chat-member').append('<div id="memberArea"></div>');
	  
	  fetch('${contextPath}/user/getUserList.do',{
	      method: 'GET',
	    })
		.then((response) => response.json())
	  .then(resData => {
		
		  // 변환한 데이터 담을 배열 선언
		  var jstreeData = [];
		  resData.employee.profilePicturePath;
		  
		  // 회사 root node로 설정
		  var com = resData.departments.find(depart => depart.departName === 'Academix');
		  if(com) {
			  jstreeData.push({
				  id: com.departmentNo,
				  parent: '#',
				  text: com.departName,
				  icon: "fas fa-building"
			  });
		  }
		  
		  // employee 데이터에서 대표데이터만 빼서 설정
		  var ceo = resData.employee.find(employee => employee.rank.rankTitle === '대표이사');
		  if(ceo) {
			  jstreeData.push({
				  id: 'emp_' + ceo.employeeNo,
				  parent: '0',
				  text: ceo.name + ' ' + ceo.rank.rankTitle,
				  icon: "fas fa-user-tie"
			  });
		  }
		  
		  // 부서 데이터
		  resData.departments.forEach(function(department) {
			  if(department.departName !== 'Academix'){
				  jstreeData.push({
					  id: department.departmentNo.toString(),
					  parent: department.parentDepartNo.toString(),
					  text: department.departName,
					  icon: "fas fa-layer-group"
				  });
			  }
		  });
		  
		  // 직원 데이터
		  resData.employee.forEach(function(employee) {
			  if(employee.depart.departmentNo !== 0 && employee.employeeStatus !== 0){ // 대표이사 제외
				  if(employee.rank.rankNo === 5) {
	     		  jstreeData.push({
	     			  id: 'emp_' + employee.employeeNo,
	     			  parent: employee.depart.departmentNo.toString(),
	     			  text: employee.name + ' ' + employee.rank.rankTitle,
	     			  icon: "fas fa-chalkboard-teacher"
	     		  });
				  } else {
       		  jstreeData.push({
       			  id: 'emp_' + employee.employeeNo,
       			  parent: employee.depart.departmentNo.toString(),
       			  text: employee.name + ' ' + employee.rank.rankTitle,
       			  icon: "fas fa-user"
       		  });
				  }
			  }
		  });
		  
		  console.log('jstreeData', jstreeData);
		  
		  // jstree 데이터 추가 - jstree가 로드되면 모든 노드 열리게 설정
		  $('#memberArea').jstree({
			  'core': {
				  'data': jstreeData,
		        'themes': {
		           'icons': true
		        }
			  },
			  'plugins': ['search', 'checkbox'],
		   		  'checkbox': {
				       'keep_selected_style': true,
				       'three_state': false,
				       'whole_node' : false,
				       'tie_selection' : false,
				       'cascade': 'down'
				    }      		  
		  }).on('ready.jstree', function() {
			  $(this).jstree(true).open_all();
		  })
		  
	    // 검색 기능 추가
	    $('.searchInput').on('keyup', function() {
	  	  var searchString = $(this).val();
	  	  $('#memberArea').jstree('search', searchString);
	    });
		  
	  })
	  .catch(error => {
	    console.error('There has been a problem with your fetch operation:', error);
	  });  
	  
	  fnGetProfile();
	  
  }
  
  // 프로필 조회하기
  const fnGetProfile = () => {
    $('#memberArea').bind('select_node.jstree', function(event, data) {
        var selectedNode = data.node;
        var employeeNo;

        // id가 0인 경우 -> Academix
        // id가 emp를 포함하는 경우 -> 그대로..
        // 그외 -> return
        if (selectedNode.id.includes('emp_')) {
            employeeNo = selectedNode.id.replace('emp_', '');
        } else {
            return;
        }

        fetch('${contextPath}/user/getUserProfileByNo.do?employeeNo=' + employeeNo, {
                method: 'GET',
            })
            .then((response) => response.json())
            .then(resData => {
                var employee = resData.employee;
                console.log(employee.employeeNo);
                let str= '<div class="list-container"  id="list-emp">';
                str += '<div class="profile-container">';
                
                str +=  '<div>' + employee.profilePicturePath.replace('<img ', '<img style="width: 50px;" ') + '</div>';
                
                str += '</div>';
                str += '<div class="not-profile-grid">';
                str += '<div>이름: ' + employee.name + '</div>';
                str += '<div>이메일: ' + employee.email + '</div>';
                str += '<div>비밀번호: ' + employee.password + '</div>';
                str += '<div>전화번호: ' + employee.phone + '</div>';
                str += '<div>주소: ' + employee.address + '</div>';
                str += '<div>부서: ' + employee.depart.departName + '</div>';
                str += '<div>직급: ' + employee.rank.rankTitle + '</div>';
                str += '<div>상태: ' + employee.employeeStatus + '</div>';
                str += '<div>입사일: ' + employee.hireDate + '</div>';
                str += '<div>사원번호: ' + employee.employeeNo + '</div>';
                str += '<div>퇴사일: ' + employee.exitDate + '</div>';
                
                str += '</div>'; // grid닫기
                
                str += '<div>';
                str += '<button type="button" class="btn btn-default btn-empEdit" onclick="profileEdit(\'' + employee.employeeNo + '\')">수정</button>';
                str += '</div>';
                str += '</div>';

                $('.empList').empty().append(str); // 기존 정보 삭제 후 새로운 정보 추가
                $('.empList').show();
            })
            .catch(error => {
                console.error('There has been a problem with your fetch operation:', error);
            });
    });
};

function profileEdit(employeeNo) {
    // 새로운 페이지 URL 생성 (예시 URL)
    var editPageUrl = '${contextPath}/hr/profileEdit.do?employeeNo=' + employeeNo;	
    // 페이지 이동
    window.location.href = editPageUrl;
}


	   
	  
	   
	   
	   
  fnGetChatUserList()  
  </script>


<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>
<!-- Bootstrap 3.3.6 -->
<script src="/bootstrap/js/bootstrap.min.js"></script>
<!-- Morris.js charts -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="/plugins/morris/morris.min.js"></script>

<!-- Sparkline -->
<script src="/plugins/sparkline/jquery.sparkline.min.js"></script>
<!-- jvectormap -->
<!-- <script src="/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script> -->
<!-- <script src="/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script> -->
<!-- jQuery Knob Chart -->
<script src="/plugins/knob/jquery.knob.js"></script>
<!-- daterangepicker -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
<script src="/plugins/daterangepicker/daterangepicker.js"></script>
<!-- datepicker -->
<script src="/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- Bootstrap WYSIHTML5 -->
<script src="/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
<!-- Slimscroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="/dist/js/app.min.js"></script>
<!-- AdminLTE dashboard demo (This is only for demo purposes) -->

<!-- AdminLTE for demo purposes -->
<script src="/dist/js/demo.js"></script>
<!-- <script src="/dist/js/pages/dashboard.js"></script>   -->
    
<jsp:include page="${contextPath}/WEB-INF/views/layout/footer.jsp" />
