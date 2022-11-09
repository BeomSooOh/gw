<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var gubunCombobox = '';		// 구분 콤보박스 값 (disable을 위해 선언)

	$(document).ready(function(){
		// 임시 데이터
		//:TODO 임시데이터 확인 후 변경 필요
		$("#division").kendoComboBox({
			dataSource : [
            	{Gubun:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", Value:"all"},
            	{Gubun:"<%=BizboxAMessage.getMessage("TX000016163","웹")%>", Value:"WEB"},
            	{Gubun:"<%=BizboxAMessage.getMessage("TX000004025","메신저")%>", Value:"MESSENGER"},
            	{Gubun:"<%=BizboxAMessage.getMessage("TX000016053","모바일")%>", Value:"MOBILE"}
            ],
            dataTextField : "Gubun",
            dataValueField : "Value"
		});
		
		gubunCombobox = $("#division").data("kendoComboBox");
		gubunCombobox.select(0);
	
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
	    
	    // 결과 검색
	    $("#btnSearch").click(function(){
	    	fnLoginSatisticsGrid();
	    });
	    
	    // 기간 셋팅
	    fnInitDatePicker(3);
	    
	    // 로그인 데이터 가져오기
	    fnLoginSatisticsGrid();
	});
	
	// 기간 셋팅
	function fnInitDatePicker(dayGap) {

		// Object Date add prototype
		Date.prototype.ProcDate = function () {
			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString(); //
			var dd = this.getDate().toString();
			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-'
					+ (dd[1] ? dd : "0" + dd[0]);
		};

		var toD = new Date();
		$('#txtToDt').val(toD.ProcDate());

		
		var fromD = new Date(toD.getFullYear(), toD.getMonth(),
				toD.getDate()-dayGap);
		
		$('#txtFrDt').val(fromD.ProcDate());
	}
		
	
	// login내역 datasource
	var dataSource = new kendo.data.DataSource({
	     	  serverPaging: true,
	     	  pageSize: 20,
	     	  transport: {
	     	    read: {
	     	      type: 'post',
	     	      dataType: 'json',
	     	      url: '<c:url value="/cmm/systemx/satistics/loginSatisticsData.do"/>'
	     	    },
	     	    parameterMap: function(data, operation) {
	     	    	data.gubun = $("#division").val();
	     	    	data.empName = $("#txtEmpName").val();
	     	    	data.frDt = $("#txtFrDt").val() + ' 00:00:00'; 
	     	    	data.toDt = $("#txtToDt").val() + ' 23:59:59';
	     	    	
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
	

	function fnLoginSatisticsGrid() {
		var grid = $("#grid").kendoGrid({
			columns: [
	          {
					title:"<%=BizboxAMessage.getMessage("TX000000076","사원명")%>", 
					template: function(data) {
						return data.empName + " [" + data.loginId + "]";
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  }, 
			  {
					title:"<%=BizboxAMessage.getMessage("TX000000243","사용일시")%>", 
					template: function(data) {
						return data.loginDate;
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  },
			  {
					title:"<%=BizboxAMessage.getMessage("TX000000236","로그인IP")%>", 
					template: function(data) {
						return data.accessIp;
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  },			  
			  {
					title:"<%=BizboxAMessage.getMessage("TX000000214","구분")%>", 
					template: function(data) {
						return data.deviceType;
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  }]
			,
			dataSource: dataSource,
	        sortable: true ,
	        selectable: "single",
	        navigatable: true,
	        pageable: {
		          refresh: false,
		          pageSizes: true
		        },
	        scrollable: true,
	        columnMenu: false,
	        autoBind: true
		}).data("kendoGrid");
		
		//grid.dataSource.page(0);
	}
	
	function excelDown(){
		var gubun = $("#division").val();
	   	var empName = $("#txtEmpName").val();
	    var frDt = $("#txtFrDt").val() + ' 00:00:00'; 
	    var toDt = $("#txtToDt").val() + ' 23:59:59';
	    
	    var paraStr = "?gubun=" + gubun + "&empName=" + encodeURI(encodeURIComponent(empName)) + "&frDt=" + frDt + "&toDt=" + toDt;  
	    self.location.href = "/gw/cmm/systemx/satistics/loginSatisticsDataExcel.do" + paraStr;
	}
</script>

<div class="top_box">
	<dl>
		<dt class="ar" style="width:68px;"><%=BizboxAMessage.getMessage("TX000000229","조회일자")%></dt>
		<dd>
			<input id="txtFrDt" class="dpWid"/>
			~
			<input id="txtToDt" class="dpWid"/>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000076","사원명")%></dt>
		<dd>
			<input onkeydown="if(event.keyCode==13){javascript:fnLoginSatisticsGrid();}" type="text" id="txtEmpName" />
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000214","구분")%></dt>
		<dd>
			<input  id="division" style="width:100px;"/>
		</dd>
		<dd>
			<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
		</dd>
	</dl>
</div>

<div class="sub_contents_wrap">
	<div class="right_div">
		<div id="" class="controll_btn">			
			<button id="excelDown" class="k-button" onclick="excelDown();"><%=BizboxAMessage.getMessage("TX000006928","엑셀저장")%></button>
		</div>
	</div>
	<!-- 그리드 리스트 -->
	<div id="grid"></div>
	
</div><!-- //sub_contents_wrap -->