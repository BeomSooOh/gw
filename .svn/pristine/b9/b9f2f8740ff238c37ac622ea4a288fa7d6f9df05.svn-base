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
    
    var type = 0;
    
    	function userSelectPop() {
	    	var url = "../html/common/cmmOcPop.jsp";
	    	var pop = window.open("", "empInfo1Pop", "width=668,height=606,scrollbars=no");
					
			frmPop.target = "empInfo1Pop";
			frmPop.method = "post";
			frmPop.action = url; 
			frmPop.submit(); 
			frmPop.target = ""; 
	    	    
	    	pop.focus();   
	     }
    	
    	function callbackSel(data) {
    		
    		var jsonStr = JSON.stringify(data);
    		
    		$("#moduleType").val(data.moduleType); 
    		$("#selectType").val(data.selectType); 
    		$("#selectedList").val(JSON.stringify(data.selectedList)); 
    		$("#selectedOrgList").val(JSON.stringify(data.selectedOrgList)); 
    		type= JSON.stringify(data.type);
    	}
    	
    	function callbackSelectUser(data) {
    		
    		var jsonStr = JSON.stringify(data);
    		
    		$("#moduleType").val(data.moduleType); 
    		$("#selectType").val(data.selectType); 
    		$("#selectedList").val(JSON.stringify(data.selectedList)); 
    		$("#selectedOrgList").val(JSON.stringify(data.selectedOrgList)); 
    		type= JSON.stringify(data.type);
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
            			<label for="popUrlStr">popUrlStr</label> 
	                    <input class="k-textbox" id="popUrlStr" name="popUrlStr" value="/gw/cmm/systemx/cmmOcType1Pop.do" style="width:600px"/> 
	                    <button id="selBtn" type="button" onclick="userSelectPop()" class="k-primary">선택</button>
	                </li>
	                <li> 
            			<label for="type">callback</label>
	                     <input class="k-textbox" id="callback" name="callback" value="callbackSel" />
	                </li>  
	                <li> 
            			<label for="type">callbackUrl</label>
	                     <input class="k-textbox" id="callbackUrl" name="callbackUrl" style="width:600px" value="/gw/html/common/callback/callbackPop.jsp" />
	                </li> 
            		<li> 
            			<label for="mode">mode</label> 
	                    <input class="k-textbox" id="mode" name="mode" value="dev" /> ※ 운영서버에서는  제거
	                </li>
            		<li> 
            			<label for="groupSeq">groupSeq</label>
	                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="" /> ※ 운영서버에서는  제거  개발:dev, 데모:demo, 운영:duzon
	                </li>
            		<li> 
            			<label for="compSeq">compSeq</label>
	                    <input class="k-textbox" id="compSeq" name="compSeq" value="" /> ※ 운영서버에서는  제거 개발/데모/운영 더존비즈온 : 6
	                </li>
	                <li> 
            			<label for="deptSeq">deptSeq</label>
	                    <input class="k-textbox" id="deptSeq" name="deptSeq" value="" /> ※ 최초선택할 부서시퀀스 공용기술 파트 : 4516  
	                </li>
            		<li> 
            			<label for="langCode">langCode</label>
	                    <input class="k-textbox" id="langCode" name="langCode" value="kr" /> ※ 운영서버에서는  제거
	                </li>
            		<li> 
            			<label for="moduleType">moduleType</label>
	                     <input class="k-textbox" id="moduleType" name="moduleType" value="" /> e : 사원선택, d : 부서선택, ed : 사원, 부서 선택
	                </li>  
            		<li> 
            			<label for="selectType">selectType</label>
	                     <input class="k-textbox" id="selectType" name="selectType" value="" /> s : 단일선택, m : 다중선택
	                </li>  
            		<li> 
            			<label for="isGroupAll">isGroupAll</label>
	                     <input class="k-textbox" id="isGroupAll" name="isGroupAll" value="Y" /> Y : 그룹 하위 회사 모두 조회
	                </li>  
            		<li> 
            			<label for="selectedList">selectedList</label>
	                    <textarea class="k-textbox" id="selectedList" name="selectedList" value="" style="width:800px; height:100px"></textarea>
	                </li>  
            		<li> 
            			<label for="selectedOrgList">selectedOrgList</label>
	                    <textarea class="k-textbox" id="selectedOrgList" name="selectedOrgList" value="" style="width:800px; height:100px"></textarea>
	                </li>  
            		<li> 
            			<label for="duplicateOrgList">duplicateOrgList</label>
	                    <textarea class="k-textbox" id="duplicateOrgList" name="duplicateOrgList" value="" style="width:800px; height:100px"></textarea>
	                </li>  
            	</ul> 
            </div> 
	</form>
	            <div id="imgContainer"> 
	            
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
