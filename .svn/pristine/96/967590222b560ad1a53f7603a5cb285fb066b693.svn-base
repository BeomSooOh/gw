<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="../css/kendoui/kendo.common.min.css" />
    <link rel="stylesheet" href="../css/kendoui/kendo.default.min.css" />

    <script src="../js/kendoui/jquery.min.js"></script>
    <script src="../js/kendoui/kendo.all.min.js"></script>
    
    <script>
    
    var type = 0;
    
    	function sync1() {
	    	var url = "/edms/home/convOrgChart.do";
	    	var params = "groupSeq="+$("#groupSeq").val();
	    	params += "&compSeq="+$("#compSeq").val();
	    	
	    	$("#iframe").attr("src", url+"?"+params);
	     }
    
    	function sync2() {
	    	var url = "/edms/home/convOrgPosi.do";
	    	var params = "groupSeq="+$("#groupSeq").val();
	    	params += "&compSeq="+$("#compSeq").val();
	    	
	    	$("#iframe").attr("src", url+"?"+params);
	     }
    
    	function sync3() {
	    	var url = "/edms/home/convUser.do";
	    	var params = "groupSeq="+$("#groupSeq").val();
	    	params += "&compSeq="+$("#compSeq").val();
	    	
	    	$("#iframe").attr("src", url+"?"+params);
	     }
    </script> 
</head> 
<body>
	<h2>공용 사용자 선택 팝업 예제</h2>
	<form id="frmPop" name="frmPop">  
        <div id="example">
        		<h4>하위 파라미터는 옵션입니다. 선택 결과는 json object 리턴합니다.</h4>
            	<ul id="fieldlist">
            		<li> 
            			<label for="groupSeq">groupSeq</label>
	                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="duzon" /> ※ 필수
	                </li>
            		<li> 
            			<label for="compSeq">compSeq</label>
	                    <input class="k-textbox" id="compSeq" name="compSeq" value="6" /> ※ 회사시퀀스 없으면 해당하는 그룹의 회사 전체 동기화
	                </li>
	                  
            		<li> 
            			<label for="popUrlStr">동기화</label> 
	                    <button id="selBtn1" type="button" onclick="sync1()" class="k-primary">조직도 동기화</button>
	                    <button id="selBtn2" type="button" onclick="sync2()" class="k-primary">직책 동기화</button>
	                    <button id="selBtn3" type="button" onclick="sync3()" class="k-primary">사원 동기화</button>
	                </li>
            	</ul> 
            </div> 
	</form>
	            <div id="imgContainer"> 
	            	<iframe id="iframe" src="" width="100%" height="200px" frameborder="0" scrolling="yes"></iframe>
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