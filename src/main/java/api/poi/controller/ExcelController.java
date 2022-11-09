package api.poi.controller;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

import javax.annotation.Resource;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.util.FileCopyUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import api.poi.service.ExcelService;
import neos.cmm.util.CommonUtil;
import net.sf.json.JSONArray;


@Controller
public class ExcelController {
	
	private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);
	
	 
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
		
	@RequestMapping(value = "/poi/procExcelFile", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> procExcelFile(HttpServletRequest request) throws Exception {

		  logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
	
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
	
			  String savePath = File.separator;
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;
						
				     File tempFile = new File(saveFileName);
				     OutputStream outputStream  = new FileOutputStream(tempFile);	
				     FileCopyUtils.copy(mFile.getInputStream(), outputStream);		
				     outputStream.close();
				     
				     
				     excelContentList = excelService.procExtractExcel2(saveFileName);
				  }
			  }
			  
		  } catch (Exception ex) {
	
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
	
		  }
	
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);
//		  System.out.println("procExcelFile! ======> "+arrExcelContentList);
		  logger.debug("procExcelFile! ======> "+arrExcelContentList);
		  
		  resultMap.put("retMsg", "success");
		  resultMap.put("retData", arrExcelContentList);
		  
		  logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  
	
		  return resultMap;
	
	}
	
		
	@RequestMapping(value = "/poi/procExcelTemp", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> procExcelTemp(HttpServletRequest request) throws Exception {

		  logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
	
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
	
			  String savePath = File.separator;
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;
						
				     File tempFile = new File(saveFileName);
				     OutputStream outputStream  = new FileOutputStream(tempFile);	
				     FileCopyUtils.copy(mFile.getInputStream(), outputStream);		
				     outputStream.close();
				     
				     
				     excelContentList = excelService.procExtractExcelTemp(saveFileName);
				  }
			  }
			  
		  } catch (Exception ex) {
	
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
	
		  }
	
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);
//		  System.out.println("procExcelFile! ======> "+arrExcelContentList);
		  logger.debug("procExcelFile! ======> "+arrExcelContentList);
		  
		  resultMap.put("retMsg", "success");
		  resultMap.put("retData", arrExcelContentList);
		  
		  logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  
	
		  return resultMap;
	
	}
	
		
	@RequestMapping(value = "/poi/procExcelToJSON", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> procExcelToJSON(HttpServletRequest request) throws Exception {

		  logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
	
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
	
			  String savePath = File.separator;
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize   = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;
						
				     File tempFile = new File(saveFileName);
				     OutputStream outputStream  = new FileOutputStream(tempFile);	
				     FileCopyUtils.copy(mFile.getInputStream(), outputStream);		
				     outputStream.close();
				     
				     
				     excelContentList = excelService.procExtractExcel(saveFileName);
				  }
			  }
			  
		  } catch (Exception ex) {
	
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
	
		  }
	
	
		  // SET JSON
		  JSONArray arrExcelContentList = new JSONArray();
	
		  arrExcelContentList = JSONArray.fromObject(excelContentList);
//		  System.out.println("procExcelToJSON! ======> "+arrExcelContentList);
		  logger.debug("procExcelToJSON! ======> "+arrExcelContentList);
		  
		  resultMap.put("retMsg", "success");
		  resultMap.put("retData", arrExcelContentList);
		  
		  logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  
	
		  return resultMap;
	
	}
	
	
	@RequestMapping(value = "/poi/procExcelToList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> procExcelToList(HttpServletRequest request) throws Exception {

		  logger.info("CONTROLLER BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
	
		  
		  Map<String,Object> resultMap = new HashMap<String, Object>();
	
		  // SET LOCAL VALUE
		  List<Map<String,Object>> excelContentList = null; 	  
	
		  try {
	
			  String savePath = File.separator;
	
			  MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
			  MultipartFile mFile = multipartRequest.getFile("excelUploadFile"); // NAME IN JSP FORM
	
			  if (mFile != null && mFile.getSize() > 0) {
				  String saveFileName  = mFile.getOriginalFilename();
	
				  long fileSize = mFile.getSize();
	
				  if (fileSize > 0 && !saveFileName.equals("")) {
					 saveFileName = savePath + saveFileName;
						
				     File tempFile = new File(saveFileName);
				     OutputStream outputStream  = new FileOutputStream(tempFile);	
				     FileCopyUtils.copy(mFile.getInputStream(), outputStream);		
				     outputStream.close();
				     
				     
				     excelContentList = excelService.procExtractExcel(saveFileName);
				  }
			  }
			  
		  } catch (Exception ex) {
	
			  CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출
	
		  }
		  

//		  System.out.println("procExcelToList! ======> "+excelContentList);
		  logger.debug("procExcelToList! ======> "+excelContentList);
		  
		  resultMap.put("retMsg", "success");
		  resultMap.put("retData", excelContentList);
		  
		  logger.info("CONTROLLER END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		  
	
		  return resultMap;
	
	}
	
		
	@RequestMapping(value="/poi/procDataToExcel", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> procDataToExcel(@RequestBody Map<String, Object> paramMap) {

		Map<String,Object> resultMap = new HashMap<String, Object>();

		String fileName = (String) paramMap.get("fileName");
		List<Map<String, Object>> excelData = (List<Map<String, Object>>) paramMap.get("excelData");
		
		
		HSSFWorkbook wb = new HSSFWorkbook();
		
		HSSFSheet sheet = wb.createSheet();
		HSSFRow row = sheet.createRow(0);   // row 생성
		  
		// cell 생성
	 	row.createCell(0).setCellValue("1, A");
	 	row.createCell(1).setCellValue("1, B");
	  
	 	row = sheet.createRow(1);     // row 생성
	  
	 	// cell 생성
	 	row.createCell(0).setCellValue("2, A");
	 	row.createCell(1).setCellValue("2, B");

//		for (int i = 0 ; i < excelData.size() ; i++) {
//			
//		}
		
		FileOutputStream outStream;
		
		try {

			outStream = new FileOutputStream(fileName+"xls");
			wb.write(outStream);
			outStream.close();
			
			resultMap.put("retMsg", "success");
			
		} catch (Exception e){
			
			resultMap.put("retMsg", "fail");
			
		}

		
		return resultMap;
	}
	 
}
