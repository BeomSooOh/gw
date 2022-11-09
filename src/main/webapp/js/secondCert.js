/**************************************************
   secondCert.js
   
   [이차인증 전용 js파일]
  
**************************************************/
/******/


function secondCertPopInit() {
		/*리사이즈*/
		var loginWidth = $('#login_v2').width();
		var loginHeight = $('#login_v2').height();
		$('#login_v2').css("margin-top", -loginHeight * 0.5);
		$('#login_v2').css("margin-left", -loginWidth * 0.5);

		$(window).resize(function() {
			var loginWidth = $('#login_v2').width();
			var loginHeight = $('#login_v2').height();
			$('#login_v2').css("margin-top", -loginHeight * 0.5);
			$('#login_v2').css("margin-left", -loginWidth * 0.5);
		});
		
		/*리사이즈*/
		var loginWidth = $('#login_v3').width();
		var loginHeight = $('#login_v3').height();
		$('#login_v3').css("margin-top", -loginHeight * 0.5);
		$('#login_v3').css("margin-left", -loginWidth * 0.5);

		$(window).resize(function() {
			var loginWidth = $('#login_v3').width();
			var loginHeight = $('#login_v3').height();
			$('#login_v3').css("margin-top", -loginHeight * 0.5);
			$('#login_v3').css("margin-left", -loginWidth * 0.5);
		});
		
		
		/*리사이즈*/
	    var loginWidth = $('#login_v4').width();
	    var loginHeight = $('#login_v4').height();
	    $('#login_v4').css("margin-top",-loginHeight*0.5);
	    $('#login_v4').css("margin-left",-loginWidth*0.5);
	    
	    $(window).resize(function(){
	        var loginWidth = $('#login_v4').width();
		    var loginHeight = $('#login_v4').height();
		    $('#login_v4').css("margin-top",-loginHeight*0.5);
		    $('#login_v4').css("margin-left",-loginWidth*0.5);
	    });

		tid = setInterval(function() {
			msg_time();
		}, 1000);
	}

	function qrCreate(data, type) {
		//QR코드에 담을 정보를 넣어주세요.			
		var secondCertKey = data;
		var qrCodeUrl = window.location.protocol + "//" + window.location.host + secondCertKey + "?ver=" + new Date().getTime();
		
		var qrImgId = (type == "L" ? "qrImg1" : "qrImg2");
		
		var imgQrCode = '<img id="' + qrImgId + '" src="' + qrCodeUrl + '" border="0" title="QR Codes">';
		
		if(type == "L"){
			$('#qr_view1').html($('#qr_view1').html() + imgQrCode);
		}
		else if(type == "D"){
			$('#qr_view2').html($('#qr_view2').html() + imgQrCode);
		}
		
		$("#" + qrImgId).attr("src", qrCodeUrl);
	}

	var SetTime = 179; // 최초 설정 시간(기본 : 3분)
	function msg_time() { // 1초씩 카운트			
		// 남은 시간 계산
		var min = Math.floor(SetTime / 60);
		var sec = (SetTime % 60);

		if (min < 10) {
			min = "0" + min;
		}
		if (sec < 10) {
			sec = "0" + sec;
		}
		SetTime--; // 1초씩 감소
		if (SetTime < 0) { // 시간이 종료 되었으면..				
			clearInterval(tid); // 타이머 해제
			setScAlert("제한시간 이내에 QR코드 인증을 하지 않아 로그인 화면으로 이동합니다.</br>재로그인해주세요.", 'warning', '1');
		}else{
			if(secondCertType == "L"){
				$("#qr_time1").html(min + ":" + sec);
			}else{
				$("#qr_time2").html(min + ":" + sec);
			}
			
			checkSecondCertValidate();
		}

		
	}
	
	
	function setSecondCertPop() {
		readScOptionInfo();
	}
	
	function readScOptionInfo(){
		tblParam = {};
		tblParam.empSeq = ScTargetEmpSeq;
		tblParam.groupSeq = scGroupSeq;
		
		$.ajax({
			type : "post",
			url : "/gw/cmm/systemx/selectScOptionInfo.do",
			datatype : "json",	
			data : tblParam,
			success : function(data) {
				scOptionInfo = data.scOptionInfo; 
			    pinInfo = data.pinInfo;
			    
			    qrCreate(secondCertQrData, secondCertType);
				
				if(scOptionInfo.pinYn == "Y" && secondCertType != "L"){
					var data = {};
					data.scPinInfo = pinInfo;
					setPinInput(data);
				}else{		
					if(secondCertType == "L"){
						$("#login_v2").css("display", "block");
						$("#login_v3").css("display", "none");			
					}else{
						$("#login_v2").css("display", "none");
						$("#login_v3").css("display", "block");
					}			
					secondCertPopInit();
				}
			}
		});
	}
	
	
	function checkSecondCertValidate(){
		tblParam = {};
		tblParam.seq = secondCertSeq;
		tblParam.type = secondCertType;
		tblParam.groupSeq = scGroupSeq;
		tblParam.empSeq = ScTargetEmpSeq;
		
		$.ajax({
			type : "post",
			url : "/gw/cmm/systemx/checkSecondCertValidate.do",
			datatype : "json",	
			data : tblParam,
			success : function(data) {
				checkResultCode(data, secondCertType);
			},
			error : function(e) {
				clearInterval(tid);
				location.href = "/gw/uat/uia/egovLoginUsr.do";
			}
		});
	}
	
	var removeDeviceCnt = 0;
	
	function btnChangScDevice(){
		
		$("#devRegTitle").html("이차인증 기기변경");
		$("#devRegText").html("이차인증 기기를 변경합니다.</br>비즈박스 알파 모바일 앱에서 아래의 코드를 읽어주세요.");
		$("#devRegSubText").html("※ 인증기기 변경 이후, 재로그인이 필요합니다.</br>인증기기 승인 여부 옵션에 따라, 관리자의 승인이 필요할 수 있습니다.");
		
		tblParam = {};
		tblParam.empSeq = ScTargetEmpSeq;
		tblParam.groupSeq = scGroupSeq;
		
		$.ajax({
			type : "post",
			url : "/gw/cmm/systemx/changScDevicePopView.do",
			datatype : "json",	
			data : tblParam,
			success : function(data) {
				if(data.pinYn == 'Y' && data.failCount >= 5){
					setScAlert("PIN번호 입력 실패로 등록할 수 없습니다.</br>관리자에게 초기화 요청이 필요합니다. 관리자에게 문의하세요.", 'warning', '1');
				}else{
					//이차인증 로그인 타이머 중지후 인증기기등록 qr코드 노출
					clearInterval(tid);
					setScDeviceRegPop();
				}
			}
		});
	}
	
	function setScDeviceRegPop(){
		SetTime = 179;		
		secondCertType = "D";		
		$('.qr_view').html("");
		
		tblParam = {};
		tblParam.groupSeq = scGroupSeq;
		tblParam.empSeq = ScTargetEmpSeq;
		tblParam.type = "D";
		tblParam.devType = "1";		//devType = 1 -> 인증기기
									//devType = 2 -> 사용기기
		
		$.ajax({
			type : "post",
			url : "/gw/cmm/systemx/getQrCodeData.do",
			datatype : "json",	
			data : tblParam,
			success : function(data) {
				secondCertSeq = data.seq;
				secondCertQrData = data.qrData;
				setSecondCertPop();
			}
		});		
	}
	
	function checkResultCode(data, type){
		if(type == "L"){
			if(data.resultCode == "S"){
				clearInterval(tid);
				secondCertLogin();
			}else if(data.resultCode == "D"){
				clearInterval(tid);
				setScAlert("등록된 본인 인증기기가 아니므로 인증할 수 없습니다.</br>관리자에게 문의하세요.", 'warning', '1');
			}else if(data.resultCode == "X"){
				clearInterval(tid);
				setScAlert("유효하지 않은 QR코드 입니다.", 'warning', '1');
			}else if(data.resultCode == "F"){
				clearInterval(tid);
				setScAlert("이차인증 중 오류가 발생하였습니다.", 'warning', '1');
			}else if(data.resultCode == "H"){
				clearInterval(tid);
				setScAlert("이미 승인 대기중인 기기 입니다.", 'warning', '1');
			}else if(data.resultCode == "T"){
				clearInterval(tid);
				setScAlert("사용기기로는 이차인증 로그인이 불가합니다.", 'warning', '1');
			}
		}else{
			if(data.resultCode == "M"){
				clearInterval(tid);
				setScAlert("등록된 본인 인증기기가 아니므로 인증 할 수 없습니다.</br>관리자에게 문의하세요.", 'warning', '1');
			}else if(data.resultCode == "E"){
				clearInterval(tid);
				setScAlert("사용자 정보가 일치하지 않습니다.", 'warning', '1');
			}else if(data.resultCode == "H"){
				clearInterval(tid);
				setScAlert("등록한 인증기기가 승인 대기 중에 있습니다.</br>관리자에게 문의해주세요.", 'warning', '1');
			}else if(data.resultCode == "W"){
				clearInterval(tid);
				setScAlert("이미 사용기기로 등록된 기기는 인증기기로 변경할 수 없습니다.</br>관리자에게 인증기기 해제요청 후 변경해주세요.", 'warning', '1');
			}else if(data.resultCode == "S"){
				clearInterval(tid);
				checkDeviceId = data.uuid;
				$("#login_v3").css("display", "none");
				if(scOptionInfo.approvalYn == "Y"){
					getApprovalUserInfo();
				}else{
					setScAlert("인증기기 등록이 완료되었습니다.</br>재로그인 후 사용해주세요.", 'success', '1');
				}
				
// 				clearInterval(tid);
// 				setScAlert("인증기기 등록이 완료되었습니다.</br>재로그인 후 사용해주세요.");				
			}else if(data.resultCode == "F"){
				clearInterval(tid);
				setScAlert("이차인증 중 오류가 발생하였습니다.", 'warning', '1');
			}else if(data.resultCode == "X"){
				clearInterval(tid);
				setScAlert("유효하지 않은 QR코드 입니다.", 'warning', '1');
			}
		}
	}
	
	
	function getApprovalUserInfo(){
		tblParam = {};
    	tblParam.empSeq = ScTargetEmpSeq;
    	tblParam.groupSeq = scGroupSeq;
    	tblParam.deviceNum = checkDeviceId;
    	$.ajax({
 			type:"post",
 			url:"/gw/cmm/systemx/getApprovalUserInfo.do",
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
				var text = '인증기기에 대해 관리자 승인이 필요합니다.<br /><span class="text_blue">[ 요청자 : ' + data.empName + ', 요청한 인증기기 : ' + data.appName + ']</span><br />위 정보로 승인요청되어, 관리자에게 문의하세요.';
				setScAlert(text, 'success', '1');
 			},			
 			error : function(e){
 				alert("error");	
 			}
 		});
	}
	
	
	function secondCertLogin(){	
		
		$("#isScLogin").val("Y");
    		
		var userId0 = securityEncrypt($("#scUserId").val());
		var userId1 = "";
		var userId2 = "";
		
		if(userId0.length > 50){
			userId1 = userId0.substr(50);
			userId0 = userId0.substr(0,50);
			
    		if(userId1.length > 50){
    			userId2 = userId1.substr(50);
    			userId1 = userId1.substr(0,50);
    			
    		}    			
		}
		
		$("#userId").val(userId0);
		$("#userIdSub1").val(userId1);
		$("#userIdSub2").val(userId2);
		$("#userPw").val($("#scUserPwd").val());

		actionLogin();
	}
	
	
	
	
	function fnPop(type){
		// type : F -> 핀번호 입력오류 팝업
		// type : C -> 인증기기등록 승인요청 팝업
		// type : O -> 핀번호 입력회수 초과 팝업
		
		var w = 448;
		var h = 208;
		var left = (screen.width / 2) - (w / 2);
		var top = (screen.height / 2) - (h / 2);
		
		window.open("", "scPop", "width=" + w + ",height="+ h + ", left=" + left + ", top=" + top + "");		         
        var frmData = document.scPop ;		        
        
        $('input[name="groupSeq"]').val(ScTargetEmpSeq);
        $('input[name="empSeq"]').val(scGroupSeq);
        
		$('input[name="type"]').val(type);
		if(type == "C")
			$('input[name="deviceNum"]').val(checkDeviceId);
		
		frmData.submit();	
	}
	
	
	function setPinInput(data){
		pinType = "I";
		
		if(data.scPinInfo != ""){		
			$("#pinTitle").html("PIN번호 입력");
			$("#pinContents").html("인증기기 변경 및 사용기기를 추가하는 경우,<br />PIN번호 입력이 필요합니다.<br />비밀번호를 잃어버린 경우, 변경 및 등록 불가합니다.<br />PIN번호 입력 횟수 5회 초과 시, 관리자에게 초기화 요청해주세요.");
		}else{
			$("#pinTitle").html("PIN번호 설정");
			$("#pinContents").html("PIN번호는 최초 한번만 설정합니다.<br />인증기기 변경 및 사용기기를 추가하는 경우,<br />PIN번호 입력이 필요합니다.");
		}
		
		/*리사이즈*/
		var loginWidth = $('#login_v2').width();
		var loginHeight = $('#login_v2').height();
		$('#login_v2').css("margin-top", -loginHeight * 0.5);
		$('#login_v2').css("margin-left", -loginWidth * 0.5);

		$(window).resize(function() {
			var loginWidth = $('#login_v2').width();
			var loginHeight = $('#login_v2').height();
			$('#login_v2').css("margin-top", -loginHeight * 0.5);
			$('#login_v2').css("margin-left", -loginWidth * 0.5);
		});
		
		/*리사이즈*/
		var loginWidth = $('#login_v3').width();
		var loginHeight = $('#login_v3').height();
		$('#login_v3').css("margin-top", -loginHeight * 0.5);
		$('#login_v3').css("margin-left", -loginWidth * 0.5);

		$(window).resize(function() {
			var loginWidth = $('#login_v3').width();
			var loginHeight = $('#login_v3').height();
			$('#login_v3').css("margin-top", -loginHeight * 0.5);
			$('#login_v3').css("margin-left", -loginWidth * 0.5);
		});
		
		
		/*리사이즈*/
	    var loginWidth = $('#login_v4').width();
	    var loginHeight = $('#login_v4').height();
	    $('#login_v4').css("margin-top",-loginHeight*0.5);
	    $('#login_v4').css("margin-left",-loginWidth*0.5);
	    
	    $(window).resize(function(){
	        var loginWidth = $('#login_v4').width();
		    var loginHeight = $('#login_v4').height();
		    $('#login_v4').css("margin-top",-loginHeight*0.5);
		    $('#login_v4').css("margin-left",-loginWidth*0.5);
	    });
		
		$("#login_v4").css("display","block");
	}
	
	
	
	function nextPwd(idx, e){	
		regNumber = /^[0-9]*$/;
		  
		  
		if(regNumber.test($("#pwd_" + idx).val())) {
			if(idx < 3){
				idx++;
				$("#pwd_" + idx).focus();
			}
			pinIdx = idx;
		}else{
			$("#pwd_" + idx).val("");
		}
	}
	
	function fnClickPinNum(num){
		if(pinIdx < 0)
			pinIdx = 0;
		if(pinIdx > 3)
			pinIdx = 3;
		
		
		if($("#pwd_" + pinIdx).val() != ""){
			pinIdx++;
		}
		
		$("#pwd_" + pinIdx).val(num);
		
		if(pinIdx < 3){
			pinIdx++;
			$("#pwd_" + pinIdx).focus();
		}
	}
	
	function initPinNum(){
		$("#pwd_0").val("");
		$("#pwd_1").val("");
		$("#pwd_2").val("");
		$("#pwd_3").val("");		
		
		$("#pwd_0").focus();
		
		pinIdx = 0;
	}
	
	
	function delPinNum(){
		if($("#pwd_" + pinIdx).val() != ""){
			$("#pwd_" + pinIdx).val("");
		}else{
			$("#pwd_" + (pinIdx - 1)).val("");
			pinIdx --;
		}
		
		if(pinIdx != 0)
			pinIdx --;
		
		$("#pwd_" + pinIdx).focus();		
	}
	
	function fnClosePinPop(){
		location.href = "/gw/uat/uia/egovLoginUsr.do";
	}
	
	
	
	function fnSavePin(){
		if($("#pwd_0").val() == "" || $("#pwd_1").val() == "" || $("#pwd_2").val() == "" || $("#pwd_3").val() == ""){
			setScAlert("잘못된 PIN번호 입니다.", 'warning', '0')
		}else{		
			var pin = $("#pwd_0").val() + $("#pwd_1").val() +$("#pwd_2").val() + $("#pwd_3").val();
			
			if(pinFailCount >= 5){
				setScAlert("PIN번호 입력 횟수 초과로 등록불가합니다.<br />관리자에게 PIN번호 초기화를 요청하세요.", 'warning', '1');
				return;
			}
			
			if(pinInfo == null || pinInfo == "")
				pinType = "F";
			
			// F : 최초 인증기기 등록,   I : 핀번호입력(기기등록시)
			 if(pinType == "F"){
				savePinCode(pin);
			 }else if(pinType == "I"){
				 if(pinInfo.pin != pin){	
					 setPinFailCnt();
					 initPinNum();
				 }else{
					 setDeviceReg();
				 }
			 }
		}
	}
	
	
	
	function setDeviceReg(){
		tblParam = {};
    	tblParam.empSeq = ScTargetEmpSeq;
    	tblParam.status = scOptionInfo.approvalYn == "Y" ? "R" : "P";
    	tblParam.groupSeq = scGroupSeq;
    	tblParam.deviceNum = checkDeviceId;
    	$.ajax({
 			type:"post",
 			url:"/gw/cmm/systemx/setDeviceReg.do",
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				$("#login_v2").css("display", "none");
				$("#login_v3").css("display", "block");	
				$("#login_v4").css("display","none");
 				secondCertPopInit();
 			},			
 			error : function(e){
 				alert("error");	
 			}
 		});
	}
	
	
	function savePinCode(pin){
		tblParam = {};
    	tblParam.empSeq = ScTargetEmpSeq;
    	tblParam.groupSeq = scGroupSeq;
    	tblParam.isLoginYn = "Y";
    	tblParam.pin = pin;
    	tblParam.status = scOptionInfo.approvalYn == "Y" ? "R" : "P";
    	tblParam.deviceNum = checkDeviceId;
    	tblParam.pinType = pinType;
    	tblParam.newPin = pin;
    	$.ajax({
 			type:"post",
 			url:"/gw/cmm/systemx/savePinPassWord.do",
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
				$("#login_v2").css("display", "none");
				$("#login_v3").css("display", "block");	
				$("#login_v4").css("display","none");
 				secondCertPopInit();
 			},			
 			error : function(e){
 				alert("error");	
 			}
 		});
	}
	
	
	function setPinFailCnt(){
		tblParam = {};
    	tblParam.empSeq = ScTargetEmpSeq;
    	tblParam.groupSeq = scGroupSeq;
    	$.ajax({
 			type:"post",
 			url:"/gw/cmm/systemx/setPinFailCnt.do",
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				pinInfo = data.pinInfo;
 				pinFailCount = pinInfo.failCount; 				
 				if(pinInfo.failCount >= 5){
 					setScAlert("PIN번호 입력 횟수 초과로 등록불가합니다.<br />관리자에게 PIN번호 초기화를 요청하세요.", 'warning', '1');
 				}else{
 					setScAlert("PIN번호가 맞지않습니다.<br />다시 확인해주세요. (<span class='text_red'>비밀번호 오류횟수 " + pinFailCount + "/5</span>)", 'warning', '0');
 				}
 			},			
 			error : function(e){
 				alert("error");	
 			}
 		});
	}
	
	function btnClose() {		
		location.href = "/gw/uat/uia/egovLoginUsr.do";
	}
	
	
	var puddDialog2;
	function confirmAlert(msg){
		puddDialog2 = Pudd.puddDialog({
			 
			width : 400
		,	height : 100 + (removeDeviceCnt * 20)	 
		,	message : {
				type : "question"
			,	content : '<div class="sub_txt" style="font-size: 13px;">' + msg + '</div>'
		}
	 
		,	footer : {
		
				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm2", class : "submit" }// control 자체 객체 속성 설정
					,	value : "확인"
					,	clickCallback : function( puddDlg ) {		
							clearInterval(tid);
							setScDeviceRegPop();
							puddDlg.showDialog( false );
						}
					}
				,	{
						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnCancel2" }// control 자체 객체 속성 설정
					,	value : "취소"
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
						}
					}
				]
			}
		});
		
		$( "#btnConfirm2" ).click(function(puddDlg) {
			clearInterval(tid);
			setScDeviceRegPop();
			puddDialog2.showDialog( false );
		});	
		
		$( "#btnCancel2" ).click(function(puddDlg) {
			puddDialog2.showDialog( false );
		});	
	}
	
	
	function setScAlert(msg, type, isRedirect){
		//type -> success, warning
		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';
		
		if(isRedirect == "1"){		
			var puddDialog = Pudd.puddDialog({	
					width : 800	// 기본값 300
				,	height : 120	// 기본값 400		 
				,	message : {		 
						type : type
					,	content : titleStr
					},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : "확인"
					}
				]
			}
			});			
			$( "#btnConfirm" ).click(function() {
				location.href = "/gw/uat/uia/egovLoginUsr.do";
			});			
		}else{			
			var puddDialog = Pudd.puddDialog({	
				width : 800	// 기본값 300
			,	height : 120	// 기본값 400		 
			,	message : {		 
					type : type
				,	content : titleStr
				}	
			});
		}
	}