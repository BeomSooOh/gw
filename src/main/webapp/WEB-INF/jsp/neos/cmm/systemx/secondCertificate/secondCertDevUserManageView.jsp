<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>

	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/common.js"></script>

    <script>
	    var empSeq = "${empSeq}";
	    var scGroupSeq = "${loginVO.groupSeq}";
	    var secondCertSeq = "";
		var secondCertQrData = "";
		var tid;
		var devCnt = 0;
		var cnt = 0;
		
		var pinInfo = "";
		var scOptionInfo = "";
		
		var pinIdx = 0;	
		var pinType = "F";   // F : 최초 인증기기 등록,   C : 기존핀코드입력,    N : 새핀번호,     R : 새핀번호 확인	I : 핀번호입력(기기등록시)
		
		var newPin = "";
		var checkPin = "";
		
		var checkDeviceId = "";
		
		var pinFailCount = "";
		
		 $(document).ready(function() {
			 
			 $("#checkAll").click(function(){
		    	    $('input:checkbox').not(this).prop('checked', this.checked);
		    	});
			 
			/*리사이즈*/
		    var loginWidth = $('#login_v2').width();
		    var loginHeight = $('#login_v2').height();
		    $('#login_v2').css("margin-top",-loginHeight*0.5);
		    $('#login_v2').css("margin-left",-loginWidth*0.5);
		    
		    $(window).resize(function(){
		        var loginWidth = $('#login_v2').width();
			    var loginHeight = $('#login_v2').height();
			    $('#login_v2').css("margin-top",-loginHeight*0.5);
			    $('#login_v2').css("margin-left",-loginWidth*0.5);
		    });	    
		    
		    
		    
		  	//인증기기 설명 다이얼로그 호출
		  	var contentStr1 = '';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000035","로그인 시 이차 인증에 사용되는 모바일 기기입니다.")%></span><br />';
			contentStr1 += '<span>- <%=BizboxAMessage.getMessage("TX900000036","인증기기로 그룹웨어 앱을 사용하실 수 있습니다.")%></span><br /><br />';
			contentStr1 += '<span class="text_line"><%=BizboxAMessage.getMessage("TX900000297","※ 모바일 앱을 재설치하는 경우, 기기 등록이 필요합니다.")%></span>';
			$( "#helpDialog1" ).on( "click", function() {
				Pudd.puddDialog({
						width : 400
					,	modal : true		// 기본값 true
					,	draggable : true	// 기본값 true
					,	resize : false		// 기본값 false
					,	header : {
							title : "<%=BizboxAMessage.getMessage("TX900000298","인증 기기란?")%>"
						,	align : "left"	// left, center, right
						,	minimizeButton : false	// 기본값 false
						,	maximizeButton : false	// 기본값 false
						,	closeButton : true	// 기본값 true
					}
					,	body : {
							// dialog content 문자열
							content : contentStr1
					}
				});
			});
		    
			//사용기기 설명 다이얼로그 호출
			var contentStr2 = '';
			contentStr2 += '<span>- <%=BizboxAMessage.getMessage("TX900000038","그룹웨어 앱을 사용할 수 있는 모바일 또는 태블릿 기기입니다.")%></span><br />';
			contentStr2 += '<span>- <%=BizboxAMessage.getMessage("TX900000039","사용 기기로 등록하지 않는 경우, 그룹웨어 앱 사용이 불가합니다.")%></span><br /><br />';
			contentStr2 += '<span class="text_line"><%=BizboxAMessage.getMessage("TX900000297","※ 모바일 앱을 재설치하는 경우, 기기 등록이 필요합니다.")%></span>';
			
			$( "#helpDialog2" ).on( "click", function() {
				Pudd.puddDialog({
						width : 400
					,	modal : true		// 기본값 true
					,	draggable : true	// 기본값 true
					,	resize : false		// 기본값 false
					,	header : {
							title : "<%=BizboxAMessage.getMessage("TX900000299","사용 기기란?")%>"
						,	align : "left"	// left, center, right
						,	minimizeButton : false	// 기본값 false
						,	maximizeButton : false	// 기본값 false
						,	closeButton : true	// 기본값 true
					}
					,	body : {
							// dialog content 문자열
							content : contentStr2
					}
				});
			});
			
			
			
			var contentHtml = '<input type="text" id="desc" class="puddSetup" pudd-style="width:100%;" value="" placeholder="<%=BizboxAMessage.getMessage("TX900000300","해지 사유를 입력해주세요.")%>"/>';
			
			$( "#terminateDialog" ).on( "click", function() {
				
				var seqList = "";
		    	
		    	$('.chkbox:checked').each(function() {
		    		seqList += "," + $(this).attr("seq");   
		    	});
		    	if(seqList.length > 0){
		    		seqList = seqList.substring(1);
		    	}
		    	
		    	if(seqList == ""){
		    		setScAlert("<%=BizboxAMessage.getMessage("TX900000301","해지할 기기를 선택해 주세요.")%>", "warning", "1");
		    		return;
		    	}
				
				Pudd.puddDialog({
						width : 400					
					,	header : {
							title : "<%=BizboxAMessage.getMessage("TX900000302","해지사유")%>"
						,	align : "left"	// left, center, right						
					}
					,	body : {
							content : contentHtml
					}
					,	footer : {
				 
						buttons : [
							{
								attributes : {}// control 부모 객체 속성 설정
							,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
							,	value : "<%=BizboxAMessage.getMessage("","")%>확인"
							,	clickCallback : function( puddDlg ) {
									var tblParam = {};
									tblParam.seqList = seqList;
									tblParam.status = "C";
									tblParam.desc = $("#desc").val();
									
									$.ajax({
										type : "post",
										url : '<c:url value="/cmm/systemx/setSecondCertDevStatus.do" />',
										datatype : "text",
										data : tblParam,
										success : function(data) {
											setScAlert("<%=BizboxAMessage.getMessage("TX900000072","해지되었습니다.")%>", "success", "1");
											puddDlg.showDialog( false );
										}
									});
								}
							}
						,	{
								attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
							,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
							,	value : "취소"
							,	clickCallback : function( puddDlg ) {
									puddDlg.showDialog( false );
									// 추가적인 작업 내용이 있는 경우 이곳에서 처리
								}
							}
						]
					}
				});
			});
		    
		    
	    	gridRead();
	    	
	    	if("${range}" == "A")
	    		devCnt = "${deviceCnt}" - 1;
	    	else
	    		devCnt = "${deviceCnt}";
	    		
	    		
	    		
	    	if(("${scUseYn}" == "N" && "${scMobileUseYn}" == "N") || "${useYn}" == "N"){
	    		$("#contentsB").show();
	    	}else{
	    		$("#contentsA").show();
	    	}
		 });
		 
		 
		 function gridRead(){
		    	tblParam = {};
		    	tblParam.empSeq = empSeq;
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/selectEmpScInfo.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				pinInfo = data.pinInfo;
		 				scOptionInfo = data.scOptionInfo;
		 				setDevListTable(data.devList);
		 				
		 				pinFailCount = pinInfo.failCount;
		 				 //이차인증 APP만 사용하는 경우 PIN번호 영역 비활성처리.
		 			    if(scOptionInfo.range == "M"){
		 			    	$("#pinNum").attr('disabled',true);
		 			    }
		 			    
		 			    if(pinInfo != ""){
		 			    	$("#pinNum").val("****");
		 			    }
		 			}
		 		});
		    	
		    	
	    }
		 
		 function setDevListTable(devList){
		    	var innerHtml = '';
		    	var innerHtml2 = '';
		    	cnt = 0;
		    	
		    	for(var i=0; i<devList.length; i++){
		    		if(devList[i].type == "2"){
			    		innerHtml += '<tr>';
			    		if(devList[i].status == "C"){
			    			innerHtml += '<td></td>';
			    		}else{
			    			innerHtml += '<td><input type="checkbox" name="chk_' + devList[i].seq + '" id="chk_' + devList[i].seq + '" seq="' + devList[i].seq + '" class="chkbox status_' + devList[i].status + '"/> <label for="chk_' + devList[i].seq + '"></label></td>';
			    		}
			    		innerHtml += '<td><img src="/gw/Images/ico/ico_phone_user.png" class="mr5">' + devList[i].deviceName + '</td>';
			    		innerHtml += '<td>' + devList[i].appName + '</td>';
			    		innerHtml += '<td><input type="text" id="" class="ac" style="width:90%;" value="' + devList[i].deviceNickName + '" seq="' + devList[i].seq + '" onblur="setDevNickName(this)"/></td>';
			    		innerHtml += '<td>' + devList[i].requestDate + '</td>';
			    		if(devList[i].status == "C"){
			    			innerHtml += '<td>' + devList[i].statusMulti + '&nbsp;&nbsp;<input type="button" value="사유" onclick=fnDescPop("' + devList[i].seq + '") /></td>';
			    		}else{
			    			innerHtml += '<td class="status" status="' + devList[i].status + '">' + devList[i].statusMulti + '</td>';
			    		}
			    		innerHtml += '</tr>'
			    		if(devList[i].status != "C")
			    			cnt++;
		    		}else{
		    			innerHtml2 += '<tr>';		    			
		    			innerHtml2 += '<td><img src="/gw/Images/ico/ico_phone.png" class="mr5">' + devList[i].deviceName + '</td>';
		    			innerHtml2 += '<td>' + devList[i].appName + '</td>';
		    			innerHtml2 += '<td><input type="text" id="" class="ac" style="width:90%;" value="' + devList[i].deviceNickName + '" seq="' + devList[i].seq + '" onblur="setDevNickName(this)"/></td>';
		    			innerHtml2 += '<td>' + devList[i].requestDate + '</td>';
			    		if(devList[i].status == "C"){
			    			innerHtml2 += '<td>' + devList[i].statusMulti + '&nbsp;&nbsp;<input type="button" value="사유" onclick=fnDescPop("' + devList[i].seq + '") /></td>';
			    		}else{
			    			innerHtml2 += '<td class="status" status="' + devList[i].status + '">' + devList[i].statusMulti + '</td>';
			    		}
			    		innerHtml2 += '</tr>'
		    		}
		    	}
		    	if(innerHtml.length == 0)
		    		innerHtml = "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX900000303","등록된 사용기기가 없습니다.")%></td></tr>";
	    		if(innerHtml2.length == 0)
		    		innerHtml2 = "<tr><td colspan='5'><%=BizboxAMessage.getMessage("TX900000304","등록된 인증기기가 없습니다.")%></td></tr>";
		    		
		    	$("#devListTable").html(innerHtml);		    	
		    	$("#devTable").html(innerHtml2);
		    	$("#devCnt").html("(" + cnt + "/" + devCnt + ")");
		    }
		 
		 
		 function fnDescPop(seq){		
			var tblParam = {};
			tblParam.seq = seq				
			
			var contentHtml = "";
			
			$.ajax({
				type : "post",
				url : '<c:url value="/cmm/systemx/scDescInfo.do" />',
				datatype : "text",
				data : tblParam,
				success : function(data) {
					contentHtml = '<input type="text" id="descContent" placeholder="<%=BizboxAMessage.getMessage("TX900000066","사유를 입력하지 않았습니다.")%>" class="puddSetup" pudd-style="width:100%;" value="' + data.desc + '" readonly="readonly"/>';
					
					var puddDialog = Pudd.puddDialog({
							width : 400
						,	header : {
								title : "<%=BizboxAMessage.getMessage("TX900000067","해지사유")%>"
							,	align : "left"	// left, center, right						
						}
						,	body : {
								content : contentHtml
						}
						,	footer : {
					 
							buttons : [
								{
									attributes : {}// control 부모 객체 속성 설정
								,	controlAttributes : { id : "btnDesc", class : "submit" }// control 자체 객체 속성 설정
								,	value : "<%=BizboxAMessage.getMessage("TX000000078","확인")%>"
								,	clickCallback : function( puddDlg ) {
										puddDialog.showDialog( false );
									}
								}
							]
						}
					});
				}
			});
	 	}
		 
		 function setDevNickName(e){
		    	var deviceNickName = $(e).val();
		    	var seq = $(e).attr("seq");
		    	
		    	tblParam = {};
		    	tblParam.deviceNickName = deviceNickName;
		    	tblParam.seq = seq;
		    	
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/setDeviceNickName.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				
		 			}
		 		});
		    }
		 
		    
		    var removeDeviceCnt = 0;
			function btnChangScDevice(){
				
				if(cnt >= devCnt){
					setScAlert("<%=BizboxAMessage.getMessage("TX900000305","등록할 수 있는 사용기기 개수가 초과되어 등록할 수 없습니다.")%></br><%=BizboxAMessage.getMessage("TX900000306","관리자에게 문의하세요.")%>", "warning", "1");
					return;
				}
				
				setScDeviceRegPop();
			}
			
			
			function setScDeviceRegPop(){
				SetTime = 179;			
				$('.qr_view').html("");
				
				tblParam = {};
				tblParam.groupSeq = scGroupSeq;
				tblParam.empSeq = empSeq;
				tblParam.type = "D";
				tblParam.devType = "2";
				
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
			
			
			function setSecondCertPop() {
				qrCreate(secondCertQrData, "D");
				if(scOptionInfo.pinYn == "Y"){
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
					
					setPinInput();
				}else{
					$("#login_v3").css("display", "block");
					secondCertPopInit();
				}
			}
			
			
			function qrCreate(data, type) {
				//QR코드에 담을 정보를 넣어주세요.			
				var secondCertKey = data;
				var timestamp = new Date().getTime();
				var qrCodeUrl = window.location.protocol + "//" + window.location.host + secondCertKey + "?timestamp=" + timestamp;				
				var qrImgId = "qrImg2";
				
				var imgQrCode = '<img id="' + qrImgId + '" src="' + qrCodeUrl + '" border="0" title="QR Codes">';		

				$('#qr_view2').html($('#qr_view2').html() + imgQrCode);
				
				$("#" + qrImgId).attr("src", qrCodeUrl);
			}

			
			
			function secondCertPopInit() {
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

				tid = setInterval(function() {
					msg_time();
				}, 1000);
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
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000307","제한시간 이내에 QR코드 인증이 되지 않았습니다.")%></br><%=BizboxAMessage.getMessage("TX900000308","재시도 해 주세요.")%>", "warning", "1");
				}else{
					$("#qr_time2").html(min + ":" + sec);			
					checkSecondCertValidate();
				}
			}
			
			
			function checkSecondCertValidate(){
				tblParam = {};
				tblParam.seq = secondCertSeq;
				tblParam.type = "D";
				tblParam.groupSeq = scGroupSeq;
				
				$.ajax({
					type : "post",
					url : "/gw/cmm/systemx/checkSecondCertValidate.do",
					datatype : "json",	
					data : tblParam,
					success : function(data) {				
						checkResultCode(data, "D");
					},
					error : function(e) {
						clearInterval(tid);				
					}
				});
			}
			
			
			function checkResultCode(data, type){
				if(data.resultCode == "H"){
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000309","등록한 인증기기가 승인 대기 중에 있습니다.")%></br><%=BizboxAMessage.getMessage("TX900000306","관리자에게 문의해주세요.")%>", 'warning', '1');				
				}else if(data.resultCode == "Q"){
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000310","이미 등록된 기기 입니다.")%>", "warning", "1");
				}else if(data.resultCode == "M"){
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000311","등록된 본인 인증기기가 아니므로 인증 할 수 없습니다.")%></br><%=BizboxAMessage.getMessage("TX900000306","관리자에게 문의하세요.")%>", "warning", "1");
				}else if(data.resultCode == "S"){	
					clearInterval(tid);
					checkDeviceId = data.uuid;
					$("#login_v3").css("display", "none");
					if(scOptionInfo.approvalYn == "Y"){
						fnPop("C");
					}else{
						setScAlert("<%=BizboxAMessage.getMessage("TX900000312","사용기기 등록이 완료되었습니다.")%>", "success", "1");
					}
				}else if(data.resultCode == "F"){
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000313","이차인증 중 오류가 발생하였습니다.")%>", "warning", "1");
				}else if(data.resultCode == "X"){
					clearInterval(tid);
					setScAlert("<%=BizboxAMessage.getMessage("TX900000314","유효하지 않은 QR코드 입니다.")%>", "warning", "1");
				}
			}
			
			function btnClose(){
				clearInterval(tid);
				$("#login_v3").css("display", "none");
			}
			
			
			function setScAlert(msg, type, flag){
				//type -> success, warning
				
				var titleStr = '';		
				titleStr += '<p class="sub_txt">' + msg + '</p>';

				
				var puddDialog = Pudd.puddDialog({	
						width : 550	// 기본값 300
					,	message : {		 
							type : type
						,	content : titleStr
						},
				footer : {
					 
					buttons : [
						{
							attributes : {}// control 부모 객체 속성 설정
						,	controlAttributes : { id : "alertConfirm", class : "submit" }// control 자체 객체 속성 설정
						,	value : "<%=BizboxAMessage.getMessage("TX000000078","확인")%>"
						}
					]
				}
				});			
				$( "#alertConfirm" ).click(function() {
					if(flag == "1"){
						$("#login_v3").css("display", "none");
						puddDialog.showDialog( false );
						fnClosePinPop();
						gridRead();
					}else if(flag == "2"){
						puddDialog.showDialog( false );
					}
				});			
			
			}
			
			
			
			function pinChangePop(){		
				
				if(pinInfo == ""){
					pinType = "F";	 // F : 최초 인증기기 등록,   C : 기존핀코드입력,    N : 새핀번호,     R : 새핀번호 확인	I : 핀번호입력(기기등록시)
					$("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000315","PIN번호 설정")%>");
					$("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000316","인증기기 최초 등록시에만 설정합니다.")%><br/><%=BizboxAMessage.getMessage("TX900000317","인증기기 추가 시, PIN번호 입력이 필요합니다.")%>");		
				}else{
					pinType = "C";	 // F : 최초 인증기기 등록,   C : 기존핀코드입력,    N : 새핀번호,     R : 새핀번호 확인	I : 핀번호입력(기기등록시)
					$("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000318","기존 PIN번호 입력")%>");
					$("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000319","4자리 PIN번호를 입력하세요.")%>");
				}
				
				$("#login_v2").css("display","block");
				$("#pwd_0").focus();

			}
			
			function setPinInput(){		
				pinType = "I";  // F : 최초 인증기기 등록,   C : 기존핀코드입력,    N : 새핀번호,     R : 새핀번호 확인	I : 핀번호입력(기기등록시)	
				
				if(pinInfo == ""){			
					$("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000315","PIN번호 설정")%>");
					$("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000316","인증기기 최초 등록시에만 설정합니다.")%><br/><%=BizboxAMessage.getMessage("TX900000317","인증기기 추가 시, PIN번호 입력이 필요합니다.")%>");		
				}else{			
					$("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000320","PIN번호 입력")%>");
					$("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000321","인증기기 추가 시 PIN번호 입력이 필요합니다.")%><br /><%=BizboxAMessage.getMessage("TX900000322","비밀번호를 잃어버진 경우, 인증기기 추가 불가합니다.")%><br /><%=BizboxAMessage.getMessage("TX900000323","마이페이지 > 인증기기 관리 > 이차 인증기기 등록메뉴에서 재설정 가능합니다.")%>");
				}	
				
				$("#login_v2").css("display","block");
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
			
			function delPinNum(){
				$("#pwd_" + pinIdx).val("");
				
				if(pinIdx != 0)
					pinIdx --;
				
				$("#pwd_" + pinIdx).focus();		
			}
			
			function initPinNum(){
				$("#pwd_0").val("");
				$("#pwd_1").val("");
				$("#pwd_2").val("");
				$("#pwd_3").val("");		
				
				$("#pwd_0").focus();
				
				pinIdx = 0;
			}
			
			function fnClickPinNum(num){
				$("#pwd_" + pinIdx).val(num);
				
				if(pinIdx < 3){
					pinIdx++;
					$("#pwd_" + pinIdx).focus();
				}
			}
			
			function fnClosePinPop(){
				initPinNum();
				$("#login_v2").css("display","none");
			}
			
			function fnSavePin(){
				if($("#pwd_0").val() == "" || $("#pwd_1").val() == "" || $("#pwd_2").val() == "" || $("#pwd_3").val() == ""){
					setScAlert("<%=BizboxAMessage.getMessage("","잘못된 PIN번호 입니다.")%>", "warning", "2");
				}else{		
					var pin = $("#pwd_0").val() + $("#pwd_1").val() +$("#pwd_2").val() + $("#pwd_3").val();
					
					if(pinFailCount >= 5){						
						fnPop("O");
						return;
					}
										
					// F : 최초 인증기기 등록,   C : 기존핀코드입력,    N : 새핀번호,     R : 새핀번호 확인	I : 핀번호입력(기기등록시)
					 if(pinType == "F"){
						savePinCode(pin, "F");
					 }else if(pinType == "C"){
						 checkPin = pin;
						 if(!fnPinCheck(pin)){					 
							 setPinFailCnt();
							 initPinNum();
						 }else{
							initPinNum();
							pinType = "N";
							$("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000324","새 PIN번호 설정")%>");
							$("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000319","4자리 PIN번호를 입력하세요.")%>");
						 }
					 }else if(pinType == "N"){
						 initPinNum();
						 newPin = pin;
						 pinType = "R";
						 $("#pinTitle").html("<%=BizboxAMessage.getMessage("TX900000324","새 PIN번호 확인")%>");
						 $("#pinContents").html("<%=BizboxAMessage.getMessage("TX900000319","4자리 PIN번호를 입력하세요.")%>");
						 pinType = "R";
					 }else if(pinType == "R"){
						 if(newPin != pin){
							 setScAlert("<%=BizboxAMessage.getMessage("TX900000325","PIN번호가 일치하지 않습니다.")%>", "warning", "2");							 
							 initPinNum();
						 }else{
							 savePinCode(pin, "R");
						 }
					 }else if(pinType == "I"){
						 if(pinInfo != "" && !fnPinCheck(pin)){	
							 setPinFailCnt();
							 initPinNum();
						 }else{
							 initPinNum();
							 setDeviceReg(pin);
						 }
					 }
				}
			}
			
			
			function setDeviceReg(pin){
				tblParam = {};
		    	tblParam.empSeq = empSeq;
		    	tblParam.status = scOptionInfo.approvalYn == "Y" ? "R" : "P";
		    	tblParam.pin = pin;
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/setDeviceReg.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				$("#login_v3").css("display", "block");
		 				$("#login_v2").css("display", "none");
		 				secondCertPopInit();	 				
		 			},			
		 			error : function(e){
		 				alert("error");	
		 			}
		 		});
			}
			
			function setPinFailCnt(){
				tblParam = {};
		    	tblParam.empSeq = empSeq;
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/upatePinFailCnt.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				pinInfo = data.pinInfo;
		 				pinFailCount = pinInfo.failCount; 				
		 				if(pinInfo.failCount >= 5){
		 					fnPop("O");
		 				}else{
		 					fnPop("F");
		 				}
		 			},			
		 			error : function(e){
		 				alert("error");	
		 			}
		 		});
			}
			
			
			function fnPop(type){
				// type : F -> 핀번호 입력오류 팝업
				// type : C -> 인증기기등록 승인요청 팝업
				// type : O -> 핀번호 입력회수 초과 팝업

				var tblParam = {};
				tblParam.type = type;
				if(type == "C")
					tblParam.deviceNum = checkDeviceId;				
				
				$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/scDescInfo.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				var contents = "";
		 				var status = "";
		 				var flag = "";
		 				if(type == "F"){
		 					contents += '<span class=""><%=BizboxAMessage.getMessage("TX900000326","PIN번호가 맞지않습니다.")%><br /><%=BizboxAMessage.getMessage("TX900000327","다시 확인해주세요.")%><br /><span class="text_red"><%=BizboxAMessage.getMessage("TX900000330","비밀번호 오류횟수")%> ' + data.failCount + '/5</span></span>';
		 					status = "warning";
		 					flag = "2";
		 				}else if(type == "C"){
		 					contents += '<span class=""><%=BizboxAMessage.getMessage("TX900000328","인증기기에 대해 관리자 승인이 필요합니다.")%><br /><span class="text_blue">[ <%=BizboxAMessage.getMessage("TX000000761","요청자")%> : ' + data.empName + ', <%=BizboxAMessage.getMessage("TX900000329","요청한 인증기기 : ")%>' + data.appName + ' ]</span><br /><%=BizboxAMessage.getMessage("TX900000331","위 정보로 승인요청되어, 관리자에게 문의하세요.")%></span>';
		 					status = "success";
		 					flag = "1";
		 					
		 				}else if(type == "O"){
		 					contents += '<span class=""><%=BizboxAMessage.getMessage("TX900000332","PIN번호 입력 횟수 초과로 등록불가합니다.")%><br /><%=BizboxAMessage.getMessage("TX900000333","관리자에게 PIN번호 초기화를 요청하세요.")%></span>';
		 					status = "warning";
		 					flag = "1";
		 				}		 				
		 				setScAlert(contents, status, flag);	
		 			}
		 		});
			}
			
			
			function savePinCode(newPin, pinType){
				var tblParam = {};
		    	tblParam.empSeq = empSeq;
		    	tblParam.newPin = newPin;
		    	tblParam.oldPin = checkPin;
		    	tblParam.pinType = pinType;
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/savePinPassWord.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			success:function(data){
		 				$("pinNum").val(newPin);
		 				pinInfo.pin = newPin;
		 				setScAlert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>", "success", "1");
		 			},			
		 			error : function(e){
		 				alert("error");	
		 			}
		 		});
			}
			
			
			function fnPinCheck(pin){
				tblParam = {};
		    	tblParam.empSeq = empSeq;
		    	tblParam.groupSeq = scGroupSeq;
		    	tblParam.pin = pin;
		    	
		    	var result = false;
		    	$.ajax({
		 			type:"post",
		 			url:'<c:url value="/cmm/systemx/checkEmpPinInfo.do" />',
		 			datatype:"text",
		 			data:tblParam,
		 			async:false,
		 			success:function(data){
		 				if(data.pinInfo == null){
		 					result = false;
		 				}else{
		 					result = true;
		 				}
		 			},			
		 			error : function(e){
		 				alert("error");	
		 			}
		 		});
		    	
		    	return result;
			}
    </script>
    
