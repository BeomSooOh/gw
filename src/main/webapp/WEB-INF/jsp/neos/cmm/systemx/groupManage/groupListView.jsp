<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var groupSeq = '';

	$(document).ready(function() {
		// 그룹리스트 데이터 가져오기
		fnGroupListData();

		// 회사리스트 데이터 가져오기
		fnCompListData();
		
		// 이벤트 초기화
		fnEventInit();
	});

	
	// 이벤트 초기화	
	function fnEventInit() {
		// 그룹 선택 
		$("#tList").on("click", "tr", function(){
			fnSelectGroup(this);
		});
		
		// 그룹 더블 클릭
		$("#tList").on("dblclick", "tr", function(){
			var url = "groupAddPop.do?type=mode&grouppingSeq=" + groupSeq + "";
   	    	var pop = window.open(url, "groupAddPop", "width=395,height=340");
		});
		
		// 추가 버튼 클릭
		$("#btnAdd").click(function(){
			var url = "groupAddPop.do?type=save";
   	    	var pop = window.open(url, "groupAddPop", "width=395,height=340");
		});
				
		// 삭제 버튼 클릭		
		$("#btnDel").click(function(){
			fnDel();
		});		
		
		// 저장 버튼 이벤트
		$("#btnSave").click(function(){
			fnAddComp();
		});
		
		// 검색 버튼 이벤트
		$("#searchButton").click(function() {
			fnGroupListData();
		});
		
		// 엔터키 이벤트
		$("#searchText").keydown(function(e){
			if(e.keyCode==13) {
				fnGroupListData();
			}
				
		});	
		
		// 체크박스  active
		$("#compList").on("click", ".k-checkbox", function(){
			if($(this).is(":checked")) {
				$(this).closest("tr").addClass("on");	
			} else {
				$(this).closest("tr").removeClass();
			}
		});
		
		// 전체 클릭 이벤트
		$("#allCheck").click(function(){
			if($(this).is(":checked")) {
				$("input[name=groupListComp]").prop("checked", true);
				$("#compList tr").addClass("on");
				
			} else {
				$("input[name=groupListComp]").prop("checked", false);
				$("#compList tr").removeClass("on");
			}
		});
	}
	
	
	// 그룹 리스트 데이터 가져오기
	function fnGroupListData() {
		var param = {};
		param.searchText = $("#searchText").val() || ""; 
		
		//console.log(JSON.stringify(param));
		$.ajax({
			type : "POST",
			data : param,
			url : '<c:url value="/cmm/systemx/groupManage/getGroupData.do" />',
			success : function(result) {
				//console.log(JSON.stringify(result));
				fnDrawList(result.groupList);
			},
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}

	// 그룹리스트 그려주기
	function fnDrawList(data) {
		var groupList = data;
		var tag = '';

		if (groupList.length == 0) {
			tag += '<tr>';
			tag += '<td class="nocon"><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td>';
			tag += '</tr>';
		} else {
			for (var i = 0; i < groupList.length; i++) {
				tag += '<tr class="" id="' + groupList[i].grouppingSeq + '" groupName="' + groupList[i].grouppingName + '  ">';
				tag += '<td>' + groupList[i].grouppingName + '</td>';
				tag += '</tr>';
			}
		}
		$("#tList").html(tag);
	}
	
	
	// 회사리스트 데이터 가져오기
	function fnCompListData() {
		var param = {};
		param.grouppingSeq = groupSeq;
		
		$.ajax({
			type : "POST"
			, data : param
			, url : '<c:url value="/cmm/systemx/groupManage/allCompList.do"/>'
			, success: function(result) {
				fnGridAllCompList(result);
			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010627","그룹핑 된 회사 목록을 가져오는데 실패했습니다")%>");
			}
		});
	}
	
	
	// 회사 그려주기
	function fnGridAllCompList(data) {
		var compListData = data.compList;
		
		var tag = '';
		
		
		if(compListData.length == 0) {
			tag += '<tr><td>-</td></tr>';
		} else {
			for(var i=0; i<compListData.length; i++) {
				tag += '<tr>';
				
				tag += '<td>';
				tag += '<input type="checkbox" name="groupListComp" id="comp_' + compListData[i].compSeq + '" class="k-checkbox" value="' + compListData[i].compSeq + '"> ';
				tag += '<label class="k-checkbox-label bdChk2" for="comp_' + compListData[i].compSeq + '"></label>';
				tag += '</td>';
				tag += '<td>' + compListData[i].compCd + '</td>';
				tag += '<td>' + compListData[i].compName + '</td>';
				tag += '</tr>';
			}
		}
		
		$("#compList").html(tag);
	}
	
	// 그룹 클릭
	function fnSelectGroup(data) {
		groupSeq = $(data).attr("id");
		
		//전체 tr 초기화
		$("#tList tr").removeClass("on");
		//선택 tr 변경
		$(data).addClass("on");
		
		fnGroupingComp();
	}
	
	
	// 그룹 삭제
	function fnDel() {
		var param = {};
		param.grouppingSeq = groupSeq;
		
		if(groupSeq == "" || groupSeq == null || groupSeq == "undefind") {
			alert("<%=BizboxAMessage.getMessage("TX000007779","그룹을 선택해주세요")%>");
			return;
		}
		if(!confirm("! "+"<%=BizboxAMessage.getMessage("TX000010624","그룹핑 삭제 시 등록된 회사가 모두 해제됩니다.　                  삭제하시겠습니까?")%>".replace("　","\n"))) {
			return;
		}
		
		$.ajax({
			type: "POST"
			, url: '<c:url value="/cmm/systemx/groupManage/groupDel.do" />'
			, data: param
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000002121","삭제 되었습니다.")%>");
				
				// 체크 박스 초기화
				$("input[name=groupListComp]").prop("checked", false);
				$("#compList tr").removeClass("on");
				
				fnGroupListData();
			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010629","저장하는데 오류가 발생하였습니다")%>");
			}
		});
	}
	
	// 그룹핑 된 회사 
	function fnGroupingComp() {
		var param = {};
		param.grouppingSeq = groupSeq;
		param.gubun = "grouping"
		
		$.ajax({
			type : "POST"
			, data : param
			, url : '<c:url value="/cmm/systemx/groupManage/groupingComp.do"/>'
			, success: function(result) {
				// 체크 박스 초기화
				$("input[name=groupListComp]").prop("checked", false);
				$("#compList tr").removeClass("on");
				
				for(var i=0; i<result.groupingComp.length; i++) {
					var compSeq = result.groupingComp[i].compSeq;
				
					$("input[name=groupListComp]").each(function() {
						if($(this).val() == compSeq){
							$(this).prop("checked", true);
							$(this).closest("tr").addClass("on");
						}
					});
					
				}
				
			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010627","그룹핑 된 회사 목록을 가져오는데 실패했습니다")%>");
			}
		});
	}
	
	
	// 저장 버튼 이벤트
	function fnAddComp() {
		//console.log("반영");
		var compArray = new Array();
		var param = {};
		param.grouppingSeq = groupSeq;
		
		$("input[name=groupListComp]").each(function(){
			if($(this).is(":checked")) {
				//alert($(this).val());
				var paramComp = {};
				var compSeq = $(this).val();
				paramComp.compSeq = compSeq;
				compArray.push(paramComp);
			}
		});
		param.compList = compArray;
		
		if(groupSeq == "" || groupSeq == null || groupSeq == "undefind") {
			alert("<%=BizboxAMessage.getMessage("TX000007779","그룹을 선택해주세요")%>");
			return;
		}
		
		$.ajax({
			type : "POST"
			, contentType: "application/json; charset=utf-8"
			, url : '<c:url value="/cmm/systemx/groupManage/groupingCompAdd.do"/>'
			, data : JSON.stringify(param)
			, dataType: "json"
			, success: function(result) {
				alert('<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>');
				fnGroupingComp(groupSeq);
			}
			, error: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010623","회사 저장에 실패했습니다")%>");
			}
		});
	}
