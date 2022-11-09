package api.msg.service.impl;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.UUID;

import javax.annotation.Resource;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ibm.icu.text.SimpleDateFormat;

import api.msg.service.MsgService;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.CommonCodeUtil;


@Service("MsgService")
public class MsgServiceImpl implements MsgService{
	
	@Resource(name="MsgDAO")
	private MsgDAO msgDAO; 
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	
	public APIResponse MsgMenuVer(Map<String, Object> paramMap) {	
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> companyInfo = new HashMap<String, Object>();
		Map<String, Object> ret = new HashMap<String, Object>();
		
		try {
			
			Map<String, Object> headerJson = (Map<String, Object>) paramMap.get("header");
			Map<String, Object> bodyJson = (Map<String, Object>) paramMap.get("body");
			
			companyInfo = (Map<String, Object>) bodyJson.get("companyInfo");
			
			param.put("groupSeq", headerJson.get("groupSeq"));
			param.put("empSeq", headerJson.get("empSeq"));
			param.put("tId", headerJson.get("tId"));
			param.put("pId", headerJson.get("pId"));
			param.put("compSeq", companyInfo.get("compSeq"));
			param.put("langCode", bodyJson.get("langCode"));
			//System.out.println("param info! ======> "+param);
			
			ret.put("tId", headerJson.get("tId"));
			String result = msgDAO.getMsgMenuVer(param);
			ret.put("linkVersion", result);
			//ret.put("linkVersion", CommonUtil.getIntNvl(msgDAO.getMsgMenuVer(param)+""));
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(ret);
			
		} catch(Exception e) {
			
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
			response.setResult(ret);
			
		}
			
		return response;
	}
	

