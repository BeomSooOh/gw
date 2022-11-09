<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<style type="text/css">  
	html {overflow:hidden;}  
</style>


<script type="text/javascript">
	var empSeq = "${params.empSeq}";
	var compSeq = "${params.compSeq}";
	var compNm = "${params.compNm}";
	var deptSeq = "${params.deptSeq}";
	var groupSeq = "${params.groupSeq}";
	var isMailUse = "${isMailUse}";
	var targetBtn;
	var eaType = "${loginVO.eaType}";
	var empDeptList = "";
	
	$(document).ready(function() {		
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			}
		});

		// 퇴사일
	    $("#out_date").kendoDatePicker({
	    	format: "yyyy-MM-dd",
	    	change: function() {
	    		var reSignDay = $("#out_date").data("kendoDatePicker").value();
	    		var toDay = kendo.toString(kendo.parseDate(new Date()));
	    		if(reSignDay > toDay){
	    			alert("<%=BizboxAMessage.getMessage("TX000017943","예약 퇴사처리는 불가합니다.")%>");
	    			var todayDate = kendo.toString(kendo.parseDate(new Date()), 'yyyy-MM-dd');
    	            $("#out_date").data("kendoDatePicker").value(todayDate);
	    		}
	        }
	    });
		
	    $("#out_date").attr("disabled","disabled");


		//기본버튼
          $(".controll_btn button").kendoButton();

          var todayDate = kendo.toString(kendo.parseDate(new Date()), 'yyyy-MM-dd');
          $("#out_date").data("kendoDatePicker").value(todayDate);
          
         // (임시주석 20161211 주성덕)
          $("#prevBtn").hide(); //처음엔 이전 버튼 안보이게
          $("#finishBtn").hide(); //완료버튼 안보이게
          $(".pop_wrap_dir").hide();
          
          if("${params.resignDay}" != "")
        	  $("#out_date").data("kendoDatePicker").value("${params.resignDay}");
          
          initData();
          getEmpDeptList();
          
          if(eaType == "ea"){
          	
          	if("${params.changeDept}" == "Y"){
          	  stepEaDocData("4");
          	  $("#popTitle").html("<%=BizboxAMessage.getMessage("","부서변경")%>");
            }else{
            	$("#popTitle").html("<%=BizboxAMessage.getMessage("TX000004490","퇴사처리")%>");
            }
          }
          

          if(eaType == "eap"){
                     	$("#popTitle").html("퇴사처리");
          }
          
	});
	
	function getEmpDeptList(){
		
		var paramData = {};
		paramData.empSeq = empSeq
		
		$.ajax({
            type:"post",
            url:"getEmpDeptList.do",
            datatype:"json",
            data: paramData,           
            success:function(data){
            	empDeptList = data.empDeptList;
            }
        });
		
	}
	
	function initData(){
		
		var paramData = {};
		paramData.empSeq = empSeq;
        paramData.compSeq = compSeq;
        paramData.deptSeq = deptSeq;
        paramData.groupSeq = groupSeq;
		$.ajax({
            type:"post",
            url:"empResignInitData.do",
            datatype:"json",
            data: paramData,
            success:function(data){
            	if(data){
            		if(data.step2){
            			setStep2Table(data.step2);
            			setAllComp(data.step2);
            			
            			if(data.step2.length == 1){
            				$("#mf1").attr("disabled", true);
            				document.getElementById("mf2").checked = true;            				
            			}
            		}
            		
            		if(data.step6){
                        setStep6Table(data.step6);                        
                    }
            		if(data.step7){
                        setStep7Table(data.step7);                        
                    }
            	}
            },          
            error : function(e){
                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>"); 
            }
        }); 
	}
	
	function setAllComp(dataList){
		var compHtml = '';
		var allCompSeq = "";
		var allCompNm = "";
		for(i = 0; i < dataList.length; i ++){
			compHtml += '<tr>';
	        compHtml += '<td>'+dataList[i].compName+'</td>';
	        compHtml += '<td>'+dataList[i].deptName+'</td>';
	        compHtml += '<td>'+dataList[i].duty_code_name+'</td>';
	        compHtml += '<td>'+dataList[i].position_code_name+'</td>';
	        compHtml += '</tr>';
	        if(allCompSeq.indexOf(","+dataList[i].compSeq+",") == -1){
	        	allCompSeq += "," + dataList[i].compSeq + ",";
	        	allCompNm += "," + dataList[i].compName + ",";
	        }
		}
		
		if(allCompSeq.length > 0){
			allCompSeq = allCompSeq.substring(1);
			allcompSeq = allCompSeq.substring(0,allCompSeq.length-1);
		}
		
		if(allCompNm.length > 0){
			allCompNm = allCompNm.substring(1);
			allCompNm = allCompNm.substring(0,allCompNm.length-1);
		}
		
		var arrAllCompSeq = allcompSeq.split(",,");
		var arrAllCompNm = allCompNm.split(",,");
		
		allCompSeq = "";
		allCompNm = "";
		
		for(var i=0;i<arrAllCompSeq.length;i++){
			allCompSeq += "," + arrAllCompSeq[i];
			allCompNm += "," + arrAllCompNm[i];
		}
		
		
		
		$("#step2_allComp").val(allCompSeq.substring(1));
		$("#step2_allCompNm").val(allCompNm.substring(1));
		$("#allCompTable").append(compHtml);
		$(".pop_wrap_dir").hide();
	}
	
	function compInfo(){
		var $parent;
		var $children;
		var $children2;
		var header = '';
		$parent = $(".pop_wrap");
		$parent.append('<div id="modal" class="modal"></div>');
		
		$children = $(".pop_wrap_dir");  //자식창 세팅
		$children.show();
		$children.css("border", "1px solid #adadad");
        $children.css("z-index", "20");
		        
        var popWid = $children.outerWidth();
        var popHei = $children.outerHeight();
        var ptWid = $parent.outerWidth();
        var ptHei = $parent.outerHeight();
        $children.css("top","50%").css("left","50%").css("marginLeft",-popWid/2).css("marginTop", -popHei/2);

	}
	
	function compInfoClose(){
		$("#modal").remove();
		$(".pop_wrap_dir").hide();
	}
	
	
	function setStep2Table(dataList){
		var tableHtml = '';
		var nowComp = '';
		for(i = 0; i < dataList.length; i ++){
			if(dataList[i].compSeq == compSeq){
				nowComp = 'Y';
			}else{
				nowComp = 'N';
			}
			tableHtml += '<tr nowComp="'+nowComp+'">';
			tableHtml += '<td>'+dataList[i].compName+'</td>';
			tableHtml += '<td>'+dataList[i].deptName+'</td>';
			tableHtml += '<td>'+dataList[i].mainDeptYn+'</td>';
			tableHtml += '</tr>';
			$("#step3_allComp").val($("#step3_allComp").val()+','+dataList[i].compSeq);
        }
		$("#step3Table").append(tableHtml);
	}
	
	function step4DocData(){
        var paramData = {};
        var allComp = $("#step2_allComp").val();
        var isAll = $("input[name=isAll]:checked").val();        
        if(isAll == 'N'){
        	allComp = compSeq;        	
        }                
        paramData.allComp = allComp;
        paramData.empSeq = empSeq;
        paramData.deptSeq = deptSeq;
        paramData.groupSeq = groupSeq;
        state(1);
        $.ajax({
            type:"post",
            url:"empResignDocStep4Data.do",
            datatype:"json",
            data: paramData,
            beforeSend: function() {
                //통신을 시작할때 처리되는 함수 
                $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
            },
            complete: function() {
                //통신이 완료된 후 처리되는 함수
                $('html').css("cursor","auto"); // 통신이 완료 된 후 다시 일반적인 커서 모양으로 변경
            },
            success:function(data){
            	setStep4Table(data.docStep4Data, allComp)
                state(0);
            },          
            error : function(e){
                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>"); 
                state(0);
            }
        });
    }
	
	
	
	function step5DocData(){
		
		var paramData = {};
        var allComp = $("#step2_allComp").val();
        var isAll = $("input[name=isAll]:checked").val();
        setCompSelDDL(isAll);
        
        if($("#com_sel").data("kendoComboBox").value() != "")
        	compSeq = $("#com_sel").data("kendoComboBox").value();
        if(isAll == 'N'){
        	allComp = compSeq;        	
        }  
		

        paramData.allComp = allComp;
        paramData.empSeq = empSeq;
        paramData.deptSeq = deptSeq;
        paramData.groupSeq = groupSeq;
        state(1);
        $.ajax({
            type:"post",
            url:"empResignDocStep5Data.do",
            datatype:"json",
            data: paramData,
            beforeSend: function() {
                //통신을 시작할때 처리되는 함수 
                $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
            },
            complete: function() {
                //통신이 완료된 후 처리되는 함수
                $('html').css("cursor","auto"); // 통신이 완료 된 후 다시 일반적인 커서 모양으로 변경
            },
            success:function(data){
            	$("#com_sel").data("kendoComboBox").value(compSeq);
            	setStep5Table(data.docStep5Data, data.totalDocCnt);
                state(0);
            },          
            error : function(e){
                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>"); 
                state(0);
            }
        });
    }
	
	function setStep5Table(dataList, totalCnt){
		if(eaType != "ea"){
			$("#com_sel").data("kendoComboBox").value(compSeq);	
			var targetCompSeq = $("#com_sel").data("kendoComboBox").value();
			
			if(dataList[targetCompSeq] == null){
				return;
			}
			
			$("#appTab1Cnt").html(dataList[targetCompSeq].pendingDocCnt);
			$("#appTab2Cnt").html(dataList[targetCompSeq].afterDocCnt);
			$("#appTab3Cnt").html(dataList[targetCompSeq].waitingDocCnt);
			
			$("#mkZone").empty();
			$("#mkZone").append(totalCnt);
			
			
			var pendingDocList = dataList[targetCompSeq].pendingDocList;
			var afterDocList = dataList[targetCompSeq].afterDocList;
			var waitingDocList = dataList[targetCompSeq].waitingDocList;
			
			
			var pendingHtml = "";
			var afterHtml = "";
			var waitingHtml = "";
			
			//step5Tab1e
			
			//미결건 테이블 그리그
			pendingHtml += "<colgroup>";
			pendingHtml += "<col width='100'/>";
			pendingHtml += "<col width='100'/>";
			pendingHtml += "<col width='130'/>";
			pendingHtml += "<col width='185'/>";
			pendingHtml += "<col width='80'/>";
			pendingHtml += "<col width=''/>";
			pendingHtml += "</colgroup>";
				
			for(var i=0; i<pendingDocList.length; i++){
				pendingHtml += "<tr docId='" + pendingDocList[i].docId + "' class='pendingDoc'>";
				pendingHtml += "<td>" + pendingDocList[i].formNm + "</td>";
				pendingHtml += "<td>" + pendingDocList[i].docNo + "</td>";
				pendingHtml += "<td>" + pendingDocList[i].docTitle + "</td>";
				pendingHtml += "<td>" + pendingDocList[i].repDt + "</td>";
				pendingHtml += "<td>" + pendingDocList[i].deptNm + "</td>";
				pendingHtml += "<td>" + pendingDocList[i].userNm + "</td>";
				pendingHtml += "</tr>";			
			}		
			$("#step5Tab1").html(pendingHtml);
			
			
			
			//후결 테이블 그리그
			afterHtml += "<colgroup>";
			afterHtml += "<col width='100'/>";
			afterHtml += "<col width='100'/>";
			afterHtml += "<col width='130'/>";
			afterHtml += "<col width='185'/>";
			afterHtml += "<col width='80'/>";
			afterHtml += "<col width=''/>";
			afterHtml += "</colgroup>";
				
			for(var i=0; i<afterDocList.length; i++){				
				afterHtml += "<tr docId='" + afterDocList[i].docId + "' class='afterDoc'>";
				afterHtml += "<td>" + afterDocList[i].formNm + "</td>";
				afterHtml += "<td>" + afterDocList[i].docNo + "</td>";
				afterHtml += "<td>" + afterDocList[i].docTitle + "</td>";
				afterHtml += "<td>" + afterDocList[i].repDt + "</td>";
				afterHtml += "<td>" + afterDocList[i].deptNm + "</td>";
				afterHtml += "<td>" + afterDocList[i].userNm + "</td>";
				afterHtml += "</tr>";
			}
			$("#step5Tab2").html(afterHtml);
			
			
			//예정 테이블 그리그
			waitingHtml += "<colgroup>";
			waitingHtml += "<col width='100'/>";
			waitingHtml += "<col width='100'/>";
			waitingHtml += "<col width='130'/>";
			waitingHtml += "<col width='100'/>";
			waitingHtml += "<col width='80'/>";
			waitingHtml += "<col width='80'/>";
			waitingHtml += "<col width=''/>";
			waitingHtml += "</colgroup>";
				
			for(var i=0; i<waitingDocList.length; i++){	
				waitingHtml += "<tr docId='" + waitingDocList[i].docId + "' class='waitingDoc'>";
				waitingHtml += "<td>" + waitingDocList[i].formNm + "</td>";
				waitingHtml += "<td>" + waitingDocList[i].docNo + "</td>";
				waitingHtml += "<td>" + waitingDocList[i].docTitle + "</td>";
				waitingHtml += "<td>" + waitingDocList[i].repDt + "</td>";
				waitingHtml += "<td>" + waitingDocList[i].deptNm + "</td>";
				waitingHtml += "<td>" + waitingDocList[i].userNm + "</td>";
				waitingHtml += "<td>";
				waitingHtml += "<div class='controll_btn ac p0'>";
				waitingHtml += "<input readonly='readonly' style='width:65px;' type='text' class='pl10' id='txt_" + waitingDocList[i].docId + "'/>";
				waitingHtml += "<button readonly='readonly' style='width:52px;' class='btnReplaceEmp' onclick='openOrgCahrtCommonPop(this)' docId='" + waitingDocList[i].docId + "' compSeq='" + waitingDocList[i].coId + "' deptSeq='" + waitingDocList[i].deptId + "' empSeq='" + waitingDocList[i].userId + "'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				waitingHtml += "</div>";
				waitingHtml += "</td>";		
				waitingHtml += "</tr>";
			}		
			$("#step5Tab3").html(waitingHtml);
		}else{
			$("#eaDocCnt").val(totalCnt);
		}
	}
	
	function setStep4Table(dataList, allComp){
		var compArray = allComp.split(",");
		var tableHtml = '';
		var totalCnt = 0;
		
		tableHtml += '<colgroup>';
		tableHtml += '<col width="180"/>';
		tableHtml += '<col width="180"/>';
		tableHtml += '<col width="180"/>';
		tableHtml += '<col width=""/>';
		tableHtml += '</colgroup>';
		
		for(var i=0; i<compArray.length; i++){
			if(dataList[compArray[i]].eaMustRoleAppLineList != null){
				var mustLineData = dataList[compArray[i]].eaMustRoleAppLineList;
				totalCnt += dataList[compArray[i]].eaMustRoleAppLineCount;
				for(var j=0; j<dataList[compArray[i]].eaMustRoleAppLineList.length; j++){					
					tableHtml += '<tr class="eaMustRole">';
					tableHtml += '<td>'+mustLineData[j].formNm+'</td>';
					tableHtml += '<td>'+mustLineData[j].actNm+'</td>';
					tableHtml += '<td>'+ (mustLineData[j].lineType == "L" ? "사용자" : "결재롤") +'</td>';
					tableHtml += '<td>';
					
					tableHtml += "<div class='controll_btn ac p0'>";
					tableHtml += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='txt_sKey" + (i + "" + j) + "'/>";
					tableHtml += "<button class='eaMustRoleInfo' style='width:52px;' onclick='OrgCahrtCommonPop(this)' bntPkKey='sKey" + (i + "" + j) + "' formId='" + mustLineData[j].formId + "' actId='" + mustLineData[j].actId + "' lineType='" + mustLineData[j].lineType + "' roleId='" + mustLineData[j].roleId + "' proxyEmpSeq='' proxyGroupSeq='' proxyCompSeq='' proxyBizSeq='' proxyDeptSeq='' proxyOrgPath='' formCompSeq='" + mustLineData[j].compSeq + "' resignCompSeq='" + dataList[compArray[i]].resignCompSeq + "' resignDeptSeq='" + dataList[compArray[i]].resignDeptSeq + "' resignEmpSeq='" + dataList[compArray[i]].resignEmpSeq + "'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
					tableHtml += "</div>";
					
					
					tableHtml += '</td>';
					tableHtml += '</tr>';
				}
			}
		}
			
		$("#step4Table").html(tableHtml);
		$("#mustCnt").val(totalCnt);
	}	
	
	function setSubUser(rtnNm, mustKyulPk, callback){
		var pop = window.open("", "cmmOrgPop", "width=799,height=789,scrollbars=no");
		$("input[name=targetDeptSeq]").val("");
        $("input[name=callback]").val(callback);
        
        $("input[name=compSeq]").val(mustKyulPk);
        
        frmPop.target = "cmmOrgPop";
        frmPop.method = "post";
        frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
        frmPop.submit();
        pop.focus();
	}
	
	function rtnMustKyul(returnObj){
		var rtnPk = returnObj.receiveParam.compSeq;
		var rtnSeq = returnObj.returnObj[0].empSeq;
		var rtnNm = returnObj.returnObj[0].empName;
		$("#daeKyulNm_"+rtnPk).val(rtnNm);
		
		$("#step5_pk").val($("#step5_pk").val()+'|'+rtnPk);
		$("#step5_empSeq").val($("#step5_empSeq").val()+'|'+rtnSeq);
	}
	
	function rtnBoard(returnObj){
        var rtnPk = returnObj.receiveParam.compSeq;
        var rtnSeq = returnObj.returnObj[0].empSeq;
        var rtnNm = returnObj.returnObj[0].empName;
        $("#docNm_"+rtnPk).val(rtnNm);
        
        $("#step6_pk").val($("#step6_pk").val()+'|'+rtnPk);
        $("#step6_empSeq").val($("#step6_empSeq").val()+'|'+rtnSeq);
    }
	
	function rtnDoc(returnObj){
        var rtnPk = returnObj.receiveParam.compSeq;
        var rtnSeq = returnObj.returnObj[0].empSeq;
        var rtnNm = returnObj.returnObj[0].empName;
        $("#boardNm_"+rtnPk).val(rtnNm);
        
        $("#step7_pk").val($("#step7_pk").val()+'|'+rtnPk);
        $("#step7_empSeq").val($("#step7_empSeq").val()+'|'+rtnSeq);
    }
	
	function setStep6Table(dataList){
		var tableHtml = '';
        for(i = 0; i < dataList.length; i ++){
        	tableHtml += '<tr>';
        	tableHtml += '<td>'+dataList[i].parent_dir_nm+ ' > '+dataList[i].dir_nm+'</td>';
        	tableHtml += '<td class="le">';
        	tableHtml += '    <div class="controll_btn ac p0">';
        	tableHtml += '        <button onclick="setSubUser(\'docNm_\',\''+dataList[i].dir_cd+'\', \'rtnBoard\')"><%=BizboxAMessage.getMessage("TX000016329","대체자 선택")%></button>';
        	tableHtml += '        <input type="text" style="width:120px;" id="docNm_'+dataList[i].dir_cd+'" readonly/>';
        	tableHtml += '    </div>';
        	tableHtml += '</td>';
        	tableHtml += '</tr>';
        }
        if(dataList.length == 0)
        	tableHtml += '<tr><td colspan="3"><%=BizboxAMessage.getMessage("","처리할 항목이 없습니다.")%></td></tr>';
        $("#docCnt").val(dataList.length);
        $("#step6Table").append(tableHtml);
	}
	
	function setStep7Table(dataList){
		var tableHtml = '';
        for(i = 0; i < dataList.length; i ++){
        	tableHtml += '<tr>';
        	tableHtml += '<td>'+dataList[i].cat_nm+'</td>';
        	tableHtml += '<td class="le">';
        	tableHtml += '    <div class="controll_btn ac p0">';
        	tableHtml += '        <button onclick="setSubUser(\'boardNm_\',\''+dataList[i].cat_seq_no+'\', \'rtnDoc\')"><%=BizboxAMessage.getMessage("TX000016329","대체자 선택")%></button>';
        	tableHtml += '        <input type="text" style="width:120px;" id="boardNm_'+dataList[i].cat_seq_no+'" readonly/>';
        	tableHtml += '    </div>';
        	tableHtml += '</td>';
        	tableHtml += '</tr>';
        }
        if(dataList.length == 0)
        	tableHtml += '<tr><td colspan="3"><%=BizboxAMessage.getMessage("","처리할 항목이 없습니다.")%></td></tr>';
        $("#boardCnt").val(dataList.length);
        $("#step7Table").append(tableHtml);
	}
	
	function selDoc(chkCode){
		var isChk = $("input[name=mk]:checked");
	    var mk1 = false;
	    var mk2 = false;
	    var mk3 = false;
	    var mk4 = false;
		for(i = 0; i < isChk.length; i ++){
			if(isChk[i].id == 'mk1'){
				mk1 = true;
			}else if(isChk[i].id == 'mk2'){
				mk2 = true;
			}else if(isChk[i].id == 'mk3'){
                mk3 = true;
            }else if(isChk[i].id == 'mk4'){
                mk4 = true;
            }
		}
		
		$("#step4Table tr").each(function(){
			if(mk1 && $(this).attr("chkCode") == '20'){
				$(this).show();
			}else if(!mk1 && $(this).attr("chkCode") == '20'){
				$(this).hide();
			}
			
			if(mk2 && $(this).attr("chkCode") == '70'){
                $(this).show();
            }else if(!mk2 && $(this).attr("chkCode") == '70'){
                $(this).hide();
            }
			
			if(mk3 && $(this).attr("chkCode") == '80'){
                $(this).show();
            }else if(!mk3 && $(this).attr("chkCode") == '80'){
                $(this).hide();
            }
			
			if(mk4 && $(this).attr("chkCode") == '100'){
                $(this).show();
            }else if(!mk4 && $(this).attr("chkCode") == '100'){
                $(this).hide();
            }
			
			if($(this).attr("coId") != $("#com_sel").val()){
				$(this).hide();
			}
				
			
		});
	}
	
	
	function ddlCoChange(){
		var coId = $("#com_sel").val();
		$("#step4Table tr").each(function(){
			if($(this).attr("coId") == coId){
				$(this).show();
			}else{
				$(this).hide();
			}			
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function ok(){

		if("${isMasterAuth}" == "Y"){ 
			if(document.getElementById("mYn2").checked){
				if($("#step8_empSeq").val() == ""){
					//(임시주석 20161211 주성덕)
					alert("<%=BizboxAMessage.getMessage("TX000017944","마스터권한 대체자가 지정되지 않았습니다.")%>");
					return;
				}
			}
			if("${masterAuthCnt}" == "1" && !document.getElementById("mYn2").checked){
				alert("<%=BizboxAMessage.getMessage("TX000017944","마스터권한 대체자가 지정되지 않았습니다.")%>\n(<%=BizboxAMessage.getMessage("TX000010848","마스터권한은 최소 한 명 이상 존재해야 합니다")%>)");
				return;
			}
		}
		
		if("${params.changeDept}" == "Y"){
			if($("#step9Cnt").html() != "0"){
				alert("<%=BizboxAMessage.getMessage("","처리되지 않은 항목이 존재합니다.")%>");
				return;
			}else{
				if(confirm("<%=BizboxAMessage.getMessage("","부서 변경을 하시겠습니까?")%>")){
					if(opener != null && opener.ok != null){
						opener.ok("1");						
					}		
					self.close();
				}
			}
		}else{
			var mustKyulPk = '';
	        var mustKyulEmpSeq = '';  //필수결재 설정
	        if($("#step5_pk").val()){
	        	mustKyulPk = $("#step5_pk").val().substring(1);
	        	mustKyulEmpSeq = $("#step5_empSeq").val().substring(1);
	        }
	        var docPk = '';
	        var docEmpSeq = '';  //문서함 설정
	        if($("#step6_pk").val()){
	        	docPk = $("#step6_pk").val().substring(1);
	            docEmpSeq = $("#step6_empSeq").val().substring(1);
	        }
	        var boardPk = '';
	        var boardEmpSeq = '';  //게시판 설정
	        if($("#step7_pk").val()){
	        	boardPk = $("#step7_pk").val().substring(1);
	        	boardEmpSeq = $("#step7_empSeq").val().substring(1);
	        }
	        
			var paramData = {};
			
			var resignDate = $("#out_date").val();
			var isAll = $("input[name=isAll]:checked").val();
		    var isDeptDel = $("#step2_deptDel").val();
			paramData.empSeq = empSeq;
			paramData.compSeq = compSeq;
			paramData.deptSeq = deptSeq;
			paramData.resignDate = resignDate;
			paramData.isAll = isAll;
			paramData.isDeptDel = isDeptDel;
			paramData.mustKyulPk = mustKyulPk;
			paramData.mustKyulEmpSeq = mustKyulEmpSeq;
			paramData.docPk = docPk;
			paramData.docEmpSeq = docEmpSeq;
			paramData.boardPk = boardPk
	        paramData.boardEmpSeq = boardEmpSeq;
			paramData.isMasterAuth = $("#isMasterAuth").val();
			paramData.masterSubEmpSeq = $("#step8_empSeq").val(); //마스터권한 대체자 empSeq
			
			
			if(document.getElementById("myn2").checked)
				paramData.mailDelYn = "N";
			else
				paramData.mailDelYn = "Y";
			
			
			if("${isMasterAuth}" == "Y"){  
				if(document.getElementById("mYn1").checked)	//마스터권한 설정값(삭제 or 대체자지정)
					paramData.masterAuthDelYn = "Y";
				else
					paramData.masterAuthDelYn = "N";
			}
			
			if (confirm("<%=BizboxAMessage.getMessage("TX000006258","퇴사처리 하시겠습니까?")%>")) {
				var rtnCode = '';
				state(1);
				$.ajax({
		 			type:"post",
		 			url:"empResignProcFinish.do", //신규
		 			datatype:"json",
		 			data: paramData,
		 			success:function(data){
		 				
		 				//erp조직도 동기화 호출
		 				if("${params.target}" == "erpSyncEmp"){		 					
		 					opener.setResignEmpInfo(empSeq);
		 					self.close();
		 					return;
		 				}
		 				
		 				alert(data.result);
		 				
		 				state(0);
		 				if("${params.isEmpPop}" == "Y"){
		 					opener.opener.gridRead();
		 					opener.self.close();
		 					self.close();
		 				}else if("${params.isEmpDeptPop}" == "Y"){
		 					opener.getEmpList();
		 					self.close();
		 				}else{
			 				opener.gridRead();
			 				self.close();
		 				}		 					
	
		 			},			
		 			error : function(e){		 				
		 				alert("<%=BizboxAMessage.getMessage("TX000010689","퇴사처리중 오류가 발생했습니다.")%>");
		 				state(0);
		 			}
		 		});	
			}		
		}
	}
	
	function rtnMailCode(){
		var params = {};
		params.empSeq = empSeq;
		params.flag = '1';
		params.mailUrl = 'resignUser.do';
		return setMailId("resignUser.do","<%=BizboxAMessage.getMessage("TX000010688","메일 ID 삭제")%>", params);
	}
	
	function setStepData(stepCnt){
		var isDeptDel = $("input[name=deptDeletYn]:checked").val();
        $("#step2_deptDel").val(isDeptDel);
        var mailDel = $("input[name=mailDelYn]:checked").val();
        $("#step3_mailDel").val(mailDel);
        
		if(stepCnt == '3') {
			var isAll = $("input[name=isAll]:checked").val();
			$("#step1_isAll").val(isAll);
			if(isAll == 'N'){   //현재 회사만 보이도록 
				$("#step3Table tr").each(function(){
					var tr = $(this);
					if(tr.attr("nowComp") == 'Y'){
						tr.show();
					}else{
						tr.hide();
					}
				});
			}else if(isAll == 'Y'){  //모든 회사 다 보이도록
				$("#step3Table tr").each(function(){
                    var tr = $(this);
                    tr.show();
                });
			}
		}else if(stepCnt == '2'){
		    if(mailDel == 'Y'){
		    	$("#mailDelTxt").show();
		    	$("#mailDelTxt2").show();
		    	$("#mailDelTxt3").show();
		    	$("#mailNonDelTxt1").hide();		    	
		    }else if(mailDel == 'N'){
		    	$("#mailDelTxt").hide();
		    	$("#mailDelTxt2").hide();
		    	$("#mailDelTxt3").hide();
		    	$("#mailNonDelTxt1").show();
		    }
		}else if(stepCnt == '4'){
            
        }else if(stepCnt == '5'){
            
        }else if(stepCnt == '6'){
            
        }else if(stepCnt == '7'){
            
        }else if(stepCnt == '8'){
            
        }
	}
	
	function stepByStep(isStep){
		var totalCnt = $("div[id^='step_div']").length;
		var nowCnt = 0;
		var nextCnt = 0;
		
		if($("#out_date").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000006247","퇴사일이 지정되지 않았습니다.")%>");
			return;
		}
		
		for(i = 1; i <= totalCnt; i++){
			if($("#step_div"+i).css("display") == 'block'){ //현재 보이는 step 찾기
				nowCnt = i;
			    if(isStep == 'prev'){
			    	nextCnt = i - 1;
			    }else if(isStep == 'next'){
			        nextCnt = i + 1;
			        if(nextCnt == 2){
			        	checkEmailDelProcess();	//모든겸직 및 선택회사 퇴사에따른 메일삭제가능여부 체크.
			        }else{
			        	if(eaType == "eap"){
			        		//영리 퇴사처리 스탭 정의 
					        if(nextCnt == 4){ //step1에서 선택한 회사정보에 따른 문서정보 가져오기			        	
		 			        	step4DocData();			        	
					        }else if(nextCnt == 5){
					        	if($(".eaMustRole").length > 0){
					        		alert("<%=BizboxAMessage.getMessage("TX900000150","처리되지 않은 양식이 존재합니다.")%>");
					        		return;
					        	}
					        	fnSetEaAppLine();
					        	step5DocData();			        	
					        }else if(nextCnt == 6){
					        	if($("#mkZone").html() != "0"){
					        		alert("<%=BizboxAMessage.getMessage("TX900000176","처리되지 않은 결재 문서가 존재 합니다.")%>");
					        		return;
					        	}
					        }
			        	}else{
			        		//비영리 퇴사처리 스탭 정의
			        		
			        		//nextCnt : 4 -> 필수결재라인
			        		//nextCnt : 5 -> 대결자설정
			        		//nextCnt : 6 -> 결재문서처리
			        		//nextCnt : 7 -> 기록물/철 처리
			        		//nextCnt : 8 -> 발송권한
			        		//nextCnt : 9 -> 관인사용권한
			        		if(nextCnt >= 4 && nextCnt <= 10){
			        			if(nextCnt == 5){
			        				if($("#step4Cnt").val() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("TX900000150","처리되지 않은 양식이 존재합니다.")%>");
			        					return;
			        				}
			        			}else if(nextCnt == 6){
			        				if($("#step5Cnt").val() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("TX900000151","대체자 설정이 되지않았습니다.")%>");
			        					return;
			        				}
			        			}else if(nextCnt == 7){
			        				if($("#step6Cnt").html() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("TX900000151","대체자 설정이 되지 않았습니다")%>");
			        					return;
			        				}
			        			}else if(nextCnt == 8){
			        				if($("#step7Cnt").html() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("TX900000152","담당자 설정이 되지 않았습니다.")%>");
			        					return;
			        				}
			        			}else if(nextCnt == 9){
			        				if($("#step8Cnt").html() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("","처리되지 않은 항목이 존재합니다.")%>");
			        					return;
			        				}
			        			}else if(nextCnt == 10){
			        				if($("#step9Cnt").html() != "0"){
			        					alert("<%=BizboxAMessage.getMessage("","처리되지 않은 항목이 존재합니다.")%>");
			        					return;
			        				}
			        			}
			        			if(nextCnt != 10)
			        				stepEaDocData(nextCnt);
			        		}
			        	}
			        }
			    }
			}
		}
		
		//결재건 처리여부 확인.
		if(nowCnt == 5 && isStep == 'next'){
			if($("#step4Table tr").length > 0){
				alert("<%=BizboxAMessage.getMessage("TX000017946","결재 처리가 완료 되지 않았습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000153","일괄결재 처리를 진행해 주세요.")%>")
				return;
			}
		}		

		if(nowCnt == 2 && isStep == 'next'){
			if(!document.getElementById("myn1").checked){
				document.getElementById("yn2").checked = true;
			}
		}
		
		$("#naviUl li").removeClass("on");
		if("${params.changeDept}" != "Y"){
			$("#naviUl li").eq(nextCnt-1).addClass("on");
			
			if(nextCnt == 1){  //맨처음은 이전버튼 없애기
	            $("#prevBtn").hide();
				$("#closeBtn").show();
	        }else{
	        	$("#prevBtn").show();
	        	$("#closeBtn").hide();
	        }
			if(nextCnt == totalCnt){ //마지막 버튼은 다음 버튼 없애기
	            $("#nextBtn").hide();
	            $("#finishBtn").show();
	        }else{
	            $("#nextBtn").show();
	            $("#finishBtn").hide();
	        }
		}else{
			if(nextCnt == 4){  //맨처음은 이전버튼 없애기
	            $("#prevBtn").hide();
				$("#closeBtn").show();
	        }else{
	        	$("#prevBtn").show();
	        	$("#closeBtn").hide();
	        }
			if(nextCnt == "9"){ //마지막 버튼은 다음 버튼 없애기
	            $("#nextBtn").hide();
	            $("#finishBtn").show();
	        }else{
	            $("#nextBtn").show();
	            $("#finishBtn").hide();
	        }
			
			$("#naviUl li").eq(nextCnt-4).addClass("on");
		}
		
		$("#step_div"+nowCnt).css("display","none");
        $("#step_div"+nextCnt).css("display","block");
        setStepData(nextCnt);
	}
	
	
 	function stepEaDocData(step){
 		//step : 4 -> 필수결재라인
		//step : 5 -> 대결자설정
		//step : 6 -> 결재문서처리
		//step : 7 -> 기록물/철 처리
		//step : 8 -> 발송권한
		//step : 9 -> 관인사용권한
		
		var isAll = $("input[name=isAll]:checked").val();
        setCompSelDDLEa(isAll, "com_sel_ea" + step);
				
		var arrCompSeq = [];
		
		if($("input[name=isAll]:checked").val() == "Y"){
			for(var i=0; i<empDeptList.length; i++){
				var chkCnt = 0;
				for(var j=0; j<arrCompSeq.length; j++){
					if(empDeptList[i].compSeq == arrCompSeq[j]){
						chkCnt++;
					}
				}
				
				if(chkCnt == 0){
					arrCompSeq.push(empDeptList[i].compSeq);
				}
			}
		}else{
			arrCompSeq.push(compSeq);
		}
		
		
		var chkIdx = 0;
		var docCount = 0;
		for(var i=0; i<arrCompSeq.length; i++){
			
			chkIdx = i;
			
			if(step == "4")
				url = "/ea/user/relation/getLineList.do";
			else if(step == "5")
				url = "/ea/user/relation/getAbsentList.do";
			else if(step == "6")
				url = "/ea/user/relation/getApprovalList.do";
			else if(step == "7")
				url = "/ea/user/relation/getArchiveList.do";
			else if(step == "8")
				url = "/ea/user/relation/getDeliveryAuthList.do";
			else if(step == "9")
				url = "/ea/user/relation/getSignAuthList.do";	
				
				
			//params.changeDept == 'Y'  -> 사원부서연결->부서변경(비영리)
			//사원부서연결->부서변경(비영리)일때는 부서기준으로 조회도도록 파라미터(deptSeq) 추가
			if("${params.changeDept}" != "Y"){
				url += "?empSeq=" + empSeq + "&compSeq=" + arrCompSeq[i] + "&langCode=" + "${loginVO.langCode}";
			}else{
				url += "?empSeq=" + empSeq + "&deptSeq=" + deptSeq + "&compSeq=" + arrCompSeq[i] + "&langCode=" + "${loginVO.langCode}";
			}
			
			$.ajax({
	            type:"POST",
	            url:url,
	            contentType: "application/json",
	            datatype:"json",
	            async:false,
	            success:function(data){
	            	if($("#com_sel_ea" + step).val() == arrCompSeq[chkIdx]){
		            	setEaDocDataTable(step, data);
	            	}
	            	if(step == "4"){
	            		docCount += data.templateLineList.length + data.appLineList.length + data.auditLineList.length;
	            		$("#step4Cnt").val(docCount);
	            	}else if(step == "5"){
	            		docCount += data.absentList.length;
	        			$("#step5Cnt").val(docCount);
	            	}else if(step == "6"){
	            		docCount += data.approvalStandingList.length + data.approvalStandByList.length + data.approvalAfterAppList.length + data.approvalAuditAppList.length;
	            		$("#step6Cnt").html(docCount);
	            	}else if(step == "7"){
	            		docCount += data.getArchiveList.length;
	            		$("#step7Cnt").html(docCount);
	            	}else if(step == "8"){
	            		docCount += data.getDeliveryAuthList.length;
	            		$("#step8Cnt").html(docCount);
	            	}else if(step == "9"){
	            		docCount += data.getSignAuthList.length;
	            		$("#step9Cnt").html(docCount);
	            	}
	            },
	            error:function(e){
	            	console.log("status : " + e.status + "\n" + e.responseText);
	            }
	        });
		}
		
 	}
	
	function setEaDocDataTable(step, data){
		if(step == "4"){
			//필수결재라인	
			var templateLineList = data.templateLineList;
			var appLineList = data.appLineList;
			var auditLineList = data.auditLineList;
			
			$("#step4Tab1Cnt").html(templateLineList.length);
			$("#step4Tab2Cnt").html(appLineList.length);
			$("#step4Tab3Cnt").html(auditLineList.length);
			
			var tab1Html = "";
			var tab2Html = "";
			var tab3Html = "";
			
			var docCnt = 0;
			
			tab1Html += '<colgroup>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="160"/>';
			tab1Html += '<col width="110"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			for(var i=0;i<templateLineList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + templateLineList[i].C_TINAME + '</td>';
				tab1Html += '<td>' + templateLineList[i].DEPT_NAME +'</td>';
				tab1Html += '<td>' + templateLineList[i].LINE_TYPE_NAME +'</td>';
				tab1Html += '<td>사용자</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step4DocInfo" + docCnt + "_Nm'/>";
				tab1Html += "<input type='hidden' id='step4DocInfo" + docCnt + "' class='step4DocInfo' lineType='templateLine' lineSeq='" + templateLineList[i].C_TIKEYCODE + "' toEmp='0' toDept='0' toComp='0' targetDeptSeq='" + templateLineList[i].DEPT_SEQ + "' eaLineEmp='" + templateLineList[i].C_KLUSERKEYLINE + "' eaLineDept='" + templateLineList[i].C_KLORGCODELINE + "'//>";
				tab1Html += "<button class='' target='step4DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='4'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			if(templateLineList.length == 0)
				tab1Html += '<tr><td colspan="5"><%=BizboxAMessage.getMessage("TX900000154","처리할 결재양식이 없습니다.")%></td></tr>';
			
			
			
			tab2Html += '<colgroup>';
			tab2Html += '<col width="250"/>';
			tab2Html += '<col width="250"/>';
			tab2Html += '<col width=""/>';
			tab2Html += '</colgroup>';
			for(var i=0;i<appLineList.length;i++){
				tab2Html += '<tr>'
				tab2Html += '<td>' + appLineList[i].APPLINE_NAME + '</td>';
				tab2Html += '<td>' + appLineList[i].DEPT_NAME + '</td>';
				tab2Html += "<td><div class='controll_btn ac p0'>";
				tab2Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step4DocInfo" + docCnt + "_Nm'/>";
				tab2Html += "<input type='hidden' id='step4DocInfo" + docCnt + "' class='step4DocInfo' lineType='appLine' lineSeq='" + appLineList[i].APPLINE_SEQ + "' toEmp='0' toDept='0' toComp='0' targetDeptSeq='" + appLineList[i].DEPT_SEQ + "' eaLineEmp='" + appLineList[i].C_KLUSERKEYLINE + "' eaLineDept='" + appLineList[i].C_KLORGCODELINE + "'//>";
				tab2Html += "<button class='' target='step4DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='4'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab2Html += "</div></td>";
				tab2Html += '</tr>';
				docCnt++;
			}
			if(appLineList.length == 0)
				tab2Html += '<tr><td colspan="3"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';
			
			
			tab3Html += '<colgroup>';
			tab3Html += '<col width="250"/>';
			tab3Html += '<col width="250"/>';
			tab3Html += '<col width=""/>';
			tab3Html += '</colgroup>';
			for(var i=0;i<auditLineList.length;i++){
				tab3Html += '<tr>'
				tab3Html += '<td>' + auditLineList[i].AUDIT_NAME + '</td>';
				tab3Html += '<td>' + auditLineList[i].DEPT_NAME + '</td>';
				tab3Html += "<td><div class='controll_btn ac p0'>";
				tab3Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step4DocInfo" + docCnt + "_Nm'/>";
				tab3Html += "<input type='hidden' id='step4DocInfo" + docCnt + "' class='step4DocInfo' lineType='auditLine' lineSeq='" + auditLineList[i].AUDIT_SEQ + "' toEmp='0' toDept='0' toComp='0' targetDeptSeq='" + auditLineList[i].DEPT_SEQ + "' eaLineEmp='" + auditLineList[i].C_KLUSERKEYLINE + "' eaLineDept='" + auditLineList[i].C_KLORGCODELINE + "'//>";
				tab3Html += "<button class='' target='step4DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='4'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab3Html += "</div></td>";
				tab3Html += '</tr>';
				docCnt++;
			}
			if(auditLineList.length == 0)
				tab3Html += '<tr><td colspan="3"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';
				
			
			$("#step4Tab1").html(tab1Html);
			$("#step4Tab2").html(tab2Html);
			$("#step4Tab3").html(tab3Html);
			
		}else if(step == "5"){
			//대결자설정 
			
			var absentList = data.absentList;
			
			var tab1Html = "";
			var docCnt = 0;
        
	        tab1Html += '<colgroup>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			
			for(var i=0;i<absentList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + absentList[i].C_VIUSERNAME + '</td>';
				tab1Html += '<td>' + absentList[i].C_UIUSERNAME + '</td>';
				tab1Html += '<td>' + absentList[i].C_CIKEYNM + '</td>';
				tab1Html += '<td>' + absentList[i].C_AISTIME + '~' + absentList[i].C_AIETIME  + '</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step5DocInfo" + docCnt + "_Nm'/>";
				tab1Html += "<input type='hidden' id='step5DocInfo" + docCnt + "' class='step5DocInfo' aiEmp='" + absentList[i].C_UIUSERKEY +"' aiDept='" + absentList[i].C_OIORGCODE +"' aiSeqNum='" + absentList[i].C_AISEQNUM +"' viSeqNum='" + absentList[i].C_VISEQNUM +"' viEmp='' viDept='' targetDeptSeq='" + absentList[i].C_VIORGCODE + "' />";
				tab1Html += "<button class='' target='step5DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='5'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			
			if(absentList.length == 0)
				tab1Html += "<tr><td colspan='5'><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>";
			
			$("#step5Tab1").html(tab1Html);
			
		}else if(step == "6"){
			//결재문서처리
        	
        	var approvalStandingList = data.approvalStandingList;		//결재대기 
			var approvalStandByList = data.approvalStandByList;			//결재예정
			var approvalAfterAppList = data.approvalAfterAppList;		//후결
			var approvalAuditAppList = data.approvalAuditAppList;		//결재감사
			
			$("#appStep6Tab1Cnt").html(approvalStandingList.length);
			$("#appStep6Tab2Cnt").html(approvalStandByList.length);
			$("#appStep6Tab3Cnt").html(approvalAfterAppList.length);
			$("#appStep6Tab4Cnt").html(approvalAuditAppList.length);
			
			
        	var tab1Html = "";
			var tab2Html = "";
			var tab3Html = "";
			var tab4Html = "";
			
			var docCnt = 0;
			
			

	        tab1Html += '<colgroup>';
			tab1Html += '<col width="100"/>';
			tab1Html += '<col width="100"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="80"/>';
			tab1Html += '<col width="80"/>';
			tab1Html += '<col width="80"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			for(var i=0;i<approvalStandingList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + approvalStandingList[i].C_DIDOCFLAGNAME + '</td>';
				tab1Html += '<td>' + approvalStandingList[i].C_DITITLE +'</td>';
				tab1Html += '<td>' + approvalStandingList[i].C_DIWRITEDAY +'</td>';
				tab1Html += '<td>' + approvalStandingList[i].DEPTNAME +'</td>';
				tab1Html += '<td>' + approvalStandingList[i].USERNAME +'</td>';
				tab1Html += '<td>' + approvalStandingList[i].C_KLUSERTYPE_NM +'</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step6DocInfo" + docCnt + "_Nm'/>";
				tab1Html += "<input type='hidden' id='step6DocInfo" + docCnt + "' class='step6DocInfo' diKeyCode='" + approvalStandingList[i].C_DIKEYCODE + "' toEmp='' toDept='' targetDeptSeq='" + approvalStandingList[i].C_DIORGCODE + "' eaLineEmp='" + approvalStandingList[i].C_KLUSERKEYLINE + "' eaLineDept='" + approvalStandingList[i].C_KLORGCODELINE + "' approvalType='0' />";
				tab1Html += "<button class='' target='step6DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='6'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			if(approvalStandingList.length == 0)
				tab1Html += '<tr><td colspan="7"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';
				
				
			tab2Html += '<colgroup>';
			tab2Html += '<col width="100"/>';
			tab2Html += '<col width="100"/>';
			tab2Html += '<col width="130"/>';
			tab2Html += '<col width="80"/>';
			tab2Html += '<col width="80"/>';
			tab2Html += '<col width="80"/>';
			tab2Html += '<col width=""/>';
			tab2Html += '</colgroup>';	
			for(var i=0;i<approvalStandByList.length;i++){
				tab2Html += '<tr>'
				tab2Html += '<td>' + approvalStandByList[i].C_DIDOCFLAGNAME + '</td>';
				tab2Html += '<td>' + approvalStandByList[i].C_DITITLE +'</td>';
				tab2Html += '<td>' + approvalStandByList[i].C_DIWRITEDAY +'</td>';
				tab2Html += '<td>' + approvalStandByList[i].DEPTNAME +'</td>';
				tab2Html += '<td>' + approvalStandByList[i].USERNAME +'</td>';
				tab2Html += '<td>' + approvalStandByList[i].C_KLUSERTYPE_NM +'</td>';
				tab2Html += "<td><div class='controll_btn ac p0'>";
				tab2Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step6DocInfo" + docCnt + "_Nm'/>";
				tab2Html += "<input type='hidden' id='step6DocInfo" + docCnt + "' class='step6DocInfo' diKeyCode='" + approvalStandByList[i].C_DIKEYCODE + "' toEmp='' toDept='' targetDeptSeq='" + approvalStandByList[i].C_DIORGCODE + "' eaLineEmp='" + approvalStandByList[i].c_kluserkey + "' eaLineDept='" + approvalStandByList[i].c_klorgcode + "' approvalType='1' />";
				tab2Html += "<button class='' target='step6DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='6'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab2Html += "</div></td>";
				tab2Html += '</tr>';
				docCnt++;
			}
			if(approvalStandByList.length == 0)
				tab2Html += '<tr><td colspan="7"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';	
				
				
			tab3Html += '<colgroup>';
			tab3Html += '<col width="100"/>';
			tab3Html += '<col width="100"/>';
			tab3Html += '<col width="130"/>';
			tab3Html += '<col width="80"/>';
			tab3Html += '<col width="80"/>';
			tab3Html += '<col width="80"/>';
			tab3Html += '<col width=""/>';
			tab3Html += '</colgroup>';	
			for(var i=0;i<approvalAfterAppList.length;i++){
				tab3Html += '<tr>'
				tab3Html += '<td>' + approvalAfterAppList[i].C_DIDOCFLAGNAME + '</td>';
				tab3Html += '<td>' + approvalAfterAppList[i].C_DITITLE +'</td>';
				tab3Html += '<td>' + approvalAfterAppList[i].C_DIWRITEDAY +'</td>';
				tab3Html += '<td>' + approvalAfterAppList[i].DEPTNAME +'</td>';
				tab3Html += '<td>' + approvalAfterAppList[i].USERNAME +'</td>';
				tab3Html += '<td>' + approvalAfterAppList[i].C_KLUSERTYPE_NM +'</td>';
				tab3Html += "<td><div class='controll_btn ac p0'>";
				tab3Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step6DocInfo" + docCnt + "_Nm'/>";
				tab3Html += "<input type='hidden' id='step6DocInfo" + docCnt + "' class='step6DocInfo' diKeyCode='" + approvalAfterAppList[i].C_DIKEYCODE + "' toEmp='' toDept='' targetDeptSeq='" + approvalAfterAppList[i].C_DIORGCODE + "' eaLineEmp='" + approvalAfterAppList[i].c_kluserkey + "' eaLineDept='" + approvalAfterAppList[i].c_klorgcode + "' approvalType='2'/>";
				tab3Html += "<button class='' target='step6DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='6'>선택</button>";
				tab3Html += "</div></td>";
				tab3Html += '</tr>';
				docCnt++;
			}
			if(approvalAfterAppList.length == 0)
				tab3Html += '<tr><td colspan="7"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';	
				
				
			tab4Html += '<colgroup>';
			tab4Html += '<col width="100"/>';
			tab4Html += '<col width="100"/>';
			tab4Html += '<col width="130"/>';
			tab4Html += '<col width="80"/>';
			tab4Html += '<col width="160"/>';
			tab4Html += '<col width=""/>';
			tab4Html += '</colgroup>';	
			for(var i=0;i<approvalAuditAppList.length;i++){
				tab4Html += '<tr>'
				tab4Html += '<td>' + approvalAuditAppList[i].C_DIDOCFLAGNAME + '</td>';
				tab4Html += '<td>' + approvalAuditAppList[i].C_DITITLE +'</td>';
				tab4Html += '<td>' + approvalAuditAppList[i].C_DIWRITEDAY +'</td>';
				tab4Html += '<td>' + approvalAuditAppList[i].DEPTNAME +'</td>';
				tab4Html += '<td>' + approvalAuditAppList[i].USERNAME +'</td>';
				tab4Html += "<td><div class='controll_btn ac p0'>";
				tab4Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step6DocInfo" + docCnt + "_Nm'/>";
				tab4Html += "<input type='hidden' id='step6DocInfo" + docCnt + "' class='step6DocInfo' diKeyCode='" + approvalAuditAppList[i].C_DIKEYCODE + "' toEmp='' toDept='' targetDeptSeq='" + approvalAuditAppList[i].C_DIORGCODE + "' eaLineEmp='" + approvalAuditAppList[i].C_KLUSERKEYLINE + "' eaLineDept='" + approvalAuditAppList[i].C_KLORGCODELINE + "' approvalType='3'/>";
				tab4Html += "<button class='' target='step6DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='6'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab4Html += "</div></td>";
				tab4Html += '</tr>';
				docCnt++;
			}
			if(approvalAuditAppList.length == 0)
				tab4Html += '<tr><td colspan="6"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';	
				
			$("#step6Tab1").html(tab1Html);
			$("#step6Tab2").html(tab2Html);
			$("#step6Tab3").html(tab3Html);
			$("#step6Tab4").html(tab4Html);
				
			
		}else if(step == "7"){
			//기록물/철 처리
        	
        	var getArchiveList = data.getArchiveList;

			var tab1Html = '';
			var docCnt = 0;
			
			tab1Html += '<colgroup>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width="130"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			for(var i=0;i<getArchiveList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + (getArchiveList[i].OWN_TYPE == 'record' ? '기록물' : '기록물철') + '</td>';
				tab1Html += '<td>' + getArchiveList[i].OWN_DEPT_NAME + '</td>';
				tab1Html += '<td>${params.empNm}</td>';
				tab1Html += '<td>' + getArchiveList[i].OWN_CNT +'</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step7DocInfo" + docCnt + "_Nm'/>";
				tab1Html += "<input type='hidden' id='step7DocInfo" + docCnt + "' class='step7DocInfo' toEmp='' toDept='' OWN_TYPE='" + getArchiveList[i].OWN_TYPE +"' targetDeptSeq='" + getArchiveList[i].OWN_DEPT_SEQ + "' />";
				tab1Html += "<button class='' target='step7DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='7' targetDeptSeq='" + getArchiveList[i].OWN_DEPT_SEQ + "' ><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			if(getArchiveList.length == 0)
				tab1Html += '<tr><td colspan="5"><%=BizboxAMessage.getMessage("TX900000155","처리할 결재문서가 없습니다.")%></td></tr>';
				
			$("#step7Tab1").html(tab1Html);
			
			
		}else if(step == "8"){
			//발송권한        	
        	var getDeliveryAuthList = data.getDeliveryAuthList;

			var tab1Html = '';
			var docCnt = 0;
			
			tab1Html += '<colgroup>';
			tab1Html += '<col width="250"/>';
			tab1Html += '<col width="250"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			for(var i=0;i<getDeliveryAuthList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + getDeliveryAuthList[i].DEPT_NAME + '</td>';
				tab1Html += '<td>' + (getDeliveryAuthList[i].AUTH_TYPE == '0' ? '<%=BizboxAMessage.getMessage("","대내/대외")%>' : (getDeliveryAuthList[i].AUTH_TYPE == '1' ? '<%=BizboxAMessage.getMessage("","대내")%>' : '<%=BizboxAMessage.getMessage("","대외")%>')) + '</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step8DocInfo" + docCnt + "_Nm'" + " deliverySeq='" + getDeliveryAuthList[i].DELIVERY_SEQ  + "'/>";
				tab1Html += "<input type='hidden' id='step8DocInfo" + docCnt + "' toEmpSeq='' toDeptSeq='' authEmpSeq='" + getDeliveryAuthList[i].AUTH_EMP_SEQ + "' authDeptSeq='" + getDeliveryAuthList[i].AUTH_DEPT_SEQ + "' deliverySeq='" + getDeliveryAuthList[i].DELIVERY_SEQ + "' class='step8DocInfo'/>";
				tab1Html += "<button class='' target='step8DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='8'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			if(getDeliveryAuthList.length == 0)
				tab1Html += '<tr><td colspan="3"><%=BizboxAMessage.getMessage("","처리할 항목이 없습니다.")%></td></tr>';
				
			$("#step8Tab1").html(tab1Html);
			
			
		}else if(step == "9"){
			//관인사용권한
			var getSignAuthList = data.getSignAuthList;

			var tab1Html = '';
			var docCnt = 0;
			
			tab1Html += '<colgroup>';
			tab1Html += '<col width="200"/>';
			tab1Html += '<col width="200"/>';
			tab1Html += '<col width="200"/>';
			tab1Html += '<col width=""/>';
			tab1Html += '</colgroup>';
			for(var i=0;i<getSignAuthList.length;i++){
				tab1Html += '<tr>'
				tab1Html += '<td>' + getSignAuthList[i].C_CIKIND_KO + '</td>';
				tab1Html += '<td>' + getSignAuthList[i].C_SINAME + '</td>';
				tab1Html += '<td>' + getSignAuthList[i].DEPTNAME + '</td>';
				tab1Html += "<td><div class='controll_btn ac p0'>";
				tab1Html += "<input readonly='readonly' style='width:100px;' type='text' class='pl10' id='step9DocInfo" + docCnt + "_Nm'/>";
				tab1Html += "<input type='hidden' id='step9DocInfo" + docCnt + "' toEmpSeq='' toDeptSeq='' authDeptSeq='" + getSignAuthList[i].AUTHDEPTSEQ + "' siCode='" + getSignAuthList[i].C_SICODE + "' siSeqNum='" + getSignAuthList[i].C_SISEQNUM + "' class='step9DocInfo'/>";
				tab1Html += "<button class='' target='step9DocInfo" + docCnt + "' style='width:52px;' onclick='OrgCahrtCommonPopEa(this)' step='9'><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>";
				tab1Html += "</div></td>";
				tab1Html += '</tr>';
				docCnt++;
			}
			if(getSignAuthList.length == 0)
				tab1Html += '<tr><td colspan="4"><%=BizboxAMessage.getMessage("","처리할 항목이 없습니다.")%></td></tr>';
				
			$("#step9Tab1").html(tab1Html);
		}
	}
 	
 	
 	
	function checkEmailDelProcess(){		
		if("${empDeptCntInfo.emailDomainCnt}" > 1 && "${empDeptCntInfo.empDeptCnt}" > 1 && $("input[name=isAll]:checked").val() != "Y"){
	     	$("#myn1").attr("disabled", true);        	  
	     	document.getElementById("myn2").checked = true;
       	}else{
	       	$("#myn1").attr("disabled", false);        	  
	    	document.getElementById("myn1").checked = true;
       }
		
		if("${empDeptCntInfo.empMailDomainCount}" > 0){
			$("#myn1").attr("disabled", true);        	  
	     	document.getElementById("myn2").checked = true;
		}
	}
	
	function makeJsonData(){
		var docInfoArray = new Array();        
        
		var chkItem = $("input[flag=chk]");
		chkItem.each(function(){
			var docInfo = new Object();
			docInfo.DOC_ID = $(this).attr("DOC_ID");
			docInfo.USER_NM = $(this).attr("USER_NM");
			docInfo.DEPT_ID = $(this).attr("DEPT_ID");
			docInfo.READYN = $(this).attr("READYN");
			docInfo.DOC_TITLE = $(this).attr("DOC_TITLE");
			docInfo.REP_DT = $(this).attr("REP_DT");
			docInfo.CREATED_NM = $(this).attr("CREATED_NM");
			docInfo.OPERYN = $(this).attr("OPERYN");
			docInfo.FORM_NM = $(this).attr("FORM_NM");
			docInfo.CREATED_DT = $(this).attr("CREATED_DT");
			docInfo.USER_ID = $(this).attr("USER_ID");
			docInfo.FORM_ID = $(this).attr("FORM_ID");
			docInfo.CO_ID = $(this).attr("CO_ID");
			docInfo.TRAY_DOC_ID = ""
			docInfo.DOC_TITLE_ORIGIN = ""
			docInfo.DOC_STS = $(this).attr("DOC_STS");
			docInfo.FORM_MODE = $(this).attr("FORM_MODE");
			docInfo.DOC_NO = $(this).attr("DOC_NO");
			docInfo.REP_DT_120 = $(this).attr("REP_DT_120");
			docInfoArray.push(docInfo);
		});
		var totalObj = new Object();
		var jsonStr = JSON.stringify(docInfoArray);
		return jsonStr;
	}
  
    function fnMultiAppDocApprovalProc(){
  		var target = $(".appTab.on")[0].id;
  		
  		var docId = "";
  		
  		if(target == "appTab1"){
  			$(".pendingDoc").each(function(){
  				docId += "," + $(this).attr("docId");
  			});  			
  		}else if(target == "appTab2"){
  			$(".afterDoc").each(function(){
  				docId += "," + $(this).attr("docId");
  			});
  		}else if(target == "appTab3"){
  			$(".waitingDoc").each(function(){
  				docId += "," + $(this).attr("docId");
  			});		
  		}
  		
  		if(docId.length > 0){
			docId = docId.substring(1);		
			
			
			if(target == "appTab1" || target == "appTab2"){
				if(confirm("<%=BizboxAMessage.getMessage("TX900000156","퇴사자가 결재자 정보로 반영됩니다.")%>\n<%=BizboxAMessage.getMessage("TX900000157","일괄 결재 처리 진행하시겠습니까?")%>")){
					fnAppDocApprovalProc(docId, '1')
				}
			}else{
				//대결자지정이 모드 되어있는지 체크
				var replaceCnt = 0;
				$(".btnReplaceEmp").each(function(){
					if($(this).attr("replaceEmpInfo") != null && $(this).attr("replaceEmpInfo") != ""){
						replaceCnt++;
					}
				});
				if(replaceCnt != $(".btnReplaceEmp").length){
					alert("<%=BizboxAMessage.getMessage("TX900000158","대결자가 지정되지 않은 문서가 존재합니다.")%>\n<%=BizboxAMessage.getMessage("TX900000159","대결자를 모두 선택하여 주세요.")%>")
				}else{
					if(confirm("<%=BizboxAMessage.getMessage("TX900000160","선택 된 대결자 정보로 결재자가 변경 됩니다.")%>\n<%=BizboxAMessage.getMessage("TX000013783","진행 하시겠습니까?")%>"))
						fnAppDocApprovalProc(docId, '0')					
				}
			}			
			
  		}else{
  			alert("<%=BizboxAMessage.getMessage("TX900000161","결재가능한 문서가 존재하지 않습니다.")%>");
  			return;
  		}
    }
    
 // 문서보기  url : /ea/eadocpop/EAAppDocViewPop.do
    function fnAppDoc(docID, formID, docWidth){
        
              

        var doc_id = docID ;
        var form_id = formID ;
        var intWidth = docWidth;
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
        var url = "/eap/ea/docpop/EAAppDocViewPop.do?doc_id="+doc_id+"&form_id=" + form_id;
        window.open(url, 'AppDoc', 'menubar=0,resizable=0,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
        
    }  
    
    /* 공통 팝업 호출 (대결자)*/
    function openOrgCahrtCommonPop(e) {	    	
    	targetBtn = e;
    	
        var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
        $("input[name=callback]").val("callbackSel");
        $("input[name=compSeq]").val("");
        $("input[name=deptSeq]").val("");
        $("input[name=empSeq]").val("");
        $("input[name=targetDeptSeq]").val("");
        frmPop.target = "cmmOrgPop";
        frmPop.method = "post";
        frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	    frmPop.submit();
	    pop.focus();
    }
    
    
    /* 공통 팝업 호출 (대체자 설정 -비영리)*/
    function OrgCahrtCommonPopEa(e) {	    	
    	targetBtn = e;    	
        if($(targetBtn).attr("step") == "7"){
        	pop = window.open("", "cmmOrgPop", "width=500,height=604,scrollbars=no");
        	$("input[name=compSeq]").val("");
            $("input[name=empSeq]").val("");
            $("input[name=deptSeq]").val($(targetBtn).attr("targetDeptSeq"));
            $("input[name=targetDeptSeq]").val("");
        	$("input[name=initMode]").val("");
        	$("input[name=compFilter]").val("");
        	$("input[name=callback]").val("callbackSelectUser");
            frmPop.target = "cmmOrgPop";
            frmPop.method = "post";
            frmPop.action = '/ea/neos/cmm/orgpop/DeptUserSelectPop.do';
            frmPop.submit();
            pop.focus();        	
        }else{
        	var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
            $("input[name=callback]").val("callbackSelEa");
            $("input[name=compSeq]").val("");
            $("input[name=deptSeq]").val("");
            $("input[name=empSeq]").val("");
        	
        	$("input[name=targetDeptSeq]").val("");
        	$("input[name=initMode]").val("");
        	
        	 $("input[name=compFilter]").val(compSeq);
        	 $("input[name=selectedItems]").val($(targetBtn).attr("proxyorgpath"));
             
             frmPop.target = "cmmOrgPop";
             frmPop.method = "post";
             frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
     	    frmPop.submit();
     	    pop.focus();
        }       
    }
    
    function callbackSelectUser(data){
    	var target = $(targetBtn).attr("target");
    	
    	$("#" + target).attr("toEmp", data.seq);
		$("#" + target).attr("toDept", "");
		$("#" + target + "_Nm").val(data.name);
    }
    
    
    function callbackSelEa(data){
    	var returnInfo = data.returnObj[0];
    	
    	var target = $(targetBtn).attr("target");
    	
    	if(returnInfo == null){
    		if($(targetBtn).attr("step") == "4"){
	    		returnInfo = {};
	    		returnInfo.empSeq = "0";
	    		returnInfo.deptSeq = "0";
	    		returnInfo.compSeq = "0";
	    		returnInfo.empName = "";    	
    		}else{
    			returnInfo = {};
	    		returnInfo.empSeq = "";
	    		returnInfo.deptSeq = "";
	    		returnInfo.compSeq = "";
	    		returnInfo.empName = "";   
    		}
    	}
    	
    	
    	if($(targetBtn).attr("step") == "4"){
    		var eaLineEmp = $("#" + target).attr("eaLineEmp").split(',');
    		var eaLineDept = $("#" + target).attr("eaLineDept").split(',');
			var checkCount = 0;
    		for(var i=0;i<eaLineEmp.length;i++){
    			if(returnInfo.empSeq == eaLineEmp[i] && returnInfo.deptSeq == eaLineDept[i]){
    				checkCount++;
    			}    				
    		}
    		if(checkCount > 0){
    			alert("<%=BizboxAMessage.getMessage("TX900000162","이미 결재라인에 있는 사용자로 결재자가 중복됩니다.")%>\n<%=BizboxAMessage.getMessage("TX900000163","다시 선택해주세요.")%>");
    			returnInfo = {};
	    		returnInfo.empSeq = "";
	    		returnInfo.deptSeq = "";
	    		returnInfo.compSeq = "";
	    		returnInfo.empName = "";
    		}     		
    		
	    	$("#" + target).attr("toEmp", returnInfo.empSeq);
	    	$("#" + target).attr("toDept", returnInfo.deptSeq);
	    	$("#" + target).attr("toComp", returnInfo.compSeq);
	    	$("#" + target + "_Nm").val(returnInfo.empName);
	    	
	    	$(targetBtn).attr("proxyOrgPath", returnInfo.superKey);
    	}else if($(targetBtn).attr("step") == "5"){
    		if(returnInfo.empSeq == $("#" + target).attr("aiEmp")){
    			alert("<%=BizboxAMessage.getMessage("TX900000164","부재자와 대체자가 같을 수 없습니다.")%>")
    			returnInfo = {};
	    		returnInfo.empSeq = "";
	    		returnInfo.deptSeq = "";
	    		returnInfo.compSeq = "";
	    		returnInfo.empName = ""; 
    		}    		
    		
    		$("#" + target).attr("viEmp", returnInfo.empSeq);
    		$("#" + target).attr("viDept", returnInfo.deptSeq);
    		$("#" + target + "_Nm").val(returnInfo.empName);
    	}else if($(targetBtn).attr("step") == "6"){
    		var eaLineEmp = $("#" + target).attr("eaLineEmp").split('|');
    		var eaLineDept = $("#" + target).attr("eaLineDept").split('|');
			var checkCount = 0;
    		for(var i=0;i<eaLineEmp.length;i++){
    			if(returnInfo.empSeq == eaLineEmp[i] && returnInfo.deptSeq == eaLineDept[i]){
    				checkCount++;
    			}    				
    		}
    		if(checkCount > 0){
    			alert("<%=BizboxAMessage.getMessage("TX900000165","이미 결재라인에 있는 사용자로 결재자가 중복됩니다.")%>\n<%=BizboxAMessage.getMessage("TX900000163","다시 선택해주세요.")%>");
    			returnInfo = {};
	    		returnInfo.empSeq = "";
	    		returnInfo.deptSeq = "";
	    		returnInfo.compSeq = "";
	    		returnInfo.empName = "";
    		}  
    		$("#" + target).attr("toEmp", returnInfo.empSeq);
    		$("#" + target).attr("toDept", returnInfo.deptSeq);
    		$("#" + target + "_Nm").val(returnInfo.empName);
    	}else if($(targetBtn).attr("step") == "8"){ 
    		$("#" + target).attr("toEmpSeq", returnInfo.empSeq);
    		$("#" + target).attr("toDeptSeq", returnInfo.deptSeq);
    		$("#" + target + "_Nm").val(returnInfo.empName);
    	}else if($(targetBtn).attr("step") == "9"){ 
    		$("#" + target).attr("toEmpSeq", returnInfo.empSeq);
    		$("#" + target).attr("toDeptSeq", returnInfo.deptSeq);
    		$("#" + target + "_Nm").val(returnInfo.empName);
    	}
    }
    
    
    /* 공통 팝업 호출 (대체자)*/
    function OrgCahrtCommonPop(e) {	    	
    	targetBtn = e;
        var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
        $("input[name=callback]").val("callbackSel2");
        $("input[name=compSeq]").val("");
        $("input[name=deptSeq]").val("");
        $("input[name=empSeq]").val("");
        $("input[name=targetDeptSeq]").val("");
        if($(e).attr("formCompSeq") == "0"){
        	$("input[name=compFilter]").val("");
        }else{
        	$("input[name=compFilter]").val($(e).attr("formCompSeq"));
        } 
        $("input[name=selectedItems]").val($(targetBtn).attr("proxyorgpath"));
        frmPop.target = "cmmOrgPop";
        frmPop.method = "post";
        frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	    frmPop.submit();
	    pop.focus();
    }
    
    
    
    /* 공통 팝업 호출 (마스터권한 대체자지정)*/
    function openOrgCahrtCommonPop2() {
        var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
        $("input[name=callback]").val("callbackSelMasterAuth");
        $("input[name=compSeq]").val("");
        $("input[name=deptSeq]").val("");
        $("input[name=empSeq]").val("");
        $("input[name=targetDeptSeq]").val("");
        frmPop.target = "cmmOrgPop";
        frmPop.method = "post";
        frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
	    frmPop.submit();
	    pop.focus();
    }
    
    
    
    
    
    
    
    
    function callbackSel(data){
    	var returnInfo = data.returnObj[0];
    	var replaceEmpInfo = $(targetBtn).attr("docId") + "|" + returnInfo.compSeq + "|" + returnInfo.deptSeq + "|" + returnInfo.empSeq + "|" + returnInfo.dutyCode + "|" + returnInfo.positionCode; 
    	$(targetBtn).attr("replaceEmpInfo", replaceEmpInfo);
    	
    	$("#txt_" + $(targetBtn).attr("docId")).val(returnInfo.empName);
    }
    
    
    function callbackSel2(data){
     	var returnInfo = data.returnObj[0];
//     	var replaceEmpInfo = $(targetBtn).attr("docId") + "|" + returnInfo.compSeq + "|" + returnInfo.deptSeq + "|" + returnInfo.empSeq + "|" + returnInfo.dutyCode + "|" + returnInfo.positionCode; 
//     	$(targetBtn).attr("replaceEmpInfo", replaceEmpInfo);
		$(targetBtn).attr("proxyEmpSeq", returnInfo.empSeq);
		$(targetBtn).attr("proxyGroupSeq", returnInfo.groupSeq);
		$(targetBtn).attr("proxyCompSeq", returnInfo.compSeq);
		$(targetBtn).attr("proxyBizSeq", returnInfo.bizSeq);
		$(targetBtn).attr("proxyDeptSeq", returnInfo.deptSeq);
		$(targetBtn).attr("proxyOrgPath", returnInfo.superKey);
		$(targetBtn).addClass("setFlag");
    	$("#txt_" + $(targetBtn).attr("bntPkKey")).val(returnInfo.empName);
    }
    
    
    function callbackSelMasterAuth(daeKyulObj){
    	if(daeKyulObj.returnObj){
    		if(daeKyulObj.returnObj.length > 0){
    			var daeKyulNm = daeKyulObj.returnObj[0].empName;
    			var daeKyulSeq = daeKyulObj.returnObj[0].empSeq;
    			var daeKyulDept = daeKyulObj.returnObj[0].deptSeq;
    	
    			$("#step8_empSeq").val(daeKyulSeq);	
    	 
    	 		$("#txtMasterSubUser").val(daeKyulNm);
    		}
    	}
    }
    
    
    
    
    
    
    
    
    function naviChange(naviCnt){
    	
    }
    
    
    function getSubUser(target){    	
    	var table = document.getElementById("step4Table");
		var tr = table.getElementsByTagName("tr");
		for(var i=0; i<tr.length; i++)
			tr[i].style.background = "white";
		target.style.backgroundColor = "#E6F4FF";
		
		$("#txtSubUserNm").val($(target).attr("subUserNm"));
    }
    
    
	function allChk(obj){
		var checked = $(obj)[0].checked;
		
		if($(obj).attr("name") == "all_chk"){
			$("input[type=checkbox][name=chk]").prop("checked",checked);
		}else{
			if($("input[type=checkbox][name=chk]:not(:checked)").length == 0){
				$("input[type=checkbox][name=all_chk]").prop("checked",true);
			}else{
				$("input[type=checkbox][name=all_chk]").prop("checked",false);
			}
		}
	}

	
	function chkEaDoc(){
		var table = document.getElementById("step4Table");
		var tr = table.getElementsByTagName("tr");
		
		var cnt = 0;
		
		for(var i=0;i<tr.length;i++){
			if($(tr[i]).attr("subUserId") == "")
				cnt++;
		}
		if(cnt > 0)
			return false;
		else
			return true;
		
	}
	
	
	function fnMasterAuthSetting(){
		
		if(document.getElementById("mYn1").checked){
			$("#btnMasterSubUser").data("kendoButton").enable(false);
			$("#txtMasterSubUser").attr("disabled", true);
		}
		else{
			$("#btnMasterSubUser").data("kendoButton").enable(true);
			$("#txtMasterSubUser").removeAttr("disabled");
		}
	}
	
	
	function checkMailinfo(){
		if(document.getElementById("myn2").checked){
			alert("<%=BizboxAMessage.getMessage("TX000017950","메일정보가 남아있어 부서를 삭제 할 수 없습니다.")%>");
			document.getElementById("yn2").checked = true;
		}
	
			
	}
	
	function setCompSelDDL(isAll){
		$("#com_sel").kendoComboBox({
	    	dataTextField: "compName",
            dataValueField: "compSeq",
	        index : 0,
	         filter: "contains",
	        suggest: true
	    });
		
		if(isAll == 'N'){
			var coCombobox = $("#com_sel").data("kendoComboBox");
		    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length
		    coCombobox.dataSource.insert(cnt, { compName: compNm, compSeq: compSeq });		    
		    coCombobox.refresh();			 
		    coCombobox.select(0);
		}
		else{
			var arrCompSeq = $("#step2_allComp").val().split(",");
			var arrCompNm = $("#step2_allCompNm").val().split(",");
			
			for(var i=0;i<arrCompSeq.length;i++){
				var coCombobox = $("#com_sel").data("kendoComboBox");
			    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length
			    coCombobox.dataSource.insert(cnt, { compName: arrCompNm[i], compSeq: arrCompSeq[i] });			    
			}
			coCombobox.refresh();
		}
		
	}
	
	function setCompSelDDLEa(isAll, target){
		$("#" + target).kendoComboBox({
	    	dataTextField: "compName",
            dataValueField: "compSeq",
	        index : 0,
	         filter: "contains",
	        suggest: true
	    });
		
		if(isAll == 'N'){
			var coCombobox = $("#" + target).data("kendoComboBox");
		    var cnt = $("#" + target).data("kendoComboBox").dataSource.data().length
		    coCombobox.dataSource.insert(cnt, { compName: compNm, compSeq: compSeq });		    
		    coCombobox.refresh();			 
		    coCombobox.select(0);
		}
		else{
			var arrCompSeq = $("#step2_allComp").val().split(",");
			var arrCompNm = $("#step2_allCompNm").val().split(",");
			
			for(var i=0;i<arrCompSeq.length;i++){
				var coCombobox = $("#" + target).data("kendoComboBox");
			    var cnt = $("#" + target).data("kendoComboBox").dataSource.data().length
			    coCombobox.dataSource.insert(cnt, { compName: arrCompNm[i], compSeq: arrCompSeq[i] });			    
			}
			coCombobox.refresh();
			coCombobox.select(0);
		}
		
	}
	
	
	function fnClose(){
		
		if("${params.changeDept}" == "Y"){
			if(confirm("<%=BizboxAMessage.getMessage("","취소하시겠습니까?")%>")){
				self.close();
			}
		}else{		
			if(confirm("<%=BizboxAMessage.getMessage("TX000017951","퇴사처리 진행을 취소하시겠습니까?")%>")){
				if("${params.isEmpPop}" == "Y"){
					opener.setRelease();
				}
				self.close();
			}
		}
			
	}
	
	
	//탭
	function tab_nor_Fn(num){
		$(".tab"+num).show();
		$(".tab"+num).siblings().hide();
		
		var inx = num -1

		$(".tab_nor li").eq(inx).addClass("on");
		$(".tab_nor li").eq(inx).siblings().removeClass("on");
		
		if(inx == 2){
			$("#btnAppTab3").show();
			$("#btnAppTab1").hide();
		}else{
			$("#btnAppTab3").hide();
			$("#btnAppTab1").show();
		}
			
	}
	
	
	//탭2
	function tab_nor_Fn2(num){
		$(".tab"+num).show();
		$(".tab"+num).siblings().hide();
		
		var inx = num -1

		$("#tab2 li").eq(inx).addClass("on");
		$("#tab2 li").eq(inx).siblings().removeClass("on");
	}
	
	
	function fnAppDocApprovalProc(docIds, target){
		//target : 0 -> 예정 결재(대체자지정)
		//target : 1 -> 미결,후결 일괄결재
		
		
		if(target == "0"){
			var paramData = {};
			var replaceAppDocInfo = "";			
			
			$(".btnReplaceEmp").each(function(){
				replaceAppDocInfo += "," + $(this).attr("replaceEmpInfo");
			});
			replaceAppDocInfo = replaceAppDocInfo.substring(1);
				
			
			
			paramData.replaceAppDocInfo = replaceAppDocInfo;
	        paramData.compSeq = $("#com_sel").data("kendoComboBox").value();
	        paramData.empSeq = empSeq;	
	        state(1);
			$.ajax({
	            type:"post",
	            url:"empResignReplaceAppDocProc.do",
	            datatype:"json",
	            data: paramData,
	            success:function(data){
	            	if(data.result.resultCode != "SUCCESS"){
	            		alert(data.result.resultMessage);
	            	}else{
	            		alert("<%=BizboxAMessage.getMessage("TX900000166","변경 처리 되었습니다.")%>");
	            	}
	            	step5DocData();
	            },          
	            error : function(e){	            	
	                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>");
	                state(0);
	            }
	        }); 			
		}else{
			var paramData = {};
			paramData.docIds = docIds;
	        paramData.compSeq = $("#com_sel").data("kendoComboBox").value();
	        paramData.empSeq = empSeq;	
	        state(1);
			$.ajax({
	            type:"post",
	            url:"empResignAppDocApprovalProc.do",
	            datatype:"json",
	            data: paramData,
	            success:function(data){
	            	if(data.result.resultCode == "SUCCESS")
	            		alert("<%=BizboxAMessage.getMessage("TX900000167","결재 처리 되었습니다.")%>");
	            	else
	            		alert("<%=BizboxAMessage.getMessage("TX900000168","결재 처리중 오류가 발생하였습니다.")%>");
	            	step5DocData();
	            },          
	            error : function(e){	            	
	                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>");
	                state(0);
	            }
	        }); 
		}
		
	}
	
	
	//수신참조자 또는 시행자 삭제처리
	function fnSetEaAppLine(){
		var allComp = $("#step2_allComp").val();
        var isAll = $("input[name=isAll]:checked").val();        
        if(isAll == 'N'){
        	allComp = compSeq;        	
        } 
                
        var confirmTxt = "";			
		var paramData = {};
	
		paramData.eaMustRoleInfo = "";
        paramData.empSeq = empSeq;	
        paramData.compSeq = compSeq;
        paramData.allComp = allComp;
        paramData.deleteFlage = true;
        
		$.ajax({
	           type:"post",
	           url:"empResignSetEaMustRoleAppLine.do",
	           datatype:"json",
	           data: paramData,
	           async: false,
	           success:function(data){
// 	        	   alert(data);
	            },          
	            error : function(e){
// 	            	alert(data);
	            }
	    });	
	}
	
	
	
	function fnSetEaMustRoleAppLine(){
		
		
		var allComp = $("#step2_allComp").val();
        var isAll = $("input[name=isAll]:checked").val();        
        if(isAll == 'N'){
        	allComp = compSeq;        	
        } 
        
        var confirmTxt = "";
        
		
		if($(".eaMustRoleInfo").length == $(".setFlag").length || confirm("<%=BizboxAMessage.getMessage("TX900000169","설정되지 않은 항목이 있습니다.")%>\n<%=BizboxAMessage.getMessage("TX900000170","대체자 미설정 시 퇴사자 정보는 양식에서 삭제 처리 되며, 결재 Role정보도 삭제 처리 됩니다.")%>")){
			var eaMustRoleInfo = "";
			$(".eaMustRoleInfo").each(function(){
				eaMustRoleInfo += "," + $(this).attr("formId") + "*" + $(this).attr("actId") + "*" + $(this).attr("lineType") + "*" + $(this).attr("roleId") + "*" + $(this).attr("proxyEmpSeq") + "*" + $(this).attr("proxyGroupSeq") + "*" + $(this).attr("proxyCompSeq") + "*" + $(this).attr("proxyBizSeq") + "*" + $(this).attr("proxyDeptSeq") + "*" + $(this).attr("proxyOrgPath") + "*" + $(this).attr("resignCompSeq");
			});		
			
			if(eaMustRoleInfo.length > 0){
				eaMustRoleInfo = eaMustRoleInfo.substring(1);
				var paramData = {};
			
				paramData.eaMustRoleInfo = eaMustRoleInfo;
		        paramData.empSeq = empSeq;	
		        paramData.compSeq = compSeq;
		        paramData.allComp = allComp;
		        state(1);
				$.ajax({
		            type:"post",
		            url:"empResignSetEaMustRoleAppLine.do",
		            datatype:"json",
		            data: paramData,
		            success:function(data){
		            	if(data.result.resultCode == "SUCCESS"){
		            		alert("<%=BizboxAMessage.getMessage("TX900000166","변경 처리 되었습니다.")%>");
		            	}else{
		            		alert(data.result.resultMessage);
		            	}
		            	state(0);
		            	step4DocData();
		            	
		            },          
		            error : function(e){	            	
		                alert("<%=BizboxAMessage.getMessage("TX000009901","오류가 발생하였습니다.")%>");
		                state(0);
		            }
		        });
			}	
		}
		
	}
	
	
	function eaDocProc(step){
		if(step == "4"){
			var docCnt = $(".step4DocInfo").length;
			var checkCnt = 0;
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step4DocInfo" + i).attr("toEmp") != "0"){
						checkCnt++;
					}
				}
				
				if(docCnt != checkCnt){
					if(confirm("<%=BizboxAMessage.getMessage("TX900000171","대체자를 지정하지 않은 항목이 있습니다.")%>\n<%=BizboxAMessage.getMessage("TX000013946","진행하시겠습니까?")%>")){
						eaDocProcStart(step);
					}
				}else{
					eaDocProcStart(step);
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
		else if(step == "5"){
			var docCnt = $(".step5DocInfo").length;
			var checkCnt = 0;
			
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step5DocInfo" + i).attr("viEmp") != ""){
						checkCnt++;
					}
				}			
				if(docCnt != checkCnt){
					alert("<%=BizboxAMessage.getMessage("TX900000173","대체자를 지정하지 않은 항목이 존재합니다.")%>");
					return false;
				}else{
					eaDocProcStart(step);
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
		else if(step == "6"){
			var docCnt = $(".step6DocInfo").length;
			var checkCnt = 0;
			
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step6DocInfo" + i).attr("toEmp") != ""){
						checkCnt++;
					}
				}
				
				if(docCnt != checkCnt){
					alert("<%=BizboxAMessage.getMessage("TX900000174","대체자가 지정되지 않은 항목이 존재합니다.")%>");
					return false;
				}else{
					if(confirm("<%=BizboxAMessage.getMessage("TX900000177","선택 된 대결자 정보로 결재자가 변경 됩니다.")%>\n<%=BizboxAMessage.getMessage("TX000013783","진행 하시겠습니까?")%>")){
						eaDocProcStart(step);
					}
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
		else if(step == "7"){
			var docCnt = $(".step7DocInfo").length;
			var checkCnt = 0;
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step7DocInfo" + i).attr("toEmp") != ""){
						checkCnt++;
					}
				}
				
				if(docCnt != checkCnt){
					alert("<%=BizboxAMessage.getMessage("TX900000175","담당자가 지정되지 않은 문서가 존재합니다.")%>\n<%=BizboxAMessage.getMessage("TX900000178","담당자를 모두 지정하여 주세요.")%>");
					return false;
				}else{
					eaDocProcStart(step);
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
		else if(step == "8"){
			var docCnt = $(".step8DocInfo").length;
			var checkCnt = 0;
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step8DocInfo" + i).attr("toEmpSeq") != ""){
						checkCnt++;
					}
				}
				
				if(docCnt != checkCnt){
					if(confirm("<%=BizboxAMessage.getMessage("","대체자 지정하지 않은 항목이 있습니다.")%>\n<%=BizboxAMessage.getMessage("TX000013946","진행하시겠습니까?")%>")){
						eaDocProcStart(step);
					}
				}else{
					eaDocProcStart(step);
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
		else if(step == "9"){
			var docCnt = $(".step9DocInfo").length;
			var checkCnt = 0;
			if(docCnt > 0){
				for(var i=0;i<docCnt;i++){
					if($("#step9DocInfo" + i).attr("toEmpSeq") != ""){
						checkCnt++;
					}
				}
				
				if(docCnt != checkCnt){
					if(confirm("<%=BizboxAMessage.getMessage("","대체자 지정하지 않은 항목이 있습니다.")%>\n<%=BizboxAMessage.getMessage("TX000013946","진행하시겠습니까?")%>")){
						eaDocProcStart(step);
					}
				}else{
					eaDocProcStart(step);
				}
			}else{
				alert("<%=BizboxAMessage.getMessage("TX900000172","처리할 데이터가 존재하지 않습니다.")%>")
			}
		}
	}
	
	
	function eaDocProcStart(step){
		if(step == "4"){
			var docCnt = $(".step4DocInfo").length;
			
			var tblParamTemp = {};
			tblParamTemp.lineType = "templateLine";
			tblParamTemp.lineSeq = "";
			tblParamTemp.toEmp = "";
			tblParamTemp.toDept = "";
			tblParamTemp.toComp = "";
			tblParamTemp.fromCompSeq = compSeq;
			tblParamTemp.fromEmpSeq = empSeq;
			tblParamTemp.fromDept = "";
			tblParamTemp.fromCompSeq = $("#com_sel_ea4").data("kendoComboBox").value();
			tblParamTemp.modifySeq = "${loginVO.uniqId}";
			
			var tblParamApp = {};
			tblParamApp.lineType = "appLine";
			tblParamApp.lineSeq = "";
			tblParamApp.toEmp = "";
			tblParamApp.toDept = "";
			tblParamApp.toComp = "";
			tblParamApp.fromEmpSeq = empSeq;
			tblParamApp.fromDept = "";
			tblParamApp.fromCompSeq = $("#com_sel_ea4").data("kendoComboBox").value();
			tblParamApp.modifySeq = "${loginVO.uniqId}";
			
			var tblParamAudit = {};
			tblParamAudit.lineType = "auditLine";
			tblParamAudit.lineSeq = "";
			tblParamAudit.toEmp = "";
			tblParamAudit.toDept = "";
			tblParamAudit.toComp = "";
			tblParamAudit.fromEmpSeq = empSeq;
			tblParamAudit.fromDept = "";
			tblParamAudit.fromCompSeq = $("#com_sel_ea4").data("kendoComboBox").value();
			tblParamAudit.modifySeq = "${loginVO.uniqId}";
			
			for(var i=0;i<docCnt;i++){
				if($("#step4DocInfo" + i).attr("lineType") == "templateLine"){
					tblParamTemp.lineSeq = tblParamTemp.lineSeq + "|" + $("#step4DocInfo" + i).attr("lineSeq");
					tblParamTemp.toEmp = tblParamTemp.toEmp + "|" + $("#step4DocInfo" + i).attr("toEmp");
					tblParamTemp.toDept = tblParamTemp.toDept + "|" + $("#step4DocInfo" + i).attr("toDept");
					tblParamTemp.toComp = tblParamTemp.toComp + "|" + $("#step4DocInfo" + i).attr("toComp");
					tblParamTemp.fromDept = tblParamTemp.fromDept + "|" + $("#step4DocInfo" + i).attr("targetDeptSeq");
				}else if($("#step4DocInfo" + i).attr("lineType") == "appLine"){
					tblParamApp.lineSeq = tblParamApp.lineSeq + "|" + $("#step4DocInfo" + i).attr("lineSeq");
					tblParamApp.toEmp = tblParamApp.toEmp + "|" + $("#step4DocInfo" + i).attr("toEmp");
					tblParamApp.toDept = tblParamApp.toDept + "|" + $("#step4DocInfo" + i).attr("toDept");
					tblParamApp.toComp = tblParamApp.toComp + "|" + $("#step4DocInfo" + i).attr("toComp");
					tblParamApp.fromDept = tblParamApp.fromDept + "|" + $("#step4DocInfo" + i).attr("targetDeptSeq");
				}else if($("#step4DocInfo" + i).attr("lineType") == "auditLine"){
					tblParamAudit.lineSeq = tblParamAudit.lineSeq + "|" + $("#step4DocInfo" + i).attr("lineSeq");
					tblParamAudit.toEmp = tblParamAudit.toEmp + "|" + $("#step4DocInfo" + i).attr("toEmp");
					tblParamAudit.toDept = tblParamAudit.toDept + "|" + $("#step4DocInfo" + i).attr("toDept");
					tblParamAudit.toComp = tblParamAudit.toComp + "|" + $("#step4DocInfo" + i).attr("toComp");
					tblParamAudit.fromDept = tblParamAudit.fromDept + "|" + $("#step4DocInfo" + i).attr("targetDeptSeq");
				}
			}
			
			tblParamTemp.lineSeq = tblParamTemp.lineSeq.length > 0 ? tblParamTemp.lineSeq.substring(1) : "";
			tblParamTemp.toEmp = tblParamTemp.toEmp.length > 0 ? tblParamTemp.toEmp.substring(1) : "";
			tblParamTemp.toDept = tblParamTemp.toDept.length > 0 ? tblParamTemp.toDept.substring(1) : "";
			tblParamTemp.toComp = tblParamTemp.toComp.length > 0 ? tblParamTemp.toComp.substring(1) : "";
			tblParamTemp.fromDept = tblParamTemp.fromDept.length > 0 ? tblParamTemp.fromDept.substring(1) : "";
			
			tblParamApp.lineSeq = tblParamApp.lineSeq.length > 0 ? tblParamApp.lineSeq.substring(1) : "";
			tblParamApp.toEmp = tblParamApp.toEmp.length > 0 ? tblParamApp.toEmp.substring(1) : "";
			tblParamApp.toDept = tblParamApp.toDept.length > 0 ? tblParamApp.toDept.substring(1) : "";
			tblParamApp.toComp = tblParamApp.toComp.length > 0 ? tblParamApp.toComp.substring(1) : "";
			tblParamApp.fromDept = tblParamApp.fromDept.length > 0 ? tblParamApp.fromDept.substring(1) : "";
			
			tblParamAudit.lineSeq = tblParamAudit.lineSeq.length > 0 ? tblParamAudit.lineSeq.substring(1) : "";
			tblParamAudit.toEmp = tblParamAudit.toEmp.length > 0 ? tblParamAudit.toEmp.substring(1) : "";
			tblParamAudit.toDept = tblParamAudit.toDept.length > 0 ? tblParamAudit.toDept.substring(1) : "";
			tblParamAudit.toComp = tblParamAudit.toComp.length > 0 ? tblParamAudit.toComp.substring(1) : "";
			tblParamAudit.fromDept = tblParamAudit.fromDept.length > 0 ? tblParamAudit.fromDept.substring(1) : "";
			
			var step4Tab1Cnt = $("#step4Tab1Cnt").html();
			var step4Tab2Cnt = $("#step4Tab2Cnt").html();
			var step4Tab3Cnt = $("#step4Tab3Cnt").html();
			
			if(step4Tab1Cnt != "0"){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateLine.do",
		            datatype:"json",
		            data: tblParamTemp
		        }); 
			}
			
			if(step4Tab2Cnt != "0"){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateLine.do",
		            datatype:"json",
		            data: tblParamApp
		        });
			}
			
			if(step4Tab3Cnt != "0"){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateLine.do",
		            datatype:"json",
		            data: tblParamAudit
		        });
			}
			
			alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
			stepEaDocData("4");
		}
		else if(step == "5"){
			var docCnt = $(".step5DocInfo").length;
			
			var tblParam = {};
			tblParam.viEmp = "";
			tblParam.viDept = "";
			tblParam.aiEmp = "";
			tblParam.aiDept = "";
			tblParam.aiSeqNum = "";
			tblParam.viSeqNum = "";
			tblParam.modifySeq = "${loginVO.uniqId}";
			
			for(var i=0;i<docCnt;i++){
				if($("#step5DocInfo" + i).attr("viEmp") != ""){
					tblParam.viEmp = tblParam.viEmp + "|" + $("#step5DocInfo" + i).attr("viEmp");
					tblParam.viDept = tblParam.viDept + "|" + $("#step5DocInfo" + i).attr("viDept");
					tblParam.aiEmp = tblParam.aiEmp + "|" + $("#step5DocInfo" + i).attr("aiEmp");
					tblParam.aiDept = tblParam.aiDept + "|" + $("#step5DocInfo" + i).attr("aiDept");
					tblParam.aiSeqNum = tblParam.aiSeqNum + "|" + $("#step5DocInfo" + i).attr("aiSeqNum");
					tblParam.viSeqNum = tblParam.viSeqNum + "|" + $("#step5DocInfo" + i).attr("viSeqNum");
				}
			}
			tblParam.viEmp = tblParam.viEmp.length > 0 ? tblParam.viEmp.substring(1) : "";
			tblParam.viDept = tblParam.viDept.length > 0 ? tblParam.viDept.substring(1) : "";
			tblParam.aiEmp = tblParam.aiEmp.length > 0 ? tblParam.aiEmp.substring(1) : "";
			tblParam.aiDept = tblParam.aiDept.length > 0 ? tblParam.aiDept.substring(1) : "";
			tblParam.aiSeqNum = tblParam.aiSeqNum.length > 0 ? tblParam.aiSeqNum.substring(1) : "";
			tblParam.viSeqNum = tblParam.viSeqNum.length > 0 ? tblParam.viSeqNum.substring(1) : "";
			
			if(tblParam.viEmp.length > 0){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateAbsentUser.do",
		            datatype:"json",
		            data: tblParam
		        });
				
				alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
				stepEaDocData("5");
			}
		}
		
		else if(step == "6"){
			var docCnt = $(".step6DocInfo").length;
			var tblParam = {};
			tblParam.fromEmpSeq = empSeq;
			tblParam.fromDept = "";
			tblParam.diKeyCode = "";
			tblParam.toEmp = "";
			tblParam.toDept = "";
			tblParam.modifySeq = "${loginVO.uniqId}";
			tblParam.approvalType = "";
			
			for(var i=0;i<docCnt;i++){
				if($("#step6DocInfo" + i).attr("viEmp") != ""){
					tblParam.diKeyCode = tblParam.diKeyCode + "|" + $("#step6DocInfo" + i).attr("diKeyCode");
					tblParam.toEmp = tblParam.toEmp + "|" + $("#step6DocInfo" + i).attr("toEmp");
					tblParam.toDept = tblParam.toDept + "|" + $("#step6DocInfo" + i).attr("toDept");
					tblParam.fromDept = tblParam.fromDept + "|" + $("#step6DocInfo" + i).attr("targetDeptSeq");
					tblParam.approvalType = tblParam.approvalType + "|" + $("#step6DocInfo" + i).attr("approvalType");
				}
			}
			
			tblParam.diKeyCode = tblParam.diKeyCode.length > 0 ? tblParam.diKeyCode.substring(1) : "";
			tblParam.toEmp = tblParam.toEmp.length > 0 ? tblParam.toEmp.substring(1) : "";
			tblParam.toDept = tblParam.toDept.length > 0 ? tblParam.toDept.substring(1) : "";
			tblParam.fromDept = tblParam.fromDept.length > 0 ? tblParam.fromDept.substring(1) : "";
			tblParam.approvalType = tblParam.approvalType.length > 0 ? tblParam.approvalType.substring(1) : "";
			
			
			if(tblParam.toEmp.length > 0){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateApprovalList.do",
		            datatype:"json",
		            data: tblParam
		        });
				
				alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
				stepEaDocData("6");
			}
			
		}
		
		else if(step == "7"){
			var docCnt = $(".step7DocInfo").length;
			
			var tblParam = {};
			tblParam.fromEmpSeq = empSeq;
			tblParam.fromDept = "";
			tblParam.toEmp = "";
			tblParam.toDept = "";
			tblParam.OWN_TYPE = "";
			tblParam.modifySeq = "${loginVO.uniqId}";
			
			for(var i=0;i<docCnt;i++){
				if($("#step7DocInfo" + i).attr("toEmp") != ""){
					tblParam.toEmp = tblParam.toEmp + "|" + $("#step7DocInfo" + i).attr("toEmp");
					tblParam.toDept = tblParam.toDept + "|" + $("#step7DocInfo" + i).attr("toDept");
					tblParam.OWN_TYPE = tblParam.OWN_TYPE + "|" + $("#step7DocInfo" + i).attr("OWN_TYPE");
					tblParam.fromDept = tblParam.fromDept + "|" + $("#step7DocInfo" + i).attr("targetDeptSeq");
				}
			}
			tblParam.toEmp = tblParam.toEmp.length > 0 ? tblParam.toEmp.substring(1) : "";
			tblParam.toDept = tblParam.toDept.length > 0 ? tblParam.toDept.substring(1) : "";
			tblParam.OWN_TYPE = tblParam.OWN_TYPE.length > 0 ? tblParam.OWN_TYPE.substring(1) : "";
			tblParam.fromDept = tblParam.fromDept.length > 0 ? tblParam.fromDept.substring(1) : "";
			
			if(tblParam.toEmp.length > 0){
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/updateArchive.do",
		            datatype:"json",
		            data: tblParam,
		            success:function(data){
		            	alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
						stepEaDocData("7");
		            }
		        });
			}
		}
		
		else if(step == "8"){
			var docCnt = $(".step8DocInfo").length;
			
			var listData = new Array();
			
			for(var i=0;i<docCnt;i++){
				var tblParam = {};
				tblParam.toEmpSeq = $("#step8DocInfo" + i).attr("toEmpSeq");
				tblParam.toDeptSeq = $("#step8DocInfo" + i).attr("toDeptSeq");
				tblParam.authEmpSeq = $("#step8DocInfo" + i).attr("authEmpSeq");
				tblParam.authDeptSeq = $("#step8DocInfo" + i).attr("authDeptSeq");
				tblParam.deliverySeq = $("#step8DocInfo" + i).attr("deliverySeq");
				
				listData.push(tblParam);
			}			
			
			if(listData.length > 0){
				
				var para = {};
				para.paramList = JSON.stringify(listData);
				
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/getDeliveryAuthUpdate.do",
		            datatype:"json",
		            data: para,
		            success:function(data){
		            	var dupleList = data.resultList;
		            	var dupleEmpName = "";
		            	
		            	// 대체자 중복인 경우
		            	if(data.resultList.length > 0){
		            		for(var i=0; i<dupleList.length; i++){
		            			var dupleId = $('[deliveryseq="' + dupleList[i].duplicateSeq + '"]').attr('id');
			            		dupleEmpName = dupleEmpName + $("#" + dupleId).val() + ", ";	
		            		}
		            		// 중복된 발송권한 찾기
		            		dupleEmpName = dupleEmpName.substring(0, dupleEmpName.length-2);
		            		alert('이미 발송권한자로 지정된 사용자입니다.\n대체자를 재설정해주세요.\n(중복된 대체자: '+dupleEmpName+')');
		            		
		            	}
		            	// 정상 
		            	else {
		            		alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
							stepEaDocData("8");	
		            	}
		            }
		        });
			}
		}
		
		else if(step == "9"){
			var docCnt = $(".step9DocInfo").length;
			
			var listData = new Array();
			
			for(var i=0;i<docCnt;i++){
				var tblParam = {};
				tblParam.toEmpSeq = $("#step9DocInfo" + i).attr("toEmpSeq");
				tblParam.toDeptSeq = $("#step9DocInfo" + i).attr("toDeptSeq");
				tblParam.authEmpSeq = empSeq;
				tblParam.authDeptSeq = $("#step9DocInfo" + i).attr("authDeptSeq");
				tblParam.siCode = $("#step9DocInfo" + i).attr("siCode");
				tblParam.siSeqNum = $("#step9DocInfo" + i).attr("siSeqNum");
				
				listData.push(tblParam);
			}			
			
			if(listData.length > 0){
				
				var para = {};
				para.paramList = JSON.stringify(listData);
				
				$.ajax({
		            type:"post",
		            async:false,
		            url:"/ea/user/relation/getSignAuthUpdate.do",
		            datatype:"json",
		            data: para,
		            success:function(data){
		            	alert("<%=BizboxAMessage.getMessage("TX900000180","변경 처리되었습니다.")%>");
						stepEaDocData("9");
		            }
		        });
			}
		}
	}
	
	
	function eaComSelChange(step, e){
		//step : 4 -> 필수결재라인
		//step : 5 -> 대결자설정
		//step : 6 -> 결재문서처리
		//step : 7 -> 기록물/철 처리
		var url = "";
		
		if(step == "4")
			url = "/ea/user/relation/getLineList.do";
		else if(step == "5")
			url = "/ea/user/relation/getAbsentList.do";
		else if(step == "6")
			url = "/ea/user/relation/getApprovalList.do";
		else if(step == "7")
			url = "/ea/user/relation/getArchiveList.do";
		else if(step == "8")
			url = "/ea/user/relation/getDeliveryAuthList.do";	
		else if(step == "9")
			url = "/ea/user/relation/getSignAuthList.do";
		
		//params.changeDept == 'Y'  -> 사원부서연결->부서변경(비영리)
		//사원부서연결->부서변경(비영리)일때는 부서기준으로 조회도도록 파라미터(deptSeq) 추가
		if("${params.changeDept}" != "Y"){
			url += "?empSeq=" + empSeq + "&compSeq=" + $(e).val(); + "&langCode=" + "${loginVO.langCode}";
		}else{
			url += "?empSeq=" + empSeq + "&deptSeq=" + deptSeq + "&compSeq=" + $(e).val(); + "&langCode=" + "${loginVO.langCode}";
		}	

		$.ajax({
            type:"POST",
            url:url,
            contentType: "application/json",
            datatype:"json",
            success:function(data){
	            setEaDocDataTable(step, data);
            },
            error:function(e){
            	console.log("status : " + e.status + "\n" + e.responseText);
            }         
        });
	}
