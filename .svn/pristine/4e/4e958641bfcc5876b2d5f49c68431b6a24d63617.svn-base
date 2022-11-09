package restful.item.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import main.web.BizboxAMessage;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import restful.fund.controller.FundController;
import restful.item.service.ItemService;
import restful.item.vo.ItemVO;
import restful.mobile.vo.RestfulRequest;

@Controller
public class ItemController {
	/* 로그 변수 */
	private static final Log LOG = LogFactory.getLog(FundController.class);
	
	/* 서비스 정의 */
	@Resource(name="ItemService")
	private ItemService itemService;
	
	@RequestMapping(value="/item/ItemList", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Object ItemList(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		LOG.debug("+ [ITEM] INFO - @Controller >> /item/ItemList");
		
		/*변수 선언*/
		ItemVO itemVO = new ItemVO();
		List<Map<String, Object>> itemResult = new ArrayList<Map<String, Object>>();
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> reBody =  request.getBody();
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> itemList = new HashMap<String, Object>();
		
		String itemType = reBody.get("itemType").toString();
		String langCode = reBody.get("langCode").toString();
		String tId = (String) (request.getHeader()).gettId(); 			 // 요청식별아이디(요청하는쪽에서생성하여응답)
		String pId = (String) (request.getHeader()).getpId(); 			 // 프로토콜 아이디	

		params.put("itemType", itemType);
		params.put("langCode", langCode);
		try {
			itemResult = itemService.getItemList(params);
			
			itemList.put("authList", itemResult != null ? itemResult : new ArrayList<Map<String, Object>>());
			
			if(itemResult == null) {
				result.put("result", itemList);
			} else {
				result.put("result", itemList);
			}
			
			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			result.put("tId", tId);
			result.put("result", itemList);
		} catch(Exception e) {
			
			if(itemResult == null) {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다."));
			} else {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", BizboxAMessage.getMessage("TX000009255","처리 시 문제가 발생하였습니다"));
			}
			
			result.put("tId", null);
			result.put("authList", null);
		}
		
		LOG.debug("- [ITEM] INFO - @Controller >> /item/ItemList");
		
		return result;
	} 
}
