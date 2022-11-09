<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<style>
table {width:100%;padding:0;marign:0;}
table td{vertical-align:top;padding:0;marign:0;}	
</style>
<body>
<table cellpadding="0"  cellspacing="0">
	<colgroup>
	 <col width="50%"/>
	 <col/>
	</colgroup>
	<tr>
		<td>
			QUERY
			<textarea style="width:100%; height: 400px;" onkeyup="convert();" id="query"></textarea>
		</td>
		<td rowspan="2">
			RESULT
			<textarea style="width:100%; height: 800px" readonly="readonly" id="result"></textarea>
		</td>
	</tr>
	<tr>
		<td>
			PARAMETER
			<textarea style="width:100%; height: 400px;" onkeyup="convert();" id="para"></textarea>
		</td>
	</tr>
</table>
</body>

	<script type="text/javascript">

		function convert(){
			var para = $("#para").val().split(", ");
			
			for(var i=0; i<para.length; i++){
				var imsi = para[i];
				imsi = imsi.substring(0, imsi.lastIndexOf("("));
				para[i] = imsi;
			}
			
			var result = $("#query").val();
			
			for(var i=0; i<para.length; i++){
				result = result.replace("?", "'" + para[i] + "'");
			}
			
			$("#result").val(result);
			
		}
	</script>

</html> 

