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

<style>
      td{
        max-width: 200px;
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
      }

      [role="tooltip"]{
        visibility: hidden;
      }
</style>

<script type="text/javascript">
	var rowClickCheck = false;			
	var refreshFlag = false;
	// 부서 데이터, 사원 데이터 합쳐주는 변수
	var resultData;
	var faxSeq;
	var faxNo;
	
	var langCode = '${langCode}';
	var groupSeq = '${groupSeq}';
	var compSeq = '${compSeq}';
	var deptSeq = '${deptSeq}';
	var empSeq = '${empSeq}';
	var userSe = '${userSe}';
	
	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();

		//연결 셀렉트박스
		$("#connectSelectBox").kendoComboBox();

		//부서사원선택 셀렉트박스
		$("#orgChoiceSelectBox").kendoComboBox();

		//번호소멸 
		$("tr.extinction td").addClass('text_gray2');
		
		// 팩스 번호 선택 데이터 조회
		fnFaxNumChoiceData(); 
		
		// 조직도 클릭 이벤트
		$("#orgChartButton").click(function(){
			if(rowClickCheck){
				fnOrgChart();	
			} else {
				alert("<%=BizboxAMessage.getMessage("TX000010917","팩스번호를 선택해주세요")%>");
				return;
			}
			
		});
		
		// 삭제 클릭 이벤트
		$("#removeButton").click(function(){
			fnRemove();
		});
		
		// 검색 클릭 이벤트
		$("#faxNoSearchButton").click(function() {
			fnFaxNumChoiceData();
		});
		
		$("#searchDeptUserButton").click(function() {
			if(rowClickCheck){
				fnSearchDeptUser();	
			} else {
				alert("<%=BizboxAMessage.getMessage("TX000010917","팩스번호를 선택해주세요")%>");
				return;
			}
			
		});
	});
	
	function fnRefresh(){
		$("#grid2").html("");
		refreshFlag = true;
		fnFaxNumChoiceData();
		refreshFlag = false;
	}
	
	// 팩스 번호 선택 데이터 조회
	function fnFaxNumChoiceData() {
		var param = {};
		param.faxNo = $("#btnText").val();
		param.syncYn = $("#connectSelectBox").val();

		$.ajax({
			type: "POST"
			, contentType: "application/json; charset=utf-8"
			, url : "<c:url value='/api/fax/web/admin/FaxNoList'/>"
			, data : JSON.stringify(param)
			, dataType : "json"
			, success : function(result) {
				//alert(JSON.stringify(result));

				var faxNoListData = result.result.faxNoList;
				
				fnFaxNumDataGrid(faxNoListData);
				
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});	
	}
	
	function fnFaxNumDataGrid(data) {
		$("#grid").kendoGrid({
			dataSource : data,
			height : 556,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : false,
			columns : [ {
				title : "<%=BizboxAMessage.getMessage("TX000000074","팩스번호")%>",
				template: function(data) {
					// 핸드폰 번호 하이픈 정규식
					var tel = data.faxNo.replace(/(^050.{1}|^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3" );
					
					return tel;
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
				sortable : false
			},	{
				title : "<%=BizboxAMessage.getMessage("TX000000402","별칭")%>",
				template: function(data) {
					return data.nickName;
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center; text-overflow: ellipsis;"
				},
				sortable : false
			},	{
				title : "<%=BizboxAMessage.getMessage("TX000010916","연결")%>",
				template: function(data) {
					var connect = data.syncYn;
					
					if(connect == "Y") {
						return "<%=BizboxAMessage.getMessage("TX000006520","설정")%>";
					} else {
						return "<%=BizboxAMessage.getMessage("TX000010915","미설정")%>";
					}
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
				sortable : false
			}, {
				title : "<%=BizboxAMessage.getMessage("TX000010914","서비스기간")%>",
				template: function(data) {
					var start = data.useBeginDate;
					var end = data.useEndDate;
					
					return start + "~" + end;
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center; "
				},
				sortable : false
			}, {
				title : "<%=BizboxAMessage.getMessage("TX000000543","상태")%>",
				template: function(data) {
					var status = data.status;
					
					if(status == "A") {
						return "<%=BizboxAMessage.getMessage("TX000001464","사용중")%>";
					} else if(status == "B") {
						return "<%=BizboxAMessage.getMessage("TX000010913","종료임박")%>";
					} else if(status == "C") {
						return "<%=BizboxAMessage.getMessage("TX000010912","기간종료")%>";
					} else {
						return "<%=BizboxAMessage.getMessage("TX000010911","번호소멸")%>";
					}
				},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;",
						
				}, /* class명 필요 - 종료임박:text_red, 번호소멸:text_gray2   //팩스연동설정 페이지 확인해주시면 되세요.*/
				sortable : false
			},
			{
				title : "faxSeq",
				template: function(data) {
					return data.faxSeq;
				},
				hidden:true
			}], 
			dataBound : function(e) {
				dataView = this.dataSource.view();
				for(var i=0; i<dataView.length; i++) {
					var uid = dataView[i].uid;

					// 번호소멸, 종료임박 구분 class 추가
					if(dataView[i].status === "B") {
						$("#grid tbody").find("tr[data-uid=" + uid + "]").addClass("text_red");
					} else if(dataView[i].status === "D") {
						$("#grid tbody").find("tr[data-uid=" + uid + "]").addClass("text_gray2");
					}
				}
				
				$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
					$("#grid tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					//선택 item
					var selectedItem = e.sender.dataItem(e.sender.select());
					//데이타 조회 fucntion 호출
					fnRowClick(selectedItem);
		        });						
			}
		});
		
		
		$("#grid").kendoTooltip({
	        filter: "td",
	        position: "right",
	        show: function(e){
	          if(this.content.text() !=""){
	            $('[role="tooltip"]').css("visibility", "visible");
	          }
	        },
	        hide: function(){
	          $('[role="tooltip"]').css("visibility", "hidden");
	        },
	        content: function(e){
	          var element = e.target[0];
	          if(element.offsetWidth < element.scrollWidth){
	        	  var text = $(e.target).text();
	        	  return '<div style="width: ' + text.length * .6 + 'em; max-width: 14em">' + text + '</div>';
	          }else{
	            return "";
	          }
	        }
	      })
	}
	
	// 팩스번호 row 선택 시 데이터 가져오기
	function fnRowClick(selectedItem) {
		rowClickCheck = true;
		
		faxSeq = selectedItem.faxSeq;
		faxNo = selectedItem.faxNo.replace(/\-/g,'');
		
		var param = {};
		param.faxSeq = faxSeq;
		param.faxNo = faxNo;
		
		$.ajax({
			type: "POST"
			, contentType: "application/json; charset=utf-8"
			, url : "<c:url value='/api/fax/web/admin/FaxSyncList'/>"
			, async : false
			, data : JSON.stringify(param)
			, dataType : "json"
			, success : function(result) {

				
				if(result.result.changeResult.changeDeptName == null && result.result.changeResult.changeUserName == null) {
					resultData = [];
				} else {
					resultData = result.result.changeResult.changeDeptName.concat(result.result.changeResult.changeUserName);
					var res = [];
	 				
	 				// 널값 처리하기
	 				for(var index in resultData) {
	 					if(resultData[index]) {
	 						res.push(resultData[index]);
	 					}
	 				}
	 				resultData = res;
				}
				
				fnFaxDeptOrUserDataGrid(resultData);	// 부서/사원 선택 리스트 그리기
				
				// 조직도 선택된 항목 가져오기
				var selectedOrgItem="";
				for(var i=0; i<resultData.length; i++) {
					var path = "";
					
					if(resultData[i].gubun == "E") {
						path = "";
						path = resultData[i].group_seq + "|" + resultData[i].comp_seq + "|" + resultData[i].dept_seq + "|" + resultData[i].orgSeq + "|u"; 
					} else {
						path = "";
						path = resultData[i].group_seq + "|" + resultData[i].comp_seq + "|" + resultData[i].orgSeq + "|0|d";
					}
					
					selectedOrgItem += path + ",";
						
				}
				
				$("#selectedItems").val(selectedOrgItem);
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});	
		
	}
	
	// 부서/사원 그리드 
	function fnFaxDeptOrUserDataGrid(data) {
		$("#grid2").kendoGrid({
			dataSource : data,
			height : 556,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : false,
			columns : [
					{
						field : "<%=BizboxAMessage.getMessage("TX000000265","선택")%>",
						width : 34,
						headerTemplate : '<input type="checkbox" name="allCheck" id="grid_all_chk" onclick="allClick()" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="grid_all_chk"></label>',
						headerAttributes : {
							style : "text-align:center;vertical-align:middle;"
						},
						template : '<input type="checkbox" name="inp_chk" id="#= gubun + "|" + orgSeq + "|" + group_seq + "|" + comp_seq #" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="#= gubun + "|" + orgSeq + "|" + group_seq + "|" + comp_seq #"></label>', //그리드안의 체크박스는 로우별로 아이디가 달라야합니다. 개발 시 아이디를 다르게 넣어주세요.
						attributes : {
							style : "text-align:center;vertical-align:middle;"
						},
						sortable : false
					},
					{
						//field : "회사이름아이디",
						title : "<%=BizboxAMessage.getMessage("TX000016069","회사/이름(아이디)")%>",
						template: function(data) {
							var disp='';
							
							if(data.gubun == "D") {
								disp = data.comp_name;
							} else {
								disp = data.emp_name + "(" + data.login_id + ")";
							}
							
							return disp;
						},
						headerAttributes : {
							style : "text-align: center;"
						},
						attributes : {
							style : "text-align: center;"
						},
						sortable : false
					},
					{
						//field : "부서",
						title: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>",
						template: function(data) {

 								return data.dept_name;

						},
						headerAttributes : {
							style : "text-align: center;"
						},
						attributes : {
							style : "text-align: center;"
						},
						sortable : false
					},
					{
						//field : "직급",
						title:"<%=BizboxAMessage.getMessage("TX000000099","직급")%>",
						template:function(data) {

								return data.man_grade_name;

						},
						width : 80,
						headerAttributes : {
							style : "text-align: center;"
						},
						attributes : {
							style : "text-align: center;"
						},
						sortable : false
					},
					],			
		});
	}
	
	// 체크 박스 전체 클릭
	function allClick() {
		if($("#grid_all_chk").is(":checked")){
			$("input[name=inp_chk]").prop("checked", true);
		} else {
			$("input[name=inp_chk]").prop("checked", false);
		}
	}

	// 조직도 호출
	function fnOrgChart() {
		//$("#compFilter").val(compSeq);
		
		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus();
	}
	
	//담당자 선택팝업 콜백함수
	function callbackSel(data) {
   		// 조직도 정보 저장
   		fnFaxSyncAdd(data);
   }   
	
	// 조직도 정보 저장
	function fnFaxSyncAdd(data) {
		var param = {};
		var infoArray = new Array();
		
		var orgInfo = data.returnObj;
		param.faxSeq = faxSeq;
		param.faxNo = faxNo;
		for(var i=0; i < orgInfo.length; i++) {
			var info = {};
			
			if(orgInfo[i].empDeptFlag == "d") {
				info.orgType = "D";
				info.orgSeq = orgInfo[i].deptSeq;
			} else {
				info.orgType = "E";
				info.orgSeq = orgInfo[i].empSeq;
			}
			info.groupSeq = orgInfo[i].groupSeq;
			info.compSeq = orgInfo[i].compSeq;
			
			infoArray.push(info);
		}

		
		param.faxSyncList =infoArray;

		$.ajax({
			type: "POST"
			, contentType: "application/json; charset=utf-8"
			, url : "<c:url value='/api/fax/web/admin/FaxSyncAdd'/>"
			, data : JSON.stringify(param)
			, dataType : "json"
			, success : function(result) {
				if(result.resultCode == "0") {
					alert("<%=BizboxAMessage.getMessage("TX000001887","사용자가 추가 되었습니다.")%>");
					fnRefresh();	
				} else {
					alert(result.resultMessage);
				}
				
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});	
	}
	
	// 검색 결과
	function fnSearchDeptUser() {
		var gubun = $("#orgChoiceSelectBox").val();
		var search = $("#searchDeptUser").val();

		var searchResultData = [];
		
		for(var i=0; i<resultData.length; i++) {
			if(gubun == "") {
				if(search == "") {
					searchResultData = resultData;
				} else {
					if(resultData[i].gubun == "D") {
						if(resultData[i].dept_name.indexOf(search) > -1 ) {
							searchResultData.push(resultData[i]);	
						}	
					} else {
						if(resultData[i].emp_name.indexOf(search) > -1 ) {
							searchResultData.push(resultData[i]);	
						}	
					}
				}
			} else if(gubun == "D") {
				if(resultData[i].gubun == "D") {
					if(resultData[i].dept_name.indexOf(search) > -1) {
						searchResultData.push(resultData[i]);
					}	
				}
				
			} else {
				if(resultData[i].gubun == "E") {
					if(resultData[i].emp_name.indexOf(search) > -1) {
						searchResultData.push(resultData[i]);
					}
				}
			}
		}
		
		fnFaxDeptOrUserDataGrid(searchResultData);
	}
	
	// 삭제 
	function fnRemove() {
		var param = {};
		var removeInfo = new Array();
		
		$("input[name=inp_chk]").each(function(data) {
			var info = {};
			
			if($(this).is(":checked")) {
				var id = $(this).attr("id");
				var gubun = id.split("|")[0];
				var orgSeq = id.split("|")[1];
				var groupSeq = id.split("|")[2];
				var compSeq = id.split("|")[3];
				
				info.orgType = gubun;
				info.orgSeq = orgSeq;
				info.groupSeq = groupSeq;
				info.compSeq = compSeq;
				
				removeInfo.push(info);
			}
			
		});
		
		param.faxSeq = faxSeq;
		param.faxNo = faxNo;
		param.faxSyncList = removeInfo;

		if(!confirm("<%=BizboxAMessage.getMessage("TX000010909","정말 사용자를 삭제하시겠습니까?")%>")) {
			return;
		}
		
		$.ajax({
			type: "POST"
			, contentType: "application/json; charset=utf-8"
			, url : "<c:url value='/api/fax/web/admin/FaxSyncDel'/>"
			, data : JSON.stringify(param)
			, dataType : "json"
			, success : function(result) {
				if(result.resultCode =="0") {
					alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");
					fnRefresh();	
				} else {
					alert(result.resultMessage);
				}
				
			},
			error : function(request, status, error) {
				alert("code:" + request.status + "\n" + "message:"
						+ request.responseText + "\n" + "error:" + error);
			}
		});	
		
	}
	
</script>

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" width="800" value="<c:url value='/systemx/orgChart.do'/>">
	<input type="hidden" name="selectMode" width="500" value="ud" />
	<!-- value : [u : 사용자 선택], [d : 부서 선택], [ud : 사용자 부서 선택], [od : 부서 조직도 선택], [oc : 회사 조직도 선택]  --> 
	<input type="hidden" name="selectItem" width="500" value="m" />
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	<input type="hidden" name="compSeq" id="compSeq"  value="" />
	<input type="hidden" name="compFilter" id="compFilter" value="" />
	<input type="hidden" name="initMode" id="initMode" value="" />
	<input type="hidden" name="noUseDefaultNodeInfo" id="noUseDefaultNodeInfo" value="" />
	<input type="hidden" name="selectedItems" id="selectedItems" value="" />
</form>

<div class="sub_contents_wrap">
	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width: 50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 팩스번호 선택 -->
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000016092","팩스번호 선택")%></h5>
						</div>
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="" class="k-button"><%=BizboxAMessage.getMessage("TX000016394","갱신")%></button>
							</div>
						</div>
					</div>

					<div class="top_box">
						<dl>
							<dt><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></dt>
							<dd>
								<input class="k-textbox input_search fl" id="btnText"
									type="text" value="" style="width: 120px;" placeholder="">
								<a href="#" class="btn_search fl posi_re" id="faxNoSearchButton"></a>
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000010916","연결")%></dt>
							<dd>
								<!-- <input id="connect" type="text" value="" style="width: 90px;" /> -->
								<select id="connectSelectBox" class="kendoComboBox" style="width: 100px">
								<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
								<option value="Y"><%=BizboxAMessage.getMessage("TX000006520","설정")%></option>
								<option value="N"><%=BizboxAMessage.getMessage("TX000010915","미설정")%></option>
							</select>
							</dd>
						</dl>
					</div>
					<div id="grid" class="mt15">
				</td>

				<td class="twinbox_td">
					<!-- 부서/사원 선택 -->
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000002681","부서/사원 선택")%></h5>
						</div>
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="orgChartButton" class="k-button"><%=BizboxAMessage.getMessage("TX000004738","조직도")%></button>
								<button id="removeButton" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
							</div>
						</div>
					</div>

					<div class="top_box">
						<div class="top_box_in">
							<!-- <input id="orgChoice" type="text" value="" style="width: 100px;" /> -->
							<select id="orgChoiceSelectBox" class="kendoComboBox" style="width: 100px">
								<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
								<option value="E"><%=BizboxAMessage.getMessage("TX000000286","사용자")%></option>
								<option value="D"><%=BizboxAMessage.getMessage("TX000000098","부서")%></option>
							</select>
							<input class="k-textbox input_search" id="searchDeptUser" type="text"
								value="" placeholder="" /> <a href="#" class="btn_search" id="searchDeptUserButton"></a>
						</div>
					</div>
					<div id="grid2" class="mt15">
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //sub_contents_wrap -->