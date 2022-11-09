<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
 * 
 * @title 권한부여관리 화면
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2016. 7. 25.  이혜영        최초 생성
 *
 */
%>

<script>

var userSe = '${loginVO.userSe}';
var compSeq = '${loginVO.compSeq}';

$(document).ready(function() {
	//기본버튼
	$(".controll_btn button").kendoButton();
	comBoInit();
	fnGrid();
	assignInfo("");
	
	$("#btnMenuSave").click(function() {callbackSel();});
	
	$("#btnAdd").click(function() {fnAdd();});
	$("#btnDel").click(function() {fnDel();});
});

var menuAuthTypeOld = "";

function topMenuListinit(authorType){
	
	var menuAuthType = (authorType == "005" ? "ADMIN" : "USER");
	
	if(menuAuthType != menuAuthTypeOld){
		
		var topMenuList = [];
		
		$.ajax({
	        type:"post",
	        url:'<c:url value="/cmm/system/getAllTopMenuList.do" />',
	        data:{menuAuthType: menuAuthType},
	        datatype:"json",
	        async:false,
	        success:function(data){
	        	menuAuthTypeOld = menuAuthType;
	        	topMenuList = data.list;
	        }
	    });
	    
		$("#menu_sel").kendoComboBox({
			dataSource : topMenuList,
			dataTextField: "menuNm",
			dataValueField: "menuGubun",
			change :  assignInfo,
			index: 0
		});	
		
		var coComboboxMenu = $("#menu_sel").data("kendoComboBox");
		coComboboxMenu.dataSource.insert(0, { menuNm: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", menuGubun: "" });
		coComboboxMenu.refresh();
	}
}

function comBoInit(){
    // 마스터의 경우 회사선택 comboBox 추가
	if(userSe == 'MASTER'){
		$("#com_sel").kendoComboBox({
			dataTextField: "compName",
			dataValueField: "compSeq",
			dataSource :${compListJson},
			change: fnGrid,
			filter: "contains",
			suggest: true
		});
		    
		var coCombobox = $("#com_sel").data("kendoComboBox");
		coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
		coCombobox.refresh();
		coCombobox.select(0);
		
	}
	
    //대메뉴리스트 바인딩
	topMenuListinit("001");
	
	//권한구분 셀렉트박스
	var ddlAuthorType = NeosCodeUtil.getCodeList("COM505");
    $("#searchAuthorType").kendoComboBox({
        dataSource : ddlAuthorType,
        dataTextField: "CODE_NM",
        dataValueField: "CODE",
		change : fnGrid
    });	
    var comboxAuthorTyp = $("#searchAuthorType").data("kendoComboBox");
    comboxAuthorTyp.dataSource.insert(0, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", CODE: "" });
    comboxAuthorTyp.refresh();
    comboxAuthorTyp.select(0);
	
    // 기본부여여부
    $("#searchAuthorBaseYn").kendoComboBox({
        dataSource : [{ CODE_NM: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", CODE: "" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000002850","예")%>", CODE: "Y" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000002849","아니요")%>", CODE: "N" }],
        dataTextField: "CODE_NM",
        dataValueField: "CODE",
		index: 0,
		change : fnGrid
    });	
    // 사용여부
    $("#searchAuthorUseYn").kendoComboBox({
        dataSource : [{ CODE_NM: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", CODE: "" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000000180","사용")%>", CODE: "Y" }, { CODE_NM: "<%=BizboxAMessage.getMessage("TX000001243","미사용")%>", CODE: "N" }],
        dataTextField: "CODE_NM",
        dataValueField: "CODE",
		index: 1,
		change : fnGrid
    });
} 

// 권한  리스트
function fnGrid() {
	   
	$("#selAuthorCode").val("");
	$("#selAuthorType").val("");
	$("#selCompSeq").val("");
	assignInfo();
	
	var tblParam = {};
	tblParam.searchKeyword = $("#searchKeyword").val();
	tblParam.searchAuthorType = $("#searchAuthorType").val();
	tblParam.searchAuthorBaseYn = $("#searchAuthorBaseYn").val();
	tblParam.searchAuthorUseYn = $("#searchAuthorUseYn").val();
	tblParam.comp_seq = $("#com_sel").val();
  	
	$.ajax({
		type : "post",
		url  : "<c:url value='/cmm/system/authorCodeList.do'/>",
		dataType : "json",
		data : tblParam,
		async : false,
		success : function(result) {
			if (result.list) {
				var list = result.list;
				var nlen = list.length;
				var Html = "";
				for (var nfor = 0; nfor < nlen; nfor++) {
					Html += "<tr authorCode=\'" + list[nfor].authorCode + "\'";
					Html += " authorNm=\'" + list[nfor].authorNm +"\'";
					Html += " authorType=\'" + list[nfor].authorType +"\'";
					Html += " authorBaseYn=\'" + list[nfor].authorBaseYn +"\'";
					Html += " authorUseYn=\'" + list[nfor].authorUseYn +"\'";
					Html += " compSeq=\'" + list[nfor].compSeq +"\'>";					
					Html += "<td><input name=\'inp_chk\' class=\'k-checkbox\' id=\'" + list[nfor].authorCode + "\' type=\'checkbox\' value=\'" + list[nfor].authorCode + "\'>";
					Html += "<label class=\'k-checkbox-label chkSel2\' for=\'" + list[nfor].authorCode + "\'></label></td>";
					Html += "<td>" + list[nfor].authorNm + "</td>";
					Html += "<td>" + list[nfor].authorTypeNm + "</td>";
					Html += "<td>" + list[nfor].compNm + "</td>";
					Html += "<td>" + list[nfor].authorBaseYnNm + "</td>";
					Html += "<td>" + list[nfor].authorUseYnNm + "</td>";
					Html += "</tr>";
				}
				if(nlen == 0){
					Html += "<tr><td colspan='6'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
				}

				$("#tList").html(Html);
			}
		}, 
		error : function(result) {
			alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
		}
	});
	
	
	$("#tList tr").bind({
		dblclick : function(){
			
			var Item = {};
			Item.authorCode = $(this).attr("authorCode");
			Item.authorNm = $(this).attr("authorNm");
			Item.authorType = $(this).attr("authorType");
			Item.authorBaseYn = $(this).attr("authorBaseYn");
			Item.authorUseYn = $(this).attr("authorUseYn");
			Item.compSeq = $(this).attr("compSeq");
			
			fnEdit(Item);
		},
		click: function(){
			var Item = {};
			Item.authorCode = $(this).attr("authorCode");
			Item.authorNm = $(this).attr("authorNm");
			Item.authorType = $(this).attr("authorType");
			Item.authorBaseYn = $(this).attr("authorBaseYn");
			Item.authorUseYn = $(this).attr("authorUseYn");
			Item.compSeq = $(this).attr("compSeq");
			
			//전체 tr 초기화
			$("#tList tr").removeClass("on");
			//선택 tr 변경
			$(this).addClass("on");
    		
	    	$("#selAuthorCode").val(Item.authorCode);
	    	$("#selAuthorType").val(Item.authorType);
	    	$("#selCompSeq").val(Item.compSeq);
	    	
    		assignInfo();
    		
		 }
	});
}

var authorCode = "";
	
function assignInfo(){
	var no = 0;
	
	var compSeq = $("#selCompSeq").val();
	var authorCode = $("#selAuthorCode").val();
	var authorType = $("#selAuthorType").val();	

    //대메뉴리스트 바인딩
	topMenuListinit(authorType);	
	var menuGubun = $("#menu_sel").val();
	
	var obj = {
			startWith : 1
		, 	authorCode: authorCode
	 	,   compSeq   : compSeq
	 	,   menuGubun : menuGubun
	 	,   authorType : authorType
	}   
 	var url = '<c:url value="/cmm/system/authorMenuTreeView.do"/>';

 	$.ajax({
 		type:"post",
 		url:url,
 		data:obj,
 		datatype:"html",
 		    success:function(data){
 		    	$("#treeList").html(data);
 		    }
 	});		
	
}   

function callbackSel(data){
    
	if($("#selAuthorCode").val() ==""){
		alert("<%=BizboxAMessage.getMessage("TX000010853","권한을 선택하세요")%>");
		return;
	}
    var tblParam = {};

    tblParam.authorCode = $("#selAuthorCode").val();
    var authorType = $("#selAuthorType").val();
    tblParam.authorType = authorType;
    tblParam.menuGubun = $("#menu_sel").val();
    tblParam.treeCheckList = CommonKendo.getTreeCheckedToJson($("#treeview2").data("kendoTreeView"));
    
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/system/saveAuthMenu.do" />',
		datatype:"json",
		data: tblParam,
		success:function(data){
			var result = data.result;
			if(result == "insert"){		
				//기관을 저장 하였습니다.
				alert('<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>');
				   
				assignInfo();
				
			}else{
				//sql 에러가 발생했습니다! error code: {0}, error msg: {1}
				alert('<%=BizboxAMessage.getMessage("TX000010687","sql 에러가 발생했습니다")%>');				
// 				assignInfo();
			}																		 
		}
	});
	
}

// 전체 체크박스 
function onCheckAll(chkbox) {
	var isCheck = chkbox.checked;
	var treeview = $("#treeview2").data("kendoTreeView");
	
	var nodes = treeview.dataSource.view();
	setTreeNodesAllCheck(treeview, nodes, isCheck);
};	

function setTreeNodesAllCheck(treeview, nodes, isCheck){
	var node, childNodes;
	var _nodes = [];
	
	for (var i = 0; i < nodes.length; i++) {
		node = nodes[i];
		var dataItem = treeview.dataSource.get(node.seq);
		var n = treeview.findByUid(dataItem.uid);
		treeview.dataItem(n).set("checked", isCheck);
		
		if (node.hasChildren) {
			childNodes = setTreeNodesAllCheck(treeview, node.children.view(), isCheck);

		}
	}
}

//체크박스 선택시 toggle
function chkAll(allChkName, chkName) {
	var chkDoc = document.getElementsByName(chkName);

	var allChkName = document.getElementsByName(allChkName);
    allCheckBox(chkDoc, allChkName[0].checked);
}

function fnAdd(){
	var tblParam = {};
	tblParam.callback = "fnGrid";
	var url = '<c:url value="/cmm/system/AuthorCodeInfoPop.do" />';
	layerPopOpen(url, tblParam, "<%=BizboxAMessage.getMessage("TX000010852","권한코드 등록")%>", "400", "", "1");
}

function fnEdit(tblParam){
	
	tblParam.callback = "fnGrid";
	var url = '<c:url value="/cmm/system/AuthorCodeInfoPop.do" />';
	layerPopOpen(url, tblParam, "<%=BizboxAMessage.getMessage("TX000010851","권한코드 수정")%>", "400", "", "1");
}

function fnDel(){
	
	if(!checkBoxSelected(document.getElementsByName("inp_chk")) ) {
		alert("! <%=BizboxAMessage.getMessage("TX000006310","삭제할 권한을 선택하세요.")%>");
		return false ;
	}
    var list = document.getElementsByName("inp_chk");
    var chkedList =   checkBoxSelectedIndex(list) ;
    
	var len = list.length ;
	var cnt = chkedList.length ;

    var arrValue = new Array(cnt);

	var index  = 0 ;
	if (len ==  undefined ) {
		if( list.checked == true )  arrValue[0].authorCode =  list.value ;
	} else {

		for ( var i = 0 ; i < len ; i++ ) {
			if ( list[i].checked == true )  {
				
			    var arrNew = {};
			    arrNew.authorCode = list[i].value;
			    arrValue[index] = eval(arrNew);
			    index = index + 1;
			}
		}
	}

	var tblParam = {};
	tblParam.selectedList = JSON.stringify(arrValue);
	var isDel = confirm("! "+"<%=BizboxAMessage.getMessage("TX000016374","권한 삭제 시 연결된 메뉴 및 사용자가 모두 초기화 됩니다.　삭제 하시겠습니까?")%>".replace("　","\n"));/*삭제하시겠습니까?*/

	if(!isDel) return;
	
	$.ajax({
		type : "post",
		url  : '<c:url value="/cmm/system/delAuthCode.do" />',
		datatype : "json",
		data : tblParam,
		success:function(data){

			var result = data.result;
			if(result == 'delete'){
				alert('<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>');
				fnGrid();	
			}else{
				alert('<%=BizboxAMessage.getMessage("TX000010850","삭제처리중 오류가 발생하였습니다")%>');
			}
			
		}
	});
}


</script>
<input type="hidden" id="selAuthorCode" />
<input type="hidden" id="selAuthorType" />
<input type="hidden" id="selCompSeq" />

<c:if test="${loginVO.userSe != 'MASTER'}"> 
<input type="hidden" id="com_sel" val="${loginVO.compSeq}"/>
</c:if>

					<div class="top_box">
						<dl class="dl1">
						<c:if test="${loginVO.userSe == 'MASTER'}">
							<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
							<dd><input id="com_sel" /></dd>
						</c:if>	

							<dt><%=BizboxAMessage.getMessage("TX000000136","권한명")%></dt>
							<dd style="width:190px;">
								<input type="text" class="" id="searchKeyword"  style="width:162px;" value="${searchKeyword}"  onkeyup="javascript:if(event.keyCode==13){fnGrid();}"/>
							</dd>
							<dd class="mr40"><input id="" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onclick="javascript:fnGrid();" /></dd>
						</dl>
						<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000000793","상세")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>"/></span>
					</div>

					<div class="SearchDetail">
						<dl>
							<dt><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></dt>
							<dd class="mr20">
								<input id="searchAuthorType" name="searchAuthorType" style="width:98px;"/>
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000006305","기본부여여부")%></dt>
							<dd class="mr20">
							    <input id="searchAuthorBaseYn" name="searchAuthorBaseYn" style="width:98px;"/>
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
							<dd class="mr5">
							    <input id="searchAuthorUseYn" name="searchAuthorUseYn" style="width:98px;"/>
							</dd>
						</dl>
					</div>	

					<!-- 컨텐츠내용영역 -->
					<div class="sub_contents_wrap">
						
						<div class="twinbox mt15">
							<table>
								<colgroup>
									<col style="width:55%;" />
									<col />
								</colgroup>
								<tr>
									<td class="twinbox_td p0">
										<div class="pl15 pr15">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000015963","권한목록")%></p>
											<div class="controll_btn fr">
												<button type="button" id="btnAdd"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
												<button type="button" id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
											</div>
										</div>
										
										<!-- 테이블 -->
										<div class="com_ta2 mt15 ml15 mr15">
											<table>
												<colgroup>
													<col width="34"/>
													<col width=""/>
													<col width="90"/>
													<col width="130"/>
													<col width="90"/>
													<col width="107"/>
												</colgroup>
												<tr>
													<th>
														<input type="checkbox" name="all_chk" id="all_chk" class="k-checkbox" onClick="chkAll('all_chk','inp_chk');">
														<label class="k-checkbox-label chkSel" for="all_chk"></label>
													</th>
													<th><%=BizboxAMessage.getMessage("TX000000136","권한명")%></th>
													<th><%=BizboxAMessage.getMessage("TX000006303","권한구분")%></th>
													<th><%=BizboxAMessage.getMessage("TX000006442","적용회사")%></th>
													<th><%=BizboxAMessage.getMessage("TX000016352","기본부여")%></th>
													<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
												</tr>
											</table>
										</div>
										
										<div class="com_ta2 mb15 ml15 mr15 bg_lightgray ova_sc" style="height:477px;overflow-y:scroll;">
											<table>
												<colgroup>
													<col width="34"/>
													<col width=""/>
													<col width="90"/>
													<col width="130"/>
													<col width="90"/>
													<col width="90"/>
												</colgroup>
												<tbody id="tList"></tbody>
												
											</table>	
										</div>
									</td>
									<td class="twinbox_td p0">
										<div class="tb_borderB pl15 pr15 clear">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000003360","메뉴선택")%></p>
											
											<div class="controll_btn fr">
												<button type="button" id="btnMenuSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
											</div>
										</div>
										
										<div class="tb_borderB pl15 pr15 clear bg_lightgray">
											<p class="tit_p fl mt14"><%=BizboxAMessage.getMessage("TX000006286","메뉴분류")%></p>
											<div class="fl ml10 mt9">
												<input id="menu_sel"/>
											</div>
											<div class="fr mt14">
												<input type="checkbox" id="all_tree" class="k-checkbox" onclick="onCheckAll(this)">
												<label class="k-checkbox-label chkSel" for="all_tree"><%=BizboxAMessage.getMessage("TX000003025","전체선택")%></label>
											</div>
											
										</div>
										
										<div class="treeCon" id="treeList">									
<!-- 											<div id="treeview" class="tree_icon" style="height:492px;"></div> -->
										</div>
									</td>
								</tr>
							</table>
						</div>
						
					</div><!-- //sub_contents_wrap -->	