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



 	<!--css-->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/pudd/css/pudd.css">

    <!--js-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/pudd/js/pudd-1.1.84.min.js"></script>



<script type="text/javascript">
	var faxNOData;
	var faxCompData;
	var todayDisplay;

	var today = new Date();
	todayDisplay = today.toISOString().slice(0,10).replace(/-/g,"");
	

	
	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();

		//팩스번호 셀렉트박스
		$("#faxNumSelectBox").kendoComboBox();

		//회사설정 셀렉트박스
		$("#faxCompSelectBox").kendoComboBox();

		//번호소멸 
		$("tr.extinction td").addClass('text_gray2');

		//팩스 번호 리스트 조회
		fnFaxNoList();
		
		// 회사 설정 리스트 조회
		fnFaxCompList();
		
		// 저장 버튼
		$("#saveButton").click(function(){
			fnSaveComp();
		})
		
		//팩스번호 별칭 설정
		$("#btnNickname").click(function(){
			setFaxNickNameOption();
		})
		
		// 팩스번호 목록 조회버튼
		$("#faxNoSearchButton").click(function() {
			fnFaxNoList();
		});
		
		// 회사 설정 조회 버튼
		$("#compSearchButton").click(function() {
			fnFaxCompList();
		});
	});

	//팩스번호 별칭 설정
	function setFaxNickNameOption(){
		window.puddDlgObj = Pudd.puddDialog({
				width : 830	
			,	height : 418
			,	body : {			 
					iframe : true
					,url : '<c:url value="/api/fax/web/master/FaxNickNameOptionPop.do" />'	 
				}
		});
	}
	
	// 팩스 번호 목록 조회 데이터
 	function fnFaxNoList() {
 		faxNoData = new kendo.data.DataSource({
 		 	  serverPaging: true,
 		 	  //pageSize: 10,
 		 	  transport: {
 		 	    read: {
 		 	      type: 'post',
 		 	      dataType: 'json',
 		 	      url: "<c:url value='/api/fax/web/master/getFaxIDAndNO'/>"
 		 	    },
 		 	    parameterMap: function(data, operation) {
 						data.gubun = $("#faxNumSelectBox").val();
 						data.today = todayDisplay;
 						data.search = $("#faxNumSearch").val();
						//alert(JSON.stringify(data));
 						return data;
 		 	    }
 		 	  },
 		 	  schema: {
 		 	    data: function(response) {
 		 	    	console.log(response.list);
 		 	      return response.faxIDAndNO;
 		 	    },
 			      total: function(response) {
 				        return response.totalCount;
 				      }
 		 	  }
 		});	
 		
		fnFaxNoListTableGrid();
 	}		
 	
	// 팩스번호 목록 그리드		
	function fnFaxNoListTableGrid() {
		
		$("#grid").kendoGrid({
			dataSource : faxNoData,
			height : 556,
			selectable : "single",
			groupable : false,
			columnMenu : false,
			editable : false,
			sortable : true,
			pageable : false,
			columns : [ {
				title: "<%=BizboxAMessage.getMessage("TX000010902","팩스아이디")%>",
				template:function(data) {
					return data.bill36524ID;
					},
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
				sortable : false
			}, {
				title: "<%=BizboxAMessage.getMessage("TX000000074","팩스번호")%>",
				template:function(data) { 
					
					var tel = data.faxNO.replace(/(^050.{1}|^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3" );
					
					return tel;
				},
				
				headerAttributes : {
					style : "text-align: center;"
				},
				attributes : {
					style : "text-align: center;"
				},
				sortable : false
			}, {
				title: "<%=BizboxAMessage.getMessage("TX000000402","별칭")%>",
				template:function(data) { 					
					return "<input type='text' id='" + data.faxSeq + data.faxNO + "' faxSeq='" + data.faxSeq + "' faxNo='" + data.faxNO + "'  style='width:95%;' value='" + data.nickName + "' readonly='readonly' onclick='fnSetNickName(this);'/>";;
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
				title : "faxSeq",
				template: function(data) {
					return data.faxSeq;
				},
				hidden:true
			}],
			dataBound: function(e){ 
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
		
	}
	
	// 팩스번호에 맵핑 된 회사 리스트 정보 가져오기
	function fnRowClick(selectedItem) {

		var param = {};
		
		param.faxSeq = selectedItem.faxSeq;
		param.faxNo = selectedItem.faxNO.replace(/\-/g,'');

		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url : "<c:url value='/api/fax/web/master/FaxNoCompList '/>"
				, data : JSON.stringify(param)
				, dataType : "json"
				, success : function(result) {
					var compList = result.result.compList;
					
					$("input[name=inp_chk]").prop("checked", false);

					// 팩스 번호와 맵핑 된 리스트 체크
					for(var i=0; i<compList.length; i++) {
						$("input[name=inp_chk]").each(function(e){
							var comp = $(this).attr("id");
							
							if(comp == compList[i].compSeq) {
								$(this).prop("checked", true);
							}
						});
					}
					
				},
				error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:"
							+ request.responseText + "\n" + "error:" + error);
				}
		});
		
	}	
	
	// 회사 목록 조회 데이터
	function fnFaxCompList() {
		faxCompData = new kendo.data.DataSource({
		 	  serverPaging: true,
		 	  //pageSize: 10,
		 	  transport: {
		 	    read: {
		 	      type: 'post',
		 	      dataType: 'json',
		 	      url: "<c:url value='/api/fax/web/master/getFaxComp'/>"
		 	    },
		 	    parameterMap: function(data, operation) {
						data.gubun = $("#faxCompSelectBox").val();
						data.search = $("#compSearch").val();
						//alert(JSON.stringify(data));
						return data;
		 	    }
		 	  },
		 	  schema: {
		 	    data: function(response) {
		 	    	console.log(response.list);
		 	      return response.faxComp;
		 	    },
			      total: function(response) {
				        return response.totalCount;
				      }
		 	  }
		});	
		fnFaxCompListGrid();
	}

	// 회사 설정 그리드
	function fnFaxCompListGrid() {
		$("#grid2").kendoGrid({
			dataSource : faxCompData,
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
						headerTemplate : '<input type="checkbox" name="inp_chk" id="grid_all_chk" onclick="allClick()" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="grid_all_chk"></label>',
						headerAttributes : {
							style : "text-align:center;vertical-align:middle;"
						},
						template : '<input type="checkbox" name="inp_chk" id="#= comp_seq #" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="#= comp_seq #"></label>', //그리드안의 체크박스는 로우별로 아이디가 달라야합니다. 개발 시 아이디를 다르게 넣어주세요.
						attributes : {
							style : "text-align:center;vertical-align:middle;"
						},
						sortable : false
					},
					{
						title : "<%=BizboxAMessage.getMessage("TX000000017","회사코드")%>",
						template: function(data) {
							return data.comp_seq;
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
						title : "<%=BizboxAMessage.getMessage("TX000000018","회사명")%>",
						template: function(data) {
							return data.comp_name;
						},
						headerAttributes : {
							style : "text-align: center;"
						},
						attributes : {
							style : "text-align: center;"
						},
						sortable : false
					} ],

		});
	}
	
	// 체크 박스 전체 클릭
	function allClick(){
		if($("#grid_all_chk").is(":checked")){
			$("input[name=inp_chk]")	.prop("checked", true);
		} else {
			$("input[name=inp_chk]").prop("checked", false);
		}
		
	}

	// 팩스 번호에 회사 저장하기
	function fnSaveComp() {
		
		var grid = $("#grid").data("kendoGrid");
		var selectedItem = grid.dataItem(grid.select());
		
		if (selectedItem == null) {
			alert("<%=BizboxAMessage.getMessage("TX000002084","항목을 선택하세요.")%>");
			return;
		}
		
		var param = {};
		var companyArray = new Array();
		
		
		$("input[name=inp_chk]").each(function(e){
			var company = {};
			var comp = $(this).attr("id");
			
			if($(this).is(":checked")) {
				company.compSeq=comp;
				companyArray.push(company);
			}
		});
		
		param.faxSeq = selectedItem.faxSeq;
		param.faxNo = selectedItem.faxNO;
		param.compList = companyArray;
		
		$.ajax({
			type: "POST"
				, contentType: "application/json; charset=utf-8"
				, url : "<c:url value='/api/fax/web/master/FaxNoCompAdd '/>"
				, data : JSON.stringify(param)
				, dataType : "json"
				, success : function(result) {
					//console.log(JSON.stringify(result));
					if(result.resultCode == "0") {
						alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
					}
				},
				error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:"
							+ request.responseText + "\n" + "error:" + error);
				}
		});
		
	}
	
	
	function fnSetNickName(e){
		var targetNickName = $("#" + $(e).attr("faxSeq") + $(e).attr("faxNo"));
		window.puddDlgObj = Pudd.puddDialog({
			width : 497	
		,	height : 139
		,	body : {			 
				iframe : true
				,url : "/gw/api/fax/web/master/FaxNickNameSetPop.do?faxSeq="+$(e).attr("faxSeq")+"&faxNo="+$(e).attr("faxNo")	 
			}
		});
	}
