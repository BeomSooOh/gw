/**
 * 직급직책관리 @Controller
 * @author doban7 2016-06-23
 */
package neos.cmm.systemx.dutyPosition.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.drm.service.DrmService;
import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.annotation.IncludedInfo;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.dutyPosition.sercive.DutyPositionManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONArray;
import restful.com.controller.AttachFileController;

@Controller
public class DutyPositionManageController {

	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "DutyPositionManageService")
	private DutyPositionManageService dutyPositionService;
	
	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;
		
	/** EgovMessageSource */
	@Resource(name="egovMessageSource")
	EgovMessageSource egovMessageSource;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "attachFileController")
	private AttachFileController attachFileController;
	
	@Resource(name = "DrmService")
	private DrmService drmService;	
    
	/**
	 * 직급직책관리  view
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@IncludedInfo(name="직급직책관리", order = 140 ,gid = 60)
	@RequestMapping("/cmm/systemx/dutyPositionManageView.do")
	public ModelAndView dutyPositionManageView(@RequestParam Map<String,Object> paramMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		boolean isAuthMenu = menuManageService.checkIsAuthMenu(paramMap, loginVO);
		if(!isAuthMenu){
			mv.setViewName("redirect:/forwardIndex.do");			
			return mv;
		}
		
		
		String userSe = loginVO.getUserSe();
		paramMap.put("userSe", userSe);
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("loginId", loginVO.getId());
			
			if (userSe.equals("ADMIN")) {
				paramMap.put("empSeq", loginVO.getUniqId());
				paramMap.put("compSeq", loginVO.getCompSeq());
			}
			compList = compService.getCompListAuth(paramMap);
		}
		
		// 회사 선택으로 변경
		String compSeq = paramMap.get("compSeq")+"";
//		if (EgovStringUtil.isEmpty(paramMap.get("compSeq")+"")) {
//			paramMap.put("compSeq", loginVO.getCompSeq());
//		}
			
		if (EgovStringUtil.isEmpty(compSeq) ) {
			if(loginVO.getUserSe().equals("MASTER")){
//				paramMap.put("compSeq", compList.get(0).get("compSeq"));
				paramMap.put("compSeq", "0"); 
			}else{
				paramMap.put("compSeq", loginVO.getCompSeq());
			}
		}
		
		mv.addObject("compList", compList);
		JSONArray json = JSONArray.fromObject(compList);
		mv.addObject("compListJson", json);
		mv.addObject("params", paramMap);
		
		mv.setViewName("/neos/cmm/systemx/dutyPosition/dutyPositionManageView");
		
		return mv;
	}
	
	/**
	 * 직급/직책 조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/dutyPositionData.do")
	public ModelAndView dutyPositionData(@RequestParam Map<String,Object> paramMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		List<Map<String,Object>> list = null;
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("userSe", loginVO.getUserSe());
		paramMap.put("loginCompSeq", loginVO.getCompSeq());
		
		// 회사 선택으로 변경
//		if (EgovStringUtil.isEmpty(paramMap.get("compSeq")+"")) {
//			paramMap.put("compSeq", loginVO.getCompSeq());
//		}
		
		/** 회사 직급/직책 조회 */
		list = dutyPositionService.getDutyPositionList(paramMap);
		
		paramMap.put("option", "cm1100");
		
		Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(paramMap);
		
		if(erpOptions.get("optionRealValue").equals("0")) {
			mv.addObject("erpUse", "N");
		} else {
			mv.addObject("erpUse", "Y");
		}			
		
		mv.addObject("list", list);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 직위/직급 저장
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/dutyPositionSaveProc.do")
	public ModelAndView dutyPositionSaveProc(@RequestParam Map<String,Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

//		String result = egovMessageSource.getMessage("success.common.update");
		Map<String, Object> result = new HashMap<String,Object>();
		try{
			
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());
			paramMap.put("empSeq", loginVO.getUniqId());
			
			// 회사 선택으로 변경
			if (EgovStringUtil.isEmpty((String) paramMap.get("compSeq"))) {
				if(!loginVO.getUserSe().equals("MASTER")){
					paramMap.put("compSeq", loginVO.getCompSeq());
				}else{
					paramMap.put("compSeq", "0");
				}
			}
			
			result = dutyPositionService.insertDutyPosition(paramMap);
		}catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e);
			result.put("msg", "-1");
