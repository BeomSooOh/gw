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
    
    function fnSave(){
    	
		var param = {};
		param.compSeq = "${erpInfo.compSeq}";
		
		fnSetSyncState();
		
		$.ajax({
			type:"post",
 			url:"selectErpPartnerSync.do",
 			datatype:"json",
 			data: param,
 			timeout: 90000,
 			success:function(result){
 				
 				fnRemoveSyncState();
 				
 				if(result.syncNewList != null && result.syncNewList.length > 0){
 					
 					if(!confirm(result.syncNewList.length + "<%=BizboxAMessage.getMessage("TX900000088","건의 ERP 거래처를 동기화 하시겠습니까?")%>")){
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
        	formData.append(key, value);
        });
        
		$.ajax({
			url:"/gw/systemx/partnerSaveProcAPI.do",
		   type: 'POST',
		   data: formData,
		   cache: false,
		   async: true,
		   contentType: false,
		   processData: false,
		   success:function(result){
				   
			   if(result.apiResult == "Y"){
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
		
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> / <%=BizboxAMessage.getMessage("TX000006510","실패")%> : " + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.gridRead != null){
			opener.gridRead();
		}    	
    }
    
    function addProjectEnd(){
		fnRemoveProgress();
			
		alert("<%=BizboxAMessage.getMessage("TX000011981","성공")%> : " + successCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> / <%=BizboxAMessage.getMessage("TX000006510","실패")%> : " + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%>");
		
		if(opener != null && opener.gridRead != null){
			opener.gridRead();
		}
		
		fnclose();
    }        
    
    function progressHandlingFunction() {
    	
    	if(nowCnt < syncNewList.length){
    		parent.document.getElementById("uploadName").innerHTML = syncNewList[nowCnt].lnPartner;
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
				</table>
			</div>
		</div>
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" onclick="fnSave();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnclose();" />
			</div>
		</div>
	</div>