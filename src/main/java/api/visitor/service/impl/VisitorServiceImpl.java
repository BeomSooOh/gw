package api.visitor.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import api.visitor.service.VisitorService;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.ex.visitor.service.VisitorManageService;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONObject;

@Service("VisitorService")
public class VisitorServiceImpl implements VisitorService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "VisitorManageService")
	private VisitorManageService visitorManageService;
	
	/* 승인된 방문자 리스트 조회 */
	@Override
	public List<Map<String, Object>> getAppvVisitorList(Map<String, Object> request) {
		return commonSql.list("VisitorManageDAO.getAppvVisitorList",request);
	}
	
	
	@Override
	public Map<String, Object> insertInHouseVisitorList(Map<String, Object> request) throws Exception {
		
		List<Map<String, Object>> visitorList = (List<Map<String, Object>>) request.get("insertVisitorList");
		Map<String, Object> result = new HashMap<String, Object>();
		
		/* 필수 값 체크 */
		for(int i=0; i<visitorList.size(); i++) {
			
			Map<String, Object> data = visitorList.get(i);
			
			if(data.get("manLoginId") == null || data.get("manLoginId").equals("")) {
				result.put("code", "ERR001");
				result.put("message", "로그인 아이디가 입력되지 않았습니다.");
				return result;
			}
			
			Map<String, Object> manInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getManInfo", data);
			
			if(data.get("visitorNm") == null || data.get("manLoginId").equals("")) {
				result.put("code", "ERR002");
				result.put("message", "방문자 명이 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitPticketYn").equals("Y") && (data.get("visitorCarNo") == null || data.get("visitorCarNo").equals(""))) {
				result.put("code", "ERR003");
				result.put("message", "무료주차권 발급이지만 차량번호가 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitorHp") == null || data.get("visitorHp").equals("")) {
				result.put("code", "ERR004");
				result.put("message", "방문자 핸드폰 번호가 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitPlaceCode") == null || data.get("visitPlaceCode").equals("")) {
				result.put("code", "ERR005");
				result.put("message", "방문 장소가 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitDistinct") == null || data.get("visitDistinct").equals("")) {
				result.put("code", "ERR006");
				result.put("message", "방문자 유형이 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitCo") == null || data.get("visitCo").equals("")) {
				result.put("code", "ERR007");
				result.put("message", "방문 회사가 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitDt") == null || data.get("visitDt").equals("")) {
				result.put("code", "ERR008");
				result.put("message", "방문 날짜가 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("visitTm") == null || data.get("visitTm").equals("")) {
				result.put("code", "ERR009");
				result.put("message", "방문 시간이 입력되지 않았습니다.");
				return result;
			}
			else if(manInfo == null) {
				result.put("code", "ERR010");
				result.put("message", "유효한 로그인 id가 아닙니다.");
				return result;
			}
			else if(data.get("qrSendStatusCode") == null || data.get("qrSendStatusCode").equals("")) {
				result.put("code", "ERR011");
				result.put("message", "QR 발송 여부가 입력되지 않았습니다.");
				return result;
			}
		}
		
		for(int i=0; i<visitorList.size(); i++) {
			
			/* 방문자 정보 */
			Map<String, Object> data = visitorList.get(i);
			
			/* DB insert 데이터 */
			Map<String, Object> insertData = new HashMap<String, Object>();
			insertData.put("groupSeq", request.get("groupSeq"));
			
			// nR_NO, nSeq 세팅(현재 max값 +1)
			int maxRNo = (int)commonSql.select("VisitorManageDAO.getMaxRNo", request ) +1;
			insertData.put("nR_NO", maxRNo);
			
			int nSeq = (int)commonSql.select("VisitorManageDAO.getNseq", request) +1;
			insertData.put("nSeq", nSeq);
			
			Map<String, Object> manInfo = new HashMap<String, Object>();
			manInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getManInfo", data);
			
			insertData.put("nManCoSeq", manInfo.get("manCompSeq"));
			insertData.put("nManUserSeq", manInfo.get("manEmpSeq"));
			
			if(data.get("manTelNum") == null || data.get("manTelNum").equals("")) {
				insertData.put("nManUserHp", manInfo.get("manTelNum"));
			}
			else {
				insertData.put("nManUserHp", data.get("manTelNum"));
			}
			
			insertData.put("nReqCoSeq", manInfo.get("manCompSeq"));
			insertData.put("nReqUserSeq", manInfo.get("manEmpSeq"));
			insertData.put("sDistinct", "1");
			insertData.put("sVisitCO", data.get("visitCo"));
			insertData.put("sVisitNM", data.get("visitorNm"));
			insertData.put("sVisitHP", data.get("visitorHp"));
			if(data.get("visitPticketYn").toString().equals("noCar")) {
				insertData.put("sVisitCarNo", "");
			}
			else {
				if(insertData.get("visitorCarNo") == null || insertData.get("visitorCarNo").equals("")) {
					insertData.put("sVisitCarNo", "");
				}
				else {
					insertData.put("sVisitCarNo", data.get("visitorCarNo"));
				}
								
			}
			insertData.put("sVisitFrDT", data.get("visitDt"));
			insertData.put("sVisitFrTM", data.get("visitTm"));
			insertData.put("sVisitAIM", data.get("visitAim"));
			insertData.put("nVisitCnt", data.get("visitCnt"));
			insertData.put("approvalYn", "1");
			insertData.put("sETC", data.get("etc"));
			insertData.put("visit_place_code", data.get("visitPlaceCode"));
			insertData.put("visitDistinct", data.get("visitDistinct") == null ? "" : data.get("visitDistinct"));
			
			String visitPticketYn = "";
			if(data.get("visitPticketYn").toString().equals("Y")) {
				visitPticketYn = "Issue";
			}
			else if(data.get("visitPticketYn").toString().equals("N")) {
				visitPticketYn = "noIssue";
			}
			else {
				visitPticketYn = "noCar";
			}
			insertData.put("visit_pticket_yn", visitPticketYn);
			
			/* qr_send_status_code - QR발송 여부(Y/N) */
			if(data.get("qrSendStatusCode").toString().equals("N")) {
				insertData.put("qr_data", "");
				insertData.put("qr_send_status_code", "N"); //QR 발송 후 업데이트
			}
			else {
				insertData.put("qr_data", maxRNo);
				insertData.put("qr_send_status_code", ""); //QR 발송 후 업데이트
			}
			
			String visitPlaceName = "";
			visitPlaceName = CommonCodeUtil.getCodeName("VISIT001", data.get("visitPlaceCode").toString());
			
			insertData.put("visit_place_name", visitPlaceName);
			insertData.put("elet_appv_link_yn", "N");
			insertData.put("elet_appv_interface_key", "");
			insertData.put("elct_appv_doc_id", "");
			insertData.put("elct_appv_doc_status", "");
			
			commonSql.insert("VisitorManageDAO.insertInHouseVisitor", insertData);
			commonSql.insert("VisitorManageDAO.insertNormalVisitorInOutTime", insertData);
			
			if(data.get("qrSendStatusCode").toString().equals("Y")) {
				visitorManageService.sendMMSQrImage(insertData);
			}
			
		}
		
		result.put("code", "SUCCESS");
		result.put("message", "방문객 일괄 등록 성공");
		return result;
	}

	/* 입/퇴실 처리 */
	@Override
	public Map<String, Object> BatchInOutCheck(Map<String, Object> request) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		List<Map<String, Object>> inOutCheckList = (List<Map<String, Object>>) request.get("inOutCheckList");
		
		SimpleDateFormat format1 = new SimpleDateFormat ("yyyyMMdd");
		Date time = new Date();
		String time1 = format1.format(time);
		
		int inOutMenuAuthYn = (int) commonSql.select("VisitorManageDAO.checkInOutMenuAuthYn", request);
		
		if(inOutCheckList.size() <= 0) {
			result.put("code", "ERR001");
			result.put("message", "업데이트할 방문객 리스트가 없습니다.");
    		return result;
		}
		
		/* 입/퇴실체크 권한 체크 */
		if(inOutMenuAuthYn <= 0) {
			result.put("code", "ERR007");
			result.put("message", "입/퇴실 처리 권한이 없습니다.");
			return result;
		}
		
		/* 방문객 정보 체크 */
		for(int i=0; i<inOutCheckList.size(); i++) {
			/* 방문자 입/퇴실 정보 */
			Map<String, Object> data = inOutCheckList.get(i);
			
			if(data.get("rNo") == null || data.get("rNo").equals("") ) {
				data.remove("rNo");
			}
			if(data.get("outTime") == null ||data.get("outTime").equals("") ) {
				data.remove("outTime");
			}
			if(data.get("inTime") == null || data.get("inTime").equals("")) {
				data.remove("inTime");
			}
			if(data.get("visitCardNo") == null || data.get("visitCardNo").equals("")) {
				data.remove("visitCardNo");
			}
			
			if(data.get("rNo") == null && data.get("visitCardNo") == null) {
				result.put("code", "ERR002");
				result.put("message", "방문객 번호와 표찰번호가 모두 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("inTime") == null && data.get("outTime") == null) {
				result.put("code", "ERR003");
				result.put("message", "입/퇴실 시간이 모두 입력되지 않았습니다.");
				return result;
			}
			else if(data.get("inTime") != null ) {
				if(data.get("visitCardNo") == null) {
					result.put("code", "ERR004");
					result.put("message", "입실 처리 시 표찰번호가 입력되지 않았습니다.");
					return result;
				}
				else {
					data.put("nCardNo", data.get("visitCardNo"));
					
					String visitDtCheck = (String)commonSql.select("VisitorManageDAO.getCheckVisitDt", data);
					if(!visitDtCheck.equals(time1)) {
						result.put("code","ERR006");
						result.put("message", "입실 처리 시 방문날짜가 오늘이 아닙니다.");
						return result;
					}
					
					int check = (int) commonSql.select("VisitorManageDAO.getCheckVisitCardNo", data);
					if(check > 0) {
						result.put("code", "ERR005");
						result.put("message", "퇴실하지 않은 표찰번호가 존재합니다.");
						return result;
					}
					
//					Map<String, Object> check = new HashMap<String, Object>();
//					check = (Map<String, Object>) commonSql.select("VisitorManageDAO.getCheckVisitCardNo", data);
//					if(Integer.parseInt(check.get("count").toString()) > 0) {
//						result.put("resultCode", "ERR005");
//						result.put("resultMessage", "퇴실하지 않은 표찰번호가 존재합니다.");
//						return result;
//					}
//					else if(!check.get("visit_dt").toString().equals(time1)) {
//						result.put("resultCode", "ERR002");
//						result.put("resultMessage", "방문날짜가 오늘이 아닙니다.");
//						return result;
//					}
				}
			}
		}
		
		for(int i=0; i<inOutCheckList.size(); i++) {
			
			Map<String, Object> data = inOutCheckList.get(i);
			
			String inTime = null;
			String outTime = null;
			
			if(data.get("inTime") == null || data.get("inTime").equals("")) {
				outTime = time1 + data.get("outTime").toString();
			}
			else if(data.get("outTime") == null || data.get("outTime").equals("")) {
				inTime = time1 + data.get("inTime").toString();
			}
			else {
				inTime = time1 + data.get("inTime").toString();
				outTime = time1 + data.get("outTime").toString();
			}
			
			/* 입퇴실 데이터 업데이트 */
			Map<String, Object> updateData = new HashMap<String, Object>();
			updateData.put("groupSeq", request.get("groupSeq"));
			updateData.put("rNo", data.get("rNo"));
			updateData.put("inTime", inTime);
			updateData.put("outTime", outTime);
			updateData.put("visitCardNo", data.get("visitCardNo"));
			
			commonSql.insert("VisitorManageDAO.BatchInOutCheck", updateData);
		}
		result.put("code", "SUCCESS");
		result.put("message", "방문객 일괄 입/퇴실 시간 업데이트 완료");
		return result;
	}


	@Override
	public Map<String, Object> getVisitorInfo(Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		int inOutMenuAuthYn = (int) commonSql.select("VisitorManageDAO.checkInOutMenuAuthYn", paramMap);
		
		if(paramMap.get("rNo").equals("") && paramMap.get("visitCardNo").equals("")) {
			result.put("result", null);
			result.put("code", "ERR001");
			result.put("message", "방문객 번호와 표찰번호가 모두 입력되지 않았습니다.");
			return result;
		}
		
		/* 만약 표찰번호가 입실 시간만 체크되어있고 퇴실시간은 없는 경우 - active 상태 */
		String activeCardYn = "";
		paramMap.put("nCardNo", paramMap.get("visitCardNo"));
		if((int)commonSql.select("VisitorManageDAO.getCheckVisitCardNo", paramMap) > 0) {
			activeCardYn = "Y";
		}
		else {
			activeCardYn = "N";
		}
		paramMap.put("activeCardYn", activeCardYn);
		
		
		/* 방문객 정보 조회 시 입/퇴실 체크 메뉴 권한 체크 - (모바일)입/퇴실 체크 노출 여부 체크를 위함 */
		String authYn = "";
		if(inOutMenuAuthYn <= 0) {
			authYn = "N";
		}
		else {
			authYn = "Y";
		}
		paramMap.put("authYn", authYn);
		
		result.put("result", commonSql.select("VisitorManageDAO.getVisitorInfo", paramMap));
		result.put("code", "SUCCESS");
		result.put("message", "방문객 정보 조회 완료");
		
		return result;
	}


	@Override
	public Map<String, Object> insertQrStayLog(Map<String, Object> param) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		String qrGbnCode = param.get("qrGbnCode") == null ? "" : param.get("qrGbnCode").toString();
		String qrCode = param.get("qrCode") == null ? "" : param.get("qrCode").toString();
		String qrDetailCode = param.get("qrDetailCode") == null ? "" : param.get("qrDetailCode").toString();
		String compName = param.get("compName") == null ? "" : param.get("compName").toString();
		String deptPathName = param.get("deptPathName") == null ? "" : param.get("deptPathName").toString();
		String empName = param.get("empName") == null ? "" : param.get("empName").toString();
		String empSeq = param.get("empSeq") == null ? "" : param.get("empSeq").toString();
		String mobileTelNum = param.get("mobileTelNum") == null ? "" : param.get("mobileTelNum").toString();
		String gpsInfo = param.get("gpsInfo") == null ? "" : param.get("gpsInfo").toString();
		String locationAddr = "";
		
		//파라미터 체크
		Map<String, Object> empInfo = new HashMap<String, Object>();
		if(deptPathName.equals("") || empName.equals("") || compName.equals("")) {
			empInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getEmpInfo", param);
			
			deptPathName = empInfo.get("deptPathName").toString();
			compName = empInfo.get("compName").toString();
			empName = empInfo.get("empName").toString();
			mobileTelNum = empInfo.get("mobileTelNum").toString();
		}
		
		param.put("qrGbnCode", qrGbnCode);
	    param.put("qrCode", qrCode);
	    param.put("qrDetailCode", qrDetailCode);
	    param.put("compName", compName);
	    param.put("deptPathName", deptPathName);
	    param.put("empName", empName);
	    param.put("empSeq", empSeq);
	    param.put("mobileTelNum", mobileTelNum);
	    param.put("gpsInfo", gpsInfo);
		
		// 이미 등록된 정보인지 체크
	    int timeDiff = commonSql.select("VisitorManageDAO.checkQrStayLogDuple", param) == null ? 0 : (int)(commonSql.select("VisitorManageDAO.checkQrStayLogDuple", param)); 
		
	    if(timeDiff > 0 && timeDiff < 10) {
			result.put("message", "QR 정보 저장 성공");
			result.put("code", "duple");
			return result;
	    }
	    else if(timeDiff >= 10 && timeDiff < 300) {
			result.put("message", "이미 등록된 QR 정보입니다.");
			result.put("code", "duple");
			return result;
	    }
		
	    if(!gpsInfo.equals("") && !(gpsInfo.equals("0|0"))) {
	    	String longitude = param.get("gpsInfo").toString().split("\\|")[1];
		    String latitude = param.get("gpsInfo").toString().split("\\|")[0];
		    
		    JSONObject jsonBody = new JSONObject();
			
			JSONObject custHeader = new JSONObject();
			custHeader.put("Authorization", "KakaoAK bcf2d3988985d071b426ec4dc220581a");
			
			/* 리턴 JSON 정의 */
			JSONObject jsonResult = new JSONObject();
			String apiUrl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x="+longitude+"&y="+latitude;
			jsonResult = JSONObject.fromObject( HttpJsonUtil.executeCustomSSLTimeOut("GET", apiUrl, jsonBody, custHeader, 10000));
			
			if(jsonResult != null) {
				Map<String, Object> data = (Map<String, Object>) jsonResult.get("meta"); 
				if(Integer.parseInt(data.get("total_count").toString()) > 0){
					Map<String, Object> addr = ((List<Map<String, Object>>) jsonResult.get("documents")).get(0);
					Map<String, Object> addrDetail = (Map<String, Object>) addr.get("address");
					locationAddr = addrDetail.get("address_name").toString();
				}
			}
	    }
	    
		param.put("locationAddr", locationAddr);
		
		commonSql.insert("VisitorManageDAO.insertQrStayLog", param);
		result.put("message", "QR 정보 저장 성공");
		result.put("code", "success");
		return result;
	}
	
}
