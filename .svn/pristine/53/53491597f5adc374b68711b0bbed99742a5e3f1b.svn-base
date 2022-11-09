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
</head>
<body>    
<h2>압축 file down</h2>
<div id="example">
    	<h4>Single 업로드</h4>
    	<form id="form" name="form" method="post" action="/gw/cmm/file/attachFileCompressProc.do">
    	<ul id="fieldlist">  
            <li>
    			<label for="fileId">fileId</label>
                <input class="k-textbox" id="fileId" name="fileId" value="" />
            </li>
            <li>
    			<label for="fileId">target</label>
                <input class="k-textbox" id="target" name="target" value="" />
            </li>
    		
    	</ul>
		</form>
        <button type="button" onclick="document.form.submit()">다운로드</button>
</div>


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