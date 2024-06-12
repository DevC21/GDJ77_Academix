<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- sockjs-client 1.6.1 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js" integrity="sha512-1QvjE7BtotQjkq8PxLeF6P46gEpBRXuskzIVgjFpekzFVF4yjRgrQvTG1MTOJ3yQgvTteKAcO7DSZI92+u/yZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<!-- stomp.js 2.3.3 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>  

<script>
  $.widget.bridge('uibutton', $.ui.button);
  
  

  // 전역 stomp 클라이언트 설정
  let globalStompClient;
  
  const fnConnectGlobalStompClient = () => {
	  let employeeNo = ${sessionScope.user.employeeNo};
	  let globalSocket = new SockJS("/ws-stomp?employeeNo=" + employeeNo);
	  globalStompClient = Stomp.over(globalSocket); // STOMP 클라이언트 객체 저장
	  
	  
	  globalStompClient.connect({}, (frame) => {
		  
		  console.log('전역 소켓 연결 성공: ' + frame);
		  
		  globalStompClient.subscribe('/user/queue/notifications', (notification) => { // notification은 수신된 메시지를 가리키는 객체
			  
			  console.log('메시지 받음 >>> ', notification.body)
			  
			  const message = JSON.parse(notification.body);
			  fnShowAlert(message);
			  //showNotification(JSON.parse(notification.body));
		  }, {id: 'alert-' + ${sessionScope.user.employeeNo}});
	  }, function(error) {
		  console.log('WebSocket connection error: ' + error);
	  });
  };
  
/*    const showNotification = (message) => {
	    console.log('알림 표시 시도: ' + message);
 	    if (Notification.permission === 'granted') {
	        new Notification('New message', {
	            body: message,
	        });
	        console.log('알림 표시 완료');
	    } else if (Notification.permission !== 'denied') {
	        Notification.requestPermission().then(permission => {
	            if (permission === 'granted') {
	                new Notification('New message', {
	                    body: message,
	                });
	                console.log('알림 권한 획득 후 알림 표시 완료');
	            }
	        });
	    } 
	}; */
	
	
	// 알림 메시지 추가
 	const fnShowAlert = (notification) => {
 		
		/*
		{"notificationNo":4,
			"seenStatus":0,
			"employeeNo":6,
			"chatroomNo":2,
			"notifierNo":16,
			"message":"알림 테스트3\n",
			"notificationType":"CHAT",
			"notifierName":"김지현 강사",
			"notificationDate":"2024-06-11T06:26:48.562+00:00"
			} 
		*/
 		
		// 메시지 내용 : 송신자/내용 -> /기준으로 각각 파싱
		
		// 메시지 내용이 10자 이상이면 10글자까지만 추출해서 보여줌.
		let messageContent = notification.message;
		let chatroomNo = notification.chatroomNo;
		let senderName = notification.notifier.name + ' ' + notification.notifier.rank.rankTitle;
		
		let notificationDate = notification.notificationDate;
		let notificationTime = getTimeDifference(notificationDate);
		
		let $menu = $('.alert-menu');
		// 받아온 메시지를 알림메시지에 추가한다.
		let msg = '';
		msg += '<li class="notification-item" data-chatroom-no="' + chatroomNo + '">';
		msg += '  <a href="#">';
		msg += '    <div class="pull-left">';
		msg += '      <img src="${contextPath}/resources/images/free-icon-star-1828884.png" class="img-circle" alt="User Image" style="width: 20px; height: 20px; margin: 6px auto auto 6px;">';
		msg += '    </div>';
		msg += '    <h4>';
		msg += senderName;
		msg += '<small style="margin-right: 15px;"><i class="fa fa-clock-o" style="margin-right: 2px;"></i>' + notificationTime + '</small>'
		msg += '<small class="btn-removeMessageAlert"><i class="fa fa-times"></i></small>';
		msg += '    </h4>';
		msg += '    <p>' + messageContent + '</p>';
		msg += ' </a>';
		msg += '</li>';
		
		$menu.prepend(msg);
        <!-- start message -->
		
	}
 	
 	// 알림 메시지 가져오기
 	const fnGetNotificationList = () => {
 		
 		// employeeNo에 따른 알림 메시지 가져오기
 		let employeeNo = ${sessionScope.user.employeeNo};
 		fetch('${contextPath}/notification/getNotificationList.do?employeeNo=' + employeeNo, {
 			method: 'GET',
 		})
 		.then((response) => response.json())
 		.then(resData => {
 			
 			console.log('알림 리스트: ', resData);
 			
 			/*
			{
			    "notificationList": [
			        {
			            "notificationNo": 18,
			            "seenStatus": 0,
			            "employeeNo": 7,
			            "chatroomNo": 2,
			            "notifierNo": 11,
			            "message": "내일 회의 시간 다시 확인 부탁드려요.\n",
			            "notificationType": "CHAT",
			            "notificationDate": "2024-06-12T00:12:42.513+00:00",
			            "notifier": {
			                "employeeNo": 7,
			                "employeeStatus": 0,
			                "name": "정은비",
			                "email": null,
			                "phone": null,
			                "address": null,
			                "password": null,
			                "profilePicturPath": null,
			                "hireDate": null,
			                "exitDate": null,
			                "depart": null,
			                "rank": {
			                    "rankNo": 1,
			                    "rankTitle": "수석"
			                }
			            }
			        },
 			*/
				// 받아온 알림 리스트를 돌면서 알림창에 추가 
				resData.notificationList.forEach((notification) => {
					
			 			let messageContent = notification.message;
			 			let chatroomNo = notification.chatroomNo;
			 			let notificationNo = notification.notificationNo;
			 			let senderName = notification.notifier.name + ' ' + notification.notifier.rank.rankTitle;
			 			
			 			let notificationDate = notification.notificationDate;
			 			let notificationTime = getTimeDifference(notificationDate);
			 			
			 			let $menu = $('.alert-menu');
			 			// 받아온 메시지를 알림메시지에 추가한다.
			 			let msg = '';
			 			msg += '<li class="notification-item" data-chatroom-no="' + chatroomNo + '" data-notification-no="' + notificationNo + '">';
			 			msg += '  <a href="#">';
			 			msg += '    <div class="pull-left">';
			 			msg += '      <img src="${contextPath}/resources/images/free-icon-star-1828884.png" class="img-circle" alt="User Image" style="width: 20px; height: 20px; margin: 6px auto auto 6px;">';
			 			msg += '    </div>';
			 			msg += '    <h4>';
			 			msg += senderName;
			 			msg += '<small style="margin-right: 15px;"><i class="fa fa-clock-o" style="margin-right: 2px;"></i>' + notificationTime + '</small>'
			 			msg += '<small class="btn-removeMessageAlert"><i class="fa fa-times"></i></small>';
			 			msg += '    </h4>';
			 			msg += '    <p>' + messageContent + '</p>';
			 			msg += ' </a>';
			 			msg += '</li>';
			 			
			 			$menu.append(msg);			 			
			 			
				})
				if(resData.notificationList.length > 0) {
					$('.alert-menu-sub').text('총 ' + resData.notificationList.length + '개의 읽지않은 알람');
				} else {
					$('.alert-menu-sub').text('알람을 모두 확인했어요!');
				}
 			})
  }
 	
 	
	  // 알림 메시지 삭제하기 (X 버튼)
