<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

<script>

	$(document).ready(function() {
		<c:if test="${erpSyncYn == 'N'}">
		alert('<%=BizboxAMessage.getMessage("TX000021965","연동된 정보가 없습니다.\\n연동정보를 확인하여 주세요.")%>');
		fnclose();
		</c:if>
		
		$("#compName").html(opener.$("#selComp option:selected").text());
	});
	
    function fnclose(){
    	self.close();
    }
    
    function userSelectPop(){
    	var width = 799;
    	var height = 769;
    	var windowX = Math.ceil( (window.screen.width  - width) / 2 );
    	var windowY = Math.ceil( (window.screen.height - height) / 2 );
    	var pop = window.open("", "cmmOrgPop", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=no");
    	frmPop.target = "cmmOrgPop";
    	frmPop.method = "post";
    	frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
    	frmPop.submit();
    	pop.focus();    	
    }
    
    function callbackSel(jons){
    	if(jons.isSave){
    		if(jons.returnObj.length > 0){
    			$("#pmName").val(jons.returnObj[0].empName + " " + jons.returnObj[0].positionName);
    			$("#pmSeq").val(jons.returnObj[0].empSeq);
    			$("#pmDeptSeq").val(jons.returnObj[0].deptSeq);
    			$("#pmCompSeq").val(jons.returnObj[0].compSeq);
    			$("#selectedItems").val(jons.returnObj[0].superKey);
    		}else{
    			$("#pmName").val("");
    			$("#pmSeq").val("");
    			$("#pmDeptSeq").val("");
    			$("#pmCompSeq").val("");
    		}
    	}
    }
    
    function fnSave(){
    	
    	if($("#pmName").val() == ""){
    		alert("<%=BizboxAMessage.getMessage("TX000010575","PM를 선택해주세요")%>");
    		userSelectPop();
    		return
    	}
    	
		var param = {};
		param.compSeq = "${erpInfo.compSeq}";
		param.termTp = $("#termTp").val();
		param.pmSeq = $("#pmSeq").val();
		param.pmCompSeq = $("#pmCompSeq").val();
		param.pmDeptSeq = $("#pmDeptSeq").val();
		
		fnSetSyncState();
		
		$.ajax({
			type:"post",
 			url:"selectErpProjectSync.do",
 			datatype:"json",
 			data: param,
 			success:function(result){
 				
 				fnRemoveSyncState();
 				
 				if(result.syncNewList != null && result.syncNewList.length > 0){
 					
 					if(!confirm(result.syncNewList.length + "<%=BizboxAMessage.getMessage("TX900000409","건의 ERP 프로젝트를 동기화 하시겠습니까?")%>")){
 						return;
 					}
 					
 					abort = false;
 					successCnt = 0;
 					failCnt = 0;
 					nowCnt = 0;
 					totalCnt = result.syncNewList.length; 					
 					syncNewList = result.syncNewList;
 					fnSetProgress();
 					progressHandlingFunction();
 					addProject(nowCnt);
 					
 				}else{
 					alert("<%=BizboxAMessage.getMessage("TX000002020","반영할 데이터가 없습니다.")%>");
 				}
 			},			
 			error : function(e){
 				fnRemoveSyncState();
 				alert("<%=BizboxAMessage.getMessage("TX000011769","ERP연결 정보가 존재하지 않습니다")%>");	
 			}
		});    	
    }
    
    var syncNewList;
	var successCnt = 0;
	var failCnt = 0;
	var totalCnt = 0;
	var nowCnt = 0;
	var abort = false;
    
    function addProject(){

        var formData = new FormData();
        
        $.each(syncNewList[nowCnt], function(key, value){
        	
        	if(key == "nmProject")
        		value = value.replace("\r\n","");
        	
        	formData.append(key, value);
        	
        });

		$.ajax({
			url:"/project/Views/Common/systemx/projectSaveProcAPI",
		   type: 'POST',
		   data: formData,
		   cache: false,
		   async: true,
		   contentType: false,
		   processData: false,
		   success:function(result){
				   
			   if(result.modelMap.apiResult == "Y"){
				   successCnt++;
			   }else{
				   failCnt++;
			   }
			   
			   nowCnt++;
			   
			   progressHandlingFunction();
			   
			   if(!abort){
				   if(nowCnt < totalCnt){
					   addProject();
				   }else{
					   addProjectEnd();
				   }				   
			   }
 		   },			
 			error : function(e){
 				failCnt++;
 			    nowCnt++;
 			    
 			   progressHandlingFunction();
 			   
 			  if(!abort){
 				    if(nowCnt < totalCnt){
 				    	addProject();
 				    }else{
 				    	addProjectEnd();
 				    } 		 				  
 			  }
 		   }		   
		});
    }
    
    function syncAbort(){
    	
    	abort = true;
		fnRemoveProgress();
		
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX900000410","건 / 실패 : ")%>" + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.erpSyncPopCallback != null){
			opener.erpSyncPopCallback();
		}    	
    }
    
    function addProjectEnd(){
		fnRemoveProgress();
			
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX900000410","건 / 실패 : ")%>" + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.erpSyncPopCallback != null){
			opener.erpSyncPopCallback();
		}
		
		fnclose();
    }        
    
    function progressHandlingFunction() {

    	if(nowCnt < syncNewList.length){
    		parent.document.getElementById("uploadName").innerHTML = syncNewList[nowCnt].nmProject;
    	}else{
    		parent.document.getElementById("uploadName").innerHTML = "";	
    	}
    	
       	parent.document.getElementById("uploadStat").innerHTML = parseInt(((nowCnt+1) / totalCnt) * 100);
       	parent.document.getElementById("uploadStatByte").innerHTML = (nowCnt+1) + "/" + totalCnt;
    }    
    
    function fnSetProgress() {
        if (document.getElementById("UploadProgress") != null) {
        	document.getElementById('UploadProgress').style.display = 'block';  
        } else {
			var newDiv = document.createElement("div");        	
        	
            var progTag = "<div id='UploadProgress' style='position: absolute;width: 100%;background-color: red;height: 100%;z-index: 99999;top: 0;background: white;opacity: 0.8;'>";
            progTag += "<div style='padding-top: 100px;'>";
            progTag += "<div style='text-align: center;  width: 100%; height:122px;'>";
            progTag += "<p style='font-size: 20px;  font-family:initial;'>" + '<%=BizboxAMessage.getMessage("TX900000089","동기화중")%>' + "</p>";
	        progTag += "<p style='padding: 20px;font-size: 30px;font-family:initial;'><span id='uploadStat'>0</span>  %</p>";
	        progTag += "<p style='font-size:15px;font-family:initial;'><span id='uploadName'></span></p>";
	        progTag += "<p style='font-size:15px;font-family:initial;'>( <span id='uploadStatByte'>0/0</span> )</p>";
	        progTag += "<p style='padding-top: 10px;'><input onclick='syncAbort();' style='font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#000000;color:#FFFFFF;padding:0 8px; height:30px; border-bottom:1px solid #909090;line-height:22px;' type='button' value='" + '<%=BizboxAMessage.getMessage("TX000002947","취소")%>' + "' /></p>";
            progTag += "</div>";   
            
            newDiv.innerHTML  = progTag;
            
            document.getElementsByTagName("body")[0].appendChild(newDiv);
        }
    }

    function fnRemoveProgress() {
    	document.getElementById('UploadProgress').style.display = 'none';
    }
    
    function fnSetSyncState() {
        if (document.getElementById("SyncState") != null) {
        	document.getElementById('SyncState').style.display = 'block';  
        } else {
			var newDiv = document.createElement("div");        	
        	
            var progTag = "<div id='SyncState' style='position: absolute;width: 100%;background-color: red;height: 100%;z-index: 99999;top: 0;background: white;opacity: 0.8;'>";
            progTag += "<div style='padding-top: 100px;'>";
            progTag += "<div style='text-align: center;  width: 100%; height:122px;'>";
            progTag += "<p style='font-size: 20px;  font-family:initial;'>" + '<%=BizboxAMessage.getMessage("TX900000090","ERP데이터 검색중")%>' + "</p>";
            progTag += "</div>";   
            
            newDiv.innerHTML  = progTag;
            
            document.getElementsByTagName("body")[0].appendChild(newDiv);
        }
    }
    
    function fnRemoveSyncState() {
    	document.getElementById('SyncState').style.display = 'none';
    }    
    
    
