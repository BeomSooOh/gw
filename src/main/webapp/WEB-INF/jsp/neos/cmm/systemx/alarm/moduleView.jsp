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
	var alarmInfo = ${alarmList};
	
	$(document).ready(function() {
		$("#menuName").val(alarmInfo[0].flag2);
		$("#menuCode").val(alarmInfo[0].flag1);
		// 알림 테이블 그려주기
		fnAlarmTableGrid();
		
		// 저장 버튼 클릭
		$("#saveButton").click(function(){
			fnSaveAlarmDetail();
		});
		
		// 전체 선택 
		fnAllCheck();
		
		$("#menuNameDetail").html(alarmInfo[0].flag2);
		//$("#allTalk").attr("disabled", "");
	});
	
	// 알림 테이블 그려주기
	function fnAlarmTableGrid() {
		var tag = '';
		
		
		// 알림 항목 그려주기
		for(var i=0; i<alarmInfo.length; i++) {
			tag += '<tr class="item" onclick="fnAlarmInfo($(this))" id="' + alarmInfo[i].alertType + '" value="' + alarmInfo[i].note + '" >';
			tag +='<td class="le">' + alarmInfo[i].detailName + '</td>';
			tag += '<td>';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setAlert" id="alert_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminAlert + '"  />';
			tag += '<label class="k-checkbox-label" for="alert_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
			tag += '<td>';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setPush" id="push_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminPush + '"  />';
			tag += '<label class="k-checkbox-label" for="push_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
			tag += '<td>';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setTalk" id="talk_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminTalk + '"  />';
			tag += '<label class="k-checkbox-label" for="talk_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
			tag += '<td>';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setMail" id="mail_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminMail + '"  />';
			tag += '<label class="k-checkbox-label" for="mail_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
			tag += '<td style="display:none;">';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setSms" id="sms_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminSms + '"  />';
			tag += '<label class="k-checkbox-label" for="sms_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
			tag += '<td>';
			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setPortal" id="portal_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminPortal + '"  />';
			tag += '<label class="k-checkbox-label" for="portal_' + alarmInfo[i].alertType + '"></label><span></span>';
			tag += '</td>';
// 			tag += '<td>';
// 			tag += '<input type="checkbox" onclick="fnCheckBoxClick($(this))" name="setTimeline" id="timeline_' + alarmInfo[i].alertType + '" class="k-checkbox" value="' + alarmInfo[i].adminTimeline + '"  />';
// 			tag += '<label class="k-checkbox-label" for="timeline_' + alarmInfo[i].alertType + '"></label><span></span>';
// 			tag += '</td>';
			tag += '</tr>';
		}
		
		$("#alarmDetail").append(tag);
		
		fnAlarmListNotUse();
	}

	// 알림 설명
	function fnAlarmInfo(e) {
//		alert(e.html());
 		var menuCode = e.attr("id");
 		var explain = e.attr("value");
 		//alert(explain);
// 		//alert(e.parent().closest("tr").attr("id"));
		
 		$(".item").removeClass("on");
 		$("#" + menuCode).addClass("on");
		
 		$("#detail").html(explain);
	}

	
	function fnAlarmListNotUse() {
		var menu = ["alert", "push", "talk", "mail", "sms", "portal", "timeline"];
		
		for(var i=0; i<menu.length; i++) {
			for(var j=0; j<alarmInfo.length; j++) {
				// 마스터 권한 설정
	 			if(alarmInfo[0].masterAlert == "N") {
					$("#allAlert").prop("disabled", true);
					$("#alert_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allAlert").prop("checked", true);
					
				}
				
				if(alarmInfo[0].masterPush == "N") {
					$("#allPush").prop("disabled", true);
					$("#push_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allPush").prop("checked", true);
					
				}
				
				if(alarmInfo[0].masterTalk == "N") {
					$("#allTalk").prop("disabled", true);
					$("#talk_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allTalk").prop("checked", true);
					
				}
				
				if(alarmInfo[0].masterMail == "N") {
					$("#allMail").prop("disabled", true);
					$("#mail_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allMail").prop("checked", true);
					
				}
				
				if(alarmInfo[0].masterSms == "N") {
					$("#allSms").prop("disabled", true);
					$("#sms_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allSms").prop("checked", true);
					
				}
				
				if(alarmInfo[0].masterPortal == "N") {
					$("#allPortal").prop("disabled", true);
					$("#portal_" + alarmInfo[j].alertType).attr("disabled", "");
				} else {
					$("#allPortal").prop("checked", true);
					
				}
				
// 				if(alarmInfo[0].masterTimeline == "N") {
// 					$("#allTimeline").prop("disabled", true);
// 					$("#timeline_" + alarmInfo[j].alertType).attr("disabled", "");
// 				} else {
// 					$("#allTimeline").prop("checked", true);
					
// 				}	
				
				if($("#" + menu[i]+ "_" + alarmInfo[j].alertType).val() == "Y") {
					$("#" + menu[i]+ "_" + alarmInfo[j].alertType).prop("checked", true);
				} else if($("#" + menu[i]+ "_" + alarmInfo[j].alertType).val() == "B") {
					$("#" + menu[i]+ "_" +alarmInfo[j].alertType).css("display","none");
					$("label[for=" + menu[i] + "_" + alarmInfo[j].alertType + "]").removeClass("k-checkbox-label").css("display","none").next().html("-");
				}	
			}
		}
		
		fnCheckBox();
	}
	
	// 선택된 항목 저장 및 수정
	function fnSaveAlarmDetail() {
		//loadingStart();
		var alarmSetting = new Array();
		
		for(var i=0; i<alarmInfo.length; i++) {
			var alarmParam = {};
			
			alarmParam.alertType = alarmInfo[i].alertType;
			alarmParam.alert_yn = $("#alert_" + alarmInfo[i].alertType).val() != "B" ? ($("#alert_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.push_yn = $("#push_" + alarmInfo[i].alertType).val() != "B" ? ($("#push_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.talk_yn = $("#talk_" + alarmInfo[i].alertType).val() != "B" ? ($("#talk_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.mail_yn = $("#mail_" + alarmInfo[i].alertType).val() != "B" ? ($("#mail_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.sms_yn = $("#sms_" + alarmInfo[i].alertType).val() != "B" ? ($("#sms_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.portal_yn = $("#portal_" + alarmInfo[i].alertType).val() != "B" ? ($("#portal_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			alarmParam.timeline_yn = $("#portal_" + alarmInfo[i].alertType).val() != "B" ? ($("#portal_" + alarmInfo[i].alertType).is(":checked") ? "Y" : "N") : "B";
			
			alarmSetting.push(alarmParam);

		}		
		
		// 정상 코드
 		$.ajax({
			type: "POST"
			, url: "alarmDetailUpdate.do"
			, dataType: "json"
			, data: {paramMap : JSON.stringify(alarmSetting)}
			, success: function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010811","알림이 저장되었습니다")%>");
			}
			, error: function(result) {
				
			}
		}); 
	}
	
	// 체크박스 체크
	function fnCheckBox() {
		var menu = ["SCHEDULE", "PROJECT", "EAPPROVAL", "BOARD", "EDMS", "EXTEND", "MAIL", "RESOURCE", "WORK"];
		
		for(var i=0; i<menu.length; i++) {
			$("input:checkbox[name='setAlert']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allAlert").prop("checked", false);
					}	
				}
			});
			
			$("input:checkbox[name='setPush']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allPush").prop("checked", false);
					}
				}
				
			});
			
			$("input:checkbox[name='setTalk']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allTalk").prop("checked", false);
					}
				}
				
			});
			
			$("input:checkbox[name='setMail']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allMail").prop("checked", false);
					}
				}
				
			});
			
			$("input:checkbox[name='setSms']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allSms").prop("checked", false);
					}
				}
				
			});
			
			$("input:checkbox[name='setPortal']").each(function() {
				if($(this).val() != "B") {
					if(!$(this).is(":checked")) {
						$("#allPortal").prop("checked", false);
					}
				}
				
			});
			
