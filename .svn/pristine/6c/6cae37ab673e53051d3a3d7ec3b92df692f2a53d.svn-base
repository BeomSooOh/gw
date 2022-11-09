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
  * @Class Name  : CmmnCodeList.jsp
  * @Description : 코드유형관리
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2015.06.18   조영욱              최초 생성
  * @ 2016.04.05   이두승              전체 수정
  *
  *  @author np파트 
  *  @since 2015.06.18
  *  @version 1.0
  *
  */
%>
<div class="top_box">
	<dl class="dl1">
		<dt><input id="searchType" style="width:120px"/><!-- 코드유형ID / 유형명검색 --></dt>
		<dd><input type="text"   id="searchKeyword"  style="width:173px;" /></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
</div>

<div class="sub_contents_wrap" style="">
	<div id="" class="controll_btn">
		<button id="btnAdd" class="k-button"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
		<button id="btnDel" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
	</div>
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
								<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000010919","유형ID")%></th>
								<td><input id="txtCodeId" name="codeId" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th rowspan="4"><%=BizboxAMessage.getMessage("TX000010918","코드유형명")%></th>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" />
									<%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
								<td><input id="txtCodeNm" name="codeNm" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
								<td><input id="txtCodeNmEn" name="codeNmEn" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
								<td><input id="txtCodeNmJp" name="codeNmJp" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>								
								<th><img src="" alt="" />
									<%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
								<td><input id="txtCodeNmCn" name="codeNmCn" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								<td><input id="txtCodeDesc" name="codeDesc" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th colspan="2"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td>
									<input type="radio" name="useYn" id="rdoUseYn" class="k-radio" value="Y" checked="checked">
									<label class="k-radio-label radioSel" for="rdoUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
									<input type="radio" name="useYn" id="rdoUseYn2" class="k-radio" value="N">
									<label class="k-radio-label radioSel ml10" for="rdoUseYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
								</td>
							</tr>
						</table>
					</div>
					</form>
					<div class="btn_cen">
						<input type="button" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->
</div><!-- //iframe wrap -->
</div><!-- //sub_contents -->


<script type="text/javascript">

