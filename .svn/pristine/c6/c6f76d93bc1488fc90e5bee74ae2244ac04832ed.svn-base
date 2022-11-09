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

<form id="form" name="form" method="post" enctype="multipart/form-data" action="/gw/cmm/file/attachFileUploadProc.do">
		<h2>Kendo Upload 샘플</h2>
        <div id="example">
            <div style="width:50%;float:left">
            	<h4>Single 업로드</h4>
            	<ul id="fieldlist">  
            		<li> 
            			<label for="groupSeq">rest/web</label>
	                    <input class="k-radiobox" id="type" name="type"  type="radio" value="1" checked /> rest
	                    <input class="k-radiobox" name="type"  type="radio" value="1" /> web
	                </li>
            	
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
	                    <input class="k-textbox" id="pathSeq" name="pathSeq" value="500" />0 : 기본경로, 100 : 전자결재 영리, 200 : 전자결재 비영리, 300 : 업무관리, 400 : 일정, 500 : 게시판, 600 : 문서, 700 : 메일, 800 : 메신저, 900 : 이미지, 1000 : 노트
	                </li>
            		
            		<li>
            			<label for="relativePath">relativePath(상대경로)</label>
	                    <input class="k-textbox" id="relativePath" name="relativePath" value="" />
	                </li>
	                
	                <li>
            			<label for="dataType">dataType</label>
	                    <input class="k-textbox" id="dataType" name="dataType" value="json" />
	                </li>
	                
	                <li>
            			<label for="fileId">fileId(파일 추가시 입력)</label>
	                    <input class="k-textbox" id="fileId" name="fileId" value="" />
	                </li>
	                
	                <li>
            			<label for="fileSn">fileSn(파일 변경시 입력)</label>
	                    <input class="k-textbox" id="fileSn" name="fileSn" value="" />
	                </li>
            		
            	</ul>

	            <div>
	                <div class="demo-section k-header">
	                    <input name="files" id="files" type="file" />
	                </div>
	            </div>
	            <p>
	            <div>
	            	<button type="button" onclick="document.form.submit()">submit</button>
	            </div>
	            
	            <div id="imgContainer"></div>
            </div> 
            <div style="width:50%;float:left">
            <h4>Multi 업로드</h4>
            	<iframe src="fileUploadMulti.jsp" width="100%" height="1000px" frameborder="0" scrolling="yes"></iframe>
            </div>
</form>                
              

            <script>
             
                
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
