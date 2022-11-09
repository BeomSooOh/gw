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
    		
    		$("#eapLinkYn").kendoComboBox({
	        	dataTextField: "text",
	            dataValueField: "value",
	            dataSource: [
	            	{text:"<%=BizboxAMessage.getMessage("","전체")%>", value:"all"},
	            	{text:"<%=BizboxAMessage.getMessage("","사용")%>", value:"Y"},
	            	{text:"<%=BizboxAMessage.getMessage("","미사용")%>", value:"N"}
	            ]
	     	});
    		
    		$("#eapLinkYn").data("kendoComboBox").value("all");
    		
    		// 관리자/마스터의 경우 회사선택 comboBox 추가
			if("${userSe}" != 'USER') {
				$("#com_sel").kendoComboBox({
					dataTextField: "compName",
					dataValueField: "compSeq",
					dataSource :${compListJson},
					index : 0,
					change: BindGrid,
					filter: "contains",
					suggest: true
				}); 
			   
				var coCombobox = $("#com_sel").data("kendoComboBox");
				
				coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
				coCombobox.refresh();
				coCombobox.select(0);
				
			}
    		
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
		    
		    BindGrid();
		    
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
	     	    	
	     	    	if($("#eapLinkYn").val() != "all"){
	     	    		data.pEapLinkYn = $("#eapLinkYn").val(); 	//상세검색(결재연동여부)		
	     	    	}

	     	    	if($("#com_sel").val() != ""){
		     	    	data.selectedCompSeq = $("#com_sel").val(); 	//회사 선택
		     	    }	
	     	    	
	   	    		data.searchListType = "visitor"; // 검색리스트 종류(visitor: 일반방문객, qr: qr코드/주차권 조회)
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
   	    
		function BindGrid(){
	    	var grid = $("#grid").kendoGrid({
					columns: [
						{
							title:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
							width:40, 
							headerTemplate: '<input type="checkbox" name="chkNonSels" id="chkNonSels" class="k-checkbox" onclick="onCheckNonAll(this)"><label class="k-checkbox-label chkSel2" for="chkNonSels"></label>', 
							headerAttributes: {style: "text-align:center;vertical-align:middle;"},
							template: function(rowData){
								var html = "";
								if( rowData.elet_appv_link_yn == 'Y' || ( (rowData.in_time != null && rowData.in_time != "") && (rowData.out_time == null || rowData.out_time == "")) ){
									html = '<input type="checkbox" name="chkNonSel" id="' + rowData.r_no + '" class="k-checkbox" disabled=true><label class="k-checkbox-label chkSel2" for="'+rowData.r_no+'"></label>'	
								} 
								else {
									html = '<input type="checkbox" name="chkNonSel" id="' + rowData.r_no + '" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="'+rowData.r_no+'"></label>'
								}
								return html;
							},
							attributes: {style: "text-align:center;vertical-align:middle;"},
					  		sortable: false
						},
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
							width:120,
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
				 						if( (rowData.visit_pticket_yn == "Issue" || rowData.visit_pticket_yn == "Y") && rowData.visit_car_no != ""){
				 							data += "<br />(무료)" 
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
							columnMenu:true,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {class:"man", style: "text-align: center; cursor: pointer;"}	
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010894","입실")%>",
							field:"in_time",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},
							template: function (rowData) {
								var html = "-";
								var time = rowData.f_in_time;
								
								if(time != '' && time != null) {
									if(time.length > 4){
										html = '<p>'+ time.substr(0,4) + "-" + time.substr(4,2) + "-" + time.substr(6,2) + '<br />' + time.substr(8,2) + ":" + time.substr(10,2) + '</p>';
									}
									else {
										html = '<p>' + rowData.visit_dt_fr + '<br />' + time.substr(0,2) + ":" + time.substr(2,2) + '</p>';
									}	
								}
								return html;
							}
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010893","퇴실")%>",
							field:"out_time",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},
							template: function (rowData) {
								var html = "-";
								var time = rowData.f_out_time;
								
								if(time != '' && time != null) {
									if(time.length > 4){
										html = '<p>'+ time.substr(0,4) + "-" + time.substr(4,2) + "-" + time.substr(6,2) + '<br />' + time.substr(8,2) + ":" + time.substr(10,2) + '</p>';
									}
									else {
										html = '<p>' + rowData.visit_dt_fr + '<br />' + time.substr(0,2) + ":" + time.substr(2,2) + '</p>';
									}	
								}
								return html;
							}
						},
						{
							title:"<%=BizboxAMessage.getMessage("","결재<br/>상태")%>",
							field:"elct_appv_doc_status",
							width:80, 
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
							title:"<%=BizboxAMessage.getMessage("","QR코드")%>",
							width:70,
					  		headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					  		attributes: {style: "text-align: center;"},
							template: function(rowData){
								var html = "";
								if(rowData.qr_data != ""){
									/*
									 * QR재발송 가능
									 * 1. 방문일시가 지나지 않고 입실체크가 되어있지 않은 경우
									 * 2. 결재 연동인 경우 종결되었을 경우에만 제공
									*/
									if(rowData.visit_dt_fr.replace(/\-/g,'') >= today.replace(/\-/g,'') && (rowData.in_time == "" || rowData.in_time == null) ){
										if(rowData.elet_appv_link_yn == "Y"){
											if(rowData.elct_appv_doc_status == "종결"){
												html = '<div class="controll_btn p0" style="text-align:center;"><button class="k-button" style="width:50px; min-width:max-content;" id="' + rowData.r_no + '" visit_dt_fr="'+ rowData.visit_dt_fr.replace(/-/gi, "") + '" onclick="fnQRsendConfirm(this);"><%=BizboxAMessage.getMessage("","재발송")%></button></div>';	
											}
											else {
												html = "-"
											}
										}
										else {
											html = '<div class="controll_btn p0" style="text-align:center;"><button class="k-button" style="width:50px; min-width:max-content;" id="' + rowData.r_no + '" visit_dt_fr="'+ rowData.visit_dt_fr.replace(/-/gi, "") + '" onclick="fnQRsendConfirm(this);"><%=BizboxAMessage.getMessage("","재발송")%></button></div>';
										}
									}
									else {
										html = "-";
									}
								}
								else {
									html = "-";									
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
	    	          filter: "td:nth-child(9)",
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
				
	            if(colIdx == 8 && data.man_emp_seq != ""){
	            	openEmpProfileInfo(data.man_comp_seq, data.man_dept_seq, data.man_emp_seq);
	            }
	        });
	        
	        $(grid.tbody).on("dblclick", "td", function (e) {

	        	var row = $(this).closest("tr");
	            var rowIdx = $("tr", grid.tbody).index(row);
	            var colIdx = $("td", row).index(this);
	            
	            var selectedRows = grid.dataItems(grid.select());
	            var data = selectedRows[rowIdx];
				
	            console.log(data);
	            
	            openVisitorPop(data);
	        });
	    }
	    
		//검색
		function fnSearch(){
			BindGrid();
		}
		
		//등록 
		function fnSave(r_no){
			var url = "visitorPopViewNew.do?type=new&r_no="+r_no;
		   	var left = (screen.width-958)/2;
		   	var top = (screen.height-753)/2;
		   	 
		   	var pop = window.open(url, "visitorPopViewNew", "width=550,height=485,scrollbars=yes,left="+left+" top="+top);
		   	pop.focus(); 	
		}
		
		//삭제
		function fnDelete(){
			
			var grid = $("#grid").data("kendoGrid");
			
			var checkList = CommonKendo.getChecked(grid);
			
		    if(checkList && checkList.length == 0) {
		    	puddAlert("warning", "삭제할 항목을 선택해 주세요", "");
				return;
			}
		    
			var sR_NO = "";
	  		
  			for(var i=0; i<checkList.length; i++){
  				sR_NO += "," + checkList[i].r_no;
  			}
  			sR_NO = sR_NO.substring(1);
  		    var R_No_list = sR_NO;
  		    
  		  	puddDeleteConfirm(R_No_list);
  		  	
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
		
		//체크박스 전체선택
		function onCheckNonAll(chkbox) {
			
	  		var grid = $("#grid").data("kendoGrid");
	  		
		    if (chkbox.checked == true) {
		    	checkAll(grid, 'chkNonSel', true);
		    	
		    } else {
		    	checkAll(grid, 'chkNonSel', false);
		    }
		}
	    
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
	    
	    
	  // 방문객 상세 팝업 호출
	    function openVisitorPop(e){

		var url = "";
		  	
	  	if(e.visit_place_code != null) {
	  		url = "visitorPopViewNew.do?r_no="+e.r_no+"&type=view";			
	  	}
	  	else {
	  		url = "visitorPopView.do?r_no="+e.r_no;
	  	}
    	
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "visitorPopViewNew", "width=550,height=457,scrollbars=yes, left="+left+" top="+top);
	   	pop.focus();
		   	
	    }
	    
	    //사용자 정보 팝업
		function openEmpProfileInfo (comp_seq, dept_seq, emp_seq) {
								
			var paramUrl = "?compSeq=" + comp_seq + "&deptSeq=" + dept_seq + "&empSeq=" + emp_seq ;

			var url = '/gw/empProfileInfo.do' + paramUrl;
			
			var winHeight = document.body.clientHeight;	// 현재창의 높이
			var winWidth = document.body.clientWidth;	// 현재창의 너비
			var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0;	// 현재창의 y좌표
			
			var popWidth = 520;
			var popHeight = 241;
			
			var popX = winX + (winWidth - popWidth)/2;
			var popY = winY + (winHeight - popHeight)/2;
			
			window.open(url, "사용자프로필", "width="+popWidth+",height="+popHeight+",scrollbars=0,top="+popY+ ",left="+popX);
			
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
	    
	    /* 전자결재 결재창 팝업 호출 */
		function updateEaDoc(formId, processId, approKey, docId, reqNo) {
			$.ajax({
	            type:"post",
	            url:'${pageContext.request.contextPath}/cmm/ex/visitor/updateEaAttDocId.do',
	            data:JSON.stringify({approKey:approKey, processId:processId, docId:docId, reqNo:reqNo}),
	            
	            datatype:"json",
	            contentType:'application/json; charset=utf-8',
	            success:function(e){
	            	var result = e.result;
	            	if(result){
	            		
	            		var eadocPop = window.open('','_blank','scrollbars=yes, resizable=yes, width=900, height=900');
	            		
	            		eadocPop.location.href = '/eap/ea/interface/eadocpop.do?form_id='+formId+'&processId='+processId+'&approKey='+approKey+'&docId='+docId;
						
	            	}else {
						alert('<%=BizboxAMessage.getMessage("TX000012938","신청이 실패되었습니다")%>.');
						location.reload();
					}
	               
	            }, error:function(e){                          
	            	alert('<%=BizboxAMessage.getMessage("TX000012938","신청이 실패되었습니다")%>.');
					location.reload();
	              }
	         });
		}
	    
	    
	    function fnSetSnackbar(msg, type, duration){
			var puddActionBar = Pudd.puddSnackBar({
				type	: type
			,	message : msg
			,	duration : 1500
			});
		}
	    
	    /* QR재발송 confirm */
		function fnQRsendConfirm(e) {
			
			var puddDialog = Pudd.puddDialog({
				width : 350
				,	height : 100
			 
				,	message : {
						type : "question"
					,	content : "문자를 재발송하시겠습니까?"
						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
					//,	defaultFocus :  true// 기본값 true
					}
			
			,	footer : {
					// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
					buttons : [
						{
							attributes : {}// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
						,	value : "확인"
						,	clickCallback : function( puddDlg ) {
								/* QR전송 API */
								$.ajax({
							    	type:"post",
									url:'<c:url value="/cmm/ex/visitor/ReSendMMS.do" />',
									datatype:"text",
									data: { r_no : e.id } ,
									success:function(data){
										if(data.result.resultCode == "SUCCESS"){
											fnSetSnackbar("재발송되었습니다", "success", 1500);
											puddDlg.showDialog( false );
										}
										else {
											alert('QR코드 재발송 도중 에러가 발생하였습니다.');
										}
									},error : function(data){
										alert('QR코드 재발송 도중 에러가 발생하였습니다.');
									}
						    });
							}
							// dialog 생성시에 확인 버튼으로 기본 포커스 설정
						,	defaultFocus :  true// 기본값 true
						}
					,	{
							attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
						,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
						,	value : "취소"
						,	clickCallback : function( puddDlg ) {
								puddDlg.showDialog( false );
								self.close();
							}
						}
					]
				}
			})
		}
	    
		function puddAlert(type, alertMsg, callback){
	 		var puddDialog = Pudd.puddDialog({
	 			width : "400"
	 		,	height : "100"
	 		,	message : {
	 				type : type
	 			,	content : alertMsg.replace(/\n/g, "<br>")
	 			}
	 		,	footer : {
	 		
	 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
	 				buttons : [
	 					{
	 						attributes : {}// control 부모 객체 속성 설정
	 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
	 					,	value : "확인"
	 					,	clickCallback : function( puddDlg ) {
	 							puddDlg.showDialog( false );
	 							eval(callback);
	 						}
	 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
	 					,	defaultFocus :  true// 기본값 true
	 					}
	 				]
	 			}	
	 		
	 		});		
		}
		
		function puddDeleteConfirm(R_No_list){
	 		var puddDialog = Pudd.puddDialog({
	 			width : "400"
	 		,	height : "100"
	 		,	message : {
	 				type : "question"
	 			,	content : "삭제 하시겠습니까?"
	 			}
	 		,	footer : {
	 		
	 				// puddDialog message 에서 제공되는 버튼 사용하지 않고 별도로 진행할 경우
	 				buttons : [
	 					{
	 						attributes : {}// control 부모 객체 속성 설정
	 					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
	 					,	value : "확인"
	 					,	clickCallback : function( puddDlg ) {
	 							puddDlg.showDialog( false );
	 							
	 							$.ajax({
	 				  		    	type:"post",
	 				  				url:'<c:url value="/cmm/ex/visitor/DeleteVisitorNew.do" />',
	 				  				datatype:"text",
	 				  				data: {r_no_list : R_No_list } ,
	 				  				success:function(data){
	 				  					if(data.resultCode == "SUCCESS"){
	 				  						fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>","success",1500);
		 				  					BindGrid();	
	 				  					}
	 				  					else {
	 				  						alert(data.resultMessage);
	 				  					}
	 				  					
	 				  				},error : function(data){
	 				  					alert('error');
	 				  				}
	 				  		    	
	 				  		    });

	 						}
	 						// dialog 생성시에 확인 버튼으로 기본 포커스 설정
	 					,	defaultFocus :  true// 기본값 true
	 					}
 					,	{
						attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
					,	value : "취소"
					,	clickCallback : function( puddDlg ) {
							puddDlg.showDialog( false );
							returnVal = false;
							self.close();
						}
					}
	 				]
	 			}	
	 		
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


<div class="top_box">
	<dl class="dl1">
		<c:if test="${userSe != 'USER' }">
		<dt><%=BizboxAMessage.getMessage("","회사")%></dt>
		<dd><input id="com_sel" name="com_sel" style="width:150px"></dd>
		</c:if>
		
		<dt><%=BizboxAMessage.getMessage("TX000010887","방문일시")%></dt>
		<dd>
			<input id="txtFrDt" class="dpWid"/>
			~
			<input id="txtToDt" class="dpWid"/>
		</dd>
		
		<dt><%=BizboxAMessage.getMessage("","방문장소")%></dt>
		<dd><input id="txtVisitPlace" type="text" value="" style="width:150px"></dd>
		
		<c:if test="${userSe == 'USER' }">
		<dt><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd><input id="txtVisitNM_S" type="text" value="" style="width:150px"></dd>
		</c:if>
		
		<dd><input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>
		<c:if test="${userSe != 'USER' }">
		<dt><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="mr35">
			<input id="txtVisitNM_S" type="text" value="" style="width:150px">
		</dd>
		</c:if>
		
		<dt class="ml13"><%=BizboxAMessage.getMessage("","방문자회사")%></dt>
		<dd class="mr25">
			<input id="txtVisitCO_S" type="text" value="" style="width:150px">
		</dd>
		
		<dt><%=BizboxAMessage.getMessage("","담당자")%></dt>
		<dd class="mr25">
			<input id="txtManNM_S" type="text" value="" style="width:150px">
		</dd>
		
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
		<dd class="mr35">
			<input id="txtReqNM_S" type="text" value="" style="width:150px">
		</dd>
		</c:if>
		
		<dt><%=BizboxAMessage.getMessage("","결재 사용여부")%></dt>
		<dd class="mr25">
			 <input id="eapLinkYn" name="eapLinkYn" style="width:150px">
		</dd>
	</dl>
</div> 


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="btnSave"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
				<button id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div>
	
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
						
</div><!-- //sub_contents_wrap -->