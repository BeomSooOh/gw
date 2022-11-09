package neos.cmm.systemx.empMove.web;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.empdept.service.EmpDeptManageService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import net.sf.json.JSONArray;

@Controller
public class EmpMoveManageController {
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
	
	@Resource(name = "OrgAdapterService")
	private OrgAdapterService orgAdapterService;		

	@Resource(name = "OrgAdapterDAO")
    private OrgAdapterDAO orgAdapterDAO;	
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;	
	
	@Resource(name = "EmpDeptManageService")
    private EmpDeptManageService empDeptManageService;
	
	@Resource(name = "ExcelService")
	private ExcelService excelService;

	 @RequestMapping("/cmm/systemx/empMoveManageView.do")
	   	public ModelAndView empMoveManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
		 	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			ModelAndView mv = new ModelAndView();
			
			params.put("groupSeq", loginVO.getGroupSeq());
			
			boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
			if(!isAuthMenu){
				mv.setViewName("redirect:/forwardIndex.do");			
				return mv;
			}
			
			/** 회사 리스트 조회 */
			String userSe = loginVO.getUserSe();
			List<Map<String,Object>> compList = null;
			if (userSe != null && !userSe.equals("USER")) {
				params.put("groupSeq", loginVO.getGroupSeq());
				params.put("langCode", loginVO.getLangCode());
				params.put("userSe", userSe);
				
				if (userSe.equals("ADMIN")) {
					params.put("compSeq", loginVO.getCompSeq());
					params.put("empSeq", loginVO.getUniqId());
				}
				compList = compService.getCompListAuth(params);
			}
			mv.addObject("compList", compList);
			JSONArray json = JSONArray.fromObject(compList);
			mv.addObject("compListJson", json);
			
			/** 현재 회사 선택 */
			String compSeq = params.get("compSeq")+"";
			if (EgovStringUtil.isEmpty(compSeq) ) {
				if(loginVO.getUserSe().equals("MASTER")){
					//마스터일경우 회사선택 가능
					if(compList!=null) {//Null Pointer 역참조
					params.put("compSeq", compList.get(0).get("compSeq"));
					}
				}else{
					//admin일경우 자기가 속한 회사 선택 
					params.put("compSeq", loginVO.getCompSeq());	
				}	
			}
			
			/** 부서 조회 */
			//List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(params);
			//OrgChartTree tree = orgChartService.getOrgChartTree(list, params);
			//JSONArray deptListJson = JSONArray.fromObject(tree.getRoot());
			//mv.addObject("deptListJson", deptListJson);
			//System.out.println(deptListJson);
			mv.addObject("params", params);
			mv.addObject("loginVO", loginVO);
		 
		 mv.setViewName("/neos/cmm/systemx/empMove/empMoveManageView");
		 
