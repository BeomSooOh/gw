<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<!-- script-->
	
    <script type="text/javascript">
		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
			
		    
		    setCodeBind("clsPartner", "COM516", "Y");
		    
		    $("#svType").kendoComboBox({
			    dataSource : [
					    { text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"" },
					    { text: "<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>", value:"GW" },
	                    { text: "<%=BizboxAMessage.getMessage("TX000016796","ERP")%>", value:"ERP" }
			    ],
			    dataTextField: "text",
	            dataValueField: "value",
			    index: 0
		    });		    

			//사용여부 셀렉트박스
			$("#useYn").kendoComboBox({
		        dataSource : {
					data : [{ text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000180","사용")%>", value:"Y" },
                        { text: "<%=BizboxAMessage.getMessage("TX000001243","미사용")%>", value:"N" }]
		        },
		        dataTextField: "text",
                dataValueField: "value",
		        index: 0
		    });

		    //추가버튼
		    $("#addBtn").on("click", function(e) {
		    	partnerReg();
		    });
		    
		    $(".search").on("click", function(e) {
		    	gridRead();
		    });
		    
		    // 삭제
		    $("#delBtn").on("click", function(e){
		    	if($("input:checked[name='chkCdPartner']").length == 0){
		    		alert("<%=BizboxAMessage.getMessage("TX000020276","선택 된 항목이 없습니다.")%>");
		    		return;
		    	}
		    	
	    		if(!confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
	    			return;	
	    		}
	    		
		        var paramData = {};
		        paramData.cdPartnerList = "";
		        
		        $.each($("input:checked[name='chkCdPartner']"), function( index, value ) {
		        	paramData.cdPartnerList += (index != 0 ? "," : "") + "'" + value.value + "'";
		        });
		   		
			   	 $.ajax({
			     	type:"post",
			 		url:'partnerDelProc.do',
		            datatype: "json",
		            data: paramData,
			 		success: function (data) {
						if(data.result == "1"){
							gridRead();
						}
					},
					error: function (result) {
			 			
			 		}
			 	});	    		
		    });
		    
		    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	  		pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'partnerManageData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	            	 options.compSeq = $("#selComp").val();
	                 options.sKeyword = $("#sKeyword").val();
	                 options.clsPartner = $("#clsPartner").val();
	                 options.useYn = $("#useYn").val();
	                 options.svType = $("#svType").val();
	                 options.noCompany = $("#noCompany").val();
	                    
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
		    
		    // 등록, 수정, 보기에서 넘어왔을때 해당 페이지로 이동
		    var page = parseInt('${params.page}') || 1;
		    
			dataSource.query({
		            page: page,
		            group: dataSource.group(),
		            filter: dataSource.filter(),
		            sort: dataSource.sort(),
		            pageSize: dataSource.pageSize()
		    });
		    
		    //grid table
			$("#grid").kendoGrid({
				columns: [
					{
						field:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						title:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						width:34, 
						headerTemplate: '<input type="checkbox" id="chkAll" onclick="onCheckAll(this)" />', 
						headerAttributes: {style: "text-align:center;vertical-align:middle;"},
						template: '<input type="checkbox" name ="chkCdPartner"  value="#=cdPartner#" />',
						attributes: {style: "text-align:center;vertical-align:middle;", clickevent : "N"},
				  		sortable: false
		  			},
		  			
		           	<c:if test="${loginVO.userSe == 'MASTER'}">
		          	{
		          		title:"<%=BizboxAMessage.getMessage("TX000000047","회사")%>",
		          		field:"compName",
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false		          		
		        	},		
					</c:if>		  			
		  			
		  			{
				  		field:"cdPartner", 
				  		title:"<%=BizboxAMessage.getMessage("TX000000315","거래처코드")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false 
		  			},
				  	{
				  		field:"lnPartner", 
				  		title:"<%=BizboxAMessage.getMessage("TX000000313","거래처명")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false  
		  			},
		  			{
				  		field:"noCompany",
				  		title:"<%=BizboxAMessage.getMessage("TX000010591","사업자등록번호")%>",
				  		width:140, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false  
		  			},
		  			{
				  		field:"clsPartnerNm",
				  		title:"<%=BizboxAMessage.getMessage("TX000010590","거래처분류")%>",
				  		width:100,  
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false
		  			},
					{
				  		field:"svTypeNm",
				  		title:"<%=BizboxAMessage.getMessage("TX000010589","정보유형")%>",
				  		width:100,  
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false
		  			},
		  			{
				  		field:"useYnNm",
				  		title:"<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",
				  		width:70, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false
		  			}
				],
				
				dataSource: dataSource,
				selectable: "single",
				sortable: false ,
	   	  		navigatable: true,
	   	  		pageable: {
					refresh: false,
	   	    		pageSizes: true
	   	  		},
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		autoBind: false,
				dataBound: function(e){ 
					$("#grid td[clickevent='Y']").css("cursor","pointer").click(function () {
						$("#grid tr[data-uid]").removeClass("k-state-selected");
						$(this).parent().addClass("k-state-selected");
						
						//선택 item
						var selectedItem = e.sender.dataItem(e.sender.select());
						
						//데이타 조회 fucntion 호출
						partnerInfo(selectedItem.cdPartner, selectedItem.compSeq);
			            });							
				}
			});
		    
			//ERP연동팝업
			$("#erpSyncBtn").on("click",function(){
				erpSyncPop();
			});	
			
			checkErpSet();
			
			$("#selComp").on("change",function(){
				checkErpSet();
				gridRead();
			});			    

		});
		
		function setCodeBind(selectId, code, allYn){
			$("#" + selectId).empty();
			
	        var paramData = {};
	        paramData.code = code;
	   		
		   	 $.ajax({
		     	type:"post",
		 		url:'<c:url value="/cmm/systemx/CmmGetCodeList.do"/>',
	            datatype: "text",
	            data: paramData,		
		 		success: function (data) {
		 			
		 			$("#" + selectId).kendoComboBox({
					    dataSource : data.resultList,
					    dataTextField: "detailName",
			            dataValueField: "detailCode",
					    index: 0
				    });
		 			
		 			if(allYn == "Y"){
		 			    var coCombobox = $("#" + selectId).data("kendoComboBox");
		 				coCombobox.dataSource.insert(0, { detailName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", detailCode: "" });
		 			    coCombobox.refresh();
		 			    coCombobox.select(0);		 				
		 			}
		 			
				},
				error: function (result) {
		 			
		 		}
		 	});
	    }		
		
		function checkErpSet(){
			if($("#selComp option:selected").attr("erpuseyn") == "Y"){
				$("#erpSyncBtn").show();
				$("#selectCompSeq").val($("#selComp").val());
			}else{
				$("#erpSyncBtn").hide();
			}
			
			if($("#selComp").val() == ""){
				$("#addBtn").hide();
			}else{
				$("#addBtn").show();
			}
			
		}
		
		function erpSyncPop(){
			var width = 500;
			var height = 400;
			var windowX = Math.ceil( (window.screen.width  - width) / 2 );
			var windowY = Math.ceil( (window.screen.height - height) / 2 );
			var pop = window.open("", "erpSyncPartnerSetPop", "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars=no");	
			popForm.target = "erpSyncPartnerSetPop";
			popForm.method = "post";
			popForm.action = "/gw/erp/orgchart/erpSyncPartnerSetPop.do";
			popForm.submit();
			pop.focus();
		}		
		
		function onCheckAll(chkbox) {
		    if (chkbox.checked == true) {
		    	checkAll('chkCdPartner', true)
		    } else {
		    	checkAll('chkCdPartner', false)
		    } 
		}
		
	    function gridRead() {
			 var grid = $("#grid").data("kendoGrid");
				grid.dataSource.read();
				grid.refresh();
		}
		    
		function partnerInfo(cdPartner, compSeq) {
			var url = "partnerRegPop.do?cdPartner=" + cdPartner + "&compSeq=" + compSeq;
	    	var pop = window.open(url, "partnerInfoPop", "width=995,height=630,scrollbars=yes");
	    	pop.focus();   
		}
		
		function partnerReg() {
			var url = "partnerRegPop.do?compSeq=" + $("#selComp").val();
	    	var pop = window.open(url, "partnerRegPop", "width=995,height=630,scrollbars=yes");
	    	pop.focus();
		}

	</script>
						
<form id="form" name="form" method="post" >
	<input type="hidden" id="cdPartner" name="cdPartner" value="" />
	<input type="hidden" name="pageSize" value="${params.pageSize}" />
	<input type="hidden" name="redirectPage" value="${params.redirectPage}" />
	<input type="hidden" id="page" name="page" value="${params.page}" />
							
						<div class="top_box">
							<dl class="dl1">
								<dt <c:if test="${loginVO.userSe != 'MASTER'}"> style="display:none;"</c:if>><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
								<dd <c:if test="${loginVO.userSe != 'MASTER'}"> style="display:none;"</c:if>>
									<select id="selComp">
										<c:if test="${loginVO.userSe == 'MASTER'}">
										<option value="" erpuseyn="N" ><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>		
										</c:if>
						
										<c:forEach var="items" items="${compList}">
										<option value="${items.compSeq}" erpuseyn="${items.erpUseYn}" >${items.compName}</option>
										</c:forEach>
									</select>
								</dd>
								
								<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
								<dd><input id="useYn" style="width:80px;"/></dd>								
																	
								<dt><%=BizboxAMessage.getMessage("TX000000313","거래처명")%> / <%=BizboxAMessage.getMessage("TX000000315","거래처코드")%></dt>
								<dd><input type="text" class=""id="sKeyword"  style="width:173px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}" /></dd>
								
								<dd><input type="button" id="searchButton" class="search" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
							</dl>
							<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='<c:url value="/Images/ico/ico_btn_arr_down01.png"/>'/></span>
						</div>
						
						<div class="SearchDetail">
							<dl>
								<dt><%=BizboxAMessage.getMessage("TX000010590","거래처분류")%></dt>
								<dd class="mr20"><input id="clsPartner" style="width:98px;"/></dd>

								<dt><%=BizboxAMessage.getMessage("TX000010589","정보유형")%></dt>
								<dd class="mr20"><input id="svType" style="width:98px;"/></dd>

								<dt><%=BizboxAMessage.getMessage("TX000010591","사업자등록번호")%></dt>
								<dd><input type="text" id="noCompany"  style="width:173px;" /></dd>														
							</dl>
						</div>
						
						<div class="sub_contents_wrap" style="">
							<div class="btn_div">
								<div class="left_div">
									<div id="" class="controll_btn" style="padding:0px;">
										<button id="addBtn" class="k-button" type="button" ><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
										<button id="delBtn" class="k-button" type="button" ><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
									</div>
								</div>							
								<div class="right_div">
									<div id="" class="controll_btn" style="padding:0px;">
										<button id="erpSyncBtn" type="button" style="display:none;"><%=BizboxAMessage.getMessage("TX900000087","ERP 거래처 가져오기")%></button>
									</div>
								</div>
							</div>
							<!-- 리스트 -->
							<div id="grid"></div>
						</div><!-- //sub_contents_wrap -->
</form>

<form id="popForm" name="popForm" method="post">
	<input type="hidden" id="selectCompSeq" name="selectCompSeq" value="" />
</form>