</script>



<div class="sub_contents_wrap">
	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width: 50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 회사코드 목록 -->
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000016093","팩스번호 목록")%></h5>
						</div>
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="btnNickname" class="k-button"><%=BizboxAMessage.getMessage("TX900000432","별칭표시 설정")%></button>
							</div>
						</div>
					</div>

					<div class="top_box">
						<div class="top_box_in">
							<!-- <input id="faxNumSelectBox" type="text" value="" style="width: 100px;" /> -->
							<select id="faxNumSelectBox" class="kendoComboBox" style="width: 100px">
								<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
								<option value="faxNO"><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></option>
								<option value="faxID"><%=BizboxAMessage.getMessage("TX000010902","팩스아이디")%></option>
							</select>
							<input class="k-textbox input_search" id="faxNumSearch" type="text" value="" placeholder="" /> 
							<a href="#" class="btn_search" id="faxNoSearchButton"></a>
						</div>
					</div>
					<div id="grid" class="mt15">
				</td>

				<td class="twinbox_td">
					<!-- 회사 설정 선택 -->
					<div class="btn_div mt0">
						<div class="left_div">
							<h5><%=BizboxAMessage.getMessage("TX000016073","회사 설정")%></h5>
						</div>
						<div class="right_div">
							<div id="" class="controll_btn p0">
								<button id="saveButton" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
							</div>
						</div>
					</div>

					<div class="top_box">
						<div class="top_box_in">
							<!-- <input id="faxCompSelectBox" type="text" value="" style="width: 100px;" /> -->
							<select id="faxCompSelectBox" class="kendoComboBox" style="width: 100px">
								<option value=""><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
								<option value="compCode"><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></option>
								<option value="compName"><%=BizboxAMessage.getMessage("TX000000018","회사명")%></option>
							</select>
							<input class="k-textbox input_search" id="compSearch" type="text"
								value="" placeholder="" /> <a href="#" class="btn_search" id="compSearchButton"></a>
						</div>
					</div>
					<div id="grid2" class="mt15">
				</td>
			</tr>
		</table>
	</div>
</div>
<!-- //sub_contents_wrap -->
<script type="text/javascript">




</script>