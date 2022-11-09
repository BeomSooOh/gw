package api.hrExtInterlock.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;

import api.common.model.APIResponse;
import api.common.model.APIResponse2;
import api.hrExtInterlock.service.hrExtInterlockService;

@Controller
public class hrExtInterlockController {
	
	@Resource(name="hrExtInterlockService")
	private hrExtInterlockService hrExtInterlockService;
	
	@Resource ( name = "wehagoAdapterService" )
	private wehagoAdapterService wehago;	

	 @RequestMapping(value="/hrExtInterlock/{serviceName}", method=RequestMethod.POST)
	 @ResponseBody
	 public APIResponse empInsert(@PathVariable String serviceName, HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			 @RequestBody Map<String, Object> request){

		 return hrExtInterlockService.action(serviceName, request);
	 }
	 
	 @RequestMapping(value="/viewExtInterlock/{serviceName}", method=RequestMethod.POST)
	 @ResponseBody
	 public APIResponse viewSelect(@PathVariable String serviceName, HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			 @RequestBody Map<String, Object> request){

		 return hrExtInterlockService.viewSelect(serviceName, request);
	 }
	 
	 @RequestMapping(value="/hrExtInterlock/orgAdapter", method=RequestMethod.POST)
	 @ResponseBody
	 public APIResponse orgAdapter(HttpServletRequest servletRequest, HttpServletResponse servletResponse, 
			 @RequestBody Map<String, Object> request){

		 request.put("orgAdapterRequestDomain", servletRequest.getServerName() + (servletRequest.getServerPort() == 80 ? "" : ":" + servletRequest.getServerPort()));
		 return hrExtInterlockService.action("orgAdapter", request);
	 }
	 
	 @RequestMapping(value="/wehago/joinCallback", method=RequestMethod.POST)
	 @ResponseBody
	 public APIResponse2 joinCallback(HttpServletRequest servletRequest) throws Exception{
		
		 return wehago.wehagoJoinCallback(servletRequest );
		 
	 }	 
}
