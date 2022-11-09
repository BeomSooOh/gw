<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!-- 부서, 사원 목록  -->
<!-- 부서사원선택 기능버튼 -->
<div class="trans_top_btn">
	<div class="option_top">
		<ul>
			<li id="li_item_disp_name" class="tit_li"> <span></span> </li>
		</ul>
	</div>
</div>

<!-- 부서사원선택 테이블 -->
<div class="mt10 mb10 posi_re">

	<div class="com_ta2 mt15">

		<!-- 사원 단일 선택 -->
		<div class="com_ta2 sc_head">
		<table class="orgChartItemList" id="div_org_item_list_us"  style="display:none;">
			<colgroup>
				<col width="25%" />
				<col width="25%" />
				<col width="20%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_dutyName" style="display:none;"><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		</div>
		<div class="com_ta2 ova_sc2 bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_us" style="display:none;">
			<table class="tb_item_list">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="20%" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>

		<!-- 부서 단일 선택 -->
		<div class="com_ta2 sc_head">
		<table class="orgChartItemList" id="div_org_item_list_ds" style="display:none;">
			<colgroup>
				<col width="50%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		</div>
		<div class="com_ta2 ova_sc2 bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_ds" style="display:none;">
			<table class="tb_item_list">
				<colgroup>
					<col width="50%" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>


		<!-- 사원 복수 선택 -->
		<div class="com_ta2 sc_head">
		<table class="orgChartItemList" id="div_org_item_list_um" style="display:none;">
			<colgroup>
				<col width="34" />
				<col width="30%" />
				<col width="30%" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_chk_all_um" class="k-checkbox all_check_item" />
					<label class="k-checkbox-label bdChk2" for="inp_chk_all_um" style=""></label>
				</th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_dutyName" style="display:none;"><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		</div>
		<div class="com_ta2 ova_sc2 bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_um" style="display:none;">
			<table class="tb_item_list">
				<colgroup>
					<col width="34" />
					<col width="30%" />
					<col width="30%" />
					<col />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>


		<!-- 부서 복수 선택 -->
		<div class="com_ta2 sc_head">
		<table class="orgChartItemList" id="div_org_item_list_dm" style="display:none;">
			<colgroup>
				<col width="34" />
				<col width="50%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_chk_all_dm" class="k-checkbox all_check_item">
					<label class="k-checkbox-label bdChk2" for="inp_chk_all_dm" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
			</tr>
		</table>
		</div>
		<div class="com_ta2 ova_sc2 bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_dm">
			<table class="tb_item_list">
				<colgroup>
					<col width="34" />
					<col width="50%" />
					<col width="" />
				</colgroup>
				<tbody></tbody>
			</table>
		</div>


		<!-- 사원,부서 복수 선택 -->
		<div class="com_ta2 sc_head">
		<table class="orgChartItemList" id="div_org_item_list_ud" style="display:none;">
			<colgroup>
				<col width="34" />
				<col width="22%" />
				<col width="22%" />
				<col width="20%" />
				<col />
			</colgroup>
			<tr>
				<th class="cen">
					<input type="checkbox" name="inp_chk" id="inp_chk_all_ud" class="k-checkbox all_check_item">
					<label class="k-checkbox-label bdChk2" for="inp_chk_all_ud" style=""></label>
				</th>
				<th class="itemTb_compName"><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
				<th class="itemTb_deptName"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
				<th class="itemTb_positionName"><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
				<th class="itemTb_dutyName" style="display:none;"><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
				<th class="itemTb_empName"><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
			</tr>
		</table>
		</div>
		<div class="com_ta2 ova_sc2 bg_lightgray orgChartItemList" style="height:148px;margin-top:0px;" id="div_org_item_list2_ud" style="display:none;">
			<table class="tb_item_list">
				<colgroup>
					<col width="34" />
					<col width="22%" />
					<col width="22%" />
					<col width="20%" />
					<col />
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
	function OJIL_documentReadyDf(defaultInfo) {
		/* 직급/직책 옵션 값 노출 */ 
	    if(defaultInfo.displayPositionDuty == "position") {
			$(".itemTb_positionName").show();
			$(".itemTb_dutyName").hide;
		} else {
			$(".itemTb_positionName").hide();
			$(".itemTb_dutyName").show();
		}

		var selectItem = (defaultInfo.selectMode + defaultInfo.selectItem).substring(1, 2);
		var selectMode = (defaultInfo.selectMode + defaultInfo.selectItem).substring(0, 2);
		
		$('.orgChartItemList').hide();
		$('#div_org_item_list_' + selectMode).show();
		$('#div_org_item_list2_' + selectMode).show();		 
	 }
	
	function OJIL_documentReadyInit(defaultInfo) {
		/* 체크 박스 전체선택 이벤트 지정 */
		OJIL_fnSetAllCheckEvent_Item(defaultInfo);
	 }	
	
	
	
	function OJIL_documentReady(defaultInfo) {
		OJIL_documentReadyDf(defaultInfo);
		OJIL_documentReadyInit(defaultInfo);
	}

	/* [ 테이블 ] 트리에서 선택된 노드에 해당하는
	 * 사원, 부서 정보 테이블 자료 입력
	-----------------------------------------------*/
	function OJIL_fnSetItemList(defaultInfo, param) {
		
		/* 데이터 기본정보 변경 */
		OJIL_fnSetSearchedInfo(defaultInfo, 0);
		
		/* 체크 박스 상태 변경 */
		OJIL_fnInitViewStatus_Item();

		/* # 테이블 로우 정보 생성 영역. */
		$('.itemRow').remove();
		var insertRowHtml = '';
		var colName = '';

		for (var i = 0; i < param.length; i++) {
			
			// 기능옵션 onUseCompSelect[회사선택 사용안함] 일경우 회사 아이템 필터링
			if(param[i].empDeptFlag === 'c' && defaultInfo.noUseCompSelect){
				continue;	
			}
			
			insertRowHtml += '<tr class="itemRow empDeptFlag_'+param[i].empDeptFlag+'" superKey="'+param[i].superKey.replace(/\|/g,"▦")+'">';
			$('.orgChartItemList:visible th:visible').each(function (index, item) {
				colName = $(item).attr('class').toString().replace('itemTb_', '');
				if (colName === 'cen') {
					insertRowHtml += '<td class="cen chktd"> <input type="checkbox" name="inp_chk" id="inp_chk_indexOf' + i + '" class="k-checkbox ' + $(item).find(':checkbox').attr('id') + ' checkBox_item chkSel2 chkSel_forEvent " value=\'' + JSON.stringify(param[i]).replace(/\'/g,"")+ '\'>	\n<label class="k-checkbox-label chkSel_forEvent bdChk2" 	for="inp_chk_indexOf' + i + '" style=""></label></td>'
				} else {
					var data = param[i][colName] || '';
					var advancedData = (param[i][colName+'Adv'] || '');
					
					insertRowHtml += '<td class="le">' + ( (data + advancedData ) || '') + '</td>'
				}
			});
			insertRowHtml += "<input type='hidden' value='" + JSON.stringify(param[i]).replace(/\'/g,"") + "'/></tr>";
		}
		
		/* 테이블 로우 정보 삽입 */
		$('.tb_item_list:visible > tbody:last').append(insertRowHtml);
		/* #[-END-] 테이블 로우 정보 생성 영역. */

		/* # 체크박스 및 버튼 이벤트 정의  */
		$('.itemRow').dblclick(function (e) {
			
			if (!$(this).find(':checkbox').val()) {
				OJSI_fnSetSelectedItemList(defaultInfo, [JSON.parse($(this).find(':hidden').val())], true);
			}else{
				OJSI_fnSetSelectedItemList(defaultInfo, [JSON.parse($(this).find(':checkbox').val())], true);
			}
			
		});
		
		// 체크 박스 이벤트 더블클릭 버블링 차단		
		$('.chkSel_forEvent').dblclick(function(e){
			e.stopPropagation();
		});
		
		/* 테이블 배경색 변경 및 검색사용자 처리 */
		OJIL_fnSetTableBGColor(defaultInfo);
		
		$(".tb_item_list:visible tr input:checkbox").on('change',function(){
			if($(this).is(':checked')){
				OJSI_fnSetSelectedItemList(defaultInfo, [JSON.parse($(this).val())], true);
			}else{
				var targetSuperKey = $(this).parents("tr").attr("superKey");
				var targetDiv = $("#div_selected_item_list [superkey="+targetSuperKey+"]");
				$(targetDiv).addClass("animated05s zoomOutUp");
				setTimeout( function(){$(".io_div.zoomOutUp").remove()} , 310);
				setTimeout( function(){$(".io_div.zoomOutUp").nextAll().addClass("animated03s slideInRight")} , 300);
				setTimeout( function(){$(".int_org").children().removeClass("animated03s slideInRight")} , 700);
				selectedItemSuperKeys.remove(targetSuperKey.replace(/\▦/g,"|"));
				$(this).parents("tr").removeClass('on');
				$(this).prop("checked",false);
				
				setTimeout( function(){resetSelectedItemCnt();} , 800);
			}
			
			OJIL_fnSetAllCheckStatus();
							
		});
		
		resetItemCnt();
		
	}
	
	function resetItemCnt(){
		$("#span_item_comp_cnt").html($('.tb_item_list:visible tr.empDeptFlag_c').length);
		$("#span_item_dept_cnt").html($('.tb_item_list:visible tr.empDeptFlag_d').length);
		$("#span_item_emp_cnt").html($('.tb_item_list:visible tr.empDeptFlag_u').length);
	}	

	/* [ 라벨 ] 검색된 데이터 기본정보 표기 영역
	-----------------------------------------------*/
	function OJIL_fnSetSearchedInfo(defaultInfo, count) {
		var infoTxt = '';
		if (defaultInfo.selectMode.indexOf('d') > -1) {
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000047","회사")%>(<span id="span_item_comp_cnt">0</span>)';
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000098","부서")%>(<span id="span_item_dept_cnt">0</span>)';
		} if (defaultInfo.selectMode.indexOf('u') > -1) {
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000141","사원")%>(<span id="span_item_emp_cnt">0</span>)';
		}
		infoTxt = infoTxt.substring(1) + ' <%=BizboxAMessage.getMessage("TX000003107","목록")%>';

		$('#li_item_disp_name').html(infoTxt);
	}
	
	/* [ 체크박스 ] 체크 박스 전체선택 상태값보정
	-----------------------------------------------*/
	function OJIL_fnSetAllCheckStatus() {
		if($('.tb_item_list:visible tr input:checkbox').length > 0){
			if($('.tb_item_list:visible tr input:checkbox:not(:checked)').length > 0){
				$('.all_check_item').prop("checked",false);
			}else{
				$('.all_check_item').prop("checked",true);
			}			
		}
	}

	/* [ 체크박스 ] 체크 박스 전체선택
	-----------------------------------------------*/
	function OJIL_fnSetAllCheckEvent_Item(defaultInfo) {
		
		$(".all_check_item").on('change',function(){
			
			if($(this).is(':checked')){
				
				var selectedItemArray = [];
				
				$.each($('.tb_item_list:visible tr input:checkbox:not(:checked)'), function( index, value ) {
					selectedItemArray.push(JSON.parse($(value).val()));
				});
				
				OJSI_fnSetSelectedItemList(defaultInfo, selectedItemArray, true);				
				
				$('.tb_item_list:visible tr').addClass('on');
				$('.tb_item_list:visible tr input:checkbox').prop("checked",true);
			}else{
				
				$.each($('.tb_item_list:visible tr input:checkbox:checked'), function( index, value ) {
					
					var targetSuperKey = $(value).parents("tr").attr("superKey");
					var targetDiv = $("#div_selected_item_list [superkey="+targetSuperKey+"]");
					$(targetDiv).addClass("animated05s zoomOutUp");
					selectedItemSuperKeys.remove(targetSuperKey.replace(/\▦/g,"|"));
					
				});
				
				setTimeout( function(){$(".io_div.zoomOutUp").remove()} , 310);
				setTimeout( function(){$(".io_div.zoomOutUp").nextAll().addClass("animated03s slideInRight")} , 300);
				setTimeout( function(){$(".int_org").children().removeClass("animated03s slideInRight")} , 700);				
				
				$('.tb_item_list:visible tr').removeClass('on');
				$('.tb_item_list:visible tr input:checkbox').prop("checked",false);
				
				setTimeout( function(){resetSelectedItemCnt();} , 800);
			}
							
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
			
			var key = $(this).attr("superKey").replace(/\▦/g,"|");
			
			if(selectedItemSuperKeys.containsKey(key)){
				$(this).addClass('on');
				$(this).find("input:checkbox").prop("checked",true);
			}else{
				$(this).removeClass('on');
				$(this).find("input:checkbox").prop("checked",false);	
			}

		});
		
		//검색된 사용자 디자인 및 스크롤 처리
		if(focusSuperKey != ""){
			
			var focusSuperKeyArray = focusSuperKey.split("|");
			
			if(focusSuperKeyArray.length > 4 && focusSuperKeyArray[4] == "u"){
				focusSuperKey = focusSuperKeyArray[0] + "▦0▦0▦" + focusSuperKeyArray[3] + "▦u";
				//sh_modi_20220902 emp_seq에 "." 이 포함된경우 오류 방지 위하여 '추가함
				if($(".tb_item_list:visible tr[superKey='"+focusSuperKey+"']").length > 0){
					$(".tb_item_list:visible tr[superKey='"+focusSuperKey+"']").css("font-weight","bold");
					$(".tb_item_list:visible tr[superKey='"+focusSuperKey+"']")[0].scrollIntoView();					
				}

			}
			
		}
		
		focusSuperKey = "";
		OJIL_fnSetAllCheckStatus();
	}

</script>
