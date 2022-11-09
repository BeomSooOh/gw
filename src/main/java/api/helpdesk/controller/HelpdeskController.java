package api.helpdesk.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.helpdesk.service.HelpdeskService;

@Controller
public class HelpdeskController {

	@Resource(name="HelpdeskService")
	private HelpdeskService helpdeskService;
	
	@ResponseBody
	@RequestMapping(value="/getHelpdeskApiInfo.do", produces=MediaType.TEXT_HTML_VALUE)
	public ModelAndView getHelpdeskApiInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		mv.addObject("helpdeskApiInfo", helpdeskService.returnHelpdeskInfo());
		mv.addObject("noticeContents", helpdeskService.returnNoticeContetns());
		return mv;
	}
}
