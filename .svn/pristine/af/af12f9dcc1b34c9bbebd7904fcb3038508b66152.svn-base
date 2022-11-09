<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
 /**
  * @Class Name : IncludeDatepicker.jsp
  * @Description : ë¬ë ¥ ì»¨í¸ë¡¤ ê´ë ¨ íì¼ë¤ ì°¸ì¡°
  * @Modification Information
  * @
  * @  ìì ì¼                 ìì ì            ìì ë´ì©
  * @ ----------   --------    ---------------------------
  * @ 2012.04.26    ê¹ìí             ìµì´ ìì±
  *
  *  @author ê¹ìíÂÂ
  *  @since 2012.04.16
  *  @version 1.0
  *  @see
  *  IncludeDatepicker
  *
  */
%>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/egovframework/com/cmm/datepicker/themes/base/ui.all.css' />" />
	<link type="text/css" href="<c:url value='/css/egovframework/com/cmm/datepicker/themes/base/ui.datepicker.css' />" rel="stylesheet" />
	<link type="text/css" href="<c:url value='/css/egovframework/com/cmm/datepicker/themes/base/datepicker.css' />" rel="stylesheet" />
	<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/datepicker/ui.core.js'></c:url>"></script>
	<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/datepicker/ui.datepicker.js'></c:url>"></script>
	<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/datepicker/ui.datepicker-ko.js'></c:url>"></script>
	<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/datepicker/neosdatepicker.js'/>"></script>

	<script type="text/javascript">
	$(function(){
		var src=NeosUtil.getCalcImg();
		$("img[src*='"+src+"']").addClass("fix");
	});
	
	var neosdatepicker = {};
	neosdatepicker.datepicker = function(id, pickerOpts){
		var _opt =  pickerOpts || {};
		$("#" + id).datepicker(_opt);
		$("#ui-datepicker-div").hide(); 
	};
	
	</script>
	    
	