	public APIResponse MsgMenuList(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> companyInfo = new HashMap<String, Object>();
		Map<String, Object> ret = new HashMap<String, Object>();
		
		try {
			
			JSONObject headerJson = JSONObject.fromObject(paramMap.get("header"));
			JSONObject bodyJson = JSONObject.fromObject(paramMap.get("body"));
			
			companyInfo = (Map<String, Object>)bodyJson.get("companyInfo");
			
			param.put("groupSeq", headerJson.get("groupSeq"));
			param.put("empSeq", headerJson.get("empSeq"));
			param.put("tId", headerJson.get("tId"));
			param.put("pId", headerJson.get("pId"));
			param.put("compSeq", companyInfo.get("compSeq"));
			param.put("langCode", bodyJson.get("langCode"));
			param.put("scheme", paramMap.get("scheme"));
			
			if(bodyJson.get("appType") == null || bodyJson.get("appType").equals("")) {
				param.put("appType", "13");
			}else {
				param.put("appType", bodyJson.get("appType"));
			}
			
			
			//출퇴근 사용시 사용자별 출근체크가능여부 확인 후 버튼 노출여부 결정
			JSONObject json = new JSONObject();
			json.put("accessType", "msg");
			json.put("groupSeq", headerJson.get("groupSeq"));
			json.put("compSeq", companyInfo.get("compSeq"));
			json.put("deptSeq", companyInfo.get("deptSeq"));
			json.put("empSeq", headerJson.get("empSeq"));
			
			String serverName = (String) paramMap.get("serverName");
			String apiUrl = serverName + "/attend/external/api/gw/commuteCheckPermit";
					
			//사용자별 출근체크가능 여부 확인 API
			net.sf.json.JSONObject resultJson = CommonUtil.getPostJSON(apiUrl, json.toString());
			
			if(resultJson != null && !resultJson.get("result").equals("SUCCESS")) {
				param.put("comeLeaveYn", "N");
			}
			
			
			
			ret.put("tId", headerJson.get("tId"));
			List<Map<String, Object>> result = msgDAO.getMsgMenuList(param);
			
			//날개메뉴를 가져오지 못했을 경우 기본버튼(comp_seq = 0)으로 재조회
			if(result.size() == 0) {
				result = msgDAO.getMsgBaseMenuList(param);
			}
			
			for( int i = 0; i < result.size(); i++){
				Map<String,Object> rItem = (Map<String,Object>) result.get(i);
				Map<String, Object> linkNm = new HashMap<String, Object>();
				
				linkNm.put("kr", rItem.get("linkNmKr"));
				linkNm.put("en", rItem.get("linkNmEn"));
				linkNm.put("jp", rItem.get("linkNmJp"));
				linkNm.put("cn", rItem.get("linkNmCn"));
				
				rItem.put("linkNm", linkNm);
				
				
				List<Map<String, Object>> subLink = new ArrayList<Map<String, Object>>();
				if(Integer.parseInt(String.valueOf(rItem.get("subCnt"))) > 0){
				//if((Long) rItem.get("subCnt") > 0){
					param.put("upperSeq", rItem.get("linkSeq"));
					
					subLink = msgDAO.getSubMenuList(param);
					for( int j = 0; j < subLink.size(); j++){
						Map<String,Object> sItem = (Map<String,Object>) subLink.get(j);
						Map<String, Object> sLinkNm = new HashMap<String, Object>();
						
						sLinkNm.put("kr", sItem.get("linkNmKr"));
						sLinkNm.put("en", sItem.get("linkNmEn"));
						sLinkNm.put("jp", sItem.get("linkNmJp"));
						sLinkNm.put("cn", sItem.get("linkNmCn"));
						
						sItem.put("linkNm", sLinkNm);
					}
				}
				
				rItem.put("subLinkList", subLink);
			}
			
			
			ret.put("linkList", result);
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(ret);
			
		} catch(Exception e) {
			
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
			response.setResult(ret);
			
		}
			
		return response;
	}
	
	
	public APIResponse MsgLinkToken(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		
//		System.out.println("paramMap info! ======> "+paramMap);
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> companyInfo = new HashMap<String, Object>();
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> codeMp = new HashMap<String, Object>();
		
		Map<String, Object> headerJson = (Map<String, Object>) paramMap.get("header");
		Map<String, Object> bodyJson = (Map<String, Object>) paramMap.get("body");
		
		try {
			codeMp.put("groupSeq", headerJson.get("groupSeq"));
			List<Map<String, String>> mentionOption = CommonCodeUtil.getCodeList("mentionUseYn", codeMp);
			
			if(mentionOption != null && mentionOption.size() > 0){				
				
				companyInfo = (Map<String, Object>) bodyJson.get("companyInfo");
				
				param.put("groupSeq", headerJson.get("groupSeq"));
				param.put("empSeq", headerJson.get("empSeq"));
				param.put("tId", headerJson.get("tId"));
				param.put("pId", headerJson.get("pId"));
				param.put("linkSeq", bodyJson.get("lSeq"));
				//param.put("linkSeq", bodyJson.get("linkSeq"));
				param.put("userIP", bodyJson.get("userIP"));
				param.put("compSeq", companyInfo.get("compSeq"));
				param.put("langCode", bodyJson.get("langCode"));
				param.put("seq", bodyJson.get("seq"));
				param.put("subSeq", bodyJson.get("subSeq"));
				
				param.put("linkType", bodyJson.get("linkType"));
				
				if(bodyJson.get("eventType") != null){
					param.put("eventType", bodyJson.get("eventType"));
				}
				else{
					param.put("eventType", "");
				}
				
				if(bodyJson.get("eventSubType") != null){
					param.put("eventSubType", bodyJson.get("eventSubType"));
				}
				else{
					param.put("eventSubType", "");
				}
				if(bodyJson.get("urlPath") != null){
					param.put("urlPath", bodyJson.get("urlPath"));
				}
				
				else{
					param.put("urlPath", "");
				}
				param.put("ret", null);
//				System.out.println("param info! ======> "+param);
//				System.out.println("paramMap info! ======> "+paramMap);
				
				//ret.put("tId", headerJson.get("tId"));
				ret.put("linkType", bodyJson.get("linkType"));
				ret.put("lSeq", bodyJson.get("lSeq"));
				
				
				if(param.get("linkType").toString().equals("R") || param.get("linkType").toString().equals("P") || param.get("linkType").toString().equals("S")){
					param.put("lT", "0");
				}else{
					param.put("lT", "5");
				}
				
				String sRet = "";
				
				Map<String, Object> checkLinkInfo = (Map<String, Object>) commonSql.select("MsgDAO.checkLinkInfo", param);
				
				
				if(checkLinkInfo != null){
					//sRet = (String) commonSql.select("MsgDAO.getTokenFromLinkInfo", param);
					sRet = checkLinkInfo.get("token").toString();
					param.put("sRet", sRet);
				}else{
					String sUrlPath = param.get("urlPath") + "";
					sRet = (String) commonSql.select("MsgDAO.getToken", param);
					param.put("sRet", sRet);
					
					if(param.get("linkType").toString().equals("L") && !param.get("linkType").toString().equals("0")){
						sUrlPath = (String) commonSql.select("MsgDAO.getLinkUrlPath", param);
					}
					
					param.put("urlPath", sUrlPath);
					
					if(bodyJson.get("eventSubType") != null){
						if(bodyJson.get("eventSubType").equals( "AT001" ) || bodyJson.get("eventSubType").equals( "AT002" ) || bodyJson.get("eventSubType").equals( "AT003" )) {
							param.put("urlPath", ("attend/" + sUrlPath));
						}
					}
					
					commonSql.insert("MsgDAO.insertLinkInfo", param);
				}			
				
	//			String result = msgDAO.getSSOToken(param);
				if(sRet.equals("")){
					ret.put("ssoToken", param.get("ret"));
				}
				else{
					ret.put("ssoToken", sRet);
				}
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(ret);
			}
			else{
				companyInfo = (Map<String, Object>) bodyJson.get("companyInfo");
				
				param.put("groupSeq", headerJson.get("groupSeq"));
				param.put("empSeq", headerJson.get("empSeq"));
				param.put("tId", headerJson.get("tId"));
				param.put("pId", headerJson.get("pId"));
				param.put("linkSeq", bodyJson.get("lSeq"));
				//param.put("linkSeq", bodyJson.get("linkSeq"));
				param.put("userIP", bodyJson.get("userIP"));
				param.put("compSeq", companyInfo.get("compSeq"));
				param.put("langCode", bodyJson.get("langCode"));
				
				
				param.put("linkType", bodyJson.get("linkType"));
				
				if(bodyJson.get("eventType") != null){
					param.put("eventType", bodyJson.get("eventType"));
				}
				else{
					param.put("eventType", "");
				}
				
				if(bodyJson.get("eventSubType") != null){
					param.put("eventSubType", bodyJson.get("eventSubType"));
				}
				else{
					param.put("eventSubType", "");
				}
				if(bodyJson.get("urlPath") != null){
					param.put("urlPath", bodyJson.get("urlPath"));
				}
				
				else{
					param.put("urlPath", "");
				}
				param.put("ret", null);
//				System.out.println("param info! ======> "+param);
				
				//ret.put("tId", headerJson.get("tId"));
				ret.put("linkType", bodyJson.get("linkType"));
				ret.put("lSeq", bodyJson.get("lSeq"));
				String result = msgDAO.getSSOToken(param);
				if(result == null){
					ret.put("ssoToken", param.get("ret"));
				}
				else{
					ret.put("ssoToken", result);
				}
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(ret);
			}
			
		} catch(Exception e) {
			
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
			response.setResult(ret);
			
		}
			
		return response;
	}
	

