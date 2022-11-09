<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
    <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
	<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
	<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
	<%@page import="main.web.BizboxAMessage"%>
	 
	 
	 <!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/animate.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/re_pudd.css">
	    
    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jquery-1.9.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/Scripts/jqueryui/jquery-ui.min.js"></script>
   <script src="/gw/js/neos/NeosUtil.js"></script>
	 
	 
	 <script src="/gw/js/jquery.ucgridtable.1.0.js"></script>
	 <script src="/gw/js/neos/NeosUtil.js"></script>

    <script>
    $(document).ready(function() {
	    if("${loginVO.userSe}" == "MASTER"){
		 	// Data 생성
			var codeData = ${compListJson};
			 
			// Pudd DataSource 매핑
			var dataSourceComboBox = new Pudd.Data.DataSource({
			 
				data : codeData
			});
		    
			    Pudd( "#com_sel" ).puddComboBox({
					 
					attributes : { style : "width:200px;" }// control 부모 객체 속성 설정
				,	controlAttributes : { id : "exAreaSelectBox" }// control 자체 객체 속성 설정
				,	dataSource : dataSourceComboBox
				,	dataValueField : "compSeq"
				,	dataTextField : "compName"
				,	disabled : false
				,	scrollListHide : false
			 
					// Pudd SelectBox는 내부에서 UI 부분을 재구성하여 표현하는 관계로 제공되는 이벤트만 설정가능
					// 이벤트 설정을 하고자 하는 경우 아래 주석를 해제하고 해당 이벤트 설정하면 됨
					// 제공되는 이벤트 : change
				//,	eventCallback : {
				//		"change" : function( e ) {
				//			console.log( "change" );
				//		}
				//	}
			});

		    var puddObj = Pudd( "#com_sel" ).getPuddObject();
		    puddObj.addOption( "", "<%=BizboxAMessage.getMessage("TX000022293", "전체")%>", 0);
			    
			puddObj.setSelectedIndex(0);
	    }	    
	    gridRead();
	    $("#empCnt").html("${cntInfo.empCnt}");
	    $("#deviceCnt").html("${cntInfo.deviceCnt}");
    });
    
    function gridRead(){
    	var tblParam = {};
        tblParam.compSeq = "${loginVO.userSe}" == "MASTER" ? Pudd( "#com_sel" ).getPuddObject().val() : $("#com_sel").val();
        tblParam.txtEmpName = $("#txtEmpName").val();
        tblParam.txtDevType = $("#txtDevType").val();
        tblParam.status = "P";
    	
    	$.ajax({
 			type:"post",
 			url:'<c:url value="/cmm/systemx/selectDevUserInfoList.do" />',
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				$("#empCnt").html(data.cntInfo.empCnt);
 				$("#deviceCnt").html(data.cntInfo.deviceCnt);
 				setTable(data.devList)
 			}        		        	
 		});
    }
    
    function setTable(data){
    	$(".gt_paging").remove();
    	
	     $("#divTestArea").GridTable({
	     'tTablename': 'tableName'      // [*] 자동 생성될 테이블 명 기준 코드 (사용자 입력)
	     , 'nHeight' : '600'     
	     , 'nTableType': 1              // [*] 테이블 타입 1. 기본 그리드, 2. 상세 보기 지원 그리드
	     , 'bNoHover': true
	     , 'oNoData': {                 // 데이터가 존재하지 않는 경우 
	    		'tText': '<%=BizboxAMessage.getMessage("TX000010608", "데이터가 존재하지 않습니다")%>'      //  출력 텍스트 설정
	            // , 'tStyle': 'background:red;'       // 적용 스타일 설정
	        }
	     , 'oPage': {                   // 사용자 페이징 정보
	         'bPageOff': false               // 페이징 기능 감추기 여부
	         , 'nItemSize': 10               // 페이지별 아이템 갯수
	     }
	     , "data": data               // 그리드를 구성할 실제 데이터입니다.     
	     , "aoAutoMerge" : [{'no': '0', 'key' : 'compSeq'},{'no': '1', 'key' : 'empSeq'},{'no': '6', 'key' : 'empSeq'},{'no': '7', 'key' : 'empSeq'}]  // 컬럼 병합 
	     , "aoHeaderInfo": [			 // 테이블 헤더 정보입니다.
	     {                  
	         no: '0',                        // 컬럼 시퀀스입니다.
	         renderValue: "<%=BizboxAMessage.getMessage("TX000018429", "회사")%>",
	         colgroup: '1'
	     }, {
	         no: '1',
	         renderValue: "<%=BizboxAMessage.getMessage("TX000013628", "사원명(ID)")%>",
	         colgroup: '1'
	     }, {
	         no: '2',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000059", "인증기기 명칭")%>",
	         colgroup: '1'
	     }, {
	         no: '3',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000060", "인증기기 Type")%>",
	         colgroup: '1'
	     }, {
	         no: '4',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000069", "모바일 고유번호")%>",
	         colgroup: '2'
	     }, {
	         no: '5',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000034", "인증기기")%>",
	         colgroup: '1'
	     }, {
	         no: '6',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000070", "PIN번호")%>",
	         colgroup: '1'
	     }, {
	         no: '7',
	         renderValue: "<%=BizboxAMessage.getMessage("TX900000071", "승인이력")%>",
	         colgroup: '1'
	     }
	     ],
	     "aoDataRender": [                      
	   	 {   		 
	  		 no: '0',
	         render: 'compName'        // render 프로퍼티에는 동적으로 HTML을 함수로 그려주거나, data의 컬럼명을 지정가능합니다.
	   	 }, {
	         no: '1',
        	 render: function (idx, item) {           
          			return "<p style=\"cursor: pointer;\" onclick='openEmpProfileInfoPop(\"" + item.compSeq + "\",\"" + item.deptSeq + "\",\"" + item.empSeq + "\")'>" + item.reqId + "</p>";
	      	 }
	     }, {
	         no: '2',
	         render: function (idx, item) {   
	        	if(item.type == "1")
       				return '<img src="/gw/Images/ico/ico_phone.png" class="mr5">' + item.deviceName;
       			else
       				return '<img src="/gw/Images/ico/ico_phone_user.png" class="mr5">' + item.deviceName;
	      	 }
	     }, {
	         no: '3',
	         render: 'appName'
	     }, {
	         no: '4', 	
	         render: 'deviceNum',
	      	 align: 'center'
	     }, {
	         no: '5',
         	 render: function (idx, item) {           
          			return "<input type='button' name='inp_btn' class='' value='<%=BizboxAMessage.getMessage("TX900000068", "해지")%>' seq='" + item.seq + "' onclick='fnCancel(this)'></input>";
	      	 },	      	
	      	align: 'center'
	     }, {
	         no: '6',
	         render: function (idx, item) {           
       			return "<input type='button' name='inp_btn' class='' value='<%=BizboxAMessage.getMessage("TX000002960", "초기화")%>' empSeq='" + item.empSeq + "' onclick='fnInit(this)'></input>";
	      	 },	      	
	      	 align: 'center'
	     }, {
	         no: '7',
	         render: function (idx, item) {           
       			return "<input type='button' name='inp_btn' class='' value='<%=BizboxAMessage.getMessage("TX900000208", "이력")%>' empSeq='" + item.empSeq + "' onclick='fnHistory(this)'></input>";
	      	 },
	      	 align: 'center'
	     }
	     ]
	     , "fnRowCallBack": function (row, aData) {
	         $(row).css('height','54')
	     }
	     , "fnRowCallBackTotal": function (title, contents, aData) {
	         /* type 2 테이블 에서 사용, */
	         /* 총계 데이터 바인드 시점에서 로우 콜백 */
	     }
	     , "fnRowCallBackTitle": function (row, aData) {
	         /* type 2 테이블 에서 사용, */
	         /* 타이틀(좌) 데이터 바인드 시점에서 로우 콜백 */
	     }
	     , "fnRowCallBackContents": function (row, aData) {
	         /* type 2 테이블 에서 사용, */
	         /* 컨텐츠(우) 데이터 바인드 시점에서 로우 콜백 */
	     }     
	 });
    }
    
    
 
	 
	function fnCancel(e){
		var tblParam = {};
        tblParam.seqList = $(e).attr("seq");
        tblParam.type = "D";
    	
    	$.ajax({
 			type:"post",
 			url:'<c:url value="/cmm/systemx/userDeviceDisabled.do" />',
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				var contents = '<span class=""><%=BizboxAMessage.getMessage("TX900000072", "해지되었습니다.")%></span>';
 				setScAlert(contents, "success");
 			}        		        	
 		});
	}
	 
	function fnInit(e){
		var tblParam = {};
        tblParam.empSeq = $(e).attr("empSeq");
        tblParam.type = "I";
    	
    	$.ajax({
 			type:"post",
 			url:'<c:url value="/cmm/systemx/userDeviceDisabled.do" />',
 			datatype:"text",
 			data:tblParam,
 			success:function(data){
 				var contents = '<span class=""><span class="text_blue">[ <%=BizboxAMessage.getMessage("TX000000286", "사용자")%> : ' + data.empName + ' ]</span><br /><%=BizboxAMessage.getMessage("TX900000073", "PIN번호 초기화 완료되었습니다.")%></span>';
 				setScAlert(contents, "success");
 			}        		        	
 		});
	}
	
	function fnHistory(e){
		
		Pudd.puddDialog({
			width : 880	
		,	height : 458
		,	header : {
				title : "<%=BizboxAMessage.getMessage("TX000007570", "이력확인")%>"
			,	align : "left"	// left, center, right						
		}
		,	body : {			 
				iframe : true
			,	url : '<c:url value="/cmm/systemx/secondCertDescPop.do" />?targetEmpSeq=' + $(e).attr("empSeq") + '&type=H'	 
		}
		,	footer : {
	 
			buttons : [
				{
					attributes : {}// control 부모 객체 속성 설정
				,	controlAttributes : { id : "btnConfirm", class : "submit" }// control 자체 객체 속성 설정
				,	value : "<%=BizboxAMessage.getMessage("TX000019752", "확인")%>"
				,	clickCallback : function( puddDlg ) {
						puddDlg.showDialog( false );
					}
				}			
			]
		}
	});
// 		var url = '<c:url value="/cmm/systemx/secondCertDescPop.do" />?targetEmpSeq=' + $(e).attr("empSeq") + '&type=H';
// 		var w = 853;
// 		var h = 618;
// 		var left = (screen.width / 2) - (w / 2);
// 		var top = (screen.height / 2) - (h / 2);

// 		var pop = window.open(url, "popup_window", "width=" + w + ",height="
// 				+ h + ", left=" + left + ", top=" + top + "");
// 		pop.focus();
	}
	 
	 
    
	function setScAlert(msg, type){
		//type -> success, warning
		
		var titleStr = '';		
		titleStr += '<p class="sub_txt">' + msg + '</p>';

		
		var puddDialog = Pudd.puddDialog({	
				width : 400	// 기본값 300
			,	message : {		 
					type : type
				,	content : titleStr
				},
		footer : {
			 
			buttons : [
				{
					attributes : {}// control 부모 객체 속성 설정
				,	controlAttributes : { id : "alertConfirm", class : "submit" }// control 자체 객체 속성 설정
				,	value : "<%=BizboxAMessage.getMessage("TX000019752", "확인")%>"
				}
			]
		}
		});			
		$( "#alertConfirm" ).click(function() {
			gridRead();
			puddDialog.showDialog( false );			
		});			
	
	}
    
    
    </script>
    
