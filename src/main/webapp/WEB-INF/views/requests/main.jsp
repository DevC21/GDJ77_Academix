<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<jsp:include page="${contextPath}/WEB-INF/views/layout/header.jsp">
   <jsp:param value="내 문서함" name="title"/>
 </jsp:include>
 
 <style>

.table{
 background-color: white;
 border-radius: 20px;
 margin-top: 50px;
}
.table tbody tr {
  
  padding-top: 10px;
  padding-bottom: 10px;
}
  tfoot tr {
        display: flex;
    }
  
  .bg-green-active{
   border-radius: 5px;
  }
  .bg-red-active{
   border-radius: 5px;
  }
  
  .paging {
  display: flex;
}
  
</style>
  
  
  <div class="content-wrapper">
      <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        내 문서함
        <small>Control panel</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">내 문서함</li>
      </ol>
    </section>
  
    <!-- Main content -->
    <section class="content">  
	  <div>
	  <div>
	    <input type="radio" name="sort" value="DESC" id="descending" checked>
	    <label for="descending">내림차순</label>
	    <input type="radio" name="sort" value="ASC" id="ascending">
	    <label for="ascending">오름차순</label>
	  </div>
	  <div>
	    <span>화면</span>
	    <select id="display" name="display">
	      <option>5</option>
	      <option>10</option>
	      <option>20</option>
	    </select>
	  </div>
	  <div>
	   <span>문서종류</span>
	  <select id="status" name="status">
	      <option value="5">전체</option>
	      <option value="0">미결재</option>
	      <option value="1">승인</option>
	      <option value="2">반려</option>
	    </select> 
	  </div>
	  <table class="table align-middle">
	    <thead>
	      <tr>
	        <td>기안서 번호</td>
	        <td>기안서 종류</td>
	        <td>기안자</td>
	        <td>기안일</td>
	        <td>결재 상태</td>
	      </tr>
	    </thead>
	    <tbody>
	      <c:forEach items="${requestsList}" var="leaveRequests" varStatus="vs">
	    
	        <tr class="sta" data-request-status="${leaveRequests.requestStatus}">
	          <td>${leaveRequests.requestNo}</td>
	          <td>
	          <c:if test="${leaveRequests.requestSort == 1}">
	            <a href="${contextPath}/requests/detail.do?requestNo=${leaveRequests.requestNo}">
	            </c:if>
	            <c:if test="${leaveRequests.requestSort == 0}">
	              <a href="${contextPath}/requests/attendanceDetail.do?requestNo=${leaveRequests.requestNo}">
	            </c:if>
	             <c:choose>
	                      <c:when test="${leaveRequests.requestSort eq '0'}">
	                        근태조정서
						 </c:when>
	                      <c:when test="${leaveRequests.requestSort eq '1'}">
	                        연차신청서
						 </c:when>
	                </c:choose></a>
	          </td>
	          <td>${leaveRequests.employees.name}</td>
	          <td>${leaveRequests.requestDate}</td>
	          <td>
	          <span class='<c:choose>
	            <c:when test="${leaveRequests.requestStatus eq '1'}">
			            state bg-green-active color-palette
			        </c:when>
			        <c:when test="${leaveRequests.requestStatus eq '2'}">
				            state bg-red-active color-palette
				    </c:when>
	           </c:choose>'> 
	          <c:choose>
	              <c:when test="${leaveRequests.requestStatus eq '0'}">
	                        미결재
				  </c:when>
	               <c:when test="${leaveRequests.requestStatus eq '1'}">
	                        승인
				   </c:when>
	                 <c:when test="${leaveRequests.requestStatus eq '2'}">
	                        반려
					</c:when>
	         </c:choose>
	         </span>       
	         </td>
	        </tr>
	        
	      </c:forEach>
	    </tbody>
	    <tfoot>
	      <tr>
	        <td class="paging" colspan="4">${paging}</td>
	      </tr>
	    </tfoot>
	  </table>
	</div>
  
  </section>
  <!-- /.content -->
  
  </div>
    <!-- /.content-wrapper -->

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
   
  //console.log("${requestsList}");
  
  const fnDisplay = () => {
	  document.getElementById('display').value = '${display}';
	  document.getElementById('display').addEventListener('change', (evt) => {
	    location.href = '${contextPath}/requests/main.page?employeeNo=' +${sessionScope.user.employeeNo} + '&page=1&sort=${sort}&display=' + evt.target.value;
	  })
	}

	const fnSort = () => {
	  $(':radio[value=${sort}]').prop('checked', true);
	  $(':radio').on('click', (evt) => {
	    location.href = '${contextPath}/requests/main.page?page=${page}&sort=' + evt.target.value + '&display=${display}';
	  })
	}
	
	document.getElementById('status').addEventListener('change', (evt) => {
	    const status = evt.target.value; // 선택된 옵션의 값
	    const rows = document.querySelectorAll('.sta'); // 모든 행 요소를 선택

	    // 각 상태에 따라 행을 숨기거나 보여주는 로직
	    rows.forEach(row => {
	        const rowStatus = row.getAttribute('data-request-status');
	        if (status === '5') {
	            row.style.display = ''; // 전체를 선택한 경우 모든 행 보이기
	        } else {
	            if (rowStatus === status) {
	                row.style.display = ''; // 선택한 상태에 해당하는 행 보이기
	            } else {
	                row.style.display = 'none'; // 선택한 상태가 아닌 경우 행 숨기기
	            }
	        }
	    });
	});
	
	
	//resultMap="EmployeesMap"
	console.log(${sessionScope.user.employeeNo});
	
	


	fnDisplay();
	fnSort();
	</script>

<jsp:include page="${contextPath}/WEB-INF/views/layout/footer.jsp" />