<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<div class="M_approval ptl">
	<h2 class="approvalbg"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></h2>
	<a class="title_more2" href="#n" title="<%=BizboxAMessage.getMessage("TX000006348","더보기")%>" onclick="parent.mainforwardPage('/neos/edoc/eapproval/reportstoragebox/formListX.do?tiVisible=Y')"><img src="<c:url value='/Images/ico/icon_Mmore2.png' />" alt="더보기"/></a>
	<%-- <div class="con">
		<dl>			
			<dt class="title"><a href="#" onclick="parent.mainforwardPage('/neos/edoc/eapproval/reportstoragebox/getSharedFolder.do')"><img src="<c:url value='/Images/ico/icon_new.png' />" class="mr5" alt="new"/>[개발1팀 홍길동] 20150410 휴가신청</a></dt>
			<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
			<dd class="date">15.04.08</dd>
		</dl>
		<dl>
			<dt class="title"><a href="#" onclick="parent.mainforwardPage('/neos/edoc/eapproval/approvalbox/standingList.do')">[개발1팀 홍길동] 20150410 휴가신청서를 올려드립니다.</a></dt>
			<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
			<dd class="date">15.04.08</dd>
		</dl>
		<dl>
			<dt class="title"><a href="#" onclick="parent.mainforwardPage('/neos/edoc/delivery/send/board/common/SendBoardCommonList.do')">[개발1팀 홍길동] 20150410 휴가신청</a></dt>
			<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
			<dd class="date">15.04.08</dd>
		</dl>
		<dl>
			<dt class="title"><a href="#" onclick="parent.mainforwardPage('/neos/edoc/document/record/board/common/RecordMyDraftBoardCommonList.do')">[개발1팀 홍길동] 20150410 휴가신청</a></dt>
			<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
			<dd class="date">15.04.08</dd>
		</dl>
	</div>  --%>
	<div class="Center_nocon acvm"><%=BizboxAMessage.getMessage("TX000008504","내용 준비중 입니다")%>.</div>
</div>