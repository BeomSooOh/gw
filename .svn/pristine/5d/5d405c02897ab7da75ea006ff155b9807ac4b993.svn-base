<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	var selectedPage=1;
	
	$(document).ready(function() {
		 
		 // 회사선택 comboBox 추가
		    $("#com_sel").kendoComboBox({
		    	dataTextField: "compName",
	            dataValueField: "compSeq",
		        dataSource :${companyListJson},
		        index : 0,
		        change: gridRead,
		         filter: "contains",
		        suggest: true
		    }); 
		    
		    var coCombobox = $("#com_sel").data("kendoComboBox");
		    var cnt = $("#com_sel").data("kendoComboBox").dataSource.data().length;		    
			coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000022293","전체")%>", compSeq: "" });
			coCombobox.input.attr("readonly", true);
		    coCombobox.refresh();
		    coCombobox.select(0);
	
    	gridRead();
	});
	
	function dataSource(){
		return new kendo.data.DataSource({
	        serverPaging: true,
	        pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'AddrEmergencyContactList.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.groupSeq = '1';
	                 options.mainDeptYn = 'Y';
	                 options.compSeq = $("#com_sel").val();
					 options.searchSelect = $("#searchSelectBox").val();
				     options.searchContent = $("#searchText").val();
	                 options.existMaster = "N";
	                 
	                                 
	                 if (operation !== "read" && options.models) {
	                     return {models: kendo.stringify(options.models)};
	                 }
	                 
	                 return options;
	             }
	         }, 
	         schema:{
	            data: function(response) {
	              return response.list;
	            },
	            total: function(response) {
	              return response.totalCount;
	            }
	          }
	     });		
	}
	

	
	 function gridRead() {
		 
		
		 var grid = $("#grid").kendoGrid({
				 dataSource: dataSource(),
			     sortable: true ,
	 		     selectable: true,
			     navigatable: true,
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		height: 450,
	   	  		autoBind: true,
	   	  		page: selectedPage,
		   	  	pageable: {         
		            change: function (e){
		                selectedPage = e.index;            
		            },          
			 		refresh: true,
			    	pageSizes: [10, 20, 50, 100]
		        },   	
		        
	       		// 클릭시 팝업창으로 사용자 정보 조회
		     		dataBound: function(e){
		     		$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
							$("#grid tr[data-uid]").removeClass("k-state-selected");
							$(this).addClass("k-state-selected");
			            });	
		        	if($("#com_sel").val() !="NONE"){
		        		$("#grid tr[data-uid]").click(function(){
		        			var selectItem = e.sender.dataItem(e.sender.select());
		        			addrEmergencyContactPop(selectItem.compSeq, selectItem.groupSeq, selectItem.empSeq, selectItem.langCode);
		        		});
		        	}
		        },
	   	  		columns: [
                            { field: "compName", title: "<%=BizboxAMessage.getMessage("TX000018385","회사명")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true  },
			                { field: "deptName", title: "<%=BizboxAMessage.getMessage("TX000000068","부서명")%>", width:180, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true },
			                { field: "positionName", title: "<%=BizboxAMessage.getMessage("TX000018672","직급")%>", width:80, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "dutyName", title: "<%=BizboxAMessage.getMessage("TX000000105","직책")%>", width:80, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true}, 
			                { field: "empNameId", title: "<%=BizboxAMessage.getMessage("TX000016217","사용자명(ID)")%>", width:120, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},  
			                {
								field:"<%=BizboxAMessage.getMessage("TX000000262","메일")%>",
								width: 210,
								headerAttributes: {style: "text-align: center;"},
								attributes: {style: "text-align: center;"},
								template: "#=getEmail(emailAddr,emailDomain)#"
			                },
			                { field: "bDay", title: "<%=BizboxAMessage.getMessage("TX000001672","생일")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "telNum", title: "<%=BizboxAMessage.getMessage("TX000002886","전화(회사)")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "homeTelNum", title: "<%=BizboxAMessage.getMessage("TX000002887","전화(집)")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "mobileTelNum", title: "<%=BizboxAMessage.getMessage("TX000001047","휴대폰")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true},
			                { field: "erpEmpSeq", title: "<%=BizboxAMessage.getMessage("TX000000385","사원번호")%>", width:100, headerAttributes: {style: "text-align: center;"}, attributes: {style: "text-align: center;"},sortable: true}
		           		]
			 }).data("kendoGrid");

		 	
	 }
	 
	 // email ID와 도메인 주소 합치는 함수
		function getEmail(email, domain){
			//todo  
			return email+"@"+domain;
		}
	 
	 function compChange(e) {
			$("#compSeq").val($("#com_sel").val());
			
			document.form.compSeq.value = $("#com_sel").val();
			document.form.submit();
	}
	 
	 // 비상연락망 팝업창 함수
	 function addrEmergencyContactPop(compSeq, groupSeq, empSeq, langCode) {
    	 var url = "addrEmergencyContactPop.do?compSeq="+compSeq+"&groupSeq="+groupSeq+"&empSeq="+empSeq+"&langCode="+langCode;
    	 var pop = openWindow2(url,  "addrEmergencyContactPop", 700, 413, 0) ;
    	 pop.focus();
     }
	 
	function callbackSel(data) {
		if(data.returnObj.length > 0){
			$("#com_sel").data("kendoComboBox").value(data.returnObj[0].compSeq);		    
		
		$("#deptName").val(data.returnObj[0].deptName);
		}
	}
	
	function fnExport(){
		var para = "?mainDeptYn="+'Y';				
		para += "&compSeq="+$("#com_sel").val();
		para += "&searchSelect="+$("#searchSelectBox").val();
		para += "&searchContent="+$("#searchText").val();
		para += "&existMaster="+'N';
		
		window.document.location.href = "/gw/cmm/mp/addr/AddrEmergencyContactExport.do" + para;
	}
		
		
</script>

<div class="top_box">

	<dl class="dl1">

			<dt>
				<%=BizboxAMessage.getMessage("TX000000614","회사선택")%>
			</dt>
			<dd>
				<input id="com_sel">
			</dd>
			
			<dt>
			<select id="searchSelectBox" class="selectmenu" style="width:150px; margin-bottom:3px;">
				<option value="empNmSearch" selected="selected"><%=BizboxAMessage.getMessage("TX000013628","사원명(ID)")%></option>
				<option value="deptNmSearch"><%=BizboxAMessage.getMessage("TX000000068","부서명")%></option>
				<option value="positionNmSearch"><%=BizboxAMessage.getMessage("TX000018672","직급")%></option>
				<option value="dutyNmSearch"><%=BizboxAMessage.getMessage("TX000000105","직책")%></option>
				<option value="telNoSearch"><%=BizboxAMessage.getMessage("TX000002886","전화(회사)")%></option>
				<option value="mobileSearch"><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></option>
			</select>
			</dt>
			<dd>
			<input type="text" class="kr" id="searchText" style="width:160px;text-indent:4px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}" />
			<input type="button" id="searchButton" onclick="gridRead();" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"	/>			
			</dd>
	</dl>
</div>

<div class="right_div">
	<!-- 컨트롤버튼영역 -->
	<div id="" class="controll_btn">
		<button id="btnExport" onclick="fnExport();"><%=BizboxAMessage.getMessage("TX000005727","내보내기")%></button>
	</div>
</div>

<div class="sub_contents_wrap" id="bodyDiv">

	<div id="grid" class="com_ta2"></div>
	
</div><!-- //sub_contents_wrap -->


                
  
  