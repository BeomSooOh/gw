<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<!--css-->
<link rel="stylesheet" type="text/css" href="/gw/js/pudd/css/pudd.css">
<link rel="stylesheet" type="text/css" href="/gw/css/common.css">
<link rel="stylesheet" type="text/css" href="/gw/css/animate.css">
<link rel="stylesheet" type="text/css" href="/gw/css/re_pudd.css">

<!--js-->
<script type="text/javascript" src="/gw/js/pudd/js/pudd-1.1.167.min.js"></script>
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<script>

var wehagoJoinUrl;
var wehagoJoinCompSeq;
var iframeLoadComplite = false;
var progressCnt = 0;

$(document).ready(function() {
	if(opener != null && opener.wehagoJoinUrl != null && opener.wehagoJoinUrl != ""){
		wehagoJoinCompSeq = opener.wehagoJoinCompSeq;
		wehagoJoinUrl = opener.wehagoJoinUrl;
		$("#joinFrame").attr("src", wehagoJoinUrl);
	}
});

function linearBar(){
	progressCnt = 0;
	
	Pudd( "#ProgressBar" ).puddProgressBar({ 
		progressType : "linear"
	,	attributes : { style:"width:80%;" }
	,	strokeColor : "#00bcd4"	// progress 색상
	,	strokeWidth : "25px"	// progress 두께
	,	textAttributes : { style : "color:#fff;" }
	,	percentTextColor : "#000"
	,	percentTextSize : "26px"
	,	modal : true
	,	progressCallback : function( progressBarObj ) {
			if(progressCnt < 80){
				progressCnt++;
			}
			
			return progressCnt;
		}
	});
}

function joinFrameLoad(){
	if(!iframeLoadComplite){
		//위하고 가입콜백 체크시작
		setTimeout(function(){
			getWehagoJoinState();
		}, 1000);
		
		iframeLoadComplite = true;
	}
}

function getWehagoJoinState(){
	var tblParam = {};
	
	tblParam.compSeq = wehagoJoinCompSeq;
	
	$.ajax({
		type:"post",
		url:'/gw/systemx/getWehagoJoinState.do',
		datatype:"text",
		data:tblParam,
		success:function(data){
			if(data != null && data.resultCode == "C"){
				wehagoOrgSyncBtn.disabled = false;
				wehagoOrgSyncBtn.className = "submit";
				fnOpenerRefresh();
			}
			else{
				setTimeout(function(){
					getWehagoJoinState();
				}, 2000);
			}
		}
	});
}

function fnWehagoOrgSync(){
	linearBar();
	
	setTimeout(function(){
		var tblParam = {};
		
		tblParam.compSeq = wehagoJoinCompSeq;
		
		$.ajax({
			type:"post",
			url:'/gw/systemx/wehagoInsertOrgEmpChartAll.do',
			datatype:"text",
			data:tblParam,
			success:function(data){
				progressCnt = 100;
				
				setTimeout(function(){
					puddAlert("success", "조직도 연동이 완료되었습니다.<br>'WEHAGO > 서비스 사용설정' 메뉴에서 추가설정을 할 수 있습니다.", "self.close();");
				}, 1000);
				
				fnOpenerRefresh();
			},
			error: function (result) {
				progressCnt = 100;
				puddAlert("warning", "WEHAGO 서버연결이 원활하지 않습니다.<br>관리자에게 문의하세요.", "");
	 		}
		});
	}, 2000);
}

function fnOpenerRefresh(){
	if(opener != null && opener.gridRead != null){
		opener.gridRead();
	}
}

function fnCancel(){
	puddConfirm("WEHAGO 조직도 연동을 취소 하시겠습니까?", "fnOpenerRefresh();self.close();");
}

function puddConfirm(alertMsg, callback){
	var puddDialog = Pudd.puddDialog({
		width : "400"
	,	height : "100"
	,	message : {
			type : "question"
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
			,	{
					attributes : { style : "margin-left:5px;" }// control 부모 객체 속성 설정
				,	controlAttributes : { id : "btnCancel" }// control 자체 객체 속성 설정
				,	value : "취소"
				,	clickCallback : function( puddDlg ) {
						puddDlg.showDialog( false );
					}
				}
			]
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

<body>
	<div class="pop_wrap" style="border: none;">
		<div class="pop_head">
			<h1>WEHAGO 조직도연동</h1>
		</div>	
		
		<div class="pop_con">
			<div class="Pop_border p15 mb15 lh20" style="background:#f2f2f2;">
				<p class="text_blue fwb">[WEHAGO 서비스 이용 안내]</p>
				<p>WEHAGO가입 후 조직도 연동을 사용할 수 있습니다.  가입절차에 따라 진행해 주세요.</p>
			</div>
			
			<!-- 위하고 호출 -->
			<div style="width:100%; height:500px;">
				<iframe id="joinFrame" onload="joinFrameLoad();" src="" frameborder="0" width="100%" height="100%" marginwidth="0" marginheight="0" scrolling="yes"></iframe>
			</div>
		</div><!--// pop_con -->
	
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input id="wehagoOrgSyncBtn" type="button" disabled="true" class="puddSetup" onclick="fnWehagoOrgSync();" value="조직도연동" />
				<input type="button" class="puddSetup" onclick="fnCancel();" value="취소" />
			</div>
		</div><!-- //pop_foot -->
	</div><!--// pop_wrap -->
	
	<div id="ProgressBar"></div>
</body>