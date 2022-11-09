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
	var retKey;
	var targetCompSeq = "";
	
	$(document).ready(function() {
		//기본버튼
        $(".controll_btn button").kendoButton();
	
		//회사선택 셀렉트박스
// 		compComInit();
	});
	
	//회사선택 selectBox
// 	function compComInit() {
// 		<c:if test="${not empty compListJson}">
// 	    $("#com_sel").kendoComboBox({
// 	    	dataTextField: "compName",
// 	           dataValueField: "compSeq",
// 	        dataSource :${compListJson},
// 	        value: "${params.compSeq}",
// 	        filter: "contains",
// 	        suggest: true
// 	    });
	    
// 	    var deptComData = $("#com_sel").data("kendoComboBox");
// 	    deptComData.refresh();
// 	    deptComData.select(0);
// 		</c:if>
// 	}
	
	function ExcelValidate(){
		kendo.ui.progress($(".pop_wrap"), true);
		
		
	    var formData = new FormData();
        formData.append("excelUploadFile", $("#files")[0].files[0]);

	    $.ajax({
	        url: 'deptExcelValidate.do',
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
// 	        alert(JSON.stringify(d.retData));
			
			kendo.ui.progress($(".pop_wrap"), false);
			if(d.retMsg == "errorAdminAuth"){
				alert("<%=BizboxAMessage.getMessage("TX000010756","관리자인 경우 소속 회사의 조직도만 등록 가능합니다")%>");
			}			
			else if(d.retMsg == "success"){
		        retKey = d.retKey;
		        getDeptBatchInfo(d.retKey);
			}
			else if(d.retMsg == "fail"){
				alert("<%=BizboxAMessage.getMessage("TX000010755","양식 오류!　(양식파일을 새로 받아 작성해주세요.)")%>".replace("　","\n"));
			}
	      },    
	      error : function(e){
	    	 kendo.ui.progress($(".pop_wrap"), false);
	         alert("error");	         
	      }
	    });
	}
	
	
	function deptExcelValidate(){
		
		if($("#files").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010754","업로드할 엑셀파일을 선택해 주세요")%>");	
			return;
		}
		
		if(retKey){
			var tblParam = {};
			tblParam.retKey = retKey;
			$("#uploadSpin").show();
			
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/deleteDeptBatchInfo.do"/>',
				datatype:"json",
				data: tblParam,
				success:function(data){
					$("#uploadSpin").hide();
					ExcelValidate();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					$("#uploadSpin").hide();
					alert("error");	
				}
			});	
		}
		
		else
			ExcelValidate();
		
	}
	
    function progressHandlingFunction(e) {
    	
    	console.log((e.loaded / e.total) * 100);

    }
    
    
    function setdeptBatchTable(data, infoMap){
	
		var innerHTML = "";
		var errorDeptSeq = "";
		var errorDeptPath = "";
		targetCompSeq = data[0].compSeq;
		
		$("#deptBatchList").html("");		
		for(var i=0; i<data.length; i++){
			var check_result = fnGetResultNm(data[i].checkDeptSeq, data[i].checkParentDeptSeq, data[i].checkOriDeptSeq, data[i].checkDeptSeqBatch, data[i].deptName, data[i].checkCompSeq, data[i].checkBizSeq, data[i].deptSeq);
			var cs = check_result != "" ? "class='text_red'" : "";
			
			if(check_result != ""){
				errorDeptSeq += "," + data[i].deptSeq;
				errorDeptPath += "," + data[i].checkDeptPath;
			}
			
			
			innerHTML += "<tr>";
			innerHTML += "<td " + cs + " id=checkbox"+i+">" + (check_result == "" ? "<input name='list' type='checkbox' onclick='fnCheck(this);' seq='"+data[i].deptSeq+","+data[i].parentDeptSeq+","+data[i].deptPath+"'>" : "") + "</td>";
			innerHTML += "<td " + cs + " id=parentDeptSeq"+i+">" + (data[i].parentDeptSeq == null ? "" : data[i].parentDeptSeq) + "<input type='hidden' id=hid"+i+" value='"+data[i].deptPath+"'/><input type='hidden' id=hidPath"+i+" value='"+data[i].checkDeptPath+"' /></td>";
			innerHTML += "<td " + cs + " id=deptSeq"+i+">" + data[i].deptSeq + "</td>";
			innerHTML += "<td " + cs + " id=deptName"+i+">" + data[i].deptName + "</td>";
			innerHTML += "<td " + cs + " id=check"+i+">" + (check_result == "" ? "<%=BizboxAMessage.getMessage("TX000000815","정상")%>" : "<%=BizboxAMessage.getMessage("TX000006506","오류")%>") + "</td>";
			innerHTML += "<td " + cs + " id=checkResult"+i+">" + check_result + "</td>";
			innerHTML += "</tr>";
		}
		
		
		innerHTML == "" ? "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000010743","데이타가 없습니다")%></td></tr>" : innerHTML		
		
		$("#deptBatchList").html(innerHTML);
		
