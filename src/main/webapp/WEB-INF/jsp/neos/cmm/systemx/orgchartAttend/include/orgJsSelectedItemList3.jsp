<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<div class="com_ta2">
		<span class="txt mb5 pl5 pb5" style="display:block;" id="li_selected_item_disp_name"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></span>
		<!-- 사원 단일 선택 -->
		<table class="orgChartSelectedItemList " id="div_org_selected_item_list_us">
			<colgroup>
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_us">
			<table class="tb_selected_item_list">
				<colgroup>
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>

		
		<!-- 부서 단일 선택 -->
 		<table class="orgChartSelectedItemList" id="div_org_selected_item_list_ds">
			<colgroup>
				<col width="160" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ds">
			<table class="tb_selected_item_list">
				<colgroup>
					<col width="160" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		
		
		
		<!-- 사원 복수 선택 -->
		<table class="orgChartSelectedItemList" id="div_org_selected_item_list_um">
			<colgroup>
				<col width="34" />
				<col width="125" />
				<col width="90" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_um" class="k-checkbox all_check_selected_item" />
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_um" style=""></label>
				</th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_um">
			<table class="tb_selected_item_list">
				<colgroup>
					<col width="34" />
					<col width="125" />
					<col width="90" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		
		
		
		<!-- 부서 복수 선택 -->
		<table class="orgChartSelectedItemList" id="div_org_selected_item_list_dm">
			<colgroup>
				<col width="34" />
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_dm" class="k-checkbox all_check_selected_item">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_dm" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_dm">
			<table class="tb_selected_item_list">
				<colgroup>
					<col width="34" />
					<col width="130" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>
		
		
		<!-- 사원,부서 복수 선택 -->
		<table class="orgChartSelectedItemList" id="div_org_selected_item_list_ud">
			<colgroup>
				<col width="34" />
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_ud" class="k-checkbox all_check_selected_item">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_ud" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ud">
			<table class="tb_selected_item_list">
				<colgroup>
					<col width="34" />
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		<span class="txt mb5 pl5 pb5 mt20" style="display:block;" id="li_selected_item_disp_name1"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></span>
		<!-- 사원 단일 선택 -->
		<table class="orgChartSelectedItemList1" id="div_org_selected_item_list_us1">
			<colgroup>
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList1" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_us1">
			<table class="tb_selected_item_list1">
				<colgroup>
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>
				
		
		<!-- 부서 단일 선택 -->
 		<table class="orgChartSelectedItemList1" id="div_org_selected_item_list_ds1">
			<colgroup>
				<col width="160" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList1" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ds1">
			<table class="tb_selected_item_list1">
				<colgroup>
					<col width="160" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		
		<!-- 사원 복수 선택 -->
		<table class="orgChartSelectedItemList1" id="div_org_selected_item_list_um1">
			<colgroup>
				<col width="34" />
				<col width="125" />
				<col width="90" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_um1" class="k-checkbox all_check_selected_item1" />
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_um1" style=""></label>
				</th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList1" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_um1">
			<table class="tb_selected_item_list1">
				<colgroup>
					<col width="34" />
					<col width="125" />
					<col width="90" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>

		
		<!-- 부서 복수 선택 -->
		<table class="orgChartSelectedItemList1" id="div_org_selected_item_list_dm1">
			<colgroup>
				<col width="34" />
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_dm1" class="k-checkbox all_check_selected_item1">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_dm1" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList1" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_dm1">
			<table class="tb_selected_item_list1">
				<colgroup>
					<col width="34" />
					<col width="130" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		
		
		
		<!-- 사원,부서 복수 선택 -->
		<table class="orgChartSelectedItemList1" id="div_org_selected_item_list_ud1">
			<colgroup>
				<col width="34" />
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_ud1" class="k-checkbox all_check_selected_item1">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_ud1" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList1" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ud1">
			<table class="tb_selected_item_list1">
				<colgroup>
					<col width="34" />
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		<span class="txt mb5 pl5 pb5 mt20" style="display:block;" id="li_selected_item_disp_name2"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></span>
		<!-- 사원 단일 선택 -->
		<table class="orgChartSelectedItemList2" id="div_org_selected_item_list_us2">
			<colgroup>
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList2" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_us2">
			<table class="tb_selected_item_list2">
				<colgroup>
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		
		<!-- 부서 단일 선택 -->
 		<table class="orgChartSelectedItemList2" id="div_org_selected_item_list_ds2">
			<colgroup>
				<col width="160" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList2" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ds2">
			<table class="tb_selected_item_list2">
				<colgroup>
					<col width="160" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		
				
		
		<!-- 사원 복수 선택 -->
		<table class="orgChartSelectedItemList2" id="div_org_selected_item_list_um2">
			<colgroup>
				<col width="34" />
				<col width="125" />
				<col width="90" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_um2" class="k-checkbox all_check_selected_item2" />
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_um2" style=""></label>
				</th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList2" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_um2">
			<table class="tb_selected_item_list2">
				<colgroup>
					<col width="34" />
					<col width="125" />
					<col width="90" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		
		<!-- 부서 복수 선택 -->
		<table class="orgChartSelectedItemList2" id="div_org_selected_item_list_dm2">
			<colgroup>
				<col width="34" />
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_dm2" class="k-checkbox all_check_selected_item2">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_dm2" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList2" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_dm2">
			<table class="tb_selected_item_list2">
				<colgroup>
					<col width="34" />
					<col width="130" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>		

		
		<!-- 사원,부서 복수 선택 -->
		<table class="orgChartSelectedItemList2" id="div_org_selected_item_list_ud2">
			<colgroup>
				<col width="34" />
				<col width="100" />
				<col width="100" />
				<col width="75" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_selected_chk_all_ud2" class="k-checkbox all_check_selected_item2">
					<label class="k-checkbox-label bdChk2" for="inp_selected_chk_all_ud2" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList2" style="height:111px;margin-top:0px;" id="div_org_selected_item_list2_ud2">
			<table class="tb_selected_item_list2">
				<colgroup>
					<col width="34" />
					<col width="100" />
					<col width="100" />
					<col width="75" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>
				
	</div>
		

