package api.msg.helper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import api.common.helper.LogHelper;
import main.web.BizboxAMessage;
import neos.cmm.util.CommonUtil;

@Component
public class ConvertHtmlHelper {
	
	private Logger logger = LoggerFactory.getLogger(LogHelper.class);

	/**
	 * 문서변환 관련 HTML 파일 로컬 경로
	 */
	public static String ConvertingFileDirPath = "/home/upload/converting/";
	
	/**
	 * 문서변환 관련 HTML 다운로드 링크 경로 
	 */
	public static String ConvertingHtmlDownPath = "/upload/converting/";
	
	/**
	 * 문서변환 실패시 HTML 파일명 
	 */
	public static String ConvertFailFile = "convertingFail.html";
	
	/**
	 * 문서변환중 HTML 파일명
	 */
	public static String ConvertingFile = "converting.html";
	
	/**
	 * 문서변환 완료시 파일명 (SDK에서 변환 완료시 고정)
	 */
	public static String ConvertDoneFile = "document.pdf";
	
	/**
	 * 문서변환 타입 (Html
	 */
	public static String ConvertHtml = "html";
	//public static String ConvertHtml = "hview";

	/**
	 * 문서변환 가능 확장자 리스트 ("hwp", "doc", "docx", "ppt", "pptx", "xls", "xlsx")
	 */
	public static List<String> ATTACH_CONVERT_EXT_LIST = Arrays.asList("hwp", "doc", "docx", "ppt", "pptx", "xls", "xlsx");
	
	/**
	 * 문서변환 가능 여부 체크 ()
	 * @param fileExt
	 * @return
	 */
	public boolean checkConvertExt(String fileExt) {

		if (ATTACH_CONVERT_EXT_LIST.contains(fileExt)) {
			return true;
		}
		
		return false;
	}
	
	/**
	 * 문서번환 HTML 처리 (변환가능한 문서를 HTML 변환) 
	 * @param docConvertPath : 변환 쉘스크립트 경로 (bizboxa.properties 'BizboxA.DocConvert.path' 참)
	 * @param fileLocalPath : 변환할 문서 파일 경로 (ex. /home/upload/xxx/test.hwp)  * 변환가능 확장자 (hwp|doc|docx|ppt|pptx|xls|xlsx)
	 * @param saveLocalPath : 변환된 Html 저장 폴더 경로 (ex. /home/upload/xxx/test/) 
	 * @param htmlView : document.html (변환된 HTML)
	 * @throws Exception 
	 */
	@Async
	public void convertHtml(String docConvertPath, String fileLocalPath, String saveLocalPath, String htmlView, boolean drmTempDel) {
		
		logger.info("convertHtml-start " + " docConvertPath : "+ docConvertPath + " /fileLocalPath : " + fileLocalPath + 
				" /saveLocalPath : " + saveLocalPath + " /htmlView : " + htmlView);
		
		// 미입력시 기본으로 document.html (변환된 HTML)
		if (StringUtils.isEmpty(htmlView)) { 
			htmlView = ConvertDoneFile;
		}
		
		// 입력값 확인
		if (StringUtils.isEmpty(docConvertPath) || StringUtils.isEmpty(fileLocalPath) || StringUtils.isEmpty(saveLocalPath)) {
			logger.error("convertHtml-error 입력 파라미터가 올바르지 않습니다. (" + docConvertPath + "/" +  fileLocalPath + "/" + saveLocalPath + ")");
			return;
		}
		
		// 변환 여부 확인 
		File chk = new File(saveLocalPath + htmlView);
		if (chk.exists()) {
			logger.info("convertProcess-info 이미 문서 변환됨(정상)." + saveLocalPath + htmlView);
			return;
		}
		
		// 변환 실패 여부 확인 
		File chkFail = new File(saveLocalPath + ConvertFailFile);
		if (chkFail.exists()) {
			//logger.info("convertProcess-info 이미 문서 변환됨(실패)." + saveLocalPath + ConvertFailFile);
			//return;
		}
		
		// 명령어 처리 
		 List<String> command = new ArrayList<String>();
		 command.add(docConvertPath);
		 command.add(fileLocalPath);
		 command.add(saveLocalPath);
		 command.add(ConvertHtml);
		 logger.debug(command.toString());
		 
		 try {
			 
			byCommonsExec(command.toArray(new String[command.size()]));
			
			if(drmTempDel && fileLocalPath.contains("drmDecTemp")){
				
				File file = new File(fileLocalPath);				
				
				String dirPath = file.getParent();
				if(file.delete()) {
					file = new File(dirPath);
					if(file.isDirectory()) {
						file.delete();	
					}
				}
				
			}
			
		} catch (Exception e) {
			logger.error("convertProcess convert Error info : " + fileLocalPath);
			File failed = new File(saveLocalPath);
			if (!failed.exists()) {
				failed.mkdir();
			}

			fileCopy(ConvertingFileDirPath + ConvertFailFile, saveLocalPath + ConvertFailFile);
			logger.error(ConvertingFileDirPath + ConvertFailFile + " >>> " + saveLocalPath + ConvertFailFile + " Failed. (Copy)");
		}
		 logger.debug("convertHtml-end");
	}
	
	
	@Async
	public void convertImage(String docConvertPath, String fileLocalPath, String saveLocalPath) {
		
		// 입력값 확인
		if (StringUtils.isEmpty(docConvertPath) || StringUtils.isEmpty(fileLocalPath) || StringUtils.isEmpty(saveLocalPath)) {
			logger.error("convertHtml-error 입력 파라미터가 올바르지 않습니다. (" + docConvertPath + "/" +  fileLocalPath + "/" + saveLocalPath + ")");
			return;
		}

		// 명령어 처리 
		 List<String> command = new ArrayList<String>();
		 command.add(docConvertPath);
		 command.add(fileLocalPath);
		 command.add(saveLocalPath);
		 command.add("image");
		 logger.debug(command.toString());
		 
		 try {
			byCommonsExec(command.toArray(new String[command.size()]));
		} catch (Exception e) {
			logger.error("convertProcess convert Error info : " + fileLocalPath);
			File failed = new File(saveLocalPath);
			if (!failed.exists()) {
				failed.mkdir();
			}

			fileCopy(ConvertingFileDirPath + ConvertFailFile, saveLocalPath + ConvertFailFile);
			logger.error(ConvertingFileDirPath + ConvertFailFile + " >>> " + saveLocalPath + ConvertFailFile + " Failed. (Copy)");
		}
		 logger.debug("convertHtml-end");
	}
	

