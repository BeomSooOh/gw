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
   		
   		if("${printAuth}" == "N"){
   			alert("<%=BizboxAMessage.getMessage("TX000017935","이미 출력된 증명서입니다.")%>");
   			fnClose();
   		}
   		
   		//버튼 이벤트
   		$(function () {
	        $("#btnPrint").click(function () { setCertificatePrintInfo(); });			//출력버튼
	        $("#btnClose").click(function () { fnClose(); });			//닫기버튼
        });
   		
   		//컨트롤초기화
   		fnControlInit();
   		
		//기본버튼
	    $(".controll_btn button").kendoButton();
	    
	});//document ready end
	
	
	function setCertificatePrintInfo(){
		var param = {};
		param.cerSeq = '${param.cerSeq}';
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/systemx/setCertificatePrintInfo.do"/>',
    		datatype:"json",
            data: param,
    		success: function (data) {
    			fnPrint();
   		    },
   		    error: function (result) { 
   		    	alert("<%=BizboxAMessage.getMessage("TX000016151","인증서 기본정보 가져오기에 실패 하였습니다.")%>"); 
  		    }
    	});
	}	
	
	//출력
	function fnPrint(){
		$(".pop_head").hide();
		
    	//브라우저별분기처리
        if (getInternetExplorerVersion() > -1) {
        	//IE6,IE7,IE8,IE9,IE10,IE11
        	try {
        		var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
                document.body.insertAdjacentHTML('beforeEnd', webBrowser);   
                
                //(6:인쇄/7:미리보기/8:페이지 설정)
                previewWeb.ExecWB(7, 1);
                previewWeb.outerHTML = "";
                self.close();
        	} catch (e) {
            	document.body.innerHTML = printArea.innerHTML;
            	window.print();
            	self.close();
       		}
        } else {
        	//Edge,크롬,사파리,파이어폭스,오페라
        	document.body.innerHTML = printArea.innerHTML;
        	window.print();
        	self.close();
        }
    }
	
	
	//브라우저체크 (-1이상이면 IE이다)
    function getInternetExplorerVersion() {
        var rv = -1;
        
        if (navigator.appName == 'Microsoft Internet Explorer') {
            var ua = navigator.userAgent;
            var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
            if (re.exec(ua) != null)
                rv = parseFloat(RegExp.$1);
        }
        else if (navigator.appName == 'Netscape') {
            var ua = navigator.userAgent;
            var re = new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})");
            if (re.exec(ua) != null)
                rv = parseFloat(RegExp.$1);
        }
        return rv;
    }
	
	
	//컨트롤 초기화
	function fnControlInit(){

	}   

	
	//닫기버튼
	function fnClose(){
		self.close();
	}
	
</script>


<div class="pop_wrap brn">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016123","증명서출력")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		<input id="btnPrint" type="button" value="<%=BizboxAMessage.getMessage("TX000001653","인쇄")%>" class="posi_ab" style="top:3px;right:10px;"/>
	</div>	
				
	<div id="printArea" class="">
		<div id="divForm" class="div_form" style="width: 647px;">
		   <div id="divFormBind" class="div_form_bind">${cInfo.formContent2}</div>
		</div>
	</div>
</div><!--// pop_wrap -->
<!-- 
<script>

var a = '${imgMap}';
console.log("a : "+a);
console.log(a.IMG_COMP_STAMP1.fileId);

</script> -->