<script type="text/javascript">	

/* [페이지 준비] 페이지 로드 완료시 호출
 * defaultInfo : 팝업 호출시의 옵션및 사용자 기본 정보
-----------------------------------------------*/
function OJSI_documentReady(defaultInfo) {
// 	var selectMode = (defaultInfo.selectMode + defaultInfo.selectItem).substring(0, 2);
// 	// 기본 옵션에 따른 디스플레이 선택
// 	if (selectMode.substring(0, 1) === 'o'){
// 		$('.box_right2').hide();
// 	}
	/*옵션값 선택에 따른 테이블 그려주기*/
	OJSI_fnSetAreaDraw(defaultInfo);
	/*버튼 이벤트 정의*/
	OJSI_fnSetBtnEvent(defaultInfo);
	/* 기본 출력데이터 표기 영역 */
	OJSI_fnSetSelectedInfo(defaultInfo, 0);
	OJSI_fnSetSelectedInfo1(defaultInfo, 0);
	OJSI_fnSetSelectedInfo2(defaultInfo, 0);
	/* 체크 박스 전체선택 이벤트 지정 */
	OJSI_fnSetAllCheckEvent_Selected(defaultInfo);
	/* 선택 영역  */
	//OJSI_fnSetShowDiv(defaultInfo);

}


function OJSI_fnSetAreaDraw(defaultInfo) {
	var selectMode = (defaultInfo.selectMode + defaultInfo.selectItem).substring(0, 2);
	// 기본 옵션에 따른 디스플레이 선택
	if (selectMode.substring(0, 1) === 'o'){
		$('.box_right2').hide();
		$('.posi_ab').hide();
	}
	
	$('.orgChartSelectedItemList').hide();
	$('.orgChartSelectedItemList1').hide();
	$('.orgChartSelectedItemList2').hide();
	var selectAreaInfos = defaultInfo.extendSelectAreaInfo.split("$");
	
	for(var i=0; i<selectAreaInfos.length; i++) {
		var replaceMode = selectAreaInfos[i].split("|")[1];
		var newSelectMode = selectMode.replace(selectMode.substring(1, 2), replaceMode);
		
		if(defaultInfo.selectMode == "ud") {
			newSelectMode = "ud";
		}
		
		if(i==0) {
			$('#div_org_selected_item_list_' + newSelectMode).show();
		 	$('#div_org_selected_item_list2_' + newSelectMode).show();
		} else if(i==1) {
			$('#div_org_selected_item_list_' + newSelectMode + "1").show();
		 	$('#div_org_selected_item_list2_' + newSelectMode + "1").show();
		} else {
			$('#div_org_selected_item_list_' + newSelectMode + "2").show();
		 	$('#div_org_selected_item_list2_' + newSelectMode + "2").show();
		}
	}
	
}