</head>
<body>
<div class="work_wrap sub_contents_wrap" style="display: none;" id="contentsA">
	<div class="com_ta mt14">
		<table>
			<colgroup>
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<th><%=BizboxAMessage.getMessage("TX900000070","PIN번호")%></th>
				<td><input autocomplete="new-password" class="cen" type="password" value=""
					style="width: 200px" id="pinNum" readonly="readonly"/>
					<div class="controll_btn p0">
						<button onclick="pinChangePop();" id="btnChangePin"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
					</div></td>
			</tr>
		</table>
	</div>

	<c:if test="${range == 'A'}">
		<div class="btn_div mt20">
			<div class="left_div">
				<div class="clear">
					<p class="tit_p mb0 mt5 fl"><%=BizboxAMessage.getMessage("TX900000334","인증 기기")%></p>
					<a href="#n" class="fl mt4 ml5" id="helpDialog1"><img src="/gw/Images/ico/ico_explain.png"></a>	
				</div>
				
				<p class="text_red mt5"><%=BizboxAMessage.getMessage("TX900000335","※ 인증기기 변경은 로그인 페이지에서만 가능합니다.")%></p>
			</div>
		</div>
	
		<div class="com_ta2">
			<table>
				<colgroup>
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="" />
				</colgroup>
				<thead>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000336","인증기기명칭")%></th>
						<th><%=BizboxAMessage.getMessage("TX900000060","인증기기 Type")%></th>
						<th><%=BizboxAMessage.getMessage("TX900000337","별명")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000876","등록일자")%></th>
						<th><%=BizboxAMessage.getMessage("TX000007416","승인상태")%></th>
					</tr>
				</thead>
				<tbody id="devTable">										
				</tbody>
			</table>
		</div>
	</c:if>
	<div class="btn_div mt20">
		<div class="left_div">
			<div class="clear">
				<p class="tit_p mb0 mt5 fl"><%=BizboxAMessage.getMessage("TX900000338","사용 기기")%></p>
				<a href="#n" class="fl mt4 ml5" id="helpDialog2"><img src="/gw/Images/ico/ico_explain.png"></a>
				<span class="text_blue fl fwb mt5 ml5" id="devCnt"></span>
			</div>	
		</div>					
		<div class="right_div">
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000000446","추가")%>" onclick="btnChangScDevice();"/>
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX900000068","해지")%>" id="terminateDialog"/>
		</div>
	</div>

	<div class="com_ta2">
		<table>
			<colgroup>
				<col width="34" />
				<col width="" />
				<col width="" />
				<col width="" />
				<col width="" />
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" name="checkAll" id="checkAll" class="" /> <label for="checkAll"></label></th>
					<th><%=BizboxAMessage.getMessage("TX900000339","사용기기명칭")%></th>
					<th><%=BizboxAMessage.getMessage("TX900000340","사용기기 Type")%></th>
					<th><%=BizboxAMessage.getMessage("TX900000337","별명")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000876","등록일자")%></th>
					<th><%=BizboxAMessage.getMessage("TX000007416","승인상태")%></th>
				</tr>
			</thead>
			<tbody id="devListTable">			
			</tbody>
		</table>
	</div>
