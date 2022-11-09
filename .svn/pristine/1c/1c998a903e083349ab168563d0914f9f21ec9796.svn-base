<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <style>html { font-size: 14px; font-family: Arial, Helvetica, sans-serif; }</style>
    <title></title>
    <link rel="stylesheet" href="../css/kendoui/kendo.common-material.min.css" />
    <link rel="stylesheet" href="../css/kendoui/kendo.material.min.css" />

    <script src="../js/kendoui/jquery.min.js"></script> 
    <script src="../js/kendoui/kendo.all.min.js"></script>
</head>
<body>

        <div >
		    <div id="" class="">
            <h4>Customize your Kendo T-shirt</h4>
            <img id="tshirt" src="../content/web/combobox/tShirt.png" />
            <h4>T-shirt Fabric</h4>
                  <input id="fabric" />
     
            <h4 style="margin-top: 2em;">T-shirt Size</h4>
            <select id="size" placeholder="Select size..." style="width: 100%;" >
              <option>X-Small</option>
              <option>Small</option>
              <option>Medium</option>
              <option>Large</option>
              <option>X-Large</option>
              <option>2X-Large</option>
            </select>
     
            <button class="k-button k-primary" id="get" style="margin-top: 2em; float: right;">Customize</button>
        </div>
        <style>
           #tshirt {
               display: block;
               margin: 2em auto;
           }
           .k-readonly
           {
               color: gray;
           }
        </style>

            <script>
                $(document).ready(function() {
                    // create ComboBox from input HTML element
                    $("#fabric").kendoComboBox();

                    // create ComboBox from select HTML element
                    $("#size").kendoComboBox();

                    var fabric = $("#fabric").data("kendoComboBox");
					var select = $("#size").data("kendoComboBox");


					$("#get").click(function() {
					    alert('Thank you! Your Choice is:\n\nFabric ID: ' + fabric.value() + ' and Size: ' + select.value());
                    });
                });
            </script>
        </div>


</body>
</html>
