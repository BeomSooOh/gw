<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<link rel="stylesheet" type="text/css" href="/gw/css/main<c:if test="${portalDiv == 'cloud'}">_freeb</c:if>.css?ver=20201021">
<script type="text/javascript" src="/gw/js/Scripts/common<c:if test="${portalDiv == 'cloud'}">_freeb</c:if>.js?ver=20201021"></script>

<script type="text/javascript">
	$(document).ready(function() {
		${UserMainFunction}
	});
</script>