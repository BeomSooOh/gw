<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
 /**
  * @Class Name  : EgovCcmCmmnDetailCodeList.jsp
  * @Description : EgovCcmCmmnDetailCodeList 화면
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2009.04.01   이중호              최초 생성
  *
  *  @author 공통서비스팀
  *  @since 2009.04.01
  *  @version 1.0
  *  @see
  *
  */
%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="main.web.BizboxAMessage"%>
<html lang="ko">
<head>
<title><spring:message code='system.comm.detail.commCode.list' /></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" >
<script type="text/javascript" src="<c:url value='/js/neos/json2.js'></c:url>"></script>
<script type="text/javascript">

/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/
$(function(){
	codeDetailObj.init();
	//$(window).resize(function(){
	//	codeDetailObj.windowsResizeFunction();
	//});
});



var codeDetailObj = {};
codeDetailObj.jsondata = {};
codeDetailObj.clCodeObj = {};
codeDetailObj.codeIdObj = {};

codeDetailObj.windowsResizeFunction = function(){
	//codeDetailObj.resizeTopSearch();
	//codeDetailObj.boardTableWidth();
};
/* codeDetailObj.boardTableWidth = function()
{
	//alert();
	$("#table_board2_th1").css("width", "96px");

 	var win_w1 = $(window).width() - 30;
	var min = jqGridUtil.minWidth();
	if(win_w1 && parseInt(win_w1)< parseInt(min)){
		return false;
	}
    var leftWidth = NeosUtil.getLeftMenuWidth();
	var width = win_w1 - leftWidth;

	var width_result = width - 96;
	$("#table_board2_td1").css("width", width_result);

}; */

codeDetailObj.init = function(){
	// 검색어란 key action
	codeDetailObj.searchTextSet();
	// 윈도우 리사이즈
	codeDetailObj.windowsResizeFunction();
	$("#shoutCutTitle").html('<spring:message code="system.comm.detail.commCode.list" />');
	//var list = '${cmmnClCodeList}';
	//alert('list :'+list);

	/*
	var jsonObj = eval('('+list +')');
	alert(jsonObj[0].clCode);
	alert(jsonObj[1].clCode);
	 */
	//  use json2.js
	//codeDetailObj.clCodeObj =  JSON.parse('${cmmnClCodeList}');
	//codeDetailObj.codeIdObj =  JSON.parse('${cmmnCodeList}');
	//alert(' size > clCodeObj  :'+ codeDetailObj.clCodeObj.length+'  /   codeIdObj : '+ codeDetailObj.codeIdObj.length);


	var clCode = NeosCodeUtil.getCodeSelectList(codeDetailObj.clCodeObj, "clCode",null,"codeDetailObj.selectCodeId()");
	var clCodeSelect = $(clCode).css("width", "180px");
	$("#clCodeSelect").append(clCodeSelect);

	codeDetailObj.selectCodeId();

};

codeDetailObj.pagingClick = function(pageNo){
	$("#pageIndex").val(pageNo);
	var listForm = $("#listForm");
	listForm.submit();
};

// 목록회면 처리 함수
codeDetailObj.selSearchList= function(){
	if ($("#searchCondition").val() == 1) {
		$("#searchCondition").show();
		$("#searchCondition2").hide();
	} else {
		$("#searchCondition").hide();
		$("#searchCondition2").show();
	}
};

codeDetailObj.search = function(){
	if ($("#searchCondition").val() == "1" || $("#searchCondition2").val() == "1") {
		$("#searchKeyword").val($("#searchKeyword").val().replace(/\-/, ""));
	}
	codeDetailObj.pagingClick(1);
};

codeDetailObj.searchTextSet = function(){
	$("#searchKeyword").bind({
		keypress : function(event){
			if(event.keyCode == 13){
				codeDetailObj.search();
			}
		}
	});
};

codeDetailObj.openEditForm = function(){
	$("#divEditForm").slideDown();	// 작성폼 열기
	$("#divListBtn").hide();	// 목록 버튼 닫기
	codeDetailObj.windowsResizeFunction();
};

codeDetailObj.closeEditForm = function(){
	$("#divEditForm").slideUp();	// 작성폼 닫기
	$("#divListBtn").show();	// 목록 버튼 열기
	codeDetailObj.windowsResizeFunction();
};


