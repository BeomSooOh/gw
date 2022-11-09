package neos.cmm.systemx.file;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;
import restful.com.service.AttachFileService;

public class WebAttachFileUtil {
	
	public static ModelAndView attachFileUpload(ModelAndView mv, MultipartHttpServletRequest multiRequest, Map<String,Object> paramMap) throws Exception {
		/** return 메세지 설정 */
		Map<String,Object> messageMap = new HashMap<String,Object>();
		messageMap.put("mKey", "resultMessage");
		messageMap.put("cKey", "resultCode");
		messageMap.put("codeHead", "systemx.attach.");
		
		
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
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		GroupManageService groupManageService = (GroupManageService)getBean(multiRequest, "GroupManageService");
		
		List<Map<String,Object>> pathList = groupManageService.selectGroupPathList(paramMap);
		if (pathList == null || pathList.size() < 1) {
			messageMap.put("code", "AF0050");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
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
		} else {
			/* 경로 구분자 추가 */
			if(!relativePath.startsWith("/")) {
				relativePath = File.separator + relativePath;
			}
		}
		
		/** File Id 생성(성공시 return) */
		SequenceService sequenceService = (SequenceService)getBean(multiRequest, "SequenceService");
		paramMap.put("value", "atchfileid");
		String fileId = sequenceService.getSequence(paramMap);
		
		/** save file */
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		int fileSn = 0; 																	// 파일 순번
		List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
		Map<String,Object> newFileInfo = null;
		String path = rootPath + File.separator + relativePath;								// 저장 경로
		long size = 0L;																		// 파일 사이즈
		MultipartFile file = null;
		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();								// 원본 파일명

			/* 확장자 */
			int index = orginFileName.lastIndexOf(".");
			if (index == -1) {
				messageMap.put("code", "AF0070");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				return mv;
			}
			
			String fileExt = orginFileName.substring(index + 1);
			fileExt = fileExt.toLowerCase() ;												// 확장자
			orginFileName = orginFileName.substring(0, index);

			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
			String saveFilePath = path+File.separator+newName+"."+fileExt;
			size = EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));

			
			/** 이미지일때 썸네일 이미지 저장
			 *  파일명_small.확장자
			 *  */
			try{
				String imgExt = "jpeg|bmp|gif|jpg|png";
				if (imgExt.indexOf(fileExt) != -1) {
					String imgSizeType = "thum";			//일단 썸네일 사이즈만
					int imgMaxWidth = 420;
					ImageUtil.saveResizeImage(new File(path+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth);
				}
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
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
				newFileInfo.put("createSeq", paramMap.get("empSeq"));
				saveFileList.add(newFileInfo);
				fileSn++;
			}
		}
		
		/** 파일 저장 리스트 확인 */
		if (saveFileList.size() < 1) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** DB Insert */
		AttachFileService attachFileService = (AttachFileService)getBean(multiRequest, "AttachFileService");
		String resultFileId = attachFileService.insertAttachFile(saveFileList);
		
		/** insert 결과 체크 */
		if(EgovStringUtil.isEmpty(resultFileId)) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		} else {
			messageMap.put("code", "SUCCESS");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
		}
		
		
		mv.addObject("fileId", resultFileId);
		
		return mv;
		
	
	}
	
	public static boolean isAttachFileEmpty(MultipartHttpServletRequest multiRequest) throws Exception {
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		if (files.isEmpty()) {
			return false;
		}
		
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		if (!itr.hasNext()) {
			return false;
		}
		
		return true;
		
	}
	
	
	public static Object getBean(HttpServletRequest request, String name) {
		ServletContext sc = request.getSession().getServletContext();
		WebApplicationContext ctx = RequestContextUtils.getWebApplicationContext(request, sc);
		
		return ctx.getBean(name);
	
	}
}
