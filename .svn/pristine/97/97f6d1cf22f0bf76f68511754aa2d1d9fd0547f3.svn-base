package api.cloud.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

//import neos.cmm.util.file.ZipUtils;
import neos.cmm.util.file.ZipUtils2;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.ImageUtil;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;

import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import api.cloud.service.CloudService;

@Controller
public class CloudController {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Resource(name="CloudService")
	private CloudService cloudService;
	
	@SuppressWarnings({ "unchecked" })
	//크로스사이트 요청 위조 처리
	@RequestMapping(value="/backupServiceApi", method=RequestMethod.POST)
	public ModelAndView backupServiceApi(HttpServletRequest request, @RequestBody Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(params == null || params.get("groupSeq") == null || params.get("groupSeq").equals("")) {
			mv.addObject("result","fail");
			mv.addObject("resultMSg","groupSeq가 유효하지 않습니다.");
			return mv;
		}
		
		Map<String, Object> logParam = new HashMap<String, Object>( );

		logParam.put("groupSeq", params.get("groupSeq"));
		logParam.put("apiTp", "backupServiceApi : " + params.get("apiType"));
		logParam.put("reqType", params.get("backupSeq") != null ? params.get("backupSeq") : "NEW");
		logParam.put("data", params.toString());
		commonSql.insert("HrExtInterlock.setApiLog", logParam);
		
		String groupSeq = params.get("groupSeq").toString();
		
		if(params.get("apiType") == null || params.get("apiType").equals("")) {
			
			mv.addObject("result","fail");
			mv.addObject("resultMSg","apiType이 유효하지 않습니다.");
			return mv;
			
		}else if(params.get("apiType").equals("REQ") || params.get("apiType").equals("CNT")) {
			
			/*
			params.put("pathSeq", "0");
			params.put("osType", NeosConstants.SERVER_OS);	
			Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectGroupPathList", params));
			params.put("absolPath", pathMap.get("absolPath"));			
			*/
			
			Map<String, Object> backupServiceCount = new HashMap<String, Object>( );
			backupServiceCount.put("eaCount", "0");
			backupServiceCount.put("edocCount", "0");
			backupServiceCount.put("docCount", "0");
			backupServiceCount.put("boardCount", "0");
			
			boolean eaCountCheck = false;
			boolean docCountCheck = false;
			boolean edocCountCheck = false;
			boolean boardCountCheck = false;
			
			//백업서비스 요청
			String backupSeq = UUID.randomUUID().toString().toUpperCase();
			String backupPath = "/home/upload/backupService/" + groupSeq + "/" + backupSeq;
			params.put("backupSeq", backupSeq);
			params.put("backupPath", backupPath);
			
			params.put("eaProcState", "C");
			params.put("eaCount", "0");
			params.put("docProcState", "C");
			params.put("docCount", "0");
			params.put("edocProcState", "C");
			params.put("edocCount", "0");
			params.put("boardProcState", "C");
			params.put("boardCount", "0");
		 	params.put("downZipPath", "");			
			
			if(params.get("eaBackupType") != null && !params.get("eaBackupType").equals("")) {
				
				//전자결재 카운트조회
				JSONObject jsonParam = new JSONObject();
				JSONObject header = new JSONObject();
				JSONObject body = new JSONObject();
				
				body.put("groupSeq", params.get("groupSeq"));
				body.put("moduleGbn", "eap");
				body.put("backupFromDt", params.get("backupFromDt"));
				body.put("backupToDt", params.get("backupToDt"));
				body.put("backupType", params.get("eaBackupType"));
				
				jsonParam.put("header", header);
				jsonParam.put("body", body);
				
				String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/eap/api/backupServicCount.do", jsonParam);
				
				logParam.put("apiTp", "backupServicCount.do : eap");
				logParam.put("reqType", backupSeq);
				logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
				commonSql.insert("HrExtInterlock.setApiLog", logParam);				
				
				if(responseStr != null) {
					Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
					
					if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
						
						eaCountCheck = true;
						
						if(!resultMap.get("count").equals("0")) {
							params.put("eaCount", resultMap.get("count"));
							backupServiceCount.put("eaCount", resultMap.get("count"));
							params.put("eaProcState", "P");
						}
						
					}
				}
				
				if(!eaCountCheck) {
					mv.addObject("result","fail");
					mv.addObject("resultMSg","전자결재 카운트조회 오류");
					return mv;					
				}
				
			}else {
				params.put("eaBackupType","N");
			}
			
			if(params.get("docBackupType") != null && !params.get("docBackupType").equals("")) {
				
				//결재문서
				if(params.get("docBackupType").equals("1") || params.get("docBackupType").equals("2")) {

					//결재문서 카운트조회
					JSONObject body = new JSONObject();
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("moduleGbn", "edoc");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", "0");
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServicCount.do", body);
					
					logParam.put("apiTp", "backupServicCount.do : edoc");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);							
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							
							edocCountCheck = true;
							
							if(!resultMap.get("count").equals("0")) {
								params.put("edocCount", resultMap.get("count"));
								backupServiceCount.put("edocCount", resultMap.get("count"));
								params.put("edocProcState", "P");
							}
							
						}
					}
					
