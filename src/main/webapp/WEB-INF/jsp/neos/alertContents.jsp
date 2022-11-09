<%@page import="neos.cmm.util.code.CommonCodeSpecific"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="/tags/np_taglib" prefix="nptag" %>

<html>
  <head>
  	<script>
  		alert("${alertMsg}");	
  	</script>
  </head>
  <body>
  ${html}
  </body>
</html>