// 		setRelativeDept(errorDeptSeq.substring(1), errorDeptPath.substring(1));
    }
    
    
    
    
//     function setRelativeDept(errorDeptSeq, errorDeptPath){
//     	var arrErrorDeptSeq = errorDeptSeq.split(",");
//     	var arrErrorDeptPath = errorDeptPath.split(",");
    	
    	
    	
//     	for(var i=0;i<$("#batchTable tbody tr");i++){
//     		var hidValue = '|' + $("#hid" + i).val() + '|';
    		
//     		for(var j=0;j<arrErrorDeptSeq.length;j++){
//     			if(hidValue.indexOf('|' + arrErrorDeptSeq[j] + '|') != -1 && arrErrorDeptPath[j] == "1"){
//     				if($("#hidPath" + i).val() == 0){
// 	    				$("#checkbox" + i).html("");
// 	    				$("#parentDeptSeq" + i).attr("class","text_red");
// 	    				$("#deptSeq" + i).attr("class","text_red");
// 	    				$("#deptName" + i).attr("class","text_red");
// 	    				$("#check" + i).attr("class","text_red");
// 	    				$("#check" + i).html("오류");
// 	    				$("#checkResult" + i).attr("class","text_red");
// 	    				if($("#deptSeq" + i).html() != arrErrorDeptSeq[j])
// 	    					$("#checkResult" + i).html("상위부서코드오류");
//     				}
//     			}
//     		}
//     	}   	