// Form 정보 세팅
codeDetailObj.setCmdTitle = function(cmd){
	codeDetailObj.EditFormInit();
	$("#cmd").val(cmd);
	if( cmd=='save'){
		$("#cmdTitle").html('<spring:message code="button.create" />');
	}else if(cmd=='Modify'){
		$("#cmdTitle").html('<spring:message code="button.read.detail" />'); /*상세정보*/
	}
};

//코드초기화
codeDetailObj.detailInit = function(){
	NeosCodeUtil.codeReBuild();
};

// 신규 작성
codeDetailObj.create = function(){

	codeDetailObj.setCmdTitle("save");

	$('input:radio[name=use_yn]:radio[value=Y]').prop('checked', 'checked');
    $('[name=detail_code]').val("");
    $('[name=detail_name]').val("");
    $('[name=detail_note]').val("");

	$("#list").resetSelection();
};

//내용보기
codeDetailObj.read = function(rowid){

	codeDetailObj.setCmdTitle("Modify");

	var obj = codeDetailObj.jsondata[rowid-1];

	if(obj){
		// 사용여부  
		$("#useAt > option[value = "+obj.useAt+"]").attr("selected", "ture");   // "selected"  or   "ture"
		
        $("#clCode > option[value = "+obj.clCode+"]").attr("selected", "ture");   // "selected"  or   "ture" 
		codeDetailObj.selectCodeId();
		$("#codeId > option[value = "+obj.codeId+"]").attr("selected", "ture");   // "selected"  or   "ture"
        $("#clCode").attr("disabled","disabled");       
        $("#codeId").attr("disabled","disabled");  

		//$("#tr_codeIdSel").hide();  // 코드ID 셀렉트 박스
		$("#code").val(obj.code);
		$("#code").attr("disabled", "disabled");
		$("#codeNm").val(obj.codeNm);
		if(obj.codeDc!=null)	$("#codeDc").val(obj.codeDc);	//
	}
	codeDetailObj.openEditForm();
};


//  등록/수정 취소
codeDetailObj.cancel = function(){
	var isCancel = confirm('<spring:message code="common.cancel.msg" />');/*취소하시겠습니까?*/
	if(isCancel){
		codeDetailObj.codeDetailList();
		$("#list").resetSelection();
	}
};

codeDetailObj.codeDetailList = function(){
	codeDetailObj.closeEditForm();
	codeDetailObj.EditFormInit();
};

codeDetailObj.EditFormInit = function(){
	var empty = "";

	$("#code").val(empty);
	$("#code").removeAttr("disabled");
	$("#clCode").removeAttr("disabled");
	$("#codeId").removeAttr("disabled");
 	$("#clCode").val("EFC");
	$("#codeId").val("COM001"); 
	$("#codeNm").val(empty);
	$("#codeDc").val(empty);	//

};

codeDetailObj.resizeTopSearch = function(){
	var win_w1 = $(window).width();
	var min = jqGridUtil.minWidth();
	 if(win_w1 && parseInt(win_w1)< parseInt(min)){
		 return false;
	 }
	 var leftWidth = NeosUtil.getLeftMenuWidth();
	 var width = win_w1 - leftWidth -14 ;
	 $(".top_search").css("width", width);
};

// 필수입력값 체크
codeDetailObj.validate = function(isNew,code,codeNm,codeDc){

	if(isNew) // 신규인 경우에만
		if(codeDetailObj.chkNull(code,"<spring:message code='system.comm.detail.commCode.code' />"))		return false;  //코드

	if(codeDetailObj.chkNull(codeNm,"<spring:message code='system.comm.detail.commCode.codeNm' />"))		return false;  //코드명
	if(codeDetailObj.chkNull(codeDc,"<spring:message code='system.comm.detail.commCode.codeDesc' />"))	return false;  //코드 설명

	return true;
};

codeDetailObj.chkNull = function(fVal, fTitle){
	if(!$.trim(fVal)){
		alert(fTitle+"<spring:message code='valid.input.form.requisite.msg' />"); /*  (을)를 입력해주세요.*/
		return  true;
	}
	return false;
};

