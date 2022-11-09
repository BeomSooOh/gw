

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<head>

    <title><%=BizboxAMessage.getMessage("TX000016128","주소록 선택")%></title>
  
    
	<script id="treeview-template" type="text/kendo-ui-template">
            #: item.text #
	</script>

	<script type="text/javascript">
	var deIdx = 0;	// 사용자/부서 선택 테이블 인덱스
	var selIdx = 0;	// 검색 선택 처리 인덱스
	
		$(document).ready(function() {	
		//기본버튼
           $(".controll_btn button").kendoButton();


         //그리드별 체크박스 전체체크 (1~4)
			$("#edCheckAll").on("click", function(e){
				if(this.checked) {
					$("#selectEmpTable input[name=inp_chk_1]:checkbox").each(function() {
						if(!$(this)[0].disabled)
							$(this).prop("checked", true);
					});
				} else {
					$("#selectEmpTable input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", false);
					});
				}
			});
		
		//조직도검색 셀렉트
			$("#organ_sel").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000000862","전체")%>","<%=BizboxAMessage.getMessage("TX000016055","회사/부서")%>","<%=BizboxAMessage.getMessage("TX000000277","이름")%>",""]
				},
				value:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>"
			});

		

		//탭
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			}
			});
		
		
			//주소록그룹 트리 
			treeRead();
			
			<c:if test="${not empty orgChartList}">
				//조직도 트리
				orgChartList = ${orgChartList};
				tvInit(orgChartList);
			</c:if>
			setcount();
		});
	
	
		// 트리뷰 초기화	(조직도)
		function tvInit(ocList) {
			var inline = new kendo.data.HierarchicalDataSource({
		                data: [ocList],
		                schema: {
	                        model: {
	                        	id: "seq",
	                            children: "nodes"
	                        } 
	                    }
		   });
			   $("#treeview2").kendoTreeView({
		          dataSource: inline,
		          select: onSelectTree,
		          dataTextField: ["name"],
		          dataValueField: ["seq", "gbn"]
		       }); 
		}
		
		
		function onSelectTree(e) {
			 var item = e.sender.dataItem(e.node);
			 
			 var NodesSeq = [], NodesNm = [], NodesGbn = [];
			 
			 NodesSeq.push(item.seq);
			 NodesNm.push(item.name);
			 NodesGbn.push(item.gbn);
			 
			 if(item.hasChildren > 0)
			 	checkedNode(item.nodes, NodesSeq, NodesNm, NodesGbn);
			 
			 var seqList = "";
			 
			 for(var i=0;i<NodesSeq.length;i++){
				 seqList += "," + NodesSeq[i];
			 }
			 seqList = seqList.substring(1);
			 
			 var tblParam = {};
			 tblParam.seqList = seqList;
				
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/systemx/getEmpList.do"/>',
		    		datatype:"json",
		            data: tblParam ,
		    		success: function (data) {
			    			var result = data.list;
							//$("#selectEmpTable tr").remove();
							$("#selectEmpTable tr").remove();
							for(var i=0;i<result.length;i++){
								addselectEmpTable2(result[i]);
							}
							setDisabled();
		    		    } ,
				    error: function (result) { 
				    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
		    	});
			
		}
		
		function checkedNode(nodes, NodesSeq, NodesNm, NodesGbn){
			for (var i = 0; i < nodes.length; i++) {
				NodesSeq.push(nodes[i].seq);
				NodesNm.push(nodes[i].name);
				NodesGbn.push(nodes[i].gbn);

            	 if (nodes[i].hasChildren) 
            		 checkedNode(nodes[i].children.view(), NodesSeq, NodesNm, NodesGbn);
	        }
		}
		
		function treeRead(){
			
			var homogeneous = new kendo.data.HierarchicalDataSource({
		        transport: {
		            read: {
		                url: '<c:url value="/cmm/systemx/getAddrGroupListNodes.do" />',
		                dataType: "jsonp",
		            }
// 		            	parameterMap: function(data, operation) {
// 		     	    	data.txtSearch = "";//$("#txtSearch1").val();
// 		     	    	data.searchDiv = "";//$("#searchDiv1").val();
// 		     	    	return data ;
// 		     	    }
		        },  
		        schema: {
		            model: {
		            	children: "nodes"
		            } 
		        } 
		    });   
		
			$("#treeview").kendoTreeView({
			    dataSource: homogeneous,
			    dataTextField: "group_nm",
			    dataSpriteCssClassField : "folder",
			    loadOnDemand: false,
			    select: fnSetArrdGroupInfo
			}); 
		}
		
		
		function fnSetArrdGroupInfo(e){
			var group_seq = $("#treeview").data("kendoTreeView").dataItem(e.node).group_seq
			
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/getAddrListNodes.do" />',
				datatype:"json",	
				data:{addrGroupSeq : group_seq},				
				success:function(data){		
					var result = data.list;
					$("#selectEmpTable tr").remove();
					for(var i=0;i<result.length;i++){
						addselectEmpTable(result[i]);
					}
					setDisabled();
				}
			});
		}
		
		
		
		//주소록그룹 선택시 주소록 그리드에 추가.
		function addselectEmpTable(item){
			console.log(item);
	
			var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+item.dept_seq +"\" />";
			info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+item.comp_seq +"\" />";
			info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+item.emp_seq +"\" />";
			info += "<input type=\"hidden\" name=\"group_seq\" value=\""+item.addr_group_seq +"\" />";
			info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+item.addr_seq +"\" />";
			info += "<input type=\"hidden\" name=\"group_nm\" value=\""+item.group_nm +"\" />";
			info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+item.addr_nm +"\" />";
			info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+item.comp_nm +"\" />";
			info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+item.dept_nm +"\" />";
			info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+item.emp_nm +"\" />";
			info += "<input type=\"hidden\" name=\"fax_num\" value=\""+item.comp_fax +"\" />";
			info += "<input type=\"hidden\" name=\"tel_num\" value=\""+item.comp_tel +"\" />";
			info += "<input type=\"hidden\" name=\"e_mail\" value=\""+item.e_mail +"\" />";
			info += "<input type=\"hidden\" name=\"type\" value=\""+ "A" +"\" />";
			
			var empNm = "";
			var compFax = " ";
			var seq = item.addr_seq;
			
// 			empNm = item.emp_nm + "<input type=\"hidden\" name=\"deptName\" value=\""+item.emp_nm +"\" />" ;
// 			compFax = item.comp_fax + "<input type=\"hidden\" name=\"dutyName\" value=\""+item.comp_fax +"\" />" ;

			 var h = "<tr id=\"seq"+seq+"\">" + info +
							"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
								"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
							"</td>" +
							"<td class=\"\">"+item.comp_nm+"</td>" +
							"<td class=\"\">"+item.emp_nm+"</td>" +
							"<td class=\"\">"+item.e_mail+"</td>" +
				"</tr>";
			
			//alert(html);
			$("#selectEmpTable").append(h);
			deIdx++;  
		}
		
		
		
		//주소록그룹 선택시 주소록 그리드에 추가.
		function addselectEmpTable2(item){
			console.log(item);

			var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+item.dept_seq +"\" />";
			info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+item.comp_seq +"\" />";
			info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+item.emp_seq +"\" />";
			info += "<input type=\"hidden\" name=\"group_seq\" value=\""+item.addr_group_seq +"\" />";
			info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+item.addr_seq +"\" />";
			info += "<input type=\"hidden\" name=\"group_nm\" value=\""+item.group_nm +"\" />";
			info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+item.addr_nm +"\" />";
			info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+item.comp_name +"\" />";
			info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+item.dept_name +"\" />";
			info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+item.emp_name +"\" />";
			info += "<input type=\"hidden\" name=\"fax_num\" value=\""+item.fax_num +"\" />";
			info += "<input type=\"hidden\" name=\"tel_num\" value=\""+item.mobile_tel_num +"\" />";
			info += "<input type=\"hidden\" name=\"e_mail\" value=\""+item.email_addr +"\" />";
			info += "<input type=\"hidden\" name=\"type\" value=\""+ "D" +"\" />";
			
		
			var empNm = "";
			var compFax = " ";
			var seq = item.emp_seq;
		
			
			var h = "<tr id=\"seq"+seq+"\">" + info +
							"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
								"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
							"</td>" +
							"<td class=\"\">"+item.comp_name+"</td>" +
							"<td class=\"\">"+item.emp_name+"</td>" +
							"<td class=\"\">"+item.email_addr+"</td>" +
				"</tr>";
	
			//alert(html);
			$("#selectEmpTable").append(h);
			deIdx++;   
		}
		
		
		//이메일이 없을시 체크박스 비활성화
		function setDisabled(){
			var chkBoxList = $("#selectEmpForm").find("input[name=inp_chk_1]:checkbox");
			var chkValueList;

			chkValueList = $("#selectEmpForm").find("input[name=e_mail]:hidden");

			for(var i=0;i<chkBoxList.length;i++){
				if(chkValueList[i].value == "" || chkValueList[i].value == "null")
					chkBoxList[i].disabled = true;
			}
		}
		

		function fnAdd(target){
			var arr = $("#selectEmpTable").find("input[name=inp_chk_1]:checked");
			
			var deptSeqList = arr.parent().parent().find("input[name=dept_seq]:hidden");
			var compSeqList = arr.parent().parent().find("input[name=comp_seq]:hidden");
			var empSeqList = arr.parent().parent().find("input[name=emp_seq]:hidden");
			var groupSeqList = arr.parent().parent().find("input[name=group_seq]:hidden");
			var addrSeqList = arr.parent().parent().find("input[name=addr_seq]:hidden");
			var groupNmList = arr.parent().parent().find("input[name=group_nm]:hidden");
			var addrNmList = arr.parent().parent().find("input[name=addr_nm]:hidden");
			var compNmList = arr.parent().parent().find("input[name=comp_nm]:hidden");
			var deptNmList = arr.parent().parent().find("input[name=dept_nm]:hidden");
			var empNmList = arr.parent().parent().find("input[name=emp_nm]:hidden");
			var faxNumList = arr.parent().parent().find("input[name=fax_num]:hidden");
			var telNumList = arr.parent().parent().find("input[name=tel_num]:hidden");
			var emailList = arr.parent().parent().find("input[name=e_mail]:hidden");
			var typeList = arr.parent().parent().find("input[name=type]:hidden");
			
			
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					var cnt = 0;
					
					var groupSeqChkList = $("#"+target).find("input[name=group_seq]:hidden");
					var addrSeqChkList = $("#"+target).find("input[name=addr_seq]:hidden");
					var deptSeqChkList = $("#"+target).find("input[name=dept_seq]:hidden");
					var empSeqChkList = $("#"+target).find("input[name=emp_seq]:hidden");
					
					for(var j=0;j<groupSeqChkList.length;j++){
						if(typeList[i].value == 'A'){
							if((groupSeqList[i].value == groupSeqChkList[j].value) && (addrSeqList[i].value == addrSeqChkList[j].value))
								cnt++;
						}
						if(typeList[i].value == 'D'){
							if((deptSeqList[i].value == deptSeqChkList[j].value) && (empSeqList[i].value == empSeqChkList[j].value))
								cnt++;
						}
					}
					
					if(cnt == 0){

						var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+deptSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+compSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+empSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_seq\" value=\""+groupSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+addrSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_nm\" value=\""+groupNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+addrNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+compNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+deptNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+empNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"fax_num\" value=\""+faxNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"tel_num\" value=\""+telNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"e_mail\" value=\""+emailList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"type\" value=\""+ typeList[i].value +"\" />";

												
						var seq;
						
						if(typeList[i].value == 'A')
							seq = addrSeqList[i].value;
						if(typeList[i].value == 'D')
							seq = empSeqList[i].value;
						
						
						 var h = "<tr id=\"seq"+seq+"\">" + info +
										"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
											"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
										"</td>" +
										"<td class=\"\">"+ empNmList[i].value +"</td>" +
										"<td class=\"\">"+emailList[i].value+"</td>" +
								"</tr>";
						$("#"+target).append(h);
						deIdx++; 
					}
				}
			}	
			$("#edCheckAll_1").prop("checked",false);
			setcount();
		}
		
		function fnRemove(target){
			var arr = $("#"+target).find("input[name=inp_chk_1]:checked");
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					var _tr = $(arr[i]).parent().parent();
					$(_tr).remove();
				}
			}	
			setcount();
		}
	
		function fnRemoveRef(){
			alert("fnRemoveRef");
		}
	
		function fnRemoveHidRef(){
			alert("fnRemoveHidRef");
		}
		
		
		//선택,반영된 목록 카운트 셋팅
		function setcount(){
			
			var rowCount1 = $('#selectRecTable tr').length;
			var rowCount2 = $('#selectRefTable tr').length;
			var rowCount3 = $('#selectHidRefTable tr').length;

			$("#selectRecCount").html("("+rowCount1+")");
			$("#selectRefCount").html("("+rowCount2+")");
			$("#selectHidRefCount").html("("+rowCount3+")");
		}
		
		
		
		function ok(){
			var formId1 = "selectRecForm";
			var formId2 = "selectRefForm";
			var formId3 = "selectHidRefForm";
			
			var data = {};
			
			var selectedRecList = [];
			var selectedRefList = [];
			var selectedHidRefList = [];
			
			var obj = {};
			var cnt = 0;
			var formdata1 = $("#"+formId1).serializeArray();
			var formdata2 = $("#"+formId2).serializeArray();
			var formdata3 = $("#"+formId3).serializeArray();
			
			for(var i = 0; i < formdata1.length; i++) {
				var item = formdata1[i];
				if(item.name == "dept_seq") {
					if (i != 0) {
						selectedRecList.push(obj); 
					} 
					obj = {};
				}
				obj[item.name] = item.value;
				cnt++;
			}
			if(cnt > 0)
				selectedRecList.push(obj);  
			
			///////////////////////////////////
			cnt = 0;
			obj = {};
			
			for(var i = 0; i < formdata2.length; i++) {
				var item = formdata2[i];
				if(item.name == "dept_seq") {
					if (i != 0) {
						selectedRefList.push(obj); 
					} 
					obj = {};
				}
				obj[item.name] = item.value;
				cnt++;
			}
			if(cnt > 0)
				selectedRefList.push(obj);  
			
			cnt = 0;
			obj = {};
			
			
			///////////////////////////////////
			cnt = 0;
			obj = {};
			
			for(var i = 0; i < formdata3.length; i++) {
				var item = formdata3[i];
				if(item.name == "dept_seq") {
					if (i != 0) {
						selectedHidRefList.push(obj); 
					} 
					obj = {};
				}
				obj[item.name] = item.value;
				cnt++;
			}
			if(cnt > 0)
				selectedHidRefList.push(obj);  
			
			cnt = 0;
			obj = {};
			
			
			data['selectedRecList'] = selectedRecList;
			data['selectedRefList'] = selectedRefList;
			data['selectedHidRefList'] = selectedHidRefList;
			
			var callback = '${callback}';
			try {
				if (callback) {
					eval('window.opener.' + callback)(data);
				} else {
					opener.callbackSelectUser(data);
				}
			} catch(exception) {
				var callbackUrl = "${params.callbackUrl}";
				var callbackFunction = "${params.callback}";
				data['callback'] = callbackFunction;
				
				document.getElementById("middleFrame").src = callbackUrl+"?data="+JSON.stringify(data);
			}
			window.close(); 
			
		}
	</script>

