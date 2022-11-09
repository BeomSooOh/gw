<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>

	var link_obj = opener.$("#sortable .portal_portlet[link_seq=${param.linkSeq}]");

	$(document).ready(function() {
		
		if('${param.linkSeq}' == '-1'){
			$("[name='ifHide']").hide();
		}
		
		setInfo();
		
		$("#show_from, #show_to").kendoDatePicker({format: "yyyy-MM-dd"});
		
	});

	
	function setInfo(){
		
		$("#link_nm").val($(link_obj).attr("link_nm"));
		$("#link_url").val($(link_obj).attr("link_url"));
		$("#show_from").val($(link_obj).attr("show_from"));
		$("#show_to").val($(link_obj).attr("show_to"));
		$("input[name=useYn]").val([$(link_obj).attr("use_yn")]);
		
		if($(link_obj).attr("ssoUseYn") == "Y"){
			
			$('input:radio[name="ssoUseYn"]:radio[value="Y"]').prop("checked",true);
			$('input:radio[name="ssoType"]:radio[value="'+ $(link_obj).attr("ssoType") + '"]').prop("checked",true);
			
			$('#ssoEmpCtlName').val($(link_obj).attr("ssoUserId"));
			$('#ssoLogincdCtlName').val($(link_obj).attr("ssoLoginCd"));
			$('#ssoCoseqCtlName').val($(link_obj).attr("ssoCompSeq"));
			$('#ssoErpempnoCtlName').val($(link_obj).attr("sspErpSeq"));
			$('#ssoErpcocdCtlName').val($(link_obj).attr("ssoErpCompSeq"));
			$('#ssoEtcCtlName').val($(link_obj).attr("ssoEtcName"));
			$('#ssoEtcCtlValue').val($(link_obj).attr("ssoEtcValue"));
			$("#ssoEncryptType").val($(link_obj).attr("ssoEncryptType"));
			$('#ssoEncryptKey').val($(link_obj).attr("ssoEncryptKey"));
			$("#ssoTimeLink").val($(link_obj).attr("ssoTimeLink"));
			
			$.each($("input[name=encChkSel]"), function(i, v){
				if(($(link_obj).attr('ssoEncryptScope') || '').substring(i,i+1)=="1") $(v).prop("checked", true);
			});	
			
			ssoEncryptTypeChange();
			
		}else{
			
			$('input:radio[name="ssoUseYn"]:radio[value="N"]').prop("checked",true);
			$('input:radio[name="ssoType"]:radio[value="GET"]').prop("checked",true);
			$('#ssoEmpCtlName').val("");
			$('#ssoLogincdCtlName').val("");
			$('#ssoCoseqCtlName').val("");
			$('#ssoErpempnoCtlName').val("");
			$('#ssoErpcocdCtlName').val("");
			$('#ssoEtcCtlName').val("");
			$('#ssoEtcCtlValue').val("");
			$("#ssoEncryptType").val("");
			$('#ssoEncryptKey').val("");
			$("#ssoTimeLink").val("");
			$("input[name='encChkSel']").prop("checked",false);			
			
		}
		
		fnSsoUseYn();
		
	}
	

	function fnSave(){
		
	    //암호화키 Byte체크 (16/24/32만가능)
	    if($(':radio[name="ssoUseYn"]:checked').val() == "Y" && $("input[name='encChkSel']:checked").length > 0){
	    	var ssoEncryptKeyByteLength = unescape(encodeURIComponent($("#ssoEncryptKey").val())).length;
	    	
	    	if($("#ssoEncryptType").val() == "AES128" && ssoEncryptKeyByteLength != 16){
	    		alert("<%=BizboxAMessage.getMessage("TX900000109","AES128(CBC) 암호화키는 16 Byte만 사용 가능합니다.")%>");
	    		setByteLength();
	    		$("#ssoEncryptKey").focus();
	    		return;	    		
	    		
	    	}else if($("#ssoEncryptType").val() == "AES128_ECB" && ssoEncryptKeyByteLength != 16 && ssoEncryptKeyByteLength != 24 && ssoEncryptKeyByteLength != 32){
	    		alert("<%=BizboxAMessage.getMessage("TX900000110","AES128(ECB) 암호화키는 16/24/32 Byte만 사용 가능합니다.")%>");
	    		setByteLength();
	    		$("#ssoEncryptKey").focus();
	    		return;
	    		
	    	}else if($("#ssoEncryptType").val() == "AES256" && ssoEncryptKeyByteLength != 16 && ssoEncryptKeyByteLength != 24 && ssoEncryptKeyByteLength != 32){
	    		alert("<%=BizboxAMessage.getMessage("","AES256(CBC) 암호화키는 16/24/32 Byte만 사용 가능합니다.")%>");
	    		setByteLength();
	    		$("#ssoEncryptKey").focus();
	    		return;
	    		
	    	}
	    }		
		
 		var tblParam = {};
 		
		if(opener != null){
			
			$(link_obj).attr("link_nm", $("#link_nm").val());
			$(link_obj).attr("link_url", $("#link_url").val());
			$(link_obj).attr("show_from", $("#show_from").val());
			$(link_obj).attr("show_to", $("#show_to").val());
			$(link_obj).attr("use_yn", $("input[name=useYn]:checked").val());
			
			// 링크 URL 특수문자 검사
			if($("#link_url").val().indexOf("\\") > -1){
				alert("저장 불가한 문자가 입력되었습니다.");
				$("#link_url").focus();
				$(link_obj).attr("link_url", "");
				return;
			}
			
			if(document.getElementById("ssoUseYn").checked){
				$(link_obj).attr("ssoUseYn", "Y");
				$(link_obj).attr("ssoType", $(':radio[name="ssoType"]:checked').val());
				
				$(link_obj).attr("ssoUserId", $("#ssoEmpCtlName").val());
				$(link_obj).attr("ssoCompSeq", $("#ssoCoseqCtlName").val());
				$(link_obj).attr("ssoPwd", "");
				$(link_obj).attr("sspErpSeq", $("#ssoErpempnoCtlName").val());
				$(link_obj).attr("ssoLoginCd", $("#ssoLogincdCtlName").val());
				$(link_obj).attr("ssoErpCompSeq", $("#ssoErpcocdCtlName").val());
				
				$(link_obj).attr("ssoEtcName", $("#ssoEtcCtlName").val());
				$(link_obj).attr("ssoEtcValue", ($("#ssoEtcCtlName").val() != "" ? $("#ssoEtcCtlValue").val() : ""));
				
				$(link_obj).attr("ssoEncryptType", $("#ssoEncryptType").val());
				$(link_obj).attr("ssoEncryptKey", $("#ssoEncryptKey").val());
				$(link_obj).attr("ssoTimeLink", $("#ssoTimeLink").val());
				var ssoEncryptScope=""; 
				$.each($("input[name=encChkSel]"), function(i, v){
					if(v.checked)
						ssoEncryptScope += "1";
					else 
						ssoEncryptScope+="0";
				});
				$(link_obj).attr("ssoEncryptScope", ssoEncryptScope);
			}
			else
				$(link_obj).attr("ssoUseYn", "N");
			
			if($("input[name=useYn]:checked").val() == "N"){
				//미사용
				$(link_obj).find(".link_sts").html("<%=BizboxAMessage.getMessage("TX000001243","미사용")%>");
				$(link_obj).find("img").removeClass("portlet_img").addClass("portlet_img_not_use");
			}else{
				var from = $("#show_from").val();
				var to = $("#show_to").val() == "" ? "9999-99-99" : $("#show_to").val();
				var today = new Date();
				var now = today.toISOString().substring(0, 10);
				
				if(from <= now && now <= to){
					//정상
					$(link_obj).find(".link_sts").html("");
					$(link_obj).find("img").removeClass("portlet_img_not_use").addClass("portlet_img");
				}else{
					//기간만료
					$(link_obj).find(".link_sts").html("<%=BizboxAMessage.getMessage("TX000010583","기간만료")%>");
					$(link_obj).find("img").removeClass("portlet_img").addClass("portlet_img_not_use");
				}
			}
			
		}else{
			alert("<%=BizboxAMessage.getMessage("TX000010582","포틀릿 설정창을 찾을 수 없습니다")%>");
		}
		
		self.close();		
	}
	

	function fnSsoUseYn(){
		if(document.getElementById("ssoUseYn").checked){
			$("#ssoOpDiv").show();
		}
		else
			$("#ssoOpDiv").hide();
	}
	
	function setByteLength(){
		$("#ssoEncryptKeyLength").html(unescape(encodeURIComponent($("#ssoEncryptKey").val())).length + " Byte");
	}	
	
	function howToPop(objId){
		
		var popTitle = "";
		
		if(objId=="ssoTimeLinkPop"){
			popTitle = "<%=BizboxAMessage.getMessage("TX900000111","기준시간 표시")%>";
		}else{
			popTitle = "<%=BizboxAMessage.getMessage("TX900000112","고정코드 입력방법")%>";
		}
		
		$("#" + objId).kendoWindow({
			draggable: true,
	       	resizable: true,
	       	width: '400px',
	       	height: 'auto',
	       	title: popTitle,
	       	modal: true 
	   	}).data("kendoWindow").center().open();
		
	}

	function ssoEncryptTypeChange(){
		
		if($("#ssoEncryptType").val() == ""){
			$("input[name=encChkSel]").prop("checked",false).prop("disabled",true);
			$("#ssoEncryptKey").prop("disabled",true).val("");
			$("#ssoTimeLink").prop("disabled",true).val("");
		}else{
			$("input[name=encChkSel]").prop("disabled",false);
			$("#ssoEncryptKey").prop("disabled",false);
			$("#ssoTimeLink").prop("disabled",false);
		}
		
	}	
	
	