</div>

<div class="sub_contents_wrap" style="display: none;" id="contentsB">					
	<!-- index 화면 -->
	<div class="sub_index">							
		<p class="index_menu"><%=BizboxAMessage.getMessage("TX900000341","이차인증 미사용 상태이거나")%><br/>&nbsp;<%=BizboxAMessage.getMessage("TX900000342","이차인증 대상이 아닙니다.")%></p>	
	</div>
	<!-- //index 화면 -->						

</div>	
</div>


</body>


<!-- 팝업 :: 이차인증기기등록 -->
<div id="login_v3" class="secondCert device login_v2" style="margin-left: -300px; margin-top: -289px; display: none;">
	<div class="login_wrap">
		<h2 style="padding:20px 133px 15px">
			<img src="/gw/Images/ico/ico_2_mo.png" width="25px" class="fl" />
			<span class="fl" style="margin:3px 0 0 10px"><%=BizboxAMessage.getMessage("TX900000343","사용기기 등록")%></span>
		</h2>
		<p class="info_txt">
			<%=BizboxAMessage.getMessage("TX900000344","모바일 앱을 사용할 수 있도록 기기를 등록해주세요.")%><br />
			<%=BizboxAMessage.getMessage("TX900000345","아래의 코드를 읽으면 사용기기로 등록됩니다.")%>
		</p>
		<div class="qr_area">
			<div class="qr_img">
				<div id="qr_view2" class="qr_view"></div>
			</div>
			<div class="qr_time"><%=BizboxAMessage.getMessage("TX900000346","남은 시간")%> <em id="qr_time2">03:00</em></div>
		</div>
		<p class="sub_info_txt">
			<%=BizboxAMessage.getMessage("TX900000347","※ 사용기기로 등록하지 않은 경우,")%><br />
			<%=BizboxAMessage.getMessage("TX900000348","모바일 앱 설치는 가능하나, 앱을 사용하실 수 없습니다.")%>
		</p>
		<div class="btn_cen mt20">
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" style="width:140px;height:30px;" onclick="btnClose();"/>
		</div>
	</div>
