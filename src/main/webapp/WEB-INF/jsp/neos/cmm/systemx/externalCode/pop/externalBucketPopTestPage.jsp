
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>
<%@page import="main.web.BizboxAMessage"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
TEST PAGE, OPEN ORG CHART
<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	function CallOrgBizPop() {

		var url = "<c:url value='/cmm/systemx/item/externalCodePop.do'/>";

		var pop = window.open("", "externalCodePop", "width=1200,height=800,scrollbars=no");

		frmPop2.target = "externalCodePop";
		frmPop2.method = "post";
		frmPop2.action = url; 
		frmPop2.submit(); 
		frmPop2.target = ""; 
	    pop.focus();   
    }
	
	function fnCallBack(param){
		alert(JSON.stringify(param));
	}
	
	
	function CallCustomPop() {
		var url = "/CustomNPKicpaInterlock/userPop?width=832&height=493&callback=fnCallBack";

		var pop = window.open(url, "userPop", "width=832,height=493,scrollbars=no");
	}
	
</script>


<br><br>
<input type="button" value="외부코드 호출" onclick="javascript:CallOrgBizPop()" />

<form id="frmPop2" name="frmPop2" method="post">  
<br><br>
-- 외부코드<br>

customCd	:<input type="text" name="customCd" width="500" value=""/> &nbsp;(ex : '1000') <br>
fnCallback  :<input type="text" name="fnCallback" width="500" value=""/> &nbsp;(ex : 'fnCallBack') <br>

</form>

<br><br>
<input type="button" value="외부코드 호출(커스텀)" onclick="javascript:CallCustomPop()" />

<br><br><br><br>
