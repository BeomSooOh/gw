<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!-- 부서, 사원 목록  -->
<!-- 부서사원선택 기능버튼 -->
<div class="trans_top_btn">
	<div class="option_top">
		<ul>
			<li id="li_item_disp_name" class="tit_li"> <span></span> </li>
		</ul>
		<div id="" class="controll_btn" style="padding:0px;float:right;">
			<button id="btn_selected_item_select"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
		</div>
	</div>
</div>

<!-- 부서사원선택 테이블 -->
<div class="mt10 mb10 posi_re">

	<div class="com_ta2 mt15">

		<!-- 사업장 복수 선택 -->
		<table class="orgChartItemList" id="div_org_item_list_biz">
			<colgroup>
				<col width="34" />
				<col width="130" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_chk_all_dm" class="k-checkbox all_check_item">
					<label class="k-checkbox-label bdChk2" for="inp_chk_all_dm" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("","사업장")%></th>
			</tr>
		</table>
		<div class="com_ta2 ova_sc bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_biz">
			<table class="tb_item_list">
				<colgroup>
					<col width="34" />
					<col width="130" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>
	</div>

</div>


<script type="text/javascript">

	/* [페이지 준비] 페이지 로드 완료시 호출
	 * defaultInfo : 팝업 호출시의 옵션및 사용자 기본 정보
	-----------------------------------------------*/
	function OJIL_documentReady(defaultInfo) {

		var selectItem = (defaultInfo.selectMode + defaultInfo.selectItem).substring(1, 2);
		if (selectItem === 's') {
			$('#btn_selected_item_select').hide();
		}

		$('.orgChartItemList').hide();
		$('#div_org_item_list_biz').show();
		$('#div_org_item_list2_biz').show();

		/* 선택버튼 이벤트 정의 */
		OJIL_fnSetBtnClickEvent_Select(defaultInfo);
		/* 기본 출력데이터 표기 영역 */
		OJIL_fnSetSearchedInfo(defaultInfo, 0);
		/* 체크 박스 전체선택 이벤트 지정 */
		OJIL_fnSetAllCheckEvent_Item(defaultInfo);
	}

	/* [ 테이블 ] 트리에서 선택된 노드에 해당하는
	 * 사원, 부서 정보 테이블 자료 입력
	-----------------------------------------------*/
	function OJIL_fnSetItemList(defaultInfo, param) {

		//alert(JSON.stringify(param));
		/* 데이터 기본정보 변경 */
		OJIL_fnSetSearchedInfo(defaultInfo, param.length);
		/* 체크 박스 상태 변경 */
		OJIL_fnInitViewStatus_Item();

		/* # 테이블 로우 정보 생성 영역. */
		$('.itemRow').remove();
		// var hasCheckbox = false;
		var insertRowHtml = '';
		var colName = '';

		for (var i = 0; i < param.length; i++) {
			
			// 기능옵션 onUseCompSelect[회사선택 사용안함] 일경우 회사 아이템 필터링
			if(param[i].empDeptFlag === 'c' && defaultInfo.noUseCompSelect){
				continue;	
			}
			
			insertRowHtml += '<tr class="itemRow">';
			$('.orgChartItemList:visible th').each(function (index, item) {

				colName = $(item).attr('class').toString().replace('itemTb_', '');
				if (colName === 'cen') {
					// hasCheckbox = true;
					insertRowHtml += '<td class="cen chktd"> <input type="checkbox" name="inp_chk" id="inp_chk_indexOf' + i + '" class="k-checkbox ' + $(item).find(':checkbox').attr('id') + ' checkBox_item chkSel2 chkSel_forEvent " value=\'' + JSON.stringify(param[i])+ '\'>	\n<label class="k-checkbox-label chkSel_forEvent bdChk2" 	for="inp_chk_indexOf' + i + '" style=""></label></td>'
				} else {
					var data = param[i][colName] || '';
					var advancedData = (param[i][colName+'Adv'] || '');
					
					insertRowHtml += '<td class="le">' + ( (data + advancedData ) || '') + '</td>'
				}
			});
			insertRowHtml += "<input type='hidden' value='" + JSON.stringify(param[i]) + "'/></tr>";
		}
		/* 테이블 로우 정보 삽입 */
		$('.tb_item_list:visible > tbody:last').append(insertRowHtml);
		/* #[-END-] 테이블 로우 정보 생성 영역. */


		/* # 체크박스 및 버튼 이벤트 정의  */
		$('.itemRow').dblclick(function (e) {
			
			if (!$(this).find(':checkbox').val()) {
				// function declare : /include/orgJsSelectedItemList.jsp
				OJSI_fnSetSelectedItemList(defaultInfo, [JSON.parse($(this).find(':hidden').val())]);
			}else{
				OJSI_fnSetSelectedItemList(defaultInfo, [JSON.parse($(this).find(':checkbox').val())]);
			}	
		});
		
		// 체크 박스 이벤트 더블클릭 버블링 차단		
		$('.chkSel_forEvent').dblclick(function(e){
			e.stopPropagation();
		});
		
		/* 테이블 배경색 변경 */
		OJIL_fnSetTableBGColor(defaultInfo);
	}

	/* [ 선택 ] 선택 버튼 이벤트 정의
	-----------------------------------------------*/
	function OJIL_fnSetBtnClickEvent_Select(defaultInfo) {
		/* 체크박스가 있는 경우 : 버튼 클릭 이벤트 정의 */
		$('#btn_selected_item_select').click(function () {
			var paramSet = new Array();
			$('.checkBox_item').each(function (index, item) {
				if ($(this).is(':visible') && $(this).prop('checked')) {
					paramSet.push(JSON.parse($(item).val()));
				}
			});
			// function declare : /include/orgJsSelectedItemList.jsp
			OJSI_fnSetSelectedItemList(defaultInfo, paramSet);
			
			$('.checkBox_item').prop('checked',false);
			$('.all_check_item').prop('checked',false);
		});
	}

	/* [ 라벨 ] 검색된 데이터 기본정보 표기 영역
	-----------------------------------------------*/
	function OJIL_fnSetSearchedInfo(defaultInfo, count) {
		var infoTxt = '';
		
		infoTxt += ',<%=BizboxAMessage.getMessage("","사업장")%>';

		infoTxt = infoTxt.substring(1) + ' <%=BizboxAMessage.getMessage("TX000003107","목록")%>';

		var cnt =  '(' + count + ')'
		$('#li_item_disp_name').html(infoTxt + '<span id="span_item_cnt">(-)</span>');
		$('#span_item_cnt').text(cnt);
	}

	/* [ 체크박스 ] 체크 박스 전체선택
	-----------------------------------------------*/
	function OJIL_fnSetAllCheckEvent_Item(defaultInfo) {
		$('.all_check_item:visible').click(function () {
			$('.checkBox_item').prop('checked', $('.all_check_item:visible').prop("checked"));
		});
	}


	/* [ 화면 초기화 ] 체크박스 화면 상태 초기화
	-----------------------------------------------*/
	function OJIL_fnInitViewStatus_Item(defaultInfo) {
		$('.all_check_item:visible').prop("checked", false);
	}
	
	/* [ 테이블 배경색 ] 테이블 배경색 설정
	-----------------------------------------------*/
	function OJIL_fnSetTableBGColor(defaultInfo) {
		
		$('.tb_item_list:visible tr').each(function (){
			$(this).removeClass('on');
			var key = JSON.parse($(this).find('input').val()).superKey; 
			if(selectedItemSuperKeys.get(key)){
				$(this).addClass('on');
			}
		});
	}
</script>
