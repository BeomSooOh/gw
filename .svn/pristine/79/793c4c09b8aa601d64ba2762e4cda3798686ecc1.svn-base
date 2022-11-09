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
    
    <script>
    
    	function userSelectPop() {
	    	var url = "http://172.16.111.23/gw/cmm/systemx/cmmCompDeptSelectPop.do?callback=callbackSelectUser";
	    	var pop = window.open("", "empInfoPop", "width=576,height=600,scrollbars=no");
					
			frmPop.target = "empInfoPop";
			frmPop.method = "post";
			frmPop.action = url;
			frmPop.submit(); 
			frmPop.target = ""; 
	    	    
	    	pop.focus();   
	     }
    	
    	function callbackSelectUser(data) {
    		
    		//var jsonStr = JSON.stringify(data);
    		
    		$("#selectUserList").val(data); 
    		  
    	}
    
    </script> 
</head> 
<body>
	<h2>공용 사용자 선택 팝업 예제</h2>
	<form id="frmPop" name="frmPop">  
        <div id="example">
        		<h4>하위 파라미터는 옵션입니다. 선택 결과는 json object가 아닌 json string으로 리턴합니다.</h4>
            	<ul id="fieldlist">  
            		<li> 
            			<label for="groupSeq">groupSeq</label>
	                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="" />
	                </li>
            		<li> 
            			<label for="bizSeq">bizSeq</label>
	                    <input class="k-textbox" id="bizSeq" name="bizSeq" value="" />
	                </li>
            		<li> 
            			<label for="compSeq">compSeq</label>
	                    <input class="k-textbox" id="compSeq" name="compSeq" value="" />
	                </li>
            		<li> 
            			<label for="mainDeptYn">mainDeptYn</label>
	                    <input class="k-textbox" id="mainDeptYn" name="mainDeptYn" value="" />
	                </li>
            		<li> 
            			<label for="selectUserList">selectUserList</label>
	                    <textarea class="k-textbox" id="selectUserList" name="selectUserList" value="" style="width:800px; height:400px"></textarea>
	                </li>  
            		
            	</ul> 
	            
            </div> 
	</form>
	            <div id="imgContainer"> 
	            	<button id="selBtn" type="button" onclick="userSelectPop()" class="k-primary">선택</button>
	            </div> 
	            
	            <script>
	          	  $("#selBtn").kendoButton();
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
        </div>


</body>
</html>