</head>
<!-- 검색 -->
<div class="top_box">
	<dl>
		<c:if test="${loginVO.userSe == 'MASTER'}">
			<dt><%=BizboxAMessage.getMessage("TX000021270", "회사")%></dt>
			<dd>
				<div id="com_sel"></div>
			</dd>
		</c:if>
		<c:if test="${loginVO.userSe != 'MASTER'}">
			<input id="com_sel" type="hidden" value="${loginVO.organId}"></input>
		</c:if>
		
		<dt><%=BizboxAMessage.getMessage("TX000013628", "사원명(ID)")%></dt>
		<dd>
			<input id="txtEmpName" type="text" value="" style="width: 130px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}"/>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX900000060", "인증기기 Type")%></dt>
		<dd>
			<select class="puddSetup" pudd-style="width:100px;" id="txtDevType" />
				<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Phone">Phone</option>		
				<option value="Tablet">Tablet</option>
			</select>
		</dd>
		<dd>
			<input id="searchButton" type="button" value="<%=BizboxAMessage.getMessage("TX000001289", "검색")%>" onclick="gridRead();" />
		</dd>
	</dl>
</div>


<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="btn_div">
		<div class="left_div" style="margin-top: 10px">
			<p class="tit_p m0 mt5" id="cntInfoTag"><%=BizboxAMessage.getMessage("TX900000074","총 인증사용자")%> :  [ <span class="text_blue" id="empCnt">0</span> ] ,  <%=BizboxAMessage.getMessage("TX900000075", "총 인증기기")%> [ <span class="text_blue" id="deviceCnt" >0</span> ]</p>
		</div>
	</div>
	
	<div id="divTestArea" style="margin-top: 25px; overflow: hidden;border:1px solid #eaeaea;"></div>

	
</div>

</html>