<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	var driver = new Array();
	var url = new Array();
	
	driver[0] = "";
	driver[1] = "";
	driver[2] = "";
	
	url[0] = "";
	url[1] = "";
	url[2] = "";
		
		
	$(document).ready(function() {
			//기본버튼
			$(".controll_btn button").kendoButton();
				
			var ddlErpVersion = NeosCodeUtil.getCodeList("COM519"); 
 			var ddlDbType = NeosCodeUtil.getCodeList("COM520");
			
			for(var i=1;i<=3;i++){
				//ERP버전 셀렉트박스1~3
				
				if(i == 1){
					var ddlErpVersionCube = NeosCodeUtil.getCodeList("COM519");
					
					$("#erp_sel1").kendoComboBox({
						dataSource : ddlErpVersionCube,
				        dataTextField: "CODE_NM",
				        dataValueField: "CODE",
				        index: 0
					});					
				}else{
					$("#erp_sel" + i).kendoComboBox({
						dataSource : ddlErpVersion,
				        dataTextField: "CODE_NM",
				        dataValueField: "CODE",
				        index: 0
					});					
				}
				

				
				//db 셀렉트박스1~3
				$("#db_sel" + i).kendoComboBox({
					dataSource : ddlDbType,
			        dataTextField: "CODE_NM",
			        dataValueField: "CODE",
					value:"<%=BizboxAMessage.getMessage("TX000010777","사용할 DB를 선택하세요")%>"
				});
			}
			
			//기존 저장되어 있는 db연결정보 조회 및 셋팅.
			var tblParam = {};
			tblParam.compSeq = $("#compSeq").val();
			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/systemx/getDbConnectInfo.do"/>',
	    		datatype:"json",
	    		data: tblParam ,
	    		success: function (data) {
    				setDbConnectInfo(data);	    				
    		    } ,
			    error: function (result) { 
	    			alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
	    		}
	    	});
	});	
	
	
	
	function setDbConnectInfo(data){
		//회계부분
		if(data.acMap != null){
			//mssql일때 url정보에서 ip, db명 뽑아오기
			if(data.acMap.database_type == "mssql"){
				var strIdx = data.acMap.url.lastIndexOf('/');
				var endIdx = data.acMap.url.lastIndexOf(';');
				
				var dbNm = data.acMap.url.split('=');
				
				$("#dbName1").val(dbNm[1]);
				$("#dbAddr1").val(data.acMap.url.substring(strIdx+1, endIdx));				
				$("#db_sel1").data("kendoComboBox").value("mssql");
			}
			
			//mysql,maria 일때 url정보에서 ip, db명 뽑아오기
			else if(data.acMap.database_type == "mysql" || data.acMap.database_type == "mariadb"){
				var dbNm = data.acMap.url.split('/');
				
				$("#dbName1").val(dbNm[3]);
				$("#dbAddr1").val(dbNm[2]);
				if(data.acMap.database_type == "mysql")
					$("#db_sel1").data("kendoComboBox").value("mysql");
				else
					$("#db_sel1").data("kendoComboBox").value("mariadb");
			}
			
			//oracle일때 url정보에서 ip, db명 뽑아오기
			else if(data.acMap.database_type == "oracle"){
				var dbNm = data.acMap.url.split(':');
				var setDbNm = '';
				
				if(dbNm[5] != undefined) {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4] + ":" + dbNm[5]
				} else {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4]
				}
				
				$("#dbName1").val(dbNm[1]);
				$("#dbAddr1").val(setDbNm);
				$("#db_sel1").data("kendoComboBox").value("oracle");
			}
			
			driver[0] = data.acMap.driver;
			url[0] = data.acMap.url;
			$("#erp_comp1").val(data.acMap.erp_comp_seq + " " + data.acMap.erp_comp_name);
			$("#erp_compSeq1").val(data.acMap.erp_comp_seq);
			$("#erp_compName1").val(data.acMap.erp_comp_name);
			$("#dbLoginId1").val(data.acMap.userid);
			$("#dbLoginPwd1").val(data.acMap.password);
			$("#connectMsg1").html("! <%=BizboxAMessage.getMessage("TX000010776","연결 되었습니다")%>");
			$("#connectMsg1").prop("class", "lh24 ml10 text_blue");
			
			
			
			// ext_code 값 (히든값)
			if(data.acMap.ext_code != null || data.acMap.extcode != "") {
				$("#accountExtCode").val(data.acMap.ext_code);	
			}
			
			if(data.acMap.erp_type_code == "ERPiU"){
				$("#erp_sel1").data("kendoComboBox").value("1001");
			}
			else if(data.acMap.erp_type_code == "iCUBE"){
				
				if(data.acMap.g20_yn == "Y"){
					$("#erp_sel1").data("kendoComboBox").value("G20");	
				}else{
					$("#erp_sel1").data("kendoComboBox").value("1000");	
				}
			}
		}
		
		//인사부분
		if(data.hrMap != null){
			//mssql일때 url정보에서 ip, db명 뽑아오기
			if(data.hrMap.database_type == "mssql"){
				var strIdx = data.hrMap.url.lastIndexOf('/');
				var endIdx = data.hrMap.url.lastIndexOf(';');
				
				var dbNm = data.hrMap.url.split('=');
				$("#dbName2").val(dbNm[1]);
				$("#dbAddr2").val(data.hrMap.url.substring(strIdx+1, endIdx));
				$("#db_sel2").data("kendoComboBox").value("mssql");
			}
			
			//mysql,maria 일때 url정보에서 ip, db명 뽑아오기
			else if(data.hrMap.database_type == "mysql" || data.hrMap.database_type == "mariadb"){
				var dbNm = data.hrMap.url.split('/');
				
				$("#dbName2").val(dbNm[3]);
				$("#dbAddr2").val(dbNm[2]);
				if(data.hrMap.database_type == "mysql")
					$("#db_sel2").data("kendoComboBox").value("mysql");
				else
					$("#db_sel2").data("kendoComboBox").value("mariadb");
			}
			
			//oracle일때 url정보에서 ip, db명 뽑아오기
			else if(data.hrMap.database_type == "oracle"){
				var dbNm = data.hrMap.url.split(':');
				var setDbNm = '';
				
				if(dbNm[5] != undefined) {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4] + ":" + dbNm[5]
				} else {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4]
				}
				
				$("#dbName2").val(dbNm[1]);
				$("#dbAddr2").val(setDbNm);
				$("#db_sel2").data("kendoComboBox").value("oracle");
			}
			
			driver[1] = data.hrMap.driver;
			url[1] = data.hrMap.url;
			$("#erp_comp2").val(data.hrMap.erp_comp_seq + " " + data.hrMap.erp_comp_name);
			$("#erp_compSeq2").val(data.hrMap.erp_comp_seq);
			$("#erp_compName2").val(data.hrMap.erp_comp_name);
			$("#dbLoginId2").val(data.hrMap.userid);
			$("#dbLoginPwd2").val(data.hrMap.password)
			$("#connectMsg2").html("! <%=BizboxAMessage.getMessage("TX000010776","연결 되었습니다")%>");
			$("#connectMsg2").prop("class", "lh24 ml10 text_blue");
			
			
			if(data.hrMap.erp_type_code == "ERPiU"){
				$("#erp_sel2").data("kendoComboBox").text("<%=BizboxAMessage.getMessage("TX000010775","U버전")%>");
				$("#erp_sel2").data("kendoComboBox").value("1001");
			}
			else if(data.hrMap.erp_type_code == "iCUBE"){
				if(data.hrMap.g20_yn == "Y"){
					$("#erp_sel2").data("kendoComboBox").value("G20");	
				}else{
					$("#erp_sel2").data("kendoComboBox").value("1000");	
				}
				
			}			
