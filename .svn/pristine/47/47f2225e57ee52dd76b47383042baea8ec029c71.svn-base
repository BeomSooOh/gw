<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
   	$(document).ready(function() {
		
   		$("#menuHistory").append("<li></li>");
   		
   		//버튼 이벤트 설정
   		$(function () {
        	$("#btnSearch").click(function () { fnSearch(); });		//조회버튼
            $("#btnSave").click(function () { fnSave(0); });		//등록버튼
            $("#btnNew").click(function () { fnRequest(); });		//신규버튼
            $("#btnOpt").click(function () { fnOption(); });		//옵션설정버튼
        });
   		
   		//컨트롤 초기화
   		fnControlInit();
   		
		//기본버튼
	    $(".controll_btn button").kendoButton();
	    
		//처리상태
	    $("#t_certStatus").kendoComboBox({            
            dataSource: [
            	{ text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value: "0" },
             	{ text: "<%=BizboxAMessage.getMessage("TX000003418","요청")%>", value: "10" },
             	{ text: "<%=BizboxAMessage.getMessage("TX000000798","승인")%>", value: "20" },
             	{ text: "<%=BizboxAMessage.getMessage("TX000002954","반려")%>", value: "30" }
        	],
		    dataTextField: "text",
            dataValueField: "value",
		    index: 0
	    });
   		
		//증명서 구분
	    $("#t_certGubun").kendoComboBox({            
            dataSource: [
            	{ formSeq: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", formNm: "0" }
        	],
		    dataTextField: "formSeq",
            dataValueField: "formNm",
		    index: 0
	    });
		
	    $.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/getCertificateList.do"/>',
    		datatype:"text",
    		success: function (data) {
    			certData = data.certList;
    			
    			var dataSource = [
    			    { formNm: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", formSeq: "0" }
    			];
    			
    			if(certData){
    				dataSource = dataSource.concat(certData);	
    			}
   				
   				$("#t_certGubun").kendoComboBox({
   					dataSource : dataSource,
   					dataTextField: "formNm",
   			        dataValueField: "formSeq",
   				    index: 0
   				});	
   		    },
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000016125","증명서 구분 가져오기 실패")%>");
    		}
    	});
	    
	    
	    if (mType == "issue") {
	    	BindListGrid2();
		}
	    else {
	    	BindListGrid();
	    }

	});//document ready end
	
	
	var mType = '${param.mType}';
	
	
	//datasource
	var dataSource = new kendo.data.DataSource({
     	  serverPaging: true,
     	  pageSize: 10,
     	  transport: {
     	    read: {
     	      type: 'post',
     	      dataType: 'json',
     	      url: '<c:url value="/systemx/certRequestData.do"/>'
     	    },
     	    parameterMap: function(data, operation) {
     	    	data.mType = "U";
     	    	data.formSeq = $("#t_certGubun").val();
   	    		data.apprStat = $("#t_certStatus").val();	
   	    		
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
   
	
	//검색
	function fnSearch(){
		if (mType == "issue") {
	    	BindListGrid2();
		}
	    else {
	    	BindListGrid();
	    }
	}
	
	
	//신규 
	function fnRequest(){
		var url = "certRequestPop.do?rType=U&cerSeq=0";
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "certRequestPop", "width=690,height=364,left="+left+" top="+top);
	   	pop.focus(); 	
	}
	
	
	//옵션설정 
	function fnOption(){
		var url = "certRequestPop.do?cerSeq=0";
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "certRequestPop", "width=550,height=457,left="+left+" top="+top);
	   	pop.focus(); 	
	}

	
	//컨트롤 초기화
	function fnControlInit(){
		//alert(mType);
		if (mType == "issue") {
			$("#btnNew").hide();
		}
	}
    
	
    //상세팝업
    function btnDetail(selectedItem){
    	if (mType == "issue") {
	    	//alert(selectedItem.printCnt);
	    	if (selectedItem.apprStatNm != "<%=BizboxAMessage.getMessage("TX000000798","승인")%>") {
	    		alert("<%=BizboxAMessage.getMessage("TX000005815","승인되지 않은 증명서는 출력할수 없습니다.")%>");
	    	}
	    	else {
		    	var url = "certRequestPrint.do?rType=M&cerSeq="+selectedItem.cerSeq;
			   	var left = (screen.width-958)/2;
			   	var top = (screen.height-753)/2;
			   	 
			   	var pop = window.open(url, "certRequestPrint", "width=800,height=930,left="+left+" top="+top);
			   	pop.focus();
	    	}
		}
	    else {
	    	var url = "certRequestPop.do?rType=M&cerSeq="+selectedItem.cerSeq;
		   	var left = (screen.width-958)/2;
		   	var top = (screen.height-753)/2;
		   	 
		   	var pop = window.open(url, "certRequestPop", "width=690,height=365,left="+left+" top="+top);
		   	pop.focus();
	    }
    }
    
    
    //Bind
    function BindListGrid2(){
    	var grid = $("#grid").kendoGrid({
			columns: [
				{
					title:"<%=BizboxAMessage.getMessage("TX000000953","발급번호")%>",
					field:"cerSeq",
					width:80,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"},
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000989","요청일")%>",
					field:"reqDt",
					width:110, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001014","증명서구분")%>",
					field:"formNm",
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000076","사원명")%>",
					field:"empName",
					width:120, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001004","제출예정일")%>",
					field:"reportDt",
					width:110, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000760","처리상태")%>",
					field:"apprStatNm",
					width:80,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001026","처리일")%>",
					field:"appDt",
					width:110,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001027","처리자")%>",
					field:"appUserName",
					width:120,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001030","출력일")%>",
					field:"printDt",
					width:110,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				}
			],
			dataSource: dataSource,
	        sortable: true,
	        selectable: "single",
	        navigatable: true,
	        pageable: {
		          refresh: false,
		          pageSizes: true
		        },
	        scrollable: true,
	        columnMenu: false,
	        autoBind: true,
	        dataBound: function(e){ 
				$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
					$("#grid tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					var selectedItem = e.sender.dataItem(e.sender.select());
					btnDetail(selectedItem);
				});							
			}
		}).data("kendoGrid");
	  	
	  	$("#grid").data("kendoGrid").table.on("click", ".k-checkbox" , selectRow);
    }
    
    function BindListGrid(){
    	var grid = $("#grid").kendoGrid({
			columns: [
				{
					title:"<%=BizboxAMessage.getMessage("TX000000953","발급번호")%>",
					field:"cerSeq",
					width:80,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"},
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000989","요청일")%>",
					field:"reqDt",
					width:110, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001014","증명서구분")%>",
					field:"formNm",
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000076","사원명")%>",
					field:"empName",
					width:120, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001004","제출예정일")%>",
					field:"reportDt",
					width:110, 
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"},
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000000760","처리상태")%>",
					field:"apprStatNm",
					width:80,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001026","처리일")%>",
					field:"appDt",
					width:110,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				},
				{
					title:"<%=BizboxAMessage.getMessage("TX000001027","처리자")%>",
					field:"appUserName",
					width:120,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"}
				}
			],
			dataSource: dataSource,
	        sortable: true,
	        selectable: "single",
	        navigatable: true,
	        pageable: {
	          refresh: false,
	          pageSizes: true
	        },
	        scrollable: true,
	        columnMenu: false,
	        autoBind: true,
	        dataBound: function(e){ 
				$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
					$("#grid tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					var selectedItem = e.sender.dataItem(e.sender.select());
					btnDetail(selectedItem);
				});							
			}
		}).data("kendoGrid");
	  	
	  	$("#grid").data("kendoGrid").table.on("click", ".k-checkbox" , selectRow);
    }
    
    
    function selectRow(grid) {
		CommonKendo.setChecked($("#grid").data("kendoGrid"), this);
	}
    
</script>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
   
	<!-- 검색박스 -->
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000001014","증명서구분")%></dt>
			<dd><input id="t_certGubun" style="width:120px;" /></dd>
			<dt><%=BizboxAMessage.getMessage("TX000000760","처리상태")%></dt>
			<dd><input id="t_certStatus" style="width:100px;" /></dd>
			<dd><input type="button" id="btnSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
		</dl>
	</div>
	
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="btnArea" class="controll_btn">
				<button id="btnNew"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
			</div>
		</div>
	</div>
	
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
						
</div><!-- //sub_contents_wrap -->