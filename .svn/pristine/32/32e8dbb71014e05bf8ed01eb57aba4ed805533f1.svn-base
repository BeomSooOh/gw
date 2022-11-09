<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ page import="neos.cmm.util.BizboxAProperties"%>

<!DOCTYPE html>
<html>
<head>
    <script src="../js/kendoui/jquery.min.js"></script>
    <script>
    
    $(document).ready(function(){
    	
    	if('<%=BizboxAProperties.getCustomProperty("BizboxA.Cust.functionAdminKey").equals("99") %>' == "false"){
    		$("#divAdmin").show();
    	}
    });
    
    function createKey(){
    	
    	if($("#adminKey").val() == ""){
       		alert("check input value!");
       		return;
    	}else if($("#keyType").val() == "loginToken"){
    		if($("#loginId").val() == ""){
           		alert("check input value!");
           		return;
    		}
    	}else if($("#groupSeq").val() == ""){
    		alert("check input value!");
    		return;
    	}else if(($("#keyType").val() == "license" && ($("#groupCnt").val() == "" || $("#mailCnt").val() == ""))){
       		alert("check input value!");
       		return;
    	}else if(($("#keyType").val() == "masterPwd" && $("#masterPwd").val() == "")){
       		alert("check input value!");
       		return;
    	}
 		
    	var tblParam = {};
		tblParam.type = $("#keyType").val();
		tblParam.adminKey = $("#adminKey").val();
		tblParam.groupSeq = $("#groupSeq").val();
		tblParam.param1 = $("#groupCnt").val();
		tblParam.param2 = $("#mailCnt").val();
		tblParam.param3 = $("#masterPwd").val();
		
		if($("#keyType").val() == "loginToken"){
			tblParam.param1 = $("#loginId").val();
    	}	
		
		if($("#keyType").val() == "masterPwd"){
			tblParam.param1 = $("#masterPwdExpDt").val();
			
			if(tblParam.param1 != "" && tblParam.param1.length != 12){
	       		alert("check input value!");
	       		$("#masterPwdExpDt").focus();
	       		return;				
			}
			
			if(tblParam.param1.length == 12){
				
				tblParam.param1 = tblParam.param1.substr(0,4) + "-" + tblParam.param1.substr(4,2) + "-" + tblParam.param1.substr(6,2) + " " + tblParam.param1.substr(8,2) + ":" + tblParam.param1.substr(10,2);
				
				if(new Date(tblParam.param1).toString() == "Invalid Date"){
		       		alert("check input value!");
		       		$("#masterPwdExpDt").focus();
				}else{
					
					var expDate = new Date(tblParam.param1);
					
					tblParam.param1 = 
					leadingZeros(expDate.getFullYear(), 4) + '-' +
				    leadingZeros(expDate.getMonth() + 1, 2) + '-' +
				    leadingZeros(expDate.getDate(), 2) + ' ' +
				    leadingZeros(expDate.getHours(), 2) + ':' +
				    leadingZeros(expDate.getMinutes(), 2);
					
				}
			}
			
    	}
		
		$.ajax({
			type:"post",
		    url: '/gw/cmm/system/getAesEncDesResult.do',
		    async: false,
		    dataType: 'json',
		    data: tblParam,
		    success: function(result) { 
		    	$("#resultKey").html(result.result);
		    },
		    error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
	   });	 		
    }
    
    function leadingZeros(n, digits) {
    	  var zero = '';
    	  n = n.toString();

    	  if (n.length < digits) {
    	    for (i = 0; i < digits - n.length; i++)
    	      zero += '0';
    	  }
    	  return zero + n;
   	}
    
    function insertKey(){
    	
    	if($("#addKeyStr").val() == ""){
    		alert("check input value!");
    		$("#addKeyStr").focus();
    		return;
    	}
 		
		var tblParam = {};
		tblParam.functionKey = $("#addKeyStr").val();
		
		$.ajax({
			type:"post",
		    url: '/gw/cmm/system/updateDBLicenseKey.do',
		    async: false,
		    dataType: 'json',
		    data: tblParam,
		    success: function(result) { 
		    	$("#resultMsg").html(result.result);
		    },
		    error: function(xhr) { 
		    	$("#resultMsg").html("발급키가 유효하지 않습니다.");
		    }
	   });	 		
    }   
    
    function keyTypeChange(){
    	
    	var keyType = $("#keyType").val();
    	
    	$("[name=inputLi]").hide();
    	
    	if(keyType == "license"){
    		$("#goupSeqLi").show();
    		$("#groupCntLi").show();
    		$("#mailCntLi").show();
    	}else if(keyType == "masterPwd"){
    		$("#goupSeqLi").show();
    		$("#masterPwdLi").show();
    		$("#masterPwdExtDtLi").show();
    		
			var expDate = new Date();
			
			$("#masterPwdExpDt").val(
			leadingZeros(expDate.getFullYear(), 4) + 
		    leadingZeros(expDate.getMonth() + 1, 2) + 
		    leadingZeros(expDate.getDate(), 2) + "2400" 
		    //leadingZeros(expDate.getHours(), 2) + 
		    //leadingZeros(expDate.getMinutes(), 2)  		
    		);
    		
    	}else if(keyType == "loginToken"){
    		$("#loginIdLi").show();
    	}
    }

    </script> 
