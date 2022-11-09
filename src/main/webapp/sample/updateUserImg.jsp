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
	    function onSuccess(e) {
			if (e.operation == "upload") {
				var fileId = e.response.fileId;
				if (fileId != null && fileId != '') {
					var html = '';
					html += "<div style='float:left;padding-left:20px'>";
					html += "<a href='/gw/cmm/file/attachFileDownloadProc.do?fileId="+fileId+"&fileSn=0'>다운로드("+fileId+")</a>";
					html += "<p><img src='/gw/cmm/file/attachFileDownloadProc.do?fileId="+fileId+"&fileSn=0' width='150px' height='150px' /></p>";
					html += "</div>";
					$("#imgContainer").html(html);
				} else {
					alert(e.response);
				}
				
			}
		}  
    </script>
</head> 
<body>

		<h2>사용자 프로필 사진 업로드</h2>
        <div id="example">
            	<ul id="fieldlist">  
            		<li>
            			<label for="empSeq">empSeq</label>
	                    <input class="k-textbox" id="empSeq" name="empSeq" value="200753" />
	                </li>
            	</ul>

	            <div>
	                <div class="demo-section k-header">
	                    <input name="files" id="files" type="file" />
	                </div>
	            </div>
	            
	            <div id="imgContainer"></div>
            </div> 

            <script>
                $(document).ready(function() {
                    $("#files").kendoUpload({
                        async: {
                        	saveUrl: '/gw/UpdateUserImg.do',
                            autoUpload: true
                        },
                        showFileList: false,
                        upload:function(e) { 
							var empSeq = $("#empSeq").val();
							
							var params = "empSeq=" + empSeq;
							
                        	e.sender.options.async.saveUrl = '/gw/UpdateUserImg.do?'+params;
                        },
                        success: onSuccess 
                    });
                });
                
                
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
