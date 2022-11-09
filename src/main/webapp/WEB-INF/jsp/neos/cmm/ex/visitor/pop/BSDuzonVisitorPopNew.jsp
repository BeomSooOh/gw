<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<!--css-->
<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<link rel="stylesheet" type="text/css"
	href="/gw/js/Scripts/jqueryui/jquery-ui.css" />
<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">

<!--js-->
<!-- <script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.189.min.js"></script> -->
<script type="text/javascript"
	src="/gw/js/pudd/Script/pudd/pudd-1.1.189.min.js"></script>


<script type="text/javascript">
	
	var veiwData = "";
	var origin = document.location.origin;
	var formId = '${formId}';
	var approKey = "";
	var processId = "VISIT01";
	var docId = "";
	var reqNo = "";
	var docTitle = "방문객 등록";
	var docContent = "";
	
	var left = (screen.width-958)/2;
	var top = (screen.height-753)/2;
	   	
	var interlockUrl = '/gw/cmm/ex/visitor/visitorPopViewNew.do?&type=new&r_no=0';
	var interlockName = '이전단계';
	var interlockNameEn = 'previous step';
	var interlockNameJp = '以前段階';
	var interlockNameCn = '以前阶段';
	var eaType = "eap";
	var tId = ''
    
    var dateObj = new Date();
	
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth()+1;
	var day = dateObj.getDate();

	if (month < 10)
		month = "0" + month;
	if (day < 10)
		day = "0" + day;
	
	var today = year + month + day;
	
    var currentHour = dateObj.getHours() < 10 ? '0' + dateObj.getHours() : dateObj.getHours();
	var currentMin = dateObj.getMinutes() < 10 ? '0' + dateObj.getMinutes() : dateObj.getMinutes();

	var param = {}; // 알럿 callback 처리를 위한 전역변수 선언
    
    var visitorCarNo = [{ CODE: "Issue", CODE_NM: "주차권 발급" },{ CODE: "noIssue", CODE_NM: "주차권 미발급" },{ CODE: "noCar", CODE_NM: "차량 없음" }];
    var visitorCarNo2 = [{ CODE: "noIssue", CODE_NM: "주차권 미발급" },{ CODE: "noCar", CODE_NM: "차량 없음" }];

    var ddlHour = NeosCodeUtil.getCodeList("so0007"); 
    var ddlMin = NeosCodeUtil.getCodeList("so0008"); 
    
    	$(document).ready(function() {
    		
    		window.resizeTo(550, 695);
    		
    		//버튼 이벤트
    		$(function () {
                    $("#btnSave").click(function () { fnSave(); });				      //저장버튼
                    $("#btnSubmit").click(function () { fnSubmit() }); 			      //상신버튼
                    $("#btnSelectUser").click(function () { fnUserPop(); });	      //담당자 선택버튼
                    $("#btnClose").click(function () { fnClose(); });				  //닫기버튼
                    $("#btnVisitorInfoAdd").click(function () { visitorInfoAdd(); }); //추가버튼
                    $("#btnCancel").click(function() { fnClose(); }) 				  //취소버튼
                    $("#btnEdit").click(function() { fnEdit(); }) 					  //수정버튼
    		});
    		
    		/* Event 설정 */
    		$(function () {
           		
           		// 방문자 정보 - 주차권 발급 -> 전자결재 연동 프로세스 고정
           		$(document).on("change", "#parkingTk", function() {
           			
           			var parkingCheck = false; // 주차권 발급 여부 flag 
           			$('#visitorInfoList').find('input[name=parkingTk]').each(function () {
           				if($(this).val() == "Issue") {
           					Pudd( 'input[type="radio"][name="eapLinkYn"][value="Y"]' ).getPuddObject().setChecked( true );
               				
               				/* 승인 프로세스 -> 상신 버튼 노출 */
               				$("#btnSave").hide();
       	       				$("#btnSubmit").show();
       	       				
       	       				parkingCheck = true;
	           			}
           				
           				/* 주차권 발급이 있는 경우 */
           				if(parkingCheck){
           					$("#visitorInfoCarInOutTime").css('display','');
           				}
           				/* 주차권 발급이 없는 경우 */
           				else {
           					$("#visitorInfoCarInOutTime").css('display','none');
           				}
           				
           				/* 주차권 발급 여부 - 차량 없음 - 차량번호 disabled 처리 및 초기화 */
               			if($(this).val() == 'noCar') {
               				$(this).parent().parent().find('#txtVisitCarNo').attr("disabled",true);
               				$(this).parent().parent().find('#txtVisitCarNo').attr("placeholder", '');
               				$(this).parent().parent().find('#txtVisitCarNo').css("background-color", '#E6E6E6');
               				$(this).parent().parent().find('#txtVisitCarNo').val('');
                		}
               			else{
               				$(this).parent().parent().find('#txtVisitCarNo').attr("disabled", false);
               				$(this).parent().parent().find('#txtVisitCarNo').attr("placeholder", '차량번호를 입력하세요.');
               				$(this).parent().parent().find('#txtVisitCarNo').css("background-color", ''); 
               			}
           				
           			})
           		})
           		
           		/* 방문장소 - 을지타워인 경우에만 주차권 발급 노출 */
           		$(function () {
           			$(document).on("change", "#visitPlace", function(e) {
           				
           				/* 방문장소 = 을지타워인 경우 */
           				if(e.target.value === "L0"){
           					/* 추후 사용 */
           					$("input[name=parkingTk]").each(function() {
           						$(this).kendoComboBox({
           							dataSource : visitorCarNo,
               				        dataTextField: "CODE_NM",
               				        dataValueField: "CODE",
               				        index: 1
           						})
           					})
           				}
           				else {
           					$("input[name=parkingTk]").each(function() {
           						$(this).kendoComboBox({
           							dataSource : visitorCarNo2,
               				        dataTextField: "CODE_NM",
               				        dataValueField: "CODE",
               				        index: 0
           						})
           					})
           				}
           				
           				/* 주차권 발급 event trigger */
           				$("#parkingTk").trigger('change');
           				
           			})
           		})
           		
           		
           		/* 전자결재 연동 프로세스 - 버튼 노출 여부 설정(저장/상신) */
        		Pudd( 'input[type="radio"][name="eapLinkYn"]' ).on( "click", function( e ) {
        			 
        			var puddObj = Pudd( this ).getPuddObject();
        			var val = puddObj.val();
        			
        			if(val == "Y"){
        				$("#btnSave").hide();
	       				$("#btnSubmit").show();
        			}
        			else {
        				$("#btnSave").show();
	       				$("#btnSubmit").hide();
        			}
        			
        		});
    		});
    		
    		/* 하단 여백 처리 */
    		$(".pop_foot_bg").css('display','none');
    		
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
			//방문시간 DDL 공통코드 바인딩.
		    $("#ddlStartHour").kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    $("#ddlStartMin").kendoComboBox({
		        dataSource : ddlMin,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    var visitPlace = NeosCodeUtil.getCodeList("VISIT001"); 
		    $("#visitPlace").kendoComboBox({
		        dataSource : visitPlace,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        index: 0
		    });
		    
		    var visitPlaceDetail = NeosCodeUtil.getCodeList("VISIT002"); 
		    $("#visitPlaceDetail").kendoComboBox({
		        dataSource : visitPlaceDetail,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        index: 0
		    });
		   
		   if('${param.type}' == "new" && "${content}" == ""){
			   $("#parkingTk").kendoComboBox({
			        dataSource : visitorCarNo2,
			        dataTextField: "CODE_NM",
			        dataValueField: "CODE",
			        index: 0
			    }); 
		   }
		   else {
			   $("#parkingTk").kendoComboBox({
			        dataSource : visitorCarNo,
			        dataTextField: "CODE_NM",
			        dataValueField: "CODE",
			        index: 0
			    }); 
		   }
		    
		    /* 그룹사 배포 전용 */
		    /* $("#parkingTk").kendoComboBox({
		        dataSource : visitorCarNo,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        index: 0
		    }); */
		    
    		
		  	//방문 날짜
		    $("#txtVisitDt1").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	min: new Date()
		    });
		    
		    
		    $("#visitCarInTimeHour").kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    $("#visitCarInTimeMin").kendoComboBox({
		        dataSource : ddlMin,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
		    
		    $("#visitCarOutTimeHour").kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    $("#visitCarOutTimeMin").kendoComboBox({
		        dataSource : ddlMin,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
		    
		  	
		    /* 팝업 컨트롤 */
		    fnControlInit();
		});
		
    	
		var carNoCheckFlag = 0;
    	
		//저장
		function fnSave(){
			
			param = {};
			
			/* insert 구분을 위함(normal / ext)*/
			param.extYn = "N";
			
			if(timeCheck() || requireDataCheck()){
				return;
			}
			
			/* 입/출차 시간이 변경된 경우에만 중복여부 체크 */
			var visitCarInTime = $("#visitCarInTimeHour").val() + $("#visitCarInTimeMin").val();
			var visitCarOutTime = $("#visitCarOutTimeHour").val() + $("#visitCarOutTimeMin").val(); 
			
			if(prevVisitCarInTime != visitCarInTime || prevVisitCarOutTime != visitCarOutTime){
				
				//t-map 업데이트 필요
				carNoCheckFlag = 1; 
				
				/* 주차권 중복 여부 체크 */
				if(checkVisitCarNo()){
					return;
				}
				
			}
			else {
				carNoCheckFlag = 0;
			}
			
			if('${param.type}'=='edit'){
				fnVisitorUpdate();
				return;
			}
			
			/* var param = {}; */
	        var sToDt = ""; 
			var sDist = "1";

			var sFrDt = $("#txtVisitDt1").val(); // 방문날짜
			var sHour = $("#ddlStartHour").val(); // 시간
			var sMin = $("#ddlStartMin").val(); // 분
			
			param.req_no = reqNo;
	        param.man_comp_seq = $("#hidCoSeq").val();
	        param.man_emp_seq = $("#hidUserSeq").val();
	        param.man_dept_seq = $("#hidDeptSeq").val();
	        param.man_tel_num = $("#txtManUserHp").val(); //담당자 전화번호
	        
	        param.visit_aim = $("#txtVisitAim").val(); // 방문목적

	        param.elet_appv_link_yn = Pudd( 'input[type="radio"][name="eapLinkYn"][checked]' ).getPuddObject().val(); // 결재 승인 여부
	        
	        /* param.qr_send_yn = $('input[name=qrSendYn]:checked').val(); // QR 전송 여부 */
	        param.qr_send_yn = Pudd( 'input[type="radio"][name="qrSendYn"][checked]' ).getPuddObject().val(); // QR 전송 여부
	        
	        visitInfoStr = "";
	        
	        /* 방문자 정보 */
	        $('#visitorInfoList').find('tr').each( function() {
	        	var model = $(this);
	        	
	        	/* 방문자 회사인 경우 */
	        	if (model[0].sectionRowIndex % 4 == 0){
	        		visitInfoStr += model.find('input[name=txtVisitCompany]').val() + "|";	
	        	}
	        	/* 이름인 경우*/
	        	else if( model[0].sectionRowIndex % 4 == 1 ){
	        		visitInfoStr += model.find('input[name=txtVisitNM]').val() + "|";
	        	}
	        	/* 전화번호인 경우 */
	        	else if( model[0].sectionRowIndex % 4 == 2 ) {
	        		visitInfoStr += model.find('input[name=txtVisitPhone]').val() + "|";
	        	}
	        	else if( model[0].sectionRowIndex % 4 == 3 ) {
	        		visitInfoStr += model.find('input[name=txtVisitCarNo]').val() + "|";
	        		visitInfoStr += model.find('#parkingTk').val();
	        		visitInfoStr += "▦";
	        	}
	        })
	        
	        param.visitor_detail_info = visitInfoStr;
	       
	        param.visit_place_code = $("#visitPlace").val();
	        param.visit_place_sub_code = $("#visitPlaceDetail").val();
	        param.visit_place_name = $("#visitPlace").data('kendoComboBox').text();
	        
	        param.visit_dt_fr = sFrDt.replace(/-/gi, "");
	        param.visit_dt_to = sToDt.replace(/-/gi, "");
	        param.visit_tm_fr = sDist == "1" ? sHour + (sMin == "" ? "00" : sMin) : "";
	        param.visit_tm_to = "";
	        
	        param.visit_distinct = sDist;
	        param.visit_sInTime = "";
            param.visit_sOutTime = "";
            
            param.visit_car_in_time = visitCarInTime;
	        param.visit_car_out_time = visitCarOutTime; 
            
            var visit_cnt = 1;
			param.visit_cnt = visit_cnt;
			
			/* 담당자/등록자 캘린더 여부 검사 */
			checkCalendar(param);
		}
		
		/* 방문객 저장 */
		function insertVisitor(param) {
			
			if(param.extYn == "N"){
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/ex/visitor/InsertVisitorNew.do"/>',
		    		datatype:"json",
		            data: param ,
		    		success: function (result) {
		    			if(result.resultCode == "SUCCESS" || result.resultCode == "ERR000" || result.resultCode == "ERR001"){
		    				
		    				/* 일반 로직 */
		    				if("${content}" == ""){
		    					
		    					/* 전부 실패했을 경우 - 팝업창 유지 */
		    					if(result.resultCode == "ERR000"){
		    						alert(result.resultMessage);		    						
		    					}
		    					/* 성공건이 하나라도 있는 경우 */
		    					else if(result.resultCode == "ERR001"){
		    						alert(result.resultMessage);
		    						opener.fnSetSnackbar("저장 되었습니다.", "success", 1500);
			    					opener.BindGrid();
			    					self.close();
		    					}
		    					/* 전부 성공 */
		    					else {
		    						opener.fnSetSnackbar("저장 되었습니다.", "success", 1500);
			    					opener.BindGrid();
			    					self.close();
		    					}
		    				}
		    				/* 결재 - 이전단계로 넘어온 경우 opener 사용 불가로 인한 예외 처리 */
		    				else {
		    					/* 전부 실패했을 경우 OR 성공건이 하나라도 있는 경우 */
		    					if(result.resultCode == "ERR000"){
		    						alert(result.resultMessage);
		    					}
		    					else if(result.resultCode == "ERR001"){
		    						alert(result.resultMessage);
		    						self.close();
		    					}
		    					/* 전부 성공 */
		    					else {
		    						alert('저장되었습니다.');
		    						self.close();
		    					}		
		    				}
		    			}
		    			else {
		    				alert(result.resultMessage); 
		    			}
		    			
		    		} ,
	    		    error: function (result) { 
	   		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	   		    		self.close();
	  		    	}
		    	});  
			}
			else {
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/ex/visitor/InsertVisitorExt.do"/>',
		    		datatype:"json",
		            data: param ,
		    		success: function (result) {
		    				approKey = result.approKey;
		    				reqNo = result.reqNo;
		    				fnSettingEaDoc(result);
		    		    } ,
	    		    error: function (result) { 
	    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	   		    		}
		    	});	  
			}
		}
		
		/* 방문객 정보 업데이트 */
		function fnVisitorUpdate() {
			
			var sToDt = ""; 
			var sDist = "1";

			var sHour = $("#ddlStartHour").val(); // 시간
			var sMin = $("#ddlStartMin").val(); // 분
			
			var param = {};
			param.req_no = '${param.r_no}';
			param.man_comp_seq = $("#hidCoSeq").val();
		    param.man_emp_seq = $("#hidUserSeq").val();
		    param.man_dept_seq = $("#hidDeptSeq").val();
		    param.man_tel_num = $("#txtManUserHp").val(); //담당자 전화번호
		    
		    param.visitor_co = $("#txtVisitCompany").val(); // 방문회사
		    param.visit_aim = $("#txtVisitAim").val(); // 방문목적
	        param.visitor_nm = $("#txtVisitNM").val();
		    param.visit_hp = $("#txtVisitPhone").val();
		    param.visit_car_no = $("#txtVisitCarNo").val();
		    param.visit_tm_fr = sDist == "1" ? sHour + (sMin == "" ? "00" : sMin) : "";
		    param.etc = $("#txtModify").val();
			param.pTicket_yn = $("#parkingTk").val();		    
		    param.visit_dt_fr = $("#txtVisitDt1").val().replace(/-/gi, "");
			param.visit_car_in_time = $("#visitCarInTimeHour").val() + $("#visitCarInTimeMin").val();
			param.visit_car_out_time = $("#visitCarOutTimeHour").val() + $("#visitCarOutTimeMin").val();
			param.carNoCheckFlag = carNoCheckFlag;
			
		    $.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/UpdateVisitor.do"/>',
	    		datatype:"json",
	            data: param ,
	    		success: function (result) {
	    			if(result.resultCode == "SUCCESS") {
	    				/* 수정되었을 경우 QR제공 여부 */
		    			if(prevVisitorHp != $("#txtVisitPhone").val() && Pudd( 'input[type="radio"][name="qrSendYn"][checked]' ).getPuddObject().val() == "Y"){
		    				fnQRsendConfirm('${param.r_no}');
		    			}
		    			else {
		    				opener.fnSetSnackbar("등록 되었습니다.", "success", 1500);
		    				self.close();
		    			}
		    			opener.BindGrid();
	    			}
	    			else {
	    				alert(result.resultMessage);
	    			}
	    		} ,
    		    error: function (result) { 
   		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
  		    	}
	    	});  
		}
		
		var visitInfoStr = ""; // 방문자 정보 detail : String
		 
		//상신버튼
		function fnSubmit() {
			
			visitInfoStr = "";
			
			if(timeCheck() || requireDataCheck()){
				return ;
			}
			
			if(checkVisitCarNo()) {
				return;
			}
			
	        param = {};
	        param.extYn = "Y";
	        
	        var sToDt = ""; 
			var sDist = "1";

			var sFrDt = $("#txtVisitDt1").val(); // 방문날짜
			var sHour = $("#ddlStartHour").val(); // 시간
			var sMin = $("#ddlStartMin").val(); // 분
			
			param.req_no = reqNo;
	        param.man_comp_seq = $("#hidCoSeq").val(); // 담당자 회사seq
	        param.man_emp_seq = $("#hidUserSeq").val(); //담당자 사원seq
	        param.man_dept_seq = $("#hidDeptSeq").val(); //담당자 부서seq
	        param.man_tel_num = $("#txtManUserHp").val(); //담당자 전화번호
	        
	        param.visitor_co = $("#txtVisitCO").val(); // 방문회사
	        param.visit_aim = $("#txtVisitAim").val(); // 방문목적
	        
	        param.elet_appv_link_yn = Pudd( 'input[type="radio"][name="eapLinkYn"][checked]' ).getPuddObject().val(); // 결재 승인 여부
	        
	        /* qr전송여부 - etc 컬럼에 저장 */
	        param.qr_send_yn = Pudd( 'input[type="radio"][name="qrSendYn"][checked]' ).getPuddObject().val();
	        
	        /* 방문자 정보 */
	        $('#visitorInfoList').find('tr').each( function() {
	        	var model = $(this); 
	        	
	        	/* 방문자 회사인 경우 */
	        	if (model[0].sectionRowIndex % 4 == 0){
	        		visitInfoStr += model.find('input[name=txtVisitCompany]').val() + "|";	
	        	}
	        	/* 이름인 경우*/
	        	else if( model[0].sectionRowIndex % 4 == 1 ){
	        		visitInfoStr += model.find('input[name=txtVisitNM]').val() + "|";
	        	}
	        	/* 전화번호인 경우 */
	        	else if( model[0].sectionRowIndex % 4 == 2 ) {
	        		visitInfoStr += model.find('input[name=txtVisitPhone]').val() + "|";
	        	}
	        	/* 차량번호 / 주차권발급여부 */
	        	else if( model[0].sectionRowIndex % 4 == 3 ) {
	        		visitInfoStr += model.find('input[name=txtVisitCarNo]').val() + "|";
	        		visitInfoStr += model.find('#parkingTk').val();
	        		visitInfoStr += "▦";
	        	}
	        })
	        
	        param.visitor_detail_info = visitInfoStr;
	       
	        param.visit_place_code = $("#visitPlace").val();
	        param.visit_place_sub_code = $("#visitPlaceDetail").val();
	        param.visit_place_name = $("#visitPlace").data('kendoComboBox').text();
	        
	        param.visit_dt_fr = sFrDt.replace(/-/gi, "");
	        param.visit_dt_to = sToDt.replace(/-/gi, "");
	        param.visit_tm_fr = sDist == "1" ? sHour + (sMin == "" ? "00" : sMin) : "";
	        param.visit_tm_to = "";
	        
	        param.visit_distinct = sDist;
	        param.visit_sInTime = "";
            param.visit_sOutTime = "";
            
            var visit_cnt = 1;
			param.visit_cnt = visit_cnt;
			param.visit_car_in_time = $("#visitCarInTimeHour").val() + $("#visitCarInTimeMin").val();
			param.visit_car_out_time = $("#visitCarOutTimeHour").val() + $("#visitCarOutTimeMin").val();
			
			checkCalendar(param);
		}
		
		function timeCheck() {
			
			var year = dateObj.getFullYear();
			var month = dateObj.getMonth()+1;
			var day = dateObj.getDate();

			if (month < 10)
				month = "0" + month;
			if (day < 10)
				day = "0" + day;
			
			var today = year + "-" + month + "-" + day;
			
			if('${param.type}' != 'edit'){
				if( $("#txtVisitDt1").val() == today ){
					if( (currentHour + "" + currentMin) > ($("#ddlStartHour").val()+""+$("#ddlStartMin").val()) ){
						puddAlert("warning", '방문시간이 현재시간보다 작습니다.', "");
						return true;
					}
					else {
						return false;
					}	
				}
			}
			
			var visitCarInTime = $("#visitCarInTimeHour").val() + $("#visitCarInTimeMin").val();
			var visitCarOutTime = $("#visitCarOutTimeHour").val() + $("#visitCarOutTimeMin").val(); 
			
			if(visitCarInTime > visitCarOutTime) {
				puddAlert("warning", '출차시간이 입차시간보다 작습니다.', "");
				return true;
			}
		}
		
		function requireDataCheck() {
			var visitorInfoCheck = false;
			var alertCheckData = "[";
			
			if ($("#txtManUserNM").val() == "") {
	            $("#txtManUserNM").focus();
	            alertCheckData += "담당자이름,";
	            visitorInfoCheck = true;
	        }
			
			if ($("#visitPlace").val() == "선택해주세요."){
				$("#visitPlace").focus();
				alertCheckData += "방문 장소,";
				visitorInfoCheck = true;
			}
			
			/* 관리자/마스터 수정모드 - 수정사유 체크 */
			if('${loginVO.userSe}' != "USER" && '${param.type}' == 'edit'){
				if($("#txtModify").val() == ""){
					alertCheckData += '수정사유';
					visitorInfoCheck = true;
				}
			}
			
			var visitorInfoCheckData = "";
			var companyNoInput = false;
			var nameNoInput = false;
			var phoneNoInput = false;
			var carNoInput = false;
			
			/* 방문자 정보 체크 */
			$("#visitorInfoList").find('input[name=txtVisitCompany]').each( function() {
				if($(this).val() == "") {
					visitorInfoCheck = true;
					companyNoInput = true;
					return;
				}
			})
			if(companyNoInput){
				visitorInfoCheckData += '방문자 회사,';
			}
			
			$("#visitorInfoList").find('input[name=txtVisitNM]').each( function() {
				if($(this).val() == "") {
					nameNoInput = true;
					visitorInfoCheck = true;
					return;
				}
			})
			if(nameNoInput){
				visitorInfoCheckData += '이름,';
			}
			
			$("#visitorInfoList").find('input[name=txtVisitPhone]').each( function() {
				if($(this).val() == "") {
					phoneNoInput = true;
					visitorInfoCheck = true;
					return;
				}
			})
			if(phoneNoInput){
				visitorInfoCheckData += '전화번호,';
			}
			
			$("#visitorInfoList").find('tr[name=visitorInfoCarNo]').each( function() {
				if($(this).find('#parkingTk').data('kendoComboBox').value() == "Issue"){
					if($(this).find('input[name=txtVisitCarNo]').val() == ""){
						carNoInput = true;
						visitorInfoCheck = true;
						return;
					}
				}
			})
			if(carNoInput){
				visitorInfoCheckData += '차량번호,';
			}
			
			/* 방문자정보 누락 시 */
			if(visitorInfoCheckData != ""){
				visitorInfoCheckData = "방문자정보(" + visitorInfoCheckData;
				
				/* 끝에 콤마(,) 제거 */
				if(visitorInfoCheckData.substr(visitorInfoCheckData.length-1) == ','){
					visitorInfoCheckData = visitorInfoCheckData.substring(0, visitorInfoCheckData.length-1);
				}
				
				visitorInfoCheckData += ")";
			}
			
			if(alertCheckData.substr(visitorInfoCheckData.length-1) == ','){
				alertCheckData = alertCheckData.substring(0, alertCheckData.length-1);
			}
			alertCheckData += visitorInfoCheckData + "]";
			
			if(visitorInfoCheck){
				var msg = '<p>필수값이 입력되지 않았습니다.</p>' +
						'<p style="color: #2E64FE;">' + alertCheckData + '</p>';
				puddAlert("warning", msg, "");
				return true;
			}
			else {
				/* 필수값 모두 입력 */
				return false;
			}
		}
		 
		function fnSettingEaDoc(data) {
			
			var visitorList = visitInfoStr.split('▦');
			
			docContent += "<table width='100%' height='60px' border='1' align='center' cellpadding='2' cellspacing='0' style='border-collapse:collapse' >";
			docContent += "<thead>  ";
			docContent += " <tr align='center'>";   
			docContent += "  <th height='30px' bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","담당자")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","방문 일정")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","방문 장소")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","방문자 유형")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","방문 목적")%></p></td>";
			docContent += " </tr> ";
			docContent += "</thead> ";
			docContent += "<tbody> ";
			
			/* 담당자 */
			var manager = $("#txtManUserNM").val();
			
			/* 방문 일정 */
			var visitDT = $("#txtVisitDt1").val()+" "+$("#ddlStartHour").val()+":"+$("#ddlStartMin").val();
			
			/* 방문 장소 */
			var visit_place_name = $("#visitPlace").data('kendoComboBox').text();
			
			/* 방문자 유형 */
			var visit_distinct = $("#visitPlaceDetail").data('kendoComboBox').text();
			
			/* 방문 목적 */
			var visit_aim = $("#txtVisitAim").val();
			
			
			docContent += "<tr align='center'> ";
			docContent += "	<td><p align='center'>"+manager+"</p></td>";
			docContent += "	<td><p align='center'>"+visitDT+"</p></td>";
			docContent += "	<td><p align='center'>"+visit_place_name+"</p></td>";
			docContent += "	<td><p align='center'>"+visit_distinct+"</p></td>";
			docContent += "	<td><p align='center'>"+visit_aim+"</p></td>";
			docContent += "</tr> ";
			
			docContent += "</tbody> ";
			docContent += "</table>";
			
			docContent += "<p align='left'>" + "<br /><b>* 방문인원 상세</b></p>"
			docContent += "<table width='100%' height='60px' border='1' align='center' cellpadding='2' cellspacing='0' style='border-collapse:collapse' >";
			docContent += "<thead>  ";
			docContent += " <tr align='center'>";   
			docContent += "  <th height='30px' bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","방문자 회사")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","이름")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","핸드폰 번호")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","차량번호")%></p></td>";
			docContent += "  <th bgcolor='#e3e3e3'><p align='center'>" + "<%=BizboxAMessage.getMessage("","주차권 발급 여부")%></p></td>";
			docContent += " </tr> ";
			docContent += "</thead> ";
			docContent += "<tbody> ";
			
			for (var i=0; i<visitorList.length-1; i++){
				docContent += "<tr align='center'> ";
				docContent += "	<td height='30px'><p align='center'>" +visitorList[i].split('|')[0]+"</p></td>";
				docContent += "	<td><p align='center'>"+visitorList[i].split('|')[1]+"</p></td>";
				docContent += "	<td><p align='center'>"+visitorList[i].split('|')[2]+"</p></td>";
				docContent += "	<td><p align='center'>"+visitorList[i].split('|')[3]+"</p></td>";
				
				if(visitorList[i].split('|')[4] == "Issue") {
					docContent += "	<td><p align='center'>무료주차권 발급</p></td>";
				}
				else if(visitorList[i].split('|')[4] == "noIssue"){
					docContent += "	<td><p align='center'>주차권 미발급</p></td>";
				}
				else if(visitorList[i].split('|')[4] == "noCar"){
					docContent += "	<td><p align='center'>차량 없음</p></td>";
				}
				docContent += "</tr> ";
			}
			docContent += "</tbody> ";
			docContent += "</table>"
			
			$.ajax({
	            type: 'POST',
	            url: '/gw/cmm/ex/visitor/eadocmake.do',
	    		dataType:'json',
	    		data:JSON.stringify(
	   				{
						formId : formId
						, processId : processId
						, approKey : approKey
						, docId : docId
						, docTitle : docTitle
						, docContent : docContent
						, interlockUrl : interlockUrl 
						, interlockName : interlockName
						, interlockNameEn : interlockNameEn
						, interlockNameJp : interlockNameJp
						, interlockNameCn : interlockNameCn
						, origin : origin
						, eaType : eaType
						, tId : tId
	   				}
	    		),
	    		contentType:'application/json; charset=utf-8',
	    		success: function(e){
	    			var result = e.result;
	    			
					if (result.resultCode == "SUCCESS") {
						if (docId == "") {
		    				docId = result.docId;
		    			}
						updateEaDoc();
		    			
					} else {
						alert("docId <%=BizboxAMessage.getMessage("TX000016499","생성에 실패했습니다.\n관리자에게 문의하세요")%>");
						console.log(result.resultMessage);
		    			return false;
					}
	    		}
	        });
		}
		
		/* 전자결재 문서 생성 -> 방문자 테이블 update -> 전자결재 popup Open */
		function updateEaDoc () {
			$.ajax({
	            type:"post",
	            url:'/gw/cmm/ex/visitor/updateEaAttDocId.do',
	            data:JSON.stringify({approKey:approKey, processId:processId, docId:docId, reqNo:reqNo}),
	            datatype:"json",
	            contentType:'application/json; charset=utf-8',
	            success:function(e){
	            	var result = e.result;
	            	if(result){
	            		var eadocPop = window.open('','_blank','scrollbars=yes, resizable=yes, width=900, height=900');

	            		eadocPop.location.href = '/eap/ea/interface/eadocpop.do?form_id='+formId+'&processId='+processId+'&approKey='+approKey+'&docId='+docId;
	            		window.close();
	            	}else {
						alert('<%=BizboxAMessage.getMessage("TX000012938","신청이 실패되었습니다")%>.');
						location.reload();
					}
	               
	            }, error:function(e){                          
	            	alert('<%=BizboxAMessage.getMessage("TX000012938","신청이 실패되었습니다")%>.');
					location.reload();
	              }
	         });
		}

		//컨트롤 초기화
		function fnControlInit(){
			
			var r_no = '${param.r_no}';
			
			//신규등록
    		if ('${param.type}' == "new") {
                
    			$("#btnSave").show();
    		    $("#visitPlace").data("kendoComboBox").value("선택해주세요.");
            	
    		    /* 방문일시 세팅 */
				var year = dateObj.getFullYear();
				var month = dateObj.getMonth()+1;
				var day = dateObj.getDate();

				if (month < 10)
					month = "0" + month;
				if (day < 10)
					day = "0" + day;
				
				var today = year + "-" + month + "-" + day;
				
				var hour = currentHour < 10 ? '0' + dateObj.getHours() : dateObj.getHours();
				var min  = currentMin;
				
				if( min <= 10 )
					min = '10';
				else if( min > 10 && min <= 20 )
					min = '20';
				else if( min > 20 && min <= 30 )
					min = '30';
				else if( min > 30 && min <= 40 )
					min = '40';
				else if( min > 40 && min <= 50 )
					min = '50';
				else {
					if(hour < 23){
						hour++;
					}
					else {
						hour = '00';
					}
					min = '00';
				} 
				
				$("#txtVisitDt1").val(today);
				$("#ddlStartHour").data("kendoComboBox").value(hour);
				$("#ddlStartMin").data("kendoComboBox").value(min);
	
				/* 입/출차 시간 세팅 */
				$("#visitCarInTimeHour").data("kendoComboBox").value(hour);
				$("#visitCarInTimeMin").data("kendoComboBox").value(min);
				
				var endHour = Number(hour) + 1 < 10 ? '0' + Number(hour) + 1 : Number(hour) + 1;
				
				$("#visitCarOutTimeHour").data("kendoComboBox").value(endHour);
				$("#visitCarOutTimeMin").data("kendoComboBox").value(min);
				
		        $("#txtReqUserNM").val("");
		        $("#txtVisitCompany").val("");
		        $("#txtVisitNM").val("");
		        $("#txtVisitAim").val("");
		        $("#txtVisitHP").val("");
		        $("#txtVisitCarNo").val("");
				
				$("#hidCoSeq").val('${loginVO.compSeq}');
				$("#hidUserSeq").val('${loginVO.uniqId}');
				$("#hidDeptSeq").val('${loginVO.orgnztId}');
				$("#txtManUserNM").val('${loginVO.name}');
				
				/* 담당자 전화번호 세팅 */
				getManTelNum('${loginVO.uniqId}');
				
				
				//상신 - 이전단계 데이터 세팅 
	    		if("${content}" != ""){
	    			fnSettingPrevData();
	    		}
            }
    		    		
    		//상세 조회
            else {
            	//상세조회일 경우 컨트롤 수정불가하도록 처리.
            	$("#btnClose").show(); // 확인
                
    			if('${param.type}' == 'edit'){
    				
    				/* 수정모드 컨트롤 설정 */
    				visitorInfoEdit();
    				fnGetVisitor();
    			}
    			
    			// 방문객 등록(QR 인증) - 상세 조회(view 모드 - 수정불가)
    			else if('${param.type}' == 'view'){
    				
    				/* 방문 일시 세팅 */
    				var date = '${visitorInfo.visit_dt_fr}';
    				var sYear = date.substring(0,4);
    				var sMonth = date.substring(4,6);
    				var sDay = date.substring(6);
    				var VisitDt = sYear + "-" + sMonth + "-" + sDay;
    				
    				var time = '${visitorInfo.visit_tm_fr}';
    				var hour = time.substring(0,2);
    				var min = time.substring(2,4);
    				var VisitTm = hour + "시" + min + "분";
    				
    				$("#viewVisitDt").html(VisitDt +" "+ VisitTm);
    				
    				var visitCarNo = "";
    				if('${visitorInfo.visit_pticket_yn}' == "Issue"){
    					visitCarNo = '<span>주차권 발급 / ${visitorInfo.visit_car_no}</span>'
    				}
    				else if('${visitorInfo.visit_pticket_yn}' == "noIssue"){
    					visitCarNo = '<span>주차권 미발급';
    					
    					if('${visitorInfo.visit_car_no}' != '') {
    						visitCarNo += ' / ${visitorInfo.visit_car_no}</span>'
    					}
    					else {
    						visitCarNo += '</span>'
    					}
    				}
    				else{
    					visitCarNo = '<span>차량 없음</span>'
    				}
    				$("#viewVisitCarNo").html(visitCarNo);
					
    				/* 주차권 발급인 경우 입/출차 시간 세팅 */
    				if('${visitorInfo.visit_pticket_yn}' == "Issue"){
    					window.resizeTo(550,735);
    					$("#viewVisitCarInOutTimeTr").css("display", '');
    					
    					var car_in_time = '${visitorInfo.visit_car_in_time}';
        				var car_out_time = '${visitorInfo.visit_car_out_time}';
        				var car_in = car_in_time.substring(0,2)+"시 " + car_in_time.substring(2,4)+"분 ";
        				var car_out = car_out_time.substring(0,2)+"시 " + car_out_time.substring(2,4)+"분 ";
    					var car_in_out = car_in + " ~ " + car_out;
    					
    					$("#viewVisitCarInOutTime").html('<span>'+car_in_out+'</span>')
    				}
    				
    				/* 결재 승인여부 세팅 */
    				var eapLinkYn = "";
    				if('${visitorInfo.elet_appv_link_yn}' == "Y"){
    					if('${visitorInfo.req_emp_seq}' == '${loginVO.uniqId}'){
    						eapLinkYn = '<span><p>승인 / </span><span style="cursor:pointer; color:#01A9DB; text-decoration:underline;" onClick= openEapDoc(' + '${visitorInfo.elct_appv_doc_id},' +  '"${visitorInfo.elct_appv_doc_status}"' + ')>' + '${visitorInfo.docName}' + '</span></span>';	
    					}
    					else {
    						eapLinkYn = '<span>승인 / </span><span>' + '${visitorInfo.docName}' + '</span>';
    					}
    				}
    				else {
    					eapLinkYn = "미승인";
    				}
    				$("#eapLinkYn").html(eapLinkYn);
    				
    				/* QR코드 발급여부 세팅 */
    				var qrSendYn = "";
    				if('${visitorInfo.qr_data}' != ''){
    					qrSendYn = "발급";
    				}
    				else {
    					qrSendYn = "미발급";
    				}
    				$("#qrSendYn").html(qrSendYn);
    				
    				var date2 = new Date();
    				var yyyy = date2.getFullYear().toString();
    				var mm = date2.getMonth() + 1;
    				var dd = date2.getDate();
    				
    				if (mm < 10)
    				    mm = "0" + mm;
    				if (dd < 10)
    				    dd = "0" + dd;
    				
    				var today = yyyy+mm+dd;
    				
    				/* 확인 / 수정 버튼 세팅 */
    				if('${param.readOnly}' != 'true'){
	    				if('${loginVO.userSe}' == 'USER'){
	    					if('${visitorInfo.elet_appv_link_yn}' != "Y" && date >= today){
	    						$("#btnEdit").show();
	    						$("#btnClose").hide();
	    					}
	    				}
	    				else {
	    					if(date >= today) {
		    					$("#btnEdit").show();
								$("#btnClose").hide();
								
	    					}
	    				}
    				}
    			}
            }
		}
		
		function fnEdit() {
			var url = "visitorPopViewNew.do?r_no=" + '${param.r_no}' + "&type=edit";
			window.location.href = url;
		}
		
		//데이터 조회(상세 조회)
		function fnGetVisitor(){
			var param = {};
			param.nRNo = '${param.r_no}';
			param.pDist = 1;
			
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/getVisitorNew.do"/>',
	    		datatype:"json",
	            data: param ,
	    		success: function (result) {
	    				fnSetData(result);
	    		    } ,
    		    error: function (result) { 
    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
   		    		}
	    	});
		}
		
		//data 셋팅(상세조회)
		var prevVisitorHp = "";
		var prevVisitCarInTime = "";
		var prevVisitCarOutTime = "";
		
		function fnSetData(res){
			
			var sYear = res.visit_dt_fr.substring(0,4);
			var sMonth = res.visit_dt_fr.substring(4,6);
			var sDay = res.visit_dt_fr.substring(6);
			var VisitDt = sYear + "-" + sMonth + "-" + sDay;
			
			$("#hidCoSeq").val(res.man_comp_seq);
			$("#hidUserSeq").val(res.man_emp_seq);
			$("#hidDeptSeq").val(res.man_dept_seq);
			$("#txtManUserNM").val(res.man_emp_name);
			$("#txtManUserHp").val(res.man_tel_num);
			
			$("#visitPlace").data("kendoComboBox").value(res.visit_place_code);
			$("#visitPlaceDetail").data("kendoComboBox").value(res.visit_place_sub_code);
			
	        $("#txtVisitCompany").val(res.visitor_co);
	        $("#txtVisitNM").val(res.visitor_nm);
	        $("#txtVisitAim").val(res.visit_aim);
	        $("#txtVisitPhone").val(res.visit_hp);
	        prevVisitorHp = res.visit_hp;
	        
	        $("#txtVisitCarNo").val(res.visit_car_no);
	        
	        if(res.visit_pticket_yn == "Issue" || res.visit_pticket_yn == "Y"){
	        	
	        	$("#parkingTk").data("kendoComboBox").value("Issue");
	        	
				$("#visitorInfoCarInOutTime").css("display",'');
				$("#pop_con").css('height', '448');
				window.resizeTo(550,735);
				
				$("#visitCarInTimeHour").data("kendoComboBox").value(res.visit_car_in_time.substr(0, 2));
		        $("#visitCarInTimeMin").data("kendoComboBox").value(res.visit_car_in_time.substr(2, 4));
		        $("#visitCarOutTimeHour").data("kendoComboBox").value(res.visit_car_out_time.substr(0, 2));
		        $("#visitCarOutTimeMin").data("kendoComboBox").value(res.visit_car_out_time.substr(2, 4));
		        
		        prevVisitCarInTime = res.visit_car_in_time;
				prevVisitCarOutTime = res.visit_car_out_time;
				
				/* t-map API 에서 이미 만료된 주차권인 경우 변경 불가 - 이미 만료된 주차권인 경우 입/출차 disabled 처리 */
				var time = currentHour + "" + currentMin;
				if(res.visit_dt_fr == today ){
					if(res.visit_car_in_time <= time) {
						$("#visitCarInTimeHour").data("kendoComboBox").enable(false);
						$("#visitCarInTimeHour").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
						$("#visitCarInTimeMin").data("kendoComboBox").enable(false);
						$("#visitCarInTimeMin").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
					}
					if(res.visit_car_out_time <= time){
						$("#visitCarOutTimeHour").data("kendoComboBox").enable(false);
						$("#visitCarOutTimeHour").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
						$("#visitCarOutTimeMin").data("kendoComboBox").enable(false);
						$("#visitCarOutTimeMin").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
					}
				} 
				
	        }
	        else if(res.visit_pticket_yn == "noIssue" || res.visit_pticket_yn == "N"){
	        	$("#parkingTk").data("kendoComboBox").value("noIssue");
	        }
	        else {
	        	$("#parkingTk").data("kendoComboBox").value("noCar");
	        	/* 차량 없음인 경우 차량번호 disabled */
	        	$('#txtVisitCarNo').attr("disabled", true);
   				$('#txtVisitCarNo').attr("placeholder", '');
   				$('#txtVisitCarNo').css("background-color", '#E6E6E6');
   				$('#txtVisitCarNo').val('');
	        }
	        
	        $("#txtVisitDt1").val(VisitDt);
	        $("#ddlStartHour").data("kendoComboBox").value(res.visit_tm_fr.substr(0, 2));
	        $("#ddlStartMin").data("kendoComboBox").value(res.visit_tm_fr.substr(2, 4));
	        
	        if(res.elet_appv_link_yn == "Y"){
	        	/* $('input[name=eapLinkYn][value="Y"]').prop("checked",true); */
	        	Pudd( 'input[type="radio"][name="eapLinkYn"][value="Y"]' ).getPuddObject().setChecked( true );	
	        }
	        else{
	        	/* $('input[name=eapLinkYn][value="N"]').prop("checked",true); */
	        	Pudd( 'input[type="radio"][name="eapLinkYn"][value="N"]' ).getPuddObject().setChecked( true );
	        }
	        
	        if(res.qr_data == "") {
	        	Pudd( 'input[type="radio"][name="qrSendYn"][value="N"]' ).getPuddObject().setChecked( true );	
	        	/* $('input[name=qrSendYn][value="N"]').prop("checked",true) */
	        }
	        else {
	        	/* $('input[name=qrSendYn][value="Y"]').prop("checked",true) */
	        	Pudd( 'input[type="radio"][name="qrSendYn"][value="Y"]' ).getPuddObject().setChecked( true );
	        }
	        
	        $("#txtModify").val(res.modify_reason); // 수정 사유
	        
		}
		
		/* 상세 조회 - 컨트롤 설정 */
		function visitorInfoEdit() {

			/* 수정 버튼 클릭 시 일부 컨트롤 제어 가능 */
        	$("#btnSelectUser").show();
			$("#visitPlace").data("kendoComboBox").enable(false);
			$("#visitPlaceDetail").data("kendoComboBox").enable(false);
			$("#btnVisitorInfo").hide();
			$("#txtVisitCompany").css('width', '95%');
			$("#parkingTk").data("kendoComboBox").enable(false);
			$("#txtVisitDt1").data("kendoDatePicker").enable(false);
 
			$('input[name=eapLinkYn]').attr("disabled", true);
			$('input[name=qrSendYn]').attr("disabled", true);
			$("#txtVisitCarNo").attr('disabled',true);
			
			/* disabled 색상 처리 */
			$("#visitPlace").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
			$("#visitPlaceDetail").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
			$("#txtVisitDt1").data("kendoDatePicker").wrapper.find(".k-input").css("background", "#D8D8D8");
			$("#parkingTk").data("kendoComboBox").wrapper.find(".k-input").css("background", "#D8D8D8");
			$("#txtVisitCarNo").css('background', "#E6E6E6");
			
			/* 수정 사유 추가 */
			if('${loginVO.userSe}' != 'USER'){
				var html = "";
				html =	'<tr id="">' +
							'<th colspan="2"><img src="../../../Images/ico/ico_check01.png" alt="" />  수정 사유</th>' + 
							'<td class="icon01">' + 
								'<input type="text" id="txtModify" name="txtModify" placeholder="수정 사유" style="width:330px;"/>' +
							'</td>' +
						'</tr>';
				
				$("#visitorCommonData2").append(html);
				window.resizeTo(550, 735);
			}
			
            $("#btnClose").hide();
            $("#btnSave").show();
		}
		
		//담당자 선택팝업
		function fnUserPop () {

			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
			frmPop.submit();
			pop.focus(); 
	     }
	
		//담당자 선택팝업 콜백함수
		function callbackSel(data) {
			if(data.returnObj[0].empSeq != null){
		   		$("#txtManUserNM").val(data.returnObj[0].empName);
		   		$("#hidCoSeq").val(data.returnObj[0].compSeq);
		   		$("#hidUserSeq").val(data.returnObj[0].empSeq);
		   		$("#hidDeptSeq").val(data.returnObj[0].deptSeq);
			}
			
			var data = data.returnObj[0].empSeq;
			getManTelNum(data);
	    }   
		
		function getManTelNum(data) {
			$.ajax({
		    	type:"post",
				url:'<c:url value="/cmm/ex/visitor/getEmpTelNum.do" />',
				datatype:"text",
				data: { manEmpSeq : data } ,
				success:function(data){
					if(data.resultCode == "SUCCESS"){
						$("#txtManUserHp").val(data.result);
					}
					else {
						alert('담당자 전화번호를 불러오는 중 에러 발생');
					}
				},error : function(data){
					alert('담당자 전화번호를 불러오는 중 에러 발생');
				}
	    	});
		}
	
		function openEapDoc (docId, status) {
	    	
	    	var intWidth = 900;
	        var intHeight = screen.height - 100;
	        var agt = navigator.userAgent.toLowerCase();
	        if (agt.indexOf("safari") != -1) {
	            intHeight = intHeight - 70;
	        }
	        var intLeft = screen.width / 2 - intWidth / 2;
	        var intTop = screen.height / 2 - intHeight / 2 - 40;
	        if (agt.indexOf("safari") != -1) {
	            intTop = intTop - 30;
	        }
			
	        var paramUrl = "?doc_id=" + docId + "&form_id=" + '${formId}';
	        var url = "";
		    
	        if(status != "보관"){
				url = '/eap/ea/docpop/EAAppDocViewPop.do' + paramUrl;
	        }
	        else {
	        	url = '/eap/ea/eadocpop/EAAppDocPop.do' + paramUrl;        		
	        }
	    				
			window.open(url, '방문객등록 전자결재 팝업', 'menubar=0,resizable=0,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
	    }
		
		//닫기버튼
		function fnClose(){
			self.close();
		}
		
		
		var visitorInfo_last_index = 1;
		var visitorInfo_length = 1;
		var visitorInfo_arr = [0];
		
		// 방문자 정보 추가
		function visitorInfoAdd(){
			
			var headRowSpan = $("#visitorRowHead" + visitorInfo_arr[0]).attr("rowspan");
			$("#visitorRowHead" + visitorInfo_arr[0]).attr("rowspan", parseInt(headRowSpan) + 4);
				
				var html =	'<tr id="visitorInfoCompany' + visitorInfo_last_index + '">' +
								'<th id="visitorRowHead' + visitorInfo_last_index + '" rowspan="4" colspan="1" style="text-align:right; display:none;"><img src="../../../Images/ico/ico_check01.png" alt="" />방문자<br />정보</th>' +
								'<th colspan="1">회사</th>' +
								'<td colspan="1" class="icon01">' +
									'<input type="text" id="txtVisitCompany" name="txtVisitCompany" placeholder="회사를 입력하세요." style="width: 80%;"/> ' +
									'<div id="btnVisitorInfo" class="controll_btn p0" name="btnVisitorInfo">' +
										'<div class="PUDD PUDD-COLOR-blue PUDD-UI-Button">' +
											'<input type="button" name="btnVisitorInfoDelete" onClick="visitorInfoDelete(' + visitorInfo_last_index + ')" pudd-style style="width:24px; height:24px; background:url(\'/gw/Images/btn/btn_minus01.png\') no-repeat center" /> ' +
										'</div> ' + 
										'<div class="PUDD PUDD-COLOR-blue PUDD-UI-Button">' +
											'<input id="btnVisitorInfoAdd" onClick="visitorInfoAdd()" type="button" pudd-style style="width:24px; height:24px; background:url(\'/gw/Images/btn/btn_plus01.png\') no-repeat center" />' +
										'</div>' +
									'</div>' + 
								'</td>' +
							'</tr>' +
							'<tr id="visitorInfoName' + visitorInfo_last_index + '">' + 
								'<th colspan="1">이름</th>' + 
								'<td colspan="1" class="icon01">' + 
									'<input type="text" id="txtVisitNM" name="txtVisitNM" placeholder="이름을 입력하세요." style="width: 95%"/>  ' + 
								'</td>' +
							'</tr>' +
							'<tr id="visitorInfoPhone' + visitorInfo_last_index + '">' + 
								'<th colspan="1">전화번호</th>' +
								'<td colspan="1" class="icon01">' +
									'<input type="text" id="txtVisitPhone" name="txtVisitPhone" placeholder="핸드폰 번호를 입력하세요." style="width: 95%" onKeyup="this.value=this.value.replace(/[^0-9]/g,\'\');"/>' +
								'</td>' +
							'</tr>' +
							'<tr id="visitorInfoCarNo' + visitorInfo_last_index + '" name="visitorInfoCarNo">' + 
								'<th colspan="1">차량번호</th>' + 
								'<td colspan="1" class="icon01">' +
									'<input id="parkingTk" name="parkingTk" class="kendoComboBox" style="width:45%"/> ' + 
									'<input type="text" id="txtVisitCarNo" name="txtVisitCarNo" placeholder="차량번호를 입력하세요." style="width: 49%"/>' + 
								'</td>' + 
							'</tr>';
							/* +
							'<tr id="visitorInfoCarInOutTime'+ visitorInfo_last_index + '" name="visitorInfoCarInOutTime" style="display:none">' + 
								'<th colspan="1">입/출차 시간</th>' + 
								'<td class="icon01">' +
									'<input id="visitCarInTimeHour' + visitorInfo_last_index + '" name="visitCarInTimeHour" class="kendoComboBox" style="width:18%;"/> 시 ' + 
									'<input id="visitCarInTimeMin' + visitorInfo_last_index + '" name="visitCarInTimeMin" class="kendoComboBox" style="width:18%;"/> 분 ' + 
									' ~ ' + 
									'<input id="visitCarOutTimeHour' + visitorInfo_last_index + '" name="visitCarOutTimeHour" class="kendoComboBox" style="width:18%;"/> 시 ' + 
									'<input id="visitCarOutTimeMin' + visitorInfo_last_index + '" name="visitCarOutTimeMin" class="kendoComboBox" style="width:18%;"/> 분 ' + 
								'</td>' +
					    	'</tr>'; */
							
			$("#visitorInfoList").append(html);
	
			/* kendo ComboBox 동적 추가 시 적용 */
			/* 추후 사용 */
			var parkingTkObj = $('#visitorInfoCarNo'+visitorInfo_last_index).children().children('#parkingTk');
			parkingTkObj.kendoComboBox({
		        dataSource : $("#visitPlace").data("kendoComboBox").text() == "을지타워" ? visitorCarNo : visitorCarNo2,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        index: $("#visitPlace").data("kendoComboBox").text() == "을지타워" ? 1 : 0
		    });
			
		    /* 그룹사 배포 전용 */
			/* var parkingTkObj = $('#visitorInfoCarNo'+visitorInfo_last_index).children().children('#parkingTk');
			parkingTkObj.kendoComboBox({
		        dataSource : visitorCarNo,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE",
		        index: 0
		    });
			*/

			/* $("#visitCarInTimeHour"+visitorInfo_last_index).kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    $("#visitCarInTimeMin"+visitorInfo_last_index).kendoComboBox({
		        dataSource : ddlMin,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
		    
		    $("#visitCarOutTimeHour"+visitorInfo_last_index).kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    });
			
		    $("#visitCarOutTimeMin"+visitorInfo_last_index).kendoComboBox({
		        dataSource : ddlMin,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        index: 0
		    }); */
			
		    /* $("#visitCarInTimeHour"+visitorInfo_last_index).data("kendoComboBox").value(visitHour);
		    $("#visitCarInTimeMin"+visitorInfo_last_index).data("kendoComboBox").value(visitMin);
		    
		    var endHour = Number(visitHour) + 1 < 10 ? '0' + Number(visitHour) + 1 : Number(visitHour) + 1;
		    
		    $("#visitCarOutTimeHour"+visitorInfo_last_index).data("kendoComboBox").value(endHour);
		    $("#visitCarOutTimeMin"+visitorInfo_last_index).data("kendoComboBox").value(visitMin); */
		    
			visitorInfo_arr.push(visitorInfo_last_index);
			visitorInfo_last_index++;
			visitorInfo_length++;
			$('input[name="btnVisitorInfoDelete"]').attr('disabled', false);
		}
		
		// 방문자 정보 삭제
		function visitorInfoDelete(index){
			
			var headRowSpan = $("#visitorRowHead" + visitorInfo_arr[0]).attr("rowspan");
			$("#visitorRowHead" + visitorInfo_arr[0]).attr("rowspan", parseInt(headRowSpan) - 4);
			var prevRowSpan = parseInt(headRowSpan) - 4;
			
			$("#visitorInfoCompany"+index).remove();
			$("#visitorInfoName"+index).remove();
			$("#visitorInfoPhone"+index).remove();
			$("#visitorInfoCarNo"+index).remove();
			/* $("#visitorInfoCarInOutTime"+index).remove(); */
			
			/* 첫번째 요소 삭제 시 rowHead 변경*/
			if(index == visitorInfo_arr[0]) {
				visitorInfo_arr.shift();
				$("#visitorRowHead" + visitorInfo_arr[0]).css('display', '');
				$("#visitorRowHead" + visitorInfo_arr[0]).attr('rowspan', prevRowSpan);
			}
			else {
				visitorInfo_arr.splice(visitorInfo_arr.indexOf( index ), 1);
			}
			
			visitorInfo_length--;
			if(visitorInfo_length == 1){
				$('input[name="btnVisitorInfoDelete"]').attr('disabled', true);
			}
			
			/* 방문자 정보 삭제 - 주차권 발급여부 재체크 */
			var parkingCheck = false;
			$('#visitorInfoList').find('input[name=parkingTk]').each(function () {
				if($(this).val() == "Issue") {
	       			parkingCheck = true;
       			}
   				
   				/* 주차권 발급이 있는 경우 */
   				if(parkingCheck){
   					$("#visitorInfoCarInOutTime").css('display','');
   				}
   				/* 주차권 발급이 없는 경우 */
   				else {
   					$("#visitorInfoCarInOutTime").css('display','none');
   				}
			})
		}
		
		/* 상신 -> 이전단계 데이터 세팅 */
		function fnSettingPrevData() {
			
			reqNo = '${content.reqNo}';
			
			/* 담당자 */
			$('#txtManUserNM').val('${content.emp_name}');
			$("#hidCoSeq").val('${content.man_comp_seq}');
	        $("#hidUserSeq").val('${content.man_emp_seq}');
	        $("#hidDeptSeq").val('${content.man_dept_seq}');
	        
	        /* 방문 장소 */ 
	        var model = $("#visitPlace").data("kendoComboBox");
	        $("#visitPlace").data("kendoComboBox").value('${content.visit_place_code}');
			$("#visitPlaceDetail").data("kendoComboBox").value('${content.visit_place_sub_code}');
			
			/* 방문자 회사 */
			$('#txtVisitCompany').val('${content.visitor_co}');
			
			/* 방문 목적 */
			$('#txtVisitAim').val('${content.visit_aim}');
			
			/* 방문자 정보 */
			var visitorInfo = '${content.visitor_detail_info}';
			var visitorInfoList = visitorInfo.substr(0, visitorInfo.length-1).split('▦');
			
			for(var i=0; i<visitorInfoList.length-1; i++){
				visitorInfoAdd();
			}
	        
	        var i = 0;
	        $('#visitorInfoList').find('tr').each( function() {
	        	var txtVisitCompany = visitorInfoList[i].split('|')[0];
	        	var txtVisitNm = visitorInfoList[i].split('|')[1];
	        	var txtVisitPhone = visitorInfoList[i].split('|')[2];
	        	var txtVisitCarNo = visitorInfoList[i].split('|')[3];
	        	var parkingTk = visitorInfoList[i].split('|')[4];
	        	
	        	var model = $(this); 
	        	
	        	/* 방문자 회사인 경우 */
	        	if ( model[0].sectionRowIndex % 4 == 0){
	        		model.find('input[name=txtVisitCompany]').val(txtVisitCompany);	
	        	}
	        	/* 이름인 경우 */
	        	else if( model[0].sectionRowIndex % 4 == 1 ){
	        		model.find('input[name=txtVisitNM]').val(txtVisitNm);
	        	}
	        	/* 전화번호인 경우 */
	        	else if( model[0].sectionRowIndex % 4 == 2 ) {
	        		model.find('input[name=txtVisitPhone]').val(txtVisitPhone);
	        	}
	        	/* 주차권발급여부/차량번호인 경우 */
	        	else if( model[0].sectionRowIndex % 4 == 3 ) {
	        		model.find('input[name=txtVisitCarNo]').val(txtVisitCarNo);
	        		model.find('#parkingTk').data("kendoComboBox").value(parkingTk);
	        		
	        		/* 차량 없음인 경우 차량번호 disabled 처리 */
	        		if(parkingTk == "noCar"){
	        			model.find('input[name=txtVisitCarNo]').attr("disabled", true);
	        			model.find('input[name=txtVisitCarNo]').attr("placeholder", '');
	        			model.find('input[name=txtVisitCarNo]').css("background-color", '#D8D8D8');
	        			model.find('input[name=txtVisitCarNo]').val('');
	        		}
	        		i++;
	        	}
	        })
			
	        /* 상신 - 이전단계인 경우 반드시 결재 승인 + 상신버튼 노출 */
	        $('input[type="radio"][name="eapLinkYn"][value="Y"]').attr('checked', true);
			$('input[type="radio"][name="eapLinkYn"][value="N"]').attr('checked', false);
			$("#btnSubmit").show();
			$("#btnSave").hide();
	        
			/* 방문 시간 */
			var sYear = '${content.visit_dt_fr}'.substring(0,4);
			var sMonth = '${content.visit_dt_fr}'.substring(4,6);
			var sDay = '${content.visit_dt_fr}'.substring(6);
			var VisitDt = sYear + "-" + sMonth + "-" + sDay;
			$('#txtVisitDt1').val(VisitDt);
			
			$("#ddlStartHour").data("kendoComboBox").value('${content.visit_tm_fr}'.substring(0, 2));
	        $("#ddlStartMin").data("kendoComboBox").value('${content.visit_tm_fr}'.substring(2, 4));
			
	        /* 방문자 정보 삭제 - 주차권 발급여부 재체크 */
			var parkingCheck = false;
			$('#visitorInfoList').find('input[name=parkingTk]').each(function () {
				if($(this).val() == "Issue") {
	       			parkingCheck = true;
       			}
   				
   				/* 주차권 발급이 있는 경우 */
   				if(parkingCheck){
   					$("#visitorInfoCarInOutTime").css('display','');
   				}
   				/* 주차권 발급이 없는 경우 */
   				else {
   					$("#visitorInfoCarInOutTime").css('display','none');
   				}
			})
			
	        $("#visitCarInTimeHour").data("kendoComboBox").value('${content.visit_car_in_time}'.substr(0, 2));
	        $("#visitCarInTimeMin").data("kendoComboBox").value('${content.visit_car_in_time}'.substr(2, 4));
	        $("#visitCarOutTimeHour").data("kendoComboBox").value('${content.visit_car_out_time}'.substr(0, 2));
	        $("#visitCarOutTimeMin").data("kendoComboBox").value('${content.visit_car_out_time}'.substr(2, 4));

		}
		
		/* 담당자 / 등록자 개인캘린더 여부 체크 */
		function checkCalendar(param) {
			param.req_comp_seq = '${loginVO.compSeq}';
			param.req_emp_seq = '${loginVO.uniqId}';
			param.req_dept_seq = '${loginVO.orgnztId}';
				
			/* 일정 등록자(담당자/등록자/등록X) */
			var calCheck = "man";
			
			$.ajax({
		    	type:"post",
				url:'<c:url value="/cmm/ex/visitor/checkCalendar.do" />',
				datatype:"text",
				data: param,
				success:function(data){
					param.mcalSeq = data.mcalSeq;
					if(data.resultCode == "no"){
						calCheck = "no";
						param.calCheck = calCheck;
						puddAlert("warning", "담당자/등록자의 개인 캘린더가 존재하지 않아, 일정은 등록되지 않습니다.", "insertVisitor(param)");
					}
					else if(data.resultCode == "req"){
						calCheck = "req";
						param.calCheck = calCheck;
						puddAlert("warning", "담당자의 개인 캘린더가 존재하지 않아, 등록자의 개인캘린더에 등록됩니다.", "insertVisitor(param)");
					}
					else if(data.resultCode == "FAIL") {
						calCheck = "no";
						param.calCheck = calCheck;
						alert('담당자/등록자 캘린더 여부 검사 중 오류가 발생했습니다.');
					}
					else {
						param.calCheck = calCheck;
						insertVisitor(param);
					}
					
				},error : function(data){
					alert('담당자/등록자 캘린더 여부 검사 중 오류가 발생했습니다.');
				}
	    	});
		}
		
		/* 방문자 차량번호 중복여부 체크(t-map 연동)*/
		function checkVisitCarNo() {
			
			var flag = false;
			var param = {};
			
			visitCarNoStr = "";
	        
	        /* 방문자 정보 */
	        $('#visitorInfoList').find('tr').each( function() {
	        	var model = $(this);
	        	var parkingTk = "";
	        	if( model[0].sectionRowIndex % 4 == 1) {
	        		
	        	}
	        	if( model[0].sectionRowIndex % 4 == 3 ) {
	        		visitCarNoStr += model.find('input[name=txtVisitCarNo]').val() + "|";
	        		visitCarNoStr += model.find('#parkingTk').val();
	        		parkingTk = model.find('#parkingTk').val();
	        		visitCarNoStr += "▦";
	        	}
	        })
	        
	        
	        param.visitCarNoStr = visitCarNoStr;
	        param.visitDt = $("#txtVisitDt1").val().replace(/-/gi, "");
	        param.manCompSeq = $("#hidCoSeq").val();
	        param.visitCarInTime = $("#visitCarInTimeHour").val() + $("#visitCarInTimeMin").val();
	        param.visitCarOutTime = $("#visitCarOutTimeHour").val() + $("#visitCarOutTimeMin").val(); 
			param.updateYn = '${param.type}'=='edit' ? "Y" : "N";
	        param.rNo = '${param.r_no}' == "0" ? '' : '${param.r_no}';
			
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/checkVisitCarNo.do"/>',
	    		datatype:"json",
	            data: param,
	            async: false,
	    		success: function (result) {
	    			if(result.resultCode != "SUCCESS"){
						alert(result.resultMessage);
						flag = true;
	    			}
	    		},
    		    error: function (result) { 
   		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>");
   		    		flag = true;
  		    	}
	    	});  
			
			return flag;
		}
		
		
		function puddAlert(type, alertMsg, callback){
	 		var puddDialog = Pudd.puddDialog({
	 			width : "300"
	 		,	height : "100"
	 		,	message : {
	 				type : type
	 			,	content : alertMsg.replace(/\n/g, "<br>")
	 			}
	 		,	footer : {
	 		
	 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
	 				buttons : [
	 					{
	 						attributes : {}// control 부모 객체 속성 설정
	 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
	 					,	value : "확인"
	 					,	clickCallback : function( puddDlg ) {
	 							puddDlg.showDialog( false );
	 							eval(callback);
	 						}
	 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
	 					,	defaultFocus :  true// 기본값 true
	 					}
	 				]
	 			}	
	 		
	 		});		
		}
		
		/* QR재발송 confirm */
		function fnQRsendConfirm(r_no) {
			
			var puddDialog = Pudd.puddDialog({
				width : 350
				,	height : 100
			 
				,	message : {
						type : "question"
					,	content : "방문자 전화번호가 변경되었습니다.<br />QR코드를 재발송 하시겠습니까?"
						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
					//,	defaultFocus :  true// 기본값 true
					}
			
			,	footer : {
					// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
					buttons : [
						{
							attributes : {}// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
						,	value : "확인"
						,	clickCallback : function( puddDlg ) {
								/* QR전송 API */
								$.ajax({
							    	type:"post",
									url:'<c:url value="/cmm/ex/visitor/ReSendMMS.do" />',
									datatype:"text",
									data: { r_no : r_no } ,
									success:function(data){
										if(data.result.resultCode == "SUCCESS"){
											opener.fnSetSnackbar("재발송 되었습니다.", "success", 1500);
											puddDlg.showDialog( false );
											self.close();
										}
										else {
											alert('QR코드 재발송 도중 에러가 발생하였습니다.');
										}
									},error : function(data){
										alert('QR코드 재발송 도중 에러가 발생하였습니다.');
									}
						   		});
							}
							// dialog 생성시에 확인 버튼으로 기본 포커스 설정
						,	defaultFocus :  true// 기본값 true
						}
						
					,	{
							attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
						,	value : "취소"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								self.close();
							}
						}
					]
				}
			})
		}
		
    </script>


