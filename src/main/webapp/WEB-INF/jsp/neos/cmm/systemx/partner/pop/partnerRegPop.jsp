<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

	<c:if test="${ClosedNetworkYn != 'Y'}">
		<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
	</c:if>
	
	<script type="text/javascript">		
		$(document).ready(function() {
			
		if("${params.procTp}" == "S"){
			if(opener != null && opener.gridRead != null){
				opener.gridRead();
			}
			
			self.close();
			
			return;
		}
		
		if($("#cdPartner").val() == ""){
			$("#compName").html(opener.$("#selComp option:selected").text());
			$("#svTypeNm").html("<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>");
		}
		
		setCodeBind("grc_sel", "COM516");

		//사용여부 셀렉트박스
		$("#syy_sel").kendoComboBox({
		    dataSource : [
                    { text: "<%=BizboxAMessage.getMessage("TX000002850","예")%>", value:"Y" },
                    { text: "<%=BizboxAMessage.getMessage("TX000006217","아니오")%>", value:"N" }
	        ],
		    dataTextField: "text",
            dataValueField: "value",
		    index: 0
		});
		
		$("#phone").kendoComboBox({
			dataSource : {
			    data : ["010","011","016","017","018","019"]
			},
			value:"${fn:split(info.noTel1,'-')[0]}"
		});

		$("#fax").kendoComboBox({
			dataSource : {
			    data : ["02","031","032","033","041","042","043","044","051","052","053","054","055","061","062","063","064","070","0505"]
			},
			value:"${fn:split(info.noFax1,'-')[0]}"
		});

		//확인
		$("#saveBtn").on("click", function() {
			//필수값 체크
			var alertMsg = "";
			
			if($("#cdPartner").val() == ""){
				alertMsg += ", <%=BizboxAMessage.getMessage("TX000005270","거래처 코드")%>";
			}
			if($("#lnPartner").val() == ""){
				alertMsg += ", <%=BizboxAMessage.getMessage("TX000000313","거래처명")%>";
			}
			if($("#noCompany").val() == ""){
				alertMsg += ", <%=BizboxAMessage.getMessage("TX000000024","사업자번호")%>";
			}
			if($("#nmCeo").val() == ""){
				alertMsg += ", <%=BizboxAMessage.getMessage("TX000000026","대표자명")%>";
			}
			
			if(alertMsg != ""){
				var msg = "<%=BizboxAMessage.getMessage("TX000009295","필수입력값이 누락되었습니다")%>";
				alert(msg + "\r\n[" + alertMsg.substr(2) + "]");
				return;
			}
			
		    document.regForm.action="partnerSaveProc.do";
		    document.regForm.submit();
		});
		
		$("#addPmBtn").on("click", function() {
		    addPm($(this).parent().parent().parent());
		});
		
		$("#btnZip").on("click", function() {
			fnZipPop();
		});

	});
		
		function setCodeBind(selectId, code){
			$("#" + selectId).empty();
			
	        var paramData = {};
	        paramData.code = code;
	   		
		   	 $.ajax({
		     	type:"post",
		 		url:'<c:url value="/cmm/systemx/CmmGetCodeList.do"/>',
	            datatype: "text",
	            data: paramData,		
		 		success: function (data) {
		 			
		 			$("#" + selectId).kendoComboBox({
					    dataSource : data.resultList,
					    dataTextField: "detailName",
			            dataValueField: "detailCode",
					    index: 0
				    });				 			
		 			
				},
				error: function (result) {
		 			
		 		}
		 	});
	    }			
		
		
		function addPm(t) {
			var div = $(t).find(".com_ta")[0];
			var newDiv = $(div).clone(true);
			
			var imgPath = '<c:url value="/Images/btn/close_btn01.png" />';
			
			var delBtn = '<a href="#n" onclick="delPm(this)" class="clo_btn"><img src="'+imgPath+'" alt="삭제" /></a>';
			 
			$(newDiv).find(".pmField").after(delBtn);
			
			$(newDiv).find(".requestInput").val("");
			
			$(".in_com_td").append(newDiv);
			
			// 담당자 1..2 순번 다시 매기기
			resetPmField();
		}
		
		function resetPmField() {
			var pmFieldList = $(".pmField");
			for(var i = 0; i < pmFieldList.length; i++) {
				$(pmFieldList[i]).html("<%=BizboxAMessage.getMessage("TX000000329","담당자")%>"+(i+1));
			}
		}
		
		function delPm(t) {
			$(t).parent().remove();
			resetPmField();
		}
		
		function checkPartnerCd(inp, callback) {
			var value = inp.value;
			
			if (value != '') {
				$.ajax({
		 			type:"post",
		 			url:"partnerCdCheck.do",
		 			datatype:"json",
		 			data: {cdPartner:value},
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
		
		
		function fnZipPop() {
			if(event.keyCode==13){return false;}
			
	        new daum.Postcode({
	            oncomplete: function(data) {
	            	
	                var fullAddr = ''; // 최종 주소 변수
	                var extraAddr = ''; // 조합형 주소 변수

	                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    fullAddr = data.roadAddress;

	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    fullAddr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	                if(data.userSelectedType === 'R'){
	                    //법정동명이 있을 경우 추가한다.
	                    if(data.bname !== ''){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있을 경우 추가한다.
	                    if(data.buildingName !== ''){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('noPost1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('dcAds1H').value = fullAddr;
	
	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById('dcAds1D').focus();  	
	            }
	        }).open();

	    }
			
</script>

<form id="regForm" name="regForm" method="post" onsubmit="return false;">
	<input type="hidden" id="cdCompany" name="cdCompany" value="${info.cdCompany}" />
	<input type="hidden" id="compSeq" name="compSeq" value="${info.compSeq}" />
	<input type="hidden" id="svType" name="svType" value="${info.svType}" />
	
<div class="pop_wrap" style="width:998px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016387","거래처추가")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
	</div>	
	
	<div class="pop_con">

			<div class="btn_top2">
				<h2><%=BizboxAMessage.getMessage("TX000016393","거래처 기본정보")%></h2>
			</div>

			<!-- 거래처 기본정보 테이블 -->
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="153"/>
						<col width="326"/>
						<col width="133"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000005270","거래처 코드")%></th>
						<td colspan="3">
							<c:if test="${info.cdPartner != null and info.cdPartner != ''}">
								<span>${info.cdPartner}</span>
								<input type="text"  style="width:298px;display:none;" id="cdPartner" name="cdPartner" value="${info.cdPartner}" />
							</c:if>
							<c:if test="${info.cdPartner == null}">
								<input type="text"  style="width:298px;" id="cdPartner" name="cdPartner" value="${info.cdPartner}" onkeyup="checkPartnerCd(this, noDuplInfo);" />
							</c:if>							
							
							<span class="text_blue f11 mt5" id="p_no_1" style="display:none;">* <%=BizboxAMessage.getMessage("TX000009763","사용 가능한 코드 입니다.")%></span>
							<span class="text_red f11 mt5" id="p_no_2"  style="display:none;">* <%=BizboxAMessage.getMessage("TX000016159","이미 등록된 코드 입니다.")%></span>
						</td>
					</tr> 
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000313","거래처명")%></th>
						<td colspan="3"><input type="text" value="${info.lnPartner}" id="lnPartner" name="lnPartner"  style="width:388px;"></td>
					</tr>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000024","사업자번호")%></th>
						<td><input type="text" id="noCompany" value="${info.noCompany}" style="width:298px;" name="noCompany"  ></td>
						<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000010590","거래처분류")%></th>
						<td><input id="grc_sel" style="width:298px;" id="clsPartner" name="clsPartner" value="${info.clsPartner}" ></td>
					</tr>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png' />" alt="" /> <%=BizboxAMessage.getMessage("TX000000026","대표자명")%></th>
						<td colspan="3"><input type="text" value="${info.nmCeo}" style="width:298px;" id="nmCeo" name="nmCeo" ></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000029","업태")%></th>
						<td><input type="text" value="${info.tpJob}" style="width:298px;" id="tpJob" name="tpJob" ></td>
						<th><%=BizboxAMessage.getMessage("TX000005782","업종")%></th>
						<td><input type="text" value="${info.clsJob}" style="width:298px;" id="clsJob" name="clsJob" ></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
						<td id="compName">${info.compName}</td>
						<th><%=BizboxAMessage.getMessage("TX000010589","정보유형")%></th>
						<td id="svTypeNm">${info.svTypeNm}</td>
					</tr>											
				</table>
			</div>

			<div class="btn_top2 mt12">
				<h2><%=BizboxAMessage.getMessage("TX000016390","거래처 부가정보")%></h2>
			</div>
			
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="153"/>
						<col width="326"/>
						<col width="133"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
						<td colspan="3">
							<input id="syy_sel" style="width:104px;" name="useYn" value="${info.useYn}" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000073","전화번호")%></th>
						<td>
							<input id="phone" style="width:80px;"  name="noTel1" /> - 
							<input type="text" size="6" maxlength="4" value="${fn:split(info.noTel1,'-')[1]}" style="width:80px;" name="noTel1" /> - 
							<input type="text" size="6" maxlength="4" value="${fn:split(info.noTel1,'-')[2]}" style="width:80px;" name="noTel1"/>
						</td>
						<th>FAX</th>
						<td>
							<input id="fax" style="width:80px;"  name="noFax1" /> - 
							<input type="text" size="6" maxlength="4" value="${fn:split(info.noFax1,'-')[1]}"style="width:80px;" name="noFax1"  /> - 
							<input type="text" size="6" maxlength="4" value="${fn:split(info.noFax1,'-')[2]}" style="width:80px;" name="noFax1" />
						</td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000375","주소")%></th>
						<td colspan="3" class="pd6">
							<input type="text" value="${fn:split(info.noPost1,'-')[0]}" style="width:88px;" name="noPost1" id="noPost1" <c:if test="${ClosedNetworkYn == 'Y'}">placeholder="우편번호"</c:if>>
							<div id="" class="controll_btn p0" <c:if test="${ClosedNetworkYn == 'Y'}">style="display: none;"</c:if>>
								<button id="btnZip" type="button"><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
							</div>
							
							<div class="mt5">
								<input class="mr5" type="text" value="${info.dcAds1H}" style="float:left; width:37%;" name="dcAds1H" id="dcAds1H"/>
								<input type="text" value="${info.dcAds1D}" style="float:left; width:58%;" name="dcAds1D" id="dcAds1D"/>
							</div>
						</td>
					</tr>
					
					<tr>
						<th rowspan="3"><%=BizboxAMessage.getMessage("TX000007215","거래처 담당자")%> <br /> 
							<div id="" class="controll_btn" style="padding:5px 0;">
								<button id="addPmBtn" type="button"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
							</div>
						</th>
						<td class="in_com_td flo_td"  colspan="3">
						
						<c:forEach items="${detailList}" var="list" varStatus="c">
							<div class="com_ta in_com" style="width:770px;" id="divPm${c.count}">
								<p class="p1 pmField"><%=BizboxAMessage.getMessage("TX000000329","담당자")%>${c.count}</p>
								<c:if test="${c.count > 1 }">
								<a href="#n" class="clo_btn" onclick="delPm(this)" ><img src="<c:url value='/Images/btn/close_btn01.png' />" alt="삭제" /></a>
								</c:if>
								<table>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;"><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></span>
										<input type="text" class="requestInput" style="width:35%;" name="nmPtr" value="${list.nmPtr}" />
										<span class="txt_ib" style="width:10%;">FAX</span>
										<input type="text" class="requestInput" style="width:30%;" name="noFax" value="${list.noFax}" />
									</td>
								</tr>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;">E-mail</span>
										<input type="text" class="requestInput" style="width:76%;" name="eMail" value="${list.eMail}"  />
									</td>
								</tr>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;"><%=BizboxAMessage.getMessage("TX000000006","전화")%></span>
										<input type="text" class="requestInput" style="width:35%;" name="noTel" value="${list.noTel}"  />
										<span class="txt_ib" style="width:10%;"><%=BizboxAMessage.getMessage("TX000000008","핸드폰")%></span>
										<input type="text" class="requestInput" style="width:30%;" name="noHp" value="${list.noHp}" />
									</td>
								</tr>
								</table>
							</div>
						</c:forEach>
						
						<c:if test="${empty detailList}">
							<div class="com_ta in_com" style="width:770px;" id="divPm1">
								<p class="p1 pmField"><%=BizboxAMessage.getMessage("TX000000329","담당자")%></p>
								<table>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;"><%=BizboxAMessage.getMessage("TX000015261","담당자명")%></span>
										<input type="text" class="requestInput" style="width:35%;" name="nmPtr" value="" />
										<span class="txt_ib" style="width:10%;">FAX</span>
										<input type="text" class="requestInput" style="width:30%;" name="noFax" value="" />
									</td>
								</tr>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;">E-mail</span>
										<input type="text" class="requestInput" style="width:76%;" name="eMail" value="" />
									</td>
								</tr>
								<tr>
									<td class="flo_td">
										<span class="txt_ib" style="width:20%;"><%=BizboxAMessage.getMessage("TX000000006","전화")%></span>
										<input type="text" class="requestInput" style="width:35%;" name="noTel" value="" />
										<span class="txt_ib" style="width:10%;"><%=BizboxAMessage.getMessage("TX000000008","핸드폰")%></span>
										<input type="text" class="requestInput" style="width:30%;" name="noHp" value="" />
									</td>
								</tr>
								</table>
							</div>
						</c:if>
						</td>
					</tr>
				</table>	
			</div>

	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" id="saveBtn" /> 
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="window.close()" />
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->

</form>