	public APIResponse setMsgMenu(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("groupSeq", loginVO.getGroupSeq());
		param.put("compSeq", loginVO.getCompSeq());
		param.put("empSeq", loginVO.getUniqId());
		param.put("newCompSeq", paramMap.get("compSeq"));
		
		try {
			
			String encryptSeq = (String) commonSql.select("MsgDAO.getEncryptSeq", param);
			
			if (!encryptSeq.equals("0")) {
			
				param.put("encryptSeq", encryptSeq);
				
				commonSql.insert("MsgDAO.setEncrypt", param);
				
				commonSql.insert("MsgDAO.setMsgMenu", param);
				
			}
			
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			
		} catch(Exception e) {
			
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
			
		}
			
		return response;
	}

	
	@Override
	public APIResponse GerpLinkToken(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> ret = new HashMap<String, Object>();

		try {
			Map<String, Object> gerpUserInfo = (Map<String, Object>) commonSql.select("MsgDAO.getGerpUserInfo", paramMap);
			
			paramMap.put("groupSeq", gerpUserInfo.get("groupSeq"));
			paramMap.put("compSeq", gerpUserInfo.get("compSeq"));
			paramMap.put("empSeq", gerpUserInfo.get("empSeq"));			
			
			if(!paramMap.get("msgTarget").equals("session")){
				paramMap.put("linkType", "L");				
				
				Map<String, Object> gerpLinkInfo = (Map<String, Object>) commonSql.select("MsgDAO.getGerpLinkInfo", paramMap);
				paramMap.put("linkSeq", gerpLinkInfo.get("linkSeq"));
				paramMap.put("urlPath", (String) commonSql.select("MsgDAO.getLinkUrlPath", paramMap));
				ret.put("linkType", "L");
			}else{
				ret.put("linkType", "SESSION");
				paramMap.put("linkType", "SESSION");
				paramMap.put("linkSeq", "SESSION");
				paramMap.put("eventType", "");
				paramMap.put("eventSubType", "");
				paramMap.put("urlPath", "");
				paramMap.put("userIP", "");
				paramMap.put("seq", "");
				paramMap.put("subSeq", "");
			}
			
			String sRet = (String) commonSql.select("MsgDAO.getToken", paramMap);
			paramMap.put("sRet", sRet);
			ret.put("ssoToken", sRet);
			
			commonSql.insert("MsgDAO.insertLinkInfo", paramMap);
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(ret);
			
		} catch(Exception e) {
			
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
			response.setResult(ret);
			
		}
			
		return response;
	}


