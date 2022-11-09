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
<!-- script-->
<script id="treeview-template" type="text/kendo-ui-template">
            #: item.text #
	</script>

<script type="text/javascript">
    	var check = ${check};
    
		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
			if(check == 1) {
				$("#noProject").prop("disabled", true);
			} 
			
		    //진행상태 셀렉트박스
		    var staProjectSelData = [
                        { text: "<%=BizboxAMessage.getMessage("TX000006808","작성")%>", value:"001" },
                        { text: "<%=BizboxAMessage.getMessage("TX000011889","검토")%>", value:"002" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000798","승인")%>", value:"003" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000735","진행")%>", value:"100" },
                        { text: "<%=BizboxAMessage.getMessage("TX000001288","완료")%>", value:"999" }
                    ];

		    $("#staProject").kendoComboBox({
		    	dataTextField: "text",
                dataValueField: "value",
		        dataSource : staProjectSelData,
		        index: 0
		    });
		    
		    var cdExchSelData = [
                        { text: "KRW", value:"KRW" },
                        { text: "USD", value:"USD" },
                        { text: "EUR", value:"EUR" }
            ];
		    
			//통화 셀렉트박스
		    $("#cdExch").kendoComboBox({
		    	dataTextField: "text",
                dataValueField: "value",
		        dataSource : cdExchSelData,
		        select: onSelectCdExch,
		        index: 0
		    });
			// 프로젝트기간시작
		    $("#sdProject").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR"
		    });

			// 프로젝트기간끝
		    $("#edProject").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR"
		    });
			// 계약일
		    $("#dtChange").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR"
		    });	
		    //첨부파일	
			$("#fileUpload01").kendoUpload({
				localization: {
					select: "<%=BizboxAMessage.getMessage("TX000001702","찾기")%>"
				},
				multiple: false
			});
		    
		    function onSelectCdExch(e) {
		    	var dataItem = this.dataItem(e.item.index());
		    	changeCdExch(dataItem.value);
		    	
		    	computeMoney();
		    }
		    
		    $("#saveBtn").on("click", function() {
		    	var projectCode = $("#noProject").val();
		    	
		    	// 필수값 체크
		    	if($("#noProject").val() == "") {
		    		alert("<%=BizboxAMessage.getMessage("TX000010579","프로젝트 코드를 입력해주세요")%>");
		    		$("#noProject").focus();
		    		return;
		    	}
		    	
		    	if($("#nmProject").val() == "") {
		    		alert("<%=BizboxAMessage.getMessage("TX000010578","프로젝트명을 입력해주세요")%>");
		    		$("#nmProject").focus();
		    		return;
		    	}
		    	
		    	if($("#sdProject").val() == "") {
		    		alert("<%=BizboxAMessage.getMessage("TX000010577","프로젝트 시작일을 입력해주세요")%>");
		    		$("#sdProject").focus();
		    		return;
		    	}
		    	
		    	if($("#edProject").val() == "") {
		    		alert("<%=BizboxAMessage.getMessage("TX000013360","프로젝트 종료일")%>");
		    		$("#edProject").focus();
		    		return;
		    	}
		    	
		    	if($("#pmName").val() == "") {
		    		alert("<%=BizboxAMessage.getMessage("TX000010575","PM를 선택해주세요")%>");
		    		$("#pmName").focus();
		    		return;
		    	}
		    	//alert(projectCode);
		    	//return;
		    	$("#noProject").prop("disabled", false);
		    	document.regForm.action="projectSaveProc.do";
		    	document.regForm.submit();
		    });
		    
		    $("#ptrBtn").on("click", function() {
		    	partnerPop();
		    });
		    
		    $("#ptrPmBtn").on("click", function() {
		    	partnerPmPop();
		    });
		    
		    $(".num_inp").on("keyup", function() {
		    	computeMoney($(this).attr('id'));
		    });
		    
		    // 외화 코드 설정
		    <c:if test="${not empty projectInfo.cdExch && projectInfo.cdExch != 'KRW'}">
		    	var exchInpList = $("#td_exch").find("input");
		    	$(exchInpList[0]).val('${projectInfo.cdExch}');
		    </c:if>
		    
		    // 외화 계산
		    computeMoneyExch();
		    
		   // initMoney();
		    
		   $("#noProject").keypress(function(e){
			   if(e.which === 32) {
				   //alert('abc');
				   return false;
			   }
		   });
		   
		}); 
		
		
		//프로젝트코드 한글입력 막기;
	   function fn_press_han(obj)
	   {
	        //좌우 방향키, 백스페이스, 딜리트, 탭키에 대한 예외
	        if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39
	        || event.keyCode == 46 ) return;
	        //obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	        obj.value = obj.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	    }
		
		
		
		// 외화코드 변경 처리
		function changeCdExch(cdExch) {
			var inpList = $("#td_exch").find("input");
			
			//KRW(원화) 선택 시 환율 입력칸 비활성화
			if (cdExch == 'KRW') {
				$(inpList[0]).val("");	// 외화코드
				$("#rtExch").attr("disabled",true);
				$("#rtExch").val("");
			} 
			//다른 외화 선택 시, 환율 입력 inputbox 활성화되어 환율 입력가능(해당 외화의 환율 작성)
			else  {
				$(inpList).val("0");
				$(inpList[0]).val(cdExch);	// 외화코드
				$("#rtExch").val("");
				$("#rtExch").attr("disabled",false);
				computeMoneyExch();
			}
		}
		
		function initMoney() {
			$(".num_inp").val("0");
		}
		
		// 공급가액, 부가세, 합계 계산.
		function computeMoney(id) {
			var inpList = $("#td_won").find("input");
			var base = parseInt($(inpList[1]).val())||0;  // 공급가액
			var vat = parseInt($(inpList[2]).val())||0; // 부가세
			var won = parseInt($(inpList[3]).val())||0; // 합계
			
			if (id == 'amBase') {	// 공급가액 입력: , 부가세(공급가액*10%) /합계( 공급가액+부가세 ) 자동 계산
				var v = parseInt(neosWonCeil(base, 10, 0.1, 0));
				$(inpList[2]).val(v);
				$(inpList[3]).val(v+base);
				
			} else if (id == 'amWonvat') { // 부가세 입력 : 공급가액(부가세*10) / 합계( 공급가액+부가세 ) 자동 계산
				var b = parseInt(neosWonFloor(vat, 10, 10, 0));
				$(inpList[1]).val(b); 
				$(inpList[3]).val(b+vat);
				
			} else if (id == 'amWonamt') { // 합계 입력 : 공급가액(합계/1.1), 부가세(합계/11) 자동 계산
				var b = parseInt(neosWonCeil(parseFloat(won/1.1).toFixed(0),10,1, 0));
				var v = parseInt(neosWonCeil(b, 10, 0.1, 0));
				$(inpList[1]).val(b); 
				$(inpList[2]).val(v); 
			}
			computeMoneyExch();
		}
		
		// 외화 계산
		function computeMoneyExch() {
			var rtExch = parseFloat($("#rtExch").val())||0.0;	//환율
			
			if (rtExch > 0) {
				var wonInpList = $("#td_won").find("input");
				var base =parseInt($(wonInpList[1]).val())||0;  // 공급가액
				var vat = parseInt($(wonInpList[2]).val())||0; // 부가세
				var won = parseInt($(wonInpList[3]).val())||0; // 합계	
				
				var exchInpList = $("#td_exch").find("input");
				$(exchInpList[1]).val(neosWonFloor(base * rtExch, 1, 1, 2));
				$(exchInpList[2]).val(neosWonFloor(vat * rtExch, 1, 1, 2));
				$(exchInpList[3]).val(neosWonFloor(won * rtExch, 1, 1, 2));
			} 
		}
		
		function checkProjectNo(inp, callback) {
			var value = inp.value;
			
			if(value == ""){
				$("#noProject").val("");
	 			$("#p_no_1").css("display","none");
	 			$("#p_no_2").css("display","none");
	 			return;				
			}
						
			var regExp = /[~!@\#$%<>^&*\()\=+\’]/gi;	
			
			if(!(/[a-z|A-Z|ㄱ-ㅎ|가-힣]/.test(value))) {
				alert("<%=BizboxAMessage.getMessage("TX000017976","첫 글자는 영어가 와야합니다")%>");
				$("#noProject").val("");
	 			$("#p_no_1").css("display","none");
	 			$("#p_no_2").css("display","none");
	 			return;
			}
			
			if(regExp.test(value)) {
				alert(". - _ : , <%=BizboxAMessage.getMessage("TX000016307","를 제외한 특수문자는 입력할 수 없습니다.")%>");
				$("#noProject").val(value.substring(0, value.length-1));
	 			$("#p_no_1").css("display","none");
	 			$("#p_no_2").css("display","none");
	 			return;
			}
			
			
			if (value != '') {
				$.ajax({
		 			type:"post",
		 			url:"projectNoCheck.do",
		 			datatype:"json",
		 			data: {noProject:value},
		 			success:function(data){
		 				callback(data.result);
		 			},			
		 			error : function(e){	//error : function(xhr, status, error) {
		 				//alert("error");	
		 			}
		 		});	 
			}
		}
			
	    function noDuplInfo(result) {
	    	if(result == 0) {
	 			$("#p_no_1").css("display","");
	 			$("#p_no_2").css("display","none");
	 		} else {
	 			$("#p_no_2").css("display","");
	 			$("#p_no_1").css("display","none");
	 		}
	    }
	    
//  	    function userSelectPop() {
// 	    	var url = "cmmOrgChartSelectPop.do";
// 	    	var pop = window.open(url, "empInfoPop", "width=576,height=600,scrollbars=no");
					
// 	    	pop.focus();   
// 	    } 


		function userSelectPop(){
			var url = "<c:url value='/html/common/cmmOrgPop.jsp'/>"; 
			var pop = window.open("", "cmmOrgPop", "width=768,height=800,scrollbars=no");

			orgPop.target = "cmmOrgPop";
			orgPop.method = "post";
			orgPop.action = url; 
			orgPop.submit(); 
			orgPop.target = ""; 
		    pop.focus();  
		}
	    
		function callbackSel(param){

			$("#pmSeq").val(param.returnObj[0].empSeq); 
    		$("#pmName").val(param.returnObj[0].empName); 
    		$("#pmCompSeq").val(param.returnObj[0].compSeq);
		}
		
		
	    function partnerPop() {
	    	var url = "partnerListPop.do";
	    	var pop = window.open(url, "partnerListPop", "width=576,height=600,scrollbars=no");
					
	    	pop.focus();   
	    }
	    
	    function partnerPmPop() {
	    	var cdPartner = $("#cdPartner").val();
	    	
	    	var url = "partnerPmListPop.do?cdPartner="+cdPartner;
	    	var pop = window.open(url, "partnerPmListPop", "width=596,height=600,scrollbars=no");
					
	    	pop.focus();   
	    }
    	
    	function callbackSelectUser(data) {
    		$("#pmSeq").val(data[0].empSeq); 
    		$("#pmName").val(data[0].empName); 
    		$("#pmCompSeq").val(data[0].compSeq); 
    	}
    	
    	function callbackPartner(data) {
    		console.log(data);
    		$("#lnPartner").val(data.lnPartner);
    		$("#cdPartner").val(data.cdPartner);
    	}
    	
    	function callbackPartnerPm(data) {
    		$("#nmPtr").val(data.nmPtr);
    		$("#noFax").val(data.noFax);
    		$("#eMail").val(data.eMail);
    		$("#noTel").val(data.noTel);
    		$("#noHp").val(data.noHp);
    	}
		
	</script>

<form id="regForm" name="regForm" method="POST" enctype="multipart/form-data">
	<input type="hidden" id="noSeq" name="noSeq" value="${projectInfo.noSeq}" /> 
	<input type="hidden" id="svType" name="svType" value="${projectInfo.svType}" /> 
	<input type="hidden" id="cdCompany" name="cdCompany" value="${projectInfo.cdCompany}" />
	<div class="sub_contents_wrap">
		<!-- 버튼영역 -->
		<div id="" class="controll_btn" style="padding: 0px;">
			<button id="listBtn" class="k-button" type="button"><%=BizboxAMessage.getMessage("TX000016281","목록으로 돌아가기")%></button>
			<button id="delBtn" class="k-button" type="button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
		</div>

		<!-- 프로젝트 기본정보 -->
		<p class="tit_p"><%=BizboxAMessage.getMessage("TX000016085","프로젝트 기본정보")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="165" />
					<col width="330" />
					<col width="165" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png' />"
						alt="" /> <%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%></th>
					<td class="vt"><input type="text" style="width: 300px;"
						id="noProject" name="noProject" value="${projectInfo.noProject}"
						onkeyup="checkProjectNo(this, noDuplInfo);" onkeydown="fn_press_han(this);"/>
						<p class="text_blue f11 mt5" id="p_no_1" style="display: none;">*
							<%=BizboxAMessage.getMessage("TX000009763","사용 가능한 코드 입니다")%></p>
						<p class="text_red f11 mt5" id="p_no_2" style="display: none;">*
							<%=BizboxAMessage.getMessage("TX000016159","이미 등록된 코드 입니다.")%></p></td>
					<th><%=BizboxAMessage.getMessage("TX000004254","계약일")%></th>
					<td class="vt"><input id="dtChange" name="dtChange"
						value="${projectInfo.dtChange}" style="width: 250px;" /></td>
				</tr>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png' />"
						alt="" /> <%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%></th>
					<td colspan="3"><input type="text" style="width: 743px;"
						id="nmProject" name="nmProject" value="${projectInfo.nmProject}" /></td>
				</tr>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png' />"
						alt="" /> <%=BizboxAMessage.getMessage("TX000010581","프로젝트기간")%></th>
					<td><input id="sdProject" name="sdProject"
						style="width: 142px;" value="${projectInfo.sdProject}" /> ~ <input
						id="edProject" name="edProject" style="width: 142px;"
						value="${projectInfo.edProject}" /></td>
					<th><%=BizboxAMessage.getMessage("TX000000906","진행상태")%></th>
					<td><input id="staProject" name="staProject"
						style="width: 250px;" value="${projectInfo.staProject}" /></td>
				</tr>
			</table>
		</div>
		<!--// com_ta -->

		<!-- 프로젝트 부가정보 -->
		<p class="tit_p mt20"><%=BizboxAMessage.getMessage("TX000016084","프로젝트 부가정보")%></p>
		<div class="com_ta">
			<table>
				<colgroup>
					<col width="165" />
					<col width="" />
				</colgroup>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png' />"
						alt="" /> <%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
					<td><input type="radio" name="useYn" id="useYn1"
						class="k-radio" checked="checked" value="Y" /> <label
						class="k-radio-label radioSel" for="useYn1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label> <input
						type="radio" name="useYn" id="useYn2" class="k-radio"
						<c:if test="${projectInfo.useYn == 'N'}">checked="checked"</c:if>
						value="N" /> <label class="k-radio-label radioSel ml10"
						for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label></td>
				</tr>
				<tr>
					<th><img src="<c:url value='/Images/ico/ico_check01.png' />"
						alt="" /> <%=BizboxAMessage.getMessage("TX000016086","프로젝트 PM")%></th>
					<td>
						<div class="dod_search">
							<input type="text" class="" id="pmName" name="pmName" style="width: 279px;" placeholder="" value="${projectInfo.pmName}" />
							<a href="#" class="btn_sear" onclick="userSelectPop()"></a> 
							<input id="pmSeq" name="pmSeq" value="${projectInfo.pmSeq}" type="hidden" /> 
							<input id="pmCompSeq" name="pmCompSeq" value="${projectInfo.pmCompSeq}" type="hidden" />
						</div>
					</td>
				</tr>
				<tr>
					<th rowspan="3"><%=BizboxAMessage.getMessage("TX000016118","진행금액")%></th>
					<td class="flo_td"><span class="txt_ib en_w148" style="width: 44px;">(<%=BizboxAMessage.getMessage("TX000015001","통화")%>)</span>
						<input style="width: 250px;" id="cdExch" name="cdExch"
						value="${projectInfo.cdExch}" /> <span class="txt_ib"
						style="width: 130px;">(<%=BizboxAMessage.getMessage("TX000004660","환율")%>)</span> <input type="text"
						style="width: 299px;" id="rtExch" name="rtExch" class="num_inp en_w256"
						disabled value="${projectInfo.rtExch}" /></td>
				</tr>
				<tr>
					<td class="flo_td" id="td_won"><span class="txt_ib en_w90"
						style="width: 44px;">(<%=BizboxAMessage.getMessage("TX000016165","원화")%>)</span> <input type="text"
						style="width: 64px; text-indent: 0; text-align: center;"
						value="KRW" /> <span class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></span>
						<input type="text" style="width: 120px;" class="num_inp"
						id="amBase" name="amBase" value="${projectInfo.amBase}" /> <span
						class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%></span> <input type="text"
						style="width: 120px;" class="num_inp" id="amWonvat"
						name="amWonvat" value="${projectInfo.amWonvat}" /> <span
						class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%></span> <input type="text"
						style="width: 120px;" class="num_inp" id="amWonamt"
						name="amWonamt" value="${projectInfo.amWonamt}" /></td>
				</tr>
				<tr>
					<td class="flo_td" id="td_exch"><span class="txt_ib en_w105"
						style="width: 44px;">(<%=BizboxAMessage.getMessage("TX000016166","외화")%>)</span> <input type="text"
						style="width: 64px; text-indent: 0; text-align: center;" disabled />
						<span class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000516","공급가액")%></span> <input
						type="text" style="width: 120px;" class="num_inp" disabled /> <span
						class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000517","부가세")%></span> <input type="text"
						style="width: 120px;" class="num_inp" disabled /> <span
						class="txt_ib" style="width: 75px;"><%=BizboxAMessage.getMessage("TX000000518","합계")%></span> <input type="text"
						style="width: 120px;" class="num_inp" disabled /></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000644","비고")%></th>
					<td><input type="text" style="width: 743px;" id="dcRmk"
						name="dcRmk" value="${projectInfo.dcRmk}" /></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000000521","첨부파일")%></th>
					<td class="flo_td"><input class="" type="text" value=""
						style="width: 688px" readonly="readonly"
						value="${projectInfo.nmAttach}"> <input
						name="fileUpload01" id="fileUpload01" type="file" /> <input
						name="idAttach" id="idAttach" type="hidden"
						value="${projectInfo.idAttach} " /></td>
				</tr>
				<tr>
					<th rowspan="4"><%=BizboxAMessage.getMessage("TX000016388","거래처정보")%></th>
					<td class="flo_td"><span class="txt_ib" style="width: 58px;">(<%=BizboxAMessage.getMessage("TX000000520","거래처")%>)</span>
						<div class="dod_search">
							<input type="text" class="" style="width: 279px;" placeholder=""
								id="lnPartner" name="lnPartner" value="${projectInfo.lnPartner}" /><a
								href="#" class="btn_sear" id="ptrBtn"></a> <input type="hidden"
								id="cdPartner" name="cdPartner" value="${projectInfo.cdPartner}" />
						</div></td>
				</tr>
				<tr>
					<td class="flo_td"><span class="txt_ib en_w163" style="width: 58px;">(<%=BizboxAMessage.getMessage("TX000015261","담당자명")%>)</span>
						<div class="dod_search">
							<input type="text" style="width: 279px;" id="nmPtr" name="nmPtr"
								value="${projectInfo.nmPtr}" /><a href="#" class="btn_sear"
								id="ptrPmBtn"></a>
						</div> <span class="txt_ib en_w77" style="width: 65px;">(FAX)</span> <input
						type="text" class="en_w250" style="width: 300px;" id="noFax" name="noFax"
						value="${projectInfo.noFax}" /></td>
				</tr>
				<tr>
					<td class="flo_td"><span class="txt_ib en_w54" style="width: 58px;">(E-mail)</span>
						<input type="text" style="width: 675px;" id="eMail" name="eMail" class="en_w723"
						value="${projectInfo.eMail}" /></td>
				</tr>
				<tr>
					<td class="flo_td"><span class="txt_ib en_w77" style="width: 58px;">(<%=BizboxAMessage.getMessage("TX000000006","전화")%>)</span>
						<input type="text" style="width: 300px;" id="noTel" name="noTel"
						value="${projectInfo.noTel}" /> <span class="txt_ib en_w90"
						style="width: 65px;">(<%=BizboxAMessage.getMessage("TX000000008","핸드폰")%>)</span> <input type="text"
						style="width: 300px;" id="noHp" name="noHp"
						value="${projectInfo.noHp}" /></td>
				</tr>
			</table>
		</div>
		<!--// com_ta -->

		<div class="btn_cen">
			<input type="button" id="saveBtn" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>">
		</div>


	</div>
	<!-- //sub_contents_wrap -->



</form>

<!-- 조직도 팝업 호출 -->
<form id="orgPop" name="orgPop">
	 
	<input type="hidden" name="selectMode" width="500" value="u" /> 
	<input type="hidden" name="selectItem" width="500" value="m" /> 
	<input type="hidden" name="callback" width="500" value="callbackSel" />
	
	<input type="hidden" name="noUseDefaultNodeInfo" width="500" value="true"/>
</form>		

<jsp:include
	page="/WEB-INF/jsp/neos/cmm/systemx/project/include/projectParameterForm.jsp" />