codeDetailObj.selectCodeId = function(){
	var clCode = $("#clCode").val();
	$("#codeIdSelect").html("");
	var codeId = NeosCodeUtil.getCodeSelectList(codeDetailObj.codeIdObj, "codeId", clCode,"");
	var codeIdSelect = $(codeId).css("width", "140px");
	$("#codeIdSelect").html(codeIdSelect);
};

//삭제
codeDetailObj.del =  function(){
	$("#isDel").val(true);
	codeDetailObj.actionSubmit();
};

// 수정.등록.삭제 처리.
codeDetailObj.actionSubmit = function(){

	var cmd = $("#cmd").val();	  // save, Modify, empty(delete)
	var isDel = $("#isDel").val();
	var isNew = cmd=='save'?true:false;

	// S : save  / M : modify  / D : delete
	var action;
	if(isDel == 'true'){

		var check = $("#board_table :checkbox[checked=checked]");
		var checkedLen = check.length;
		if(checkedLen==0){
			$("#isDel").val(false);
			alert("<spring:message code='system.comm.commCode.doDelSelect' />");		// 삭제할 코드를 선택해주세요.
			return false;
		}else if(checkedLen>1){
			$("#isDel").val(false);
			alert("<spring:message code='system.comm.commCode.doDelOneSelect' />");	// 삭제할 코드를 하나만 선택해주세요.
			return false;
		}
		action = "D";

	}else{
		action = isNew?"S":"M";
	}

	var comfirmMsg;

	if(action=="S"){  		// Save
		comfirmMsg = "<spring:message code='common.regist.msg' />";		//등록하시겠습니까?
	}else if(action=="M"){ 	// Modify
		comfirmMsg =  "<spring:message code='common.update.msg' />"; 	// 수정하시겠습니까?
	}else{					// Delete
		comfirmMsg = "<spring:message code='common.delete.msg' />";		//	삭제하시겠습니까?
	}

	var isConfirm = confirm(comfirmMsg);
	if(!isConfirm){
		$("#isDel").val(false);
		return false;
	}

	// save, Modify  ,  del
	var code = $("#code").val();			//  코드
	var codeId = $("#codeId").val();		//  코드 ID
	var codeNm = $("#codeNm").val();		//  코드명
	var codeDc = $("#codeDc").val();		//  코드ID 설명
	var useAt = $("#useAt").val();			//  사용여부

	if(isDel != 'true'){    // 삭제가 아닌 경우애만 valid 체크
		// 수정시 : codeNm  codeDc    , useAt
		// 신규 :  code + 수정시 항목   ..clCode  codeId
		if(!codeDetailObj.validate(isNew,code,codeNm,codeDc)){
			return false;
		}
	}

	var cUrl;
	var msgSuccess;
	var msgError;
	if(action=="S"){  	 // save
		cUrl = '<c:url value="/sym/ccm/cde/EgovCcmCmmnDetailCodeRegist.do" />';
		msgSuccess = "<spring:message code='system.bm.sign.insertend' />";  // 등록이 완료 되었습니다.
		msgError = "<spring:message code='system.bm.sign.inserterror' />";//등록을 실패 하였습니다.
	}else if(action=="M"){ 	// Modify
		cUrl = '<c:url value="/sym/ccm/cde/EgovCcmCmmnDetailCodeModify.do" />';
		msgSuccess = "<spring:message code='system.bm.sign.editend' />";//수정이 완료 되었습니다.
		msgError = "<spring:message code='system.bm.sign.editerror' />"; //수정을 실패 하였습니다.
	}else{
		cUrl = '<c:url value="/sym/ccm/cde/EgovCcmCmmnDetailCodeRemove.do" />';
		msgSuccess = "<spring:message code='system.bm.sign.deleteend' />";// 삭제가 완료 되었습니다.
		msgError = "<spring:message code='system.bm.sign.deleteerror' />"; //삭제가 실패 하였습니다.
	}
	msgError = msgError +"\r\n<spring:message code='system.bm.sign.retryplz' />";  //   잠시후에 이용해주시기 바랍니다.

	 // 삭제인 경우  ::  복수건인 경우에만 필요.
	 //             단일 건인 경우 현재 확인중인 건만 삭제 가능하므로 불필요
	// if(isDel){
	//	var id = $("#list").jqGrid('getGridParam','selrow');
	//	var obj = codeDetailObj.jsondata[id-1];
	//	var formData = {
	//		"code" : obj.code,
	//		"codeId" : obj.codeID,
	//		"codeNm" : obj.codeNm,
	//		"codeDc" : obj.codeDc,
	//		"useAt" : obj.useAt
	//	};
	// }else{

		//var formData = $("#editForm").serialize();// disable    form 은 처리 불가.
		var formData = {
			"code" : code,
			"codeId" : codeId,
			"codeNm" : codeNm,
			"codeDc" : codeDc,
			"useAt" : useAt
		};
	//}

	$.ajax({
		type:"post",
		url:cUrl,
		datatype:"json",
		data: formData,
		success:function(data){
			switch (data.result) {
				case 0:
					alert(msgSuccess);
					codeDetailObj.pagingClick(1);
					break;
				case -1:
					alert("<spring:message code='system.comm.detail.commCode.regist.duplicate' />"); /*"이미 등록된 코드가 존재합니다."*/
					break;
				default :
					alert(msgError);
					break;
			}
		},
		error : function(e){	//error : function(xhr, status, error) {
			alert(msgError);
		}
	});


};
/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* --------------------------------------------------------  *
 * jqGrid START
 * --------------------------------------------------------- */
