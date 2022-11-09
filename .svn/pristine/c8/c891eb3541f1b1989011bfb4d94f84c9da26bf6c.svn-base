<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script type="text/javascript">

	var url = "${manualDomain}";

	if(document.location.protocol.indexOf("https") > -1){
		url = url.replace("http:","https:");
	}
	
	if("${params.type}" == "reference"){
		url += "/admin/?reference=" + "${params.name}";		
	}else if("${params.type}" == "lnb"){
		url += "/user/ko/" + "${params.name}";
	}else if("${params.type}" == "lnb_adm"){
		url += "/admin/ko/" + "${params.name}";
	}else if("${params.type}" == "main"){
		url += "/user/userhome.do?lang=ko";
	}else if("${params.type}" == "main_adm"){
		url += "/admin/userhome.do?lang=ko";
	}

	document.location.href = url;

</script>	
