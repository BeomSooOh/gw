package neos.cmm.util;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import api.common.model.APIResponse;
import restful.mobile.service.ResultList;
import restful.mobile.vo.ResultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * message util
 * @author iguns
 *
 */
public class MessageUtil {
	
	/**
	 * 저장 또는 수정 서블릿 실행후
	 * 새로고침이 진행되면 다시 같은 서블릿을 재호출 이슈로
	 * FlashAttribute 로 메세지를 전달하는 기능
	 * @param request
	 * @param ra
	 * @param msgProp
	 */
	public static void setRedirectMessage(HttpServletRequest request, RedirectAttributes ra, String msgProp) {
		String msg = getMessage(request, msgProp);

		if (!EgovStringUtil.isEmpty(msg)) {
			ra.addFlashAttribute("msg", msg);
		}
	}

	public static void getRedirectMessage(ModelAndView mv, HttpServletRequest request) {
		String msg = request.getParameter("msg");
		if (!EgovStringUtil.isEmpty(msg)) {
			mv.addObject("msg", msg);
		}
	}
	
	public static void getRedirectMessage(ModelAndView mv, HttpServletRequest request, String messageKey) {
		String msg = getMessage(request, messageKey);
		if (!EgovStringUtil.isEmpty(msg)) {
			mv.addObject("msg", msg);
		}
	}
	
	/**
	 * 에러코드로 메세지 조회하여 Model에 추가
	 * @param mv
	 * @param request
	 * @param key
	 * @param msgProp
	 */
	public static void setMessage(ModelAndView mv, HttpServletRequest request, String key, String msgProp) {
		String msg = getMessage(request, msgProp);

		if (!EgovStringUtil.isEmpty(msg)) {
			mv.addObject(key, msg);
		}
	}
	
	
	public static void setApiMessage(ModelAndView mv, HttpServletRequest multiRequest, Map<String,Object> params) {
		
		String mKey = params.get("mKey")+"";
		String codeHead = params.get("codeHead")+"";
		String cKey = params.get("cKey")+"";
		String code = params.get("code")+"";
		
		setMessage(mv, multiRequest, mKey, codeHead+code);
		mv.addObject(cKey, code);
	}
	
	/**
	 * 프로퍼티에서 메세지 조회
	 * @param request
	 * @param msgProp
	 * @return
	 */
	public static String getMessage(HttpServletRequest request, String msgProp) {
		if (!EgovStringUtil.isEmpty(msgProp)) {
			ServletContext sc = request.getSession().getServletContext();
			ApplicationContext act = WebApplicationContextUtils.getRequiredWebApplicationContext(sc);
			EgovMessageSource egovMessageSource = (EgovMessageSource)act.getBean("egovMessageSource");
			String msg = egovMessageSource.getMessage(msgProp);
			return msg;
		}
		return null;
	}

	public static void setApiMessage(ResultVO resultList,
			HttpServletRequest request,
			String codeHead, String resultCode) {
	
		resultList.setResultCode(resultCode);
		resultList.setResultMessage(getMessage(request, codeHead+resultCode));
	}
	
	public static void setApiMessage(APIResponse response,
			HttpServletRequest request,
			String codeHead, String resultCode) {
	
		response.setResultCode(resultCode);
		response.setResultMessage(getMessage(request, codeHead+resultCode));
	}
	

	public static void setApiMessage(ResultList resultList,
			HttpServletRequest servletRequest, Map<String, Object> messageMap) {
		
		setApiMessage(resultList, servletRequest, messageMap.get("codeHead")+"", messageMap.get("resultCode")+"");
		
	}
}
