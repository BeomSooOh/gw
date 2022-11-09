package neos.cmm.systemx.file.web;

import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.FileImageOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.util.IOUtils;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.MetadataException;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.jpeg.JpegDirectory;
import com.google.common.io.CharStreams;

import api.drm.service.DrmService;
import bizbox.orgchart.service.vo.LoginVO;
import cloud.CloudConnetInfo;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovFileUploadUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;
import net.sf.json.JSONObject;
import restful.com.controller.AttachFileController;


@Controller
public class WebAttachFileController {
	
	@Resource(name="GroupManageService")
	GroupManageService groupManageService;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@Resource(name="WebAttachFileService")
	WebAttachFileService attachFileService;
	
	/** EgovMessageSource */
    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;	    
    
    @Resource(name="EmpManageService")
    private EmpManageService empManageService;
    
    @Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
    
    @Resource(name = "attachFileController")
	private AttachFileController attachFileController;
    
	@Resource(name = "DrmService")
	private DrmService drmService;   
	
	@RequestMapping("/cmm/file/fileUploadProc.do")
    public ModelAndView fileUploadProc(MultipartHttpServletRequest multiRequest, @RequestParam Map<String,Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		
		/** return 메세지 설정 */
		Map<String,Object> messageMap = new HashMap<String,Object>();
		messageMap.put("mKey", "resultMessage");
		messageMap.put("cKey", "resultCode");
		messageMap.put("codeHead", "systemx.attach.");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String empSeq = paramMap.get("empSeq") + "";
		
		if(EgovStringUtil.isEmpty(empSeq)) {
			empSeq = loginVO.getUniqId();
		}
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		/** 파일 체크  */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		
		if(paramMap.containsKey("file0") && files.isEmpty()){
			int cnt = Integer.parseInt(paramMap.get("attFileCnt").toString()); 
			
			for(int i=0;i<cnt;i++){
				String fileInfo = paramMap.get("file" + i).toString();
				String filePath = fileInfo.split("\\|")[0];
				String fileNm = fileInfo.split("\\|")[1];
				
				if(fileNm != null && !"".equals(fileNm)) {//경로 조작 및 자원 삽입
					fileNm = fileNm.replaceAll("", "");
				}
				
				File file = new File(filePath + "/" + fileNm);
			    FileInputStream input = new FileInputStream(file);
			    MultipartFile multipartFile = new MockMultipartFile("file" + i,file.getName(), "text/plain", IOUtils.toByteArray(input));
			    files.put("file" + i, multipartFile);
			}
		}		
		
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
		paramMap.put("value", "atchfileid");
		String fileId = sequenceService.getSequence(paramMap);
		
		
		/** 입사처리 페이지에서 등록한 사인 이미지인 경우 t_co_emp file_id 업데이트 */
		String empFlag = paramMap.get("empSeq") + "";
		if(!EgovStringUtil.isEmpty(empFlag)){
			if((paramMap.get("imgSeq")+"").equals("sign")){
				Map<String, Object> empMap = new HashMap<String, Object>();
				empMap.put("empSeq", empFlag);
				empMap.put("imgSeq", paramMap.get("imgSeq"));
				empMap.put("fileId", fileId);
				
				empManageService.updateEmpPicFileId(empMap);
			}				
		}
		
		/** save file */
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		int fileSn = 0; 																	// 파일 순번
		List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
		Map<String,Object> newFileInfo = null;
		String path = rootPath + File.separator + relativePath;								// 저장 경로
		long size = 0L;																		// 파일 사이즈
		MultipartFile file = null;
		
		// 파일마다 새로운 file id로 생성할것인가..
		boolean isNewId = (paramMap.get("isNewId") != null && paramMap.get("isNewId").equals("true"));

		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();								// 원본 파일명

			/* 확장자 */
			int index = orginFileName.lastIndexOf(".");
			if (index == -1) {
				continue;
			}
			
			String fileExt = orginFileName.substring(index + 1);
			orginFileName = orginFileName.substring(0, index);
			
			// 이미지 파일 확장자 확인(jpg, jpeg, gif, png가 아니면 에러 발생)
			// 그룹웨어 취약사항 개선
			String lowerFileExt = fileExt.toLowerCase();
			
			if(paramMap.get("pathSeq").equals("900")) {
				String imgExt = "jpg|jpeg|gif|png";
				if(!imgExt.contains(lowerFileExt)) {
					//System.out.println(extError.toString());
				}
			}
			
			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
			String saveFilePath = path+File.separator+newName+"."+fileExt;
			
			
			/** 회사로고 저장경로 다시 설정. */
			if(entry.getKey().equals("IMG_COMP_LOGO") || entry.getKey().equals("IMG_COMP_FOOTER") || entry.getKey().equals("IMG_COMP_LOGIN_LOGO_A") || entry.getKey().equals("IMG_COMP_LOGIN_LOGO_B") || entry.getKey().equals("IMG_COMP_LOGIN_BANNER_A") || entry.getKey().equals("IMG_COMP_LOGIN_BANNER_B")){
				if(EgovStringUtil.isEmpty(paramMap.get("compSeq") + "")){
					newName = entry.getKey() + "_" + loginVO.getGroupSeq();
					path = rootPath + File.separator + "logo" + File.separator + loginVO.getGroupSeq();
					saveFilePath = path + File.separator + newName + "." + fileExt;				
					relativePath = File.separator + "logo" + File.separator + loginVO.getGroupSeq();
				}
				else{
					newName = entry.getKey() + "_" + paramMap.get("compSeq");
					path = rootPath + File.separator + "logo" + File.separator + loginVO.getGroupSeq() + File.separator + paramMap.get("compSeq");
					saveFilePath = path + File.separator + newName + "." + fileExt;				
					relativePath = File.separator + "logo" + File.separator + loginVO.getGroupSeq() + File.separator + paramMap.get("compSeq");
				}
			}
			
			size = EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
			
			/** 이미지일때 썸네일 이미지 저장
			 *  파일명_small.확장자
			 *  */
			try{
				String imgExt = "jpeg|bmp|jpg|png"; // gif 썹네일 안하도록 제거(움직이는 이미지의 경우 Image 라이브러리에서 오류 발생)
				if (imgExt.indexOf(fileExt.toLowerCase()) != -1) {
					String imgSizeType = "thum";			//일단 썸네일 사이즈만
					int imgMaxWidth = 420;
					ImageUtil.saveResizeImage(new File(path+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth);
				}
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//System.out.println("## ImageUtil.saveResizeImage Error : 썸네일이미지 생성 오류");
			}
			
			//DRM 체크
			drmService.drmConvert("U", loginVO.getGroupSeq(), pathSeq, path, newName, fileExt);
			
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
				newFileInfo.put("createSeq", loginVO.getUniqId());
				newFileInfo.put("inpName", file.getName());
				saveFileList.add(newFileInfo);
				fileSn++;
			}
			
			/** field id를 파일별로 다른경우 */
			if(isNewId) {
				paramMap.put("value", "atchfileid");
				fileId = sequenceService.getSequence(paramMap);
				fileSn = 0;
			}
			
		}
		
		/** 파일 저장 리스트 확인 */
		if (saveFileList.size() < 1) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** DB Insert */
		List<Map<String,Object>> resultFileIdList = attachFileService.insertAttachFile(saveFileList);
		
