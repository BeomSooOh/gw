<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<!DOCTYPE html>
<html>
<head>
    <title></title> 
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.common.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.default.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendo/kendo.dataviz.min.css' />" ></link>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/kendos/kendo.dataviz.default.min.css' />" ></link>	

     <script type="text/javascript" src="<c:url value='/js/kendo/jquery.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/kendo/kendo.core.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendo/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/kendo/cultures/kendo.culture.ko-KR.min.js'/>"></script>
</head>
<body> 
	<div id="example">
			<p>text1 : <input type="text" id="text1" value="" /></p>
			<p>text2 : <input type="text" id="text2" value="" /></p>
			<p>text3 : <input type="text" id="text3" value="" /></p>
			<p>text4 : <input type="text" id="text4" value="" /></p>
 
            <div id="window"></div>

            <span id="undo" style="display:none" class="k-button">Click here to open the window.</span>

            <script>
                $(document).ready(function() {
                    var window = $("#window"),
                        undo = $("#undo")
                                .bind("click", function() {
                                	var text1 = $("#text1").val();
                                	var text2 = $("#text2").val();
                                	var text3 = $("#text3").val();
                                	var text4 = $("#text4").val();
                                	window.data("kendoWindow").open();
                                	window.data("kendoWindow").refresh({
                                	    url: "getWindow.do",
                                	    data: {text1:text1,text2:text2,text3:text3,text4:text4}
                                	});
                                    undo.hide();
                                });

                    var onClose = function() {
                        undo.show();
                    }

                    window.kendoWindow({
                        width: "615px",
                        title: "Window Paramter",
                        content: "getWindow.do",
                        close: onClose
                    });
                });
            </script>

            <style>

                #example {
                    min-height: 840px;
                }

                #undo {
                    text-align: center;
                    position: absolute;
                    white-space: nowrap;
                    border-width: 1px;
                    border-style: solid;
                    padding: 2em;
                    cursor: pointer;
                }
            </style>
        </div>




</body>
</html>

