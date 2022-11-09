package neos.cmm.menu.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.common.dao.APIDAO;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.constants.CommonConstants;
import main.constants.FormatConstants;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.menu.vo.MenuTreeVo;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.commonOption.vo.CommonOptionManageVO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.helper.DateHelper;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import neos.cmm.util.BizboxAProperties;

@Controller
public class MenuTreeContoroller {	
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;	

	 @Resource(name="MenuManageService")
	 private MenuManageService menuManageService; 

	 @Resource(name = "commonSql")
	 private CommonSqlDAO commonSql;	
	 
	 @Resource(name = "APIDAO")
	 private APIDAO apiDAO;
	 
	 @Resource(name="CommonOptionManageService")
	 CommonOptionManageService commonOptionManageService;
	 
	 @Resource(name="OrgChartService")
	 OrgChartService orgChartService;
	 
	 @Resource(name = "CompManageService")
	 private CompManageService compService;
	 
	 @Resource(name = "LicenseService")
	 private LicenseService licenseService;	 
	 	 
	 private static Log logger = LogFactory.getLog(MenuTreeContoroller.class);
	 
	@RequestMapping("/cmm/system/getMenu2Depth.do")
    public ModelAndView getMenu2Depth(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");		
		
		if(loginVO == null){
    		//세션이 만료되었을 경우 로그저장 
    		String sRequestedSessionId = request.getRequestedSessionId();
    		logger.error("[sessionInfo] there's no request session id : " + sRequestedSessionId + "headerInfo > " + getHeadersInfo(request).toString());			
			mv.addObject("sessionYn","N");
			return mv;
		}else{
			mv.addObject("sessionYn","Y");
		}
		
		/** top menu */
		String authCode = loginVO.getAuthorCode();
		

		
		String userSe = loginVO.getUserSe();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		//그룹사 컨테이너별 Path 가져오기 -parameter (groupSeq)
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		
		if (!EgovStringUtil.isEmpty(authCode) || (!EgovStringUtil.isEmpty(userSe) && userSe.equals("ADMIN"))) {
			String[] authArr = authCode.split("#");
			
			params.put("authCodeList", authArr);
			
			if (loginVO.getUserSe().equals("MASTER")) {
				CommonUtil.getSessionData(request, "compSeq", params);
			} else {
				params.put("compSeq", loginVO.getCompSeq());
			}
			
			if (params.get("compSeq") == null || params.get("compSeq").equals("")) {
				 params.put("compSeq", loginVO.getCompSeq());
			}
			
//			params.put("compSeq", loginVO.getCompSeq());
			
			params.put("langCode", loginVO.getLangCode());
			
			List<Map<String,Object>> depth2MenuList = null;
			params.put("id", loginVO.getId());
			params.put("empSeq", loginVO.getUniqId());
			params.put("userSe", userSe);
						
			if (userSe.equals("USER")) {
				
				params.put("level",1);
				depth2MenuList = menuManageService.selectMenuTreeList(params);
			    for(Map<String,Object> map : depth2MenuList) {
			    	// 즐겨찾기 API 카운트 
				    if(EgovStringUtil.isNullToString(map.get("menuNo")).equals("507000000")) {
						JSONObject json = new JSONObject();
						
						//api 호출 파라미터 정리
						json.put("groupSeq", EgovStringUtil.isNullToString(loginVO.getGroupSeq()));
						json.put("compSeq", EgovStringUtil.isNullToString(loginVO.getCompSeq()));
						json.put("bizSeq", EgovStringUtil.isNullToString(loginVO.getBizSeq()));
						json.put("deptSeq", EgovStringUtil.isNullToString(loginVO.getDeptid()));
						json.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));
						json.put("loginId", EgovStringUtil.isNullToString(loginVO.getId()));
						json.put("langCode", EgovStringUtil.isNullToString(loginVO.getLangCode()));
						json.put("countYn", EgovStringUtil.isNullToString("Y"));
						json.put("edmsUrl", EgovStringUtil.isNullToString(groupMap.get("edmsUrl")));
						json.put("from",  EgovStringUtil.isNullToString("user"));
						
						HttpJsonUtil httpJson = new HttpJsonUtil();
						
						String apiUrl = CommonUtil.getApiCallDomain(request) + "/edms/board/getUserBookmarkBoardList.do";
						String jsonStr = httpJson.execute("GET", apiUrl, json);
						
						if(!jsonStr.equals("")){
							JSONObject boardBookMarkList = JSONObject.fromObject(JSONSerializer.toJSON(jsonStr.substring(1)));
							
							if(boardBookMarkList.get("resultCode").equals("0")) {
								if(!boardBookMarkList.get("result").toString().equals("{}") ) {
									JSONArray boardBookMartArray = boardBookMarkList.getJSONArray("result");
									map.put("childCount", boardBookMartArray.size());
								} else {
									map.put("childCount", 0);
								}
								
							}							
						}
					  }
			    	
			    	//게시판(501000000)은 Api 호출을 해야 하기 때문에 예외처리
			    	if(CommonUtil.getIntNvl(map.get("childCount")+"") > 0 || EgovStringUtil.isNullToString(map.get("menuNo")).equals("501000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("505000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("390000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("1501000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("1505000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("1100020000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("1100030000")) {
			    		map.put("expendClass", "");
			    	}else{
			    		map.put("expendClass", "non_sub");
			    	}
			    }
				
				
			} else if (userSe.equals("ADMIN") || userSe.equals("MASTER")) {				
				params.put("menuGubun", userSe);
				params.put("menuAuthType", userSe);
				params.put("empSeq", loginVO.getUniqId());
				params.put("compSeq", loginVO.getCompSeq());
				params.put("level",1);
				params.put("userSe", loginVO.getUserSe());
				depth2MenuList = menuManageService.selectAdminMenuTreeListAuth(params);
				int sequence = 0;
				  for(Map<String,Object> map : depth2MenuList) {
					  String expendClass =  "" ;
					  
					  // 즐겨찾기 API 카운트 
					  if(EgovStringUtil.isNullToString(map.get("menuNo")).equals("507000000") || EgovStringUtil.isNullToString(map.get("menuNo")).equals("1507000000")) {
							JSONObject json = new JSONObject();
							
							//api 호출 파라미터 정리
							json.put("groupSeq", EgovStringUtil.isNullToString(loginVO.getGroupSeq()));
							json.put("compSeq", EgovStringUtil.isNullToString(loginVO.getCompSeq()));
							json.put("bizSeq", EgovStringUtil.isNullToString(loginVO.getBizSeq()));
							json.put("deptSeq", EgovStringUtil.isNullToString(loginVO.getDeptid()));
							json.put("empSeq", EgovStringUtil.isNullToString(loginVO.getUniqId()));
							json.put("loginId", EgovStringUtil.isNullToString(loginVO.getId()));
							json.put("langCode", EgovStringUtil.isNullToString(loginVO.getLangCode()));
							json.put("edmsUrl", EgovStringUtil.isNullToString(groupMap.get("edmsUrl")));
							
							if(userSe.equals("ADMIN")) {
								json.put("from",  EgovStringUtil.isNullToString("admin"));
							}
							else {
								json.put("from",  EgovStringUtil.isNullToString("master"));
							}
							
							HttpJsonUtil httpJson = new HttpJsonUtil();
							
							String apiUrl = CommonUtil.getApiCallDomain(request) + "/edms/admin/getAdmBookmarkBoardList.do";
							String jsonStr = httpJson.execute("GET", apiUrl, json);
							
							if(jsonStr != null && !jsonStr.equals("")){
								JSONObject boardBookMarkList = JSONObject.fromObject(JSONSerializer.toJSON(jsonStr.substring(1)));
								
								if(boardBookMarkList.get("resultCode") != null && boardBookMarkList.get("resultCode").equals("0")) {
									if(!boardBookMarkList.get("result").toString().equals("{}")) {
										JSONArray boardBookMartArray = boardBookMarkList.getJSONArray("result");
										map.put("childCount", boardBookMartArray.size());
									} else {
										map.put("childCount", 0);
									}
								}else{
									map.put("childCount", 0);
								}								
							}else{
								map.put("childCount", 0);
							}
					  }
					  
					    if(CommonUtil.getIntNvl(map.get("childCount")+"") > 0) {
				    		expendClass = null;
				    	}else{
				    		if(map.get("menuNo").toString().equals("501000000") || map.get("menuNo").toString().equals("1501000000") || map.get("menuNo").toString().equals("1505000000")) {
				    			expendClass = null;
				    		}
				    		else {
				    			expendClass = "non_sub";
				    		}
				    	}
					  

					  depth2MenuList.get(sequence).put("expendClass",expendClass);
					  sequence++;
				    }
			}
			
			mv.addObject("menuImgClass", (String)commonSql.select("MenuManageDAO.selectMenuImgClass", params));
			mv.addObject("depth2Menu", depth2MenuList);
			mv.addObject("userSe", userSe);
		}        
		
		String openMenuDepth = "";
		//메뉴별 openDepth 설정값 가져오기(공통옵션)
		try{
			if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1600").equals("1")){
				String topMenuNo = params.get("startWith") + "";
				
				//전자결재
				if(topMenuNo.equals("2000000000") || topMenuNo.equals("100000000") || (topMenuNo.equals("700000000") && !userSe.equals("USER")) || topMenuNo.equals("800000000") || topMenuNo.equals("1100000000") || topMenuNo.equals("1700000000")){
					
					String cm1601 = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1601");
					if(!cm1601.equals("")){
						openMenuDepth = String.valueOf(Integer.parseInt(cm1601));
					}
				}	
				//일정
				else if(topMenuNo.equals("300000000") ){
					
					String cm1602 = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1602");
					if(!cm1602.equals("")){
						openMenuDepth = String.valueOf(Integer.parseInt(cm1602));
					}
				}
				//게시판
				else if(topMenuNo.equals("500000000") || topMenuNo.equals("1500000000")){
					
					String cm1603 = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1603");
					if(!cm1603.equals("")){
						openMenuDepth = String.valueOf(Integer.parseInt(cm1603));
					}
				}
				//문서
				else if(topMenuNo.equals("600000000")){
					
					String cm1604 = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1604"); 
					
					if(!cm1604.equals("")){
						openMenuDepth = String.valueOf(Integer.parseInt(cm1604));
					}
				}
				//인사/근태
				else if((topMenuNo.equals("700000000") && userSe.equals("USER")) || topMenuNo.equals("930000000")){
					
					String cm1605 = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1605");
					if(!cm1605.equals("")){
						openMenuDepth = String.valueOf(Integer.parseInt(cm1605));
					}
				}
				
				if(Integer.parseInt(openMenuDepth) < 0){
					openMenuDepth = "1";
				}
			}else{
				openMenuDepth = "";
			}
		}catch(Exception e){
			openMenuDepth = "1";
		}
		mv.addObject("openMenuDepth", openMenuDepth);

		
		
		//전자결재 카운트 표시여부 체크(공통옵션)
		if((params.get("startWith")+"").equals("2000000000") || (params.get("startWith")+"").equals("100000000")){
			if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500").equals("1")){
				if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1501").equals("1")){
					mv.addObject("eaMenuCnt", "Y");
				}
			}
		}
		
          
        
        return mv;
    }
	
	@RequestMapping("/cmm/system/getAesEncDesResult.do")
    public ModelAndView getAesEncDesResult(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
		ModelAndView mv = new ModelAndView();
		
		String functionAdminKey = BizboxAProperties.getCustomProperty("BizboxA.Cust.functionAdminKey");
		
		if(!functionAdminKey.equals("99") && functionAdminKey.equals(params.get("adminKey"))) {
			
			if(params.get("type").equals("loginToken")) {
				
				Date now = new Date();
				
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(now);
				calendar.add(Calendar.HOUR_OF_DAY, 1);
				now = calendar.getTime();				
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
				String token = sdf.format(now) + "▦" + params.get("param1");
				mv.addObject("result", "/gw/CustEncLogOn.do?ssoKey=" + URLEncoder.encode(AESCipher.AES128EX_Encode(token, "1023497555960596"), "UTF-8"));
				
			}else {
				mv.addObject("result",AESCipher.AES128EX_Encode(DateUtil.getCurrentDate("yyyyMMddHHmmss") + "▦" + params.get("groupSeq") + "▦" + params.get("type") + "▦" + params.get("param1") + "▦" + params.get("param2") + "▦" + params.get("param3"), "1023497555960596"));	
			}
			
		}else {
			mv.addObject("result", "키발급 권한이 없습니다.");
		}
		
		mv.setViewName("jsonView");
        
        return mv;
    }
	
	@RequestMapping("/cmm/system/updateDBLicenseKey.do")
    public ModelAndView updateDBLicenseKey(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		String[] functionKeyArray = AESCipher.AES128EX_Decode(params.get("functionKey").toString(), "1023497555960596").split("▦", -1);
		
		if(functionKeyArray.length > 5) {

			if(functionKeyArray[0].length() > 13){
				
				DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmmss");
				
				DateTime nowDt = DateTime.now().minusHours(24);
				DateTime ssoDt = formatter.parseDateTime(functionKeyArray[0]);
				
				if(ssoDt.isAfter(nowDt)){
					
					String groupSeq = functionKeyArray[1];
					String type = functionKeyArray[2];
					String param1 = functionKeyArray[3];
					String param2 = functionKeyArray[4];
					String param3 = functionKeyArray[5];
					
					params.put("groupSeq", groupSeq);
					
					try {
						if(groupManageService.getGroupInfo(params) == null) {
							mv.addObject("result", "groupSeq is invalid.");
							return mv;
						}
					}catch(Exception ex) {
						mv.addObject("result", "groupSeq is invalid.");
						return mv;						
					}
					
					if(type.equals("license")) {
						
						if(param1.equals("0") && param2.equals("0")) {
							params.put("licenseKey", "");	
						}else {
							params.put("licenseKey", AESCipher.AES_Encode(groupSeq) + "▦" + AESCipher.AES_Encode(param1) + "▦" + AESCipher.AES_Encode(param2));	
						}
						
						mv.addObject("result", licenseService.updateDBLicenseKey(params));
						
					}else if(type.equals("masterPwd")) {
						
						params.put("masterSecu", CommonUtil.passwordEncrypt(param3));
						
						if(param1.length() == 16 && param1.contains("-") && param1.contains(":")) {
							params.put("masterPasswdExpDt", param1);
						}
						
						groupManageService.setMasterSecu(params);
						mv.addObject("result", "Password change complete!");
						
					}
				}				
			}
		}
        
        return mv;
    }	
	
	@RequestMapping("/cmm/system/getMenuSSOLinkInfo.do")
    public ModelAndView getMenuSSOLinkInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null) {
		
			mv.addAllObjects(menuManageService.getMenuSSOLinkInfo(params, loginVO));
		
		}
                
        return mv;
    }

	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/cmm/system/getJsTreeList.do")
    public Object getMenu2DepthIn(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		JSONArray jsonTreeList = null;
		
		if(loginVO != null) {
			/** top menu */
			String authCode = loginVO.getAuthorCode();
			String userSe = loginVO.getUserSe();
			
			List<MenuTreeVo> jsTreeList = new ArrayList<MenuTreeVo>();
			
			String sTarget = params.get("target") + "";
			

			if (!EgovStringUtil.isEmpty(authCode) || (!EgovStringUtil.isEmpty(userSe) && userSe.equals("ADMIN"))) {
				String[] authArr = authCode.split("#");
				
				params.put("authCodeList", authArr);
				
				if (loginVO.getUserSe().equals("MASTER")) {
					CommonUtil.getSessionData(request, "compSeq", params);
				} else {
					params.put("compSeq", loginVO.getCompSeq());
				}
				
				if (params.get("compSeq") == null || params.get("compSeq").equals("")) {
					 params.put("compSeq", loginVO.getCompSeq());
				}
				
				params.put("langCode", loginVO.getLangCode());
				
				List<Map<String,Object>> list = null;
				List<Map<String,Object>> boardList = null;
				List<Map<String,Object>> scheduleList = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> prjScheduleList = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> boardBookMarkList = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> kissMenuList = new ArrayList<Map<String,Object>>();

				String upperMenuNo =  "" ;
				String menuType = "";
				int level =  CommonUtil.getIntNvl(EgovStringUtil.isNullToString(params.get("level")));
				
				upperMenuNo = EgovStringUtil.isNullToString(params.get("upperMenuNo"));			
				menuType = EgovStringUtil.isNullToString(params.get("menuType")); 
				
				params.put("id", loginVO.getId());
				params.put("empSeq", loginVO.getUniqId());
				params.put("userSe", userSe);
				
				params.put("compSeq", loginVO.getCompSeq());
				params.put("groupSeq", loginVO.getGroupSeq());
				params.put("bizSeq", loginVO.getBizSeq());
				params.put("deptSeq", loginVO.getOrgnztId());
				params.put("langCode", loginVO.getLangCode());
				
				//그룹사 컨테이너별 Path 가져오기 -parameter (groupSeq)
				String serverName = CommonUtil.getApiCallDomain(request);
				String boardCntYn = "";
				
				if (userSe.equals("USER")) {
					String apiUrl =  serverName + "/schedule";
					CommonOptionManageVO resultMap = new CommonOptionManageVO();	
					try {							
						resultMap = commonOptionManageService.selectCommonOption();	
						//메뉴 카운트 표시, 1:미사용, 2:전자결재, 3:공지게시, 4:모두
						String menuCnt = resultMap.getMenuCnt();
						boardCntYn = menuCnt.equals("3") || menuCnt.equals("4") ? "Y" :"N";
						
					} catch (Exception e) {
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}
					
					//개인 결재함 일 경우
					if(menuType.equals("eaBox")) {
						params.put("eaPrivateBox",'Y');
					}
					//게시판 일경우 (edms)
					if(menuType.equals("edms")) {
						params.put("edmsUrl", serverName);
						params.put("countYn",boardCntYn);					
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						String sFrom = "";
						if(loginVO.getUserSe().equals("ADMIN"))	{
							sFrom = "admin";
						}
						else if(loginVO.getUserSe().equals("MASTER"))	{
							sFrom = "master";
						}
						params.put("from",sFrom);
						
						boardList = callByMenuAPI(params,menuType);
						
						if((upperMenuNo).equals("501000000")) {
							list = menuManageService.selectMenuJsTreeList(params);
							if (list != null && list.size() > 0) {
								for(Map<String,Object> map : list) {		
									map.put("menuType", "edms");
								}
							}
						}
						
					}else if(menuType.equals("eaCategory")) {
						//카테코리별 문서관리 예외처리.
						params.put("edmsUrl", serverName);
						params.put("countYn",boardCntYn);					
						params.put("level",1);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from","");
						params.put("dir_type", "B");
						
						boardList = callByMenuAPI(params,menuType);
					}else if(menuType.equals("doc")) {
						//카테코리별 문서관리 예외처리.
						
						params.put("edmsUrl", serverName);	
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from","");
						
						boardList = callByMenuAPI(params,menuType);
					}else if(menuType.equals("schedule") && !params.get("upperMenuNo").equals("301000000")) {
						//String calType = "";
						
						if(params.get("upperMenuNo").equals("301030000")) {
							//calType = "G";
							scheduleList = callByMenuScheduleAPI(params, apiUrl);
						} else if(params.get("upperMenuNo").equals("301040000")) {
							//calType = "M";
							scheduleList = callByMenuScheduleAPI(params, apiUrl);
						} else if(params.get("upperMenuNo").equals("301050000")) {
							//calType = "T";
							scheduleList = callByMenuScheduleAPI(params, apiUrl);
						} else if(params.get("upperMenuNo").equals("301060000")) {
							list = menuManageService.selectMenuJsTreeList(params);
						} else if(params.get("upperMenuNo").equals("390000000")) {
							prjScheduleList = callByMenuScheduleAPI(params, apiUrl);
						} else {
							scheduleList = callByMenuScheduleAPI(params, apiUrl);
						}
					}else if(menuType.equals("prjSchedule")) {
						prjScheduleList = callByMenuScheduleAPI(params, apiUrl);
					} else if(menuType.equals("bookMark")) {
						params.put("edmsUrl", CommonUtil.getApiCallDomain(request));
						params.put("countYn",boardCntYn);					
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from","user");
						
						boardBookMarkList = callByBoardBookMarkAPI(params);
					} else if(menuType.equals("kissG") || menuType.equals("kissA")) {
						params.put("apiUrl", serverName);
						params.put("countYn","");					
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						
						kissMenuList = callByKissApi(params);
					}
					else {
						list = menuManageService.selectMenuJsTreeList(params);
					}

					List<Map<String, Object>> listTemp = new ArrayList<Map<String,Object>>();
					
					// user 권한일 때, 팩스 사용 번호 리스트 추가
					if(userSe.equals("USER") && (upperMenuNo.equals("901000000"))) {
						Map<String, Object> data = new HashMap<String, Object>();
						Map<String, Object> request1 = new HashMap<String, Object>();
						
						request1.put("groupSeq", loginVO.getGroupSeq());
						request1.put("compSeq", loginVO.getOrganId());
						request1.put("deptSeq", loginVO.getOrgnztId());
						request1.put("empSeq", loginVO.getUniqId());
						request1.put("langCode", loginVO.getLangCode());
						
						long menuNoTemp =901000000L;
						data.put("faxNo", "");
						data.put("syncYn", "Y");
						data.put("groupSeq", loginVO.getGroupSeq());
						data.put("compSeq", loginVO.getCompSeq());
						data.put("langCode", loginVO.getLangCode());
						
						String depts = "";
						List<String> pathList = apiDAO.list("faxDAO.getDeptPath", request1);
						for(String path : pathList){
							depts += "," + path;
						}
						if(depts.length() > 0) {
							depts = depts.substring(1);
						}
						request1.put("depts", depts.split(","));
						List<Map<String, Object>> a = apiDAO.list("faxDAO.getFaxNoListUser", request1);
						
						String url = request.getRequestURL().toString();
						url = url.replaceAll(request.getRequestURI(), "") + "/gw/cmm/systemx/cmmOcType4Pop.do";
						String para = "?mode=ex&compSeq="+loginVO.getCompSeq()+"&groupSeq="+loginVO.getGroupSeq()+"&langCode="+loginVO.getLangCode()+"&empSeq="+loginVO.getUniqId()+"&deptSeq="+loginVO.getOrgnztId()+"&adminAuth="+loginVO.getUserSe()+"&moduleType=f&callback=callbackSel";
						
						for(Map<String, Object> items : a) {
							listTemp = new ArrayList<Map<String,Object>>();
							Map<String, Object> data1 = new LinkedHashMap<String, Object>();
							JSONObject json = new JSONObject();
							
							//웹팩스 별칭옵션에따라 메뉴명 셋팅
							String nameTemp = phoneFormat(items.get("faxNo").toString());
							if(items.get("option").toString().equals("2") && !items.get("nickName").toString().equals("")){
								nameTemp = nameTemp + " (" + items.get("nickName").toString() + ")";
							}else if(items.get("option").toString().equals("3") && !items.get("nickName").toString().equals("")){
								nameTemp = items.get("nickName").toString() + " (" + nameTemp + ")";
							}else if(items.get("option").toString().equals("4") && !items.get("nickName").toString().equals("")){
								nameTemp = items.get("nickName").toString();
							}
							
							String faxNo = items.get("faxNo").toString();
							String agentID = items.get("agentId").toString();
							String agentKey = items.get("agentKey").toString();
							Date dt = new Date();
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
							String today = sdf.format(dt); 
							String faxNoEncode = base64Encode(faxNo);
							String agentIDEncode = base64Encode(agentID);
							String agentKeyEncode = agentKey;
							String loginDataEncode = base64Encode(today);
							String serviceFlagEncode = base64Encode("FAX");
							String isAdmin = base64Encode("0");
							String addrURL = base64Encode((url + para));
									
							menuNoTemp += 10000;
							data1.put("menuNo", menuNoTemp);
							data1.put("menu_gubun", "MENU009");
							data1.put("upperMenuNo", "901000000");
							data1.put("name", nameTemp);
							data1.put("menuDc", "null");

							if(loginVO.getGroupSeq().equals("dev") || loginVO.getGroupSeq().equals("demo") || loginVO.getGroupSeq().equals("portal")) {
								data1.put("urlPath", request.getScheme() + "://172.16.119.21:9012/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin + "&addrURL=" + addrURL);
							} else {
								data1.put("urlPath", request.getScheme() + "://bizboxweb.cloudfax.co.kr/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin + "&addrURL=" + addrURL);
							}
							
							data1.put("ssoUseYn", "N");
							data1.put("lvl", "1");
							data1.put("childCount", "0");
							data1.put("urlGubun", "");
							data1.put("menuImgClass", "null");
							
							listTemp.add(data1);
							
							if(list!=null) {//Null Pointer 역참조
							list.addAll(listTemp);
							}
							
						}
					}
				}else if (userSe.equals("ADMIN") || userSe.equals("MASTER")) {
					List<Map<String, Object>> tmpList = new ArrayList<Map<String,Object>>();
					
					params.put("menuGubun", userSe);
					params.put("menuAuthType", userSe);
					params.put("empSeq", loginVO.getUniqId());
					params.put("compSeq", loginVO.getCompSeq());
					params.put("userSe", loginVO.getUserSe());
					
					//게시판관리 (edms) 또는 프로젝트 게시판관리 (project) 일 경우
					if(menuType.equals("edms") || menuType.equals("project")) {
						params.put("edmsUrl", serverName);
						params.put("countYn",boardCntYn);					
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						String sFrom = "";
						if(loginVO.getUserSe().equals("MASTER"))	{
							sFrom = "master";
						}
						else {
							sFrom = "admin";
						}
						params.put("from",sFrom);
						
						boardList = callByMenuAPI(params,menuType);
						
						//포털설정->게시판 포틀릿 게시판 선택 트리에서는 최상단 최근게시글,공지글 노드 수동 추가.
						if(sTarget.equals("portletBoardSetPop") && (upperMenuNo.equals("501000000") || upperMenuNo.equals("1501000000"))){
							Map<String, Object> mp1 = new HashMap<String, Object>();
							mp1.put("cat_seq_no", "501030000");
							mp1.put("leaf_yn", "N");
							mp1.put("dir_form", "C");
							mp1.put("not_read_cnt", "0");
							mp1.put("total_art_cnt", "0");
							mp1.put("dir_nm", BizboxAMessage.getMessage("TX800000040","최근게시글"));
							mp1.put("dir_lvl", "1");
							mp1.put("close_yn", "N");
							mp1.put("dir_cd", "501030000");
							
							boardList.add(0, mp1);
							
							Map<String, Object> mp2 = new HashMap<String, Object>();
							mp2.put("cat_seq_no", "501040000");
							mp2.put("leaf_yn", "N");
							mp2.put("dir_form", "C");
							mp2.put("not_read_cnt", "0");
							mp2.put("total_art_cnt", "0");
							mp2.put("dir_nm", BizboxAMessage.getMessage("TX000018234","최근공지글"));
							mp2.put("dir_lvl", "1");
							mp2.put("close_yn", "N");
							mp2.put("dir_cd", "501040000");

							boardList.add(0, mp2);
						}
					}else if(menuType.equals("bookMark")){
						params.put("edmsUrl", CommonUtil.getApiCallDomain(request));
						params.put("countYn",boardCntYn);					
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from","admin");
						
						boardBookMarkList = callByBoardBookMarkAPI(params);
					}else if(menuType.equals("portletDocumentSetPop")) {
						//포털설정 -> 문서 포틀릿 문서함 선택시 노출될 문서 트리 .
						
						String docFrom = loginVO.getUserSe().equals("MASTER") ? "master" : "admin";
						
						params.put("edmsUrl", serverName);	
						params.put("level",level);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from", docFrom);						
						menuType = "doc";
						
						boardList = callByMenuAPI(params,menuType);						
					}else if(menuType.equals("eaCategory")) {
						//카테코리별 문서관리 예외처리.
						params.put("edmsUrl", serverName);
						params.put("countYn",boardCntYn);					
						params.put("level",1);
						params.put("upperMenuNo",upperMenuNo);
						params.put("from","admin");
						params.put("dir_type", "B");
						
						boardList = callByMenuAPI(params,menuType);
					}else {

						list = menuManageService.selectAdminMenuJsTreeList(params);
					}
					
					
					if(userSe.equals("ADMIN") && upperMenuNo.equals("911000000")) {
		
						Map<String, Object> data = new HashMap<String, Object>();
						data.put("faxNo", "");
						data.put("syncYn", "Y");
						data.put("groupSeq", loginVO.getGroupSeq());
						data.put("compSeq", loginVO.getCompSeq());
						data.put("langCode", loginVO.getLangCode());
		
						List<Map<String, Object>> a = apiDAO.list("faxDAO.getFaxNoInfoAdmin", data);
		
						
						Map<String, Object> baseMenu = new LinkedHashMap<String, Object>();
						
						if(a.size() > 0) {
							Map<String,Object> faxRootNode = a.get(0);
							String faxNo = faxRootNode.get("faxNo").toString();
							String agentID = faxRootNode.get("agent_id").toString();
							String agentKey = faxRootNode.get("agent_key").toString();
							
							Date dt = new Date();
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
							
							String today = sdf.format(dt); 
							
							String faxNoEncode = base64Encode(faxNo);
							String agentIDEncode = base64Encode(agentID);
							String agentKeyEncode = agentKey;
							String loginDataEncode = base64Encode(today);
							String serviceFlagEncode = base64Encode("FAX");
							String isAdmin = base64Encode("1");
							
							baseMenu.put("menuNo", "911020000");
							baseMenu.put("upperMenuNo", "911000000");
							baseMenu.put("name", BizboxAMessage.getMessage("TX000011795","팩스내역관리"));
							baseMenu.put("menuDc", "null");
							if(loginVO.getGroupSeq().equals("dev") || loginVO.getGroupSeq().equals("demo") || loginVO.getGroupSeq().equals("portal")) {
								baseMenu.put("urlPath", request.getScheme() + "://172.16.119.21:9012/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin);
							} else {
								baseMenu.put("urlPath", request.getScheme() + "://bizboxweb.cloudfax.co.kr/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin);
							}
							
							baseMenu.put("ssoUseYn", "N");
							baseMenu.put("lvl", "1");
							baseMenu.put("childCount", "4");
							baseMenu.put("authMenuNo", "null");
							baseMenu.put("urlGubun", "");
							baseMenu.put("menuImgClass", "null");
							
							tmpList.add(baseMenu);
						}
					}
				
					if(userSe.equals("ADMIN") && upperMenuNo.equals("911020000")) {
						

						Map<String, Object> data = new HashMap<String, Object>();
						long menuNo =911020000L;
						data.put("faxNo", "");
						data.put("syncYn", "Y");
						data.put("groupSeq", loginVO.getGroupSeq());
						data.put("compSeq", loginVO.getCompSeq());
						data.put("langCode", loginVO.getLangCode());

						List<Map<String, Object>> a = apiDAO.list("faxDAO.getFaxNoInfoAdmin", data);
						
						if(a != null) {
							
							for(Map<String, Object> item : a) {
								Map<String, Object> data1 = new LinkedHashMap<String, Object>();
								String name = phoneFormat(item.get("faxNo").toString());
								
								//웹팩스 별칭옵션에따라 메뉴명 셋팅							
								if(item.get("option").toString().equals("2") && !item.get("nickName").toString().equals("")){
									name = name + " (" + item.get("nickName").toString() + ")";
								}else if(item.get("option").toString().equals("3") && !item.get("nickName").toString().equals("")){
									name = item.get("nickName").toString() + " (" + name + ")";
								}else if(item.get("option").toString().equals("4") && !item.get("nickName").toString().equals("")){
									name = item.get("nickName").toString();
								}
								
								
								String faxNo = item.get("faxNo").toString();
								String agentID = item.get("agent_id").toString();
								String agentKey = item.get("agent_key").toString();
								
								Date dt = new Date();
								SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
								
								String today = sdf.format(dt); 
								
								String faxNoEncode = base64Encode(faxNo);
								String agentIDEncode = base64Encode(agentID);
								String agentKeyEncode = agentKey;
								String loginDataEncode = base64Encode(today);
								String serviceFlagEncode = base64Encode("FAX");
								String isAdmin = base64Encode("1");
								
								
								menuNo += 100;
								data1.put("menuNo", menuNo);
								data1.put("upperMenuNo", "911020000");
								data1.put("name", name);
								data1.put("menuDc", "null");

								if(loginVO.getGroupSeq().equals("dev") || loginVO.getGroupSeq().equals("demo") || loginVO.getGroupSeq().equals("portal")) {
									data1.put("urlPath", request.getScheme() + "://172.16.119.21:9012/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin);
									
								} else {
									data1.put("urlPath", request.getScheme() + "://bizboxweb.cloudfax.co.kr/BizBoxWebFax/FSPage.aspx?AgentID=" + agentIDEncode + "&AgentKey=" + agentKeyEncode + "&LoginDate=" + loginDataEncode + "&ServiceFlag=" + serviceFlagEncode + "&RecvFaxNumber=" + faxNoEncode + "&isAdmin=" + isAdmin);
									
								}
								
								data1.put("ssoUseYn", "N");
								data1.put("lvl", "2");
								data1.put("childCount", "0");
								data1.put("authMenuNo", "null");
								data1.put("urlGubun", "");
								data1.put("menuImgClass", "null");
								
								tmpList.add(data1);
							}
						
						}
					
					}
					
					for(Map<String, Object> real : tmpList) {
						if(list!=null) {//Null Pointer 역참조
						list.add(real);
						}
					}
				}
				if (list != null && list.size() > 0) {				

					String id = null;
					String name = null;
					String menuNo = null;
					String urlGubun = null;
					String menuGubun = null;
					String urlPath = null;
					String menuCnt = "";
					String menuClass = null;
					String ssoUseYn = null;
					MenuTreeVo items = new MenuTreeVo ();	
					
					//jsTree Json format 만들기
					for(Map<String,Object> map : list) {		
						
						items =  new MenuTreeVo();
								
						boolean children = false; 
						id = EgovStringUtil.isNullToString(map.get("menuNo"));		
						urlPath = EgovStringUtil.isNullToString(map.get("urlPath"));		
						name = EgovStringUtil.isNullToString(map.get("name"));	
						menuNo = EgovStringUtil.isNullToString(map.get("menuNo"));	
						urlGubun = EgovStringUtil.isNullToString(map.get("urlGubun"));	
						menuGubun = EgovStringUtil.isNullToString(map.get("menuGubun"));	
						menuType = EgovStringUtil.isNullToString(map.get("menuType"));	
						menuClass = EgovStringUtil.isNullToString(map.get("menuClass"));	
						ssoUseYn = EgovStringUtil.isNullToString(map.get("ssoUseYn"));
						
						params.put("compSeq", loginVO.getCompSeq());
						params.put("deptSeq", loginVO.getOrgnztId());
						params.put("empSeq", loginVO.getUniqId());
						params.put("menuNo", menuNo);
						params.put("eaId",EgovStringUtil.isNullToString(map.get("menuNo")));
						
						if(CommonUtil.getIntNvl(map.get("childCount")+"") > 0 || CommonUtil.getIntNvl(map.get("eaChildCount")+"") > 0) {
							children = true;
						}
						
						//카테코리별 문서관리 예외처리
						if(menuNo.equals("602010000") || menuNo.equals("605000200") || menuNo.equals("1605000200") || menuNo.equals("2103000200") || menuNo.equals("607010000")){
							children = true;
							urlPath = "";
							menuType = "eaCategory";
						}
						else if(menuNo.equals("301030000") || menuNo.equals("301040000") || menuNo.equals("301050000") || menuNo.equals("390000000")){
							String action = "";
							String calType = "";
							String apiUrl =  serverName + "/schedule";
							
							if(menuNo.equals("301030000")) {
								action = "/SearchScheduleMenuList";
								calType = "G";
							} else if(menuNo.equals("301040000")) {
								action = "/SearchScheduleMenuList";
								calType = "M";
							} else if(menuNo.equals("301050000")) {
								action = "/SearchScheduleMenuList";
								calType = "T";
							} else if(menuNo.equals("390000000")) {
								action = "/SearchSchedulePrjMenuList";
								calType = "P";
							}
							
							apiUrl += action;
							
							String jsonParam = "{\"compSeq\":\"" + loginVO.getCompSeq() + "\","; 
							jsonParam += "\"deptSeq\":\"" + loginVO.getOrgnztId() + "\",";
							jsonParam += "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
							jsonParam += "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
							jsonParam += "\"langCode\":\"" + loginVO.getLangCode() + "\",";
							jsonParam += "\"calType\":\"" + calType + "\"}";
							
							JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
							HttpJsonUtil httpJson = new HttpJsonUtil();
							String jsonStr = httpJson.execute("POST", apiUrl, jsonObject2);						
							
							if(!jsonStr.equals("")) {
								JSONObject retJsonObject = JSONObject.fromObject(JSONSerializer.toJSON(jsonStr));
								JSONArray menuList = (JSONArray)retJsonObject.get("result");
								
								if(menuList.size() != 0) {
									children = true;
									urlPath = "";
									menuType = "schedule";
								}
							}
							
						}
						else {						
							urlPath =EgovStringUtil.isNullToString(map.get("urlPath"));		
						}
						
						
						//업무보고 카운트 처리
						if(id.equals("304010000") || id.equals("304020000")){
							if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500").equals("1")){
								if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1503").equals("1")){
									Map<String, Object> para = new HashMap<String, Object>();
									para.put("empSeq", loginVO.getUniqId());
									para.put("compSeq", loginVO.getOrganId());
									para.put("groupSeq", loginVO.getGroupSeq());
									String cnt = "";
									if(id.equals("304010000")){
										para.put("kind", "0");	//보낸보고서
										cnt = (String) commonSql.select("MenuManageDAO.getReportMenuCnt", para);
									}else if(id.equals("304020000")){
										para.put("kind", "1");	//받은보고서
										cnt = (String) commonSql.select("MenuManageDAO.getReportMenuCnt", para);
									}
									if(!cnt.equals("")) {
										menuCnt = "(" + cnt + ")";
									}
								}
							}
						}
						
						items.setId(id);
						items.setText(name+menuCnt);
						items.setMenuGubun(menuGubun);
						items.setUrlGubun(urlGubun);
						items.setUrlPath(urlPath);
						items.setExceptGubun(menuType);
						items.setMenuClass(menuClass);
						items.setChildren(children);
						items.setSsoUseYn(ssoUseYn);
						
						if((upperMenuNo).equals("501000000")) {
							Map<String, Object> state = new HashMap<String, Object>();
							state.put("hidden", true);
							items.setState(state);
							
						}
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}

						menuCnt = "";
					}
				}
				
				if(scheduleList != null && scheduleList.size() > 0) {
					for(Map<String, Object> data : scheduleList) {
						MenuTreeVo items = new MenuTreeVo ();
						items.setId(data.get("id").toString());
						items.setText(data.get("calTitle").toString());
						items.setMenuNo(data.get("menuNo").toString());
						items.setMenuGubun(data.get("menuGubun").toString());
						items.setUrlPath(data.get("urlPath").toString());
						items.setMenuClass(data.get("menuClass").toString());
						items.setChildren(Boolean.parseBoolean(data.get("children").toString()));
						items.setExceptGubun(data.get("exceptGubun").toString());
						items.setSsoUseYn(data.get("ssoUseYn").toString());
						items.setLevel(Integer.parseInt(data.get("level").toString()));
						if(!data.get("scheduleSeq").equals("0")) {
							items.setScheduleSeq(data.get("scheduleSeq").toString());
						}
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}
				    }
				}
				
				if(prjScheduleList != null && prjScheduleList.size() >0){
					for(Map<String, Object> data : prjScheduleList) {
						MenuTreeVo items = new MenuTreeVo ();
						items.setId(data.get("id").toString());
						items.setText(data.get("calTitle").toString());
						items.setMenuNo(data.get("menuNo").toString());
						items.setMenuGubun(data.get("menuGubun").toString());
						items.setUrlPath(data.get("urlPath").toString());
						items.setMenuClass(data.get("menuClass").toString());
						items.setChildren(Boolean.parseBoolean(data.get("children").toString()));
						//items.setChildren(true);
						items.setExceptGubun(data.get("exceptGubun").toString());
						items.setSsoUseYn(data.get("ssoUseYn").toString());
						items.setLevel(Integer.parseInt(data.get("level").toString()));
						if(!data.get("scheduleSeq").equals("0")) {
							items.setScheduleSeq(data.get("scheduleSeq").toString());
						}
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}					
				    }
				}
				
				if (boardList != null && boardList.size() > 0) {
					

					String name = null;
					MenuTreeVo items = new MenuTreeVo ();	

					boolean children = false; 
					String boardNo = null;
					String urlPath = null;	
					
					// 부모 메뉴번호
					for(Map<String,Object> menuMap : boardList) {		
						items =  new MenuTreeVo();
						urlPath = EgovStringUtil.isNullToString(menuMap.get("url_path"));
						
						//게시판 형태가 Folder 일경우
						if(EgovStringUtil.isNullToString(menuMap.get("dir_form")).equals("F")){
							children = true;
							boardNo = EgovStringUtil.isNullToString(menuMap.get("dir_cd"));
						}
						
						//문서 > 업무분류 Root노드 임의값 Id=0 입력
						if(CommonUtil.getIntNvl(EgovStringUtil.isNullToString(menuMap.get("dir_lvl"))) == 0){
							boardNo = "0";
						}

						
						//게시판 형태가 category 일경우
						if(EgovStringUtil.isNullToString(menuMap.get("dir_form")).equals("C")){
							children = false;
							int seq = CommonUtil.getIntNvl(EgovStringUtil.isNullToString(menuMap.get("cat_seq_no")));
							//사내게시판 MenuNo + 카테고리 No 
							if(menuType.equals("doc")){
								boardNo = EgovStringUtil.isNullToString(menuMap.get("dir_cd"));
							}else{
								if(userSe.equals("MASTER")) {
									boardNo = String.valueOf(1501000000+seq);
								}
								else {
									boardNo = String.valueOf(501000000+seq);
								}
							}
							
							//api 마다 urlPath가 다르므로 조건 처리
							if(menuType.equals("edms") && userSe.equals("USER")){
								//사용자 게시판 메뉴
								urlPath = "/board/viewBoard.do?boardNo="+seq;
							}else if(menuType.equals("edms") && userSe.equals("ADMIN")){
								//관리자 게시판 관리 메뉴
								urlPath = "/admin/manageArt.do?cat_seq_no="+seq;
							}else if(menuType.equals("project") && (userSe.equals("ADMIN") || userSe.equals("MASTER"))) {
								//관리자 프로젝트 게시판 관리 메뉴
								urlPath = "/admin/manageProjectArt.do?cat_seq_no="+seq;
							} else if(menuType.equals("edms") && userSe.equals("MASTER")) {		// 포틀릿 설정시 사용 (2017.05.18 장지훈 추가)
								urlPath = "/admin/manageArt.do?cat_seq_no="+seq;
							}
						}
						
						Map<String, Object> state = new HashMap<String, Object>();
						
						name = EgovStringUtil.isNullToString(menuMap.get("dir_nm"));
						//게시판 카운트 표시여부 옵션 설정값
						String cntUseYn = "N";					
						
						if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500").equals("1")){
							if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1502").equals("1")){
								cntUseYn = "Y";
							}
						}
						
						if (boardCntYn.equals("Y") && EgovStringUtil.isNullToString(menuMap.get("dir_form")).equals("C") && !menuType.equals("doc") && cntUseYn.equals("Y")) {
							if(menuMap.get("close_yn") != null && menuMap.get("close_yn").toString().equals("Y")){
								String tag = "<span class=\"text_gray f11 mt5\">";
								name = tag + name +" ("+ menuMap.get("not_read_cnt") +"/" + menuMap.get("total_art_cnt") +")" + "</span>";
							}
							else {
								name = name +" ("+ menuMap.get("not_read_cnt") +"/" + menuMap.get("total_art_cnt") +")";
							}
						}
						else{
							if(menuMap.get("close_yn") != null && menuMap.get("close_yn").toString().equals("Y")){
								String tag = "<span class=\"text_gray f11 mt5\">";
								name = tag + name + "</span>";
							}
						}
						
						
						items.setId(boardNo);
						items.setText(name);
						items.setMenuGubun("MENU005");
						items.setUrlGubun("edms");
						items.setUrlPath(urlPath);
						items.setChildren(children);
						items.setExceptGubun(menuType);
						items.setLevel(CommonUtil.getIntNvl(EgovStringUtil.isNullToString(menuMap.get("dir_lvl"))));
						items.setState(state);
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}
					}
				}	
				
				// 즐겨찾기
				if(boardBookMarkList != null && boardBookMarkList.size() > 0) {
					String name = null;
					MenuTreeVo items = new MenuTreeVo ();	

					boolean children = false; 
					String boardNo = null;
					String urlPath = null;	
					
					// 부모 메뉴번호
					for(Map<String,Object> menuMap : boardBookMarkList) {		
						items =  new MenuTreeVo();
						
						urlPath = EgovStringUtil.isNullToString(menuMap.get("url_path"));
						
											//게시판 형태가 category 일경우
						if(EgovStringUtil.isNullToString(menuMap.get("dir_form")).equals("C")){
							children = false;
							int seq = CommonUtil.getIntNvl(EgovStringUtil.isNullToString(menuMap.get("cat_seq_no")));
							
							//api 마다 urlPath가 다르므로 조건 처리
							if(menuType.equals("bookMark") && userSe.equals("USER")){
								//사용자 게시판 메뉴
								urlPath = "/board/viewBoard.do?boardNo="+seq;
							}else if(menuType.equals("bookMark") && userSe.equals("ADMIN")){
								//관리자 게시판 관리 메뉴
								urlPath = "/admin/manageArt.do?cat_seq_no="+seq;
							}
						}
						
						name = EgovStringUtil.isNullToString(menuMap.get("dir_nm"));
						//게시판 카운트 표시여부 옵션 설정값
						String cntUseYn = "N";			
						
						Map<String, Object> state = new HashMap<String, Object>();
						
						if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1500").equals("1")){
							if(commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1502").equals("1")){
								cntUseYn = "Y";
							}
						}
						
						if (boardCntYn.equals("Y") && EgovStringUtil.isNullToString(menuMap.get("dir_form")).equals("C") && !menuType.equals("doc") && cntUseYn.equals("Y")) {
							if(menuMap.get("close_yn") != null && menuMap.get("close_yn").toString().equals("Y")){
								String tag = "<span class=\"text_gray f11 mt5\">";
								name = tag + name +" ("+ menuMap.get("not_read_cnt") +"/" + menuMap.get("total_art_cnt") +")" + "</span>";
							}
							else {
								name = name +" ("+ menuMap.get("not_read_cnt") +"/" + menuMap.get("total_art_cnt") +")";
							}
						}
						else{
							if(menuMap.get("close_yn") != null && menuMap.get("close_yn").toString().equals("Y")){
								String tag = "<span class=\"text_gray f11 mt5\">";
								name = tag + name + "</span>";
							}
						}
						
						
						items.setId(boardNo);
						items.setText(name);
						items.setMenuGubun("MENU005");
						items.setUrlGubun("edms");
						items.setUrlPath(urlPath);
						items.setChildren(children);
						items.setExceptGubun(menuType);
						items.setLevel(CommonUtil.getIntNvl(EgovStringUtil.isNullToString(menuMap.get("dir_lvl"))));
						items.setState(state);
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}
					}
				}
				
				
				
				if(kissMenuList != null && kissMenuList.size() >0){
					
					Map<String, Object> state = new HashMap<String, Object>();
					
					for(Map<String, Object> data : kissMenuList) {
						MenuTreeVo items = new MenuTreeVo ();
						items.setId(data.get("prjGroupSeq").toString());
						items.setText(data.get("prjGroupName").toString());
						items.setMenuGubun("MENU014");
						items.setUrlGubun("project");
						items.setUrlPath(data.get("menuUrl").toString());
						items.setChildren((boolean)data.get("hasSub"));
						items.setExceptGubun(menuType);
						items.setLevel(CommonUtil.getIntNvl(EgovStringUtil.isNullToString((Integer)data.get("prjGroupLevel") + 1)));
						items.setState(state);
						
						if(!items.getUrlPath().equals("") || items.isChildren()){
							jsTreeList.add(items);	
						}					
				    }
				}
					
			}
			
			jsonTreeList = JSONArray.fromObject(jsTreeList);				
		}
                
        return jsonTreeList;
    }
    
    public List<Map<String, Object>> callByMenuScheduleAPI(Map<String, Object> params, String apiUrl) {

    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser(); 
    	String action = "";
		String menuNo = params.get("upperMenuNo").toString();
		int level = Integer.parseInt(params.get("level").toString());
		
		if (level > Integer.MAX_VALUE || level < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }

		String calType = "";
		
		if(menuNo.equals("301030000")) {
			action = "/SearchScheduleMenuList";
			calType = "G";
		} else if(menuNo.equals("301040000")) {
			action = "/SearchScheduleMenuList";
			calType = "M";
		} else if(menuNo.equals("301050000")) {
			action = "/SearchScheduleMenuList";
			calType = "T";
		}
		else {
			action = "/SearchSchedulePrjMenuList";
			calType = "P";
		}
		
		apiUrl += action;
		
		String jsonParam = "{\"compSeq\":\"" + loginVO.getCompSeq() + "\","; 
		jsonParam += "\"deptSeq\":\"" + loginVO.getOrgnztId() + "\",";
		jsonParam += "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
		jsonParam += "\"langCode\":\"" + loginVO.getLangCode() + "\",";
		jsonParam += "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
		jsonParam += "\"calType\":\"" + calType + "\"}";

		JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
		HttpJsonUtil httpJson = new HttpJsonUtil();
		String jsonStr = httpJson.execute("POST", apiUrl, jsonObject2);		
		
		JSONObject retJsonObject = JSONObject.fromObject(JSONSerializer.toJSON(jsonStr));
		JSONArray menuList = (JSONArray)retJsonObject.get("result");
		 
	    JSONArray sortedJsonArray = new JSONArray();

	    List<JSONObject> jsonValues = new ArrayList<JSONObject>();
	    for (int i = 0; i < menuList.size(); i++) {
	        jsonValues.add(menuList.getJSONObject(i));
	    }
	    
	    if(calType.equals("P")) {
	    	Collections.sort( jsonValues, new Comparator<JSONObject>() {
		        @Override
		        public int compare(JSONObject a, JSONObject b) {
		            Integer valA = new Integer(a.get("level").toString());//new String();
		            Integer valB = new Integer(b.get("level").toString());////new String();

		            return valA.compareTo(valB);
		        }
		    });

		    for (int i = 0; i < menuList.size(); i++) {
		        sortedJsonArray.add(jsonValues.get(i));
		    }
	    }


		List<Map<String, Object>> apiData = new ArrayList<Map<String,Object>>();
		
		Map<String, Object> temp = null;
		boolean child = false;
			
		
		if(menuNo.equals("301030000") || menuNo.equals("301040000") || menuNo.equals("301050000")) {
			int seq = 0;
			for(int i=0; i<menuList.size(); i++) {
				temp = new HashMap<String, Object>();

				JSONObject json = JSONObject.fromObject(menuList.get(i));
				
				String newMenuNo = params.get("upperMenuNo").toString() + "_" + json.get("mcalSeq");
				
				temp.put("calTitle", json.get("calTitle"));
				temp.put("id", newMenuNo);
				temp.put("menuNo", newMenuNo);
				temp.put("menuGubun", "MENU003");
				if(json.get("urlPath") == null) {
					temp.put("urlPath", "");
				} else {
					temp.put("urlPath", json.get("urlPath"));
				}
				temp.put("exceptGubun", "");
				temp.put("menuType", "");
				temp.put("menuClass", "");
				temp.put("children", "");
				temp.put("ssoUseYn", "N");
				temp.put("level", 0);
				temp.put("scheduleSeq", "0");
				
				apiData.add(temp);
			}
		} else {
			String parentSum = "";
			String scheduleSeq = "";
			
			for(int j=0; j<sortedJsonArray.size(); j++) {
				JSONObject json = JSONObject.fromObject(sortedJsonArray.get(j));
				parentSum += "|"+json.get("parentSeq").toString()+"|";
						
			}
			
			Map tree = new HashMap<String, Map<String, Object>>();
			Map burffer = new HashMap<String, Map<String, Object>>();
			int seq = 0;
			for(int i=0; i<sortedJsonArray.size(); i++) {
				JSONObject jItem = JSONObject.fromObject(sortedJsonArray.get(i));
				Map<String, Object> node = new HashMap<String, Object>();
				scheduleSeq = jItem.get("Seq").toString();
				
				if(parentSum.indexOf("|" + scheduleSeq + "|") > -1) {
					child = true;
				} else {
					child = false;
				}
				
				if(jItem.get("projectGbn").equals("p")) {
					scheduleSeq = scheduleSeq + "_" + jItem.get("mcalSeq").toString();
				}
				
				node.put("calTitle", jItem.get("treeName").toString());
				node.put("id", scheduleSeq);
				node.put("menuNo", scheduleSeq);
				node.put("menuGubun", "MENU003");
				if(jItem.get("urlPath") == null) {
					node.put("children", child);
					node.put("urlPath", "");
					node.put("exceptGubun", "schedule");
				} else {
					node.put("children", child);
					node.put("exceptGubun", "");
					node.put("urlPath", jItem.get("urlPath"));
				}
				node.put("Seq", jItem.get("Seq"));
				node.put("parentSeq", jItem.get("parentSeq"));
				node.put("menuType", "prjSchedule");
				node.put("menuClass", "");
				node.put("ssoUseYn", "N");
				node.put("level", jItem.get("level").toString());
				node.put("scheduleSeq", jItem.get("Seq"));
				
				burffer.put(jItem.get("Seq"), node);
				
			}
			ArrayList<String> rootSeq = new ArrayList<String>();
			for(int i=sortedJsonArray.size()-1; i > -1; i--) {
				JSONObject jItem = JSONObject.fromObject(sortedJsonArray.get(i));
				Map<String, Object> node = new HashMap<String, Object>();
				String id = jItem.get("Seq").toString();
				Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
				
				node.put("Seq", bNode.get("Seq"));
				node.put("menuType", bNode.get("menuType"));
				node.put("menuClass", bNode.get("menuClass"));
				node.put("ssoUseYn", bNode.get("ssoUseYn"));
				node.put("level", bNode.get("level"));
				node.put("children", bNode.get("children"));
				//node.put("parentSeq", jItem.get("parentSeq"));
				node.put("parentSeq", bNode.get("parentSeq"));
				//node.put("id", jItem.get("id"));
				node.put("id", bNode.get("id"));
				//node.put("menuNo", jItem.get("menuNo"));
				node.put("menuNo", bNode.get("menuNo"));
				node.put("calTitle", bNode.get("calTitle"));
				node.put("menuGubun", bNode.get("menuGubun"));
				node.put("urlPath", bNode.get("urlPath"));
				node.put("exceptGubun", bNode.get("exceptGubun"));
				node.put("scheduleSeq", bNode.get("scheduleSeq"));

				if(bNode.get("level").toString().equals("1")&&(params.get("scheduleSeq").toString()).equals("0")) {
					apiData.add(node);
				}
				if(Integer.parseInt(bNode.get("level").toString()) == level + 1) {
					if(params.get("scheduleSeq").toString().equals(bNode.get("parentSeq").toString())){
						apiData.add(node);
					}
					
				}
				
			}
		}
		
    	return apiData;
    }
    
    public List<Map<String, Object>> callByBoardBookMarkAPI(Map<String, Object> params) {
    	/** 솔루션 게시판 목록 조회 API 호출 및 처리 */
		/** 게시판인지 판단하여 게시판정보 조회*/
		//String upperMenuNo = EgovStringUtil.isNullToString(params.get("upperMenuNo"));
		//int level =  CommonUtil.getIntNvl(EgovStringUtil.isNullToString(params.get("level")));
		
		JSONObject json = new JSONObject();
		List<Map<String, Object>> apiData = new ArrayList<Map<String,Object>>();
		
		//api 호출 파라미터 정리
		json.put("groupSeq", EgovStringUtil.isNullToString(params.get("groupSeq")));
		json.put("compSeq", EgovStringUtil.isNullToString(params.get("compSeq")));
		json.put("bizSeq", EgovStringUtil.isNullToString(params.get("bizSeq")));
		json.put("deptSeq", EgovStringUtil.isNullToString(params.get("deptSeq")));
		json.put("empSeq", EgovStringUtil.isNullToString(params.get("empSeq")));
		json.put("loginId", EgovStringUtil.isNullToString(params.get("id")));
		json.put("langCode", EgovStringUtil.isNullToString(params.get("langCode")));
		json.put("countYn", EgovStringUtil.isNullToString(params.get("countYn")));
		json.put("edmsUrl", EgovStringUtil.isNullToString(params.get("edmsUrl")));
		json.put("from",  EgovStringUtil.isNullToString(params.get("from")));
		json.put("dir_type",  EgovStringUtil.isNullToString(params.get("dir_type")));
		json.put("dir_group_no", EgovStringUtil.isNullToString(params.get("dir_group_no")) );
		
		
		HttpJsonUtil httpJson = new HttpJsonUtil();
		
		String apiUrl = params.get("edmsUrl") + "/edms/admin/getAdmBookmarkBoardList.do";
		
		if(EgovStringUtil.isNullToString(params.get("from")).equals("admin")) {
			apiUrl = params.get("edmsUrl") + "/edms/admin/getAdmBookmarkBoardList.do";
		} else if(EgovStringUtil.isNullToString(params.get("from")).equals("user")) {
			apiUrl = params.get("edmsUrl") + "/edms/board/getUserBookmarkBoardList.do";
		}
		
		String jsonStr = httpJson.execute("GET", apiUrl, json);
		
		ModelAndView mv = new ModelAndView();
		JSONObject boardBookMarkList = JSONObject.fromObject(JSONSerializer.toJSON(jsonStr.substring(1)));
		
		if(boardBookMarkList.get("resultCode").equals("0")) {
			if(!boardBookMarkList.get("result").toString().equals("{}")) {
				JSONArray boardBookMartArray = boardBookMarkList.getJSONArray("result");
				
				if(boardBookMartArray.size() > 0) {
					for(int i=0; i<boardBookMartArray.size(); i++) {
						JSONObject jItem = JSONObject.fromObject(boardBookMartArray.get(i));
						Map<String, Object> node = new HashMap<String, Object>();
						
						node.put("cat_seq_no", jItem.get("boardNo"));
						node.put("leaf_yn", "N");
						node.put("dir_form", "C");
						node.put("dir_nm", jItem.get("board_title"));
						node.put("close_yn", jItem.get("close_yn"));
						
						if(EgovStringUtil.isNullToString(params.get("from")).equals("user")) {
							node.put("not_read_cnt", jItem.get("not_read_cnt"));
							node.put("total_art_cnt", jItem.get("total_art_cnt"));
						}
						
						apiData.add(node);
					}
				}
			}
		}
		
    	return apiData;
    }
    
    public List<Map <String,Object>> callByMenuAPI(Map<String,Object> params , String menuType) {

    	/** 솔루션 게시판 목록 조회 API 호출 및 처리 */
		/** 게시판인지 판단하여 게시판정보 조회*/
		String upperMenuNo = EgovStringUtil.isNullToString(params.get("upperMenuNo"));
		int level =  CommonUtil.getIntNvl(EgovStringUtil.isNullToString(params.get("level")));
		
		Map<String,Object> apiParemeters = new HashMap<>();
		String apiUrl = "";
		String[] fileds = null;
		//api 호출 파라미터 정리
		apiParemeters.put("groupSeq", EgovStringUtil.isNullToString(params.get("groupSeq")));
		apiParemeters.put("compSeq", EgovStringUtil.isNullToString(params.get("compSeq")));
		apiParemeters.put("bizSeq", EgovStringUtil.isNullToString(params.get("bizSeq")));
		apiParemeters.put("deptSeq", EgovStringUtil.isNullToString(params.get("deptSeq")));
		apiParemeters.put("empSeq", EgovStringUtil.isNullToString(params.get("empSeq")));
		//apiParemeters.put("loginId", EgovStringUtil.isNullToString(params.get("id")));
		apiParemeters.put("langCode", EgovStringUtil.isNullToString(params.get("langCode")));
		apiParemeters.put("countYn", EgovStringUtil.isNullToString(params.get("countYn")));
		apiParemeters.put("edmsUrl", EgovStringUtil.isNullToString(params.get("edmsUrl")));
		apiParemeters.put("from",  EgovStringUtil.isNullToString(params.get("from")));
		apiParemeters.put("dir_type",  EgovStringUtil.isNullToString(params.get("dir_type")));
		apiParemeters.put("dir_group_no", EgovStringUtil.isNullToString(params.get("dir_group_no")) );
		
		//게시판 일 경우
		if(menuType.equals("edms")) {
			apiUrl = params.get("edmsUrl")+"/edms/board/boardDirList.do";
			fileds = new String[]{"dir_cd", "dir_nm", "dir_lvl", "close_yn", "dir_form", "total_art_cnt", "not_read_cnt", "leaf_yn","cat_seq_no"} ;
		//프로젝트 관리 게시판 일 경우
		}else if(menuType.equals("project")){
			apiUrl = params.get("edmsUrl")+"/edms/board/projBoardDirList.do";
			fileds = new String[]{"dir_cd", "dir_nm", "dir_lvl", "close_yn", "dir_form","leaf_yn","cat_seq_no"} ;
		//문서(전자결재) 카테고리별 문서관리 일 경우
		}else if(menuType.equals("eaCategory")){
			apiUrl = params.get("edmsUrl")+"/edms/doc/bpmDirList.do";
			fileds = new String[]{"dir_cd", "dir_nm", "dir_lvl", "dir_form","leaf_yn","cat_seq_no","url_path"} ;
		//문서 컨텐츠 그룹 일 경우
		}else if(menuType.equals("edmsContensGroup")){
			apiUrl = params.get("edmsUrl")+"/edms/doc/docContGrpList.do";
			fileds = new String[]{"dir_group_no", "dir_group_nm"} ;
			apiParemeters.put("resultType", "dirGroup" );
		}
		//문서 일 경우
		else if(menuType.equals("doc")){
			apiParemeters.put("resultType", EgovStringUtil.isNullToString(params.get("dir_rootNode")));			
			
			apiUrl = params.get("edmsUrl")+"/edms/doc/docDirList.do";
			fileds = new String[]{"dir_cd", "dir_nm", "dir_lvl", "dir_form","leaf_yn","url_path"} ;
		} else if(menuType.equals("bookMark")) {
			apiUrl = params.get("edmsUrl")+"/edms/admin/getAdmBookmarkBoardList.do";
			fileds = new String[]{"dir_cd", "dir_nm", "dir_lvl", "dir_form","leaf_yn","url_path"} ;
		}
		
		// 501000000 : 사내게시판 , 게시판관리   602010000 : 카테고리별 문서관리 601000000:문서관리  초기 파라미터값 셋팅
		if(upperMenuNo.equals("501000000") || upperMenuNo.equals("602010000") || upperMenuNo.equals("601000000") || upperMenuNo.equals("605000200") || upperMenuNo.equals("1605000200") || upperMenuNo.equals("2103000200") || upperMenuNo.equals("607010000") || upperMenuNo.equals("1501000000")) {
			//맨처음 게시판 1depth는 dir_cd Null값
			apiParemeters.put("dir_cd", "");
			apiParemeters.put("dir_lvl", level);
		}else{
			//rootNode 일경우
			if(upperMenuNo == "0"){
				apiParemeters.put("dir_cd", "");
			}
			level = level +1 ;
			if(menuType.equals("eaCategory") && level >= 2){
				level = ((int)(upperMenuNo.length() / 3)) + 1;
			}
			apiParemeters.put("dir_cd", upperMenuNo);
			apiParemeters.put("dir_lvl",level);
		}
		return menuManageService.callApiMenuList(apiParemeters,apiUrl,fileds);
    }
    
    
    
    
    public List<Map <String,Object>> callByKissApi(Map<String,Object> params) {
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		
		JSONObject jsonParam = new JSONObject();
		
		String apiUrl = params.get("apiUrl") + "/project/SearchProjectGroupMenu";
		
		header.put("groupSeq", loginVO.getGroupSeq());
		body.put("groupSeq", loginVO.getGroupSeq());
		body.put("langCode", loginVO.getLangCode());
		body.put("compSeq", loginVO.getOrganId());
		body.put("deptSeq", loginVO.getOrgnztId());
		body.put("empSeq", loginVO.getUniqId());
		body.put("prjGroupGbn", params.get("menuType").toString().equals("kissA") ? "A" : "G");
		body.put("prjGroupSeq", params.get("level").toString().equals("1") ? "" : params.get("upperMenuNo"));
		
		jsonParam.put("header", header);
		jsonParam.put("body", body);

		JSONObject resultJson = CommonUtil.getPostJSON(apiUrl, jsonParam.toString());
		
		List<Map <String,Object>> result = (List<Map<String, Object>>) resultJson.get("result");
    	
		return result;
    }
    
    
    
    @ResponseBody
    @RequestMapping("/cmm/system/getEdmsContetnsGroup.do")
    public Object getEdmsContetnsGroup(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	JSONArray jsonArray = null;
    	
    	if(loginVO != null) {
    		
    		String authCode = loginVO.getAuthorCode();
    		
    		String userSe = loginVO.getUserSe();
    		List<Map<String,Object>> edmsContentGroupList = new ArrayList<>();

    		if (!EgovStringUtil.isEmpty(authCode) || (!EgovStringUtil.isEmpty(userSe) && userSe.equals("ADMIN"))) {
    			
    			params.put("empSeq", loginVO.getUniqId());
    			params.put("compSeq", loginVO.getCompSeq());
    			params.put("groupSeq", loginVO.getGroupSeq());
    			params.put("bizSeq", loginVO.getBizSeq());
    			params.put("deptSeq", loginVO.getOrgnztId());
    			params.put("langCode", loginVO.getLangCode());
    			params.put("edmsUrl", CommonUtil.getApiCallDomain(request));
    			
    			edmsContentGroupList = callByMenuAPI(params,"edmsContensGroup");
    			
    			if(edmsContentGroupList != null && edmsContentGroupList.size() > 0) {
    				jsonArray = JSONArray.fromObject(edmsContentGroupList);	
    			}
    		}    		
    	}
    	
    	return jsonArray;
    }
    
    private Map<String, String> getHeadersInfo(HttpServletRequest request) {

        Map<String, String> map = new HashMap<String, String>();

        Enumeration headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String key = (String) headerNames.nextElement();
            String value = request.getHeader(key);
            map.put(key, value);
        }

        return map;
    }    
        
    @RequestMapping("/cmm/system/menuUseHistory.do")
    public ModelAndView menuUseHistory(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
        APIResponse response = new APIResponse();
        
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        if(loginVO == null){
            //세션이 만료되었을 경우 로그저장 
            String sRequestedSessionId = request.getRequestedSessionId();
            logger.error("[sessionInfo] there's no request session id : " + sRequestedSessionId + "headerInfo > " + getHeadersInfo(request).toString());
            mv.addObject("sessionYn","N");
            return mv;
        }else{
            mv.addObject("sessionYn","Y");
        }
        
        if(request.getSession().getAttribute("masterLogon") == null || !request.getSession().getAttribute("masterLogon").toString().equals("Y")){
            params.put("empSeq", loginVO.getUniqId());
            params.put("empName", loginVO.getName());
            params.put("menuAuth", loginVO.getUserSe());
            params.put("menuName", params.get("menuNm"));
            params.put("accessIp", loginVO.getIp());

            params.put("groupSeq", loginVO.getGroupSeq());
            params.put("loginId", loginVO.getId());
            params.put("langCode", loginVO.getLangCode());
            params.put("typeCode", "0");
            
            String now = DateHelper.convertDateToString(Calendar.getInstance().getTime(), FormatConstants.FORMAT_DATE_TIME);
            params.put("useDate", now);
            
            // DB에 먼저 저장후 Elasticsearch에 스케쥴로 insert bulk를 위한 코드
            try{
                commonSql.insert("MenuAccess.insertMenuAccessSync", params);
            }catch(Exception e){
                response.setResultCode(CommonConstants.API_RESPONSE_FAIL);
                response.setResultMessage(e.getMessage());
                logger.error("/menuUseHistory.do ERROR : " + JSONObject.fromObject(response).toString());
            }
            
            // Elasticsearch 바로 insert
//            try{
//                response = menuAccessService.saveMenuAccessList(params);
//            }catch(Exception e){
//                response.setResultCode(CommonConstants.API_RESPONSE_FAIL);
//                response.setResultMessage(e.getMessage());
//                logger.error("/menuUseHistory.do ERROR : " + JSONObject.fromObject(response).toString());
//            }
        }
        
        logger.debug("/menuUseHistory.do Response: " + JSONObject.fromObject(response).toString());
        
        return mv;
    }
    
    
    public static String phoneFormat(String phoneNo){
		  
		   if (phoneNo.length() == 0){
		    return phoneNo;
		      }
		   
		      String strTel = phoneNo;
		      String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
		                           "051", "052", "053", "054", "055", "061", "062",
		                           "063", "064", "010", "011", "012", "013", "015",
		                           "016", "017", "018", "019", "070", "050"};
		      
		      if (strTel.length() < 9) {
		          return strTel;
		      } else if (strTel.substring(0,2).equals(strDDD[0])) {
		          strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
		               + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else if(strTel.substring(0, 3).equals(strDDD[26])){
		    	  strTel = strTel.substring(0,4) + '-' + strTel.substring(4, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else {
		          for(int i=1; i < strDDD.length; i++) {
		              if (strTel.substring(0,3).equals(strDDD[i])) {
		                  strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		              }
		          }
		      }
		      return strTel;
		 }
    
    public String base64Encode(String str) throws UnsupportedEncodingException {
		byte[] encode = Base64.encodeBase64(str.getBytes());
				
		return new String(encode, "UTF-8");
	}
    
    
    @SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/cmm/system/getMenuList.do")
    public Object getMenuList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
    	Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do params : " + params );    
    	
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do loginVO : " + loginVO);
		Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do sessionId : " + request.getSession().getId());
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		if(loginVO == null) {			
			Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do loginVO IS NULL");
			return returnList;
		}
		
		
		//조회기준 rootID
		String rootId = getRootId((String)params.get("module"));
		rootId = rootId == null ? "" : rootId;
		Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do rootId : " + rootId );  
		
		if(getMenuGbn(rootId).equals("")) {
			Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do rootId IS EMPTY");
			return returnList;
		}
		
		//rootID기준 module값 셋팅
		String module = getModule(rootId);
		if(module.equals("")) {
			Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do module IS EMPTY");
			return returnList;
		}
		
		String serverName = CommonUtil.getApiCallDomain(request);
		String subUrl = "/api/getMenuTreeList.do";
		String apiUrl = ""; 	
		
		//모듈별 공통 메뉴리스트 조회 파라미터 셋팅
		JSONObject jsonObject = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();

		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("tId", "");
		header.put("pId", "");
		
		body.put("compSeq", loginVO.getOrganId());
		body.put("bizSeq", loginVO.getBizSeq());
		body.put("deptSeq", loginVO.getOrgnztId());
		body.put("empSeq", loginVO.getUniqId());
		body.put("userSe", loginVO.getUserSe());
		body.put("langCode", loginVO.getLangCode());
		body.put("compMailDomain", loginVO.getEmailDomain());
		body.put("rootId", "");
		body.put("keyword", "");
		
		jsonObject.put("header", header);
		jsonObject.put("body", body);			
		
		//그룹웨어 패키지 메뉴 리스트 조회
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getOrganId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", loginVO.getUserSe());
		params.put("langCode", loginVO.getLangCode());
		params.put("authCodeList", loginVO.getAuthorCode().split("#"));
		
		Map<String, Object> groupMap = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
		List<Map<String, Object>> menuList = new ArrayList<Map<String, Object>>();
		
		try {
			if(getMenuGbn(rootId).equals("schedule")) {
				ObjectMapper om = new ObjectMapper();
				int cnt = 1;
				
				//일정
				body.put("rootId", "");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/schedule" + subUrl;
				JSONObject schJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> schMap = om.readValue(schJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> scheMenuList = (List<Map<String, Object>>) schMap.get("result");
				
				Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do myScheMenuList : " + scheMenuList);
				
				for(Map<String, Object> map : scheMenuList) {
					if(map.get("calType").toString().equals("E")) {
						map.put("parentId", "301030000");
						map.put("orderNum", Integer.toString(301030000 + cnt));
						cnt ++;
					}else if(map.get("calType").toString().equals("M")) {
						map.put("parentId", "301040000");
						map.put("orderNum", Integer.toString(301030000 + cnt));
						cnt ++;
					}else if(map.get("calType").toString().equals("P")) {
						map.put("parentId", "390000000");
						map.put("orderNum", Integer.toString(301030000 + cnt));
						cnt ++;
					}
				}
				
				//그룹웨어 패키지 메뉴 조회
				params.put("menuGubun", "MENU003");
				params.put("module", "schedule");
				List<Map<String, Object>> gwPkgMenuList = commonSql.list("MenuManageDAO.getGwPkgMenuList", params);		
				
				Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do gwPkgMenuList : " + gwPkgMenuList);
				
				menuList.addAll(gwPkgMenuList);
				menuList.addAll(scheMenuList);
				
			}else if(getMenuGbn(rootId).equals("edms")) {
				
				//게시판
				int cnt = 1;
				ObjectMapper om = new ObjectMapper();
				body.put("rootId", "501000000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/edms" + subUrl;
				JSONObject edmsJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> eapMap = om.readValue(edmsJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> edmsMenuList = (List<Map<String, Object>>) eapMap.get("result");
				
				Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do edmsMenuList : " + edmsMenuList);
				
				for(Map<String, Object> map : edmsMenuList) {
					if(map.get("parentId").toString().equals("")) {
						map.put("parentId", "501000000");
					}
					if(map.get("urlPath") != null && !map.get("urlPath").toString().equals("")) {
						map.put("urlPath", map.get("urlPath").toString().substring(map.get("urlPath").toString().indexOf("/edms/")));
					}
					map.put("orderNum", Integer.toString(501000000 + cnt));
					cnt ++;
				}
				
				//그룹웨어 패키지 메뉴 조회
				params.put("menuGubun", "MENU005");
				params.put("module", "edms");
				List<Map<String, Object>> gwPkgMenuList = commonSql.list("MenuManageDAO.getGwPkgMenuList", params);
				
				menuList.addAll(edmsMenuList);
				menuList.addAll(gwPkgMenuList);
				
			}else if(getMenuGbn(rootId).equals("doc")) {
				//문서(일반문서)
				int cnt = 1;
				ObjectMapper om = new ObjectMapper();
				body.put("rootId", "601000000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/edms" + subUrl;
				JSONObject docJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> docMap = om.readValue(docJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> docMenuList = (List<Map<String, Object>>) docMap.get("result");
				
				Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do edmsMenuList : " + docMenuList);
				
				for(Map<String, Object> map : docMenuList) {
					if(map.get("parentId").toString().equals("")) {
						map.put("parentId", "601000000");
					}
					if(map.get("urlPath") != null && !map.get("urlPath").toString().equals("")) {
						map.put("urlPath", map.get("urlPath").toString().substring(map.get("urlPath").toString().indexOf("/edms/")));
					}
					map.put("orderNum", Integer.toString(601000000 + cnt));
					cnt ++;
				}
				
				
				//문서(결재문서)
				cnt = 1;
				om = new ObjectMapper();
				body.put("rootId", "607010000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/edms" + subUrl;
				JSONObject docEaJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> docEaMap = om.readValue(docEaJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> docEaMenuList = (List<Map<String, Object>>) docEaMap.get("result");
				
				Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do edmsMenuList : " + docEaMenuList);
				
				for(Map<String, Object> map : docEaMenuList) {
					if(map.get("parentId").toString().equals("")) {
						map.put("parentId", "607010000");
					}
					if(map.get("urlPath") != null && !map.get("urlPath").toString().equals("")) {
						map.put("urlPath", map.get("urlPath").toString().substring(map.get("urlPath").toString().indexOf("/edms/")));
					}
					map.put("orderNum", Integer.toString(607010000 + cnt));
					cnt ++;
				}
				
				//그룹웨어 패키지 메뉴 조회
				params.put("menuGubun", "MENU006");
				params.put("module", "edms");
				List<Map<String, Object>> gwPkgMenuList = commonSql.list("MenuManageDAO.getGwPkgMenuList", params);
				
				menuList.addAll(docMenuList);
				menuList.addAll(docEaMenuList);
				menuList.addAll(gwPkgMenuList);
				
			}else if(getMenuGbn(rootId).equals("eap")) {
				//결재(영리)		
				ObjectMapper om = new ObjectMapper();
				body.put("rootId", "2002000000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/eap" + subUrl;
				JSONObject eapJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> eapMap = om.readValue(eapJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> eapMenuList = (List<Map<String, Object>>) eapMap.get("result");
			
				for(Map<String, Object> map : eapMenuList) {
					if(!map.get("urlPath").toString().equals("")) {
						map.put("urlPath", "/eap" + map.get("urlPath") + "?menu_no=" + map.get("id"));
					}
				}
				
				//그룹웨어 패키지 메뉴 조회
				params.put("menuGubun", "MENU010");
				params.put("module", "eap");
				List<Map<String, Object>> gwPkgMenuList = commonSql.list("MenuManageDAO.getGwPkgMenuList", params);	
				
				menuList.addAll(eapMenuList);
				menuList.addAll(gwPkgMenuList);
			}else if(getMenuGbn(rootId).equals("mail")) {
				//메일
				body.put("rootId", "301050000");
				jsonObject.put("body", body);	
				
				apiUrl = groupMap.get("mailUrl") + "getMenuTreeList.do";
				JSONObject subJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				
				ObjectMapper om = new ObjectMapper();
				Map<String, Object> subMap = om.readValue(subJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> mailMenuList = (List<Map<String, Object>>) ((Map<String, Object>) subMap.get("result")).get("mailBoxList");
				for(Map<String, Object> mp : mailMenuList) {
					if(mp.get("parentId") != null && Integer.parseInt(mp.get("parentId").toString()) == 0) {
						mp.put("parentId", "");
					}
					if(!mp.get("urlPath").toString().equals("")) {
						mp.put("urlPath", "/" + mp.get("urlPath"));
					}
				}
				menuList.addAll(mailMenuList);
				
				//수신확인 url 추가조회
				try {
					String mailUrl = groupMap.get("mailUrl") + "mailBoxListApi.do";
					
					JSONObject json = new JSONObject();
					json.put("id", loginVO.getEmail());
					json.put("domain", loginVO.getEmailDomain());
					HttpJsonUtil httpJson = new HttpJsonUtil();
					String result = httpJson.execute("GET", mailUrl, json);
					
					JSONObject resultJson = JSONObject.fromObject(JSONSerializer.toJSON(result));
					
					List<Map<String,Object>> list = (List<Map<String, Object>>) resultJson.get("mailboxList");
					
					for(Map<String, Object> mp : list) {
						if(mp.get("name").toString().equals("SENT")) {
							Map<String, Object> node = new HashMap<String, Object>();
							node.put("id", mp.get("mboxSeq") + "_SENT");
							
							node.put("parentId", "");
							node.put("text", BizboxAMessage.getMessage("TX000021862","수신확인함"));
							node.put("level", "1");
							node.put("count", "0");
							node.put("urlGubun", "200000000");
							node.put("orderNum", "999");
							node.put("children", false);
							node.put("urlPath", "/mail2/mailListViewApi.do?mboxSeq=" + mp.get("mboxSeq") + "&mboxName=RECEIPT");
						
							menuList.add(node);
							
							break;
						}
					}
				}catch(Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}else if(getMenuGbn(rootId).equals("project")) {				
				//그룹웨어 패키지 메뉴 조회
				params.put("menuGubun", "MENU004");
				params.put("module", "project");
				List<Map<String, Object>> gwPkgMenuList = commonSql.list("MenuManageDAO.getGwPkgMenuList", params);	
				menuList.addAll(gwPkgMenuList);
			}
			
			Map tree = new HashMap<String, Map<String, Object>>();
			Map burffer = new HashMap<String, Map<String, Object>>();
			
			//메뉴리스트 정렬처리(ordernum 내림차순)
			Collections.sort(menuList, mapComparator);
			
			//메뉴리스트 node 생성.
			for (Map<String, Object> item : menuList) {
	
				Map<String, Object> node = new HashMap<String, Object>();
				String text = item.get("text") == null ? "" : item.get("text").toString();
				
				// 여기 구분 값이 필요함.
				node.put("id", item.get("id").toString());
				node.put("name",text);
				node.put("url", (String)item.get("urlPath"));
				node.put("url2", null);
				node.put("module", module);			
				node.put("frame", true);
				node.put("children", null);
				if(node.get("url") == null || node.get("url").toString().equals("") ) {
					node.put("cd_type", "MEM");
					node.put("type", "folder");
				}else {
					node.put("cd_type", "PAG");
					node.put("type", "page");
				}
	
				burffer.put(item.get("id").toString(), node);
			}		
			
			//하위메뉴(children) 데이터 셋팅
			ArrayList<String> arrList = new ArrayList<>();
			for (int i = menuList.size() - 1; i > -1; i--) {
				
				Map<String, Object> item = menuList.get(i);
				Map<String, Object> node = new HashMap<String, Object>();
				String id = item.get("id").toString();
				Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
				
				node.put("id", bNode.get("id"));
				node.put("name", bNode.get("name"));
				node.put("url", bNode.get("url"));
				node.put("url2", bNode.get("url2"));
				node.put("module", bNode.get("module"));			
				node.put("frame", bNode.get("frame"));
				node.put("children", bNode.get("children"));
				node.put("cd_type", bNode.get("cd_type"));
				node.put("type", bNode.get("type"));
				
				if (item.get("parentId") == null || item.get("parentId").toString().equals("")) {
					tree.put(node.get("id"), burffer.get(id));
					arrList.add(0,item.get("id").toString());
				} else { 
					try{
						if((Map<String, Object>) burffer.get(item.get("parentId")) != null){
							if(((Map<String, Object>) burffer.get(item.get("parentId"))).get("children") == null ) {
								((Map<String, Object>) burffer.get(item.get("parentId"))).put("children", new ArrayList<Map<String, Object>>());
							}
							
							((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parentId"))).get("children")).add(0,node);
						}
					}catch(Exception e){
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}
				}
			}
			
			for (String item : arrList) {
				returnList.add((Map<String, Object>) tree.get(item));
			}
		}catch(Exception e) {
			Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.getMenuList.do Exception : " + e.getMessage() );
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			returnList.clear(); 
		}          
        return returnList;
    }
    
    public String getMenuGbn(String no) {    
    	//301030000 : 개인일정 
		//301040000 : 공유일정 
		//301050000 : 구독일정
		//390000000 : 프로젝트일정
    	//501000000 : 사내게시판(사용자)
		//507000000 : 즐겨찾기(사용자)
		//501000000 : 게시판 글 관리(관리자)
		//505000000 : 프로젝트 게시판 글 관리(관리자)
		//1501000000 : 게시판 글 관리(마스터)
		//1505000000 : 프로젝트 게시판 글 관리(마스터)   
    	//601000000 : 일반문서
		//607010000 : 결재문서
		//605000200 : 결재문서관리(관리자)
		//1605000200 : 결재문서관리(마스터)
    	//2002000000 : 결재문서
    	
    	
    	String gbnCode = "";
    	no = (no == null ? "" : no);
    	if(no.equals("2000000000")) {
    		gbnCode = "eap";
    	}
    	else if(no.equals("300000000")) {
    		gbnCode = "schedule";
    	}	    	
    	else if(no.equals("200000000")) {
    		gbnCode = "mail";
    	}
    	else if(no.equals("501000000")) {
    		gbnCode = "edms";
    	}
    	else if(no.equals("600000000")) {
    		gbnCode = "doc";
    	}
    	else if(no.equals("400000000")) {
    		gbnCode = "project";
    	}
    	return gbnCode;
    }
    
    
    public String getModule(String no) {   
    	String module = "";
    	no = (no == null ? "" : no);
    	if(no.equals("2000000000")) {
    		module = "EA";
    	}
    	else if(no.equals("300000000")) {
    		module = "CL";
    	}    	
    	else if(no.equals("200000000")) {
    		module = "ML";
    	}  
    	else if(no.equals("501000000")) {
    		module = "BD";
    	} 
    	else if(no.equals("600000000")) {
    		module = "DC";
    	} 
    	else if(no.equals("400000000")) {
    		module = "PR";
    	} 
    	return module;
    }
    
    public String getRootId(String module) {
    	String rootId = "";    	
    	if(module.equals("EA")) {
    		rootId = "2000000000";
    	}else if(module.equals("CL")) {
    		rootId = "300000000";
    	}else if(module.equals("ML")) {
    		rootId = "200000000";
    	}else if(module.equals("BD")) {
    		rootId = "501000000";
    	}else if(module.equals("DC")) {
    		rootId = "600000000";
    	}else if(module.equals("PR")) {
    		rootId = "400000000";
    	}     	
    	return rootId;
    }
    

    public Comparator<Map<String, Object>> mapComparator = new Comparator<Map<String, Object>>() {
        public int compare(Map<String, Object> m1, Map<String, Object> m2) {
            return m1.get("orderNum").toString().compareTo(m2.get("orderNum").toString());
        }
    };
    
    
    
    //ebp전용 메뉴검색 api
    @SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/cmm/system/searchMenuList.do")
    public Object searchMenuList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception
    {
    	Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do params : " + params );    
    	Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do sessionId : " + request.getSession().getId());
    	
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String, Object>> menuList = new ArrayList<Map<String, Object>>();		
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		if(loginVO == null) {
			Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do loginVO IS NULL");
			return returnList;
		}
		
		String module = CommonUtil.isEmptyStr(params.get("module")) ? "" : params.get("module").toString();
		String keyword = CommonUtil.isEmptyStr(params.get("keyword")) ? "" : params.get("keyword").toString();
		
		String serverName = CommonUtil.getApiCallDomain(request);
		String subUrl = "/api/getMenuTreeList.do";
		String apiUrl = ""; 	
		
		//모듈별 공통 메뉴리스트 조회 파라미터 셋팅
		JSONObject jsonObject = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();

		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("tId", "");
		header.put("pId", "");
		
		body.put("compSeq", loginVO.getOrganId());
		body.put("bizSeq", loginVO.getBizSeq());
		body.put("deptSeq", loginVO.getOrgnztId());
		body.put("empSeq", loginVO.getUniqId());
		body.put("userSe", loginVO.getUserSe());
		body.put("langCode", loginVO.getLangCode());
		body.put("compMailDomain", loginVO.getEmailDomain());
		body.put("rootId", "");
		body.put("keyword", keyword);
		
		jsonObject.put("header", header);
		jsonObject.put("body", body);
		
		
		
		//그룹웨어 패키지 메뉴 리스트 조회
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getOrganId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", loginVO.getUserSe());
		params.put("langCode", loginVO.getLangCode());
		params.put("authCodeList", loginVO.getAuthorCode().split("#"));
		params.put("keyword", keyword);
		
		Map<String, Object> groupMap = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
		
		if(module.equals("") || module.equals("GW")) {
			List<Map<String, Object>> gwPkgMenuList = new ArrayList<Map<String, Object>>();
			
			//그룹웨어 패키지 메뉴 
			try {
				gwPkgMenuList = commonSql.list("MenuManageDAO.searchGwPkgMenuList", params);	
				menuList.addAll(gwPkgMenuList);
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.getMenuList.do gwPkgMenuList ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				gwPkgMenuList.clear();
			}
		}
		
		if(module.equals("") || module.equals("PR")) {
			List<Map<String, Object>> gwPkgMenuList = new ArrayList<Map<String, Object>>();
			
			//그룹웨어 패키지 메뉴(업무관리) 
			try {
				params.put("menuGubun", "MENU004");
				gwPkgMenuList = commonSql.list("MenuManageDAO.searchGwPkgMenuList", params);	
				menuList.addAll(gwPkgMenuList);
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.getMenuList.do gwPkgMenuList ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				gwPkgMenuList.clear();
			}
		}
		
		if(module.equals("") || module.equals("BD")) {
			//게시판 api메뉴				
			body.put("rootId", "501000000");
			jsonObject.put("body", body);	
			apiUrl = serverName + "/edms" + subUrl;
			menuList.addAll(searchMenuList("BD", jsonObject, apiUrl, loginVO));
		}
		
		if(module.equals("") || module.equals("DC1")) {
			//문서(일반문서) api메뉴
			body.put("rootId", "601000000");
			jsonObject.put("body", body);	
			apiUrl = serverName + "/edms" + subUrl;
			menuList.addAll(searchMenuList("DC1", jsonObject, apiUrl, loginVO));
		}
		
		if(module.equals("") || module.equals("DC2")) {
			//문서(결재문서) api메뉴
			body.put("rootId", "607010000");
			jsonObject.put("body", body);	
			apiUrl = serverName + "/edms" + subUrl;
			menuList.addAll(searchMenuList("DC2", jsonObject, apiUrl, loginVO));
		}
		
		if(module.equals("") || module.equals("EA")) {
			//결재 api메뉴
			body.put("rootId", "2002000000");
			jsonObject.put("body", body);	
			apiUrl = serverName + "/eap" + subUrl;
			menuList.addAll(searchMenuList("EA", jsonObject, apiUrl, loginVO));
		}
		
		if(module.equals("") || module.equals("CL")) {
			//일정 api메뉴
			body.put("rootId", "");
			jsonObject.put("body", body);	
			apiUrl = serverName + "/schedule" + subUrl;
			menuList.addAll(searchMenuList("CL", jsonObject, apiUrl, loginVO));
		}

		if(module.equals("") || module.equals("ML")) {
			//메일 api메뉴
			body.put("rootId", "200000000");
			jsonObject.put("body", body);	
			apiUrl = groupMap.get("mailUrl") + "searchMenuTreeList.do";
			menuList.addAll(searchMenuList("ML", jsonObject, apiUrl, loginVO));
		}
		
		returnList.addAll(menuList);
		
        return returnList;
    }
    
    
    @SuppressWarnings("unchecked")
	public List<Map<String, Object>> searchMenuList(String module, JSONObject json, String apiUrl, LoginVO loginVO) throws JsonParseException, JsonMappingException, IOException{
    	
    	List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();    	
		ObjectMapper om = new ObjectMapper();
		
		JSONObject body = (JSONObject) json.get("body");
		String keyword = (String) body.get("keyword");
		
    	if(module.equals("BD")) {
    		try {
	    		//게시판 api메뉴				
				JSONObject edmsJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				Map<String, Object> edmsMap = om.readValue(edmsJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> edmsMenuList = (List<Map<String, Object>>) edmsMap.get("result");
				
				for(Map<String, Object> mp : edmsMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						menuMap.put("id", mp.get("id"));
						menuMap.put("name", mp.get("text"));
						menuMap.put("url", mp.get("urlPath").toString().substring(mp.get("urlPath").toString().indexOf("/edms/")));
						menuMap.put("module", "BD");
						menuMap.put("frame", true);
						menuMap.put("path", BizboxAMessage.getMessage( "TX000010142", "사내게시판") + ">" + mp.get("pathName"));
						menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000011134", "게시판"));	
						
						result.add(menuMap);
					}
				}
    		}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList BD ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    	}else if(module.equals("DC1")) {
    		try {
				//문서(일반문서) api메뉴
				JSONObject docJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				Map<String, Object> docMap = om.readValue(docJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> docMenuList = (List<Map<String, Object>>) docMap.get("result");
				
				for(Map<String, Object> mp : docMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						menuMap.put("id", mp.get("id"));
						menuMap.put("name", mp.get("text"));
						menuMap.put("url", mp.get("urlPath").toString().substring(mp.get("urlPath").toString().indexOf("/edms/")));
						menuMap.put("module", "DC");
						menuMap.put("frame", true);
						menuMap.put("path", BizboxAMessage.getMessage( "TX000008828", "일반문서") + ">" + mp.get("pathName"));
						menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000018123", "문서"));	
						
						result.add(menuMap);
					}
				}
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList DC1 ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    	}else if(module.equals("DC2")) {
    		try {
				//문서(결재문서) api메뉴
				JSONObject docEaJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				Map<String, Object> docEaMap = om.readValue(docEaJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> docEaMenuList = (List<Map<String, Object>>) docEaMap.get("result");
				
				for(Map<String, Object> mp : docEaMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						menuMap.put("id", mp.get("id"));
						menuMap.put("name", mp.get("text"));
						menuMap.put("url", mp.get("urlPath").toString().substring(mp.get("urlPath").toString().indexOf("/edms/")));
						menuMap.put("module", "DC");
						menuMap.put("frame", true);
						menuMap.put("path", BizboxAMessage.getMessage( "TX000006385", "결재문서") + ">" + mp.get("pathName"));
						menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000018123", "문서"));	
						
						result.add(menuMap);
					}
				}
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList DC2 ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    	}else if(module.equals("EA")) {
    		try {
				//결재 api메뉴
				JSONObject eapJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				Map<String, Object> eapMap = om.readValue(eapJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> eapMenuList = (List<Map<String, Object>>) eapMap.get("result");
				
				for(Map<String, Object> mp : eapMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						if(mp.get("text").toString().indexOf(keyword) != -1) {
							menuMap.put("id", mp.get("id"));
							menuMap.put("name", mp.get("text"));
							menuMap.put("url", "/eap" + mp.get("urlPath") + "?menu_no=" + mp.get("id"));
							menuMap.put("module", "EA");
							menuMap.put("frame", true);
							menuMap.put("path", BizboxAMessage.getMessage( "TX000006385", "결재문서") + ">" + mp.get("text"));
							menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000000479", "전자결재"));	
							
							result.add(menuMap);
						}
					}
				}
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList EA ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    	}else if(module.equals("CL")) {
    		try {
				//일정 api메뉴
				JSONObject schJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				Map<String, Object> schMap = om.readValue(schJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> schMenuList = (List<Map<String, Object>>) schMap.get("result");
				for(Map<String, Object> mp : schMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						if(mp.get("text").toString().indexOf(keyword) != -1) {
							menuMap.put("id", mp.get("id"));
							menuMap.put("name", mp.get("text"));
							menuMap.put("url", mp.get("urlPath"));
							menuMap.put("module", "CL");
							menuMap.put("frame", true);
							if(mp.get("calType").toString().equals("E")) {
								menuMap.put("path", BizboxAMessage.getMessage( "TX000005550", "일정관리") + ">" + BizboxAMessage.getMessage( "TX000004103", "개인일정") + ">" + mp.get("text"));}
							else if(mp.get("calType").toString().equals("M")) {
								menuMap.put("path", BizboxAMessage.getMessage( "TX000005550", "일정관리") + ">" + BizboxAMessage.getMessage( "TX000010163", "공유일정") + ">" + mp.get("text"));}
							else if(mp.get("calType").toString().equals("P")) {
								menuMap.put("path", BizboxAMessage.getMessage( "TX000010152", "프로젝트일정") + ">" + mp.get("text"));}
							
							
							menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000000483", "일정"));	
							
							result.add(menuMap);
						}
					}
				}
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList CL ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    	}else if(module.equals("ML")) {
    		try {
				//메일 api메뉴
				JSONObject mailJson = CommonUtil.getPostJSON(apiUrl, json.toString());
				
				om = new ObjectMapper();
				Map<String, Object> mailMap = om.readValue(mailJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> mailMenuList = (List<Map<String, Object>>) ((Map<String, Object>) mailMap.get("result")).get("mailBoxList");
				
				for(Map<String, Object> mp : mailMenuList) {
					Map<String, Object> menuMap = new HashMap<String, Object>();
					
					if(mp.get("urlPath") != null && !mp.get("urlPath").toString().equals("")) {
						if(mp.get("text").toString().indexOf(keyword) != -1) {
							menuMap.put("id", mp.get("id"));
							menuMap.put("name", mp.get("text"));
							menuMap.put("url", "/" + mp.get("urlPath"));
							menuMap.put("module", "ML");
							menuMap.put("frame", true);
							menuMap.put("path", mp.get("text"));
	
							menuMap.put("moduleName", BizboxAMessage.getMessage( "TX000000262", "메일"));	
							
							result.add(menuMap);
						}
					}
				}
			}catch(Exception e) {
				Logger.getLogger( MenuTreeContoroller.class ).error( "MenuTreeContoroller.searchMenuList ML ERROR");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.clear();
			}
    		
    		if(BizboxAMessage.getMessage("TX000021862","수신확인함").indexOf(keyword) != -1) {
	    		//수신확인 url 추가조회
				try {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("groupSeq", loginVO.getGroupSeq());
					Map<String, Object> groupMap = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
					
					String mailUrl = groupMap.get("mailUrl") + "mailBoxListApi.do";
					
					JSONObject jsonParam = new JSONObject();
					jsonParam.put("id", loginVO.getEmail());
					jsonParam.put("domain", loginVO.getEmailDomain());
					HttpJsonUtil httpJson = new HttpJsonUtil();
					String resultStr = httpJson.execute("GET", mailUrl, jsonParam);
					
					JSONObject resultJson = JSONObject.fromObject(JSONSerializer.toJSON(resultStr));
					
					List<Map<String,Object>> list = (List<Map<String, Object>>) resultJson.get("mailboxList");
					
					for(Map<String, Object> mp : list) {
						if(mp.get("name").toString().equals("SENT")) {
							Map<String, Object> node = new HashMap<String, Object>();
							node.put("id", mp.get("mboxSeq") + "_SENT");
							node.put("name", BizboxAMessage.getMessage("TX000021862","수신확인함"));
							node.put("url", "/mail2/mailListViewApi.do?mboxSeq=" + mp.get("mboxSeq") + "&mboxName=RECEIPT");
							node.put("module", "ML");
							node.put("frame", true);
							node.put("path", BizboxAMessage.getMessage("TX000021862","수신확인함"));
							node.put("moduleName", BizboxAMessage.getMessage( "TX000000262", "메일"));	
							result.add(node);
							break;
						}
					}
				}catch(Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
    		}
    	}
    	
    	
    	
    	return result;
    }
    
    
    
  //ebp전용 메뉴뱃지 카운트 api
    @SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/cmm/system/getMenubadgeCount.do")
    public Object getMenubadgeCount(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		String module = params.get("module") == null ? "" : (String)params.get("module");
		String menu = params.get("menu") == null ? "" : (String)params.get("menu");
		
		if(loginVO == null) {
			Logger.getLogger( MenuTreeContoroller.class ).debug( "MenuTreeContoroller.getMenuList.do loginVO IS NULL");
			return returnList;
		}
		
		String serverName = CommonUtil.getApiCallDomain(request);
		String subUrl = "/api/getMenuTreeList.do";
		String apiUrl = ""; 
    	
		//모듈별 공통 메뉴리스트 조회 파라미터 셋팅
		JSONObject jsonObject = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();

		
		header.put("groupSeq", loginVO.getGroupSeq());
		header.put("tId", "");
		header.put("pId", "");
		
		body.put("compSeq", loginVO.getOrganId());
		body.put("bizSeq", loginVO.getBizSeq());
		body.put("deptSeq", loginVO.getOrgnztId());
		body.put("empSeq", loginVO.getUniqId());
		body.put("userSe", loginVO.getUserSe());
		body.put("langCode", loginVO.getLangCode());
		body.put("compMailDomain", loginVO.getEmailDomain());
		body.put("rootId", "");
		body.put("keyword", "");
		
		jsonObject.put("header", header);
		jsonObject.put("body", body);
		
		
		//그룹웨어 그룹정보 조회
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> groupMap = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", params);
		
		try {
		
			if(module.equals("EA") || module.equals("")) {
				//결재(영리)		
				ObjectMapper om = new ObjectMapper();
				body.put("rootId", "2002000000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/eap" + subUrl;
				JSONObject eapJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> eapMap = om.readValue(eapJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> eapMenuList = (List<Map<String, Object>>) eapMap.get("result");
			
				for(Map<String, Object> map : eapMenuList) {
					//카운트 존재하는 메뉴만 추가.
					if(!CommonUtil.isEmptyStr(map.get("count"))) {
						Map<String, Object> badgeInfo = new HashMap<String, Object>();
						badgeInfo.put("module", "EA");
						badgeInfo.put("menu", map.get("id"));
						badgeInfo.put("count", Integer.parseInt(map.get("count").toString()));
						
						if(!menu.equals("") && !menu.equals(map.get("id"))) {
							continue;
						}
						returnList.add(badgeInfo);
					}
				}			
				
			}if(module.equals("CL") || module.equals("")) {
				//일정 - 업무보고(보낸보고서, 받은보고서) 메뉴만 카운트 처리
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("empSeq", loginVO.getUniqId());
				para.put("compSeq", loginVO.getOrganId());
				para.put("groupSeq", loginVO.getGroupSeq());
				String cnt1 = "";
				String cnt2 = "";
				
				para.put("kind", "0");	//보낸보고서
				cnt1 = (String) commonSql.select("MenuManageDAO.getReportMenuCnt", para);
				para.put("kind", "1");	//받은보고서
				cnt2 = (String) commonSql.select("MenuManageDAO.getReportMenuCnt", para);
	
				
				Map<String, Object> badgeInfo1 = new HashMap<String, Object>();		//보낸보고서 
				badgeInfo1.put("module", "CL");
				badgeInfo1.put("menu", "304010000");
				badgeInfo1.put("count", Integer.parseInt(cnt1));
				
				Map<String, Object> badgeInfo2 = new HashMap<String, Object>();		//받으보고서
				badgeInfo2.put("module", "CL");
				badgeInfo2.put("menu", "304020000");
				badgeInfo2.put("count", Integer.parseInt(cnt2));
				
				if(menu.equals("304010000")) {
					returnList.add(badgeInfo1);
				}else if(menu.equals("304020000")) {
					returnList.add(badgeInfo2);
				}else{
					returnList.add(badgeInfo1);
					returnList.add(badgeInfo2);
				}
					
				
				
			}if(module.equals("ML") || module.equals("")) {
				//메일
				body.put("rootId", "301050000");
				jsonObject.put("body", body);	
				
				apiUrl = groupMap.get("mailUrl") + "getMenuTreeList.do";
				JSONObject subJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				
				ObjectMapper om = new ObjectMapper();
				Map<String, Object> subMap = om.readValue(subJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> mailMenuList = (List<Map<String, Object>>) ((Map<String, Object>) subMap.get("result")).get("mailBoxList");
				for(Map<String, Object> map : mailMenuList) {
					//카운트 존재하는 메뉴만 추가.
					if(!CommonUtil.isEmptyStr(map.get("count"))) {
						Map<String, Object> badgeInfo = new HashMap<String, Object>();
						badgeInfo.put("module", "ML");
						badgeInfo.put("menu", map.get("id"));
						badgeInfo.put("count", Integer.parseInt(map.get("count").toString()));
						
						if(!menu.equals("") && !menu.equals(map.get("id"))) {
							continue;
						}
						returnList.add(badgeInfo);
					}
				}
			}if(module.equals("BD") || module.equals("")) {
				//게시판
				ObjectMapper om = new ObjectMapper();
				body.put("rootId", "501000000");
				jsonObject.put("body", body);	
				apiUrl = serverName + "/edms" + subUrl;
				JSONObject edmsJson = CommonUtil.getPostJSON(apiUrl, jsonObject.toString());
				Map<String, Object> edmsMap = om.readValue(edmsJson.toString(), new TypeReference<Map<String, Object>>(){});
				List<Map<String, Object>> edmsMenuList = (List<Map<String, Object>>) edmsMap.get("result");
				
				
				for(Map<String, Object> map : edmsMenuList) {
					//카운트 존재하는 메뉴만 추가.
					if(!CommonUtil.isEmptyStr(map.get("count"))) {
						Map<String, Object> badgeInfo = new HashMap<String, Object>();
						badgeInfo.put("module", "BD");
						badgeInfo.put("menu", map.get("id"));
						badgeInfo.put("count", Integer.parseInt(map.get("count").toString()));
						
						if(!menu.equals("") && !menu.equals(map.get("id"))) {
							continue;
						}
						returnList.add(badgeInfo);
					}
				}
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
    	
    	return returnList;
    }
}
