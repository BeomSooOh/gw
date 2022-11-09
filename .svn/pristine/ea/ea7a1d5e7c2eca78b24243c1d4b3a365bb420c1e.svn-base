<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>

<script type="text/javascript">

var today = "";

    	$(document).ready(function() {
			
    		//버튼 이벤트 설정
    		$(function () {
                $("#btnSearch").click(function () { fnSearch(); });   //조회버튼
                $("#btnSave").click(function () { fnSave(0); });      //등록버튼
                $("#btnDel").click(function () { fnDelete(); });      //삭제버튼
            });
    		
    		/* 방문일시 초기화 */
    		fnControlInit();
    		
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
			 //시작날짜
		    $("#txtFrDt").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
		    
		    //종료날짜
		    $("#txtToDt").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
		    
		 // 관리자/마스터의 경우 회사선택 comboBox 추가
			if("${userSe}" != 'USER') {
				$("#com_sel").kendoComboBox({
					dataTextField: "compName",
					dataValueField: "compSeq",
					dataSource :${compListJson},
					index : 0,
					change: BindListGrid,
					filter: "contains",
					suggest: true
				}); 
			   
				var coCombobox = $("#com_sel").data("kendoComboBox");
					
				coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
				coCombobox.refresh();
				coCombobox.select(0);
			}
		 
		    BindListGrid();	
			
		 
		    
		});//document ready end
		
		//일반방문객 조회 datasource
		var dataSource = new kendo.data.DataSource({
	     	  serverPaging: true,
	     	  pageSize: 10,
	     	  transport: {
	     	    read: {
	     	      type: 'post',
	     	      dataType: 'json',
	     	      url: '<c:url value="/cmm/ex/visitor/getNormalVisitorList.do"/>'
	     	    },
	     	    parameterMap: function(data, operation) {
	     	    	data.nRNo = 0;
	     	    	data.pDist = 1;		//1:일반,  2:외주
	     	    	
	     	    	data.pFrDT = $("#txtFrDt").val().replace(/-/gi, ''); 
	     	    	data.pToDT = $("#txtToDt").val().replace(/-/gi, '');
	     	    	
	     	    	data.pVisitPlace = $("#txtVisitPlace").val(); //상세검색(방문장소)
	     	    	data.pVisitNm = $("#txtVisitNM_S").val();	//상세검색(방문자이름)
	     	    	data.pVisitCo = $("#txtVisitCO_S").val();	//상세검색(방문자회사)
	     	    	data.pManName = $("#txtManNM_S").val();		//상세검색(담당자명)
	     	    	data.pReqName = $("#txtReqNM_S").val();	//상세검색(등록자명)
	     	    	
     	    		if($("#com_sel").val() != ""){
	     	    		data.selectedCompSeq = $("#com_sel").val(); 	//회사 선택
	     	    	}	
	     	    	
	     	    	/* data.pDept = $("#txtManDept_S").val();		//상세검색(담당자부서) */
	   	    		
	   	    		data.searchListType = "pTicket"; // 검색리스트 종류
	   	    		data.pType = "search";	   	    
	   	    		
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
		
		
		//컨트롤 초기화
		function fnControlInit(){
			//현재 날짜 셋팅(yyyy-mm-dd)
			var date = new Date();
			var yyyy = date.getFullYear().toString();
			var mm = date.getMonth() + 1;
			var dd = date.getDate();
			
			if (mm < 10)
			    mm = "0" + mm;
			if (dd < 10)
			    dd = "0" + dd;
			
			today = yyyy + "-" + mm + "-" + dd;
			
			
			date.setMonth(date.getMonth()+2);
			
			yyyy = date.getFullYear().toString();
			mm = date.getMonth() + 1;
			dd = date.getDate() + 1;

			if (mm < 10)
			    mm = "0" + mm;
			if (dd < 10)
			    dd = "0" + dd;
			
			var today2 = yyyy + "-" + mm + "-" + dd;
			
			$("#txtFrDt").val(today);
			$("#txtToDt").val(today2);
		}
		
		
	    //grid셋팅
	    function BindListGrid(){
	    	var grid = $("#grid").kendoGrid({
					columns: [
						{
							title:"<%=BizboxAMessage.getMessage("","등록일시")%>",
							field:"created_dt",
							width:140,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {style: "text-align: center;"},
							template: function(rowData) {
								var html = "";
								var created_dt = rowData.created_dt;
								
								var year = "20" + created_dt.year.toString().substr(1,2)
								var month = created_dt.month+1;
								if(month < 10){
									month = "0" + month
								}
								var date = created_dt.date;
								if(date < 10) {
									date = "0" + date;
								}
								var hour = created_dt.hours;
								if(hour < 10) {
									hour = "0" + hour;
								}
								var min = created_dt.minutes;
								if(min < 10) {
									min = "0" + min;
								}
								var html = '<p>' + year + "-" + month + "-" + date + " " + hour + ":" + min + '</p>';
								return html;
							}
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010887","방문일시")%>",
							field:"visit_dt",
							width:140,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {style: "text-align: center;"},
							template : function (rowData) {
		 						var visit_day = rowData.visit_dt_fr;
		 						var visit_time = rowData.visit_tm_fr.substr(0, 2)+":"+rowData.visit_tm_fr.substr(2,2);
		 						var html = '<p>'+visit_day+' '+visit_time+'</p>';
		 						return html;
		 					}
						},
						{
							title:"<%=BizboxAMessage.getMessage("","방문 장소")%>",
							field:"visit_place_name",
							width:140,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {style: "text-align: center;"},
						},
						{	
							title:"<%=BizboxAMessage.getMessage("TX000010895","방문자")%>",	
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},					
							columns: [
								{
									title:"<%=BizboxAMessage.getMessage("","회사")%>",
									field:"visitor_co",
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"}
								},{
									title:"<%=BizboxAMessage.getMessage("","이름")%>",
									field:"visitor_nm",
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"}
								},{
									title:"<%=BizboxAMessage.getMessage("TX000001495","연락처")%>",
									field:"visit_hp",
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"}
								},{
									title:"<%=BizboxAMessage.getMessage("TX000004850","차량번호")%>",
									field:"visit_car_no",
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"},
									template : function (rowData) {
				 						var data = rowData.visit_car_no == "" ? "-" : rowData.visit_car_no;
				 						if( (rowData.visit_pticket_yn == "Issue" || rowData.visit_pticket_yn == "Y") ){
				 							if( rowData.elet_appv_link_yn == "Y" ){
				 								if( rowData.elct_appv_doc_status == "종결" ) {
				 									if( rowData.t_map_seq == null ){
				 										data += "(실패)";
				 									}
				 									else {
				 										data += "(성공)";
				 									}
				 								}
				 								else {
				 									data += "";	
				 								}
				 								
				 							}
				 							else {
				 								if( rowData.t_map_seq == null ) {
					 								data += "(실패)";
					 							}
					 							else {
													data += "(성공)"				 								
					 							}
				 							}
				 						}
				 						var html = '<p>'+data+'</p>';
				 						return html;
				 					}
								}
							]
						},
						{
							title:"<%=BizboxAMessage.getMessage("","담당자")%>",
							field:"man_emp_name",
							width:140,
							columnMenu:true,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {style: "text-align: center; cursor: pointer; "}
						},
						{
							title:"<%=BizboxAMessage.getMessage("","결재<br/>상태")%>",
							field:"elct_appv_doc_status",
							width:100, 
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},
							template: function(rowData){
								var html = "";
								if(rowData.elet_appv_link_yn == "Y"){
									if(rowData.req_emp_seq == '${loginVO.uniqId}'){
										html = '<div id="eap_status" onclick=openEapDoc(' + rowData.elct_appv_doc_id + ',"'+ rowData.elct_appv_doc_status + '") style= "cursor: pointer;"><p style="color:#01A9DB; text-decoration:underline;">' + rowData.elct_appv_doc_status + '</p></div>';	
									}
									else {
										html = '<div id="eap_status"><p>' + rowData.elct_appv_doc_status + '</p></div>';
									}
									 
								}
								else {
									html = "-"
								}
								return html;
							}
						},
						{
					  		field: "man_dept_seq",
							hidden: true
						},
						{
							field: "req_dept_seq",
							hidden: true
						},
						{
					  		field: "man_comp_seq",
							hidden: true
						},
						{
							field: "man_emp_seq",
							hidden: true
						}
					],
					dataSource: dataSource,
			        sortable: true ,
			        selectable: "single",
			        navigatable: true,
			        pageable: {
				          refresh: false,
				          pageSizes: true
				        },
			        scrollable: false,
			        columnMenu: false,
			        autoBind: true,
			       	dataBound: onDataBound
				}).data("kendoGrid");
	    		$("#grid").data("kendoGrid").table.on("click", ".k-checkbox" , selectRow);
	    		
	    		$("#grid").kendoTooltip({
	    	          filter: "td:nth-child(8)",
	    	          position: "bottom",
	    	          content: function(e){
	    	          	  var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
	    	              var width = getTextWidth(dataItem.ManPathName);
	    	            
	    	              var content = '<div style="width:' +  width +'px;"><span>' + dataItem.ManPathName +'</span></div>';
	    	              return content;
	    	          }
	    	        }).data("kendoTooltip");
	    		
	    		$("#grid").kendoTooltip({
	    	          filter: "#eap_status",
	    	          position: "bottom",
	    	          content: function(e){
	    	            var dataItem = $("#grid").data("kendoGrid").dataItem(e.target.closest("tr"));
	    	            var width = getTextWidth(dataItem.docName);
	    	            
  	            	var content = '<div style="width:' +  width +'px;"><span>' + dataItem.docName +'</span></div>';	
  	            	return content;
	    	          }
	    	        }).data("kendoTooltip");
	    }
	    
	    function selectRow(grid) {
 	   		CommonKendo.setChecked($("#grid").data("kendoGrid"), this);
 	   	}
	    
	    function onDataBound(e) {
	    	var grid = $("#grid").data("kendoGrid");
	    	
	        $(grid.tbody).on("click", "td", function (e) {

	        	var row = $(this).closest("tr");
	            var rowIdx = $("tr", grid.tbody).index(row);
	            var colIdx = $("td", row).index(this);
	            
	            var selectedRows = grid.dataItems(grid.select());
	            var data = selectedRows[rowIdx];
				
	            console.log(colIdx);
	            
	            if(colIdx == 7 && data.man_emp_seq != ""){
	            	openEmpProfileInfo(data.man_comp_seq, data.man_dept_seq, data.man_emp_seq);
	            }
	            else if(colIdx == 8 && data.man_emp_seq != ""){
	            	openEmpProfileInfo(data.req_comp_seq, data.req_dept_seq, data.req_emp_seq);
	            }
	            
	        });
	        
	        $(grid.tbody).on("dblclick", "td", function (e) {

	        	var row = $(this).closest("tr");
	            var rowIdx = $("tr", grid.tbody).index(row);
	            var colIdx = $("td", row).index(this);
	            
	            var selectedRows = grid.dataItems(grid.select());
	            var data = selectedRows[rowIdx];
				
	            console.log(data);
	            
	            openVisitorPop(data)
	        });
	    }
	    
	    function openVisitorPop(e){
		  	var curDate = today.replace(/\-/g,'');  
			var gridDate = e.visit_dt_fr.replace(/\-/g,'');
			var url="";
			
			console.log(opener);
			
			url = "visitorPopViewNew.do?r_no="+e.r_no+"&type=view";			
	    	
		   	var left = (screen.width-958)/2;
		   	var top = (screen.height-753)/2;
		   	 
		   	var pop = window.open(url, "visitorPopViewNew", "width=550,height=457, scrollbars=yes,left="+left+" top="+top);
		   	pop.focus();
		   	
	    }
	    
		function openEapDoc (docId, status) {
	    	
	    	var intWidth = 900;
	        var intHeight = screen.height - 100;
	        var agt = navigator.userAgent.toLowerCase();
	        if (agt.indexOf("safari") != -1) {
	            intHeight = intHeight - 70;
	        }
	        var intLeft = screen.width / 2 - intWidth / 2;
	        var intTop = screen.height / 2 - intHeight / 2 - 40;
	        if (agt.indexOf("safari") != -1) {
	            intTop = intTop - 30;
	        }
			
	        var paramUrl = "?doc_id=" + docId + "&form_id=" + '${formId}';
	        var url = "";
		    
	        if(status != "보관"){
				url = '/eap/ea/docpop/EAAppDocViewPop.do' + paramUrl;
	        }
	        else {
	        	url = '/eap/ea/eadocpop/EAAppDocPop.do' + paramUrl;        		
	        }
	    				
			window.open(url, '방문객등록 전자결재 팝업', 'menubar=0,resizable=0,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
	    }
	    
	    function fnSetSnackbar(msg, type, duration){
			var puddActionBar = Pudd.puddSnackBar({
				type	: type
			,	message : msg
			,	duration : 1500
			});
		}
	    
	    function getTextWidth(data) { 
			  
            var text = document.createElement("span"); 
            document.body.appendChild(text); 
  
            text.style.font = "times new roman"; 
            text.style.fontSize = "12px"; 
            text.style.height = 'auto'; 
            text.style.width = 'auto'; 
            text.style.position = 'absolute'; 
            text.style.whiteSpace = 'no-wrap'; 
            text.innerHTML = data; 
  
            var width = Math.ceil(text.clientWidth + 10); 
            document.body.removeChild(text);
            
            return width;
        } 
	    
		</script>
    
     
    
  <!-- 검색박스 -->
<div class="top_box">
	<dl class="dl1">
		<c:if test="${userSe != 'USER' }">
		<dt><%=BizboxAMessage.getMessage("","회사")%></dt>
		<dd class="mr25">
			 <input id="com_sel" name="com_sel" style="width:150px">
		</dd>
		</c:if>
		<dt><%=BizboxAMessage.getMessage("TX000010887","방문일시")%></dt>
		<dd>
			<input id="txtFrDt" class="dpWid"/>
			~
			<input id="txtToDt" class="dpWid"/>
		</dd>
		
		<dt><%=BizboxAMessage.getMessage("","방문장소")%></dt>
		<dd class="">
			<input id="txtVisitPlace" type="text" value="" style="width:150px">
		</dd>
		
		<c:if test="${userSe == 'USER' }">
		<dt><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="">
			<input id="txtVisitNM_S" type="text" value="" style="width:150px">
		</dd>
		</c:if>
		
		<dd>
			<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
		</dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>
		<c:if test="${userSe != 'USER' }">
		<dt><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="mr35"><input id="txtVisitNM_S" type="text" value="" style="width:150px"></dd>
		</c:if>
		
		<dt><%=BizboxAMessage.getMessage("","방문자회사")%></dt>
		<dd class="mr35"><input id="txtVisitCO_S" type="text" value="" style="width:150px"></dd>
		<dt><%=BizboxAMessage.getMessage("","담당자")%></dt>
		<dd class="mr35"><input id="txtManNM_S" type="text" value="" style="width:150px"></dd>
		
		<c:if test="${userSe == 'USER' }">
		<dt><%=BizboxAMessage.getMessage("","등록자")%></dt>
		<dd class="mr25">
			<input id="txtReqNM_S" type="text" value="" style="width:150px">
		</dd>
		</c:if>
		
	</dl>
	<dl>
		<c:if test="${userSe != 'USER' }">
		<dt class="ml20"><%=BizboxAMessage.getMessage("","등록자")%></dt>
		<dd class="">
			<input id="txtReqNM_S" type="text" value="" style="width:150px">
		</dd>
		</c:if>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
			</div>
		</div>
	</div>
	
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
						
</div><!-- //sub_contents_wrap -->