$(function(){
	BindKendoGrid();
	$(window).resize(function(){
		jqGridUtil.resizeJqGrid("board_table");
	});
    var query = {
            //pageSize: 10,
            //page:1
          };
 dataSource.query(query);
 
 $("#cboRegGubun").kendoComboBox(); 
} );

/*150716 Kendo*/
var dataSource = new kendo.data.DataSource({
    //serverPaging: true,
    //pageSize: 10,
    filter: {
      field: '1',
      operator: 'neq',
      value: '1'
    },
    transport: {
      read: {
        type: 'post',
        dataType: 'json',
        url: '<c:url value="/cmm/cmmncode/ccd/CmmnCodeDetailList2.do"/>'
      },
      parameterMap: function(data, operation) {
          var fromDate =  $("#searchFromDate").val();
          var toDate = $("#searchToDate").val();
          var searchDocflagSelect = $("#searchDocflag_select").val();
  
          data.fromDate = fromDate ;
          data.toDate = toDate ;
          data.docflag_select = searchDocflagSelect ;
          return data ;
      }
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
        return response.totalCount;
      }
    }
  });
function BindKendoGrid(){
    $("#list").kendoGrid({
    dataSource: dataSource,
    height: 430,
    sortable: false ,
    selectable: true,
    navigatable: false,
    scrollable: true,
    columnMenu: false,
    autoBind: true,
    columns: [
              { field: "chkAll", title: "<input type='checkbox' id='checkAll' onchange='SelectAll();'/>", width: "30px", filterable: false, sortable: false, 
    template: "<input type=\"checkbox\"  class=\"check_row\" />"  },
              { field: "DETAIL_CODE", title: "<%=BizboxAMessage.getMessage("TX000010922","상세코드ID")%>", width: "150px"},
              //{ field: "CLCODENM", title: "분류명"},
              { field: "DETAIL_NAME", title: "<%=BizboxAMessage.getMessage("TX000010921","상세코드명")%>"},
              { field: "NOTE", title: "<%=BizboxAMessage.getMessage("TX000010920","등록구분")%>"},
              //{ field: "CODEIDNM", title: "코드ID명"},
              { field: "USE_YN", title: "<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>", width: "150px"}
     ],// row 클릭 이벤트
//      change: function (arg) {
//          var selected = $.map(this.select(), function(item) {                                                
//              var test = $(item).find('td:eq(1)').first().text();
//              var test2 = $(item).find('td:eq(2)').first().text();
//              var test3 = $(item).find('td:eq(3)').first().text();
//              var test4 = $(item).find('td:eq(4)').first().text();
//              $("#detail_code").val(test);
//              $("#detail_name").val(test2);
//              $("#detail_note").val(test3);
//              $('input:radio[name=use_yn]:radio[value='+test4+']').prop('checked', 'checked');
//          });
//      }
    
    
    dataBound: function(e){ 
        $("#list tr[data-uid]").css("cursor","pointer").click(function (item) {
         $("#list tr[data-uid]").removeClass("k-state-selected");
         $(this).addClass("k-state-selected");
         
         //선택 item
         var selectedItem = e.sender.select();
         
         var test = $(selectedItem).find('td:eq(1)').first().text();
	      var test2 = $(selectedItem).find('td:eq(2)').first().text();
	      var test3 = $(selectedItem).find('td:eq(3)').first().text();
	      var test4 = $(selectedItem).find('td:eq(4)').first().text();
	      $("#detail_code").val(test);
	      $("#detail_name").val(test2);
	      $("#detail_note").val(test3);
	      $('input:radio[name=use_yn]:radio[value='+test4+']').prop('checked', 'checked');       
       });
    }
    
    
    
    
    
    });

}