//     }
    
    
    
    
    
    function fnGetResultNm(check_dept_seq, check_parent_dept_seq, check_ori_dept_seq, check_dept_seq_batch, dept_name, check_comp_seq, check_biz_seq, dept_seq){
    	var sReturn = "";
    	
//     	if(check_dept_seq != 1){
//     		sReturn += ",부서코드중복(신규)";
//     	}    	
    	
    	if(check_parent_dept_seq != 1){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010753","상위부서코드오류")%>";
    	}
    	
    	if(check_ori_dept_seq != null){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010752","부서코드중복(기존)")%>";
    	}  
    	
    	if(check_dept_seq_batch != 1){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010751","부서코드중복(신규)")%>";
    	} 
    	
    	if(dept_name == "" || dept_name == null){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010750","부서명오류")%>";
    	}
    	
    	if(check_comp_seq == "" || check_comp_seq == null || check_comp_seq == "0"){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010749","회사코드오류")%>";
    	}
    	
    	if(check_biz_seq != null){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010748","사업장코드중복")%>"
    	}
    	if(dept_seq == "0"){
    		sReturn += ",<%=BizboxAMessage.getMessage("TX000010747","사용불가코드")%>"
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
	
	
	function getDeptBatchInfo(retKey){
		var tblParam = {};
		tblParam.retKey = retKey;
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/getDeptBatchInfo.do"/>',
			datatype:"json",
			data: tblParam,
			success:function(data){
				setdeptBatchTable(data.deptBatchList, data)
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});	
		
	}
	
		
	function ok(){
		
		
		
		
		
		
		var saveList = new Array();
		
		 $.each($("input[type=checkbox][name=list]:checked"), function (i, t) { 	    	
 	    	var saveinfo = {};
 	    	saveinfo.seq = $(t).attr("seq"); 
 	    	saveList.push(saveinfo);
 	    });
		 
		var tblParam = {};
  		tblParam.retKey = retKey;
  		tblParam.saveList = JSON.stringify(saveList);
  		
  		if(saveList.length == 0){
  			alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
  			return;
  		}
  		
  		
  		if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
    		return;
    	}
  		
  		kendo.ui.progress($(".pop_wrap"), true);
  		$.ajax({
        	type:"post",
    		url:'saveDeptBatch.do',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {  
    			var failSeqList = result.strErrorSeq.split('&');
    			var successSeqList = result.strSuccessSeq.split('&');
				var failCnt = 0;
				var SucCnt = 0;
    			
    			
    			if(failSeqList[0] != ""){
					for(var i=0;i<failSeqList.length;i++){  	
							if(failSeqList[i].indexOf("error") == -1){
		  						$("input[seq='"+failSeqList[i]+"']").parents("tr").find("td").addClass("text_red");
					    		$($("input[seq='"+failSeqList[i]+"']").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
					    		$($("input[seq='"+failSeqList[i]+"']").parents("tr").find("td")[5]).html("<%=BizboxAMessage.getMessage("TX000010745","상위부서 생성되지 않음")%>");
		// 			    		$("input[seq='"+failSeqList[i]+"']").parents("tr").find("input[type=checkbox]").hide();
							}
							else{
								var targetSeq = failSeqList[i].replace("error","")
								$("input[seq='"+targetSeq+"']").parents("tr").find("td").addClass("text_red");
					    		$($("input[seq='"+targetSeq+"']").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
					    		$($("input[seq='"+targetSeq+"']").parents("tr").find("td")[5]).html("<%=BizboxAMessage.getMessage("TX000010744","부서유형오류")%>");
		// 			    		$("input[seq='"+failSeqList[i]+"']").parents("tr").find("input[type=checkbox]").hide();
							}
						}
					failCnt = failSeqList.length;
    			}
    			
    			if(successSeqList[0] != ""){
					for(var i=0;i<successSeqList.length;i++){  						
						$("input[seq='"+successSeqList[i]+"']").parents("tr").find("td").attr("class","text_blue");
			    		$($("input[seq='"+successSeqList[i]+"']").parents("tr").find("td")[4]).html("<%=BizboxAMessage.getMessage("TX000001288","완료")%>");
			    		$($("input[seq='"+successSeqList[i]+"']").parents("tr").find("td")[5]).html("");
				    	$("input[seq='"+successSeqList[i]+"']").parents("tr").find("input[type=checkbox]").remove();
					}
					SucCnt = successSeqList.length;
    			}
				kendo.ui.progress($(".pop_wrap"), false);
				
				var result_msg = SucCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000011981","성공")%> / " + failCnt + "<%=BizboxAMessage.getMessage("TX000000476","건")%> <%=BizboxAMessage.getMessage("TX000006510","실패")%>";
				alert(result_msg);
				opener.compChange();
				opener.compChange();
				},
		    error: function (result) { 
		    		kendo.ui.progress($(".pop_wrap"), false);
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
    	}); 
  		
  	
	}
	
	
	function fnPreviewPop(){

		if($("#deptBatchList tr")[0].id == "initTr"){
			alert("<%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%>");
		}
		else{
	 		var url = "deptBatchPreviewPop.do?targetCompSeq="+targetCompSeq+"&retKey="+retKey
	 		openWindow2(url, "deptBatchPreviewPop", 400, 550, 0);
		}
	}
	
	function fnClose(){
		//창 닫을때 임시테이블의 데이터 제거후 close
		if(retKey){
			var tblParam = {};
			tblParam.retKey = retKey;
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/deleteDeptBatchInfo.do"/>',
				datatype:"json",
				data: tblParam,
				success:function(data){
					window.close();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
			});	
		}
		else
			window.close();
	}
		
    function fnFormDownload(){
        this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=gwFormFile&fileSn=4";
    }
    
	function fnReset(){
		$("input[type=file]").val("");
		$("#batchTable tbody").html("<tr id='initTr'><td colspan='6'><%=BizboxAMessage.getMessage("TX000010743","데이타가 없습니다")%></td></tr>");
	}
	
</script>

<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016131","조직도일괄등록")%></h1>
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
					<th class="cen"><%=BizboxAMessage.getMessage("TX000000343","엑셀파일")%></th>
					<td>
						<input name="files" id="files" type="file"/>
					</td>
					<th class="cen"><%=BizboxAMessage.getMessage("TX000000186","양식파일")%></th>
					<td>
						<div id="" class="controll_btn p0">
							<button onclick="fnFormDownload();"><%=BizboxAMessage.getMessage("TX000001687","다운로드")%></button>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- 테이블 타이틀 및 버튼 -->
		<div class="option_top mt14">
			<ul><li class="tit_li"><%=BizboxAMessage.getMessage("TX000016179","엑셀파일 체크리스트")%></li></ul>
			<div id="" class="controll_btn" style="padding:0px;float:right;">
				<button onclick="deptExcelValidate();"><%=BizboxAMessage.getMessage("TX000002752","업로드")%></button>
				<button onclick="fnReset();" uploadabort="true"><%=BizboxAMessage.getMessage("TX000002960","초기화")%></button>
				<div id="uploadSpin" style="display:none;float:left;padding-right:10px;padding-top:4px;"><strong class="k-upload-status k-upload-status-total"><spna id="uploadSts">100</spna>% Uploading...<span class="k-icon k-loading"></span></strong></div>
			</div>
		</div>

		<!-- 테이블 리스트-->
		<!-- 테이블 -->
		<div class="com_ta2 mt10 ">
			<table>
				<colgroup>
					<col width="30"/>
					<col width="100"/>
					<col width="100"/>
					<col width="150"/>
					<col width="80"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><input name='all' type='checkbox' onclick="fnCheck(this);" type="checkbox"></th>
					<th><%=BizboxAMessage.getMessage("TX000003295","상위부서코드")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000067","부서코드")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000078","확인")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000966","사유")%></th>
				</tr>
			</table>
		</div>

		<div class="com_ta2 ova_sc bg_lightgray" style="height:256px;">
			<table id="batchTable">
				<colgroup>
					<col width="30"/>
					<col width="100"/>
					<col width="100"/>
					<col width="150"/>
					<col width="80"/>
					<col width=""/>
				</colgroup>
				<tbody id="deptBatchList">		
					<tr id="initTr">						
						<td colspan="6"><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td>
					</tr>				
				</tbody>
			</table>
		</div>
	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="" value="<%=BizboxAMessage.getMessage("TX000003080","미리보기")%>" onclick="fnPreviewPop();"/>
			<input type="button" class="" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->