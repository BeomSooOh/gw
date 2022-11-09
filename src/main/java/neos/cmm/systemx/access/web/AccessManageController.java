package neos.cmm.systemx.access.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.SessionVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.access.service.AccessManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import net.sf.json.JSONArray;

@Controller
@SessionAttributes(types=SessionVO.class)
public class AccessManageController {
	//private static final Logger logger = LoggerFactory.getLogger(BizboxTimelineController.class);
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "AccessManageService")
	private AccessManageService accessService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@RequestMapping("/cmm/systemx/accessSetManageView.do")
    public ModelAndView accessSetManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		ModelAndView mv = new ModelAndView();		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String compSeq = "";
//		
		if(!loginVO.getUserSe().equals("MASTER")){
			if (EgovStringUtil.isEmpty(compSeq)) {
				compSeq = loginVO.getCompSeq();	
			}	
		}

		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", userSe);
		compList = compService.getCompListAuth(params);
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		params.put("compSeq", compSeq);
		mv.addObject("loginVO", loginVO);		
				
		mv.setViewName("/neos/cmm/systemx/access/accessManageView");
		mv.addObject("params", params);	
		
		return mv;		
	}
	

	@RequestMapping("/cmm/systemx/accessIpRegPop.do")
    public ModelAndView accessIpRegPop(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String isNew = "Y";
		if(!params.get("accessId").equals("")){
			Map<String, Object> accessIpInfo = accessService.getAccessIpInfo(params);
			String startIp = accessIpInfo.get("startIp")+"";
			String[] arrStartIp = startIp.split("\\.");
			mv.addObject("startIp_1", arrStartIp[0]);
			mv.addObject("startIp_2", arrStartIp[1]);
			mv.addObject("startIp_3", arrStartIp[2]);
			mv.addObject("startIp_4", arrStartIp[3]);
			
			String endIp = accessIpInfo.get("endIp")+"";
			String[] arrEndIp = endIp.split("\\.");
			mv.addObject("endIp_1", arrEndIp[0]);
			mv.addObject("endIp_2", arrEndIp[1]);
			mv.addObject("endIp_3", arrEndIp[2]);			
			mv.addObject("endIp_4", arrEndIp[3]);
			
			
			mv.addObject("accessIpInfo", accessIpInfo);
			isNew = "N";
		}
		mv.addObject("isNew", isNew);
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("langCode", loginVO.getLangCode());
		params.put("empSeq", loginVO.getUniqId());
		params.put("userSe", userSe);
		compList = compService.getCompListAuth(params);
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		
		
		mv.setViewName("/neos/cmm/systemx/access/pop/accessIpRegPop");		
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/accessIpSaveProc.do")
    public ModelAndView accessIpSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		params.put("empSeq", loginVO.getUniqId());
		params.put("groupSeq", loginVO.getGroupSeq());
		
		if(params.get("accessId").toString().equals("")){
			int accessId = accessService.getNewAccessId(params);
			params.put("accessId", accessId);
		}
		
		//정렬순서 공백 및 null 체크
		String orderNum = (String)params.get("orderNum");
		if (EgovStringUtil.isEmpty(orderNum)){
			params.put("orderNum", null);
		}
		accessService.accessIpSaveProc(params);
		
		
		mv.setViewName("/neos/cmm/systemx/access/pop/accessIpRegPop");
		
		return mv;
	}
		
		
		
	@RequestMapping("/cmm/systemx/getAccessIpList.do")
    public ModelAndView getAccessIpList(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		/**IP대역 목록 조회 */
		params.put("langCode", loginVO.getLangCode());
		List<Map<String, Object>> list = accessService.getAccessIpList(params);
		mv.addObject("accessIpList", list);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/deleteAccessIp.do")
    public ModelAndView deleteAccessIp(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		accessService.deleteAccessIp(params);
		accessService.deleteAccessRelate(params);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/AccessRelateSaveProc.do")
    public ModelAndView AccessRelateSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String accessId = params.get("accessId")+"";
		String[] arrGbnOrg = (params.get("arrGbnOrg")+"").split("\\,");
		String[] arrCompSeq = (params.get("arrCompSeq")+"").split("\\,");
		String[] arrDeptSeq = (params.get("arrDeptSeq")+"").split("\\,");
		String[] arrEmpSeq = (params.get("arrEmpSeq")+"").split("\\,");
		int idx = 0;
		
		commonSql.delete("AcessManage.accessRelateDelProc", params);
		
		for(int i=0;i<arrGbnOrg.length;i++){
			Map<String, Object> paraMap = new HashMap<String, Object>();
			paraMap.put("accessId", accessId);
			paraMap.put("gbnOrg", arrGbnOrg[i]);
			paraMap.put("compSeq", arrCompSeq[i]);
			paraMap.put("deptSeq", arrDeptSeq[i]);
			if(arrGbnOrg[i].equals("u")) {
				paraMap.put("empSeq", arrEmpSeq[i]);
			}
			else {
				paraMap.put("empSeq", "");
			}
			paraMap.put("groupSeq", loginVO.getGroupSeq());
			paraMap.put("createSeq", loginVO.getUniqId());
			paraMap.put("idx", idx);			
			commonSql.insert("AcessManage.accessRelateSaveProc", paraMap);
			idx++;
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/GetAccessRelateInfo.do")
    public ModelAndView GetAccessRelateInfo(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();	
		
		params.put("langCode", loginVO.getLangCode());
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> list = commonSql.list("AcessManage.getAccessRelateList", params);
		
		mv.addObject("list", list);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/deleteAccessRelate.do")
    public ModelAndView deleteAccessRelate(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		//LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		commonSql.delete("AcessManage.deleteAccessRelate", params);
		
		mv.setViewName("jsonView");
		return mv;
	}
}