</head>

<body>
<div class="pop_wrap email_wrap" style="width:998px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016128","주소록 선택")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
					
	<div class="pop_con">

	<div class="tab_set">
		<div class="tab_style"  id="tabstrip">

			<ul>
				<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000001491","주소록")%></li>
				<li><%=BizboxAMessage.getMessage("TX000004738","조직도")%></li>
			</ul>


		<div class="organ_tab1">
		<div class="box_left" style="width:240px;">			
			<!-- 조직도-->
			<div class="treeCon" >									
				<div id="treeview" class="tree_icon" style="height:475px;"></div>
			</div> 				
		</div><!-- //box_left -->	

		</div><!--// organ_tab1 -->

		
		<div class="organ_tab2">
			<div class="box_left" style="width:240px;">			
			<!-- 조직도-->
			<div class="treeCon" >									
				<div id="treeview2" class="tree_icon" style="height:475px;"></div>
			</div> 				
		</div><!-- //box_left -->	
		</div><!--// organ_tab2 -->

		</div><!--// tab_div -->
		</div><!--//tab_set  -->

		<div class="fix_div">
		<div class="box_left" style="width:343px;">
			<div class="record_tabSearch">
				<input id="organ_sel" style="width:66px;" />
				<input class="k-textbox input_search" id="btnText" type="text" value="" style="width:205px;" placeholder="">
				<a href="#" class="btn_search"></a>
			</div>

			<div class="br_com_area2">
				<div class="com_ta2 mt10">
				<table>
					<colgroup>
						<col width="35"/>
						<col width="80"/>
						<col width="65"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th class="le">
							<input type="checkbox" name="inp_chk" id="edCheckAll" class="k-checkbox" />
							<label class="k-checkbox-label" for="edCheckAll" style="padding:0.2em 0 0 10px;"></label>
						</th>
						<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
						<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
						<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
					</tr>
				</table>
			</div>	
			
			<form id="selectEmpForm">
			<div class="com_ta2 ova_sc"style="height:439px;margin-top:0px;">
				<table id="selectEmpTable">
					<colgroup>
						<col width="35"/>
						<col width="80"/>
						<col width="65"/>
						<col width=""/>
					</colgroup>
					
				</table>
			</div>	
			</form>		
			</div><!--// br_com_area2 -->
		</div><!-- //box_right2 -->
		
		<div class="trans_tool">
			<ul style="margin-top:77px;">
				<li><a><img src="<c:url value='/Images/btn/btn_arr01.png'/>" alt="" onclick="fnAdd('selectRecTable');"/></a></li>
				<li><a><img src="<c:url value='/Images/btn/btn_arr02.png'/>" alt="" onclick="fnRemove('selectRecTable');"/></a></li>
			</ul>

			<ul style="margin-top:141px;">
				<li><a><img src="<c:url value='/Images/btn/btn_arr01.png'/>" alt="" onclick="fnAdd('selectRefTable');"/></a></li>
				<li><a><img src="<c:url value='/Images/btn/btn_arr02.png'/>" alt="" onclick="fnRemove('selectRefTable');"/></a></li>
			</ul>

			<ul style="margin-top:141px;">
				<li><a><img src="<c:url value='/Images/btn/btn_arr01.png'/>" alt="" onclick="fnAdd('selectHidRefTable');"/></a></li>
				<li><a><img src="<c:url value='/Images/btn/btn_arr02.png'/>" alt="" onclick="fnRemove('selectHidRefTable');"/></a></li>
			</ul>
		</div>

		<div class="box_last">
			
			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li class="tit_li"><%=BizboxAMessage.getMessage("TX000001467","받는사람")%><span id="selectRecCount">(0)</span></li>
					</ul>
				</div>
				<form id="selectRecForm">
				<div class="com_ta2 ova_sc" style="height:147px;">
					<table id="selectRecTable">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<c:forEach items="${selectedRecList}" var="selList" varStatus="c">
						<c:if test="${selList.type == 'A'}">
							<tr id="seq${selList.addr_seq}">
						</c:if>
						<c:if test="${selList.type == 'D'}">
							<tr id="seq${selList.emp_seq}">
						</c:if>
								<input type="hidden" name="dept_seq" value="${selList.dept_seq}"/>
								<input type="hidden" name="comp_seq" value="${selList.comp_seq}"/>
								<input type="hidden" name="emp_seq" value="${selList.emp_seq}"/>
								<input type="hidden" name="group_seq" value="${selList.group_seq}"/>
								<input type="hidden" name="addr_seq" value="${selList.addr_seq}"/>
								<input type="hidden" name="group_nm" value="${selList.group_nm}"/>
								<input type="hidden" name="addr_nm" value="${selList.addr_nm}"/>
								<input type="hidden" name="comp_nm" value="${selList.comp_nm}"/>
								<input type="hidden" name="dept_nm" value="${selList.dept_nm}"/>
								<input type="hidden" name="emp_nm" value="${selList.emp_nm}"/>
								<input type="hidden" name="fax_num" value="${selList.fax_num}"/>
								<input type="hidden" name="tel_num" value="${selList.tel_num}"/>
								<input type="hidden" name="e_mail" value="${selList.e_mail}"/>
								<input type="hidden" name="type" value="${selList.type}"/>
								<td class="">
									<input name="inp_chk_1" class="k-checkbox" id="edCheck_rec_${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck_rec_${c.count}"></label>
								</td>
								<td class="">${selList.emp_nm}</td>
								<td>${selList.e_mail}</td>
							</tr>
						</c:forEach>
					</table>
				</div><!--// com_ta2 -->
				</form>
			</div><!--// sm_box -->

			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li class="tit_li"><%=BizboxAMessage.getMessage("TX000004364","참조")%><span id="selectRefCount">(0)</span></li>
					</ul>
				</div>
				<form id="selectRefForm">
				<div class="com_ta2 ova_sc" style="height:147px;">
					<table id="selectRefTable">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<c:forEach items="${selectedRefList}" var="selList" varStatus="c">
						<c:if test="${selList.type == 'A'}">
							<tr id="seq${selList.addr_seq}">
						</c:if>
						<c:if test="${selList.type == 'D'}">
							<tr id="seq${selList.emp_seq}">
						</c:if>
								<input type="hidden" name="dept_seq" value="${selList.dept_seq}"/>
								<input type="hidden" name="comp_seq" value="${selList.comp_seq}"/>
								<input type="hidden" name="emp_seq" value="${selList.emp_seq}"/>
								<input type="hidden" name="group_seq" value="${selList.group_seq}"/>
								<input type="hidden" name="addr_seq" value="${selList.addr_seq}"/>
								<input type="hidden" name="group_nm" value="${selList.group_nm}"/>
								<input type="hidden" name="addr_nm" value="${selList.addr_nm}"/>
								<input type="hidden" name="comp_nm" value="${selList.comp_nm}"/>
								<input type="hidden" name="dept_nm" value="${selList.dept_nm}"/>
								<input type="hidden" name="emp_nm" value="${selList.emp_nm}"/>
								<input type="hidden" name="fax_num" value="${selList.fax_num}"/>
								<input type="hidden" name="tel_num" value="${selList.tel_num}"/>
								<input type="hidden" name="e_mail" value="${selList.e_mail}"/>
								<input type="hidden" name="type" value="${selList.type}"/>
								<td class="">
									<input name="inp_chk_1" class="k-checkbox" id="edCheck_ref_${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck_ref_${c.count}"></label>
								</td>
								<td class="">${selList.emp_nm}</td>
								<td>${selList.e_mail}</td>
							</tr>
						</c:forEach>
					</table>
				</div><!--// com_ta2 -->
				</form>
			</div><!--// sm_box -->

			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li class="tit_li"><%=BizboxAMessage.getMessage("TX000001469","숨은참조")%><span id="selectHidRefCount">(0)</span></li>
					</ul>
				</div>
				<form id="selectHidRefForm">
				<div class="com_ta2 ova_sc" style="height:147px;">
					<table id="selectHidRefTable">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<c:forEach items="${selectedHidRefList}" var="selList" varStatus="c">
						<c:if test="${selList.type == 'A'}">
							<tr id="seq${selList.addr_seq}">
						</c:if>
						<c:if test="${selList.type == 'D'}">
							<tr id="seq${selList.emp_seq}">
						</c:if>
								<input type="hidden" name="dept_seq" value="${selList.dept_seq}"/>
								<input type="hidden" name="comp_seq" value="${selList.comp_seq}"/>
								<input type="hidden" name="emp_seq" value="${selList.emp_seq}"/>
								<input type="hidden" name="group_seq" value="${selList.group_seq}"/>
								<input type="hidden" name="addr_seq" value="${selList.addr_seq}"/>
								<input type="hidden" name="group_nm" value="${selList.group_nm}"/>
								<input type="hidden" name="addr_nm" value="${selList.addr_nm}"/>
								<input type="hidden" name="comp_nm" value="${selList.comp_nm}"/>
								<input type="hidden" name="dept_nm" value="${selList.dept_nm}"/>
								<input type="hidden" name="emp_nm" value="${selList.emp_nm}"/>
								<input type="hidden" name="fax_num" value="${selList.fax_num}"/>
								<input type="hidden" name="tel_num" value="${selList.tel_num}"/>
								<input type="hidden" name="e_mail" value="${selList.e_mail}"/>
								<input type="hidden" name="type" value="${selList.type}"/>
								<td class="">
									<input name="inp_chk_1" class="k-checkbox" id="edCheck_href_${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck_href_${c.count}"></label>
								</td>
								<td class="">${selList.emp_nm}</td>
								<td>${selList.e_mail}</td>
							</tr>
						</c:forEach>
					</table>
				</div><!--// com_ta2 -->
				</form>
			</div><!--// sm_box -->
		</div><!--// box_last -->
	</div><!--// fix_div -->


	</div><!-- //pop_con -->	

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="ok();" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" onclick="window.close()" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->
	<iframe id="middleFrame" height=0 width=0 frameborder=0 scrolling=no></iframe>
</body>
</html>