/* [ 테이블 ] 선택된 아이템 테이블 그리기
 * Call By : /include/orgJsItemList.jsp
-----------------------------------------------*/
var selectedItemSuperKeys = new Map();
var firstCall = true;
function OJSI_fnSetSelectedItemList(defaultInfo, param) {

	// 단일선택 모드일 경우 선택되었던 로우 삭제(중복 픽 방지)
// 	if (defaultInfo.selectItem === 's') {
// 		$('.selectedItemRow').remove();
// 		selectedItemSuperKeys.clear();
// 	}
	

	
	var extendSelectAreaInfoArray = defaultInfo.extendSelectAreaInfo.split("$");
	var extendSelectAreaSelectItem = extendSelectAreaInfoArray[0].split("|")[1];
	
	if(defaultInfo.selectMode == "ud") {
		extendSelectAreaSelectItem = "m";
	}
	
	if (extendSelectAreaSelectItem === 's') {
		if($('.selectedItemRow').length){
			$('#removeDiv').click();
		}
		$('.selectedItemRow').remove();
		selectedItemSuperKeys.clear();
	}
	
	/* 테이블 로우 정보 생성. */
	var insertRowHtml = '';
	var trTag = '';
	var colName = '';

	
	
	// 파라미터 배열만큼 반복하여 tr 구성
	var correction = $('.orgChartSelectedItemList:visible tr').length - 1 ;
	for (var i = 0; i < param.length; i++) {
		
		trTag = '<tr class="selectedItemRow" id="s_' + param[i].deptSeq +  '_' + param[i].empSeq + '">';
		// 컬럼 만큼 반복하여 td 구성
		$('.orgChartSelectedItemList:visible th').each(function (index, item) {
			colName = $(item).attr('class').toString().replace('itemTb_', '');
			if (colName === 'cen') {
				trTag += '<td class="cen"><input type="checkbox" name="inp_chk" id="selected_inp_chk_indexOf' + (i + correction) + '" class="k-checkbox chkbx_checkedData chkSel2" value=\'' + JSON.stringify(param[i])+ '\'> <label class="k-checkbox-label bdChk2" for="selected_inp_chk_indexOf' + (i + correction) + '" style=""></label></td>'
			} else {
				var data = param[i][colName] || '';
				var advancedData = (param[i][colName+'Adv'] || '');
				
				trTag += '<td class="le">' + ( (data + advancedData ) || '') + '</td>'
			}
		});
		selectedItemSuperKeys.put(param[i].superKey, true);
		trTag += "<input type='hidden' value='" + JSON.stringify(param[i]) + "'/></tr>";

		// 추가하기 전 중복검사를 통한 중복아이템 제거
		var duplicateFlag = false;
		$('.chkbx_checkedData').each(function () {
			var superKey = JSON.parse($(this).val()).superKey;
			if (param[i].superKey == superKey) {
				duplicateFlag = true;
			}
		});
		if (!duplicateFlag) {
			insertRowHtml += trTag;
		}
	}
	
	/* 테이블 로우 정보 삽입 */
	$('.tb_selected_item_list:visible > tbody:last').prepend(insertRowHtml);

	$('.selectedItemRow').click(function(){
		$('.selectedItemRow').removeClass("on");
		$(this).addClass("on");
	});
	
	/* 데이터 기본정보 변경 */
	OJSI_fnSetSelectedInfo(defaultInfo, $('.tb_selected_item_list:visible > tbody > tr').length);
	
	/* 아이템 선택여부 백그라운드 처리 */
	//OJIL_fnSetTableBGColor(defaultInfo);
	
	/* 최초 호출시 기능옵션 처리 영역 */
	if(firstCall){
		
		/* 기능 옵션 / 최초 선택 아이템 삭제 불가능 */
		if(defaultInfo.noUseDeleteBtn) {
			$('.selectedItemRow input:checkbox').attr("disabled", true);
		}	
		firstCall = false;
	}
}


