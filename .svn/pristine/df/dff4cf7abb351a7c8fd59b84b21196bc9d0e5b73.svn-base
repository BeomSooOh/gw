<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

var batchKey = "";

$(document).ready(function() {
});
	
function dutyPosiExcelValidate(){

	    var formData = new FormData();
        formData.append("excelUploadFile", inp_files_excel.files[0]);
        formData.append("compSeq", $("#ddlCompList").val());

        $("#uploadSpin").show();
        
        var AJAX = $.ajax({
	        url: ('dutyPositionExcelValidate.do'),
	        processData: false,
	        contentType: false,
	        data: formData,
	        type: 'POST',
            xhr: function () {
                myXhr = $.ajaxSettings.xhr();
                if (myXhr.upload) {
                    myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                    myXhr.abort;
                }
                return myXhr;
            },	        
	      success:function(d){	    	  
	    	  $("#uploadSpin").hide();
	    	  document.getElementById("ddlCompList").disabled = true;
	    	  if(d.checkList != null){
	    		  setDutyPositionTable(d.checkList);	    		  
	    	  }	    	  
	      },    
	      error : function(e){
	         $("#uploadSpin").hide();
	      }
	    });
        
 		
 		$("[uploadabort=true]").click(function () {
 			$("#uploadSpin").hide();
            AJAX.abort();
        });     
}

function progressHandlingFunction(e) {
	$("#uploadSts").html(parseInt((e.loaded / e.total) * 100));
}


function setDutyPositionTable(checkList){
		var tbody = "";	
		for(var i=0;i<checkList.length;i++){
			batchKey = checkList[i].batchSeq;
	    	
	    	var check_result = fnGetResultNm(checkList[i].checkDpSeq, checkList[i].checkDpNameIsNone, checkList[i].checkDpSeqIsNone);
	    	var tr = "<tr>";
	    	var cs = check_result != "" ? "class='text_red'" : "";
	    	
	    	tr += "<td class " + cs + ">" + (check_result == "" ? "<input name='list' type='checkbox' onclick='fnCheck(this);' seq='"+checkList[i].seq+"'>" : "") + "</td>";
	    	if(checkList[i].dpType == "POSITION"){
	    		tr += "<td " + cs + ">" + "<%=BizboxAMessage.getMessage("TX000000099","직급")%>" + "</td>";	
	    	}else{
	    		tr += "<td " + cs + ">" + "<%=BizboxAMessage.getMessage("TX000000105","직책")%>" + "</td>";
	    	}	    	
	    	tr += "<td " + cs + ">" + checkList[i].dpSeq + "</td>";
	    	tr += "<td " + cs + ">" + checkList[i].dpName + "</td>";
	    	tr += "<td " + cs + ">" + (check_result == "" ? "<%=BizboxAMessage.getMessage("TX000000815","정상")%>" : "<%=BizboxAMessage.getMessage("TX000006506","오류")%>") + "</td>";
	    	tr += "<td " + cs + ">" + check_result + "</td>";
	    	tr += "</tr>";
	    	
	    	tbody += tr;
	    }					
	$("#Listtable tbody").html(tbody == "" ? "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td></tr>" : tbody);
	
	if($("input[type=checkbox][name=list]").length > 0){
		$("input[type=checkbox][name=all],[name=list]").prop("checked",true);	
	}
	
}


function fnGetResultNm(checkDpSeq, checkDpNameIsNone, checkDpSeqIsNone){
	var sReturn = "";
	
	if(checkDpSeq < 0){
		sReturn += ",<%=BizboxAMessage.getMessage("TX900000270","코드중복")%>";
	}    	
	
	if(checkDpNameIsNone < 0){
		sReturn += ",<%=BizboxAMessage.getMessage("TX900000271","코드명 이상")%>";
	}
	
	if(checkDpSeqIsNone < 0){
		sReturn += ",<%=BizboxAMessage.getMessage("TX900000272","코드이상")%>";
	}   
	return sReturn.substring(1);
}


function fnCheck(obj){
	
	var checked = $(obj)[0].checked;
	
	if($(obj).attr("name") == "all"){
		$("input[type=checkbox][name=list]").prop("checked",checked);
	}else{
		if($("input[type=checkbox][name=list]:not(:checked)").length == 0){
			$("input[type=checkbox][name=all]").prop("checked",true);
		}else{
			$("input[type=checkbox][name=all]").prop("checked",false);
		}
	}
}


function fnReset(){
	$("input[type=file]").val("");
	$("#Listtable tbody").html("<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000010743","데이타가 없습니다")%></td></tr>");
	$("input[type=checkbox][name=all]").prop("checked",false);
	document.getElementById("ddlCompList").disabled = false;
}






