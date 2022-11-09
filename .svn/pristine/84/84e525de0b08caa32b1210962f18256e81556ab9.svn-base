<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
    
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="../css/kendoui/kendo.common.min.css" />
    <link rel="stylesheet" href="../css/kendoui/kendo.default.min.css" />

    <script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
    
</head> 
<body>

		<h2>기본 팝업 종류</h2>
        <div id="example">
           <button type="button" class="k-primary" onclick="AlertBox()">Alert Box</button>
           <button type="button" class="k-primary" onclick="ConfirmBox()">Confirm Box</button>
           <button type="button" class="k-primary" onclick="PromptBox()">Prompt Box</button>
		</duv>              

            <script>
             	function AlertBox() {
             		alert("메세지 제공");
             	}
             	function ConfirmBox() {
             		var ret = confirm("작업을 계속 수행하시겠습니까?");
			        if(ret==true){
			               // ‘OK’  또는 ‘확인’ 버튼을 눌렀을때 수행
			        }else{
			               // ‘Cancel’ 또는 ‘취소’ 버튼을 눌렀을때 수행
			        }
             	}
             	function PromptBox() {
             		var ret = prompt("이름을 입력해 주십시요.");
			        if(ret!=null && ret!=""){
			        	alert("입력된 이름은 "+ret+" 입니다.");
			        }
             	}
                
            </script>
            
            <style>
                #fieldlist {
                    margin: 0;
                    padding: 0;
                }

                #fieldlist li {
                    list-style: none;
                    padding-bottom: .7em;
                    text-align: left;
                }

                #fieldlist label {
                    display: block;
                    padding-bottom: .3em;
                    font-weight: bold;
                    font-size: 12px;
                    color: #444; 
                }

                #fieldlist li.status {
                    text-align: center;
                }

                #fieldlist li .k-widget:not(.k-tooltip),
                #fieldlist li .k-textbox {
                    margin: 0 5px 5px 0;
                }
                
            </style>


</body>
</html>
