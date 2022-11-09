var write = {};

dialogViewSet = function(b){
	NeosUtil.dialogStyleSet("dialog-Background");
	if(b){
		$("#dialog-Background").show();
		$("#div_work_form").css("zIndex", "899999").show();
	}else{
		$("#dialog-Background").hide();
		$("#div_work_form").hide(); 
	} 
		
};

function fn_egov_view_work(work_seq){
    $("#work_seq").attr("value", work_seq);
    
    $.ajax({
        type:"post",
        url:'/gw/neos/pims/work/workView.do',
        data:{"type":$("#type").val(),"work_seq":$("#work_seq").val()},
        datatype:"html",            
        success:function(data){  
            $("#div_work_form").html(data);
            $("#div_work_form").show();
            dialogViewSet(true);
        }
    });
}

function fn_egov_list_my_work(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#myform").attr("action","/gw/neos/pims/work/myWorkList.do");
    $("#myform").attr("target", "_self");
    $("#myform").submit();
}

function fn_egov_list_work(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#myform").attr("action","/gw/neos/pims/work/workList.do");
    $("#myform").attr("target", "_self");
    $("#myform").submit();
}

function fn_egov_delete_work(){
    
    if(confirm("할 일을 삭제하시겠습니까?")){
	    $("#myform").attr("action","/gw/neos/pims/work/workDeleteProc.do");
	    $("#myform").attr("target", "_self");
	    $("#myform").submit();
	}
    
}

function fn_egov_write_work(){
    
    $.ajax({
        type:"post",
        target:"_self",
        url:'/gw/neos/pims/work/workWriteForm.do',
        data:{"type":$("#type").val()},
        datatype:"html",            
        success:function(data){  
            $("#div_work_form").html(data);
            $("#div_work_form").show();
            write.calendar();
            dialogViewSet(true);
        }
    });
}

function fn_egov_writeProc_work() {

    if($("#title").val().length < 1){
        alert("제목을 입력하세요.");
        $("#title").focus();
        return;
    }
    
    if($("input:radio[name=is_end]:checked").val() == "2"){ 
    
	    if($("#edate").val().length < 1){
	        alert("마감일을 입력하세요.");
	        $("#edate").focus();
	        return;
	    }
    }    
    
    if($("#contents_").val().length < 1){
        alert("내용을 입력하세요.");
        $("#contents_").focus();
        return;
    }
    
    if($("#contents_").val().length > 2000){
        alert("내용은 4000byte까지 가능합니다.");
        $("#contents_").attr("value", $("#contents_").val().substring(0,2000));
        return;
    }
    
    if($("#type").val() == 2){
	    if($("#joinUserIDList").val().length < 1){
	        alert("협업담당자를 입력하세요.");
	        return;
	    }
    }
    
    $("#workform").attr("action","/gw/neos/pims/work/workWriteProc.do");
    $("#workform").attr("target", "_self");
    $("#workform").submit();
    
}

function fn_egov_update_work(){
	
	$("#work_seq2").attr("value", $("#work_seq").val());
	
    $.ajax({
        type:"post",
        target:"_self",
        url:'/gw/neos/pims/work/workUpdateForm.do',
        data:{"type":$("#type").val(),"work_seq":$("#work_seq").val(),"reply_seq":$("#reply_seq").val()},
        datatype:"html",            
        success:function(data){  
            $("#div_work_form").html(data);
            $("#div_work_form").show();
            write.calendar();
            dialogViewSet(true);
        }
    });
}

function fn_egov_updateProc_work() {

	if($("#title").val().length < 1){
        alert("제목을 입력하세요.");
        $("#title").focus();
        return;
    }
    
    if($("input:radio[name=is_end]:checked").val() == "2"){ 
    
	    if($("#edate").val().length < 1){
	        alert("마감일을 입력하세요.");
	        $("#edate").focus();
	        return;
	    }
    }    
    
    if($("#contents_").val().length < 1){
        alert("내용을 입력하세요.");
        $("#contents_").focus();
        return;
    }
    
    if($("#contents_").val().length > 2000){
        alert("내용은 4000byte까지 가능합니다.");
        $("#contents_").attr("value", $("#contents_").val().substring(0,2000));
        return;
    }
    
    if($("#type").val() == 2){
	    if($("#joinUserIDList").val().length < 1){
	        alert("협업담당자를 입력하세요.");
	        return;
	    }
    }
    
    $("#workform").attr("action","/gw/neos/pims/work/workUpdateProc.do");
    $("#workform").attr("target", "_self");
    $("#workform").submit();
    
}

function fn_egov_finish_work(){
	if(confirm("할 일을 완료하시겠습니까?")){
		$("#myform").attr("action","/gw/neos/pims/work/workFinishProc.do");
	    $("#myform").attr("target", "_self");
	    $("#myform").submit();
	}
}

function hideWriteForm(){
    $("#div_work_form").hide();
    dialogViewSet(false);
}

