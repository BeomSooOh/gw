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
    		var formData = $("#frmPop").serialize();
    		var url = $("#url").val();
    		$.ajax({
    			type:"get",
    			url:"http://221.133.55.230"+url,
    			datatype:"json",
    			data: formData,
    			success:function(data){
    				callbackSelectUser(data);
    			},			
    			error : function(e){	//error : function(xhr, status, error) {
    				alert("error");	
    			}
    		});	   
	     }
    	
    	function callbackSelectUser(data) {
    		
    		//var jsonStr = JSON.stringify(data);
    		
    		$("#selectUserList").val(data); 
    		  
    	}
    
    </script> 
</head> 
<body>
	<h2>EDMS 문서 목록 조회</h2>
        <div id="example">
        	<ul id="fieldlist">  
	            		<li> 
	            			<label for="url">url</label>
	            			<select id="url" name="url">
	            				<option value="/edms/doc/getDocDirWebList.do">문서 카테고리 조회(웹)</option>
	            				<option value="/edms/doc/getBpmDirWebList.do">전자결재 카테고리 조회(웹)</option>
	            			</select>
		                </li>
		     </ul>
		<form id="frmPop" name="frmPop">  
	            	<ul id="fieldlist">  
	            		<li> 
	            			<label for="id">id</label>
		                    <input class="k-textbox" id="loginId" name="loginId" value="nana" />
		                </li>
	            		<li> 
	            			<label for="compSeq">compSeq</label>
		                    <input class="k-textbox" id="compSeq" name="compSeq" value="100084" />
		                </li>
	            		<li> 
	            			<label for="groupSeq">groupSeq</label>
		                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="53" />
		                </li>
	            		<li> 
	            			<label for="bizSeq">bizSeq</label>
		                    <input class="k-textbox" id="bizSeq" name="bizSeq" value="1100" />
		                </li>
	            		<li> 
	            			<label for="deptSeq">deptSeq</label>
		                    <input class="k-textbox" id="deptSeq" name="deptSeq" value="100084144" />
		                </li>
	            	</ul> 
		</form>
	</div>
	<div>
			<ul id="fieldlist">  
            		<li> 
            			<label for="selectUserList">selectUserList</label>
	                    <textarea class="k-textbox" id="selectUserList" name="selectUserList" value="" style="width:800px; height:400px"></textarea>
	                </li>  
            </ul>		
         </div>   		
            		
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