	@Override
	public APIResponse MsgBoardList(Map<String, Object> paramMap) throws JsonParseException, JsonMappingException, IOException{
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> boardList = new ArrayList<Map<String, Object>>();
		
		JSONObject headerJson = JSONObject.fromObject(paramMap.get("header"));
		JSONObject bodyJson = JSONObject.fromObject(paramMap.get("body"));
		
		
		String boardId = "";
		String boardListCnt = "";
		
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("optionId", "msg1900");
		para.put("groupSeq", headerJson.get("groupSeq"));
		
		Map<String, Object> optionMap1 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
		para.put("optionId", "msg1910");
		Map<String, Object> optionMap2 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
		para.put("optionId", "msg1920");
		Map<String, Object> optionMap3 = (Map<String, Object>) commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValueMap", para);
		
		
		if(optionMap1 != null && optionMap1.get("val").toString().equals("1")){
			if(optionMap2 != null && !optionMap2.get("val").toString().equals("")){
				boardId = optionMap2.get("val").toString();
				boardId = boardId.substring(boardId.lastIndexOf("(")+1, boardId.lastIndexOf(")"));
			}
			if(optionMap3 != null && !optionMap3.get("val").toString().equals("")){
				boardListCnt = optionMap3.get("val").toString();				
			}else{
				boardListCnt = "10"; //기본값 10개
			}
		}
		
		
		if(!boardId.equals("")){
			try {
				Map<String, Object> companyInfoMap = new HashMap<String, Object>();
				
				companyInfoMap = (Map<String, Object>)bodyJson.get("companyInfo");
				
				Map<String, Object> empMap = (Map<String, Object>) commonSql.select("EmpManage.selectEmpInfoByLoginId", (Map<String, Object>)paramMap.get("header"));	
				
				String serverName = BizboxAProperties.getProperty("BizboxA.groupware.domin");
				
				String edmsUrl = "/edms/board/viewBoard.do";
				
				if(boardId.equals("501040000")) {
					//최근공지 
					edmsUrl = "/edms/board/viewBoardNewNotice.do";
				}else if(boardId.equals("501030000")) {
					//최근게시 
					edmsUrl = "/edms/board/viewBoardNewArt.do";
				}		
				
				String apiUrl = serverName + edmsUrl;				
				
				JSONObject apiParams = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				JSONObject companyInfo = new JSONObject();
				
				
				if(headerJson.get("groupSeq") == null || headerJson.get("groupSeq").toString().equals("")){
					Map<String, Object> groupMap = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", (Map<String, Object>)paramMap.get("header"));
					headerJson.put("groupSeq", groupMap.get("groupSeq"));
				}
				
				header.put("groupSeq", headerJson.get("groupSeq"));
				header.put("empSeq", empMap.get("empSeq"));
				header.put("tId", headerJson.get("tId"));
				header.put("pId", headerJson.get("pId"));
				
				companyInfo.put("compSeq", companyInfoMap.get("compSeq"));
				companyInfo.put("bizSeq", companyInfoMap.get("bizSeq"));
				companyInfo.put("deptSeq", companyInfoMap.get("deptSeq"));
				
				
				body.put("companyInfo", companyInfo);
				body.put("langCode", bodyJson.get("langCode"));
				body.put("loginId", headerJson.get("loginId"));
				body.put("boardNo", boardId);
				
				body.put("searchField", "");
				body.put("searchValue", "");
				body.put("currentPage", "1");
				body.put("countPerPage", Integer.parseInt(boardListCnt));
				body.put("mobileReqDate", "");
				body.put("cat_remark", "");
				body.put("type", "");
				body.put("remark_no", "");
				
				apiParams.put("header", header);
				apiParams.put("body", body);
				
				HttpJsonUtil httpJson = new HttpJsonUtil();
				String boxCntList = httpJson.execute("POST", apiUrl, apiParams);
				
				ObjectMapper om = new ObjectMapper();
				Map<String, Object> m = om.readValue(boxCntList, new TypeReference<Map<String, Object>>(){});
				
				List<Map<String, Object>> list  = new ArrayList<>();
				
				try {
					list = (List<Map<String, Object>>) ((Map<String, Object>)m.get("result")).get("artList");
				}catch(Exception e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					response.setResultCode("FAIL");
					response.setResultMessage(e.getMessage());
					response.setResult(m);
					
					return response;
				}
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		        Calendar c1 = Calendar.getInstance();
			    String strToday = sdf.format(c1.getTime());
				
				//읽지않은 게시글만 필터
				if(list.size() > 0){
					for(int i=0; i<list.size();i++){
						
						//게시글 등록일자 30일 이내인 것만 가져오기
						String regDate = list.get(i).get("write_date").toString();
						regDate = regDate.substring(0, 8);
						
					    long diffOfDate = diffOfDate(regDate, strToday);
					    
						
						if(list.get(i).get("readYn") != null && !list.get(i).get("readYn").toString().equals("Y") && diffOfDate <= 30){							
							Map<String, Object> mp = new HashMap<String, Object>();
							
							UUID uuid = UUID.randomUUID();
							String lSeq = uuid.toString().substring(0,20);
							
							
							String urlPath = "/viewPost.do?boardNo=" + list.get(i).get("boardNo") + "&artNo=" + list.get(i).get("artNo");
							
							mp.put("eventSubType", "BO001");
							mp.put("eventType", "BOARD");
							mp.put("artTitle", list.get(i).get("art_title"));
							mp.put("linkType", "A");
							mp.put("lSeq", lSeq);
							mp.put("seq", list.get(i).get("boardNo"));
							mp.put("subSeq", list.get(i).get("art_parent_no"));
							mp.put("urlPath", urlPath);
							
							boardList.add(mp);
						}
					}
				}		
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult(boardList);
				
			}catch(Exception e){
				response.setResultCode("FAIL");
				response.setResultMessage(e.getMessage());
				response.setResult(boardList);
			}
		}else{
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			response.setResult(boardList);
		}
		
		return response;
	}
	
	
	public static long diffOfDate(String begin, String end) throws Exception
    {
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
	 

	    Date beginDate = formatter.parse(begin);
	    Date endDate = formatter.parse(end);

	 

	    long diff = endDate.getTime() - beginDate.getTime();
	    long diffDays = diff / (24 * 60 * 60 * 1000);

	 

	    return diffDays;
	}

}