function OJSI_fnSetSelectedItemList1(defaultInfo, param) {

	// 단일선택 모드일 경우 선택되었던 로우 삭제(중복 픽 방지)
// 	if (defaultInfo.selectItem === 's') {
// 		$('.selectedItemRow1').remove();
// 		selectedItemSuperKeys.clear();
// 	}
	
	var extendSelectAreaInfoArray = defaultInfo.extendSelectAreaInfo.split("$");
	var extendSelectAreaSelectItem = extendSelectAreaInfoArray[1].split("|")[1];
	
	if(defaultInfo.selectMode == "ud") {
		extendSelectAreaSelectItem = "m";
	}
	
	if (extendSelectAreaSelectItem === 's') {
		if($('.selectedItemRow1').length){
			$('#removeDiv1').click();
		}
		$('.selectedItemRow1').remove();
		selectedItemSuperKeys.clear();
	}
	
	/* 테이블 로우 정보 생성. */
	var insertRowHtml = '';
	var trTag = '';
	var colName = '';
	

	
	
	// 파라미터 배열만큼 반복하여 tr 구성
	var correction = $('.orgChartSelectedItemList1:visible tr').length - 1 ;
	for (var i = 0; i < param.length; i++) {
		
		trTag = '<tr class="selectedItemRow1" id="s_' + param[i].deptSeq + "_" + param[i].empSeq + '">';
		// 컬럼 만큼 반복하여 td 구성
		$('.orgChartSelectedItemList1:visible th').each(function (index, item) {
			colName = $(item).attr('class').toString().replace('itemTb_', '');
			if (colName === 'cen') {
				trTag += '<td class="cen"><input type="checkbox" name="inp_chk" id="selected_inp_chk_indexOf1' + (i + correction) + '" class="k-checkbox chkbx_checkedData1 chkSel2" value=\'' + JSON.stringify(param[i])+ '\'> <label class="k-checkbox-label bdChk2" for="selected_inp_chk_indexOf1' + (i + correction) + '" style=""></label></td>'
			} else {
				var data = param[i][colName] || '';
				var advancedData = (param[i][colName+'Adv'] || '');
				
				trTag += '<td class="le">' + ( (data + advancedData ) || '') + '</td>'
			}
		});
		selectedItemSuperKeys.put(param[i].superKey, true);
		trTag += "<input type='hidden' value='" + JSON.stringify(param[i]) + "'/></tr>";

		// 추가하기 전 중복검사를 통한 중복아이템 제거
		var duplicateFlag = false;
		$('.chkbx_checkedData1').each(function () {
			var superKey = JSON.parse($(this).val()).superKey;
			if (param[i].superKey == superKey) {
				duplicateFlag = true;
			}
		});
		if (!duplicateFlag) {
			insertRowHtml += trTag;
		}
	}
	
	/* 테이블 로우 정보 삽입 */
	$('.tb_selected_item_list1:visible > tbody:last').prepend(insertRowHtml);

	$('.selectedItemRow1').click(function(){
		$('.selectedItemRow1').removeClass("on");
		$(this).addClass("on");
	});

	/* 데이터 기본정보 변경 */
	OJSI_fnSetSelectedInfo1(defaultInfo, $('.tb_selected_item_list1:visible > tbody > tr').length);
	
	/* 아이템 선택여부 백그라운드 처리 */
	//OJIL_fnSetTableBGColor(defaultInfo);
	
	/* 최초 호출시 기능옵션 처리 영역 */
	if(firstCall){
		
		/* 기능 옵션 / 최초 선택 아이템 삭제 불가능 */
		if(defaultInfo.noUseDeleteBtn) {
			$('.selectedItemRow1 input:checkbox').attr("disabled", true);
		}	
		firstCall = false;
	}
}



