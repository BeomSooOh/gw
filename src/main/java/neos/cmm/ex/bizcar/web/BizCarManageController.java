package neos.cmm.ex.bizcar.web;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.ex.bizcar.service.BizCarManageService;
import neos.cmm.systemx.comp.dao.ExCodeOrgiCUBEDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import restful.com.controller.AttachFileController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import api.drm.service.DrmService;

@SuppressWarnings("unused")
@Controller
public class BizCarManageController {
	
	@Resource(name = "BizCarManageService")
	private BizCarManageService bizCarManageService;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "ExCodeOrgiCUBEDAO")
	private ExCodeOrgiCUBEDAO exCodeOrgDAO;
	
	@Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
	@Resource(name = "attachFileController")
	private AttachFileController attachFileController;
	
	@Resource(name = "DrmService")
	private DrmService drmService;		
	
	private ConnectionVO conVo = new ConnectionVO();
	
		
	/**
	 * 업무용승용차관리 운행기록부 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @author 조영욱
	 */
	@RequestMapping("/cmm/ex/bizcar/bizCarManageView.do")
	public ModelAndView bizCarManageView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 운행기록부 페이지");
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("loginVo", loginVO);
		mv.setViewName("/neos/cmm/ex/bizcar/bizCarManageView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/bizCarDataList.do")
	public ModelAndView bizCarDataList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		////System.out.println("운행기록부 페이지 리스트가져오기");
		ModelAndView mv = new ModelAndView();
		
		int result = 0;
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		List<Map<String,Object>> bizCarDataList = bizCarManageService.getBizCarDataList(paramMap);
			
		////System.out.println("bizCarDataList=="+bizCarDataList);
		mv.addObject("list", bizCarDataList);
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/detailRowData.do")
	public ModelAndView detailRowData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		List<Map<String,Object>> detailRowData = bizCarManageService.getDetailRowData(paramMap);
		
		mv.addObject("result", detailRowData);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/insertBizCarData.do")
	public ModelAndView insertBizCarData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		int result = 0;
		// IP가져오기 (localhost로 접속했을때는 0:0:0:0:0:0:0:1로 가져옴)
		paramMap.put("ipAddress",  CommonUtil.getClientIp(request));
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq",loginVO.getOrgnztId());
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("erpCompSeq",loginVO.getErpCoCd());
		paramMap.put("erpEmpSeq",loginVO.getErpEmpCd());
		
		if(paramMap.get("startTime").toString().indexOf(":") > -1) {
			paramMap.put("startTime", paramMap.get("startTime").toString().replace(":", "")); //출발시간
		}
		
		if(paramMap.get("endTime").toString().indexOf(":") > -1) {
			paramMap.put("endTime", paramMap.get("endTime").toString().replace(":", "")); //도착시간
		}
		
		try{
			bizCarManageService.insertBizCarData(paramMap);
			result = 1;
		}catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/deleteBizCarData.do")
	public ModelAndView deleteBizCarData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		bizCarManageService.deleteBizCarData(paramMap);
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/saveBookMarkList.do")
	public ModelAndView saveBookMarkList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		int result = 0;
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq",loginVO.getOrgnztId());
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("erpCompSeq",loginVO.getErpCoCd());
		paramMap.put("erpEmpSeq",loginVO.getErpEmpCd());
		
		try{
			bizCarManageService.saveBookMarkList(paramMap);
			result = 1;
		}catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/updateAmtData.do")
	public ModelAndView updateAmtData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		int result = 0;
		int totalAmt = 0;
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq",loginVO.getOrgnztId());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		int oilAmt = CommonUtil.getIntNvl(paramMap.get("oilAmt").toString());
		int tollAmt = CommonUtil.getIntNvl(paramMap.get("tollAmt").toString());
		int parkingAmt = CommonUtil.getIntNvl(paramMap.get("parkingAmt").toString());
		int repairAmt = CommonUtil.getIntNvl(paramMap.get("repairAmt").toString());
		int etcAmt = CommonUtil.getIntNvl(paramMap.get("etcAmt").toString());
		
		paramMap.put("oilAmt",oilAmt);
		paramMap.put("tollAmt",tollAmt);
		paramMap.put("parkingAmt",parkingAmt);
		paramMap.put("repairAmt",repairAmt);
		paramMap.put("etcAmt",etcAmt);
		
		try {
			bizCarManageService.updateAmtData(paramMap);
			//업데이트 된 합계 다시 뷰로 넘기기
			totalAmt += oilAmt;
			totalAmt += tollAmt;
			totalAmt += parkingAmt;
			totalAmt += repairAmt;
			totalAmt += etcAmt;
			
			result = 1;

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}
		
		mv.addObject("result", result);
		mv.addObject("totalAmt", totalAmt);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarNumSearchPop.do")
	public ModelAndView bizCarNumSearchPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		////System.out.println("여기 차량번호조회");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		mv.addObject("carNum", request.getParameter("carNum"));
		if (request.getParameter("rowSeq") != null){
			mv.addObject("rowSeq", request.getParameter("rowSeq"));
		}else{
			mv.addObject("rowSeq", "");
		}
			
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarNumSearchPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarErpSearch.do")
	public ModelAndView bizCarErpSearch(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		//System.out.println("iCUBE 차량검색");
		
		try {
			//erp 시스템정보 조회
			List<Map<String, Object>> list = compService.getErpConList(paramMap);
			//System.out.println("getErpConList===??"+list);
			if(list.size() != 0){
				String driver = list.get(0).get("driver") + "";
				String url = list.get(0).get("url") + "";
				String dataBaseType = list.get(0).get("databaseType") + "";
				String systemType = list.get(0).get("erpTypeCode") + "";
				String userid = list.get(0).get("userid") + "";
				String password = list.get(0).get("password") + "";
				String text = request.getParameter("carNum");
				
				//System.out.println("systemType===::"+systemType);
				if(systemType.equals("iCUBE")){
					
					//erp서버 정보 가져오기.
					conVo.setDriver(driver);
					conVo.setUrl(url);			
					conVo.setDatabaseType(dataBaseType);
					conVo.setSystemType(systemType);
					conVo.setUserId(userid);
					conVo.setPassWord(password);
					
					paramMap.put("loginVO", loginVO);
					paramMap.put("erpCompSeq", list.get(0).get("erpCompSeq"));
					paramMap.put("erpCoCd", loginVO.getErpCoCd());
					paramMap.put("erpEmpCd", loginVO.getErpEmpCd());
					//System.out.println("loginVO.getErpEmpCd() = "+loginVO.getErpEmpCd());
					if(!EgovStringUtil.isEmpty(loginVO.getErpEmpCd())){
						// icube 사원정보에서 사업장정보 가져오기
						List<Map<String, Object>> bizCarErpEmpInfo = exCodeOrgDAO.getBizCarErpEmpInfo(paramMap, conVo);
						if(bizCarErpEmpInfo.size() != 0){
							String erpBizSeq = bizCarErpEmpInfo.get(0).get("erpBizSeq")+"";
							String erpDeptSeq = bizCarErpEmpInfo.get(0).get("erpDeptSeq")+"";
							paramMap.put("erpBizSeq", erpBizSeq);
							loginVO.setErpBizCd(erpBizSeq); //loginVO에 erp사업장코드 set
							loginVO.setErpDeptCd(erpDeptSeq); //loginVO에 erp부서코드 set
						}
						
						// icube 등록 차량조회
						List<Map<String, Object>> bizCarNumList = exCodeOrgDAO.getBizCarNumList(paramMap, conVo);
						//System.out.println(" icube에서 가져윤 bizCarList  : " + bizCarNumList);
						
						// 결과값에서 검색키워드로 (차량번호, 차량코드, 차종)검색후 다시 bizCarNumList2 리스트에 담음
						List<Map<String, Object>> bizCarNumList2 = new ArrayList<Map<String,Object>>();
						int cnt = 0;
						for(int i=0; i<bizCarNumList.size(); i++ ) {
							boolean chk = false;
							
							if (bizCarNumList.get(i).get("CAR_NB").toString().contains(text)){
								chk = true;
							}else if (bizCarNumList.get(i).get("CAR_NM").toString().contains(text)){
								chk = true;
							}else if (bizCarNumList.get(i).get("CAR_CD").toString().contains(text)){
								chk = true;
							}
							
							if (chk){
								bizCarNumList2.add(cnt, bizCarNumList.get(i));
								cnt ++;
							}
													
						}
						//System.out.println(" bizCarList2  : " + bizCarNumList2);

						// 반환처리
						mv.addObject("bizCarNumList2", bizCarNumList2);
						mv.addObject("bizCarNumList", bizCarNumList);
						
					}else{
						//System.out.println("==========ERP 사원연동정보가 없습니다.========== ");
						mv.addObject("result", "ERP 사원연동이 되어있지 않습니다.");	
						mv.addObject("bizCarNumList", "");
					}
					
				}else{
					//System.out.println("==========ERP타입이 icube가 아닙니다.========== ");
					mv.addObject("result", "ERP연동이 icube가 아닙니다.");	
					mv.addObject("bizCarNumList", "");
				}
				
			}
			else{
				mv.addObject("result", BizboxAMessage.getMessage("TX000011769","ERP연결 정보가 존재하지 않습니다"));		
				mv.addObject("bizCarNumList", "");
			}
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/getBizCarErpCloseDt.do")
	public ModelAndView getBizCarErpCloseDt(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		//System.out.println("iCUBE 사원정보 DIV검색");
		ModelAndView mv = new ModelAndView();

		try {
			//erp 시스템정보 사원정보 조회
			List<Map<String, Object>> list = compService.getErpConList(paramMap);
			if(list.size() != 0){
				String driver = list.get(0).get("driver") + "";
				String url = list.get(0).get("url") + "";
				String dataBaseType = list.get(0).get("databaseType") + "";
				String systemType = list.get(0).get("erpTypeCode") + "";
				String userid = list.get(0).get("userid") + "";
				String password = list.get(0).get("password") + "";
				
				//System.out.println("systemType===::"+systemType);
				if(systemType.equals("iCUBE")){
					//erp서버 정보 가져오기.
					conVo.setDriver(driver);
					conVo.setUrl(url);			
					conVo.setDatabaseType(dataBaseType);
					conVo.setSystemType(systemType);
					conVo.setUserId(userid);
					conVo.setPassWord(password);
					
					paramMap.put("loginVO", loginVO);
					paramMap.put("erpCompSeq", list.get(0).get("erpCompSeq"));
					paramMap.put("erpCoCd", loginVO.getErpCoCd());
					paramMap.put("erpEmpCd", loginVO.getErpEmpCd());
					////System.out.println("loginVO.getErpEmpCd() = "+loginVO.getErpEmpCd());
					if(!EgovStringUtil.isEmpty(loginVO.getErpEmpCd())){
						// icube 사원정보에서 사업장정보 가져오기
						List<Map<String, Object>> bizCarErpEmpInfo = exCodeOrgDAO.getBizCarErpEmpInfo(paramMap, conVo);
						//System.out.println(" icube에서 가져온 사용자정보  : " + bizCarErpEmpInfo);
						if(bizCarErpEmpInfo.size() != 0){
							String erpBizSeq = bizCarErpEmpInfo.get(0).get("erpBizSeq")+"";
							String erpDeptSeq = bizCarErpEmpInfo.get(0).get("erpDeptSeq")+"";
							paramMap.put("erpBizSeq", erpBizSeq);
							loginVO.setErpBizCd(erpBizSeq); //loginVO에 erp사업장코드 set
							loginVO.setErpDeptCd(erpDeptSeq); //loginVO에 erp부서코드 set
							
							// icube 운행기록부 마감 여부체크
							List<Map<String, Object>> bizCarErpCloseChk = exCodeOrgDAO.getBizCarErpCloseChk(paramMap, conVo);
							//String bizCarCloseYn = bizCarErpCloseChk.get(0).get("erpCloseYn")+""; // 해당 컬럼 CLOSE_YN은 ERP쪽에서 사용안함
							String bizCarCloseDt = bizCarErpCloseChk.get(0).get("erpCloseDt")+"";
							//System.out.println("업무용승용차 마감 일자="+bizCarCloseDt);
							
							//마감일자 yyyymmdd 형식을 yyyy-mm-dd 형식으로 문자열변환 
							SimpleDateFormat beforeFormat = new SimpleDateFormat("yyyymmdd");
							SimpleDateFormat afterFormat = new SimpleDateFormat("yyyy-mm-dd");
							java.util.Date tempDate = null;
							tempDate = beforeFormat.parse(bizCarCloseDt);
							String transDate = afterFormat.format(tempDate);
							
							//현재일자 반환
							/*Date nowDate = new Date();
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
							String todayDate = sdf.format(nowDate);*/

							// 반환처리
							//mv.addObject("bizCarCloseYn", bizCarCloseYn); //마감여부 0:진행중,1:마감 <-- ERP 안씀
							//mv.addObject("todayDate", todayDate); //현재일자 반환
							mv.addObject("bizCarCloseDt", transDate); //운행기록 마감일자 기준으로 마감여부 결정
						}else{
							mv.addObject("bizCarCloseDt", "");
						}
					}else{
						//System.out.println("==========ERP 사원연동정보가 없습니다.========== ");
						mv.addObject("result", "ERP 사원연동이 되어있지 않습니다.");	
						mv.addObject("bizCarErpEmpInfo", "");
						mv.addObject("bizCarCloseDt", "");
					}								
				}else{
					//System.out.println("==========ERP타입이 icube가 아닙니다.========== ");
					mv.addObject("result", "ERP연동이 icube가 아닙니다.");	
					mv.addObject("bizCarErpEmpInfo", "");
					mv.addObject("bizCarCloseDt", "");
				}				
			}
			else{
				mv.addObject("result", BizboxAMessage.getMessage("TX000011769","ERP연결 정보가 존재하지 않습니다"));		
				mv.addObject("bizCarErpEmpInfo", "");
				mv.addObject("bizCarCloseDt", "");
			}
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/bizCarErpDataInsert.do")
	public ModelAndView bizCarErpDataInsert(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		int result = 0;
		//System.out.println("iCUBE 사원정보 DIV검색");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("erpCompSeq", loginVO.getErpCoCd());
		paramMap.put("erpBizSeq", loginVO.getErpBizCd());
		paramMap.put("erpEmpSeq", loginVO.getErpEmpCd());
		paramMap.put("erpDeptSeq", loginVO.getErpDeptCd());
		
		JSONArray sendList = JSONArray.fromObject(paramMap.get("sendList"));
		JSONObject rowObj = new JSONObject();
		
		for(int i=0; i<sendList.size(); i++){
			rowObj = JSONObject.fromObject(sendList.get(i));
			//System.out.println("[전송]ERP 데이터 "+i+"번째====="+sendList.get(i));
			paramMap.put("seqNum",rowObj.get("seqNum"));
			paramMap.put("carCode",rowObj.get("carCode"));
			paramMap.put("driveDate",rowObj.get("driveDate").toString().replaceAll("-", ""));
			paramMap.put("startTime",rowObj.get("startTime").toString().replaceAll(":", ""));
			paramMap.put("mileageKm",rowObj.get("mileageKm"));
			paramMap.put("ioKm",rowObj.get("ioKm"));
			paramMap.put("workKm",rowObj.get("workKm"));
			paramMap.put("beforeKm",rowObj.get("beforeKm"));			
			paramMap.put("afterKm",rowObj.get("afterKm"));
			if(EgovStringUtil.isEmpty(rowObj.get("note").toString())){
				paramMap.put("note","");
			}else{
				paramMap.put("note",rowObj.get("note").toString());
			}
			
			//ERP_SEND_YN, ERP_SEND_SEQ값 조회
			List<Map<String, Object>> erpSendInfo = bizCarManageService.getErpSendInfo(paramMap); 
			String erpSendYn = erpSendInfo.get(0).get("ERP_SEND_YN")+"";
			String erpSendSeq = erpSendInfo.get(0).get("ERP_SEND_SEQ")+"";
			//System.out.println("erpSendYn "+i+"번째=="+erpSendYn+" // erpSendSeq="+erpSendSeq);
			paramMap.put("erpSendYn", "1"); //T_EX_BIZ_CAR_PERSON erpSendYn 전송 update
			
			if("1".equals(erpSendYn) && erpSendSeq != null){
				//기존 전송데이터일 경우 erp icube update
				try {
					//기존 전송했던 erp icube SEQ_NB 시퀀스로 진행
					//System.out.println("[전송업데이트]seqNum 시퀀스=="+rowObj.get("seqNum")+" // ERP 시퀀스=="+erpSendSeq);
					paramMap.put("erpSeqNb", erpSendSeq);
					//erp icube 데이터 update
					exCodeOrgDAO.bizCarErpDataUpdate(paramMap, conVo);
					//send 테이블에 전송내역 insert 및 erp_send_yn 값 update
					paramMap.put("sendStatus", "U");
					bizCarManageService.bizCarErpSendInsert(paramMap);
					result = 1;
				}
				catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					//System.out.println(e.getMessage());
					result = -1;
				}
				
			}else{
				//신규 데이터일 경우  erp icube insert
				try {
					//erp icube SEQ_NB 시퀀스 가져오기 (MAX+1 값)
					Integer erpSeqNb = exCodeOrgDAO.getBizCarErpSeq(paramMap, conVo);
					//System.out.println("[신규전송]신규 ERP 최대시퀀스 +1값 ="+erpSeqNb+" // seqNum 시퀀스=="+rowObj.get("seqNum"));
					paramMap.put("erpSeqNb", erpSeqNb);
					//erp icube 데이터 insert
					exCodeOrgDAO.bizCarErpDataInsert(paramMap, conVo);
					//send 테이블에 전송내역 insert 및 erp_send_yn 값 update
					paramMap.put("sendStatus", "I");
					bizCarManageService.bizCarErpSendInsert(paramMap);
					result = 1;
				}
				catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					//System.out.println(e.getMessage());
					result = -1;
				}
				
			}
			
		}
		
		mv.addObject("result", result); //전송여부 
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/bizCarErpDataDelete.do")
	public ModelAndView bizCarErpDataDelete(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		int result = 0;
		ModelAndView mv = new ModelAndView();
		
		// IP가져오기 (localhost로 접속했을때는 0:0:0:0:0:0:0:1로 가져옴)
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("erpCompSeq", loginVO.getErpCoCd());
		paramMap.put("erpBizSeq", loginVO.getErpBizCd());
		paramMap.put("erpEmpSeq", loginVO.getErpEmpCd());
		paramMap.put("erpDeptSeq", loginVO.getErpDeptCd());
		
		JSONArray sendDelList = JSONArray.fromObject(paramMap.get("sendDelList"));
		JSONObject rowObj = new JSONObject();
		for(int i=0; i<sendDelList.size(); i++){
			rowObj = JSONObject.fromObject(sendDelList.get(i));
			//System.out.println("[전송취소] ERP 데이터 "+i+"번째====="+sendDelList.get(i));
			paramMap.put("seqNum",rowObj.get("seqNum"));
			paramMap.put("carCode",rowObj.get("carCode"));
			paramMap.put("driveDate",rowObj.get("driveDate").toString().replaceAll("-", ""));
			
			List<Map<String, Object>> erpSendInfo = bizCarManageService.getErpSendInfo(paramMap);
			String erpSendYn = erpSendInfo.get(0).get("ERP_SEND_YN")+"";
			String erpSendSeq = erpSendInfo.get(0).get("ERP_SEND_SEQ")+"";
			//System.out.println("erpSendYn "+i+"번째=="+erpSendYn+" // erpSendSeq="+erpSendSeq);
			
			if("1".equals(erpSendYn) && erpSendSeq != null){
				//기존 전송데이터일 경우 erp icube delete
				try {
					//기존 전송했던 erp icube SEQ_NB 시퀀스로 진행
					//System.out.println("[전송취소]seqNum 시퀀스=="+rowObj.get("seqNum")+" // ERP 시퀀스=="+erpSendSeq);
					paramMap.put("erpSeqNb", erpSendSeq);
					
					//erp icube 데이터 delete
					exCodeOrgDAO.bizCarErpDataDelete(paramMap, conVo);
					//send 테이블에 전송내역 insert 및 erp_send_yn 값 update
					paramMap.put("erpSendYn", "0"); //T_EX_BIZ_CAR_PERSON erpSendYn 미전송 update erp값 삭제
					paramMap.put("erpSeqNb", "0");
					
					paramMap.put("sendStatus", "D");
					bizCarManageService.bizCarErpSendInsert(paramMap);
					//bizCarManageService.bizCarErpSendDelete(paramMap); //데이터 삭제 대신 D구분값으로 업데이트
					result = 1;
				}
				catch (Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					//System.out.println(e.getMessage());
					result = -1;
				}
				
			}	
		}		
		
		mv.addObject("result", result); //전송여부 
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarTradeSearchPop.do")
	public ModelAndView bizCarTradeSearchPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		////System.out.println("여기 거래처조회");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		if (request.getParameter("rowSeq") != null){
			mv.addObject("rowSeq", request.getParameter("rowSeq"));
		}else{
			mv.addObject("rowSeq", "");
		}
			
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarTradeSearchPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarErpTradeSearch.do")
	public ModelAndView bizCarErpTradeSearch(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		//System.out.println("iCUBE 거래처검색");
		
		try {
			//erp 시스템정보 조회
			List<Map<String, Object>> list = compService.getErpConList(paramMap);
			//System.out.println("getErpConList===??"+list);
			if(list.size() != 0){
				String driver = list.get(0).get("driver") + "";
				String url = list.get(0).get("url") + "";
				String dataBaseType = list.get(0).get("databaseType") + "";
				String systemType = list.get(0).get("erpTypeCode") + "";
				String userid = list.get(0).get("userid") + "";
				String password = list.get(0).get("password") + "";
				String text = request.getParameter("tradeNm");
				
				//System.out.println("systemType===::"+systemType);
				if(systemType.equals("iCUBE")){
					
					//erp서버 정보 가져오기.
					conVo.setDriver(driver);
					conVo.setUrl(url);			
					conVo.setDatabaseType(dataBaseType);
					conVo.setSystemType(systemType);
					conVo.setUserId(userid);
					conVo.setPassWord(password);
					
					paramMap.put("loginVO", loginVO);
					paramMap.put("erpCompSeq", list.get(0).get("erpCompSeq"));
					paramMap.put("erpCoCd", loginVO.getErpCoCd());
					paramMap.put("erpEmpCd", loginVO.getErpEmpCd());
					
					// icube 사원정보에서 사업장정보 가져오기
					List<Map<String, Object>> bizCarErpEmpInfo = exCodeOrgDAO.getBizCarErpEmpInfo(paramMap, conVo);
					if(bizCarErpEmpInfo.size() != 0){
						String erpBizSeq = bizCarErpEmpInfo.get(0).get("erpBizSeq")+"";
						String erpDeptSeq = bizCarErpEmpInfo.get(0).get("erpDeptSeq")+"";
						paramMap.put("erpBizSeq", erpBizSeq);
						loginVO.setErpBizCd(erpBizSeq); //loginVO에 erp사업장코드 set
						loginVO.setErpDeptCd(erpDeptSeq); //loginVO에 erp부서코드 set
					}
					
					// icube 등록 거래처조회
					List<Map<String, Object>> bizCarTradeList = exCodeOrgDAO.getBizCarTradeList(paramMap, conVo);
					//System.out.println(" icube에서 가져윤 거래처List  : " + bizCarTradeList);
					
					// 결과값에서 검색키워드로 (거래처명)검색후 다시 bizCarTradeList2 리스트에 담음
					List<Map<String, Object>> bizCarTradeList2 = new ArrayList<Map<String,Object>>();
					int cnt = 0;
					for(int i=0; i<bizCarTradeList.size(); i++ ) {
						boolean chk = false;
						
						if (bizCarTradeList.get(i).get("TR_NM").toString().contains(text)){
							chk = true;
						}else if (bizCarTradeList.get(i).get("TR_CD").toString().contains(text)){
							chk = true;
						}else if (bizCarTradeList.get(i).get("REG_NB").toString().contains(text)){
							chk = true;
						}
						
						if (chk){
							bizCarTradeList2.add(cnt, bizCarTradeList.get(i));
							cnt ++;
						}
												
					}
					//System.out.println(" bizCarList2  : " + bizCarTradeList2);

					// 반환처리
					mv.addObject("bizCarTradeList2", bizCarTradeList2);
					mv.addObject("bizCarTradeList", bizCarTradeList);
					
				}else{
					//System.out.println("==========ERP타입이 icube가 아닙니다.========== ");
					mv.addObject("result", "ERP연동이 icube가 아닙니다.");	
					mv.addObject("bizCarTradeList", "");
				}
				
			}
			else{
				mv.addObject("result", BizboxAMessage.getMessage("TX000011769","ERP연결 정보가 존재하지 않습니다"));		
				mv.addObject("bizCarTradeList", "");
			}
		}
		catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarDriveSearchPop.do")
	public ModelAndView bizCarDriveSearchPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 주행거리검색");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarDriveSearchPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarBookMarkPop.do")
	public ModelAndView bizCarBookMarkPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	
		////System.out.println("여기 즐겨찾기");
		ModelAndView mv = new ModelAndView();
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		
		List<Map<String, Object>> bookMarkList = bizCarManageService.getBizCarBookMarkList(paramMap);
		//System.out.println("@@@@@@@@@@@BizCarBookMarkPop===="+bookMarkList);
		//String ywyw = bookMarkList.get(0).get("START_TIME").toString();
		
		
		mv.addObject("bookMarkList", bookMarkList);
		mv.addObject("empSeq", loginVO.getUniqId());
		mv.addObject("compSeq", loginVO.getCompSeq());
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarBookMarkPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/deleteBookMark.do")
	public ModelAndView deleteBookMark(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		int result = 0;
		
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		
		try {
			result = bizCarManageService.deleteBookMarkData(paramMap);

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/insertBookMarkData.do")
	public ModelAndView insertBookMarkData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
	
		////System.out.println("여기 즐겨찾기 insert");
		ModelAndView mv = new ModelAndView();
		int result = 0;
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq",loginVO.getOrgnztId());
		
		try {
			int bmCode = bizCarManageService.insertBookMarkData(paramMap);
			mv.addObject("bmCode", bmCode);
			result = 1;

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarAddressPop.do")
	public ModelAndView bizCarAddressPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 주소입력팝업");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarAddressPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/getUserAddress.do")
	public ModelAndView getUserAddress(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		int result = 0;
		
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		////System.out.println("여기 주소데이터 가져오기  회사시퀀스랑 사업장 시퀀스==" + loginVO.getErpBizCd());
		try {
			Map<String, Object> userAddressInfo = bizCarManageService.getBizCarUserAddress(paramMap);
			mv.addObject("userAddressInfo", userAddressInfo);
			
			result = 1;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}		
				
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/setUserAddress.do")
	public ModelAndView setUserAddress(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		ModelAndView mv = new ModelAndView();
		int result = 0;
		
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		
		try {
			bizCarManageService.setBizCarUserAddress(paramMap);
			result = 1;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			result = -1;
		}		
		
		mv.addObject("result", result);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarReCalPop.do")
	public ModelAndView bizCarReCalPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 재계산팝업");
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("carNum", request.getParameter("fr_carNum"));
		mv.addObject("carCode", request.getParameter("fr_carCode"));
		mv.addObject("toDt", request.getParameter("fr_toDt"));
		mv.addObject("frDt", request.getParameter("fr_frDt"));
		mv.addObject("sendType", request.getParameter("fr_sendType"));
		mv.addObject("erpCloseDt", request.getParameter("fr_erpCloseDt"));
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarReCalPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/reCalData.do")
	public ModelAndView reCalData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 차량데이터 재계산");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		paramMap.put("reCalType",request.getParameter("reCalType"));
		
		try{
			bizCarManageService.reCalculationData(paramMap);
			mv.addObject("result", "ok");
			
		}catch (Exception ex){
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			mv.addObject("result", "fail");
		}	
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarDividePop.do")
	public ModelAndView bizCarDividePop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 안분팝업");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarDividePop");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/getBizCarDivideList.do")
	public ModelAndView getBizCarDivideList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 안분리스트");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		List<Map<String, Object>> divideRowList = bizCarManageService.getDivideRowList(paramMap);
		
		mv.addObject("divideRowList", divideRowList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/updateBizCarDivideList.do")
	public ModelAndView updateBizCarDivideList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 안분 데이터 업데이트");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		try{
			bizCarManageService.updateDivideRowList(paramMap);
			mv.addObject("result", "ok");
			
		}catch (Exception ex){
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			mv.addObject("result", "fail");
		}	
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarCopyPop.do")
	public ModelAndView bizCarCopyPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 복사팝업");
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarCopyPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/copyBizCarData.do")
	public ModelAndView copyBizCarData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 데이터 복사");
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("empSeq",loginVO.getUniqId());		
		paramMap.put("erpCoCd",loginVO.getErpCoCd());
		paramMap.put("erpEmpCd",loginVO.getErpEmpCd());
		
		try{
			bizCarManageService.copyBizCarData(paramMap);
			mv.addObject("result", "ok");
			
		}catch (Exception ex){
			CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			mv.addObject("result", "fail");
		}	
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/getCarAfterKm.do")
	public ModelAndView getCarAfterKm(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("empSeq",loginVO.getUniqId());
		
		Map<String, Object> carAfterKm = bizCarManageService.getCarAfterKm(paramMap);
		
		mv.addObject("result", carAfterKm);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarUploadPop.do")
	public ModelAndView bizCarUploadPop(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 업로드팝업");
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("loginVo", loginVO);
		mv.setViewName("/neos/cmm/ex/bizcar/pop/bizCarUploadPop");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/bizCarExcelValidate.do")
	public ModelAndView bizCarExcelValidate(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 엑셀업로드 데이터체크");
		ModelAndView mv = new ModelAndView();
		
		Map<String,Object> resultMap = new HashMap<String, Object>();	  
		List<Map<String,Object>> excelContentList = null; 
		
		try {
			  String osType = NeosConstants.SERVER_OS;
			  
			  Map<String, Object> param = new HashMap<String, Object>();
			  param.put("groupSeq", loginVO.getGroupSeq());
			  param.put("pathSeq", "0");
			  param.put("osType", osType);
			  
			  Map<String, Object> pathMap = groupManageService.selectGroupPath(param);
			  //System.out.println("selectGroupPath@@@"+pathMap);
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
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // jsp 에서 name값 넘겨받음
	
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
					 drmService.drmConvert("U", loginVO.getGroupSeq(), "E", savePath, newName, fileExt);					 
					 
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
					  String strFlag = "";
					  List<Map<String, Object>> saveList = new ArrayList<Map<String, Object>>(); 
					  for (int i = 0 ; i < excelContentList.size() ; i++) {
						  Map<String,Object> map = excelContentList.get(i);
						  
						  if(!map.get("C0").toString().equals("")){
							  Map<String, Object> item = new HashMap<String, Object>();
							  item.put("batchSeq", ts);
							  item.put("seq", seq);
							  item.put("compSeq", loginVO.getCompSeq());
							  item.put("empSeq", loginVO.getUniqId());
							  item.put("deptSeq", loginVO.getOrgnztId());
							  item.put("carNum", map.get("C0")); //차량
							  item.put("carCode", map.get("C1")); //차량코드
							  item.put("driveDate", map.get("C2").toString()); //운행일자
							  switch (map.get("C3").toString()) {
								  case "출근": strFlag = "1"; break;
								  case "퇴근": strFlag = "2"; break;
								  case "출퇴근": strFlag = "3"; break;
								  case "업무용": strFlag = "4"; break;
								  case "비업무용": strFlag = "5"; break;
								  default: strFlag = ""; break;
							  }
							  item.put("useFlag", strFlag); //운행구분
							  if(map.get("C4").toString().indexOf(":") > -1) {
								  item.put("startTime", map.get("C4").toString().replace(":", "")); //출발시간
							  }
						      else {
						    	  item.put("startTime", map.get("C4")); //출발시간
						      }
							  
							  if(map.get("C5").toString().indexOf(":") > -1) {
								  item.put("endTime", map.get("C5").toString().replace(":", "")); //도착시간
							  }
						      else {
						    	  item.put("endTime", map.get("C5")); //도착시간
						      }
							  							  
							  switch (map.get("C6").toString()) {
								  case "직접입력": strFlag = "0"; break;
								  case "회사": strFlag = "1"; break;
								  case "자택": strFlag = "2"; break;
								  case "거래처": strFlag = "3"; break;
								  default: strFlag = ""; break;
							  }
							  item.put("startFlag", strFlag); //출발구분
							  item.put("startAddr", map.get("C7")); //출발지
							  item.put("startAddrDetail", ""); //출발지상세
							  switch (map.get("C8").toString()) {
								  case "직접입력": strFlag = "0"; break;
								  case "회사": strFlag = "1"; break;
								  case "자택": strFlag = "2"; break;
								  case "거래처": strFlag = "3"; break;
								  default: strFlag = ""; break;
							  }
							  item.put("endFlag", strFlag); //도착구분
							  item.put("endAddr", map.get("C9")); //도착지
							  item.put("endAddrDetail", ""); //도착지상세
							  item.put("beforeKm", map.get("C10")); //주행전
							  item.put("afterKm", map.get("C11")); //주행후
							  item.put("mileageKm", map.get("C12")); //주행
							  item.put("rmkDc", map.get("C13")); //비고
							  switch (map.get("C14").toString()) {
							  case "현금": strFlag = "1"; break;
							  case "현금영수증": strFlag = "2"; break;
							  case "카드(법인)": strFlag = "3"; break;
							  case "카드(개인)": strFlag = "4"; break;
							  default: strFlag = "0"; break;
							  }
							  item.put("oilAmtType", CommonUtil.getIntNvl(strFlag)); //유류비 결제구분
							  String camt = map.get("C15").toString();
							  item.put("oilAmt", CommonUtil.getIntNvl(camt)); //유류비 금액
							  switch (map.get("C16").toString()) {
							  case "현금": strFlag = "1"; break;
							  case "현금영수증": strFlag = "2"; break;
							  case "카드(법인)": strFlag = "3"; break;
							  case "카드(개인)": strFlag = "4"; break;
							  default: strFlag = "0"; break;
							  }
							  item.put("tollAmtType", CommonUtil.getIntNvl(strFlag)); //통행료 결제구분
							  camt = map.get("C17").toString();
							  item.put("tollAmt", CommonUtil.getIntNvl(camt)); //통행료 금액
							  switch (map.get("C18").toString()) {
							  case "현금": strFlag = "1"; break;
							  case "현금영수증": strFlag = "2"; break;
							  case "카드(법인)": strFlag = "3"; break;
							  case "카드(개인)": strFlag = "4"; break;
							  default: strFlag = "0"; break;
							  }
							  item.put("parkingAmtType", CommonUtil.getIntNvl(strFlag)); //주차비 결제구분
							  camt = map.get("C19").toString();
							  item.put("parkingAmt", CommonUtil.getIntNvl(camt)); //주차비 금액
							  switch (map.get("C20").toString()) {
							  case "현금": strFlag = "1"; break;
							  case "현금영수증": strFlag = "2"; break;
							  case "카드(법인)": strFlag = "3"; break;
							  case "카드(개인)": strFlag = "4"; break;
							  default: strFlag = "0"; break;
							  }
							  item.put("repairAmtType", CommonUtil.getIntNvl(strFlag)); //수선비 결제구분
							  camt = map.get("C21").toString();
							  item.put("repairAmt", CommonUtil.getIntNvl(camt)); //수선비 금액
							  switch (map.get("C22").toString()) {
							  case "현금": strFlag = "1"; break;
							  case "현금영수증": strFlag = "2"; break;
							  case "카드(법인)": strFlag = "3"; break;
							  case "카드(개인)": strFlag = "4"; break;
							  default: strFlag = "0"; break;
							  }
							  item.put("etcAmtType", CommonUtil.getIntNvl(strFlag)); //기타 결제구분
							  camt = map.get("C23").toString();
							  item.put("etcAmt", CommonUtil.getIntNvl(camt)); //기타 금액
							  //item.put("orderNum", map.get("num"));
							  seq++;
							  saveList.add(item);
							  
						  }				  
					  }
					  
					  for(Map<String, Object> map : saveList){
						  bizCarManageService.insertBizCarBatch(map);
						  //commonSql.insert("DutyPositionManageService.insertDutyPositionBatch", map);
					  }					  
					  resultMap.put("batchMsg", "success");
					  resultMap.put("batchKey", ts);
					  
					  List<Map<String,Object>> checkList = bizCarManageService.checkBizCarBatchInfo(resultMap);
					  //List<Map<String, Object>> checkList = commonSql.list("DutyPositionManageService.CheckPositionBatchInfo", resultMap);
					  mv.addObject("checkList", checkList);
				  }
				  else {
					  resultMap.put("batchMsg", "fail");
					  resultMap.put("batchKey", "0");
				  }
			  }
			  
		  } catch (Exception ex) {
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
			  resultMap.put("batchMsg", "fail");
		  }
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);
		  //System.out.println("procExcelToJSON! ======> "+arrExcelContentList);

		  resultMap.put("batchData", arrExcelContentList);
		  
		  //logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());		  
		  mv.addAllObjects(resultMap);
		  mv.setViewName("jsonView");
		  return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/deleteBizCarBatchData.do")
	public ModelAndView deleteBizCarBatchData(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		//System.out.println("batch_seq ======> "+paramMap.get("batchKey"));
		bizCarManageService.deleteBizCarBatchData(paramMap);
		
		mv.setViewName("jsonView");		
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/pop/saveBizCarBatchData.do")
	public ModelAndView saveBizCarBatchData(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("ipAddress", CommonUtil.getClientIp(request));
		
		paramMap.put("compSeq", loginVO.getCompSeq());
		paramMap.put("deptSeq", loginVO.getOrgnztId());
		paramMap.put("empSeq",loginVO.getUniqId());		
		paramMap.put("erpCompSeq",loginVO.getErpCoCd());
		paramMap.put("erpBizSeq",loginVO.getErpBizCd());
		paramMap.put("erpEmpSeq",loginVO.getErpEmpCd());
		
		//System.out.println("batch_seq ======> "+paramMap.get("batchKey"));
		bizCarManageService.saveBizCarBatchData(paramMap);
		
		mv.setViewName("jsonView");		
		
		return mv;
	}
	
	
	
	/**
	 * 업무용승용차관리 운행기록현황 페이지 호출
	 * @param paramMap
	 * @param request
	 * @return
	 * @throws Exception
	 * @author 조영욱
	 */
	@RequestMapping("/cmm/ex/bizcar/bizCarManageDetailView.do")
	public ModelAndView bizCarManageDetailView(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		////System.out.println("여기 운행기록현황 페이지");
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("userSe", loginVO.getUserSe());
		mv.setViewName("/neos/cmm/ex/bizcar/bizCarManageDetailView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/getBizCarDetailList.do")
	public ModelAndView getBizCarDetailList(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("userSe",loginVO.getUserSe());

		List<Map<String,Object>> bizCarDetailList = bizCarManageService.getBizCarDetailList(paramMap);
		
		mv.addObject("result", bizCarDetailList);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/detailViewRowData.do")
	public ModelAndView detailViewRowData(@RequestParam Map<String, Object> paramMap , HttpServletRequest request) throws Exception{
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		
		paramMap.put("userSe",loginVO.getUserSe());

		List<Map<String,Object>> bizCarDetailRowData = bizCarManageService.getDetailViewRowData(paramMap);
		
		mv.addObject("result", bizCarDetailRowData);
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/cmm/ex/bizcar/bizCarExcelDown.do")
	 public void bizCarExcelDown(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		ModelAndView mv = new ModelAndView();
		 
		paramMap.put("langCode", loginVO.getLangCode());		
		paramMap.put("userSe",loginVO.getUserSe());
		
		List<Map<String,Object>> list = bizCarManageService.selectBizCarViewExcelList(paramMap);
		
		String[] colName = null;
		if(loginVO.getUserSe().equals("ADMIN")){
			//관리자 화면이면 부서, 이름 추가
			colName = new String[16];
			colName[0] = "부서";
			colName[1] = "이름";
			colName[2] = "차량코드";
			colName[3] = "차량";
			colName[4] = "운행일자";
			colName[5] = "운행구분";
			colName[6] = "출발시간";
			colName[7] = "도착시간";
			colName[8] = "출발구분";
			colName[9] = "출발지";
			colName[10] = "도착구분";
			colName[11] = "도착지";
			colName[12] = "주행전(km)";
			colName[13] = "주행후(km)";
			colName[14] = "주행(km)";
			colName[15] = "비고";
		}else {
			colName = new String[14];
			colName[0] = "차량코드";
			colName[1] = "차량";
			colName[2] = "운행일자";
			colName[3] = "운행구분";
			colName[4] = "출발시간";
			colName[5] = "도착시간";
			colName[6] = "출발구분";
			colName[7] = "출발지";
			colName[8] = "도착구분";
			colName[9] = "도착지";
			colName[10] = "주행전(km)";
			colName[11] = "주행후(km)";
			colName[12] = "주행(km)";
			colName[13] = "비고";
		}		
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    Calendar c1 = Calendar.getInstance();
		String strToday = sdf.format(c1.getTime());
		String fileNm = "BizboxA_BizCarExcelList_" + strToday;
		//System.out.println("엑셀 리스트 ======="+list);
		excelService.CmmExcelDownload(list, colName, fileNm, response, request);
	 }

}
