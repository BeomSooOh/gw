package api.totalsearch.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import api.common.model.APIResponse;
import main.service.MainService;
import main.service.dao.MainManageDAO;
import main.web.BizboxAMessage;
import main.web.PagingReturnObj;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("TotalSearchService")
public class TotalSearchServiceImpl implements TotalSearchService{
	
	@Resource(name = "MainManageDAO")
	private MainManageDAO mainManageDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "MainService")
	MainService mainService;

	private Logger LOG = LogManager.getLogger(this.getClass());
	
	@Override
	public APIResponse searchList(Map<String, Object> paramMap) {
		LOG.info("searchList-start.");
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, String> param = new HashMap<String, String>();
		APIResponse response = new APIResponse();
		PagingReturnObj returnObj = new PagingReturnObj();
	
		String detailSearchYn = "N";
		String selectDiv = "S";
		String dateDiv = "total";
		String orderDiv = "A";
		String pageSize = "3";
		String pageIndex = "1";
		
		try {
			
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("searchType", "content");
			param.put("tsearchKeyword", (String) header.get("tsearchKeyword"));
			param.put("boardType", (String) paramMap.get("boardType"));
			param.put("deptSeq", (String) header.get("deptSeq"));
			param.put("empSeq", (String) header.get("empSeq"));
			param.put("compSeq", (String) header.get("compSeq"));
			param.put("groupSeq", (String) header.get("groupSeq"));
			param.put("positionCode", (String) header.get("positionCode"));
			param.put("classCode", (String) header.get("classCode"));
			
			detailSearchYn = (String) body.get("detailSearchYn");
			selectDiv = (String) body.get("selectDiv");
			dateDiv = (String) body.get("dateDiv");
			orderDiv = (String) body.get("orderDiv");
			pageSize = (String) body.get("pageSize");
			pageIndex = (String) body.get("pageIndex");
			
			param.put("detailSearchYn", detailSearchYn);
			param.put("selectDiv", selectDiv);
			param.put("dateDiv", dateDiv);
			param.put("tsearchSubKeyword", (String) body.get("tsearchSubKeyword"));
			param.put("orderDiv", orderDiv);
			param.put("fromDate", (String) body.get("fromDate"));
			param.put("toDate", (String) body.get("toDate"));
			param.put("pageSize", pageSize);
			param.put("pageIndex", pageIndex);
			
			params.put("boardList", returnObj.getResultgrid());
			params.put("boardCnt", returnObj.getTotalcount());
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","?????????????????????"));
			response.setResult(params);
			LOG.info("searchList-end.");
		}catch(Exception e) {
			LOG.error("searchList-error. ???????????? ?????? ??? ????????? ??????????????????. param=" + paramMap + ", msg=" + e.getMessage(), e);
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
		}
			
		return response;
	}
	
	@Override
	public APIResponse totalList(Map<String, Object> paramMap) {
		LOG.info("totalList-start.");
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, String> param = new HashMap<String, String>();
		Map<String, String> mailParam = new HashMap<String, String>();
		List<Map<String, Object>> spaceList = new ArrayList<Map<String,Object>>(); // ???????????? ??????
		APIResponse response = new APIResponse();
		PagingReturnObj returnObj = new PagingReturnObj();
		PagingReturnObj boardMap = null;
		PagingReturnObj projectMap = null;
		PagingReturnObj scheduleMap = null;
		PagingReturnObj noteMap = null;
		PagingReturnObj reportMap = null;
		PagingReturnObj eadocMap = null;
		PagingReturnObj eapprovalMap = null;
		PagingReturnObj edmsMap = null;
		PagingReturnObj fileMap = null;
		PagingReturnObj onefficeMap = null;
		
		String detailSearchYn = "N";
		String selectDiv = "S";
		String dateDiv = "total";
		String orderDiv = "A";
		String pageSize = "3";
		String pageIndex = "1";
		String fromDate = "";
		String toDate = "";
		String filePageSize = "3";
		String onefficePageSize = "3";
		String fileTabDiv = "";
		String syncTime = "0";
		String moreYn = "N";
		
		int totalCnt = 0;
		
		try {
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			LOG.debug("(String) body.get(boardType) "+(String) header.get("boardType"));
			LOG.debug("(String) body.get(detailSearchYn) "+(String) body.get("detailSearchYn"));
			
			param.put("searchType", "content");
			param.put("tsearchKeyword", (String) header.get("tsearchKeyword"));
			param.put("boardType", (String) header.get("boardType"));
			param.put("deptSeq", (String) header.get("deptSeq"));
			param.put("empSeq", (String) header.get("empSeq"));
			param.put("compSeq", (String) header.get("compSeq"));
			param.put("groupSeq", (String) header.get("groupSeq"));
			param.put("positionCode", (String) header.get("positionCode"));
			param.put("classCode", (String) header.get("classCode"));
			param.put("orgnztPath", (String) header.get("orgnztPath"));
			param.put("mailId", (String) header.get("mailId"));
			param.put("mailDomain", (String) header.get("mailDomain"));
			
			//if((String) body.get("detailSearchYn") == null ? "kr" : loginVO.getLangCode( ));
			
			if(body.get("detailSearchYn") != null){
				if("".equals((String) body.get("detailSearchYn"))){
					detailSearchYn = "N";
				}else{
					detailSearchYn = (String) body.get("detailSearchYn");
				}
			}
			if(body.get("orderDiv") != null){
				if("".equals((String) body.get("orderDiv"))){
					orderDiv = "A";
				}else{
					orderDiv = (String) body.get("orderDiv");
				}
			}
			
			if(body.get("orderDiv") != null){
				if("".equals((String) body.get("orderDiv"))){
					selectDiv = "S";
				}else{
					selectDiv = (String) body.get("selectDiv");
				}
			}
			if(body.get("dateDiv") != null){
				if("".equals((String) body.get("dateDiv"))){
					dateDiv = "total";
				}else{
					dateDiv = (String) body.get("dateDiv");
				}
			}
			if(body.get("pageSize") != null){
				if("".equals((String) body.get("pageSize"))){
					pageSize = "3";
				}else{
					pageSize = (String) body.get("pageSize");
				}
			}
			if(body.get("pageIndex") != null){
				if("".equals((String) body.get("pageIndex"))){
					pageIndex = "1";
				}else{
					pageIndex = (String) body.get("pageIndex");
				}
			}
			if(body.get("fromDate") != null){
				if("".equals((String) body.get("fromDate"))){
					fromDate = "";
				}else{
					fromDate = (String) body.get("fromDate");
				}
			}
			if(body.get("toDate") != null){
				if("".equals((String) body.get("toDate"))){
					toDate = "";
				}else{
					toDate = (String) body.get("toDate");
				}
			}
			if(body.get("filePageSize") != null){
				if("".equals((String) body.get("filePageSize"))){
					filePageSize = "3";
				}else{
					filePageSize = (String) body.get("filePageSize");
				}
			}
			
			if(body.get("fileTabDiv") != null){
				if("".equals((String) body.get("fileTabDiv"))){
					fileTabDiv = "";
				}else{
					fileTabDiv = (String) body.get("fileTabDiv");
				}
			}
			
			if(body.get("syncTime") != null){
				if("".equals((String) body.get("syncTime"))){
					syncTime = "0";
				}else{
					syncTime = (String) body.get("syncTime");
				}
			}
			
			SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			Date currentTime = new Date();
			
			if("0".equals(syncTime)){
				syncTime = mSimpleDateFormat.format(currentTime);
			}
			
			param.put("detailSearchYn", detailSearchYn);
			param.put("selectDiv", selectDiv);
			param.put("dateDiv", dateDiv);
			param.put("tsearchSubKeyword", "");
			param.put("orderDiv", orderDiv);
			param.put("fromDate", fromDate);
			param.put("toDate", toDate);
			param.put("pageSize", pageSize);
			param.put("pageIndex", pageIndex);
			param.put("filePageSize", filePageSize);
			param.put("onefficePageSize", pageSize);
			param.put("fileTabDiv", fileTabDiv);
			param.put("syncTime", syncTime);
			
			if("2".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				param.put("boardType", "2");
				totalCnt += projectMap.getTotalcount();
				params.put("projectList",projectMap.getResultgrid());
				params.put("projectCnt",projectMap.getTotalcount());
				if("2".equals((String) header.get("boardType"))){
					params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) projectMap.getTotalcount()));
				}
				
			}
			if("3".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ??????(schedule-1:????????????, schedule-2:????????????)
				param.put("boardType", "3");
				totalCnt += scheduleMap.getTotalcount();
				params.put("scheduleList",scheduleMap.getResultgrid());
			    params.put("scheduleCnt",scheduleMap.getTotalcount());
			    if("3".equals((String) header.get("boardType"))){
					params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) scheduleMap.getTotalcount()));
				}
			}
			if("4".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ??????(note:??????)
				param.put("boardType", "4");
				totalCnt += noteMap.getTotalcount();
				params.put("noteList",noteMap.getResultgrid());
			    params.put("noteCnt",noteMap.getTotalcount());
			    if("4".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) noteMap.getTotalcount()));
			    }
			}
			if("5".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ????????????(report-1:??????, report-2:??????)
				param.put("boardType", "5");
				totalCnt += reportMap.getTotalcount();
				params.put("reportList",reportMap.getResultgrid());
			    params.put("reportCnt",reportMap.getTotalcount());
			    if("5".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) reportMap.getTotalcount()));
			    }
			}
			if("6".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ????????????(??????)(eadoc-1:??????, eadoc-2:??????)
				param.put("boardType", "6");
				totalCnt += eadocMap.getTotalcount();
				params.put("eapList",eadocMap.getResultgrid());
			    params.put("eapCnt",eadocMap.getTotalcount());
			    if("6".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) eadocMap.getTotalcount()));
			    }
			}
			if("7".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ????????????(?????????)(eapproval-1:??????, eapproval-2:??????)
				param.put("boardType", "7");
				totalCnt += eapprovalMap.getTotalcount();
				params.put("eaList",eapprovalMap.getResultgrid());
			    params.put("eaCnt",eapprovalMap.getTotalcount());
			    if("7".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) eapprovalMap.getTotalcount()));
			    }
			}
			if("8".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ??????(edms-1:?????????????????????, edms-2:??????????????????, edms-3:?????????????????????, edms-4:??????)
				param.put("boardType", "8");
				totalCnt += edmsMap.getTotalcount();
				params.put("edmsList",edmsMap.getResultgrid());
			    params.put("edmsCnt",edmsMap.getTotalcount());
			    if("8".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) edmsMap.getTotalcount()));
			    }
			}
			if("9".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				//?????????(board-1:???????????????, board-2:???????????????, board-3:?????????????????????)
				param.put("boardType", "9");
				totalCnt += boardMap.getTotalcount();
				params.put("boardList",boardMap.getResultgrid());
				params.put("boardCnt",boardMap.getTotalcount());
				if("9".equals((String) header.get("boardType"))){
					params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) boardMap.getTotalcount()));
				}
			}
			if("10".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ????????????(attach_file:????????????))
				param.put("boardType", "10");
				totalCnt += fileMap.getTotalcount();
				params.put("fileList",fileMap.getResultgrid());
			    params.put("fileCnt",fileMap.getTotalcount());
			    if("10".equals((String) header.get("boardType"))){
					params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(filePageSize), (int) fileMap.getTotalcount()));
				}
			}
			if("12".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ?????????
				param.put("boardType", "12");
				onefficeMap = null;
				totalCnt += onefficeMap.getTotalcount();
				params.put("onefficeList",onefficeMap.getResultgrid());
			    params.put("onefficeCnt",onefficeMap.getTotalcount());
			    if("12".equals((String) header.get("boardType"))){
					params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) onefficeMap.getTotalcount()));
				}
			}
			if("0".equals((String) header.get("boardType")) || "1".equals((String) header.get("boardType"))){
				// ?????? ?????? api ??????
				// ?????? ????????? ??????
				
				String tTailTmp = "";
				char[] tTail = param.get("tsearchKeyword").toCharArray();
				for(int i = 0; i < tTail.length; i++){
					if((tTail[i] >= 65) && (tTail[i] <= 90)){
						tTail[i] += 32;
					}
					tTailTmp += tTail[i];
				}
				
				tTailTmp = URLEncoder.encode(tTailTmp,"UTF-8");
				
//				System.out.println("param:"+param);
				
				
				PagingReturnObj mailMap = new PagingReturnObj();
				mailParam.put("compSeq", param.get("compSeq"));
				mailParam.put("groupSeq", param.get("groupSeq"));
				String mailUrl = mainService.getTotalSearchMailDomain(mailParam);
				String sUrl = mailUrl + "getsearchMailList.do?id="+param.get("mailId")+"&domain="+param.get("mailDomain")+"&mboxSeq=0&page="+pageIndex+"&pageSize="+pageSize+"&search="+tTailTmp+"&type=all&integrate=true";
	            
				JSONObject obj = new JSONObject();	
				obj.put("id", params.get("mailId"));
				obj.put("domain", params.get("mailDomain"));
				obj.put("mboxSeq", "0");
				obj.put("page", pageIndex);
				obj.put("pageSize", pageSize);
				obj.put("search", params.get("tsearchKeyword"));
				obj.put("type", "all");
				obj.put("integrate", "true");
				
				LOG.debug("sUrl : "+sUrl);
				JSONObject mailList = getPostJSON(sUrl, obj.toString());
				
				if(mailList != null) {
//					System.out.println("mailList : "+mailList);
					int mailCode = -1;
					
					if(mailList.containsKey("code")) {
						try {
							mailCode = (int) mailList.get("code");
						}catch(Exception e) {
							CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
						}
					}
					
					if(mailCode == 0){
						
						JSONArray mailInfo = mailList.getJSONArray("Records"); // ?????? ????????????
						int mainCount = 0;
						
						if(mailList.containsKey("TotalRecordCount")) {
							mainCount = (int)mailList.get("TotalRecordCount"); // ?????? ????????? ????????????
						}
						
						Map<String, Object> items = null; // JSONArray?????? Map??????
						List<Map<String, Object>> mailInsertParam = new ArrayList<Map<String,Object>>(); // ???????????? ??????
						
						if(mailInfo != null) {
							for(int j=0; j<mailInfo.size(); j++) {
								items = new HashMap<String, Object>();
								JSONObject info = mailInfo.getJSONObject(j);
								
								JSONObject highlightInfo = null;
								
								if(info.containsKey("highlight")) {
									highlightInfo = (JSONObject)info.get("highlight");
								}
								
								items.put("jobType", "mail-1");
								
								if(highlightInfo != null && highlightInfo.containsKey("mail_body")) {
									items.put("mailBody", highlightInfo.get("mail_body").toString());
								}else {
									items.put("mailBody", "");
								}
								items.put("subject", info.get("subject") != null ? info.get("subject").toString() : "");
								items.put("boxName", info.get("boxName") != null ? info.get("boxName").toString() : "");
								items.put("boxSeq", info.get("boxSeq") != null ? info.get("boxSeq").toString() : "");
								items.put("muid", info.get("muid") != null ? info.get("muid").toString() : "");
								items.put("mailTo", info.get("mail_to") !=null ? info.get("mail_to").toString().replaceAll("&lt;", "<").replaceAll("&gt;", ">") : "");
								items.put("mailFrom", info.get("mail_from") != null ? info.get("mail_from").toString().replaceAll("&lt;", "<").replaceAll("&gt;", ">") : "");
								items.put("rfc822date", info.get("rfc822date") != null ? info.get("rfc822date").toString() : "");
								mailInsertParam.add(items);
							}
						}
						
						mailMap.setResultgrid(mailInsertParam);
						mailMap.setTotalcount(mainCount);
					}
				}
				
				if(mailMap.getResultgrid() != null){
					totalCnt += mailMap.getTotalcount();
					params.put("mailList",mailMap.getResultgrid());
				    params.put("mailCnt",mailMap.getTotalcount());
				}else{
					params.put("mailList",spaceList);
				    params.put("mailCnt",0);
				}
			    
			    if("0".equals((String) header.get("boardType"))){
			    	params.put("moreYn",getMoreYn(Integer.parseInt(pageIndex), Integer.parseInt(pageSize), (int) mailMap.getTotalcount()));
				}
			}
		    
		    if("1".equals((String) header.get("boardType"))){
		    	params.put("totalCnt",totalCnt);
		    }
		    
			
			//returnObj = bizboxElasticSearchQuery.searchElasticSearchApi(param, "1");
			//????????????
			//params.put("totalList", returnObj.getResultgrid());
			//params.put("totalCnt", returnObj.getTotalcount());
			
		    params.put("syncTime", syncTime);
		    
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","?????????????????????"));
			response.setResult(params);
			LOG.info("totalList-end.");
		}catch(Exception e) {
			LOG.error("totalList-error. ???????????? ?????? ??? ????????? ??????????????????. param=" + paramMap + ", msg=" + e.getMessage(), e);
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
		}
			
		return response;
	}
	
	@Override
	public APIResponse boardFileInfo(Map<String, Object> paramMap) {
		LOG.info("boardFileInfo-start.");
		APIResponse response = new APIResponse();
		
		try {
			
			Map<String, Object> params = (Map<String, Object>) commonSql.select("MainManageDAO.getboardFileInfo", paramMap);
//			System.out.println("params : "+params);
			//returnObj = bizboxElasticSearchQuery.searchElasticSearchApi(param, "1");
			//????????????
			//params.put("totalList", returnObj.getResultgrid());
			//params.put("totalCnt", returnObj.getTotalcount());
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","?????????????????????"));
			response.setResult(params);
			LOG.info("boardFileInfo-end.");
		}catch(Exception e) {
			LOG.error("boardFileInfo-error. ????????? ???????????? ????????? ?????? ??? ????????? ??????????????????. param=" + paramMap + ", msg=" + e.getMessage(), e);
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
		}
			
		return response;
	}
	
	public String getMoreYn(int pageIndex, int pageSize, int pageCnt){
		
		String result = "";
		
		if(pageCnt != 0){
			
//			System.out.println("pageIndex : "+pageIndex);
//			System.out.println("pageSize : "+pageSize);
//			System.out.println("pageCnt : "+pageCnt);
			LOG.debug("pageIndex : "+pageIndex);
			LOG.debug("pageSize : "+pageSize);
			LOG.debug("pageCnt : "+pageCnt);
			
			int from = ((pageIndex - 1) * pageSize) + pageSize;
		    
//		    System.out.println("from : "+from);
		    LOG.debug("from : "+from);
		    
		    int formSize = from/pageCnt;
		    
		    if(formSize == 0){
		    	result = "Y";
		    }else if(formSize >= 1){
		    	result = "N";
		    }
		}else{
			result = "N";
		}
	    return result;
	}
	
	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// System.out.println(sbBuf);

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer ?????????
				wr.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
			}
			try {
				if(brIn!=null) {//Null Pointer ?????????
				brIn.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
			}
			try {
				if(con!=null) {//Null Pointer ?????????
				con.disconnect();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
			}
		}
	}
	 
}