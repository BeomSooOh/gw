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
			groupSeq
			<input id="groupSeq" />
			compSeq
			<input id="compSeq" />			
		</td>
		<td>
			구분
			<select id="achrGbn">
			  <option value="AC" selected="selected">ac</option>
			  <option value="HR">hr</option>
			  <option value="ETC">etc</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			QUERY
			<textarea style="width:100%; height: 400px;" id="query"></textarea>
		</td>
		<td>
			RESULT
			<textarea style="width:100%; height: 400px;" id="result"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="button" id="btnExecute" value="실행" onclick="fnExecute()">
		</td>
	</tr>	
</table>
</body>

	<script type="text/javascript">
		function fnExecute(){
			if($("#compSeq").val() == "" || $("#compSeq").val() == "query"){
				return;
			}
			
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val();
			tblParam.query = $("#query").val();
			tblParam.achrGbn = $("#achrGbn").val();
			
			
			$.ajax({
	            type:"post",
	            url:"/gw/queryExecute.do",
	            datatype:"json",
	            data: tblParam,
	            beforeSend: function() {	              
	                $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
	            },
	            success:function(data){
	            	$("#result").val(JSON.stringify(data.result));
	            }
	        });
		}
	</script>

</html> 

