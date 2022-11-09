<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	var orgChartList = null;	// 조직도 리스트
	var dupOrgEmpListJson = null;	// 중복 처리할 사용자 리스트
	//var dupOrgDeptListJson = null;	// 중복 처리할 부서 리스트
	var deIdx = 0;	// 사용자/부서 선택 테이블 인덱스
	var selIdx = 0;	// 검색 선택 처리 인덱스
	var initFlag = true;
	
	var mode = ('${params.mode}' || '');
	var langCode = ('${langCode}' || 'kr');
	var groupSeq = ('${groupSeq}' || '');
	var compSeq = ('${compSeq}' || '');
	var deptSeq = ('${deptSeq}' || '');
	var empSeq = ('${empSeq}' || '');
	
	//프로필 생년월일 표시 설정 - 공통옵션
	//1 : 월-일,   0 : 년도-월-일
	var cmm2200 = '${sCm2200}';	
	
	$(document).ready(function(){
		OJT_fnSetTreeWidth("245");
		OJT_fnSetTreeHeight("623");
		
		//alert(groupSeq + "/" + compSeq + "/" + deptSeq + "/" + empSeq);
		
		var paramSet = {};
		paramSet.groupSeq = groupSeq;
		paramSet.empSeq = empSeq || '';
		paramSet.deptSeq = deptSeq || '';
		paramSet.compSeq = compSeq || '';
		
		paramSet.selectMode = 'd';
		paramSet.selectItem = 'm';

		paramSet.nodeChageEvent = 'fnNodeSelect';

		paramSet.langCode = langCode || '';
		paramSet.initMode = '';
		/** 정의 : /orgchart/include/orgJsTree.jsp  **/
		OJT_documentReady(paramSet);
		// 검색 엔터
		$("#searchText").keydown(function(e){
			if(e.keyCode==13) {
				fnSearch();	
			}
				
		});	
		
		$("#allCheck").click(function(){
			
			if($(this).is(":checked")){
				$("input[name=chk]").attr("checked", true);
			} else {
				$("input[name=chk]").attr("checked", false);
			}
		});
		
	});
	
	
	
	function fnNodeSelect(data){
		
		//fnSetScrollToNode(data.selectedId);
		callbackOrgChart(data);
		
		if(!initFlag) {
			$("#searchText").val("");
			$("#photoImage").attr("src", "../../Images/temp/pic_Noimg.png");
			$("#name").text("");
			$("#phone").text("");
			$("#birth").text("");
			$("#compNum").text("");
			$("#faxNum").text("");
			$("#compMail").text("");
			$("#myMail").text("");
			$("#dept").text("");
			$("#duty").text("");
			$("#position").text("");
			$("#mainWork").text("");
		}
	}
	
	// 처음 선택 부서 정보 가져오기  langCode추가 2022-04-20
	function fnMyDeptInfo() {
		var dept = $(".jstree-clicked").attr("id").split("_")[0];
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/userProfileInfo.do" />',
			data:{deptSeq:dept,langCode:langCode},
			datatype:"json",			
			success:function(data){
				if(data != null || data !="") {
					fnUserInfoDraw(data.list);	
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>");
				}
				
			}
		});
	}
	
	// 팀별 유저 정보 그려주기
	function fnUserInfoDraw(userInfo) {
		var tag = '';

		for(var i=0; i<userInfo.length; i++) {		
			var dept = userInfo[i].pathName.split("|");
			var len = dept.length - 2;
			var displayDept = dept[len];
			
			tag += '<tr id="' + userInfo[i].empSeq + '" class="deptEmpInfo" onclick="fnClickUserInfo(\''+userInfo[i].compSeq+'\', \''+userInfo[i].deptSeq+'\', \''+userInfo[i].empSeq+'\')">';
			tag += '<td>' + userInfo[i].deptName + '</td>';
			tag += '<td>' + userInfo[i].positionCodeName + '</td>';
			tag += '<td>' + userInfo[i].dutyCodeName + '</td>';
			tag += '<td>' + userInfo[i].name + '(' + userInfo[i].loginId + ')</td>';
			tag += '<td>' + (userInfo[i].telNum || '') + '</td>';
			tag += '<td>' + (userInfo[i].mobileTelNum || '') + '</td>';
			tag += '</tr>';
			
		}
		
		$("#userInfo").html(tag);
		
		if(initFlag) {
			fnClickUserInfo(compSeq, deptSeq, empSeq);
		}
	}
	
	// 팀원 상세보기
	function fnClickUserInfo(comp_seq, dept_seq, emp_seq) {
		$(".deptEmpInfo").removeClass("on");
		$("#" + emp_seq).addClass("on");
		
		if(initFlag) {
			
			var offset = $("#" + emp_seq).offset();
			
			if(offset){
				$('.ova_sc').animate({scrollTop : offset.top}, 400);	
			}
			
			initFlag = false;
		}
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/userProfileInfo.do" />',
			data:{compSeq : comp_seq, deptSeq : dept_seq, empSeq : emp_seq, mode:mode, langCode:langCode},
			datatype:"json",			
			success:function(data){
				if(data != null || data !="") {
					var dept = data.list[0].pathName.split("|");
					var len = dept.length - 2;
					var displayDept = dept[len];
					var name = data.list[0].name + "(" + data.list[0].loginId + ")";
					var phone = data.list[0].mobileTelNum;
					var birth = data.list[0].bday;
					var compNum = data.list[0].telNum;
					var faxNum = data.list[0].faxNum;
					var dept = data.list[0].pathName;  
					var duty = data.list[0].dutyCodeName;
					var position = data.list[0].positionCodeName;
					var picFileId = data.list[0].picFileId;
					var mainWork = data.list[0].mainWork;
					var privateYn = data.list[0].privateYn;
					var deptArray = dept.split("|");
					
					//메일주소
					var compMail = "";
					var myMail = "";
					var display = "";
					var displayDept = "";
					
					if(data.list[0].emailAddr != "" && data.list[0].emailDomain != ""){
						compMail = data.list[0].emailAddr + "@" + data.list[0].emailDomain;
					}
					
					if(data.list[0].outMail != "" && data.list[0].outDomain != ""){
						myMail = data.list[0].outMail + "@" + data.list[0].outDomain;
					}
					
					for(var i=0; i<deptArray.length; i++) {
						display += deptArray[i] + ' > ';
					}
					
					displayDept = display.slice(0,-2);
					
					$("#name").text(name);
					$("#phone").text((phone || ''));
					if(privateYn == "Y"){
						if(cmm2200 == "0" || birth == null){
							if(birth == null)
								birth = "";
							$("#birth").text(birth);
						}
						else{
							$("#birth").text(birth.substring(5));
						}
					} else {
						$("#birth").text("");
					}
					
					$("#compNum").text((compNum||''));
					$("#faxNum").text((faxNum||''));
					$("#compMail").text(compMail);
					$("#myMail").text(myMail);
					$("#dept").text(displayDept);
					$("#duty").text(duty);
					$("#position").text(position);
					if(mainWork == null) {
						$("#mainWork").text("");
					} else {
						$("#mainWork").text(mainWork);	
					}
					
					$("#photoImage").attr("src", "/gw/cmm/file/fileDownloadProc.do?fileId="+ picFileId + "&fileSn=0");
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>");
				}
			}
		});
	}
	
	// 부서 노드 클릭 시 부서원 정보 가져오기 //langCode추가 2020-04-20
	function callbackOrgChart(data) {
		var dept = data.selectedId;
		
		if(data.orgGubun == "c" || data.orgGubun == "b"){
			var returnValue = {};
			returnValue.list = [];
			fnUserInfoDraw(returnValue.list);
		}			
		else{
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/userProfileInfo.do" />',
				data:{deptSeq:dept,langCode:langCode},
				datatype:"json",			
				success:function(data){
					if(data != null || data !="") {
						fnUserInfoDraw(data.list);	
					} else {
						alert("<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>");
					}
					
				}
			});
		}
	}
	
	// 사원 검색
	function fnSearch() {
		var param = {};
		var select = '';
		var selectContent = '';
		
		select = $("#searchSelectBox").val();
		selectContent = $("#searchText").val();
		
		param.searchSelect = select;
		param.searchContent = selectContent;
		
		// 검색 후 초기화
		$("#photoImage").attr("src", "../../Images/temp/pic_Noimg.png");
		$("#name").text("");
		$("#phone").text("");
		$("#birth").text("");
		$("#compNum").text("");
		$("#faxNum").text("");
		$("#compMail").text("");
		$("#myMail").text("");
		$("#dept").text("");
		$("#duty").text("");
		$("#position").text("");
		$("#mainWork").text("");
		
		if(selectContent != ""){
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/userProfileInfoListNew.do" />',
				data:param,
				datatype:"json",			
				success:function(data){
					if(data != null || data != "") {
						fnUserInfoDraw(data.list);	
					} else {
						alert("<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>");
					}
					
				}
			});
		} else {
			alert("<%=BizboxAMessage.getMessage("TX000002582","검색어를 입력해 주세요.")%>");
		}
	}
	
	function excelExport(){
		var url = "<c:url value='/cmm/systemx/orgExcelRangeSelectPop.do'/>";
		
		openWindow2(url,  "", 370, 200, 0);
	}
		
