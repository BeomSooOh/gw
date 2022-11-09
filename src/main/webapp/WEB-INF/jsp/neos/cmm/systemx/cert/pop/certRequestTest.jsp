<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript" src="/gw/js/dext5editor/js/dext5editor.js"></script>

<script type="text/javascript">
	var formHtml = '';

   	$(document).ready(function() {
   		//버튼 이벤트
   		$(function () {
	        $("#btnSave").click(function () { fnSave(); });				//저장버튼
	        $("#btnClose").click(function () { fnClose(); });			//닫기버튼
        });
   		
   		//컨트롤초기화
   		fnControlInit();
   		
		//기본버튼
	    $(".controll_btn button").kendoButton();
	});//document ready end
	
	
	//저장
	function fnSave(){	        
    
	}
	
	
	//컨트롤 초기화
	function fnControlInit(){

	}   

	
	//닫기버튼
	function fnClose(){
		self.close();
	}
	
</script>

<script type="text/javascript">
    function fnEditorLoad() {
        if ($("#hidEditorState").val() != "1") {
            setTimeout('fnEditorLoad()', 500);
        }
        else {
            document.Editor.AllHtml = $("#txtContentText").val();
        }
    }
    
    
    function dext_editor_loaded_event(editor){ 
        if($('#editorForm').css("display")=="none"){                         
            $("#divFormContents").append($("#editorForm"));
            $("#editorForm").show();
        }
        if(mainHtml){
            DEXT5.setHtmlValueExWithDocType(formHtml, 'BizboxA');
        }
        alert("dext_editor_loaded_event");    
    }
    
    
    function setIFrameHeight(){
    	var oFrame = document.getElementById("iframeID");       
        contentHeight = oFrame.contentWindow.document.body.scrollHeight;
        oFrame.style.height = String(contentHeight + 30) + "px";  
        $("#iframeID").css("overflow", "hidden");
    }
</script>


<div class="pop_wrap">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016123","증명서출력")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
				
	<div id="editorForm" style="height: 500px;">
        <script type="text/javascript">
	        //DEXT5.config.HandlerUrl = "/eap/ea/eadocpop/Dext5ImageUpload.do";
	        //DEXT5.config.ServerDomain = "/";
	        new Dext5editor("BizboxA");
        </script>
    </div>
</div><!--// pop_wrap -->