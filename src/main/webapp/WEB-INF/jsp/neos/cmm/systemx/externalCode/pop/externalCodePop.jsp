<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	var callbackData = {};
	var codeArray = new Array();
    var nameArray = new Array();
    var searchArray = new Array();
    var customCd = "${customCd}";
    var callback = "${fnCallback}";
    var returnData = '${returnData}';
    
	$(document).ready(function() {
		// 최초 값 가져오기
		fnInitPage();
		
		// 버튼 이벤트
		fnButtonInit();
		
		// 리사이즈
		fnSetResize();
		
		$(".pop_con").css("padding", 0);
				
	});
	
	// 버튼이벤트 정의
	function fnButtonInit() {
		$("#searchButton").click(function() {
			fnGetList();
		});
		
		// 그룹코드 선택
		$("#codeList").on("click", "tr", function(){
			onSelect(this);
		});
		
		// 반영버튼
		$("#btnSave").click(function() {
			fnSave();
		});
		
		// 취소버튼
		$("#btnCancel").click(function() {
			self.close();
		});
		
		$(".searchInput").keydown(function(e) { 
			if (e.keyCode == 13) {
				fnGetList();
			}
		});
		
		
	}
	
	// 외부코드 가져오기
	function fnInitPage() {
		var params = {};
		
		params.customCd = customCd;
		
		$.ajax({
			type : "POST",
			data : params,
			async : false,
			url : '<c:url value="/cmm/systemx/item/getExternalCodeInfo.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result));
				fnDrawPage(result.result);
				fnGetList();
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
    function fnDrawPage(res) {
    	//console.log(JSON.stringify(res));
        $("#lbtitle").text(res.customNm);
        $("#hidDisplayType").val(res.displayType);
        $("#hidCode").val(res.code);
        $("#hidSearch").val(res.search);
        $("#hidReturnCode").val(res.returnCode);
        $("#hidReturnCodeOutput").val(res.returnCodeOutputForm);
        
        codeArray = res.code.split(',');
        nameArray = res.name.split(',');
        searchArray = res.search.split(',');
        
        //검색어 영역 생성
        if (res.search != null && res.search.trim() != "") {
            var addHtml = '';
            for (var i = 0; i < searchArray.length; i++) {
                var text = "검색어";
                for (var j = 0; j < codeArray.length; j++) {
                    if(searchArray[i] == codeArray[j]) { 
                    	text = nameArray[j];
                   	}
                }
                addHtml += '<dt>'+ text +'</dt>';
                addHtml += '<dd><input type="text" class="searchInput" id="txtSearch'+ i.toString() +'" style="width:100px;"/></dd>';
             }
             addHtml += '<dd><input type="button" id="searchButton" value="검색" /></dd>';
//             $("#divSearchBox").html(addHtml);
//             $("#divSearchBox").show();
			$("#searchArea").html(addHtml);
        }
    }
	
	
    function fnGetList() {
        var tblParam = {};
        tblParam.customCd = customCd;
        tblParam.sSearchText = "";
        var searchArray = $("#hidSearch").val().split(',');
        try{
            for (var i = 0; i < searchArray.length; i++) {
                if(i == 0)
                {
                	tblParam.sSearchText += $("#txtSearch"+i.toString()).val();	
                }
                else
                {
               		tblParam.sSearchText += "▥" + $("#txtSearch"+i.toString()).val();
                }
            }
        }catch (err) {
        	console.log(err);//오류 상황 대응 부재
		}

        var url = '<c:url value="/cmm/systemx/item/getCustomInfoQuery.do" />';

        $.ajax
	    ({
	        type: "POST"
		    , dataType: "json"
		    , url: url
	        , data: tblParam
		    , success: function (res) {
		    	//console.log(JSON.stringify(res));

		    	fnBindList(res.result, res.codeInfo.selectMode);
		    }
		    , error: function (res) {
		        // 실패
		        //alert("실패");
		    }
	    });
    }	
    
    function returnDataStr(isEquals){
    	var returnCodeValue = $("#hidReturnCode").val().split(',');
    	var returnCD = $("#hidReturnCodeOutput").val();
    	var equalStr = JSON.parse(isEquals);
    	
    	var temp = returnCD;
		for (var i = 0; i < returnCodeValue.length; i++) {
			var tmp = "▥" + returnCodeValue[i] + "▥";
			temp = temp.replace(tmp, equalStr[returnCodeValue[i]]);
		}
    	
    	if(returnData){
    		
    		var checkData = $.parseJSON(returnData);
    		var returnStr = '';
    		for(var i = 0; i < checkData.length; i ++){
    			if(checkData[i] == temp){
    				return true; 
    			}
    		}
    	}
    	return false;
    }
	
	function fnBindList(data, selectMode) {
		//console.log($.parseJSON(returnData));
// 		console.log(JSON.stringify(data));
// 		console.log(selectMode);
		var headTag = '';
		var contentTag = '';		
		
		var contentArray = new Array();
		
		headTag += '<colgroup>';
		
		if(selectMode == "m") {
			headTag += '<col width="34"/>';
		}
		
		for(var i=0; i<nameArray.length; i++) {
			headTag += '<col width=""/>';
		}
		headTag += '</colgroup>';
		
		headTag += '<tr>';
		
		if(selectMode == "m") {
			headTag += '<th>';
			headTag += '<input type="checkbox" id="allCheck" onClick="javascript:fnAllcheck(this);"/> <label for="allCheck"></label>';
			headTag += '</th>';
		}
		
		for(var i=0; i<nameArray.length; i++) {
			headTag += '<th>' + nameArray[i] + '</th>';	
		}
		headTag += '</tr>';

		
		
		contentTag += '<colgroup>';
		
		if(selectMode == "m") {
			contentTag += '<col width="34"/>';
		}
		
		
		for(var i=0; i<codeArray.length; i++) {
			contentTag += '<col width=""/>';
		}
		contentTag += '</colgroup>';
		
		
		for(var j=0; j<data.length; j++) {
			
			var returnBoolean = false;
			if(returnDataStr(JSON.stringify(data[j]))){
				returnBoolean = true;
			}
			
			var trClass = '';
			if(returnBoolean){
				trClass = 'on';
			}
			
			contentTag += '<tr selectMode=' + selectMode + ' value=\'' + JSON.stringify(data[j]) + '\' class=\''+trClass+'\'>';
			for(var i=0; i<codeArray.length; i++) {
				if(i==0 && selectMode == "m") {
					contentTag += '<td>';
					if(returnBoolean){
						contentTag += '<input name="codeListCheck" type="checkbox" onClick="javascript:fnCheckClick(this);" id="code_' + j + '" checked/> <label for="code_' + j + '"></label>';
					}else{
						contentTag += '<input name="codeListCheck" type="checkbox" onClick="javascript:fnCheckClick(this);" id="code_' + j + '"/> <label for="code_' + j + '"></label>';
					}
					contentTag += '</td>';
				}
				contentTag += '<td>' + data[j][codeArray[i]] + '</td>';	
			}
			
			contentTag += '</tr>';
		}
		
		
		$("#codeHeader").html(headTag);
		$("#codeList").html(contentTag);
	}
	
	
	// table row 클릭 시 이벤트
	var multiValue = [];
	function onSelect(data) {
		
		externalCode = $(data).attr("value");
		var selectMode = $(data).attr("selectMode");
		//console.log(externalCode);
		
		if(selectMode != 'm') {
			externalCode = $(data).attr("value");
		} else {
			//externalCode = $(data).attr("value");
			//multiValue.push(JSON.parse(externalCode));
		}
		
		if(selectMode != 'm') {
			$("#codeList tr").removeClass("on");	
		}
		
		if(selectMode != 'm') {
			$(data).addClass("on");	
		}
		
	}
	
	function fnSave() {
		//var valueObj = JSON.parse(externalCode);
		var returnValue = new Array();
		var ReturnVal = $("#hidDisplayType").val();
        var returnCode = $("#hidCode").val().split(',');
        var returnCodeValue = $("#hidReturnCode").val().split(',');
        var returnCD = $("#hidReturnCodeOutput").val();
        

       	$("#codeList tr").each(function(){
       		if($(this).hasClass("on")) {
       			multiValue.push(JSON.parse($(this).attr("value")));
       		}
       	});
        

       	// 전자결재 양식값 노출데이터 만들기
        var returnForm = '';
        for(var j = 0; j < multiValue.length; j++) {
			var temp = ReturnVal;
			for (var i = 0; i < returnCode.length; i++) {
				var tmp = "▥" + returnCode[i] + "▥";
				temp = temp.replace(tmp, multiValue[j][returnCode[i]]);
			}
			
			returnForm += temp + ",";
			
        }
        
        // returnCD 만들어주기
		for(var j = 0; j < multiValue.length; j++) {
			var temp = returnCD;
			for (var i = 0; i < returnCodeValue.length; i++) {
				var tmp = "▥" + returnCodeValue[i] + "▥";
				temp = temp.replace(tmp, multiValue[j][returnCodeValue[i]]);
			}
			returnValue.push(temp);
        }


        callbackData.returnVal = returnForm.slice(0, -1);
        callbackData.returnCD = returnValue;

        window.opener[callback](callbackData);
		
        window.close();
	}
	
	// 전체 체크 박스 
	function fnAllcheck(data) {
		// 전체 클릭 이벤트
		if($(data).is(":checked")) {
			$("input[name=codeListCheck]").prop("checked", true);
			$("#codeList tr").addClass("on");
			
		} else {
			$("input[name=codeListCheck]").prop("checked", false);
			$("#codeList tr").removeClass("on");
		}
		
	}
	
	// 체크박스 선택시
	function fnCheckClick(data) {
		if($(data).is(":checked")) {
			var id = $(data).attr("id");
			$(data).closest("tr").addClass("on");
			
		} else {
			var id2 = $(data).attr("id");
			$(data).closest("tr").removeClass("on");
		}
	}
	

	// 팝업 크기 조절
	function fnSetResize() {
		$(".location_info").css("display", "none");
		$(".iframe_wrap").css("padding", "0");

		var strWidth = $('.pop_wrap').outerWidth()
				+ (window.outerWidth - window.innerWidth);
		var strHeight = $('.pop_wrap').outerHeight()
				+ (window.outerHeight - window.innerHeight);

		$('.pop_wrap').css("overflow", "auto");
		//$('.jstreeSet').css("overflow","auto");

		var isFirefox = typeof InstallTrigger !== 'undefined';
		var isIE = /*@cc_on!@*/false || !!document.documentMode;
		var isEdge = !isIE && !!window.StyleMedia;
		var isChrome = !!window.chrome && !!window.chrome.webstore;

		if (isFirefox) {

		}
		if (isIE) {
			//$(".pop_foot").css("width", strWidth);
		}
		if (isEdge) {

		}
		if (isChrome) {
		}

		try {
			window.resizeTo(strWidth, strHeight);
		} catch (exception) {
			console.log('window resizing cat not run dev mode.');
		}
	}
</script>


<input type="hidden" id="hidSearch" name="hidSearch" /> 
<input type="hidden" id="hidCode" name="hidCode" /> 
<input type="hidden" id="hidDisplayType" name="hidDisplayType" /> 
<input type="hidden" id="hidReturnCode" name="hidReturnCode" />
<input type="hidden" id="hidReturnCodeOutput" name="hidReturnCodeOutput" /> 

<div class="pop_wrap resources_reservation_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000020969","외부시스템")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<!-- //pop_head -->

	<div class="pop_con">
					<div class="p15 Pop_border">
						<p class="tit_p"><%=BizboxAMessage.getMessage("TX900000458","외부시스템연동 코드 목록")%></p>

						<div class="top_box">
							<dl id="searchArea">
<!-- 								<dt>부서명</dt> -->
<!-- 								<dd><input type="text" style="width:100px;"/></dd> -->
<!-- 								<dt>직급</dt> -->
<!-- 								<dd><input type="text" style="width:100px;"/></dd> -->
<!-- 								<dt>재직여부</dt> -->
<!-- 								<dd><input id="combo_sel1" style="width:100px;"/></dd> -->
<!-- 								<dt>사원명</dt> -->
<!-- 								<dd><input type="text" class=""id="text_input" style="width:120px;text-indent:8px;"/></dd> -->
<!-- 								<dd><input type="button" id="searchButton" value="검색" /></dd> -->
							</dl>
						</div>

						<div class="com_ta2 sc_head mt14" style="">
							<table id="codeHeader">
<%-- 								<colgroup> --%>
<%-- 									<col width="" /> --%>
<%-- 									<col width="" /> --%>
<%-- 								</colgroup> --%>
<!-- 								<tr> -->
<%-- 									<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th> --%>
<%-- 									<th><%=BizboxAMessage.getMessage("","코드명")%></th> --%>
<!-- 								</tr> -->
							</table>
						</div>

						<div class="com_ta2 ova_sc2 cursor_p bg_lightgray"
							style="height: 327px;">
							<table id="codeList">
<%-- 								<colgroup> --%>
<%-- 									<col width="" /> --%>
<%-- 									<col width="" /> --%>
<%-- 								</colgroup> --%>
								
<!-- 								<tr class="on"> -->
<!-- 									<td>1536</td> -->
<!-- 									<td>넥스트</td> -->
<!-- 								</tr> -->
								
							</table>
						</div>
				</div><!-- //Pop_border -->
	</div>
	<!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="btnSave" value="<%=BizboxAMessage.getMessage("TX000000423","반영")%>" /> 
			<input type="button" id="btnCancel" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div>
	<!-- //pop_foot -->
</div>
<!-- //pop_wrap -->