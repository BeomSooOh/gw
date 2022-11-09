
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

<c:if test="${ClosedNetworkYn != 'Y'}">
	<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
</c:if>

<script>
	var ID_check = false;
	var Email_check = false;
	var empSignfileId = "${infoMap.signFileId}";
	
    $(document).ready(function () {  
       	
        $("#compSeq").val("${infoMap.compSeq}");        
        
    	var authCodeList;

        getWorkTeamMst();
        getEmpJobList();
        getEmpStatusList();
        checkWorkYn('${checkWorkYn}');
        var cwCombobox = $("#work_team").data("kendoComboBox");
        
        var diaHei = $("#basicForm").height();
        $("#dialog-form-background").css("height", diaHei + 10);
        
     	// 연차설정
	    $("#ea1_date").kendoDatePicker({
	    	format: "yyyy-MM-dd"
	    });
		
		$("#ea2_date").kendoDatePicker({
	    	format: "yyyy-MM-dd"
	    });
		
		//라이선스
		if("${infoMap.licenseCheckYn}" != "")
			$("#licenseCheckYn").val("${infoMap.licenseCheckYn}");
		//사진등록임시
		$(".phogo_add_btn").on("click",function(){
			$(".hidden_file_add").click();
		})
		
		//사인등록임시
		$(".sign_add_btn").on("click",function(){
			if("${eaType}" == "eap") {
				fnSignImgPop();
			} else {
				$(".hidden_file_add2").click();	
			}	
		})
		
        $(".phogo_add_btn2").on("click", function () {
            $(".hidden_file_add").click();
        })
        $("#year_sel").kendoComboBox({
			dataSource : {
			    data : ["2016","..."]
			},
			value:"2016"
		});
        initDate();
        setOutMailInfo();
        
        var data = ${compList};
        
        //기간 셀렉트박스
        var compSeqSel = $("#compSeq").kendoComboBox({
        	dataSource : data,
            dataTextField: "compName",
            dataValueField: "compSeq",
            change: function(e) {
            	
            	if(e.sender.selectedIndex == -1){
            		e.sender.value("");   
            	}else{
                    var value = this.value();
                    // 회사변경시 직급, 직책 코드 리스트 변경 , 권한정보 변경.
                    setPosition(value, "POSITION");
                    setDuty(value, "DUTY");
                    selectAuthList();
                    getWorkTeamMst();
                    getNativeLangCode();           		
            	}
              }
        
        }).data("kendoComboBox");
        
	    var coCombobox = $("#compSeq").data("kendoComboBox");
        
        compSeqSel.value("${infoMap.compSeq}");
        if( "${userSe}" != "MASTER"){
        	compSeqSel.enable(false);
        }else if("${infoMap.compSeq}" == ""){
        	coCombobox.value("");
        	//coCombobox.select(0);
        }
        if("${infoMap.compSeq}" != ""){
        	compSeqSel.enable(false);
        }
        
        setPosition("${infoMap.compSeq}", "POSITION");
        setDuty("${infoMap.compSeq}", "DUTY");
									
        var d = new Date();

        var s =leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
		
        if("${infoMap.empSeq}" == ""){
        	$("#joinDay").val(s);
        	$("#weddingDay").val("");
        	$("#bday").val("");
        	$("#resignDay").val("");
			$("#orgchartDisplayYn").val("Y");
			$("#messengerDisplayYn").val("Y");  
			
			$("#btnCertPop").attr("disabled", "disabled");
        }
        
        var picFileImg = document.getElementById('img_picFileIdNew');
		var signFileImg = document.getElementById('img_signFileIdNew');
		if(document.getElementById('picFileIdNew').value == '')
			picFileImg.src = '/gw/Images/bg/mypage_noimg.png';
		if(document.getElementById('signFileIdNew').value == '')
			signFileImg.src = '/gw/Images/bg/sign_noimg.png';
		
		
		if($("#compSeq").val() != '')
			selectAuthList();
		
		if(!document.getElementById("jj_radi2").checked){
    		$("#resignDay").val("");
    	}

		if($("#empSeq").val() != ""){
			ID_check = true;
			Email_check = true;
			
			$("#deptPath").html(rtnDeptPath("${infoMap.pathName}"));
		}else if($("#compSeq").val() != ""){
			getNativeLangCode();
		}
		
		fnErpOption();
		
		// 사인이미지 최초 호출
		if("${eaType}" == "eap" && $("#empSeq").val() != "") {
			fnSignImgInit();	
		}
    });   
    
	function getImgSrc(){
		return $("#img_signFileIdNew").attr("src");
	}
	
	function getSignFileId(){
		return empSignfileId;
	}
    
    function fnSignImgInit() {
		if("${infoMap.signType}" == "img") {
			$("#signTypeClass").hide();	
			$("#Delbtn_sign").show();
			$("#signTxt").hide();
			$("#img_signFileIdNew").show();
			signType = "img";
		} else {
			var empName = $("#empName").val();
			signType = "${infoMap.signType}";
			
			if(signType == "") {
				signType = "stamp_de_div";
			}			
			
			if(signType == "stamp_de_div") {
				$("#signStamp").hide();
			} else {
				$("#signStamp").show();
			}
			
			$("#signTypeClass").attr("class", signType);
			$("#signTypeClass").show();	
			$("#signName").text(empName);
			$("#img_signFileIdNew").hide();
			$("#Delbtn_sign").hide();
			$("#signTxt").hide();
		}
	}
    
    function getEmpJobList(){
    	$("#jobCode").empty();
   		
	   	 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/cmm/systemx/getEmpJobList.do"/>',
	 		datatype:"text",
	 		success: function (data) {
	 			$.each(data.jobList, function( key, value ) {
	 				
	 				$("#jobCode")[0].add(new Option(value.detailName, value.detailCode));
	 			});
	 			
	 			$("#jobCode").val("${infoMap.jobCode}");
	 			
			},
			error: function (result) {
	 			
	 		}
	 	});
    }
    
	function getEmpStatusList(){
		$("#statusCode").empty();
   		
	   	 $.ajax({
	     	type:"post",
	 		url:'<c:url value="/cmm/systemx/getEmpStatusList.do"/>',
	 		datatype:"text",
	 		success: function (data) {
	 			$.each(data.statusList, function( key, value ) {
	 				
	 				$("#statusCode")[0].add(new Option(value.detailName, value.detailCode));
	 			});
	 			
	 			$("#statusCode").val("${infoMap.statusCode}");
			},
			error: function (result) {
	 			
	 		}
	 	});
    }
	
	function setOutMailInfo(){
		
		$("#outDomain").on("change",function(){
			if($("#outDomain").val() != ""){
				$("#outDomainText").hide();
				$("#outDomainText").val($("#outDomain").val());
			}else{
				$("#outDomainText").show();
				$("#outDomainText").val("");
				$("#outDomainText").focus();
			}
		});
		
		var userOutMail = "${infoMap.outMail}";
		var userOutDomain = "${infoMap.outDomain}";
		
		if(userOutMail != "" && userOutDomain != ""){
			$("#outEmail").val(userOutMail);
			$("#outDomainText").val(userOutDomain);
			$("#outDomain").val(userOutDomain);
			
			if($("#outDomain").val() != ""){
				$("#outDomainText").hide();
			}
		}
	}
       	
    function getWorkTeamMst(){
    	
        var chkCode = '${teamWorkMap.workTeamSqno}';
        
    	$("#work_team").empty();
    	
    	var wtdata = {};
    	wtdata.compSeq = $("#compSeq").val();
    	$.ajax({
            type: "post",
            url: "getWorkTeamMst.do",
            datatype: "text",
            data: wtdata,
            async: false,
            success: function (data) { 
                if(data.result){
                	var isCode = false;
                	var wtHtml = '';                   
                	var stHtml = '';
                	var dataStr = JSON.stringify(data.result);
                	for(i = 0; i < data.result.length; i ++){
                		
                		var seq = data.result[i].workTeamSqno;
                		var nm = data.result[i].workTeamName;
                		if(chkCode && chkCode == seq){                			
                			  isCode = true;
                			  wtHtml += '<option value="'+seq+'" selected="selected">'+nm+'</option>';
                		}else {
                			wtHtml += '<option value="'+seq+'" >'+nm+'</option>';
                		}
                		
                	}
                	if(isCode){
                		stHtml = '<option value="default" ><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>';
                		stHtml += wtHtml;
                	}else{
                		stHtml = '<option value="default" selected="selected"><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>';
                		stHtml += wtHtml;
                	}
                	
                }
                $("#work_team").append(stHtml);   
                $("#work_team").kendoComboBox();
            },
            error: function (e) {   //error : function(xhr, status, error) {
                alert("error1");
            }
        });
    	
    }
    
    function getNativeLangCode(){        
        
        var paramData = {};
        paramData.compSeq = $("#compSeq").val();
        
        $.ajax({
            type: "post",
            url: "getNativeLangCode.do",
            datatype: "text",
            data: paramData,
            async: false,
            success: function (data) { 
                if(data.result){
                	$("#nativeLangCode").val(data.result);
                }
            },
            error: function (e) {   //error : function(xhr, status, error) {
                alert("error2");
            }
        });
    }
    	
    function leadingZeros(n, digits) {
        var zero = '';
        n = n.toString();
        if (n.length < digits) {
            for (i = 0; i < digits - n.length; i++)
                zero += '0';
        }
        return zero + n;
    }


    function setPosition(compSeq, dpType){
    	
    	var dataSource = new kendo.data.DataSource({
	    	 transport: { 
	             read:  {
	                 url: 'getDutyPositionListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.compSeq = compSeq;    
	                 options.dpType = dpType;
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.dpList;
	 	  	    }
	 	  	  }
	     });
  	
        $("#positionCode").kendoComboBox({
        	dataSource : dataSource,
            dataTextField: "dpName",
            dataValueField: "dpSeq",
            value : "${infoMap.deptPositionCode}",
            change: function (e) {
            	if(e.sender.selectedIndex == -1)
            		e.sender.value("");
            }
        });

    }
    
    function setDuty(compSeq, dpType){
    	
    	var dataSource = new kendo.data.DataSource({
	    	 transport: { 
	             read:  {
	                 url: 'getDutyPositionListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.compSeq = compSeq;    
	                 options.dpType = dpType;
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.dpList;
	 	  	    }
	 	  	  }
	     });

        $("#dutyCode").kendoComboBox({
        	dataSource : dataSource,
            dataTextField: "dpName",
            dataValueField: "dpSeq",
            value : "${infoMap.deptDutyCode}",
            change: function (e) {
            	if(e.sender.selectedIndex == -1)
            		e.sender.value("");
            }          
        });
        
    	
    }
    
    function empDeptInfoPop(compSeq, deptSeq, empSeq) {
		
			$("#compFilter").val(compSeq);
			$("input[seq='deptFlag']").val(deptSeq);

			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
			frmPop.submit();
			pop.focus(); 
		
		
    }
    
    function rtnDeptPath(pathName){
    	var deptName = '';
        var pathNameS = pathName.split('|');
        for(i = 0; i < pathNameS.length; i ++){
            if(i == pathNameS.length-1){
                deptName += '<em class="text_blue">'+pathNameS[i]+'</em>';
            }else{
                deptName += pathNameS[i]+' > ';
            }               
        }
        return deptName;
    }
    
    function callbackSel(data) {
    	if(data.returnObj.length > 0){
	    	$("#deptName_1").val(data.returnObj[0].deptName);
	    	$("#deptSeqNew").val(data.returnObj[0].deptSeq);
	    	var pathName = rtnDeptPath(data.returnObj[0].pathName);     //부서 상위 뿌려줌
	    	
	    	$("#deptPath").html(pathName);
	    	if($("#empSeq").val() == ""){
	    		$("#deptSeq").val(data.returnObj[0].deptSeq);
	    	}
    	}
  	}

    function removeEmpDept(compSeq, deptSeq, empSeq) {
        $.ajax({
            type: "post",
            url: "empDeptRemoveProc.do",
            datatype: "text",
            data: { compSeq: compSeq, deptSeq: deptSeq, empSeq: empSeq },
            success: function (data) {
                var result = data.result;

                alert(data.msg.replace("　","\n"));

                if (result == true) {

                } else {

                }
            },
            error: function (e) {	//error : function(xhr, status, error) {
                alert("error3");
            }
        });
    }

    function checkLoginId(id) {
    
    	if($("#empSeq").val() == ""){
	        if (id != null && id != '') {
	            $.ajax({
	                type: "post",
	                url: "empLoginIdCheck.do",
	                datatype: "text",
	                data: { loginId: id },
	                success: function (data) {
	                    if (data.result == 0) {
	                    	$("#info").prop("class", "text_blue f11 mt5");
	                        $("#info").html("<%=BizboxAMessage.getMessage("TX000010714","사용가능한 아이디 입니다")%>");
	                        ID_check = true;
	                    } if (data.result == 1) {
	                    	$("#info").prop("class", "text_red f11 mt5");
	                        $("#info").html("<%=BizboxAMessage.getMessage("TX000010713","이미 사용중인 아이디 입니다")%>");
	                        ID_check = false;
	                    } if (data.result == 2) {
	                    	$("#info").prop("class", "text_red f11 mt5");
	                        $("#info").html("<%=BizboxAMessage.getMessage("TX900000141", "추측하기 쉬운 단어입니다")%>");
	                        ID_check = false;
	                    }
	
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error4");
	                }
	            });
	        } else if(id == '') {	        	
	        	$("#info").prop("class", "text_red f11 mt5");
	            $("#info").html("<%=BizboxAMessage.getMessage("TX000010717","아이디를 입력해 주세요")%>");
	            Email_check = false;
	        }
	        $("#emailAddr").val($("#loginId").val().replace(/ /gi,""));
	        checkEmailId($("#emailAddr").val());
       }
    }

        
    function initDate(){
    	fnLicenseChange(null);
    }


    function checkEmailId(id) {
    
    	var checkId = /[A-Z]/;

    	if(checkId.test(id)) {
    		Email_check = false;
    		$("#email_info").prop("class", "text_red f11 mt5");
            $("#email_info").html("<%=BizboxAMessage.getMessage("TX000016330","대문자를 포함할 수 없습니다.")%>");
            return;
    	}
    	
    	checkId = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
    	if(checkId.test($("#emailAddr").val())){
    		Email_check = false;
    		$("#email_info").prop("class", "text_red f11 mt5");
            $("#email_info").html("<%=BizboxAMessage.getMessage("TX900000142","한글를 포함할 수 없습니다.")%>");
            return;
    	}
    	
    	var reg_email=/^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*$/;
    	
    	if(id.search(reg_email) < 0){
    		Email_check = false;
    		$("#email_info").prop("class", "text_red f11 mt5");
            $("#email_info").html("<%=BizboxAMessage.getMessage("TX900000143","특수문자나 공백을 포함할 수 없습니다.")%>");
            return;
    	}

    	if($("#empSeq").val() == ""){
	        if (id != null && id != '') {
	            $.ajax({
	                type: "post",
	                url: "empLoginIdCheck.do",
	                datatype: "text",
	                data: { emailAddr: id },
	                success: function (data) {
	                    if (data.result == 0) {
	                    	$("#email_info").prop("class", "text_blue f11 mt5");
	                        $("#email_info").html("<%=BizboxAMessage.getMessage("TX000010714","사용가능한 아이디 입니다")%>");
	                        Email_check = true;
	                    } else if (data.result == 1) {
	                    	$("#email_info").prop("class", "text_red f11 mt5");
	                        $("#email_info").html("<%=BizboxAMessage.getMessage("TX000010713","이미 사용중인 아이디 입니다")%>");
	                        Email_check = false;
	                    } else if (data.result == 2) {
	                    	$("#email_info").prop("class", "text_red f11 mt5");
	                        $("#email_info").html("<%=BizboxAMessage.getMessage("TX900000141", "추측하기 쉬운 단어입니다")%>");
	                        Email_check = false;
	                    }
	
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error5");
	                }
	            });
	        } else if(id == '') {	        	
	        	$("#email_info").prop("class", "text_red f11 mt5");
	            $("#email_info").html("<%=BizboxAMessage.getMessage("TX000010717","아이디를 입력해 주세요")%>");
	            Email_check = false;
	        }
        }
    }
        
    function setWedding(){
    	if($("#weddingYn").val() == "Y"){
    		$('#weddingDay').data('kendoDatePicker').enable(true);
    		var d = new Date();
            var s =leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
            if($("#weddingDay").val() == ""){
            	$("#weddingDay").val(s);
            }
            $("#sp_2").show();
       	 	$("#weddingDay").attr("readonly", true);
    	}
    	if($("#weddingYn").val() == "N" || $("#weddingYn").val() == ""){
    		$('#weddingDay').data('kendoDatePicker').enable(false);
    		$("#sp_2").hide();
    	}
    }
    
    
    function setLunar(){
    	if($("#lunarYn").val() != ""){
    		$('#bday').data('kendoDatePicker').enable(true);
    		var d = new Date();
            var s =leadingZeros(d.getFullYear(), 4) + '-' +leadingZeros(d.getMonth() + 1, 2) + '-' +leadingZeros(d.getDate(), 2);
            if($("#bday").val() == ""){
            	$("#bday").val(s);
            }
            $("#sp_3").show();
       	 	$("#bday").attr("readonly", true);
    	}
    	else{
    		$('#bday').data('kendoDatePicker').enable(false);
    		$("#sp_3").hide();
    	}
    }

    
    function selectAuthList(){
    	

	    	var comp_seq = $("#compSeq").val();
	    	$.ajax({
	            type: "post",
	            url: "getAuthCodeList.do",
	            datatype: "text",
	            data: { comp_seq: comp_seq, pageInfo : "empinfoPop"},
	            success: function (data) {
	                authCodeList = data;
	                if("${authCurHtml}" == "" || "${authCurHtml}" == null){
	                	$("#authListBody").html("");
	 	                $("#authListBody").html(data.authHtml);
	                }
	                else{
	                	$("#authListBody").html("");
	            		$("#authListBody").html("${authCurHtml}");
	                }
	               
	            },
	            error: function (e) {	//error : function(xhr, status, error) {
	                alert("error6");
	            }
	        });
    	
    }
	    	
	function checkWorkYn(cwData){
		var cwCombobox = $("#work_team").data("kendoComboBox");
	
		if(cwData.value == 'N'){
			cwCombobox.enable(false);
		}else{
			cwCombobox.enable(true);
		}
	}
	
	function replaceAll(str, searchStr, replaceStr) {

	    return str.split(searchStr).join(replaceStr);
	}
	
	// 공통옵션 - erp 조직도연동
	var erpOptions = '${erpEmpOptions}';
	var gwUpdateYN = '${gwUpdateYN}';
	var erpType = '${erpType}';
	var ERPUpdateYN = "";
	var updateItem = "";
	function fnErpOption() {
		if(erpOptions != "N" && "${infoMap.empSeq}" != "") {
			if(gwUpdateYN == "N") {
				$("#lunarYn").kendoDropDownList({enable:false});
				$("#bday").attr("disabled", true);
				$("#weddingYn").kendoDropDownList({enable:false});
				$("#weddingDay").attr("disabled", true);
				$("#tel_house").attr("disabled", true);
				$("#mobileTelNum").attr("disabled", true);
				$("#zipCode").attr("disabled", true);
				$("#detailAddr").attr("disabled", true);
				$("#addr").attr("disabled", true);
				$("#btnZip").attr("disabled", true);
				$("#empName").attr("disabled", true);
				$("#empNameEn").attr("disabled", true);
				$("#empNameCn").attr("disabled", true);
				$("#empNameJp").attr("disabled", true);
			} else {
				if(erpOptions != "Y") {
					erpOptions = JSON.parse(erpOptions);	
				
					for(var i=0; i<erpOptions.length; i++) {
						// ERP 정보수정 
						if(erpOptions[i].realOptionId == "cm1104") {
							if(erpOptions[i].realValue == "1") {
								ERPUpdateYN = "Y";
							} else {
								ERPUpdateYN = "N";
							}
						}
					
						// 생년월일
						if(erpOptions[i].realOptionId == "cm1105") {
							if(erpOptions[i].realValue == "1") {
								//compSeqSel.enable(false);
								$("#lunarYn").kendoDropDownList({enable:false});
								$("#bday").attr("disabled", true);
							} else {
								updateItem += ", <%=BizboxAMessage.getMessage("TX000000083","생년월일")%>, ";
							}
						}
						
						// 결혼 기념일
						if(erpOptions[i].realOptionId == "cm1106") {
							if(erpOptions[i].realValue == "1") {
								$("#weddingYn").kendoDropDownList({enable:false});
								$("#weddingDay").attr("disabled", true);
								
							} else {
								updateItem += ", <%=BizboxAMessage.getMessage("TX000010831","결혼 기념일")%>, ";
							}
						}
						
						// 전화번호
						if(erpOptions[i].realOptionId == "cm1107") {
							if(erpOptions[i].realValue == "1") {
								$("#tel_house").attr("disabled", true);
								$("#mobileTelNum").attr("disabled", true);
								
							} else {
								updateItem += ", <%=BizboxAMessage.getMessage("TX000000073","전화번호")%>, ";
							}
						}
						
						// 집주소
						if(erpOptions[i].realOptionId == "cm1108") {
							if(erpOptions[i].realValue == "1") {
								$("#zipCode").attr("disabled", true);
								$("#detailAddr").attr("disabled", true);
								$("#addr").attr("disabled", true);
								$("#btnZip").attr("disabled", true);
								
							} else {
								updateItem += ", <%=BizboxAMessage.getMessage("TX000018208","집주소")%>, ";
							}
						}
						
						// 사용자명
						if(erpOptions[i].realOptionId == "cm1109") {
							if(erpOptions[i].realValue == "1") {
								$("#empName").attr("disabled", true);
								$("#empNameEn").attr("disabled", true);
								$("#empNameCn").attr("disabled", true);
								$("#empNameJp").attr("disabled", true);
								
							} else {
								updateItem += ", <%=BizboxAMessage.getMessage("TX000021265","사용자명")%>, ";
							}
						}			
					}			
				}
				
			}
		}
	}
	
	var signType = "";
	function fnSignImgPop() {
		if(signType == "") {
			signType = "stamp_de_div";	
		}
		
		$('input[name="stamp"]').val(signType);
		$('input[name="empName"]').val($("#empName").val());		
		
		if($("#empSeq").val() != "") {
			
			$('input[name="empSeq"]').val($("#empSeq").val());
			$('input[name="compSeq"]').val("${infoMap.compSeq}");			
			$('input[name="groupSeq"]').val("${infoMap.groupSeq}");
			$('input[name="langCode"]').val("${infoMap.nativeLangCode}");
			
		} else {
			$('input[name="empSeq"]').val("");
		}
		
		window.open("", "singImgPop", "width=430,height=350,scrollbars=yes");
		
        var frmData = document.signPopForm ;
        frmData.target = "singImgPop" ;		
		frmData.submit();		
		
	}
	
	var signImgFlag = false;
	function fnCallBack(signTypeCallback) {
		$("#signType").val(signTypeCallback);
		
		signType = signTypeCallback;
		
		var empName = $("#empName").val();
		
		if(signTypeCallback != "img") {
			$("#img_signFileIdNew").hide();
			$("#signTxt").hide();
			$("#signTypeClass").show();	
			
			$("#signTypeClass").attr("class", signTypeCallback);
			$("#signName").text(empName);
			$("#Delbtn_sign").hide();
			
			if(signTypeCallback == "stamp_de_div") {
				$("#signStamp").hide();
			} else {
				$("#signStamp").show();
			}
			
			signImgFlag = false;
			
			
		} else {
			console.log("img");
			$("#signTypeClass").hide();
		}
	}
	
	function fnCallBackImg(signTypeCallback, imgSrc, signImgValue, signFileId) {
		signType = "img";
		if(typeof signImgValue == "undefined") {
			signImgFlag = false;
		} else {
			signImgFlag = true;	
		}
		
		$("#signFileIdNew").val(signFileId);
		$("#signTypeClass").hide();	
		$("#img_signFileIdNew").show();
		$("#Delbtn_sign").show();
		$("#signType").val(signTypeCallback);
	    $("#Delbtn_sign").show();
		$("#signTxt").hide();
		$("#img_signFileIdNew").attr("src", imgSrc);
	}	
	
	function fnCerpPop(){

		if("${infoMap.empSeq}" == ""){
			return;
		}
		
		var workStatusFromGW = "${infoMap.workStatus}" == "001" ? "retire" : "working";
		var url = "/attend/views/certificate/certRequestCreatePop?workStatusFromGW=" + workStatusFromGW + "&empSeq=" + "${infoMap.empSeq}" + "&compSeq=" + "${infoMap.compSeq}";
		openWindow2(url,  "certSendPop", 690, 378, 0);
	}
