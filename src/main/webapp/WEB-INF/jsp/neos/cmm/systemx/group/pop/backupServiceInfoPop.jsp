<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>
<style type="text/css">  
	html {overflow:hidden;}  
</style>  

<script>

	var backupSeq = opener.backupServiceInfo.backupSeq;
	var backupFromDt = opener.backupServiceInfo.backupFromDt;
	var backupToDt = opener.backupServiceInfo.backupToDt;
	var downFromDt = opener.backupServiceInfo.downFromDt;
	var downToDt = opener.backupServiceInfo.downToDt;

	$(document).ready(function() {
		var backupDt = fnGetDateText(backupFromDt) + " ~ " + fnGetDateText(backupToDt);
		$("#backupDt").html(backupDt);
		
		var downDt = fnGetDateText(downFromDt) + " ~ " + fnGetDateText(downToDt);
		$("#downDt").html(downDt);
		
	});
	
	function fnUnexposed(){
		
		if(opener != null){
			opener.localStorage.setItem('backupServiceInfo', (opener.localStorage.getItem('backupServiceInfo') == null ? "" : opener.localStorage.getItem('backupServiceInfo')) + '|' + backupSeq + '|');	
		}

		window.close();
	}
	
	function fnDownload(){

		this.location.href = "/gw/api/backupServiceDownload?downTp=POP&backupSeq="+backupSeq;
		
	}
	
	function fnGetDateText(date){
		
		if(date != null && date != "" && date.length == 8){
			return date.substr(0,4) + "-" + date.substr(4,2) + "-" + date.substr(6,2);
		}else{
			return "";
		}
		
	}
	
</script>

<div class="pop_wrap" style="border-color: white;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("","백업파일 다운로드 공지")%></h1>
	</div>	
	
	<div class="pop_con">
		<div class="com_ta6" style="height:440px; overflow:auto;">
			<table>
				<colgroup>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("","백업기간")%></th>
					<td class="le" id="backupDt"></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("","다운로드 가능기간")%></th>
					<td class="le" id="downDt"></td>
				</tr>
				<tr>
					<th><%=BizboxAMessage.getMessage("","다운로드")%>${pop_yn}</th>
					<td class="le"><u><a style="color: blue;" href="javascript:fnDownload();"><%=BizboxAMessage.getMessage("","백업파일 다운로드")%></a></u></td>
				</tr>
				<tr>
					<td class="le p15" colspan="2" valign="top" style="height:250px;">
						안녕하세요. 더존 그룹웨어팀입니다.<br>
						다운로드 영역 내 백업파일 다운로드 버튼 클릭 시, 백업파일을 다운로드 할 수 있습니다.<br><br>
						※ 해당 팝업은 다운로드 가능기간에만 뜨며, 이후에는 제공하지 않습니다.
					</td>
				</tr>
			</table>
		</div>
	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" onclick="fnUnexposed();" value="<%=BizboxAMessage.getMessage("","오늘 하루 띄우지 않기")%>" />
			<input type="button" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000019668","닫기")%>" />
		</div>		
	</div>

</div><!--// pop_wrap -->