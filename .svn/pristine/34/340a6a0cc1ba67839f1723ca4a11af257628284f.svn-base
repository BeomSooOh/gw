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


<script type="text/javascript">
	$(document).ready(function() {
		var result = "${result}";
		
		$("#result").text(result);
		
		$("#btnOk").click(function() {
			window.close();
		});
	});
</script>

<div class="pop_wrap color_pop_wrap" style="width:518px;">
	<div class="pop_head">
		<h1>Bizbox Alpha</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class="Alertbg" style="background-position:0 35%;">
						<dl class="result_con">
							
							<dt><%=BizboxAMessage.getMessage("TX900000292","필수값이입력되지않았습니다.")%><br/>
								   <%=BizboxAMessage.getMessage("TX000012873","필수값을 입력해 주세요")%></dt>
							<dd class="fwb">[ <span class="text_blue" id="result"></span> ]</dd>
						</dl>
					</span>		
				</td>
			</tr>
		</table>
	</div>
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" id="btnOk" />
		</div>
	</div>
</div>

