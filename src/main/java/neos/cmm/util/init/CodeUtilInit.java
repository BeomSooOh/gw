package neos.cmm.util.init;

import javax.servlet.ServletContext;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import cloud.CloudConnetInfo;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.util.code.service.impl.CommonCodeDAO;
//import neos.mail.messenger.service.MailMessengerService;
//import neos.mobile.push.service.impl.PushManageDAO;

public class CodeUtilInit{


	public static void init(ServletContext sc){
		try {
			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
			CommonCodeDAO commonCodeDAO = (CommonCodeDAO)act.getBean("CommonCodeDAO");
			
			
			if(CloudConnetInfo.getBuildType().equals("build")){
				CommonCodeUtil.init(commonCodeDAO, null) ;
				CommonCodeUtil.initChild(commonCodeDAO, null);
				CommonCodeUtil.initCmmOption(commonCodeDAO, null);
			}

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

}