/*     const fnRemoveMessageAlert = () => {
    	$(document).on('click', function(evt) {
    	    if ($(evt.target).closest('.btn-removeMessageAlert').length) {
    	        evt.preventDefault();
    	        $(evt.target).closest('.notification-item').remove();
    	    }
    	});
   	} */
   	
   	// x 버튼 눌러서 메시지 알림 삭제
   	const fnRemoveMessageAlert = () => {
   		$(document).on('click', '.btn-removeMessageAlert', (evt) => {
				
   			// 해당 요소의 notification_no 넘겨줌
   			let notificationNo = $(evt.target).closest('.notification-item').data('notification-no');
   			let notificationNoList = [];
   			notificationNoList.push(notificationNo);
   			fnUpdateSeendStatus(notificationNoList);

   			// 해당 요소 삭제
   			evt.preventDefault();
   			$(evt.target).closest('.notification-item').remove();
   		})
   	}
    
    // seenStatus값 0에서 1로 업데이트하기
    const fnUpdateSeendStatus = (notificationNoList) => {
    	
    	fetch('${contextPath}/notification/updateSeenStatus.do', {
    		method: 'PATCH',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            notificationNoList: notificationNoList,
        })
    	})
    	.then((response) => response.json())
    	.then(resData => {
    		console.log(resData);
    	})
   	} 	
    
    
    // 시간 계산
    const getTimeDifference = (timestamp) => {
        const notificationTime = new Date(timestamp);
        const now = new Date();
        const diff = now - notificationTime;
        const diffMinutes = Math.floor(diff / 1000 / 60);
        const diffHours = Math.floor(diff / 1000 / 60 / 60);
        const diffDays = Math.floor(diff / 1000 / 60 / 60 / 24);

        if (diffMinutes < 1) {
            return "방금";
        } else if (diffMinutes < 60) {
            return diffMinutes + "분 전";
        } else if (diffHours < 24) {
            return diffHours + "시간 전";
        } else {
            return diffDays + "일 전";
        }
    }
    
    // 메시지 알림 모두 삭제
		const fnRemoveAllMessageNotify = () => {
			// 모든 메시지 알림 삭제 버튼 클릭 시
	    $('.remove-allMessageNoti').on('click', () => {
	        let notificationNoList = [];

	        $('.notification-item').each(function() {
	        	notificationNoList.push($(this).data('notification-no'));
	        });
	        
	        if(notificationNoList.length > 0) {
		        fnUpdateSeendStatus(notificationNoList);
		        $('.alert-menu').empty();
		        $('.alert-menu-sub').text('알람을 모두 확인했어요!');
	        } else {
	        	return;
	        }
	    });
		}
    

		
    // 알림 클릭 시 해당 채팅방으로 이동
     const fnDirectChatroom = () => {
    	$(document).on('click', '.notification-item', (evt) => {
    		
    		let notificationNo = $(evt.currentTarget).data('notification-no');
    		let chatroomNo = $(evt.currentTarget).data('chatroom-no');
    		let notificationNoList = [notificationNo];
    		fnUpdateSeendStatus(notificationNoList);
    		window.location.href = '${contextPath}/chatting/chat.page?chatroomNo=' + chatroomNo;
    	})
    } 
    
	
	window.addEventListener('load', fnConnectGlobalStompClient);
	fnGetNotificationList();
	fnRemoveMessageAlert();
	fnRemoveAllMessageNotify();
	fnDirectChatroom();



  
  
  
  
  
  
</script>
  <footer class="main-footer">
    
  </footer>

</body>
</html>