function BindjqGrid(){
	var jsondata = $.parseJSON('${resultList}');
	//$("#jsonData").html( '${resultList}');
	codeDetailObj.jsondata = jsondata;
	var obj = {};
	obj.option = {
		data: jsondata,
		datatype: 'local',
		colNames:[
		 '<spring:message code="comm.board.listNo" />',  // 순번
		 '<spring:message code="system.comm.detail.commCode.codeId" />',  // 코드ID
		 '<spring:message code="system.comm.detail.commCode.code" />',  // 코드
		 '<spring:message code="system.comm.detail.commCode.codeNm" />',  // 코드명
		 '<spring:message code="cop.useAt" />',  // 사용여부
		  //'CodeIdNm',  // 코드명
		  'CodeDc',  // 코드 설명
		  'clCode'
		],
		colModel:[
		{name:'menuNm', index:'menuNm', align:'center',sortable:false},  // <c:out value="${(searchVO.pageIndex - 1) * searchVO.pageSize + status.count}"/>
		{name:'codeId', index:'codeId', align:'center'},	  // , editable: true
		{name:'code', index:'code',  align:'center'},
		{name:'codeNm', index:'codeNm',  align:'left' , formatter : jqGridUtil.textStyle},// , formatter : jqGridUtil.TextOverFlow
		{name:'useAt', index:'useAt', align:'center',  formatter : fn_useYN },
		//{name:'CodeIdNm', index:'CodeIdNm',  hidden:true},
		{name:'CodeDc', index:'CodeDc',  hidden:true},
		{name:'clCode', index:'clCode',  hidden:true}
		],
			multiselect:true,
			emptyrecords:"<spring:message code='common.nodata.msg' />" ,  // 데이터가 존재하지 않습니다.

			//ondblClickRow: function(rowid, iRow, iCol, e) { }, //row 더블 클릭시 상세 보기.

			//onSelectRow: function(rowid, iRow, iCol, e){ //row 클릭시 event
			onSelectRow: function(rowid){ //row 클릭시 event

				var idList = $("#list").jqGrid('getGridParam','selarrrow');
				for(var i =0;i< idList.length;i++){
					if(idList[i]!=rowid){
						$("#list").resetSelection(idList[i]);
					}
				}

				var idList = $("#list").jqGrid('getGridParam','selarrrow');
				if(idList.length){	// 선택 되었을 때에만 세팅.
					codeDetailObj.read(rowid);
				}
			},

			loadComplete  : function(){
				// 넘버 추가
				var ids = $("#list").jqGrid('getDataIDs');
				for(var i=0;i < ids.length;i++){
					var num = parseInt('<c:out value="${paginationInfo.totalRecordCount}"/>') - (parseInt('<c:out value="${(searchVO.pageIndex - 1) * searchVO.pageSize}"/>')+i);
					jQuery("#list").jqGrid('setRowData',ids[i],{menuNm:num});
				}

				$.jqGrid = {};
				//$.jqGrid.data = {"0":"6%","1":"20%", "2":"20%", "3":"40%", "4":"14%"};
				$.jqGrid.data = {"0":"20px","1":"80px","2":"150px", "3":"150px", "4":"100%", "5":"150px"};

				$.jqGrid.min = jqGridUtil.minWidth();
				jqGridUtil.resizeJqGrid("board_table");
				//jqGridUtil.tableRowStyle("list");
				jqGridUtil.tableRowClickStyle("list");  // row link 처리
				jqGridUtil.setEmptyData(obj, "board_table");
			}
		//,height:"700px"
	};
	//공통으로 적용할 옵션 가져오기
	obj = jqGridUtil.jqGridCommonOption(obj);
	$("#list").jqGrid(obj.option);
}
function fn_useYN(cellvalue, options, rowObject){
	if(cellvalue=='Y')  return  "<spring:message code='button.use' />";  // 사용
	else  return  "<spring:message code='button.use.none' />";  // 미사용
}
	