</script>

<div class="pop_wrap resources_reservation_wrap" style="border:none;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX900000091","ERP프로젝트 가져오기")%></h1>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
			
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
						<td id="compName"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000021","ERP버전")%></th>
						<td>${erpInfo.erpTypeCode}</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></th>
						<td>${erpInfo.erpCompSeq} ${erpInfo.erpCompName}</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000906","진행상태")%></th>
						<td>
							<select id="termTp" style="padding-right: 20px;">
							<option value="0"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
							<option value="1" selected><%=BizboxAMessage.getMessage("TX900000411","진행중인 프로젝트(기간기준)")%></option>
							<option value="2"><%=BizboxAMessage.getMessage("TX900000412","종료된 프로젝트(기간기준)")%></option>
							<option value="3" selected><%=BizboxAMessage.getMessage("TX900000413","진행중인 프로젝트(상태값기준)")%></option>
							<option value="4"><%=BizboxAMessage.getMessage("TX900000414","종료된 프로젝트(상태값기준)")%></option>							
							</select>
						</td>
					</tr>
					<tr>
						<th><img src="/gw/Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX900000415","PM설정")%></th>
						<td colspan="3">
							<div class="dod_search">
								<input type="text" readonly class="k-textbox input_search" id="pmName" name="pmName" style="width: 279px;height:24px" placeholder="" value="" />
								<a href="#" class="btn_sear" onclick="userSelectPop()"></a>
								<input id="pmSeq" name="pmSeq" value="" type="hidden" /> 
								<input id="pmCompSeq" name="pmCompSeq" value="" type="hidden" />
								<input id="pmDeptSeq" name="pmDeptSeq" value="" type="hidden" />
							</div>
						</td>						
					</tr>
					<!-- 
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000416","동기화구분")%></th>
						<td>
							<select id="syncTp" style="padding-right: 20px;">
							<option value="new" selected>신규항목만 동기화</option>
							<option value="mod">전체 업데이트</option>
							</select>
						</td>
					</tr>
					 -->					
				</table>
			</div>
			
			<ul class="mt10">
				<li style="clear:both;background:url('../../Images/ico/ico_dot01.png') no-repeat 3px 8px;padding:0 0 0 12px;" ><%=BizboxAMessage.getMessage("TX900000417","PM설정은 가져오는 모든 프로젝트에 일괄 등록 되며 추후에 프로젝트 수정으로 변경 할 수 있습니다.")%></li>
			</ul>
			
		</div>
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnSave();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
	</div>
	
<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="compFilter" width="500" value="${erpInfo.compSeq}" />
	<input type="hidden" name="initMode" width="500" value="true" />
	<input type="hidden" name="selectMode" width="500" value="u" />
	<input type="hidden" name="selectItem" width="500" value="s" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="selectedItems" id="selectedItems" width="500" value="" />
	<input type="hidden" name="noUseDeleteBtn" width="500" value="true" />
</form>	