</script>

<div class="pop_wrap" style="width:100%;height:579px;">
<input type="hidden" id="step1_isAll" />  <!-- 모든회사 Y:보여줌 N:현재회사  -->
<input type="hidden" id="step2_deptDel" /> <!-- 부서를 삭제할건가? Y:삭제 N:삭제안함 -->
<input type="hidden" id="step2_allComp" /> <!-- 모든 겸직회사 -->
<input type="hidden" id="step2_allCompNm" /> <!-- 모든 겸직회사이름 -->
<input type="hidden" id="step3_mailDel" /> <!-- 메일을 삭제할건가? Y:삭제 N:삭제안함 -->
<input type="hidden" id="step4_docID" /> <!-- 선택된 문서  -->
<input type="hidden" id="step5_pk" /> <!-- 필수결재선 정보 form_id + act_id -->
<input type="hidden" id="step5_empSeq" /> <!-- 필수결재 변경할 사용자seq -->
<input type="hidden" id="step6_pk" /> <!-- 문서함 정보 -->
<input type="hidden" id="step6_empSeq" /> <!-- 문서함 대체자seq -->
<input type="hidden" id="step7_pk" /> <!-- 게시판 정보 -->
<input type="hidden" id="step7_empSeq" /> <!-- 게시판 대체자seq -->
<input type="hidden" id="step8_empSeq" value=""/> <!-- 마스터권한 대체자seq -->
<input type="hidden" id="isMasterAuth" value="${isMasterAuth}"/> <!-- 마스터권한 유무(Y/N) -->

	<div class="pop_head">
		<h1 id="popTitle"></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div><!-- //pop_head -->	
	<div class="pop_con">
	   <div class="tit_step">
            <ul id="naviUl">
            	<c:if test="${isMasterAuth == 'N'}">
            		<c:if test="${loginVO.eaType != 'ea'}">
		                <li class="on"><span><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017952","메일정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000016245","부서정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>	                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>	                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017955","문서함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017956","게시함 권한")%></span></li>
	                	<li class=""><span> > <%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></li>
	                </c:if>
	                <c:if test="${loginVO.eaType == 'ea' && params.changeDept != 'Y'}">
		                <li class="on"><span><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017952","메일정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000016245","부서정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>	                
		                <li class="" id="eaStep5"><span> > <%=BizboxAMessage.getMessage("TX000010082","대결자설정")%></span></li>	                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX900000181","기록물/철 처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","발송권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","관인사용권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017955","문서함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017956","게시함 권한")%></span></li>
	                	<li class=""><span> > <%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></li>
	                </c:if>
	                <c:if test="${loginVO.eaType == 'ea' && params.changeDept == 'Y'}">
		                <li class="on"><span> <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>	                
		                <li class="" id="eaStep5"><span> > <%=BizboxAMessage.getMessage("TX000010082","대결자설정")%></span></li>	                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX900000181","기록물/철 처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","발송권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","관인사용권한")%></span></li>
	                </c:if>
                </c:if>
                
                <c:if test="${isMasterAuth == 'Y'}">
                	<c:if test="${loginVO.eaType != 'ea'}">
	                	<li class="on"><span><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></span></li>
	                	<li class=""><span> > <%=BizboxAMessage.getMessage("TX000017952","메일정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000016245","부서정보")%></span></li>	
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017955","문서함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017956","게시함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017957","마스터 권한")%></span></li>
                	</c:if>
                	<c:if test="${loginVO.eaType == 'ea' && params.changeDept != 'Y'}">
                		<li class="on"><span><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></span></li>
	                	<li class=""><span> > <%=BizboxAMessage.getMessage("TX000017952","메일정보")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000016245","부서정보")%></span></li>	
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>                
		                <li class="" id="eaStep5"><span> > <%=BizboxAMessage.getMessage("TX000010082","대결자설정")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX900000181","기록물/철 처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","발송권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","관인사용권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017955","문서함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017956","게시함 권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000017957","마스터 권한")%></span></li>
                	</c:if>
                	<c:if test="${loginVO.eaType == 'ea' && params.changeDept == 'Y'}">
		                <li class="on"><span> <%=BizboxAMessage.getMessage("TX000017954","필수결재라인")%></span></li>	                
		                <li class="" id="eaStep5"><span> > <%=BizboxAMessage.getMessage("TX000010082","대결자설정")%></span></li>	                
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX000022165","결재문서처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("TX900000181","기록물/철 처리")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","발송권한")%></span></li>
		                <li class=""><span> > <%=BizboxAMessage.getMessage("","관인사용권한")%></span></li>
	                </c:if>
                </c:if>
            </ul>

        </div>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
					<td>${params.compNm}</td>
					<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
					<td>${params.deptNm}</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000075","아이디")%></th>
					<td>${params.loginId}</td>
					<th><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
					<td>${params.empNm}</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
					<td>${params.positionCodeNm}</td>
					<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
					<td>${params.dutyCodeNm}</td>
				</tr>
			</table>
		</div>
		
		<%-- <div class="com_ta mt14">
            <table>
                <colgroup>
                    <col width="130"/>
                    <col width=""/>
                </colgroup>
                <tr>
                    <th><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></th>
                    <td><input id="out_date" class="dpWid" style="width:;"/></td>
            </table>
        </div> --%>
        <!-- <div style="height: 200px"></div> -->	
		
		<div class="step_div1" id="step_div1" stepCnt="1" <c:if test="${params.changeDept == 'Y'}">style="display:none;"</c:if> > 
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016066","회사겸직정보")%></th>
                        <td>
                            <div class="fl lh23" <c:if test="${loginVO.userSe != 'MASTER'}">style="display:none;"</c:if>>
                                <input type="radio" name="isAll" id="mf1" class="k-radio" value="N" checked="checked"/>
                                <label class="k-radio-label radioSel" for="mf1"><%=BizboxAMessage.getMessage("TX000016197","선택한 회사만 퇴사처리")%></label>
                                <input type="radio" name="isAll" id="mf2" class="k-radio" value="Y"/>
                                <label class="k-radio-label radioSel ml10" for="mf2"><%=BizboxAMessage.getMessage("TX000016379","겸직회사 모두 퇴사처리")%></label>
                            </div>
                            <div class="controll_btn <c:if test="${loginVO.userSe == 'MASTER'}">fr</c:if> p0">
                                <button onclick="compInfo()"><%=BizboxAMessage.getMessage("TX000016378","겸직회사 정보")%></button>
                            </div>
                        </td>
                </table>
            </div>  

            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000113","퇴사일")%></th>
                        <td><input id="out_date" value="2015-01-01" class="dpWid" style="width:;"/></td>
                </table>
            </div>  
        </div>	
        
        
        <div class="step_div2" id="step_div2" stepCnt="2" style=" display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016286","메일정보삭제")%></th>
                        <td>
                            <div class="fl lh23">
                                <input type="radio" name="mailDelYn" id="myn1" class="k-radio" checked="checked" value="Y" onchange="setStepData('2')"/>
                                <label class="k-radio-label radioSel" for="myn1"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
                                <input type="radio" name="mailDelYn" id="myn2" class="k-radio" value="N" onchange="setStepData('2')"/>
                                <label class="k-radio-label radioSel ml10" for="myn2"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
                            </div>
                        </td>
                </table>
            </div>  

            <div class="com_ta4 mt14">
                <table>
                    <colgroup>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <td class="le" style="vertical-align:top; height:90px">
                            <p class="text_red lh23" id="mailDelTxt"> <%=BizboxAMessage.getMessage("TX900000182","※ 사용자의 메일 계정 및 메일정보가 모두 삭제 처리되며, 복구는 불가능 합니다.")%> </p>
                            <p class="text_red lh23" id="mailDelTxt2"> <%=BizboxAMessage.getMessage("TX900000183","※ 겸직 회사의 메일 계정 및 메일 정보가 모두 삭제처리 되며, 복구는 불가능 합니다.")%></p>   
                            <p class="text_red lh23" id="mailDelTxt3"> <%=BizboxAMessage.getMessage("TX900000184","(단 회사별로 동일한 도메인을 사용하는 경우, 메일 정보를 삭제할 수 없어 ‘아니오’인 상태로 비활성화 처리됩니다.)")%></p>
                            <p class="text_blue lh23" id="mailNonDelTxt1"> <%=BizboxAMessage.getMessage("TX900000185","※ 메일 계정 및 메일 정보가 삭제 처리되지 않습니다.")%></p>                            
                        </td>
                    </tr>
                </table>
            </div>  
        </div><!--// step_div3 -->
        
        
        
        <div class="step_div3" id="step_div3" stepCnt="3" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016244","부서정보삭제")%></th>
                        <td>
                            <div class="fl lh23">
                                <input type="radio" name="deptDeletYn" id="yn1" class="k-radio" value="Y" onclick="checkMailinfo()"/>
                                <label class="k-radio-label radioSel" for="yn1"><%=BizboxAMessage.getMessage("TX000002850","예")%></label>
                                <input type="radio" name="deptDeletYn" id="yn2" class="k-radio" value="N" checked="checked"/>
                                <label class="k-radio-label radioSel ml10" for="yn2"><%=BizboxAMessage.getMessage("TX000006217","아니오")%></label>
                            </div>
                        </td>
                </table>
            </div>  

            <div class="com_ta2 mt14">
                <table>
                    <colgroup>
                        <col width="300"/>
                        <col width="300"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
                    </tr>
                </table>
            </div>            
            <div class="com_ta2 bg_lightgray ova_sc" style="height:185px;">
                <table>
                    <colgroup>
                        <col width="300"/>
                        <col width="300"/>
                        <col width=""/>
                    </colgroup>
                    <tbody id="step3Table">                        
                    </tbody>
                </table>
            </div>  
        </div><!--// step_div2 -->
        
        
        <c:if test="${loginVO.eaType != 'ea'}">
        <div class="step_div4" id="step_div4" style="display:none;">        	
        	<div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX900000186","양식 건수")%></th>
                        <td> <input type="text" class="ar pr10" style="width:80px;" readonly id="mustCnt"/>  건</td>
                        <td style="text-align: right; border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
                        <span style="color:red"><%=BizboxAMessage.getMessage("TX900000187","! 대체자가 지정되지 않은 결재라인정보는 자동 삭제합니다.")%></span>
                        </td>
                    </tr>
                </table>
            </div>  
            <div class="controll_btn">  
            	<span style="color:red; margin-right: 310px;"><%=BizboxAMessage.getMessage("TX900000188","!수신참조자 또는 시행자의 경우, 별도 대체자 지정 없이 자동 삭제됩니다.")%></span>              
                <button id="" onclick="fnSetEaMustRoleAppLine();"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
            </div>
            <div class="com_ta2 mt0">
                <table>
                    <colgroup>
                        <col width="180"/>
                        <col width="180"/>
                        <col width="180"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000173","양식명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004511","결재종류")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000003433","결재구분")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step4Table">
	                <colgroup>
                        <col width="180"/>
                        <col width="180"/>
                        <col width="180"/>
                        <col width=""/>
                    </colgroup>
	            </table>
	        </div>
        </div><!--// step_div4 -->
        
        
       
	        <div class="step_div5" id="step_div5" style="display:none;">
	        	<div class="com_ta mt14">
	                <table>
	                    <colgroup>
	                        <col width="130"/>
	                        <col width="200"/>
	                        <col width=""/>
	                    </colgroup>
	                    <tr>
	                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
	                        <td>
	                            <input id="com_sel" onchange="step5DocData();">
	                        </td>
	                        <td style="border-left-color: currentColor; border-left-width: 0px; 
	                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
	                        <span style=""><%=BizboxAMessage.getMessage("TX900000189","총 결재 건수 : ")%></span> 
	                        <span style="color: red;" id="mkZone">0</span>
	                        </td>
	                    </tr>
	                </table>
	            </div>  
	            
	            <div class="mt20 posi_re">
	            	<div class="tab_nor" >
						<ul>
							<li class="appTab on" id="appTab1"><a href="javascript:tab_nor_Fn(1);"><%=BizboxAMessage.getMessage("TX000003976","미결")%> (<span id="appTab1Cnt" class="">0</span> )</a></li>
							<li class="appTab" id="appTab2"><a href="javascript:tab_nor_Fn(2)"><%=BizboxAMessage.getMessage("TX000001227","후결")%> (<span id="appTab2Cnt" class="">0</span> )</a></li>
							<li class="appTab" id="appTab3"><a href="javascript:tab_nor_Fn(3)"><%=BizboxAMessage.getMessage("TX000007898","예정")%> (<span id="appTab3Cnt" class="">0</span> )</a></li>
						</ul>
					</div>
					<div class="controll_btn posi_ab" style="top:-4px; right:0px;">
		            	<span style="color:#058df5; margin-right: 127px;"><%=BizboxAMessage.getMessage("TX900000190","※퇴사자의 대결정보는 자동 삭제 처리 됩니다.")%></span>
		                <button onclick="fnMultiAppDocApprovalProc()" id="btnAppTab1"><%=BizboxAMessage.getMessage("TX000003797","일괄결재")%></button>
		                <button onclick="fnMultiAppDocApprovalProc()" style="display: none;" id="btnAppTab3"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
		            </div>
					<div class="tab_area pt10">
						<!-- 탭 -->
						<div class="tab1">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="100"/>
				                        <col width="100"/>
				                        <col width="130"/>
				                        <col width="185"/>
				                        <col width="80"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX000000492","문서분류")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000018380","품의번호")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000018669","제목")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000021750","기안일")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000018600","기안자")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step5Tab1">
					            	<colgroup>
				                        <col width="100"/>
				                        <col width="100"/>
				                        <col width="130"/>
				                        <col width="185"/>
				                        <col width="80"/>
				                        <col width=""/>
				                    </colgroup>			                    
					            </table>
					        </div> 
	
						</div>
							
							
						<!-- 탭2 -->
						<div class="tab2" style="display:none;">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="100"/>
				                        <col width="100"/>
				                        <col width="130"/>
				                        <col width="185"/>
				                        <col width="80"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX000000492","문서분류")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000491","품의번호")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000493","제목")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000021750","기안일")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000499","기안자")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step5Tab2">
					            </table>
					        </div>
						</div>
						
						
						<!-- 탭 3-->
						<div class="tab3" style="display:none;">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="100"/>
				                        <col width="100"/>
				                        <col width="130"/>
				                        <col width="100"/>
				                        <col width="80"/>
				                        <col width="80"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX000000492","문서분류")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000491","품의번호")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000493","제목")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000021750","기안일")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000499","기안자")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000020510","대결자")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step5Tab3">
					            </table>
					        </div>
						</div>
					</div><!--// tab_area -->			
	                
	        	</div><!--// step_div5 -->
	        </div>
	        
	        <div class="step_div6" id="step_div6" style=" display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016278","문서함 담당자 권한")%></th>
                        <td> <input type="text" class="ar pr10" style="width:80px;" readonly id="docCnt"/>  건</td>
                        <td style="text-align: right; border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;">
                        <span style="color:red"><%=BizboxAMessage.getMessage("TX000016461","* 대체자를 선택하지 않은 문서함 권한은 자동 삭제 됩니다.")%></span>
                </table>
            </div>  
            <div class="com_ta2 mt14">
                <table>
                    <colgroup>
                        <col width="350"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016335","담당 중인 문서함")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step6Table">
	                <colgroup>
	                        <col width="350"/>
	                        <col width=""/>
	                </colgroup>
	            </table>
	        </div>
        </div><!--// step_div6 -->


        <div class="step_div7" id="step_div7" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016386","게시판 담당자 권한")%></th>
                        <td><input type="text" class="ar pr10" style="width:80px;" readonly id="boardCnt"/> 건</td>
                        <td style="text-align: right; border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;">
                        <span style="color:red"><%=BizboxAMessage.getMessage("TX000016463","* 대체자를 선택하지 않은 게시판 권한은 자동 삭제 됩니다.")%></span>
                </table>
            </div>  
            <div class="com_ta2 mt14">
                <table>
                    <colgroup>
                        <col width="350"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016336","담당 중인 게시판")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step7Table">
	                <colgroup>
	                        <col width="350"/>
	                        <col width=""/>
	                    </colgroup>
	            </table>
	        </div>
        </div><!--// step_div7 -->
        
		<c:if test="${loginVO.userSe == 'MASTER'}">
        <div class="step_div8" id="step_div8" style="display:none;">
            <div class="com_ta4 mt14">
                <table>
                    <colgroup>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <td class="le" style="vertical-align:top; height:90px">
                            <p class="text_red lh23"> <%=BizboxAMessage.getMessage("TX900000191","※ 퇴사일 STEP에서 ‘겸직회사 모두 퇴사처리’ 를 선택한 경우, 1:1대화방, 1:N 대화방에서 모두 나가기 처리됩니다.")%></p>
                            <p class="text_blue lh23"> <%=BizboxAMessage.getMessage("TX900000192","※ 퇴사일 STEP에서 ‘선택한 회사만 퇴사처리’ 를 선택한 경우, 겸직정보가 남아있어 대화방 나가기 기능을 제공하지 않습니다.")%></p>                            
                        </td>
                    </tr>
                </table>
            </div>             
        </div>   		
		</c:if>        
        
        <c:if test="${isMasterAuth == 'Y'}">  
        <div class="step_div9" id="step_div9" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000017959","마스터 권한 설정")%></th>
                        <td>
                            <div class="controll_btn ac p0">
                                <input type="radio" name="masterAuthDelYn" id="mYn1" class="k-radio" checked="checked" value="Y" onclick="fnMasterAuthSetting()"/>
                                <label class="k-radio-label radioSel" for="mYn1"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="radio" name="masterAuthDelYn" id="mYn2" class="k-radio" value="N" onclick="fnMasterAuthSetting()"/>
                                <label class="k-radio-label radioSel ml10" for="mYn2"><%=BizboxAMessage.getMessage("TX000017960","대체자 지정")%></label>&nbsp;&nbsp;&nbsp;&nbsp;
                                <button id="btnMasterSubUser" disabled="disabled" onclick="openOrgCahrtCommonPop2()"><%=BizboxAMessage.getMessage("TX000016329","대체자 선택")%></button>
            					<input type="text" style="width:120px;" class="pl10" id="txtMasterSubUser" readonly="readonly" disabled="disabled"/>
                            </div>
                        </td>
                </table>
            </div>         
        </div>
        </c:if>
        </c:if>
       
        
        <c:if test="${loginVO.eaType == 'ea'}">
        <c:if test="${params.changeDept == 'Y'}">
        	<div class="step_div4" id="step_div4">
        </c:if>
        <c:if test="${params.changeDept != 'Y'}">
        	<div class="step_div4" id="step_div4" style="display:none;">
        </c:if>
        	
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
						<col width="250"/>
						<col width="130"/>
						<col width=""/>
                    </colgroup>
                    <tr>
                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
                        <td>
                            <input id="com_sel_ea4" onchange="eaComSelChange('4', this);">
                        </td>
                        <th><%=BizboxAMessage.getMessage("TX900000193","결재라인 건수")%></th>
                        <td> <input type="text" class="ar pr10" style="width:80px;" readonly id="step4Cnt"/>  건</td>
                    </tr>
                </table>
                </br>
                <span style="color:red;"><%=BizboxAMessage.getMessage("TX900000187","! 대체자가 지정되지 않은 결재라인정보는 자동 삭제합니다.")%></span></br>
                <span style="color:red;"><%=BizboxAMessage.getMessage("TX900000194","! 필수열람자의 경우, 별도 대체자 지정 없이 자동 삭제됩니다.")%></span>
            </div>
            
            
            <div class="mt20 posi_re">
	            	<div class="tab_nor" >
						<ul>
							<li class="appTab on" id="appTab1"><a href="javascript:tab_nor_Fn(1);"><%=BizboxAMessage.getMessage("TX900000195","필수결재")%> (<span id="step4Tab1Cnt" class="">0</span> )</a></li>
							<li class="appTab" id="appTab2"><a href="javascript:tab_nor_Fn(2)"><%=BizboxAMessage.getMessage("TX000021038","결재그룹")%> (<span id="step4Tab2Cnt" class="">0</span> )</a></li>
							<li class="appTab" id="appTab3"><a href="javascript:tab_nor_Fn(3)"><%=BizboxAMessage.getMessage("TX000011947","감사")%> (<span id="step4Tab3Cnt" class="">0</span> )</a></li>
						</ul>
					</div>
					<div class="controll_btn posi_ab" style="top:-4px; right:0px;">		            	
		                <button onclick="eaDocProc('4')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
		            </div>
					<div class="tab_area pt10">
						<!-- 탭 -->
						<div class="tab1">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="130"/>
				                        <col width="130"/>
				                        <col width="160"/>
				                        <col width="110"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX000016763","양식명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000175","결재종류")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000003433","결재구분")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step4Tab1">
					            	<colgroup>
				                        <col width="130"/>
				                        <col width="130"/>
				                        <col width="160"/>
				                        <col width="110"/>
				                        <col width=""/>
				                    </colgroup>			                    
					            </table>
					        </div> 
	
						</div>
							
							
						<!-- 탭2 -->
						<div class="tab2" style="display:none;">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="250"/>
				                        <col width="250"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX000003424","결재라인명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step4Tab2">
					            	<colgroup>
				                        <col width="250"/>
				                        <col width="250"/>
				                        <col width=""/>
				                    </colgroup>			                    
					            </table>
					        </div>
						</div>
						
						
						<!-- 탭 3-->
						<div class="tab3" style="display:none;">
							<div class="com_ta2">
				                <table>
				                    <colgroup>
				                        <col width="250"/>
				                        <col width="250"/>
				                        <col width=""/>
				                    </colgroup>
				                    <tr>
				                        <th><%=BizboxAMessage.getMessage("TX900000196","감사그룹명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
				                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
				                    </tr>
				                </table>
				            </div>  
				
				            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
					            <table id="step4Tab3">
					            	<colgroup>
				                        <col width="250"/>
				                        <col width="250"/>
				                        <col width=""/>
				                    </colgroup>			                    
					            </table>
					        </div>
						</div>
					</div><!--// tab_area -->			
	                
	        	</div>
                         
        	</div>
        	
        	
        	<div class="step_div5" id="step_div5" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
						<col width="250"/>
						<col width="130"/>
						<col width=""/>
                    </colgroup>
                    <tr>
                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
                        <td>
                            <input id="com_sel_ea5" onchange="eaComSelChange('5', this);">
                        </td>
                        <th><%=BizboxAMessage.getMessage("TX900000197","대결자 권한")%></th>
                        <td> <input type="text" class="ar pr10" style="width:80px;" readonly id="step5Cnt"/>  건</td>
                    </tr>
                </table>
            </div>  
            <div class="controll_btn">
                <button id="" onclick="eaDocProc('5')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
            </div>
            <div class="com_ta2 mt0">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000020510","대결자")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000016238","부재자")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000021507","부재사유")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000019422","부재기간")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step5Tab1">
	            </table>
	        </div>             
        	</div>
        	
        	
        	<div class="step_div6" id="step_div6" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
                        <td>
                            <input id="com_sel_ea6" onchange="eaComSelChange('6', this);">
                        </td>
                        <td style="border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
                        <span style=""><%=BizboxAMessage.getMessage("TX900000189","총 결재 건수 : ")%></span> 
                        <span style="color: red;" id="step6Cnt">0</span>
                        </td>
                    </tr>
                </table>
            </div>   
            <div class="mt10 posi_re">
				<span style="color:red;"><%=BizboxAMessage.getMessage("TX900000198","!퇴사자의 내접수함에 있는 문서는 부서접수함으로 자동 변경됩니다.")%></span>
			</div>
            
            <div class="mt20 posi_re">
            	<div class="tab_nor" id="tab2">
					<ul>
						<li class="appTab on" id=""><a href="javascript:tab_nor_Fn2(1);"><%=BizboxAMessage.getMessage("TX000010935","대기")%> (<span id="appStep6Tab1Cnt" class="">0</span> )</a></li>
						<li class="appTab" id=""><a href="javascript:tab_nor_Fn2(2)"><%=BizboxAMessage.getMessage("TX000007898","예정")%> (<span id="appStep6Tab2Cnt" class="">0</span> )</a></li>
						<li class="appTab" id=""><a href="javascript:tab_nor_Fn2(3)"><%=BizboxAMessage.getMessage("TX000001227","후결")%> (<span id="appStep6Tab3Cnt" class="">0</span> )</a></li>
						<li class="appTab" id=""><a href="javascript:tab_nor_Fn2(4)"><%=BizboxAMessage.getMessage("TX000020836","비상근감사")%> (<span id="appStep6Tab4Cnt" class="">0</span> )</a></li>
					</ul>
				</div>
				<div class="controll_btn posi_ab" style="top:-4px; right:0px;">	            	
	                <button onclick="eaDocProc('6')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	            </div>
				<div class="tab_area pt10">
					<!-- 탭 -->
					<div class="tab1">
						<div class="com_ta2">
			                <table>
			                    <colgroup>
			                        <col width="100"/>
			                        <col width="100"/>
			                        <col width="130"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width=""/>
			                    </colgroup>
			                    <tr>
			                        <th><%=BizboxAMessage.getMessage("TX000007371","문서구분")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018669","제목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000022119","기안일자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018600","기안자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000008874","결재유형")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX900000199","대결자 설정")%></th>
			                    </tr>
			                </table>
			            </div>  
			
			            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
				            <table id="step6Tab1">
				            </table>
				        </div> 

					</div>
						
						
					<!-- 탭 2-->
					<div class="tab2" style="display:none;">
						<div class="com_ta2">
			                <table>
			                    <colgroup>
			                        <col width="100"/>
			                        <col width="100"/>
			                        <col width="130"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width=""/>
			                    </colgroup>
			                    <tr>
			                        <th><%=BizboxAMessage.getMessage("TX000007371","문서구분")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018669","제목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000022119","기안일자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018600","기안자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000008874","결재유형")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX900000199","대결자 설정")%></th>
			                    </tr>
			                </table>
			            </div>  
			
			            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
				            <table id="step6Tab2">
				            </table>
				        </div>
					</div>
					
					
					<!-- 탭 3-->
					<div class="tab3" style="display:none;">
						<div class="com_ta2">
			                <table>
			                    <colgroup>
			                        <col width="100"/>
			                        <col width="100"/>
			                        <col width="130"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width="80"/>
			                        <col width=""/>
			                    </colgroup>
			                    <tr>
			                        <th><%=BizboxAMessage.getMessage("TX000007371","문서구분")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018669","제목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000022119","기안일자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018600","기안자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000008874","결재유형")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX900000199","대결자 설정")%></th>
			                    </tr>
			                </table>
			            </div>  
			
			            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
				            <table id="step6Tab3">
				            </table>
				        </div>
					</div>
					
					<!-- 탭 4-->
					<div class="tab4" style="display:none;">
						<div class="com_ta2">
			                <table>
			                    <colgroup>
			                        <col width="100"/>
			                        <col width="100"/>
			                        <col width="130"/>
			                        <col width="80"/>
			                        <col width="160"/>
			                        <col width=""/>
			                    </colgroup>
			                    <tr>
			                     	<th><%=BizboxAMessage.getMessage("TX000007371","문서구분")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018669","제목")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000022119","기안일자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000000500","기안부서")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX000018600","기안자")%></th>
			                        <th><%=BizboxAMessage.getMessage("TX900000199","대결자 설정")%></th>
			                    </tr>
			                </table>
			            </div>  
			
			            <div class="com_ta2 ova_sc bg_lightgray" style="height:129px;">
				            <table id="step6Tab4">
				            </table>
				        </div>
					</div>
				</div><!--// tab_area -->			
                
        	</div><!--// step_div5 -->           
        	</div>
        	
        	
        	<div class="step_div7" id="step_div7" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
                        <td>
                            <input id="com_sel_ea7" onchange="eaComSelChange('7', this);">
                        </td>
                        <td style="border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
                        <span style=""><%=BizboxAMessage.getMessage("TX900000200","기록물/철 건수 : ")%></span> 
                        <span style="color: red;" id="step7Cnt">0</span>
                        </td>
                    </tr>
                </table>
            </div>           
            
            <div class="controll_btn">
                <button id="" onclick="eaDocProc('7')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
            </div>
            <div class="com_ta2 mt0">
                <table>
                    <colgroup>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX900000201","기록물/철")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000767","담당부서")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000018368","담당자")%></th>
                        <th><%=BizboxAMessage.getMessage("TX900000202","건수")%></th>
                        <th><%=BizboxAMessage.getMessage("TX900000203","담당자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step7Tab1">
	                <colgroup>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width="130"/>
                        <col width=""/>
                    </colgroup>
	            </table>
	        </div>  
        	</div>
        	        	
        	<div class="step_div8" id="step_div8" style="display:none;">
	            <div class="com_ta mt14">  
	            	<table>
	                    <colgroup>
	                        <col width="130"/>
	                        <col width="200"/>
	                        <col width=""/>
	                    </colgroup>
	                    <tr>
	                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
	                        <td>
	                            <input id="com_sel_ea8" onchange="eaComSelChange('8', this);">
	                        </td>
	                        <td style="border-left-color: currentColor; border-left-width: 0px; 
	                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
	                        <span style=""><%=BizboxAMessage.getMessage("","발송권한 건수 : ")%></span> 
	                        <span style="color: red;" id="step8Cnt">0</span>
	                        </td>
	                    </tr>
	                </table>      
		        </div> 
		        <div class="mt10 posi_re">
					<span style="color:red;"><%=BizboxAMessage.getMessage("","!대체자가 지정되지 않아 발송권한자가 없을 경우, 부서의 모든 사용자에게 문서가 조회됩니다.")%></span>
				</div>
		        <div class="controll_btn">
	                <button id="" onclick="eaDocProc('8')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	            </div>
	            <div class="com_ta2 mt0">
	                <table>
	                    <colgroup>
	                        <col width="250"/>
	                        <col width="250"/>
	                        <col width=""/>
	                    </colgroup>
	                    <tr>
	                        <th><%=BizboxAMessage.getMessage("","부서명")%></th>
	                        <th><%=BizboxAMessage.getMessage("","권한구분")%></th>
	                        <th><%=BizboxAMessage.getMessage("","대체자 설정")%></th>
	                    </tr>
	                </table>
	            </div>  
	
	            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
		            <table id="step8Tab1">
		                <colgroup>
	                        <col width="250"/>
	                        <col width="250"/>
	                        <col width=""/>
	                    </colgroup>
		            </table>
		        </div> 
		         
        	</div>
        	        	
        	<div class="step_div9" id="step_div9" style="display:none;">
	            <div class="com_ta mt14">  
	            	<table>
	                    <colgroup>
	                        <col width="130"/>
	                        <col width="200"/>
	                        <col width=""/>
	                    </colgroup>
	                    <tr>
	                    	<th><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
	                        <td>
	                            <input id="com_sel_ea9" onchange="eaComSelChange('9', this);">
	                        </td>
	                        <td style="border-left-color: currentColor; border-left-width: 0px; 
	                        border-left-style: none;"><!-- <input class="ar pr10" type="button" value="필수라인 전체삭제"> -->
	                        <span style=""><%=BizboxAMessage.getMessage("","발송권한 건수 : ")%></span> 
	                        <span style="color: red;" id="step9Cnt">0</span>
	                        </td>
	                    </tr>
	                </table>      
		        </div>
		        <div class="mt10 posi_re">
					<span style="color:red;"><%=BizboxAMessage.getMessage("","!대체자가 지정되지 않아 관인의 사용범위가 미설정된 경우, 관인의 종류에 따라 회사/부서 전체에 노출됩니다.")%></span>
				</div> 
		        <div class="controll_btn">
	                <button id="" onclick="eaDocProc('9')"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	            </div>
	            <div class="com_ta2 mt0">
	                <table>
	                    <colgroup>
	                        <col width="200"/>
	                        <col width="200"/>
	                        <col width="200"/>
	                        <col width=""/>
	                    </colgroup>
	                    <tr>
	                        <th><%=BizboxAMessage.getMessage("","종류")%></th>
	                        <th><%=BizboxAMessage.getMessage("","관인명")%></th>
	                        <th><%=BizboxAMessage.getMessage("","부서명")%></th>
	                        <th><%=BizboxAMessage.getMessage("","대체자 설정")%></th>
	                    </tr>
	                </table>
	            </div>  
	
	            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
		            <table id="step9Tab1">
		                <colgroup>
	                        <col width="200"/>
	                        <col width="200"/>
	                        <col width="200"/>
	                        <col width=""/>
	                    </colgroup>
		            </table>
		        </div>
        	</div>        	
        	
        	<div class="step_div10" id="step_div10" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016278","문서함 담당자 권한")%></th>
                        <td> <input type="text" class="ar pr10" style="width:80px;" readonly id="docCnt"/>  건</td>
                        <td style="text-align: right; border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;">
                        <span style="color:red"><%=BizboxAMessage.getMessage("TX000016461","* 대체자를 선택하지 않은 문서함 권한은 자동 삭제 됩니다.")%></span>
                </table>
            </div>  
            <div class="com_ta2 mt14">
                <table>
                    <colgroup>
                        <col width="350"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016335","담당 중인 문서함")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step6Table">
	                <colgroup>
	                        <col width="350"/>
	                        <col width=""/>
	                </colgroup>
	            </table>
	        </div>             
        	</div>
        	
        	
        	
        	<div class="step_div11" id="step_div11" style="display:none;">
            <div class="com_ta mt14">
                <table>
                    <colgroup>
                        <col width="200"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016386","게시판 담당자 권한")%></th>
                        <td><input type="text" class="ar pr10" style="width:80px;" readonly id="boardCnt"/> 건</td>
                        <td style="text-align: right; border-left-color: currentColor; border-left-width: 0px; 
                        border-left-style: none;">
                        <span style="color:red"><%=BizboxAMessage.getMessage("TX000016463","* 대체자를 선택하지 않은 게시판 권한은 자동 삭제 됩니다.")%></span>
                </table>
            </div>  
            <div class="com_ta2 mt14">
                <table>
                    <colgroup>
                        <col width="350"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000016336","담당 중인 게시판")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000004495","대체자 설정")%></th>
                    </tr>
                </table>
            </div>  

            <div class="com_ta2 ova_sc bg_lightgray" style="height:185px;">
	            <table id="step7Table">
	                <colgroup>
	                        <col width="350"/>
	                        <col width=""/>
	                    </colgroup>
	            </table>
	        </div>             
        	</div>
        	
        	<c:if test="${loginVO.userSe == 'MASTER'}">
        	<div class="step_div12" id="step_div12" style="display:none;">
            <div class="com_ta4 mt14">
                <table>
                    <colgroup>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <td class="le" style="vertical-align:top; height:90px">
                            <p class="text_red lh23"> <%=BizboxAMessage.getMessage("TX900000191","※ 퇴사일 STEP에서 ‘겸직회사 모두 퇴사처리’ 를 선택한 경우, 1:1대화방, 1:N 대화방에서 모두 나가기 처리됩니다.")%></p>
                            <p class="text_blue lh23"> <%=BizboxAMessage.getMessage("TX900000192","※ 퇴사일 STEP에서 ‘선택한 회사만 퇴사처리’ 를 선택한 경우, 겸직정보가 남아있어 대화방 나가기 기능을 제공하지 않습니다.")%></p>                            
                        </td>
                    </tr>
                </table>
            </div>             
        	</div>
        	</c:if>
        	
        	
        	<c:if test="${isMasterAuth == 'Y'}"> 
        		<c:if test="${loginVO.userSe == 'MASTER'}">
	        	<div class="step_div13" id="step_div13" style="display:none;">
	        	</c:if>
	        	<c:if test="${loginVO.userSe != 'MASTER'}">
	        	<div class="step_div12" id="step_div12" style="display:none;">
	        	</c:if>
		            <div class="com_ta mt14">
		                <table>
		                    <colgroup>
		                        <col width="200"/>
		                        <col width=""/>
		                    </colgroup>
		                    <tr>
		                        <th><%=BizboxAMessage.getMessage("TX000017959","마스터 권한 설정")%></th>
		                        <td>
		                            <div class="controll_btn ac p0">
		                                <input type="radio" name="masterAuthDelYn" id="mYn1" class="k-radio" checked="checked" value="Y" onclick="fnMasterAuthSetting()"/>
		                                <label class="k-radio-label radioSel" for="mYn1"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		                                <input type="radio" name="masterAuthDelYn" id="mYn2" class="k-radio" value="N" onclick="fnMasterAuthSetting()"/>
		                                <label class="k-radio-label radioSel ml10" for="mYn2"><%=BizboxAMessage.getMessage("TX000017960","대체자 지정")%></label>&nbsp;&nbsp;&nbsp;&nbsp;
		                                <button id="btnMasterSubUser" disabled="disabled" onclick="openOrgCahrtCommonPop2()"><%=BizboxAMessage.getMessage("TX000016329","대체자 선택")%></button>
		            					<input type="text" style="width:120px;" class="pl10" id="txtMasterSubUser" readonly="readonly" disabled="disabled"/>
		                            </div>
		                        </td>
		                </table>
		            </div>         
        		</div>
        	</c:if>
        </c:if>
        
        
	</div><!-- //pop_con -->	
		<!-- <div style="height: 200px"></div> -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
		    <input type="button" value="<%=BizboxAMessage.getMessage("TX000003165","이전")%>" id="prevBtn" onclick="stepByStep('prev');"/>
		    <input type="button" value="<%=BizboxAMessage.getMessage("TX000003164","다음")%>" id="nextBtn" onclick="stepByStep('next');"/>
		    <input type="button" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" id="closeBtn" onclick="fnClose();"/>
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" id="finishBtn" onclick="ok();"/>		
			<!-- <input type="button" class="gray_btn" value="이전" />
			<input type="button" value="다음" />	 -->		
		</div>
	</div><!-- //pop_foot -->
	<div id="dialog-form-background" style="display:none; background-color:#FFFFDD;filter:Alpha(Opacity=50); z-Index:8888; width:100%; height:100%; position:absolute; top:1px"></div>
