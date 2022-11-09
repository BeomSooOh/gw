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
  * @Class Name  : CmmnDetailCodeList.jsp
  * @Description : 상세코드관리
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2015.06.18   조영욱              최초 생성
  * @ 2016.04.06   이두승              전체 수정
  *
  *  @author np파트 
  *  @since 2015.06.18
  *  @version 1.0
  *
  */
%>
<!-- 코드유형 선택 팝업 -->
<div id="codePop">
</div>


<div class="top_box">
	<dl class="dl1">
		<dt><input id="searchType"/ style="width:120px"></dt>
		<dd><input type="text" class=""id="searchKeyword"  style="width:173px;" /></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
</div>

<div class="sub_contents_wrap" style="">
<!-- 
	<div id="" class="controll_btn">
		<button id="" class="k-button">추가</button>
		<button id="" class="k-button">삭제</button>
		<button id="" class="k-button">등록구분</button>
	</div> -->
	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width:50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 리스트 -->
					<div id="grid"></div>					
				</td>
				<td class="twinbox_td">
					<!-- 옵션설정 -->
				<form id="frmCode">					
				<input type="hidden" id="hidType" name="crudType" />
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120"/>
								<col width="120"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000010792","코드유형 선택")%></th>
								<td>
									<input class="" id="txtTypeName" type="text" style="width:120px">
									<input type="hidden" id="hidTypeCode" name="codeTypeId" />
									<div id="" class="controll_btn p0">
										<button type="button" id="btnCodeSearch"><%=BizboxAMessage.getMessage("TX000001702","찾기")%></button>
									</div>
								</td>
							</tr>
							<tr style="display: none;">
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000010920","등록구분")%></th>
								<td>
									<input id="addcls_sel" style="width:121px;"/>
								</td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000010922","상세코드ID")%></th>
								<td><input class="" type="text" id="txtCodeId" name="codeId" style="width:95%"></td>
							</tr>
							<tr>
								<th rowspan="4"><%=BizboxAMessage.getMessage("TX000010921","상세코드명")%></th>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
								<td><input class="" type="text" id="txtCodeNm" name="codeNm" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
								<td><input class="" type="text" id="txtCodeNmEn" name="codeNmEn" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
								<td><input class="" type="text" id="txtCodeNmJp" name="codeNmJp" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
								<td><input class="" type="text" id="txtCodeNmCn" name="codeNmCn" style="width:95%"></td>
							</tr>
							
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								<td><input class="" type="text" id="txtCodeDesc" name="codeDesc" style="width:95%"></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td>
									<input type="radio" name="useYn" id="rdoUseYn" class="k-radio" checked="checked">
									<label class="k-radio-label radioSel" for="rdoUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
									<input type="radio" name="useYn" id="rdoUseYn2" class="k-radio">
									<label class="k-radio-label radioSel ml10" for="rdoUseYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
								</td>
							</tr>
						</table>
					</div>
					<div class="btn_cen">
						<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
					</div>
				</form>	
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->
<script type="text/javascript">

$(document).ready(function() {
	//기본버튼
    $(".controll_btn button").kendoButton();
	
     $("#searchType").kendoComboBox({
        dataSource : [
          { name:"<%=BizboxAMessage.getMessage("TX000010922","상세코드ID")%>",value:0},
          { name:"<%=BizboxAMessage.getMessage("TX000010921","상세코드명")%>",value:1}
         ],
         dataTextField: "name",
         dataValueField: "value",
    	 index:0
    }); 
	
	    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	         transport: { 
	             read:  {
	                 url: 'CmmCodeDetailListData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                  options.searchKeyword = $("#searchKeyword").val();
	                  options.searchType = $("#searchType").data("kendoComboBox").value(); 
	                 	                    
	                 if (operation !== "read" && options.models) {
	                     return {models: kendo.stringify(options.models)};
	                 } 
	                 
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.resultList;
	 	  	    }
	 	  	  }
	     });
    
