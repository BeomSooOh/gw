<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

<script>

	$(document).ready(function() {
		
		
		
		
		
	});
	
    function fnclose(){
    	self.close();
    }
    
    function fnSave(){
    	
    	var syncCnt = parseInt("${ldapSetInfo.ldapEmpCnt}");	
    	
		<c:if test="${ldapSetInfo.deptOuType == 'M'}">
		syncCnt += parseInt("${ldapSetInfo.ldapDeptCnt}");			
		</c:if>
		
		if(syncCnt == 0){
			alert("<%=BizboxAMessage.getMessage("TX000002020","반영할 데이터가 없습니다.")%>");
			return;
		}
    	
		if(!confirm("<%=BizboxAMessage.getMessage("TX000006312","반영하시겠습니까?")%>")){
			return;
		}
    	
		fnSetSyncState();
		
		var tblParam = {};
		tblParam.compSeq = "${compSeq}";
		
 		$.ajax({
        	type:"post",
    		url:'createLdapSyncListInfo.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
				
 				fnRemoveSyncState();
 				
 				if(result.syncNewList != null && result.syncNewList.length > 0){
 					newSyncSeq = result.newSyncSeq;
 					abort = false;
 					successCnt = 0;
 					failCnt = 0;
 					nowCnt = 0;
 					totalCnt = result.syncNewList.length; 					
 					syncNewList = result.syncNewList;
 					fnSetProgress();
 					progressHandlingFunction();
 					adSyncProcess(nowCnt);
 				}else{
 					alert("<%=BizboxAMessage.getMessage("TX000002020","반영할 데이터가 없습니다.")%>");
 				}    			
    			
    		} ,
		    error: function (result) {
		    	alert("<%=BizboxAMessage.getMessage("TX000002003", "작업이 실패했습니다.")%>");
			}
		});				
    }
    
    var syncNewList;
	var successCnt = 0;
	var failCnt = 0;
	var totalCnt = 0;
	var nowCnt = 0;
	var abort = false;
	var newSyncSeq;
    
    function adSyncProcess(){

        var formData = new FormData();
        
        $.each(syncNewList[nowCnt], function(key, value){
        	formData.append(key, value);
        });
        
        formData.append("syncSeq",newSyncSeq);
        formData.append("compSeq","${compSeq}");

		$.ajax({
			url:"ldapSyncProcess.do",
		   type: 'POST',
		   data: formData,
		   cache: false,
		   async: true,
		   contentType: false,
		   processData: false,
		   success:function(result){
				   
			   if(result.resultCode == "SUCCESS"){
				   successCnt++;
			   }else{
				   failCnt++;
			   }
			   
			   nowCnt++;
			   
			   progressHandlingFunction();
			   
			   if(!abort){
				   if(nowCnt < totalCnt){
					   adSyncProcess();
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
 				    	adSyncProcess();
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
		
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX900000474","건 / 실패")%> : " + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.erpSyncPopCallback != null){
			opener.erpSyncPopCallback();
		}    	
    }
    
    function addProjectEnd(){
		fnRemoveProgress();
			
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX900000474","건 / 실패")%> : " + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.erpSyncPopCallback != null){
			opener.erpSyncPopCallback();
		}
		
		fnclose();
    }        
    
    function progressHandlingFunction() {

    	if(nowCnt < syncNewList.length){
    		parent.document.getElementById("uploadName").innerHTML = syncNewList[nowCnt].orgName;
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
			<h1><%=BizboxAMessage.getMessage("TX900000475","AD서버 조직도 반영")%></h1>
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
						<th><%=BizboxAMessage.getMessage("TX900000237","AD 서버 IP")%></th>
						<td>${ldapSetInfo.adIp}</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000476","조직도연동 OU")%></th>
						<td>${ldapSetInfo.deptDir}</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000477","퇴사자이동 OU")%></th>
						<td>${ldapSetInfo.empDir}</td>
					</tr>
					<c:if test="${ldapSetInfo.deptOuType == 'M'}">
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000478","부서반영 대기건수")%></th>
							<td>${ldapSetInfo.ldapDeptCnt} 건</td>
						</tr>			
					</c:if>	
					<tr>
						<th><%=BizboxAMessage.getMessage("TX900000479","사원반영 대기건수")%></th>
						<td>${ldapSetInfo.ldapEmpCnt} 건</td>
					</tr>									
				</table>
			</div>
		</div>
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000423","반영")%>" onclick="fnSave();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
	</div>
	