<div class="pop_wrap" style="border: none;">
	<!-- HiddenField -->
	<input type="hidden" id="hidCoSeq" name="hidCoSeq" /> <input
		type="hidden" id="hidUserSeq" name="hidUserSeq" /> <input
		type="hidden" id="hidDeptSeq" name="hidDeptSeq" />

	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000010110", "일반방문객")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div
		style="height: 80px; text-align: left; margin-left: 10px; margin-right: 20px; margin-top: 10px; border: 1px solid #c3c3c3; padding: 15px 0px 0px 15px;">
		<div style="margin-top: 3px;">
			<b>[방문객 등록 유의사항]</b> <br />
			<p>- 방문객 등록 후 등록자는 일부 정보만 수정 가능합니다.</p>
			<p>- '결재 승인'을 통한 방문객 등록 정보는 관리자만 수정이 가능합니다.</p>
			<span style="color: red;">- QR코드 발급은 등록된 방문자에게만 발송됩니다.</span>
		</div>
	</div>

	<c:if test="${param.type == 'edit' || param.type == 'new'}">
		<div id="pop_con" class="pop_con"
			style="overflow-y:auto; 
				height:
					<c:choose>
						<c:when test="${param.type == 'new' }">408px;">
			</c:when>
			<c:otherwise>
				<c:if test="${loginVO.userSe == 'USER' }">408px;"></c:if>
				<c:if test="${loginVO.userSe != 'USER' }">448px;"></c:if>
			</c:otherwise>
			</c:choose>
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="14%" />
						<col width="16%" />
						<col wdith="70%" />
					</colgroup>

					<tr id="">
						<th rowspan="2" colspan="1"><%=BizboxAMessage.getMessage("TX000000329", "담당자")%></th>
						<th colspan="1"><img
							src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("", "이름")%></th>
						<td class="icon01"><input type="text" id="txtManUserNM"
							name="txtManUserNM" placeholder="담당자 이름을 입력하세요."
							style="width: 80%;" readonly="readonly" />
							<div id="" class="controll_btn p0">
								<button type="button" id="btnSelectUser"><%=BizboxAMessage.getMessage("TX000000265", "선택")%></button>
							</div></td>
					</tr>
					<tr id="">
						<th colspan="1"><%=BizboxAMessage.getMessage("", "전화번호")%></th>
						<td class="icon01"><input type="text" id="txtManUserHp"
							name="txtManUserHp" placeholder="담당자 전화번호를 입력하세요."
							style="width: 95%;" /></td>
					</tr>
					<tr id="">
						<th colspan="2"><img
							src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("", "방문 장소 / 유형")%></th>
						<td class="icon01"><input id="visitPlace"
							class="kendoComboBox" style="width: 60%" /> <input
							id="visitPlaceDetail" class="kendoComboBox" style="width: 35%" />
						</td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "방문 일시")%></th>
						<td class="icon01" id="viewVisitDt"><input id="txtVisitDt1"
							class="dpWid" style="width: 35%;" /> <input id="ddlStartHour"
							class="kendoComboBox" style="width: 24%;" /> <%=BizboxAMessage.getMessage("TX000001228", "시")%>
							<input id="ddlStartMin" class="kendoComboBox" style="width: 24%;" />
							<%=BizboxAMessage.getMessage("TX000001229", "분")%></td>
					</tr>


					<tbody id="visitorInfoList" name="visitorInfo">
						<tr id="visitorInfoCompany0">
							<th id="visitorRowHead0" rowspan="4" colspan="1"
								style="text-align: right;"><img
								src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("", "방문자<br />정보")%></th>
							<th colspan="1"><%=BizboxAMessage.getMessage("", "회사")%></th>
							<td colspan="1" class="icon01"><input type="text"
								id="txtVisitCompany" name="txtVisitCompany"
								placeholder="회사를 입력하세요." style="width: 80%;" />
								<div id="btnVisitorInfo" class="controll_btn p0"
									name="btnVisitorInfo">
									<div class="PUDD PUDD-COLOR-blue PUDD-UI-Button">
										<input type="button" onClick="visitorInfoDelete(0)"
											name="btnVisitorInfoDelete" pudd-style
											style="width: 24px; height: 24px; background: url('/gw/Images/btn/btn_minus01.png') no-repeat center"
											disabled />
									</div>
									<div class="PUDD PUDD-COLOR-blue PUDD-UI-Button">
										<input id="btnVisitorInfoAdd" type="button" pudd-style
											style="width: 24px; height: 24px; background: url('/gw/Images/btn/btn_plus01.png') no-repeat center" />
									</div>
								</div></td>
						</tr>
						<tr id="visitorInfoName0">
							<th colspan="1"><%=BizboxAMessage.getMessage("", "이름")%></th>
							<td colspan="1" class="icon01"><input type="text"
								id="txtVisitNM" name="txtVisitNM" placeholder="이름을 입력하세요."
								style="width: 95%;" /></td>
						</tr>
						<tr id="visitorInfoPhone0">
							<th colspan="1"><%=BizboxAMessage.getMessage("", "전화번호")%></th>
							<td colspan="1" class="icon01"><input type="text"
								id="txtVisitPhone" name="txtVisitPhone"
								placeholder="전화번호를 입력하세요." style="width: 95%"
								onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" /></td>
						</tr>
						<tr id="visitorInfoCarNo0" name="visitorInfoCarNo">
							<th colspan="1"><%=BizboxAMessage.getMessage("", "차량번호")%></th>
							<td colspan="1" class="icon01"><input id="parkingTk" class="kendoComboBox" name="parkingTk" style="width: 45%" /> 
								<input type="text" id="txtVisitCarNo" name="txtVisitCarNo" placeholder="차량번호를 입력하세요." style="width: 49%" />
							</td>
						</tr>
						<%--  <tr id="visitorInfoCarInOutTime0" name="visitorInfoCarInOutTime" style="display:none">
						<th colspan="1"><%=BizboxAMessage.getMessage("","입/출차 시간")%></th>
						<td class="icon01">
							<input id="visitCarInTimeHour" class="kendoComboBox" style="width:18%;"/> <%=BizboxAMessage.getMessage("TX000001228","시")%>
							<input id="visitCarInTimeMin" class="kendoComboBox" style="width:18%;"/> <%=BizboxAMessage.getMessage("TX000001229","분")%>
							~
							<input id="visitCarOutTimeHour" class="kendoComboBox" style="width:18%;"/> <%=BizboxAMessage.getMessage("TX000001228","시")%>
							<input id="visitCarOutTimeMin" class="kendoComboBox" style="width:18%;"/> <%=BizboxAMessage.getMessage("TX000001229","분")%>
						</td>
				    </tr> --%>


					</tbody>
					<tbody id="visitorCommonData2">
						<tr id="visitorInfoCarInOutTime" style="display: none">
							<th colspan="2"><%=BizboxAMessage.getMessage("", "입/출차 시간")%></th>
							<td class="icon01">
								<input id="visitCarInTimeHour" class="kendoComboBox" 
								style="width: 18%;" /> <%=BizboxAMessage.getMessage("TX000001228", "시")%>
								<input id="visitCarInTimeMin" class="kendoComboBox"
								style="width: 18%;" /> <%=BizboxAMessage.getMessage("TX000001229", "분")%>
								~ <input id="visitCarOutTimeHour" class="kendoComboBox"
								style="width: 18%;" /> <%=BizboxAMessage.getMessage("TX000001228", "시")%>
								<input id="visitCarOutTimeMin" class="kendoComboBox"
								style="width: 18%;" /> <%=BizboxAMessage.getMessage("TX000001229", "분")%>
							</td>
						</tr>
						<tr id="">
							<th colspan="2"><%=BizboxAMessage.getMessage("", "방문 목적")%></th>
							<td class="icon01"><input type="text" id="txtVisitAim"
								name="txtVisitAim" placeholder="방문 목적을 입력하세요."
								style="width: 95%;" /></td>
						</tr>
						<tr id="">
							<th colspan="2"><%=BizboxAMessage.getMessage("", "결재 승인여부")%></th>
							<td class="icon01"><input type="radio" id=eapLinkYnY
								name="eapLinkYn" value="Y" class="puddSetup" pudd-label="승인" />
								<input type="radio" id=eapLinkYnN name="eapLinkYn" value="N"
								class="puddSetup" pudd-label="미승인" checked /></td>
						</tr>
						<tr id="visitorInfoQrSend">
							<th colspan="2"><%=BizboxAMessage.getMessage("", "QR코드 발급여부")%></th>
							<td class="icon01"><input type="radio" id=qrSendYnY
								name="qrSendYn" value="Y" class="puddSetup" pudd-label="발급"
								<c:if test="${content.qr_send_yn == 'Y' || content == null }">checked</c:if> />
								<input type="radio" id=qrSendYnN name="qrSendYn" value="N"
								class="puddSetup" pudd-label="미발급"
								<c:if test="${content.qr_send_yn == 'N'}">checked</c:if> /></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</c:if>

	<c:if test="${param.type == 'view'}">
		<div class="pop_con">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="13%" />
						<col width="17%" />
						<col wdith="70%" />
					</colgroup>
					<tr id="">
						<th rowspan="2" colspan="1"><%=BizboxAMessage.getMessage("TX000000329", "담당자")%></th>
						<th colspan="1"><%=BizboxAMessage.getMessage("", "이름")%></th>
						<td class="icon01">${visitorInfo.man_emp_name}</td>
					</tr>
					<tr id="">
						<th colspan="1"><%=BizboxAMessage.getMessage("", "전화번호")%></th>
						<td class="icon01">${visitorInfo.man_tel_num}</td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "방문 장소 / 유형")%></th>
						<td class="icon01">${visitorInfo.visit_place}/
							${visitorInfo.visit_place_sub}</td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "방문 일시")%></th>
						<td class="icon01" id="viewVisitDt"></td>
					</tr>
					<tr id="">
						<th rowspan="4" colspan="1" style="text-align: right;"><%=BizboxAMessage.getMessage("", "방문자<br />정보")%></th>
						<th colspan="1"><%=BizboxAMessage.getMessage("", "회사")%></th>
						<td colspan="1" class="icon01">${visitorInfo.visitor_co}</td>
					</tr>
					<tr>
						<th colspan="1"><%=BizboxAMessage.getMessage("", "이름")%></th>
						<td colspan="1" class="icon01">${visitorInfo.visitor_nm}</td>
					</tr>
					<tr>
						<th colspan="1"><%=BizboxAMessage.getMessage("", "전화번호")%></th>
						<td colspan="1" class="icon01">${visitorInfo.visit_hp}</td>
					</tr>
					<tr>
						<th colspan="1"><%=BizboxAMessage.getMessage("", "차량번호")%></th>
						<td colspan="1" class="icon01" id="viewVisitCarNo"></td>
					</tr>
					<tr id="viewVisitCarInOutTimeTr" style="display:none;'">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "입/출차 시간")%></th>
						<td class="icon01" id="viewVisitCarInOutTime"></td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "방문 목적")%></th>
						<td class="icon01">${visitorInfo.visit_aim}</td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "결재 승인여부")%></th>
						<td class="icon01" id="eapLinkYn"></td>
					</tr>
					<tr id="">
						<th colspan="2"><%=BizboxAMessage.getMessage("", "QR코드 발급여부")%></th>
						<td class="icon01" id="qrSendYn"></td>
					</tr>
				</table>
			</div>
		</div>
	</c:if>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input id="btnSave" type="button"
				value="<%=BizboxAMessage.getMessage("TX000001256", "저장")%>"
				style="display: none;" /> <input id="btnSubmit" type="button"
				value="<%=BizboxAMessage.getMessage("", "상신")%>"
				style="display: none;" /> <input id="btnClose" type="button"
				value="<%=BizboxAMessage.getMessage("", "확인")%>"
				style="display: none;" /> <input id="btnCancel" type="button"
				value="<%=BizboxAMessage.getMessage("", "취소")%>"
				style="display: none;" /> <input id="btnEdit" type="button"
				value="<%=BizboxAMessage.getMessage("", "수정")%>"
				style="display: none;" />
		</div>
	</div>
</div>
<!-- //pop_wrap -->

<form id="frmPop" name="frmPop" hidden>
	<input type="hidden" name="popUrlStr" id="txt_popup_url"
		value="/gw/systemx/orgChart.do"><br> <input type="hidden"
		name="selectMode" value="u" /><br> <input type="hidden"
		name="selectItem" value="s" /><br> <input type="hidden"
		id="callback" name="callback" value="" /> <input type="hidden"
		name="deptSeq" value="" />
	<c:if test="${loginVO.userSe == 'USER' }">
		<input type="hidden" name="compFilter" value="${loginVO.compSeq}" />
	</c:if>
	<input type="hidden" name="callbackUrl"
		value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />" />
</form>