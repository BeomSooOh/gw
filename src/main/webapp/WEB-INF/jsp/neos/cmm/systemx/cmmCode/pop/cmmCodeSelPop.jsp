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
  * @Class Name  : cmmCodeSelPop.jsp
  * @Description : 코드유형 선택 팝업
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2016.04.06   이두승              최초 개발
  *
  *  @author 개발1팀
  *  @since 2016.04.06 
  *  @version 1.0
  *
  */
%>
<input type="hidden" id="hidCodeId"/>
<input type="hidden" id="hidCodeName"/>
<div class="pop_wrap_dir">				
	<div class="pop_con" >
	<p class="tit_p"><%=BizboxAMessage.getMessage("TX000017323","코드유형선택")%></p>
	<div class="code_div">
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="99"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000017324","코드유형검색")%></th>
					<td>
						<div class="dod_search">
							<input type="text" id="searchKeyword"  style="width:293px;" placeholder="<%=BizboxAMessage.getMessage("TX000010918","코드유형명")%>" /><a href="#" onclick="fnSearch()" class="btn_sear"></a>
						</div>
					</td>
				</tr>
			</table>
		</div>

		<div class="com_ta2 mt15" >			
			<!-- 리스트 -->
			<div id="grid" style="border-width:1px 0;"></div>
		</div>
	</div>	
	</div><!-- //pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btnConfirm" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
			<input type="button" id="btnCancle" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div>

<script>

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
              options.popSearch = "Y";	                    
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
	height:258,
columns: [	
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
		}
		],
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

$("#btnConfirm").kendoButton({
	click: function(e) {

		 var codeName = $("#hidCodeName").val();
		 var codeId = $("#hidCodeId").val();
		
		 if(codeId == ''){
			 alert("<%=BizboxAMessage.getMessage("TX000010793","코드를 선택해 주세요")%>");
			 return;
		 }
		 $("#txtTypeName", parent.document).val(codeName);
		 $("#hidTypeCode", parent.document).val(codeId);		 
		 
         parent.$("#codePop").data("kendoWindow").close();
		 
	 } 
});


function fnSearch(){
	var grid = $("#grid").data("kendoGrid");
	grid.dataSource.read();
	grid.refresh();
}

function fnSelectCode(items){
	$("#hidCodeId").val(items.CODE);
	$("#hidCodeName").val(items.NAMEMULTI);
}



</script>

