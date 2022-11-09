<%--
 *********************************************************************** 
 * 1. 단위업무명 :  메뉴생성 화면
 * 2. 설명       :  사용자별 메뉴를 생성한다. 
 *                 로그인 유저별 관리 메뉴 생성. 
 * ------- 개정이력(Modification Information) ----------
 *  작성일          작성자     작성정보
 *   2016. 6. 15.     이재혁     최초작성
 * ----------------------------------------------
 ********************************************************************
 * Copyright ⓒ Duzon NewTurns. All Right Reserved
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="egovframework.com.cmm.service.EgovProperties" %>

<%@ taglib prefix="c"        uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"       uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn"       uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring"   uri="http://www.springframework.org/tags"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
    var compSeq = '${compSeq}';
    var auth = '';
	$(document).ready(function(){
		$("#btnSave").click(function (){ fnSave(); return false; });
		
		onLoadData();
		
		//첨부파일  
		
	});
	
	function onLoadData(){
		var tblParam = {};
        $.ajax({
            type:"post",
            url: '<c:url value="/acc/money/AccMoneyFormInit.do" />', 
            datatype:"json",
            data: tblParam,
            success: function (data) {
                if(data){
                	if(data.smartOption001 == 2 ){
                		$('#radio_acountNote').prop('checked', false);
                		$('#radio_resNote').prop('checked', true);
                	}
                	
                	auth = data.auth;
                	var compList = data.selectComp;
                	selFormBySeq(compSeq);
                	if(auth != 'MASTER'){
                		$('.top_box').empty();
                		
                	}else{                		
                        setSelectComp(compList);
                        
                	}
                	setKendoUI();
                }
            },error: function (request, status, error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
        
	}
	
	function setKendoUI(){
		$("#compSel").kendoComboBox();
		
		$("#bd_file").kendoUpload({
            "multiple" : false,
            async: {
                   saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
                   autoUpload: true
               },
               showFileList: false,
               upload:function(e) {                
                   var dataType = 'json';
                   var pathSeq = '100';
                   var relativePath = '/form/accForm/'+compSeq+'/';
                   
                   var params = "dataType=" + dataType;
                   params += "&pathSeq=" + pathSeq;
                   params += "&relativePath=" + relativePath;
                   
                   e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
                   
                   var inputName =  $(e.sender).attr("name");
                   
                   $('#'+inputName+"_INP").val(e.files[0].name);
                   
               },              
            localization: {
                select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
            },
               success: onSuccess
        });
	}
	
	function onSuccess(e){
	       window.scrollTo(0, document.body.scrollHeight);
	       
	       var file_id = e.response.fileId;
	       //var stre_file_name = e.response.fileInfo.stre_file_name;
	       //var file_extsn = e.response.fileInfo.file_extsn;
	       //var filename = stre_file_name + '.' + file_extsn;
	       var filename = e.files[0].name;
	       var downUrl = '<c:url value="/cmm/file/fileDownloadProc.do?fileSn=0&fileId="/>';
	       //$("#ajaxfile_TempFolder").val(e.response.fileInfo.file_stre_cours);
	       var attachhtml = '';
	       if(file_id){
	           $("#fileID").val(file_id);
	       }
	       if(filename){
	            $("#fileNM").val(filename);
	       }
	       var size = e.files[0].size;
	       var name = e.files[0].name;
	       $("#file_list_box").empty();
	       attachhtml += '<li>';
	       attachhtml += '<img src="'+_g_contextPath_+'/Images/ico/ico_clip02.png"  id="" alt="">';
	       attachhtml += '<a href="'+downUrl+''+file_id+'" id="">'+filename+'</a>';
	       attachhtml += '<span id="">('+size+' byte)</span>';
	       attachhtml += '<a href="javascript:;" id="" title="<%=BizboxAMessage.getMessage("TX000008714","파일삭제")%>"><img src="'+_g_contextPath_+'/Images/btn/close_btn01.png" id="" alt=""></a>';
	       attachhtml += '</li>';
	       $("#file_list_box").append(attachhtml);
	       //$("#attachCnt").text(getAttachCnt());
	       //$("#attachSize").text(Number($("#attachSize").text())+Number(size));
	   }
	
	function setSelectComp(compList){
		var compHtml = '<select id="compSel" name="compSel" onchange="selFormBySeq(this.value)">';
		if(compList.length > 0){
			compHtml += '<option value="0"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>';
		}
		for(i = 0; i < compList.length; i ++){
			compHtml += '<option value="'+compList[i].seq+'" >'+compList[i].comp_name+'</option>';
		}
		compHtml += '</select>';
		$(".dod_search").append(compHtml);
		
	}
	
	function selFormBySeq(compSeq){
		var tblParam = {};
		tblParam.compSeq = compSeq;
		$.ajax({
            type:"post",
            url: '<c:url value="/acc/money/AccMoneyFormBySeq.do" />', 
            datatype:"json",
            data: tblParam,
            success: function (data) {
            	var downUrl = '<c:url value="/cmm/file/fileDownloadProc.do?fileSn=0&fileId="/>';
                if(data.selForm){
                	$("#file_list_box").empty();
                	var attachhtml = '';
                    attachhtml += '<li>';
                    attachhtml += '<img src="'+_g_contextPath_+'/Images/ico/ico_clip02.png"  id="" alt="">';
                    attachhtml += '<a href="'+downUrl+''+data.selForm.file_id+'" id="">'+data.selForm.form_nm+'</a>';
                    attachhtml += '<span id="">('+data.selForm.file_size+' byte)</span>';
                    attachhtml += '<a href="javascript:;" id="" title="<%=BizboxAMessage.getMessage("TX000008714","파일삭제")%>"><img src="'+_g_contextPath_+'/Images/btn/close_btn01.png" id="" alt=""></a>';
                    attachhtml += '</li>';
                    $("#file_list_box").append(attachhtml);
                    var comp_name = $("#compSel option:selected").text();
                    if(!!comp_name){
                    	$("#comp_name").text("("+comp_name+")");
                    }
                }else{
                	$("#file_list_box").empty();
                	//alert("자금일보 양식이 등록되어 있지 않습니다.");
                }
            },error: function (request, status, error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
	}
	
	function fnSave(){
		var tblParam = {};
		if(auth == 'MASTER'){
			tblParam.compSel = $("#compSel").val();
		}else{
			tblParam.compSel = compSeq;
		}
		
	    tblParam.file_id = $("#fileID").val();
	    tblParam.file_nm = $("#fileNM").val();
	    tblParam.smart001Value = $('#radio_acountNote').prop('checked') ? '1' : '2';
	    $.ajax({
	        type:"post",
	        url: '<c:url value="/acc/money/AccMoneyFormInsert.do" />', 
	        datatype:"json",
	        data: tblParam,
	        success: function (data) {
	            alert('<%=BizboxAMessage.getMessage("TX000011037","성공적으로 저장하였습니다.")%>');
	        },error: function (request, status, error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });
	}
	
</script>

<input type="hidden" id="fileID" />
<input type="hidden" id="fileNM" />
<!-- Code Here  -->
<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">

        <!-- 컨트롤박스 // 관리자일경우 컨트롤박스 삭제 -->  
<div class="top_box">
    <dl>
        <dt><%=BizboxAMessage.getMessage("TX000000047","회사")%></dt>
        <dd>
            <div class="dod_search">
                
            </div>
        </dd>
        <dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
    </dl>
</div>

<!-- 컨트롤버튼영역 -->
<div class="btn_div">
    <div class="left_div">                          
        <h5><%=BizboxAMessage.getMessage("TX000006476","양식설정")%></h5>
    </div>

    <div class="right_div">
        <div id="" class="controll_btn p0">
            <button id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
        </div>
    </div>
</div>
    
<!-- 테이블 -->
    <div class="com_ta mt10">
        <table>
            <colgroup>
                <col width="150" />
                <col />
            </colgroup>
            <tr>
                <th>자금이체적요</th>
                <td class="">
                      <input type="radio" id="radio_acountNote" name="drone" value="huey" checked>
					  <label for="radio_acountNote">출금통장적요</label> 
                      <input type="radio" id="radio_resNote" name="drone" value="huey">
					  <label for="radio_resNote">전표적요(여러 건일 경우 '첫행 외 OO건'으로 표시)</label> 					  
                </td>
            </tr>    
            <tr>
                <th><%=BizboxAMessage.getMessage("TX000015977","자금일보양식")%><br/><span id="comp_name"></span></th>
                <td class="file_add">
                    <input id="" type="text" class="file_input" style="width:423px;" readonly="readonly"/>
                    <input name="bd_file" id="bd_file" type="file"/>                                            
                    <ul class="file_list_box" id="file_list_box">
                        
                    </ul>
                </td>
            </tr>
        </table>
    </div>
    
</div><!-- //sub_contents_wrap -->


