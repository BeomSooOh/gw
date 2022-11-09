package neos.cmm.systemx.portal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.constant.ErpConstant;
import neos.cmm.kendo.KItemBase;
import neos.cmm.kendo.KTree;
import neos.cmm.kendo.KTreeItem;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.MessageUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class PortalManageController {
	/* 변수정의 로그 */
	private Logger LOG = LogManager.getLogger(this.getClass());
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name = "CommonOptionManageService")
	CommonOptionManageService commonOptionManageService;	
	
	@RequestMapping("/cmm/systemx/portal/portalManageView.do")
    public ModelAndView partnerManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		LOG.debug("+ [PortalMange] INFO - @Controller >> /cmm/systemx/portal/portalManageView.do");
		LOG.debug("+ [PortalMange] INFO - Param >> " + params.toString());
		
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
		if(!isAuthMenu){
			if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpYn").equals("Y")){
				mv.setViewName("redirect:/forwardIndex.do");			
				return mv;
			}
		}
		
		mv.setViewName("/neos/cmm/systemx/portal/portalManageView");
		
		params.put("redirectPage", "portalManageView.do");
		
		MessageUtil.getRedirectMessage(mv, request);
		
		mv.addObject("isSyncAuto", ErpConstant.PARTNER_AUTO);
		
		mv.addObject("params", params);
		
		LOG.debug("- [PortalMange] END - @Controller >> /cmm/systemx/portal/portalManageView.do");
		
		return mv; 
	}
	
	@RequestMapping("/cmm/systemx/portal/portalInfoPop.do")
    public ModelAndView portalInfoPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		if (userSe != null && userSe.equals("MASTER")) {
			params.put("compSeq", "0");
		}else{
			params.put("compSeq", loginVO.getCompSeq());
		}
				
		@SuppressWarnings("unchecked")
		List<Map<String,Object>> compList = commonSql.list("PortalManageDAO.selectCoList", params);
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		/** 현재 회사 선택 */
		String compSeq = params.get("compSeq")+"";
		if (EgovStringUtil.isEmpty(compSeq) ) {
			if(loginVO.getUserSe().equals("MASTER")){
				params.put("compSeq", compList.get(0).get("compSeq")); 
			}else{
				params.put("compSeq", loginVO.getCompSeq());
			}
		}
		
		if(params.get("portalId").equals("0")){
			params.put("addYn", "1");
			params.put("portalId", "1");
		}else{
			params.put("addYn", "0");
		}
		
		@SuppressWarnings("unchecked")
		Map<String,Object> portalInfo = (Map<String,Object>) commonSql.select("PortalManageDAO.selectPortalInfo", params);
		mv.addObject("portalInfo", portalInfo);
		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portalInfoPop");
		
		params.put("redirectPage", "portalInfoPop.do");
		
		if (CloudConnetInfo.getBuildType().equals("cloud")){
			params.put("BuildType" ,"cloud");
		}
		else {
			params.put("BuildType" ,"build");
		}

		MessageUtil.getRedirectMessage(mv, request);
		
		mv.addObject("isSyncAuto", ErpConstant.PARTNER_AUTO);
		mv.addObject("params", params);
		
		return mv; 
	}	
	

	  @RequestMapping("/cmm/systemx/portal/portletInfoPop.do")
    public ModelAndView portletInfoPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		long controllerStartTime = System.currentTimeMillis();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getCompSeq());
		params.put("empSeq", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		params.put("deptSeq", loginVO.getOrgnztId());		
		
		ModelAndView mv = new ModelAndView();
		
		LOG.info("포탈 아이디를 가져온다.");
		@SuppressWarnings("unchecked")
		Map<String, Object> portalInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectPortalInfo", params);
		
		if(portalInfo != null){
			LOG.info("EBP 프로퍼티 값을 가져온다.");
			String ebpType = BizboxAProperties.getProperty("BizboxA.Cust.ebpYn");
			LOG.info("EBP 프로퍼티 값을 가져옴" + ebpType);
			if(ebpType.equals("Y")) {
				mv.setViewName("/neos/cmm/systemx/portal/pop/portletInfoEbpPop");
				
				LOG.info("포틀릿 정보를 가져옴");
				@SuppressWarnings("unchecked")
				Map<String, Object> portletCloudInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectportletCloudInfo", params);
				
				/*
				String weatherApiKey = (String) commonSql.select("PortalManageDAO.selectWeatherApiKey",params);
				mv.addObject("weatherApiKey",weatherApiKey);
				*/
				if(portletCloudInfo != null){
					mv.addObject("portalHeight", portletCloudInfo.get("portalHeight"));
					mv.addObject("portletInfo", portletCloudInfo.get("portletInfo"));					
				}else{
					mv.addObject("portalHeight", "");
					mv.addObject("portletInfo", "");
				}
				
				if(CloudConnetInfo.getBuildType().equals("cloud")){
					mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
				}else{
					mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
				}
				
				String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
				String displayPositionDuty = "";
				
				if(positionDutyOptionValue == null) {
					displayPositionDuty = "position";
				} else if(positionDutyOptionValue.equals("0")){
					displayPositionDuty = "position";
				} else if(positionDutyOptionValue.equals("1")) {
					displayPositionDuty = "duty";
				}
				
				mv.addObject("displayPositionDuty", displayPositionDuty);
				
				// 개인정보 표시 옵션 가져와 셋팅
				if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
					mv.addObject("optionValue", "1");
					String empPathNm = getEmpPathNm();
					mv.addObject("empPathNm", empPathNm);
				}
				
				String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn", params);
				
				if(empCheckWorkYn == null){
					mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
					return mv;
				}
				
				if (!empCheckWorkYn.equals("") && empCheckWorkYn.equals("Y")) {
					// 출퇴근 정보
					params.put("loginId", loginVO.getId());
					@SuppressWarnings("unchecked")
					Map<String, Object> userAttInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttPortalInfo", params);
					mv.addObject("userAttInfo", userAttInfo);

					// 출퇴근 옵션 정보
					@SuppressWarnings("unchecked")
					Map<String, Object> userAttOptionInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttOptionInfo", params);
					if (userAttOptionInfo != null) {
						mv.addObject("userAttOptionInfo", userAttOptionInfo);
					}

					mv.addObject("empCheckWorkYn", "Y");
				} else {
					mv.addObject("empCheckWorkYn", "N");
				}
				
			} else if (portalInfo.get("portalDiv") != null && portalInfo.get("portalDiv").equals("cloud")) {
				long portalCloudInfoStartTime1 = System.currentTimeMillis();
				mv.setViewName("/neos/cmm/systemx/portal/pop/portletInfoCloudPop");
				
				@SuppressWarnings("unchecked")
				Map<String, Object> portletCloudInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectportletCloudInfo", params);
				
				String weatherApiKey = (String) commonSql.select("PortalManageDAO.selectWeatherApiKey",params);
				mv.addObject("weatherApiKey",weatherApiKey);
				
				if(portletCloudInfo != null){
					mv.addObject("portalHeight", portletCloudInfo.get("portalHeight"));
					mv.addObject("portletInfo", portletCloudInfo.get("portletInfo"));					
				}else{
					mv.addObject("portalHeight", "");
					mv.addObject("portletInfo", "");
				}
				
				if(CloudConnetInfo.getBuildType().equals("cloud")){
					mv.addObject("profilePath", "/upload/" + loginVO.getGroupSeq() + "/img/profile/" + loginVO.getGroupSeq());
				}else{
					mv.addObject("profilePath", "/upload/img/profile/" + loginVO.getGroupSeq());
				}
				long portalCloudInfoEndTime1 = System.currentTimeMillis();
				long controllerTime1 = portalCloudInfoEndTime1 - portalCloudInfoStartTime1;
				System.out.println("portletInfoPop.do time1 Time : " + controllerTime1 + "(ms)");
				
				long portalCloudInfoStartTime2 = System.currentTimeMillis();
				mv.setViewName("/neos/cmm/systemx/portal/pop/portletInfoCloudPop");
				String positionDutyOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm1900");
				String displayPositionDuty = "";
				
				if(positionDutyOptionValue == null) {
					displayPositionDuty = "position";
				} else if(positionDutyOptionValue.equals("0")){
					displayPositionDuty = "position";
				} else if(positionDutyOptionValue.equals("1")) {
					displayPositionDuty = "duty";
				}
				
				mv.addObject("displayPositionDuty", displayPositionDuty);
				
				// 개인정보 표시 옵션 가져와 셋팅
				if (commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm700").equals("1")) {
					mv.addObject("optionValue", "1");
					String empPathNm = getEmpPathNm();
					mv.addObject("empPathNm", empPathNm);
				}
				long portalCloudInfoEndTime2 = System.currentTimeMillis();
				long controllerTime2 = portalCloudInfoEndTime2 - portalCloudInfoStartTime2;
				System.out.println("portletInfoPop.do time2 Time : " + controllerTime2 + "(ms)");
				
				long portalCloudInfoStartTime3 = System.currentTimeMillis();
				String empCheckWorkYn = (String) commonSql.select("Empmanage.getEmpCheckWorkYn", params);
				
				if(empCheckWorkYn == null){
					mv.setViewName("redirect:/uat/uia/egovLoginUsr.do");
					return mv;
				}
				
				if (!empCheckWorkYn.equals("") && empCheckWorkYn.equals("Y")) {
					// 출퇴근 정보
					params.put("loginId", loginVO.getId());
					@SuppressWarnings("unchecked")
					Map<String, Object> userAttInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttPortalInfo", params);
					mv.addObject("userAttInfo", userAttInfo);

					// 출퇴근 옵션 정보
					@SuppressWarnings("unchecked")
					Map<String, Object> userAttOptionInfo = (Map<String, Object>) commonSql.select("PortalManageDAO.selectUserAttOptionInfo", params);
					if (userAttOptionInfo != null) {
						mv.addObject("userAttOptionInfo", userAttOptionInfo);
					}

					mv.addObject("empCheckWorkYn", "Y");
				} else {
					mv.addObject("empCheckWorkYn", "N");
				}
				long portalCloudInfoEndTime3 = System.currentTimeMillis();
				long controllerTime3 = portalCloudInfoEndTime3 - portalCloudInfoStartTime3;
				System.out.println("portletInfoPop.do time3 Time : " + controllerTime3 + "(ms)");
			}else{
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> portletList = commonSql.list("PortalManageDAO.selectPortletList", params);
				mv.addObject("portletList", portletList);
				
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> portletSetList = commonSql.list("PortalManageDAO.selectPortletSetList", params);
				mv.addObject("portletSetList", portletSetList);
				mv.setViewName("/neos/cmm/systemx/portal/pop/portletInfoPop");
			}
		}
		
		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		long controllerEndTime = System.currentTimeMillis();
		long controllerTotalTime = controllerEndTime - controllerStartTime;
		System.out.println("portletInfoPop.do Total Time : " + controllerTotalTime + "(ms)");
		return mv; 
	}
	
	public String getEmpPathNm() throws Exception {
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		// 0:회사, 1:사업장, 2:부서, 3:팀, 4:임시부서, 5:부서(부서명)
		String sOptionValue = commonOptionManageService.getCommonOptionValue(loginVO.getGroupSeq(), loginVO.getCompSeq(), "cm701");
		String arrOptionValue[] = sOptionValue.split("\\|");

		String empPathNm = "";

		String compName = "";
		String bizName = "";
		String teamNm = "";
		String virDeptNm = "";
		String pathName = "";
		String onlyDeptName = "";

		if (arrOptionValue.length > 0) {
			Map<String, Object> mp = new HashMap<String, Object>();

			mp.put("empSeq", loginVO.getUniqId());
			mp.put("compSeq", loginVO.getCompSeq());
			mp.put("bizSeq", loginVO.getBizSeq());
			mp.put("deptSeq", loginVO.getOrgnztId());
			mp.put("langCode", loginVO.getLangCode());
			mp.put("groupSeq", loginVO.getGroupSeq());

			Map<String, Object> empInfoMap = (Map<String, Object>) commonSql.select("Empmanage.getEmpInfo", mp);

			String virDeptYn = empInfoMap.get("virDeptYn") + "";
			String teamYn = empInfoMap.get("teamYn") + "";
			pathName = "";
			String removeDeptNm ="";
			for (int i = 0; i < arrOptionValue.length; i++) {
				if (arrOptionValue[i].equals("0")) {
					compName = empInfoMap.get("compName") + "-";
				} else if (arrOptionValue[i].equals("1")) {
					bizName = empInfoMap.get("bizName") + "-";
				} else if(arrOptionValue[i].equals("2")){
					if(teamYn.equals("Y") || virDeptYn.equals("Y")) {
						String [] array = empInfoMap.get("pathName").toString().split("-");
						List<String> list = new ArrayList<>(Arrays.asList(array));
						removeDeptNm = list.get(list.size()-1);
						list.remove(list.size()-1);
						for(int j=0;j<list.size(); j++) {
							pathName +=  list.get(j)+"-";
						}
					}else {
						pathName = empInfoMap.get("pathName")+"-";
					}
					
				} else if (arrOptionValue[i].equals("3") && teamYn.equals("Y")) {
					teamNm = empInfoMap.get("deptName") + "-";
				} else if (arrOptionValue[i].equals("4") && virDeptYn.equals("Y")) {
					virDeptNm = empInfoMap.get("deptName") + "-";
				} else if (arrOptionValue[i].equals("5")) {
					onlyDeptName = empInfoMap.get("displayDeptName") + "-";
				}
			}
			if(removeDeptNm != null && removeDeptNm !="") {
				if(teamNm==""&&virDeptNm=="") {
					pathName += removeDeptNm;
				}
			}
		}

		if (!pathName.equals("")) {
			onlyDeptName = "";
		}

		empPathNm = compName + bizName + pathName + onlyDeptName + teamNm + virDeptNm;

		if (empPathNm.length() > 0 && empPathNm.substring(empPathNm.length() - 1).equals("-")) {
			empPathNm = empPathNm.substring(0, empPathNm.length() - 1);
		}
		return empPathNm;
	}	
	
	@RequestMapping("/cmm/systemx/portal/portletSetPop.do")
    public ModelAndView portletSetPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();

		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);		
		
		params.put("langCode",loginVO.getLangCode());
		
		@SuppressWarnings("unchecked")		
		Map<String,Object> portletSetInfo = (Map<String,Object>) commonSql.select("PortalManageDAO.selectPortletSetInfo", params);
		mv.addObject("portletSetInfo", portletSetInfo);
		
		Object linkId = portletSetInfo.get("linkId");
		
		if(linkId != null){
			params.put("linkId", linkId);
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> portletLinkList = commonSql.list("PortalManageDAO.selectPortletLinkList", params);
			mv.addObject("portletLinkList", portletLinkList);			
		}
		
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletSetPop");
		params.put("redirectPage", "portletSetPop.do");
		MessageUtil.getRedirectMessage(mv, request);
		mv.addObject("isSyncAuto", ErpConstant.PARTNER_AUTO);
		mv.addObject("params", params);
		
		return mv; 
	}
	
	@RequestMapping("/cmm/systemx/portal/portletCloudSetPop.do")
    public ModelAndView portletCloudSetPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletCloudSetPop");
		LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		mv.addObject("loginVo", loginVo);
		mv.addObject("params", params);
		
		return mv; 
	}	
	
	@RequestMapping("/cmm/systemx/portal/portletLinkPop.do")
    public ModelAndView portletLinkPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletLinkPop");
		params.put("redirectPage", "portletLinkPop.do");
		MessageUtil.getRedirectMessage(mv, request);
		mv.addObject("isSyncAuto", ErpConstant.PARTNER_AUTO);
		mv.addObject("params", params);
		
		return mv; 
	}	
	
	@RequestMapping ( "/cmm/systemx/portal/portalList.do" )
	public ModelAndView portalList ( @RequestParam Map<String, Object> params, HttpServletRequest request ) throws Exception {
		/* 변수정의 */
		ModelAndView mv = new ModelAndView( );
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>( );
		try {
			/* 변수정의 */
			LoginVO loginVo = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
			/* 파라미터 정의 */
			params.put( "langCode", loginVo.getLangCode( ) );
			/* 마스터 / 사용자 분리 처리 */
			if ( loginVo.getUserSe( ).equals( "MASTER" ) ) {
				/* 마스터의 경우 회사 시퀀스 "0" */
				/* 마스터인 경우 모든 회사의 포틀릿 목록을 조회한다. */
				params.put( "compSeq", "0" );
			}
			else {
				/* 마스터가 아닌 경우 로그인된 사용자 회사 시퀀스 */
				/* 마스터가 아닌 경우 로그인된 사용자의 회사 정보 기준으로만 포틀릿 목록을 조회한다. */
				params.put( "compSeq", loginVo.getCompSeq( ) );
			}
			result = commonSql.list( "PortalManageDAO.selectPortalList", params );
		}
		catch ( Exception e ) {
			LOG.error( "[/cmm/systemx/portal/portalList.do] - " + e.toString( ) );
			result = new ArrayList<Map<String, Object>>( );
		}
		mv.addObject( "list", result );
		mv.setViewName( "jsonView" );
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portalInsert.do")
	public ModelAndView portalInsert(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("uniqId", loginVO.getUniqId());
		params.put("langCode", loginVO.getLangCode());
		
		if(loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER")){
			
			if(params.get("useYn").equals("Y")){
				commonSql.update("PortalManageDAO.updatePortalUse", params);	
			}			
			
			if(params.get("portalId").equals("0")){
				Object portalId = commonSql.select("PortalManageDAO.selectportalId", params);
				params.put("portalId", portalId);
				commonSql.insert("PortalManageDAO.insertPortal", params);
				//하단기본버튼 추가.
				commonSql.insert("PortalManageDAO.insertFootBaseBtn", params);
			}else{
				commonSql.update("PortalManageDAO.updatePortal", params);	
			}
			
			mv.addObject("value", "1");
		}else{
			mv.addObject("value", "-1");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/portal/portalDelete.do")
	public ModelAndView portalDelete(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!params.get("portalId").equals("0") && (loginVO.getUserSe().equals("ADMIN") || loginVO.getUserSe().equals("MASTER"))){
			commonSql.delete("PortalManageDAO.deletePortalListLink", params);
			commonSql.delete("PortalManageDAO.deletePortalListSet", params);
			commonSql.delete("PortalManageDAO.deletePortalList", params);
			commonSql.delete("PortalManageDAO.deleteFootBtnListLink", params);
			commonSql.delete("PortalManageDAO.deleteFootBtnList", params);			
			mv.addObject("value", "1");		
		}else{
			mv.addObject("value", "-1");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portletInsert.do")
	public ModelAndView portletInsert(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		String jsonStr = (String)params.get("portletList");
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> portletList = new ArrayList<Map<String, Object>>();
		portletList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
		
		for (Map<String, Object> map : portletList) {
			commonSql.insert("PortalManageDAO.insertPortletSet", map);
		}
		
		if(portletList.size() > 0){
			params.put("portletList", portletList);
			commonSql.delete("PortalManageDAO.deletePortletLink", params);
			commonSql.delete("PortalManageDAO.deletePortletSet", params);			
		}
		
		mv.addObject("value", "1");
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portletCloudInsert.do")
	public ModelAndView portletCloudInsert(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/*
		 * 날씨 API 추가에 따른 API 키 별도 저장 로직 
		 *
		 * */
		if(params.get("weatherApiKey") != null) {
			params.put("groupSeq", loginVO.getGroupSeq());
			commonSql.update("PortalManageDAO.updateWeatherApiKey", params);
		}
		
		commonSql.delete("PortalManageDAO.deletePortletCloudSet", params);
		commonSql.insert("PortalManageDAO.insertPortletCloudSet", params);
		
		mv.addObject("value", "1");
		mv.setViewName("jsonView");
		return mv;
	}		
	
	@RequestMapping("/cmm/systemx/portal/portletSetInsert.do")
	public ModelAndView portletSetInsert(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Object newLinkId = null;
		

		if(params.get("linkId").equals("0")){
			newLinkId = commonSql.select("PortalManageDAO.selectLinkId", params);
		}else{
			commonSql.delete("PortalManageDAO.deleteLinkList", params);
			commonSql.delete("PortalManageDAO.deleteSSoLinkList", params);
			newLinkId = params.get("linkId");
		}
		
		String jsonStr = (String)params.get("linkList");
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> linkList = new ArrayList<Map<String, Object>>();
		linkList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
		
		List<Map<String, Object>> ssoLinkInfoList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> map : linkList) {
			map.put("link_id", newLinkId);
			if(map.get("ssoUseYn").toString().equals("Y")){
				map.put("portletTp", params.get("portletTp"));
				ssoLinkInfoList.add(map);
			}
		}
		
		if(linkList.size() > 0){
			Map<String, Object> linkMp = new HashMap<String, Object>();
			linkMp.put("linkList", linkList);
			commonSql.insert("PortalManageDAO.insertPortletLink", linkMp);			
		}else{
			//링크리스트가 하나도 없을때 link_id 0으로 초기화
			newLinkId = 0;
		}
		
		if(ssoLinkInfoList.size() > 0){
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("ssoLinkInfoList", ssoLinkInfoList);
			commonSql.insert("PortalManageDAO.insertPortletSSoLink", mp);			
		}
		
		if(params.get("messengerUseYn") != null){
			// 연말정산 포틀릿 메신저 날개설정 업데이트
			Map<String,Object> portalInfo = (Map<String,Object>) commonSql.select("PortalManageDAO.selectPortalInfo", params);
			
			if(portalInfo != null) {
				params.put("compSeq", portalInfo.get("compSeq"));
				commonSql.insert("PortalManageDAO.updateMessengerUse", params);				
			}

		}
		
		if(params.get("weatherApiKey") != null) {
			//날씨 api 키값이 있으면 t_co_group 테이블에 추가
			params.put("groupSeq", loginVO.getGroupSeq());
			commonSql.update("PortalManageDAO.updateWeatherApiKey", params);
		}		
		
		params.put("linkId", newLinkId);
		commonSql.insert("PortalManageDAO.insertPortlet", params);
		
		mv.addObject("value", newLinkId);
		mv.setViewName("jsonView");
		return mv;
	}	
	
	
	@RequestMapping("/cmm/systemx/portal/portletEaBoxListPop.do")
	public ModelAndView portletEaBoxListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletEaBoxListPop");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portletEaFormListPop.do")
	public ModelAndView portletEaFormListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletEaFormListPop");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portletBoardListPop.do")
	public ModelAndView portletBoardListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletBoardListPop");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/portletDocListPop.do")
	public ModelAndView portletDocListPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletDocListPop");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/getEaBoxMenuTreeList.do")
	public ModelAndView getEaBoxMenuTreeList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String menuNoList = params.get("menuNoList") + "";
		String[] arrMenuNoList = menuNoList.split(",");
		
		List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
		
		String eaType = loginVO.getEaType() + "";
		if(eaType == null || eaType.equals("")) {
			eaType = "eap";
		}
		
		
		if(eaType.equals("eap")) {
			params.put("langCode", loginVO.getLangCode());
			params.put("menuGubun", "MENU010");
			params.put("startWith", "2002000000");
			params.put("eaType", eaType);
			
			list = commonSql.list("MenuManageDAO.selectEaBoxListTreeMenu", params);
		} else if (eaType.equals("ea")) {
			params.put("langCode", loginVO.getLangCode());
			params.put("menuGubun", "MENU001");
			params.put("startWith", "102000000");
			params.put("startWith1", "101000000");
			
			params.put("eaType", eaType);
			
			list = commonSql.list("MenuManageDAO.selectNonEaBoxListTreeMenu", params);
		}
