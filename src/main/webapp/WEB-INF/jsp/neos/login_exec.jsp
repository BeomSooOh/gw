<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="com.initech.eam.nls.*" %>
<%@ page import="com.initech.eam.smartenforcer.*" %>
<%@ page import="com.initech.eam.nls.command.*" %>
<%@ include file="./config.jsp" %>
<%

    CookieManager.setEncStatus(true);

	String uurl = null;

	//1.SSO ID ����
	String sso_id = getSsoId(request);
	System.out.println("*================== [login_exec.jsp]  sso_id = "+sso_id);
	if (sso_id == null) {
		goLoginPage(response, false);
		return;
	} else {
		System.out.println("*================== [Login");

		//4.��Ű ��ȿ�� Ȯ�� :0(����)
		String retCode = getEamSessionCheck(request,response);
		//retCode="0";
		System.out.println("*================== [retCode== "+ retCode);
		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		//
		//5.�����ý��ۿ� ���� ����� ���̵� �������� ����
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			//session.setAttribute("SSO_ID", sso_id);
			session.setAttribute("SSO_ID", sso_id);
		}
		System.out.println("SSO ���� ����!!"+ sso_id);

		//6.�����ý��� ������ ȣ��(���� ������ �Ǵ� ���������� ����)  --> �����ý��ۿ� �°� URL ����!
		System.out.println("SSO ���� : " + session.getAttribute("custSSO"));

		if(session.getAttribute("custSSO") != null) {
			response.sendRedirect("/gw/MsgLogOn.do");
		} else {
			response.sendRedirect("/gw/CustLogOn.do");
		}
		
		//out.println("��������");
	}
%>
