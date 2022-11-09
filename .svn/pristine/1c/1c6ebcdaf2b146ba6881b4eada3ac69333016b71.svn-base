<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!-- 선택된 부서/사원 정보 테이블 -->
<div class="mt30">

	<div class="clear">
		<div class="option_top">
			<ul>
				<li class="tit_li" id="li_selected_item_disp_name"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></li>
			</ul>

			<div id="" class="controll_btn" style="padding:0px;float:right;">
				<button id="btn_selected_item_delete"><%=BizboxAMessage.getMessage("TX000002960","초기화")%></button>
			</div>
		</div>
	</div>
	
	<div id="div_selected_item_list" class="int_org mt15" style="height:155px;"></div>	

</div>



<div id="itemRemovePop" class="pop_wrap_dir" style="display:none;">
	<div class="pop_con p0" >
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class="reportbg">
						<dl id="confirmMsg" class="result_con">
						</dl>
					</span>		
				</td>
			</tr>
		</table>
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" onclick="fnConfirm('1');" value="<%=BizboxAMessage.getMessage("TX900000481", "1건삭제")%>" />
				<input type="button" onclick="fnConfirm('2');" value="<%=BizboxAMessage.getMessage("TX900000482", "전체삭제")%>" />
				<input type="button" class="gray_btn" onclick="fnConfirm('0');" value="<%=BizboxAMessage.getMessage("TX000002947", "취소")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->			
</div>

