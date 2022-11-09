<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="com.initech.eam.nls.*" %>
<%@ page import="com.initech.eam.smartenforcer.*" %>
<%@ page import="com.initech.eam.nls.command.*" %>
<%@ include file="./config.jsp" %>
<%@page import="main.web.BizboxAMessage"%>
<%

	    CookieManager.setEncStatus(true);
	
		//1.SSO ID 수신
		String sso_id = getSsoId(request);
		System.out.println("seesionId : " + session.getId());
		System.out.println("*================== [login_exec.jsp]  sso_id = "+sso_id);
		if (sso_id == null) {
			if(session.getAttribute("custNoticePortlet") == null)
				goLoginPage(response, true, "portlet");
			else
				goLoginPage(response, true, "notice");
			return;
		} else {
			System.out.println("*================== [Login");
	
			//4.쿠키 유효성 확인 :0(정상)
			String retCode = getEamSessionCheck(request,response);
			//retCode="0";
			System.out.println("*================== [retCode== "+ retCode);
			if(!retCode.equals("0")){
				goErrorPage(response, Integer.parseInt(retCode));
				return;
			}
			//
			//5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
			String EAM_ID = (String)session.getAttribute("SSO_ID");
			if(EAM_ID == null || EAM_ID.equals("")) {
				//session.setAttribute("SSO_ID", sso_id);
				session.setAttribute("SSO_ID", sso_id);
			}
			System.out.println("SSO 인증 성공!!"+ sso_id);
			
	
			//6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
			System.out.println("SSO 세션 : " + session.getAttribute("custSSO"));

			if((session.getAttribute("custNoticePortlet") == null)){		
				response.sendRedirect("/gw/custPortletTargetPop.do");
			}
			else{							
				response.sendRedirect("/gw/custNoticePortlet.do");
			}
			
	// 		if(session.getAttribute("custNoticePortlet") != null)
	// 			response.sendRedirect("/gw/custPortletView.do");
	// 		else
	// 			response.sendRedirect("/gw/custNoticePortletView.do");
			
			//out.println("인증성공");
			
		}


%>




