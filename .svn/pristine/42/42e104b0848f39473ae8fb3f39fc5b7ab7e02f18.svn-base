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

		//현재 날짜 셋팅(yyyy mm dd)
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
		    
		    //버튼이벤트
		    $(function () {
	            $("#btnSearch").click(function () { fnSearch() });		//조회버튼
	            $("#btnSearch2").click(function () { fnSearch(); });	//조회버튼
	        })
		    
	        $("#com_sel").kendoComboBox({
				dataTextField: "compName",
				dataValueField: "compSeq",
				dataSource :${compListJson},
				index : 0,
				change: fnGetDataList,
				filter: "contains",
				suggest: true
			}); 
		   
			var coCombobox = $("#com_sel").data("kendoComboBox");
			
			coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
			coCombobox.refresh();
			coCombobox.select(0);
			
			
		    //컨트롤 초기화
		    fnControlInit();
		    
		});//document ready end
		
		 //컨트롤 초기화
		function fnControlInit() {
	        $("#txtFrDt").val(today);
	        $("#txtToDt").val(today2);
	        fnGetDataList();  //데이터 조회
	    }
		
		function fnMouseIn(e) {
			
			/* var grid = $("#grid").data("kendoGrid");
			var gridData = grid.dataSource.data();
			
			console.log(gridData); */
			
			console.log(e);
			console.log("in " + e.getAttribute('r_no'));
			
			var type = e.getAttribute('name');
			var r_no = e.getElementsByTagName('div')[0].getAttribute('r_no');
			var in_time = e.getElementsByTagName('div')[0].getAttribute('in_time');
			var out_time = e.getElementsByTagName('div')[0].getAttribute('out_time');
			var visit_dt_fr = e.getElementsByTagName('div')[0].getAttribute('visit_dt_fr');
			
			/* 입실 컬럼 */
			if(type == 'in'){
				/* 입실만 되어있는 상태 */
				if((out_time == "null" || out_time == "") && visit_dt_fr == today){
					if(in_time != "" && in_time != "null"){
						$("#text_in_"+r_no).hide();
						$("#edit_in_"+r_no).show();
						$("#cancel_in_"+r_no).show();
					}
				}
			}
			
			/* 퇴실 컬럼 */
			else {
				/* 입/퇴실 모두 완료인 경우 */
				if(in_time != "null" && out_time != "null" && visit_dt_fr == today){
					$("#text_out_"+r_no).hide();
					$("#edit_out_"+r_no).show();
					$("#cancel_out_"+r_no).show();
					
				}
			}
		}
		
		function fnMouseOut(e) {
			console.log("out " + e.getAttribute('r_no'));
			
			var type = e.getAttribute('name');
			var r_no = e.getElementsByTagName('div')[0].getAttribute('r_no');
			var in_time = e.getElementsByTagName('div')[0].getAttribute('in_time');
			var out_time = e.getElementsByTagName('div')[0].getAttribute('out_time');
			var visit_dt_fr = e.getElementsByTagName('div')[0].getAttribute('visit_dt_fr');
			
			if(type == 'in'){
				if((out_time == "null" || out_time == "") && visit_dt_fr == today){
					if(in_time != "" && in_time != "null"){
						$("#text_in_"+r_no).show();
						$("#edit_in_"+r_no).hide();
						$("#cancel_in_"+r_no).hide();
					}
				}
			}
			
			else {
				if(in_time != "null" && out_time != "null" && visit_dt_fr == today){
					$("#text_out_"+r_no).show();
					$("#edit_out_"+r_no).hide();
					$("#cancel_out_"+r_no).hide();
					
				}
			}
			
		}
		
		
		//검색
		function fnSearch(){
			fnGetDataList();
		}
		
		//grid셋팅
		function fnGetDataList(){
			//grid table
			var grid = $("#grid").kendoGrid({
				columns: [
						{
							title:"<%=BizboxAMessage.getMessage("","방문일시")%>",
							field:"visit_dt_fr",
							width:120,
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
							field:"<%=BizboxAMessage.getMessage("TX000010895","방문자")%>",					
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
				 						if(rowData.visit_pticket_yn == "Y" && rowData.visit_car_no != ""){
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
							attributes: {style: "text-align: center;"}
						},
						{
							title:"<%=BizboxAMessage.getMessage("","등록자")%>",
							field:"req_emp_name",
							columnMenu:true,
							headerAttributes: {style: "text-align: center; vertical-align:middle;"},
							attributes: {style: "text-align: center;"}
						},
						{	
							title:"<%=BizboxAMessage.getMessage("TX000010894","입실")%>",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {name:"in", style: "text-align: center;", onmouseover: 'fnMouseIn(this)', onmouseout: 'fnMouseOut(this)'},
							field:"in_time",
							width:120,
							template: function(rowData){
								var html = '<div name="data" in_time='+ rowData.in_time + ' out_time=' + rowData.out_time + ' r_no=' + rowData.r_no + ' visit_dt_fr=' + rowData.visit_dt_fr + ' id=in_'+rowData.r_no+'><input type="button" value="확인" class="big_btn" id="btn_in_'+ rowData.r_no + '" style="display: none;" onclick="fnOpenTimeCheckPop('+rowData.r_no+', 1, 1);"/></div>' +
								'<input type="button" style="display:none; margin-right:3px;" value="수정" class="big_btn" id="edit_in_'+ rowData.r_no + '" onclick="fnOpenTimeCheckPop('+rowData.r_no+', 1, 2);"/></div>' +
								'<input type="button" style="display:none;" value="취소" class="big_btn" id="cancel_in_'+ rowData.r_no + '" onclick="fnInOutCancle('+rowData.r_no+',' + null +' ,' + '1);"/></div>'; 
								return html;
								
							}
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010893","퇴실")%>",
							headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
							attributes: {name:"out", style: "text-align: center;", onmouseover: 'fnMouseIn(this)', onmouseout: 'fnMouseOut(this)'},
							field:"out_time",
							width:120,
							template: function (rowData){
								var html = '<div in_time=' + rowData.in_time + ' out_time=' + rowData.out_time + ' r_no=' + rowData.r_no + ' visit_dt_fr=' + rowData.visit_dt_fr +' id=out_'+rowData.r_no+ '><input type="button" value="확인" class="big_btn" id="btn_out_'+ rowData.r_no + '" style="display: none;" onclick="fnOpenTimeCheckPop('+rowData.r_no+', 2, 1);"/></div>' +
								'<input type="button" style="display:none; margin-right:3px;" value="수정" class="big_btn" id="edit_out_'+ rowData.r_no + '" onclick="fnOpenTimeCheckPop('+rowData.r_no+', 2, 2);"/></div>' +
								'<input type="button" style="display:none;" value="취소" class="big_btn" id="cancel_out_'+ rowData.r_no + '" onclick=\"fnCardCheck('+rowData.r_no+', \'' + rowData.visit_card_no + '\');\"/></div>'; 
								return html;
							}
								
						},
						{
							title:"<%=BizboxAMessage.getMessage("TX000010892","표찰번호")%>",
							field:"visit_card_no",
							width:70,
					  		headerAttributes: {style: "text-align: center; vertical-align:middle;"}, 
					  		attributes: {style: "text-align: center;"},
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
		        dataBound:btnSetting,
			}).data("kendoGrid");
			
			/* btnSetting(); */
			
		}
		
		
		//  입실/퇴실/표찰번호 셋팅
		function btnSetting(e){
			var grid = $("#grid").data("kendoGrid");
			var gridData = grid.dataSource.data();
			
			for(var i=0;i<gridData.length;i++){
				
				/* 입/퇴실 시간 세팅 */
				var time = gridData[i].f_in_time;
				
				if(time != '' && time != null) {
					if(time.length > 4){
						in_date = time.substr(0,4) + "-" + time.substr(4,2) + "-" + time.substr(6,2);
						in_time = time.substr(8,2) + ":" + time.substr(10,2); 
					}
					else {
						in_date = gridData[i].visit_dt_fr;
						in_time = time.substr(0,2) + ":" + time.substr(2,2);
					}	
				}
				
				var time2 = gridData[i].f_out_time;
				
				if(time2 != '' && time2 != null) {
					if(time2.length > 4){
						out_date = time2.substr(0,4) + "-" + time2.substr(4,2) + "-" + time2.substr(6,2);
						out_time = time2.substr(8,2) + ":" + time2.substr(10,2); 
					}
					else {
						out_date = gridData[i].visit_dt_fr;
						out_time = time2.substr(0,2) + ":" + time2.substr(2,2);
					}	
				}
				
				//방문날짜가 현재 날짜와 같고 입실 처리가 되어 있지 않은 경우 입실버튼 출력
				if((gridData[i].in_time == null || gridData[i].in_time == '') && gridData[i].visit_dt_fr == today){
					document.getElementById("btn_in_"+gridData[i].r_no).style.display = "inline-block";

					if(gridData[i].out_time == null || gridData[i].out_time == ""){
						document.getElementById("out_"+gridData[i].r_no).innerHTML = "";
					}
					else {
						document.getElementById("out_"+gridData[i].r_no).innerHTML = '<div><p>' + out_date +'<br />'+ out_time +'</p></div>';
					}
					
				}
				
				//방문날짜가 현재 날짜와 같고 입실 처리가 되어 있는 경우 
				if((gridData[i].out_time == null || gridData[i].out_time == "")){
					//날짜가 오늘인 경우
					if(gridData[i].visit_dt_fr == today) {
						if(gridData[i].in_time != "" && gridData[i].in_time != null){
							document.getElementById("btn_out_"+gridData[i].r_no).style.display = "inline-block";
							
							if(gridData[i].in_time == null || gridData[i].in_time == ""){
								document.getElementById("in_"+gridData[i].r_no).innerHTML = "";
							}
							else {
								document.getElementById("in_"+gridData[i].r_no).innerHTML = '<div id=text_in_'+ gridData[i].r_no + '><p>' + in_date + '<br />' + in_time +'</p></div>';
							}
						}
					}
					//방문날짜가 지났지만 입실만 체크되어 있는 경우 - 아직 입실중인 상태
					else if(gridData[i].visit_dt_fr < today){
						
						if(gridData[i].in_time == null || gridData[i].in_time == ""){
							document.getElementById("in_"+gridData[i].r_no).innerHTML = "";
						}
						else {
							
							document.getElementById("btn_out_"+gridData[i].r_no).style.display = "inline-block";
							document.getElementById("in_"+gridData[i].r_no).innerHTML = '<div id=text_in_'+ gridData[i].r_no + '><p>' + in_date + '<br />' + in_time + '</p></div>';
						}
					}
				}
				
				/* //표찰번호가 0이 아닐 경우(입실처리가 되어 있는 경우) 표찰번호 수정불가
				if(gridData[i].visit_card_no != 0){
					document.getElementById("card_no_"+gridData[i].r_no).value = gridData[i].visit_card_no;
					document.getElementById("card_no_"+gridData[i].r_no).readOnly  = "true";
				} */
				
				/* 입/퇴실 모두 완료인 경우 시간 노출 */
				if(gridData[i].in_time != null && gridData[i].out_time != null){
					
					document.getElementById("in_"+gridData[i].r_no).innerHTML = '<div id=text_in_'+ gridData[i].r_no+'><p>' + in_date +'<br />'+ in_time +'</p></div>';
					document.getElementById("out_"+gridData[i].r_no).innerHTML = '<div id=text_out_'+ gridData[i].r_no+'><p>'+ out_date +'<br />'+ out_time +'</p></div>';
				}
			}
		}
		
		//조회항목 dataSource
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
					
	     	    	data.searchListType = "check";
	     	    	
	     	    	if($("#txtVisitCardNo").val() != ""){
						data.pVisitCardNo = $("#txtVisitCardNo").val(); //상세검색(표찰번호)	
					}
	     	    	
					if($("#com_sel").val() != ""){
	     	    		data.selectedCompSeq = $("#com_sel").val(); 	//회사 선택
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
		
		function fnOpenTimeCheckPop(r_no, type, kind) {
			
			if(kind == 1){
				kind = "new";
			}
			else {
				kind = "edit";
			}
			
			var paramUrl = "?r_no=" + r_no + "&type=" + type + "&kind=" + kind;

			var url = '/gw/cmm/ex/visitor/visitCheckPopView.do' + paramUrl;
			
			var winHeight = document.body.clientHeight;	// 현재창의 높이
			var winWidth = document.body.clientWidth;	// 현재창의 너비
			var winX = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0;	// 현재창의 y좌표
			
			var popWidth = 445;
			var popHeight = 265;
			
			var popX = winX + (winWidth - popWidth)/2;
			var popY = winY + (winHeight - popHeight)/2;
			
			window.open(url, "입/퇴실체크 팝업", "width="+popWidth+",height="+popHeight+",scrollbars=0,top="+popY+ ",left="+popX);
		}
		
	<%-- 	// 입/퇴실 처리(type:1 -> 입실)
		//          (type:2 -> 퇴실)
		function fnTimeCheck(r_no, seq, type) {
			
			var dateNow = new Date();
			
	        var sType = "";
	        var card_no = $("#card_no_" + r_no).val();
	        
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
  					if(data.resultCode == "SUCCESS"){
  						if(sType == "in")
  	  						fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000010890","입실처리 되었습니다")%>","success",1500);
  	  					else
  	  						fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000017929","퇴실처리 되었습니다")%>","success",1500);	
  						fnGetDataList();
  					}
  					else {
						if(data.resultCode == "ERR000"){
							alert("입퇴실 체크 오류");
						} 						
						else if(data.resultCode == "ERR001"){
							alert("퇴실하지 않은 표찰번호입니다.");
						}
  					}
  				},error : function(data){
  					alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
  				}
  		    	
  		    });
	    } --%>
		
		
		function fnInOutCancle(r_no, cardNo, type) {
			
			var tblParam = {};
			
			tblParam.nRNo = r_no;
	        tblParam.nSeq = 1;
	        
	        if(type == 1){
	        	tblParam.nCardNo = null;
	        	tblParam.sType = "in";
	        }
	        else {
	        	tblParam.sType = "out";
	        }
	        tblParam.sTime = null;
	        
	        $.ajax({
  		    	type:"post",
  				url:'<c:url value="/cmm/ex/visitor/CheckVisitorNew.do" />',
  				datatype:"text",
  				data: tblParam ,
  				success:function(data){
  					if(data.resultCode == "SUCCESS"){
  						fnSetSnackbar("<%=BizboxAMessage.getMessage("","취소 되었습니다.")%>","success",1500);
  						fnGetDataList();
  					}
  					else {
						if(data.resultCode == "ERR000"){
							alert("입퇴실 체크 오류");
						} 						
  					}
  				},error : function(data){
  					alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
  				}
  		    	
  		    });
			
		}
		
		
		/* 퇴실 취소 시 표찰번호 체크  */
		function fnCardCheck(r_no, cardNo) {
			
			/* 표찰번호가 없는 경우 - 사용중 표찰 여부 체크 X */			
			if(cardNo == '') {
				fnInOutCancle(r_no, cardNo, 2);
			}
			else {
				/* 사용중인 표찰인지 확인 */
				$.ajax({
	  		    	type:"post",
	  				url:'<c:url value="/cmm/ex/visitor/CheckVisitCard.do" />',
	  				datatype:"json",
	  				data: {
	  					nCardNo: cardNo
	  				},
	  				success:function(data){
	  					if(data.resultCode == "ERR001"){
	  						puddAlert('warning', '이미 사용중인 표찰번호가 있어,<br />퇴실처리가 불가능합니다.', '');
	  					}
	  					else if(data.resultCode == "SUCCESS"){
	  						fnInOutCancle(r_no, cardNo, 2);
	  					}
	  					else {
	  						alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
	  					}
	  				},error : function(data){
	  					alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
	  				}
	  		    });
			}
		}
		
		function fnSetSnackbar(msg, type, duration){
			var puddActionBar = Pudd.puddSnackBar({
				type	: type
			,	message : msg
			,	duration : 1500
			});
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
		
    </script>


<!-- 검색박스 -->
<div class="top_box">
	<dl class="dl1">
		<dt ><%=BizboxAMessage.getMessage("","회사")%></dt>
		<dd class="mr25">
			 <input id="com_sel" name="com_sel" style="width:150px">
		</dd>
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
		
		<dd>
			<input id="btnSearch" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>">
		</dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src='../../../Images/ico/ico_btn_arr_down01.png'/></span>
</div>

<!-- 상세검색박스 -->
<div class="SearchDetail">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000016264","방문자이름")%></dt>
		<dd class="mr35">
			<input id="txtVisitNM_S" type="text" value="" style="width:150px">
		</dd>
		<dt><%=BizboxAMessage.getMessage("","방문자회사")%></dt>
		<dd class="mr35">
			<input id="txtVisitCO_S" type="text" value="" style="width:150px">
		</dd>
		<dt><%=BizboxAMessage.getMessage("","담당자")%></dt>
		<dd class="mr25">
			<input id="txtManNM_S" type="text" value="" style="width:150px">
		</dd>
	</dl>
	<dl>
		<dt class="ml20"><%=BizboxAMessage.getMessage("","등록자")%></dt>
		<dd class="mr45">
			<input id="txtReqNM_S" type="text" value="" style="width:150px">
		</dd>	
		<dt><%=BizboxAMessage.getMessage("","표찰번호")%></dt>
		<dd class="mr25">
			<input id="txtVisitCardNo" name="txtVisitCardNo" type="text" value="" style="width:150px">
		</dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="mt20"></div>						
	<!-- 그리드 리스트 -->
	<div id="grid" ></div>
						
</div><!-- //sub_contents_wrap -->