/*		
		params.put("langCode", loginVO.getLangCode());
		params.put("menuGubun", "MENU001");
		params.put("startWith", "102000000");
		params.put("startWith1", "101000000");
		
		params.put("eaType", eaType);
		
		list = commonSql.list("MenuManageDAO.selectNonEaBoxListTreeMenu", params);
*/		
/*		
		params.put("langCode", loginVO.getLangCode());
		params.put("menuGubun", "MENU001");
		params.put("startWith1", "101000000");
		params.put("startWith", "102000000");
		params.put("eaType", "ea");
*/		
//		List<Map<String,Object>> list = commonSql.list("MenuManageDAO.selectNonEaBoxListTreeMenu", params);
		
		List<KItemBase> treeList = new ArrayList<KItemBase>();
		
		if (list != null && list.size() > 0) {
			Map<String,Object> root = list.get(0);
			
			KTree tree = new KTree();

			KTreeItem rootitem = null;
//			rootitem = new KTreeItem("100000000","0", "양식" ,"", true, "rootfolder");
			
			if(eaType.equals("ea")) {
				rootitem = new KTreeItem("100000000","0", BizboxAMessage.getMessage("TX000000177","양식") ,"", true, "rootfolder");
			} else {
				rootitem = new KTreeItem(root.get("menuNo")+"", root.get("upperMenuNo")+"", root.get("name")+"", "", true, "rootfolder");
			}
		
//			rootitem = new KTreeItem("100000000","0", "양식" ,"", true, "rootfolder");
			if (!EgovStringUtil.isEmpty(root.get("authMenuNo")+"")) {
				rootitem.setChecked(true);
			}

			tree.setRoot(rootitem);
//			tree.setRoot(new KTreeItem("100000000","0", "양식" ,"", true, "rootfolder"));
			
			String url = null;
			String name = null;
			
			boolean checked = false; 
			boolean expanded = true;
			for(Map<String,Object> map : list) {
				url = map.get("urlPath")+"";
				name = map.get("name")+"";
				
				int cnt = 0;
				for(int i=0;i<arrMenuNoList.length;i++){
					if(arrMenuNoList[i].equals(map.get("menuNo")+"")) {
						cnt++;
					}
				}
				
				if(cnt > 0){
					checked = true;
				} else {
					checked = false;
				}
				
				KTreeItem item = new KTreeItem(map.get("menuNo")+"",map.get("upperMenuNo")+"", name,url,expanded, map.get("spriteCssClass")+"");
				item.setChecked(checked);
				
				treeList.add(item);
			}
			
			tree.addAll(treeList);

			JSONObject json = JSONObject.fromObject(tree.getRoot());
			mv.addObject("treeList", json);
		} 
		
		mv.setViewName("/neos/cmm/System/author/detail/AuthorMenuTreeView");
		return mv;
	}

	
	@RequestMapping("/cmm/systemx/portal/getEaFormTreeList.do")
	public ModelAndView getEaFormTreeList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        
        if(loginVO == null) {
        	return mv;
        }
        
        params.put("groupSeq", loginVO.getGroupSeq());
        params.put("loginVo", loginVO);
        
        List<Map<String,Object>> list = commonSql.list("MenuManageDAO.selectEaFormTreeMenu", params);
        
        List<KItemBase> treeList = new ArrayList<KItemBase>();
        
        if (list != null && list.size() > 0) {            
            
            boolean expanded = false;
            
            KTree tree = new KTree();
            tree.setRoot(new KTreeItem("0","0", BizboxAMessage.getMessage("TX000000177","양식") ,true, "rootfolder", "", "", "", "", "", ""));
            for(Map<String,Object> map : list) {
                if(map.get("expanded").equals("true")){
                    expanded = true;
                }                

                treeList.add(new KTreeItem( map.get("formId")+""            // 양식 아이디 
                		                  , map.get("upperFormId")+""      // 폴더 아이디
                		                  , map.get("formNm")+""            // 양식 명 
                		                  , expanded                         //
                		                  , map.get("spriteCssClass")+""     // class 
                		                  , map.get("interlockUrl")+""      
                		                  , map.get("interlockWidth")+""
                		                  , map.get("interlockHeight")+""
                		                  , map.get("formTp")+""
                		                  , map.get("formDTp")+""
                		                  , map.get("docWidth")+""
                		                  )
                		);
            }
            
            tree.addAll(treeList);
            
            // panel은 root 노드 제외
            mv.addObject("treeList", ((KItemBase)tree.getRoot()).getItems());
            
        }

        return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/portal/portletEaTreePop.do")
	public ModelAndView portletEaTreePop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		mv.addObject("params", params);
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletEaTreePop");
		return mv;
	}
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    @RequestMapping("/admin/form/getFormTree.do")
    public ModelAndView getFormTree(@RequestParam Map<String,Object> params) throws Exception
    {
        LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        
        /** top menu */
        String authCode = loginVO.getAuthorCode();
        
        ModelAndView mv = new ModelAndView();

        if (!EgovStringUtil.isEmpty(authCode)) {
        	Map<String, Object> selectList = new HashMap<String, Object>();
            HashMap<String, Object> vo = new HashMap<String, Object>();
            vo.put("organnm", loginVO.getOrganNm());
            vo.put("loginVO", loginVO);
            vo.put("c_tiuseorgcode", loginVO.getOrganId());
            vo.put("tiVisible",(String) params.get("tiVisible"));
            
            List<Map<String, Object>> selectListTemp = commonSql.list("MenuManageDAO.FormTreeList", vo);
            
            selectList.put("selectList", selectListTemp);
            
            List<Map> list = (List<Map>)selectList.get("selectList");
            
            List<KItemBase> treeList = new ArrayList<KItemBase>();
            
            if (list != null && list.size() > 0) {
                Map<String,Object> root = list.get(0);

                KTree tree = new KTree();
                
                tree.setRoot(new KTreeItem(root.get("UPPER_CODE")+"","0", BizboxAMessage.getMessage("TX000008197","서식") ,"",true, "rootfolder"));
                if (list.size() > 0) {
                    String url = null;
                    String name = null; 
                    boolean expanded = true;
                    
                    for(Map<String,Object> map : list) {
                        url = map.get("REL")+"";
                        name = map.get("CODE_NM")+""; 
                        
                        treeList.add(new KTreeItem(map.get("CODE")+"",map.get("UPPER_CODE")+"", name, url, expanded, map.get("SPRITECSSCLASS")+""));
                    }
                }
                
                tree.addAll(treeList);
                
                // panel은 root 노드 제외                
                mv.addObject("treeList", ((KItemBase)tree.getRoot()).getItems());
                
            }
        }
        
        mv.setViewName("jsonView");         
                
        return mv;
    }

	@RequestMapping("/cmm/systemx/portal/getEaFormPortletInfo.do")
	public ModelAndView getEaFormPortletInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("langCode", loginVO.getLangCode());
		List list = commonSql.list("MenuManageDAO.getEaFormPortletInfo", params);
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/getNonEaFormPortletInfo.do")
	public ModelAndView getNonEaFormPortletInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		List list = commonSql.list("MenuManageDAO.getNonEaFormPortletInfo", params);
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/getAttendCheck.do")
	public ModelAndView getAttendCheck(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> result = new HashMap<String, Object>();
		
		List list = commonSql.list("MenuManageDAO.getAttendCheck", params);
		
		if(list.size() == 0) {
			result.put("secomUse", "N");
		} else {
			result.put("secomUse", "Y");
		}
		mv.addObject("list", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/portal/getEaBoxPortletInfo.do")
	public ModelAndView getEaBoxPortletInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		List list = commonSql.list("MenuManageDAO.getEaBoxPortletInfo", params);
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/portal/portletFootSetPop.do")
    public ModelAndView portletFootSetPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/portal/pop/portletFootSetPop");
		mv.addObject("params", params);
		return mv; 
	}
	
	
	
	
	@RequestMapping("/cmm/systemx/portal/getFootBotnList.do")
    public ModelAndView getFootBotnList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		ModelAndView mv = new ModelAndView();

		//하단푸터 버튼 리스트 조회
		List<Map<String,Object>> portletBtnList = (List<Map<String,Object>>) commonSql.list("PortalManageDAO.selectPortletBtnList", params);

		
		mv.addObject("portletBtnList", portletBtnList);				
		mv.addObject("params", params);
		
		mv.setViewName("jsonView");				
		
		return mv; 
	}
	
	
	
	
	
	@RequestMapping("/cmm/systemx/portal/footBtnModifyPop.do")
    public ModelAndView footBtnModifyPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		ModelAndView mv = new ModelAndView();
		
		if((params.get("seq") + "").equals("")){
			String seq = (String) commonSql.select("PortalManageDAO.getFootBtnSeq", params);
			params.put("footBtnSeq", seq);
			params.put("newYn", "Y");
			params.put("linkId", "0");
		}
		else{
			params.put("footBtnSeq", params.get("seq"));
		}
			
		mv.addObject("params", params);
		
		mv.setViewName("/neos/cmm/systemx/portal/pop/footBtnModifyPop");				
		
		return mv; 
	}
	
	
	
	
	
	@RequestMapping("/cmm/systemx/portal/saveFootBtnListInfo.do")
    public ModelAndView saveFootBtnListInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		List<Map<String,Object>> baseBtnInfoList = ConvertJsonToListMap(params.get("baseBtnInfo")+"");
		List<Map<String,Object>> addBtnInfoList = ConvertJsonToListMap(params.get("addBtnInfo")+"");
		
		if(baseBtnInfoList.size() > 0 ){
			for(int i=0;i<baseBtnInfoList.size();i++){				
				commonSql.update("PortalManageDAO.saveFootBaseBtnInfo", baseBtnInfoList.get(i));				
			}
		}
		
		
		if(addBtnInfoList.size() > 0 ){
			for(int i=0;i<addBtnInfoList.size();i++){			
				addBtnInfoList.get(i).put("empSeq", loginVO.getUniqId());
				
				if(addBtnInfoList.get(i).get("linkId").equals("0")){
					Object newLinkId = null;
					newLinkId = commonSql.select("PortalManageDAO.selectFootBtnLinkId", params);
					params.put("linkId", "footBtn" + newLinkId);
				}
				
				//버튼정보 저장
				if(addBtnInfoList.get(i).get("newFileId") != null && !addBtnInfoList.get(i).get("newFileId").equals("")){
					addBtnInfoList.get(i).put("fileId", addBtnInfoList.get(i).get("newFileId"));
				}
				addBtnInfoList.get(i).put("linkId", params.get("linkId"));
				commonSql.insert("PortalManageDAO.saveFootAddBtnInfo",addBtnInfoList.get(i));
				//sso연동 정보 저장
				if(addBtnInfoList.get(i).get("ssoYn").equals("Y")) {
					commonSql.insert("PortalManageDAO.saveFootBtnSsoInfo",addBtnInfoList.get(i));
				}
			}
		}
		
		if(params.get("delList") != null){
			if(params.get("delList").toString().length() > 0){
				commonSql.delete("PortalManageDAO.delFootAddBtnInfo", params);
			}
		}
		if(params.get("delLinkList") != null){
			if(params.get("delLinkList").toString().length() > 0){
				commonSql.delete("PortalManageDAO.delFootAddBtnLinkInfo", params);
			}
		}
		
		
		
		mv.addObject("params", params);
		
		mv.setViewName("jsonView");				
		
		return mv; 
	}
	
	
	public static List<Map<String, Object>> ConvertJsonToListMap(String jsonStr) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		jsonStr = ConvertCharSetToString(jsonStr);

		try {
			result = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>() {});
		}
		catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}
	
	/* Helper - 간접 표현식 변경 */
	public static String ConvertCharSetToString(String source) throws Exception {
		source = source.replaceAll("&nbsp;", " ");
		source = source.replaceAll("&nbsp", " ");
		source = source.replaceAll("&lt;", "<");
		source = source.replaceAll("&lt", "<");
		source = source.replaceAll("&gt;", ">");
		source = source.replaceAll("&gt", ">");
		source = source.replaceAll("&amp;", "&");
		source = source.replaceAll("&amp", "&");
		source = source.replaceAll("&quot;", "\"");
		source = source.replaceAll("&quot", "\"");

		return source;
	}
	
	@RequestMapping("/cmm/systemx/portal/getTaxMessengerCheck.do")
	public ModelAndView getTaxMessengerCheck(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		Map<String, Object> result = new HashMap<String, Object>();
		
		params.put("compSeq", loginVO.getCompSeq());
		List list = commonSql.list("PortalManageDAO.getTaxMessengerCheck", params);
		
		if(list.size() > 0) {
			result.put("taxMsnYn", "Y");
		} else {
			result.put("taxMsnYn", "N");
		}
		mv.addObject("list", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/portal/checkBoardId.do")
	public ModelAndView checkBoardId(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		String catType = (String) commonSql.select("PortalManageDAO.selectBoardCatType", params);
		
		mv.addObject("catType", catType);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/portal/getWeatherApiKey.do")
	public ModelAndView getWeatherApiKey(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq",loginVO.getGroupSeq());
		
		String weatherApiKey = (String) commonSql.select("PortalManageDAO.selectWeatherApiKey", params);
		
		mv.addObject("weatherApiKey", weatherApiKey);
		mv.setViewName("jsonView");
		
		return mv;
		
	}
}