// 			$("#erp_sel2").data("kendoComboBox").value(data.hrMap.erp_seq);
		}		
		
		//기타부분
		if(data.etcMap != null){
			//mssql일때 url정보에서 ip, db명 뽑아오기
			if(data.etcMap.database_type == "mssql"){
				var strIdx = data.etcMap.url.lastIndexOf('/');
				var endIdx = data.etcMap.url.lastIndexOf(';');
				
				var dbNm = data.etcMap.url.split('=');
				$("#dbName3").val(dbNm[1]);
				$("#dbAddr3").val(data.etcMap.url.substring(strIdx+1, endIdx));
				$("#db_sel3").data("kendoComboBox").value("mssql");
			}
			
			//mysql,maria 일때 url정보에서 ip, db명 뽑아오기
			else if(data.etcMap.database_type == "mysql" || data.etcMap.database_type == "mariadb"){
				var dbNm = data.etcMap.url.split('/');
				
				$("#dbName3").val(dbNm[3]);
				$("#dbAddr3").val(dbNm[2]);
				if(data.etcMap.database_type == "mysql")
					$("#db_sel3").data("kendoComboBox").value("mysql");
				else
					$("#db_sel3").data("kendoComboBox").value("mariadb");
			}
			
			//oracle일때 url정보에서 ip, db명 뽑아오기
			else if(data.etcMap.database_type == "oracle"){
				var dbNm = data.etcMap.url.split(':');
				var setDbNm = '';
				
				if(dbNm[5] != undefined) {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4] + ":" + dbNm[5]
				} else {
					setDbNm = dbNm[3].substring(1) + ":" + dbNm[4]
				}
				
				$("#dbName3").val(dbNm[1]);
				$("#dbAddr3").val(setDbNm);
				$("#db_sel3").data("kendoComboBox").value("oracle");
			}
			
			driver[2] = data.etcMap.driver;
			url[2] = data.etcMap.url;
			$("#erp_comp3").val(data.etcMap.erp_comp_seq + " " + data.etcMap.erp_comp_name);
			$("#erp_compSeq3").val(data.etcMap.erp_comp_seq);
			$("#erp_compName3").val(data.etcMap.erp_comp_name);
			$("#dbLoginId3").val(data.etcMap.userid);
			$("#dbLoginPwd3").val(data.etcMap.password)
			$("#connectMsg3").html("! <%=BizboxAMessage.getMessage("TX000010776","연결 되었습니다")%>");
			$("#connectMsg3").prop("class", "lh24 ml10 text_blue");
			
			
			if(data.etcMap.erp_type_code == "ERPiU"){
				$("#erp_sel3").data("kendoComboBox").text("U버전");
				$("#erp_sel3").data("kendoComboBox").value("1001");
			}
			else if(data.etcMap.erp_type_code == "iCUBE"){
				if(data.etcMap.g20_yn == "Y"){
					$("#erp_sel3").data("kendoComboBox").value("G20");	
				}else{
					$("#erp_sel3").data("kendoComboBox").value("1000");	
				}
			}
