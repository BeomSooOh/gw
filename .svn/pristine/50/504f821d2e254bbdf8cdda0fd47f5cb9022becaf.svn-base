package neos.cmm.util.file.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.util.NeosConstants;
import neos.cmm.util.file.UploadFileService;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.utl.fcc.service.EgovFormBasedFileUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;

@Service("UploadFileDocService")
public class UploadFileDocServiceImpl implements UploadFileService {

	@Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;

	@Override
	public void upload(List<MultipartFile> files, HttpServletRequest request) throws Exception {
		if(files == null ) {
			return ;
		}
		String fileID = request.getParameter("file_id") ;
		String pFileSize = egovMessageSource.getMessage(fileID+".file.size") ;
		String filePath = egovMessageSource.getMessage(fileID+".file.path."+NeosConstants.SERVER_OS) ;
		String pFileCnt = egovMessageSource.getMessage(fileID+".file.cnt") ;
		String filePermission  = egovMessageSource.getMessage(fileID+".file.permission") ;
		String fileRestrict =  egovMessageSource.getMessage(fileID+".file.restrict") ;
		String dirSeperate = EgovFormBasedFileUtil.SEPERATOR ;
		String fileName = "" ;
		String ext = "" ;
		String distFileName = "" ;

		String[] arrFilePermission = null   ;
		String[] arrFileRestrict = null  ;

		int rowNum = 0 ;
		if( !EgovStringUtil.isEmpty(filePermission)) {
			arrFilePermission = filePermission.split("[|]");
			rowNum  = arrFilePermission.length ;
		}else if (!EgovStringUtil.isEmpty(fileRestrict)) {
			arrFileRestrict = fileRestrict.split("[|]");
			rowNum  = arrFileRestrict.length ;
		}

		int fileSize = 0 ;
		int fileCnt = 0 ;

		if(!EgovStringUtil.isEmpty(pFileSize)) {
			fileSize =  Integer.parseInt(pFileSize);
		}
		if(!EgovStringUtil.isEmpty(pFileCnt)) {
			fileCnt =  Integer.parseInt(pFileCnt);
		}
		boolean  isPermission = false ;

		String path = "" ;
		int uploadFileCnt = 0 ;
		path = (String)request.getAttribute("destFilePath") ;

		//파일체크
		for (MultipartFile file : files) {
			String fileOriginal = file.getOriginalFilename() ;
			if (!file.isEmpty()) {
				uploadFileCnt ++ ;
				if(fileSize >0 && file.getSize()>fileSize){
					return ;
				}
				fileName = file.getOriginalFilename() ;
				ext = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());

				if( arrFilePermission != null ) {
					isPermission = false  ;
					for(int inx = 0 ;  inx < rowNum; inx++ ) {
						if ( arrFilePermission[inx].equalsIgnoreCase(ext) ) {
							isPermission = true ;
							break;
						}
					}
					if(!isPermission ) {
						return ;
					}

				}else if (arrFileRestrict != null ) {
					isPermission = true ;
					for(int inx = 0 ;  inx < rowNum; inx++ ) {
						if ( arrFileRestrict[inx].equalsIgnoreCase(ext) ) {
							isPermission = false ;
							break;
						}
					}
					if(!isPermission ) {
						return ;
					}
				}

			}
		}

		if(fileCnt >0 &&  uploadFileCnt > fileCnt  ) {
			return ;
		}

		File dir =  null ;
		File dest = null ;
		List<Map<String, String>> fileInfoList = new ArrayList<Map<String, String>>();
		Map<String, String>fileInfoMap = null ;

		String srcFileName = "" ;
		String destFileName = "" ;
		String convertFileName = "" ;
		for (MultipartFile file : files) {

			if (!file.isEmpty()) {
				dir = new File(path);
				if (!dir.isDirectory()) {
					dir.mkdirs();
				}
				fileInfoMap = new HashMap<String, String>();

				fileName = file.getOriginalFilename() ;
				ext = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
				srcFileName = fileName.substring(0, fileName.lastIndexOf(".") -1);
				convertFileName =  EgovStringUtil.makeIdentifier() ;
				destFileName = convertFileName+"."+ext;

				filePath = path + dirSeperate + destFileName ; //파일명포함
				dest = new File(filePath);
				file.transferTo(dest);
				fileInfoMap.put("srcFileName", srcFileName);
				fileInfoMap.put("convertFileName", convertFileName);
				fileInfoMap.put("ext", ext);
				fileInfoList.add(fileInfoMap);
			}
		}
		request.setAttribute("fileInfoList", fileInfoList);
		request.setAttribute("path", path);
	}


}
