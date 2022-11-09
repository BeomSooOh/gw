package api.hdcs.controller;

import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestBody;

import api.common.model.APIResponse;

import api.hdcs.service.HdcsService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import net.sf.json.JSONObject;


@Controller
public class HdcsController {

	@Resource(name="HdcsService")
	private HdcsService hdcsService;
		
	@RequestMapping(value="/hdcs/HtmlConvert", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse convertAttachFileHtml(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
 
		response = hdcsService.ConvertAttachFileHtml(paramMap);
		
		return response;
	}
	
	@RequestMapping(value="PopConvertHtml.do")
	public ModelAndView convertAttachFileHtml2(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq", loginVO.getUniqId());
 
		Map<String,Object> htmlInfo = hdcsService.ConvertAttachFileHtml2(paramMap);
		
		mv.addObject("htmlInfo", JSONObject.fromObject(htmlInfo));
		
		mv.setViewName("/main/pop/popConvertHtml");
		
		
		return mv;
	}
	
	@RequestMapping(value="CheckConvertHtml.do")
	public ModelAndView checkConvertHtml(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mv = new ModelAndView();
 
		Map<String,Object> htmlInfo = hdcsService.CheckConvertHtml(paramMap);
		
		mv.addObject("htmlInfo", htmlInfo);
		//mv.addObject("htmlInfo", JSONObject.fromObject(htmlInfo));
		
		mv.setViewName("jsonView");
		
		
		return mv;
	}
	
}