</div><!-- //pop_wrap -->

<div class="pop_wrap_dir" style="width:398px;">
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000016380","겸직정보 보기")%></h1>
        <a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
    </div>     
    <div class="pop_con">
        <div class="com_ta2"> <!-- 겸직회사정보 -->
                <table>
                    <colgroup>
                        <col width="120"/>
                        <col width="95"/>
                        <col width="77"/>
                        <col width=""/>
                    </colgroup>
                    <tr>
                        <th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
                        <th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
                    </tr>
                </table>
                </div>            
                <div class="com_ta2 ova_sc bg_lightgray" id="allCompInfo2" style="height:111px;">
                <table id="allCompTable">
                    <colgroup>
                        <col width="120"/>
                        <col width="95"/>
                        <col width="77"/>
                        <col width=""/>
                    </colgroup>
                    
            </table>            
        </div>
    </div>   
    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" onclick="compInfoClose()" value="<%=BizboxAMessage.getMessage("TX000002972","닫기")%>" />
        </div>
    </div><!-- //pop_foot -->
    
    
    <!-- 사용자 단일 선택 폼 기본 형  -->
<form id="frmPop" name="frmPop" style="display:none;">
    <input type="text" name="popUrlStr" id="txt_popup_url" width="800" value="/gw/systemx/orgChart.do"><br>
    <!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  -->
    <input type="text" name="selectMode" width="500" value="u" /><br>
    <!-- value : [s : 단일선택], [m : 복수 선택]-->
    <input type="text" name="selectItem" width="500" value="s" /><br>    
    <input type="text" name="callback" width="500" value="" />
    <input type="text" name="langCode" width="500" value="kr"/>
    
    <input type="text" name="langCode" width="500" value="kr"/><br>
	<input type="text" name="groupSeq" width="500" value=""/><br>
	<input type="text" name="compSeq" width="500" value="${compSeq }"/><br>  
	<input type="text" name="deptSeq" width="500" value="${deptSeq }"/><br>
	<input type="text" name="empSeq" width="500" value="${empSeq }"/><br>
	<input type="text" name="compFilter" width="500" value=""/><br>
	<input type="text" name="targetDeptSeq" width="500" value=""/><br>
	<input type="text" name="initMode" width="500" value=""/><br>
    <input type="text" name="callbackParam" width="500" value="params. - call back param"/><br>
    <input type="hidden" name="selectedItems" value="" />
</form>

</div>