</head>
<body>
	<div id="divAdmin" style="display:none;">
	<h2>Key Generation(Douzone Manager Only)</h2>
	<form>
        <div id="example">
            	<ul id="fieldlist">
            		<li> 
            			Key Type : 
	                    <select id="keyType" name="" onchange="keyTypeChange();">
	                    	<option value="license">license</option>
	                    	<option value="masterPwd">masterPwd</option>
	                    	<option value="loginToken">loginToken</option>
	                    </select>
	                </li>
            		<li id="goupSeqLi" style="margin-top: 10px;" name="inputLi" > 
            			Group SEQ : 
	                    <input id="groupSeq" />
	                </li>
            		<li id="groupCntLi" style="margin-top: 10px;" name="inputLi" > 
            			GW Count : 
	                    <input id="groupCnt" />
	                </li>
            		<li id="mailCntLi" style="margin-top: 10px;" name="inputLi" > 
            			Mail Count : 
	                    <input id="mailCnt" />
	                </li>
            		<li id="masterPwdLi" style="margin-top: 10px; display:none;" name="inputLi" > 
            			Master Pwd : 
	                    <input id="masterPwd" />
	                </li>
            		<li id="masterPwdExtDtLi" style="margin-top: 10px; display:none;" name="inputLi" > 
            			Expiration date : 
	                    <input placeholder="yyyyMMddHHmm" id="masterPwdExpDt" />
	                </li>	                
            		<li id="loginIdLi" style="margin-top: 10px; display:none;" name="inputLi" > 
            			Login Id : 
	                    <input id="loginId" />
	                </li>	                
            		<li style="margin-top: 10px;"> 
            			Douzone Manager Key : 
	                    <input type="password" id="adminKey" />
	                </li>	                	                
            		<li style="margin-top: 10px;"> 
	                    <button id="selBtn1" type="button" onclick="createKey()" >request</button>
	                </li>
            		<li style="margin-top: 10px;"> 
            			Result Key : 
            			<text id="resultKey"></text>
	                </li>		                
            	</ul> 
        </div> 
        </form>
        </div>
	<h2>Key Registration(Customer)</h2>
	<form>
        <div id="example">
            	<ul id="fieldlist">
            		<li style="margin-top: 10px;"> 
            			Registration key : <input type="password" id="addKeyStr" />
            			<button id="selBtn2" type="button" onclick="insertKey()" >apply</button>
	                </li>
	               	<text id="resultMsg"></text>
            	</ul> 
        </div> 
        </form>        
</body>
</html>