// 			$("input:checkbox[name='setTimeline']").each(function() {
// 				if($(this).val() != "B") {
// 					if(!$(this).is(":checked")) {
// 						$("#allTimeline").prop("checked", false);
// 					}
// 				}
				
// 			});
		}
	}
	
	// 체크박스 클릭 이벤트
	function fnCheckBoxClick(data) {
		console.log($(data));
		var checkBoxId = $(data).attr("id");
		var alarmGubun = initCap(checkBoxId.split("_")[0]);
		var alarmParamGubun = checkBoxId.split("_")[0];

		//alert(checkBoxId);
		if(!$(data).is(":checked")) {
			$("#all" + alarmGubun).attr("checked", false);
		}
		
		// 항목 전체 클릭 시 전체 선택
		fnAllCheckBox(alarmParamGubun);
	}
	
	// 항목 전체 클릭 시 전체 선택 
	function fnAllCheckBox(alarmParamGubun) {
		var check = 0;
		var alarmGubun = initCap(alarmParamGubun);
		
		$("input:checkbox[name='set" + alarmGubun + "']").each(function(){
			//alert($(this).val());
			
			if($(this).val() != "B") {
				if(!$(this).is(":checked")) {
					check++;
				}	
			}
			
		});
		//alert(check);
		if(check==0) {
			$("#all" + alarmGubun).prop("checked", true);
		} else {
			$("#all" + alarmGubun).prop("checked", false);
		}
	}
	
	// 항목별 전체 클릭
	function fnAllCheck() {
		var menu = ["Alert", "Push", "Talk", "Mail", "Sms", "Portal", "Timeline"];
		
		 for(var i = 0; i<menu.length; i++) {
			$("input[name=all" + menu[i] + "]").each(function(){
				var small = menu[i].toLowerCase();
				$(this).click(function(){
					var id = $(this).attr('id');
					//alert(id);
					//var idIndex = id.indexOf("all");
					var gubun = id.split("all");
					//alert(gubun[1]);
					if($(this).is(":checked")) {
						$("input[name=set" + gubun[1] + "]").prop("checked", true);	
					} else {
						$("input[name=set" + gubun[1] + "]").prop("checked", false);
					}
					
				});
			}); 
		}
	}
	
	// 맨앞글씨 대문자 처리
	 function initCap(str) {
		 var str = str.substring(0, 1).toUpperCase() + str.substring(1, str.length).toLowerCase();
		 return str;
	 }
	
