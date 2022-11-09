<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
dutyPositionManageView.jsp  직급/직책관리
doban7 2016-06-23
**/
%>
<!-- script-->

<script>

    var hidTabType = "POSITION";
    var erpUse = "";
    
	$(document).ready(function() {
		
		// 탭
		$("#tabstrip_in").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			},
			select: onTabSelect
		});
		
		$("button").kendoButton();
        //Text 버튼
        $(function () {
            // 버튼 이벤트
            // 일괄등록
            $("#btnBatch").click(function () { fnDutyPositionBatchPop(); });            
            // 신규
            $("#btnNew").click(function () { fnNew(); });
            // 저장
            $("#btnSave").click(function () { fnSave(); });
            // 삭제
            $("#btnDel").click(function () { fnDel(); });
            // 코드 중복체크 
//             $("#btnExistChk").click(function () { fnExistChk(); });
            
        });
        
        //회사선택 selectBox
        compComInit();
        compComInit2();

	    $("#combo_sel_2").kendoComboBox({
	        dataSource : {
				data : [{codeName : "<%=BizboxAMessage.getMessage("TX000000862","전체")%>" , codeSeq : ""}
				      , {codeName : "<%=BizboxAMessage.getMessage("TX000000180","사용")%>" , codeSeq : "Y"}
				      , {codeName : "<%=BizboxAMessage.getMessage("TX000001243","미사용")%>" , codeSeq : "N"}]
	        },
	    	dataTextField: "codeName",
            dataValueField: "codeSeq",
            change: fnGrid ,
	        value:"Y"
	    });
	    
	    fnGrid();
      
	 	// 공통옵션 - erp 조직도연동
	    fnErpOption();
	});
	
	
	//회사선택 selectBox
	function compComInit() {
		var compSeqSel = $("#com_sel").kendoComboBox({
        	dataSource : ${compListJson},
            dataTextField: "compName",
            dataValueField: "compSeq",
            change: fnCompChange,
            index : 0
        }).data("kendoComboBox");
		
		if("${loginVO.userSe}" == "MASTER"){
		    var coCombobox = $("#com_sel").data("kendoComboBox");
		    coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000933","그룹")%>", compSeq: "0" });
		    coCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", compSeq: "" });
		    coCombobox.refresh();
		    coCombobox.select(0);
		}
		
	}
	
	function fnCompChange(){
		$("#compSeq").data("kendoComboBox").value($("#com_sel").data("kendoComboBox").value());
		fnGrid();
		fnCompChange2();
	}
	
	//회사선택 selectBox2(우측 상세)
	function compComInit2() {
		var compSeqCombobox = $("#compSeq").kendoComboBox({
        	dataSource : ${compListJson},
            dataTextField: "compName",
            dataValueField: "compSeq",
            change: fnCompChange2,
            index : 0
        }).data("kendoComboBox");
		
		if("${loginVO.userSe}" == "MASTER"){
		    var compSeqCombobox = $("#compSeq").data("kendoComboBox");
		    compSeqCombobox.dataSource.insert(0, { compName: "<%=BizboxAMessage.getMessage("TX000000933","그룹")%>", compSeq: "0" }); 
		    compSeqCombobox.refresh();
		    compSeqCombobox.select(0);
	    }
	}
	
	
	function fnCompChange2(){
		//erp조직도 연도여부 체크
		//erp조직도 사용인 경우 신규등록 불가.
		var tblParam = {};
		tblParam.compSeq = $("#compSeq").data("kendoComboBox").value();
        
		$.ajax({
			type : "post",
			url : "<c:url value='/cmm/systemx/checkErpCompUseYn.do'/>",
			dataType : "json",
			data : tblParam,
			async : false,
			success : function(result) {
				if(result.erpUse == "Y") {            		
            		$("#erpUse").show();
            		$("#compSeq").data("kendoComboBox").enable(false);
            		// 입력창
        			$("#dpSeq").attr("disabled", true);
        			$("#dpNameKr").attr("disabled", true);
        			$("#dpNameEn").attr("disabled", true);
        			$("#dpNameJp").attr("disabled", true);
        			$("#dpNameCn").attr("disabled", true);

        			// 버튼
        			$("#btnNew").data("kendoButton").enable(false);
        			$("#btnDel").data("kendoButton").enable(false);
        			
        			// 사용여부
        			$("input[name='useYn']").attr("disabled", true);
            	} else {
            		
            		$("#erpUse").hide();	
            		$("#compSeq").data("kendoComboBox").enable(true);
            		// 입력창
        			$("#dpSeq").attr("disabled", false);
        			$("#dpNameKr").attr("disabled", false);
        			$("#dpNameEn").attr("disabled", false);
        			$("#dpNameJp").attr("disabled", false);
        			$("#dpNameCn").attr("disabled", false);	
        		
        			// 버튼
        			$("#btnNew").data("kendoButton").enable(true);
        			$("#btnDel").data("kendoButton").enable(true);
        			
        			// 사용여부
        			$("input[name='useYn']").attr("disabled", false);
            	}
				
			}, 
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
			}
		});
	}
	
	function onTabSelect(e){
		
		var type = e.item.id;
		
		hidTabType = type;
		
		if(hidTabType =="DUTY"){
			$("#infoTitle").html("<%=BizboxAMessage.getMessage("TX000010737","직책정보")%>");
		}else{
			$("#infoTitle").html("<%=BizboxAMessage.getMessage("TX000010736","직급정보")%>");
		}
        fnGrid();
    }
	
	function fnDutyPositionBatchPop(){
		//var compSeq = $("#com_sel").data("kendoComboBox").value();
		var compSeq = $("#compSeq").data("kendoComboBox").value();
		openWindow2("dutyPositionRegBatchPop.do?compSeq="+compSeq, "dutyPositionRegBatchPop", 1000, 710, 0);
	}
	
	function fnButtonInt(compSeq){
   	    if('${loginVO.userSe}' != "MASTER" && compSeq == '0'){
   	    	$("#btnSave").data("kendoButton").enable(false);
			$("#btnDel").data("kendoButton").enable(false);
   	    }else{
   	    	
			if(erpUse == "Y") {
				$("#btnDel").data("kendoButton").enable(false);
			} else {
				$("#btnSave").data("kendoButton").enable(true);
				$("#btnDel").data("kendoButton").enable(true);	
			}
   	    }
	}
	// 결재라인 설정 리스트
	function fnGrid() {
   	    
   	    fnNew();
   	    
		var tblParam = {};
		tblParam.dpName = $("#searchKeyword").val();
		tblParam.dpType = hidTabType;
		tblParam.compSeq = $("#com_sel").val();
		tblParam.useYn = $("#combo_sel_2").val();
        
		$.ajax({
			type : "post",
			url : "<c:url value='/cmm/systemx/dutyPositionData.do'/>",
			dataType : "json",
			data : tblParam,
			async : false,
			success : function(result) {
				if (result.list) {
					var list = result.list;
					var nlen = list.length;
					var actHtml = "";
					for (var nfor = 0; nfor < nlen; nfor++) {
			                actHtml += "<tr id=\'" + list[nfor].dpSeq + "\'";
			                actHtml += " compSeq=\'" + list[nfor].compSeq +"\'";
			                actHtml += " dpType=\'" + list[nfor].dpType +"\'";
			                actHtml += " dpSeq=\'" + list[nfor].dpSeq +"\'";
			                actHtml += " dpName=\'" + list[nfor].dpName +"\'";
			                actHtml += " useYn=\'" + list[nfor].useYn +"\'";
			                actHtml += " orderNum=\'" + list[nfor].orderNum +"\'>";
			                actHtml += " commentText=\'" + list[nfor].commentText +"\'>";
			                actHtml += "<td>" + list[nfor].dpSeq + "</td>";
			                actHtml += "<td>" + list[nfor].dpName + "</td>";
			                actHtml += "<td>" + list[nfor].compName + "</td>";
			                actHtml += "<td>" + list[nfor].useYnNm + "</td>";
			                actHtml += "</tr>";
					}
					if(nlen == 0){
						actHtml += "<tr><td colspan='4'><%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%></td></tr>";
					}

					$("#tList").html(actHtml);
					
					erpUse = result.erpUse;
					fnErpOption(result.erpUse);
				}
			}, 
			error : function(result) {
				alert("<%=BizboxAMessage.getMessage("TX000010858","목록을 가져오는 도중 오류가 발생했습니다")%>");
			}
		});
		
		$("#tList tr").on({
			click: function(){
				var Item = {};
				if(Item.compSeq = $(this).attr("compSeq") == null)
					return;
				Item.compSeq = $(this).attr("compSeq");
				Item.dpType = $(this).attr("dpType");
				Item.dpSeq = $(this).attr("dpSeq");
				Item.useYn = $(this).attr("useYn");
				Item.orderNum = $(this).attr("orderNum");
				Item.commentText = $(this).attr("commentText");
				
				//전체 tr 초기화
				$("#tList tr").removeClass("on");
				//선택 tr 변경
				$(this).addClass("on");
				fnButtonInt(Item.compSeq);
				
				$.ajax({
	            	type: "post",
	                url: "<c:url value='/cmm/systemx/getDutyPositionSeqLangInfo.do'/>",
	                datatype: "json",
	                data: Item,
	                success: function (data) {
	                	console.log(JSON.stringify(data));
	                	if(data.erpUse == "Y") {
	                		
	                		$("#erpUse").show();
	                		$("#compSeq").data("kendoComboBox").enable(false);
	                		// 입력창
	            			$("#dpSeq").attr("disabled", true);
	            			$("#dpNameKr").attr("disabled", true);
	            			$("#dpNameEn").attr("disabled", true);
	            			$("#dpNameJp").attr("disabled", true);
	            			$("#dpNameCn").attr("disabled", true);

	            			// 버튼
	            			$("#btnNew").data("kendoButton").enable(false);
	            			$("#btnDel").data("kendoButton").enable(false);
	            			
	            			// 사용여부
	            			$("input[name='useYn']").attr("disabled", true);
	                	} else {
	                		
	                		$("#erpUse").hide();	
	                		$("#compSeq").data("kendoComboBox").enable(true);
	                		// 입력창
	            			$("#dpSeq").attr("disabled", false);
	            			$("#dpNameKr").attr("disabled", false);
	            			$("#dpNameEn").attr("disabled", false);
	            			$("#dpNameJp").attr("disabled", false);
	            			$("#dpNameCn").attr("disabled", false);	
	            		
	            			// 버튼
	            			$("#btnNew").data("kendoButton").enable(true);
	            			$("#btnDel").data("kendoButton").enable(true);
	            			
	            			// 사용여부
	            			$("input[name='useYn']").attr("disabled", false);
	                	}
	                
	                	Item.dpNameKr = data.result.dpNameKr;
	                	Item.dpNameEn = data.result.dpNameEn;
	                	Item.dpNameCn = data.result.dpNameCn;
	                	Item.dpNameJp = data.result.dpNameJp;
	                	Item.commentText = data.result.commentText;
	                	dutyPositionInfo(Item);
	                	fnButtonInt(Item.compSeq);
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
			 }

		});
	}

	
	function dutyPositionInfo(Item) {
		
		$("#compSeq").data("kendoComboBox").value(Item.compSeq); // 회사코드
		$("#dpSeq").val(Item.dpSeq);  // 코드
		$("#dpNameKr").val(Item.dpNameKr); // 명
		$("#dpNameEn").val(Item.dpNameEn); // 명
		$("#dpNameCn").val(Item.dpNameCn); // 명
		$("#dpNameJp").val(Item.dpNameJp); // 명
//			$("#useYn").val(result.useYn); // 사용여부
		$('input:radio[name="useYn"]:radio[value="'+ Item.useYn + '"]').prop("checked",true);
		
		if(Item.orderNum == "null"){
			$("#orderNum").val(""); // 정렬순서
		}else{
			$("#orderNum").val(Item.orderNum); // 정렬순서
		}		
			
		$("#descText").val(Item.descText); // 설명
		$("#commentText").val(Item.commentText); // 비고
		
//			$("#dpSeq").attr("readonly", true);
		$("#dpSeq").attr("disabled", true);
		$("#compSeq").data("kendoComboBox").enable(false);
		$("#info").prop("class", "text_blue f11 mt5 ml5");
        $("#info").html("");
		
		$("#hidChkId").val("1");
	}
	
	// 코드 추가
	function fnNew() {
		//$("#compSeq").data("kendoComboBox").value("0"); // 회사코드
		
		$("#btnSave").data("kendoButton").enable(true);
		$("#btnDel").data("kendoButton").enable(true);
		
		$("#dpSeq").val("");  // 코드
		$("#dpNameKr").val(""); // 명
		$("#dpNameEn").val(""); // 명
		$("#dpNameJp").val(""); // 명
		$("#dpNameCn").val(""); // 명
		$('input:radio[name="useYn"]:radio[value="Y"]').prop("checked",true);
		$("#orderNum").val(""); // 정렬순서
		$("#descText").val(""); // 설명
		$("#commentText").val(""); // 비고
		
		$("#dpSeq").attr("disabled", false);
		$("#compSeq").data("kendoComboBox").enable(true);
    	$("#info").prop("class", "fl text_red f11 mt5 ml5");
        $("#info").html("");
        $("#hidChkId").val("0");
		
	}
	
	//코드 중복검사(중복체크버튼)
	function fnDpSeqExistChk(dpSeq){
		var data = {};
		data.dpSeq = dpSeq;
		data.dpType = hidTabType;
		data.compSeq = $("#compSeq").val();
		
		if (dpSeq != null && dpSeq != '') {
            $.ajax({
            	type: "post",
                url: "dutyPositionChkSeq.do",
                datatype: "text",
                data: data,
                success: function (data) {
                	var result = data.resultCnt;
                    if (result == 0) {
                    	$("#info").prop("class", "fl text_blue f11 mt5 ml5");
                        $("#info").html(" <%=BizboxAMessage.getMessage("TX000009763","사용 가능한 코드 입니다")%>");
                        $("#hidChkId").val("1");
                    } else {
                    	$("#info").prop("class", "fl text_red f11 mt5 ml5");
                        $("#info").html(" ! <%=BizboxAMessage.getMessage("TX000010735","사용중인 코드 입니다")%>");
                        $("#hidChkId").val("0");
                    }
                },
                error: function (e) {	//error : function(xhr, status, error) {
                    alert("error");
                }
            });
        }else if(dpSeq == '') {
           	$("#info").prop("class", "fl text_red f11 mt5 ml5");
           	$("#info").html("");
           	$("#hidChkId").val("0");
        }
	}
	
	
	// 저장
	function fnSave() {
		
		if($("#dpSeq").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010734","코드를 입력해주세요")%>");
			$("#dpSeq").focus();
			return;
		}
		
		if($("#dpNameKr").val() == "") {
			alert("<%=BizboxAMessage.getMessage("TX000010733","코드명를 입력해주세요")%>");
			$("#dpNameKr").focus();
			return;
		}
		
		if($("#hidChkId").val() == "0"){
			alert("<%=BizboxAMessage.getMessage("TX000010732","코드를 확인해 주세요")%>");
			return false;
		}
		

		var nameList = {};
		var arrName = [];

// 		if($("#menuNameKr").val() != "") {
// 			nameList.menuNm = $("#menuNameKr").val();
// 			nameList.langKind = "kr";
// 			arrName.push(nameList);
// 		}	
// 		if($("#menuNameEn").val() != "") {
// 			nameList = {};
// 			nameList.menuNm = $("#menuNameEn").val();
// 			nameList.langKind = "en";
// 			arrName.push(nameList);
// 		}
		
// 		if($("#menuNameJp").val() != "") {
// 			nameList = {};
// 			nameList.menuNm = $("#menuNameJp").val();
// 			nameList.langKind = "jp";
// 			arrName.push(nameList);
// 		}
		
// 		if($("#menuNameCn").val() != "") {
// 			nameList = {};
// 			nameList.menuNm = $("#menuNameCn").val();
// 			nameList.langKind = "cn";
// 			arrName.push(nameList);
// 		}
		
		var tblParam = {};
		tblParam.dpSeq = $("#dpSeq").val();
		tblParam.dpNameKr = $("#dpNameKr").val();
		tblParam.dpNameEn = $("#dpNameEn").val();
		tblParam.dpNameCn = $("#dpNameCn").val();
		tblParam.dpNameJp = $("#dpNameJp").val();
		tblParam.useYn = $(':radio[name="useYn"]:checked').val();
		tblParam.orderNum = $("#orderNum").val();
		tblParam.descText = $("#descText").val();
		tblParam.commentText = $("#commentText").val();
		
		tblParam.compSeq = $("#compSeq").val();
		tblParam.dpType = hidTabType;
		
// 		tblParam.menuNmList = JSON.stringify(arrName);
		
		$.ajax({
			type:"post",
			url:'dutyPositionSaveProc.do',
			data:tblParam,
			datatype:"json",
			success:function(data){
				if(data.result) {
					
					if(data.result.msg == "0"){
						alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>");
						fnGrid();
					}else if(data.result.msg == "1"){
						alert("! <%=BizboxAMessage.getMessage("TX000010731","해당 코드를 사용중인 사용자가 있습니다")%>");
					}else{
						alert("<%=BizboxAMessage.getMessage("TX000002299","저장에 실패하였습니다.")%>");
					}					
				}	
			},error:function(data){
				alert("<%=BizboxAMessage.getMessage("TX000002299","저장에 실패하였습니다.")%>");
			}
		});
	}

	//코드 삭제
	function fnDel() {
		// 사용중인 직급, 직위일때 체크 필요
		if($("#dpSeq").val() == '') {
			alert("<%=BizboxAMessage.getMessage("TX000010730","삭제할 코드를 선택해주세요")%>");
			return;
		}
		
		var tblParam = {};
		tblParam.dpSeq = $("#dpSeq").val();
		tblParam.compSeq = $("#compSeq").val();
		tblParam.dpType = hidTabType;
		

		if(confirm("<%=BizboxAMessage.getMessage("TX000001981","삭제 하시겠습니까?")%>")){
			
			$.ajax({
				type:"post",
				url:'dutyPositionRemoveProc.do',
				data:tblParam,
				datatype:"json",
				success:function(data){
					if(data.result) {
						if(data.result.msg == "0"){
							alert("<%=BizboxAMessage.getMessage("TX000002074","삭제되었습니다.")%>");
							fnGrid();
						}else if(data.result.msg == "1"){
							alert("! <%=BizboxAMessage.getMessage("TX000010731","해당 코드를 사용중인 사용자가 있습니다")%>");
						}else{
							alert("<%=BizboxAMessage.getMessage("TX000010815","삭제하는데 실패하였습니다")%>");
						}					
					}	
				},error:function(data){
					 alert("<%=BizboxAMessage.getMessage("TX000010815","삭제하는데 실패하였습니다")%>");
				}
			});
		};
		
	}
	
	// 공통옵션 - erp 조직도연동
	function fnErpOption(data) {
		if(data == "Y") {
			
			$("#erpUse").show();
			$("#compSeq").data("kendoComboBox").enable(false);
			// 입력창
			$("#dpSeq").attr("disabled", true);
			$("#dpNameKr").attr("disabled", true);
			$("#dpNameEn").attr("disabled", true);
			$("#dpNameJp").attr("disabled", true);
			$("#dpNameCn").attr("disabled", true);

			// 버튼
			$("#btnNew").data("kendoButton").enable(false);
			$("#btnDel").data("kendoButton").enable(false);
			
			// 사용여부
			$("input[name='useYn']").attr("disabled", true);
			
		} else if(data == "N") {
			$("#erpUse").hide();	
			$("#compSeq").data("kendoComboBox").enable(true);
			// 입력창
			$("#dpSeq").attr("disabled", false);
			$("#dpNameKr").attr("disabled", false);
			$("#dpNameEn").attr("disabled", false);
			$("#dpNameJp").attr("disabled", false);
			$("#dpNameCn").attr("disabled", false);	
		
			// 버튼
			$("#btnNew").data("kendoButton").enable(true);
			$("#btnDel").data("kendoButton").enable(true);
			
			// 사용여부
			$("input[name='useYn']").attr("disabled", false);
		}
	}
</script>
<input type="hidden" id="hidChkId"/>
<input type="hidden" id="hidTabType"/>

					<div class="top_box">
						<dl class="dl1">
	                      <c:if test="${not empty compListJson}">
		                    <dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
		                    <dd><input id="com_sel"/></dd>
                          </c:if>	
							<dt><%=BizboxAMessage.getMessage("TX000015243","직급/직책")%></dt>
							<dd style="width:190px;">
								<input type="text" class="" id="searchKeyword"  style="width:162px;" value="${searchKeyword}"  onkeyup="javascript:if(event.keyCode==13){fnGrid();}"/>
							</dd>
							<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
							<dd><input id="combo_sel_2" style="width:100px;"/></dd>
							<dd><input type="button" id="textButton" onclick="javascript:fnGrid();" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
						</dl>
					</div>

					<div id="" class="controll_btn pt10 posi_ab" style="right:20px;">
						<button type="button" id="btnBatch" class="k-button"><%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></button>
						<button type="button" id="btnNew" class="k-button"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
						<button type="button" id="btnSave" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
						<button type="button" id="btnDel" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
					</div>
					
					<div id="tabstrip_in" class="tab_style">
						
						<ul class="pt10 mb10">
							<li id="POSITION" class="k-state-active"><%=BizboxAMessage.getMessage("TX000000099","직급")%></li>
							<li id="DUTY"><%=BizboxAMessage.getMessage("TX000000105","직책")%></li>
						</ul>
					</div><!-- //tabstrip_in -->

						<div class="sub_contents_wrap">
							<div class="twinbox">
								<table>
									<colgroup>
										<col style="width:55%;" />
										<col />
									</colgroup>
									<tr>
										<td class="twinbox_td">
											<!-- 테이블 -->
											<div class="com_ta2">
												<table>
													<colgroup>
														<col width=""/>
														<col width=""/>
														<col width=""/>
														<col width="117"/>
													</colgroup>
													<tr>
														<th><%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
														<th><%=BizboxAMessage.getMessage("TX000000152","명칭")%></th>
														<th><%=BizboxAMessage.getMessage("TX000016216","사용회사")%></th>
														<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
													</tr>
												</table>
											</div>
											
											<div class="com_ta2 bg_lightgray ova_sc" style="height:518px;overflow-y:scroll;">
												<table>
													<colgroup>
														<col width=""/>
														<col width=""/>
														<col width=""/>
														<col width="100"/>
													</colgroup>
													<tbody id="tList">
											        </tbody>
													<!-- 
													<tr>
														<td colspan="4" class="nocon" style="height:285px;">데이터가 존재하지 않습니다.</td>
													</tr>		 
													-->
												</table>
											</div>
										</td>
										
										<td class="twinbox_td">											
											<div class="posi_re">					
												<p class="tit_p fl" id="infoTitle"><%=BizboxAMessage.getMessage("TX000010736","직급정보")%></p>
												<p class="fr text_blue" id="erpUse" style="display:none;margin-right:35px;"><%=BizboxAMessage.getMessage("TX900000269","ERP 조직도 연동 사용 중")%></p>
											</div>
											
											<div class="com_ta mt14">
												<table>
													<colgroup>
														<col width="130"/>
														<col width=""/>
													</colgroup>
													<tr>
														<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000614","회사선택")%></th>
														<td>
															<input id="compSeq"/>
														</td>
													</tr>
													<tr>
														<th colspan="2"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000045","코드")%></th>
														<td>
															<input class="fl" type="text" value="" maxlength="32" style="width:162px" name="dpSeq" id="dpSeq" onkeyup="fnDpSeqExistChk(this.value);">
						                                    
															<p id="info" class="fl text_red f11 mt5 ml5"> ! <%=BizboxAMessage.getMessage("TX000010734","코드를 입력해주세요")%></p> <!-- 사용 안할경우 p태그 주석처리-->
															<!-- <p class="fl text_blue f11 mt5 ml5">* 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
														</td>		
													</tr>
													<tr>
														<th rowspan="4" width="15%"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000000152","명칭")%></th>
														<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000002787","한국어")%></th>
														<td><input class="" type="text" style="width:162px" name="dpNameKr" id="dpNameKr" maxlength="128"></td>
													</tr>
													<tr>
														<th><%=BizboxAMessage.getMessage("TX000002790","영어")%></th>
														<td><input class="" type="text" style="width:162px" name="dpNameEn" id="dpNameEn" maxlength="128"></td>
													</tr>
													<tr>
														<th><%=BizboxAMessage.getMessage("TX000002788","일본어")%></th>
														<td><input class="" type="text" style="width:162px" name="dpNameJp" id="dpNameJp" maxlength="128"></td>
													</tr>
													<tr>
														<th><%=BizboxAMessage.getMessage("TX000002789","중국어")%></th>
														<td><input class="" type="text" style="width:162px" name="dpNameCn" id="dpNameCn" maxlength="128"></td>
													</tr>
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
														<td>
															<input type="radio" value="Y" name="useYn" id="useYn1" class="k-radio" checked="checked">
							                                <label class="k-radio-label radioSel" for="useYn1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
                                                            <input type="radio"  value="N" name="useYn" id="useYn2" class="k-radio">
			        				                        <label class="k-radio-label radioSel ml10" for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
														</td>
													</tr>
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000000125","정렬순서")%></th>
														<td><input class="" type="text" style="width:92%" name="orderNum" id="orderNum" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)' maxlength="9"></td>
													</tr>
													<tr>
														<th colspan="2"><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
														<td><input class="" type="text" style="width:92%" name="commentText" id="commentText" maxlength="512"></td>
													</tr>
													<input class="" type="hidden" style="width:92%" name="descText" id="descText">
												</table>
																
											</div>
										</td>
									</tr>
								</table>
							</div>
						</div>
																