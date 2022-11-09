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
    	$(document).ready(function() {
    		
			//버튼이벤트
   	        $(function () {
   	            $("#btnSearch").click(function () { fnSearch(); })		//조회버튼1
   	            $("#btnSearch2").click(function () { fnSearch(); });	//조회버튼2
   	            $("#btnSave").click(function () { fnSave(0); })			//등록버튼
   	            $("#btnDel").click(function () { fnDelete(); })			//삭제버튼
   	        });
			
			//컨트롤 초기화
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
		    fnGetListData();
		    
		});//document ready end
		
		
		//컨트롤 초기화
		function fnControlInit() {
			//현재 날짜 셋팅(yyyy-mm-dd)
			var date = new Date();
			var yyyy = date.getFullYear().toString();
			var mm = date.getMonth() + 1;
			var dd = date.getDate();
			
			if (mm < 10)
			    mm = "0" + mm;
			if (dd < 10)
			    dd = "0" + dd;
			
			var today = yyyy + "-" + mm + "-" + dd;
			
			
			date.setMonth(date.getMonth()+2);
			
			yyyy = date.getFullYear().toString();
			mm = date.getMonth() + 1;
			dd = date.getDate();

			if (mm < 10)
			    mm = "0" + mm;
			if (dd < 10)
			    dd = "0" + dd;
			
			var today2 = yyyy + "-" + mm + "-" + dd;
			
			
			$("#txtFrDt").val(today);
			$("#txtToDt").val(today2);
	    }
		
		//grid 셋팅
		function fnGetListData(){
			var grid = $("#grid").kendoGrid({
				columns: [
					{
						title:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						width:40, 
						headerTemplate: '<input type="checkbox" name="chkNonSels" id="chkNonSels" class="k-checkbox" onclick="onCheckNonAll(this)"><label class="k-checkbox-label chkSel2" for="chkNonSels"></label>', 
						headerAttributes: {style: "text-align:center;vertical-align:middle;"},
						template: '<input type="checkbox" name="chkNonSel" id="chk_#: r_no #" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="chk_#: r_no #"></label>', //그리드안의 체크박스는 로우별로 아이디가 달라야합니다. 개발 시 아이디를 다르게 넣어주세요.
						attributes: {style: "text-align:center;vertical-align:middle;"},
				  		sortable: false
					},
					{
						title:"<%=BizboxAMessage.getMessage("TX000000364","시작일")%>",
						field:"visit_dt_fr",
						width:80,
						headerAttributes: {style: "text-align: center; vertical-align:middle;"},
						attributes: {style: "text-align: center;"}
					},
					{
						title:"<%=BizboxAMessage.getMessage("TX000000606","종료일")%>",
						field:"visit_dt_to",
						width:80,
						headerAttributes: {style: "text-align: center; vertical-align:middle;"},
						attributes: {style: "text-align: center;"}
					},
					{	
						title:"<%=BizboxAMessage.getMessage("TX000010895","방문자")%>",	
						headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
						attributes: {style: "text-align: center;"},					
						columns: [
							{
								title:"<%=BizboxAMessage.getMessage("TX000000018","회사명")%>",
								field:"visitor_co",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000000978","성명")%>",
								field:"visitor_nm",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000004993","목적")%>",
								field:"visit_aim",
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
								attributes: {style: "text-align: center;"}
							}
						]
					},
					{	
						title:"<%=BizboxAMessage.getMessage("TX000000329","담당자")%>",					
						headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
						attributes: {style: "text-align: center;"},					
						columns: [
							{
								title:"<%=BizboxAMessage.getMessage("TX000000018","회사명")%>",
								field:"man_comp_name",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000000068","부서명")%>",
								field:"man_dept_name",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000001020","직위")%>",
								field:"man_grade_name",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000000978","성명")%>",
								field:"man_emp_name",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							}
						]
					},
					{	
						title:"<%=BizboxAMessage.getMessage("TX000005924","승인자")%>",					
						headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
						attributes: {style: "text-align: center;"},					
						columns: [
							{
								title:"<%=BizboxAMessage.getMessage("TX000001020","직위")%>",
								field:"approver_grade",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							},{
								title:"<%=BizboxAMessage.getMessage("TX000000978","성명")%>",
								field:"approver_emp_name",
								columnMenu:true,
								headerAttributes: {style: "text-align: center; vertical-align:middle;"},
								attributes: {style: "text-align: center;"}
							}
						]
					},
					{
						title:"<%=BizboxAMessage.getMessage("TX000000798","승인")%>",
						field:"approval_yn",
						headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
						attributes: {style: "text-align: center;"},
					},
					{
						title:"<%=BizboxAMessage.getMessage("TX000016270","방문<br/>인원")%>",
						field:"visit_cnt",
						width:50, 
						headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
						attributes: {style: "text-align: center;"}
					},
					{
						title:"<%=BizboxAMessage.getMessage("TX000000793","상세")%>",
						width:70,
				  		headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
				  		attributes: {style: "text-align: center;"},
						template: '<div class="controll_btn p0" style="text-align:center;"><button class="k-button" style="min-width:auto;" id="#: r_no #" onclick="btnDetail(this);"><%=BizboxAMessage.getMessage("TX000000899","조회")%></button></div>'
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
		        scrollable: true,
	  	  		//dataBound: gridDataBound,
		        columnMenu: false,
		        autoBind: true
//					dataSource: dataSource,
//					scrollable:true,
//					selectable: "single",
//					groupable: false,
//					columnMenu:false,
//					editable: false,
//					sortable: true,
//					navigatable: true,
//					pageable: {
//			          refresh: false,
//			          pageSizes: true
//			        },
			}).data("kendoGrid");
			$("#grid").data("kendoGrid").table.on("click", ".k-checkbox" , selectRow);
		}
		
		function selectRow(grid) {
 	   		CommonKendo.setChecked($("#grid").data("kendoGrid"), this);
 	   	}
		
		//조회항목 dataSource
		var dataSource = new kendo.data.DataSource({
	     	  serverPaging: true,
	     	  pageSize: 10,
	     	  transport: {
	     	    read: {
	     	      type: 'post',
	     	      dataType: 'json',
	     	      url: '<c:url value="/cmm/ex/visitor/getVisitorList.do"/>'
	     	    },
	     	    parameterMap: function(data, operation) {
	     	    	data.nRNo = 0;
	     	    	data.pDist = 2;
	     	    	data.pFrDT = $("#txtFrDt").val().replace(/-/gi, '');
	     	    	data.pToDT = $("#txtToDt").val().replace(/-/gi, '');
	     	    	data.pDept = $("#txtManDept_S").val();
	   	    		data.pGrade = $("#txtManGrade_S").val();
	   	    		data.pName = $("#txtManNM_S").val();
	   	    		data.pVisitCo = $("#txtVisitCO_S").val();
	   	    		data.pVisitNm = $("#txtVisitNM_S").val();
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
	    

	     //검색
         function fnSearch(){
        	 fnGetListData();
         }
	     
	     //등록
         function fnSave(r_no){
 			var url = "visitorPopSubView.do?type=new&r_no="+r_no;
 		   	var left = (screen.width-958)/2;
 		   	var top = (screen.height-753)/2;
 		   	 
 		   	var pop = window.open(url, "visitorPopView", "width=550,height=455,left="+left+" top="+top);
 		   	pop.focus(); 	
 		}
         
	     //삭제
         function fnDelete(){
 			var grid = $("#grid").data("kendoGrid");
 			
 			var checkList = CommonKendo.getChecked(grid);
 			var sR_NO = "";
 			
 			
 	  		if (checkList.length == 0) {
 	  			alert("<%=BizboxAMessage.getMessage("TX000010889","삭제할 항목을 선택해 주세요")%>");
 	  			return;
 	  		}
 	  		
 	  		else{
 	  			for(var i=0; i<checkList.length; i++){
 	  				sR_NO += "," + checkList[i].r_no;
 	  			}
 	  			sR_NO = sR_NO.substring(1);
 	  			
 	  			if (!confirm("<%=BizboxAMessage.getMessage("TX000001981","삭제 하시겠습니까?")%>")) {
 	  		        return;
 	  		    }
 	  		    
 	  		    var R_No_list = sR_NO;
 	  		    
 	  		    $.ajax({
 	  		    	type:"post",
 	  				url:'<c:url value="/cmm/ex/visitor/DeleteVisitor.do" />',
 	  				datatype:"text",
 	  				data: {r_no_list : R_No_list } ,
 	  				success:function(data){
 	  					fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>","success",1500);
 	  					fnGetListData();
 	  				},error : function(data){
 	  					alert('error');
 	  				}
 	  		    	
 	  		    });
 	  		}
 	  		
 		}
	    
	     
	     //상세 조회
         function btnDetail(e){
 	    	var url = "visitorPopSubView.do?r_no="+e.id;
 		   	var left = (screen.width-958)/2;
 		   	var top = (screen.height-753)/2;
 		   	 
 		   	var pop = window.open(url, "visitorPopSubView", "width=550,height=455,left="+left+" top="+top);
 		   	pop.focus();
 	    }
	     
         function fnSetSnackbar(msg, type, duration){
				var puddActionBar = Pudd.puddSnackBar({
					type	: type
				,	message : msg
				,	duration : 1500
				});
			}
    </script>


<!-- 검색박스 -->
<div class="top_box">
	<dl>
		<dt class="ar" style="width:68px;"><%=BizboxAMessage.getMessage("TX000010887","방문일시")%></dt>
		<dd>
			<input id="txtFrDt" class="dpWid"/>
			~
			<input id="txtToDt" class="dpWid"/>
		</dd>
		<dd>
			<input id="btnSearch2" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
		</dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>	
		<dt style="width:70px;"><%=BizboxAMessage.getMessage("TX000016333","담당자부서")%></dt>
		<dd class="mr5">
			<input type="text" id="txtManDept_S" name="txtManDept_S" style="width:150px">
		</dd>
		<dt style="width:80px;"><%=BizboxAMessage.getMessage("TX000016332","담당자직급")%></dt>
		<dd class="mr5">
			<input type="text" id="txtManGrade_S" name="txtManDept_S" style="width:150px">
		</dd>
		<dt style="width:80px;"><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></dt>
		<dd class="mr5">
			<input type="text" id="txtManNM_S" name="txtManDept_S" style="width:150px">
		</dd>
	</dl>
	<dl>	
		<dt style="width:70px;"><%=BizboxAMessage.getMessage("TX000016263","방문자회사")%></dt>
		<dd class="mr5">
			<input type="text" id="txtVisitCO_S" name="txtManDept_S" style="width:150px">
		</dd>
		<dt style="width:80px;"><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="mr5">
			<input type="text" id=txtVisitNM_S name="txtManDept_S" style="width:150px">
		</dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="btn_div m0">
		<div class="right_div">
			<!-- 컨트롤버튼영역 -->
			<div id="" class="controll_btn">
				<button id="btnSearch"><%=BizboxAMessage.getMessage("TX000000899","조회")%></button>
				<button id="btnSave"><%=BizboxAMessage.getMessage("TX000000602","등록")%></button>
				<button id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div>
	
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
						
</div><!-- //sub_contents_wrap -->