// 			$("#erp_sel3").data("kendoComboBox").value(data.etcMap.erp_seq);
		}
		
		
		//사용안함일 경우 readonly, disabled 처리
		for(var i=1; i<=3; i++){
			if($("#erp_sel" + i).val() == "0000"){
				$("#dbAddr" + i).val("");
				$("#dbName" + i).val("");
				$("#dbLoginId" + i).val("");
				$("#dbLoginPwd" + i).val("");
				
				$("#db_sel" + i).data("kendoComboBox").enable(false);
				$("#db_sel" + i).data("kendoComboBox").value("<%=BizboxAMessage.getMessage("TX000010777","사용할 DB를 선택하세요")%>");
				$("#dbAddr" + i).attr("readonly", true);
				$("#dbName" + i).attr("readonly", true);
				$("#dbLoginId" + i).attr("readonly", true);
				$("#dbLoginPwd" + i).attr("readonly", true);
				$("#ok" + i).data("kendoButton").enable(false);
				$("#connectMsg" + i).html("");
				$("#connectMsg" + i).prop("class", "");
			}	
		}
	}
	
	//접속 확인버튼.
	function fnConnect(num){
		kendo.ui.progress($(".pop_con"), true);
		//필수 입력값 체크(erp버전 사용안함의 경우 제외)
		if($("#db_sel1" + num).val() == "" || $("#dbAddr" + num).val() == "" || $("#dbName" + num).val() == "" || $("#dbLoginId" + num).val() == "" || $("#dbLoginPwd" + num).val() == ""){
			alert("<%=BizboxAMessage.getMessage("TX000010774","DB접속 정보 중 입력되지 않은 항목이 존재합니다")%>");
			kendo.ui.progress($(".pop_con"), false);
			return false;
		}
		
		//db접속정보 파라미터 전달.
		var tblParam = {};
		tblParam.dbType = $("#db_sel" + num).val();			
		tblParam.dbIpAddr = $("#dbAddr" + num).val();
		tblParam.dbName = $("#dbName" + num).val();
		tblParam.dbLoginId = $("#dbLoginId" + num).val();
		tblParam.dbLoginPwd = $("#dbLoginPwd" + num).val();
		
		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/dbConnectConfirm.do"/>',
    		datatype:"json",
            data: tblParam ,
    		success: function (data) {
    				if(data.result == 1){
    					$("#connectMsg" + num).html("! <%=BizboxAMessage.getMessage("TX000010776","연결 되었습니다")%>");
    					$("#connectMsg" + num).prop("class", "lh24 ml10 text_blue");
    				}
    				else{
    					$("#connectMsg" + num).html("! <%=BizboxAMessage.getMessage("TX000010773","연결 되지 않았습니다")%>")
    					$("#connectMsg" + num).prop("class", "lh24 ml10 text_red");
    				}    
    				driver[num-1] = data.driver;
    				url[num-1] = data.url;
    				kendo.ui.progress($(".pop_con"), false);
    		    } ,
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		kendo.ui.progress($(".pop_con"), false);
		    		}
    	});	
	}
	
	//입력정보 수정 된 경우 기존 연결정보 제거.
	function fnConInfoChange(num){
		driver[num-1] = "";
		url[num-1] = "";
		$("#connectMsg" + num).html("");
		$("#connectMsg" + num).prop("class","");
		
		$("#erp_comp" + num).val("");
		$("#erp_compSeq" + num).val("");
		$("#erp_compName" + num).val("");
	}
	
	//저장버튼.
	function ok(){

// 		if($(".text_blue").length < 1){
// 			alert("연결된 DB정보가 존재하지 않습니다.");
// 			return false;
// 		}
		
		//필수 입력값 체크.
		for(var i=1;i<=3;i++){
			if($("#erp_sel" + i).val() != '0000'){
				if($("#db_sel" + i).val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000010772","DB종류는 필수 선택 값입니다")%>");
					return false;
				}
				else if($("#dbAddr" + i).val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000010771","DB 서버IP는 필수 입력 값입니다")%>");
					return false;
				}
				else if($("#dbName" + i).val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000010770","접속 DB명칭은 필수 입력 값입니다")%>");
					return false;
				}
				else if($("#dbLoginId" + i).val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000010769","DB 접속ID는 필수 입력 값입니다")%>");
					return false;
				}
				else if($("#dbLoginPwd" + i).val() == ""){
					alert("<%=BizboxAMessage.getMessage("TX000010768","DB 접속Pass는 필수 입력 값습니다")%>");
					return false;
				}
				else if($("#connectMsg" + i).prop("class") == "lh24 ml10 text_blue"){
					if($("#erp_compSeq" + i).val() == ""){
						alert("<%=BizboxAMessage.getMessage("TX000010767","ERP 회사코드를 선택해 주세요")%>");
						return false;
					}
				}
			}
		}
		
		//연결 확인된 정보만 저장, 사용안함의 경우 기존 정보 제거
		if(confirm("<%=BizboxAMessage.getMessage("TX000010766","저장 하시겠습니까? 연결확인 된 DB정보만 저장 됩니다.")%>"))
		{
			var achrGbn = "";
			var erpTypeCode = "";
			var databaseType = "";
			var listDriver = "";
			var listUrl = "";
			var listUserId = "";
			var listPassWord = "";
			var delType = "";
			var erpCompSeq = "";
			var erpCompName = "";
			var type = ['ac', 'hr', 'etc'];		
			
			for(var i=1;i<=3;i++){
				if($("#connectMsg" + i).prop("class") == "lh24 ml10 text_blue"){
					achrGbn += "," + type[i-1];
					if($("#erp_sel" + i).data("kendoComboBox").value() == "1001"){
						erpTypeCode += ",ERPiU";
					}else{
						erpTypeCode += ",iCUBE";
					}
					
					if($("#db_sel" + i).val() == "mssql")
						databaseType += ",mssql";
					else if($("#db_sel" + i).val() == "mysql")
						databaseType += ",mysql";
					else if($("#db_sel" + i).val() == "mariadb")
						databaseType += ",mariadb";
					else if($("#db_sel" + i).val() == "oracle")
						databaseType += ",oracle";				
					
					listDriver += "," + driver[i-1];
					listUrl += "," + url[i-1];
					listUserId += "," + $("#dbLoginId" + i).val();
					listPassWord += "," + $("#dbLoginPwd" + i).val();					
				}
				if($("#erp_sel" + i).val() == '0000'){
					delType += "," + type[i-1];
				}
			}
			
			var tblParam = {};
			tblParam.achrGbn = achrGbn.substring(1);
			tblParam.erpTypeCode = erpTypeCode.substring(1);			
			tblParam.databaseType = databaseType.substring(1);
			tblParam.listDriver = listDriver.substring(1);
			tblParam.listUrl = listUrl.substring(1);
			tblParam.listUserID = listUserId.substring(1);
			tblParam.listPassWord = listPassWord.substring(1);			
			tblParam.ErpCompSeq1 = $("#erp_compSeq1").val();
			tblParam.ErpCompName1 = $("#erp_compName1").val();
			tblParam.ErpCompSeq2 = $("#erp_compSeq2").val()
			tblParam.ErpCompName2 = $("#erp_compName2").val();
			tblParam.ErpCompSeq3 = $("#erp_compSeq3").val()
			tblParam.ErpCompName3 = $("#erp_compName3").val();
			tblParam.delType = delType.substring(1);			
			tblParam.compSeq = $("#compSeq").val();
			tblParam.g20Yn1 = $("#erp_sel1").data("kendoComboBox").value() == "G20" ? "Y" : "N";;
			tblParam.g20Yn2 = $("#erp_sel2").data("kendoComboBox").value() == "G20" ? "Y" : "N";;
			tblParam.g20Yn3 = $("#erp_sel3").data("kendoComboBox").value() == "G20" ? "Y" : "N";;
			
			// 회계쪽 데이터만 따로 구분(t_co_crp_comp 테이블에 ext_code 컬럼값을 위함) - hidden 값
			if($("#accountExtCode").val() != null || $("#accountExtCode").val() != "") {
				tblParam.accountExtCode = $("#accountExtCode").val(); 
			}

			$.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/systemx/dbConnectInfoSave.do"/>',
	    		datatype:"json",
	            data: tblParam ,
	    		success: function (data) {
	    				alert("<%=BizboxAMessage.getMessage("TX000010779","정상적으로 저장 되었습니다")%>");
	    				self.close();
	    		    } ,
			    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    		}
	    	});	
		}
	}
	
	//erp버전 선택 이벤트  - 사용안함의 경우 disabled 및 readonly처리
	function fnErpVerChange(num, target){
		//사용안함 - 0000
		if($("#"+target.id).val() == "0000"){
			$("#dbAddr" + num).val("");
			$("#dbName" + num).val("");
			$("#dbLoginId" + num).val("");
			$("#dbLoginPwd" + num).val("");
			
			$("#db_sel" + num).data("kendoComboBox").enable(false);
			$("#db_sel" + num).data("kendoComboBox").value("<%=BizboxAMessage.getMessage("TX000010777","사용할 DB를 선택하세요")%>");
			$("#dbAddr" + num).attr("readonly", true);
			$("#dbName" + num).attr("readonly", true);
			$("#dbLoginId" + num).attr("readonly", true);
			$("#dbLoginPwd" + num).attr("readonly", true);
			$("#ok" + num).data("kendoButton").enable(false);
			$("#connectMsg" + num).html("");
			$("#connectMsg" + num).prop("class", "");
			
			$("#erp_comp" + num).val("");
			$("#erp_compSeq" + num).val("");
			$("#erp_compName" + num).val("");
			$("#btnErpComp" + num).data("kendoButton").enable(false);
		}
		
		//그외
		else{
			$("#db_sel" + num).data("kendoComboBox").enable(true);
			$("#dbAddr" + num).attr("readonly", false);
			$("#dbName" + num).attr("readonly", false);
			$("#dbLoginId" + num).attr("readonly", false);
			$("#dbLoginPwd" + num).attr("readonly", false);
			$("#ok" + num).data("kendoButton").enable(true);
			$("#btnErpComp" + num).data("kendoButton").enable(true);
		}
	}
	
	function fnExCompPop(achrGbn, index){
		
		if($("#connectMsg" + index).prop("class") != "lh24 ml10 text_blue"){
			alert("<%=BizboxAMessage.getMessage("TX000010765","연동확인 후 사용해 주세요")%>");
			return false;
		}
		
		var erpVer = $("#erp_sel" + index).data("kendoComboBox").value() == "1001" ? "IU" : "ICUBE";
		var dbType = $("#db_sel" + index).data("kendoComboBox").value();
		var sUrl = url[index-1];
		var sDriver = driver[index-1];
		var dbId = $("#dbLoginId" + index).val();
		var dbPwd = escape($("#dbLoginPwd" + index).val());
		var urladdr = "<c:url value='/cmm/systemx/ExCompPop.do'/>" + "?achrGbn=" + achrGbn + "&compSeq=" + $("#compSeq").val() + "&erpVer=" + erpVer + "&dbType=" + dbType + "&url=" + sUrl + "&driver=" + sDriver + "&dbId=" + dbId + "&dbPwd=" + dbPwd + "&index=" + index;       
    	openWindow2(urladdr,  "ExCompPop", 340, 560, 0) ;
	}
	
	function fnSetErpCompInfo(erpComSeq, erpComName, index){
		$("#erp_comp" + index).val(erpComSeq + " " + erpComName);
		$("#erp_compSeq" + index).val(erpComSeq);
		$("#erp_compName" + index).val(erpComName);
	}