	public void convertImageSync(String docConvertPath, String fileLocalPath, String saveLocalPath) {
		
		// 입력값 확인
		if (StringUtils.isEmpty(docConvertPath) || StringUtils.isEmpty(fileLocalPath) || StringUtils.isEmpty(saveLocalPath)) {
			logger.error("convertHtml-error 입력 파라미터가 올바르지 않습니다. (" + docConvertPath + "/" +  fileLocalPath + "/" + saveLocalPath + ")");
			return;
		}

		// 명령어 처리 
		 List<String> command = new ArrayList<String>();
		 command.add(docConvertPath);
		 command.add(fileLocalPath);
		 command.add(saveLocalPath);
		 command.add("image");
		 logger.debug(command.toString());
		 
		 try {
			byCommonsExec(command.toArray(new String[command.size()]));
		} catch (Exception e) {
			logger.error("convertProcess convert Error info : " + fileLocalPath);
			File failed = new File(saveLocalPath);
			
			if (!failed.exists()) {
				failed.mkdir();
			}

			fileCopy(ConvertingFileDirPath + ConvertFailFile, saveLocalPath + ConvertFailFile);
			logger.error(ConvertingFileDirPath + ConvertFailFile + " >>> " + saveLocalPath + ConvertFailFile + " Failed. (Copy)");
		}
		 logger.debug("convertHtml-end");
	}
	
		
	/**
	 * 변환 문서 체크 및 다운로드 링 조회 
	 * @param saveLocalPath
	 * @param htmlView
	 * @return code (-1:입력 오류, 0:성공, 1:변환실패문서, 2:변환중, 3:변환중(변환요청필요)  msg : 다운로드 링 (ex. /upload/xxx/document.html)
	 * code : 0,1,2,3 인경우 msg에 다운로드 링크가 조회됨, 3 인경우 문서변환 요청해야함.
	 */
	public Map<String, String> checkConvertHtml(String saveLocalPath) {
		Map<String, String> result = new HashMap<String, String>();
		
		String htmlView = "hview.html";
		
		result.put("code", "0");
		result.put("msg", saveLocalPath + htmlView);
		logger.info("checkConvertHtml-info (saveLocalPath : " + saveLocalPath + ") / htmlView : (" + htmlView + ")");
		
		// 입력값 확인
		if ( StringUtils.isEmpty(saveLocalPath)) {
			logger.error("checkConvertHtml-error 입력 파라미터가 올바르지 않습니다. (" + saveLocalPath + ")");
			result.put("code", "-1");
			result.put("msg", BizboxAMessage.getMessage("TX800000024","입력 오류"));
			return result;
		}
				
		// 미입력시 기본으로 document.html (변환된 HTML)
		if (StringUtils.isEmpty(htmlView)) {
			htmlView = ConvertDoneFile;
		}
		
		File ckDir = new File(saveLocalPath);
		File ckFile = new File(saveLocalPath + htmlView);
		
		// convertHtml 한번 이상 실행중 이고,
		// 파일이 존재 하면 이미 변환 됨.
		if (ckFile.exists()) {
			logger.info("checkConvertHtml-info 이미 문서 변환됨.. " + saveLocalPath + htmlView);
		}
		else if (ckDir.exists() && !ckFile.exists()) {
			File ckFile2 = new File(saveLocalPath + ConvertFailFile);
			if (ckFile2.exists()) {
				logger.info("checkConvertHtml-info 문서변환 실패문서.. " + saveLocalPath + ConvertFailFile);
				result.put("code", "1");
				result.put("msg", saveLocalPath + ConvertFailFile);
			}
			else {
				logger.info("checkConvertHtml-info 문서 변환중.. " + ConvertingHtmlDownPath + ConvertingFile);
				result.put("code", "2");
				result.put("msg", ConvertingHtmlDownPath + ConvertingFile);
			}
		}
		else {
			logger.info("checkConvertHtml-info 문서 변환중(폴더없음 변환요청 해야함.).. " + ConvertingHtmlDownPath + ConvertingFile);
			result.put("code", "3");
			result.put("msg", ConvertingHtmlDownPath + ConvertingFile);
		}
		String retStr = result.get("msg");
		// 다운로드 URL 경로를 마추기 위해 /upload 뒤로 경로만 리턴
		if(retStr.indexOf("/upload") != -1){
			int idx = retStr.indexOf("/upload");
			retStr = retStr.substring(idx < 0 ? 0 :idx, retStr.length());
		}
		else if(retStr.indexOf("/UPLOAD") != -1){
			int idx = retStr.indexOf("/UPLOAD");
			retStr = retStr.substring(idx < 0 ? 0 :idx, retStr.length());
		}
		
		result.put("msg", retStr);
		return result;
	}
	
