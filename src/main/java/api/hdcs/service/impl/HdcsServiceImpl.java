package api.hdcs.service.impl;

import java.io.File;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import api.hdcs.service.HdcsService;
import api.hdcs.helper.ShellExecHelper;
import api.hdcs.helper.ResponseHelper;

import api.common.helper.LogHelper;
import api.common.model.APIResponse;

import com.fasterxml.jackson.databind.ObjectMapper;


@Service("HdcsService")
public class HdcsServiceImpl implements HdcsService{
	
	@Resource(name="HdcsDAO")
	private HdcsDAO hdcsDAO; 
	
	private Logger logger = LoggerFactory.getLogger(LogHelper.class);
	
	private String serverPath;
	
	@Value("#{bizboxa['BizboxA.groupware.domin']}")
	private String serverDomain;
	
	@Value("#{bizboxa['BizboxA.DocConvert.path']}")
	private String convertPath;
	
	@Value("#{bizboxa['BizboxA.OsType']}")
	private String osType;
	
	// 문서파일 변환 가능 확장자 
	private String ATTACH_CONVERT_EXT = "hwp|doc|docx|ppt|pptx|xls|xlsx";
	

	public APIResponse ConvertAttachFileHtml(Map<String, Object> paramMap) {
		
		logger.info("[ConvertAttachFileHtml] -start " + LogHelper.getRequestString(paramMap));
		
		APIResponse response = null;
		String filePath = null;
		
		Map<String, Object> paramF = new HashMap<String, Object>();
		Map<String, Object> paramP = new HashMap<String, Object>();
		Map<String, Object> companyInfo = new HashMap<String, Object>();
		
		Map<String, Object> headerJson = (Map<String, Object>) paramMap.get("header");
		Map<String, Object> bodyJson = (Map<String, Object>) paramMap.get("body");
		
		companyInfo = (Map<String, Object>) bodyJson.get("companyInfo");
		
		
		try {
			
			long time = System.currentTimeMillis();

			
			paramF.put("groupSeq", headerJson.get("groupSeq"));
			paramF.put("empSeq", headerJson.get("empSeq"));
			paramF.put("tId", headerJson.get("tId"));
			paramF.put("pId", headerJson.get("pId"));
			paramF.put("compSeq", companyInfo.get("compSeq"));
			paramF.put("fileId", bodyJson.get("fileId"));
			paramF.put("langCode", bodyJson.get("langCode"));
			
			
			Map<String, Object> fileInfo = hdcsDAO.selectAttachFileInfo(paramF);
			
			if(fileInfo == null) {
				
				logger.info("[ConvertAttachFileHtml] file not found [fileId: " + paramF.get("fileId") + "]");
				
				response = new APIResponse();
				response.setResultCode((String) headerJson.get("pId"));			
				response.setResultMessage("The file information is not valid.");
				
				return response;
				
			}
			

			serverPath = "";
			
			osType = StringUtils.isEmpty(osType) ? "linux" :osType;
			
			paramP.put("groupSeq", paramF.get("groupSeq"));
			paramP.put("pathSeq", fileInfo.get("pathSeq"));
			paramP.put("osType", osType);
			
			Map<String, Object> pathInfo = hdcsDAO.selectGroupPath(paramP);
			
			serverPath = (String) pathInfo.get("absolPath");
			serverPath = StringUtils.isEmpty(serverPath) ? "/home/Upload" :serverPath;
			
			
			String htmlFileUrl = StringUtils.EMPTY;
			String fileExtsn = String.valueOf(fileInfo.get("fileExtsn"));
			String outputDir =  serverPath + "/hdcs/" + paramF.get("groupSeq") + File.separator + paramF.get("fileId") + File.separator;
			
			filePath = serverPath + (String) fileInfo.get("fileStreCours") + File.separator + fileInfo.get("streFileName") + "." + fileInfo.get("fileExtsn");
			
			if(ATTACH_CONVERT_EXT.indexOf(fileExtsn) != -1) {
				File chk = new File(outputDir + "document.html");
				
				if (chk.exists()) {
					logger.info("[ConvertAttachFileHtml] The files that have already been converted ==> " + outputDir);
				}
				else {
					String command = String.format("%s %s %s html", convertPath, filePath, outputDir);
					logger.info("[ConvertAttachFileHtml] command request: " + command);
					
					if(File.separator.equals("/")) {
						String convertRet = ShellExecHelper.executeCommand(command);
						logger.info("[ConvertAttachFileHtml] command result: " + convertRet + " (" + convertRet.length() + ")");
					}
				}
				
				htmlFileUrl = serverDomain + File.separator + outputDir.replace("/home/", "").replace("/NAS_File/", "") + "document.html";
			}
			else {
				logger.info("[ConvertAttachFileHtml] Unsupported file format ==> " + fileExtsn);
			}
			
			logger.info("[ConvertAttachFileHtml] Conversion Success ==> " + htmlFileUrl);
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("fileId", paramF.get("fileId"));
			result.put("fileName", fileInfo.get("orignlFileName")+"."+fileInfo.get("fileExtsn"));
			result.put("fileExtsn", fileInfo.get("fileExtsn"));
			result.put("fileSize", fileInfo.get("fileSize"));
			result.put("htmlUrl", htmlFileUrl);
			
			
			ObjectMapper mapper = new ObjectMapper();
			response = ResponseHelper.createSuccess(result);
			
			time = System.currentTimeMillis() - time;
			logger.info("[ConvertAttachFileHtml] -end ET[" + time + "]" + " result - " + mapper.writeValueAsString(response));

		//} catch (FileNotFoundException e) {
		} catch (Exception e) {
			
			logger.error("[ConvertAttachFileHtml] filePath=" + filePath + " not found", e);
			
			response = new APIResponse();
			response.setResultCode((String) headerJson.get("pId"));			
			response.setResultMessage("Requested information is not valid.");
			
			return response;
			
		}
		
		
		return response;
		
	}
	
	
	public Map<String, Object> ConvertAttachFileHtml2(Map<String, Object> paramMap) {
		
		logger.info("[ConvertAttachFileHtml2] -start " + LogHelper.getRequestString(paramMap));
		
		APIResponse response = null;
		String filePath = null;
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		Map<String, Object> paramF = new HashMap<String, Object>();
		Map<String, Object> paramP = new HashMap<String, Object>();
		
		
		try {
			
			long time = System.currentTimeMillis();

			
			paramF.put("groupSeq", paramMap.get("groupSeq"));
			paramF.put("empSeq", paramMap.get("empSeq"));
			paramF.put("compSeq", paramMap.get("compSeq"));
			paramF.put("fileId", paramMap.get("fileId"));
			paramF.put("langCode", paramMap.get("langCode"));
			
//			System.out.println(paramF);
			Map<String, Object> fileInfo = hdcsDAO.selectAttachFileInfo(paramF);
//			System.out.println(fileInfo);
			
			if(fileInfo == null) {
				
				logger.info("[ConvertAttachFileHtml2] file not found [fileId: " + paramF.get("fileId") + "]");
				
				response = new APIResponse();
				response.setResultCode("DC02");			
				response.setResultMessage("The file information is not valid.");
				
				result.put("ret", "1");
				
				
				return result;
				
			}
			

			serverPath = "";
			
			osType = StringUtils.isEmpty(osType) ? "linux" :osType;
			
			paramP.put("groupSeq", paramF.get("groupSeq"));
			paramP.put("pathSeq", fileInfo.get("pathSeq"));
			paramP.put("osType", osType);
			
			Map<String, Object> pathInfo = hdcsDAO.selectGroupPath(paramP);
			
			serverPath = (String) pathInfo.get("absolPath");
			serverPath = StringUtils.isEmpty(serverPath) ? "/home/Upload" :serverPath;
			
			
			String htmlFileUrl = StringUtils.EMPTY;
			String fileExtsn = String.valueOf(fileInfo.get("fileExtsn"));
			String outputDir =  serverPath + "/hdcs/" + paramF.get("groupSeq") + File.separator + paramF.get("fileId") + File.separator;
			
			filePath = serverPath + (String) fileInfo.get("fileStreCours") + File.separator + fileInfo.get("streFileName") + "." + fileInfo.get("fileExtsn");
			
			if(ATTACH_CONVERT_EXT.indexOf(fileExtsn) != -1) {
				File chk = new File(outputDir + "document.html");
				
				if (chk.exists()) {
					logger.info("[ConvertAttachFileHtml2] The files that have already been converted ==> " + outputDir);
				}
				else {
					String command = String.format("%s %s %s html", convertPath, filePath, outputDir);
					logger.info("[ConvertAttachFileHtml2] command request: " + command);
					
					if(File.separator.equals("/")) {
						String convertRet = ShellExecHelper.executeCommand(command);
						logger.info("[ConvertAttachFileHtml2] command result: " + convertRet + " (" + convertRet.length() + ")");
					}
				}
				
				htmlFileUrl = serverDomain + File.separator + outputDir.replace("/home/", "").replace("/NAS_File/", "") + "document.html";
			}
			else {
				logger.info("[ConvertAttachFileHtml2] Unsupported file format ==> " + fileExtsn);
			}
			
			logger.info("[ConvertAttachFileHtml2] Conversion Success ==> " + htmlFileUrl);
			
			result.put("ret", "0");
			result.put("fileId", paramF.get("fileId"));
			result.put("fileName", fileInfo.get("orignlFileName")+"."+fileInfo.get("fileExtsn"));
			result.put("fileExtsn", fileInfo.get("fileExtsn"));
			result.put("fileSize", fileInfo.get("fileSize"));
			result.put("htmlUrl", htmlFileUrl);
			
			File chkDir = new File(outputDir);
			File chkFile = new File(outputDir + "document.html");
			
			if (chkDir.exists() && !chkFile.exists()) {
				result.put("htmlStatus", "convert");
			}
			else if (chkDir.exists() && chkFile.exists()) {
				result.put("htmlStatus", "complete");
			}
			else {
				result.put("htmlStatus", "fail");
			}
			
			result.put("chkDir", outputDir);
			result.put("chkFile", outputDir + "document.html");
			
			ObjectMapper mapper = new ObjectMapper();
			response = ResponseHelper.createSuccess(result);
			
			time = System.currentTimeMillis() - time;
			logger.info("[ConvertAttachFileHtml2] -end ET[" + time + "]" + " result - " + mapper.writeValueAsString(response));

		//} catch (FileNotFoundException e) {
		} catch (Exception e) {
			
			logger.error("[ConvertAttachFileHtml2] filePath=" + filePath + " not found", e);
			
			response = new APIResponse();
			response.setResultCode("DC02");			
			response.setResultMessage("Requested information is not valid.");
			
			result.put("ret", "1");
			
			
			return result;
			
		}
		
		
		return result;
		
	}
	/*
	public APIResponse ConvertAttachFileHtml2(Map<String, Object> paramMap) {
		
		logger.info("[ConvertAttachFileHtml2] -start " + LogHelper.getRequestString(paramMap));
		
		APIResponse response = null;
		String filePath = null;
		
		Map<String, Object> paramF = new HashMap<String, Object>();
		Map<String, Object> paramP = new HashMap<String, Object>();
		
		
		try {
			
			long time = System.currentTimeMillis();

			
			paramF.put("groupSeq", paramMap.get("groupSeq"));
			paramF.put("empSeq", paramMap.get("empSeq"));
			paramF.put("compSeq", paramMap.get("compSeq"));
			paramF.put("fileId", paramMap.get("fileId"));
			paramF.put("langCode", paramMap.get("langCode"));
			
			System.out.println(paramF);
			Map<String, Object> fileInfo = hdcsDAO.selectAttachFileInfo(paramF);
			System.out.println(fileInfo);
			
			if(fileInfo == null) {
				
				logger.info("[ConvertAttachFileHtml2] file not found [fileId: " + paramF.get("fileId") + "]");
				
				response = new APIResponse();
				response.setResultCode("DC02");			
				response.setResultMessage("The file information is not valid.");
				
				return response;
				
			}
			

			serverPath = "";
			
			osType = StringUtils.isEmpty(osType) ? "linux" :osType;
			
			paramP.put("groupSeq", paramF.get("groupSeq"));
			paramP.put("pathSeq", fileInfo.get("pathSeq"));
			paramP.put("osType", osType);
			
			Map<String, Object> pathInfo = hdcsDAO.selectGroupPath(paramP);
			
			serverPath = (String) pathInfo.get("absolPath");
			serverPath = StringUtils.isEmpty(serverPath) ? "/home/Upload" :serverPath;
			
			
			String htmlFileUrl = StringUtils.EMPTY;
			String fileExtsn = String.valueOf(fileInfo.get("fileExtsn"));
			String outputDir =  serverPath + "/hdcs/" + paramF.get("groupSeq") + File.separator + paramF.get("fileId") + File.separator;
			
			filePath = serverPath + (String) fileInfo.get("fileStreCours") + File.separator + fileInfo.get("streFileName") + "." + fileInfo.get("fileExtsn");
			
			if(ATTACH_CONVERT_EXT.indexOf(fileExtsn) != -1) {
				File chk = new File(outputDir + "document.html");
				
				if (chk.exists()) {
					logger.info("[ConvertAttachFileHtml2] The files that have already been converted ==> " + outputDir);
				}
				else {
					String command = String.format("%s %s %s html", convertPath, filePath, outputDir);
					logger.info("[ConvertAttachFileHtml2] command request: " + command);
					
					if(File.separator.equals("/")) {
						String convertRet = ShellExecHelper.executeCommand(command);
						logger.info("[ConvertAttachFileHtml2] command result: " + convertRet + " (" + convertRet.length() + ")");
					}
				}
				
				htmlFileUrl = serverDomain + File.separator + outputDir.replace("/home/", "") + "document.html";
			}
			else {
				logger.info("[ConvertAttachFileHtml2] Unsupported file format ==> " + fileExtsn);
			}
			
			logger.info("[ConvertAttachFileHtml2] Conversion Success ==> " + htmlFileUrl);
			
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("fileId", paramF.get("fileId"));
			result.put("fileName", fileInfo.get("orignlFileName")+"."+fileInfo.get("fileExtsn"));
			result.put("fileExtsn", fileInfo.get("fileExtsn"));
			result.put("fileSize", fileInfo.get("fileSize"));
			result.put("htmlUrl", htmlFileUrl);
			
			File chkDir = new File(outputDir);
			File chkFile = new File(outputDir + "document.html");
			
			if (chkDir.exists() && !chkFile.exists()) {
				result.put("htmlStatus", "convert");
			}
			else if (chkDir.exists() && chkFile.exists()) {
				result.put("htmlStatus", "complete");
			}
			else {
				result.put("htmlStatus", "fail");
			}
			
			result.put("chkDir", outputDir);
			result.put("chkFile", outputDir + "document.html");
			
			ObjectMapper mapper = new ObjectMapper();
			response = ResponseHelper.createSuccess(result);
			
			time = System.currentTimeMillis() - time;
			logger.info("[ConvertAttachFileHtml2] -end ET[" + time + "]" + " result - " + mapper.writeValueAsString(response));

		//} catch (FileNotFoundException e) {
		} catch (Exception e) {
			
			logger.error("[ConvertAttachFileHtml2] filePath=" + filePath + " not found", e);
			
			response = new APIResponse();
			response.setResultCode("DC02");			
			response.setResultMessage("Requested information is not valid.");
			
			return response;
			
		}
		
		
		return response;
		
	}
	*/
	
	
	public Map<String, Object> CheckConvertHtml(Map<String, Object> paramMap) {
		
		logger.info("[CheckConvertHtml] -start " + LogHelper.getRequestString(paramMap));
		
		APIResponse response = null;
		String filePath = null;
		
		
		try {
			
			paramMap.put("ret", "0");
			
			String ckDir = (String) paramMap.get("ckDir");
			String ckFile = (String) paramMap.get("ckFile");
			
			if(ckDir != null && !"".equals(ckDir)) {//경로 조작 및 자원 삽입
				ckDir = ckDir.replaceAll("", "");
			}
			if(ckFile != null && !"".equals(ckFile)) {//경로 조작 및 자원 삽입
				ckFile = ckFile.replaceAll("", "");
			}
			
			File chkDir = new File(ckDir);
			File chkFile = new File(ckFile);
			
			if (chkDir.exists() && !chkFile.exists()) {
				paramMap.put("htmlStatus", "convert");
			}
			else if (chkDir.exists() && chkFile.exists()) {
				paramMap.put("htmlStatus", "complete");
			}
			else {
				paramMap.put("htmlStatus", "fail");
			}
			
			logger.info("[CheckConvertHtml] htmlStatus=" +  paramMap.get("htmlStatus"));

		} catch (Exception e) {
			
			logger.error("[CheckConvertHtml] filePath=" + filePath + " not found", e);
			
			response = new APIResponse();
			response.setResultCode("DC02");			
			response.setResultMessage("Requested information is not valid.");
			
			paramMap.put("ret", "1");
			
			
			return paramMap;
			
		}
		
		
		return paramMap;
		
	}

}
