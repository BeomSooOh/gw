<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 선택된 부서/사원 정보 테이블 -->
<%-- 	<div class="clear">
		<div class="option_top">
			<ul>
				<li class="tit_li" id="li_selected_item_disp_name"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></li>
			</ul>

			<div id="" class="controll_btn" style="padding:0px;float:right;">
				<button id="btn_selected_item_delete"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>
	</div> --%>

	<div class="com_ta2">
		<span class="txt mb5 pl5 pb5" style="display:block;" id="li_selected_item_disp_name"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></span>
		<!-- 사원 단일 선택 -->
		<table class="orgChartSelectedItemList" id="div_org_selected_item_list_us">
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
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:484px;margin-top:0px;" id="div_org_selected_item_list2_us">
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
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:484px;margin-top:0px;" id="div_org_selected_item_list2_ds">
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
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:484px;margin-top:0px;" id="div_org_selected_item_list2_um">
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
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:484px;margin-top:0px;" id="div_org_selected_item_list2_dm">
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
		<div class="com_ta2 ova_sc bg_lightgray orgChartSelectedItemList" style="height:484px;margin-top:0px;" id="div_org_selected_item_list2_ud">
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

	</div>




<script type="text/javascript">

	/* [페이지 준비] 페이지 로드 완료시 호출
	 * defaultInfo : 팝업 호출시의 옵션및 사용자 기본 정보
	-----------------------------------------------*/
	function OJSI_documentReady(defaultInfo) {
// 		var selectMode = (defaultInfo.selectMode + defaultInfo.selectItem).substring(0, 2);
// 		// 기본 옵션에 따른 디스플레이 선택
// 		if (selectMode.substring(0, 1) === 'o'){
// 			$('.box_right2').hide();
// 		}

// 		$('.orgChartSelectedItemList').hide();
// 		$('#div_org_selected_item_list_' + selectMode).show();
// 		$('#div_org_selected_item_list2_' + selectMode).show();

		/*옵션값 선택에 따른 테이블 그려주기*/
		OJSI_fnSetAreaDraw(defaultInfo);
		/*버튼 이벤트 정의*/
		OJSI_fnSetBtnEvent(defaultInfo);
		/* 기본 출력데이터 표기 영역 */
		OJSI_fnSetSelectedInfo(defaultInfo, 0);
		/* 체크 박스 전체선택 이벤트 지정 */
		OJSI_fnSetAllCheckEvent_Selected(defaultInfo);

	}
	
	function OJSI_fnSetAreaDraw(defaultInfo) {
		var selectMode = (defaultInfo.selectMode + defaultInfo.selectItem).substring(0, 2);
		// 기본 옵션에 따른 디스플레이 선택
		if (selectMode.substring(0, 1) === 'o'){
			$('.box_right2').hide();
			$('.posi_ab').hide();
		}
		
		$('.orgChartSelectedItemList').hide();
		if(defaultInfo.extendSelectAreaInfo != "") {
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
				}
			}
		} else {
	 		$('#div_org_selected_item_list_' + selectMode).show();
	 		$('#div_org_selected_item_list2_' + selectMode).show();
		}
		
	}	

	/* [ 테이블 ] 선택된 아이템 테이블 그리기
	 * Call By : /include/orgJsItemList.jsp
	-----------------------------------------------*/
	var selectedItemSuperKeys = new Map();
	var firstCall = true;
	function OJSI_fnSetSelectedItemList(defaultInfo, param) {

		//본인 추가 불가옵션체크
		if(defaultInfo.exMyinfoYn == "Y"){
			var reParam = [];
			var checkCnt = 0;
			for(var i=0;i<param.length;i++){
				if(param[i].empSeq != defaultInfo.empSeq){
					reParam.push(param[i]);	
				}else{
					checkCnt++;
				}		
			}
			param = reParam;
			if(checkCnt > 0){
				alert("자기자신은 제외 후 추가됩니다.");
			}
		}
		
		// 단일선택 모드일 경우 선택되었던 로우 삭제(중복 픽 방지)
		$('.selectedItemRow').click(function(){
			$('.selectedItemRow').removeClass("on");
			$(this).addClass("on");
		});
		
		if(defaultInfo.selectMode == "ud") {
			extendSelectAreaSelectItem = "m";
		}
		
		if(extendSelectAreaInfo != "") {
			var extendSelectAreaInfoArray = defaultInfo.extendSelectAreaInfo.split("$");
			var extendSelectAreaSelectItem = extendSelectAreaInfoArray[0].split("|")[1];
	
			if (extendSelectAreaSelectItem === 's') {
				if($('.selectedItemRow').length){
					$('#removeDiv').click();
				}
				$('.selectedItemRow').remove();
				selectedItemSuperKeys.clear();
			}
		} else {
			if(defaultInfo.selectMode == "ud") {
				defaultInfo.selectItem = "m";
			}
			
			if (defaultInfo.selectItem === 's' ) {
				if($('.selectedItemRow1').length){
					$('#removeDiv1').click();
				}
				//$('.selectedItemRow').remove();
				selectedItemSuperKeys.clear();
			}
		}
		
		/* 테이블 로우 정보 생성. */
		var insertRowHtml = '';
		var trTag = '';
		var colName = '';
		
		// 파라미터 배열만큼 반복하여 tr 구성
		var correction = $('.orgChartSelectedItemList:visible tr').length - 1 ;
		for (var i = 0; i < param.length; i++) {
			
			trTag = '<tr class="selectedItemRow">';
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

	/* [ 삭제 ] 삭제 버튼 이벤트 정의
	-----------------------------------------------*/
	function OJSI_fnSetBtnEvent(defaultInfo) {		
		$('.a_deleteInfo').click(function () {
			/* 체크박스 상태 초기화 */
			OJSI_fnInitViewStatus_SelectedItem();

			// 다중 선택 모드인지 확인
			var isMultiSelector = $('.selectedItemRow input:checkbox').length;
			if (isMultiSelector) {
				$('.selectedItemRow input:checkbox:checked').each(function(){
					var item = JSON.parse($(this).val());
					selectedItemSuperKeys.remove(item.superKey);
				});
				$('.selectedItemRow input:checkbox:checked').parents('tr').remove();
				// 기본정보 표기 변경
				OJSI_fnSetSelectedInfo(defaultInfo, $('.selectedItemRow input:checkbox').length);
				//OJIL_fnSetTableBGColor(defaultInfo);
			} else {
				$('.selectedItemRow').remove();
				selectedItemSuperKeys.clear();
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
		
		if(defaultInfo.extendSelectAreaInfo !="") {
			infoTxt = extendSelectAreaInfo.split("|")[0];
		} else {
			if (defaultInfo.selectMode.indexOf('u') > -1) {
				infoTxt += ',<%=BizboxAMessage.getMessage("TX000000141","사원")%>';
			} 
			if (defaultInfo.selectMode.indexOf('d') > -1) {
				infoTxt += ',<%=BizboxAMessage.getMessage("TX000000098","부서")%>';
			}
			infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1));
		}
		
		
		
		var cnt = '(' + count + ')'
		$('#li_selected_item_disp_name').html(infoTxt + '<span id="span_selected_item_cnt">(-)</span>');
		$('#span_selected_item_cnt').text(cnt);
	}
	/* [ 체크박스 ] 체크 박스 전체선택
	-----------------------------------------------*/
	function OJSI_fnSetAllCheckEvent_Selected(defaultInfo) {
		$('.all_check_selected_item:visible').click(function () {
			$('.selectedItemRow input:checkbox').prop('checked', $('.all_check_selected_item:visible').prop("checked"));
		});
	}

	/* [ 화면 초기화 ] 체크박스 화면 상태 초기화
	-----------------------------------------------*/
	function OJSI_fnInitViewStatus_SelectedItem() {
		$('.all_check_selected_item:visible').prop("checked", false);
	}
</script>
