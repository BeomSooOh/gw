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

var visitCardUse = false;

var date = new Date();
var yyyy = date.getFullYear().toString();
var mm = date.getMonth() + 1;
var dd = date.getDate();

if (mm < 10)
    mm = "0" + mm;
if (dd < 10)
    dd = "0" + dd;

var today = yyyy+mm+dd;

    	$(document).ready(function() {
    		
    		//버튼 이벤트
    		$(function () {
            	$("#btnSave").click(function () { fnSave(); });				//저장버튼
            });
    		
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
			//방문시간
		    $("#txtVisitDt1").kendoDatePicker({
		    	format: "yyyy-MM-dd"
		    });
		    
			
			//방문시간 DDL 공통코드 바인딩.
		    var ddlHour = NeosCodeUtil.getCodeList("so0007"); 
		    $("#ddlStartHour").kendoComboBox({
		        dataSource : ddlHour,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        height: 100,
		        index: 0
		    });
			
		    var min = [
		    	{ CODE: "00", CODE_NM: "00" },{ CODE: "01", CODE_NM: "01" },{ CODE: "02", CODE_NM: "02" },{ CODE: "03", CODE_NM: "03" },{ CODE: "04", CODE_NM: "04" },{ CODE: "05", CODE_NM: "05" },{ CODE: "06", CODE_NM: "06" },{ CODE: "07", CODE_NM: "07" },{ CODE: "08", CODE_NM: "08" },{ CODE: "09", CODE_NM: "09" },
		    	{ CODE: "10", CODE_NM: "10" },{ CODE: "11", CODE_NM: "11" },{ CODE: "12", CODE_NM: "12" },{ CODE: "13", CODE_NM: "13" },{ CODE: "14", CODE_NM: "14" },{ CODE: "15", CODE_NM: "15" },{ CODE: "16", CODE_NM: "16" },{ CODE: "17", CODE_NM: "17" },{ CODE: "18", CODE_NM: "18" },{ CODE: "19", CODE_NM: "19" },
		    	{ CODE: "20", CODE_NM: "20" },{ CODE: "21", CODE_NM: "21" },{ CODE: "22", CODE_NM: "22" },{ CODE: "23", CODE_NM: "23" },{ CODE: "24", CODE_NM: "24" },{ CODE: "25", CODE_NM: "25" },{ CODE: "26", CODE_NM: "26" },{ CODE: "27", CODE_NM: "27" },{ CODE: "28", CODE_NM: "28" },{ CODE: "29", CODE_NM: "29" },
		    	{ CODE: "30", CODE_NM: "30" },{ CODE: "31", CODE_NM: "31" },{ CODE: "32", CODE_NM: "32" },{ CODE: "33", CODE_NM: "33" },{ CODE: "34", CODE_NM: "34" },{ CODE: "35", CODE_NM: "35" },{ CODE: "36", CODE_NM: "36" },{ CODE: "37", CODE_NM: "37" },{ CODE: "38", CODE_NM: "38" },{ CODE: "39", CODE_NM: "39" },
		    	{ CODE: "40", CODE_NM: "40" },{ CODE: "41", CODE_NM: "41" },{ CODE: "42", CODE_NM: "42" },{ CODE: "43", CODE_NM: "43" },{ CODE: "44", CODE_NM: "44" },{ CODE: "45", CODE_NM: "45" },{ CODE: "46", CODE_NM: "46" },{ CODE: "47", CODE_NM: "47" },{ CODE: "48", CODE_NM: "48" },{ CODE: "49", CODE_NM: "49" },
		    	{ CODE: "50", CODE_NM: "50" },{ CODE: "51", CODE_NM: "51" },{ CODE: "52", CODE_NM: "52" },{ CODE: "53", CODE_NM: "53" },{ CODE: "54", CODE_NM: "54" },{ CODE: "55", CODE_NM: "55" },{ CODE: "56", CODE_NM: "56" },{ CODE: "57", CODE_NM: "57" },{ CODE: "58", CODE_NM: "58" },{ CODE: "59", CODE_NM: "59" },
		    	
		    ];
		    
		    var ddlMin = NeosCodeUtil.getCodeList("so0008"); 
		    $("#ddlStartMin").kendoComboBox({
		        dataSource : min,
		        dataTextField: "CODE_NM",
		        dataValueField: "CODE_NM",
		        height: 100,
		        index: 0
		    });
	
	        //컨트롤초기화
    		fnControlInit();
		  
		});//document ready end
		
		//컨트롤 초기화
		function fnControlInit(){
			
			/* 방문일자 세팅 */
			var date = '${visitorInfo.visit_dt_fr}';
			var sYear = date.substring(0,4);
			var sMonth = date.substring(4,6);
			var sDay = date.substring(6);
			var VisitDt = sYear + "-" + sMonth + "-" + sDay;
			
			$("#txtVisitDt").html(VisitDt);
			
			var dateNow = new Date();
			var Hour = dateNow.getHours()+"";
			var Min = dateNow.getMinutes()+"";
			if (Hour < 10)
				Hour = "0" + Hour;
			if (Min < 10)
				Min = "0" + Min;
			
			var in_time = '${visitorInfo.in_time}';
			var out_time = '${visitorInfo.out_time}';
			
			var in_hour="";
			var in_min="";
			var out_hour="";
			var out_min="";
			
			if(in_time.length > 4){
				in_hour = in_time.substr(8,2);
				in_min = in_time.substr(10,2);
			}	
			else{
				in_hour = in_time.substr(0,2);
				in_min = in_time.substr(2,2);
			}
			
			if(out_time.length > 4){
				out_hour = out_time.substr(8,2);
				out_min = out_time.substr(10,2);
			}
			else {
				out_hour = out_time.substr(0,2);
				out_min = out_time.substr(2,2);
			}
			
			/* 입실체크 */
			if('${paramMap.type}' == 1){
				
				/* 입실시간 세팅 */
				/* 신규 입실 */
				if('${paramMap.kind}' == "new"){
					$("#ddlStartHour").data("kendoComboBox").value(Hour);
			        $("#ddlStartMin").data("kendoComboBox").value(Min);
				}
				/* 수정 모드 */
				else {
					$("#ddlStartHour").data("kendoComboBox").value(in_hour);
			        $("#ddlStartMin").data("kendoComboBox").value(in_min);
			        $("#txtVisitCardNo").val('${visitorInfo.visit_card_no}');
				}
			}
			/* 퇴실체크 */
			else {
				/* 신규 퇴실 */
				if('${paramMap.kind}' == "new"){
					$("#ddlStartHour").data("kendoComboBox").value(Hour);
			        $("#ddlStartMin").data("kendoComboBox").value(Min);
			        $("#txtVisitCardNo").val('${visitorInfo.visit_card_no}');
			        $("#txtVisitCardNo").attr("disabled", true);
				}
				/* 수정 모드 */
				else {
					$("#ddlStartHour").data("kendoComboBox").value(out_hour);
			        $("#ddlStartMin").data("kendoComboBox").value(out_min);
			        $("#txtVisitCardNo").val('${visitorInfo.visit_card_no}');
			        $("#txtVisitCardNo").attr("disabled", true);
				}
			}
		}
		
		//닫기버튼
		function fnClose(){
			self.close();
		}
		
		/* 표찰번호 중복 체크 */
		function fnCheckVisitCard() {
			
			var text = $("#txtVisitCardNo").val();
			if(text != ""){
				$.ajax({
	  		    	type:"post",
	  				url:'<c:url value="/cmm/ex/visitor/CheckVisitCard.do" />',
	  				datatype:"json",
	  				data: {
	  					nCardNo: text
	  				},
	  				success:function(data){
	  					if(data.resultCode == "ERR001"){
	  						if('${visitorInfo.visit_card_no}' != text){
	  							$("#txtVisitCheck").show();
		  						$("#txtVisitCheck").html('이미 사용중인 표찰번호입니다.');
		  						visitCardUse = true;	
	  						}
	  					}
	  					else {
	  						$("#txtVisitCheck").hide();
	  						visitCardUse = false;
	  					}
	  				},error : function(data){
	  					alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
	  				}
	  		    	
	  		    });
			}
			else {
				$("#txtVisitCheck").hide();
				visitCardUse = false;
			}
		}
		
		/* 입/퇴실 처리 */
		function fnSave(){
			
			if(visitCardUse == true){
				puddAlert("warning", "이미 사용중인 표찰번호입니다.", "");
				return;
			}
			
			type = '${paramMap.type}'; //type: 1 -> 입실 , type:2 -> 퇴실

			var sType = "";
			var tblParam = {};
			var card_no = "";
			
			/* 입실 */
			if(type == 1){
				sType = 'in';
				card_no = $("#txtVisitCardNo").val();
				
				var Hour = $("#ddlStartHour").val(); // 시간
				var Min = $("#ddlStartMin").val(); // 분
				
			}
			/* 퇴실 */
			else {
				
				sType = 'out';
				
				var Hour = $("#ddlStartHour").val(); // 시간
				var Min = $("#ddlStartMin").val(); // 분
				
				var in_time = '${visitorInfo.in_time}';

				if(in_time.length <= 4){
					in_time = '${visitorInfo.visit_dt_fr}' + in_time; 
				}
				
				if(in_time > today + Hour + Min){
					puddAlert("warning", "퇴실시간이 입실시간보다 작습니다.", "");
					return;
				}
				
			}
			
	        tblParam.nRNo = '${paramMap.r_no}'
	        tblParam.nSeq = 1;
	        tblParam.nCardNo = card_no;
	        tblParam.sType = sType;
	        tblParam.sTime = today + Hour + Min;
	        
	        $.ajax({
  		    	type:"post",
  				url:'<c:url value="/cmm/ex/visitor/CheckVisitorNew.do" />',
  				datatype:"text",
  				data: tblParam ,
  				success:function(data){
  					if(data.resultCode == "SUCCESS"){
  						if(sType == "in")
  	  						opener.fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000010890","입실처리 되었습니다")%>","success",1500);
  	  					else
  	  						opener.fnSetSnackbar("<%=BizboxAMessage.getMessage("TX000017929","퇴실처리 되었습니다")%>","success",1500);	
  						
  						opener.fnGetDataList();
  						self.close();
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


<div class="pop_wrap" style="width:443px;">
		<div class="pop_head">
			<c:if test="${paramMap.type == '1' }">
			<h1><%=BizboxAMessage.getMessage("","입실체크")%></h1>
			</c:if>
			<c:if test="${paramMap.type == '2' }">
			<h1><%=BizboxAMessage.getMessage("","퇴실체크")%></h1>
			</c:if>
			<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div>
		
		<div class="pop_con" style="height:135px;">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="20%"/>
						<col width="80%"/>
					</colgroup>
					<tr id="">
						<th colspan="1"><%=BizboxAMessage.getMessage("","방문일자")%></th>
						<td id="txtVisitDt" name="txtVisitDt"></td>
					</tr>
					<tr id="">
						<c:if test="${paramMap.type == '1' }">
						<th colspan="1"> <%=BizboxAMessage.getMessage("","입실시간")%></th>
						</c:if>
						<c:if test="${paramMap.type == '2' }">
						<th colspan="1"> <%=BizboxAMessage.getMessage("","퇴실시간")%></th>
						</c:if>
						<td>
							<input id="ddlStartHour" class="kendoComboBox" style="width:50px;"/> <%=BizboxAMessage.getMessage("TX000001228","시")%>
							<input id="ddlStartMin" class="kendoComboBox" style="width:50px;"/> <%=BizboxAMessage.getMessage("TX000001229","분")%>
						</td>
					</tr>
					<tr id="">
						<th colspan="1"><%=BizboxAMessage.getMessage("","표찰번호")%></th>
						<td><input type="text" id="txtVisitCardNo" name="txtVisitCardNo" onKeyup="fnCheckVisitCard()" style="width:100%"/><br /><p id="txtVisitCheck" style="margin-top:5px; color:red;"></p></td>
					</tr>
				</table>
			</div>
		</div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input id="btnSave" type="button" value="<%=BizboxAMessage.getMessage("","확인")%>"/>
			</div>
		</div>
	</div><!-- //pop_wrap -->
