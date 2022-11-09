package egovframework.com.cmm.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.exp.FileExtUploadException;
import neos.cmm.exp.FileNumberUploadException;
import neos.cmm.exp.FileSizeUploadException;
import neos.cmm.util.CommonUtil;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.EgovWebUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;


/**
 * @Class Name  : EgovFileMngUtil.java
 * @Description : 메시지 처리 관련 유틸리티
 * @Modification Information
 *
 *     수정일         수정자                   수정내용
 *     -------          --------        ---------------------------
 *   2009.02.13       이삼섭                  최초 생성
 *   2011.08.09       서준식                  utl.fcc패키지와 Dependency제거를 위해 getTimeStamp()메서드 추가
 * @author 공통 서비스 개발팀 이삼섭
 * @since 2009. 02. 13
 * @version 1.0
 * @see
 *
 */
@Component("EgovFileMngUtil")
public class EgovFileMngUtil {

    public static final int BUFF_SIZE = 2048;


    @Resource(name = "egovFileIdGnrService")
    private EgovIdGnrService idgenService;

    private static final Logger LOG = Logger.getLogger(EgovFileMngUtil.class.getName());

    /**
     * 첨부파일에 대한 목록 정보를 취득한다.
     *
     * @param files
     * @return
     * @throws Exception
     */
    public List<FileVO> parseFileInf(Map<String, MultipartFile> files, String keyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
	int fileKey = fileKeyParam;

	String storePathString = "";
	String atchFileIdString = "";

	if ("".equals(storePath) || storePath == null) {
	    storePathString = EgovProperties.getProperty("Globals.fileStorePath");
	} else {
		storePathString = EgovProperties.getProperty(storePath);
	}

	if ("".equals(atchFileId) || atchFileId == null) {
	    atchFileIdString = idgenService.getNextStringId();
	} else {
	    atchFileIdString = atchFileId;
	}

	File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));

	if (!saveFolder.exists() || saveFolder.isFile()) {
	    saveFolder.mkdirs();
	}

	Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
	MultipartFile file;
	String filePath = "";
	List<FileVO> result  = new ArrayList<FileVO>();
	FileVO fvo;

	while (itr.hasNext()) {
	    Entry<String, MultipartFile> entry = itr.next();

	    file = entry.getValue();
	    String orginFileName = file.getOriginalFilename();

	    //--------------------------------------
	    // 원 파일명이 없는 경우 처리
	    // (첨부가 되지 않은 input file type)
	    //--------------------------------------
	    if ("".equals(orginFileName)) {
		continue;
	    }
	    ////------------------------------------

	    int index = orginFileName.lastIndexOf(".");
	    String fileExt = orginFileName.substring(index + 1);
	    fileExt = fileExt.toLowerCase() ;
	    String newName = keyStr + getTimeStamp() + fileKey +"."+fileExt ;
	    long psize = file.getSize();

	    if (!"".equals(orginFileName)) {
		filePath = storePathString + File.separator + newName ;
		
		file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
	    }
	    fvo = new FileVO();
	    fvo.setFileExtsn(fileExt);
	    fvo.setFileStreCours(storePathString);
	    fvo.setFileMg(Long.toString(psize));
	    fvo.setOrignlFileNm(orginFileName);
	    fvo.setStreFileNm(newName);
	    fvo.setAtchFileId(atchFileIdString);
	    fvo.setFileSn(String.valueOf(fileKey));

	    //writeFile(file, newName, storePathString);
	    result.add(fvo);

	    fileKey++;
	}

	return result;
    }
    
    /**
     * 첨부파일에 대한 목록 정보를 취득한다.
     *
     * @param files
     * @return
     * @throws Exception
     */
    public List<FileVO> parseFileInfPortal(Map<String, MultipartFile> files, String keyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
	int fileKey = fileKeyParam;

	String storePathString = "";
	String atchFileIdString = "";

	if ("".equals(storePath) || storePath == null) {
	    storePathString = EgovProperties.getProperty("Globals.fileStorePath");
	} else {
		storePathString = storePath;
	//    storePathString = EgovProperties.getProperty(storePath);
	}

	if ("".equals(atchFileId) || atchFileId == null) {
	    atchFileIdString = idgenService.getNextStringId();
	} else {
	    atchFileIdString = atchFileId;
	}

	File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));

	if (!saveFolder.exists() || saveFolder.isFile()) {
	    saveFolder.mkdirs();
	}

	Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
	MultipartFile file;
	String filePath = "";
	List<FileVO> result  = new ArrayList<FileVO>();
	FileVO fvo;

	while (itr.hasNext()) {
	    Entry<String, MultipartFile> entry = itr.next();

	    file = entry.getValue();
	    String orginFileName = file.getOriginalFilename();

	    //--------------------------------------
	    // 원 파일명이 없는 경우 처리
	    // (첨부가 되지 않은 input file type)
	    //--------------------------------------
	    if ("".equals(orginFileName)) {
		continue;
	    }
	    ////------------------------------------

	    int index = orginFileName.lastIndexOf(".");
	    //String fileName = orginFileName.substring(0, index);
	    String fileExt = orginFileName.substring(index + 1);
	    String newName = keyStr + getTimeStamp() + fileKey;
	    long psize = file.getSize();

	    if (!"".equals(orginFileName)) {
		filePath = storePathString + File.separator + newName;
		
		file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
	//	file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath+"."+fileExt)));
	//	System.out.println("::::::::::::::::::: filePath : "+filePath+"."+fileExt);
	    }
	    fvo = new FileVO();
	    fvo.setFileExtsn(fileExt);
	    fvo.setFileStreCours(storePathString);
	    fvo.setFileMg(Long.toString(psize));
	    fvo.setOrignlFileNm(orginFileName);
	    fvo.setStreFileNm(newName);
	    fvo.setAtchFileId(atchFileIdString);
	    fvo.setFileSn(String.valueOf(fileKey));

	    //writeFile(file, newName, storePathString);
	    result.add(fvo);

	    fileKey++;
	}

	return result;
    }
    
    public List<FileVO> parseFileInfComm(Map<String, MultipartFile> files, String keyStr, int fileKeyParam, String atchFileId, String storePath) throws Exception {
        int fileKey = fileKeyParam;

        String storePathString = "";
        String atchFileIdString = "";

        if ("".equals(storePath) || storePath == null) {
            storePathString = EgovProperties.getProperty("Globals.fileStorePath");
        } else {
            storePathString = storePath;
        }

        if ("".equals(atchFileId) || atchFileId == null) {
            atchFileIdString = idgenService.getNextStringId();
        } else {
            atchFileIdString = atchFileId;
        }

        File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));

        if (!saveFolder.exists() || saveFolder.isFile()) {
            saveFolder.mkdirs();
        }

        Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
        MultipartFile file;
        String filePath = "";
        List<FileVO> result  = new ArrayList<FileVO>();
        FileVO fvo;

        while (itr.hasNext()) {
            Entry<String, MultipartFile> entry = itr.next();

            file = entry.getValue();
            String orginFileName = file.getOriginalFilename();

            //--------------------------------------
            // 원 파일명이 없는 경우 처리
            // (첨부가 되지 않은 input file type)
            //--------------------------------------
            if ("".equals(orginFileName)) {
            continue;
            }
            ////------------------------------------

            int index = orginFileName.lastIndexOf(".");
            //String fileName = orginFileName.substring(0, index);
            String fileExt = orginFileName.substring(index + 1);
            fileExt = fileExt.toLowerCase() ;
            String newName = keyStr + getTimeStamp() + fileKey +"."+fileExt ;
            long psize = file.getSize();

            if (!"".equals(orginFileName)) {
            filePath = storePathString + File.separator + newName ;
            
            file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
            }
            fvo = new FileVO();
            fvo.setFileExtsn(fileExt);
            fvo.setFileStreCours(storePathString);
            fvo.setFileMg(Long.toString(psize));
            fvo.setOrignlFileNm(orginFileName);
            fvo.setStreFileNm(newName);
            fvo.setAtchFileId(atchFileIdString);
            fvo.setFileSn(String.valueOf(fileKey));

            result.add(fvo);

            fileKey++;
        }

        return result;
        }

    /**
     * 첨부파일을 서버에 저장한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    protected void writeUploadedFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
	InputStream stream = null;
	OutputStream bos = null;

	try {
	    stream = file.getInputStream();
	    File cFile = new File(stordFilePath);

	    if (!cFile.isDirectory()) {
		boolean pflag = cFile.mkdir();
		if (!pflag) {
		    throw new IOException("Directory creation Failed ");
		}
	    }

	    bos = new FileOutputStream(stordFilePath + File.separator + newName);

	    int bytesRead = 0;
	    byte[] buffer = new byte[BUFF_SIZE];

	    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
	    	bos.write(buffer, 0, bytesRead);
	    }
	} catch (Exception e) {
	    //e.printStackTrace();
	    	LOG.error("IGNORE:", e);	// 2011.10.10 보안점검 후속조치
	} finally {
	    if (bos != null) {
		try {
		    bos.close();
		} catch (Exception ignore) {
		    LOG.debug("IGNORED: " + ignore.getMessage());
		}
	    }
	    if (stream != null) {
		try {
		    stream.close();
		} catch (Exception ignore) {
		    LOG.debug("IGNORED: " + ignore.getMessage());
		}
	    }
	}
    }

    /**
     * 서버의 파일을 다운로드한다.
     *
     * @param request
     * @param response
     * @throws Exception
     */
    public static void downFile(HttpServletRequest request, HttpServletResponse response) throws Exception {

	String downFileName = "";
	String orgFileName = "";

	if ((String)request.getAttribute("downFile") == null) {
	    downFileName = "";
	} else {
	    downFileName = (String)request.getAttribute("downFile");
	}

	if ((String)request.getAttribute("orgFileName") == null) {
	    orgFileName = "";
	} else {
	    orgFileName = (String)request.getAttribute("orginFile");
	}

	orgFileName = orgFileName.replaceAll("\r", "").replaceAll("\n", "");

	File file = new File(EgovWebUtil.filePathBlackList(downFileName));

	if (!file.exists()) {
	    throw new FileNotFoundException(downFileName);
	}

	if (!file.isFile()) {
	    throw new FileNotFoundException(downFileName);
	}

	byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.

	response.setContentType(CommonUtil.getContentType(file));
	response.setHeader("Content-Disposition:", "attachment; filename=" + new String(orgFileName.getBytes(), "UTF-8"));
	response.setHeader("Content-Transfer-Encoding", "binary");
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Expires", "0");

	BufferedInputStream fin = null;
	BufferedOutputStream outs = null;

	try {
		fin = new BufferedInputStream(new FileInputStream(file));
	    outs = new BufferedOutputStream(response.getOutputStream());
	    int read = 0;

		while ((read = fin.read(b)) != -1) {
		    outs.write(b, 0, read);
		}
	} finally {
	    if (outs != null) {
			try {
			    outs.close();
			} catch (Exception ignore) {
			    //System.out.println("IGNORED: " + ignore.getMessage());
			    LOG.debug("IGNORED: " + ignore.getMessage());
			}
		    }
		    if (fin != null) {
			try {
			    fin.close();
			} catch (Exception ignore) {
			    //System.out.println("IGNORED: " + ignore.getMessage());
			    LOG.debug("IGNORED: " + ignore.getMessage());
			}
		    }
		}
    }

    /**
     * 첨부로 등록된 파일을 서버에 업로드한다.
     *
     * @param file
     * @return
     * @throws Exception
     */
    public static HashMap<String, String> uploadFile(MultipartFile file) throws Exception {

	HashMap<String, String> map = new HashMap<String, String>();
	//Write File 이후 Move File????
	String newName = "";
	String stordFilePath = EgovProperties.getProperty("Globals.fileStorePath");
	String orginFileName = file.getOriginalFilename();

	int index = orginFileName.lastIndexOf(".");
	//String fileName = orginFileName.substring(0, _index);
	String fileExt = orginFileName.substring(index + 1);
	long size = file.getSize();

	//newName 은 Naming Convention에 의해서 생성
	newName = getTimeStamp() + "." + fileExt;
	writeFile(file, newName, stordFilePath);
	//storedFilePath는 지정
	map.put(Globals.ORIGIN_FILE_NM, orginFileName);
	map.put(Globals.UPLOAD_FILE_NM, newName);
	map.put(Globals.FILE_EXT, fileExt);
	map.put(Globals.FILE_PATH, stordFilePath);
	map.put(Globals.FILE_SIZE, String.valueOf(size));

	return map;
    }

    /**
     * 파일을 실제 물리적인 경로에 생성한다.
     *
     * @param file
     * @param newName
     * @param stordFilePath
     * @throws Exception
     */
    protected static void writeFile(MultipartFile file, String newName, String stordFilePath) throws Exception {
	InputStream stream = null;
	OutputStream bos = null;

	try {
	    stream = file.getInputStream();
	    File cFile = new File(EgovWebUtil.filePathBlackList(stordFilePath));

	    if (!cFile.isDirectory()) {
	    	cFile.mkdir();
	    }

	    bos = new FileOutputStream(EgovWebUtil.filePathBlackList(stordFilePath + File.separator + newName));

	    int bytesRead = 0;
	    byte[] buffer = new byte[BUFF_SIZE];

	    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		bos.write(buffer, 0, bytesRead);
	    }
	} catch (Exception e) {
	    //e.printStackTrace();
	    //throw new RuntimeException(e);	// 보안점검 후속조치
		Logger.getLogger(EgovFileMngUtil.class).debug("IGNORED: " + e.getMessage());
	} finally {
	    if (bos != null) {
		try {
		    bos.close();
		} catch (Exception ignore) {
		    Logger.getLogger(EgovFileMngUtil.class).debug("IGNORED: " + ignore.getMessage());
		}
	    }
	    if (stream != null) {
		try {
		    stream.close();
		} catch (Exception ignore) {
		    Logger.getLogger(EgovFileMngUtil.class).debug("IGNORED: " + ignore.getMessage());
		}
	    }
	}
    }

    /**
     * 서버 파일에 대하여 다운로드를 처리한다.
     *
     * @param response
     * @param streFileNm
     *            : 파일저장 경로가 포함된 형태
     * @param orignFileNm
     * @throws Exception
     */
    public void downFile(HttpServletResponse response, String streFileNm, String orignFileNm) throws Exception {
		String downFileName = streFileNm;
		String orgFileName = orignFileNm;
	
		File file = new File(downFileName);
	
		if (!file.exists()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		if (!file.isFile()) {
		    throw new FileNotFoundException(downFileName);
		}
	
		//byte[] b = new byte[BUFF_SIZE]; //buffer size 2K.
		int fSize = (int)file.length();
		if (fSize > 0) {
		    BufferedInputStream in = null;
	
		    try {
			in = new BufferedInputStream(new FileInputStream(file));
	
	    	String mimetype = "text/html"; //"application/x-msdownload"
	
	    	response.setBufferSize(fSize);
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition:", "attachment; filename=" + orgFileName);
			response.setContentLength(fSize);
			FileCopyUtils.copy(in, response.getOutputStream());
		    } finally {
				if (in != null) {
				    try {
					in.close();
				    } catch (Exception ignore) {
		
					Logger.getLogger(EgovFileMngUtil.class).debug("IGNORED: " + ignore.getMessage());
				    }
				}
		    }
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		}

    }

    /**
     * 2011.08.09
     * 공통 컴포넌트 utl.fcc 패키지와 Dependency제거를 위해 내부 메서드로 추가 정의함
     * 응용어플리케이션에서 고유값을 사용하기 위해 시스템에서17자리의TIMESTAMP값을 구하는 기능
     *
     * @param
     * @return Timestamp 값
     * @exception MyException
     * @see
     */
    private static String getTimeStamp() {

	String rtnStr = null;

	// 문자열로 변환하기 위한 패턴 설정(년도-월-일 시:분:초:초(자정이후 초))
	String pattern = "yyyyMMddhhmmssSSS";

	try {
	    SimpleDateFormat sdfCurrent = new SimpleDateFormat(pattern, Locale.KOREA);
	    Timestamp ts = new Timestamp(System.currentTimeMillis());

	    rtnStr = sdfCurrent.format(ts.getTime());
	} catch (Exception e) {
	    //e.printStackTrace();

	    //throw new RuntimeException(e);	// 보안점검 후속조치
	    LOG.debug("IGNORED: " + e.getMessage());
	}

	return rtnStr;
    }
    
	public boolean isValid( String fileID, EgovMessageSource egovMessageSource, Map<String, MultipartFile> files) throws Exception {
		
		boolean isPermission = false ;
		String pFileSize = egovMessageSource.getMessage(fileID+".file.size") ;
		String pFileCnt = egovMessageSource.getMessage(fileID+".file.cnt") ;
		String filePermission  = egovMessageSource.getMessage(fileID+".file.permission") ;
		String fileRestrict =  egovMessageSource.getMessage(fileID+".file.restrict") ;
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
		
		Iterator<Entry<String, MultipartFile>> itr = files.entrySet().iterator();
		MultipartFile file;
		
		int fileSize = 0 ;
		int fileCnt = 0 ;

		if(!EgovStringUtil.isEmpty(pFileSize)) {
			fileSize =  Integer.parseInt(pFileSize);
		}
		if(!EgovStringUtil.isEmpty(pFileCnt)) {
			fileCnt =  Integer.parseInt(pFileCnt);
		}
		int uploadFileCnt = 0 ;
		while (itr.hasNext()) {
		    Entry<String, MultipartFile> entry = itr.next();

		    file = entry.getValue();
		    String orginFileName = file.getOriginalFilename();
		    
		    //--------------------------------------
		    // 원 파일명이 없는 경우 처리
		    // (첨부가 되지 않은 input file type)
		    //--------------------------------------
		    if ("".equals(orginFileName)) {
		    	continue;
		    }
		    
		    long psize = file.getSize();
		    ////------------------------------------
		    
		    if(fileSize >0 && psize > fileSize){
//				request.setAttribute("errorCode", 1003); //파일 사이즈오류
				throw new FileSizeUploadException("파일크기 오류입니다.")  ;
			}
		    int index = orginFileName.lastIndexOf(".");
		    //String fileName = orginFileName.substring(0, index);
		  
		    String fileExt = orginFileName.substring(index + 1);
		    
		    //확장자 허용파일 체크
		    if( arrFilePermission != null ) {
				isPermission = false  ;
				for(int inx = 0 ;  inx < rowNum; inx++ ) {
					if ( arrFilePermission[inx].equalsIgnoreCase(fileExt) ) {
						isPermission = true ;
						break;
					}
				}
				if(!isPermission ) {
					throw new FileExtUploadException("허용하지 않은 파일입니다.")  ;
				}
				
			}else if (arrFileRestrict != null ) { //확장자 금지파일 체크
				isPermission = true ;
				for(int inx = 0 ;  inx < rowNum; inx++ ) {
					if ( arrFileRestrict[inx].equalsIgnoreCase(fileExt) ) {
						isPermission = false ;
						break;
					}
				}
				if(!isPermission ) {
					throw new FileExtUploadException("허용하지 않은 파일입니다.")  ;
				}
			}
		    uploadFileCnt++;
		}
		
		if(fileCnt >0 &&  uploadFileCnt > fileCnt  ) {
			throw new FileNumberUploadException("파일 개수 오류")  ;
		}
//		int fileSize = 0 ;
//		int fileCnt = 0 ;
//
//		if(!EgovStringUtil.isEmpty(pFileSize)) {
//			fileSize =  Integer.parseInt(pFileSize);
//		}
//		if(!EgovStringUtil.isEmpty(pFileCnt)) {
//			fileCnt =  Integer.parseInt(pFileCnt);
//		}
//		boolean  isPermission = true ;
//
//		int uploadFileCnt = 0 ;
//		long fileUploadSize = 0 ;
//		for (FileVO fileVO : files) {
//
//			if (fileVO != null ) {
//				uploadFileCnt ++ ;
//				ext = fileVO.getFileExtsn();
//
//				if( arrFilePermission != null ) {
//					isPermission = false  ;
//					for(int inx = 0 ;  inx < rowNum; inx++ ) {
//						if ( arrFilePermission[inx].equalsIgnoreCase(ext) ) {
//							isPermission = true ;
//							break;
//						}
//					}
//					if(!isPermission ) {
//						throw new FileExtUploadException("허용하지 않은 파일입니다.")  ;
//					}
//					
//				}else if (arrFileRestrict != null ) {
//					isPermission = true ;
//					for(int inx = 0 ;  inx < rowNum; inx++ ) {
//						if ( arrFileRestrict[inx].equalsIgnoreCase(ext) ) {
//							isPermission = false ;
//							break;
//						}
//					}
//					if(!isPermission ) {
//						//request.setAttribute("errorCode", 1001); //허용하지 않은 파일
//						throw new FileSizeUploadException("허용하지 않은 파일입니다.")  ;
//					}
//				}
//
//			}
//		}
//
//		if(fileCnt >0 &&  uploadFileCnt > fileCnt  ) {
//			throw new FileNumberUploadException("파일 개수 오류")  ;
//		}
		return true ;

	}
}
