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
    
     function go() {
    	  var iframes = $("iframe");
		  var url = $("#requestPageUrl").val();
		   
		  var siteList = ["gwa.duzon.com", "gwa1.duzon.com", "gwa2.duzon.com"]; 
		   
		  for(var i = 0; i < iframes.length; i++) {
		    var iframe = iframes[i];
			
			  $(iframe).attr("src","http://" + siteList[i] + "/" + url);
			
		  }
     }
    </script> 
</head> 
<body>
	<h2>사이트 접속 확인</h2>
	<form id="frmPop" name="frmPop">  
        <div id="example">
        		<h4></h4>
            	<ul id="fieldlist">  
            		<li> 
            			<label for="requestPageUrl">requestPageUrl</label> 
	                    <input class="k-textbox" id="requestPageUrl" name="requestPageUrl" value="/gw/test.jsp" style="width:600px"/> 
	                    <button id="selBtn" type="button" onclick="go()" class="k-primary">선택</button>
	                </li>
            	</ul> 
            </div> 
	</form>
	
	
	<table>
		<tr>
			<th colspan="2">
				gwa.duzon.com
			</th>
		</tr>
		<tr>
			<td colspan="2"><iframe style="width:600px;height:310px"></iframe>
			</td>
		</tr>
		<tr>
			<th>
				gwa1.duzon.com
			</th>
			<th>
				gwa2.duzon.com
			</th>
		</tr>
		<tr>
			<td><iframe style="width:300px;height:300px"></iframe>
			</td>
			<td><iframe style="width:300px;height:300px"></iframe>
			</td>
		</tr>
		
	</table>
	
	            
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