</script>

<form id="signPopForm" name="signPopForm" method="post" action="/gw/cmm/systemx/signPop.do" target="popup_window">
  <input name="page" value="empInfo" type="hidden"/>
  <input name="stamp" value="" type="hidden"/>
  <input name="empName" value="" type="hidden"/>
  <input name="groupSeq" value="" type="hidden"/>
  <input name="langCode" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>
  <input name="compSeq" value="" type="hidden"/>  
</form>

<form id="basicForm" name="basicForm" action="empInfoSaveProc.do"
	method="post" onsubmit="return false;">
	<div class="pop_wrap resources_reservation_wrap" style="width: 998px;">
	<div id="dialog-form-background" style="display:none; background-color:#FFFFDD;filter:Alpha(Opacity=50); z-Index:8888; width:100%; height:100%; position:absolute; top:1px; cursor:wait" ></div>
		<input id="groupSeq" name="groupSeq" value="${infoMap.groupSeq}"
			type="hidden" /> <input id="bizSeq" name="bizSeq"
			value="${infoMap.bizSeq}" type="hidden" /> <input id="empSeq"
			name="empSeq" value="${infoMap.empSeq}" type="hidden" /> <input
			id="deptSeq" name="deptSeq" value="${infoMap.deptSeq}" type="hidden" />
		<input id="authCodeList" name="authCodeList" type="hidden" />
		<div class="pop_head">
			<h1>
			<c:if test="${infoMap.empSeq != null}"><%=BizboxAMessage.getMessage("TX000011780","사원정보관리")%></c:if>
			<c:if test="${infoMap.empSeq == null}"><%=BizboxAMessage.getMessage("TX000004488","입사처리")%></c:if>
			</h1>
			<a href="#n" class="clo"><img
				src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></p>
			<div class="my_story">
				<div class="my_left">

					<!-- 이미지 등록 -->
					<ul>
						<li class="mypage_file">
							<p class="imgfile" id="">
								<span class="posi_re dp_ib"> 
									<c:if test="${infoMap.picFileId ne NULL}">
										<img id="img_picFileIdNew"
											src="${profilePath}/${infoMap.empSeq}_thum.jpg?<%=System.currentTimeMillis()%>"
											onerror="this.src='/gw/Images/bg/mypage_noimg.png';$('#picTxt').show();"
											/>
								
									</c:if> 
									<c:if test="${infoMap.picFileId eq NULL}">
										<img id="img_picFileIdNew"
											src="<c:url value='/Images/bg/mypage_noimg.png'/>"
											alt="등록된 이미지가 없습니다" />
									</c:if> 
									<span class="txt" id="picTxt" style="display:none;"><%=BizboxAMessage.getMessage("TX900000448","사진을 등록해 주세요")%> <br /> (120*160)</span>									
									<a href="#n" class="del_btn" title="<%=BizboxAMessage.getMessage("TX000000424","삭제")%>" id="Delbtn_pic"
									onclick="return fn_picImgDel();"></a>
								</span>
							</p>
						</li>
						<li class="mt7 controll_btn p0">
							<div class="mypage_file_upload">
								<p id="p_File">
									<input type="file" id="picFileId_New" class="hidden_file_add" name="picFileIdNew" onchange="profileImgUpload(this);"/>
								</p>	
								<button class="phogo_add_btn"><%=BizboxAMessage.getMessage("TX000016206","사진등록/변경")%></button>						
