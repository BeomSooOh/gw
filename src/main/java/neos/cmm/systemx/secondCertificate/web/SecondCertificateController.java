package neos.cmm.systemx.secondCertificate.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.secondCertificate.service.SecondCertificateService;
import net.sf.json.JSONArray;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class SecondCertificateController {
	
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	
	@Resource(name="SecondCertificateService")
    private SecondCertificateService SecondCertificateService;
	
	@Resource ( name = "CompManageService" )
	private CompManageService compService;
	
	@Resource ( name = "MenuManageService" )
	private MenuManageService menuManageService;
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/systemx/SecondCertOptionManageView.do")
	public ModelAndView SecondCertOptionManageView(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("empSeq", loginVO.getUniqId());		
		params.put("langCode", loginVO.getLangCode());
		Map<String, Object> optionMp = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", params);
		
		List<Map<String, Object>> excludeOrgList = commonSql.list("SecondCertManage.selectexcludeOrgList", params);
		List<Map<String, Object>> includeOrgList = commonSql.list("SecondCertManage.selectIncludeOrgList", params);

		mv.addObject("excludeOrgList", JSONArray.fromObject(excludeOrgList));
		mv.addObject("includeOrgList", JSONArray.fromObject(includeOrgList));
		
		mv.addAllObjects(optionMp);
		
		mv.setViewName("/neos/cmm/systemx/secondCertificate/SecondCertOptionManageView");
		
		return mv;
	}
		
	
	@RequestMapping("/cmm/systemx/saveSecondCertOptionInfo.do")
	public ModelAndView saveSecondCertOptionInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		params.put("groupSeq", loginVO.getGroupSeq());
		
		commonSql.update("SecondCertManage.saveSecondCertOptionInfo", params);
		
		
		
		commonSql.delete("SecondCertManage.deleteSecondCertRelate", params);
		String selectedItemE = params.get("selectedItemE") + "";
		String selectedItemI = params.get("selectedItemI") + "";
		
		String []arrItem = selectedItemE.split("▩");
		
		for(int i=0;i<arrItem.length; i++){
			String []sItemInfo = arrItem[i].split("▦");
			if(sItemInfo.length > 1){				
				String gbnOrg = sItemInfo[0];
				String orgSeq = sItemInfo[1];
				String superKey = sItemInfo[2];
				
				params.put("type", "E");
				params.put("gbnOrg", gbnOrg);
				params.put("orgSeq", orgSeq);
				params.put("superKey", superKey);
				
				commonSql.insert("SecondCertManage.insertSecondCertRelate", params);
			}
		}
		
		
		arrItem = selectedItemI.split("▩");
		
		for(int i=0;i<arrItem.length; i++){
			String []sItemInfo = arrItem[i].split("▦");
			if(sItemInfo.length > 1){
				String gbnOrg = sItemInfo[0];
				String orgSeq = sItemInfo[1];
				String superKey = sItemInfo[2];
				
				params.put("type", "I");
				params.put("gbnOrg", gbnOrg);
				params.put("orgSeq", orgSeq);
				params.put("superKey", superKey);
				
				commonSql.insert("SecondCertManage.insertSecondCertRelate", params);
			}
		}
		
		
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/checkSecondCertValidate.do")
	public ModelAndView checkSecondCertValidate(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		Map<String, Object> infoMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertInfo", params);
		Map<String, Object> scPinInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		
		if(infoMap != null){
			mv.addObject("resultCode", infoMap.get("status"));
			mv.addAllObjects(infoMap);
		}else{
			//유효하지않은 QR코드
			mv.addObject("resultCode", "X");
		}
		
		mv.addObject("scPinInfo", scPinInfo == null ? "" : scPinInfo);
		
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/changScDevicePopView.do")
	public ModelAndView changScDevicePopView(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		Map<String, Object> scOptionMap = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertOption", params);
		Map<String, Object> scPinInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		
		//사용자정보로 등록된 인증기기리스트 조회
	    params.put("isRegYn", "Y");
		List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectUsedDeviceInfo", params);
		
		int chkDevCnt = scOptionMap.get("deviceCnt") == null || "".equals(scOptionMap.get("deviceCnt").toString()) ? 0 : Integer.parseInt(scOptionMap.get("deviceCnt").toString());
		
		if(devList.size() >= chkDevCnt){
			params.put("limitCnt", (devList.size() - chkDevCnt + 1));
			List<Map<String, Object>> list = commonSql.list("SecondCertManage.selectOldestDevice", params);
			
			mv.addObject("removeDeviceList", list);
		}
		
		if(scPinInfo != null)
			mv.addAllObjects(scPinInfo);
		mv.addAllObjects(scOptionMap);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/getQrCodeData.do")
	public ModelAndView getQrCodeData(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		
		Map<String, Object> qrDataInfo = SecondCertificateService.setQrCodeInfo(params);
		

		mv.addAllObjects(qrDataInfo);
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/secondCertDeviceManageView.do")
	public ModelAndView secondCertDeviceManageView(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();	
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );		
		
		String userSe = loginVO.getUserSe( );
		List<Map<String, Object>> compList = null;
		
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "userSe", userSe );
		params.put( "empSeq", loginVO.getUniqId());
		compList = compService.getCompListAuth( params );
		
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList );
		
		
		//이차인증 설정값 조회
		//이차인증 사용여부 및 세부옵션값 조회.
	    Map<String, Object> paraMp = new HashMap<String, Object>();	    
	    paraMp.put("groupSeq", loginVO.getGroupSeq());
	    paraMp.put("empSeq", loginVO.getUniqId());
	    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);
		
	    
	    mv.addAllObjects(secondCertInfo);
		mv.addObject("loginVO", loginVO);
		mv.addObject( "compListJson", json );	
		mv.setViewName("/neos/cmm/systemx/secondCertificate/secondCertDeviceManageView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/devApprovalList.do")
	public ModelAndView devApprovalList(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();		
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		PaginationInfo paginationInfo = new PaginationInfo( );
		
		params.put("userSe", loginVO.getUserSe());
		params.put("langCode", loginVO.getLangCode());
		
		
		paginationInfo.setCurrentPageNo( EgovStringUtil.zeroConvert( params.get( "page" ) ) );
		paginationInfo.setPageSize( EgovStringUtil.zeroConvert( params.get( "pageSize" ) ) );
		
		List<Map<String, Object>> listMap = commonSql.list("SecondCertManage.getDeviceApprovalList", params); 
		mv.addObject("list", listMap);
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/setSecondCertDevStatus.do")
	public ModelAndView setSecondCertDevStatus(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		//승인 처리일 경유 인증기기 등록 가능갯수 체크
		if(params.get("status").equals("P")){
			String sEmpSeqList = (String) commonSql.select("SecondCertManage.selectEmpSeqFromDevList", params);
			String[] arrEmpSeq =  sEmpSeqList.split(",");
			
			//이차인증 셋팅정보 조회
		    Map<String, Object> paraMp = new HashMap<String, Object>();	    
		    paraMp.put("groupSeq", loginVO.getGroupSeq());
		    paraMp.put("empSeq", loginVO.getUniqId());
		    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", paraMp);
			
			for(int i=0;i<arrEmpSeq.length;i++){
				int checkCnt = 0;
				String checkEmpSeq = arrEmpSeq[i];
				for(int j=0;j<arrEmpSeq.length;j++){
					if(checkEmpSeq.equals(arrEmpSeq[j])) {
						checkCnt ++;
					}
				}
				
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("status", "P");
				mp.put("empSeq", arrEmpSeq[i]);
				mp.put("devType", "2");				
				
				List<Map<String, Object>> list = commonSql.list("SecondCertManage.selectSecondCertDeviceList", mp);
				
				mp.put("seqList", params.get("seqList"));
				List<Map<String, Object>> list2 = commonSql.list("SecondCertManage.selectSecondCertDeviceList2", mp);
				
			
				if(secondCertInfo.get("range").toString().equals("A")){
					secondCertInfo.put("deviceCnt", String.valueOf(Integer.parseInt(secondCertInfo.get("deviceCnt").toString()) - 1));
				}
				
				if(Integer.parseInt(secondCertInfo.get("deviceCnt").toString()) < checkCnt+list.size()-list2.size()){
					mv.addObject("resultCode", "FAIL");
					mv.setViewName( "jsonView" );
					return mv;
				}
			}
		}else if(params.get("status").equals("C")){
			//해지처리 시 토큰 로그아웃 api호출
			params.put("groupSeq", loginVO.getGroupSeq());
			List<Map<String, Object>> devList = (List<Map<String, Object>>) commonSql.list("SecondCertManage.selectSecondDevList", params);
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", params);
			
			if(groupInfo != null){
				for(Map<String, Object> mp : devList){
					if(mp.get("token") != null && !mp.get("token").toString().equals("")){					
						Map<String, Object> para = new HashMap<String, Object>();
						para.put("token", mp.get("token"));
						para.put("appType", mp.get("appType"));
						para.putAll(groupInfo);
						para.put("groupSeq", loginVO.getGroupSeq());
						SecondCertificateService.secondCertTokenLogOut(para);
					}				
				}
			}
		}
		
		
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("confirmSeq", loginVO.getUniqId());
		
		commonSql.update("SecondCertManage.setSecondCertDevStatus", params);
	 
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/secondCertDescPop.do")
	public ModelAndView secondCertDescPop(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
	
		String groupSeq = "";
		String empSeq = "";
		String langCode = "";
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		if(loginVO == null){
			groupSeq = params.get("groupSeq") + "";
			empSeq = params.get("empSeq") + "";
			langCode = "kr";
		}else{
			groupSeq = loginVO.getGroupSeq();
			empSeq = loginVO.getUniqId();
			langCode = loginVO.getLangCode();
		}
		
	
		
		if(params.get("seq") != null){
			Map<String, Object> descMp = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertDeviceInfo", params);
			mv.addAllObjects(descMp);
		}else if(params.get("type") != null){						
			params.put("groupSeq", groupSeq);
			params.put("empSeq", empSeq);
			Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
			
			if(pinMp != null)
				mv.addAllObjects(pinMp);
			
			//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
			if(params.get("type").equals("C")){
				//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
				params.put("langCode", langCode);
				params.put("deviceNum", params.get("deviceNum"));				
				Map<String, Object> devInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getDeviceInfo", params);
				mv.addAllObjects(devInfo);
			}
		}
		
		mv.addAllObjects(params);
	 
		mv.setViewName("/neos/cmm/systemx/secondCertificate/pop/secondCertDescPop");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/secondCertDescInfo.do")
	public ModelAndView secondCertDescInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
	
		String groupSeq = "";
		String empSeq = "";
		String langCode = "";
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		if(loginVO == null){
			groupSeq = params.get("groupSeq") + "";
			empSeq = params.get("empSeq") + "";
			langCode = "kr";
		}else{
			groupSeq = loginVO.getGroupSeq();
			empSeq = loginVO.getUniqId();
			langCode = loginVO.getLangCode();
		}
		
	
		
		if(params.get("seq") != null){
			Map<String, Object> descMp = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertDeviceInfo", params);
			mv.addAllObjects(descMp);
		}else if(params.get("type") != null){						
			params.put("groupSeq", groupSeq);
			params.put("empSeq", empSeq);
			Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
			
			if(pinMp != null)
				mv.addAllObjects(pinMp);
			
			//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
			if(params.get("type").equals("C")){
				//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
				params.put("langCode", langCode);
				params.put("deviceNum", params.get("deviceNum"));				
				Map<String, Object> devInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getDeviceInfo", params);
				mv.addAllObjects(devInfo);
			}
		}
		
		mv.addAllObjects(params);
	 
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/scDescInfo.do")
	public ModelAndView scDescInfo(@RequestParam Map<String, Object> params,
			HttpServletRequest request) throws Exception {
	
		String groupSeq = "";
		String empSeq = "";
		String langCode = "";
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		if(loginVO == null){
			groupSeq = params.get("groupSeq") + "";
			empSeq = params.get("empSeq") + "";
			langCode = "kr";
		}else{
			groupSeq = loginVO.getGroupSeq();
			empSeq = loginVO.getUniqId();
			langCode = loginVO.getLangCode();
		}
		
	
		
		if(params.get("seq") != null){
			Map<String, Object> descMp = (Map<String, Object>) commonSql.select("SecondCertManage.selectSecondCertDeviceInfo", params);
			mv.addAllObjects(descMp);
		}else if(params.get("type") != null){						
			params.put("groupSeq", groupSeq);
			params.put("empSeq", empSeq);
			Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
			
			if(pinMp != null)
				pinMp.remove("pin");
			
			mv.addAllObjects(pinMp);
			
			//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
			if(params.get("type").equals("C")){
				//인증기기 승인요청 팝업은 요청기기에대한 정보 추가조회
				params.put("langCode", langCode);
				params.put("deviceNum", params.get("deviceNum"));				
				Map<String, Object> devInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getDeviceInfo", params);
				mv.addAllObjects(devInfo);
			}
		}
		
		mv.addAllObjects(params);
	 
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/secondCertDevUserManageView.do")
	public ModelAndView secondCertDevUserManageView(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if(!menuManageService.checkMenuAuth(loginVO, request.getServletPath())) {
			mv.setViewName( "redirect:/forwardIndex.do" );
			return mv;
		}
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("empSeq", loginVO.getUniqId());
	    Map<String, Object> secondCertInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", params);
		
		
		mv.addObject("loginVO", loginVO);
		mv.addObject("empSeq", loginVO.getUniqId());
		mv.addAllObjects(secondCertInfo);
		
		mv.setViewName("/neos/cmm/systemx/secondCertificate/secondCertDevUserManageView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/getScDevList.do")
	public ModelAndView getScDevList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		params.put("langCode", loginVO.getLangCode());
		params.put("compSeq", loginVO.getOrganId());
		params.put("userSe", loginVO.getUserSe());
		
		List<Map<String, Object>> devList = commonSql.list("SecondCertManage.getDeviceApprovalList", params);
		
		mv.addObject("devList", devList);	
		
		//사원핀번호 조회
		params.put("empSeq", loginVO.getUniqId());
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		//이차인증 설정값 조회
		Map<String, Object> scOption = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", params);
		
		mv.addObject("pinInfo", pinMp == null ? "" : pinMp);
		mv.addObject("scOptionInfo", scOption);
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/selectEmpScInfo.do")
	public ModelAndView selectEmpScInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		params.put("langCode", loginVO.getLangCode());
		params.put("compSeq", loginVO.getOrganId());
		params.put("userSe", loginVO.getUserSe());
		
		List<Map<String, Object>> devList = commonSql.list("SecondCertManage.getDeviceApprovalList", params);
		
		mv.addObject("devList", devList);	
		
		//사원핀번호 조회
		params.put("empSeq", loginVO.getUniqId());
		params.put("groupSeq", loginVO.getGroupSeq());
		Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		if(pinMp != null)
			pinMp.remove("pin");
		
		
		//이차인증 설정값 조회
		Map<String, Object> scOption = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", params);
		
		mv.addObject("pinInfo", pinMp == null ? "" : pinMp);
		mv.addObject("scOptionInfo", scOption);
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/setDeviceNickName.do")
	public ModelAndView setDeviceNickName(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
				
		commonSql.update("SecondCertManage.setDeviceNickName", params);
		
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/savePinPassWord.do")
	public ModelAndView savePinPassWord(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
				
		String langCode = "";
		if(loginVO != null){
			params.put("groupSeq", loginVO.getGroupSeq());
			langCode = loginVO.getLangCode();
		}else{
			langCode = "kr";
		}
		
				
		if(params.get("pinType").equals("F")) {
			params.put("pin", params.get("newPin"));
			commonSql.insert("SecondCertManage.savePinPassWord", params);
		}
		else if(params.get("pinType").equals("R")) {
			Map<String, Object> oldPinMap = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
			if(oldPinMap != null && oldPinMap.get("pin").equals(params.get("oldPin"))) {
				params.put("pin", params.get("newPin"));
				commonSql.insert("SecondCertManage.savePinPassWord", params);
			}
		}
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/setPinFailCnt.do")
	public ModelAndView setPinFailCnt(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if(loginVO != null) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		commonSql.insert("SecondCertManage.setPinFailCnt", params);		
		
		Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		mv.addObject("pinInfo", pinMp);
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/upatePinFailCnt.do")
	public ModelAndView upatePinFailCnt(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		if(loginVO != null) {
			params.put("groupSeq", loginVO.getGroupSeq());
		}
		
		commonSql.insert("SecondCertManage.setPinFailCnt", params);		
		
		Map<String, Object> pinMp = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);
		
		if(pinMp != null)
			pinMp.remove("pin");
		
		mv.addObject("pinInfo", pinMp);
		
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/setDeviceReg.do")
	public ModelAndView setDeviceReg(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		if(loginVO != null)	{		
			params.put("groupSeq", loginVO.getGroupSeq());
		}	

		commonSql.update("SecondCertManage.initPinFailCount", params);

		//pin코드 저장 및 업데이트
		if(params.get("pin") != null) {
			commonSql.insert("SecondCertManage.savePinPassWord", params);
		}

		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/selectScOptionInfo.do")
	public ModelAndView selectScOptionInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		Map<String, Object> scOptionInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertOptionValue", params);	    
	    Map<String, Object> pinInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getUserPinInfo", params);

	    mv.addObject("scOptionInfo", scOptionInfo);
	    mv.addObject("pinInfo", pinInfo == null ? "" : pinInfo);
	    
		mv.setViewName( "jsonView" );
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/secondCertDeviceHistoryView.do")
	public ModelAndView secondCertDeviceHistoryView(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		String userSe = loginVO.getUserSe( );
		List<Map<String, Object>> compList = null;
		
		params.put( "groupSeq", loginVO.getGroupSeq( ) );
		params.put( "langCode", loginVO.getLangCode( ) );
		params.put( "userSe", userSe );
		params.put( "empSeq", loginVO.getUniqId());
		compList = compService.getCompListAuth( params );
	
		mv.addObject( "compList", compList );
		JSONArray json = JSONArray.fromObject( compList ); 
		
		
		//인증사용자 및 인증기기 카운트 조회
		params.put("compSeq", loginVO.getOrganId());
		mv.addObject("cntInfo", (Map<String, Object>)commonSql.select("SecondCertManage.deviceInfoCnt", params));
		
		
		mv.addObject( "compListJson", json );	
		mv.addObject("loginVO", loginVO);
		
		mv.setViewName("/neos/cmm/systemx/secondCertificate/secondCertDeviceHistoryView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/selectDevUserInfoList.do")
	public ModelAndView selectDevUserInfoList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );		
		params.put("langCode", loginVO.getLangCode());
		
		List<Map<String, Object>> devList = commonSql.list("SecondCertManage.getDeviceApprovalList",  params);	
		
		mv.addObject("cntInfo", (Map<String, Object>)commonSql.select("SecondCertManage.deviceInfoCnt", params));		
		mv.addObject("devList", devList);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/userDeviceDisabled.do")
	public ModelAndView userDeviceDisabled(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );		
		
		if(params.get("type").equals("D")){
			params.put("status", "C");
			params.put("confirm_seq", loginVO.getUniqId());
			
			commonSql.update("SecondCertManage.setSecondCertDevStatus", params);
			
			//해지처리 시 토큰 로그아웃 api호출
			params.put("groupSeq", loginVO.getGroupSeq());
			List<Map<String, Object>> devList = (List<Map<String, Object>>) commonSql.list("SecondCertManage.selectSecondDevList", params);
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getGroupInfo", params);
			
			if(groupInfo != null){
				for(Map<String, Object> mp : devList){
					if(mp.get("token") != null && !mp.get("token").toString().equals("")){					
						Map<String, Object> para = new HashMap<String, Object>();
						para.put("token", mp.get("token"));
						para.put("appType", mp.get("appType"));
						para.putAll(groupInfo);
						para.put("groupSeq", loginVO.getGroupSeq());
						SecondCertificateService.secondCertTokenLogOut(para);
					}				
				}
			}
			
		}else if(params.get("type").equals("I")){
			params.put("langCode", loginVO.getLangCode());
			commonSql.delete("SecondCertManage.InitUserPinCode", params);
			
			String empName = (String) commonSql.select("SecondCertManage.getUserName", params);
			mv.addObject("empName", empName);
		}
		
		mv.addObject("type", params.get("type"));
//		mv.setViewName("/neos/cmm/systemx/secondCertificate/pop/secondCertDescPop");
		mv.setViewName("jsonView");
		
		return mv;
	}	
	
	@RequestMapping("/cmm/systemx/selectUserDevHistroyList.do")
	public ModelAndView selectUserDevHistroyList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		
		params.put("langCode", loginVO.getLangCode());
		
		List<Map<String,Object>> historyList = commonSql.list("SecondCertManage.getUserDeviceHistory", params);
		
		mv.addObject("historyList", historyList);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/getApprovalUserInfo.do")
	public ModelAndView getApprovalUserInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser( );
		String langCode = "";
		if(loginVO != null)	{		
			params.put("groupSeq", loginVO.getGroupSeq());
			langCode = loginVO.getLangCode();
		}else{
			langCode = "kr";
		}
		
		params.put("langCode", langCode);		
		Map<String, Object> devInfo = (Map<String, Object>) commonSql.select("SecondCertManage.getDeviceInfo", params);
		mv.addAllObjects(devInfo);
		
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/checkEmpPinInfo.do")
	public ModelAndView checkEmpPinInfo(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> pinInfo = (Map<String, Object>) commonSql.select("SecondCertManage.checkEmpPinInfo", params);
		mv.addObject("pinInfo", pinInfo);
		mv.setViewName("jsonView");
		return mv;
	}
}
