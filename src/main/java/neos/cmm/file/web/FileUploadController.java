package neos.cmm.file.web;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.file.vo.FileUploadVO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.CommonCodeSpecific;
import net.sf.json.JSONObject;

/**
 * 
 * @title 파일 업로드 팝업 화면
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 6. 7.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 6. 7.  박기환        최초 생성
 * 2012.10.17.	박민우        포탈 파일경로 추가		  
 *
 */
@Controller
public class FileUploadController {

    @Resource(name = "EgovFileMngService")
    private EgovFileMngService fileMngService;

    @Resource(name = "EgovFileMngUtil")
    private EgovFileMngUtil fileUtil;

	
    private static final Logger LOG = Logger.getLogger(FileUploadController.class.getName());
    
	/**
     * 파일 업로드 Popup 화면
     * 
     * @param organVO 
     * @return
     * @throws Exception
     */
	
	@RequestMapping("/cmm/file/PictureFileUploadPopup.do")
	public String PictureFileUploadPopup(@ModelAttribute("FileUploadVO") FileUploadVO fileUploadVO, ModelMap model) throws Exception{
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("fileUploadVO", fileUploadVO);
		model.addAttribute("LoginVO", user);
		return "/neos/cmm/file/PictureFileUploadPopup";
	}
	
	 /**
     * 파일 업로드 
     * 
     * @param MultipartHttpServletRequest multiRequest
     * @param model
     * @return
     * @throws Exception
     */

    @RequestMapping("/cmm/file/insertFileUpload.do")
    public String insertFileUpload(final MultipartHttpServletRequest multiRequest, ModelMap model, HttpServletRequest req, @ModelAttribute("FileUploadVO") FileUploadVO fileUploadVO) throws Exception {

		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	
		if (isAuthenticated) {
		    List<FileVO> result = null;
		    
		    final Map<String, MultipartFile> files = multiRequest.getFileMap();
		    if (!files.isEmpty()) {
		    	
		    	String fileType = req.getParameter("fileType")==null? "":req.getParameter("fileType");
		    	HashMap<String, String> map = getStorePath(fileType);
		    	String keyStr = map.get("KeyStr");
		    	String storePath = map.get("storePath");
		    	
		    	LOG.debug("upload file:"+storePath+keyStr);
				result = fileUtil.parseFileInf(files, keyStr, 0, "", storePath);
				fileMngService.insertFileInfs(result);
		    }
		    if(result!=null) {//Null Pointer 역참조
		    FileVO fileVo = (FileVO)result.get(0);
		    
		    model.addAttribute("fileVo", fileVo);
		    }
		    model.addAttribute("fileUploadVO", fileUploadVO);
		}
		
		return "/neos/cmm/file/PictureFileUploadPopup";
    }
    
    /**
     * 파일 업로드 
     * 
     * @param MultipartHttpServletRequest multiRequest
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/cmm/file/fileUpload.do", method = RequestMethod.POST) 
    public void fileUpload(final MultipartHttpServletRequest multiRequest, ModelMap model, HttpServletRequest req, 
    		@ModelAttribute("FileUploadVO") FileUploadVO fileUploadVO, HttpServletResponse response) throws Exception {
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
	
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if (isAuthenticated) {
		    List<FileVO> result = null;
		    
		    final Map<String, MultipartFile> files = multiRequest.getFileMap();
		    if (!files.isEmpty()) {
		    	
		    	String fileType = req.getParameter("fileType")==null? "":req.getParameter("fileType");
		    	HashMap<String, String> map = getStorePath(fileType);
		    	String keyStr = map.get("KeyStr");
		    	String storePath = map.get("storePath");
				result = fileUtil.parseFileInf(files, keyStr, 0, "", storePath);
				fileMngService.insertFileInfs(result);
		    }
		    if(result!=null) {//Null Pointer 역참조
		    FileVO fileVo = (FileVO)result.get(0);
		    
		    resultMap.put("fileVo", fileVo);
		    }

		}
		
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = null ;
		try {
			
			JSONObject result = JSONObject.fromObject(resultMap);
			out = response.getWriter();
			out.println(result.toString());
		}catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			LOG.error(e);
		}finally {
			if ( out != null ) {
				out.close() ;
			}
		}
    } 
    
    @RequestMapping(value="/cmm/file/commonFileUpload.do", method = RequestMethod.POST) 
    public void commonFileUpload(final MultipartHttpServletRequest multiRequest, ModelMap model, HttpServletRequest req, 
            @ModelAttribute("FileUploadVO") FileUploadVO fileUploadVO, HttpServletResponse response) throws Exception {
        Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
    
        Map<String, Object> resultMap = new HashMap<String, Object>();
        
        if (isAuthenticated) {
            List<FileVO> result = null;
            
            final Map<String, MultipartFile> files = multiRequest.getFileMap();
            if (!files.isEmpty()) {
                
                String fileType = req.getParameter("fileType")==null? "":req.getParameter("fileType");
                HashMap<String, String> map = getStorePath(fileType);
                String keyStr = map.get("KeyStr");
                String storePath = map.get("storePath");
                result = fileUtil.parseFileInfComm(files, keyStr, 0, "", storePath);
                fileMngService.insertFileInfs(result);
            }
            if(result!=null) {//Null Pointer 역참조
            FileVO fileVo = (FileVO)result.get(0);
            
            resultMap.put("fileVo", fileVo);
            }

        }
        
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = null ;
        try {
            
            JSONObject result = JSONObject.fromObject(resultMap);
            out = response.getWriter();
            out.println(result.toString());
        }catch (Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
            LOG.error(e);
        }finally {
            if ( out != null ) {
            	out.close() ;
            }
        }
    }     
    /**
     * prefix(KeyStr), storePath 구하는 메서드
     * 
     * @param String fileType
     * @return HashMap<String, String>
     * @throws Exception
     */
    private HashMap<String, String> getStorePath(String fileType){
    	HashMap<String, String> map = new HashMap<String, String>();
    	String keyStr = "";
    	String storePath = "";
		if("photo".equals(fileType)){
    		keyStr = "PIC_";
    		storePath = "Globals.fileStorePath.photo." + NeosConstants.SERVER_OS;
    	}else if("sign".equals(fileType)){
    		keyStr = "SIGN_";
    		storePath = "Globals.fileStorePath.sign." + NeosConstants.SERVER_OS;
    	}else if("stamp".equals(fileType)){
    		keyStr = "STAMP_";
    		storePath = "Globals.fileStorePath.stamp." + NeosConstants.SERVER_OS;
    	}else if("template".equals(fileType)){
    		keyStr = "TEMP_";
    		storePath = "Globals.fileStorePath.template." + NeosConstants.SERVER_OS;
    	}else if("portalPhoto".equals(fileType)){
    		keyStr = "PIC_";
    		storePath = "Globals.fileStorePath.portal.photo." + NeosConstants.SERVER_OS;
    	}else if("portalFile".equals(fileType)){
    		keyStr = "FILE_";
    		storePath = "Globals.fileStorePath.portal.file." + NeosConstants.SERVER_OS;
    	}else if("logo".equals(fileType)){
            keyStr = "LOGO_";
            //storePath = "Globals.fileStorePath.logo." + NeosConstants.SERVER_OS;
            storePath = CommonCodeSpecific.getLogoPath();
        }
		
		map.put("KeyStr", keyStr);
		map.put("storePath", storePath);
    	
    	return map;
    }
    
}