function search_upper_code(){
    var codeIdSearch = $("#codeIdSearch").val();
    //window.open('/cmm/cmmncode/ccd/selectCodePopupView.do?codeIdSearch='+codeIdSearch+'', "codeChkView", 'toolbar=no, scrollbar=no, width=330, height=250, resizable=no, status=no');
    window.open('<c:url value="/cmm/cmmncode/ccd/selectCodePopupView.do" />', "selectCodePopupView.do", 'toolbar=no, scrollbar=no, width=290, height=520, resizable=no, status=no');
}

/* --------------------------------------------------------  *
 * jqGrid END
 * --------------------------------------------------------- */
</script>

<style> 
                #fieldlist
                {
                    margin:0;
                    padding:0;
                } 
                #fieldlist li
                {
                    list-style:none;
                    padding:10px 0;
                }
                #fieldlist label {
                    display: inline-block; 
                    width: 150px;
                    margin-right: 5px;
                    text-align: right;
                }
</style>
</head>
<body>

<!--  edward  scrollbar 처리를 위한  body height check  실패.-_-
<div class='contents_body'>-->

    <form name="listForm" id="listForm"  action="<c:url value='/sym/ccm/cde/EgovCcmCmmnDetailCodeList.do'/>" method="post">
    <input name="pageIndex" id="pageIndex"  type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
        
<div class="searchArea clearfx" id="" >
        <span>
            <select name="searchCondition" id="searchCondition" class="text-pad" style="width:100px" title=""  >
                       <option selected value=''><spring:message code='select.option.title' /></option>
                       <option value='1' <c:if test="${searchVO.searchCondition == '1'}">selected="selected"</c:if>><spring:message code='system.comm.detail.commCode.codeId' /></option>
                       <option value='2' <c:if test="${searchVO.searchCondition == '2'}">selected="selected"</c:if>><spring:message code='system.comm.detail.commCode.code' /></option>
                       <option value='3' <c:if test="${searchVO.searchCondition == '3'}">selected="selected"</c:if>><spring:message code='system.comm.detail.commCode.codeNm' /></option>
             </select> <input type="text" name="searchKeyword" id="searchKeyword" style="width:200px;" value="${searchVO.searchKeyword }"  onkeyup="javascript:if(event.keyCode==13){codeDetailObj.search(); return false;}"/></span>
        <a href="javascript:codeDetailObj.search();" ><img src="<c:url value='/images/btn/btn_search.gif' />" alt="검색"  width="55" height="26"/></a>
</div>
    </form>

    <input id="cmd" name="cmd" type="hidden"/>
    <input id="isDel" name="isDel" type="hidden"/>
    
    <!--  수정/등록 화면   START -->
    <%--<form id="editForm" name="editForm" method="post" enctype="multipart/form-data" >
    <input id="cmd" name="cmd" type="hidden"/>
    <input id="isDel" name="isDel" type="hidden"/>

<div id="divEditForm" style="display:none; width:100% ">
       <fieldset class="mT20">
                    <legend>상세 정보</legend>
                    <ul class="inputForm">
                        <li id='tr_codeIdSel'><strong style="width:95px;"><spring:message code='system.comm.detail.commCode.codeId' /><span class="f_red">*</span></strong>
                             <span id='clCodeSelect'></span> <span id='codeIdSelect'></span>
                        </li>
                        <li><strong style="width:95px;"><spring:message code='system.comm.detail.commCode.code' /><span class="f_red">*</span></strong> 
                              <input type="text"  name="code" id="code" maxlength="15" style="width:153px;"/>
                        </li>
                        <li><strong style="width:95px;"><spring:message code='system.comm.detail.commCode.codeNm' /><span class="f_red">*</span></strong>
                              <input type="text"  name="codeNm" id="codeNm" maxlength="60" style="width:153px;"/> 
                        </li>
                        <li><strong style="width:95px; vertical-align:top;"><spring:message code='system.comm.detail.commCode.codeDesc' /></strong>
                              <textarea name="codeDc" id="codeDc" style="width:440px; height:40px;">내용을 입력해 주세요</textarea>
                         </li>
                         <li><strong style="width:95px;"><spring:message code='cop.useAt' /></strong>
                             <select name="useAt" id="useAt" class="select"  style="width:100px;"  title="<spring:message code='cop.useAt' />">
                                <option value='Y' ><spring:message code='button.use'/></option>
                                <option value='N' ><spring:message code='button.use.none'/></option>
                            </select>
                          </li>
                         
                    </ul>
            <p class="tC mT15" id="saveButton">
                 <a href="javascript:codeDetailObj.actionSubmit();" class="darkBtn"><span>저장</span></a> 
                 <a href="javascript:codeDetailObj.cancel();" class="grayBtn"><span>취소</span></a>
            </p>
            <p class="tC mT15"  style="display:none;"  id="editButton">
                 <a href="javascript:codeDetailObj.actionSubmit();" class="darkBtn"><span>수정</span></a> 
                 <a href="javascript:codeDetailObj.del();" class="grayBtn"><span>폐기</span></a>
            </p>
        </fieldset>             