</script>


<div class="sub_contents_wrap">
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000016360","그룹핑 명")%></dt>
			<dd>
				<input id="searchText" class="" type="text" value="" placeholder=""
					style="width: 200px;">
			</dd>
			<dd>
				<input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
			</dd>
		</dl>
	</div>

	<div class="twinbox mt14">
		<table>
			<colgroup>
				<col style="width: 40%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000016359","그룹핑 목록")%></h5>
						</div>
						<div class="right_div">
							<div class="controll_btn p0">
								<button id="btnAdd"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
								<button id="btnDel"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
							</div>
						</div>
					</div>

					<div class="com_ta2">
						<table>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000002","그룹명")%></th>
							</tr>
						</table>
					</div>

					<div class="com_ta2 bg_lightgray ova_sc scroll_y_on"
						style="height: 518px;">
						<table id="tList">
							<!-- 							<tr> -->
							<!-- 								<td>A 그룹핑</td> -->
							<!-- 							</tr> -->
							<!-- 							<tr> -->
							<!-- 								<td>B 그룹핑</td> -->
							<!-- 							</tr> -->
							<!-- 							<tr> -->
							<!-- 								<td>C 그룹핑</td> -->
							<!-- 							</tr> -->
							<!-- 							<tr> -->
							<!-- 								<td>D 그룹핑</td> -->
							<!-- 							</tr> -->
						</table>
					</div>
				</td>

				<td class="twinbox_td">
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000016074","회사 목록")%></h5>
						</div>
						<div class="right_div">
							<div class="controll_btn p0">
								<button id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
							</div>
						</div>
					</div>

					<div class="com_ta2">
						<table>
							<colgroup>
								<col width="34" />
								<col width="100" />
								<col width="" />
							</colgroup>
							<tr>
								<th><input type="checkbox" name="inp_chk" id="allCheck"
									class="k-checkbox"> <label
									class="k-checkbox-label bdChk2" for="allCheck"></label></th>
								<th><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></th>
								<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
							</tr>
						</table>
					</div>

					<div class="com_ta2 bg_lightgray ova_sc scroll_y_on"
						style="height: 518px;">
						<table>
							<colgroup>
								<col width="34" />
								<col width="100" />
								<col width="" />
							</colgroup>
							<tbody id="compList">
							</tbody>
