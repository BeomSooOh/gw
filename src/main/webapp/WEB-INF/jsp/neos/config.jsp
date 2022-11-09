<%@page import="neos.cmm.util.BizboxAProperties"%>
<%@page import="neos.cmm.util.CommonUtil"%>
<%@page import="sun.misc.*,
				java.io.*,
				java.util.*,
				com.initech.eam.nls.*,
				com.initech.eam.api.*,
				com.initech.eam.base.*,
				com.initech.eam.nls.command.*,
				com.initech.eam.smartenforcer.*
				"%>

<%! 
	private String SERVICE_NAME = "Web";
	private String SERVER_URL = BizboxAProperties.getCustomProperty("BizboxA.Cust.outSSOServerUrl");
	private String ASCP_URL = SERVER_URL + "/gw/bizbox.do";
	private String ASCP_PORTLET_URL = SERVER_URL + "/gw/custPortletTargetPop.do";
	private String ASCP_NOTICE_URL = SERVER_URL + "/gw/custNoticePortlet.do";
	private String NLS_URL = "http://sso.sk.com";
	private String NLS_PORT = BizboxAProperties.getCustomProperty("BizboxA.Cust.ssoNLS_PORT");
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + BizboxAProperties.getCustomProperty("BizboxA.Cust.ssoNLS_LOGIN_URL");
	private String NLS_LOGOUT_URL = NLS_URL + ":" + NLS_PORT + "/nls3/cookieLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	private static String ND_URL1 = "http://sso.sk.com:5480";
	private static String ND_URL2 = "http://sso.sk.com:5480";
	private String TOA = "3";
	private String SSO_DOMAIN = BizboxAProperties.getCustomProperty("BizboxA.Cust.ssoDomain");

	// connection timeout
	private static final int timeout = 1500000;
	
	private static NXContext context = null;
	static{
		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1); 
		serverurlList.add(ND_URL2);
	}

	public void goLoginPage(HttpServletResponse response, boolean isPortlet)
	throws Exception {
		if(!isPortlet){
			CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
			CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
			response.sendRedirect(NLS_LOGIN_URL + "?UURL=" + ASCP_URL);
		}
		else{
			CookieManager.addCookie(SECode.USER_URL, ASCP_PORTLET_URL, SSO_DOMAIN, response);
			CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
			response.sendRedirect(NLS_LOGIN_URL + "?UURL=" + ASCP_PORTLET_URL);
		}
	}
	
	public void goLoginPage(HttpServletResponse response, boolean isPortlet, String type)
	throws Exception {
		if(type.equals("portlet")){
			CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
			CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
			response.sendRedirect(NLS_LOGIN_URL + "?UURL=" + ASCP_PORTLET_URL);
		}
		else{
			CookieManager.addCookie(SECode.USER_URL, ASCP_PORTLET_URL, SSO_DOMAIN, response);
			CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
			response.sendRedirect(NLS_LOGIN_URL + "?UURL=" + ASCP_NOTICE_URL);
		}
	}
	
	

	public void goErrorPage(HttpServletResponse response, int error_code)
	throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		
		System.out.println("*================== [Config.jsp" + sso_id);
		return sso_id;
	}

	public boolean getStatus() {

		boolean bResult = false;

		Environment env = new Environment();
		bResult = Environment.getStatus(NLS_URL + ":" + NLS_PORT + "/rpc2");

		return bResult;
	}

	public int checkSsoId(HttpServletRequest request,
	HttpServletResponse response) throws Exception {
		int return_code = 0;

		return_code = CookieManager.readNexessCookie(request, response,
			SSO_DOMAIN);
		return return_code;
	}

	public String getSystemAccount(String sso_id) {
		NXUserAPI userAPI = new NXUserAPI(context);
		String retValue = null;
		try {
			NXAccount account = userAPI.getUserAccount(sso_id, SERVICE_NAME);
			System.out.println(account.toString());
			retValue = account.getAccountName();
			System.out.println("retValue = " + retValue);
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return retValue;
	}

	public String getSsoDomain(HttpServletRequest request) throws Exception {
		String sso_domain = null;

		sso_domain = NLSHelper.getCookieDomain(request);
		return sso_domain;
	}
	
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response)
	{
		int i = 1000;
		try{
			if(SSO_DOMAIN.equals("99")){
				i = CookieManager.readNexessCookie(request, response, NLSHelper.getCookieDomain(request), 10, 72000);
			}else{
				i = CookieManager.readNexessCookie(request, response, SSO_DOMAIN, 10, 72000);
			}
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return String.valueOf(i);
	}

	public Properties getUserInfo(String userid)
	throws Exception {
		NXUserAPI userAPI = new NXUserAPI(context);
		Properties prop = null;

		if (userid==null || userid.length() <= 0)
			return prop;

		try {
			NXUserInfo userInfo = userAPI.getUserInfo(userid);
			prop = new Properties();

			prop.setProperty("USERID", userInfo.getUserId());
			prop.setProperty("EMAIL", userInfo.getEmail());
			prop.setProperty("ENABLE", String.valueOf(userInfo.getEnable()));
			prop.setProperty("STARTVALID", userInfo.getStartValid());
			prop.setProperty("ENDVALID", userInfo.getEndValid());
			prop.setProperty("NAME", userInfo.getName());
			prop.setProperty("LASTPASSWDCHANGE", userInfo.getLastpasswdchange());
			prop.setProperty("LastLoginIP", userInfo.getLastLoginIp());
			prop.setProperty("LastLoginTime", userInfo.getLastLoginTime());
			prop.setProperty("LastLoginAuthLevel",	userInfo.getLastLoginAuthLevel());

		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return prop;
	}

	public boolean existUser(String userid)
	throws Exception {
		NXUserAPI userAPI = new NXUserAPI(context);
		boolean returnFlag = false;

		try {
			returnFlag= userAPI.existUser(userid);
		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (Exception e) {
			throw e;
		}
		return returnFlag;
	}

	public boolean addAccountToUser(String userid, String serviceName,
	String accountName, String accountPasswd)
	throws Exception {
		NXUserAPI userAPI = new NXUserAPI(context);
		NXExternalFieldSet nxefs = null;
		boolean returnFlag = false;

		try {
			userAPI.addAccountToUser(userid, serviceName,
				accountName, accountPasswd);
			returnFlag = true;
		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalArgumentException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return returnFlag;
	}

	public boolean removeAccountFromUser(String userid, String serviceName)
	throws Exception {
		NXUserAPI userAPI = new NXUserAPI(context);
		boolean returnFlag = false;

		try {
			userAPI.removeAccountFromUser(userid, serviceName);
			returnFlag = true;
		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalArgumentException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return returnFlag;
	}

	public String getUserExField(String userid, String exName)
	throws Exception {
		NXUserAPI userAPI = new NXUserAPI(context);
		NXExternalField nxef = null;
		String returnValue = null;

		if (userid==null || userid.length() <= 0)
			return returnValue;

		try {
			nxef = userAPI.getUserExternalField(userid, exName);
			returnValue = (String) nxef.getValue();

		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalArgumentException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return returnValue;
	}

	@SuppressWarnings({ "rawtypes" })
	public String getUserAttribute(String userid, String attrName)
	throws Exception {
		NXUserAPI userAPI = new  NXUserAPI(context);
		String attrValue = null;
		List valueList = null;
		NXAttributeValue nxav = null;

		if (userid==null || userid.length() <= 0)
			return attrValue;

		try {
			valueList = userAPI.getUserAttributes(userid, attrName);
			for (int i = 0, j = valueList.size(); i < j; i++) {
				nxav = (NXAttributeValue) valueList.get(i);
				attrValue = nxav.toString();
			}
		} catch (EmptyResultException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalArgumentException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return attrValue;
	}


	 @SuppressWarnings({ "unchecked" }) 
	public List<Vector<String>> getUserResourceList(String userId, String applicationBaseID, String searchPath, int searchLevel) throws Exception {
		
		List<Vector<String>> resourceList = null;

		NXProfile nxProfile = new NXProfile(context);
		NXApplication nxApplication = null;		
		try {
			nxApplication = nxProfile.getNXApplication(userId, applicationBaseID, searchPath, searchLevel);
		} catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		

		if(nxApplication != null && nxApplication.size() > 0){
			
			resourceList = new ArrayList<Vector<String>>();
			
			Iterator<NXResourceSet> nxApplicationIter = nxApplication.iterator();
			while (nxApplicationIter.hasNext()) {
				
				NXResourceSet nxResourceSet = nxApplicationIter.next();
				
				Iterator<NXResource> nxResourceSetIter = nxResourceSet.iterator();				
				while(nxResourceSetIter.hasNext() ) {
					
					NXResource nxResource = nxResourceSetIter.next();
					
					String codePath = nxResource.getCodePath().getSelfPath();
					if(searchLevel != 0 && codePath.equals(searchPath))
						continue;
					
					Vector<String> v = new Vector<String>();
					v.add(Integer.toString(nxResource.getCodePath().getDepth()));
					v.add(codePath);
					v.add(nxResource.getDescriptionPath().getSelfValue());
					
					String actionValues = "";
					Iterator<String> iter = nxResource.getAllowedActionValues().iterator();
					while(iter.hasNext()){
						actionValues += iter.next();
					}
					v.add(actionValues);
					
					resourceList.add(v);
				}
			}
		}
		
		ResourceComparator resourceComparator = new ResourceComparator(ResourceComparator.CODE);
		Collections.sort(resourceList, resourceComparator);
		
		return resourceList;
	}	
	
	 @SuppressWarnings({ "rawtypes"})
	public class ResourceComparator implements Comparator {

		public final static int CODE = 1;
		public final static int DESCRIPTION = 2;	
		
		private int sortRule;
		
		public ResourceComparator(int sortRule) {
			this.sortRule = sortRule;
		}
		
		public int compare(Object o1, Object o2) {
			
			Vector v1 = (Vector) o1;
			Vector v2 = (Vector) o2;

			String v1rs = (String)v1.get(sortRule);
			String v2rs = (String)v2.get(sortRule);
			int i = v1rs.compareTo(v2rs);

			return i;
		}
	} 
	
	
	 @SuppressWarnings({ "rawtypes", "unchecked" })
	public List getRoleList(String sso_id) {
		
		List userRoleList = null;
		NXRole roleAPI = new NXRole(context);
		try {			
			List tempRoleList = roleAPI.getRoles(sso_id);
			if(tempRoleList != null && tempRoleList.size() > 0){ 
				
				userRoleList = new ArrayList();
				for(int i=0; i<tempRoleList.size(); i++){					
					NXRoleInfo roleInfo = (NXRoleInfo)tempRoleList.get(i);
					userRoleList.add(roleInfo.getRoleName());
				}				
			}
						
		} catch (APIException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return userRoleList;
	}

%>
