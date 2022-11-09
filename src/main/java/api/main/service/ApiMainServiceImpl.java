package api.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import api.common.dao.APIDAO;
import api.common.exception.APIException;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("ApiMainService")
public class ApiMainServiceImpl implements ApiMainService{
	
	@Resource(name = "APIDAO")
	private APIDAO apiDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Override
	public Object action(String serviceName, Map<String, Object> body) {
		
		Object o = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		if(serviceName.equals("AlertCnt")) {
			o = AlertCnt(body);
			resultMap.put("alertCnt", o);
			return resultMap;
		} 
		else if(serviceName.equals("AlertList")) {
			return AlertList(body);
		}
		else if(serviceName.equals("AlertRead")) {
			return AlertRead(body);
		} else if(serviceName.equals("TimelineCnt")) {
			o = TimelineCnt(body);
			resultMap.put("timelineCnt", o);
			return resultMap;
		} 
		else if(serviceName.equals("TimelineList")) {
			return TimelineList(body);
		}
		else if(serviceName.equals("TimelineRead")) {
			return TimelineRead(body);
		}
		else if(serviceName.equals("CmmOptionValue")) {
			return CmmOptionValue(body);
		}
		else if(serviceName.equals("CmmOptionValueList")) {
			return CmmOptionValueList(body);
		}
		
		return resultMap;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public int AlertCnt(Map request) {
		
		return CommonUtil.getIntNvl(apiDAO.select("apiMainDAO.selectAlert_TOTAL_COUNT", request)+"");
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Map<String, Object> AlertList(Map request) {
		String pageSize = request.get("pageSize")+"";
		if (EgovStringUtil.isEmpty(pageSize)) {
			throw new APIException("AL000");
		}
		
		String pageNum = request.get("pageNum")+"";
		if (EgovStringUtil.isEmpty(pageNum)) {
			throw new APIException("AL010");
		}
		
		String syncTime =  request.get("syncTime")+"";
		
		if(request.get("newYn") != null){
				request.put("newYn", request.get("newYn"));
				request.put("syncTime", "");
				syncTime = "";
		}else{
			/** db쪽에서 최초 조회시간을 가져온다. */
			if (EgovStringUtil.isEmpty(syncTime)) {
				syncTime = (String) apiDAO.select("apiMainDAO.selectSynctime", request);
				request.put("syncTime", syncTime);
			}			
		}
		
		/** 페이지 처리 */
		int size = CommonUtil.getIntNvl(pageSize);
		int page = CommonUtil.getIntNvl(pageNum);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setPageSize(size);
		paginationInfo.setCurrentPageNo(page);
		
		request.put("pageSize", size+1); // 더보기 유무 알기 위해 페이지 사이즈보다 1크게 조회
		
		/** db 처리 */
		Map<String,Object> map = apiDAO.listOfPaging2(request, paginationInfo, "apiMainDAO.selectAlertList");
		
		List<Map<String,String>> list = (List<Map<String, String>>) map.get("list");
		int totalCount =  CommonUtil.getIntNvl(map.get("totalCount")+"");
		
		/** 더보기 유무 */
		String moreYn = "N";
		
		Map<String, Object> reusltMap = new HashMap<String,Object>();
		if (totalCount > size*page) {
			moreYn = "Y";
		}

		reusltMap.put("alertList", list);
		reusltMap.put("moreYn", moreYn);
		reusltMap.put("syncTime", syncTime);
		
		//syncTime 기준조회일 경우 자동 일괄 읽음처리
		if(request.get("newYn") == null){
			apiDAO.update("apiMainDAO.updateAlertAllRead", request);
		}
		
		return reusltMap;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int AlertRead(Map request) {
		String alertSeqListStr = request.get("alertSeqList")+"";

		if (!EgovStringUtil.isEmpty(alertSeqListStr)) {
			JSONArray jsonArr = JSONArray.fromObject(alertSeqListStr);
			if (jsonArr != null) {
				String[] arr = new String[jsonArr.size()];
				for(int i = 0; i < jsonArr.size(); i++) {
					JSONObject json = JSONObject.fromObject(jsonArr.get(i));
					arr[i] = json.getString("alertSeq");
				}
				request.put("alertSeqList", arr);
			}
		} else {
			request.put("alertSeqList", null);
		}
		
		int r = apiDAO.update("apiMainDAO.updateAlertRead", request);
		
		return r > 0 ? 1 : 0;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public int TimelineCnt(Map request) {
		
		/** 
		 * 2016-07-07 주성덕 
		 * 변경내용 : 타임라인 토탈카운트 리턴값 0으로 고정
		 * 요청내용 : 정현수 이상님 요청건.
		 */
		// return CommonUtil.getIntNvl(apiDAO.select("apiMainDAO.selectTimeline_TOTAL_COUNT", request)+"");
		///////////////////////
		return 0;
		
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Map<String, Object> TimelineList(Map request) {
		String pageSize = request.get("pageSize")+"";
		if (EgovStringUtil.isEmpty(pageSize)) {
			throw new APIException("AL000");
		}
		
		String pageNum = request.get("pageNum")+"";
		if (EgovStringUtil.isEmpty(pageNum)) {
			throw new APIException("AL010");
		}
		
		/** db쪽에서 최초 조회시간을 가져온다. */
		String syncTime =  request.get("syncTime")+"";
		if (EgovStringUtil.isEmpty(syncTime)) {
			syncTime = (String) apiDAO.select("apiMainDAO.selectSynctime", request);
			request.put("syncTime", syncTime);
		}
		
		/** 페이지 처리 */
		int size = CommonUtil.getIntNvl(pageSize);
		int page = CommonUtil.getIntNvl(pageNum);
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		paginationInfo.setPageSize(size);
		paginationInfo.setCurrentPageNo(page);
		
		request.put("pageSize", size+1); // 더보기 유무 알기 위해 페이지 사이즈보다 1크게 조회
		
		/** db 처리 */
		Map<String,Object> map = apiDAO.listOfPaging2(request, paginationInfo, "apiMainDAO.selectTimelineList");
		
		List<Map<String,String>> list = (List<Map<String, String>>) map.get("list");
		int totalCount =  CommonUtil.getIntNvl(map.get("totalCount")+"");
		
		/** 더보기 유무 */
		String moreYn = "N";
		
		Map<String, Object> reusltMap = new HashMap<String,Object>();
		if (totalCount > size*page) {
			moreYn = "Y";
		}

		reusltMap.put("timelineList", list);
		reusltMap.put("moreYn", moreYn);
		reusltMap.put("syncTime", syncTime);
		
		apiDAO.update("apiMainDAO.updateTimelineAllRead", request);
		
		return reusltMap;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public int TimelineRead(Map request) {
		String tlSeqListStr = request.get("tlSeqList")+"";

		if (!EgovStringUtil.isEmpty(tlSeqListStr)) {
			JSONArray jsonArr = JSONArray.fromObject(tlSeqListStr);
			if (jsonArr != null) {
				String[] arr = new String[jsonArr.size()];
				for(int i = 0; i < jsonArr.size(); i++) {
					JSONObject json = JSONObject.fromObject(jsonArr.get(i));
					arr[i] = json.getString("tlSeq");
				}
				request.put("tlSeqList", arr);
			}
		} else {
			request.put("tlSeqList", null);
		}
		
		int r = apiDAO.update("apiMainDAO.updateTimelineRead", request);
		
		return r > 0 ? 1 : 0;
	}
	
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map<String, Object> CmmOptionValue(Map request) {
		try{
			Map<String, Object> para = new HashMap<String, Object>();
			
			para.put("groupSeq", request.get("groupSeq"));
			para.put("compSeq", request.get("compSeq"));
			para.put("optionId", request.get("optionId"));		
			para.put("langCode", request.get("langCode"));
			
			return (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueInfo", para);
		}catch(Exception e){
			return null;
		}
		
	}

	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map<String, Object>> CmmOptionValueList(Map request) {
		try{
			Map<String, Object> para = new HashMap<String, Object>();
			
			para.put("groupSeq", request.get("groupSeq"));
			para.put("compSeq", request.get("compSeq"));				
			para.put("langCode", request.get("langCode"));
			
			List<Map<String, Object>> list = (List<Map<String, Object>>) request.get("optionIdList");
			String[] arrOptionId = new String[list.size()];
			int idx = 0;
			
			for(Map<String, Object> mp : list) {
				arrOptionId[idx] = (String) mp.get("optionId");
				idx++;
			}
			
			para.put("arrOptionId", arrOptionId);
			
			return commonSql.list("CmmnCodeDetailManageDAO.getOptionSetValueInfoList", para);
		}catch(Exception e){
			return null;
		}
		
	}
}