function fnSave(){
	
	if($("input[type=checkbox][name=list]:checked").length == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}
	
	if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
		return;
	}
	

		var saveList = new Array();
		
	    $.each($("input[type=checkbox][name=list]:checked"), function (i, t) {
	    	
	    	var saveinfo = {};
	    	saveinfo.seq = $(t).attr("seq"); 
	    	saveList.push(saveinfo);
	    });
	    
 		var tblParam = {};
 		tblParam.batchKey = batchKey;
 		tblParam.saveList = JSON.stringify(saveList);
 		
 		$.ajax({
        	type:"post",
    		url:'saveDutyPositionBatch.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
    			
    			if(result.value == "1"){
    				var s_cnt = 0;
    				var f_cnt = 0;
    				
    			    $.each(result.dutyPositionSaveList, function (i, t) {    			    	
    			    	var seq = t.seq;
    			    	
   			    		s_cnt++;
   			    		$("input[seq="+seq+"]").parents("tr").find("td").addClass("text_blue");
   			    		$($("input[seq="+seq+"]").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000001288","완료")%>");
    			    	    			    	
    			    	$("input[seq="+seq+"]").parents("tr").find("input[type=checkbox]").remove();
    			    });	       
    			    
			    	var result_msg = s_cnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000011981","성공")%>";
			    	alert(result_msg);         
			    	opener.fnGrid();
    			}
				
    		},
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
    	});    		
}


function fnCancel(){
	self.close();
}


function fnFormDownload(){
        this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=gwFormFile&fileSn=1"
    }
</script>

<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con div_form">
		
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120"/>
					<col width=""/>
					<col width="120"/>
					<col width=""/>
				</colgroup>				
				
				<!-- 엑셀등록 -->
				<tr id="excelLow" style="">
					<th class="cen"><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
					<td>						
						<select class="selectmenu" style="width:154px;" id="ddlCompList">
							<option value="0"><%=BizboxAMessage.getMessage("TX000000933","그룹")%></option>
							<c:forEach items="${compList}" var="list">
								<option value="${list.compSeq}" <c:if test="${params.compSeq == list.compSeq}">selected</c:if>>${list.compName}</option>
							</c:forEach>
						</select>
					</td>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000000343","엑셀파일")%></th>
					<td>
						<input id="inp_files_excel" type="file"/>
					</td>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000000186","양식파일")%></th>
					<td>
						<div id="" class="controll_btn p0">
							<button onclick="fnFormDownload();"><%=BizboxAMessage.getMessage("TX000001687","다운로드")%></button>
						</div>
					</td>
				</tr>
				<!-- 사진등록 -->
				<tr id="photoLow" style="display:none;">
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016205","사진파일")%></th>
					<td colspan="3">
						<input id="inp_files_photo" type="file"/>
						<font class="text_blue f11 mt5 ml10">* <%=BizboxAMessage.getMessage("TX000016207","사진 이미지가 들어있는 압축파일 선택")%></font>
					</td>
				</tr>
				<!-- 사인등록 -->
				<tr id="signLow" style="display:none;">
					<th class="cen"><%=BizboxAMessage.getMessage("TX000016209","사인파일")%></th>
					<td colspan="3">
						<input id="inp_files_sign" type="file"/>
						<font class="text_blue f11 mt5 ml10">* <%=BizboxAMessage.getMessage("TX000016211","사인 이미지가 들어있는 압축파일 선택")%></font>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- 테이블 타이틀 및 버튼 -->
		<div class="option_top mt14">
			<ul><li class="tit_li"><%=BizboxAMessage.getMessage("TX000016179","엑셀파일 체크리스트")%></li></ul>
			<div id="" class="controll_btn" style="padding:0px;float:right;">
				<button onclick="dutyPosiExcelValidate();"><%=BizboxAMessage.getMessage("TX000002752","업로드")%></button>
				<button onclick="fnReset();" uploadabort="true"><%=BizboxAMessage.getMessage("TX000002960","초기화")%></button>
				<div id="uploadSpin" style="display:none;float:left;padding-right:10px;padding-top:4px;"><strong class="k-upload-status k-upload-status-total"><spna id="uploadSts">100</spna>% Uploading...<span class="k-icon k-loading"></span></strong></div>
			</div>
		</div>

		<!-- 테이블 리스트-->
		<div class="com_ta2 mt14">
			<table>
				<colgroup>
					<col width="30"/>
					<col width="150"/>
					<col width="150"/>
					<col width="150"/>
					<col width="80"/>
					<col width=""/>
				</colgroup>
				<thead>
					<tr>
						<th><input name='all' type='checkbox' onclick="fnCheck(this);" type="checkbox"></th>
						<th><%=BizboxAMessage.getMessage("TX000022126","구분")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000209","코드명")%></th>
						<th><%=BizboxAMessage.getMessage("TX000001748","결과")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000966","사유")%></th>
					</tr>
				</thead>
			</table>		
			</div>

		<div class="com_ta2 scroll_y_on bg_lightgray" style="height:473px;">
			<table id="Listtable" class="brtn">
				<colgroup>
					<col width="30"/>
					<col width="150"/>
					<col width="150"/>
					<col width="150"/>
					<col width="80"/>
					<col width=""/>
				</colgroup>
				<tbody>
					<tr>
						<td colspan="6"><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td>
					</tr>				
				</tbody>
			</table>		
		</div>
	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="fnSave();" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" onclick="fnCancel();" uploadabort="true" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->