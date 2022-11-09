package api.fax.controller;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import api.common.model.APIResponse;
import api.fax.service.SmsService;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;

@Controller
public class SmsController {
	/* 변수정의 로그 */
	private Logger LOG = LogManager.getLogger(this.getClass());
	
	@Resource(name="SmsService")
	private SmsService smsService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
	@RequestMapping(value="/sms/web/admin/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse smsWebAdmin(HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@PathVariable String serviceName, @RequestBody Map<String, Object> request) {
		
		return smsService.action(servletRequest, request, "ADMIN", serviceName);
	}
	
	@RequestMapping(value="/sms/web/external/{serviceName}", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse smsWebUser(HttpServletRequest servletRequest, HttpServletResponse servletResponse,
			@PathVariable String serviceName, @RequestBody Map<String, Object> request) {
		
		return smsService.externalAction(servletRequest, request, serviceName);
	}
	
	@RequestMapping(value="/sms/web/admin/smsMonthStatisView")
	public ModelAndView smsMonthStatisView(@RequestParam Map<String, Object> params) {
		LOG.debug("+ [SMS] INFO - @Controller >> /sms/web/admin/smsMonthStatisView");
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		// 최초 현재 달 구하기
		Calendar cal = Calendar.getInstance();
		
		// 날짜 셋팅
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;

		
		// 최초 캘린더 조회 날짜 셋팅
		String smsDate = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month));
				
		
		try{
			// bill365 정보 가져오기
			
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("smsDAO.getSmsRegInfo", params);	
			
			result.put("agentID", groupInfo.get("agentId").toString());
			result.put("agentKey", groupInfo.get("agentKey").toString());
			result.put("compSeq", groupInfo.get("compSeq").toString());
			result.put("smsDate", smsDate);
			
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.addObject("result", result);
		mv.setViewName("/neos/cmm/ex/sms/smsMonthStatisView");
		LOG.debug("- [SMS] INFO - @Controller >> /sms/web/admin/smsMonthStatisView");
		return mv;
	}
	
	@RequestMapping(value="/sms/web/admin/pop/smsDeptMonthDetail")
	public ModelAndView smsMonthStatisPopDetail(@RequestParam Map<String, Object> params) {
		LOG.debug("+ [SMS] INFO - @Controller >> /sms/web/admin/smsMonthStatisPopDetail");
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		//params.put("compSeq", loginVO.getCompSeq());
		
		Map<String, Object> result = new HashMap<String, Object>();
	
		try{
			result.put("agentID", params.get("agentID").toString());
			result.put("agentKey", params.get("agentKey").toString());
			result.put("compSeq", params.get("compSeq").toString());
			result.put("smsDate", params.get("smsDate").toString());
			result.put("deptSeq", params.get("deptSeq").toString());
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		mv.addObject("result", result);
		mv.setViewName("/neos/cmm/ex/sms/pop/smsDeptMonthDetail");
		LOG.debug("- [SMS] INFO - @Controller >> /sms/web/admin/pop/smsDeptMonthDetail");
		return mv;
	}
	
	@RequestMapping(value="/sms/web/admin/excelDownload")
	public void test(HttpServletRequest servletRequest, HttpServletResponse servletResponse, @RequestParam Map<String, Object> params) {
		LOG.debug("+ [SMS] INFO - @Controller >> /sms/web/admin/smsMonthStatisPopDetail");
		
		APIResponse apiResponse = smsService.action(servletRequest, params, "ADMIN", "SmsMonthStatis");
		
		Map<String, Object> smsData = (Map<String, Object>)apiResponse.getResult();
		
		Map<String, Object> smsList = (Map<String, Object>)smsData.get("result");
		
		List<Map<String, Object>> arr = (List<Map<String, Object>>)smsList.get("SMSMonthStatisInfoList");
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> temp : arr) {
			Map<String, Object> smsDataOrder = new HashMap<String, Object>();
			
			smsDataOrder.put("deptName", temp.get("deptName").toString());
			smsDataOrder.put("deptPoint", String.valueOf((int)Float.parseFloat(temp.get("deptPoint").toString())));
			smsDataOrder.put("deptCount", String.valueOf(Integer.parseInt(temp.get("deptCount").toString())));
			
			list.add(smsDataOrder);
		}
		
		String arrCol[] = new String[3];
		String fileNm = "Month_Statis_SMS_" + Integer.parseInt(params.get("smsDate").toString());
		
		arrCol[0] = BizboxAMessage.getMessage("TX000000068","부서명");
		arrCol[1] = BizboxAMessage.getMessage("TX800000009","사용포인트");
		arrCol[2] = BizboxAMessage.getMessage("TX800000010","사용 건수");
		
		
		
		excelService.CmmExcelDownload(list, arrCol, fileNm, servletResponse, servletRequest);
		LOG.debug("- [SMS] INFO - @Controller >> /sms/web/admin/pop/smsDeptMonthDetail");

	}
}