<!-- 								<input type="file" name="picFileIdNew" id="picFileId_New" class="hidden_file_add" name="" /> -->
								<!-- 찾아보기 할때 나오는 input text박스 숨김처리 -->
								<input id="picFileIdNew" name="picFileId" type="hidden" value="${infoMap.picFileId}" />
								<input id="Old_picFileId" name="Old_picFileId" type="hidden" value="${infoMap.picFileId}"/>
							</div>
						</li>
					</ul>

					<!-- 사인 등록 -->
					<ul class="mt20">
						<li class="mypage_file_sign">
							<div class="sign" id="">
								<div class="sign_sel">
									<div id="signTypeImg" class="cen">
				                        <p id="signTypeClass" class="stamp_de_div"  style="display:none">
				                            <span id="signName"></span><span id="signStamp" class="">인</span>
				                        </p>
									
		 								<c:if test="${infoMap.signFileId ne NULL}">
											<img id="img_signFileIdNew"
												src="<c:url value='/cmm/file/fileDownloadProc.do?fileId=${infoMap.signFileId}&fileSn=0' />"
												onerror="this.src='/gw/Images/bg/mypage_noimg.png';$('#signTxt').show();"
												/>
										</c:if> 
										<c:if test="${infoMap.signFileId eq NULL}">
											<img id="img_signFileIdNew"
												src="<c:url value='/Images/bg/sign_noimg.png' />"
												alt="등록된 이미지가 없습니다" />
										</c:if>
										
										<input type="hidden" id="signType" name="signType" value=""/>
										<span class="txt" id="signTxt" style="display:none;"><%=BizboxAMessage.getMessage("TX900000449","사인을 등록해 주세요")%> <br /> (49*49)</span>
										<a href="#n" class="del_btn" title="<%=BizboxAMessage.getMessage("TX000000424","삭제")%>" id="Delbtn_sign"
											onclick="return fn_signImgDel();"></a>
									 </div>
								</div>
								
							</div>
						</li>
						<li class="mt7 controll_btn p0">
							<div class="mypage_file_upload">
								<p id="p_File2">
									<input type="file" id="signFileId_New" class="hidden_file_add2" name="signFileIdNew" onchange="signImgUpload(this);"/>
								</p>
								<button class="sign_add_btn"><%=BizboxAMessage.getMessage("TX000016210","사인등록/변경")%></button>
								<!-- 찾아보기 할때 나오는 input text박스 숨김처리 -->
								<input id="signFileIdNew" name="signFileId" type="hidden" value="${infoMap.signFileId}" />
							</div>
						</li>
					</ul>

				</div>
				<div class="my_con">
					<!-- 기본정보 -->
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="70" />
								<col width="80" />
								<col width="246" />
								<col width="123" />
								<col width="" />
							</colgroup>
							<tr>
								<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" id="compCheckImg"/>
									<%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
								<td>
									<input id="compSeq" name="compSeq" style="width: 216px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
									<input id="mainCompSeq" name="mainCompSeq" type="hidden" value="${infoMap.mainCompSeq}"/>
								</td>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td><input type="radio" id="useYn" name="useYn" value="Y"
									class="k-radio" checked="checked" /> <label
									class="k-radio-label radioSel" for="useYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> <input
									type="radio" id="useN" name="useYn" value="N"
									<c:if test="${infoMap.eUseYn == 'N'}">checked</c:if>
									class="k-radio" /> <label class="k-radio-label radioSel ml10"
									for="useN"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label></td>
							</tr>
							<tr>
								<th colspan="2"><img
									src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000000075","아이디")%></th>
								<td><input type="text" id="loginId" name="loginId"
									value="${infoMap.loginId}" onkeyup="checkLoginId(this.value);"
									style="width: 216px;"
									<c:if test="${infoMap.empSeq != null}">disabled</c:if> />
									<p id="info" class="text_blue f11 mt5"></p></td>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>"
									alt="" /> <%=BizboxAMessage.getMessage("TX000016288","메일 아이디")%></th>
								<td><input type="text" id="emailAddr" name="emailAddr"
									value="${infoMap.emailAddr}"
									onkeyup="checkEmailId(this.value);"
									onchange="checkEmailId(this.value);" style="width: 216px;"
									<c:if test="${infoMap.empSeq != null}">disabled</c:if> />
									<p id="email_info" class="text_blue f11 mt5"></p></td>
							</tr>
							<tr>
								<th rowspan="4"><img
									src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>"
									alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
								<td><input type="text" style="width: 210px;" id="empName"
									name="empName" value="${infoMap.empName}" /></td>
								<th><%=BizboxAMessage.getMessage("TX000000081","성별")%></th>
								<td><input type="radio" id="man" name="genderCode"
									value="M" class="k-radio" checked="checked" /> <label
									class="k-radio-label radioSel" for="man"><%=BizboxAMessage.getMessage("TX000007648","남자")%></label> <input
									type="radio" class="k-radio" id="girl" name="genderCode"
									value="F"
									<c:if test="${infoMap.genderCode == 'F'}">checked</c:if> /> <label
									class="k-radio-label radioSel ml10" for="girl"><%=BizboxAMessage.getMessage("TX000007647","여자")%></label></td>
							</tr>

							<tr>
								<th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
								<td><input type="text" style="width: 210px" id="empNameEn" name="empNameEn" value="${infoMap.empNameEn}" /></td>
								<th><c:if test="${infoMap.empSeq eq NULL}">
										<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									</c:if><%=BizboxAMessage.getMessage("TX000015416","로그인 비밀번호")%></th>
								<td>
									<c:if test="${buildType eq 'cloud' and infoMap.empSeq ne NULL}">
										<div id="" class="controll_btn p0">
											<button id="" onclick="fn_pwdPop('def');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
										</div>
									</c:if>
									<c:if test="${buildType ne 'cloud' or infoMap.empSeq eq NULL}">
										<input autocomplete="new-password" type="password" id="loginPasswdNew" name="loginPasswdNew" style="width: 216px;" />
										<input type="hidden" name="loginPasswd" value="" />
									</c:if>
									
								</td>
							</tr>

							<tr>
								<th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
								<td><input type="text" style="width: 210px" id="empNameJp" name="empNameJp" value="${infoMap.empNameJp}" /></td>
								<th><c:if test="${infoMap.empSeq eq NULL}">
									</c:if><%=BizboxAMessage.getMessage("TX000015415","결재 비밀번호")%></th>
								<td>
									<c:if test="${buildType eq 'cloud' and infoMap.empSeq ne NULL}">
										<div id="" class="controll_btn p0">
											<button id="" onclick="fn_pwdPop('app');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
										</div>
									</c:if>
									<c:if test="${buildType ne 'cloud' or infoMap.empSeq eq NULL}">
										<input autocomplete="new-password" type="password" id="apprPasswdNew" name="apprPasswdNew" style="width: 216px;" /> 
										<input type="hidden" id="apprPasswd" name="apprPasswd" value="" />
									</c:if>									
								</td>
							</tr>

							<tr>
								<th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
								<td><input type="text" style="width: 210px" id="empNameCn" name="empNameCn" value="${infoMap.empNameCn}" /></td>
								<th><c:if test="${infoMap.empSeq eq NULL}">
									</c:if><%=BizboxAMessage.getMessage("TX000016355","급여 비밀번호")%></th>
								<td>
									<c:if test="${buildType eq 'cloud' and infoMap.empSeq ne NULL}">
										<div id="" class="controll_btn p0">
											<button id="" onclick="fn_pwdPop('pay');"><%=BizboxAMessage.getMessage("TX000003226","변경")%></button>
										</div>
									</c:if>
									<c:if test="${buildType ne 'cloud' or infoMap.empSeq eq NULL}">
										<input autocomplete="new-password" type="password" id="payPasswdNew" name="payPasswdNew" style="width: 216px;" /> 
										<input type="hidden" id="payPasswd" name="payPasswd" value="" />
									</c:if>
								</td>
							</tr>

							<tr>
								<th colspan="2"><img
                                    src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /><%=BizboxAMessage.getMessage("TX000000098","부서")%> </th>
								<td colspan="3"><input type="text" id="deptName_1"
									value="${infoMap.deptName}" style="width: 210px;"
									readonly="readonly" /> <input id="deptSeqNew" name="deptSeqNew"
									type="hidden" value="${infoMap.deptSeq}" />
									<div class="controll_btn p0">
										<button class="findDeptBtn" id='btnSearch_1'
											onclick="fnSearch(this)"><%=BizboxAMessage.getMessage("TX000001702","찾기")%></button>
									</div>
									<div class="f11 pt6" id="deptPath"></div>
									</td>
							</tr>
							
							<tr>
								<th colspan="2">
									<%=BizboxAMessage.getMessage("TX000000088","담당업무")%>
								</th>
								<td colspan="3">
									<input type="text" id="mainWork" name="mainWork" value="${infoMap.mainWork}" />
								</td>
							</tr>		
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000020288","개인메일")%></th>
								<td colspan="3">									
									<input type="text" value="" style="width:100px;" id="outEmail" name="outEmail"/>
									@
									<input type="text" value="" style="width:88px;" id="outDomainText" name="outDomainText"/>
									<select id="outDomain" name="outDomain">
										<option value="" selected ><%=BizboxAMessage.getMessage("TX000001021","직접입력")%></option>
										<option value="naver.com">naver.com</option>
										<option value="hanmail.net">hanmail.net</option>
										<option value="nate.com">nate.com</option>
										<option value="gmail.com">gmail.com</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="lycos.co.kr">lycos.co.kr</option>
										<option value="empal.com">empal.com</option>
										<option value="dreamwiz.com">dreamwiz.com</option>
										<option value="korea.com">korea.com</option>
									</select>
								</td>
							</tr>					
							<tr>
								<th colspan="2">
									<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000000099","직급")%>
								</th>
								<td>
									<input id="positionCode" name="positionCode" style="width: 216px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
								</td>
								<th>
									<img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000000105","직책")%>
								</th>
								<td>
									<input id="dutyCode" name="dutyCode" style="width: 216px;" placeholder="<%=BizboxAMessage.getMessage("TX000000265","선택")%>" />
								</td>
							</tr>

							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000016136","전화번호(회사)")%></th>
								<td><input type="text" id="tel_company"
									style="width: 120px;" id="telNum" name="telNum"
									value="${infoMap.telNum}" /></td>
								<th><%=BizboxAMessage.getMessage("TX000004107","전화번호(집)")%></th>
								<td><input type="text" id="tel_house" id="homeTelNum"
									name="homeTelNum" value="${infoMap.homeTelNum}"
									style="width: 120px;" /></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
								<td><input type="text" id="mobileTelNum"
									name="mobileTelNum" value="${infoMap.mobileTelNum}"
									style="width: 120px;" /></td>
								<th><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
								<td><input type="text" id="fax" id="faxNum" name="faxNum"
									value="${infoMap.faxNum}" style="width: 120px;" /></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000004110","주소(집)")%></th>
								<td colspan="3" class="pd6"><input type="text" id="zipCode"
									name="zipCode" style="width: 88px;" value="${infoMap.zipCode}" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="우편번호"</c:if>>
									<div class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if>>
										<button id="btnZip" class="saveBtn" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
									</div>

									<div class="mt5">
										<input class="mr5" type="text" id="addr" name="addr"
											value="${infoMap.addr}" style="float: left; width: 40%;" /> <input
											type="text" id="detailAddr" name="detailAddr"
											value="${infoMap.detailAddr}"
											style="float: left; width: 55%;" />
									</div></td>
							</tr>

							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000004113","주소(회사)")%></th>
								<td colspan="3" class="pd6"><input type="text"
									id="deptZipCode" name="deptZipCode"
									style="width: 88px;" value="${infoMap.deptZipCode }" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="우편번호"</c:if>/> 
									<div class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if>>
										<button id="btnCompZip" onclick="fnZipPop(this);"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
									</div>
									<div class="mt5">
										<input class="mr5" type="text" id="deptAddr" name="deptAddr"
											value="${infoMap.deptAddr}" style="float: left; width: 40%;" />
										<input type="text" id="deptDetailAddr" name="deptDetailAddr"
											value="${infoMap.deptDetailAddr}"
											style="float: left; width: 55%;" />
									</div></td>
							</tr>

							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000083","생년월일")%></th>
								<td>
									<select id="lunarYn" name="lunarYn" style="width: 70px;" onchange="setLunar();">
										<option value=""><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>
										<option value="Y" <c:if test="${'Y' == infoMap.lunarYn}">selected</c:if>><%=BizboxAMessage.getMessage("TX000005617","양력")%></option>
										<option value="N" <c:if test="${'N' == infoMap.lunarYn}">selected</c:if>><%=BizboxAMessage.getMessage("TX000005616","음력")%></option>
									</select> 
									<span id="sp_3">
										<input id="bday" name="bday" value="${infoMap.bday}" class="dpWid" />
									</span>									
								</td>
								<th><%=BizboxAMessage.getMessage("TX000003963","결혼기념일")%></th>
								<td>
									<select id="weddingYn" name="weddingYn" style="width: 70px;" onchange="setWedding();">
										<option value=""><%=BizboxAMessage.getMessage("TX000000265","선택")%></option>
										<option value="N" <c:if test="${'N' == infoMap.weddingYn}">selected</c:if>><%=BizboxAMessage.getMessage("TX000006273","미혼")%></option>
										<option value="Y" <c:if test="${'Y' == infoMap.weddingYn}">selected</c:if>><%=BizboxAMessage.getMessage("TX000006272","기혼")%></option>
									</select> 
									<span id="sp_2">
										<input id="weddingDay" name="weddingDay" value="${infoMap.weddingDay}" class="dpWid" />
									</span>
								</td>
							</tr>
						</table>
					</div>
				</div>
			</div>


			<!-- 근태정보 -->
			<p class="tit_p mt20" style="clear: both;"><%=BizboxAMessage.getMessage("TX000005117","근태정보")%></p>
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="153" />
						<col width="326" />
						<col width="133" />
						<col width="" />
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000110","입사일")%></th>
						<td><input id="joinDay" name="joinDay"
							value="${infoMap.joinDay}" class="dpWid" style="width:;" /></td>
						<th><%=BizboxAMessage.getMessage("TX000016143","재직정보")%></th>
						<td><input type="radio" name="workStatus" id="jj_radi1"
							value="999" class="k-radio" checked="checked"
							onclick="checkWorkStatus();" /> <label
							class="k-radio-label radioSel" for="jj_radi1"><%=BizboxAMessage.getMessage("TX000010068","재직")%></label> <input
							type="radio" name="workStatus" id="jj_radi3" value="004"
							class="k-radio"
							<c:if test="${infoMap.workStatus == '004'}">checked</c:if>
							onclick="checkWorkStatus();" /> <label
							class="k-radio-label radioSel ml10" for="jj_radi3"><%=BizboxAMessage.getMessage("TX000010067","휴직")%></label> <input
							type="radio" name="workStatus" id="jj_radi2" value="001"
							class="k-radio"
							<c:if test="${infoMap.workStatus == '001'}">checked</c:if>
							onclick="checkWorkStatus();" /> <label
							class="k-radio-label radioSel ml10" for="jj_radi2"><%=BizboxAMessage.getMessage("TX000008312","퇴직")%></label> <span
							id="sp_1"><input id="resignDay" name="resignDay"
								value="${infoMap.resignDay}" class="dpWid ml10" /></span></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016121","직무유형")%></th>
						<td><select id="jobCode" name="jobCode" style="width: 296px;" /></td>
						<th><%=BizboxAMessage.getMessage("TX000004789","고용형태")%></th>
						<td><select id="statusCode" name="statusCode" style="width: 296px;" /></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016356","근태사용")%></th>
						<td><input type="radio" name="checkWork" id="sy_radi1" value="Y" 
						    <c:if test="${erpMap.checkWorkYn == 'Y' || erpMap.checkWorkYn eq null}">checked</c:if> class="k-radio" onclick="checkWorkYn(this)" /> 
						    <label	class="k-radio-label radioSel" for="sy_radi1"><%=BizboxAMessage.getMessage("TX000006211","적용")%></label> 
							<input type="radio" name="checkWork" id="sy_radi2" class="k-radio" value="N"
							<c:if test="${erpMap.checkWorkYn == 'N'}">checked</c:if> onclick="checkWorkYn(this)"/> 
							<label	class="k-radio-label radioSel ml10" for="sy_radi2"><%=BizboxAMessage.getMessage("TX000006212","미적용")%></label></td>
						<th style="display: none;"><%=BizboxAMessage.getMessage("TX000003830","근무조")%></th>
						<td style="display: none;"><select name="work_team" id="work_team" style="width: 296px;" /></td>
						
						
						<th><%=BizboxAMessage.getMessage("TX000001013","증명서")%></th>
						<td>
							<div class="controll_btn p0 fl ml5">
								<button onclick="fnCerpPop();" id="btnCertPop"><%=BizboxAMessage.getMessage("TX000005917","신청")%></button>
							</div>
						</td>
					</tr>
				</table>
			</div>














			<!-- 권한정보 -->
			<p class="tit_p mt20" style="clear: both;"><%=BizboxAMessage.getMessage("TX000016372","권한정보")%></p>
			<div class="fl" style="width: 49%;">
				<div class="com_ta4">
					<table>
						<colgroup>
							<col width="34" />
							<col width="" />
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
							</tr>
						</thead>
					</table>
				</div>

				<div class="com_ta4 scroll_y_on bgtable3" style="height: 184px;">
					<table>
						<colgroup>
							<col width="34" />
							<col width="" />
						</colgroup>
						<tbody id="authListBody">
						<tbody>
					</table>
				</div>
			</div>

			<div class="fr" style="width: 49%;">
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="130" />
							<col width="" />
						</colgroup>
						<tr>
							<th class="cen"><%=BizboxAMessage.getMessage("TX000001543","설정항목")%></th>
							<th class="cen brrn"><%=BizboxAMessage.getMessage("TX000000217","설정값")%></th>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></th>

							<td class="le">
								<input type="hidden" id="erpCompSeq" name="erpCompSeq" value="${erpMap.erpCompSeq}"/>
								<input type="text" id="erpEmpNum" name="erpEmpNum" value="${erpMap.erpEmpSeq}" class="fl" style="width: 200px;" />
								<div class="controll_btn p0 fl ml5">
									<button onclick="fnErpEmpPop();"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
								</div></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000017941","라이선스")%></th>
							<td class="le"><select id="licenseCheckYn" name="licenseCheckYn" style="width: 200px;" onchange="fnLicenseChange(this);" onload="fnLicenseChange(this);">
							<option value="1" <c:if test="${infoMap.licenseCheckYn == '1' or infoMap.licenseCheckYn == 'null'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></option>
							<option value="2" <c:if test="${infoMap.licenseCheckYn == '2'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000000262","메일")%></option>
							<option value="3" <c:if test="${infoMap.licenseCheckYn == '3'}">selected</c:if> ><%=BizboxAMessage.getMessage("TX000017901","비라이선스")%></option>
							</select>
							</td>
				
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000090","사용언어")%></th>
							<td class="le"><select id="nativeLangCode" name="nativeLangCode">
								<c:forEach items="${langList}" var="list">
									<option value="${list.detailCode}"
										<c:if test="${list.detailCode == infoMap.nativeLangCode}">selected</c:if>>${list.detailName}</option>
								</c:forEach>
							</select></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016293","메신저 사용")%></th>
							<td class="le"><input type="radio" id="messengerUseYn"
								name="messengerUseYn" value="Y" class="k-radio"
								checked="checked" /> <label class="k-radio-label radioSel"
								for="messengerUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> <input type="radio"
								name="messengerUseYn" value="N" id="ms_radi2" class="k-radio"
								<c:if test="${infoMap.messengerUseYn == 'N'}">checked</c:if> />
								<label class="k-radio-label radioSel ml10" for="ms_radi2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016283","모바일 사용")%></th>
							<td class="le"><input type="radio" id="mobileUseYn"
								name="mobileUseYn" value="Y" class="k-radio" checked="checked" />
								<label class="k-radio-label radioSel" for="mobileUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
								<input type="radio" id="mo_radi2" class="k-radio"
								name="mobileUseYn" value="N"
								<c:if test="${infoMap.mobileUseYn == 'N'}">checked</c:if> /> <label
								class="k-radio-label radioSel ml10" for="mo_radi2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
							</td>
						</tr>
							<input type="hidden" id="orgchartDisplayYn" name="orgchartDisplayYn" value="${infoMap.orgchartDisplayYn}"/>
							<input type="hidden" id="messengerDisplayYn" name="messengerDisplayYn" value="${infoMap.messengerDisplayYn}"/>
					</table>
				</div>
			</div>
		</div>
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnsave();" /> <input
					type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
		<!-- //pop_foot -->

		<script>
				
		
				function fn_pwdPop(type){
					url = "/gw/uat/uia/passwordCheckPop.do?type=" + type + "&pageInfo=empInfoPop&empSeq=" + $("#empSeq").val() + "&passwdStatusCode=${infoMap.passwdStatusCode}";
					var w = 685;
					var h = 405;
					var left = (screen.width/2)-(w/2);
					var top = (screen.height/2)-(h/2);
					var pop = window.open(url, "popup_window", "width=" + w +",height=" + h + ", left=" + left + ", top=" + top + "");
		    	}
				
                function fnSearch(e){
                    // 회사선택 없을시 부서선택창 안뜨도록 
    	        	if($("#compSeq").val() == ""){
    	        		alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
    	        		return;
    	        	}
                    var compSeq = $("#compSeq").val();
		       		var empSeq = $("#empSeq").val(); 
		       		var deptSeq =  $("#deptSeq").val();
		       		empDeptInfoPop(compSeq,deptSeq,empSeq);
                }
                
                function fn_picImgDel()
            	{
        			document.getElementById('picFileIdNew').value = '';
           			var picFileImg = document.getElementById('img_picFileIdNew');
           			picFileImg.src = "${pageContext.request.contextPath}/Images/bg/mypage_noimg.png";
           			$("#Delbtn_pic").hide();
           			$("#picTxt").show();
           			
           			$("#p_File").html("");
        			var innerHTML = "<input type='file' id='picFileId_New' class='hidden_file_add' name='picFileIdNew' onchange='profileImgUpload(this);'/>";
        			$("#p_File").html(innerHTML);
            		return false;
            	}
            	
            	function fn_signImgDel()
            	{
           			$("#Delbtn_sign").hide();
           			$("#signTxt").show();
           			
           			$("#p_File2").html("");
        			var innerHTML = "<input type='file' id='signFileId_New' class='hidden_file_add2' name='signFileIdNew' onchange='signImgUpload(this);'/>";
        			$("#p_File2").html(innerHTML);
            		
        			if("${eaType}" == "eap") {
        				$("#img_signFileIdNew").css("display", "none");
        				if(signType == "img") {
                			$("#signTypeClass").show();
                			$("#signTypeClass").attr("class", "stamp_de_div");
                			$("#signName").text($("#empName").val());
                			$("#signStamp").hide();
                			$("#signTxt").hide();
                			signImgFlag = false;
                			signType = "stamp_de_div";
                			
                		} else {
                			if(signType == "stamp_de_div") {
                				$("#signStamp").hide();	
                			} else {
                				$("#signStamp").show();
                			}
                			
                		}
        			} else {
        				var picSignImg = document.getElementById('img_signFileIdNew');
               			picSignImg.src = "${pageContext.request.contextPath}/Images/bg/sign_noimg.png";
        				document.getElementById('signFileIdNew').value = '';
        			}
        			
        			return false;
            	}


	            $(document).ready(function() {
	            	$(".deptInfoBtn").kendoButton({
		       			 click: function(e) {
		       				var compSeq = $("#compSeq").val();
		       				var empSeq = $("#empSeq").val();
		       				var deptSeq = e.event.target.value;
		       				empDeptInfoPop(compSeq, deptSeq, empSeq, e.id);
		       			 }
		       		 });
	            	
	            	$(".removeDeptBtn").kendoButton({
		       			 click: function(e) {
		       				var compSeq = $("#compSeq").val();
		       				var empSeq = $("#empSeq").val();
		       				var deptSeq = e.event.target.value;
		       				var con = confirm("<%=BizboxAMessage.getMessage("TX000010712","겸직정보를 삭제하시겠습니까?")%>");
		       				if (con) {
		       					removeEmpDept(compSeq, deptSeq, empSeq);
		       				}
		       			 }
		       		 });
	            	
	            	var validator = $("#basicForm").kendoValidator().data("kendoValidator");
	            	
	            	if($("#empSeq").val() != ""){
	            		$("#compCheckImg").hide(); 
	            	}
	            		
	            	 $("basicForm").submit(function(event) {
	                        event.preventDefault();
	                        if (validator.validate()) {
	                            status.text("Hooray! Your tickets has been booked!")
	                                .removeClass("invalid")
	                                .addClass("valid");
	                        } else {
	                            status.text("Oops! There is invalid data in the form.")
	                                .removeClass("valid")
	                                .addClass("invalid");
	                        }
	                    });

	            	  
	            	 $("#bday").kendoDatePicker({format: "yyyy-MM-dd"});
	            	 $("#weddingDay").kendoDatePicker({format: "yyyy-MM-dd"});
	            	 $("#joinDay").kendoDatePicker({format: "yyyy-MM-dd"});
	            	 $("#resignDay").kendoDatePicker({format: "yyyy-MM-dd"});
	            	 
	            	 
	            	 checkWorkStatus();	
	            	 
	            	 if($("#joinDay").val() == "0000-00-00")
	                 	$("#joinDay").val("");
	                 if($("#weddingDay").val() == "0000-00-00")
	                 	$("#weddingDay").val("");
	                 if($("#weddingYn").val() == "N" || $("#weddingYn").val() == ""){
	                 	$('#weddingDay').data('kendoDatePicker').enable(false);
	                 	$("#weddingDay").val("");
	                 	$("#sp_2").hide();
	                 }        	
	                 if($("#lunarYn").val() == ""){
	                 	$('#bday').data('kendoDatePicker').enable(false);
	                 	$("#bday").val("");
	                 	$("#sp_3").hide();
		              } 
	                 if($("#bday").val() == "0000-00-00")
	                 	$("#bday").val("");
	                 if($("#resignDay").val() == "0000-00-00")
	                 	$("#resignDay").val("");
	                 
	                 if("${infoMap.picFileId}" == ""){
	                	 $("#Delbtn_pic").hide();
	                	 $("#picTxt").show();
	                 }	                 
	                 if("${infoMap.signFileId}" == ""){
	                	 if("${eaType}" == "eap"){ 
	                	 
	                		 if(signType == "") {
	                			 $("#Delbtn_sign").hide();
			                	 $("#signTxt").show();	 
	                		 } else if(signType != "img") {
	                			 $("#Delbtn_sign").hide();
			                	 $("#signTxt").hide();
	                		 } else {
	                			 $("#Delbtn_sign").hide();
			                	 $("#signTxt").show();
	                		 }
	                	 } else {
	                		 $("#Delbtn_sign").hide();
		                	 $("#signTxt").show();
	                	 }
	                 }
	                 
	                 $("#bday").attr("readonly", true);
	            	 $("#weddingDay").attr("readonly", true);
	            	 $("#joinDay").attr("readonly", true);
	            	 $("#resignDay").attr("readonly", true);	 
	            
	            	 

	            	 if("${infoMap.workStatus}" == "001"){
	            		 if("${infoMap.mailDelYn}" == "Y"){
	            			 $("#emailAddr").val("");
	            		 }
	            	 }
	            });
	            
	            
	       var dataSource = new kendo.data.DataSource({
	            	data : ${authList},
	                batch: true,
	                schema: {
	                    model: {
	                        id: "authorCode",
	                        fields: {
	                        	authorNm: { editable: false, nullable: true },
	                        	codeType: { editable: false, nullable: true },
	                        	authorBaseYn: { editable: false, nullable: true}
	                        }
	                    }
	                   
	                }
	        });

	        $("#authGrid").kendoGrid({
	            dataSource: dataSource,
	            pageable: false,
	            columns: [  
	                { field: "authorNm", title: "<%=BizboxAMessage.getMessage("TX000000136","권한명")%>", width: "180px" },
	                { field: "codeTypeName", title:"<%=BizboxAMessage.getMessage("TX000006303","권한구분")%>", width: "120px"},
	                { field: "authorBaseYn", title:"<%=BizboxAMessage.getMessage("TX000006305","기본부여여부")%>", width: "120px", template: "#= authorBaseYn ? '<%=BizboxAMessage.getMessage("TX000002850","예")%>' : '-' #"  }], 
	            refresh:true
	        });

	        $("#weddingYn").kendoDropDownList();
	        $("#lunarYn").kendoDropDownList();
	        
	        function fnsave(){
	        
	        	if("${eaType}" == "eap") {
					$("#signType").val(signType);
				}
	        	
	        	if($("#compSeq").val() == ""){
	        		alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
	        		$("input[name=compSeq_input]").focus();
	        		return false;
	        	}
	        		
	        	
	        	else if($("#loginId").val() == ""){
	        		alert("<%=BizboxAMessage.getMessage("TX000010717","아이디를 입력해 주세요")%>");
	        		$("#loginId").focus();
	        		return false;
	        	}
	        		
	        	
	        	else if(!ID_check){
	        		alert("<%=BizboxAMessage.getMessage("TX000016183","아이디를 확인해 주세요.")%>");	        		
	        		return false;
	        	}
	        		
	        	else if(!Email_check){
	        		alert("<%=BizboxAMessage.getMessage("TX000010711","이메일을 확인해 주세요")%>");
	        		return false;
	        	}
	        		
	        	<c:if test="${infoMap.empSeq == null}">
	        	else if($("#emailAddr").val() == ""){
	        		alert("<%=BizboxAMessage.getMessage("TX000010710","메일 아이디를 입력해 주세요")%>");
	        		$("#emailAddr").focus();
	        		return false;
	        	}
	        	</c:if>
	        		
	        	
	        	else if($("#empName").val() == ""){
	        		alert("<%=BizboxAMessage.getMessage("TX000010709","이름을 입력해 주세요")%>");
	        		$("#empName").focus();
	        		return false;
	        	}	        		
	        	
	        	else if("${infoMap.empSeq}" == "" || "${infoMap.empSeq}" == null){
	        		if($("#loginPasswdNew").val() == ""){
	        			alert("<%=BizboxAMessage.getMessage("TX000002641","비밀번호를 입력해 주세요")%>");
	        			$("#loginPasswdNew").focus();
	        			return false;
	        		}	
	        		
	        		/*
	        		else if($("#apprPasswdNew").val() == ""){
		        		alert("<%=BizboxAMessage.getMessage("TX000010708","결재비밀번호를 입력해 주세요")%>");
		        		$("#apprPasswdNew").focus();
		        		return false;
		        	}	
	        		
		        	else if($("#payPasswdNew").val() == ""){
		        		alert("<%=BizboxAMessage.getMessage("TX000010707","급여비밀번호를 입력해 주세요")%>");
		        		$("#payPasswdNew").focus();
		        		return false;
		        	}
	        		*/
	        		
	        	}
	        	
	        	if($("#deptSeq").val() == "" || $("#deptName_1").val() == ""){
                    alert("<%=BizboxAMessage.getMessage("TX000004739","부서를 선택해 주세요")%>");
                    $("#deptName_1").focus();
                    return false;
                }
	        		
 	        	if($("#positionCode").val() == ""){
 	        		alert("<%=BizboxAMessage.getMessage("TX000010706","직급을 선택해 주세요")%>");
 	        		$("input[name=positionCode_input]").focus();
 	        		return false;
 	        	}
	        		
 	        	if($("#dutyCode").val() == ""){
 	        		alert("<%=BizboxAMessage.getMessage("TX000010705","직책을 선택해 주세요")%>");
 	        		$("input[name=dutyCode_input]").focus();
 	        		return false;
 	        	}
 	        	
 	    		//담당업무 길이제한
 	    		if($("#mainWork").val().length > 128){
 					alert("<%=BizboxAMessage.getMessage("TX900000290","담당업무 최대길이는 128입니다.")%>");
 					$("#mainWork").focus();
 					return false;
 	    		} 	        	
	        	
        		var isModify = '${infoMap.empSeq}';
        		var fnMsg = '';
        		if(!isModify){
        			if(document.getElementById("jj_radi2").checked){       		    	
       		    		alert('<%=BizboxAMessage.getMessage("TX900000450","퇴직으로 입사처리 할 수 없습니다.")%>');
       		    		return;	       		    	
        			}
        			
        			if(confirm('<%=BizboxAMessage.getMessage("TX000010704","입사처리를 완료 하시겠습니까?")%>')){
                        
                    }else{
                        return;
                    }
        		}
        		
        		$("#mobileUseYn").attr("disabled", false);
				$("#mo_radi2").attr("disabled", false);
				$("#messengerUseYn").attr("disabled", false);
				$("#ms_radi2").attr("disabled", false);
				$("#useYn").attr("disabled", false);
				$("#useN").attr("disabled", false);
				
				$("#loginId").val($("#loginId").val().replace(/ /gi,""));
				$("#emailAddr").val($("#emailAddr").val().replace(/ /gi,""));
				
				if($("#mainCompSeq").val() == "")
       				$("#mainCompSeq").val($("#compSeq").val());
				
       			//if(confirm(fnMsg)){
       				if($("#weddingYn").val() != "Y"){
           				$("#weddingDay").val("");
           			}
       				
       			var sAuthCodeList = "";
       		       	
       		     $( 'input[name=all_chk]' ).each( function() {
       		    	 var target = "authorCode" + $(this).attr("id").replace("all_chk","");
       		    	 if($(this).is(":checked")){
       		    			sAuthCodeList += ","+$("#" + target).val();
       		    	 }
       		     });
       		       	
       		       	sAuthCodeList = sAuthCodeList.substring(1);
       		       	$("#authCodeList").val(sAuthCodeList);
       				       		       	
       		       	var params = {};
       		     	$("#compSeq").data("kendoComboBox").enable(true);
       		       	state(1);
       		       	
       		       
       		       	
	       		     if(document.getElementById("jj_radi2").checked && "${infoMap.workStatus}" != "001"){	       		    	
	       		    	if(confirm('<%=BizboxAMessage.getMessage("TX900000452","퇴직을 선택 하였습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000451","사용자를 퇴사처리 하시겠습니까?")%>')){
	       		    		var compNm = $("#compSeq").data("kendoComboBox").text();
	       					var compSeq = $("#compSeq").data("kendoComboBox").value();
	       					var deptNm = $("#deptName_1").val();
	       					var deptSeq = $("#deptSeqNew").val();
	       					var loginId = $("#loginId").val();
	       					var empNm = $("#empName").val();
	       					var dutyCodeNm = $("#dutyCode").data("kendoComboBox").text();
	       					var positionCodeNm = $("#positionCode").data("kendoComboBox").text();
	       					var empSeq = $("#empSeq").val();
	       					var groupSeq = $("#groupSeq").val();
	       					var resignDay = kendo.toString(kendo.parseDate($('#resignDay').data('kendoDatePicker').value()), 'yyyy-MM-dd');
	       					if(resignDay == null)
	       						resignDay = "";
	       					var isEmpPop = "Y";
	       					
	       					
	       					
	       					window.open("", "empResignPop", "width=950,height=581,scrollbars=yes") ;		         
	       			        var frmData = document.empResignPop ;		        
	       			        
	       					$('input[name="compSeq"]').val(compSeq);
	       					$('input[name="compNm"]').val(compNm);
	       					$('input[name="deptNm"]').val(deptNm);
	       					$('input[name="deptSeq"]').val(deptSeq);
	       					$('input[name="groupSeq"]').val(groupSeq);
	       					$('input[name="loginId"]').val(loginId);
	       					$('input[name="empNm"]').val(empNm);
	       					$('input[name="dutyCodeNm"]').val(dutyCodeNm);
	       					$('input[name="positionCodeNm"]').val(positionCodeNm);
	       					$('input[name="empSeq"]').val(empSeq);
	       					$('input[name="resignDay"]').val(resignDay);
	       					$('input[name="isEmpPop"]').val(isEmpPop);
	       					
	       					frmData.submit();
	       					
		       		  		var timer = setInterval(function() { 
			       		  	    if(pop.closed) {
			       		  	        clearInterval(timer);
			       		  	   		state(0);
			       		  	    }
	       		  			}, 500);
	       		  	    	
	       		    	}else{
	       		    		state(0);
	       		    	}
	       		    	return;
	       		     }
       		       	
       		        //var getMailCode = setMailId("createUser.do","메일 ID 생성", params);
       		        
           			//document.basicForm.submit();
       				if(document.getElementById("jj_radi2").checked){
	 	        		$('#orgchartDisplayYn').val("N");
	 	        		$('#messengerDisplayYn').val("N");
	 	        	}
       				
       				// disabled 처리 풀어주기
	         		if(erpOptions != "N") {
	         			$("#lunarYn").kendoDropDownList({enable:true});
	         			$("#weddingYn").kendoDropDownList({enable:true});
	         			
	         			$("#bday").removeAttr("disabled");
						$("#weddingDay").removeAttr("disabled");
						$("#tel_house").removeAttr("disabled");
						$("#mobileTelNum").removeAttr("disabled");
						$("#zipCode").removeAttr("disabled");
						$("#detailAddr").removeAttr("disabled");
						$("#addr").removeAttr("disabled");
						$("#btnZip").removeAttr("disabled");
						$("#empName").removeAttr("disabled");
						$("#empNameEn").removeAttr("disabled");
						$("#empNameCn").removeAttr("disabled");
						$("#empNameJp").removeAttr("disabled");
	         		}
       				     				
	 	        	
	         		var parameter = $("#basicForm").serialize();
	         		
					if($("#loginPasswdNew").val() == ""){
						parameter = parameter.replace("&loginPasswd=", "");
       				}
					
					if($("#apprPasswdNew").val() == ""){
						parameter = parameter.replace("&apprPasswd=", "");
       				} 
					
					if($("#payPasswdNew").val() == ""){
						parameter = parameter.replace("&payPasswd=", "");
       				} 
	         		
	         		// ERP 조직도 사용 여부
	         		if(ERPUpdateYN == "Y") {
	         			// asd, ,asd, ,asd,
	         			var items = updateItem.split(',');
	         			var realItem = '';
	         			$.each(items, function(idx, item){
	         				
	         				item = item.replace(/ /g, '');
	         				if(item){
	         					realItem += (', ' + item);
	         				}
	         			});
	         			realItem = realItem.substring(1);
	         			
	         			if(realItem != "" && erpType == "iCUBE"){
	         				alert("<%=BizboxAMessage.getMessage("TX900000453","ERP 조직도 연동 사용으로 변경 정보를 ERP에 반영합니다.")%>\n[" + realItem + " ]");	
	         			}
	         			
	         		}				

	         		
	         		$.ajax({
			            type: "post",
			            url: "empInfoSaveProc.do",
			            datatype: "text",
			            async:false,
			            data: parameter,
			            success: function (data) {
							if(data.resultCode == "fail") {
								alert(data.result);
								self.close();
								return;
							} else {
								insertEdmsAuth(data);
							}
			            },
			            error: function (e) {	//error : function(xhr, status, error) {
			            	alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
			            }
			        });	
	         		
	        }
	        
	        document.onfocus = state(0);
	        
	        function setRelease(){
	        	state(0);
	        }
	        
	        function insertEdmsAuth(resultMap){
	        	
	        	if($("#picFileId_New").val() != ""){
					var formData = new FormData();
	   	 			var pic = $("#picFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "910");	//이미지 폴더
	   	 			formData.append("relativePath", ""); // 상대 경로
	   	 			formData.append("empSeq", resultMap.empSeq);
	   	 			formData.append("imgSeq", "profile");
	    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 async:false,
	   	                 // cache: false,
	   	                 processData: false,
	   	                 contentType: false,
	   	                 success: function(data) {
	   	                		$("#picFileIdNew").val(data.fileId);
// 								alert("성공");								
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
			
	        	if($("#signFileId_New").val() != ""){
					var formData = new FormData();
	   	 			var pic = $("#signFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "900");	//이미지 폴더
	   	 			formData.append("relativePath", "photo"); // 상대 경로
	   	 			formData.append("empSeq", resultMap.empSeq);	
	   	 			formData.append("imgSeq", "sign");	   	 			
		    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 // cache: false,
	   	                 processData: false,
	   	                 contentType: false,
	   	              	 async:false,
	   	                 success: function(data) {
								$("#signFileIdNew").val(data.fileId);								
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
	        	
	        	
				if($("#signFileId_New").val() != "" && "${eaType}" == "eap" && signImgFlag){
					var formData = new FormData();
	   	 			var pic = $("#signFileId_New")[0];
	    				
	   	 			formData.append("file", pic.files[0]);
	   	 			formData.append("pathSeq", "900");	//이미지 폴더
	   	 			formData.append("relativePath", "photo"); // 상대 경로
	   	 			formData.append("empSeq", resultMap.empSeq);	
	   	 			formData.append("imgSeq", "sign");	   	 			
		    				 
	   	 			$.ajax({
	   	                 url: _g_contextPath_ + "/cmm/file/fileUploadProc.do",
	   	                 type: "post",
	   	                 dataType: "json",
	   	                 data: formData,
	   	                 // cache: false,
	   	                 processData: false,
	   	                 contentType: false,
	   	              	 async:false,
	   	                 success: function(data) {
								$("#signFileIdNew").val(data.fileId);								
	   	                 },
	   	                 error: function (result) { 
	   	 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	   	 		    			return false;
	   	 		    		}
	   	             });
				}
	        	
	        	alert(resultMap.result);
	        	
	        	if(window.location.protocol.indexOf("https:") == -1){
	        		opener.gridRead();
	        	}
	        	
	        	self.close();
	 			state(0);
	        }
	        
	        function fnclose(){
	        	if(confirm("<%=BizboxAMessage.getMessage("TX000010703","취소 하시겠습니까?")%>")==true){
	        		self.close();
	        	}else{
	        		return;
	        	}
	        }
	        
	        function checkWorkStatus(){
	        	if(!document.getElementById("jj_radi2").checked){
	        		$('#resignDay').data('kendoDatePicker').enable(false);
	        		$('#resignDay').val("");
	        		$("#sp_1").hide();
	        	}
	        	else{
	        		$('#resignDay').data('kendoDatePicker').enable(true);
	        		$("#sp_1").show();
	        		$("#bday").attr("readonly", true);
	            	$("#resignDay").attr("readonly", true);
	        	}

	        }

	        function setPwd(){
	        	if($("#empSeq").val() == "" || $("#empSeq").val() == null){
		        	$("#apprPasswdNew").val($("#loginPasswdNew").val());
		        	$("#apprPasswd").val($("#loginPasswdNew").val());
		        	
		        	$("#payPasswdNew").val($("#loginPasswdNew").val());
		        	$("#apprPasswd").val($("#loginPasswdNew").val());
	        	}
	        }
	        
	        function setEmail(){
		        	$("#apprPasswdNew").val($("#loginPasswdNew").val());
		        	$("#apprPasswd").val($("#loginPasswdNew").val());
		        	
		        	$("#payPasswdNew").val($("#loginPasswdNew").val());
		        	$("#apprPasswd").val($("#loginPasswdNew").val());
	        }
	        
	        
	        function fnZipPop(target) {
	            new daum.Postcode({
	                oncomplete: function(data) {
	                	
	                    var fullAddr = ''; // 최종 주소 변수
	                    var extraAddr = ''; // 조합형 주소 변수

	                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                        fullAddr = data.roadAddress;

	                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                        fullAddr = data.jibunAddress;
	                    }

	                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	                    if(data.userSelectedType === 'R'){
	                        //법정동명이 있을 경우 추가한다.
	                        if(data.bname !== ''){
	                            extraAddr += data.bname;
	                        }
	                        // 건물명이 있을 경우 추가한다.
	                        if(data.buildingName !== ''){
	                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                        }
	                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                        fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                    }

	                    if(target.id == "btnCompZip"){
	    	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	    	                document.getElementById('deptZipCode').value = data.zonecode; //5자리 새우편번호 사용
	    	                document.getElementById('deptAddr').value = fullAddr;
	    	
	    	                // 커서를 상세주소 필드로 이동한다.
	    	                document.getElementById('deptDetailAddr').focus();
	                    }
	                    else{
	                    	// 우편번호와 주소 정보를 해당 필드에 넣는다.
	    	                document.getElementById('zipCode').value = data.zonecode; //5자리 새우편번호 사용
	    	                document.getElementById('addr').value = fullAddr;
	    	
	    	                // 커서를 상세주소 필드로 이동한다.
	    	                document.getElementById('detailAddr').focus();
	                    }
	                }
	            }).open();
	        }
	        
	        function fnErpEmpPop(){
	        	if($("#compSeq").val() == ""){
	        		alert("<%=BizboxAMessage.getMessage("TX000010785","회사를 선택해 주세요")%>");
	        		return false;
        		}
				var compSeq = $("#compSeq").val();
				var urladdr = "<c:url value='/cmm/systemx/ExEmpPop.do'/>?compSeq=" + compSeq + "&searchStr=" + encodeURI($("#empName").val()) + "&groupSeq=" + $("#groupSeq").val()+ "&empSeq=" + $("#empSeq").val();    
		    	openWindow2(urladdr,  "fnErpEmpPop", 340, 560, 0) ;
			}
			
			function setEmpErpNo(no, erpCompSeq){
				$("#erpEmpNum").val(no);
				$("#erpCompSeq").val(erpCompSeq);
			}
	        
			function profileImgUpload(value){
				
				if(value.files && value.files[0]) 
				{
				
					if(value.files[0].type.indexOf("image") > -1){
						
						var reader = new FileReader();

						reader.onload = function (e) {
							$('#img_picFileIdNew').attr('src', e.target.result);
						}
					
						reader.readAsDataURL(value.files[0]);
						
						$("#Delbtn_pic").show();
						$("#picTxt").hide();
						
					}else{
						
				    	var checkExtMsg = "<%=BizboxAMessage.getMessage("TX000010638","이미지 파일이 아닙니다 지원 형식({0})")%>";
				    	checkExtMsg = checkExtMsg.replace("{0}","jpg, jpeg, bmp, gif, png").replace("　","\n");				
						alert(checkExtMsg);
						fn_picImgDel();
						
					}					
				}
			}
			
			
			function signImgUpload(value){
				
				if(value.files && value.files[0]) 
				{
					var reader = new FileReader();

					reader.onload = function (e) {
						$('#img_signFileIdNew').attr('src', e.target.result);
					}
				
					reader.readAsDataURL(value.files[0]);
					
					$("#Delbtn_sign").show();
					$("#signTxt").hide();
				}
			}
			
			
			
			function fnLicenseChange(target){
				if(target != null){
					//사용 type = 메일				
					if(target.value == "2"){
						document.getElementById("mo_radi2").checked =  true;
						document.getElementById("ms_radi2").checked = true;
						$("#mobileUseYn").attr("disabled", true);
						$("#mo_radi2").attr("disabled", true);
						$("#messengerUseYn").attr("disabled", true);
						$("#ms_radi2").attr("disabled", true);
						$("#orgchartDisplayYn").val("N");
						$("#messengerDisplayYn").val("N");
						
						document.getElementById("useYn").checked = true;
						$("#useYn").attr("disabled", false);
						$("#useN").attr("disabled", false);
					}
					//사용 type = 비라이선스
					else if(target.value == "3"){
						alert("라이선스 사용자를 비라이선스로 변경하면 사용하던 메일이 삭제됩니다. 삭제된 메일은 복구 불가능합니다.");
						document.getElementById("mo_radi2").checked = true;
						document.getElementById("ms_radi2").checked = true;
						$("#mobileUseYn").attr("disabled", true);
						$("#mo_radi2").attr("disabled", true);
						$("#messengerUseYn").attr("disabled", true);
						$("#ms_radi2").attr("disabled", true);
						$("#orgchartDisplayYn").val("N");
						$("#messengerDisplayYn").val("N");
						
						document.getElementById("useN").checked = true;
						$("#useYn").attr("disabled", true);
						$("#useN").attr("disabled", true);
					}
					//사용 type = 그룹웨어
					else{
						document.getElementById("mobileUseYn").checked = true;
						document.getElementById("messengerUseYn").checked = true;
						$("#mobileUseYn").attr("disabled", false);
						$("#mo_radi2").attr("disabled", false);
						$("#messengerUseYn").attr("disabled", false);
						$("#ms_radi2").attr("disabled", false);
						$("#orgchartDisplayYn").val("Y");
						$("#messengerDisplayYn").val("Y");
						
						document.getElementById("useYn").checked = true;
						$("#useYn").attr("disabled", false);
						$("#useN").attr("disabled", false);
					}
				}
				else{
					if("${infoMap.licenseCheckYn}" == "2"){
						$("#mobileUseYn").attr("disabled", true);
						$("#mo_radi2").attr("disabled", true);
						$("#messengerUseYn").attr("disabled", true);
						$("#ms_radi2").attr("disabled", true);
						
						$("#useYn").attr("disabled", false);
						$("#useN").attr("disabled", false);
					}
					else if("${infoMap.licenseCheckYn}" == "3"){
						$("#mobileUseYn").attr("disabled", true);
						$("#mo_radi2").attr("disabled", true);
						$("#messengerUseYn").attr("disabled", true);
						$("#ms_radi2").attr("disabled", true);
						
						$("#useYn").attr("disabled", true);
						$("#useN").attr("disabled", true);
					}
					else{
						$("#mobileUseYn").attr("disabled", false);
						$("#mo_radi2").attr("disabled", false);
						$("#messengerUseYn").attr("disabled", false);
						$("#ms_radi2").attr("disabled", false);
						
						$("#useYn").attr("disabled", false);
						$("#useN").attr("disabled", false);
					}
				}
			}
            </script>
    
	</div>
</form>

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="d" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="deptSeq" value="" seq="deptFlag"/>
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="initMode" value="true"/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>



<form id="empResignPop" name="empResignPop" method="post" action="/gw/cmm/systemx/empResignPop.do" target="empResignPop">
  <input name="compSeq" value="" type="hidden"/>
  <input name="compNm" value="" type="hidden"/>
  <input name="deptNm" value="" type="hidden"/>
  <input name="deptSeq" value="" type="hidden"/>
  <input name="groupSeq" value="" type="hidden"/>
  <input name="loginId" value="" type="hidden"/>
  <input name="empNm" value="" type="hidden"/>  
  <input name="dutyCodeNm" value="" type="hidden"/>
  <input name="positionCodeNm" value="" type="hidden"/>
  <input name="empSeq" value="" type="hidden"/>
  <input name="resignDay" value="" type="hidden"/>
  <input name="isEmpPop" value="" type="hidden"/>
</form>   