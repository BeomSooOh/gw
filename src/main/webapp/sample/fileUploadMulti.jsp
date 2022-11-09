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
	<form id="form" name="form" method="post" action="/gw/cmm/file/attachFileUploadProc.do" enctype="multipart/form-data">
        <div id="example">
            	<ul id="fieldlist">  
            		<li> 
            			<label for="groupSeq">groupSeq</label>
	                    <input class="k-textbox" id="groupSeq" name="groupSeq" value="53" />
	                </li>
            		 
            		<li>
            			<label for="empSeq">empSeq</label>
	                    <input class="k-textbox" id="empSeq" name="empSeq" value="12222" />
	                </li>
            		
            		<li> 
            			<label for="pathSeq">pathSeq(절대경로. 코드로 관리)</label>
	                    <input class="k-textbox" id="pathSeq" name="pathSeq" value="500" />(게시판)
	                </li>
            		
            		<li>
            			<label for="relativePath">relativePath(상대경로)</label>
	                    <input class="k-textbox" id="relativePath" name="relativePath" value="" />
	                </li>
	                
	                <li>
            			<label for="dataType">dataType</label>
	                    <input class="k-textbox" id="dataType" name="dataType" value="json" />
	                </li>
            		 
            	</ul>

	            <div>
	                <div class="demo-section k-header">
	                    <input id="file1" name="file1" type="file" />
	                </div>
	            </div>
	             <div>
	                <div class="demo-section k-header">
	                    <input id="file2" name="file2"  type="file" />
	                </div>
	            </div>
	             <div>
	                <div class="demo-section k-header">
	                    <input id="file3" name="file3"  type="file" />
	                </div>
	            </div>
	            
	            <div id="imgContainer">
	            	<button type="submit">저장</button>
	            </div>
            </div> 
	</form>
	
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
