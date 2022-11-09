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


	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.167.min.js"></script>

<script type="text/javascript">
	var retKey;
	var targetCompSeq = "";
	var addrBatchSaveList = [];
	
	$(document).ready(function() {
        $(".controll_btn button").kendoButton();
	});	
	
	
	function ExcelValidate(){
		kendo.ui.progress($(".pop_wrap"), true);
		
		
	    var formData = new FormData();
        formData.append("excelUploadFile", $("#files")[0].files[0]);

	    $.ajax({
	        url: 'addrExcelValidate.do',
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
			if(d.retMsg == "success"){
		        retKey = d.retKey;
		        getAddrBatchInfo(d.retKey);
			}
			else if(d.retMsg == "fail"){
				alert("<%=BizboxAMessage.getMessage("","지원하지 않는 양식입니다. 제공하는 양식 파일을 다운받아 작성해 주세요.")%>");	
			}
			
	      },    
	      error : function(e){
	    	 kendo.ui.progress($(".pop_wrap"), false);
	         alert("error");	         
	      }
	    });
	}
	
	
	function addrExcelValidate(){
		
		if($("#files").val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010754","업로드할 엑셀파일을 선택해 주세요")%>");	
			return;
		}
		
		if(retKey){
			var tblParam = {};
			tblParam.retKey = retKey;
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/mp/addr/deleteAddrBatchInfo.do"/>',
				datatype:"json",
				data: tblParam,
				success:function(data){
					ExcelValidate();
				},			
				error : function(e){	//error : function(xhr, status, error) {
					alert("error");	
				}
			});	
		}
		else {
			ExcelValidate();
		}
	}
	
    function progressHandlingFunction(e) {
    	
    	console.log((e.loaded / e.total) * 100);

    }
    
    
    function setaddrBatchTable(data, infoMap){

		var innerHTML = "";

		$("#addrBatchList").html("");		
		for(var i=0; i<data.length; i++){
			var check_result = "";

			if(isNull(data[i].addrDivNm) == "" || isNull(data[i].addrGroupNm) == "" || isNull(data[i].empNm) == ""){
				check_result += "</br><%=BizboxAMessage.getMessage("","필수값 미입력")%>";
			}
			
			if(isNull(data[i].empEmail) == "" && isNull(data[i].empHp) == "" && isNull(data[i].empFax) == ""){
				check_result += "</br><%=BizboxAMessage.getMessage("","선택값 미입력")%>";
			}
			
			if(data[i].checkGroupTp != data[i].batchGroupTp){
				if(isNull(data[i].addrGroupNm) != "" && isNull(data[i].addrDivNm) != ""){
					check_result += "</br><%=BizboxAMessage.getMessage("","구분-그룹명 오류")%>";
				}
			}else if(data[i].addrGroupSeq == null){
				if(isNull(data[i].addrDivNm) != "" && isNull(data[i].addrGroupNm) != ""){
					check_result += "</br><%=BizboxAMessage.getMessage("","권한 오류")%>";
				}
			}

			
			var cs = "";
			
			if(check_result != ""){
				check_result = check_result.substring(5);
				cs = "class='text_red'"
			}
			
			innerHTML += "<tr>";
			innerHTML += "<td " + cs + " id=checkbox"+data[i].seq+">" + (check_result == "" ? "<input name='list' type='checkbox' onclick='fnCheck(this);' seq='"+data[i].seq+"' addrGroupSeq='"+data[i].addrGroupSeq+"' data='" + escape(JSON.stringify(data[i])) + "'>" : "") + "</td>";
			innerHTML += "<td " + cs + " id=addrDivNm"+data[i].seq+">" + isNull(data[i].addrDivNm) + "</td>";
			innerHTML += "<td " + cs + " id=addrGroupNm"+data[i].seq+">" + isNull(data[i].addrGroupNm) + "<input type='hidden' id=hid"+i+" value='"+data[i].deptPath+"'/><input type='hidden' id=hidPath"+i+" value='"+data[i].checkDeptPath+"' /></td>";
			innerHTML += "<td " + cs + " id=empName"+data[i].seq+">" + isNull(data[i].empNm) + "</td>";
			innerHTML += "<td " + cs + " id=empEmail"+data[i].seq+">" + isNull(data[i].empEmail) + "</td>";
			innerHTML += "<td " + cs + " id=empHp"+data[i].seq+">" + isNull(data[i].empHp) + "</td>";
			innerHTML += "<td " + cs + " id=empFax"+data[i].seq+">" + isNull(data[i].empFax) + "</td>";
			innerHTML += "<td " + cs + " id=check"+data[i].seq+">" + (check_result == "" ? "<%=BizboxAMessage.getMessage("TX000000815","정상")%>" : "<%=BizboxAMessage.getMessage("TX000006506","오류")%>") + "</td>";		
			innerHTML += "<td " + cs + " id=checkResult"+data[i].seq+">" + check_result + "</td>";			
			innerHTML += "</tr>";
		}
		
		innerHTML == "" ? "<tr><td colspan='7'><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td></tr>" : innerHTML		
		
		$("#addrBatchList").html(innerHTML);
		
		kendo.ui.progress($(".pop_wrap"), false);
    }
    
  //null값 체크(''공백 반환)
	function isNull(obj){
		return (typeof obj != "undefined" && obj != null) ? obj : "";
	}
    
    
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
	
	
	function getAddrBatchInfo(retKey){
		var tblParam = {};
		tblParam.retKey = retKey;
		tblParam.create_seq = opener.getTargetEmpSeq();
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/mp/addr/getAddrBatchInfo.do"/>',
			datatype:"json",
			data: tblParam,
			success:function(data){
				setaddrBatchTable(data.addrBatchList, data)
			},			
			error : function(e){	//error : function(xhr, status, error) {
				alert("error");	
			}
		});	
		
	}
	
		
	function ok(){		
		var saveList = new Array();
		
		 $.each($("input[type=checkbox][name=list]:checked"), function (i, t) { 	    	
 	    	saveList.push(JSON.parse(unescape($(t).attr("data"))));
 	    });
		 		
  		
  		if(saveList.length == 0){
  			alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
  			return;
  		}
  		
  		
  		if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
    		return;
    	}

  		addrBatchSaveList = saveList;
  		AddrBatchSaveProc(retKey, saveList);
	}
		
	function AddrBatchSaveProc(retKey, saveList){
		var tblParam = {};
		var loopFlag = false;
		
  		//500개이상 등록시에는 서버쪽 timeout시간(100초)를 고려하여
    	//500개씩 끊어서 반복호출
    	if(saveList.length > 500){
    		tblParam.retKey = retKey;
    		tblParam.saveList = JSON.stringify(saveList.slice(0,500));
    		saveList = saveList.slice(500, saveList.length);
    		loopFlag = true;
    	}else{    	
	 		tblParam.retKey = retKey;
	 		tblParam.saveList = JSON.stringify(saveList);	 		
    	}
  		
  		
  		kendo.ui.progress($(".pop_wrap"), true);
  		$.ajax({
        	type:"post",
        	url:'<c:url value="/cmm/mp/addr/saveAddrBatch.do"/>',
    		datatype:"json",
            data: tblParam ,
    		success: function (result) {
    				if(loopFlag){
    					AddrBatchSaveProc(retKey, saveList);
        			}else{
        				kendo.ui.progress($(".pop_wrap"), false);
	    				$.each($("input[type=checkbox][name=list]:checked"), function (i, t) { 	    	
	    		 	    	$(t).remove();
	    		 	    });
	    				
	    				for(var i=0;i<addrBatchSaveList.length;i++){
	    					
	    					$("#addrDivNm" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					
	    					$("#addrGroupNm" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					
	    					$("#empName" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					
	    					$("#empEmail" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					
	    					$("#empHp" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					
	    					$("#empFax" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    						    					
	    					$("#check" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    					$("#check" + addrBatchSaveList[i].seq).html("<%=BizboxAMessage.getMessage("TX000001288","완료")%>");
	    					
	    					$("#checkResult" + addrBatchSaveList[i].seq).attr("class","text_blue");	
	    				}
	    				fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000009810","정상적으로 등록되었습니다")%>","success",1500);
	    				window.opener.fnSearch();
        			}
				},
		    error: function (result) { 
		    		kendo.ui.progress($(".pop_wrap"), false);
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	    		}
    	}); 
	}
	
	function fnClose(){
		//창 닫을때 임시테이블의 데이터 제거후 close
		if(retKey){
			var tblParam = {};
			tblParam.retKey = retKey;
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/mp/addr/deleteAddrBatchInfo.do"/>',
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
		
	function fnSetSnackbar(msg, type, duration){
		var puddActionBar = Pudd.puddSnackBar({
			type	: type
		,	message : msg
		,	duration : 1500
		});
	}
</script>

<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016127","주소록일괄등록")%></h1>
	</div><!-- //pop_head -->
	<div class="pop_con">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="130"/>
					<col width=""/>
					<col width="130"/>
					<col width="120"/>
				</colgroup>
				<tr>
<!-- 					<th>회사선택</th> -->
<!-- 					<td><input id="com_sel" style="width:96%"></td> -->
					<th><%=BizboxAMessage.getMessage("TX000003519","엑셀업로드")%></th>
					<td colspan="3">		
						<div class="fl file_div w_file200">
							<input type="file" id="files" class="puddSetup" pudd-style="width:320px;" pudd-button-text="파일 선택" pudd-file-type="union"/>				
						</div>						
						<div class="controll_btn p0 ml70">
							<button onclick="addrExcelValidate()"><%=BizboxAMessage.getMessage("TX000002752","업로드")%></button>
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000000186","양식파일")%></th>
					<td>
						<div class="controll_btn fl p0">
							<a href="/gw/cmm/file/fileDownloadProc.do?fileId=gwFormFile&fileSn=0"><button><%=BizboxAMessage.getMessage("TX000001687","다운로드")%></button></a>
						</div>
					</td>
				</tr>				
			</table>
		</div>
		
		<!-- 테이블 -->
		<div class="com_ta2 mt10 ">
			<table>
				<colgroup>
					<col width="30"/>
					<col width="50"/>
					<col width="130"/>
					<col width="130"/>
					<col width="130"/>
					<col width="110"/>
					<col width="110"/>
					<col width="110"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><input name='all' type='checkbox' onclick="fnCheck(this);" type="checkbox"></th>
					<th><%=BizboxAMessage.getMessage("","구분")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
					<th><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>					
					<th><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
					<th><%=BizboxAMessage.getMessage("","일반팩스")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000078","확인")%></th>
					<th><%=BizboxAMessage.getMessage("TX000000966","사유")%></th>
				</tr>
			</table>
		</div>

		<div class="com_ta2 ova_sc bg_lightgray" style="height:296px;">
			<table id="batchTable">
				<colgroup>
					<col width="30"/>
					<col width="50"/>
					<col width="130"/>
					<col width="130"/>
					<col width="130"/>
					<col width="110"/>
					<col width="110"/>
					<col width="110"/>
					<col width=""/>
				</colgroup>
				<!-- <tr>
					<td colspan="5" class="nocon" style="height:285px;">데이터가 존재하지 않습니다.</td>
				</tr>		 -->
				<tbody id="addrBatchList">		
					<tr id="initTr">						
						<td colspan="9"><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td>
					</tr>				
				</tbody>
			</table>
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
		</div>
	</div><!-- //pop_foot -->


</div><!-- //pop_wrap -->