		/** insert 결과 체크 */
		if(resultFileIdList == null || resultFileIdList.size() == 0) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		} else {
			messageMap.put("code", "SUCCESS");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
		}
		
		/** field id를 파일별로 다른경우 */
		if (isNewId) {
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < resultFileIdList.size(); i++) {
				Map<String,Object> m = resultFileIdList.get(i);
				sb.append(m.get("inpName")+"");
				sb.append("|");
				sb.append(m.get("fileId")+"");
				if (i < resultFileIdList.size()-1) {
					sb.append(";");
				}
			}
			
			mv.addObject("fileList", sb.toString());
		} 
		/** 일반적인 경우 fileId만 리턴 */
		else {
			if (resultFileIdList != null && resultFileIdList.size() > 0) {
				mv.addObject("fileId", resultFileIdList.get(0).get("fileId"));
			} else {
				mv.addObject("fileId", null);
			}
		}
		
		String datatype = paramMap.get("dataType")+"";
		if (EgovStringUtil.isEmpty(datatype)||datatype.equals("json")) {
			mv.setViewName("jsonView");
		} 
		else if (datatype.equals("page")) {			
			if(!EgovStringUtil.isEmpty(paramMap.get("displayText")+"")){
				String displayText = URLEncoder.encode(paramMap.get("displayText")+"", "UTF-8");
				paramMap.put("displayText", displayText);
			}
			mv.setViewName("redirect:"+paramMap.get("page")+"?"+CommonUtil.getUrlParameter(paramMap));
		}
		//페이지명
		else {
			mv.setViewName(datatype);
		}
		
		
		return mv;
	}
	
	@SuppressWarnings("deprecation")
	@RequestMapping("/cmm/file/Dext5Uploader.do")
    public void Dext5Uploader(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		res.setCharacterEncoding("UTF-8");
		if(paramMap.get("dext5CMD").equals("openRequest")){
            String str = "<script type='text/javascript'>function onloadEvent(){setTimeout('winResize();',1000);}function winResize(){var imgWidth = img.width;var imgHeight = img.height;if(img.width > img.height){if(img.width > screen.width){img.style.width = screen.width - 100;}}else{if(img.height > screen.height){img.style.height = screen.height - 200;}}img.style.display = 'block';window.resizeTo(img.width + 50,img.height + 100);}</script><body style='background-color:rgba(241, 241, 241, 1);'><center><img id='img' src='";
            str += URLDecoder.decode((String)paramMap.get("customValue")) + "' onload='onloadEvent();' style='display:none;border: #cacaca; border-width: thin; border-style: dotted;'></center></body>";
            res.getWriter().write(str);
		}else if(paramMap.get("dext5CMD").equals("downloadRequest")) {
			String str = "";
			if(paramMap.get("activxYn").equals("Y")){
				str = "<script type=\"text/javascript\">alert('보안설정으로 업로드 컴포넌트에서 다운로드가 불가합니다.');</script>";
			}else{
				str = "<script type=\"text/javascript\">this.location.href = '" + URLDecoder.decode((String)paramMap.get("customValue")) + "';</script>";
			}
            res.getWriter().write(str);
		}else{
			res.getWriter().println("Hi, DEXT5 Upload !!!???-2.7.1127812.1000.01--");
		}
    }	
	
	@RequestMapping("/cmm/file/Dext5ImageUpload.do")
    public void Dext5ImageUpload(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws IOException{
		
		String imgPath = "";
		
		if(paramMap.get("htmlstring") != null){
			imgPath = URLDecoder.decode(paramMap.get("htmlstring").toString().trim(), "UTF-8");
			res.setHeader("Pragma","public");
			res.setHeader("Expires","0");
			res.setHeader("Content-Type","application/octet-stream;charset=UTF-8");
			res.setHeader("Content-disposition","attachment; filename=duzon_content.html");
			res.setHeader("Content-Transfer-Encoding","binary");
		}else if(paramMap.get("dext") == null){
			
			String editorParam = (String)paramMap.get("tosavepathurl");
			String saveFileName  = java.util.UUID.randomUUID().toString() + "." + (String)paramMap.get("savefileext");

			if(saveFileName != null && !"".equals(saveFileName)) {//경로 조작 및 자원 삽입
				saveFileName = saveFileName.replaceAll("", "");
			}
			
			if(paramMap.get("imagedata") == null){
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
				MultipartFile imgFile = multipartRequest.getFile("Filedata");
				EgovFileUploadUtil.saveFile(imgFile.getInputStream(), new File(editorParam.split("\\|")[1] + "/editorImg/" + saveFileName));
			}else{
				Base64 decoder = new Base64(); 
				String dzeUpimageData = (String)paramMap.get("imagedata");
				byte[] dArray = decoder.decode(dzeUpimageData.getBytes());
				InputStream inputStream = new ByteArrayInputStream(dArray);
				EgovFileUploadUtil.saveFile(inputStream, new File(editorParam.split("\\|")[1] + "/editorImg/" + saveFileName));				
			}
			imgPath = editorParam.split("\\|")[0] + "/editorImg/" + saveFileName;
		}
		
        PrintWriter out = res.getWriter();
        out.println(imgPath);
        out.close();			
    }
	
	@RequestMapping("/cmm/file/DzEditorImageUpload.do")
    public void DzEditorImageUpload(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		
		String uploadPath = "";
		String fileName = "";
		String sReturn = "";
		String type = (String)paramMap.get("type");
		String[] extArr = {"doc","docx","xls","xlsx","ppt","pptx","hwp","txt","pdf","png","jpg","gif","jpeg"};

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO != null) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
		}
		
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", NeosConstants.SERVER_OS);	
		
		@SuppressWarnings("unchecked")
		Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("GroupManage.selectPathInfo", paramMap);
		
		String absolPath = pathMap.get("absolPath").toString().replace("/home", "");
		
		if(type.equals("save_contents")){ 
			request.setCharacterEncoding("UTF-8");
			
			String strCR = "\r\n";
			
			String curUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
			
			String contents = request.getParameter("content");
			contents = contents.replaceAll("&nbsp;", " ");
			contents = contents.replaceAll("&lt;", "<");
			contents = contents.replaceAll("&gt;", ">");
			contents = contents.replaceAll("&amp;", "&");
			contents = contents.replaceAll("&quot;", "\"");
			contents = contents.replaceAll("&apos;", "'");
			
			contents = contents.replaceAll("src=\"" + absolPath + "/editorImg/", "src=\"" + curUrl + absolPath + "/editorImg/");

			String strHTML = "";
			strHTML += "<html>";
			strHTML += strCR;
			strHTML += "<head>";
			strHTML += strCR;
			strHTML += "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />";
			strHTML += strCR;
			strHTML += "<title></title>";
			strHTML += strCR;
			strHTML += "</head>";
			strHTML += strCR;
			strHTML += "<body>";
			strHTML += strCR;
			strHTML += contents;
			strHTML += strCR;
			strHTML += "</body>";
			strHTML += strCR;
			strHTML += "</html>";
			strHTML += strCR;

			String strFileName = "duzon_content.html";
			
			res.setHeader("Pragma","public");
			res.setHeader("Expires","0");
			res.setHeader("Content-Type","application/octet-stream");
			res.setHeader("Content-disposition","attachment; filename=" + strFileName);
			res.setHeader("Content-Transfer-Encoding","binary");
			
			res.setCharacterEncoding("UTF-8");
			res.setContentType("text/html; charset=UTF-8");
	        res.getWriter().println(strHTML);
	        res.getWriter().close();
	        return;
		}
		
		
		if(type.equals("form_upload_image") || type.equals("dnd_upload_image")){
			
			MultipartHttpServletRequest mhsq = (MultipartHttpServletRequest)request;
			List<MultipartFile> mf = mhsq.getFiles("dze_upimage_file");

			MultipartFile uploadFile = null;
			
			String fileNameIn = "";
			String uploadPathIn = "";
			
			for(int i=0; i<mf.size(); i++){
				uploadFile = mf.get(i);
				
				String extension = FilenameUtils.getExtension(uploadFile.getOriginalFilename()).toLowerCase();
				if(checkExtension(extension, extArr)) {				
					String editorParam = (String)paramMap.get("tosavepathurl");
					fileNameIn += "|" + uploadFile.getOriginalFilename();
					String saveFileName  = java.util.UUID.randomUUID().toString() + "." + fileNameIn.substring(fileNameIn.lastIndexOf( "." ) + 1);
					EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(editorParam.split("\\$")[1] + "/editorImg/" + saveFileName));
					uploadPathIn += "|" + editorParam.split("\\$")[0] + "/editorImg/" + saveFileName;
				}
			}
			
			if(fileNameIn.length() > 0) {
				fileNameIn = fileNameIn.substring(1);
			}
				
			if(uploadPathIn.length() > 0) {
				uploadPathIn = uploadPathIn.substring(1);
			}
			
			JSONObject json = new JSONObject();
			
			json.put("result", "success");
			json.put("type", type);
			json.put("filename", fileNameIn.split("\\|"));
			json.put("url", uploadPathIn.split("\\|"));
			
			sReturn = json.toString();
			
		}else if(type.equals("form_upload_extfile")){
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("dze_up_extfile");

			if(uploadFile != null && uploadFile.getSize() > 0){
				
				String extension = FilenameUtils.getExtension(uploadFile.getOriginalFilename()).toLowerCase();
				if(checkExtension(extension, extArr)) {	
				
					String editorParam = (String)paramMap.get("tosavepathurl");
					fileName = uploadFile.getOriginalFilename();
					String saveFileName  = java.util.UUID.randomUUID().toString() + "." + fileName.substring(fileName.lastIndexOf( "." ) + 1);
					
					List<Map<String,Object>> pathList = groupManageService.selectGroupPathList(paramMap);
	
					String rootPath = null;
					for(Map<String,Object> path : pathList) {
						rootPath = path.get("absolPath")+"";
					}
					
					String relativePath = File.separator + "dzeditor_ext";
	
					String path = rootPath + relativePath + File.separator + saveFileName;
					
					/** File Id 생성(성공시 return) */
					paramMap.put("value", "atchfileid");
					String fileId = sequenceService.getSequence(paramMap);
					
					long size = EgovFileUploadUtil.saveFile(uploadFile.getInputStream(), new File(path));
					
					List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
					HashMap<String,Object> newFileInfo = new HashMap<String,Object>();
					newFileInfo.put("fileId", fileId);
					newFileInfo.put("fileSn", "0");
					newFileInfo.put("pathSeq", "0");
					newFileInfo.put("fileStreCours", relativePath);
					newFileInfo.put("streFileName", saveFileName.substring(0,saveFileName.lastIndexOf( "." )));
					newFileInfo.put("orignlFileName", fileName.substring(0,fileName.lastIndexOf( "." )));
					newFileInfo.put("fileExtsn", fileName.substring(fileName.lastIndexOf( "." ) + 1));
					newFileInfo.put("fileSize", size);
					newFileInfo.put("createSeq", loginVO == null ? "" : loginVO.getUniqId());
					newFileInfo.put("inpName", uploadFile.getName());
					saveFileList.add(newFileInfo);
					
					/** DB Insert */
					attachFileService.insertAttachFile(saveFileList);
					uploadPath = editorParam + "/cmm/file/fileDownloadProc.do?fileId=" + fileId;
				}
				
				JSONObject json = new JSONObject();
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				
				sReturn = json.toString();
			}				
		}
		else if(type.equals("paste_image")){
			
			String dzeUpimageData = (String)paramMap.get("dze_upimage_data");
			
			if(dzeUpimageData != null && !dzeUpimageData.equals("")){
				Base64 decoder = new Base64(); 
				dzeUpimageData = dzeUpimageData.substring(dzeUpimageData.indexOf(",")+1);
				byte[] dArray = decoder.decode(dzeUpimageData.getBytes());
				InputStream inputStream = new ByteArrayInputStream(dArray);
				String editorParam = (String)paramMap.get("tosavepathurl");
				fileName = java.util.UUID.randomUUID().toString() + ".png";
				EgovFileUploadUtil.saveFile(inputStream, new File(editorParam.split("\\$")[1] + "/editorImg/" + fileName));
				uploadPath = editorParam.split("\\$")[0] + "/editorImg/" + fileName;				
				
				JSONObject json = new JSONObject();
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				sReturn = json.toString();					
			}
		}
		else if(type.equals("openfile")){
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("openfile");
			
			String extension = FilenameUtils.getExtension(uploadFile.getOriginalFilename()).toLowerCase();
			
			String[] extContentArr = {"html","htm","txt"};
			
			if(checkExtension(extension, extContentArr)) {	
				byte[] byteArray = uploadFile.getBytes();
				sReturn = CharStreams.toString(new InputStreamReader(uploadFile.getInputStream(), charLength(byteArray) ? StandardCharsets.UTF_8 : Charset.forName("EUC-KR")));
			}
		}		
		
		res.setCharacterEncoding("UTF-8");
		res.setContentType("text/html; charset=UTF-8");
        res.getWriter().println(sReturn);
        res.getWriter().close();
    }
	
	public boolean checkExtension(String ext, String[] extArr) {
		boolean result = false;
		for(int i=0;i<extArr.length;i++) {
			if(ext.equals(extArr[i])) {
				result = true;
				break;
			}
		}
		return result;
	}
	
	
	@SuppressWarnings("unused")
	@RequestMapping("/cmm/file/onefficeUpload.do")
    public void onefficeUpload(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		
		String uploadPath = "";
		String absolPath = "";
		String fileName = "";
		String sReturn = "";
		String type = (String)paramMap.get("type");
		boolean isReport = (paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report"));
		
		LoginVO loginVO = checkLoginVO(request);
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		//문서정보 조회
		@SuppressWarnings("unchecked")
		Map<String, Object> docInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getDocumentInfo", paramMap);
		String ownerId = "";
		
		if(docInfo == null){
			docInfo = new HashMap<String, Object>();
		}else{		
			ownerId = docInfo.get("owner_id") == null ? "" : docInfo.get("owner_id").toString();
		}
		
		if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null){
			LoginVO tempVO = new LoginVO();
			try{
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("empSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
				params.put("groupSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[2]);
				
				@SuppressWarnings("unchecked")
				Map<String, Object> userInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getUserInfo", params);
				
				tempVO.setGroupSeq(userInfo.get("group_seq").toString());
				tempVO.setUniqId(userInfo.get("emp_seq").toString());
				tempVO.setLangCode(userInfo.get("lang_code").toString());
				tempVO.setOrganId(userInfo.get("comp_seq").toString());
				tempVO.setCompSeq(userInfo.get("comp_seq").toString());
			}catch(Exception e){
				tempVO = null;
			}
			loginVO = tempVO;
		}
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
		if(pathMap != null){
			absolPath = pathMap.get("absolPath").toString();	
		}		
		
		if(type.equals("save_contents")){ 
			request.setCharacterEncoding("UTF-8");
			
			String strCR = "\r\n";
			String contents = request.getParameter("content");
			contents = contents.replaceAll("&nbsp;", " ");
			contents = contents.replaceAll("&lt;", "<");
			contents = contents.replaceAll("&gt;", ">");
			contents = contents.replaceAll("&amp;", "&");
			contents = contents.replaceAll("&quot;", "\"");
			contents = contents.replaceAll("&apos;", "'");
			
			String strHTML = "";
			strHTML += "<html>";
			strHTML += strCR;
			strHTML += "<head>";
			strHTML += strCR;
			strHTML += "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />";
			strHTML += strCR;
			strHTML += "<title></title>";
			strHTML += strCR;
			strHTML += "</head>";
			strHTML += strCR;
			strHTML += "<body>";
			strHTML += strCR;
			strHTML += contents;
			strHTML += strCR;
			strHTML += "</body>";
			strHTML += strCR;
			strHTML += "</html>";
			strHTML += strCR;


			String strFileName = "duzon_content.html";
			
			res.setHeader("Pragma","public");
			res.setHeader("Expires","0");
			res.setHeader("Content-Type","application/octet-stream");
			res.setHeader("Content-disposition","attachment; filename=" + strFileName);
			res.setHeader("Content-Transfer-Encoding","binary");
			
//			out.print(strHTML);
			res.setCharacterEncoding("UTF-8");
			res.setContentType("text/html; charset=UTF-8");
	        res.getWriter().println(strHTML);
	        res.getWriter().close();
	        return;
		}
		
		
		if(type.equals("form_upload_image") || type.equals("dnd_upload_image")){
			
			
			MultipartHttpServletRequest mhsq = (MultipartHttpServletRequest)request;
			List<MultipartFile> mf = mhsq.getFiles("dze_upimage_file");

			MultipartFile uploadFile = null;
			
			String fileNameIn = "";
			String fileUrl = "";
			
			//제한확장자설정			
			String[] extArr = {"asa","asp","cdx","cer","htr","aspx","jsp","jspx","html","htm","php","php3","php4","php5"};
			
			for(int i=0; i<mf.size(); i++){
				uploadFile = mf.get(i);
			
				fileName = uploadFile.getOriginalFilename();
				
				String extension = FilenameUtils.getExtension(fileName).toLowerCase();
				if(checkExtension(extension, extArr)) {	
					res.setCharacterEncoding("UTF-8");
					res.setContentType("text/html; charset=UTF-8");
			        res.getWriter().println("");
			        res.getWriter().close();
				}
				
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
				
				fileNameIn += "," + fileName;
				fileUrl += "," + uploadPath;
			}
			
			if(fileNameIn.length() > 0) {
				fileNameIn = fileNameIn.substring(1);
			}
			
			if(fileUrl.length() > 0) {
				fileUrl = fileUrl.substring(1);
			}
			
			JSONObject json = new JSONObject();
			
			json.put("result", "success");
			json.put("type", type);
			json.put("filename", fileNameIn.split(","));
			json.put("url", fileUrl.split(","));
			
			sReturn = json.toString();
		}else if(type.equals("form_upload_video") || type.equals("dnd_upload_video")){
			
			//제한확장자설정			
			String[] extArr = {"asa","asp","cdx","cer","htr","aspx","jsp","jspx","html","htm","php","php3","php4","php5"};
			
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("dze_upvideo_file");

			if(uploadFile != null && uploadFile.getSize() > 0){
				fileName = uploadFile.getOriginalFilename();
				
				String extension = FilenameUtils.getExtension(fileName).toLowerCase();
				if(checkExtension(extension, extArr)) {	
					res.setCharacterEncoding("UTF-8");
					res.setContentType("text/html; charset=UTF-8");
			        res.getWriter().println("");
			        res.getWriter().close();
				}
				
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
				
				JSONObject json = new JSONObject();
				
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				
				sReturn = json.toString();
			}		
		}else if(type.equals("form_upload_extfile")){
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("dze_up_extfile");

			if(uploadFile != null && uploadFile.getSize() > 0){
				
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
				newFileInfo.put("groupSeq", loginVO.getGroupSeq());
				newFileInfo.put("fileId", fileId);
				newFileInfo.put("fileSn", "0");
				newFileInfo.put("pathSeq", "0");
				newFileInfo.put("fileStreCours", relativePath);
				newFileInfo.put("streFileName", saveFileName.substring(0,saveFileName.lastIndexOf( "." )));
				newFileInfo.put("orignlFileName", fileName.substring(0,fileName.lastIndexOf( "." )));
				newFileInfo.put("fileExtsn", fileName.substring(fileName.lastIndexOf( "." ) + 1));
				newFileInfo.put("fileSize", size);
				newFileInfo.put("createSeq", loginVO.getUniqId());
				newFileInfo.put("inpName", uploadFile.getName());
				saveFileList.add(newFileInfo);
				
				/** DB Insert */
				List<Map<String,Object>> resultFileIdList = attachFileService.insertAttachFile(saveFileList);
				
				uploadPath = "/gw/cmm/file/fileDownloadProc.do?fileId=" + fileId;
				
				JSONObject json = new JSONObject();
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				
				sReturn = json.toString();
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
				
				JSONObject json = new JSONObject();
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				sReturn = json.toString();					
			}
		}
		else if(type.equals("openfile")){
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("openfile");
			
			byte[] byteArray = uploadFile.getBytes();
			sReturn = CharStreams.toString(new InputStreamReader(uploadFile.getInputStream(), charLength(byteArray) ? StandardCharsets.UTF_8 : Charset.forName("EUC-KR")));
		}
		else if(type.equals("uploadThumbImg")){
			MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			MultipartFile uploadFile = multipartRequest.getFile("upImgThumbImg");

			if(uploadFile != null && uploadFile.getSize() > 0){
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
						paramMap.put("groupSeq", loginVO.getGroupSeq());
						
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
				
				JSONObject json = new JSONObject();
				
				json.put("result", "success");
				json.put("type", type);
				json.put("filename", fileName);
				json.put("url", uploadPath);
				
				sReturn = json.toString();
			}
		}
		
		res.setCharacterEncoding("UTF-8");
		res.setContentType("text/html; charset=UTF-8");
        res.getWriter().println(sReturn);
        res.getWriter().close();
    }	
	
	@RequestMapping("/cmm/file/onefficeDownloadPdf.do")
    public ModelAndView onefficeDownloadPdf(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		
		String absolPath = "";
		
		LoginVO loginVO = checkLoginVO(request);
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		if(loginVO == null){ 
			mv.addObject("result","fail");
			return mv;
		}
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		paramMap.put("pathSeq", "0");
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
		if(pathMap != null){
			absolPath = pathMap.get("absolPath").toString();	
		}
		
		request.setCharacterEncoding("UTF-8");
		
		String htmlContent = paramMap.get("content").toString();
		String printLayout = paramMap.get("printLayout").toString();
		String printHeader = paramMap.get("printHeader").toString();
		String printFooter = paramMap.get("printFooter").toString();
		String printMargin = paramMap.get("printMargin").toString();
		String paperColor = paramMap.get("paperColor").toString();
		String docName = paramMap.get("subject").toString();
		
		int imgIndex = htmlContent.indexOf("getAttachmentData.do?seq=");
		
		Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.onefficeDownloadPdf.do htmlContent : " +  htmlContent);
		
		if(imgIndex > -1){
			String docNo = htmlContent.substring(imgIndex + 25, imgIndex + 57);
			paramMap.put("doc_no", docNo);
			paramMap.put("empSeq", loginVO.getUniqId());
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			
			//이미지 비세션 파라미터 추가
			while(true) {
				
				if(htmlContent.indexOf("/gw/onefficeApi/getAttachmentData.do?seq=") == -1) {
					break;
				}
				
				String docNoIn = htmlContent.substring(htmlContent.indexOf("/gw/onefficeApi/getAttachmentData.do?seq=")+41, htmlContent.indexOf("/gw/onefficeApi/getAttachmentData.do?seq=")+73);
				paramMap.put("doc_no", docNoIn);
				String ownerId = (String) commonSql.select("OnefficeDao.getOnefficeOwnerId", paramMap);
				
				String newHtmlContent = htmlContent.replaceFirst("/gw/onefficeApi/getAttachmentData.do\\?seq=", absolPath.replace("/home", "") + "/onefficeFile/" + ownerId + "/" + docNoIn + "/");
				htmlContent = newHtmlContent;
			}
			Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.onefficeDownloadPdf.do htmlContent replace : " +  htmlContent);
		}
				
	    File directory = new File(absolPath + "/onefficeFile/");
	    if (! directory.exists()){
	        directory.mkdir();
	    }
		
	    directory = new File(absolPath + "/onefficeFile/pdfTemp/");
	    if (! directory.exists()){
	        directory.mkdir();
	    }
	    String savePath = absolPath + "/onefficeFile/pdfTemp/";
	    
		String strFileBody = System.currentTimeMillis() + "";
		String strFile	= strFileBody + ".html";
		File f = new File(savePath, strFile);
		f.createNewFile();
		
		FileWriter fw = new FileWriter(savePath + strFile);
		fw.write(htmlContent);
		fw.close();		
		
		String cmd = "/home/neos/hermes-sdk/convert.sh " + savePath + strFile +" " + savePath + " pdf -Dorientation="+printLayout+" -Dheader="+printHeader+" -Dfooter="+printFooter+" -Dmargin="+printMargin+" -Dbackground="+paperColor;
		
		Logger.getLogger( CloudConnetInfo.class ).debug( "WebAttachFileController.onefficeDownloadPdf.do byCommonsExecStr params str : " + cmd);
		String cmdResult = executeCommand(cmd);
		Logger.getLogger( CloudConnetInfo.class ).debug( "WebAttachFileController.onefficeDownloadPdf.do byCommonsExecStr result : " + cmdResult);
		
		
		//원본 HTML 파일 삭제
		if( f.exists()) {
			f.delete();		
		}
		
		try{
			File file = new File(savePath, strFileBody + ".pdf");
			List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
			
			paramMap.put("value", "atchfileid");
			String fileId = sequenceService.getSequence(paramMap);
			int fileSn = 0;
			
			Map<String,Object> newFileInfo = new HashMap<String,Object>();
			newFileInfo.put("fileId", fileId);
			newFileInfo.put("fileSn", fileSn);
			newFileInfo.put("pathSeq", "0");
			newFileInfo.put("fileStreCours", "/onefficeFile/pdfTemp/");
			newFileInfo.put("streFileName", strFileBody);
			newFileInfo.put("orignlFileName", docName);
			newFileInfo.put("fileExtsn", "pdf");
			newFileInfo.put("fileSize", file.length());
			newFileInfo.put("createSeq", loginVO.getUniqId());
			saveFileList.add(newFileInfo);
						
			attachFileService.insertAttachFile(saveFileList);
			
			String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/gw/onefficeApi/onefficePdfDownLoad.do?fileId=" + fileId + "&groupSeq=" + loginVO.getGroupSeq();
			
			Map<String, Object> result = new HashMap<>();			
			mv.addObject("result", "success");
			result.put("url", url);
			result.put("size", file.length());
			mv.addObject("data", result);
			
			return mv;
		}catch(Exception e) {
			mv.addObject("result","fail");
			return mv;
		}
    }
	
	@RequestMapping("/cmm/file/onefficeSearch.do")
    public void onefficeServerSearch(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO == null){ 
			return;
		}
		
		request.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");

		String clientId = "HcGLlTBybjCRQOC_km3i";
		String clientSecret = "yphHYqsFGT";
		
		String query = request.getParameter("query").trim();
		String start = request.getParameter("start").trim();
		String display = request.getParameter("display").trim();
		String searchType = request.getParameter("searchType").trim();
		
		try {
			
			String text = query;

			String apiURL = "https://openapi.naver.com/v1/search/";
			
			if(searchType.equals("dic")) {
				apiURL += "encyc";
			} else if(searchType.equals("img")) {
				apiURL += "image";
			} else if(searchType.equals("news")) {
				apiURL += "news.json";
			} else if(searchType.equals("errata")) {
				apiURL += "errata.json";
			} else {
				apiURL += "encyc";
			}
			
			apiURL += "?query="+ text + "&start="+start+"&display="+display;
			
			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("X-Naver-Client-Id", clientId);
			con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if(responseCode==200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream(),"utf-8"));
			} else { 
				br = new BufferedReader(new InputStreamReader(con.getErrorStream(),"utf-8"));
			}
			String inputLine;
			StringBuffer sb = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();
			
			String content = sb.toString();
			res.getWriter().println(content);
			
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e);
		}
				
    }	
	
	@RequestMapping("/cmm/file/onefficeGetWebcontent.do")
    public void onefficeGetWebcontent(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse res) throws Exception{
		
		LoginVO loginVO = checkLoginVO(request);
		
		if(loginVO == null){ 
			return;
		}
		
		request.setCharacterEncoding("UTF-8");
		res.setContentType("text/html;charset=UTF-8");
		
		URL url = null;
		HttpURLConnection con = null;
		int timeoutValue = 10000;

		try {
			
			String accessUrl = request.getParameter("url").trim();
			accessUrl = java.net.URLDecoder.decode(accessUrl, "UTF-8");

			String charSet = "utf-8";
			if(request.getParameter("charSet") != null) {
				charSet = request.getParameter("charSet").trim();
			}


			url = new URL(accessUrl);
			con = (HttpURLConnection)url.openConnection();
			con.setConnectTimeout(timeoutValue);
			con.setReadTimeout(timeoutValue);

			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if(responseCode==200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream(),charSet));
			} else { 
				br = new BufferedReader(new InputStreamReader(con.getErrorStream(),charSet));
			}
			String inputLine;
			StringBuffer sb = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				sb.append(inputLine);
			}
			br.close();

			String content = sb.toString();
			res.getWriter().println(content);

		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}finally{
			if(con!=null) {//Null Pointer 역참조
		   con.disconnect();
			}
		}		
		
    }	
	
	
	
	@RequestMapping("/cmm/file/onefficeGetWebImage.do")
    public ModelAndView onefficeGetWebImage(@RequestParam Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		LoginVO loginVO = checkLoginVO(request);
		
		boolean isReport = paramMap.get("ref") != null && paramMap.get("ref").toString().equals("bizbox_report");
		
		if(loginVO == null){ 
			return null;
		}
		
		HttpURLConnection con = null; 
	    	
    	if(request.getParameter("doc_no") != null) {
    		
    		ModelAndView mv = new ModelAndView();
    		
    		try {
    			
    			String fileName = request.getParameter("url").trim();
    			
    			String fileUrl = request.getParameter("url").trim();  
    			if(fileUrl.indexOf("/gw/onefficeApi/getAttachmentData.do?") != -1) {
    				fileUrl = fileUrl.replace("/gw/onefficeApi/getAttachmentData.do?", "/gw/onefficeApi/getAttachmentData.do?noAuth=Y&groupSeq=" + loginVO.getGroupSeq() + "&");
    				Map<String, String> urlParamMap = CommonUtil.getQueryMap(fileUrl);				
    				fileName = urlParamMap.get("seq");
    			}    			
    			
    			String extension = "";
    			
    			URL u = new URL(fileUrl);
        		URLConnection uc = u.openConnection();
        		
        		extension = CommonUtil.getFileExtensionByMime(uc.getContentType());
        		
        		if(extension.equals("")) {
        			if(fileName.indexOf(".") != -1) {
        				extension = fileName.substring(fileName.lastIndexOf( "." ) + 1);
        			}else {
        				extension = "png";
        			}
        		}
    			
    			
				String saveFileName  = java.util.UUID.randomUUID().toString() + "." + extension;
				
				String docNo = request.getParameter("doc_no");
				
				if(!docNo.equals("")){
					saveFileName = 	docNo + "-" + saveFileName;
				}
					
				String savePath = "";
				String absolPath = "";
				
				paramMap.put("groupSeq", loginVO.getGroupSeq());
	    		paramMap.put("pathSeq", "0");
	    		paramMap.put("osType", NeosConstants.SERVER_OS);
	    		
	    		Map<String, Object> pathMap = groupManageService.selectGroupPath(paramMap);
	    		if(pathMap != null){
	    			absolPath = pathMap.get("absolPath").toString();	
	    		}
				
				String uploadPath = "";
				savePath = absolPath + "";
				
				if(!isReport){
					//문서 소유자 path에 이미지 저장 (UCAIMP-5258, 2020-06-30)
					String ownerId = loginVO.getUniqId();
					if(!docNo.equals("")) {	//doc_no: 현재 문서 seq
						paramMap.put("doc_no", docNo);
						paramMap.put("empSeq", loginVO.getUniqId());
						paramMap.put("groupSeq", loginVO.getGroupSeq());

						@SuppressWarnings("unchecked")
						Map<String, Object> result = (Map<String, Object>) commonSql.select("OnefficeDao.getDocument", paramMap);
						if(result != null && result.get("owner_id") != null) {
							ownerId = result.get("owner_id").toString();	//문서의 소유자 얻기
						}
					}

					uploadPath = "/gw/onefficeApi/getAttachmentData.do?seq=" + saveFileName;
					savePath = absolPath + "/onefficeFile/" + ownerId + "/" + (!docNo.equals("") ? (docNo + "/") : "");
				}
				else{
					uploadPath = "/gw/onefficeApi/getAttachmentData.do?ref=bizbox_report&seq=" + saveFileName;
					savePath = absolPath + "/onefficeFile/report/" + docNo + "/";
				}
				
				
				EgovFileUploadUtil.urlFileDown(fileUrl, savePath, saveFileName);
				
				mv.addObject("result", "success");
				mv.addObject("type", "get_web_image");
				mv.addObject("filename", saveFileName);
				mv.addObject("url", uploadPath);
				
    		}catch(Exception e) {
    			Logger.getLogger( WebAttachFileController.class ).error( "WebAttachFileController.onefficeGetWebImage.do ERROR");
    			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    		}
    		mv.setViewName("jsonView");
			return mv;
			
    	}else {
    		try {
		        int timeoutValue = 10000;//ms 
		        String orgImgUrl = request.getParameter("url").trim();
	//	      System.out.println("[getWebImg] orgImgUrl : "+ orgImgUrl );
	
		        int pos = orgImgUrl.lastIndexOf( "." );
		        String imgFileExt = orgImgUrl.substring( pos + 1 ).toLowerCase();
		        orgImgUrl = java.net.URLDecoder.decode(orgImgUrl, "UTF-8");
		  
		//connection - real data request
		        URL tmpURL = new URL(orgImgUrl);
		        con = (HttpURLConnection)tmpURL.openConnection();
		        con.setConnectTimeout(timeoutValue);
		        con.setReadTimeout(timeoutValue);
		        con.setRequestMethod("GET");
	
		//connection - real data response
		        InputStream inReq = con.getInputStream();//응답 전체, InputStream = 요청
	
		//make response body                
		        ByteArrayOutputStream outRes = new ByteArrayOutputStream();//br =OutputStream = 응답
		        byte[] tmpBuf = new byte[  1024 * 8] ;//8KB
	
		        int readLen = 0;
		        while((readLen = inReq.read(tmpBuf)) != -1)        
		        {
		            outRes.write(tmpBuf,0,readLen);
		        }
	
		        byte[] imgBuf = null;
		        imgBuf = outRes.toByteArray();//??
		        outRes.close();
		        inReq.close();    
	
		//make response header
		        //contentType set
		        String contentType = "";
				
				//image file
				if(imgFileExt.equals("gif")) {
					contentType = "image/gif";
				}
				else if(imgFileExt.equals("png")) {
					contentType = "image/png";
				}
				else if(imgFileExt.equals("jpg") || imgFileExt.equals("jpeg")) {
					contentType = "image/jpeg";
				}
				else if(imgFileExt.equals("bmp")) {
					contentType = "image/bmp";
				}
				//video file
				else if(imgFileExt.equals("mp4")) {
					contentType = "video/mp4";
				}
				else if(imgFileExt.equals("webm")) {
					contentType = "video/webm";
				}
				else if(imgFileExt.equals("ogg")) {
					contentType = "video/ogg";
				}
		        else 
		        {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					return null;
		        }
		        
		        int length = imgBuf.length;   
	
		        //header set
		        response.reset() ;
		        response.setContentType(contentType);
		        response.setContentLength(length);
	
		        //out
		        OutputStream os = response.getOutputStream();    
		        os.write(imgBuf , 0, length);
		        os.close();   
    		} catch(Exception e){
    			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
    		}finally{
    			if(con!=null) {//Null Pointer 역참조
    			con.disconnect();
    			}
    		}    		
	        return null;
    	}
    }
	
	
	
	
	//문자 인코딩 체크
    public static boolean charLength(byte[] bytes) {
        int expectedLen;

        for (int i = 0; i < bytes.length; i++) {
            // Lead byte analysis
            if ((bytes[i] & Integer.parseInt("10000000", 2)) == Integer.parseInt("00000000", 2)) {
                continue;
            } else if ((bytes[i] & Integer.parseInt("11100000", 2)) == Integer.parseInt("11000000", 2)) {
                expectedLen = 2;
            } else if ((bytes[i] & Integer.parseInt("11110000", 2)) == Integer.parseInt("11100000", 2)) {
                expectedLen = 3;
            } else if ((bytes[i] & Integer.parseInt("11111000", 2)) == Integer.parseInt("11110000", 2)) {
                expectedLen = 4;
            } else if ((bytes[i] & Integer.parseInt("11111100", 2)) == Integer.parseInt("11111000", 2)) {
                expectedLen = 5;
            } else if ((bytes[i] & Integer.parseInt("11111110", 2)) == Integer.parseInt("11111100", 2)) {
                expectedLen = 6;
            } else {
                return false;
            }

            while (--expectedLen > 0) {
                if (++i >= bytes.length) {
                    return false;
                }
                if ((bytes[i] & Integer.parseInt("11000000", 2)) != Integer.parseInt("10000000", 2)) {
                    return false;
                }
            }
        }
        return true;
    }	
	
	/**
	 * loginVO 체크 파일 다운로드(WEB 용)
	 * @param paramMap
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	@RequestMapping("/cmm/file/fileDownloadProc.do")
    public void fileDownloadProc(HttpServletRequest request, @RequestParam Map<String, Object> paramMap, HttpServletResponse response){

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();

		//게시판 외부계정 예외처리
		if(loginVO == null && request.getSession().getAttribute("sess_out_mbr") != null && request.getSession().getAttribute("sess_out_mbr").equals("Y") ) {
			loginVO = (LoginVO)request.getSession().getAttribute("userInfo");
		}

		if (loginVO == null || paramMap.get("fileId") == null || paramMap.get("fileId").equals("")) {
			return;
		}
		
		paramMap.put("groupSeq", loginVO.getGroupSeq());
		
		Map<String, Object> fileMap = new HashMap<String, Object>();
		
		String pathSeq = "1100";
		
		//모듈별 공통 필수 변수
		File file = null;
		FileInputStream fis = null;

		String drmPath = "";
		String path = "";
		String fileNameWithoutExt = "";
		String fileName = "";
		String orignlFileName = "";
		String fileExtsn = "";
		String imgExt = "jpeg|bmp|gif|jpg|png";
		String metaDataImgExt = "jpeg|jpg";
		String applicationExt = "pdf";
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		//게시판
		if(paramMap.get("moduleTp") != null && paramMap.get("moduleTp").toString().equals("board")){			
			paramMap.put("uploadPath", BizboxAProperties.getEdmsProperty("UPLOAD_PATH"));
			
			fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBoard", paramMap);

			if (fileMap == null) {
				return;
			}
			
			fileMap.put("fileExtsn", fileMap.get("fileExtsn").toString().toLowerCase());
			path = fileMap.get("filePath") + "";
			fileNameWithoutExt = fileMap.get("streFileName") + "";
			fileName = fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
			orignlFileName = fileMap.get("oriFileName") + "";
			fileExtsn = fileMap.get("fileExtsn") + "";
			
			if(!new File(fileMap.get("fileFullPath") + "").isFile() && new File(fileMap.get("fileFullPathMig") + "").isFile()){
				path = fileMap.get("filePathMig").toString();
			}			
			
			//suite->alpha 마이그레이션 데이터의 경우 첨부파일 확장자가 존재하지 않을 수 있기때문에 파일 미존재시 확장자 제거
			File f = new File(path + File.separator + fileName);
			if (!f.isFile()) {
		      fileName = fileMap.get("streFileName").toString();
		    }
		}
		//문서
		else if(paramMap.get("moduleTp") != null && paramMap.get("moduleTp").toString().equals("doc")){
			paramMap.put("uploadPath", BizboxAProperties.getEdmsProperty("UPLOAD_PATH"));
			fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDoc", paramMap);
			
			if (fileMap == null) {
				return;
			}
			
			fileMap.put("fileExtsn", fileMap.get("fileExtsn").toString().toLowerCase());
			path = fileMap.get("filePath") + "";
			fileNameWithoutExt = fileMap.get("streFileName") + "";
			fileName = fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
			orignlFileName = fileMap.get("oriFileName") + "";
			fileExtsn = fileMap.get("fileExtsn") + "";
			
			//suite->alpha 마이그레이션 데이터의 경우 첨부파일 확장자가 존재하지 않을 수 있기때문에 파일 미존재시 확장자 제거
			File f = new File(path + File.separator + fileName);
			if (!f.isFile()) {
		      fileName = fileMap.get("streFileName").toString();
		    }
		}
		//문서(기존문서)
		else if(paramMap.get("moduleTp") != null && paramMap.get("moduleTp").toString().equals("doc_old")){
			paramMap.put("uploadPath", BizboxAProperties.getEdmsProperty("UPLOAD_PATH"));
			fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoDocOld", paramMap);
			
			if (fileMap == null) {
				return;
			}
			
			fileMap.put("fileExtsn", fileMap.get("fileExtsn").toString().toLowerCase());
			path = fileMap.get("filePath") + "";
			fileNameWithoutExt = fileMap.get("streFileName") + "";
			fileName = fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
			orignlFileName = fileMap.get("oriFileName") + "";
			fileExtsn = fileMap.get("fileExtsn") + "";
			
			//suite->alpha 마이그레이션 데이터의 경우 첨부파일 확장자가 존재하지 않을 수 있기때문에 파일 미존재시 확장자 제거
			File f = new File(path + File.separator + fileName);
			if (!f.isFile()) {
		      fileName = fileMap.get("streFileName").toString();
		    }
		}		
		//문서(이관문서)
		else if(paramMap.get("moduleTp") != null && paramMap.get("moduleTp").toString().equals("bpm")){
			paramMap.put("uploadPath", BizboxAProperties.getEdmsProperty("UPLOAD_PATH"));
			fileMap = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathInfoBpm", paramMap);
			
			if (fileMap == null) {
				return;
			}
			
			fileMap.put("fileExtsn", fileMap.get("fileExtsn").toString().toLowerCase());
			path = fileMap.get("filePath") + "";
			fileNameWithoutExt = fileMap.get("streFileName") + "";
			fileName = fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
			orignlFileName = fileMap.get("oriFileName") + "";
			fileExtsn = fileMap.get("fileExtsn") + "";
		}
		//gw로직
		else{			
			/** 첨부파일 상세정보 조회 */
		 	fileMap = attachFileService.getAttachFileDetail(paramMap);
		 	
		 	if (fileMap == null) {
		 		return;
		 	}
		 	
		 	pathSeq = fileMap.get("pathSeq")+"";
		 	
		 	String imgSizeType = String.valueOf(paramMap.get("imgSizeType"));
	
		 	/** 절대경로 조회 */
		 	paramMap.put("pathSeq", pathSeq);
		 	paramMap.put("osType", NeosConstants.SERVER_OS);
		 	Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);
		 	
		 	path = groupPahtInfo.get("absolPath") + File.separator + (fileMap.get("fileStreCours") == null ? "" : fileMap.get("fileStreCours"));
		 	fileNameWithoutExt = fileMap.get("streFileName") + "";
		 	fileName =  fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
		 	orignlFileName = fileMap.get("orignlFileName") + "." + fileMap.get("fileExtsn");
	
			if (fileMap == null) {
				return;
			}
			
			fileExtsn = String.valueOf(fileMap.get("fileExtsn"));
			
			if (!EgovStringUtil.isEmpty(imgSizeType) && imgExt.indexOf(fileExtsn.toLowerCase()) != -1) {
				
				String fileNamethum = fileMap.get("streFileName") + "_"+imgSizeType+"." + fileMap.get("fileExtsn");
				
				/** 파일이 없을경우 원본 이미지 리턴하도록 */
				File f = new File(path + File.separator + fileNamethum);
				if (f.isFile()) {
					fileName = fileNamethum;
				}
			}
		}
		
		try {
			//DRM 체크
			drmPath = drmService.drmConvert(paramMap.get("inlineView") != null && paramMap.get("inlineView").toString().equals("Y") ? "V" : "D", paramMap.get("groupSeq") != null ? paramMap.get("groupSeq").toString() : "", pathSeq, path, fileNameWithoutExt, fileExtsn);
			//System.out.println("drmPath: " + drmPath);
			
			file = new File(drmPath);
		    fis = new FileInputStream(file);

		    String browser = request.getHeader("User-Agent");

		    //파일 인코딩
		    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
		    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
		    } 
		    else {
		    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
		    }
		    
		    String type = "";
		    
			if (fileExtsn != null && !fileExtsn.equals("")) {
				//이미지 컨텐츠타입 설정
				if(imgExt.indexOf(fileExtsn.toLowerCase()) != -1){
					
					if(fileExtsn.toLowerCase().equals("jpg")){
						type = "image/jpeg";
					}else{
						type = "image/" + fileExtsn.toLowerCase();
					}
					
					if(metaDataImgExt.indexOf(fileExtsn.toLowerCase()) != -1) {
					
						//					atf = calcImgFileOrientation(file);
					}
					
					response.setHeader("Cache-Control", "public, max-age=2592000");
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

		    if(paramMap.get("inlineView") != null && paramMap.get("inlineView").toString().equals("Y")){
		    	
		    	if(!type.equals("")) {
					//Inline View
			    	response.setHeader("Content-Disposition","inline;filename=\"" + orignlFileName+"\"");
		    	}else {
		    		//비정상 접근 또는 첨부파일 오류
		    		return;
		    	}
		    	
		    }else{
		    	//Attach Download
		    	response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
		    }

		    
		    if(Integer.MAX_VALUE >= file.length()) {
		    	response.setContentLength((int) file.length());
		    }else {		    	
		    	response.addHeader("Content-Length",Long.toString(file.length()));
		    }

//		    if(imgExt.indexOf(fileExtsn.toLowerCase()) != -1){
//		    	fis.close();
//		    	fis = saveRotateImgFileAndReadFile(file, fis, atf, drmPath, fileExtsn);
//		    }

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
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
			
			// DRM 임시파일(폴더포함) 삭제
			//Null Pointer 역참조
			if(file!=null && file.exists() && drmPath.contains("drmDecTemp") && !path.contains("drmDecTemp")) {
				
				String dirPath = file.getParent();
				if(file.delete()) {
					file = new File(dirPath);
					if(file.isDirectory()) {
						file.delete();	
					}
				}
			}
			
		}
    }
	
	@RequestMapping("/cmm/file/profileUploadProc.do")
    public ModelAndView profileUploadProc(MultipartHttpServletRequest multiRequest, @RequestParam Map<String,Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		/** return 메세지 설정 */
		Map<String,Object> messageMap = new HashMap<String,Object>();
		messageMap.put("mKey", "resultMessage");
		messageMap.put("cKey", "resultCode");
		messageMap.put("codeHead", "systemx.attach.");
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String empSeq = paramMap.get("empSeq") + "";		
		
		if(EgovStringUtil.isEmpty(empSeq) && loginVO != null) {
			empSeq = loginVO.getUniqId();
		}
		
		if(loginVO != null) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
		}
		
		/** 파일 체크  */
		Map<String, MultipartFile> files = multiRequest.getFileMap();
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		
		if(files.isEmpty()) {
			messageMap.put("code", "AF0030");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;			
		}
		else if(paramMap.get("imgConvertYn") == null || paramMap.get("imgConvertYn").equals("N")) {
			
			boolean fileExtCheck = false;
			
			while (itr.hasNext()) {
				Entry<String, MultipartFile> entry = itr.next();
				String orginFileName = entry.getValue().getOriginalFilename();
				int index = orginFileName.lastIndexOf(".");
				String fileExt = orginFileName.substring(index + 1);
				if ("jpeg|bmp|gif|jpg|png|tif|tiff".indexOf(fileExt.toLowerCase()) == -1) {
					fileExtCheck = true;
				}
			}
			
			if (fileExtCheck || files.isEmpty()) {
				messageMap.put("code", "AF0030");
				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
				return mv;
			}			
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
		// 프로필 이미지
		if(pathSeq.equals("910")) {
			relativePath = File.separator + paramMap.get("groupSeq");
		}
		
		/** File Id 생성(성공시 return) */
		paramMap.put("value", "atchfileid");
		String fileId = sequenceService.getSequence(paramMap);
		
		
		
		/** 입사처리 페이지에서 등록한 프로필 사진인 경우 t_co_emp file_id 업데이트 */
		String empFlag = paramMap.get("empSeq") + "";
		if(!EgovStringUtil.isEmpty(empFlag)){
			if((paramMap.get("imgSeq")+"").equals("profile")){
				Map<String, Object> empMap = new HashMap<String, Object>();
				empMap.put("empSeq", empFlag);
				empMap.put("imgSeq", paramMap.get("imgSeq"));
				empMap.put("fileId", fileId);
				
				empManageService.updateEmpPicFileId(empMap);
			}				
		}
		
		/** save file */
		int fileSn = 0; 																	// 파일 순번
		List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();		// 파일 저장 리스트
		Map<String,Object> newFileInfo = null;
		String path = rootPath + File.separator + relativePath;								// 저장 경로
		long size = 0L;																		// 파일 사이즈
		MultipartFile file = null;
		itr = files.entrySet().iterator();
		
		// 파일마다 새로운 file id로 생성할것인가..
		boolean isNewId = paramMap.get("isNewId") != null && paramMap.get("isNewId").equals("true");

		while (itr.hasNext()) {
			Entry<String, MultipartFile> entry = itr.next();
			file = entry.getValue();
			String orginFileName = file.getOriginalFilename();								// 원본 파일명

			/* 확장자 */
			int index = orginFileName.lastIndexOf(".");
			if (index == -1) {
				continue;
			}
			
			String fileExt = orginFileName.substring(index + 1);
			orginFileName = orginFileName.substring(0, index);
			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
			String imgExt = "jpeg|bmp|gif|jpg|png";
			
			if (imgExt.indexOf(fileExt.toLowerCase()) != -1 && pathSeq.equals("910")) {					// 프로필 사진이면 png 저장
				fileExt = "jpg"; 
			}

			if(pathSeq.equals("910")) {														// 프로필 사진이면 empSeq 파일명으로 저장// direct 접근하기 위해
				newName = empSeq;
			}
			
			String saveFilePath = path+File.separator+newName+"."+fileExt;
			
			size = EgovFileUploadUtil.saveFile(file.getInputStream(), new File(saveFilePath));
			
			//DRM 체크
			drmService.drmConvert("U", paramMap.get("groupSeq").toString(), pathSeq, path, newName, fileExt);
			
			/** 이미지일때 썸네일 이미지 저장
			 *  파일명_small.확장자
			 *  */
			try{
				if (imgExt.indexOf(fileExt) != -1) {
					String imgSizeType = "thum";			//일단 썸네일 사이즈만
					int imgMaxWidth = 420;
					ImageUtil.saveResizeImage(new File(path+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth);
				}
			}catch(Exception e){
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				//System.out.println("## ImageUtil.saveResizeImage Error : 썸네일이미지 생성 오류");
			}
			
			//System.out.println("## size : " + size);
			
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
				newFileInfo.put("createSeq", loginVO.getUniqId());
				newFileInfo.put("inpName", file.getName());
				saveFileList.add(newFileInfo);
				fileSn++;
			}
			
			/** field id를 파일별로 다른경우 */
			if(isNewId) {
				paramMap.put("value", "atchfileid");
				fileId = sequenceService.getSequence(paramMap);
				fileSn = 0;
			}
			
		}
		
		/** 파일 저장 리스트 확인 */
		if (saveFileList.size() < 1) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		}
		
		/** DB Insert */
		List<Map<String,Object>> resultFileIdList = attachFileService.insertAttachFile(saveFileList);
		
		/** insert 결과 체크 */
		if(resultFileIdList == null || resultFileIdList.size() == 0) {
			messageMap.put("code", "AF0090");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			return mv;
		} else {
			messageMap.put("code", "SUCCESS");
			MessageUtil.setApiMessage(mv, multiRequest, messageMap);
		}
		
		/** field id를 파일별로 다른경우 */
		if (isNewId) {
			StringBuffer sb = new StringBuffer();
			for(int i = 0; i < resultFileIdList.size(); i++) {
				Map<String,Object> m = resultFileIdList.get(i);
				sb.append(m.get("inpName")+"");
				sb.append("|");
				sb.append(m.get("fileId")+"");
				if (i < resultFileIdList.size()-1) {
					sb.append(";");
				}
			}
			
			mv.addObject("fileList", sb.toString());
		} 
		/** 일반적인 경우 fileId만 리턴 */
		else {
			if (resultFileIdList != null && resultFileIdList.size() > 0) {
				mv.addObject("fileId", resultFileIdList.get(0).get("fileId"));
			} else {
				mv.addObject("fileId", null);
			}
		}
		
		//프로필 이미지 FTP 전송
		if(!EgovStringUtil.isEmpty(empFlag)){
			orgAdapterService.ftpProfileSync(paramMap);
		}
		
		String datatype = paramMap.get("dataType")+"";
		if (EgovStringUtil.isEmpty(datatype)||datatype.equals("json")) {
			mv.setViewName("jsonView");
		} 
		else if (datatype.equals("page")) {
			
			mv.setViewName("redirect:"+paramMap.get("page")+"?"+CommonUtil.getUrlParameter(paramMap));
		}
		//페이지명
		else {
			mv.setViewName(datatype);
		}
		
		
		return mv;
	}
	
	@RequestMapping("/cmm/file/profileConvert.do")
    public ModelAndView profileConvert(HttpServletRequest multiRequest, @RequestParam Map<String,Object> paramMap) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("result", attachFileService.profileConvert(paramMap));
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	@RequestMapping("/FileAttach.do")
	public ModelAndView FileAttachProc(MultipartHttpServletRequest multiRequest, @RequestParam Map<String,Object> params) throws Exception {
		
		Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do start.... params : " + params );
		
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		String fileId = "";		
		boolean isNew = false;
		
		if(!params.containsKey("fileId") || !params.get("fileId").toString().isEmpty()){
			fileId = params.get("fileId").toString();
			isNew = false;
		}else {
			isNew = true;
		}				
		
		try{
			
			/** 파일 체크  */
			Map<String, MultipartFile> files = multiRequest.getFileMap();
						
			if(params.containsKey("file0") && files.isEmpty()){
				int cnt = Integer.parseInt(params.get("attFileCnt").toString()); 
				
				for(int i=0;i<cnt;i++){
					String fileInfo = params.get("file" + i).toString();
					String filePath = fileInfo.split("\\|")[0];
					String fileNm = fileInfo.split("\\|")[1];
					
					if(fileNm != null && !"".equals(fileNm)) {//경로 조작 및 자원 삽입
						fileNm = fileNm.replaceAll("", "");
					}
					
					File file = new File(filePath + "/" + fileNm);
				    FileInputStream input = new FileInputStream(file);
				    MultipartFile multipartFile = new MockMultipartFile("file" + i,file.getName(), "text/plain", IOUtils.toByteArray(input));
				    files.put("file" + i, multipartFile);
				}
			}
			
			if (files.isEmpty() && isNew) {		
					mv.addObject("params", params);
					return mv;
			}
			
			/** 파일 ROOT 경로 체크 */
			String pathSeq = params.get("pathSeq")+"";
			if (StringUtils.isEmpty(pathSeq)) {
				mv.addObject("params", params);
				return mv;
			}
			
			/** 그룹 경로설정 조회 */			
			String osType = NeosConstants.SERVER_OS;
			if(StringUtils.isEmpty(osType)){
				mv.addObject("params", params);
				return mv;
			}

			params.put("osType", osType);
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> pathList = commonSql.list("AttachFileUpload.selectGroupPathList", params);
			if (pathList == null || pathList.size() < 1) {
				mv.addObject("params", params);
				return mv;
			}			
			
			Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do pathList : " + pathList );
						
			/** 파일 절대경로 조회 */
			String rootPath = null;
			for(Map<String,Object> path : pathList) {
				String ps = path.get("pathSeq")+"";
				if (ps.equals(pathSeq)) {
					rootPath = path.get("absolPath")+"";
				}
			}
			if (StringUtils.isEmpty(rootPath)) {
				mv.addObject("params", params);
				return mv;
			}
		    
		    /** 상대경로 */
			String relativePath = params.get("relativePath")+"";
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
			int fileSn = 0; 																	// 파일 순번
			if(isNew){
				Map<String, Object> mp = new HashMap<String, Object>();
				mp.put("groupSeq", params.get("groupSeq"));
				fileId = (String) commonSql.select("AttachFileUpload.getAttchFileId", mp);		
			}else{
				fileSn = (int)commonSql.select("AttachFileUpload.selectAttachFileMaxSn",params) + 1;
			}
			
			Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do fileId, fileSn : " + fileId + ", " + fileSn );
			
			/** save file */
			Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();			
			List<Map<String,Object>> saveFileList  = new ArrayList<Map<String,Object>>();			// 파일 저장 리스트
					
			Map<String,Object> newFileInfo = null;			
			String path = rootPath + File.separator + relativePath;								// 저장 경로
			
			//디렉토리 생성 
			File desti = new File(path);
			
			if(!desti.exists()){
				desti.mkdirs();
			}
			
			long size = 0L;																		// 파일 사이즈
			MultipartFile file = null;
			
			List<Map<String, Object>> fileListMap = new ArrayList<Map<String, Object>>();
			while (itr.hasNext()) {
				
				Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do itr.hasNext() : " + itr.hasNext() );
				
				Map<String, Object> mp = new HashMap<>();
				Entry<String, MultipartFile> entry = itr.next();
				file = entry.getValue();
									
				/* 원본 파일명 */
				String orginFileName = file.getOriginalFilename();
				/* 확장자 */
				int index = orginFileName.lastIndexOf(".");
				
				//제한확장자설정			
				String[] extArr = {"asa","asp","cdx","cer","htr","aspx","jsp","jspx","html","htm","php","php3","php4","php5"};
				String extension = FilenameUtils.getExtension(file.getOriginalFilename()).toLowerCase();
				if(checkExtension(extension, extArr)) {	
					mv.addObject("params", params);
					return mv;
				}
				
				if (index == -1) {
					//확장자 없을경우 리턴
					mv.addObject("params", params);
					return mv;
				}
				
				String fileExt = orginFileName.substring(index + 1);
				orginFileName = orginFileName.substring(0, index);
				
				String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
				String saveFilePath = path+File.separator+newName+"."+fileExt;				
				file.transferTo(new File(saveFilePath));
				size = file.getSize();
				
				
				Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do saveFilePath : " + saveFilePath );
				
				//파수DRM연동 사용시 복호화작업
				drmService.drmConvert("U", params.get("groupSeq") == null ? "" : params.get("groupSeq").toString(), pathSeq, path, newName, fileExt);

				/** 이미지일때 썸네일 이미지 저장
				 *  파일명_small.확장자
				 *  */
				try{
					String imgExt = "jpeg|bmp|gif|jpg|png";
					if (imgExt.indexOf(fileExt.toLowerCase()) != -1) {
						String imgSizeType = "thum";			//일단 썸네일 사이즈만
						int imgMaxWidth = 420;
						ImageUtil.saveResizeImage(new File(path+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth);
					}
				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					//System.out.println("## ImageUtil.saveResizeImage Error : 썸네일이미지 생성 오류");
				}
				
				Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do size : " + size );
				
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
					//newFileInfo.put("createSeq", paramMap.get("empSeq"));
					newFileInfo.put("createSeq", params.get("empSeq"));
					
					saveFileList.add(newFileInfo);
					
					mp.put("fileId", fileId);
					mp.put("orginFileName", orginFileName);
					mp.put("fileSn", fileSn++);
					mp.put("fileExt", fileExt);
					mp.put("fileSize", size);
					
					fileListMap.add(mp);
				}				
				
			}
			
			/** 파일 저장 리스트 확인 */
			if (saveFileList.size() < 1 && isNew) {
				mv.addObject("params", params);
				return mv;
			}
			
			/** DB Insert   (공통 파일관련 테이블) */
			String resultFileId = null;				
			if(isNew){
				//신규 등록 (t_co_atch_file,t_co_atch_file_detail)
				resultFileId = attachFileService.insertAttachFileInfo(saveFileList);
			}else{
				//수정 등록 (t_co_atch_file_detail)
				
				//# 수정화면 첨부파일 추가
				if(saveFileList.size() > 0){
					resultFileId = attachFileService.insertAttachFileInfo(saveFileList);
				}
				
			}
						
			Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do resultFileId : " + resultFileId );
			
			
			/** insert 결과 체크 */
			if(StringUtils.isEmpty(resultFileId)) {
				mv.addObject("params", params);
				return mv;
			} else {
//				messageMap.put("code", "SUCCESS");
//				MessageUtil.setApiMessage(mv, multiRequest, messageMap);
			}
			
			params.put("fileListMap", fileListMap);
						
			
		} catch(Exception e) {
			Logger.getLogger( WebAttachFileController.class ).error( "WebAttachFileController.FileAttach.do Exception!!!!!!! " );
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		Logger.getLogger( WebAttachFileController.class ).debug( "WebAttachFileController.FileAttach.do params : " + params );

		
		mv.addObject("params", params);
		return mv;		
	
	}
	
	
	
	
	
	
	/**
	 * 인사기록카드 pdf뷰어용
	 * @param paramMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("/cmm/file/personnelCardPdfViewer.do")
    public void cmmPdfViewerProc(HttpServletRequest request, @RequestParam Map<String, Object> paramMap, HttpServletResponse response){

		String fileId = paramMap.get("fileId").toString();
		String groupSeq = "";
		String empSeq = "";
		String compSeq = "";
		String userSe = "";
		boolean masterAuth = false;
		
		if(paramMap.get("isRestFul") != null && paramMap.get("isRestFul").toString().equals("Y")){
			//api호출시 보내주는 파라미터로 대처 (모바일/메신저()
			groupSeq = paramMap.get("groupSeq") == null ? "" : paramMap.get("groupSeq").toString();
			empSeq = paramMap.get("empSeq") == null ? "" : paramMap.get("empSeq").toString();
			compSeq = paramMap.get("compSeq") == null ? "" : paramMap.get("compSeq").toString();
			userSe = "USER";
		}else{		
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			if(loginVO != null){
				groupSeq = loginVO.getGroupSeq();
				empSeq = loginVO.getUniqId();
				compSeq = loginVO.getOrganId();
				userSe = loginVO.getUserSe();
				
				paramMap.put("groupSeq", groupSeq);
			}
		}
		
		//인사기록카드 마스터조회권한 조회
		paramMap.put("empSeq", empSeq);
		paramMap.put("groupSeq", groupSeq);
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> authList = commonSql.list("GroupManage.getPerssonelCardMasterAuth", paramMap);
		for(Map<String, Object> mp : authList){
			if(mp.get("empSeq").toString().equals(paramMap.get("empSeq").toString())){
				masterAuth = true;
				break;
			}
		}
		
		
		
		
		if(!masterAuth){		
			//인사기록카드 열람 권한있는지 추가조회가 필요.
			//필요 파라미터  (fileId, groupSeq, empSeq, compSeq, userSe)	
			paramMap.put("fileId", fileId);
			paramMap.put("groupSeq", groupSeq);
			paramMap.put("empSeq", empSeq);
			paramMap.put("compSeq", compSeq);
			paramMap.put("userSe", userSe);
			boolean isAuth = attachFileService.checkPersonnelCardAuth(paramMap);
			
			if(!isAuth) {
				return;
			}
				
		}
	
		
		
		//인사기록카드 정보조회
		@SuppressWarnings("unchecked")
		Map<String, Object> myCard = (Map<String, Object>) commonSql.select("AttachFileUpload.getPersonnelCardInfo", paramMap);
		
		
		//인사기록카드 조회 이력관리 테이블 정보 저장.
		Map<String, Object> historyMap = new HashMap<String, Object>();
		historyMap.put("groupSeq", groupSeq);
		historyMap.put("empSeq", empSeq);
		historyMap.put("targetEmpSeq", myCard.get("empSeq"));
		historyMap.put("fileId", fileId);
		
		commonSql.insert("AttachFileUpload.InsertPersonnelCardHistoryInfo", historyMap);
		
		File file = null;
		FileInputStream fis = null;
		
		String path = "";
		String fileName = "";
		String orignlFileName = "";
		String fileExtsn = "";
		String imgExt = "jpeg|bmp|gif|jpg|png";
		String applicationExt = "pdf";
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		
		/** 첨부파일 상세정보 조회 */
		Map<String, Object> fileMap = new HashMap<String, Object>();
	 	fileMap = attachFileService.getAttachFileDetail(paramMap);
	 	
	 	if (fileMap == null) {
	 		return;
	 	}
	 	
	 	String pathSeq = fileMap.get("pathSeq")+"";

	 	/** 절대경로 조회 */
	 	paramMap.put("pathSeq", pathSeq);
	 	paramMap.put("osType", NeosConstants.SERVER_OS);
	 	Map<String, Object> groupPahtInfo = groupManageService.selectGroupPath(paramMap);
	 	
	 	
	 	path = groupPahtInfo.get("absolPath") + File.separator + fileMap.get("fileStreCours");
	 	fileName =  fileMap.get("streFileName") + "." + fileMap.get("fileExtsn");
	 	orignlFileName = fileMap.get("orignlFileName") + "." + fileMap.get("fileExtsn");

		fileExtsn = String.valueOf(fileMap.get("fileExtsn"));
		try {			

			file = new File(path + File.separator + fileName);
			
		    fis = new FileInputStream(file);

		    String browser = request.getHeader("User-Agent");
		    
		    //파일 인코딩
		    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
		    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
		    } 
		    else {
		    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
		    }
		    
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
		    
			//Inline View
	    	response.setHeader("Content-Disposition","inline;filename=\"" + orignlFileName+"\"");

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
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			//System.out.println(e.getMessage());
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
	
	
	
	public boolean checkAuth(int type){
		//type (0)  => 메뉴권한 조회(사용자 - 인사기록카드(본인))
		//type (1)  => 메뉴권한 조회(사용자 - 인사기록카드(권한))
		//type (2)  => 메뉴권한 조회(관리자 - 인사기록카드(전사))
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("empSeq", loginVO.getUniqId());
		params.put("compSeq", loginVO.getOrganId());
		
		if(type == 0){
			params.put("menuNo", "707060000");
		}else if(type == 1){
			params.put("menuNo", "707070000");
		}else if(type == 2){
			params.put("menuNo", "932060000");
		}
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> authList = commonSql.list("AttachFileUpload.getPersonnelCardMenuAuth", params);
		if(authList.size() > 0) {
			return true;
		}
		else {
			return false;
		}
			
	}
	
	public LoginVO checkLoginVO(HttpServletRequest request){
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(loginVO == null && request.getSession().getAttribute("bizboxa_oneffice_emp_seq") != null){
			LoginVO tempVO = new LoginVO();
			try{
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("empSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[1]);
				params.put("groupSeq", request.getSession().getAttribute("bizboxa_oneffice_emp_seq").toString().split("▦")[2]);
				
				@SuppressWarnings("unchecked")
				Map<String, Object> userInfo = (Map<String, Object>) commonSql.select("OnefficeDao.getUserInfo", params);
				
				tempVO.setGroupSeq(userInfo.get("group_seq").toString());
				tempVO.setUniqId(userInfo.get("emp_seq").toString());
				tempVO.setLangCode(userInfo.get("lang_code").toString());
				tempVO.setOrganId(userInfo.get("comp_seq").toString());
				tempVO.setCompSeq(userInfo.get("comp_seq").toString());
			}catch(Exception e){
				tempVO = null;
			}
			loginVO = tempVO;
		}
		
		return loginVO;
	}
	
	public AffineTransform calcImgFileOrientation(File imageFile) {
		
		int orientation = 1; // 회전정보, 1. 0도, 3. 180도, 6. 270도, 8. 90도 회전한 정보 
		int width = 0; // 이미지의 가로폭
		int height = 0; // 이미지의 세로높이 
		int tempWidth = 0; // 이미지 가로, 세로 교차를 위한 임의 변수 
		Metadata metadata; // 이미지 메타 데이터 객체 
		Directory directory; // 이미지의 Exif 데이터를 읽기 위한 객체 
		JpegDirectory jpegDirectory; // JPG 이미지 정보를 읽기 위한 객체
		
		try {
			metadata = ImageMetadataReader.readMetadata(imageFile);
			directory = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
			jpegDirectory = metadata.getFirstDirectoryOfType(JpegDirectory.class);
			if(directory != null){
				orientation = directory.getInt(ExifIFD0Directory.TAG_ORIENTATION); // 회전정보
				width = jpegDirectory.getImageWidth(); // 가로
				height = jpegDirectory.getImageHeight(); // 세로
			}
			
			// 3. 변경할 값들을 설정한다.
		    AffineTransform atf = new AffineTransform();
		    //System.out.println("orientation: " + orientation);
		    switch (orientation) {
		    case 1:
		        break;
		    case 2: // Flip X
		    	atf.scale(-1.0, 1.0);
		    	atf.translate(-width, 0);
		        break;
		    case 3: // PI rotation 
		    	atf.translate(width, height);
		    	atf.rotate(Math.PI);
		        break;
		    case 4: // Flip Y
		    	atf.scale(1.0, -1.0);
		    	atf.translate(0, -height);
		        break;
		    case 5: // - PI/2 and Flip X
		    	atf.rotate(-Math.PI / 2);
		    	atf.scale(-1.0, 1.0);
		        break;
		    case 6: // -PI/2 and -width
		    	atf.translate(height, 0);
		    	atf.rotate(Math.PI / 2);
		        break;
		    case 7: // PI/2 and Flip
		    	atf.scale(-1.0, 1.0);
		    	atf.translate(-height, 0);
		    	atf.translate(0, width);
		    	atf.rotate(  3 * Math.PI / 2);
		        break;
		    case 8: // PI / 2
		    	atf.translate(0, width);
		    	atf.rotate(  3 * Math.PI / 2);
		        break;
			default:
			    break;			        
		    }
		    
		    switch (orientation) {
			case 8:
		        tempWidth = width;
		        width = height;
		        height = tempWidth;
				break;
			default:
			    break;				
			}
		    
		    return atf;
			
		} catch (ImageProcessingException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (MetadataException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IOException e) {
			//System.out.println("WebAttachFileController calcImgFileOrientation error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;

	}
	
	public FileInputStream saveRotateImgFileAndReadFile(File imgFile, FileInputStream fis, AffineTransform atf, String drmPath, String fileExtsn) {
		
		try {
			BufferedImage image = ImageIO.read(imgFile);
			final BufferedImage afterImage = new BufferedImage(3000, 3000, image.getType());
			final AffineTransformOp rotateOp = new AffineTransformOp(atf, AffineTransformOp.TYPE_BILINEAR);
			final BufferedImage rotatedImage = rotateOp.filter(image, afterImage);
			Iterator<ImageWriter> iter = ImageIO.getImageWritersByFormatName(fileExtsn);
		    ImageWriter writer = iter.next();
		    ImageWriteParam iwp = writer.getDefaultWriteParam();
		    iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
		    iwp.setCompressionQuality(1.0f);

		    // 4. 회전하여 생성할 파일을 만든다.
		    File outFile = new File(drmPath);
		    FileImageOutputStream fios = new FileImageOutputStream(outFile);
		    
		    // 5. 원본파일을 회전하여 파일을 저장한다.
		    writer.setOutput(fios);
		    writer.write(null, new IIOImage(rotatedImage ,null,null),iwp);
		    fios.close();
		    writer.dispose();
		    fis.close();
		    fis = new FileInputStream(outFile);
		    
		    return fis;
		    
		} catch (IOException e) {
			//System.out.println("WebAttachFileController saveRotateImgFileAndReadFile error: " + e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return null;
	}
	
	
	/**
	 * 명렁 실행 
	 * @param command
	 * @return
	 */
	public String executeCommand(String command) {

		StringBuffer output = new StringBuffer();

		Process p;
		BufferedReader reader = null;
		try {
			
			if(command!=null && !"".equals(command)) {//운영체제 명령어 삽입
				command = command.replaceAll("&", "");
				command = command.replaceAll(";", "");
				//throw new IllegalArgumentException("savePath");
		    }
			
			p = Runtime.getRuntime().exec(command);

			reader = new BufferedReader(new InputStreamReader(p.getInputStream()));

            String line = "";			
			while ((line = reader.readLine())!= null) {
				output.append(line);
			}
			

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (reader != null)
				try {
					reader.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
		}
		return output.toString();
	}
	
}