</div>

	</form> --%>
	<!--  수정/등록 화면   END -->

	<div id="div_btn"></div>
	<script type="text/javascript">
		var msg = ["<%=BizboxAMessage.getMessage("TX000016340","다시가져오기")%>", "<spring:message code='button.new' />"/*신규 */, "<spring:message code='button.delete2' />"/*폐기 */];
		var fn = ["codeDetailObj.detailInit()", "codeDetailObj.create()","codeDetailObj.del()"];
		var div_btn = "div_btn";
		NeosUtil.makeButonType02(msg, fn, div_btn);
	</script>


    <div id="div_codelist">
        <div id="left_codelist" style="width:50%; float:left;">
			<div class="board_table mT7"  style="" id="board_table">
			       <table id="list" ></table>
			       <!--  table id="jsonData" ></table -->
			   </div>
        </div>
        
        <div id="right_codelist" style="width:48%; height:500px; float:right;">
            <ul id="fieldlist">
                <li>
                    <label for="CODE">*<%=BizboxAMessage.getMessage("TX000010792","코드유형 선택")%></label>
                    <input id="code_id" name="code_id" />
                    <a href="javascript:search_upper_code();" name="codeIdSearch" id="codeIdSearch"  class="btn18"><span><%=BizboxAMessage.getMessage("TX000001702","찾기")%></span></a>
                </li>
                <li>
                    <label for="TYPE"><%=BizboxAMessage.getMessage("TX000010920","등록구분")%></label>
                    
                    <select id="cboRegGubun" name="cboRegGubun" >
                    <c:forEach items="${cmmnCodeList}" var="c">
                        <option value="${c.CODE}">${c.NAME}</option>                  
                    </c:forEach>
                    </select>
                <li>
                    <label for="CODE"><%=BizboxAMessage.getMessage("TX000010922","상세코드ID")%></label>
                    <textarea id="detail_code" name="detail_code" style="width:250px; height:50px;"/></textarea>
                </li>
                <li>
                    <label for="NAME"><%=BizboxAMessage.getMessage("TX000010921","상세코드명")%></label>
                    <textarea id="detail_name" name="detail_name" style="width:250px; height:50px;"/></textarea>
                </li>
                <li>
                    <label for="NOTE"><%=BizboxAMessage.getMessage("TX000000016","설명")%></label>
                    <textarea id="detail_note" name="detail_note" style="width:250px; height:50px;"/></textarea>
                </li>
                <li>
                    <label for="USE_YN"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></label>
                    <input type="radio" name="use_yn" value="Y" /><%=BizboxAMessage.getMessage("TX000000180","사용")%>
                    <input type="radio" name="use_yn" value="N" /><%=BizboxAMessage.getMessage("TX000001243","미사용")%>                 
                </li>
           </ul>
           <p class="tC mT15" id="saveButton">
           <a href="javascript:codeDetailObj.actionSubmit();" class="darkBtn"><span><%=BizboxAMessage.getMessage("TX000001256","저장")%></span></a> 
           </p>
        </div>
   
	<div style="height: 12px;"></div>
	<%-- <div align="center" class="paging">
		<ui:pagination paginationInfo="${paginationInfo}" type="image"	jsFunction="codeDetailObj.pagingClick" />
	</div> --%>
<!--  /div  -->


</body>
</html>