					if(!edocCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","문서(결재) 카운트조회 오류");
						return mv;					
					}					
					 
					params.put("edocBackupType", "Y");
					
				}else {
					params.put("edocBackupType", "N");
				}				
				
				//일반문서
				if(params.get("docBackupType").equals("0") || params.get("docBackupType").equals("2")) {
					
					//일반문서 카운트조회
					JSONObject body = new JSONObject();
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("moduleGbn", "doc");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", "0");
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServicCount.do", body);
					
					logParam.put("apiTp", "backupServicCount.do : doc");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							
							docCountCheck = true;
							
							if(!resultMap.get("count").equals("0")) {
								params.put("docCount", resultMap.get("count"));
								backupServiceCount.put("docCount", resultMap.get("count"));
								params.put("docProcState", "P");
							}
							
						}
					}
					
					if(!docCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","문서 카운트조회 오류");
						return mv;					
					}					
					 
					params.put("docBackupType", "Y");
					
				}else {
					params.put("docBackupType", "N");
				}
				
			}else {
				params.put("docBackupType", "N");
				params.put("edocBackupType", "N");
			}	
			
			if(params.get("boardBackupType") != null && !params.get("boardBackupType").equals("")) {
				
				//게시판 카운트조회
				JSONObject body = new JSONObject();
				
				body.put("groupSeq", params.get("groupSeq"));
				body.put("moduleGbn", "board");
				body.put("backupFromDt", params.get("backupFromDt"));
				body.put("backupToDt", params.get("backupToDt"));
				body.put("backupType", "0");
				
				String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServicCount.do", body);
				
				logParam.put("apiTp", "backupServicCount.do : board");
				logParam.put("reqType", backupSeq);
				logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
				commonSql.insert("HrExtInterlock.setApiLog", logParam);					
				
				if(responseStr != null) {
					Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
					
					if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
						
						boardCountCheck = true;
						
						if(!resultMap.get("count").equals("0")) {
							params.put("boardCount", resultMap.get("count"));
							backupServiceCount.put("boardCount", resultMap.get("count"));
							params.put("boardProcState", "P");
						}
						
					}
				}
				
				if(!boardCountCheck) {
					mv.addObject("result","fail");
					mv.addObject("resultMSg","게시판 카운트조회 오류");
					return mv;					
				}					
				 
				params.put("boardBackupType", "Y");
				
			}else {
				params.put("boardBackupType","N");
			}
			
			if(params.get("apiType").equals("CNT")) {
				//백업서비스정보 조회
				mv.addObject("backupServiceCount", backupServiceCount);
				
			}else {
				//백업서비스 기본데이터 Insert
				commonSql.insert("GroupManage.insertBackupServiceInfo", params);
				
				if(params.get("eaProcState").equals("P")) {
					
					//전자결재 백업요청
					JSONObject jsonParam = new JSONObject();
					JSONObject header = new JSONObject();
					JSONObject body = new JSONObject();
					
					String modulePath = backupPath + "/backupData/eap";
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("backupSeq", backupSeq);
					body.put("backupPath", modulePath);
					
					body.put("moduleGbn", "eap");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", params.get("eaBackupType"));
					
					//폴더생성
					File folder = new File(modulePath);
					
					if(!folder.exists()) {
						folder.mkdirs();
					}				
					
					jsonParam.put("header", header);
					jsonParam.put("body", body);
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/eap/api/backupServiceProc.do", jsonParam);
					
					logParam.put("apiTp", "backupServiceProc.do : eap");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					eaCountCheck = false;
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							eaCountCheck = true;
						}
					}
					
					if(!eaCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","전자결재 백업요청 오류");
						return mv;					
					}				
					
				}
				
				if(params.get("docProcState").equals("P")) {
					//문서 백업요청
					JSONObject body = new JSONObject();
					String modulePath = backupPath + "/backupData/doc";
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("backupSeq", backupSeq);
					body.put("backupPath", modulePath);
					
					body.put("moduleGbn", "doc");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", "0");

					//폴더생성
					File folder = new File(modulePath);
					
					if(!folder.exists()) {
						folder.mkdirs();
					}				
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServiceProc.do", body);
					
					logParam.put("apiTp", "backupServiceProc.do : doc");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					docCountCheck = false;
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							docCountCheck = true;
						}
					}
					
					if(!docCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","문서 백업요청 오류");
						return mv;					
					}					
				}
				
				if(params.get("edocProcState").equals("P")) {
					//문서(결재) 백업요청
					JSONObject body = new JSONObject();
					String modulePath = backupPath + "/backupData/edoc";
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("backupSeq", backupSeq);
					body.put("backupPath", modulePath);
					
					body.put("moduleGbn", "edoc");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", "0");

					//폴더생성
					File folder = new File(modulePath);
					
					if(!folder.exists()) {
						folder.mkdirs();
					}					
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServiceProc.do", body);
					
					logParam.put("apiTp", "backupServiceProc.do : edoc");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					edocCountCheck = false;
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							edocCountCheck = true;
						}
					}
					
					if(!edocCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","문서(결재) 백업요청 오류");
						return mv;					
					}					
				}
				
				if(params.get("boardProcState").equals("P")) {
					//게시판 백업요청
					JSONObject body = new JSONObject();
					String modulePath = backupPath + "/backupData/board";
					
					body.put("groupSeq", params.get("groupSeq"));
					body.put("backupSeq", backupSeq);
					body.put("backupPath", modulePath);
					
					body.put("moduleGbn", "board");
					body.put("backupFromDt", params.get("backupFromDt"));
					body.put("backupToDt", params.get("backupToDt"));
					body.put("backupType", "0");

					//폴더생성
					File folder = new File(modulePath);
					
					if(!folder.exists()) {
						folder.mkdirs();
					}					
					
					String responseStr = HttpJsonUtil.execute("POST", CommonUtil.getApiCallDomain(request) + "/edms/api/backupServiceProc.do", body);
					
					logParam.put("apiTp", "backupServiceProc.do : board");
					logParam.put("reqType", backupSeq);
					logParam.put("data", body.toString() + ">>>>>>>>>>>>>>>" + responseStr);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					boardCountCheck = false;
					
					if(responseStr != null) {
						Map<String, Object> resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
						
						if(resultMap != null && resultMap.get("resultCode") != null && resultMap.get("resultCode").equals("SUCCESS")) {
							boardCountCheck = true;
						}
					}
					
					if(!boardCountCheck) {
						mv.addObject("result","fail");
						mv.addObject("resultMSg","게시판 백업요청 오류");
						return mv;					
					}				
				}				
				
				//백업서비스정보 조회
				mv.addObject("backupServiceInfo", (Map<String, Object>) commonSql.select("GroupManage.selectBackupServiceInfo", params));
			}			

		}else if(params.get("apiType").equals("INFO")) {
			//백업서비스정보 조회
			Map<String, Object> backupServiceInfo = (Map<String, Object>) commonSql.select("GroupManage.selectBackupServiceInfo", params);
			
			if(backupServiceInfo != null && backupServiceInfo.get("downZipPath") != null && !backupServiceInfo.get("downZipPath").equals("")) {
				
				String downUrl = request.getScheme()+"://"+request.getServerName()+(request.getServerPort() == 80 ? "" : ":" + request.getServerPort())+"/gw/api/backupServiceDownload?backupSeq="+backupServiceInfo.get("backupSeq")+"&groupSeq=" + backupServiceInfo.get("groupSeq");
				backupServiceInfo.put("downUrl", downUrl);
				
			}

			mv.addObject("backupServiceInfo", backupServiceInfo);
			
			
		}else if(params.get("apiType").equals("DOWNHISTORY")) {
			//다운로드 이력
			mv.addObject("backupServiceDownList", commonSql.list("GroupManage.selectBackupServiceDownList", params));
		}else if(params.get("apiType").equals("MODIFY")) {
			//백업서비스 정보 수정
			commonSql.update("GroupManage.updateBackupServiceInfo", params);
		}else if(params.get("apiType").equals("CALLBACK")) {
			
			//백업서비스정보 조회
			Map<String, Object> backupServiceInfo = (Map<String, Object>) commonSql.select("GroupManage.selectBackupServiceInfo", params);
			
			if(backupServiceInfo == null) {
				mv.addObject("result","fail");
				mv.addObject("resultMSg","백업요청정보가 존재하지 않습니다.");
				return mv;				
			}
			
			boolean alreadyCheck = false;
			
			Map<String, Object> updateParam = new HashMap<String, Object>( );
			updateParam.put("groupSeq", params.get("groupSeq"));
			updateParam.put("backupSeq", params.get("backupSeq"));
			
			String procState = params.get("procState").toString();
			
			//백업서비스 완료 콜백
			if(params.get("moduleGbn").equals("eap")) {
				updateParam.put("eaProcState", procState);
				
				if(backupServiceInfo.get("eaProcState").equals("C")) {
					alreadyCheck = true;
				}
				
				backupServiceInfo.put("eaProcState", "C");
				
			}else if(params.get("moduleGbn").equals("doc")) {
				updateParam.put("docProcState", procState);
				
				if(backupServiceInfo.get("docProcState").equals("C")) {
					alreadyCheck = true;
				}
				
				backupServiceInfo.put("docProcState", "C");
				
			}else if(params.get("moduleGbn").equals("edoc")) {
				updateParam.put("edocProcState", procState);
				
				if(backupServiceInfo.get("edocProcState").equals("C")) {
					alreadyCheck = true;
				}
				
				backupServiceInfo.put("edocProcState", "C");
				
			}else if(params.get("moduleGbn").equals("board")) {
				updateParam.put("boardProcState", procState);
				
				if(backupServiceInfo.get("boardProcState").equals("C")) {
					alreadyCheck = true;
				}
				
				backupServiceInfo.put("boardProcState", "C");
				
			}
			
			if(alreadyCheck) {
				mv.addObject("result","fail");
				mv.addObject("resultMSg","이미 요청된 콜백입니다.");
				return mv;					
			}
			
			//백업서비스 상태값 Update
			commonSql.update("GroupManage.updateBackupServiceInfo", updateParam);
			
			if(procState.equals("C")) {
				
				if(backupServiceInfo.get("eaProcState").equals("C") && backupServiceInfo.get("docProcState").equals("C")
						&& backupServiceInfo.get("edocProcState").equals("C") && backupServiceInfo.get("boardProcState").equals("C")) {
					
					//압축 시작
					String backupPath = backupServiceInfo.get("backupPath").toString();
					String zipPath = backupPath + "/" + params.get("backupSeq").toString() + ".zip";
					
					logParam.put("apiTp", "backupServiceAPI : createZipFile(Start)");
					logParam.put("data", backupPath + "/backupData" + ">>>>>>>>>>>>>>>" + zipPath);
					commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					
					try {
						ZipUtils2.createZipFile(backupPath + "/backupData", zipPath);
						logParam.put("apiTp", "backupServiceAPI : createZipFile(Complite)");
						commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					}catch(Exception ex) {
						logParam.put("apiTp", "backupServiceAPI : createZipFile(Error)");
						logParam.put("data", ex.getMessage());	
						commonSql.insert("HrExtInterlock.setApiLog", logParam);						
					}
					
					updateParam = new HashMap<String, Object>( );
					updateParam.put("groupSeq", params.get("groupSeq"));
					updateParam.put("backupSeq", params.get("backupSeq"));
					updateParam.put("downZipPath", zipPath);
					
					logParam.put("apiTp", "backupServiceAPI : updateBackupServiceInfo");
					logParam.put("data", updateParam.toString());
					commonSql.insert("HrExtInterlock.setApiLog", logParam);
					
					//백업서비스 상태값 Update
					commonSql.update("GroupManage.updateBackupServiceInfo", updateParam);
					
					logParam.put("apiTp", "backupServiceAPI : createZipFile(Finished)");
					commonSql.insert("HrExtInterlock.setApiLog", logParam);					
					
				}				
			}
			
		}else if(params.get("apiType").equals("ZIP")) {
			
			ZipUtils2.createZipFile(params.get("targetPath").toString(), params.get("zipPath").toString());
			
		}else {
			mv.addObject("result","fail");
			mv.addObject("resultMSg","apiType이 유효하지 않습니다.");
			return mv;
		}
		
		mv.addObject("result","success");
		return mv;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/backupServiceApiTest")
	public ModelAndView backupServiceApiTest(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		
		JSONObject jsonParam = new JSONObject();
		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		body.putAll(params);
		
		jsonParam.put("header", header);
		jsonParam.put("body", body);
		
		String responseStr = HttpJsonUtil.execute("POST", params.get("apiUrl").toString(), jsonParam);
		
		if(responseStr != null) {
			resultMap = JSONObject.fromObject(JSONSerializer.toJSON(responseStr));
		}	
		
		mv.addObject("result",resultMap);
		
		return mv;		
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/contentsToHtml")
	public ModelAndView contentsToHtml(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.contentsToHtmlUse").equals("Y")) {
			mv.addObject("resultMsg","권한없음");
			return mv;	
		}
		
		String resultMsg = "";
		String resultTp = params.get("resultTp") == null ? "" : params.get("resultTp").toString();
		
		List<Map<String, Object>> list = commonSql.list(params.get("queryId").toString() , params);
		
		if(resultTp.equals("list")) {
			
			mv.addObject("result",list);
			
		}else if(resultTp.equals("html")) {
			
			String savePath = params.get("savePath").toString();
			String gwDomain = params.get("gwDomain").toString();
			String[] replaceImgDomain = null;
			
			if(params.get("replaceImgDomain") != null && !params.get("replaceImgDomain").equals("")) {
				replaceImgDomain = params.get("replaceImgDomain").toString().split("▦", -1);
			}
			
			Pattern pattern = Pattern.compile("<img[^>]*src=[\\\"']?([^>\\\"']+)[\\\"']?[^>]*>");
			List<String> srcList = new ArrayList<>();
			List<Integer> startIndexList = new ArrayList<>();
			List<Integer> endIndexList = new ArrayList<>();
			
			for(Map<String, Object> info : list){
				
				params.putAll(info);
				
				Map<String, Object> infoData = (Map<String, Object>) commonSql.select(params.get("queryId").toString() , params);
				
				if(infoData != null) {
					
					srcList = new ArrayList<>();
					startIndexList = new ArrayList<>();
					endIndexList = new ArrayList<>();					
					
					String filename = infoData.get("fileName").toString();
					String contents = infoData.get("contents").toString().replace("<<AW_IMG_PATH>>", gwDomain).replace("src=\"/upload/", "src=\"" + gwDomain + "/upload/");
			        Matcher matcher = pattern.matcher(contents);

			        while(matcher.find()) {
			        	srcList.add(matcher.group(1));
			        	startIndexList.add(matcher.start(1));
			        	endIndexList.add(matcher.end(1));
			        }
			        
					for( int j = startIndexList.size()-1; j > -1; j--){
						
						String imgBase64 = "data:image/png;base64,";
						String imgUrl = srcList.get(j);
						
						if(!imgUrl.contains("data:image/")) {
							
							if(replaceImgDomain != null) {
								for( int k = 0; k < replaceImgDomain.length; k++){
									String[] replaceImgDomainInfo = replaceImgDomain[k].split("\\|");
									imgUrl = imgUrl.replace(replaceImgDomainInfo[0], replaceImgDomainInfo[1]);
								}								
							}							
							
							try {
								byte[] imgContent = ImageUtil.getImageContent(new URL(imgUrl));
								imgBase64 += new String(Base64.encodeBase64(imgContent));
							}catch(Exception ex) {
								imgBase64 = imgUrl;
								resultMsg += "|" + filename + " > " + imgUrl;
							}
							contents = contents.substring(0, startIndexList.get(j)) + imgBase64 + contents.substring(endIndexList.get(j));						
						}
					}
					
					FileWriter fileWriter = new FileWriter(savePath + filename);
					fileWriter.write(contents);
					fileWriter.close();
				}
			}
			mv.addObject("resultMsg",resultMsg);			
		}
		return mv;		
	}	
	
	@RequestMapping("/backupServiceDownload")
	public void backupServiceDownload(@RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();

		if (loginVO != null) {
			
			if(paramMap.get("groupSeq") != null && !paramMap.get("groupSeq").equals(loginVO.getGroupSeq())){
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");

				PrintWriter printwriter = response.getWriter();
				printwriter.println("<script>");
				printwriter.println("alert('그룹코드가 유효하지 않습니다. 관리자에게 문의바랍니다.');self.close();");
				printwriter.println("</script>");	
				printwriter.flush();
				printwriter.close();
				return;
			}
			
			if(paramMap.get("downTp") == null || paramMap.get("downTp").equals("")) {
				paramMap.put("downTp", "URL");
			}		
			
			paramMap.put("empSeq", loginVO.getUniqId());
			
		}else {
			paramMap.put("downTp", "URL");
			paramMap.put("empSeq", "");
		}
		
		@SuppressWarnings("unchecked")
		Map<String, Object> backupServiceInfo = (Map<String, Object>) commonSql.select("GroupManage.selectBackupServiceInfo", paramMap);
		
		if(backupServiceInfo == null || backupServiceInfo.get("downZipPath").equals("")) {
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");

			PrintWriter printwriter = response.getWriter();
			printwriter.println("<script>");
			printwriter.println("alert('비정상적인 접근입니다. 관리자에게 문의바랍니다.');self.close();");
			printwriter.println("</script>");			
			printwriter.flush();
			printwriter.close();
			return;
		}
		
		//다운로드 요청
		String downSeq = UUID.randomUUID().toString().toUpperCase();
		
		paramMap.put("downSeq", downSeq);
		paramMap.put("resultTp", backupServiceInfo.get("downYn"));
		
		paramMap.put("clientIp", CommonUtil.getClientIp(request));
		
		commonSql.insert("GroupManage.insertBackupServiceDownHis", paramMap);
		
		if(backupServiceInfo.get("downYn").equals("N")) {
			
			paramMap.put("resultTp", "D");
			commonSql.update("GroupManage.updateBackupServiceDownHis", paramMap);				
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");

			PrintWriter printwriter = response.getWriter();
			printwriter.println("<script>");
			printwriter.println("alert('다운로드 기간이 만료되었습니다. 관리자에게 문의바랍니다.');self.close();");
			printwriter.println("</script>");
			printwriter.flush();
			printwriter.close();
			return;
			
		}
		
		String zipFileName = backupServiceInfo.get("downZipPath").toString();
		
		Date dt = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");			
		String today = sdf.format(dt); 
		String orignlFileName = "그룹웨어 백업파일_" + today + ".zip";
		
		File file = null;
		FileInputStream fis = null;
		
		try {
			file = new File(zipFileName);
			
			if(!file.exists()) {
				
				paramMap.put("resultTp", "F");
				commonSql.update("GroupManage.updateBackupServiceDownHis", paramMap);				
				
				response.setCharacterEncoding("UTF-8");
				response.setContentType("text/html; charset=UTF-8");

				PrintWriter printwriter = response.getWriter();
				printwriter.println("<script>");
				printwriter.println("alert('백업파일이 존재하지 않습니다. 관리자에게 문의바랍니다.');self.close();");
				printwriter.println("</script>");
				printwriter.flush();
				printwriter.close();			
				return;
			}
			
		    orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8"); 
		    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해
		    orignlFileName = orignlFileName.replaceAll("%28", "("); //
		    orignlFileName = orignlFileName.replaceAll("%29", ")"); // 
		    orignlFileName = orignlFileName.replaceAll("%27", "'"); //
		    orignlFileName = orignlFileName.replaceAll("%21", "!"); //
		    orignlFileName = orignlFileName.replaceAll("%7E", "~"); //			
		    
			fis = new FileInputStream(file);
			
		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
			response.setContentType( CommonUtil.getContentType(file) );
			response.setContentLength((int) file.length());
			response.setHeader( "Content-Transfer-Coding", "binary" );

			byte buffer[] = new byte[4096];
			int bytesRead = 0, byteBuffered = 0;
			
			while((bytesRead = fis.read(buffer)) > -1) {
				
				response.getOutputStream().write(buffer, 0, bytesRead);
				byteBuffered += bytesRead;
				
				//flush after 1MB
				if(byteBuffered > 1024*1024) {
					byteBuffered = 0;
					response.getOutputStream().flush();
				}
			}

			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			paramMap.put("resultTp", "S");
			commonSql.update("GroupManage.updateBackupServiceDownHis", paramMap);
			
		} catch(Exception e) {
			paramMap.put("resultTp", "F");
			commonSql.update("GroupManage.updateBackupServiceDownHis", paramMap);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");

			PrintWriter printwriter = response.getWriter();
			printwriter.println("<script>");
			printwriter.println("alert('일시적인 오류가 발생했습니다. 관리자에게 문의바랍니다.');self.close();");
			printwriter.println("</script>");			
			printwriter.flush();
			printwriter.close();			
			
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
		}
	}	
	
	@RequestMapping(value="/cloud/setGwVolumeFromGCMS", method=RequestMethod.POST)
	@ResponseBody
	public APIResponse setGwVolumeFromGCMS(@RequestBody Map<String, Object> paramMap) {
		
		APIResponse response = null;
		
		// 리턴 결과 
		response = cloudService.setGwVolumeFromGCMS(paramMap);
		
		return response;
	}
	
	static int GcmsNoticePopDate = 0;
	static List<Map<String, Object>> GcmsNoticePopList = null;
	static List<Map<String, Object>> GcmsNoticeList = null;
	static List<Map<String, Object>> GcmsNoticeAllList = null;
	

	@RequestMapping("/refreshGcmsNotice")
	public ModelAndView refreshGcmsNotice(@RequestParam Map<String, Object> params) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("result","success");
		
		GcmsNoticePopDate = 0;
		GcmsNoticePopList = null;
		GcmsNoticeList = null;
		GcmsNoticeAllList = null;
		cloudService.setBizboxCloudNoticeInfo("");
		
		if(params.get("sideYn") == null){
			
			String sideServerIp = BizboxAProperties.getProperty("BizboxA.cloud.sideServerIp");
			
			if(!sideServerIp.equals("99")) {
				
				String[] sideServerIpArray = sideServerIp.split("\\|");
				
				for( int j = 0; j < sideServerIpArray.length; j++){
					executeApi(sideServerIpArray[j] + "/gw/api/refreshGcmsNotice?sideYn=Y");	
				}				
			}
		}
		
		return mv;
	}
	
	@SuppressWarnings("static-access")
	private void executeApi(String apiUrl) {
		try{
			JSONObject param = new JSONObject();
			HttpJsonUtil httpJson = new HttpJsonUtil();
			httpJson.execute("POST", apiUrl, param);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}		
	}
	
	
	@SuppressWarnings({ "static-access", "unchecked" })
	@RequestMapping("/getGcmsNoticeList.do")
	public ModelAndView getGcmsNoticeList(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		String reqType = params.get("reqType").toString();
		
		if(GcmsNoticeAllList == null){

			String apiUrl = "http://gcms.bizboxa.com:60801/gcms_api/Cloud/GetCloudNotice";
			JSONObject totalShareParam = new JSONObject();
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();		
			
			body.put("assembly", BizboxAProperties.getProperty("BizboxA.cloud.gcms.assembly"));
			body.put("count", "100");

			totalShareParam.put("header", header);
			totalShareParam.put("body", body);
			
			HttpJsonUtil httpJson = new HttpJsonUtil();
			String noticeList = "";
			
			try{
				
				noticeList = httpJson.execute("POST", apiUrl, totalShareParam);
				noticeList = noticeList.replaceAll("\\\\r\\\\n", "</br>");
				
				ObjectMapper om = new ObjectMapper();
				
				Map<String, Object> result = om.readValue(noticeList, new TypeReference<Map<String, Object>>(){});
				
				if(result.get("resultCode").equals("0")){
					
					Map<String, Object> resultData = (Map<String, Object>) result.get("result");
					
					GcmsNoticeAllList = (List<Map<String, Object>>) resultData.get("NoticeList");
					
					if(GcmsNoticeAllList == null){
						GcmsNoticeAllList = new ArrayList<Map<String, Object>>();
					}
					
					String bizboxCloudNoticeInfo = "";
					GcmsNoticePopList = new ArrayList<Map<String, Object>>();
					GcmsNoticeList = new ArrayList<Map<String, Object>>();
					
					for(Map<String, Object> info : GcmsNoticeAllList){
						
						if(GcmsNoticeList.size() < 5){
							GcmsNoticeList.add(info);
						}
						
						if(info.get("pop_yn") != null && info.get("pop_yn").equals("Y") && !info.get("pop_from_dt").equals("") && !info.get("pop_to_dt").equals("")){
							bizboxCloudNoticeInfo += "|" + info.get("seq").toString();
							GcmsNoticePopList.add(info);
						}

					}
					
					cloudService.setBizboxCloudNoticeInfo(bizboxCloudNoticeInfo);
					
				}
				
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}			
		}
		
		if(GcmsNoticeAllList != null){

			if(reqType.equals("all")){
				mv.addObject("GcmsNoticeList", GcmsNoticeAllList);
			}else if(reqType.equals("main")){
				mv.addObject("GcmsNoticeList", GcmsNoticeList);
			}
			
			if("main|pop".contains(reqType)){

				Date dt = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");			
				int today = Integer.parseInt(sdf.format(dt)); 
				
				if(today != GcmsNoticePopDate){
					
					String bizboxCloudNoticeInfo = "";
					
					List<Map<String, Object>> gcmsNoticePopListNew = new ArrayList<Map<String, Object>>();
					
					for(Map<String, Object> info : GcmsNoticePopList){
						
						int popFromDt = Integer.parseInt(info.get("pop_from_dt").toString());
						int popToDt = Integer.parseInt(info.get("pop_to_dt").toString());
						
						if(popFromDt <= today && today <= popToDt){
							gcmsNoticePopListNew.add(info);
							bizboxCloudNoticeInfo += "|" + info.get("seq").toString();
						}
					}
					
					GcmsNoticePopList = gcmsNoticePopListNew;
					GcmsNoticePopDate = today;
					cloudService.setBizboxCloudNoticeInfo(bizboxCloudNoticeInfo);
				}
				
				mv.addObject("GcmsNoticePopList", GcmsNoticePopList);
			}
		}


		return mv;
	}	
	
	@RequestMapping("/GcmsNoticeListPop.do")
	public ModelAndView GcmsNoticeListPop(@RequestParam Map<String, Object> params, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mv = new ModelAndView();
		
		mv.addAllObjects(params);
		
		mv.setViewName("/neos/include/cloudNoticeListPop");

		return mv;
	}	
}
