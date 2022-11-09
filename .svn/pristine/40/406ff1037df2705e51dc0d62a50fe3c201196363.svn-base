<%@page import="neos.cmm.util.BizboxAProperties"%>
<%@page import="neos.cmm.util.CommonUtil"%>

<%
    String AUTH_URL = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_AUTH_URL");
    String AUTHORIZATION_URL = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_AUTHORIZATION_URL");
    String requestData = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_requestData");
    
    String agentId = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_agentId");
    String innerIp = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_innerIp");
    
    if(!innerIp.equals("99")){
    	
    	String connectIp = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_innerIpType").equals("host") ? request.getServerName() : CommonUtil.getClientIp(request);
    	
    	String[] innerIps = innerIp.split("\\|");
    	
		for( int j = 0; j < innerIps.length; j++){
					
	    	if(connectIp.indexOf(innerIps[j]) == 0){
	    		agentId = BizboxAProperties.getCustomProperty("BizboxA.Cust.PENTA_innerAgentId");
	    		break;
	    	}
		}
    			
    	System.out.println("sso.agentInfo.jsp connectIp : " + connectIp);
    	System.out.println("sso.agentInfo.jsp agentId : " + agentId);
    }
%>