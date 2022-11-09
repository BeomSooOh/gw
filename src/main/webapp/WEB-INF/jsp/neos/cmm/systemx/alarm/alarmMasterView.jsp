<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	$(document).ready(function(){
		// 버튼 초기화
		fnButtonInit();

	});

	// 버튼 초기화
	function fnButtonInit() {
		// 저장 버튼 동작
		$("#alarmSaveButton").click(function(){
			fnAlarmSave();
		});
		
		// 전체 체크 박스 동작
		$("input[name='all_chk']").click(function(){
			var allChkID = $(this).attr("id");
			
			fnAllCheck(allChkID);
		});
	}
		
	// 알림 설정 저장
	function fnAlarmSave() {
		// 알림 설정 체크 값
		var alarmInfo = new Array();
		var compChoiceCount = 0;
		
		// 모든 회사 체크 값 저장
 		$(".companyList").each(function(){
 			var param = {};	
			var compSeq = $(this).attr("id");	
			var compCheck = false;
			
			
 			param.compSeq = compSeq;
			param.alert = $(this).find("#alert" + compSeq).is(":checked") ? "Y" : "N";
			param.push = $(this).find("#push" + compSeq).is(":checked") ? "Y" : "N";
			param.talk = $(this).find("#talk" + compSeq).is(":checked") ? "Y" : "N";
			param.mail = $(this).find("#mail" + compSeq).is(":checked") ? "Y" : "N";
			param.sms = $(this).find("#sms" + compSeq).is(":checked") ? "Y" : "N";
			
			// 체크 된 회사만 알림정보 저장
			if($(this).find("#compSeq" + compSeq).is(":checked")){
				alarmInfo.push(param);
				compChoiceCount++;
			} else {
				param = {};
			}
		}); 
		
		// 회사 선택이 하나도 안 된 상태로 저장 버튼 눌렀을 때
		if(compChoiceCount == 0) {
			alert('<%=BizboxAMessage.getMessage("TX000010812","회사가 선택되지 않았습니다. 회사를 선택해주세요.")%>');
			return;
		}
		
 		$.ajax({
			type: "post"
			, url: "alarmUpdate.do"
			, dataType: "json"
			, data:  {paramMap : JSON.stringify(alarmInfo) } 
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000002120","저장 되었습니다.")%>");
				$("#reloadPage").submit();
			}
			, error: function (request, status, error){
                alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
			
		});
	}
	
	// 전체 체크 박스 선택
	function fnAllCheck(id) {
		if($("#" + id).is(":checked")) {
			$("input[name='" + id + "']").prop("checked", true);
		} else {
			$("input[name='" + id + "']").prop("checked", false);
		}
	}

</script>

<div class="sub_contents_wrap" style="">
	<div id="" class="controll_btn">
		<button id="alarmSaveButton" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	</div>

	<div class="com_ta2 alarm_ta_in bdt">
		<table>
			<colgroup>
				<col width="50" />
				<col width="" />
				<col width="70" />
				<col width="70" />
				<col width="70" />
				<col width="70" />
				<col width="70" />
				<col width="70" />
			</colgroup>
			<tr>
				<th class="vm one_inp">
					<input type="checkbox" name="all_chk" id="company" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="company"></label>
				</th>
				<th class="vm"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th><input type="checkbox" name="all_chk" id="alarm" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="alarm"><%=BizboxAMessage.getMessage("TX000000893","알림")%></label>
				</th>
				<th><input type="checkbox" name="all_chk" id="push" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="push">Push</label>
				</th>
				<th><input type="checkbox" name="all_chk" id="talk" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="talk"><%=BizboxAMessage.getMessage("TX000007934","대화방")%></label>
				</th>
				<th><input type="checkbox" name="all_chk" id="mail" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="mail"><%=BizboxAMessage.getMessage("TX000000262","메일")%></label>
				</th>
				<th style="display:none;"><input type="checkbox" name="all_chk" id="sms" class="k-checkbox" /> 
					<label class="k-checkbox-label" for="sms">SMS</label>
				</th>
				<th class="vm"><%=BizboxAMessage.getMessage("TX000010833","포털")%></th>
				<th class="vm"><%=BizboxAMessage.getMessage("TX000007364","타임라인")%></th>
			</tr>
			<c:forEach var="compLists" items="${compList}" varStatus="status">
				<tr class="companyList" id="${compLists.compSeq}">
					<td>
						<input type="checkbox" name="company" id="compSeq${compLists.compSeq}" class="k-checkbox" />
						<label class="k-checkbox-label" for="compSeq${compLists.compSeq}"></label>
					</td>
					<td class="le"><a href="#n">${compLists.compName}</a></td>
					<td>
						<input type="checkbox" name="alarm" id="alert${compLists.compSeq}" class="k-checkbox"  
							<c:if test="${compLists.alert=='Y'}">checked</c:if>
						/> 
						<label class="k-checkbox-label" for="alert${compLists.compSeq}"></label>
					</td>
					<td>
						<input type="checkbox" name="push" id="push${compLists.compSeq}" class="k-checkbox"  
							<c:if test="${compLists.push=='Y'}">checked</c:if>						
						/> 
						<label class="k-checkbox-label" for="push${compLists.compSeq}"></label>
					</td>
					<td>
						<input type="checkbox" name="talk" id="talk${compLists.compSeq}" class="k-checkbox"  
							<c:if test="${compLists.talk=='Y'}">checked</c:if>
						/> 
						<label class="k-checkbox-label" for="talk${compLists.compSeq}"></label>
					</td>
					<td>
						<input type="checkbox" name="mail" id="mail${compLists.compSeq}" class="k-checkbox"  
							<c:if test="${compLists.mail=='Y'}">checked</c:if>						
						/> 
						<label class="k-checkbox-label" for="mail${compLists.compSeq}"></label>
					</td>
					<td style="display:none;">
						<input type="checkbox" name="sms" id="sms${compLists.compSeq}" class="k-checkbox"  
							<c:if test="${compLists.sms=='Y'}">checked</c:if>						
						/> 
						<label class="k-checkbox-label" for="sms${compLists.compSeq}"></label>
					</td>
					<td colspan="2"><%=BizboxAMessage.getMessage("TX000016351","기본사용")%></td>
				</tr>	
			</c:forEach>
		</table>
	</div>
	<!--// com_ta2 alarm_ta_in 공통-->

	<p class="mt10 ar"><%=BizboxAMessage.getMessage("TX000016458","* 알림, Push, 대화방 사용시 회사별 기본 체크박스 처리")%></p>

	<form action="alarmMasterView.do" id="reloadPage">
	</form>
	<!-- <div class="paging mt20">
		<span class="pre_pre"><a href="">10페이지전</a></span> <span class="pre"><a
			href="">이전</a></span>
		<ol>
			<li class="on"><a href="">1</a></li>
			<li><a href="">2</a></li>
			<li><a href="">3</a></li>
			<li><a href="">4</a></li>
			<li><a href="">5</a></li>
			<li><a href="">6</a></li>
			<li><a href="">7</a></li>
			<li><a href="">8</a></li>
			<li><a href="">9</a></li>
			<li><a href="">10</a></li>
		</ol>
		<span class="nex"><a href="">다음</a></span> <span class="nex_nex"><a
			href="">10페이지다음</a></span>
	</div> -->
</div>