/* 달력 컨트롤 초기화 */
write.calendar = function(){
    var calendarList = ["edate"];
    var pickerOpts = {
            showOn : 'button',
            buttonImage : NeosUtil.getCalcImg(),
            buttonImageOnly : false,
            changeMonth : true,
            changeYear : true,
            buttonText : "날짜선택",
            duration : "normal",
            onSelect : function(dateText, inst) {
                //var id = $(inst).attr("id");
                //approvalSearchForm.datepickerOnSelect(dateText, id);
            }
        };
   
    for(var i =0, max = calendarList.length; i< max ; i++){
        $("#" + calendarList[i]).attr("readonly", "readonly"); 
        neosdatepicker.datepicker(calendarList[i], pickerOpts); 
    }
        
};
// 보낸협업 상세보기에서 보기
function fn_egov_view_rep_work(reply_seq){
    
    $("#reply_seq").attr("value", reply_seq);
    
    $.ajax({
        type:"post",
        target:"_self",
        url:'/gw/neos/pims/work/workMainReplyView.do',
        data:{"work_seq":$("#work_seq").val(),"reply_seq":$("#reply_seq").val()},
        datatype:"html",            
        success:function(data){  
            $("#div_reply").html(data);
            $("#div_reply").show();
            dialogViewSet(true);
        }
    });
}

function fn_egov_list_reply_work(currentPage){
    $("#currentPage").attr("value", currentPage);
    
    $("#myform").attr("action","/gw/neos/pims/work/workReplyList.do");
    $("#myform").attr("target", "_self");
    $("#myform").submit();
}
// 받은 협업 상세보기
function fn_egov_reply_view_work(work_seq, reply_seq){
    
    $("#work_seq").attr("value", work_seq);
    $("#reply_seq").attr("value", reply_seq);
    
    $.ajax({
        type:"post",
        target:"_self",
        url:'/gw/neos/pims/work/workReplyView.do',
        data:{"work_seq":$("#work_seq").val(),"reply_seq":$("#reply_seq").val()},
        datatype:"html",            
        success:function(data){  
        	//alert(data);
            $("#div_work_form").html(data);
            $("#div_work_form").show();
            dialogViewSet(true);
        }
    });
}

function fn_egov_reply_updateProc_work() {
	
	$("#work_seq2").attr("value", $("#work_seq").val());
	$("#reply_seq2").attr("value", $("#reply_seq").val());

	if($("#title").val().length < 1){
        alert("답변을 입력하세요.");
        $("#title").focus();
        return;
    }
	
	if($("#title").val().length > 2000){
        alert("답변은 4000byte까지 가능합니다.");
        $("#title").attr("value", $("#title").val().substring(0,2000));
        return;
    }
    
    $("#workform").attr("action","/gw/neos/pims/work/workReplyUpdateProc.do");
    $("#workform").attr("target", "hiFrame");
    $("#workform").submit();
    
}

function fn_egov_reply_deleteProc_work() {
	
	if(confirm("답변 내용을 삭제하시겠습니까?")){
		$.ajax({
	        type:"post",
	        target:"_self",
	        url:'/gw/neos/pims/work/workReplyDeleteProc.do',
	        data:{"work_seq":$("#work_seq").val(),"reply_seq":$("#reply_seq").val()},
	        datatype:"html",            
	        success:function(data){  
	        	if(data.err_code == "0000"){
	        		//fn_egov_reply_view_work($("#work_seq").val(), $("#reply_seq").val());
	        		fn_egov_list_reply_work($("#currentPage").val());
	            }else{
	                alert('오류가 발생하였습니다. 관리자에게 문의 바랍니다.');
	            }
	        }
	    });
	}else{
		return;
	}
    
}


function fn_egov_down_work(file_seq){
    
    $("#file_seq").attr("value", file_seq);
            
    $("#myform").attr("action","/gw/neos/pims/work/workFileDown.do");
    $("#myform").attr("target", "_self");
    $("#myform").submit();
}

function fn_egov_deleteFile_work(file_seq){
    if(confirm("첨부파일을 삭제하시겠습니까?")){
	    $("#file_seq").attr("value", file_seq);
	    
	    $.ajax({
	        type:"post",
	        target:"_self",
	        url:'/gw/neos/pims/work/workFileDeleteProc.do',
	        data:{"work_seq":$("#work_seq").val(),"reply_seq":$("#reply_seq").val(),"file_seq":$("#file_seq").val()},
	        datatype:"html",            
	        success:function(data){  
	        	if(data.err_code == "0000"){
	                $("#div_file").hide();
	            }else{
	                alert('오류가 발생하였습니다. 관리자에게 문의 바랍니다.');
	            }
	        }
	    });
	}
}

function insNote(from, toids, tonms){
	$("#note_from").attr("value", from);
	$("#note_toids").attr("value", toids);
	$("#note_tonms").attr("value", tonms);
	$("#note_msg").attr("value", tonms + "님이 요청하신 협업을 완료하였습니다.\r\n");
	
	$("#myform").attr("action","/gw/anonymous/messenger/SendMsgNP.do");
    $("#myform").attr("target", "hiFrame");
    $("#myform").submit();
    
    alert(tonms + '님께 쪽지가 발송되었습니다.');
}

/**
 * 조직도 
 */
var openOrgList = function(obj){
    NeosUtil.openMultiSelectUser();
}
 
var getMultiSelectUser = function(obj){
	return { 
			name : $("#joinUserNameList").val(), 
			id : $("#joinUserIDList").val(),
			dept : $("#joinUserDeptList").val()
		};
};

/* 팝업에서 참여자 리스트 셋팅 */
var setMultiSelectUser = function(name, id, dept){
    //alert(name);
    //alert(dept);
    //alert(id);
	$("#joinUserNameList").val(name);
	$("#joinUserIDList").val(id);
	$("#joinUserDeptList").val(dept);
	
	var cnt = 0;
	try{
		cnt = name.split(",").length;
		if(!name.split(",")[0]){
			cnt = 0;
		}
	}catch(e){
		console.log(e);//오류 상황 대응 부재
	}
	
	$("#div_reply_cnt").html("총 " + cnt + "명");
}; 