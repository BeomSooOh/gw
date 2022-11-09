package restful.com.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.FileUtils;
import neos.cmm.util.JsonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;
import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import restful.com.helper.AsyncCallHelper;
import restful.com.service.AttachFileService;
import restful.mobile.service.ResultAttachFile;
import restful.mobile.vo.AttachFileVO;
import restful.mobile.vo.RestfulRequest;
import restful.mobile.vo.ResultVO;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import api.msg.helper.ConvertHtmlHelper;
import api.drm.service.DrmService;
import org.apache.log4j.Logger;

@Controller
public class AttachFileController {
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name="WebAttachFileService")
	WebAttachFileService webAttachFileService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
    
	@Resource(name = "DrmService")
	private DrmService drmService;	    
    
	@Value("#{bizboxa['BizboxA.DocConvert.path']}")
	private String convertPath;
	
	@Value("#{bizboxa['BizboxA.OsType']}")
	private String osType;
	
	@Autowired
	private AsyncCallHelper asyncCallHelper;
	
	private static final String  ATTACH_IMG_EXT = "jpeg|bmp|gif|jpg|png";
	
	private Logger logger = Logger.getLogger(AttachFileController.class);
    
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/file/attachFileUploadProc.do")
    public ModelAndView attachFileUploadProc(MultipartHttpServletRequest multiRequest, @RequestParam Map<String,Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		String datatype = (String)paramMap.get("dataType");
		
		Logger.getLogger( AttachFileController.class ).debug( "AttachFileController.attachFileUploadProc paramMap : " + paramMap );
		
		if (datatype == null || datatype.equals("json")) {
			mv.setViewName("jsonView");
		} else {
			mv.setViewName(datatype);
		}
		
		/** return 메세지 설정 */
		Map<String,Object> messageMap = new HashMap<String,Object>();
		messageMap.put("mKey", "resultMessage");
		messageMap.put("cKey", "resultCode");
		messageMap.put("codeHead", "systemx.attach.");
		
		/** 그룹시퀀스 체크 */
		String groupSeq = paramMap.get("groupSeq")+"";
		if (EgovStringUtil.isEmpty(groupSeq)) {
			messageMap.put("code", "AF0010");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** 사용자 체크 */
		String empSeq = paramMap.get("empSeq")+"";
		if (EgovStringUtil.isEmpty(empSeq)) {
			messageMap.put("code", "AF0020");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** 파일 체크  */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (files.isEmpty()) {
			messageMap.put("code", "AF0030");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** 파일 ROOT 경로 체크 */
		String pathSeq = paramMap.get("pathSeq")+"";
		if (EgovStringUtil.isEmpty(pathSeq)) {
			messageMap.put("code", "AF0040");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		/** 그룹 경로설정 조회 */
		// ONEFFICE	는 예외처리
		paramMap.put("osType", NeosConstants.SERVER_OS);
		List<Map<String,Object>> pathList = groupManageService.selectGroupPathList(paramMap);
		if (pathList == null || pathList.size() < 1) {
			messageMap.put("code", "AF0050");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		
		if(!pathSeq.equals("1600")) {		
			/** 파일 절대경로 조회 */
			String rootPath = null;
			for(Map<String,Object> path : pathList) {
				String ps = path.get("pathSeq")+"";
				if (ps.equals(pathSeq)) {
					rootPath = path.get("absolPath")+"";
				}
			}
			if (EgovStringUtil.isEmpty(rootPath)) {
				messageMap.put("code", "AF0060");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				return mv;
			}
			
			/** 상대경로 */
			String relativePath = paramMap.get("relativePath")+"";
			/** 상대경로가 없다면 기본경로 + 현재날짜 */
			if(EgovStringUtil.isEmpty(relativePath)) {
				
				relativePath = File.separator + "base"+ File.separator + EgovDateUtil.today("yyyy")+File.separator+EgovDateUtil.today("MM")+File.separator+EgovDateUtil.today("dd");
				
				/* moduleGbnCode 추가 */
				if(paramMap.get("moduleGbnCode") != null && !paramMap.get("moduleGbnCode").equals("")) {
					relativePath = File.separator + paramMap.get("moduleGbnCode").toString().toLowerCase() + relativePath;
				}
				
			} else {
				/* 경로 구분자 추가 */
				if(!relativePath.startsWith("/")) {
					relativePath = File.separator + relativePath;
				}
			}	
			
			// 프로필 이미지
			if(pathSeq.equals("910")) {
				relativePath = File.separator + paramMap.get("groupSeq");
			}
	
			String fileId = String.valueOf(paramMap.get("fileId"));
			String reqFileSn = String.valueOf(paramMap.get("fileSn"));
			
			List<Map<String,Object>> fileList = null;
			int fileSn = 0; 																	// 파일 순번
	
			/** File Id 생성(성공시 return) */
			if (EgovStringUtil.isEmpty(fileId)) {
				paramMap.put("value", "atchfileid");
				fileId = sequenceService.getSequence(paramMap);
			} 
			/** 파일 추가 */
			else {
				paramMap.put("fileSn", null);		// 파일 리스트 불러올때 fileSn는 필요 없음.
				fileList = attachFileService.getAttachFileList(paramMap);
				if (fileList != null && fileList.size() > 0) {
					if (EgovStringUtil.isEmpty(reqFileSn)) {
						fileSn = attachFileService.selectAttachFileMaxSn(paramMap)+1;
					} else {
						fileSn = CommonUtil.getIntNvl(reqFileSn);								// 파일 순번이 파라미터로 넘어왔다는 것은 파일 변경
					}
				}
			}
			
			/** save file */
			Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
			
			List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
			List<Map<String,String>> thumFileList  = new ArrayList<Map<String,String>>();		// 파일 썸네일 리스트
			Map<String,Object> newFileInfo = null;
			String path = rootPath + File.separator + relativePath;								// 저장 경로
			long size = 0L;																		// 파일 사이즈
			MultipartFile file = null;
			String thumImgSizeType = "thum";			//썸네일 이미지 타
			
			while (itr.hasNext()) {
				Entry<String, MultipartFile> entry = itr.next();
				file = entry.getValue();
				String orginFileName = file.getOriginalFilename();								// 원본 파일명
				
				logger.debug("## orginFileName : " + orginFileName);
	
				if (!EgovStringUtil.isEmpty(orginFileName)) {
	
					/* 확장자 */
					int index = orginFileName.lastIndexOf(".");
					if (index == -1) {
						messageMap.put("code", "AF0070");
						MessageUtil.setApiMessage(mv, multiRequest, messageMap);
						return mv;
					} 
	
					String fileExt = orginFileName.substring(index + 1);
					orginFileName = orginFileName.substring(0, index);
	
					String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
					
					
					if (ATTACH_IMG_EXT.indexOf(fileExt.toLowerCase()) != -1 && pathSeq.equals("910")) {					// 프로필 사진이면 png 저장
						fileExt = "jpg"; 
					}
	
					if(pathSeq.equals("910")) {														// 프로필 사진이면 empSeq 파일명으로 저장// direct 접근하기 위해
						newName = empSeq;
						
						//프로필 사진이면 사용자 프로필 파일 ID업데이트
						Map<String, Object> profileMp = new HashMap<String, Object>();
						profileMp.put("empSeq", empSeq);
						profileMp.put("groupSeq", groupSeq);
						profileMp.put("fileId", fileId);
						
						commonSql.update("AttachFileUpload.setEmpProfileFileId", profileMp);
					}
					
					String saveFilePath = path+File.separator+newName+"."+fileExt;				
					size = EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
					
					//DRM 체크
					drmService.drmConvert("U", groupSeq, pathSeq, path, newName, fileExt);
					
					if (size > 0) {
						newFileInfo = new HashMap<String,Object>();
						newFileInfo.put("fileId", fileId);
						newFileInfo.put("fileSn", fileSn);
						newFileInfo.put("pathSeq", pathSeq);
						newFileInfo.put("fileStreCours", relativePath);
						newFileInfo.put("streFileName", newName);
						newFileInfo.put("orignlFileName", orginFileName);
						newFileInfo.put("fileExtsn", fileExt);
						newFileInfo.put("fileSize", size);
						newFileInfo.put("createSeq", empSeq);
						newFileInfo.put("groupSeq", paramMap.get("groupSeq"));
						saveFileList.add(newFileInfo);
						fileSn++;
						//--------------
						/*
						 * 이미지일때 썸네일 이미지 저장 (파일명_small.확장자)
						 * 20181002 soyoung, 이미지파일일경우 데이타만 가지고 있고, 파일생성 완료 후 처리
						 */
						if (ATTACH_IMG_EXT.indexOf(fileExt.toLowerCase()) != -1) {
							Map<String,String> thumFileInfo = new HashMap<String, String>();
							thumFileInfo.put("filePathThum", path+File.separator+newName+"_"+thumImgSizeType+"."+fileExt);
							thumFileInfo.put("filePath", saveFilePath);
							
							thumFileList.add(thumFileInfo);
						}
						//--------------
					}
				} 
			}
			
			/** 파일 저장 리스트 확인 */
			if (saveFileList.size() < 1) {
				messageMap.put("code", "AF0090");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				return mv;
			}
			
			/** DB Insert */
			String resultFileId = attachFileService.insertAttachFile(saveFileList);
			/** insert 결과 체크 */
			if(EgovStringUtil.isEmpty(resultFileId)) {
				messageMap.put("code", "AF0090");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				return mv;
			} else {
				logger.debug("## attachFileUploadProc - resultFileId[ " +resultFileId+"]");
				messageMap.put("code", "0");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				
				//파일저장이 정상처리되었으면 썸네일 생성한다.
				for(Map<String,String> thumFileInfo: thumFileList) {
					int thumImgMaxWidth = 420;

					try {
						logger.debug("## attachFileUploadProc - filePathThum[ " +thumFileInfo.get("filePathThum")+"]");
						asyncCallHelper.setASyncImageSet(
								new File(thumFileInfo.get("filePathThum")), 
								new File(thumFileInfo.get("filePath")),
								thumImgMaxWidth);
					}catch(Exception e){
						logger.error("## ImageUtil.saveResizeImage Error : 썸네일이미지 생성 오류");
					}
				}
				logger.debug("## attachFileUploadProc - fileId[ " +fileId+"]");
			}
			
			AttachFileVO vo = new AttachFileVO();
			
			vo.setFileId(fileId);
			vo.setFileSn(fileSn-1);
			
			mv.addObject("result", vo);
			
			return mv;
		}
		
		else {
			String uploadPath = "";
			String absolPath = "";
			String fileName = "";
			String type = (String)paramMap.get("type");
			boolean isReport = paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report");
			
			JSONObject json = new JSONObject();
			
			//문서정보 조회
			Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentInfo", paramMap);
			String ownerId = "";
			
			if(docInfo == null){
				docInfo = new HashMap<String, Object>();
			}else{		
				ownerId = docInfo.get("owner_id") == null ? "" : docInfo.get("owner_id").toString();
			}

			paramMap.put("pathSeq", "0");
			paramMap.put("osType", NeosConstants.SERVER_OS);
			
			Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
			if(pathMap != null){
				absolPath = pathMap.get("absolPath").toString();	
			}		
			
			if(type.equals("form_upload_image") || type.equals("dnd_upload_image")){

				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();				
				MultipartFile uploadFile = null;
				
				String fileNameStr = "";
				String fileUrl = "";
				
				while (itr.hasNext()) {
					Entry<String, MultipartFile> entry = itr.next();
					uploadFile = entry.getValue();
				
					fileName = uploadFile.getOriginalFilename();
					String saveFileName  = java.util.UUID.randomUUID().toString() + "." + fileName.substring(fileName.lastIndexOf( "." ) + 1);
					
					String docNo = paramMap.get("doc_no") == null ? "" : (String)paramMap.get("doc_no");
					
					if(!docNo.equals("")){
						saveFileName = 	docNo + "-" + saveFileName;
					}
					
					String savaPath = "";
					
					if(!isReport){
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?seq=" + saveFileName;
						savaPath = absolPath + "/onefficeFile/" + ownerId + "/" + (!docNo.equals("") ? (docNo + "/") : "") + saveFileName;
					}
					else{
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=" + saveFileName;
						savaPath = absolPath + "/onefficeFile/report/" + docNo + "/" + saveFileName;
					}
					EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(savaPath));
					
					fileNameStr += "," + fileName;
					fileUrl += "," + uploadPath;
				}
				
				if(fileNameStr.length() > 0) {
					fileNameStr = fileNameStr.substring(1);
				}
					
				if(fileUrl.length() > 0) {
					fileUrl = fileUrl.substring(1);
				}
				
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileNameStr.split(","));
				json.put("url", fileUrl.split(","));
				
			}else if(type.equals("form_upload_video") || type.equals("dnd_upload_video")){
				
				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
				MultipartFile uploadFile = null;
				while (itr.hasNext()) {
					
					Entry<String, MultipartFile> entry = itr.next();
					uploadFile = entry.getValue();
					
					fileName = uploadFile.getOriginalFilename();
					String saveFileName  = java.util.UUID.randomUUID().toString() + "." + fileName.substring(fileName.lastIndexOf( "." ) + 1);
					
					String docNo = paramMap.get("doc_no") == null ? "" : (String)paramMap.get("doc_no");
					
					if(!docNo.equals("")){
						saveFileName = 	docNo + "-" + saveFileName;
					}
					
					String savaPath = "";
					
					if(!isReport){
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?seq=" + saveFileName;
						savaPath = absolPath + "/onefficeFile/" + ownerId + "/" + (!docNo.equals("") ? (docNo + "/") : "") + saveFileName;
					}
					else{
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=" + saveFileName;
						savaPath = absolPath + "/onefficeFile/report/" + docNo + "/" + saveFileName;
					}
					EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(savaPath));
					
					json.put("result", "success");
					json.put("type", type);
					json.put("filename", fileName);
					json.put("url", uploadPath);
				}
			}else if(type.equals("form_upload_extfile")){

				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
				MultipartFile uploadFile = null;
				
				while (itr.hasNext()) {
					
					Entry<String, MultipartFile> entry = itr.next();
					uploadFile = entry.getValue();
					
					fileName = uploadFile.getOriginalFilename();
					String saveFileName  = java.util.UUID.randomUUID().toString() + "." + fileName.substring(fileName.lastIndexOf( "." ) + 1);
					
					String docNo = paramMap.get("doc_no") == null ? "" : (String)paramMap.get("doc_no");
					
					if(!docNo.equals("")){
						saveFileName = 	docNo + "-" + saveFileName;
					}
					
					String relativePath = File.separator + "onefficefile_ext" + (!docNo.equals("") ? ("/" + docNo + "/") : "");

					String path = absolPath + relativePath + File.separator + saveFileName;
					
					/** File Id 생성(성공시 return) */
					paramMap.put("value", "atchfileid");
					String fileId = sequenceService.getSequence(paramMap);
					
					
					
					long size = EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(path));
					
					List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
					HashMap<String,Object> newFileInfo = new HashMap<String,Object>();
					newFileInfo.put("groupSeq", groupSeq);
					newFileInfo.put("fileId", fileId);
					newFileInfo.put("fileSn", "0");
					newFileInfo.put("pathSeq", "0");
					newFileInfo.put("fileStreCours", relativePath);
					newFileInfo.put("streFileName", saveFileName.substring(0,saveFileName.lastIndexOf( "." )));
					newFileInfo.put("orignlFileName", fileName.substring(0,fileName.lastIndexOf( "." )));
					newFileInfo.put("fileExtsn", fileName.substring(fileName.lastIndexOf( "." ) + 1));
					newFileInfo.put("fileSize", size);
					newFileInfo.put("createSeq", paramMap.get("empSeq"));
					newFileInfo.put("inpName", uploadFile.getName());
					saveFileList.add(newFileInfo);
					
					/** DB Insert */
					//List<Map<String,Object>> resultFileIdList = webAttachFileService.insertAttachFile(saveFileList);
					webAttachFileService.insertAttachFile(saveFileList);
					
					uploadPath = "/gw/cmm/file/fileDownloadProc.do?fileId=" + fileId;
					
					json.put("result", "success");
					json.put("type", type);
					json.put("filename", fileName);
					json.put("url", uploadPath);
				}
			}
			else if(type.equals("paste_image")){
				
				String dzeUpimageData = (String)paramMap.get("dze_upimage_data");
				
				if(dzeUpimageData != null && !dzeUpimageData.equals("")){
					Base64 decoder = new Base64(); 
					dzeUpimageData = dzeUpimageData.substring(dzeUpimageData.indexOf(",")+1);
					byte[] dArray = decoder.decode(dzeUpimageData.getBytes());
					InputStream inputStream = new ByteArrayInputStream(dArray);
					fileName = java.util.UUID.randomUUID().toString() + ".png";
					
					String docNo = paramMap.get("doc_no") == null ? "" : (String)paramMap.get("doc_no");
					
					if(!docNo.equals("")){
						fileName = 	docNo + "-" + fileName;
					}
					
					String savaPath = "";
					
					if(!isReport){
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?seq=" + fileName;
						savaPath = absolPath + "/onefficeFile/" + ownerId + "/" + (!docNo.equals("") ? (docNo + "/") : "") + fileName;
					}
					else{
						uploadPath = "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=" + fileName;
						savaPath = absolPath + "/onefficeFile/report/" + docNo + "/" + fileName;
					}
					
					EgovFileUploadUtil.saveFile(inputStream, new File(savaPath));
					
					json.put("result", "success");
					json.put("type", type);
					json.put("filename", fileName);
					json.put("url", uploadPath);
				}
			}
			else if(type.equals("uploadThumbImg")){

				Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
				MultipartFile uploadFile = null;
				
				while (itr.hasNext()) {
					
					Entry<String, MultipartFile> entry = itr.next();
					uploadFile = entry.getValue();
				
					fileName = uploadFile.getOriginalFilename();
					String docNo = paramMap.get("doc_no") == null ? "" : (String)paramMap.get("doc_no");
					
					//원피스 썸네일 png로 고정.
					String saveFileName  = "uploadThumbImg.png";
					String savaPath = "";
					
					
					if(!docNo.equals("")){
						
						saveFileName = 	docNo + "-" + saveFileName;
						
						if(!isReport){
							//썸네일명 테이블 저장(oneffice_document)
							paramMap.put("thumbnail", saveFileName);
							paramMap.put("groupSeq", groupSeq);
							
							commonSql.update("OnefficeDao.updateDocumentThumbnail", paramMap);
							
							
							uploadPath = "/gw/onefficeApi/getAttachmentData.do?seq=" + saveFileName;
							savaPath = absolPath + "/onefficeFile/" + ownerId + "/" + (!docNo.equals("") ? (docNo + "/") : "") + saveFileName;
						}
						else{
							uploadPath = "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=" + saveFileName;
							savaPath = absolPath + "/onefficeFile/report/" + docNo + "/" + saveFileName;
						}
					}
					
					EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(savaPath));
					
					json.put("result", "success");
					json.put("type", type);
					json.put("filename", fileName);
					json.put("url", uploadPath);
				}
			}
			
			messageMap.put("code", "0");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			
			mv.addObject("result", json);
			return mv;
		}
	}
	
	@RequestMapping("/cmm/file/attachFileDownloadProcBak.do")
    public void attachFileDownloadProcBak(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {

		String fileId = paramMap.get("fileId").toString();
		
		if (fileId == null || fileId.equals("")) {
			return;
		}
		
		/** 첨부파일 상세정보 조회 */
	 	Map<String, Object> fileMap = attachFileService.getAttachFileDetail(paramMap);
	 	
	 	if (fileMap == null) {
	 		return;
	 	}
	 	String pathSeq = fileMap.get("pathSeq")+"";
	 	
	 	String imgSizeType = String.valueOf(paramMap.get("imgSizeType"));
	 	

	 	/** 절대경로 조회 */
	 	paramMap.put("pathSeq", pathSeq);
	 	paramMap.put("osType", NeosConstants.SERVER_OS);
	 	Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);
	 	
	 	
	 	String path = groupPahtInfo.get("absolPath") + File.separator + fileMap.get("fileStreCours");
	 	String fileName =  fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
	 	String orignlFileName = fileMap.get("orignlFileName") + "." + fileMap.get("fileExtsn");
	 			
		File file = null;
		FileInputStream fis = null;

		String type = "";
		
		String fileExtsn = String.valueOf(fileMap.get("fileExtsn"));
		
		if (fileExtsn != null && !"".equals(fileExtsn)) {
			
			
			if ("jpg".equals(fileExtsn.toLowerCase())) {
				type = "image/jpeg";
			} else {
				type = "image/" + fileExtsn.toLowerCase();
			}
			type = "image/" + fileExtsn.toLowerCase();
			
			
		} else {
			//LOGGER.debug("Image fileType is null.");
		}
		
//		String imgExt = "jpeg|bmp|gif|jpg|png";
		if (!EgovStringUtil.isEmpty(imgSizeType) && ATTACH_IMG_EXT.indexOf(fileExtsn.toLowerCase()) != -1) {
			
			String fileNamethum = fileMap.get("streFileName") + "_"+imgSizeType+"." + fileMap.get("fileExtsn");
			
			/** 파일이 없을경우 원본 이미지 리턴하도록 */
			File f = new File(path + File.separator + fileNamethum);
			if (f.isFile()) {
				fileName = fileNamethum;
			}
			
		}
		
		try {
			
		    file = new File(path + File.separator + fileName);
		    fis = new FileInputStream(file);

		    orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8"); 
		    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해

		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
		    
		    /** 이미지 */
		    if (ATTACH_IMG_EXT.indexOf(fileExtsn) > -1) {
		    	response.setHeader("Content-Type", type);
		    } 
		    /** 일반 */
		    else {
				response.setContentType( CommonUtil.getContentType(file) );
				response.setHeader( "Content-Transfer-Coding", "binary" );
		    }

            response.setContentLength((int) file.length());
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
		} catch(Exception e) {
			logger.error("Exception : " + e.getMessage());
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
	

	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/file/attachFileDownloadProc.do")
    public void attachFileDownloadProc(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {

		//원피스(하이브리드앱) pathSeq 분기처리
		if(paramMap.get("pathSeq") != null && paramMap.get("pathSeq").toString().equals("1600")) {
			ModelAndView mv = new ModelAndView();
			mv.setViewName("jsonView");
			
			String fileName = paramMap.get("seq") == null ? "" : paramMap.get("seq").toString();
			
			String docNo = fileName.split("-")[0];
			paramMap.put("doc_no", docNo);
			paramMap.put("noAuth", "Y");
			Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);
			
			if(result != null || (paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report"))){
				
				String filePath = "";
				String absolPath = "";
				
				paramMap.put("pathSeq", "0");
				paramMap.put("osType", NeosConstants.SERVER_OS);
				Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
				
				if(pathMap != null){
					absolPath = pathMap.get("absolPath").toString();	
				}				
				
				if(paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report")){
					filePath = absolPath + "/onefficeFile/report/" + (!docNo.equals("") ? (docNo + "/") : "") + fileName;
				}else{				
					filePath = absolPath + "/onefficeFile/" + result.get("owner_id").toString() + "/" + (!docNo.equals("") ? (docNo + "/") : "") + fileName;
				}
				
				FileInputStream fis = null;
				
				try {
					String orignlFileName = "";
					String fileExtsn = fileName.substring(fileName.lastIndexOf(".") + 1);
					
					String imgExt = "jpeg|bmp|gif|jpg|png";
					String applicationExt = "pdf";
					
					File file = new File(filePath);
					
					fis = new FileInputStream(file);
				    
				    orignlFileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1"); 
				    
				    String type = "";
				    
					if (fileExtsn != null && !fileExtsn.equals("")) {
						//이미지 컨텐츠타입 설정
						if(imgExt.indexOf(fileExtsn.toLowerCase()) != -1){
							
							if(fileExtsn.toLowerCase().equals("jpg")){
								type = "image/jpeg";
							}else{
								type = "image/" + fileExtsn.toLowerCase();
							}
						}
						//어플리케인션 컨텐츠타입 설정
						else if(applicationExt.indexOf(fileExtsn.toLowerCase()) != -1){
							type = "application/" + fileExtsn.toLowerCase();
						}				
					}
				    
					if(!type.equals("")){
						response.setHeader("Content-Type", type);
					}else{
						response.setContentType(CommonUtil.getContentType(file));
						response.setHeader("Content-Transfer-Encoding", "binary;");
					}

				    if(!type.equals("") && paramMap.get("inlineView") != null && paramMap.get("inlineView").toString().equals("Y")){
						//Inline View
				    	response.setHeader("Content-Disposition","inline;filename=\"" + orignlFileName+"\"");
				    }else{
				    	//Attach Download
				    	response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
				    }

				    response.setContentLength((int) file.length());
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
					
				} catch (FileNotFoundException e) {
					logger.error(e.getMessage());
				} catch (IOException e) {
					logger.error(e.getMessage());
				} finally {
					if (fis != null) {
						try {
							fis.close();
						} catch (Exception ignore) {
							logger.error(ignore.getMessage());
						}
					}
				}
			}else {
				response.setStatus(403);
			}
		}else {
			String fileId = paramMap.get("fileId").toString();
			
			if (fileId == null || fileId.equals("")) {
				return;
			}
			
			paramMap.put("osType", NeosConstants.SERVER_OS);
			//groupSeq 체크
			if(paramMap.get("groupSeq") == null || paramMap.get("groupSeq").toString().equals("")){
				LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
				
				if(loginVO != null && loginVO.getGroupSeq() != null) {
					paramMap.put("groupSeq", loginVO.getGroupSeq());
				}else{
					Map<String, Object> mp = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", paramMap);
					paramMap.put("groupSeq", mp.get("groupSeq"));
				}
			}
			
			//pathSeq 보정
			if(paramMap.get("fileId") != null) {
				
				paramMap.put("limitCount","1");
				
				Map<String, Object> fileInfo = (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetail", paramMap);
				
				if(fileInfo != null) {
					paramMap.put("pathSeq", fileInfo.get("pathSeq"));
				}
			}
		 	
			Map<String, Object> fileMp = null;
			if(paramMap.get("pathSeq") != null){
				if(paramMap.get("pathSeq").equals("500") || paramMap.get("pathSeq").equals("501") || paramMap.get("pathSeq").equals("502")){
			 		if(paramMap.get("pathSeq").equals("501")){
			 			fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getFileDetailInfoBoardReply", paramMap);
			 		}else{
			 			//게시판 타입 체크 (이미지/동영상 게시판일경우 썸네일 이미지경로를 따로 가져와야하기 때문.		 			
			 			Map<String, Object> mp = (Map<String, Object>) commonSql.select("AttachFileUpload.CheckBoardType", paramMap); 
			 			boolean isThume = false;
			 			
			 			if(mp != null){
			 				String catType = mp.get("catType") + "";
			 				if(catType.equals("I") || catType.equals("V")){
			 					//이미지게시판 게물중 썸네일이미지 등록여부 확인.
			 					//썸네일이 등록되어있을경우  orgImage, imgPath 두 컬럼에 값이 존재해야함.
			 					if(mp.get("orgImage") != null && !mp.get("orgImage").equals("")){
			 						if(mp.get("imgPath") != null && !mp.get("imgPath").equals("")){		 							
			 							isThume = true;
			 						}
			 					}
			 				}
			 			}
			 			fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getFileDetailInfoBoard", paramMap);
			 			if(fileMp == null && isThume) {
			 				fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getFileDetailInfoBoardThume", paramMap);
			 			}
			 		}
				}
				else if(paramMap.get("pathSeq").equals("600")){
					//이전문서 여부 체크
					if(paramMap.get("oldDocYn") == null || paramMap.get("oldDocYn").toString().equals("") || paramMap.get("oldDocYn").toString().equals("N")) {
						fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getFileDetailInfoDoc", paramMap);
					}else {
						fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getFileDetailInfoDocOld", paramMap);
					}
				}
				else {
			 		fileMp = (Map<String, Object>) commonSql.select("AttachFileUpload.selectAttachFileDetailApi", paramMap);
		
			 		if (fileMp == null) {
				 		return;
				 	} else {
				 		paramMap.put("pathSeq", fileMp.get("pathSeq"));
				 	}
				}
			}
			
			String pathSeq = paramMap.get("pathSeq") + "";
			
		 	if (fileMp == null) {
		 		return;
		 	}
		 	
		 	String path = fileMp.get("filePath") + "";
		 	
			//문서변환 요청 체크
			if (paramMap.get("htmlView") != null){		
				try{
				 	ConvertHtmlHelper convert = new ConvertHtmlHelper();
				 	Map<String, String> docMap = new HashMap<String, String>();
				 	
				 	String docConvertPath = BizboxAProperties.getProperty("BizboxA.DocConvert.path");				 	
				 	String saveLocalPath = fileMp.get("filePath").toString() + fileMp.get("fileId").toString();
				 	
				 	if(fileMp.get("fileSn") != null && !fileMp.get("fileSn").equals("")){
				 		saveLocalPath = saveLocalPath + fileMp.get("fileSn").toString();
				 	}

					/** 절대경로 조회 */
					paramMap.put("pathSeq", "0");
					paramMap.put("osType", NeosConstants.SERVER_OS);
					Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);

					saveLocalPath = groupPahtInfo.get("absolPath") + "/convertDocTemp/" + pathSeq + "_" + CommonUtil.sha256Enc(saveLocalPath, "") + "/";					
				 	
					//이미 변환처리된 건인지 체크
					File chk = new File(saveLocalPath + "document.html");

					if (!chk.exists()) {
						//DRM 체크
						String drmPath = drmService.drmConvert("V", paramMap.get("groupSeq").toString(), pathSeq, path.replace("//", "/"), fileMp.get("streFileName").toString(), fileMp.get("fileExtsn").toString());
						convert.convertHtml(docConvertPath, drmPath, saveLocalPath, "document.html", (drmPath.contains("drmDecTemp") && !path.contains("drmDecTemp")));
					}
				 	
					docMap = convert.checkConvertHtml(saveLocalPath);				 	
				 	
				 	String htmlFileUrl = docMap.get("msg").replace("/home/", "").replace("/NAS_File/", "");
				 			
				 	response.getOutputStream().println(htmlFileUrl);
					
					return;
			
				}catch(Exception e){
					logger.info("[ConvertAttachFileHtml Error] : " + e.getMessage());
					response.getOutputStream().println("");
					return;
				}
			}
			//문서변환 끝	 	
		 	
		 	String imgSizeType = String.valueOf(paramMap.get("imgSizeType"));
	
		 	/** 절대경로 조회 */
		 	paramMap.put("pathSeq", pathSeq);
		 	
		 	
		 	//String fileName =  fileMp.get("streFileName") + "." + fileMp.get("fileExtsn");
		 	String orignlFileName = fileMp.get("orignlFileName") + "." + fileMp.get("fileExtsn");
		 			
			File file = null;
			FileInputStream fis = null;
	
			String type = "";
			
			String fileExtsn = String.valueOf(fileMp.get("fileExtsn"));
			
			if (fileExtsn != null && !"".equals(fileExtsn)) {
				
				if ("jpg".equals(fileExtsn.toLowerCase())) {
					type = "image/jpeg";
				} else {
					type = "image/" + fileExtsn.toLowerCase();
				}
				type = "image/" + fileExtsn.toLowerCase();
				
				
			} else {
				//LOGGER.debug("Image fileType is null.");
			}
			
	//		String imgExt = "jpeg|bmp|gif|jpg|png";
			if (!EgovStringUtil.isEmpty(imgSizeType) && ATTACH_IMG_EXT.indexOf(fileExtsn.toLowerCase()) != -1) {
				
				String fileNamethum = fileMp.get("streFileName") + "_"+imgSizeType+"." + fileMp.get("fileExtsn");
				
				/** 파일이 없을경우 원본 이미지 리턴하도록 */
				File f = new File(path + File.separator + fileNamethum);
				if (f.isFile()) {
					//fileName = fileNamethum;
				}
				
			}
			
			try {
				//DRM 체크
				String drmPath = drmService.drmConvert("D", paramMap.get("groupSeq").toString(), pathSeq, path, fileMp.get("streFileName").toString(), fileMp.get("fileExtsn").toString());
				file = new File(drmPath);
			    fis = new FileInputStream(file);
			    
			    orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8"); 
			    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해
	
			    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
			    
			    /** 이미지 */
			    if (ATTACH_IMG_EXT.indexOf(fileExtsn) > -1) {
			    	response.setHeader("Content-Type", type);
			    } 
			    /** 일반 */
			    else {
					response.setContentType( CommonUtil.getContentType(file) );
					response.setHeader( "Content-Transfer-Coding", "binary" );
			    }
	
			    response.setContentLength((int) file.length());
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
				
			} catch(Exception e) {
				logger.error("Exception : " + e.getMessage());
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
    }
	
	
	@RequestMapping("/cmm/file/attachFileCompressProc.do")
    public void attachFileCompressProc(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {

		/** 첨부파일 상세정보 조회 */
	 	List<Map<String, Object>> fileList = attachFileService.getAttachFileList(paramMap);
	 	
	 	if (fileList == null || fileList.size() < 1) {
	 		return;
	 	}
	 	
	 	Map<String,Object> fileMap = fileList.get(0);
	 	
	 	if (fileMap == null) {
	 		return;
	 	}
	 	
	 	String pathSeq = fileMap.get("pathSeq")+"";
	 	
	 	/** 절대경로 조회 */
	 	paramMap.put("pathSeq", pathSeq);
	 	paramMap.put("osType", NeosConstants.SERVER_OS);
	 	Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);
	 	
	 	String rootPath = groupPahtInfo.get("absolPath")+"";
	 	
		File file = null;
		FileInputStream fis = null;

		String target = paramMap.get("target")+"";
		
		if (EgovStringUtil.isEmpty(target)) {
			return;
		}
		
		String fileId = paramMap.get("fileId")+"";
		String tempTarget = rootPath + File.separator + "temp" + File.separator + fileId + ".zip";
		
		if (!FileUtils.cmprsFile(fileList, rootPath, tempTarget)) {
			return;
		}
		
		try {
			
		    file = new File(tempTarget);
		    fis = new FileInputStream(file);

		    String orignlFileName = URLEncoder.encode(target, "UTF-8"); 
		    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해

		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
		    response.setContentType( CommonUtil.getContentType(file) );
		    response.setHeader( "Content-Transfer-Coding", "binary" );

		    response.setContentLength((int) file.length());
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
			
		} finally {
			
			file.delete();
			
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					logger.error(ignore.getMessage()); 
				}
			}
		}
    }
	
	
	@RequestMapping(value="/AttachFileSave", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultAttachFile AttachFileSave(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
		String resultHead = "systemx.attach.";
		
		ResultAttachFile result  = new ResultAttachFile();
		
		Map<String, Object> reBody =  request.getBody();
		
		String empSeq = (String) (request.getHeader()).getEmpSeq();
		String groupSeq = (String) (request.getHeader()).getGroupSeq();
		
		String fromPathSeq = (String) reBody.get("fromPathSeq");
		String toPathSeq = (String) reBody.get("toPathSeq");
		String tId = (String)  (request.getHeader()).gettId();
		String moduleGbnCode = (String) reBody.get("moduleGbnCode"); 
		result.settId(tId);		
		
		String[] fields = new String[]{"downloadUrl", "originalFileName", "fileExtsn", "originalFileName"};
		List<Map<String,Object>> fileList = JsonUtil.getJsonObjectToArray(reBody, fields);

		/** 타시스템 그룹 파일 경로 시퀀스 체크 */
		if (EgovStringUtil.isEmpty(fromPathSeq)) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF1010");
			return result;		
		}
		/** 저장시스템 그룹 파일 경로 시퀀스 체크 */
		if (EgovStringUtil.isEmpty(toPathSeq)) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF1020");
			return result;		
		}
		
		/** 파일 목록 체크 */
		if (fileList == null || fileList.size() < 1) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF1030");
			return result;		
		}
		
		
		Map<String,Object> params = new HashMap<String,Object>();
		/** 그룹 경로설정 조회 */
		params.put("osType", NeosConstants.SERVER_OS);
		params.put("groupSeq", groupSeq);
		params.put("pathSeq", toPathSeq);
		List<Map<String,Object>> pathList = groupManageService.selectGroupPathList(params);
		if (pathList == null || pathList.size() < 1) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF1040");
			return result;		
		}
		
		String rootPath = null;
		for(Map<String,Object> path : pathList) {
			String ps = path.get("pathSeq")+"";
			if (ps.equals(toPathSeq)) {
				rootPath = path.get("absolPath")+"";
			}
		}
		
		params.put("path",rootPath);
		params.put("pathSeq",toPathSeq);
		params.put("empSeq", empSeq);
		
		String relativePath = File.separator + "base"+ File.separator + EgovDateUtil.today("yyyy")+File.separator+EgovDateUtil.today("MM")+File.separator+EgovDateUtil.today("dd");
		
		if(moduleGbnCode != null && !moduleGbnCode.equals("")) {
			relativePath = File.separator + moduleGbnCode.toLowerCase() + relativePath;
		}		
		
		params.put("relativePath",relativePath);
		
		String fileId = attachFileService.fileSave(fileList, params);
		
		AttachFileVO r = new AttachFileVO();
		
		r.setFileId(fileId);
		
		result.setResult(r);
		
		MessageUtil.setApiMessage(result, servletRequest, resultHead, "0");
		
		return result;		
	} 
	
	
	@RequestMapping(value="/AttachFileDel", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResultVO AttachFileDel(
								HttpServletRequest servletRequest, 
								HttpServletResponse servletResponse,
								@RequestBody RestfulRequest request
							) throws Exception {
		
		String resultHead = "systemx.attach.";
		ResultVO result  = new ResultVO();
		
		Map<String, Object> reBody =  request.getBody();
		
		String empSeq = (String) (request.getHeader()).getEmpSeq();
		String tId = (String)  (request.getHeader()).gettId();
		result.settId(tId);		
		
		/** 사용자 체크 */
		if (EgovStringUtil.isEmpty(empSeq)) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF0020");
			return result;		
		}
		
		String fileId = (String) reBody.get("fileId");
		if (EgovStringUtil.isEmpty(fileId)) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF2010");
			return result;		
		}
		
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("empSeq", empSeq);
		paramMap.put("fileId", fileId);
		String fileSn = (String) reBody.get("fileSn");
		paramMap.put("fileSn", fileSn);
		
		int r = 0;
		List<Map<String,Object>> fileList = attachFileService.getAttachFileList(paramMap);
		if (fileList.size() > 0 ) {
			
			paramMap.put("useYn", "N");
			
			/** fileId 전체삭제 */
			if (EgovStringUtil.isEmpty(fileSn)) {
				r = attachFileService.updateAttachFile(paramMap); 		// 파일 정보 삭제
				attachFileService.updateAttachFileDetail(paramMap);		// 파일 상세 정보 삭제
			} 
			/** 부분 삭제 */
			else {
				r =  attachFileService.updateAttachFileDetail(paramMap);	// 파일 상세 정보 삭제
			}
		}

		/** insert 결과 체크 */
		if(r < 1) {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF2020");
			return result;		
		} else {
			MessageUtil.setApiMessage(result, servletRequest, resultHead, "AF2000");
			return result;		
		}
	}
	
	public  static String FileTypeStr(int i) 
	{
		String ret = null;
		switch(i)
		{
	    	case 20 : ret = BizboxAMessage.getMessage("TX800000094","파일을 찾을 수 없습니다."); break;
	    	case 21 : ret = BizboxAMessage.getMessage("TX800000095","파일 사이즈가 0 입니다.");  break;
	    	case 22 : ret = BizboxAMessage.getMessage("TX800000096","파일을 읽을 수 없습니다."); break;
	    	case 29 : ret = BizboxAMessage.getMessage("TX800000097","암호화 파일이 아닙니다.");  break;
	    	case 26 : ret = BizboxAMessage.getMessage("TX800000098","FSD 파일입니다.");       	break;
	    	case 105: ret = BizboxAMessage.getMessage("TX800000099","Wrapsody 파일입니다.");  	break;
	    	case 106: ret = BizboxAMessage.getMessage("TX800000100","NX 파일입니다.");			break;	    	
	    	case 101: ret = BizboxAMessage.getMessage("TX800000101","MarkAny 파일입니다.");   	break;
	    	case 104: ret = BizboxAMessage.getMessage("TX800000102","INCAPS 파일입니다.");    	break;
	    	case 103: ret = BizboxAMessage.getMessage("TX800000103","FSN 파일입니다.");       	break;
	    	default:break;
		}
		return ret;		
	}
	
	
	@RequestMapping(value="/cmm/file/exModuleFasooDrmDecoding.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> exModuleFasooDrmDecoding(@RequestBody Map<String, Object> paramMap) {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		String fileNm = paramMap.get("fileNm").toString();
		fileNm = fileNm.substring(0, fileNm.lastIndexOf("."));
		
		String filePath = paramMap.get("filePath") + "";
		String fileExt = paramMap.get("fileNm").toString().substring(paramMap.get("fileNm").toString().lastIndexOf(".")+1, paramMap.get("fileNm").toString().length());
		filePath = drmService.drmConvert("D", paramMap.get("groupSeq").toString(), paramMap.get("pathSeq").toString(), filePath, fileNm, fileExt);
		
		result.put("filePath", filePath);
		result.put("fileNm", fileNm + "." + fileExt);
		
		return result;

	}
	
	@RequestMapping("/cmm/file/edmsDownloadProc.do")
    public void edmsDownloadProc(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {
		
		File file = null;
		FileInputStream fis = null;

		String groupSeq = paramMap.get("groupSeq") + "";
		String pathSeq = paramMap.get("pathSeq") == null ? "1100" : paramMap.get("pathSeq") + "";
		String path = paramMap.get("filePath") + "";
		String saveFileName = paramMap.get("saveFileName") + "";
		String fileExt = paramMap.get("fileExt") + "";
		String orignlFileName = paramMap.get("orignlFileName") + "." + fileExt; 
		
		try {
			//DRM 체크
			String drmPath = drmService.drmConvert("D", groupSeq, pathSeq, path, saveFileName, fileExt);
			file = new File(drmPath);
		    fis = new FileInputStream(file);

		    orignlFileName = URLEncoder.encode(orignlFileName, "UTF-8"); 
		    orignlFileName = orignlFileName.replaceAll("\\+", "%20"); // 한글 공백이 + 되는 현상 해결 위해

		    response.setHeader( "Content-Disposition", "attachment; filename=\""+ orignlFileName + "\"" );
			response.setContentType( CommonUtil.getContentType(file) );
			response.setHeader( "Content-Transfer-Coding", "binary" );
		    response.setContentLength((int) file.length());
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
		} catch(Exception e) {
			logger.error("Exception : " + e.getMessage());
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
	
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/file/convertFileExtForMig.do")
    public void convertFileExtForMig(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {
	
		String module = paramMap.get("module").toString();
		
		

		if(module != null && module.equals("edms")){						
			List<Map<String, Object>> boardList = (List<Map<String, Object>>) commonSql.list("boardAttachFileList", paramMap);
			List<Map<String, Object>> boardReplyList = (List<Map<String, Object>>) commonSql.list("boardReplyAttachFileList", paramMap);
			
			if(boardList.size() > 0 ){
				for(Map<String, Object> mp : boardList){
					String filePath = "/home" + BizboxAProperties.getEdmsProperty("UPLOAD_PATH") + mp.get("filePath2");
					String fileName = mp.get("tmpFileName").toString();
					if(mp.get("fileExtsn") != null && mp.get("tmpFileName").toString().equals(mp.get("fileExtsn2").toString())){
						String newName = mp.get("tmpFileName") + "." + mp.get("fileExtsn");
						
						File file1 = new File(filePath + fileName);
					    File file2 = new File(filePath + newName);
					    	
					    if (file1.renameTo(file2)) {					    	
					        //System.err.println("이름 변경 성공 : " + file1);
					    }						
					}
				}
				
				commonSql.update("boardAttachUpdateFileName", paramMap);				
			}
			
			
			if(boardReplyList.size() > 0 ){
				for(Map<String, Object> mp : boardReplyList){
					String filePath = "/home" + BizboxAProperties.getEdmsProperty("UPLOAD_PATH") + mp.get("filePath2");
					String fileName = mp.get("tmpFileName").toString();
					if(mp.get("fileExtsn") != null && mp.get("tmpFileName").toString().equals(mp.get("fileExtsn2").toString())){
						String newName = mp.get("tmpFileName") + "." + mp.get("fileExtsn");
						
						File file1 = new File(filePath + fileName);
					    File file2 = new File(filePath + newName);
					    	
					    if (file1.renameTo(file2)) {					    	
					        //System.err.println("이름 변경 성공 : " + file1);
					    }						
					}
				}
				commonSql.update("boardReplyAttachUpdateFileName", paramMap);
			}
		}				
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/file/EdmsAttachMig2.do")
	public void subDirList(@RequestParam Map<String, Object> paramMap){

		String targetPath = paramMap.get("targetPath") + "";
		if(targetPath != null && !"".equals(targetPath)) {//경로 조작 및 자원 삽입
			targetPath = targetPath.replaceAll("", "");
		}
		
		File dir = new File(targetPath); 

		File[] fileList = dir.listFiles(); 

		try{
			for(int i = 0 ; i < fileList.length ; i++){

				File file = fileList[i]; 

				if(file.isFile()){
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("fileNm", file.getName());
					Map<String, Object> mp = (Map<String, Object>) commonSql.select("NpToAlphaEdmsAttachMig2", para);
					if(mp != null){
						
						File dir2 = new File("D:/mig/docs" + mp.get("filePath2"));
						if(!dir2.exists()){
							dir2.mkdirs();
						}
						
						if(file.renameTo(new File("D:/mig/docs" + mp.get("filePath2") + mp.get("tmpFileName")))){ //파일 이동
			                //System.out.println("파일명 변경 및 이동 성공!");
						}
		            }
				}else if(file.isDirectory()){
					//System.out.println("디렉토리 이름 = " + file.getName());
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("targetPath", file.getCanonicalPath());
					subDirList(para); 
				}
			}

		}catch(IOException e){
			logger.error(e.getMessage());
		}

	}

	
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/cmm/file/NpToAlphaEdmsAttachMig.do")
    public void NpToAlphaEdmsAttachMig(@RequestParam Map<String, Object> paramMap, HttpServletResponse response) throws Exception {
		String targetPath = paramMap.get("targetPath") + "";		
		
		List<Map<String, Object>> list = commonSql.list("NpToAlphaEdmsAttachMig", paramMap);
		
		//int totalCnt = list.size();
		//int nowCnt = 0;
		
		for(Map<String, Object> mp : list){
			String fileNm = mp.get("tmpFileName") + "";
			if(fileNm.indexOf(".") > -1) {
				fileNm = fileNm.substring(0, fileNm.indexOf("."));
			}
			
			String targetFolder = targetPath + mp.get("filePath2");
			
			File dir = new File(targetFolder);
			if(!dir.exists()){
				dir.mkdirs();
			}
			
		  try{
			  
	            File file =new File(targetPath + "/" + fileNm);
	 
	            if(file.exists()){	            
		            if(file.renameTo(new File(targetFolder + mp.get("tmpFileName")))){ //파일 이동
		                //System.out.println(nowCnt  + " / " + totalCnt + " : '" + fileNm +"' 파일명 변경 및 이동 성공!");
		            }
	            }
	 
	        }catch(Exception e){
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
		  //nowCnt++;
		}
		//System.out.println("전송 완료!");
	}
}