</script>
<div class="sub_contents_wrap" style="">
	<div id="" class="controll_btn">
		<button id="saveButton" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
	</div>

	<div class="alarm_ta">
		<table cellspacing="0" cellpadding="0">
			<tr class="">
				<th id="menuNameDetail"><%=BizboxAMessage.getMessage("TX000006671","공통")%><a href="#n" class="al_down"></a></th>
			</tr>
			<tr>
				<td class="td_class">
					<div class="com_ta2 alarm_ta_in">
						<table>
							<colgroup>
								<col width="" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
								<col width="70" />
							</colgroup>
							<thead>
								<th class="vm" style="color: black;"><%=BizboxAMessage.getMessage("TX000005521","항목")%></th>
								<th>
									<input type="checkbox" name="allAlert" id="allAlert" class="" value=""   /> <label class="mt8" for="allAlert"></label> 
									<label class="" for="allAlert"><span><%=BizboxAMessage.getMessage("TX000004025","메신저")%></span></label></br><span style="float:left;margin:-5px 0 0 24px; color: black;">Push</span></label>
								</th>
								<th>
									<input type="checkbox" name="allPush" id="allPush" class="" value=""  /> <label class="mt8" for="allPush"></label> 
									<label class="" for="allPush"><span><%=BizboxAMessage.getMessage("TX000016053","모바일")%></span></br><span style="float:left;margin:-5px 0 0 24px;">Push</span></label>
								</th>
								<th>
									<label class="" for="allTalk"><%=BizboxAMessage.getMessage("TX000007934","대화방")%></label></br>
									<input type="checkbox" name="allTalk" id="allTalk" class="" value=""  /><label class="" for="allTalk"></label>
								</th>
								<th>
									<label class="" for="allMail"><%=BizboxAMessage.getMessage("TX000000262","메일")%></label></br>
									<input type="checkbox" name="allMail" id="allMail" class="" value=""  /> <label class="" for="allMail"></label>
								</th>
								<th style="display:none;">
									<label class="" for="sllSms">SMS</label></br>
									<input type="checkbox" name="allSms" id="allSms" class="" value=""  /> <label class="" for="sllSms"></label>
								</th>
								<th>
									<label class="" for="allPortal"><%=BizboxAMessage.getMessage("TX000021955","메인알림")%></label></br>
									<input type="checkbox" name="allPortal" id="allPortal" class="" value=""  /><label class="" for="allPortal"></label>
									
								</th>
<!-- 								<th> -->
<!-- 									<input type="checkbox" name="allTimeline" id="allTimeline" class="k-checkbox" value=""  />  -->
<%-- 									<label class="k-checkbox-label" for="allTimeline"><%=BizboxAMessage.getMessage("TX000007364","타임라인")%></label> --%>
<!-- 								</th> -->
							</thead>
							<tbody id="alarmDetail">
<!-- 								<tr> -->
<!-- 									<td class="le">커스터마이징 알림 사용</td> -->
<!-- 									<td> -->
<!-- 										<span class="text_gray2">-</span> -->
<!-- 									</td> -->
<!-- 									<td> -->
<!-- 										<span class="text_gray2">-</span> -->
<!-- 									</td> -->
<!-- 									<td><input type="checkbox" name="inp_chk" id="td1_chk3" class="k-checkbox" checked />  -->
<!-- 										<label class="k-checkbox-label" for="td1_chk3"></label> -->
<!-- 									</td> -->
<!-- 									<td> -->
<!-- 										<input type="checkbox" name="inp_chk" id="td1_chk4" class="k-checkbox" checked />  -->
<!-- 										<label class="k-checkbox-label" for="td1_chk4"></label> -->
<!-- 									</td> -->
<!-- 									<td><span class="text_gray2">-</span></td> -->
<!-- 									<td><span class="text_gray2">-</span></td> -->
<!-- 									<td><span class="text_gray2">-</span></td> -->
<!-- 								</tr> -->
							</tbody>
						</table>
					</div> <!--// com_ta2 alarm_ta_in 공통-->
				</td>
			</tr>
		</table>
	</div>
	
	<div class="com_ta6 mt40" >
		<table>
			<tr>
				<th class=""><%=BizboxAMessage.getMessage("TX000016181","알림 상세 설명")%></th>
			</tr>
			<tr>
				<td class="le" style="height: 105px" id="detail"></td>
			</tr>
		</table>
	</div>
	
	<input type="hidden" id="menuName" value=""/>
	<input type="hidden" id="menuCode" value=""/>
</div>
