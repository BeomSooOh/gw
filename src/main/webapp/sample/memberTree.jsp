<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <link rel="stylesheet" href="../css/kendo/kendo.common.min.css" />
    <link rel="stylesheet" href="../css/kendo/kendo.default.min.css" />
    <link rel="stylesheet" href="../css/kendo/kendo.dataviz.min.css" />
    <link rel="stylesheet" href="../css/kendo/kendo.dataviz.default.min.css" />

    <script src="../js/kendo/jquery.min.js"></script>
    <script src="../js/kendo/kendo.all.min.js"></script>
</head>
<body>
        <div id="example">
            <div class="demo-section k-header">
                <div id="treeview"></div>
            </div>
            <script>
                    homogeneous = new kendo.data.HierarchicalDataSource({
                        transport: {
                            read: {
                                url: "memberTree.do", 
                                dataType: "jsonp"

                            } 
                        },  
                        schema: {
                            model: {
                                id: "seq",
                                hasChildren: "has_child"
                            } 
                        } 
                    });  

                $("#treeview").kendoTreeView({
                    dataSource: homogeneous,
                    dataTextField: "org_name" 
                }); 
            </script>

            <style>
                #example {
                    text-align: center;
                }

                .demo-section {
                    display: inline-block;
                    vertical-align: top;
                    width: 320px;
                    height:100%;
                    text-align: left;
                    margin: 0 2em;
                }
            </style>
        </div>


</body>
</html>