</script>

<div class="pop_wrap" style="min-width:898px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000004738","조직도")%></h1>
		<a href="#n" class="clo"><img
			src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">
		<table cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="250"/>
				<col width=""/>
			</colgroup>
			<tr>
				<td class="vt">
					<jsp:include page="../include/orgJsTree.jsp" flush="false" />
				</td>
				<td class="pl10 vt">
					<div class="top_box">
						<div class="top_box_in">
							<div id="" class="dod_search posi_re">
								<select id="searchSelectBox" class="selectmenu" style="width:100px;">
									<option value="empNmSearch" selected="selected"><%=BizboxAMessage.getMessage("TX000000076","사원명")%>(ID)</option>
									<option value="deptNmSearch"><%=BizboxAMessage.getMessage("TX000000068","부서명")%></option>
									<option value="positionNmSearch"><%=BizboxAMessage.getMessage("TX000018672","직급")%></option>
									<option value="dutyNmSearch"><%=BizboxAMessage.getMessage("TX000000105","직책")%></option>
									<option value="telNoSearch"><%=BizboxAMessage.getMessage("TX000000073","전화번호")%></option>
									<option value="mobileSearch"><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></option>
								</select>
								<input type="text" class="kr" id="searchText" style="width:250px;text-indent:4px;"/>
								<input type="button" id="searchButton" onclick="fnSearch();" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" />
							</div>
						</div>
					</div>

				<div class="trans_top_btn mt10">
					<div class="option_top">
						<ul>
							<li class="tit_li"><%=BizboxAMessage.getMessage("TX000013655","사원목록")%><span id="empCount"></span></li>			
						</ul>
						
						<div id="" class="controll_btn p0 fr">
						
						<c:if test="${excelDownYn == 'Y'}">
							<button id="" onclick="excelExport();"><%=BizboxAMessage.getMessage("TX000006928","엑셀저장")%></button>
						</c:if>
												
						</div>
					</div>
				</div>
				<div class="com_ta2 sc_head mt10">
					<table>
						<colgroup>
								<col width="12.9%">
								<col width="12.9%">
								<col width="12.9%">
								<col width="22%">
								<col width="19.5%">
								<col width="">
							</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000076","사원명")%>(ID)</th>
							<th><%=BizboxAMessage.getMessage("TX000000073","전화번호")%></th>
							<th><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
						</tr>
					</table>
				</div>
				<div class="com_ta2 bg_lightgray ova_sc2" style="height:185px">
					<table>
						<colgroup>
								<col width="12.9%">
								<col width="12.9%">
								<col width="12.9%">
								<col width="22%">
								<col width="19.5%">
								<col width="">
						</colgroup>
						<tbody id="userInfo"></tbody>
					</table>
				</div>

				<!-- 부서사원선택후 테이블 -->
				<div class="mt10" >	
					<table cellpadding="0" cellspacing="0" style="width:100%;">
						<colgroup>
							<col width="180"/>
							<col width=""/>
						</colgroup>
						<tr>
							<td class="vt">
								<!-- 이미지 -->
								<ul>
									<li class="mypage_file" style="width: 180px; height: 295px;">
										<p class="imgfile" id="">
											<span class="posi_re dp_ib"> 
												<img class="userImg" id="photoImage" src="" alt="" onerror="this.src='../../Images/temp/pic_Noimg.png'" />
											</span>
										</p>
									</li>
								</ul>
							</td>
							<td class="vt pl10">
								<div class="com_ta">
									<table>
										<colgroup>
											<col width="19.4%"/>
											<col width="30.6%"/>
											<col width="19.4%"/>
											<col width=""/>
										</colgroup>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000076","사원명")%>(ID)</th>
											<td id="name"></td>
											<th><%=BizboxAMessage.getMessage("TX000000083","생년월일")%></th>
											<td id="birth"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
											<td id="position"></td>
											<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
											<td id="duty"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000020525","전체부서")%></th>
											<td colspan="3" id="dept"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
											<td colspan="3" id="phone"></td>
										</tr>
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000073","전화번호")%></th>
											<td id="compNum"></td>
											<th><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
											<td id="faxNum"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000020522","회사메일")%></th>
											<td colspan="3" id="compMail"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000020523","개인메일")%></th>
											<td colspan="3" id="myMail"></td>
										</tr>
										
										<tr>
											<th><%=BizboxAMessage.getMessage("TX000000088","담당업무")%></th>
											<td colspan="3" id="mainWork"></td>
										</tr>										
									</table>
								</div>
							</td>
						</tr>
					</table>
				</div>
				</td>
			</tr>
		</table>

	</div><!--// pop_con -->

</div>
<!--// pop_wrap -->