		 return mv;
	 }
	 
	 @RequestMapping("/cmm/systemx/empMovePopView.do")
	   	public ModelAndView empMovePopView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
		 ModelAndView mv = new ModelAndView();
		 
		 mv.addObject("compSeq", params.get("formCompSeq"));
		 mv.addObject("formEmpInfoList", params.get("formEmpInfoList"));
		 mv.addAllObjects(params);
		 
		 mv.setViewName("/neos/cmm/systemx/empMove/pop/empMovePop");
		 return mv;
	 }
	 
	 
	 @RequestMapping("/cmm/systemx/empMoveSaveProc.do")
	   	public ModelAndView empMoveSaveProc(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
		 ModelAndView mv = new ModelAndView();
		 
		 String empList = params.get("empList") + "";		
		 String compSeq = params.get("compSeq") + "";		
		 
		 String eaEmpSeqList = params.get("eaEmpSeqList") + "";
		 String eaDeptSeqList = params.get("eaDeptSeqList") + "";
		 String eaEmpNmList = params.get("eaEmpNmList") + "";
		 
		 String[] arrEmpInfo = empList.split("\\|");
		 
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		 Map<String, Object> oldDeptMap = new HashMap<String, Object>();
		 Map<String, Object> newDeptMap = new HashMap<String, Object>();
		 
		 for(int i=0;i<arrEmpInfo.length;i++){
			 
			 String newDeptSeq = params.get("newDeptSeq") + "";
			 String newPositionCode = params.get("newPositonCode") + "";
			 String newDutyCode = params.get("newDutyCode") + "";
			 
			 String empSeq = arrEmpInfo[i].split("▦")[0];
			 String oldDeptSeq = arrEmpInfo[i].split("▦")[1];
			 
			 boolean deptChange = true;
			 boolean positionChange = true;
			 boolean dutyChange = true;
			 
			 if(!eaEmpSeqList.equals("")){
				 String[] arrEaEmpSeqList = eaEmpSeqList.split(",");
				 
				 for(int j=0;j<arrEaEmpSeqList.length;j++){
					 if(empSeq.equals(arrEaEmpSeqList[j])){
						 deptChange = false;
						 break;
					 }
				 }
			 }
			 
			 Map<String, Object> param = new HashMap<String, Object>();
			 
			 param.put("langCode", loginVO.getLangCode());
			 param.put("empSeq", empSeq);
			 param.put("compSeq", compSeq);
			 param.put("deptSeq", oldDeptSeq);
			 oldDeptMap = (Map<String, Object>) commonSql.select("EmpDeptManage.SelectEmpAllInfoByEmpMove", param);
			 
			 if(newDeptSeq.equals("") || newDeptSeq.equals(oldDeptSeq)){
				 deptChange = false;
				 newDeptSeq = oldDeptSeq;
			 }
			 
			 if(newPositionCode.equals("") || (oldDeptMap.get("deptPositionCode") != null && oldDeptMap.get("deptPositionCode").equals(newPositionCode))){
				 positionChange = false;
			 }
			 
			 if(newDutyCode.equals("") || (oldDeptMap.get("deptDutyCode") != null && oldDeptMap.get("deptDutyCode").equals(newDutyCode))){
				 dutyChange = false;
			 }
			 
			 Map<String, Object> paraMap = new HashMap<String, Object>();
			 paraMap.put("empSeq", empSeq);
			 paraMap.put("oldDeptSeq", oldDeptSeq);
			 paraMap.put("newDeptSeq", newDeptSeq);
			 paraMap.put("compSeq", compSeq);
			 paraMap.put("deptSeq", newDeptSeq);

			 Map<String, Object> newDeptInfo = (Map<String, Object>) commonSql.select("DeptManage.getDeptInfo", paraMap);
		 
			 //부서변경
			 paraMap.put("flagOldDeptSeq", "Y");
			 paraMap.put("deptSeq", oldDeptSeq);
			 oldDeptMap = (Map<String, Object>) commonSql.select("EmpDeptManage.SelectEmpAllInfoByEmpMove", paraMap);			 
			 
			 if(deptChange || positionChange || dutyChange){
				 Map<String, Object> adapter = new HashMap<String, Object>();
				 adapter.put("callType", "saveEmpDept");
				 adapter.put("createSeq", loginVO.getUniqId());
				 adapter.put("groupSeq", loginVO.getGroupSeq());
				 adapter.put("compSeq", compSeq);
				 adapter.put("deptSeq", oldDeptSeq);
				 adapter.put("empSeq", empSeq);
				 adapter.put("mainCompYn", oldDeptMap.get("mainCompYn"));
				 
				 if(deptChange){
					 adapter.put("deptSeqNew", newDeptSeq);
				 }
				 
				 if(positionChange){
					 adapter.put("positionCode", newPositionCode);
				 }
				 
				 if(dutyChange){
					 adapter.put("dutyCode", newDutyCode);
				 }
				 
				 Map<String, Object> empSaveAdapterResult = orgAdapterService.empSaveAdapter(adapter);
				 
 				// mailSync호출
 				if(adapter.get("compSeq") != null){
 					orgAdapterService.mailUserSync(params);    					
 				} 					 

 				/*
				if(empSaveAdapterResult.get("resultCode").equals("fail")){
					 
				}else{
					 
				}
				*/
				 
				 //인사이동현황 저장
				 if(deptChange) {
					 paraMap.put("deptSeq", newDeptSeq);
				 }
				 else {
					 paraMap.put("deptSeq", oldDeptSeq);
				 }
				 
				 newDeptMap = (Map<String, Object>) commonSql.select("EmpDeptManage.SelectEmpAllInfoByEmpMove", paraMap);
				 
				 if(newDeptMap != null && oldDeptMap != null){
					 Map<String, Object> historyMap = new HashMap<String, Object>();
					 historyMap.put("compSeq", compSeq);
					 historyMap.put("empSeq", empSeq);
					 historyMap.put("newDeptSeq", newDeptSeq);
					 historyMap.put("newDeptNm", newDeptMap.get("deptName")+"");
					 historyMap.put("newDeptPathNm", newDeptMap.get("pathName")+"");
					 historyMap.put("newPositionCode", newDeptMap.get("deptPositionCode")+"");
					 historyMap.put("newPositionNm", newDeptMap.get("deptPositionNm")+"");
					 historyMap.put("newDutyCode", newDeptMap.get("deptDutyCode")+"");
					 historyMap.put("newDutyNm", newDeptMap.get("deptDutyNm")+"");
					 historyMap.put("oldDeptSeq", oldDeptSeq);
					 historyMap.put("oldDeptNm", oldDeptMap.get("deptName")+"");
					 historyMap.put("oldDeptPathNm", oldDeptMap.get("pathName")+"");
					 historyMap.put("oldPositionCode", oldDeptMap.get("deptPositionCode")+"");
					 historyMap.put("oldPositionNm", oldDeptMap.get("deptPositionNm")+"");
					 historyMap.put("oldDutyCode", oldDeptMap.get("deptDutyCode")+"");
					 historyMap.put("oldDutyNm", oldDeptMap.get("deptDutyNm")+"");
					 historyMap.put("createSeq", loginVO.getUniqId());
					 commonSql.insert("EmpDeptManage.InsertEmpMoveHistory", historyMap);				 
				 }
				 
				//edms 사원 동기화 api호출
//				BufferedReader in = null;
//				try {
//					String sUrl = CommonUtil.getApiCallDomain(request) + "/edms/home/convUser.do?group_seq=" + loginVO.getGroupSeq() + "&comp_seq=" + compSeq + "&emp_seq=" + empSeq;			
//				URL obj = new URL(sUrl); // 호출할 url            
//				HttpURLConnection con = (HttpURLConnection)obj.openConnection(); 
//				con.setRequestMethod("GET"); 
//				in = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));        
//				String line;
//				while((line = in.readLine()) != null) { // response를 차례대로 출력
//				        System.out.println(line);
//				    }
//				} catch(Exception e) {
//				    e.printStackTrace();
//				} finally {
//				    if(in != null) try { in.close(); } catch(Exception e) { e.printStackTrace(); }
//				}				 
			 }
		 }
		
		 mv.setViewName("jsonView");
		 return mv;
	 }
	 
	 
	 
	 
	 
	 @RequestMapping("/cmm/systemx/empMoveHistoryManageView.do")
	   	public ModelAndView empMoveHistoryManageView(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception{
		 	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			ModelAndView mv = new ModelAndView();
			
			params.put("groupSeq", loginVO.getGroupSeq());
			
			boolean isAuthMenu = menuManageService.checkIsAuthMenu(params, loginVO);
			if(!isAuthMenu){
				mv.setViewName("redirect:/forwardIndex.do");			
				return mv;
			}
			
			/** 회사 리스트 조회 */
			String userSe = loginVO.getUserSe();
			List<Map<String,Object>> compList = null;
			if (userSe != null && !userSe.equals("USER")) {
				params.put("groupSeq", loginVO.getGroupSeq());
				params.put("langCode", loginVO.getLangCode());
				params.put("userSe", userSe);
				
				if (userSe.equals("ADMIN")) {
					params.put("compSeq", loginVO.getCompSeq());
					params.put("empSeq", loginVO.getUniqId());
				}
				compList = compService.getCompListAuth(params);
			}
			mv.addObject("compList", compList);
			JSONArray json = JSONArray.fromObject(compList);
			mv.addObject("compListJson", json);
			
			/** 현재 회사 선택 */
			String compSeq = params.get("compSeq")+"";
			if (EgovStringUtil.isEmpty(compSeq) ) {
				if(loginVO.getUserSe().equals("MASTER")){
					//마스터일경우 회사선택 가능
					if(compList!=null) {//Null Pointer 역참조
					params.put("compSeq", compList.get(0).get("compSeq"));
					}
				}else{
					//admin일경우 자기가 속한 회사 선택 
					params.put("compSeq", loginVO.getCompSeq());	
				}	
			}
			
			/** 부서 조회 */
			//List<Map<String,Object>> list = orgChartService.selectCompBizDeptListAdmin(params);
			//OrgChartTree tree = orgChartService.getOrgChartTree(list, params);
			//JSONArray deptListJson = JSONArray.fromObject(tree.getRoot());
			//mv.addObject("deptListJson", deptListJson);
			//System.out.println(deptListJson);
			mv.addObject("params", params);
			mv.addObject("loginVO", loginVO);
		 
		 mv.setViewName("/neos/cmm/systemx/empMove/empMoveHistoryManageView");
		 
		 return mv;
	 }
	 
	 
	 
	 @RequestMapping("/cmm/systemx/empMoveHistoryData.do")
	 public ModelAndView empListData(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		 ModelAndView mv = new ModelAndView();
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		 params.put("langCode", loginVO.getLangCode());
		 
		 PaginationInfo paginationInfo = new PaginationInfo();
		 
		 paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
		 paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
		 
		 Map<String,Object> listMap = empDeptManageService.selectEmpMoveHistoryData(params, paginationInfo);

		 mv.addAllObjects(listMap);
			
		 mv.setViewName("jsonView");
			
		 return mv;
	 }
	 
	 
	 
	 
	 @RequestMapping("/cmm/systemx/empMoveHistoryExcelDown.do")
	 public void empMoveHistoryExcelDown(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		 ModelAndView mv = new ModelAndView();
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		 params.put("langCode", loginVO.getLangCode());		
		 
		 List<Map<String,Object>> list = commonSql.list("EmpDeptManage.SelectEmpMoveHistoryExcelList", params);
		 
		 String[] colName = new String[10];
		 colName[0] = BizboxAMessage.getMessage("TX800000041","변경일");
		 colName[1] = BizboxAMessage.getMessage("TX000021259","회사명");
		 colName[2] = BizboxAMessage.getMessage("TX000013628","사원명(ID)");
		 colName[3] = BizboxAMessage.getMessage("TX000003305","재직여부");
		 colName[4] = BizboxAMessage.getMessage("TX800000042","변경 부서");
		 colName[5] = BizboxAMessage.getMessage("TX800000043","변경 직급");
		 colName[6] = BizboxAMessage.getMessage("TX800000044","변경 직책");
		 colName[7] = BizboxAMessage.getMessage("TX800000045","이전 부서");
		 colName[8] = BizboxAMessage.getMessage("TX800000046","이전 직급");
		 colName[9] = BizboxAMessage.getMessage("TX800000047","이전 직책");
		 
		 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	     Calendar c1 = Calendar.getInstance();
		 String strToday = sdf.format(c1.getTime());
		
		 String fileNm = "BizboxA_EmpMoveHistory_" + strToday;
		 
		 excelService.CmmExcelDownload(list, colName, fileNm, response, request);
	 }
	 
	 
	 
	 @RequestMapping("/cmm/systemx/checkEaDocList.do")
	 public ModelAndView checkEaDocList(@RequestParam Map<String,Object> params, HttpServletRequest request, HttpServletResponse response) throws Exception {
		 ModelAndView mv = new ModelAndView();
		 LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		 
		 String empInfoList = params.get("empInfoList") + "";
		 
		 String[] arrEmpInfoList = empInfoList.split("\\|");		 
		 String checkEmpList = "";
		 
		 for(int i=0;i<arrEmpInfoList.length;i++){
			 String[] arrEmpInfo = arrEmpInfoList[i].split("▦");
			 
			 Map<String, Object> mp = new HashMap<String, Object>();
			 
			 mp.put("empSeq", arrEmpInfo[0]);
			 mp.put("deptSeq", arrEmpInfo[1]);
			 
			 String eaMap = (String)commonSql.select("EmpDeptManage.getEaDocCnt", mp);
			 
			 if(!eaMap.equals("0")){
				 checkEmpList += "|" + arrEmpInfo[0] + "▦" + arrEmpInfo[1] + "▦" + arrEmpInfo[2]; 
			 }
		 }
		 
		 if(checkEmpList.length() > 0) {
			 checkEmpList = checkEmpList.substring(1);
		 }
		 
		 mv.addObject("checkEmpList", checkEmpList);
		 
		 mv.setViewName("jsonView");
		
			
		 return mv;
	 }
	  
}