$(document).ready(function() {
	//기본버튼
    $(".controll_btn button").kendoButton();
	
    $("#searchType").kendoComboBox({
        dataSource : [
          { name:"<%=BizboxAMessage.getMessage("TX000010791","코드유형ID")%>",value:0},
          { name:"<%=BizboxAMessage.getMessage("TX000010790","유형명검색")%>",value:1}
         ],
         dataTextField: "name",
         dataValueField: "value",
    	 index:0
    });
	
	    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	        transport: { 
	             read:  {
	                 url: 'CmmCodeListData.do',
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
		selectable: "single",
  	  		scrollable: true,
  	  		columnMenu: false,
  	  		autoBind: true,
		height:556,
	    columns: [
			{
				field:"chkbox", 
				width:34, 
				headerTemplate: '<input type="checkbox" name="checkAll" id="checkAll" class="k-checkbox" onclick="onCheckAll(this)"><label class="k-checkbox-label radioSel" for="checkAll"></label>', 
				headerAttributes: {style: "text-align:center;vertical-align:middle;"},
				template: '<input type="checkbox" name="chkCodeSel" id="#=CODE#" value="#=CODE#" class="k-checkbox"/><label class="k-checkbox-label radioSel" for="#=CODE#"></label>',
				attributes: {style: "text-align:center;vertical-align:middle;"},
		  		sortable: false
  			},
  			{
		  		field:"CODE", 
		  		title:"<%=BizboxAMessage.getMessage("TX000010919","유형ID")%>", 
		  		headerAttributes: {style: "text-align: center;"}, 
		  		attributes: {style: "text-align: center;"},
		  		sortable: false 
  			},
		  	{
		  		field:"NAMEMULTI", 
		  		title:"<%=BizboxAMessage.getMessage("TX000010918","코드유형명")%>", 
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
		],
		dataBound: function(e){ 
			$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
				//$("#grid tr[data-uid]").removeClass("k-state-selected");
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
	 
     //추가 버튼
	 $("#btnAdd").kendoButton({
		 click: function(e) {
			 fnAddNewCode();
		 } 
	 });
	 
     //저장버튼
	 $("#btnSave").kendoButton({
		 click: function(e) {
			 fnSaveCode();
		 } 
	 });
	 
     //삭제버튼
	 $("#btnDel").kendoButton({
		 click: function(e) {
			 fnDelCode();
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

function selectRow(grid) {
	CommonKendo.setChecked($("#grid").data("kendoGrid"), this);
}

// 리스트 가져오기 
function gridRead() {
	 var grid = $("#grid").data("kendoGrid");
		grid.dataSource.read();
		grid.refresh();
}

function fnSelectCode(items) {
	$("#txtCodeId").val(items.CODE);
	
	var nameMulti = items.NAME.split("▦");
	
	$("#txtCodeNm").val(nameMulti[0]);
	$("#txtCodeNmEn").val(nameMulti[1]);
	$("#txtCodeNmJp").val(nameMulti[2]);
	$("#txtCodeNmCn").val(nameMulti[3]);
	
	$("#txtCodeDesc").val(items.NOTE);
	
	$("input:radio[name='useYn']:radio[value='"+items.USE_YN+"']").prop("checked",true);
	$("#hidType").val('U');
	
	/* var chkbox = $("input:checkbox[id='"+items.CODE+"']");
	$(chkbox).prop("checked",true);
	
	CommonKendo.setChecked($("#grid").data("kendoGrid"), chkbox); */
}

function fnAddNewCode() {
	$("#txtCodeId").val('');
	$("#txtCodeNm").val('');
	$("#txtCodeNmEn").val('');
	$("#txtCodeNmCn").val('');
	$("#txtCodeNmJp").val('');
	$("#txtCodeDesc").val('');
	
	$("input:radio[name='useYn']:radio[value='Y']").prop("checked",true);
	$("#hidType").val('I');
}

function fnSaveCode() {
	
	if($("#txtCodeId").val() == ''){
		alert("<%=BizboxAMessage.getMessage("TX000010789","유형ID를 입력해주세요")%>");
		return;
	}
	
	
	$.ajax({
		type:"post",
		url:"<c:url value='/cmm/systemx/CmmCodeSaveProc.do'/>",
		datatype: "json",
		data: $("#frmCode").serialize(),
        success: function (data) {
        	if(data.result == '-1'){
        		alert("<%=BizboxAMessage.getMessage("TX000002299","저장에 실패하였습니다.")%>");
        	}else if (data.result == '0'){
        		alert("<%=BizboxAMessage.getMessage("TX000010788","저장에 성공하였습니다")%>")
        	}
        	gridRead();
        }, error: function (res) {
            // 실패
            alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
        } 
		
	});
}

function fnDelCode() {
	
	var isChecked = $("input:checkbox[name='chkCodeSel']").is(":checked");
	
	if(!isChecked){
		alert("<%=BizboxAMessage.getMessage("TX000010787","삭제하실 코드를 체크해주세요")%>");
		return;
	}
	
	if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
	
		var checkedBox = $("input:checkbox[name='chkCodeSel']:checked");
		var total = checkedBox.length;
		var chekedItems = "";
		
		checkedBox.each(function (index,val){	
			if (index != total - 1 ) { 			
				chekedItems += $(this).val()+",";
		    }else {
		    	chekedItems += $(this).val();
		    }
		});	
		
		$.ajax({
			type:"post",
			url:"<c:url value='/cmm/systemx/CmmCodeDel.do'/>",
			datatype: "json",
			data: {items : chekedItems },
	        success: function (data) {
	        	gridRead();
	        }, error: function (res) {
	            // 실패
	            alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
	        } 
		});
	}else{
		return;
	}
	
}

</script>