</script>


<body>
<div class="pop_wrap" style="width:698px;">
	<input id="compSeq" name="compSeq" type="hidden" value="${compSeq}">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016428","ERP 연동 설정")%></h1>
		<a href="#n" class="clo"><img src="../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">
	
		<div class="btn_top2">
			<h2><%=BizboxAMessage.getMessage("TX000007040","회계")%></h2>
		</div>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120"/>
					<col width="213"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000021","ERP버전")%></th>
					<td><input id="erp_sel1" style="width:90%" onchange="fnErpVerChange(1,this)"/></td>
					<th><%=BizboxAMessage.getMessage("TX000010363","DB종류")%></th>
					<td><input id="db_sel1" style="width:90%" onchange="fnConInfoChange(1)"/></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016434","DB 서버 IP")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbAddr1" name="dbAddr1" onchange="fnConInfoChange(1)" placeholder="172.0.0.1:1433"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016135","접속 DB 명칭")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbName1" name="dbName1" onchange="fnConInfoChange(1)" placeholder="Database"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016432","DB 접속 ID")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbLoginId1" name="dbLoginId1" onchange="fnConInfoChange(1)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016430","DB 접속 Pass")%></th>
					<td>
						<div class="posi_re">
							<input autocomplete="new-password" type="password" style="width:90%" id="dbLoginPwd1" name="dbLoginPwd1" onchange="fnConInfoChange(1)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016178","연결확인")%></th>
					<td>
						<div class="controll_btn p0 fl">
							<button onclick="fnConnect(1);" id="ok1"><%=BizboxAMessage.getMessage("TX000000078","확인")%></button>
						</div>
						<span class="" id="connectMsg1"></span>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016422","ERP 회사 코드")%></th>
					<td>
						<input type="text" style="width:123px;" class="fl mr5" readonly="readonly" id="erp_comp1" name="erp_comp1"/>
						<div class="controll_btn p0 fl">
							<button onclick="fnExCompPop('ac', '1');" id="btnErpComp1"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
							<input type="hidden" id="erp_compSeq1" name="erp_compSeq1" value=""/>
							<input type="hidden" id="erp_compName1" name="erp_compName1" value=""/>
						</div>	
					</td>
				</tr>
			</table>
			<input type="hidden" id="accountExtCode" value=""/> 
		</div>		
		
		<div class="btn_top2 mt12">
			<h2><%=BizboxAMessage.getMessage("TX000007041","인사")%></h2>
		</div>

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120"/>
					<col width="213"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000021","ERP버전")%></th>
					<td><input id="erp_sel2" style="width:90%" onchange="fnErpVerChange(2,this)"/></td>
					<th><%=BizboxAMessage.getMessage("TX000010363","DB종류")%></th>
					<td><input id="db_sel2" style="width:90%" onchange="fnConInfoChange(2)"/></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016434","DB 서버 IP")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbAddr2" name="dbAddr2" onchange="fnConInfoChange(2)" placeholder="172.0.0.1:1433"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016135","접속 DB 명칭")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbName2" name="dbName2" onchange="fnConInfoChange(2)" placeholder="Database"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016432","DB 접속 ID")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbLoginId2" name="dbLoginId2" onchange="fnConInfoChange(2)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016430","DB 접속 Pass")%></th>
					<td>
						<div class="posi_re">
							<input autocomplete="new-password" type="password" style="width:90%" id="dbLoginPwd2" name="dbLoginPwd2" onchange="fnConInfoChange(2)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016178","연결확인")%></th>
					<td>
						<div class="controll_btn p0 fl">
							<button onclick="fnConnect(2);" id="ok2"><%=BizboxAMessage.getMessage("TX000000078","확인")%></button>
						</div>
						<span class="" id="connectMsg2"></span>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016422","ERP 회사 코드")%></th>
					<td>
						<input type="text" style="width:123px;" class="fl mr5" readonly="readonly" id="erp_comp2" name="erp_comp2"/>
						<div class="controll_btn p0 fl">
							<button onclick="fnExCompPop('hr', '2');" id="btnErpComp2"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
							<input type="hidden" id="erp_compSeq2" name="erp_compSeq2" value=""/>
							<input type="hidden" id="erp_compName2" name="erp_compName2" value=""/>
						</div>	
					</td>
				</tr>
			</table>
		</div>

		<div class="btn_top2 mt12">
			<h2><%=BizboxAMessage.getMessage("TX000005400","기타")%></h2>
		</div>

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="120"/>
					<col width="213"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000021","ERP버전")%></th>
					<td><input id="erp_sel3" style="width:90%" onchange="fnErpVerChange(3,this)"/></td>
					<th><%=BizboxAMessage.getMessage("TX000010363","DB종류")%></th>
					<td><input id="db_sel3" style="width:90%" onchange="fnConInfoChange(3)"/></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016434","DB 서버 IP")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbAddr3" name="dbAddr3" onchange="fnConInfoChange(3)" placeholder="172.0.0.1:1433"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016135","접속 DB 명칭")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbName3" name="dbName3" onchange="fnConInfoChange(3)" placeholder="Database"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016432","DB 접속 ID")%></th>
					<td>
						<div class="posi_re">
							<input type="text" style="width:90%" id="dbLoginId3" name="dbLoginId3" onchange="fnConInfoChange(3)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016430","DB 접속 Pass")%></th>
					<td>
						<div class="posi_re">
							<input autocomplete="new-password" type="password" style="width:90%" id="dbLoginPwd3" name="dbLoginPwd3" onchange="fnConInfoChange(3)" placeholder="sa"/>
							<a href="#n" class="posi_ab" style="top:7px;right:25px;display:none;"><img src="../../../Images/btn/close_btn01.png" alt="" /></a><!-- 엑스버튼 -->
						</div>
					</td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016178","연결확인")%></th>
					<td>
						<div class="controll_btn p0 fl">
							<button onclick="fnConnect(3);" id="ok3"><%=BizboxAMessage.getMessage("TX000000078","확인")%></button>
						</div>
						<span class="" id="connectMsg3"></span>
					</td>
					<th><%=BizboxAMessage.getMessage("TX000016422","ERP 회사 코드")%></th>
					<td>
						<input type="text" style="width:123px;" class="fl mr5" readonly="readonly" id="erp_comp3" name="erp_comp3"/>
						<div class="controll_btn p0 fl">
							<button onclick="fnExCompPop('etc', '3');" id="btnErpComp3"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
							<input type="hidden" id="erp_compSeq3" name="erp_compSeq3" value=""/>
							<input type="hidden" id="erp_compName3" name="erp_compName3" value=""/>
						</div>	
					</td>
				</tr>
			</table>
		</div>


	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok();"/>
			<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
</body>