</div>


<div id="login_v2" class="login_v2" style="display: none;">
	<div class="login_wrap">
		<h2 style="padding:20px 103px 15px">
			<img src="/gw/Images/ico/ico_2_login.png" width="25px" class="fl" />
			<span class="fl" style="margin:3px 0 0 10px" id="pinTitle"></span>
		</h2>
		<p class="info_txt" id="pinContents">			
		</p>
		<div class="pin_area">
			<div class="pin_input">
				<table>
					<tr>
						<td><input id="pwd_0" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(0, this)"/></td>
						<td><input id="pwd_1" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(1, this)"/></td>
						<td><input id="pwd_2" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(2, this)"/></td>
						<td><input id="pwd_3" autocomplete="new-password" type="password" class="number ac" value="" maxlength="1" onkeyup="nextPwd(3, this)"/></td>
					</tr>
				</table>
			</div>
			<div class="pin_board">
				<table>
					<tr>
						<td><input type="button" class="btn ac" value="1" onclick="fnClickPinNum(1)"/></td>
						<td><input type="button" class="btn ac" value="2" onclick="fnClickPinNum(2)"/></td>
						<td><input type="button" class="btn ac" value="3" onclick="fnClickPinNum(3)"/></td>
					</tr>
					<tr>
						<td><input type="button" class="btn ac" value="4" onclick="fnClickPinNum(4)"/></td>
						<td><input type="button" class="btn ac" value="5" onclick="fnClickPinNum(5)"/></td>
						<td><input type="button" class="btn ac" value="6" onclick="fnClickPinNum(6)"/></td>
					</tr>
					<tr>
						<td><input type="button" class="btn ac" value="7" onclick="fnClickPinNum(7)"/></td>
						<td><input type="button" class="btn ac" value="8" onclick="fnClickPinNum(8)"/></td>
						<td><input type="button" class="btn ac" value="9" onclick="fnClickPinNum(9)"/></td>
					</tr>
					<tr>
						<td><input type="button" class="btn ac" value="<%=BizboxAMessage.getMessage("TX000002960","초기화")%>" onclick="initPinNum()"/></td>
						<td><input type="button" class="btn ac" value="0" onclick="fnClickPinNum(0)"/></td>
						<td><input type="button" class="btn ac" value="Del" onclick="delPinNum();"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="btn_cen mt20">
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" style="width:135px;height:30px;" onclick="fnClosePinPop();"/>
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" style="width:135px;height:30px;" onclick="fnSavePin();"/>
		</div>
	</div>
</div>


<form id="scPop" name="scPop" method="post" action="/gw/cmm/systemx/secondCertDescPop.do" target="scPop">
  <input name="type" value="" type="hidden"/>
  <input name="deviceNum" value="" type="hidden"/>
</form>
</html>