<script type="text/javascript">

	/* [페이지 준비] 페이지 로드 완료시 호출
	 * defaultInfo : 팝업 호출시의 옵션및 사용자 기본 정보
	-----------------------------------------------*/
	function OJSI_documentReadyDf(defaultInfo) {
		/* 기본 출력데이터 표기 영역 */
		OJSI_fnSetSelectedInfo(defaultInfo, 0);
	 }
	
	function OJSI_documentReadyInit(defaultInfo) {
		/*버튼 이벤트 정의*/
		OJSI_fnSetBtnEvent(defaultInfo);

		/* 체크 박스 전체선택 이벤트 지정 */
		OJSI_fnSetAllCheckEvent_Selected(defaultInfo);		 
	 }	
	
	function OJSI_documentReady(defaultInfo) {
		OJSI_documentReadyDf(defaultInfo);
		OJSI_documentReadyInit(defaultInfo);
	}

	/* [ 테이블 ] 선택된 아이템 테이블 그리기
	 * Call By : /include/orgJsItemList.jsp
	-----------------------------------------------*/
	var selectedItemSuperKeys = new Map();
	var firstCall = true;
	
	function OJSI_fnSetSelectedItemList(defaultInfo, param, newYn) {
		
		// 단일선택 모드일 경우 선택되었던 로우 삭제(중복 픽 방지)
		if (defaultInfo.selectItem === 's') {
			selectedItemSuperKeys.clear();
			$("#div_selected_item_list").html("");
		}

		$.each(param, function( index, value ) {
			
			if(!selectedItemSuperKeys.containsKey(value.superKey)){
				//겸직체크
				//sh_modi_20220902 emp_seq에 "." 이 포함된경우 오류 방지 위하여 '추가함
				if(value.empDeptFlag == "u" && $("#div_selected_item_list div[superKey='"+value.superKey.replace(/\|/g,"▦")+"']").length > 0){
					//이미 사용자 정보가 있을 경우 겸직정보에 추가
					$("#div_selected_item_list div[superKey='"+value.superKey.replace(/\|/g,"▦")+"'] ul").append("<li>"+value.pathName+"</li>");

				}else{
				
					var orgDivClass = value.empDeptFlag == "u" ? " idt1" : (value.empDeptFlag == "d" ? " idt2" : " idt3");
					
					if(value.useYn == "N"){
						//미사용항목인 경우
						orgDivClass += " disa";
					}
					
					if(newYn){
						//신규추가인 경우
						orgDivClass += " on";						
					}
					
					var selectedItemHtml = "<div class='io_div"+orgDivClass+"' superKey='"+value.superKey.replace(/\|/g,"▦")+"'>";
					selectedItemHtml += "<input type='hidden' value='" + JSON.stringify(value).replace(/\'/g,"") + "'/>";
					selectedItemHtml += "<div class='ico'></div>";
					selectedItemHtml += "<div class='who' onmouseover='tooltip_fc(this);' onmouseout='tooltip_out_fc(this);'>"+value.orgName+"</div>";
					selectedItemHtml += "<a onclick='removeSelectedItem(this, true);' href='#n' class='clo'></a>";
					selectedItemHtml += "<div class='io_tooltip'>";
					selectedItemHtml += "<div class='io_tooltip_in'>";
					selectedItemHtml += "<div class='io_tooltip_con'>";
					selectedItemHtml += "<ul>";
					
					var pathNameArray = value.pathName.split(",");
					
					$.each(pathNameArray, function( inx0, value0 ) {
						selectedItemHtml += "<li>"+value0+"</li>";	
					});
					
					selectedItemHtml += "</ul>";
					selectedItemHtml += "<div class='semo'></div>";
					selectedItemHtml += "</div>";
					selectedItemHtml += "</div>";
					selectedItemHtml += "</div>";
					
					$("#div_selected_item_list").append(selectedItemHtml);
					selectedItemSuperKeys.put(value.superKey, true);
				}
			}			
		});	
		
		OJIL_fnSetTableBGColor(defaultInfo);
		
		if(newYn){
			//신규추가인 경우 스크롤 하단이동
			$("#div_selected_item_list").animate({ scrollTop: 10000}, 400);						
		}		
		
		resetSelectedItemCnt();
	}
	
	function resetSelectedItemCnt(){
		$("#span_selected_item_comp_cnt").html($("#div_selected_item_list .io_div.idt3").length);
		$("#span_selected_item_dept_cnt").html($("#div_selected_item_list .io_div.idt2").length);
		$("#span_selected_item_emp_cnt").html($("#div_selected_item_list .io_div.idt1").length);
	}
	
	var itemRemovePopObj;
	var selectedSuperKeyToDelObj;
	
	function fnConfirm(delType){
		
		if(delType == 1){
			//1개만 삭제
			removeSelectedItem(selectedSuperKeyToDelObj, false);
		}else if(delType == 2){
			//전체삭제
			var orgDivClassDel;
			
			if($(selectedSuperKeyToDelObj).parent(".io_div").hasClass("idt1")){
				//사용자
				orgDivClassDel = "idt1";
			}else if($(selectedSuperKeyToDelObj).parent(".io_div").hasClass("idt2")){
				//부서
				orgDivClassDel = "idt2";
			}else{
				//회사
				orgDivClassDel = "idt3";
			}
			
			$.each($(".io_div."+orgDivClassDel+".disa a"), function( index, value ) {
				removeSelectedItem(value, false);	
			});
			
		}
		
		$('#itemRemovePop').data("kendoWindow").close();
	}
	
	function removeSelectedItem(obj, confirmYn){
		
		if(confirmYn && $(obj).parent(".io_div").hasClass("disa")){
			
			if($(obj).parent(".io_div").hasClass("idt1") && $(".io_div.idt1.disa").length > 1){
				$("#confirmMsg").html("<%=BizboxAMessage.getMessage("TX900000485", "미사용 처리된 사용자를 삭제하시겠습니까?")%>");
				confirmYn = false;
			}else if($(obj).parent(".io_div").hasClass("idt2") && $(".io_div.idt2.disa").length > 1){
				$("#confirmMsg").html("<%=BizboxAMessage.getMessage("TX900000484", "미사용 처리된 부서를 삭제하시겠습니까?")%>");
				confirmYn = false;
			}else if($(obj).parent(".io_div").hasClass("idt3") && $(".io_div.idt3.disa").length > 1){
				$("#confirmMsg").html("<%=BizboxAMessage.getMessage("TX900000483", "미사용 처리된 회사를 삭제하시겠습니까?")%>");
				confirmYn = false;
			}
			
			if(!confirmYn){
				itemRemovePopObj = $("#itemRemovePop").kendoWindow({
					draggable: true,
			       	resizable: true,
			       	width: '360px',
			       	height: 'auto',
			       	title: "",
			       	modal: true 
			   	});	
				itemRemovePopObj.data("kendoWindow").center().open();
				selectedSuperKeyToDelObj = obj;
				return;
			}

		}
		
		var targetSuperKey = $(obj).parent(".io_div").attr("superKey");
		$(obj).parent().addClass("animated05s zoomOutUp");
		setTimeout( function(){$(".io_div.zoomOutUp").remove()} , 310);
		setTimeout( function(){$(".io_div.zoomOutUp").nextAll().addClass("animated03s slideInRight")} , 300);
		setTimeout( function(){$(".int_org").children().removeClass("animated03s slideInRight")} , 700);
		selectedItemSuperKeys.remove(targetSuperKey.replace(/\▦/g,"|"));
		$('.tb_item_list:visible tr[superkey='+targetSuperKey+']').removeClass("on");
		$('.tb_item_list:visible tr[superkey='+targetSuperKey+'] input:checkbox').prop("checked",false);
		OJIL_fnSetAllCheckStatus();
		setTimeout( function(){resetSelectedItemCnt();} , 800);
		return false;
	}
	
	function removeSelectedAllItem(){
		$(".io_div").addClass("animated03s fadeOutUp");
		
		setTimeout( function(){
			$(".int_org").html("");
			resetSelectedItemCnt();
		} , 300);
		
		selectedItemSuperKeys.clear();
		
		$('.tb_item_list:visible tr').removeClass("on");
		$('.tb_item_list:visible tr input:checkbox').prop("checked",false);
		OJIL_fnInitViewStatus_Item();
		
	}	

	/* [ 삭제 ] 삭제 버튼 이벤트 정의
	-----------------------------------------------*/
	function OJSI_fnSetBtnEvent(defaultInfo) {
		
		$('#btn_selected_item_delete').click(function () {
			
			if(!confirm('<%=BizboxAMessage.getMessage("TX000019433","초기화 하시겠습니까?")%>')){
				return false;
			}
			
			removeSelectedAllItem();

		});
		
	}

	/* [ 라벨 ] 선택된 데이터 기본정보 표기 영역
	-----------------------------------------------*/
	function OJSI_fnSetSelectedInfo(defaultInfo, count) {
		var infoTxt = '';
		if (defaultInfo.selectMode.indexOf('d') > -1) {
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000047","회사")%>(<span id="span_selected_item_comp_cnt">0</span>)';
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000098","부서")%>(<span id="span_selected_item_dept_cnt">0</span>)';			
		} if (defaultInfo.selectMode.indexOf('u') > -1) {
			infoTxt += ', <%=BizboxAMessage.getMessage("TX000000141","사원")%>(<span id="span_selected_item_emp_cnt">0</span>)';
		}
		
		infoTxt = "<%=BizboxAMessage.getMessage("TX000010617","선택된 {0} 목록")%>".replace("{0}",infoTxt.substring(1));

		$('#li_selected_item_disp_name').html(infoTxt);

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
