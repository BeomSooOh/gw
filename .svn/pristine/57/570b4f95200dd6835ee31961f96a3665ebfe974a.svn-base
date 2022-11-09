package neos.cmm.systemx.img.web;

import java.io.File;
import java.io.FileInputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.EgovMessageSource;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;

@Controller
public class FileManageController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(FileManageController.class);
	
	@Resource(name="FileUploadService")
	FileUploadService fileUploadService;
	
    @Resource(name="SequenceService")
    private SequenceService sequenceService;
    
    /** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
    @Resource(name = "loginService")
    private EgovLoginService loginService;	
    
    @Resource(name = "GroupManageService")
	private GroupManageService groupManageService;
	
	
	@RequestMapping("/cmm/systemx/orgUploadImage.do")
	public ModelAndView orgUploadImage(@RequestParam Map<String,Object> paramMap) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		paramMap.put("orgSeq", paramMap.get("orgSeq"));
		
		if (paramMap.get("osType") == null) {
			paramMap.put("osType", "");
		}
		if (paramMap.get("appType") == null) {
			paramMap.put("appType", "");
		}
		if (paramMap.get("dispMode") == null) {
			paramMap.put("dispMode", "");
		}
		if (paramMap.get("dispType") == null) {
			paramMap.put("dispType", "");
		}
		
		paramMap.put("createSeq", loginVO.getUniqId());
		paramMap.put("modifySeq", loginVO.getUniqId());
		
		/** file list 처리 */
		String fileList = paramMap.get("fileList")+"";
		if(!EgovStringUtil.isEmpty(fileList)) {
			/*<!-- P1202xxdpi_p -->*/
			/*<!-- dispMod + AppType + osType + dispType -->*/
			
			String[] arr = fileList.split(";");				// P1202xxdpi_p|1213;P1202xxdpi_p|1214
			for(String s : arr) {
				String[] items = s.split("\\|");			// P1202xxdpi_p|1213
				if (items.length > 1) {
					
					String type = items[0];
					String fileId = items[1];

					
					String imgType = type.substring(0,7);
					String dispMode = type.substring(7, 8);	// P
					String appType = type.substring(8, 10);	// 12
					String osType = type.substring(10, 12);	// 02
					String dispType = type.substring(12);	// xxdpi_p
					
					
					paramMap.put("imgType", imgType);
					paramMap.put("dispMode", dispMode);
					paramMap.put("appType", appType);
					paramMap.put("osType", osType);
					paramMap.put("dispType", dispType);
					paramMap.put("fileId", fileId);
					
					Object orgImgChk = fileUploadService.selectOrgImg(paramMap);
					
					if (orgImgChk != null){
						String ifileId = orgImgChk.toString();
						paramMap.put("file_Id", ifileId);
						fileUploadService.deleteFile(paramMap); //이미 등록되어 있는 로고인 경우 기존 첨부파일 내역 삭제;
					}
					
					fileUploadService.insertOrgImg(paramMap);
				}
				
			}
		} else {
			Object orgImgChk = fileUploadService.selectOrgImg(paramMap);
			
			if (orgImgChk != null){
				String ifileId = orgImgChk.toString();
				paramMap.put("file_Id", ifileId);
				fileUploadService.deleteFile(paramMap); //이미 등록되어 있는 로고인 경우 기존 첨부파일 내역 삭제;
			}
			
			/** db t_co_org_img table insert */
			fileUploadService.insertOrgImg(paramMap);
		}
		
		//백그라운드 이미지타입 저장
		if(paramMap.get("bgType") != null){
			groupManageService.updateBgType(paramMap);
		}		

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	@RequestMapping("/cmm/systemx/orgDeleteImage.do")
	public ModelAndView orgDeleteImage(@RequestParam Map<String,Object> paramMap) throws Exception {

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		paramMap.put("orgSeq", paramMap.get("orgSeq"));	
		
		
		paramMap.put("createSeq", loginVO.getUniqId());
		paramMap.put("modifySeq", loginVO.getUniqId());
		
		
		//phone이미지일 경우 추가 파라미터 처리.
		if(paramMap.get("target") != null){
			String type = paramMap.get("imgType").toString();
			
			
			String imgType = type.substring(0,7);
			String dispMode = type.substring(7, 8);	// P
			String appType = type.substring(8, 10);	// 12
			String osType = type.substring(10, 12);	// 02
			String dispType = type.substring(12);	// xxdpi_p

			paramMap.put("dispMode", dispMode);
			paramMap.put("appType", appType);
			paramMap.put("osType", osType);
			paramMap.put("dispType", dispType);
			paramMap.put("imgType", imgType);
			
		}
		
		
		
		//저장파일삭제(프로필 이미지)
		if(!EgovStringUtil.isEmpty(paramMap.get("file_Id") + "")){
			paramMap.put("fileId", paramMap.get("file_Id"));
			Map<String, Object> imgMap = fileUploadService.getAttachFileDetail(paramMap);
			
			String fileName = imgMap.get("streFileName") + "";
			
			Map<String, Object> params = new HashMap<String, Object>();
			
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("pathSeq", "900");
			params.put("osType", NeosConstants.SERVER_OS);
			
			List<Map<String, Object>> groupPathList = groupManageService.selectGroupPathList(params);
			if(groupPathList.size() > 0){   				
	
	   			Map<String, Object> groupPathMap = groupPathList.get(0);
	   			
	   			if(groupPathMap != null){
	   				//프로필 저장 경로 셋팅
		   			String filePath = groupPathMap.get("absolPath").toString() + imgMap.get("fileStreCours").toString();
		   			
		   			File path = new File(filePath);
		   			File[] fileList = path.listFiles();
		   			
		   			for(File file: fileList){
		   				
		   				//프로필 저장 폴더 내 자신의 empSeq로 시작하는 파일이 존재하면 삭제.
		   				if(file.getName().startsWith(fileName + ".")){
		   					file.delete();
		   				}
		   				if(file.getName().startsWith(fileName + "_thum.")){
		   					file.delete();
		   				}
		   			}
	   			}
			}
		}
		
		//백그라운드 이미지타입 저장
		if(paramMap.get("bgType") != null){
			groupManageService.updateBgType(paramMap);
		}
		
		fileUploadService.deleteFile(paramMap);
		fileUploadService.deleteOrgImg(paramMap);
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
    /**
     * 이미지 파일 viewer 하기
     * @param params
     * @param response
     * @throws Exception
     */
	@RequestMapping("/cmm/systemx/orgGetImage.do")
    public void orgGetImage(@RequestParam Map<String,Object> params, HttpServletResponse response) throws Exception {

		String path = String.valueOf(params.get("path"));
		String fileName = String.valueOf(params.get("fileName"));

		if(fileName != null && !"".equals(fileName)) {//경로 조작 및 자원 삽입
			fileName = fileName.replaceAll("", "");
		}
		
		if (EgovStringUtil.isEmpty(path) || EgovStringUtil.isEmpty(fileName)) {
			return;
		}
		
		String rootPath = egovMessageSource.getMessage("SystemX.uploadpath."+NeosConstants.SERVER_OS);

		// 2011.10.10 보안점검 후속조치
		File file = null;
		FileInputStream fis = null;

		try {
		    file = new File(rootPath+"/"+path+"/"+fileName);
		    fis = new FileInputStream(file);

		    String type = "";

		    int index = fileName.lastIndexOf(".");
			String extension = fileName.substring(index);
		    
			String fileExtsn = extension;

			if (fileExtsn != null && !"".equals(fileExtsn)) {
			    if ("jpg".equals(fileExtsn.toLowerCase())) {
				type = "image/jpeg";
			    } else {
			    	type = "image/" + fileExtsn.toLowerCase();
			    }
			    type = "image/" + fileExtsn.toLowerCase();

			} else {
				LOGGER.debug("Image fileType is null.");
			}

			response.setHeader("Content-Type", type);
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

			// 2011.10.10 보안점검 후속조치 끝
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
		}
    }
	
	
	@RequestMapping("/cmm/systemx/userPicUpdateProc.do")
	public ModelAndView userPicUpdateProc(@RequestParam Map<String,Object> paramMap) throws Exception {
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		paramMap.put("empSeq", loginVO.getUniqId());
		
		String picFileId = paramMap.get("picFileId")+"";
		
		boolean bool = loginService.updateUserImg(paramMap);
		
		if (bool) {
			loginVO.setPicFileId(picFileId);
		}

		return mv;
	}
	
}
