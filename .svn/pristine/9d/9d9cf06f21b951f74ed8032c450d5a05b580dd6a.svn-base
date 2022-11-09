package restful.fund.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import main.web.BizboxAMessage;
import restful.fund.service.FundService;
import restful.fund.vo.FundVO;
import restful.mobile.vo.RestfulRequest;

@Controller
public class FundController {
	/* 로그 변수 */
	private static final Log LOG = LogFactory.getLog(FundController.class);
	
	/* 서비스 정의 */
	@Resource(name="FundService")
	private FundService fundService;	
	
	@RequestMapping(value="/fund/SmartMenuAuthList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Object SmartMenuAuthList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");
		
		/*변수 선언*/
		FundVO fundVO = new FundVO();
		List<Map<String, Object>> fundResult = new ArrayList<Map<String, Object>>();
		Map<String, Object> reBody =  request.getBody();
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> authList = new HashMap<String, Object>();
		String empSeq = (String)  (request.getHeader()).getEmpSeq();
		String groupSeq = (String) (request.getHeader()).getGroupSeq();
		String tId = (String) (request.getHeader()).gettId(); 			 // 요청식별아이디(요청하는쪽에서생성하여응답)
		String pId = (String) (request.getHeader()).getpId(); 			 // 프로토콜 아이디	

		params.put("empSeq", empSeq);
		params.put("groupSeq", groupSeq);
		
		try {
			fundResult = fundService.getSmartMenuAuthList(params);
			authList.put("authList", fundResult != null ? fundResult : new ArrayList<Map<String, Object>>());
			
			if(fundResult == null) {
				result.put("result", authList);
			} else {
				result.put("result", authList);
			}
			
			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			result.put("tId", tId);
			result.put("result", authList);
		} catch(Exception e) {
			if(fundResult == null) {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", BizboxAMessage.getMessage("TX000016539","권한이 존재하지 않습니다."));
			} else {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", BizboxAMessage.getMessage("TX000009255","처리 시 문제가 발생하였습니다"));
			}
			
			result.put("tId", null);
			result.put("authList", null);
		}
		
		
		
		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");
		
		return result;
	} 
	
}
