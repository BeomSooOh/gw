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

	//현재 날짜, 한달후 날짜 셋팅 (yyyy-mm-dd)
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
	
$(document).ready(function() {
	$(function () {
        $("#btnSearch").click(function () { fnSearch() });
    })
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
    
    //컨트롤 초기화
    fnControlInit();


});//document ready end
	//컨트롤 초기화
	function fnControlInit(){
		$("#txtFrDt").val(today);
        $("#txtToDt").val(today2);
        
        fnGetDataList();
	}
	
	
	//grid셋팅
	function fnGetDataList(){
		//grid table
		var grid = $("#grid").kendoGrid({
			columns: [
						{
							title:"<%=BizboxAMessage.getMessage("TX000010896","방문일")%>",
							field:"visit_dt_fr",
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
							title:"<%=BizboxAMessage.getMessage("TX000010894","입실")%>",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},
							columns: [
								{
									title:"<%=BizboxAMessage.getMessage("TX000010894","입실")%>",
									field:"in_time",
									width:50,
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"},
									//template: '<input type="button" value="확인" class="small_btn"/>'
								},{
									title:"<%=BizboxAMessage.getMessage("TX000005887","체크")%>",
									width:50,
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"},
									template: '<input type="button" value="확인" id="btn_in_#: r_no #_#: seq #" onclick="fnTimeCheck(#: r_no #, #: seq #, 1);" class="small_btn" style="display: none;"/>'
								}
							]
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010893","퇴실")%>",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"},
							columns: [
								{
									title:"<%=BizboxAMessage.getMessage("TX000010893","퇴실")%>",
									field:"out_time",
									width:50,
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"},
									//template: '<input type="button" value="확인" class="small_btn"/>'
								},{
									title:"<%=BizboxAMessage.getMessage("TX000005887","체크")%>",
									width:50,
									columnMenu:true,
									headerAttributes: {style: "text-align: center; vertical-align:middle;"},
									attributes: {style: "text-align: center;"},
									template: '<input type="button" value="확인" id="btn_out_#: r_no #_#: seq #" class="small_btn" onclick="fnTimeCheck(#: r_no #, #: seq #, 2);" style="display: none;"/>'
								}
							]
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000016270","방문<br/>인원")%>",
							field:"visit_cnt",
							width:50, 
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {style: "text-align: center;"}
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010892","표찰번호")%>",
							width:70,
					  		headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					  		attributes: {style: "text-align: center;"},
							template: '<input type="text" style="width:50px; height:18px;text-align: center;" id="card_no_#: r_no #_#: seq #"/>'
						}
					
					],
			dataSource: dataSource,
	        sortable: true ,
	        selectable: "single",
	        navigatable: true,
	        dataBound:btnSetting,
	        pageable: {
		          refresh: false,
		          pageSizes: true
		        },
	        scrollable: true,
	        columnMenu: false,
	        autoBind: true,
		}).data("kendoGrid");
		
		btnSetting();
	}
	
	
	//  입실/퇴실/표찰번호 셋팅
	function btnSetting(){
		var grid = $("#grid").data("kendoGrid");
		var gridData = grid.dataSource.data();
		
		for(var i=0;i<gridData.length;i++){
			//방문날짜가 현재 날짜와 같고 입실 처리가 되어 있지 않은 경우 입실버튼 출력
			if((gridData[i].in_time == null || gridData[i].in_time == '') && gridData[i].visit_dt_fr == today){
				document.getElementById("btn_in_"+gridData[i].r_no+"_"+gridData[i].seq).style.display = "block";
			}
			
			//방문날짜가 현재 날짜와 같고입실 처리가 되어 있는 경우 퇴실버튼 출력
			if((gridData[i].out_time == null || gridData[i].out_time == "") && gridData[i].visit_dt_fr == today){
				if(gridData[i].in_time != "" && gridData[i].in_time != null){
					document.getElementById("btn_out_"+gridData[i].r_no+"_"+gridData[i].seq).style.display = "block";
				}
			}
			
			//표찰번호가 0이 아닐 경우(입실처리가 되어 있는 경우) 표찰번호 수정불가
			if(gridData[i].visit_card_no != 0){
				document.getElementById("card_no_"+gridData[i].r_no+"_"+gridData[i].seq).value = gridData[i].visit_card_no;
				document.getElementById("card_no_"+gridData[i].r_no+"_"+gridData[i].seq).readOnly  = "true";
			}
				
		}
	}
	
	//조회 dataSource
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
   	    	data.pVisitCo = $("#txtVisitCO_S").val();
   	    	data.pVisitNm = $("#txtVisitNM_S").val();
   	    	data.pDept = $("#txtManDept_S").val();
    		data.pGrade = $("#txtManGrade_S").val();
    		data.pName = $("#txtManNM_S").val();
    		data.pType = "check";	   	    	
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
		fnGetDataList();
	}
	
	
	// 입/퇴실 처리(type:1 -> 입실)
	//          (type:2 -> 퇴실)
	function fnTimeCheck(r_no, seq, type) {
		var dateNow = new Date();
		
        var sType = "";
        var card_no = $("#card_no_" + r_no + "_" + seq).val();
        
        if (card_no == "") {
            alert("<%=BizboxAMessage.getMessage("TX000010891","표찰번호를 입력하세요")%>");
            return false;
        }

        if (type == 1) {
            sType = "in";
        }
        else {
            sType = "out";
        }
        var tblParam = {};
        
        var Hour = dateNow.getHours()+"";
    	var Min = dateNow.getMinutes()+"";
    	
    	if (Hour < 10)
    		Hour = "0" + Hour;
    	if (Min < 10)
    		Min = "0" + Min;
        
        tblParam.nRNo = r_no;
        tblParam.nSeq = seq;
        tblParam.nCardNo = card_no;
        tblParam.sType = sType;
        tblParam.sTime = Hour + Min;
        
        $.ajax({
		    	type:"post",
				url:'<c:url value="/cmm/ex/visitor/CheckVisitor.do" />',
				datatype:"text",
				data: tblParam ,
				success:function(data){
					if(sType == "in")
						fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000010890","입실처리 되었습니다")%>","success",1500);
					else
						fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000017929","퇴실처리 되었습니다")%>","success",1500);
					fnGetDataList();
				},error : function(data){
					alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
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
    </script>

<!-- 검색박스 -->
<div class="top_box">
	<dl>
		<dt class="ar en_w13" style="width:68px;"><%=BizboxAMessage.getMessage("TX000010887","방문일시")%></dt>
		<dd>
			<input id="txtFrDt" class="dpWid"/>
			~
			<input id="txtToDt" class="dpWid"/>
		</dd>
		<dd>
			<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
		</dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>	
		<dt style="width:70px;" class="en_w232"><%=BizboxAMessage.getMessage("TX000016333","담당자부서")%></dt>
		<dd class="mr5">
			<input id="txtManDept_S" name="txtManDept_S" type="text" value="" style="width:150px;">
		</dd>
		<dt style="width:80px;" class="en_w232"><%=BizboxAMessage.getMessage("TX000016332","담당자직급")%></dt>
		<dd class="mr5">
			<input id="txtManGrade_S" name="txtManGrade_S" type="text" value="" style="width:150px">
		</dd>
		<dt style="width:80px;" class="en_w185"><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></dt>
		<dd class="mr5">
			<input id="txtManNM_S" name="txtManNM_S" type="text" value="" style="width:150px">
		</dd>
	</dl>
	<dl>	
		<dt style="width:70px;" class="en_w232"><%=BizboxAMessage.getMessage("TX000016263","방문자회사")%></dt>
		<dd class="mr5">
			<input id="txtVisitCO_S" name="txtVisitCO_S" type="text" value="" style="width:150px">
		</dd>
		<dt style="width:80px;" class="en_w232"><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="mr5">
			<input id="txtVisitNM_S" name="txtVisitNM_S" type="text" value="" style="width:150px">
		</dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="mt20"></div>						
	<!-- 그리드 리스트 -->
	<div id="grid" ></div>
						
</div><!-- //sub_contents_wrap -->