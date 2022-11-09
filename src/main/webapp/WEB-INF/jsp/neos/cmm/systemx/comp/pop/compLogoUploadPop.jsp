<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
	$(document).ready(function() {
		var result = '${resultCode}';
		
		if (result == 'SUCCESS') {
			alert('${resultMessage}');
			
			var callback = '${callback}';
		
			if (callback) {
				eval('window.opener.' + callback)('${fileList}', '${imgType}');
			}
			
			window.close();
			
		}
		else if(result != ""){
			alert('${resultMessage}');
			self.close();
		}
		
		//기본버튼
		$(".controll_btn button").kendoButton();
			
			for ( i = 1; i<= $(".file_chum_box").size(); i++ )
			{
			//이미지등록	
				$("#inp_files"+i).kendoUpload({
					multiple: false,
					localization: {
						select: "<%=BizboxAMessage.getMessage("TX000003995","찾아보기")%>"
					}
				});
			}			
		$("#okBtn").on("click", ok);
	});	
		
	function ok() {
		document.form.submit();
	}	
</script>

<form id="form" name="form" method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/cmm/file/fileUploadProc.do">	
	<input type="hidden" id="orgSeq" name="orgSeq" value="${orgSeq}" >
	<input type="hidden" id="imgType" name="imgType" value="${imgType}" >
	<input type="hidden" id="callback" name="callback" value="${callback}" >
	<input type="hidden" id="pathSeq" name="pathSeq" value="900" > 
	<input type="hidden" id="dataType" name="dataType" value="page" >
	<input type="hidden" id="isNewId" name="isNewId" value="true" >
	<input type="hidden" id="page" name="page" value="/cmm/systemx/compLogoUploadPop.do" >  
<div class="pop_wrap" style="width:558px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000005881","이미지등록")%></h1>
		<a href="#n" class="clo"><img src="../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>

	<div class="pop_con">	
		<div class="com_ta2 hover_no">
			<table>
				<colgroup>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000016212","사이즈")%></th>
					<th><%=BizboxAMessage.getMessage("TX000005188","파일첨부")%></th>
				</tr>
				<tr>
					<td>372 X 122(1)</td>
					<td>
						<div class="file_chum_box">
							<!-- P1202xxdpi_p -->
							<!-- dispMod + AppType + osType + dispType -->
							<input name="P1202xxdpi_p" id="inp_files1" type="file"/>
						</div>			
					</td>
				</tr>
				<tr>
					<td>372 X 122(2)</td>
					<td>
						<div class="file_chum_box">
							<input name="P1202xdpi_p" id="inp_files2" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td>279 X 92</td>
					<td>
						<div class="file_chum_box">
							<input name="P1202hdpi_p" id="inp_files3" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td>256 X 84</td>
					<td>
						<div class="file_chum_box">
							<input name="P1202mdpi_p" id="inp_files4" type="file"/>
						</div>					
					</td>
				</tr>
				<tr>
					<td>248 X 81(1)</td>
					<td>
						<div class="file_chum_box">
							<input name="P1102xxdpi" id="inp_files5" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td>248 X 81(2)</td>
					<td>
						<div class="file_chum_box">
							<input name="P1102xdpi" id="inp_files6" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td>186 X 61</td>
					<td>
						<div class="file_chum_box">
							<input name="P1102hdpi" id="inp_files7" type="file"/>
						</div>					
					</td>
				</tr>
				<tr>
					<td>240 X 60</td>
					<td>
						<div class="file_chum_box">
							<input name="L1201ldpi" id="inp_files8" type="file"/>
						</div>						
					</td>
				</tr>
				<tr>
					<td>149 X 39</td>
					<td>
						<div class="file_chum_box">
							<input name="P1101ldpi" id="inp_files9" type="file"/>
						</div>						
					</td>
				</tr>
			</table>
		
		</div>
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" id="okBtn" />
			<input type="button" class="gray_btn" onclick="javascript:window.close();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->
</form>