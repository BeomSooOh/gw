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
	    	fnMenuSatisticsGrid();
	    });
	    
	    // 기간 셋팅
	    fnInitDatePicker(3);
	    
	    // 로그인 데이터 가져오기
	    fnMenuSatisticsGrid();
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
	     	      url: '<c:url value="/cmm/systemx/satistics/menuSatisticsData.do"/>'
	     	    },
	     	    parameterMap: function(data, operation) {
	     	    	data.empName = $("#txtEmpName").val();
	     	    	data.menuName = $("#txtMenuName").val();
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

	function fnMenuSatisticsGrid() {
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
						return data.useDate;
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  }, 
			  {
					title:"<%=BizboxAMessage.getMessage("TX000000120","메뉴명")%>", 
					template: function(data) {
						return data.menuNm + " [" + data.menuAuth + "]";
					}, 
					headerAttributes : {
						style : "text-align: center;"
					},
					attributes : {
						style : "text-align: center;"
					}
			  }, 
			  {
					title:"<%=BizboxAMessage.getMessage("TX000000245","사용IP")%>", 
					template: function(data) {
						return data.accessIp;
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
		
		var empName = $("#txtEmpName").val();
	   	var menuName = $("#txtMenuName").val();
	    var frDt = $("#txtFrDt").val() + ' 00:00:00'; 
	    var toDt = $("#txtToDt").val() + ' 23:59:59';
	    
	    var paraStr = "?empName=" + encodeURI(empName) + "&menuName=" + encodeURI(menuName) + "&frDt=" + frDt + "&toDt=" + toDt;  
	    self.location.href = "/gw/cmm/systemx/satistics/menuSatisticsDataExcel.do" + paraStr;
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
			<input onkeydown="if(event.keyCode==13){javascript:fnMenuSatisticsGrid();}" type="text" id="txtEmpName" />
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000120","메뉴명")%></dt>
		<dd>
			<input onkeydown="if(event.keyCode==13){javascript:fnMenuSatisticsGrid();}" type="text" id="txtMenuName" style="width:100px;"/>
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