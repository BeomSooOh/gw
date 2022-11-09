<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="css/kendo/kendo.common.min.css" />
    <link rel="stylesheet" href="css/kendo/kendo.default.min.css" />
    <link rel="stylesheet" href="css/kendo/kendo.dataviz.min.css" />
    <link rel="stylesheet" href="css/kendo/kendo.dataviz.default.min.css" />

    <script src="js/kendo/jquery.min.js"></script>
    <script src="js/kendo/jszip.min.js"></script>
    <script src="js/kendo/kendo.all.min.js"></script>
</head>
<body>
<div id="example">
    <div id="grid" style="width: 900px"></div>
    <script>
        $("#grid").kendoGrid({
            toolbar: ["excel"],
            excel: {
                fileName: "Kendo UI Grid Export.xlsx",
                proxyURL: "http://demos.telerik.com/kendo-ui/service/export",
                filterable: true
            },
            dataSource: {
                type: "odata",
                transport: {
                    read: "http://demos.telerik.com/kendo-ui/service/Northwind.svc/Products"
                },
                schema:{
                    model: {
                        fields: {
                            UnitsInStock: { type: "number" },
                            ProductName: { type: "string" },
                            UnitPrice: { type: "number" },
                            UnitsOnOrder: { type: "number" },
                            UnitsInStock: { type: "number" }
                        }
                    }
                }, 
                pageSize: 7
            },
            sortable: true,
            pageable: true,
            groupable: true,
            filterable: true,
            columnMenu: true,
            reorderable: true,
            resizable: true,
            columns: [ 
                { width: 300, locked: true, field: "ProductName", title: "Product Name"},
                { width: 300, field: "UnitPrice", title: "Unit Price"},
                { width: 300, field: "UnitsOnOrder", title: "Units On Order"},
                { width: 300, field: "UnitsInStock", title: "Units In Stock"}
            ]
        });

    </script>
</div>


</body>
</html>

