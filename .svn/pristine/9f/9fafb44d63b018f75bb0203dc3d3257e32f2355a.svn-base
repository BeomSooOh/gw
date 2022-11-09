package api.ext.service.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import bizbox.orgchart.service.vo.LoginVO;
import api.ext.service.ExtService;
import api.common.model.APIResponse;
import main.web.BizboxAMessage;
import api.fax.util.AES128Util;
import api.mail.service.*;


@Service("ExtService")
public class ExtServiceImpl implements ExtService{
	
	@Resource(name="ExtDAO")
	private ExtDAO extDAO; 
	
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	
	public APIResponse ExtToken(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		Map<String, Object> param = new HashMap<String, Object>();
		Map<String, Object> ret = new HashMap<String, Object>();
		
		try {
			
			Map<String, Object> headerJson = (Map<String, Object>) paramMap.get("header");
			Map<String, Object> bodyJson = (Map<String, Object>) paramMap.get("body");
			
			param.put("groupSeq", headerJson.get("groupSeq"));
			param.put("compSeq", headerJson.get("compSeq"));
			param.put("empSeq", headerJson.get("empSeq"));

			String params = "?";
			for(Map.Entry<String , Object> keyValue : bodyJson.entrySet()){
				if(keyValue.getKey() != "urlPath"){
					params += keyValue.getKey() + "=" + keyValue.getValue() + "&";
				}
				
				param.put(keyValue.getKey(), keyValue.getValue());
			}
			param.put("urlPath2", bodyJson.get("urlPath") + params);
			//System.out.println("param info! ======> "+param);
			
			String result = extDAO.getExtToken(param);
			ret.put("returnUrl", result);
			
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
	
	
	public Map<String, Object> ExtSSO(Map<String, Object> paramMap) {
		
		return extDAO.getExtSSO(paramMap);
	}
	
	
	public Map<String, Object> ExtSSOInfo(Map<String, Object> paramMap) {
		
		return extDAO.getExtInfo(paramMap);
	}
	
	
	public Map<String, Object> SWLinkInfo(Map<String, Object> paramMap) {
		
		return extDAO.getSWLinkInfo(paramMap);
	}
	
	
	public Map<String, Object> ExtErpInfo(Map<String, Object> paramMap) {
		
		return extDAO.getErpInfo(paramMap);
	}


	@Override
	public APIResponse getExPortletInfo(Map<String, Object> paramMap, HttpServletRequest request) {
		
		APIResponse response = new APIResponse();
		Map<String, Object> result = new HashMap<String, Object>();
		
		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			String token = AES128Util.AES_Decode(body.get("token")+"");
			String moduleTp = body.get("moduleTp") + "";
			String type = body.get("type") + "";
			
			String checkTime = token.substring(0, 14);
			String loginId = token.substring(14);
			String groupSeq = body.get("groupSeq") + "";
			String deptSeq = body.get("deptSeq") == null ? "" : body.get("deptSeq").toString();
			String deptCd = body.get("deptCd")  == null ? "" : body.get("deptCd").toString();
			
								
			
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("checkTime", checkTime);
			mp.put("id", loginId);
			mp.put("groupSeq",  groupSeq);
			
			if(!deptSeq.equals("")){
				mp.put("deptSeq", deptSeq);
			}else if(!deptCd.equals("")){
				mp.put("deptCd", deptCd);
			}
			
//			org.apache.log4j.Logger.getLogger( ExtServiceImpl.class ).info("para mp :" + mp);
			//토큰정보 유효성 체크.
			LoginVO loginVO = (LoginVO) commonSql.select("loginDAO.extActionLogin", mp);
			
			if(loginVO == null){
				response.setResultCode("ERR001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000007","계정 정보를 찾을 수 없습니다."));
				return response;
			}
			
			if(moduleTp.equals("mail")){
				//메일현황
				mp.put("compSeq", loginVO.getOrganId());
				String mailUrl = (String) commonSql.select("CompManage.getMailDomain", mp);
				
				ApiMailInterface apiMailInterface = new ApiMailInterface();
				
				JSONObject jsonParam = apiMailInterface.MailBoxCount(loginVO, mailUrl, false, false);
								
				if(jsonParam.get("resultMessage").toString().equals("SUCCESS")){	
					JSONObject jsonResult = (JSONObject) jsonParam.get("result");
					
					String url = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=";
					
					
					result.put("mailCnt", jsonResult.get("allunseen"));
					result.put("usedVolume", jsonResult.get("mailboxsize"));
					result.put("totalVolume", jsonResult.get("mailboxmaxsize"));
					result.put("totalVolume", jsonResult.get("mailboxmaxsize"));
					result.put("url", url);
					
					response.setResultCode("SUCCESS");
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					response.setResult(result);
				}else{
					response.setResultCode("ERR002");
					response.setResultMessage(BizboxAMessage.getMessage("TX800000008","메일 API조회 오류"));
				}
			}else if(moduleTp.equals("ea")){
				//결재 카운트or문서 조회시 필요 파라미터 정의
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("compSeq", loginVO.getCompSeq());
				para.put("groupSeq", loginVO.getGroupSeq());
				para.put("empSeq", loginVO.getUniqId());
				para.put("deptSeq", loginVO.getOrgnztId());
				
				 Date date = new Date();
				 Calendar calendar = new GregorianCalendar();
				 calendar.setTime(date);
				 int year = calendar.get(Calendar.YEAR);
				 //Add one to month {0 - 11}
				 int month = calendar.get(Calendar.MONTH) + 1;
				 int day = calendar.get(Calendar.DAY_OF_MONTH);			 
				 
				 String fromDt = Integer.toString(year-1) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
				 String toDt = Integer.toString(year) + (month < 10 ? "0" + Integer.toString(month) : Integer.toString(month)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
				 
				 String menuList = body.get("menuList") == null || body.get("menuList").toString().equals("") ? "101060000" : body.get("menuList").toString();
				 String pageSize = body.get("pageSize") == null || body.get("pageSize").toString().equals("") ? "10" : body.get("pageSize").toString();
				 
					
				// 결재함별 카운트 조회 API호출
				String jsonParam =	  "{\"header\":{";
				jsonParam +=	    "\"groupSeq\":\"" + loginVO.getGroupSeq() + "\",";
				jsonParam +=	    "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
				jsonParam +=	    "\"tId\":\"B001\",";
				jsonParam +=	    "\"pId\":\"B001\"},";
				jsonParam +=	  "\"body\":{";
				jsonParam +=	    "\"companyInfo\" :{";
				jsonParam +=	      "\"compSeq\":\"" + loginVO.getOrganId() + "\",";
				jsonParam +=	      "\"bizSeq\":\"" + loginVO.getBizSeq() + "\",";
				jsonParam +=	      "\"deptSeq\":\"" + loginVO.getOrgnztId() + "\",";
				jsonParam +=	      "\"empSeq\":\"" + loginVO.getUniqId() + "\",";
				jsonParam +=	      "\"langCode\":\"" + loginVO.getLangCode() + "\",";
				jsonParam +=	      "\"emailAddr\":\"" + loginVO.getEmail() + "\",";
				jsonParam +=	      "\"emailDomain\":\"" + loginVO.getEmailDomain() + "\"},";
				jsonParam +=	    "\"parMenuId\" : \"" + "0" + "\",";
				jsonParam +=	    "\"menuList\" : \"" + menuList + "\",";
				jsonParam +=	    "\"pageSize\" : \"" + pageSize + "\",";
				jsonParam +=	    "\"leftMenuCntYn\":\"" + "Y" + "\",";
				jsonParam +=	    "\"fromDt\":\"" + fromDt + "\",";
				jsonParam +=	    "\"toDt\":\"" + toDt + "\"}}";
				 
				//eaType 셋팅
				String eaType = loginVO.getEaType();
				if(eaType == null || eaType.equals("")){
					eaType = "eap";
				}			

				if(type.equals("cnt")){
					//결재현황(카운터)
					String apiUrl = CommonUtil.getApiCallDomain(request) + "/" + eaType + "/ea/box.do";
		
					JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
					HttpJsonUtil httpJson = new HttpJsonUtil();
					String boxCntList = httpJson.execute("POST", apiUrl, jsonObject2);
					
					ObjectMapper om = new ObjectMapper();
					Map<String, Object> m = om.readValue(boxCntList, new TypeReference<Map<String, Object>>(){});
					
					
					List<Map<String, Object>> list = (List<Map<String, Object>>) ((Map<String, Object>)m.get("result")).get("boxList");
					
					int eaCnt = 0;
					int readDocCnt = 0;
					int receiveDocCnt = 0;
					int rejectDocCnt = 0;
					
					for(Map<String, Object> cntMp : list){
						if(cntMp.get("menuId").toString().equals("102010000")){
							eaCnt += Integer.parseInt(cntMp.get("alramCnt").toString());
						}else if(cntMp.get("menuId").toString().equals("101060000")){
							readDocCnt += Integer.parseInt(cntMp.get("alramCnt").toString());
						}else if(cntMp.get("menuId").toString().equals("103020100")){
							receiveDocCnt += Integer.parseInt(cntMp.get("displayCnt").toString());
						}else if(cntMp.get("menuId").toString().equals("101040000")){
							rejectDocCnt += Integer.parseInt(cntMp.get("displayCnt").toString());
						}
					}
					
					String eaUrl = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=ea";
					String readDocUrl = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=readDoc";
					String receiveDocUrl = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=receiveDoc";
					String rejectDocUrl = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=rejectDoc";
					
					
					
					result.put("eaCnt", eaCnt);
					result.put("readDocCnt", readDocCnt);
					result.put("receiveDocCnt", receiveDocCnt);
					result.put("rejectDocCnt", rejectDocCnt);
					
					result.put("eaUrl", eaUrl);
					result.put("readDocUrl", readDocUrl);
					result.put("receiveDocUrl", receiveDocUrl);
					result.put("rejectDocUrl", rejectDocUrl);
					
					response.setResultCode("SUCCESS");
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					response.setResult(result);
					
				}else if(type.equals("list")){
					//결재현황(리스트)			
					String apiUrl = CommonUtil.getApiCallDomain(request) + "/" + eaType + "/restful/ea/portletList.do";
		
					JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
					HttpJsonUtil httpJson = new HttpJsonUtil();
					String boxDocList = httpJson.execute("POST", apiUrl, jsonObject2);
					
					ObjectMapper om = new ObjectMapper();
					Map<String, Object> m = om.readValue(boxDocList, new TypeReference<Map<String, Object>>(){});
					List<Map<String, Object>> docList = (List<Map<String, Object>>) ((Map<String, Object>)m.get("result")).get("eaList");
					
					
					for(Map<String, Object> docMp : docList){
						String eaUrl = "/gw/extSSOLogin.do?groupSeq=" + loginVO.getGroupSeq() + "&moduleTp=" +  moduleTp + "&type=view&docId=" + docMp.get("docId");
						docMp.put("url", eaUrl);
					}
					
					result.put("EaList", docList);
					
					response.setResultCode("SUCCESS");
					response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
					response.setResult(result);
					
				}
			}					
			
		}catch(Exception e){
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
		}
		
		return response;
	}

}