function OJSI_fnSetSelectedItemList2(defaultInfo, param) {

	// 단일선택 모드일 경우 선택되었던 로우 삭제(중복 픽 방지)
// 	if (defaultInfo.selectItem === 's') {
// 		$('.selectedItemRow2').remove();
// 		selectedItemSuperKeys.clear();
// 	}
	
	var extendSelectAreaInfoArray = defaultInfo.extendSelectAreaInfo.split("$");
	var extendSelectAreaSelectItem = extendSelectAreaInfoArray[2].split("|")[1];
	
	if(defaultInfo.selectMode == "ud") {
		extendSelectAreaSelectItem = "m";
	}
	
	if (extendSelectAreaSelectItem === 's') {
		if($('.selectedItemRow2').length){
			$('#removeDiv2').click();
		}
		$('.selectedItemRow2').remove();
		selectedItemSuperKeys.clear();
	}
	
	/* 테이블 로우 정보 생성. */
	var insertRowHtml = '';
	var trTag = '';
	var colName = '';

	
	
	// 파라미터 배열만큼 반복하여 tr 구성
	var correction = $('.orgChartSelectedItemList2:visible tr').length - 1 ;
	for (var i = 0; i < param.length; i++) {
		
		trTag = '<tr class="selectedItemRow2" id="s_' + param[i].deptSeq + "_" + param[i].empSeq + '">';
		// 컬럼 만큼 반복하여 td 구성
		$('.orgChartSelectedItemList2:visible th').each(function (index, item) {
			colName = $(item).attr('class').toString().replace('itemTb_', '');
			if (colName === 'cen') {
				trTag += '<td class="cen"><input type="checkbox" name="inp_chk" id="selected_inp_chk_indexOf2' + (i + correction) + '" class="k-checkbox chkbx_checkedData2 chkSel2" value=\'' + JSON.stringify(param[i])+ '\'> <label class="k-checkbox-label bdChk2" for="selected_inp_chk_indexOf2' + (i + correction) + '" style=""></label></td>'
			} else {
				var data = param[i][colName] || '';
				var advancedData = (param[i][colName+'Adv'] || '');
				
				trTag += '<td class="le">' + ( (data + advancedData ) || '') + '</td>'
			}
		});
		selectedItemSuperKeys.put(param[i].superKey, true);
		trTag += "<input type='hidden' value='" + JSON.stringify(param[i]) + "'/></tr>";

		// 추가하기 전 중복검사를 통한 중복아이템 제거
		var duplicateFlag = false;
		$('.chkbx_checkedData2').each(function () {
			var superKey = JSON.parse($(this).val()).superKey;
			if (param[i].superKey == superKey) {
				duplicateFlag = true;
			}
		});
		if (!duplicateFlag) {
			insertRowHtml += trTag;
		}
	}
	
	/* 테이블 로우 정보 삽입 */
	$('.tb_selected_item_list2:visible > tbody:last').prepend(insertRowHtml);


	$('.selectedItemRow2').click(function(){
		$('.selectedItemRow2').removeClass("on");
		$(this).addClass("on");
	});
	/* 데이터 기본정보 변경 */
	OJSI_fnSetSelectedInfo2(defaultInfo, $('.tb_selected_item_list2:visible > tbody > tr').length);
	
	/* 아이템 선택여부 백그라운드 처리 */
	//OJIL_fnSetTableBGColor(defaultInfo);
	
	/* 최초 호출시 기능옵션 처리 영역 */
	if(firstCall){
		
		/* 기능 옵션 / 최초 선택 아이템 삭제 불가능 */
		if(defaultInfo.noUseDeleteBtn) {
			$('.selectedItemRow2 input:checkbox').attr("disabled", true);
		}	
		firstCall = false;
	}
}