<!-- 							<tr> -->
<!-- 								<td><input type="checkbox" name="inp_chk" id="inp_chk1" -->
<!-- 									class="k-checkbox"> <label -->
<!-- 									class="k-checkbox-label bdChk2" for="inp_chk1"></label></td> -->
<!-- 								<td>1000</td> -->
<!-- 								<td>더존비즈온</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td><input type="checkbox" name="inp_chk" id="inp_chk2" -->
<!-- 									class="k-checkbox"> <label -->
<!-- 									class="k-checkbox-label bdChk2" for="inp_chk2"></label></td> -->
<!-- 								<td>1000</td> -->
<!-- 								<td>더존비즈온</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td><input type="checkbox" name="inp_chk" id="inp_chk3" -->
<!-- 									class="k-checkbox"> <label -->
<!-- 									class="k-checkbox-label bdChk2" for="inp_chk3"></label></td> -->
<!-- 								<td>1000</td> -->
<!-- 								<td>더존비즈온</td> -->
<!-- 							</tr> -->
<!-- 							<tr> -->
<!-- 								<td><input type="checkbox" name="inp_chk" id="inp_chk4" -->
<!-- 									class="k-checkbox"> <label -->
<!-- 									class="k-checkbox-label bdChk2" for="inp_chk4"></label></td> -->
<!-- 								<td>1000</td> -->
<!-- 								<td>더존비즈온</td> -->
<!-- 							</tr> -->
						</table>
					</div>

				</td>
			</tr>
		</table>
	</div>
</div>

</div>
<!-- //iframe wrap -->
</div>
<!-- //sub_contents -->