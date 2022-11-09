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
               $("#btnSearch").click(function () { fnSearch(); });   //조회버튼
               $("#btnSearch2").click(function () { fnSearch(); });   //조회버튼2
               $("#btnSave").click(function () { fnSave(0); });      //등록버튼
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

		 //시작날짜
	    $("#from_date").kendoDatePicker({
	    	format: "yyyy-MM-dd"
	    });
	    
	    //종료날짜
	    $("#to_date").kendoDatePicker({
	    	format: "yyyy-MM-dd"
	    });
	    
	    BindListGrid();
	    
	    getDataList();

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
     	    	data.mType = "A";
     	    	data.formSeq = $("#t_certGubun").val(); 
   	    		data.apprStat = $("#t_certStatus").val();
   	    		
   	    		sDate = $("#from_date").val();
   	    		eDate = $("#to_date").val();
   	    		data.sDate = sDate.replace(/-/g,"");
   	    		data.eDate = eDate.replace(/-/g,"");
   	    		
   	    		sKeyword = $("#t_keyword").val();
   	    		if (sKeyword != "<%=BizboxAMessage.getMessage("TX000001289","검색")%>" && sKeyword != "") {
   	    			data.sKeyword = sKeyword;
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
		getDataList();
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
		
		var today = yyyy + "-" + mm + "-" + dd;
		
		
		date.setMonth(date.getMonth() - 1);
		
		yyyy = date.getFullYear().toString();
		mm = date.getMonth()+1;
		dd = date.getDate();

		if (mm < 10)
		    mm = "0" + mm;
		if (dd < 10)
		    dd = "0" + dd;
		
		var today2 = yyyy + "-" + mm + "-" + dd;
		
		$("#from_date").val(today2);
		$("#to_date").val(today);
	}
    
	
    //상세팝업
    function btnDetail(selectedItem){
    	if (selectedItem.apprStatNm != "<%=BizboxAMessage.getMessage("TX000000798","승인")%>") {
    		alert("<%=BizboxAMessage.getMessage("TX000005815","승인되지 않은 증명서는 출력할수 없습니다.")%>");
    	}
    	else {
	    	var url = "certRequestPrint.do?cerSeq="+selectedItem.cerSeq+"&formSeq="+selectedItem.formSeq;
		   	var left = (screen.width-958)/2;
		   	var top = (screen.height-753)/2;
		   	 
		   	var pop = window.open(url, "certRequestPrint", "scrollbars=auto,resizable=1,width=800,height=930,left="+left+" top="+top);
		   	pop.focus();
    	}
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
    
    
    function getDataList() {
    	var rParam = {};
    	
    	rParam.sDate = $("#from_date").val();
    	rParam.eDate = $("#to_date").val();
    	rParam.mType = "A";
    	rParam.formSeq = $("#t_certGubun").val(); 
    	rParam.apprStat = $("#t_certStatus").val();
    	var sKeyword = $("#t_keyword").val();
   		if (sKeyword != "<%=BizboxAMessage.getMessage("TX000001289","검색")%>" && sKeyword != "") {
   			rParam.sKeyword = sKeyword;
   		}
    	
    	$.ajax({
         	type:"post",
     		url:'<c:url value="/systemx/getCertificatePresentConditionList.do"/>',
     		datatype:"text",
     		data:rParam,
     		success: function (data) {
     			setDataList(data.cpcList);
     		},
 		    error: function (result) { 
     			
     		}
     	});
    }
    
    
    function setDataList(dataList) {
		var tag = '';
		tag += '<table><colgroup><col width="11.5%"/><col width="11%"/><col width="11%"/><col width="11%"/>';
		tag += '<col width="11%"/><col width="11%"/><col width="11%"/><col width="11%"/><col width=""/></colgroup>';
		tag += '<thead><tr><th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th><th><%=BizboxAMessage.getMessage("TX000016056","금융기관 제출용")%></th><th><%=BizboxAMessage.getMessage("TX000016057","교육기관 제출용")%></th><th><%=BizboxAMessage.getMessage("TX000016058","관공서 제출용")%></th>';
		tag += '<th><%=BizboxAMessage.getMessage("TX000017315","타사 제출용")%></th><th><%=BizboxAMessage.getMessage("TX000016395","개인증빙용")%></th><th><%=BizboxAMessage.getMessage("TX000016346","기타사유")%></th><th><%=BizboxAMessage.getMessage("TX000017940","세관제출용")%></th><th><%=BizboxAMessage.getMessage("TX000000518","합계")%></th></tr></thead>';
		
		for(var i=0; i<dataList.length; i++) {
			tag += '<th>' + dataList[i].formNm + '</th><th>' + dataList[i].reqCnt10 + '</th>';
			tag += '<th>' + dataList[i].reqCnt20 + '</th><th>' + dataList[i].reqCnt30 + '</th>';
			tag += '<th>' + dataList[i].reqCnt40 + '</th><th>' + dataList[i].reqCnt50 + '</th>';
			tag += '<th>' + dataList[i].reqCnt60 + '</th><th>' + dataList[i].reqCnt70 + '</th>';
			tag += '<th>' + dataList[i].reqCntSum + '</th></tr>';
				
			if (dataList[i].formSeq != "0") {
				tag = '<tfoot><td class="fwb">' + tag + '</tfoot>';
			}
			else {
				tag = '<td>' + tag;
			}
		}
		
		tag += '</table>';
		
		
		$(".data_area").html(tag);
    }
    
    
    function selectRow(grid) {
		CommonKendo.setChecked($("#grid").data("kendoGrid"), this);
	}
    
</script>

   
<!-- 검색박스 -->
<div class="sub_contents_wrap">
	<div class="top_box">										
		<dl>
			<dt><%=BizboxAMessage.getMessage("","요청기간")%></dt>
			<dd><input id="from_date" class="dpWid"/> ~ <input id="to_date" class="dpWid"/>	</dd>
			<dt><%=BizboxAMessage.getMessage("TX000000076","사원명")%></dt>
			<dd><input id="t_keyword" type="text" style="width:130px;" placeholder="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" value=""/></dd>
			<dd><input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"/></dd>
		</dl>								
		<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='/gw/Images/ico/ico_btn_arr_down01.png'/></span>
	</div>
	
	<div class="SearchDetail mb14">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000001014","증명서구분")%></dt>
			<dd>
				<input id="t_certGubun" style="width:120px;"/>
			</dd>
			<dt style="width:100px;"><%=BizboxAMessage.getMessage("TX000000760","처리상태")%></dt>
			<dd>
				<input id="t_certStatus" style="width:100px;"/>
				<input id="btnSearch2" class="btn_search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"/>
			</dd>
		</dl>
	</div>

	<!-- 그리드 리스트 -->
	<div id="grid" style="clear:both" class="mt14"></div>

	<div class="com_ta2 hover_no mt30">
		<div class="data_area"> </div>
		<!--<table>
			<colgroup>
				<col width="11.5%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width="11%"/>
				<col width=""/>
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>
					<th>금융기관 제출용</th>
					<th>교육기관 제출용</th>
					<th>관공서 제출용</th>
					<th>타사 제출용</th>
					<th>개인증빙용</th>
					<th>기타사유</th>
					<th>세관제출용</th>
					<th>합계</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<td class="fwb">[소계]</td>
					<td>80</td>
					<td>3</td>
					<td>4</td>
					<td>5</td>
					<td>55</td>
					<td>5</td>
					<td>5</td>
					<td>11</td>
				</tr>
			</tfoot>
				<tr>
					<td>재직증명서</td>
					<td>65</td>
					<td>2</td>
					<td>1</td>
					<td>1</td>
					<td>8</td>
					<td>4</td>
					<td>4</td>
					<td>45</td>
				</tr>
				<tr>
					<td>재직증명서</td>
					<td>65</td>
					<td>2</td>
					<td>1</td>
					<td>1</td>
					<td>8</td>
					<td>4</td>
					<td>4</td>
					<td>45</td>
				</tr>
				<tr>
					<td>재직증명서</td>
					<td>65</td>
					<td>2</td>
					<td>1</td>
					<td>1</td>
					<td>8</td>
					<td>4</td>
					<td>4</td>
					<td>45</td>
				</tr>
		</table>-->					
	</div>

</div><!-- //sub_contents_wrap -->