/* [ 삭제 ] 삭제 버튼 이벤트 정의
-----------------------------------------------*/
function OJSI_fnSetBtnEvent(defaultInfo) {
	$('.a_deleteInfo').click(function () {
		
		if($(this).attr("id") == "removeDiv") {
			/* 체크박스 상태 초기화 */
			OJSI_fnInitViewStatus_SelectedItem();
			// 다중 선택 모드인지 확인
			var isMultiSelector = $('.selectedItemRow input:checkbox').length;
			if (isMultiSelector) {
				$('.selectedItemRow input:checkbox:checked').each(function(){
					var item = JSON.parse($(this).val());
					
					if(defaultInfo.isDuplicate) {
						$("#l_" + item.deptSeq + "_" + item.empSeq).show().removeClass("on");
					}
					selectedItemSuperKeys.remove(item.superKey);
				});
				$('.selectedItemRow input:checkbox:checked').parents('tr').remove();
				// 기본정보 표기 변경
				OJSI_fnSetSelectedInfo(defaultInfo, $('.selectedItemRow input:checkbox').length);
				//OJIL_fnSetTableBGColor(defaultInfo);
			} else {
				if(defaultInfo.isDuplicate) {
					var id = $('.selectedItemRow').attr("id").split("_")[1] + "_" +  $('.selectedItemRow').attr("id").split("_")[2];
					
					//$(".itemRow").removeClass("on");
					$("#l_" + id).show().removeClass("on");
					//$("#l_" + id).addClass("on");
				}
				$('.selectedItemRow').remove();
				selectedItemSuperKeys.clear();
				OJSI_fnSetSelectedInfo(defaultInfo, $('.selectedItemRow input:checkbox').length);
			}	
		}
		if($(this).attr("id") == "removeDiv1") {
			/* 체크박스 상태 초기화 */
			OJSI_fnInitViewStatus_SelectedItem();
			// 다중 선택 모드인지 확인
			var isMultiSelector = $('.selectedItemRow1 input:checkbox').length;
			if (isMultiSelector) {
				$('.selectedItemRow1 input:checkbox:checked').each(function(){
					var item = JSON.parse($(this).val());
					
					if(defaultInfo.isDuplicate) {
						//$('.itemRow').removeClass("on");
						$("#l_" + item.deptSeq + "_" + item.empSeq).show().removeClass("on");
					}
					selectedItemSuperKeys.remove(item.superKey);
				});
				$('.selectedItemRow1 input:checkbox:checked').parents('tr').remove();
				// 기본정보 표기 변경
				OJSI_fnSetSelectedInfo1(defaultInfo, $('.selectedItemRow1 input:checkbox').length);
				//OJIL_fnSetTableBGColor(defaultInfo);
			} else {
				if(defaultInfo.isDuplicate) {
					var id = $('.selectedItemRow1').attr("id").split("_")[1] + "_" +  $('.selectedItemRow1').attr("id").split("_")[2];

					//$('.itemRow').removeClass("on");
					$("#l_" + id).show().removeClass("on");
					//$("#l_" + id).addClass("on");
				}
				$('.selectedItemRow1').remove();
				selectedItemSuperKeys.clear();
				OJSI_fnSetSelectedInfo1(defaultInfo, $('.selectedItemRow1 input:checkbox').length);
			}	
		}
		if($(this).attr("id") == "removeDiv2") {
			/* 체크박스 상태 초기화 */
			OJSI_fnInitViewStatus_SelectedItem();
			// 다중 선택 모드인지 확인
			var isMultiSelector = $('.selectedItemRow2 input:checkbox').length;
			if (isMultiSelector) {
				$('.selectedItemRow2 input:checkbox:checked').each(function(){
					var item = JSON.parse($(this).val());
					
					if(defaultInfo.isDuplicate) {
						//$('.itemRow').removeClass("on");
						$("#l_" + item.deptSeq + "_" + item.empSeq).show().removeClass("on");
					}
					selectedItemSuperKeys.remove(item.superKey);
				});
				$('.selectedItemRow2 input:checkbox:checked').parents('tr').remove();
				// 기본정보 표기 변경
				OJSI_fnSetSelectedInfo2(defaultInfo, $('.selectedItemRow2 input:checkbox').length);
				//OJIL_fnSetTableBGColor(defaultInfo);
			} else {
				if(defaultInfo.isDuplicate) {
					var id = $('.selectedItemRow2').attr("id").split("_")[1] + "_" +  $('.selectedItemRow2').attr("id").split("_")[2];

					//$('.itemRow').removeClass("on");
					$("#l_" + id).show().removeClass("on");
					//$("#l_" + id).addClass("on");
				}
				$('.selectedItemRow2').remove();
				selectedItemSuperKeys.clear();
				OJSI_fnSetSelectedInfo2(defaultInfo, $('.selectedItemRow2 input:checkbox').length);
			}	
		}
		if(defaultInfo.isDuplicate) {
			// orgChartItemList
			OJIL_fnItemCount(defaultInfo, $('.tb_item_list:visible > tbody > tr:visible').length);	
		}
		
	});
}

