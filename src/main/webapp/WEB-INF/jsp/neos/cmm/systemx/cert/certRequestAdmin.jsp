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
            	{ detailName : "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", detailCode: "0" }
        	],
		    dataTextField: "detailName",
            dataValueField: "detailCode",
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
		
		//재직여부 구분
	    $("#t_workStatus").kendoComboBox({            
            dataSource: [
            	  { workStatusNm: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", workStatus: "" }
            	, { workStatusNm: "<%=BizboxAMessage.getMessage("TX000021242","재직")%>", workStatus: "999" }
            	, { workStatusNm: "<%=BizboxAMessage.getMessage("TX000021244","휴직")%>", workStatus: "004" }
            	, { workStatusNm: "<%=BizboxAMessage.getMessage("TX000021243","퇴직")%>", workStatus: "001" }
        	],
		    dataTextField: "workStatusNm",
            dataValueField: "workStatus",
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
	    
	    $.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/getCertificateStatusList.do"/>',
    		datatype:"text",
    		success: function (data) {
    			certStatusList = data.certStatusList;
    			
    			var dataSource = [
    			    { detailName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", detailCode: "0" }
    			];
    			
    			if(certStatusList){
    				dataSource = dataSource.concat(certStatusList);	
    			}
   				
   				$("#t_certStatus").kendoComboBox({
   					dataSource : dataSource,
   					dataTextField: "detailName",
   			        dataValueField: "detailCode",
   				    index: 0
   				});	
   		    },
		    error: function (result) { 
    			alert("<%=BizboxAMessage.getMessage("TX000017936","처리상태 가져오기 실패")%>");
    		}
    	});
	    
	    BindListGrid();

	});//document ready end
	
	
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
     	    	data.mType = "A";
     	    	data.formSeq = $("#t_certGubun").val();
   	    		data.apprStat = $("#t_certStatus").val();
   	    		
   	    		if($("#t_workStatus").val() != '') {
   	    			data.workStatus = $("#t_workStatus").val(); 	
   	    		}
   	    		
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
		BindListGrid();
	}
	
	
	//신규 
	function fnRequest(){
		var url = "/attend/certificate/views/certRequestCreatePop";
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "certRequestCreatePop", "width=690,height=472,left="+left+" top="+top);
	   	pop.focus();	
	}
	
	
	//옵션설정 
	function fnOption(){
		var url = "certRequestOpt.do?cerSeq=0";
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "certRequestOpt", "width=550,height=457,left="+left+" top="+top);
	   	pop.focus(); 	
	}

	
	//컨트롤 초기화
	function fnControlInit(){
		
	}
    
	
    //상세팝업
    function btnDetail(selectedItem){
    	var url = "certRequestPop.do?rType=A&cerSeq="+selectedItem.cerSeq;
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "certRequestPop", "width=690,height=370,left="+left+" top="+top);
	   	pop.focus();
    }
    
    
    //Bind
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
					title:"<%=BizboxAMessage.getMessage("TX000003305","재직 여부")%>",
					field:"workStatus",
					width:80,
					headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					attributes: {style: "text-align: center;"} , 
					template: function(data) {
						var workStatusNm = '비정상';
						
						switch (data.workStatus) {
							case '999':
								workStatusNm = "재직";
								break;
							case '001':
								workStatusNm = "퇴직";
								break;
							case '004':
								workStatusNm = "휴직";
								break;
						}
						
						return workStatusNm;
					}
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
			<dt><%=BizboxAMessage.getMessage("TX000003305","재직여부")%></dt>
			<dd><input id="t_workStatus" style="width:100px;" /></dd>
			<dd><input type="button" id="btnSearch" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
		</dl>
	</div>
	
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="btnNew"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
				<!--<button id="btnOpt">옵션설정</button>-->
			</div>
		</div>
	</div>
	
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
						
</div><!-- //sub_contents_wrap -->