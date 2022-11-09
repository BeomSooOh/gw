<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

$(document).ready(function() {
	var PimonAXObj;
	
	var url = "${url}";
	var loginId = "${loginId}";
	var fileNm = "${fileNm}";
	
	if(loginId == null || loginId == ""){
		alert("<%=BizboxAMessage.getMessage("TX000017930","파일 다운로드 권한이 없습니다.")%>");		
	}else{
		try{
			if(PimonAXObj == null)
			PimonAXObj = PimonAX.ElevatePimonX();			
			PimonAXObj.FileDownLoad(url, loginId, fileNm); // 다운로드파일경로, UserID			
		}catch(e){
			if(e.number != -2147023673)
			alert("<%=BizboxAMessage.getMessage("TX000017931","파일 다운로드는 IE브라우져에서만 가능합니다.")%>");			
		}
	}
	
	fnClose();
});		


function fnClose(){
	
	window.close();
// 	if (/MSIE/.test(navigator.userAgent)) { 
//         if(navigator.appVersion.indexOf("MSIE 7.0")>=0) { 
//             //IE7에서는 아래와 같이 
//             window.open('about:blank','_self').close(); 
//         } 
//         else { 
//             //IE7이 아닌 경우 
//             window.opener = self; 
//             self.close(); 
//         }                      
//     } else { 
//         window.name = '__t__'; 
//         var w = window.open('about:blank'); 
//         w.document.open(); 
//         w.document.write('<html><body><script type="text/javascript">function _(){var w=window.open("about:blank","'+window.name+'");w.close();self.close();}</'+'script></body></html>'); 
//         w.document.close(); 
//         w._(); 
//     }  
}

</script>

<OBJECT id="PimonAX"
		  classid="clsid:D5EC7744-CA4E-42C0-BF49-3A6F2B225A32"
		  codebase="/gw/js/activeX/plugin/PimonFileCtrl.cab#version=2017.1.3.1"
		  width=0 
		  height=0 
		  align=center 
		  hspace=0 
		  vspace=0
	>
	</OBJECT>