/* [ 라벨 ] 선택된 데이터 기본정보 표기 영역
-----------------------------------------------*/
function OJSI_fnSetSelectedInfo(defaultInfo, count) {
	var infoTxt = '';
	
	if(defaultInfo.extendSelectAreaInfo.split("$")[0].split("|")[0] != "") {
		infoTxt = defaultInfo.extendSelectAreaInfo.split("$")[0].split("|")[0];
	} else {
		if (defaultInfo.selectMode.indexOf('u') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>';
		} 
		if (defaultInfo.selectMode.indexOf('d') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>';
		}
		infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1));	
	}
	
	
// 	if (defaultInfo.selectMode.indexOf('u') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>'; --%>
// 	} 
// 	if (defaultInfo.selectMode.indexOf('d') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>'; --%>
// 	}
<%-- 	infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1)); --%>
	
	
	var cnt = '(' + count + ')'
	$('#li_selected_item_disp_name').html(infoTxt + '<span id="span_selected_item_cnt">(-)</span>');
	$('#span_selected_item_cnt').text(cnt);
}

/* [ 라벨 ] 선택된 데이터 기본정보 표기 영역
-----------------------------------------------*/
function OJSI_fnSetSelectedInfo1(defaultInfo, count) {
	var infoTxt = '';
	
	if(defaultInfo.extendSelectAreaInfo.split("$")[1].split("|")[0] != "") {
		infoTxt = defaultInfo.extendSelectAreaInfo.split("$")[1].split("|")[0];
	} else {
		if (defaultInfo.selectMode.indexOf('u') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>';
		} 
		if (defaultInfo.selectMode.indexOf('d') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>';
		}
		infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1));	
	}
	
// 	if (defaultInfo.selectMode.indexOf('u') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>'; --%>
// 	} 
// 	if (defaultInfo.selectMode.indexOf('d') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>'; --%>
// 	}
<%-- 	infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1)); --%>
	
	
	var cnt = '(' + count + ')'

	$('#li_selected_item_disp_name1').html(infoTxt + '<span id="span_selected_item_cnt1">(-)</span>');
	$('#span_selected_item_cnt1').text(cnt);	
}

/* [ 라벨 ] 선택된 데이터 기본정보 표기 영역
-----------------------------------------------*/
function OJSI_fnSetSelectedInfo2(defaultInfo, count) {
	var infoTxt = '';
	
	if(defaultInfo.extendSelectAreaInfo.split("$")[2].split("|")[0] != "") {
		infoTxt = defaultInfo.extendSelectAreaInfo.split("$")[2].split("|")[0];
	} else {
		if (defaultInfo.selectMode.indexOf('u') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>';
		} 
		if (defaultInfo.selectMode.indexOf('d') > -1) {
			infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>';
		}
		infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1));	
	}
	
// 	if (defaultInfo.selectMode.indexOf('u') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>'; --%>
// 	} 
// 	if (defaultInfo.selectMode.indexOf('d') > -1) {
<%-- 		infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>'; --%>
// 	}
<%-- 	infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1)); --%>
	
	
	var cnt = '(' + count + ')'
	$('#li_selected_item_disp_name2').html(infoTxt + '<span id="span_selected_item_cnt2">(-)</span>');
	$('#span_selected_item_cnt2').text(cnt);
}



/* [ 체크박스 ] 체크 박스 전체선택
-----------------------------------------------*/
function OJSI_fnSetAllCheckEvent_Selected(defaultInfo) {
	$('.all_check_selected_item:visible').click(function () {
		$('.selectedItemRow input:checkbox').prop('checked', $('.all_check_selected_item:visible').prop("checked"));
	});
	
	$('.all_check_selected_item1:visible').click(function () {
		$('.selectedItemRow1 input:checkbox').prop('checked', $('.all_check_selected_item1:visible').prop("checked"));
	});
	
	$('.all_check_selected_item2:visible').click(function () {
		$('.selectedItemRow2 input:checkbox').prop('checked', $('.all_check_selected_item2:visible').prop("checked"));
	});	
}

/* [ 화면 초기화 ] 체크박스 화면 상태 초기화
-----------------------------------------------*/
function OJSI_fnInitViewStatus_SelectedItem() {
	$('.all_check_selected_item:visible').prop("checked", false);
	$('.all_check_selected_item1:visible').prop("checked", false);
	$('.all_check_selected_item2:visible').prop("checked", false);
}

</script>