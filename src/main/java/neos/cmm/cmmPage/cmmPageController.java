package neos.cmm.cmmPage;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class cmmPageController {
	
	 @Resource(name = "commonSql")
	 private CommonSqlDAO commonSql;	
	 
	 @Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;

	 /* 로그 설정 */
	Logger LOG = LogManager.getLogger(this.getClass());
	
	@RequestMapping("/cmm/cmmPage/CmmPageView.do") 
	public ModelAndView cmmPageView(@RequestParam Map<String, Object> paramMap){
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/cmmPage/cmmPageView");
		
		return mv;
		
	}
	
	@RequestMapping("/cmm/cmmPage/cmmSmsFrameView.do") 
	public ModelAndView cmmSmsFrameView(@RequestParam Map<String, Object> paramMap, HttpServletRequest request) throws UnsupportedEncodingException{
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		// POST 방식 호출
		JSONObject phoneList = new JSONObject();
		JSONArray phoeListArray = new JSONArray();
		JSONObject userInfo = new JSONObject();
		
		
		Map<String, Object> smsParam = new HashMap<String, Object>();
		smsParam.put("empSeq", loginVO.getUniqId());
		smsParam.put("compSeq", loginVO.getCompSeq());
		String smsURL = ""; 
		
		String url = request.getRequestURL().toString();
		url = url.replaceAll(request.getRequestURI(), "") + "/gw/cmm/systemx/cmmOcType4Pop.do";
				
		
		Map<String, Object> smsCompany = (Map<String, Object>)commonSql.select("faxDAO.getSMSCompany", smsParam);
		
		if(smsCompany != null) {
			
			String bill36524Url = smsCompany.get("bill36524_url").toString();
			
			String addrURL = base64Encode(url + "?mode=ex&compSeq="+loginVO.getCompSeq()+"&groupSeq="+loginVO.getGroupSeq()+"&langCode="+loginVO.getLangCode()+"&empSeq="+loginVO.getUniqId()+"&deptSeq="+loginVO.getOrgnztId()+"&adminAuth="+loginVO.getUserSe()+"&moduleType=t&callback=callbackSel");
			String serviceFlag = paramMap.get("ServiceFlag").toString();
			Date dt = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");			
			String today = sdf.format(dt); 
			String agentID = smsCompany.get("agent_id").toString();
			String agentKey = smsCompany.get("agent_key").toString();
			String isAdmin = base64Encode(loginVO.getUserSe().equals("USER") ? "0" : "1");
			String phoneNum = "";
			
			//mv.addObject("phoneList"," ");
			if(loginVO.getUserSe().equals("USER")){
				
				phoneNum = base64Encode(smsCompany.get("mobile_tel_num").toString().replaceAll("-", ""));
				
				if(phoneNum == null) {
					phoneNum = base64Encode("00000000000");
				}
				if(serviceFlag.equals("SMSRESULT") && phoneNum.equals("")){
					phoneNum = base64Encode("00000000000");
				}
				else{
					
					String phone = (String)request.getSession().getAttribute("SMSInfo");
					
					if(phone == null) {
						//smsURL = bill36524_url + "/BizBoxWebFax/FSPage.aspx?AgentID=" + agentID + "&AgentKey=" + agentKey + "&LoginDate=" + base64Encode(today) + "&ServiceFlag=" + base64Encode(ServiceFlag) + "&RecvFaxNumber=&CallbackMobileNumber=" + phoneNum + "&IsAdmin=" + isAdmin + "&addrURL=" + addrURL;
					} else {
						/* 변수선언 */
						String[] msgData = phone.split("\\|", 5);
						String compSeqList = "";
						String bizSeqList = "";
						String deptSeqList = "";
						String empSeqList = "";

						Map<String, Object> param = new HashMap<String, Object>();

						/* 데이터 검증 */
						for (int i = 0; i < msgData.length; i++) {
							if (i == 0) {
								compSeqList = msgData[i];

								param.put("compList", compSeqList.split(","));

							} else if (i == 1) {
								bizSeqList = msgData[i];

								param.put("bizList", bizSeqList.split(","));

							} else if (i == 2) {
								deptSeqList = msgData[i];

								param.put("deptList", deptSeqList.split(","));

							} else if (i == 3) {
								empSeqList = msgData[i];

								param.put("empList", empSeqList.split(","));
							}
						}

						List<Map<String, Object>> pP = (ArrayList<Map<String, Object>>) commonSql.list("faxDAO.getPhoneNumber", param);
						
						for(int i=0; i<pP.size(); i++) {
							userInfo = new JSONObject();
							userInfo.put("n", pP.get(i).get("mobileTelNum"));
							userInfo.put("c", pP.get(i).get("compNameList"));
							userInfo.put("u", pP.get(i).get("empName"));
							
							phoeListArray.add(userInfo);
						}

						phoneList.put("phoneList", phoeListArray);
						mv.addObject("phoneList",
								base64Encode(phoneList.toString()));
					}
					
					
				}
			}
			
			mv.addObject("compSeq", base64Encode(loginVO.getOrganId()));
			mv.addObject("compName", base64Encode(loginVO.getOrganNm()));
			mv.addObject("deptSeq", base64Encode(loginVO.getOrgnztId()));
			mv.addObject("deptName", base64Encode(loginVO.getOrgnztNm()));
			mv.addObject("empSeq", base64Encode(loginVO.getUniqId()));
			mv.addObject("empName", base64Encode(loginVO.getName()));
			mv.addObject("addrURL", addrURL);
			mv.addObject("agentID", base64Encode(agentID));
			mv.addObject("agentKey", agentKey);
			mv.addObject("loginDate", base64Encode(today));
			mv.addObject("serviceFlag", base64Encode(serviceFlag));
			mv.addObject("RecvFaxNumber", base64Encode(""));
			mv.addObject("CallbackMobileNumber", phoneNum);
			mv.addObject("isAdmin", isAdmin);
			//smsURL = "http://172.16.119.21:9001" + "/BizBoxWebFax/FSPagePost.aspx";
			smsURL = bill36524Url + "/BizBoxWebFax/FSPagePost.aspx";
			
			mv.addObject("smsURL",smsURL);
			mv.addObject("billAuthYn","Y");
		}else{
			//연동계정 없음
		}
		
		mv.setViewName("/neos/cmm/cmmPage/cmmSmsFrameView");
		request.getSession().setAttribute("SMSInfo", null);
		return mv;
		
	}
	
	@RequestMapping("/cmm/cmmPage/cmmCheckPop.do") 
	public ModelAndView cmmCheckPop(@RequestParam Map<String, Object> paramMap){
		LOG.debug("+ [cmmPageController] INFO - @Controller >> /cmm/cmmPage/cmmCheckPop.do");
		ModelAndView mv = new ModelAndView();
		
		
		
		if(paramMap.get("type") != null) {
			mv.addObject("title", paramMap.get("resultContent").toString());
			mv.addObject("content", paramMap.get("resultMessage").toString());
			
			mv.setViewName("/neos/cmm/cmmPage/pop/cmmPassResultPop");
		} else {
			mv.addObject("content", paramMap.get("resultContent").toString());
			mv.addObject("result", paramMap.get("resultMessage").toString());
			
			mv.setViewName("/neos/cmm/cmmPage/pop/cmmCheckPop");
		}

		LOG.debug("- [cmmPageController] INFO - @Controller >> /cmm/cmmPage/cmmCheckPop.do");
		return mv;
	}

    public String base64Encode(String str) throws UnsupportedEncodingException {
		byte[] encode = Base64.encodeBase64(str.getBytes());
		return new String(encode, "UTF-8");
	}	
	
}