//grid table
$("#grid").kendoGrid({
     	dataSource: dataSource,
     	sortable: true ,
		selectable: "row",
  		scrollable: true,
  		columnMenu: false,
  		autoBind: true,
		height:556,
	    columns: [
	              /*
			{
				field:"선택", 
				width:34, 
				headerTemplate: '<input type="checkbox" name="checkAll" id="checkAll" class="k-checkbox" onclick="onCheckAll(this)"><label class="k-checkbox-label radioSel" for="checkAll"></label>', 
				headerAttributes: {style: "text-align:center;vertical-align:middle;"},
				template: '<input type="checkbox" name="chkCodeSel" id="#: DETAIL_CODE #" value="#: DETAIL_CODE #" class="k-checkbox" /><label class="k-checkbox-label radioSel" for="#: DETAIL_CODE #"></label>',
				attributes: {style: "text-align:center;vertical-align:middle;"},
		  		sortable: false
  			},*/
  			{
		  		field:"DETAIL_CODE", 
		  		title:"<%=BizboxAMessage.getMessage("TX000010919","유형ID")%>", 
		  		headerAttributes: {style: "text-align: center;"}, 
		  		attributes: {style: "text-align: center;"},
		  		sortable: false 
  			},
		  	{
		  		field:"DETAIL_NAME", 
		  		title:"<%=BizboxAMessage.getMessage("TX000010918","코드유형명")%>", 
		  		headerAttributes: {style: "text-align: center;"}, 
		  		attributes: {style: "text-align: center;"},
		  		sortable: false  
  			},
		  	{
		  		field:"", 
		  		title:"<%=BizboxAMessage.getMessage("TX000010920","등록구분")%>", 
		  		headerAttributes: {style: "text-align: center;"}, 
		  		attributes: {style: "text-align: center;"},
		  		sortable: false  
  			},
  			{
		  		field:"USE_YN", 
		  		title:"<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>", 
		  		headerAttributes: {style: "text-align: center;"}, 
		  		attributes: {style: "text-align: center;"},
		  		template : function(dataItem) {
		  			if(dataItem.USE_YN == 'Y'){
		  				return "<%=BizboxAMessage.getMessage("TX000002850","예")%>";
		  			}
		  			else {
		  				return "<%=BizboxAMessage.getMessage("TX000006217","아니오")%>";
		  			}
		  			
		  		},
		  		sortable: false
  			}
		] ,
		dataBound: function(e){ 
			$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
				$("#grid tr[data-uid]").removeClass("k-state-selected");
				$(this).addClass("k-state-selected");
				
				//선택 item
				var selectedItem = e.sender.dataItem(e.sender.select());
				
				//데이타 조회 fucntion 호출
				fnSelectCode(selectedItem);
		        });							
		}
	});
	
	//검색버튼
	$("#searchButton").kendoButton({
		 click: function(e) {
			 gridRead();
		 } 
	});
	
	$("#btnCodeSearch").kendoButton({
		 click: function(e) {
		 var dialog = $("#codePop");
	    	var url = '<c:url value="/cmm/systemx/CmmCodeSelectPop.do" />';
	    	var title = "<%=BizboxAMessage.getMessage("TX000010792","코드유형 선택")%>";
	    		
	    	dialog.kendoWindow({
	    		iframe: true ,
	    		draggable: false,
	    		width : "600px",
	    		height: "460px",
	    		title : title,
	    		visible : false,
	    		content : {
	    			url : url,
	    			type : "POST"
	    		},
	    		actions: [
	                          "Pin",
	                          "Minimize",
	                          "Maximize",
	                          "Close"
	                      ],
	    	}).data("kendoWindow").center().open();	
		 } 
	});
	
	
});

//전체 체크박스 
function onCheckAll(chkbox) {
	
	var grid = $("#grid").data("kendoGrid");
		
    if (chkbox.checked == true) {
    	checkAll(grid, 'chkCodeSel', true);
    	
    } else {
    	checkAll(grid, 'chkCodeSel', false);
    }
};

/**
* 체크박스 선택
* @param checks
* @param isCheck
*/
function checkAll(grid, checks, isCheck){
	var fobj = document.getElementsByName(checks);
	var style = "";
	if(fobj == null) return;
	if(fobj.length){
		for(var i=0; i < fobj.length; i++){
			if(fobj[i].disabled==false){
				fobj[i].checked = isCheck;
				CommonKendo.setChecked(grid, fobj[i]);
			}
		}
	}else{
		if(fobj.disabled==false){
			fobj.checked = isCheck;
		}
	}
}	

//리스트 가져오기 
function gridRead() {
	 var grid = $("#grid").data("kendoGrid");
		grid.dataSource.read();
		grid.refresh();
}


function fnSelectCode(items) {
	$("#txtCodeId").val(items.DETAIL_CODE);
	
	var detailNameMulti = items.DETAIL_NAME_MULTI.split("▦");
	
	$("#txtCodeNm").val(detailNameMulti[0]);
	$("#txtCodeNmEn").val(detailNameMulti[1]);
	$("#txtCodeNmJp").val(detailNameMulti[2]);
	$("#txtCodeNmCn").val(detailNameMulti[3]);
	
	
	$("#txtCodeDesc").val(items.NOTE);
	$("#txtTypeName").val(items.CODE_NAME);
	
	$("input:radio[name='useYn']:radio[value='"+items.USE_YN+"']").prop("checked",true);
	$("#hidType").val('U');
	
	/* var chkbox = $("input:checkbox[id='"+items.DETAIL_CODE+"']");
	$(chkbox).prop("checked",true);
	
	CommonKendo.setChecked($("#grid").data("kendoGrid"), chkbox); */
}
</script>
