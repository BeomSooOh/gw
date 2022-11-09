package api.addr.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import api.common.dao.APIDAO;
import api.common.model.APIResponse;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.dao.CommonOptionManageDAO;
import neos.cmm.util.CommonUtil;
import main.web.BizboxAMessage;

@Service("AddrService")
public class AddrServiceImpl implements AddrService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "APIDAO")
	private APIDAO apiDAO;
	
	@Resource(name = "CommonOptionDAO")
    private CommonOptionManageDAO commonOptionDAO;

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse addrGroupList(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("groupSeq", header.get("groupSeq"));
			param.put("addrGroupTp", body.get("addrGroupTp"));
			param.put("endNum", body.get("endNum"));
			param.put("startNum", body.get("startNum"));
			
			
			if(body.get("adminAuth") == null || body.get("adminAuth").toString().equals("") || body.get("adminAuth").toString().equals("USER")) {
				param.put("adminAuth", "");
			}
			else {
				param.put("adminAuth","ADMIN");
			}

			
			param.put("txtSearchGroupNm", "");
			param.put("useYN", "Y");
			
			
			//주소록 관련 옵션조회 (회사 주소록 그룹 등록 가능여부)
			param.put("optionId", "com400");
			Map<String,Object> optionInfo = (Map<String, Object>) commonOptionDAO.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", param);
			if(optionInfo != null) {
				param.put("com400", optionInfo.get("val").toString());
			}
			
			//주소록 그룹 가져오기.
			params.put("AddrGroupList", commonSql.list("AddrManageService.GetAddrGroupList", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse addrList(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("groupSeq", header.get("groupSeq"));
			
			if(body.get("adminAuth") == null || body.get("adminAuth").toString().equals("") || body.get("adminAuth").toString().equals("USER")) {
				param.put("adminAuth", "");
			}
			else {
				param.put("adminAuth","ADMIN");
			}
			
			param.put("chkMyGroup", "");
			param.put("addrDiv", "");
			param.put("addrGroupSeq", body.get("groupSeq"));
			param.put("txtSearch", body.get("txtSearch"));
			param.put("searchTarget", body.get("searchTarget"));
			
			
			//주소록 리스트 가져오기
			params.put("AddrList", commonSql.list("AddrManageService.GetAddrList", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	
	
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse addrList2(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("groupSeq", header.get("groupSeq"));
			
			
			if(body.get("adminAuth") == null || body.get("adminAuth").toString().equals("") || body.get("adminAuth").toString().equals("USER")) {
				param.put("adminAuth", "");
			}
			else {
				param.put("adminAuth","ADMIN");
			}
			
			param.put("chkMyGroup", "");
			param.put("addrDiv", "");
			param.put("addrGroupSeq", body.get("groupSeq"));
			param.put("txtSearch", body.get("txtSearch"));
			param.put("searchTarget", body.get("searchTarget"));
			
			if(body.get("searchTarget") != null && body.get("searchTarget").toString().equals("mailReceiver")){
				String[] arrTxtSearch = body.get("txtSearch").toString().split(",");	
				param.put("txtSearch", arrTxtSearch);
			}
			
			
			//주소록 리스트 가져오기
			param.put("targetModule", "mail");
			params.put("AddrList", commonSql.list("AddrManageService.GetAddrList2", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse addrInfo(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");

			param.put("addrSeq", body.get("addrSeq"));
			param.put("groupSeq", header.get("groupSeq"));
			
			
			//주소록 정보 가져오기.
			params.put("AddrInfo", commonSql.list("AddrManageService.GetAddrInfo", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse InsertAddrInfo(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");

			int addrGroupSeq = Integer.parseInt(body.get("addrGroupSeq").toString());
			String addrDiv = "";
			
			
			
			if(body.get("addrGroupSeq").toString().equals("0")){
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("groupSeq", header.get("groupSeq"));
				Object addrGroupID = commonSql.select("AddrManageService.GetAddrGroupID", para);
				if(addrGroupID == null) {
					addrGroupID = "0";
				}
				addrGroupSeq = Integer.parseInt(addrGroupID.toString()) + 1;
				para.put("addr_group_id", Integer.parseInt(addrGroupID.toString()) + 1);
				para.put("addr_group_nm", "SENT");
				para.put("addr_group_tp", "30");
				para.put("addr_group_desc", "");
				para.put("useYn", "Y");
				para.put("empSeq", header.get("empSeq"));
				
				commonSql.insert("AddrManageService.InsrtAddrGroupInfo", para);
				
				//공개범위 저장
				Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", para);
				if(addrPublicID == null) {
						addrPublicID = "0";
				}
				
				para.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
				para.put("gbnInfo", "m");
				para.put("seqInfo", header.get("empSeq"));
				
				commonSql.insert("AddrManageService.InsertAddrPublicInfo", para);
				
				addrDiv = "30"; //신규등록일 경우 주소록 그룹 구분 기본값 = 30(개인)
				
				params.put("addrGroupSeq", addrGroupSeq);
			}
			else{
				//기존 등록되어 있는 주소록 그룹 구분 가져오기.
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("groupSeq", header.get("groupSeq"));
				para.put("addr_group_seq", addrGroupSeq);
				Object addrGroupDiv = commonSql.select("AddrManageService.GetAddrGroupTp", para);
				addrDiv = addrGroupDiv.toString();
				
				Object addrSeq = commonSql.select("AddrManageService.GetAddrID", para);
				if(addrSeq == null) {
						addrSeq = "0";
				}
				
				params.put("addrSeq", Integer.parseInt(addrSeq.toString()));
				params.put("addrGroupSeq", addrGroupSeq);
				params.put("groupSeq", header.get("groupSeq"));
				params.put("compSeq", company.get("compSeq"));
				params.put("addrDiv", addrDiv);
				params.put("empNm", body.get("empNm"));
				params.put("empEmail", body.get("empEmail"));
				params.put("empHp", body.get("empHp"));
				params.put("empFax", body.get("empFax"));
				params.put("empSeq", header.get("empSeq"));
				
				commonSql.insert("AddrManageService.InsertAddrInfo", params);
				params.clear();
			}
			
			
			
			
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse faxAddrGroupList(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));		
			param.put("groupSeq", header.get("groupSeq"));

			param.put("useYN", "Y");
			
			
			//주소록 그룹 가져오기.
			params.put("addrGroupList", commonSql.list("AddrManageService.GetAddrGroupList_api", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse faxAddrList(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("groupSeq", header.get("groupSeq"));
			
			param.put("addrGroupSeq", body.get("addrGroupSeq"));
			param.put("txtSearch", body.get("txtSearch"));
			param.put("searchTarget", body.get("searchTarget"));
			
			
			param.put("apiFlag", "fax");
			
			
			String pageSize = body.get("pageSize")+"";
			String pageNum = body.get("pageNum")+"";
			
			/** db쪽에서 최초 조회시간을 가져온다. */
			String syncTime =  body.get("syncTime")+"";
			if (EgovStringUtil.isEmpty(syncTime) || syncTime.equals("0")) {
				syncTime = (String) commonSql.select("apiMainDAO.selectSynctime", param);
				param.put("syncTime", syncTime);
			}
			
			if (EgovStringUtil.isEmpty(pageSize) || EgovStringUtil.isEmpty(pageNum)){				
				if(body.get("searchTarget") == null){
					body.put("searchTarget", "all");
				}else{
					String searchTarget = body.get("searchTarget").toString();
					if(!searchTarget.equals("all") && !searchTarget.equals("name") && !searchTarget.equals("comp") && !searchTarget.equals("email") && !searchTarget.equals("fax")){
						response.setResultCode("ERROR001");
						response.setResultMessage(BizboxAMessage.getMessage("TX800000000","검색조건 오류") + "(searchTarget)");
						return response;
					}
				}
				
				List<Map<String,Object>> list = commonSql.list("AddrManageService.GetAddrList",param);
				
				//주소록 리스트 가져오기
				params.put("addrList", list);
	
				params.put("moreYn", "N");
				params.put("syncTime", syncTime);
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(params);
			}
				
			
			else{
				/** 페이지 처리 */
				int size = CommonUtil.getIntNvl(pageSize);
				int page = CommonUtil.getIntNvl(pageNum);
				
				PaginationInfo paginationInfo = new PaginationInfo();
				
				paginationInfo.setPageSize(size);
				paginationInfo.setCurrentPageNo(page);
				
				
				if(body.get("searchTarget") == null){
					body.put("searchTarget", "all");
				}else{
					String searchTarget = body.get("searchTarget").toString();
					if(!searchTarget.equals("all") && !searchTarget.equals("name") && !searchTarget.equals("comp") && !searchTarget.equals("email") && !searchTarget.equals("fax")){
						response.setResultCode("ERROR001");
						response.setResultMessage(BizboxAMessage.getMessage("TX800000000","검색조건 오류") + "(searchTarget)");
						return response;
					}
				}
				
				Map<String,Object> map = commonSql.listOfPaging2(param, paginationInfo, "AddrManageService.GetAddrList");
				
				//주소록 리스트 가져오기
				params.put("addrList", map.get("list"));
				
				int totalCount =  CommonUtil.getIntNvl(map.get("totalCount")+"");
				
				/** 더보기 유무 */
				String moreYn = "N";			
				
				if (totalCount > size*page) {
					moreYn = "Y";
				}						
				params.put("moreYn", moreYn);
				params.put("syncTime", syncTime);
	
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(params);
			}
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse addrGroupList2(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");
			
			param.put("langCode", body.get("langCode"));
			param.put("deptSeq", company.get("deptSeq"));
			param.put("compSeq", company.get("compSeq"));
			param.put("empSeq", header.get("empSeq"));
			param.put("addrGroupTp", body.get("addrGroupTp"));
			param.put("groupSeq", header.get("groupSeq"));
			
			
			if(body.get("adminAuth") == null || body.get("adminAuth").toString().equals("") || body.get("adminAuth").toString().equals("USER")) {
				param.put("adminAuth", "");
			}
			else {
				param.put("adminAuth","ADMIN");
			}
			
			param.put("txtSearchGroupNm", "");
			param.put("useYN", "Y");
			
			
			//주소록 그룹 가져오기.
			params.put("AddrGroupList", commonSql.list("AddrManageService.GetAddrGroupList2", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}
	
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse InsertAddrInfo2(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
				Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
				Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
				Map<String, Object> company = (Map<String, Object>)body.get("companyInfo");					
				
				Object addrSeq = new Object();
				
				
				params.put("addrGroupSeq", body.get("addrGroupSeq").toString());
				params.put("groupSeq", header.get("groupSeq"));
				params.put("compSeq", company.get("compSeq"));
				params.put("addrDiv", body.get("addrGroupTp").toString());
				params.put("empNm", body.get("empNm"));
				params.put("empEmail", body.get("empEmail"));
				params.put("empHp", body.get("empHp"));
				params.put("empFax", body.get("empFax"));
				params.put("empSeq", header.get("empSeq"));
				
				if(body.get("addrSeq") == null || (body.get("addrSeq")+"").equals("")){
					addrSeq = commonSql.select("AddrManageService.GetAddrID", params);
					if(addrSeq == null) {
							addrSeq = "0";
					}
					params.put("addrSeq", Integer.parseInt(addrSeq.toString()) + 1);
				}else{
					params.put("addrSeq", body.get("addrSeq"));
				}
				
				
				
				
				commonSql.insert("AddrManageService.InsertAddrInfo", params);
				addrSeq = params.get("addrSeq");
				params.clear();
				
				resultMap.put("addrSeq", addrSeq);
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));				
				response.setResult(resultMap);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings({ "unchecked", "unused" })
	@Override
	public APIResponse InsertAddrGroup(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");				
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			//신규등록
			if(body.get("addrGroupSeq") == null || (body.get("addrGroupSeq")+"").equals("")){
				
				params.put("addr_group_nm", body.get("addrGroupNm"));
				params.put("addr_group_tp", body.get("addrGroupTp"));
				params.put("addr_group_des", body.get("addrGroupDes"));
				params.put("useYn", body.get("useYn"));
				params.put("empSeq", body.get("empSeq"));
				params.put("groupSeq", header.get("groupSeq"));
				
				
				Object addrGroupID = commonSql.select("AddrManageService.GetAddrGroupID", params);
				if(addrGroupID == null) {
					addrGroupID = "0";
				}
				params.put("addr_group_id", Integer.parseInt(addrGroupID.toString()) + 1);
				commonSql.insert("AddrManageService.InsrtAddrGroupInfo", params);
				
				
				//공개범위등록
				List<Map<String, Object>> authList = (List<Map<String, Object>>) body.get("authList");
				
								
				if(body.get("addrGroupTp").equals("10")){
					
					Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", params);
					if(addrPublicID == null) {
							addrPublicID = "0";
					}
					
					Map<String, Object> authMp = new HashMap<String, Object>();	
					authMp.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
					authMp.put("addr_group_id", params.get("addr_group_id"));
					authMp.put("gbnInfo", "c");
					authMp.put("seqInfo", authList.get(0).get("orgSeq"));
					authMp.put("empSeq", body.get("empSeq"));
				}
				else if(body.get("addrGroupTp").equals("20")){
					int index = 0;
					for(Map<String, Object> mp : authList){
						
						Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", params);
						if(addrPublicID == null) {
							addrPublicID = "0";
						}
								
						Map<String, Object> authMp = new HashMap<String, Object>();	
						authMp.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
						authMp.put("addr_group_id", params.get("addr_group_id"));
						authMp.put("gbnInfo", mp.get("orgDiv"));
						authMp.put("seqInfo", mp.get("orgSeq"));
						authMp.put("empSeq", body.get("empSeq"));
						authMp.put("groupSeq", header.get("groupSeq"));
						commonSql.insert("AddrManageService.InsertAddrPublicInfo", authMp);
						
						index++;
					}
				}	
				resultMap.put("addrGroupId", params.get("addr_group_id"));
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(resultMap);
			}
			//업데이트
			else{
				params.put("addr_group_nm", body.get("addrGroupNm"));
				params.put("addr_group_tp", body.get("addrGroupTp"));
				params.put("addr_group_des", body.get("addrGroupDes"));
				params.put("useYn", body.get("useYn"));
				params.put("empSeq", body.get("empSeq"));	
				params.put("groupSeq", header.get("groupSeq"));
				
				
				params.put("addr_group_id", body.get("addrGroupSeq"));
				commonSql.update("AddrManageService.UpdateAddrGroupInfo", params);
				
				//기존 공개범위 삭제 후 insert
				commonSql.delete("AddrManageService.DeleteAddrPublicID", params);
				
				
				//공개범위재등록
				List<Map<String, Object>> authList = (List<Map<String, Object>>) body.get("authList");
				
				if(body.get("addrGroupTp").equals("10")){
					
					Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", params);
					if(addrPublicID == null) {
							addrPublicID = "0";
					}
					
					Map<String, Object> authMp = new HashMap<String, Object>();	
					authMp.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
					authMp.put("addr_group_id", params.get("addr_group_id"));
					authMp.put("gbnInfo", "c");
					authMp.put("seqInfo", authList.get(0).get("orgSeq"));
					authMp.put("empSeq", body.get("empSeq"));
				}
				else if(body.get("addrGroupTp").equals("20")){
					int index = 0;
					for(Map<String, Object> mp : authList){
						
						Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", params);
						if(addrPublicID == null) {
								addrPublicID = "0";
						}
						
						Map<String, Object> authMp = new HashMap<String, Object>();	
						authMp.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
						authMp.put("addr_group_id", params.get("addr_group_id"));
						authMp.put("gbnInfo", authList.get(index).get("orgDiv"));
						authMp.put("seqInfo", authList.get(index).get("orgSeq"));
						authMp.put("empSeq", body.get("empSeq"));
						authMp.put("groupSeq", header.get("groupSeq"));
						
						commonSql.insert("AddrManageService.InsertAddrPublicInfo", authMp);
						
						index++;
					}
				}
				
				resultMap.put("addrGroupId", params.get("addr_group_id"));
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(resultMap);
			}
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse InsertAddrGroupForGCMS(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");				
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			
			//신규등록
			if(body.get("addrGroupSeq") == null || (body.get("addrGroupSeq")+"").equals("")){
				
				params.put("addr_group_nm", body.get("addrGroupNm"));
				params.put("addr_group_tp", "20");
				params.put("addr_group_des", "");
				params.put("useYn", "Y");
				params.put("empSeq", "344710586"); //등록자는 GCMS관리자 seq로 고정셋팅
				params.put("groupSeq", header.get("groupSeq"));
				
				Object addrGroupID = commonSql.select("AddrManageService.GetAddrGroupID", params);
				if(addrGroupID == null) {
					addrGroupID = "0";
				}
				params.put("addr_group_id", Integer.parseInt(addrGroupID.toString()) + 1);
				commonSql.insert("AddrManageService.InsrtAddrGroupInfo", params);
				
				
				//공개범위등록 - GCMS연동용은 UC고객지원부(하위포함), GCMS관리자(유저) 고정
				String jsonStr = "[{\"orgDiv\":\"d\", \"orgSeq\":\"4090\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4097\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4119\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4120\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4121\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4122\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4123\"},{\"orgDiv\":\"d\", \"orgSeq\":\"4124\"},{\"orgDiv\":\"m\", \"orgSeq\":\"344710586\"}]";
				
				ObjectMapper mapper = new ObjectMapper();
				List<Map<String, Object>> authList = mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>(){});
				
				for(Map<String, Object> mp : authList){	
					
					Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", params);
					
					if(addrPublicID == null) {
							addrPublicID = "0";
					}
					
					Map<String, Object> authMp = new HashMap<String, Object>();	
					authMp.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
					authMp.put("addr_group_id", params.get("addr_group_id"));
					authMp.put("gbnInfo", mp.get("orgDiv"));
					authMp.put("seqInfo", mp.get("orgSeq"));
					authMp.put("empSeq", "344710586"); //등록자는 GCMS관리자 seq로 고정셋팅
					authMp.put("groupSeq", header.get("groupSeq"));
					
					commonSql.insert("AddrManageService.InsertAddrPublicInfo", authMp);
					
				}
	
				resultMap.put("addrGroupSeq", params.get("addr_group_id"));
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(params.get("addr_group_id"));
			}
			//업데이트(GCMS전용은 공개범위 고정이기때문에 업데이트 시에 공개범위는 업데이트 안함)
			else{
				params.put("addr_group_nm", body.get("addrGroupNm"));
				params.put("addr_group_tp", "20");
				params.put("addr_group_des", "");
				params.put("useYn", "Y");
				params.put("empSeq", "344710586");  //등록자는 GCMS관리자 seq로 고정셋팅
				params.put("groupSeq", header.get("groupSeq"));
				
				
				params.put("addr_group_id", body.get("addrGroupSeq"));
				commonSql.update("AddrManageService.UpdateAddrGroupInfo", params);
				
				resultMap.put("addrGroupSeq", params.get("addr_group_id"));
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(params.get("addr_group_id"));
			}
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse InsertAddrInfoForGCMS(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {				
				Map<String, Object> body = (Map<String, Object>)paramMap.get("body");									
				
				params.put("groupSeq", "duzon");
				param.put("groupSeq", "duzon");
				
				Object addrSeq = new Object();
				
				if(body.get("addrSeq") == null || (body.get("addrSeq")+"").equals("")){
					addrSeq = commonSql.select("AddrManageService.GetAddrID", params);
					if(addrSeq == null) {
							addrSeq = "0";
					}
					params.put("addrSeq", Integer.parseInt(addrSeq.toString()) + 1);
				}else{
					params.put("addrSeq", body.get("addrSeq"));
				}
				
				params.put("addrGroupSeq", body.get("addrGroupSeq").toString());
				params.put("groupSeq", "duzon");
				params.put("compSeq", "6");
				params.put("addrDiv", "20");
				params.put("empNm", body.get("empNm"));
				params.put("empEmail", body.get("empEmail"));
				params.put("empHp", body.get("empHp"));
				params.put("empFax", body.get("empFax"));
				params.put("empSeq", "344710586");
				
				commonSql.insert("AddrManageService.InsertAddrInfo", params);
				addrSeq = params.get("addrSeq");
				params.clear();
				
				resultMap.put("addrSeq", addrSeq);
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));				
				response.setResult(addrSeq);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}


	@SuppressWarnings("unchecked")
	@Override
	public APIResponse AddrGroupTp(Map<String, Object> paramMap) {
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("langCode", body.get("langCode"));
			param.put("groupSeq", header.get("groupSeq"));
			param.put("code", "mp0007");
			
			//주소록 그룹 가져오기.
			params.put("AddrGroupTpList", commonSql.list("AddrManageService.GetAddrGroupTpList", param));

			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(params);
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse CreateAddrGroup(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
	
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("groupSeq", header.get("groupSeq"));
			param.put("addr_group_nm", body.get("addrGroupNm"));
			param.put("addr_group_tp", "30");
			param.put("addr_group_desc", "");
			param.put("useYn", "Y");
			param.put("orderNum", "999");
			param.put("empSeq", body.get("empSeq"));
			
			
			Object addrGroupID = commonSql.select("AddrManageService.GetAddrGroupID", param);
			
			if(addrGroupID == null) {
				addrGroupID = "0";
			}
			param.put("addr_group_id", Integer.parseInt(addrGroupID.toString()) + 1);
			commonSql.insert("AddrManageService.InsrtAddrGroupInfo", param);

			result.put("addrGroupSeq", param.get("addr_group_id"));
			result.put("addrGroupNm", param.get("addr_group_nm"));
			
			response.setResultCode("SUCCESS");
			response.setResult(result);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			
		}catch(Exception e) {
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());	
		}
			
		return response;
	}
}
