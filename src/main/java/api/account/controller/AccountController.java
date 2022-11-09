package api.account.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.account.service.AccountService;
import api.account.service.CallbackService;
import api.common.model.APIResponse;
import main.web.BizboxAMessage;

/**
 * AccountController.java 클래스
 *
 * @author 김재호
 * @since 2015. 11. 20.
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    -------------    ----------------------
 *  
 * </pre>
 */


@Controller
public class AccountController {

    private static final Logger logger = LoggerFactory.getLogger(AccountController.class);
    
	@Resource(name="AccountService")
	private AccountService accountService;
	
	@Resource(name="CallbackService")
	private CallbackService callbackService;
	
	@RequestMapping(value="/account/AccountCallback", method=RequestMethod.POST)
	@ResponseBody
	public String AccountCallback(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@RequestBody Map<String, Object> request){
		
		logger.info("==================== AccountCallback Start ====================");
		ObjectMapper mapper = new ObjectMapper();
		try{
			logger.info(mapper.writeValueAsString(request));
			callbackService.callback(request);
		}catch(Exception e){
			logger.error("AccountCallback Error", e);
			return "E|" + e.getMessage();
		}
		logger.info("==================== AccountCallback End ======================");
		
		return "S|"+BizboxAMessage.getMessage("TX000011981", "성공");
	}
	
	@RequestMapping(value="/account/web/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse web(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){
		
		return accountService.action(servletRequest, request, serviceName);
	}
	
	@RequestMapping(value="/account/mobile/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse mobile(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			@PathVariable String serviceName, @RequestBody Map<String, Object> request){
		return accountService.action4m(servletRequest, request, serviceName);
	}

	/**
	 * 20160322 장지훈 추가
	 * bankAccountConfig 계좌정보입력 페이지 가져오기
	 * @param servletRequest
	 * @param params
	 * @return
	 */
	@RequestMapping(value="/account/web/bankAccountConfig")
	public ModelAndView bankAccounConfig(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params){
		ModelAndView mv = new ModelAndView();
	
		mv.setViewName("/neos/cmm/systemx/bankAccount/bankAccountConfig");
		
		return mv;
	}	
	
	/**
	 * 20160324 장지훈 추가
	 * bankAccounDetailSearch 계좌정보조회 페이지 가져오기
	 * @param servletRequest
	 * @param params
	 * @return
	 */
	@RequestMapping(value="/account/web/bankAccountDetailSearch")
	public ModelAndView bankAccounDetailSearch(HttpServletRequest servletRequest, @RequestParam Map<String, Object> params){
		ModelAndView mv = new ModelAndView();
	
		mv.setViewName("/neos/cmm/systemx/bankAccount/bankAccountDetailSearch");
		
		return mv;
	}	
}
