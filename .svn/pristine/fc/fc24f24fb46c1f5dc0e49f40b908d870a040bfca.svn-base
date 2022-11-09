<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@page import="main.web.BizboxAMessage"%>

	<!--css-->
	<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="/gw/js/Scripts/jqueryui/jquery-ui.css"/>
    	<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
	<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="/gw/js/pudd/Script/pudd/pudd-1.1.189.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="/gw/js/Scripts/jqueryui/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>


 <script type="text/javascript">
 	var compSeq = "${compSeq}";
	var saveYN = "${erpSyncAuto}";
	var saveFlag = "insert";
	var today = ConvertDateToString();
 
 
    $(document).ready(function() {
    	/* 이벤트 초기화 */
		fnButtonInit();
		
		/* 이미 저장된 값 있을 경우 데이터 셋팅 */
		if(saveYN == "Y") {
			saveFlag = "update";
			fnInit();	
		} else {
			saveFlag = "insert";
			
			var puddObj = Pudd( "#from_date" ).getPuddObject();
			if( ! puddObj ) return;
			
			puddObj.setDate( today );
			
			Pudd( '#noUseInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
		}
	});//-----// $(document).ready 끝

	
	
	/* 이벤트 초기화 */
	function fnButtonInit() {
		$("#saveButton").click(function() {
			fnSave();
		});
		
		$("#cancelButton").click(function(){
			self.close();
		});
		
		// Pudd 이벤트
		Pudd( "#repeatType" ).getPuddObject().on( "change", function( e ) {
			if($("#repeatType").val() == "m"){
				$("#repeat1").show();
				$("#repeat2").hide();
			}else {
				$("#repeat1").hide();
				$("#repeat2").show();
			}
		});
	}

	
	/* 이미 저장된 값 있을 경우 데이터 셋팅 */
	function fnInit() {
		var scheduleType = "${erpSyncAutoList.scheduleType}";
		
		if(scheduleType == "0") {			// 사용안함
			Pudd( '#noUseInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
		} else if(scheduleType == "1") {	// 매일
			Pudd( '#everyDayInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
			Pudd( "#everyDaySelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleTime}" );
		} else if(scheduleType == "2") {	// 매주
			Pudd( '#everyWeekInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
			Pudd( "#everyWeekSelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleWeek}" );
			Pudd( "#everyWeekTimeSelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleTime}" );
		} else if(scheduleType == "3") {	// 매월
			Pudd( '#everyMonthInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
			Pudd( "#everyMonthSelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleDay}" );
			Pudd( "#everyMonthTimeSelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleTime}" );
		} else if(scheduleType == "4") {	// 지정한 시간
			var scheduleTime = "${erpSyncAutoList.specialDay}";
			Pudd( '#specialDayInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( scheduleTime );
			Pudd( "#specialDateTimeSelect" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.scheduleTime}" );
		} else if(scheduleType == "5") {	// 반복
			Pudd( '#repeatInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( scheduleTime );
			Pudd( "#repeatType" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.repeatType}" );
			if("${erpSyncAutoList.repeatType}" == "m"){
				Pudd( "#repeatSelect1" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.repeatValue}" );
				$("#repeat1").show();
				$("#repeat2").hide();
			}else {
				Pudd( "#repeatSelect2" ).getPuddObject().setSelectedIndex( "${erpSyncAutoList.repeatValue}" );
				$("#repeat1").hide();
				$("#repeat2").show();
			}
			Pudd( "#from_date" ).getPuddObject().setDate( today );
		}else{
			Pudd( '#noUseInput' ).getPuddObject().setChecked( true );
			Pudd( "#from_date" ).getPuddObject().setDate( today );
		}
	}
	
	
	/* 스케줄러 데이터 저장  */
	function fnSave() {
		var param = {};
		var selectOption = $("input[name='day_sel']:checked").val();
		
		// 선택 값에 따른 데이터 가져오기
		if(selectOption == "noUse") {						// 사용안함
			param.time = "";
		} else if(selectOption == "everyDay") {				// 매일
			param.time = $("#everyDaySelect").val();
		} else if(selectOption == "everyWeek") {			// 매주
			param.week = $("#everyWeekSelect").val();
			param.time = $("#everyWeekTimeSelect").val(); 
		} else if(selectOption == "everyMonth") {			// 매월
			param.day = $("#everyMonthSelect").val();
			param.time = $("#everyMonthTimeSelect").val();
		} else if(selectOption == "specialDay") {			// 지정한 시간
			param.date = $("#from_date").val(); //.replace(/-/gi, "");
			param.time = $("#specialDateTimeSelect").val();
		} else if(selectOption == "repeatInput") {			// 반복(분/시간 마다)
			param.repeatType = $("#repeatType").val();
			param.time = "";
			if($("#repeatType").val() == "m"){
				param.repeatValue = $("#repeatSelect1").val();
			}else if($("#repeatType").val() == "h"){
				param.repeatValue = $("#repeatSelect2").val();
			}
			
		}
		
		param.selectOption = selectOption;
		param.compSeq = compSeq;
		param.saveFlag = saveFlag;
		
		
		$.ajax({
			type : "POST"
			, url : "<c:url value='/erp/orgchart/pop/erpSyncAutoSetSave.do'/>"
			, data : param
			, async : false
			, dataType : "json"
			, success : function(result) {
				setAlert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다")%>","success",true);
			}
			, error: function(result) {
				
			}
		});	
		
		
	}
	
	function ConvertDateToString(date) {
        var newDate = new Date();
        var year = null;
        var month = null;
        var day = null;

        if (date) {

            year = date.getFullYear();
            month = date.getMonth();
            day = date.getDate();
        } else {
            year = newDate.getFullYear();
            month = newDate.getMonth();
            day = newDate.getDate();
        }

        month = month + 1;
        if (month < 10) {
            month = "0" + month;
        }
        if (day < 10) {
            day = "0" + day;
        }

        return year.toString() + "-" + month.toString() + "-"
                + day.toString();
    };
	
    
    
    function setAlert(msg, type, closeFlag){
		//type -> success, warning		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';		
			
		var puddDialog = Pudd.puddDialog({	
			width : 500	// 기본값 300
		,	height : 100	// 기본값 400		 
		,	message : {		 
				type : type
				,content : titleStr
			},
			footer : {
				 
				buttons : [
					{
						attributes : {}// control 부모 객체 속성 설정
					,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
					,	value : '<%=BizboxAMessage.getMessage("TX000019752", "확인")%>'
					,	clickCallback : function( puddDlg ) {
							if(closeFlag){
								opener.firstList();
								self.close();
							}else{
								puddDialog.showDialog(false);
							}
						}
					}				
				]				
			}
		});			
		$("#btnConfirm").focus();	
	}
</script>

<body>
<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","자동 동기화 설정")%></h1>
		<a href="#n" class="clo"><img src="/gw/Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con posi_re">

			<div class="Pop_border p15 mb15 fwn_div" style="background:#f0f6fd;">
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","자동 동기화 사용중에는 수동 동기화가 불가합니다.")%></p>
				<p class="tit_p mb8"><%=BizboxAMessage.getMessage("","다음 스케줄 도달 시, 현재 동기화가 진행중인 경우 진행중인 동기화만 반영됩니다.")%></p>
				<p class="tit_p mb0"><%=BizboxAMessage.getMessage("","퇴사자의 경우, 자동 동기화 처리되지 않으며, 조직도 동기화 팝업에서 사용자 퇴사처리 진행 후 연동해야 합니다.")%></p>
			</div>
			
			<div class="com_ta6 bs_com_ta">
				<table>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000005964","사용안함")%>" id="noUseInput" value="noUse"/>
							</p>
						</td>
					</tr>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006594","매일")%>" id="everyDayInput" value="everyDay"/>
							</p>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000018694","시간")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="everyDaySelect"/>
										<option value="0000"  selected="selected">00:00</option>
										<option value="0100">01:00</option>
										<option value="0200">02:00</option>
										<option value="0300">03:00</option>
										<option value="0400">04:00</option>
										<option value="0500">05:00</option>
										<option value="0600">06:00</option>
										<option value="0700">07:00</option>
										<option value="0800">08:00</option>
										<option value="0900">09:00</option>
										<option value="1000">10:00</option>
										<option value="1100">11:00</option>
										<option value="1200">12:00</option>
										<option value="1300">13:00</option>
										<option value="1400">14:00</option>
										<option value="1500">15:00</option>
										<option value="1600">16:00</option>
										<option value="1700">17:00</option>
										<option value="1800">18:00</option>
										<option value="1900">19:00</option>
										<option value="2000">20:00</option>
										<option value="2100">21:00</option>
										<option value="2200">22:00</option>
										<option value="2300">23:00</option>
									</select>
								</dd>
							</dl>	
							<dl class="bs_at_dl">
								<dt style="width:153px;">* <%=BizboxAMessage.getMessage("","매일 1회 동기화")%></dt>
							</dl>						
						</td>
					</tr>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006594","매일")%>" id="repeatInput" value="repeatInput"/>
							</p>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000000466","단위")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="repeatType"/>
										<option value="m"><%=BizboxAMessage.getMessage("TX000001229","분")%></option>
										<option value="h"><%=BizboxAMessage.getMessage("TX000001228","시")%></option>
									</select>
								</dd>
							</dl>
							<dl class="bs_at_dl" id="repeat1">
								<dt><%=BizboxAMessage.getMessage("TX000001229","분")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="repeatSelect1"/>
										<option value="05">05</option>
										<option value="10">10</option>
										<option value="15">15</option>
										<option value="20">20</option>
										<option value="25">25</option>
										<option value="30">30</option>
										<option value="35">35</option>
										<option value="40">40</option>
										<option value="45">45</option>
										<option value="50">50</option>
										<option value="55">55</option>
									</select>
								</dd>
							</dl>
							<dl class="bs_at_dl" style="display:none;" id="repeat2">
								<dt><%=BizboxAMessage.getMessage("TX000020499","시간")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="repeatSelect2"/>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
										<option value="6">6</option>
										<option value="7">7</option>
										<option value="8">8</option>
										<option value="9">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
									</select>
								</dd>
							</dl>							
						</td>
					</tr>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006579","매주")%>" id="everyWeekInput" value="everyWeek"/>
							</p>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000000635","요일")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="everyWeekSelect"/>
										<option value="mon"  selected="selected"><%=BizboxAMessage.getMessage("TX000005657","월")%></option>
										<option value="tue"><%=BizboxAMessage.getMessage("TX000005658","화")%></option>
										<option value="wed"><%=BizboxAMessage.getMessage("TX000005659","수")%></option>
										<option value="thu"><%=BizboxAMessage.getMessage("TX000005660","목")%></option>
										<option value="fri"><%=BizboxAMessage.getMessage("TX000005661","금")%></option>
										<option value="sat"><%=BizboxAMessage.getMessage("TX000005662","토")%></option>
										<option value="sun"><%=BizboxAMessage.getMessage("TX000005656","일")%></option>
									</select>
								</dd>
							</dl>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000018694","시간")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="everyWeekTimeSelect"/>
										<option value="0000"  selected="selected">00:00</option>
										<option value="0100">01:00</option>
										<option value="0200">02:00</option>
										<option value="0300">03:00</option>
										<option value="0400">04:00</option>
										<option value="0500">05:00</option>
										<option value="0600">06:00</option>
										<option value="0700">07:00</option>
										<option value="0800">08:00</option>
										<option value="0900">09:00</option>
										<option value="1000">10:00</option>
										<option value="1100">11:00</option>
										<option value="1200">12:00</option>
										<option value="1300">13:00</option>
										<option value="1400">14:00</option>
										<option value="1500">15:00</option>
										<option value="1600">16:00</option>
										<option value="1700">17:00</option>
										<option value="1800">18:00</option>
										<option value="1900">19:00</option>
										<option value="2000">20:00</option>
										<option value="2100">21:00</option>
										<option value="2200">22:00</option>
										<option value="2300">23:00</option>
									</select>
								</dd>
							</dl>
						
						</td>
					</tr>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000006581","매월")%>" id="everyMonthInput" value="everyMonth"/>
							</p>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000000437","일")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="everyMonthSelect"/>
										<option value="01"  selected="selected">1</option>
										<option value="02">2</option>
										<option value="03">3</option>
										<option value="04">4</option>
										<option value="05">5</option>
										<option value="06">6</option>
										<option value="07">7</option>
										<option value="08">8</option>
										<option value="09">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
										<option value="25">25</option>
										<option value="26">26</option>
										<option value="27">27</option>
										<option value="28">28</option>
										<option value="29">29</option>
										<option value="30">30</option>
										<option value="31">31</option>
									</select>
								</dd>
							</dl>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000018694","시간")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="everyMonthTimeSelect"/>
										<option value="0000"  selected="selected">00:00</option>
										<option value="0100">01:00</option>
										<option value="0200">02:00</option>
										<option value="0300">03:00</option>
										<option value="0400">04:00</option>
										<option value="0500">05:00</option>
										<option value="0600">06:00</option>
										<option value="0700">07:00</option>
										<option value="0800">08:00</option>
										<option value="0900">09:00</option>
										<option value="1000">10:00</option>
										<option value="1100">11:00</option>
										<option value="1200">12:00</option>
										<option value="1300">13:00</option>
										<option value="1400">14:00</option>
										<option value="1500">15:00</option>
										<option value="1600">16:00</option>
										<option value="1700">17:00</option>
										<option value="1800">18:00</option>
										<option value="1900">19:00</option>
										<option value="2000">20:00</option>
										<option value="2100">21:00</option>
										<option value="2200">22:00</option>
										<option value="2300">23:00</option>
									</select>
								</dd>
							</dl>
						</td>
					</tr>
					<tr>
						<td>
							<p class="bs_radio_p">
								<input type="radio" name="day_sel" class="puddSetup" pudd-label="<%=BizboxAMessage.getMessage("TX000011068","날짜선택")%>" id="specialDayInput" value="specialDay"/>
							</p>
							<dl class="bs_at_dl">
								<dt></dt>
								<dd>
									<input type="text" value="2017-02-01" class="puddSetup" pudd-type="datepicker" pudd-style="width:125px;" id="from_date"/>
								</dd>
							</dl>
							<dl class="bs_at_dl">
								<dt><%=BizboxAMessage.getMessage("TX000018694","시간")%></dt>
								<dd>
									<select class="puddSetup" pudd-style="width:125px;" id="specialDateTimeSelect"/>
										<option value="0000"  selected="selected">00:00</option>
										<option value="0100">01:00</option>
										<option value="0200">02:00</option>
										<option value="0300">03:00</option>
										<option value="0400">04:00</option>
										<option value="0500">05:00</option>
										<option value="0600">06:00</option>
										<option value="0700">07:00</option>
										<option value="0800">08:00</option>
										<option value="0900">09:00</option>
										<option value="1000">10:00</option>
										<option value="1100">11:00</option>
										<option value="1200">12:00</option>
										<option value="1300">13:00</option>
										<option value="1400">14:00</option>
										<option value="1500">15:00</option>
										<option value="1600">16:00</option>
										<option value="1700">17:00</option>
										<option value="1800">18:00</option>
										<option value="1900">19:00</option>
										<option value="2000">20:00</option>
										<option value="2100">21:00</option>
										<option value="2200">22:00</option>
										<option value="2300">23:00</option>
									</select>
								</dd>
							</dl>
						
						</td>
					</tr>
				</table>
			
			</div>
			

	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="puddSetup submit" value="<%=BizboxAMessage.getMessage("TX000021432","확인")%>" id="saveButton"/>
			<input type="button" class="puddSetup" value="<%=BizboxAMessage.getMessage("TX000022128","취소")%>" id="cancelButton"/>
		</div>
	</div><!-- //pop_foot -->
</div><!--// pop_wrap -->

<div id="ProgressBar"></div>

</body>
</html>