	/**
	 * 명령 실행 
	 * @param command
	 * @throws Exception
	 */
	public void byCommonsExec(String[] command) throws Exception, ExecuteException{
	    
		DefaultExecutor executor = new DefaultExecutor();
	    ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    PumpStreamHandler streamHandler = new PumpStreamHandler(baos);
	    executor.setStreamHandler(streamHandler);
	    CommandLine cmdLine = CommandLine.parse(command[0]);
	    
	    for (int i=1, n=command.length ; i<n ; i++ ) {
	    	if (!StringUtils.isEmpty(command[i])) {
	    		cmdLine.addArgument(command[i], false);
	    	}
	    }
	    
	    logger.debug("byCommonsExecStr-cmdline : " +  Arrays.asList(command));
	    try {	   
	    	int exitCode = executor.execute(cmdLine);
	    
	    	logger.info("byCommonsExecStr-end " + " exitCode : " + exitCode + " /outputStr : " + baos.toString());
	    } catch (Exception e) {
	    	logger.error("byCommonsExecStr-error " + baos.toString());
	    	throw e;
		} finally {
			if (baos != null) {
				baos.close();
			}
		}
	}
	
	/**
	 * 명령 실행 (리턴) 
	 * @param command
	 * @return
	 * @throws Exception
	 */
	public String byCommonsExecStr(String[] command){
	    String retStr = StringUtils.EMPTY;
		DefaultExecutor executor = new DefaultExecutor();
	    ByteArrayOutputStream baos = new ByteArrayOutputStream();
	    PumpStreamHandler streamHandler = new PumpStreamHandler(baos);
	    executor.setStreamHandler(streamHandler);
	    CommandLine cmdLine = CommandLine.parse(command[0]);
	    
	    for (int i=1, n=command.length ; i<n ; i++ ) {
	    	if (!StringUtils.isEmpty(command[i])) {
	    		cmdLine.addArgument(command[i]);
	    	}
	    }
	    
	    logger.debug("byCommonsExecStr-cmdline : " +  Arrays.asList(command));
	    try {	   
	    	int exitCode = executor.execute(cmdLine);
	    	retStr = baos.toString();
	    	logger.info("byCommonsExecStr-end " + " exitCode : " + exitCode + " /outputStr : " + retStr);
	    } catch (Exception e) {
	    	logger.error("byCommonsExecStr-error ", e.getMessage());
	    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} finally {
			if (baos != null) {
				try {
					baos.close();
				} catch (IOException e) {
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}   
	    
	    return baos.toString();
	}

	private void fileCopy(String inFileName, String outFileName) {

		try {
			FileInputStream fis = new FileInputStream(inFileName);
			FileOutputStream fos = new FileOutputStream(outFileName);
		   
			int data = 0;
			while((data=fis.read())!=-1) {
				fos.write(data);
			}
			
			fis.close();
			fos.close();
	  	} catch (IOException e) {
	  		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	  	} 
	}
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args){
//    	try {
//			String [] cmd = new String[] { "ls", "-lrt", "", "" };
//			ConvertHtmlHelper a = new ConvertHtmlHelper();
//			a.convertHtml("ls", "-lt", "", "", false);
//			a.byCommonsExecStr(cmd);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//    }
}