//			result = egovMessageSource.getMessage("fail.common.update");
		}
		
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	/**
	 * 직위/직급 삭제 
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/dutyPositionRemoveProc.do")
	public ModelAndView dutyPositionRemoveProc(@RequestParam Map<String,Object> paramMap) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());		
		
		Map<String, Object> result = new HashMap<String,Object>();
		
		try{
			result = dutyPositionService.deleteDutyPosition(paramMap);
		}catch (Exception e) {
//			result = egovMessageSource.getMessage("fail.common.delete");
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e);
			result.put("msg", "-1");
		}
		
		mv.addObject("result", result);
		
		mv.setViewName("jsonView");

		return mv;
	}
	
	/**
	 * 직위/직급 코드 중복체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/dutyPositionChkSeq.do")
	public ModelAndView dutyPositionChkSeq(@RequestParam Map<String,Object> paramMap) throws Exception {				
		
		ModelAndView mv = new ModelAndView();			
		Map<String, Object> map = new HashMap<String, Object>();		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		Integer resultCnt = dutyPositionService.getDutyPositionSeqCheck(paramMap);

		map.put("resultCnt", resultCnt);
				
		mv.setViewName("jsonView");			
		mv.addAllObjects(map);
				
		return mv;
	}
	
	/**
	 * 직위/직급 코드 중복체크
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/getDutyPositionInfo.do")
	public ModelAndView getDutyPositionInfo(@RequestParam Map<String,Object> paramMap) throws Exception {				
		
		ModelAndView mv = new ModelAndView();			
		Map<String, Object> map = new HashMap<String, Object>();		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("langCode", loginVO.getLangCode());
		paramMap.put("groupSeq", loginVO.getGroupSeq());

		Map<String, Object> result = dutyPositionService.getDutyPositionInfo(paramMap);

		mv.addObject("result", result);
				
		mv.setViewName("jsonView");			
		mv.addAllObjects(map);
				
		return mv;
	}
	
	/**
	 * 직위/직급 다국어정보
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/systemx/getDutyPositionSeqLangInfo.do")
	public ModelAndView getDutyPositionSeqLangInfo(@RequestParam Map<String,Object> paramMap) throws Exception {				
		
		ModelAndView mv = new ModelAndView();			
		Map<String, Object> map = new HashMap<String, Object>();		
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("option", "cm1100");
		
		Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(paramMap);
		
		if(erpOptions.get("optionRealValue").equals("0")) {
			mv.addObject("erpUse", "N");
		} else {
			mv.addObject("erpUse", "Y");
		}
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("compSeq", loginVO.getCompSeq());

		Map<String, Object> result = dutyPositionService.getDutyPositionSeqLangInfo(paramMap);

		
		
		mv.addObject("result", result);
				
		mv.setViewName("jsonView");			
		mv.addAllObjects(map);
				
		return mv;
	}
	
	
	@RequestMapping("/cmm/systemx/dutyPositionRegBatchPop.do")
	public ModelAndView dutyPositionRegBatchPop(@RequestParam Map<String,Object> params) throws Exception {				
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		params.put("groupSeq", loginVO.getGroupSeq());
		
		/** 그룹 정보 가져오기. 그룹명 가져오기 위해 */
		Map<String,Object> groupMap = orgChartService.getGroupInfo(params);
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("groupMap", groupMap);
		
		/** 회사 리스트 조회 */
		String userSe = loginVO.getUserSe();
		List<Map<String,Object>> compList = null;
		if (userSe != null && !userSe.equals("USER")) {
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			params.put("userSe", userSe);
			if (userSe.equals("ADMIN")) {
				params.put("empSeq", loginVO.getUniqId());
				params.put("compSeq", loginVO.getCompSeq());
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

		mv.addObject("params", params);
		mv.addObject("loginVO", loginVO);
		
		mv.setViewName("/neos/cmm/systemx/dutyPosition/pop/dutyPositionRegBatchPop");
		
		return mv;
	}
	
	
	
	
	@RequestMapping(value="/cmm/systemx/dutyPositionExcelValidate.do", method=RequestMethod.POST)//크로스사이트 요청 위조
	public ModelAndView dutyPositionExcelValidate(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
		
		  ModelAndView mv = new ModelAndView();		
		  LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();	  
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
			  String osType = NeosConstants.SERVER_OS;
			  
			  Map<String, Object> param = new HashMap<String, Object>();
			  param.put("groupSeq", loginVO.getGroupSeq());
			  param.put("pathSeq", "0");
			  param.put("osType", osType);
			  
			  Map<String, Object> pathMap = groupManageService.selectGroupPath(param);
			  
			  String savePath = "";
			  
			  if(pathMap.size() == 0) {
				  savePath = File.separator;
			  }
			  else {
				  savePath = pathMap.get("absolPath") + "/exceltemp/";
			  }
			  
			  File dir = new File(savePath);
			  
			  if(!dir.exists()){
			         dir.mkdir();
	  		  }
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;					 
					 
					 EgovFileUploadUtil.saveFile(mFile.getInputStream(), new File(saveFileName));
					 
					 
					 int index = mFile.getOriginalFilename().lastIndexOf(".");
						
					 String fileExt = mFile.getOriginalFilename().substring(index + 1);
					 String newName = mFile.getOriginalFilename().substring(0, index);				
						
					//DRM 체크
					 drmService.drmConvert("U", "", "E", savePath, newName, fileExt);
					 
				     excelContentList = excelService.procExtractExcelTemp(saveFileName);
				     
				     File path = new File(savePath);
			   			File[] fileList = path.listFiles();
			   			
			   			for(File file: fileList){
			   				if(file.getName().equals(mFile.getOriginalFilename())){
			   					file.delete();
			   				}
			   			}
				     
				  }
				  
				  if (excelContentList != null && excelContentList.size() > 0) {
					  Calendar cal = Calendar.getInstance();
					  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
					  String ts = sdf.format(cal.getTime());			  
					  int seq = 0;
					  List<Map<String, Object>> saveList = new ArrayList<Map<String, Object>>(); 
					  for (int i = 0 ; i < excelContentList.size() ; i++) {
						  Map<String,Object> map = excelContentList.get(i);
						  
						  if(!map.get("C0").toString().equals("")){
							  Map<String, Object> item = new HashMap<String, Object>();
							  item.put("batchSeq", ts);
							  item.put("dpSeq", map.get("C2"));
							  item.put("dpName", map.get("C3"));
							  
							  if(!map.get("C4").equals("")){
								  item.put("dpNameEn", map.get("C4"));
							  }
							  
							  if(!map.get("C5").equals("")){
								  item.put("dpNameJp", map.get("C5"));
							  }
							  
							  if(!map.get("C6").equals("")){
								  item.put("dpNameCn", map.get("C6"));
							  }							  
							  
							  item.put("commentText", map.get("C8"));
							  item.put("seq", seq);
							  
							  if(map.get("C1").equals(BizboxAMessage.getMessage("TX000018672","직급"))){
								  item.put("dpType", "POSITION");  
							  }else{
								  item.put("dpType", "DUTY");  
							  }
							  
							  if(!map.get("C7").equals("")){
								  item.put("orderNum", map.get("C7"));  
							  }else{
								  item.put("orderNum", map.get("num"));
							  }
							  
							  item.put("compSeq", params.get("compSeq"));
							  
							  seq++;
							  
							  saveList.add(item);
							  
						  }
					  }
					  
					  for(Map<String, Object> map : saveList){
						  commonSql.insert("DutyPositionManageService.insertDutyPositionBatch", map);
					  }					  
					  resultMap.put("retMsg", "success");
					  resultMap.put("retKey", ts);
					  
					  List<Map<String, Object>> checkList = commonSql.list("DutyPositionManageService.CheckPositionBatchInfo", resultMap);
					  mv.addObject("checkList", checkList);
				  }
				  else {
					  resultMap.put("retMsg", "fail");
					  resultMap.put("retKey", "0");
				  }
			  }
			  
		  } catch (Exception ex) {
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			  resultMap.put("retMsg", "fail");
		  }
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);
		  //System.out.println("procExcelToJSON! ======> "+arrExcelContentList);

		  resultMap.put("retData", arrExcelContentList);
		  
		  //logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());		  
		  mv.addAllObjects(resultMap);
		  mv.setViewName("jsonView");
		  return mv;
	}
	
	@RequestMapping("/cmm/systemx/saveDutyPositionBatch.do")
	public ModelAndView saveDutyPositionBatch(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		String batchKey = (String) params.get("batchKey");
		String jsonStr = (String)params.get("saveList");
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> saveList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
		
		params.put("saveList",saveList);
		params.put("batchKey",batchKey);
		params.put("langCode",loginVO.getLangCode());
		params.put("groupSeq",loginVO.getGroupSeq());
		
		List<Map<String,Object>> dutyPositionSaveList = commonSql.list("DutyPositionManageService.getDutyPositionBatchList", params);

		
		for(int i=0;i<dutyPositionSaveList.size();i++){
			Map<String, Object> dutyPositionInfo = dutyPositionSaveList.get(i);
			dutyPositionInfo.put("groupSeq", loginVO.getGroupSeq());
			dutyPositionInfo.put("empSeq", loginVO.getUniqId());
			dutyPositionInfo.put("useYn", "Y");
			dutyPositionInfo.put("multilangCode", "kr");
			
			commonSql.insert("DutyPositionManage.insertDutyPositionBatch", dutyPositionInfo);
			commonSql.insert("DutyPositionManage.insertDutyPositionMultiBatch", dutyPositionInfo);
			
			if(dutyPositionInfo.get("dpNameEn") != null && !dutyPositionInfo.get("dpNameEn").equals("")){
				dutyPositionInfo.put("dpName", dutyPositionInfo.get("dpNameEn"));
				dutyPositionInfo.put("multilangCode", "en");
				commonSql.insert("DutyPositionManage.insertDutyPositionMultiBatch", dutyPositionInfo);	
			}
			
			if(dutyPositionInfo.get("dpNameJp") != null && !dutyPositionInfo.get("dpNameJp").equals("")){
				dutyPositionInfo.put("dpName", dutyPositionInfo.get("dpNameJp"));
				dutyPositionInfo.put("multilangCode", "jp");
				commonSql.insert("DutyPositionManage.insertDutyPositionMultiBatch", dutyPositionInfo);	
			}
			
			if(dutyPositionInfo.get("dpNameCn") != null && !dutyPositionInfo.get("dpNameCn").equals("")){
				dutyPositionInfo.put("dpName", dutyPositionInfo.get("dpNameCn"));
				dutyPositionInfo.put("multilangCode", "cn");
				commonSql.insert("DutyPositionManage.insertDutyPositionMultiBatch", dutyPositionInfo);	
			}			
		}
	
		mv.addObject("dutyPositionSaveList", dutyPositionSaveList);
		mv.addObject("value", "1");
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/checkErpCompUseYn.do")
	public ModelAndView checkErpCompUseYn(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		params.put("option", "cm1100");
		
		Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(params);
		
		if(erpOptions.get("optionRealValue").equals("0")) {
			mv.addObject("erpUse", "N");
		} else {
			mv.addObject("erpUse", "Y");
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
}
