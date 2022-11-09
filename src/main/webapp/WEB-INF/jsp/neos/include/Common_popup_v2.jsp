<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%
/**
 * @Class Name : Common_popup_v2.jsp
 * @title 
 * @author 공공사업부 포털개발팀  김석환
 * @since 2012. 9. 11.
 * @version 
 * @dscription 모든 페이지에 참조되어야 할 리소스들(js, css  기타 등등) -->popup 전용
 * Common.jsp 에서 css 정리된 파일로 변경함
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 9. 11.  김석환        최초 생성
 *
 */
%>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/css.css'/>" />
<script type="text/javascript" src="<c:url value='/js/neos/NeosUtil.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/jquery-1.7.2.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/jquery.alphanumeric.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/neos/common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/neos/NeosCodeUtil.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.form.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.MetaData.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.MultiFile.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/multifile/jquery.blockUI.js' />"></script>

<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.ui/jquery-ui-1.8.18.custom.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.ui/ui.js' />"></script>

<!--[if IE 6]>
    <script src="<spring:message code='neos.comonPath' />/js/neos/DD_belatedPNG_0.0.8a-min.js"></script>
    <script>
    DD_belatedPNG.fix('.fix');
    DD_belatedPNG.fix('.fix2');
    </script>
<![endif]--> 