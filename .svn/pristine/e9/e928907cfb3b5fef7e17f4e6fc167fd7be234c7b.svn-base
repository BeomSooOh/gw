package neos.cmm.systemx.secGrade.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.secGrade.constant.Constant;
import neos.cmm.systemx.secGrade.dao.SecGradeDAO;
import neos.cmm.systemx.secGrade.service.SecGradeService;
import neos.cmm.systemx.secGrade.util.SecGradeUtil;
import neos.cmm.systemx.secGrade.vo.CompInfo;
import neos.cmm.systemx.secGrade.vo.SecGrade;
import neos.cmm.systemx.secGrade.vo.SecGradeRemoveResponse;
import neos.cmm.systemx.secGrade.vo.SecGradeUser;
import neos.cmm.systemx.secGrade.vo.SecGradeUserMatchedInfo;
import net.sf.json.JSONObject;
import restful.mobile.vo.RestfulRequest;
import restful.mobile.vo.RestfulRequestHeader;

@Service("SecGradeService")
public class SecGradeServiceImpl implements SecGradeService {

	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "SecGradeDAO")
	SecGradeDAO secGradeDAO;
	
	private Logger logger = Logger.getLogger(SecGradeServiceImpl.class);
	
	@Override
	public List<SecGrade> getSecGradeList(Map<String, Object> params) throws Exception {
		
		//회사 코드 : "0"이면 그룹, "" 빈스트링이면 전체 , "6" 등 
		String compSeq = (String) params.get("compSeq");
		String userSe = (String) params.get("userSe");
		if("".equals(compSeq)) {//전체이면(그룹 포함 나머지 회사들 전체 조회)

			if (userSe.equals("ADMIN")) {
				params.put("compSeq", (String) params.get("compSeqForAdmin"));
			}
			
			List<Map<String,Object>> compList = compService.getCompListAuth(params);
			
			String compSeqList = "'0'";
			
			for (int i=0;i<compList.size();i++) {
				compSeqList += ",'" + (String) compList.get(i).get("compSeq") + "'";
			}

			params.put("compSeqList", compSeqList);
		}else {//전체가 아니면 해당 compSeq만 조회
			params.put("compSeqList", "'" + compSeq + "'");
		}
		
		params.put("addInfoType", "1");
		params.put("sharp", "#");
		
		return secGradeDAO.selectSecGrade(params);
	}

	@Override
	public void saveSecGradeUser(Map<String, Object> params) throws Exception {
		ArrayList<HashMap<String, Object>> saveList = (ArrayList<HashMap<String, Object>>) params.get("saveList");
		String secId = (String) params.get("secId");
		for(int i=0;i<saveList.size();i++) {
			HashMap<String, Object> saveParam = saveList.get(i);
			saveParam.put("createSeq", params.get("createSeq"));
			saveParam.put("secId", secId);
			if(!saveParam.containsKey("groupSeq")) {
				saveParam.put("groupSeq", params.get("groupSeq"));
			}
			
			String deptSeq = (String) saveParam.get("deptSeq");
			
			if("0".equals(deptSeq)) {
				List<String> deptSeqList = secGradeDAO.selectDeptSeqFromCompSeq(saveParam);
				for(int j=0;j<deptSeqList.size();j++) {
					saveParam.put("deptSeq", deptSeqList.get(j));
					secGradeDAO.insertSecGradeUser(saveParam);
				}
				
			}else {
				secGradeDAO.insertSecGradeUser(saveParam);
			}
		}
	}

	@Override
	public List<SecGradeUser> getSecGradeUserList(Map<String, Object> params) throws Exception {
		
		//회사 코드 : "0"이면 그룹, "" 빈스트링이면 전체 , "6" 등 
		String compSeq = (String) params.get("compSeq");
		String userSe = (String) params.get("userSe");
		if("0".equals(compSeq)) {//그룹이면(admin/master 권한에 따른 회사들 조회)

			if (userSe.equals("ADMIN")) {
				params.put("compSeq", (String) params.get("compSeqForAdmin"));
			}
			
			List<Map<String,Object>> compList = compService.getCompListAuth(params);
			
			String compSeqList = "";
			boolean isExistComp = false;
			for (int i=0;i<compList.size();i++) {
				compSeqList += ",'" + (String) compList.get(i).get("compSeq") + "'";
				isExistComp = true;
			}
			if(isExistComp) {
				compSeqList = compSeqList.substring(1);
			}

			params.put("compSeqList", compSeqList);
		}else {//전체가 아니면 해당 compSeq만 조회
			params.put("compSeqList", "'" + compSeq + "'");
		}
		
		return secGradeDAO.selectSecGradeUser(params);
	}

	@Override
	public void removeSecGradeUser(Map<String, Object> params) throws Exception {
		ArrayList<HashMap<String, Object>> removeList = (ArrayList<HashMap<String, Object>>) params.get("removeList");
		for(int i=0;i<removeList.size();i++) {
			HashMap<String, Object> removeParam = removeList.get(i);
			if(!removeParam.containsKey("groupSeq")) {
				removeParam.put("groupSeq", params.get("groupSeq"));
			}
			secGradeDAO.deleteSecGradeUser(removeParam);
		}
	}
	
	@Override
	public List<SecGrade> getSecGradeListForPop(Map<String, Object> params) throws Exception {
		
		String compSeq = (String) params.get("compSeq");
		
		String compSeqList = "'0'";
		
		if(!"0".equals(compSeq)) {//0이 아니면(그룹+해당 회사 조회)
			compSeqList += ",'" + compSeq + "'";
			params.put("compSeqList", compSeqList);
		}else {//0이면 해당 compSeq만 조회
			params.put("compSeqList", compSeqList);
		}
		
		params.put("addInfoType", "2");
		params.put("sharp", "#");
		
		return secGradeDAO.selectSecGrade(params);
	}

	@Override
	public SecGrade getSecGrade(Map<String, Object> params) throws Exception {
		return secGradeDAO.selectSecGradeOne(params);
	}

	@Override
	public void modifySecGrade(Map<String, Object> params) throws Exception {
		secGradeDAO.updateSecGrade(params);
		
	}

	@Override
	public void regSecGrade(Map<String, Object> params) throws Exception {
		
		String upperSecId = (String) params.get("upperSecId");
		String upperSecDepth = (String) params.get("upperSecDepth");
		String secOrder = (String) params.get("secOrder");
		String prevSelectedCompSeq = (String) params.get("prevSelectedCompSeq");
		String compSeq = (String) params.get("compSeq");
		int upperSecDepthNum = Integer.parseInt(upperSecDepth);
		
		if (upperSecDepthNum >= Integer.MAX_VALUE || upperSecDepthNum < Integer.MIN_VALUE) {
	        throw new IllegalArgumentException("out of bound");
	    }
		
		//upperSecDepth = 0 이면서, 회사선택을 변경했으면 변경된 회사의 upperSecId를 조회
		if("0".equals(upperSecDepth) && !prevSelectedCompSeq.equals(compSeq)) {
			upperSecId = EgovStringUtil.isNullToString(secGradeDAO.selectSecGradeByCompAndDepth(params));
			params.put("upperSecId", upperSecId);
		}
		
		//정렬 비어있으면 0으로 삽입
		if(StringUtils.isEmpty(secOrder)) {
			params.put("secOrder", 0);
		}
		//비어있으면 최상위 회사 만들어서 insert 후 등급 생성
		if(StringUtils.isEmpty(upperSecId)) {
			//upperSecId = '#' 이면서 해당 compSeq가 존재하면 secId를 upperSecId에 할당 secDepth = 1
			params.put("sharp", "#");
			SecGrade secGrade = secGradeDAO.selectSecGradeOneRoot(params);
			//루트 회사가 존재하면
			if(secGrade !=null && StringUtils.isNotEmpty(secGrade.getId())) {
				params.put("upperSecId", secGrade.getId());
				params.put("secDepth", secGrade.getSecDepth() + 1);
				secGradeDAO.insertSecGrade(params);
			}else {
				//루트 생성 위함
				String uuid = UUID.randomUUID().toString().toUpperCase().replaceAll("-", "");
				HashMap<String, Object> paramForRootComp = new HashMap<>();
				paramForRootComp.put("groupSeq", params.get("groupSeq"));
				paramForRootComp.put("secId", uuid);
				paramForRootComp.put("upperSecId", "#");
				paramForRootComp.put("secDepth", 0);
				paramForRootComp.put("compSeq", params.get("compSeq"));
				paramForRootComp.put("useModule", params.get("useModule"));
				paramForRootComp.put("etc", "");
				paramForRootComp.put("iconYn", "N");
				paramForRootComp.put("useYn", "Y");
				paramForRootComp.put("empSeq", params.get("empSeq"));
				
				//회사정보 조회 (회사 한국어,영문,일본어,중국어, 정렬값 조회)
				CompInfo compInfo = secGradeDAO.selectCompInfo(paramForRootComp);
				paramForRootComp.put("secOrder", compInfo.getSecOrder());
				paramForRootComp.put("secNameKr", compInfo.getSecNameKr());
				paramForRootComp.put("secNameEn", compInfo.getSecNameEn());
				paramForRootComp.put("secNameJp", compInfo.getSecNameJp());
				paramForRootComp.put("secNameCn", compInfo.getSecNameCn());
				
				secGradeDAO.insertSecGrade(paramForRootComp);
				params.put("upperSecId", uuid);
				params.put("secDepth", 1);
				secGradeDAO.insertSecGrade(params);
			}
		}else {
			params.put("secDepth", upperSecDepthNum + 1);
			secGradeDAO.insertSecGrade(params);
		}
		
	}

	@Override
	public SecGradeRemoveResponse canRemoveSecGrade(Map<String, Object> params) throws Exception {
		SecGradeRemoveResponse secGradeRemoveResponse = new SecGradeRemoveResponse();

		String secId = (String) params.get("secId");
		String langCode = (String) params.get("langCode");
		String module = (String) params.get("module");
		
		//서버 기본정보
		String scheme = (String) params.get("scheme");
		String serverName = (String) params.get("serverName");
		int serverPort  = (int) params.get("serverPort");
		String apiUrl = (String) params.get("apiUrl");
		
		RestfulRequest request = new RestfulRequest();
		RestfulRequestHeader requestHeader = new RestfulRequestHeader();
		HashMap<String, Object> requestBody = new HashMap<>();
		requestHeader.setGroupSeq((String)params.get("groupSeq"));
		requestHeader.setEmpSeq((String)params.get("empSeq"));
		requestHeader.settId("");
		requestHeader.setpId("");
		request.setHeader(requestHeader);
		request.setBody(requestBody);
		//서버 기본정보 + API URL
		String url = "";
		
		//전자결재(영리)
		if(Constant.MODULE_EAP.equals(module)) {
			//삭제가능 API URL
			//전자결재(영리) 삭제가능 API URL 받아라.
			url = scheme + "://" + serverName + ":" + serverPort + apiUrl;
			//파라메터
			requestBody.put("secId", secId);
			requestBody.put("langCode", langCode);
		}
		
		//삭제 가능 여부 API 호출
		String paramObjStr = JSONObject.fromObject(request).toString();
		logger.debug("[canRemoveSecGrade][" + url + "]Request Params: " + paramObjStr);
		JSONObject returnObject = SecGradeUtil.getPostJSON(url, paramObjStr);
		logger.debug("[canRemoveSecGrade][" + url + "]Response: " + returnObject);
		
		if(returnObject != null) {
			if(!params.containsKey("unused")) {
				secGradeRemoveResponse.setCanRemoveYn(returnObject.getString("canRemoveYn"));
			}
			secGradeRemoveResponse.setType(returnObject.getString("type"));
			secGradeRemoveResponse.setTypeMessage(returnObject.getString("typeMessage"));
			secGradeRemoveResponse.setCallBackYn(returnObject.getString("callBackYn"));
			secGradeRemoveResponse.setCallBackUrl(returnObject.getString("callBackUrl"));//콜백 호출이 필요 없으면 비어있을것.
		}else {
			throw new Exception(url + "\nRequest: " + paramObjStr + "\nResponse: " + returnObject);
		}
		return secGradeRemoveResponse;
	}

	@Override
	public void removeSecGrade(Map<String, Object> params) throws Exception {
		int resultCnt = 0;
		boolean isContainsDataRemoveYn = params.containsKey("dataRemoveYn"); 
		if(!isContainsDataRemoveYn || (isContainsDataRemoveYn && "Y".equals((String)params.get("dataRemoveYn")))){
			/**
			 * 
			 * 삭제되는 대상의 secId를 upper_sec_id로 갖고 있는 노드들의 upper_sec_id를 삭제되는 대상의 parentId로 할당.
			 * 삭제되는 대상의 secId를 upper_sec_id로 갖고 있는 노드들을 포함한 그 밑 자식들의 level = level - 1로 갱신
			 */
			
			//secGradeDAO.updateSecGradeAllChild(params);
			List<SecGrade> secGradeList = secGradeDAO.selectSecGradeDirectChild(params);
			
			for(int i=0;i<secGradeList.size();i++) {
				SecGrade secGrade = secGradeList.get(i);
				HashMap<String, Object> tempParam = new HashMap<>();
				tempParam.put("groupSeq", params.get("groupSeq"));
				tempParam.put("empSeq", params.get("empSeq"));
				tempParam.put("secId", secGrade.getId());
				tempParam.put("upperSecId", secGrade.getParent());
				tempParam.put("secDepth", secGrade.getSecDepth());
				secGradeDAO.updateSecGradeChild(tempParam);
			}
			
			//해당 보안 등급 삭제 로직 실행
			resultCnt = secGradeDAO.deleteSecGrade(params);
		}
		
		//삭제가 정상적으로 실행되고 callBackUrl 존재시 호출
		String callBackUrl = (String) params.get("callBackUrl");
		if((isContainsDataRemoveYn && "N".equals((String)params.get("dataRemoveYn")) && StringUtils.isNotBlank(callBackUrl)) 
				|| (resultCnt > 0 && StringUtils.isNotBlank(callBackUrl))) {
			
			RestfulRequest request = new RestfulRequest();
			RestfulRequestHeader requestHeader = new RestfulRequestHeader();
			HashMap<String, Object> requestBody = new HashMap<>();
			requestHeader.setGroupSeq((String)params.get("groupSeq"));
			requestHeader.setEmpSeq((String)params.get("empSeq"));
			requestHeader.settId("");
			requestHeader.setpId("");
			request.setHeader(requestHeader);
			request.setBody(requestBody);
			
			String secId = (String) params.get("secId");//삭제되는 대상의 보안등급코드
			String langCode = (String) params.get("langCode");
			String type = (String) params.get("type");
			//서버 기본정보
			String scheme = (String) params.get("scheme");
			String serverName = (String) params.get("serverName");
			int serverPort  = (int) params.get("serverPort");
			//서버 기본정보 + API URL
			String url = scheme + "://" + serverName + ":" + serverPort + "/" + callBackUrl;
			//파라메터
			requestBody.put("secId", secId);
			requestBody.put("langCode", langCode);
			requestBody.put("type", type);
			
			//callBack API 호출
			String paramObjStr = JSONObject.fromObject(request).toString();
			logger.debug("[CallBack removeSecGrade][" + url + "]Request Params: " + paramObjStr);
			JSONObject returnObject = SecGradeUtil.getPostJSON(url, paramObjStr);
			logger.debug("[CallBack removeSecGrade][" + url + "]Response: " + returnObject);
		}
		
	}

	@Override
	public HashMap<String, Object> getMatchedInfo(Map<String, Object> params) throws Exception {
		HashMap<String, Object> returnObj = new HashMap<>();
		SecGradeUserMatchedInfo secGradeUserMatchedInfo = new SecGradeUserMatchedInfo();
		//필수 파라메터 체크
		if(!validateForMathcedInfo(params)) {
			returnObj.put("resultCode", Constant.COMMON_ERROR_COM700);
			return returnObj;
		}
		//입력받은 보안등급
		String secId = (String) params.get("secId");
		//기본설정
		secGradeUserMatchedInfo.setOriginSecId(secId);
		secGradeUserMatchedInfo.setMatched(false);
		
		/*
		 * compSeq, deptSeq, empSeq에 [해당 하는 모든 secId] 조회후 [input secId]가 존재하는지 조회
		 * 존재하지 않으면 [해당 하는 모든 secId] 하위 모든 ID 조회 하여 input secId가 있는지 조회 있으면 true 없으면 false
		 */
		List<String> secIdListWithUser = secGradeDAO.selectSecGradeUserFromUserInfo(params);
		
		boolean isExists = false;
		//compSeq, deptSeq, empSeq에 [해당 하는 모든 secId] 조회후 [input secId]가 존재하는지 조회
		for(int i=0;i<secIdListWithUser.size();i++) {
			String secIdWithUser = secIdListWithUser.get(i);
			if(secIdWithUser.equals(secId)) {
				secGradeUserMatchedInfo.setMatched(true);
				secGradeUserMatchedInfo.setMatchedSecId(secId);
				isExists = true;
				break;
			}
		}
		//존재하지 않으면, [해당 하는 모든 secId] 하위 모든 ID 조회 하여 input secId가 있는지 조회 있으면 true 없으면 false
		//존재하지 않으면, 상위 모든 노드 조회
		
		if(!isExists) {
			boolean isExistsAtChild = false;
			Map<String, Object> tempParam = new HashMap<>();
			tempParam.put("groupSeq", params.get("groupSeq"));
			tempParam.put("secId", secId);
			
			String[] secGradeAllParent = secGradeDAO.selectSecGradeAllParentString(tempParam).split("\\|");
			for(int i=0;i<secIdListWithUser.size();i++) {
				if(isExistsAtChild) {
					break;
				}
				String secIdWithUser = secIdListWithUser.get(i);
				
				for(int j=0;j<secGradeAllParent.length;j++) {
					String parent = secGradeAllParent[j];
					if(secIdWithUser.equals(parent)) {
						secGradeUserMatchedInfo.setMatched(true);
						secGradeUserMatchedInfo.setMatchedSecId(secIdWithUser);
						isExistsAtChild = true;
						break;
					}
				}
			}
		}
		
		returnObj.put("result", secGradeUserMatchedInfo);
		returnObj.put("resultCode", Constant.API_RESPONSE_SUCCESS);
		
		return returnObj;
	}
	
	//사용자 보안등급 매칭정보 필수 파라메터 체크
	private boolean validateForMathcedInfo(Map<String, Object> params) {
		if(params.get("secId") == null || StringUtils.isBlank((String)params.get("secId"))) {
			return false;
		}
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("compSeq") == null || StringUtils.isBlank((String)params.get("compSeq"))) {
			return false;
		}
		if(params.get("deptSeq") == null || StringUtils.isBlank((String)params.get("deptSeq"))) {
			return false;
		}
		if(params.get("empSeq") == null || StringUtils.isBlank((String)params.get("empSeq"))) {
			return false;
		}
		return true;
	}

	@Override
	public HashMap<String, Object> getSecGradeInfo(Map<String, Object> params) throws Exception {
		HashMap<String, Object> returnObj = new HashMap<>();
		//필수 파라메터 체크
		if(!validateForSecGradeInfo(params)) {
			returnObj.put("resultCode", Constant.COMMON_ERROR_COM700);
			return returnObj;
		}
		
		params.put("addInfoType", "0");
		params.put("sharp", "#");
		
		returnObj.put("result", secGradeDAO.selectSecGrade(params));
		returnObj.put("resultCode", Constant.API_RESPONSE_SUCCESS);
		return returnObj;
	}
	
	//보안등급코드정보 필수 파라메터 체크
	private boolean validateForSecGradeInfo(Map<String, Object> params) {
		if(params.get("groupSeq") == null || StringUtils.isBlank((String)params.get("groupSeq"))) {
			return false;
		}
		if(params.get("useModule") == null || StringUtils.isBlank((String)params.get("useModule"))) {
			return false;
		}
		return true;
	}
}
