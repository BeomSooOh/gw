<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

	var mode;
	var groupSeq;
	var pathSeq;
	var rootPath;
	var relativePath;
	var batchKey;
	
	var empBatchSaveList = [];
	
    // 로딩이미지
    $(document).bind("ajaxStart", function () {
    	kendo.ui.progress($(".pop_con"), true);
    }).bind("ajaxStop", function () {
    	kendo.ui.progress($(".pop_con"), false);
    });	

	$(document).ready(function() {
		//기본버튼
        $(".controll_btn button").kendoButton();
		
		$("input[type=radio][name=type]").change(function() {
			switch($("input[type=radio][name=type]:checked").val()){
				case "emp" : $("#photoLow, #signLow").hide();break;
				case "photo" : $("#photoLow").show();$("#signLow").hide();break;
				case "sign" : $("#signLow").show();$("#photoLow").hide();break;
			}
			
			fnReset();
		});		
	});
	
	function fnReset(){
		$("input[type=file]").val("");
		$("#Listtable tbody").html("<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000010743","데이타가 없습니다")%></td></tr>");
		$("input[type=checkbox][name=all]").prop("checked",false);
	}
	
	function empExcelValidate(){
		
		var fileChk = false;
		
		switch($("input[type=radio][name=type]:checked").val()){
			case "emp" : fileChk = $("#inp_files_excel").val() != "" ? true : false; break;
			case "photo" : fileChk = $("#inp_files_excel").val() != "" && $("#inp_files_photo").val() ? true : false; break;
			case "sign" : fileChk = $("#inp_files_excel").val() != "" && $("#inp_files_sign").val() ? true : false; break;
		}
		
		if(!fileChk){
			alert("<%=BizboxAMessage.getMessage("TX000010702","업로드할 파일을 선택해 주세요")%>");	
			return;
		}
		
	    var formData = new FormData();
        formData.append("excel", inp_files_excel.files[0]);
        formData.append("photo", inp_files_photo.files[0]);
        formData.append("sign", inp_files_sign.files[0]);
		
        $("#uploadSpin").show();
        
        var AJAX = $.ajax({
	        url: ('empExcelValidate.do?mode=' + $("input[type=radio][name=type]:checked").val()),
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
	    	  
	    	  if(d.retData == ""){
	    		  initValidate(d);  
	    	  }else{
	    		  alert(d.retData);	  
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
    
    function initValidate(data){
    	
		var tbody = "";
		
		mode = data.mode;
		groupSeq = data.groupSeq;
		if(mode == "emp"){
			batchKey = data.batch_key;
		    $.each(data.validateList, function (i, t) {
		    	
		    	var check_result = fnGetResultNm(t.check_comp, t.check_auth, t.check_dept, t.check_emp_name, t.check_login_id, t.check_block_login_id, t.check_mail, t.check_block_mail, t.check_position, t.check_duty, t.check_pw, t.license_check_yn, t.email_addr, t.license_count_check, t.check_join_day);
		    	var tr = "<tr>";
		    	var cs = check_result != "" ? "class='text_red'" : "";
		    	
		    	tr += "<td class " + cs + ">" + (check_result == "" ? "<input name='list' type='checkbox' onclick='fnCheck(this);' seq='"+t.seq+"'>" : "") + "</td>";
		    	tr += "<td " + cs + ">" + t.emp_name_kr + "</td>";
		    	tr += "<td " + cs + ">" + t.login_id + "</td>";
		    	tr += "<td " + cs + ">" + t.email_addr + "</td>";
		    	tr += "<td " + cs + ">" + (check_result == "" ? "<%=BizboxAMessage.getMessage("TX000000815","정상")%>" : "<%=BizboxAMessage.getMessage("TX000006506","오류")%>") + "</td>";
		    	tr += "<td " + cs + ">" + check_result + "</td>";
		    	tr += "</tr>";
		    	
		    	tbody += tr;
		    });					
			
		}else{
			
			pathSeq = data.pathSeq;
			rootPath = data.rootPath;
			relativePath = data.relativePath;
			
	    	var checkExtMsg = "<%=BizboxAMessage.getMessage("TX000010638","이미지 파일이 아닙니다 지원 형식({0})")%>";
	    	checkExtMsg = checkExtMsg.replace("{0}","jpeg, jpg, png");
			
		    $.each(data.validateList, function (i, t) {
		    	
		    	if(t.check_code == "1" && !fnCheckExt(t.pic_file_dir)){
		    		t.check_code = "-3";
		    	}
		    	
		    	var tr = "<tr>";
		    	var cs = t.check_code != "1" ? "class='text_red'" : "";
		    	
		    	tr += "<td class " + cs + ">" + (t.check_code == "1" ? "<input name='list' type='checkbox' onclick='fnCheck(this);' emp_seq='"+t.emp_seq+"' pic_file_dir='"+t.pic_file_dir+"'>" : "") + "</td>";
		    	tr += "<td " + cs + ">" + t.emp_name + "</td>";
		    	tr += "<td " + cs + ">" + t.login_id + "</td>";
		    	tr += "<td " + cs + ">" + t.email_addr + "</td>";
		    	tr += "<td " + cs + ">" + (t.check_code == "1" ? "<%=BizboxAMessage.getMessage("TX000000815","정상")%>" : "<%=BizboxAMessage.getMessage("TX000006506","오류")%>") + "</td>";
		    	tr += "<td " + cs + ">";
		    	
		    	if(t.check_code == "1"){
		    		tr += t.pic_file_dir;
		    	}else if(t.check_code == "-1"){
		    		tr += "<%=BizboxAMessage.getMessage("TX000016218","사용자계정 없음")%>";
		    	}else if(t.check_code == "-3"){
		    		tr += checkExtMsg;
		    	}else{
		    		tr +=  t.pic_file_id + " <%=BizboxAMessage.getMessage("TX000005882","이미지없음")%>";
		    	}
		    	
		    	tr += "</td></tr>";
		    	tbody += tr;
		    });					
		}
		

					
		$("#Listtable tbody").html(tbody == "" ? "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td></tr>" : tbody);
		
		if($("input[type=checkbox][name=list]").length > 0){
			$("input[type=checkbox][name=all],[name=list]").prop("checked",true);	
		}
    }
    
    function fnCheckExt(fileName){
    	
		var extName = fileName.substring(fileName.lastIndexOf(".")+1);
		
		if(("|jpeg|jpg|png|").indexOf("|" + extName.toLowerCase() + "|") < 0){
			return false;
		}else{
			return true;
		}
    	
    }
    
    function fnGetResultNm(check_comp, check_auth, check_dept, check_emp_name, check_login_id, check_block_login_id, check_mail, check_block_mail, check_position, check_duty, check_pw, license_check_yn, email_addr, license_count_check, check_join_day){
    	var sReturn = "";
    	
    	if(check_emp_name < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010701","사용자명없음")%>";
    	}    	
    	
    	if(check_comp < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010700","회사코드없음")%>";
    	}
    	
    	if(check_auth < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010699","등록회사권한없음")%>";
    	}    	
    	
    	if(check_dept < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010698","부서코드없음")%>";
    	}    	
    	
    	if(check_login_id < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010697","로그인계정 중복")%>";
    	}
    	
    	if(check_block_login_id < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX900000454","추측하기 쉬운 로그인계정")%>";
    	}    	
    	
    	if(check_mail < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010696","메일계정 중복")%>";
    	}else{
        	var reg_email=/^[-A-Za-z0-9_]+[-A-Za-z0-9_.]*$/;
        	if(email_addr.search(reg_email) < 0){
        		sReturn += ",<%=BizboxAMessage.getMessage("TX900000455","메일계정 특수문자 포함")%>";
        	}    		
    	}
    	
    	if(check_block_mail < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX900000456","추측하기 쉬운 메일계정")%>";
    	}    	
    	
    	if(check_position < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010695","직급코드 없음")%>";
    	}    	
    	
    	if(check_duty < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010694","직책코드 없음")%>";
    	}
    	
    	if(check_pw < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010693","패스워드 없음")%>";
    	}         	
    	
    	if(license_check_yn == ""){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000017942","라이선스 입력오류")%>";
    	}
    	
    	if(license_count_check == "-1") {
    		sReturn += ",<%=BizboxAMessage.getMessage("TX900000371","그룹웨어 라이센스 초과")%>";
    	} else if(license_count_check == "-2") {
    		sReturn += ",<%=BizboxAMessage.getMessage("TX900000372","메일 라이센스 초과")%>";
    	}
    	
    	if(check_join_day < 0){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX900000457","입사일 미입력")%>";
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
    
    function fnSave(){
    	
    	if($("input[type=checkbox][name=list]:checked").length == 0){
    		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
    		return;
    	}
    	
    	if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
    		return;
    	}
    	
    	if(mode == "photo" || mode == "sign"){
    		
    		var saveList = new Array();
    		
    	    $.each($("input[type=checkbox][name=list]:checked"), function (i, t) {
    	    	
    	    	var saveinfo = {};
    	    	saveinfo.emp_seq = $(t).attr("emp_seq"); 
    	    	saveinfo.pic_file_dir = $(t).attr("pic_file_dir");
    	    	saveList.push(saveinfo);
    	    });
    	    
     		var tblParam = {};
     		tblParam.groupSeq = groupSeq;
     		tblParam.pathSeq = pathSeq;
     		tblParam.rootPath = rootPath;
     		tblParam.relativePath = relativePath;     		
     		tblParam.saveList = JSON.stringify(saveList);
     		
     		$.ajax({
            	type:"post",
        		url:'saveImageBatch.do',
        		datatype:"json",
                data: tblParam ,
        		success: function (result) {
        			
        			if(result.value == "1"){
        				var s_cnt = 0;
        				var f_cnt = 0;
        				
        			    $.each(result.saveList, function (i, t) {
        			    	
        			    	var emp_seq = t.emp_seq;
        			    	
        			    	if(t.result == ""){
        			    		s_cnt++;
        			    		$("input[emp_seq="+emp_seq+"]").parents("tr").find("td").addClass("text_blue");
        			    		$($("input[emp_seq="+emp_seq+"]").parents("tr").find("td")[4]).html("완료");
        			    	}else{
        			    		f_cnt++;
        			    		$("input[emp_seq="+emp_seq+"]").parents("tr").find("td").addClass("text_red");
        			    		$($("input[emp_seq="+emp_seq+"]").parents("tr").find("td")[4]).html("오류");
        			    		$($("input[emp_seq="+emp_seq+"]").parents("tr").find("td")[5]).html(t.result);
        			    	}
        			    	
        			    	$("input[emp_seq="+emp_seq+"]").parents("tr").find("input[type=checkbox]").remove();
        			    });	      
        			    
    			    	var result_msg = s_cnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000011981","성공")%> / " + f_cnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000006510","실패")%>";
    			    	alert(result_msg);        			    
        			}
					
        		    } ,
    		    error: function (result) { 
    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
    		    		}
        	});
   		
    		
    	}else{
    		var saveList = new Array();
    		
    	    $.each($("input[type=checkbox][name=list]:checked"), function (i, t) {
    	    	
    	    	var saveinfo = {};
    	    	saveinfo.seq = $(t).attr("seq"); 
    	    	saveList.push(saveinfo);
    	    });  		
    	    
    	    EmpBatchSaveProc(batchKey, saveList);
    	}
    }
    
    
    function EmpBatchSaveProc(batchKey, saveList){
    	
    	var tblParam = {};
    	var loopFlag = false;
    	
    	
    	//10개이상 등록시에는 서버쪽 timeout시간(100초)를 고려하여
    	//10개씩 끊어서 반복호출
    	if(saveList.length > 1){
    		tblParam.batchKey = batchKey;
    		tblParam.saveList = JSON.stringify(saveList.slice(0,1));
    		saveList = saveList.slice(1, saveList.length);
    		loopFlag = true;
    	}else{    	
	 		tblParam.batchKey = batchKey;
	 		tblParam.saveList = JSON.stringify(saveList);	 		
    	}
 		
 		$.ajax({
        	type:"post",
    		url:'saveEmpBatch.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {    			
    			
    			var message = "";
    			
    			if(result.value == "1"){    	
    				for(var i=0;i<result.empSaveList.length;i++){
    					empBatchSaveList.push(result.empSaveList[i]);    					
    				}
    			} else if(result.value == "0") {
    				// 라이센스 초과로 인한 실패
    				loopFlag = false;
    				var overMail = result.licenseReslut.overMailLicense || "false";
	 					var overGw = result.licenseReslut.overGwLicense || "false";
	 					
	 					if(overGw == "true") {
	 						message += "<%=BizboxAMessage.getMessage("TX900000371","그룹웨어 라이센스 초과")%>";
	 					} else if(overMail == "true") {
	 						message += "<%=BizboxAMessage.getMessage("TX900000372","메일 라이센스 초과")%>";
	 					}
	 					
	 					alert(message);
	 					return;
    			}
    			
    			if(loopFlag){
    				EmpBatchSaveProc(batchKey, saveList);
    			}else{
    				var s_cnt = 0;
    				var f_cnt = 0;
    				
    			    $.each(empBatchSaveList, function (i, t) {
    			    	
    			    	var seq = t.seq;
    			    	
    			    	if(t.result == ""){
    			    		s_cnt++;
    			    		$("input[seq="+seq+"]").parents("tr").find("td").addClass("text_blue");
    			    		$($("input[seq="+seq+"]").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000001288","완료")%>");
    			    	}else{
    			    		f_cnt++;
    			    		$("input[seq="+seq+"]").parents("tr").find("td").addClass("text_red");
    			    		$($("input[seq="+seq+"]").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
    			    		$($("input[seq="+seq+"]").parents("tr").find("td")[5]).html(t.result);
    			    	}
    			    	
    			    	$("input[seq="+seq+"]").parents("tr").find("input[type=checkbox]").remove();
    			    });	       
    			    
			    	var result_msg = s_cnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000011981","성공")%> / " + f_cnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000006510","실패")%>";
			    	alert(result_msg); 
			    	empBatchSaveList = [];
    			}
				
    		} ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
    	});
    }
    
    
    
    function fnCancel(){
    	self.close();
    }
    
    function fnFormDownload(){
    	
    	if($("input[type=radio][name=type]:checked").val() == "emp"){
    		this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=gwFormFile&fileSn=2";
    	}else{
        	var selCompSeq = "";
        	
        	if(opener != null){
        		selCompSeq = opener.$("#com_sel").val() == "NONE" ? "" : opener.$("#com_sel").val();
        	}    		
    		
    		this.location.href = "/gw/cmm/systemx/userInfoExcelForm.do?type=" + $("input[type=radio][name=type]:checked").val() + "&compSeq=" + selCompSeq;
    	}
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
				<tr>
					<td colspan="4">
						<input value="emp" type="radio" name="type" id="type1" class="k-radio" checked="checked"/>
						<label class="k-radio-label radioSel" for="type1"><%=BizboxAMessage.getMessage("TX000000286","사용자")%> <%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></label>
						<input value="photo" type="radio" name="type" id="type2" class="k-radio"/>
						<label class="k-radio-label radioSel ml30" for="type2"><%=BizboxAMessage.getMessage("TX000000082","사진")%> <%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></label>
						<input value="sign" type="radio" name="type" id="type3" class="k-radio"/>
						<label class="k-radio-label radioSel ml30" for="type3"><%=BizboxAMessage.getMessage("TX000000086","사인")%> <%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></label>
					</td>
				</tr>
				
				<!-- 엑셀등록 -->
				<tr id="excelLow" style="">
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
				<button onclick="empExcelValidate();"><%=BizboxAMessage.getMessage("TX000002752","업로드")%></button>
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
						<th><%=BizboxAMessage.getMessage("TX000000150","사용자명")%></th>
						<th><%=BizboxAMessage.getMessage("TX000000133","로그인ID")%></th>
						<th><%=BizboxAMessage.getMessage("TX000016287","메일ID")%></th>
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