</script>


<div class="pop_wrap resources_reservation_wrap" style="width:650px;overflow-X:hidden">	

		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016262","배너설정")%></h1>
		</div>
		<!-- //pop_head -->

		<div class="pop_con">
			<p class="tit_p"><%=BizboxAMessage.getMessage("TX000006443","링크설정")%></p>
			
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
					</colgroup>
					
					<tr name="ifHide">
						<th><%=BizboxAMessage.getMessage("TX000006355","링크명")%></th>
						<td><input style="width:90%;" type="text" id="link_nm" /></td>
					</tr>
				
					<tr name="ifHide">
						<th><%=BizboxAMessage.getMessage("TX000016342","노출시작일자")%></th>
						<td><input id="show_from" value="" class="dpWid"/></td>
					</tr>
					<tr name="ifHide">
						<th><%=BizboxAMessage.getMessage("TX000016341","노출종료일자")%></th>
						<td><input id="show_to" value="" class="dpWid"/></td>
					</tr>
					<tr name="ifHide">
						<th><%=BizboxAMessage.getMessage("TX000016305","링크URL")%></th>
						<td><input style="width:90%;" type="text" id="link_url" /></td>
					</tr>
					<tr name="ifHide">
						<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
						<td>
							<input type="radio" id="useYn" name="useYn" value="Y" class="k-radio" checked="checked" />
							<label class="k-radio-label radioSel" for="useYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" id="useYn2" name="useYn" value="N" class="k-radio" />
							<label class="k-radio-label radioSel ml10" for="useYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>								
						</td>
					</tr>

					<tr>
						<th><%=BizboxAMessage.getMessage("TX000016405","SSO연동")%></th>
						<td>
							<input type="radio" id="ssoUseYn" name="ssoUseYn" value="Y" class="k-radio" onclick="fnSsoUseYn()"/>
							<label class="k-radio-label radioSel" for="ssoUseYn"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
							<input type="radio" id="ssoUseYn2" name="ssoUseYn" value="N" class="k-radio" checked="checked" onclick="fnSsoUseYn()"/>
							<label class="k-radio-label radioSel ml10" for="ssoUseYn2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>								
						</td>
					</tr>										
										
				</table>
			</div>
			
			<div style="height:10px" ></div>
			
			<div class="com_ta" id="ssoOpDiv">
			
				<table>
					<colgroup>
						<col width="130"/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
					</colgroup>
					
					<tr name="ssoSection">
						<th colspan="1"><%=BizboxAMessage.getMessage("TX000016175","연동방식")%></th>
						<td colspan="3">
							<input type="radio" name="ssoType" id="ssoTypeGet" class="k-radio" value="GET" checked="checked" >
							<label class="k-radio-label radioSel" for="ssoTypeGet">GET</label>
							<input type="radio" name="ssoType" id="ssoTypePost" class="k-radio" value="POST">
							<label class="k-radio-label radioSel ml10" for="ssoTypePost">POST</label>
						</td>
					</tr>
					
					<tr name="ssoSection">
						<th colspan="1"><%=BizboxAMessage.getMessage("TX900000114","암호화 방식")%></th>
						<td colspan="3">
							<select onchange="ssoEncryptTypeChange();" id="ssoEncryptType" name="ssoEncryptType" style="width:200px">
								<option value=""><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
								<option value="AES128">AES128(CBC)</option>
								<option value="AES128_ECB">AES128(ECB)</option>
								<option value="AES256">AES256(CBC)</option>
							</select>
						</td>
					</tr>
					
					<tr name="ssoSection">
						<th colspan="1"><%=BizboxAMessage.getMessage("TX900000115","암호화 key")%></th>
						<td colspan="3">
							<input type="text" id="ssoEncryptKey" name="ssoEncryptKey" style="width:200px" onkeyup='setByteLength();' /> <span id="ssoEncryptKeyLength"></span>
						</td>
					</tr>	
																	
					<tr name="ssoSection">
						<th colspan="1"><%=BizboxAMessage.getMessage("TX900000116","기준시간")%></th>
						<td colspan="3">
							<select id="ssoTimeLink" name="ssoTimeLink" style="width:200px">
								<option value=""><%=BizboxAMessage.getMessage("TX000001243","미사용")%></option>
								<option value="01">yMdHms(14<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
								<option value="02">y-M-d H:m:s(19<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
								<option value="03">Timestamp(13<%=BizboxAMessage.getMessage("TX000005067","자리")%>)</option>
							</select>
							<img src="/gw/Images/ico/ico_explain.png" onclick="howToPop('ssoTimeLinkPop');" style="cursor:pointer;">															 
						</td>
					</tr>
					
					<tr name="ssoSection">
						<th rowspan="7" colspan="1"><%=BizboxAMessage.getMessage("TX900000117","파라미터 설정")%></th>
						<th style="text-align:center">Key</th>
						<th style="text-align:center">Value</th>
						<th style="text-align:center"><%=BizboxAMessage.getMessage("TX900000118","암호화")%></th>
					</tr>
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoEmpCtlName" style="width:100%;" />
						</td>
						
						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000357","사원코드")%></span>
						</td>															
						
						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" /> 
						</td>														
					</tr>																	
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoLogincdCtlName" style="width:100%;" />
						</td>

						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000016308","로그인계정")%></span>
						</td>															
						
						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" />
						</td>														
					</tr>
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoCoseqCtlName" style="width:100%;" />
						</td>
						
						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000017","회사코드")%></span>
						</td>														

						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" />
						</td>														
					</tr>
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoErpempnoCtlName" style="width:100%;" />
						</td>

						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></span>
						</td>														
						
						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" />
						</td>														
					</tr>		
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoErpcocdCtlName" style="width:100%;" />
						</td>
						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<span style="width:80%;"><%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></span>
						</td>
						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" />
						</td>														
					</tr>
					
					<tr name="ssoSection">
						<td style="text-align:center">
							<input type="text" id="ssoEtcCtlName" style="width:100%;text-align:center;" placeholder="<%=BizboxAMessage.getMessage("TX900000119","고정코드명")%>">
						</td>
						<td style="text-align:center; position:relative;">
							<span style="position:absolute; left:10px; top:13px;">=</span>
							<input type="text" id="ssoEtcCtlValue" style="width:80%;text-align:center;" placeholder="<%=BizboxAMessage.getMessage("TX900000120","고정코드값")%>">
							<img src="/gw/Images/ico/ico_explain.png" onclick="howToPop('ssoEtcCtlValueSetPop');" style="cursor:pointer;">
						</td>
						<td style="text-align:center">
							<input type="checkbox" name="encChkSel" />
						</td>														
					</tr>																																								

				</table>			
				
				
			</div>
		</div>
		
		
		<!-- //pop_con -->
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001288","완료")%>" onclick="fnSave();" /> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="self.close();" />
			</div>
		</div>
		
	</div>

	<div id="ssoEtcCtlValueSetPop" class="pop_wrap_dir" style="display:none;">
	
		<div class="pop_con p0" style="margin:10px;">
			<p class="f12 mt5">&lt;<%=BizboxAMessage.getMessage("TX900000121","치환")%> Value&gt;</p>
			<p class="f12 mt5">$log_id$ = <%=BizboxAMessage.getMessage("TX000016308","로그인계정")%></p>
			<p class="f12 mt5">$emp_cd$ = <%=BizboxAMessage.getMessage("TX000000357","사원코드")%></p>
			<p class="f12 mt5">$comp_cd$ = <%=BizboxAMessage.getMessage("TX000000017","회사코드")%></p>
			<p class="f12 mt5">$erp_comp_cd$ = <%=BizboxAMessage.getMessage("TX000004237","ERP회사코드")%></p>
			<p class="f12 mt5">$erp_id$ = <%=BizboxAMessage.getMessage("TX000000106","ERP사번")%></p>
			<p class="f12 mt5">$yyyyMMddHHmmss$ = <%=BizboxAMessage.getMessage("TX900000122","현재시간")%> ex) 20180915130000</p>
			<p class="f12 mt5">$y-M-d H:m:s$ = <%=BizboxAMessage.getMessage("TX900000122","현재시간")%> ex) 2018-09-15 13:00:00</p>
			<p class="f12 mt5">$time_stamp$ = <%=BizboxAMessage.getMessage("TX900000123","타임스템프")%> ex) 1537016400000</p>
			
			<p class="text_red f12 mt15"><%=BizboxAMessage.getMessage("TX900000124","* 고정코드입력하여사용시, 아래예시와같이전달됩니다.")%></p>
			<p class="f12 mt5">ex) $log_id$ㅣ$comp_cd$ㅣ1001</p> 
			<p class="text_blue f12 mt5">http://www.abc/com/sso.cust.do ? Dkey = adminㅣ3000ㅣ1001</p>
		</div>
		
	</div>
	
	<div id="ssoTimeLinkPop" class="pop_wrap_dir" style="display:none;">
	
		<div class="pop_con p0" style="margin:10px;">
			<p class="text_red f12 mt5"><%=BizboxAMessage.getMessage("TX900000125","* 암호화시, value 값앞에기준시간이포함됩니다.")%></p>
			<p class="text_red f12 mt5">ex) 20180101091133(<%=BizboxAMessage.getMessage("TX900000116","기준시간")%>) , douzone(<%=BizboxAMessage.getMessage("TX000016308","로그인계정")%>)</p>
			<p class="text_blue f12 mt5">http://www.abc/com/sso.cust.do? key= 20180101091133douzone&</p>
		</div>
		
	</div>





                
  