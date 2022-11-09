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
            <div id="grid"></div>

            <script>
                $(document).ready(function () {
                    $("#grid").kendoGrid({
                        dataSource: {
                            type: "odata",
                            transport: {
                                read: "http://demos.telerik.com/kendo-ui/service/Northwind.svc/Customers"
                            },
                            pageSize: 20
                        },
                        height: 550,
                        groupable: true,
                        sortable: true,
                        pageable: {
                            refresh: true,
                            pageSizes: true,
                            buttonCount: 5
                        },
                        columns: [{
                            field: "ContactName",
                            title: "Contact Name",
                            width: 200
                        }, {
                            field: "ContactTitle",
                            title: "Contact Title"
                        }, {
                            field: "CompanyName",
                            title: "Company Name"
                        }, {
                            field: "Country",
                            width: 150
                        }]
                    });
                $("#grid thead [data-field=ContactName] .k-link").html("NewTitle");
                }); 
                
                
            </script>
</div>
</body>
</html>

