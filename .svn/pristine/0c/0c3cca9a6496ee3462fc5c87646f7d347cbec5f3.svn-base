<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ page import="neos.cmm.util.BizboxAProperties"%>

<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>
<OBJECT ID="NEXESS_API" CLASSID="CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612" width=0 height=0></OBJECT>
 <script>

 
 function ssoLogout() {

 var is_installed = (typeof(NEXESS_API.Login) == "unknown") ? true : false;
  if (is_installed==true) {
 //Nexess Client 유무
  if(NEXESS_API != null) {
 //로그인 상태 확인 '1':로그인
   var islogin = NEXESS_API.IsLoginGP();
 //로그인 중인 상태에서만 로그아웃 실행
   if(islogin == "1" || islogin == "3") {
     NEXESS_API.LogoutWithOption("051");
 // 로그아웃 묻지않고, 등록된 프로그램을 종료한 후 로그인 페이지로 이동함
   }
   }
  }
 }
 </script>

<script language=javascript>
	
$(document).ready(function() {
	redirect();
});

 function redirect()
 {
  document.execCommand('ClearAuthenticationCache');
  ssoLogout();
  window.location.href='<%=BizboxAProperties.getCustomProperty("BizboxA.Cust.outSSOUrl")%>';
 }
 </script>
