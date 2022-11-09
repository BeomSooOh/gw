package neos.cmm.ex.bizcar.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.ex.bizcar.service.BizCarManageService;
import neos.cmm.systemx.comp.dao.ExCodeOrgiCUBEDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("BizCarManageService")
public class BizCarManageServiceImpl implements BizCarManageService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "ExCodeOrgiCUBEDAO")
	private ExCodeOrgiCUBEDAO exCodeOrgDAO;
	
	@Override
	public List<Map<String, Object>> getBizCarDataList(Map<String, Object> paramMap) {
		
		return commonSql.list("BizCarManageDAO.getBizCarDataList", paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getBizCarBookMarkList(Map<String, Object> paramMap) {
		
		return commonSql.list("BizCarManageDAO.getBizCarBookMarkList", paramMap);
	}
	
	@Override
	public int insertBookMarkData(Map<String, Object> paramMap) {
		
		int bmCode = getMaxBmSeq();
		paramMap.put("bmCode", bmCode);
		
		commonSql.insert("BizCarManageDAO.insertBookMarkData", paramMap);
		commonSql.insert("BizCarManageDAO.updateBookMarkCode", paramMap);
		
		return bmCode;
	}

	@Override
	public int deleteBookMarkData(Map<String, Object> paramMap){
		int result = 0;
		
		JSONArray bmCodeArr = JSONArray.fromObject(paramMap.get("bmCodeArr"));
				
		for(int i=0; i<bmCodeArr.size(); i++){
			paramMap.put("bmCode",bmCodeArr.get(i));
			//bookmark 테이블 삭제
			commonSql.delete("BizCarManageDAO.deleteBookMarkData", paramMap);
			//bizcar 테이블 bookmark_code 삭제
			commonSql.update("BizCarManageDAO.delBookMarkCode", paramMap);
			result++;
		}
		
		return result;
	}

	@Override
	public void insertBizCarBatch(Map<String, Object> paramMap) {
		commonSql.insert("BizCarManageDAO.insertBizCarBatch", paramMap);
	}
	
	@Override
	public List<Map<String, Object>> checkBizCarBatchInfo(Map<String, Object> paramMap) {
		
		return commonSql.list("BizCarManageDAO.checkBizCarBatchInfo", paramMap);
	}

	@Override
	public void deleteBizCarBatchData(Map<String, Object> paramMap) {		
		if(paramMap.get("delList") != null){
			JSONArray jsonStr = JSONArray.fromObject(paramMap.get("delList"));
			List<String> delList = new ArrayList<String>();
			
			for(int i=0; i<jsonStr.size(); i++){
				delList.add(jsonStr.getString(i));
			}
			paramMap.put("delList",delList);
		}
		
		commonSql.delete("BizCarManageDAO.deleteBizCarBatchData", paramMap);
	}

	@Override
	public void saveBizCarBatchData(Map<String, Object> paramMap) {
		if(paramMap.get("saveList") != null){
			JSONArray jsonStr = JSONArray.fromObject(paramMap.get("saveList"));
			List<String> saveList = new ArrayList<String>();
			
			for(int i=0; i<jsonStr.size(); i++){
				saveList.add(jsonStr.getString(i));
			}
			paramMap.put("saveList",saveList);
			paramMap.put("insertType",3); //저장타입  0:사용자신규생성  1:복사데이터  2:북마크데이터 3:엑셀업로드
		}
		
		commonSql.insert("BizCarManageDAO.saveBizCarBatchData", paramMap);
		
	}

	@Override
	public List<Map<String, Object>> getDetailRowData(Map<String, Object> paramMap) {
		return commonSql.list("BizCarManageDAO.getDetailRowData", paramMap);
	}

	@Override
	public void deleteBizCarData(Map<String, Object> paramMap) {
		if(paramMap.get("seqNumArr") != null){
			JSONArray seqNumArr = JSONArray.fromObject(paramMap.get("seqNumArr"));
			List<String> delList = new ArrayList<String>();
			
			for(int i=0; i<seqNumArr.size(); i++){
				delList.add(seqNumArr.getString(i));
			}
			paramMap.put("delList",delList); //delete할 대상 seqList
			
			commonSql.delete("BizCarManageDAO.deleteBizCarData", paramMap);	
		}
	}

	@Override
	public void insertBizCarData(Map<String, Object> paramMap) {
		if(paramMap.get("seqNum") == null){
			int seqNum = getMaxSeq();
			paramMap.put("seqNum", seqNum);
		}
		paramMap.put("insertType",0); //저장타입  0:사용자신규생성  1:복사데이터  2:북마크데이터 3:엑셀업로드
		commonSql.insert("BizCarManageDAO.insertBizCarData", paramMap);
	}

	@Override
	public List<Map<String, Object>> getBizCarDetailList(Map<String, Object> paramMap) {
		
		if(paramMap.get("chkSel") != null){
			JSONArray jsonStr = JSONArray.fromObject(paramMap.get("chkSel"));
			List<String> flagList = new ArrayList<String>();
			
			for(int i=0; i<jsonStr.size(); i++){
				flagList.add(jsonStr.getString(i));
			}
			paramMap.put("flagList",flagList);
		}
		
		return commonSql.list("BizCarManageDAO.getBizCarDetailList", paramMap);
	}

	@Override
	public List<Map<String, Object>> getDetailViewRowData(Map<String, Object> paramMap) {
		
		if(paramMap.get("chkSel") != null){
			JSONArray jsonStr = JSONArray.fromObject(paramMap.get("chkSel"));
			List<String> flagList = new ArrayList<String>();
			
			for(int i=0; i<jsonStr.size(); i++){
				flagList.add(jsonStr.getString(i));
			}
			paramMap.put("flagList",flagList);
		}
		
		return commonSql.list("BizCarManageDAO.getDetailViewRowData", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectBizCarViewExcelList(Map<String, Object> paramMap) {
		
		return commonSql.list("BizCarManageDAO.selectBizCarViewExcelList", paramMap);
	}

	@Override
	public void setBizCarUserAddress(Map<String, Object> paramMap) {
		
		commonSql.insert("BizCarManageDAO.setBizCarUserAddress", paramMap);
	}

	@Override
	public Map<String, Object> getBizCarUserAddress(Map<String, Object> paramMap) {
		
		Map<String, Object> addrMap = new HashMap<String, Object>();
		
		List<Map<String, String>> userAddr = commonSql.list("BizCarManageDAO.getBizCarUserAddress", paramMap);
		if(userAddr.size() > 0){ //저장된 주소값이 있을떄
			String compAddr = userAddr.get(0).get("COMP_ADDR") + "";
			String houseAddr = userAddr.get(0).get("HOUSE_ADDR") + "";
			
			addrMap.put("compAddr", compAddr);
			addrMap.put("houseAddr", houseAddr);
			addrMap.put("newYn", "N");
		}else{ //신규면 GW 주소 정보 가져오기			
			List<Map<String, String>> gwUserData = commonSql.list("BizCarManageDAO.getGwUserAddress", paramMap);
			String compAddr = gwUserData.get(0).get("COMP_ADDR") + "";
			String houseAddr = gwUserData.get(0).get("HOUSE_ADDR") + "";
			
			addrMap.put("compAddr", compAddr);
			addrMap.put("houseAddr", houseAddr);
			addrMap.put("newYn", "Y");
		}
		
		return addrMap;
		
	}

	@Override
	public void reCalculationData(Map<String, Object> paramMap) {
		
		paramMap.put("getRecalYn", "Y"); // 공통 조회 getBizCarDataList 에 재계산데이터 가져올 시 ERP전송 데이터 제외를 구분할 파라미터 추가
		List<Map<String,Object>> bizCarDataList = getBizCarDataList(paramMap);
		//System.out.println("재계산 대상 데이터 가져옴==="+bizCarDataList);
		
		List<Map<String, Object>> reCalList = new ArrayList<Map<String, Object>>(); //실제 재계산 대상 리스트
		String cDt = paramMap.get("erpCloseDt").toString(); //ERP운행기록부 마감일자
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date closeDt = null;
		Date driveDt = null;
		
		for(int i=0; i<bizCarDataList.size(); i++){
			String dDt = bizCarDataList.get(i).get("driveDate").toString(); //운행일자
			try {
				closeDt = dateFormat.parse(cDt); //ERP운행기록부 마감일자 날짜형식으로 변환
				driveDt = dateFormat.parse(dDt); //운행일자 날짜형식으로 변환
			} catch (ParseException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			int compare = closeDt.compareTo(driveDt); //날짜 비교
			if(compare < 0){
				//erp미전송된 데이터 및 마감일자보다 큰 데이터만 재계산 대상 추가
				reCalList.add(bizCarDataList.get(i));
			}
		}
		
		if(reCalList.size() > 0){
			
			if(paramMap.get("reCalType").equals("forward")) {
				//정방향 재계산
				//첫행 데이터
				int seq0 = Integer.parseInt(reCalList.get(0).get("seqNum").toString());
				int before0 = Integer.parseInt(reCalList.get(0).get("beforeKm").toString());
				int mileage0 = Integer.parseInt(reCalList.get(0).get("mileageKm").toString());
				int after0 = before0+mileage0;
				
				paramMap.put("seqNum", seq0);
				paramMap.put("afterKm", after0);
				commonSql.update("BizCarManageDAO.updateReCalData", paramMap);
				
				for(int i=1; i<reCalList.size(); i++){
					int nextSeq = Integer.parseInt(reCalList.get(i).get("seqNum").toString());
					int nextMileage = Integer.parseInt(reCalList.get(i).get("mileageKm").toString());
					int nextAfter = after0 + nextMileage;
					
					//System.out.println("이번 주행후 거리==="+nextAfter);
					paramMap.put("seqNum", nextSeq);
					paramMap.put("beforeKm", after0);
					paramMap.put("afterKm", nextAfter);
					commonSql.update("BizCarManageDAO.updateReCalData", paramMap);
					
					//주행후거리가 다음 주행전 데이터로
					after0 = after0+nextMileage;
					
				}
				
			}else if (paramMap.get("reCalType").equals("reverse")){
				//역방향 재계산
				
				int last = reCalList.size() - 1;
				//마지막행 데이터
				int seq0 = Integer.parseInt(reCalList.get(last).get("seqNum").toString());
				int after0 = Integer.parseInt(reCalList.get(last).get("afterKm").toString());
				int mileage0 = Integer.parseInt(reCalList.get(last).get("mileageKm").toString());
				int before0 = after0-mileage0;
				
				paramMap.put("seqNum", seq0);
				paramMap.put("beforeKm", before0);
				commonSql.update("BizCarManageDAO.updateReCalData", paramMap);
				
				for(int i=last-1; i >= 0; i--){
					int nextSeq = Integer.parseInt(reCalList.get(i).get("seqNum").toString());
					int nextMileage = Integer.parseInt(reCalList.get(i).get("mileageKm").toString());
					int nextBefore = before0 - nextMileage;
					
					//System.out.println("이번 주행전 거리==="+nextBefore);
					paramMap.put("seqNum", nextSeq);
					paramMap.put("afterKm", before0);
					paramMap.put("beforeKm", nextBefore);
					commonSql.update("BizCarManageDAO.updateReCalData", paramMap);
					
					//주행전거리가 이전 주행후 데이터로
					before0 = before0-nextMileage;
					
				}
			}
			
		}
	}

	@Override
	public void bizCarErpSendInsert(Map<String, Object> paramMap) {
		commonSql.insert("BizCarManageDAO.bizCarErpSendInsert", paramMap);
		commonSql.update("BizCarManageDAO.updateBizCarErpSendYn", paramMap);
	}

	@Override
	public List<Map<String, Object>> getErpSendInfo(Map<String, Object> paramMap) {
		return commonSql.list("BizCarManageDAO.getErpSendInfo", paramMap);
	}

	@Override
	public void bizCarErpSendDelete(Map<String, Object> paramMap) {
		commonSql.delete("BizCarManageDAO.bizCarErpSendDelete", paramMap);
		commonSql.update("BizCarManageDAO.updateBizCarErpSendYn", paramMap);
		
	}

	@Override
	public List<Map<String, Object>> getDivideRowList(Map<String, Object> paramMap) {
		
		if(paramMap.get("seqNumArr") != null){
			JSONArray jsonStr = JSONArray.fromObject(paramMap.get("seqNumArr"));
			List<String> dRowList = new ArrayList<String>();
			
			for(int i=0; i<jsonStr.size(); i++){
				dRowList.add(jsonStr.getString(i));
			}
			paramMap.put("dRowList",dRowList);
		}else{
			paramMap.put("dRowList","");
		}
		
		return commonSql.list("BizCarManageDAO.getDivideRowList", paramMap);
	}

	@Override
	public void updateDivideRowList(Map<String, Object> paramMap) {
		
		JSONArray divideList = JSONArray.fromObject(paramMap.get("divideList"));
		JSONObject jsonObject = new JSONObject();
		
		for(int i=0; i<divideList.size(); i++){
			jsonObject = JSONObject.fromObject(divideList.get(i));
			paramMap.put("seqNum",jsonObject.get("seqNum"));
			paramMap.put("carCode",jsonObject.get("carCode"));
			paramMap.put("driveDate",jsonObject.get("driveDate").toString().replaceAll("-", ""));
			paramMap.put("editkm",jsonObject.get("editkm"));
			paramMap.put("beforekm",jsonObject.get("beforekm"));
			paramMap.put("afterkm",jsonObject.get("afterkm"));
			
			commonSql.update("BizCarManageDAO.updateDivideRowList", paramMap);
		}
	}

	@Override
	public int getMaxSeq() {
		//최대 시퀀스+1 가져오기
		Map<String,Object> paramMap = new HashMap<String, Object>(); //cloud db스키마 파라미터 넘겨주기 위해
		int maxSeq = (int) commonSql.select("BizCarManageDAO.maxSeq", paramMap);
		return maxSeq;
	}
	
	
	@Override
	public void copyBizCarData(Map<String, Object> paramMap) {
		if(paramMap.get("seqNumArr") != null){
			JSONArray seqNumArr = JSONArray.fromObject(paramMap.get("seqNumArr"));
			List<String> copyList = new ArrayList<String>();
			
			for(int i=0; i<seqNumArr.size(); i++){
				copyList.add(seqNumArr.getString(i));
			}
			paramMap.put("copyList",copyList); //copy할 대상 seqList
			paramMap.put("insertType",1); //저장타입  0:사용자신규생성  1:복사데이터  2:북마크데이터 3:엑셀업로드
		}
		
		commonSql.insert("BizCarManageDAO.copyBizCarDataInsert", paramMap);
	}

	@Override
	public int getMaxBmSeq() {
		//즐겨찾기 최대 시퀀스+1 가져오기
		Map<String,Object> paramMap = new HashMap<String, Object>(); //cloud db스키마 파라미터 넘겨주기 위해
		int maxBmSeq = (int) commonSql.select("BizCarManageDAO.maxBmSeq", paramMap);
		return maxBmSeq;
	}

	@Override
	public void saveBookMarkList(Map<String, Object> paramMap) {
		JSONArray rowDataList = JSONArray.fromObject(paramMap.get("rowDataList"));
		JSONObject jsonObject = new JSONObject();
		
		//t_ex_biz_car_person 최대시퀀스+1 가져오기
		int seqNum = getMaxSeq();
		String td3 = "";
		String td6 = "";
		String td8 = "";
		
		for(int i=0; i<rowDataList.size(); i++){
			jsonObject = JSONObject.fromObject(rowDataList.get(i));
			paramMap.put("seqNum", seqNum+i);
			paramMap.put("carCode",jsonObject.get("carCode"));
			paramMap.put("carNum",jsonObject.get("carNum"));
			paramMap.put("carName",jsonObject.get("carName"));
			paramMap.put("driveDate",jsonObject.get("driveDate").toString().replaceAll("-", ""));
			switch (jsonObject.get("td3").toString()) {
			  case "출근": td3 = "1"; break;
			  case "퇴근": td3 = "2"; break;
			  case "출퇴근": td3 = "3"; break;
			  case "업무용": td3 = "4"; break;
			  case "비업무용": td3 = "5"; break;
			  default: td3 = ""; break;
			}
			paramMap.put("driveFlag",td3); //운행구분
			
			if(jsonObject.get("td4").toString().indexOf(":") > -1) {
				paramMap.put("startTime", jsonObject.get("td4").toString().replace(":", "")); //출발시간
			}
		    else {
		    	paramMap.put("startTime", jsonObject.get("td4").toString()); //출발시간
		    }
			
			if(jsonObject.get("td5").toString().indexOf(":") > -1) {
				paramMap.put("endTime", jsonObject.get("td5").toString().replace(":", "")); //도착시간
			}
		    else {
		    	paramMap.put("endTime", jsonObject.get("td5").toString()); //도착시간
		    }
			
			switch (jsonObject.get("td6").toString()) {
			  case "직접입력": td6 = "0"; break;
			  case "회사": td6 = "1"; break;
			  case "자택": td6 = "2"; break;
			  case "거래처": td6 = "3"; break;
			  default: td6 = ""; break;
			}
			paramMap.put("startFlag",td6); //출발구분
			paramMap.put("startAddr",jsonObject.get("td7")); //출발지
			switch (jsonObject.get("td8").toString()) {
			  case "직접입력": td8 = "0"; break;
			  case "회사": td8 = "1"; break;
			  case "자택": td8 = "2"; break;
			  case "거래처": td8 = "3"; break;
			  default: td8 = ""; break;
			}
			paramMap.put("endFlag",td8); //도착구분
			paramMap.put("endAddr",jsonObject.get("td9")); //도착지
			paramMap.put("note",jsonObject.get("td10")); //비고
			
			paramMap.put("startAddrDetail",jsonObject.get("startAddrDetail")); //출발지상세
			paramMap.put("endAddrDetail",jsonObject.get("endAddrDetail")); //도착지상세
			
			paramMap.put("insertType",2); //저장타입  0:사용자신규생성  1:복사데이터  2:북마크데이터 3:엑셀업로드
			commonSql.insert("BizCarManageDAO.insertBizCarData", paramMap);
		}
		
	}

	@Override
	public Map<String, Object> getCarAfterKm(Map<String, Object> paramMap) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		List<Map<String, String>> afterKm = commonSql.list("BizCarManageDAO.getCarAfterKm", paramMap);
		map.put("afterKm", afterKm);
		
		return map;
	}

	@Override
	public void updateAmtData(Map<String, Object> paramMap) {
		
		commonSql.update("BizCarManageDAO.updateAmtData", paramMap);
		
	}

	@Override
	public Map<String, Object> getCarNum(Map<String, Object> paramMap) {
		Map<String, Object> carMap = new HashMap<String, Object>();
		
		List<Map<String, String>> carNumData = commonSql.list("BizCarManageDAO.getBizCarUserAddress", paramMap);
		if(carNumData.size() > 0){ //저장된 주소값이 있을떄
			String compAddr = carNumData.get(0).get("COMP_ADDR") + "";
			String houseAddr = carNumData.get(0).get("HOUSE_ADDR") + "";
			
			carMap.put("compAddr", compAddr);
			carMap.put("houseAddr", houseAddr);
			carMap.put("newYn", "N");
		}else{ //신규면 GW 주소 정보 가져오기			
			List<Map<String, String>> gwUserData = commonSql.list("BizCarManageDAO.getGwUserAddress", paramMap);
			String compAddr = gwUserData.get(0).get("COMP_ADDR") + "";
			String houseAddr = gwUserData.get(0).get("HOUSE_ADDR") + "";
			
			carMap.put("compAddr", compAddr);
			carMap.put("houseAddr", houseAddr);
			carMap.put("newYn", "Y");
		}
		
		return carMap;
	}
	
	
		

	
}
