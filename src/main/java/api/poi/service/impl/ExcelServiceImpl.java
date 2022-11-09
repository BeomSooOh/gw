package api.poi.service.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import org.springframework.stereotype.Service;

import api.poi.service.ExcelService;
import main.web.BizboxAMessage;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import api.drm.service.DrmService;

@Service("ExcelService")
public class ExcelServiceImpl implements ExcelService{
	
	private static final Logger logger = LoggerFactory.getLogger(ExcelServiceImpl.class);
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "DrmService")
	private DrmService drmService;		
	
	 private static final DataFormatter FORMATTER = new DataFormatter();
	 
	 
	 private static String getCellContent(Cell cell) {
	
		 if(cell.getCellType() == 2){
			 try{
				return Integer.toString(((int)(cell.getNumericCellValue())));
			 }catch(Exception e){
				 return cell.getStringCellValue();
			 }
		 }			 
		 else {
			 return FORMATTER.formatCellValue(cell);
		 }
	 }
	 
	 
	 public List<Map<String,Object>> procExtractExcel(String excelFileName) throws IOException {

		 //logger.info("SERVICE BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());


		 // SET LOCAL VALUE
		 List<Map<String,Object>> excelContentList = new ArrayList<>();  
	
		 File file  = new File(excelFileName);


		 // VALIDATE FILE  
		 if (!file.exists() || !file.isFile() || !file.canRead()) {
	
			 throw new IOException(excelFileName);
	
		 }
	  

		 try {
			 
			 Workbook wb = null;
			 
			 if (excelFileName.indexOf(".xlsx") > -1) {
				 wb  = new XSSFWorkbook(new FileInputStream(file));
			 }
			 else {
				 wb = new HSSFWorkbook(new FileInputStream(file));
			 }

			 
			 int sCnt = wb.getNumberOfSheets();
			 
			 for (int i = 0 ; i < 1 ; i++) {
				 
				Sheet sheet = wb.getSheetAt(i);	// i번째 sheet 정보를 얻어옴
			    
			    int rowCnt = sheet.getPhysicalNumberOfRows();	// row 개수 얻어옴
			    
			    int sRow = Integer.parseInt(getCellContent(sheet.getRow(0).getCell(0)));
			    Map<String, Object> keyMap = getExcelDataKey(sheet, sheet.getRow(1));
			    
			    excelContentList.add(keyMap);

			    
			    for (int r = sRow ; r < rowCnt ; r++) {
			    	
				    Row row = sheet.getRow(r);	// row 정보 얻어옴
				    
				    //int cellCnt = row.getPhysicalNumberOfCells();	// cell 개수 얻어옴
				    int cellCnt = row.getLastCellNum();
				    
				    Map<String, Object> map = new HashMap<String, Object>();
				     
				    for(int c = 0 ; c < cellCnt ; c++){
				    
				    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
				    	
				    	String cVal = "";
				    	if (isMergedRegion(sheet, cell)) {
				    		//map.put((String) keyMap.get("c"+c), getMergedRegionValue(sheet, cell));
				    		cVal = getMergedRegionValue(sheet, cell);
				    	}
				    	else {
				    		//map.put((String) keyMap.get("c"+c), cell.getStringCellValue());
				    		//map.put((String) keyMap.get("c"+c), getCellContent(cell));
				    		cVal = getCellContent(cell);
				    	}
				    	
				    	map.put((String) keyMap.get("c"+c), cVal.trim());

				    }
				    
				    excelContentList.add(map);
			    }
			 }

		 } catch( Exception ex ) {

			 CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

		 }

		 //logger.info("SERVICE END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		 

		 return excelContentList;

	 }
	 
	 
	 public static boolean isMergedRegion(Sheet sheet, Cell cell) {
		 
		 int sheetmergerCount = sheet.getNumMergedRegions();
		 
		 for (int i = 0; i <sheetmergerCount; i++) {
			 
			 CellRangeAddress ca = sheet.getMergedRegion(i);
			 
			 int firstC = ca.getFirstColumn();
			 int lastC = ca.getLastColumn();
			 int firstR = ca.getFirstRow();
			 int lastR = ca.getLastRow();
			 
			 if (cell.getColumnIndex() <= lastC && cell.getColumnIndex() >= firstC) {
				 if (cell.getRowIndex() <= lastR && cell.getRowIndex() >= firstR) {
					 return true;
				 }
			 }
			 
		 }
		 
		 return false;
		 
	 }
	 
	 
	 public static String getMergedRegionValue(Sheet sheet, Cell cell) {
		 
		 int sheetmergerCount = sheet.getNumMergedRegions();
		 
		 for (int i = 0; i <sheetmergerCount; i++) {
			 
			 CellRangeAddress ca = sheet.getMergedRegion(i);
			 
			 int firstC = ca.getFirstColumn();
			 int lastC = ca.getLastColumn();
			 int firstR = ca.getFirstRow();
			 int lastR = ca.getLastRow();
			 
			 if (cell.getColumnIndex() <= lastC && cell.getColumnIndex() >= firstC && cell.getRowIndex() <= lastR && cell.getRowIndex() >= firstR) {
				 return getMergedCellContent(sheet, firstR, firstC);
			 }
			 
		 }
		 
		 return "";
		 
	 }
	 
	 
	 private static String getMergedCellContent(Sheet sheet, int r, int c) {
		 
		 Row row = sheet.getRow(r);
		 Cell cell = row.getCell(c);
		 
		 return getCellContent(cell);
		 
	 }
	 
	 
	 private static Map<String, Object> getExcelDataKey(Sheet sheet, Row row) {
		 
		 Map<String, Object> keyMap = new HashMap<String, Object>();
	    	
		 int cellCnt = row.getPhysicalNumberOfCells();
		 
		 for(int c = 0 ; c < cellCnt ; c++){
			    
	    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
	    	
	    	if (isMergedRegion(sheet, cell)) {
	    		keyMap.put("c"+c, getMergedRegionValue(sheet, cell));
	    	}
	    	else {
	    		keyMap.put("c"+c, getCellContent(cell));
	    	}

	     }
//		 System.out.println("keyMap! ======> "+keyMap);
		 logger.debug("keyMap! ======> "+keyMap);
		 
		 return keyMap;
		 
	 }
	 
	 
	 public List<Map<String,Object>> procExtractExcelTemp(String excelFileName) throws IOException {

		 // SET LOCAL VALUE
		 List<Map<String,Object>> excelContentList = new ArrayList<>();  
		 File file  = new File(excelFileName);

		 // VALIDATE FILE  
		 if (!file.exists() || !file.isFile() || !file.canRead()) {
			 throw new IOException(excelFileName);
		 }
	  
		 try {
			 
			 Workbook wb = null;
			 
			 if (excelFileName.indexOf(".xlsx") > -1) {
				 wb = new XSSFWorkbook(new FileInputStream(file));
			 }
			 else {
				 wb = new HSSFWorkbook(new FileInputStream(file));
			 }

			 
			 int sCnt = wb.getNumberOfSheets();
			 
			 for (int i = 0 ; i < 1 ; i++) {
				 
				Sheet sheet = wb.getSheetAt(i);	// i번째 sheet 정보를 얻어옴
			    
			    int rowCnt = sheet.getPhysicalNumberOfRows() + 3;	// row 개수 얻어옴

			    int sRow = 7;
			    
			    for (int r = sRow ; r <= rowCnt ; r++) {
			    	
				    Row row = sheet.getRow(r);	// row 정보 얻어옴
				    
				    int cellCnt = 0;
				    if(row != null) {
				    	cellCnt = row.getLastCellNum();	// cell 개수 얻어옴
				    }
			        else {
			            continue;
			        }
				    
				    Map<String, Object> map = new HashMap<String, Object>();
				    
				    map.put("num", (r - sRow)+"");
				     
				    for (int c = 0 ; c < cellCnt ; c++) {
				    
				    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
				    	
				    	String cVal = "";
				    	if (cell != null && isMergedRegion(sheet, cell)) {
				    		cVal = getMergedRegionValue(sheet, cell);
				    	}
				    	else {
				    		if(cell == null) {
				    			cVal = "";
				    		}
				    		else {
				    			cVal = getCellContent(cell);
				    		}
				    	}
				    	
				    	map.put("C"+c, cVal.trim());

				    }
				    
				    boolean chk = false;
				    for(Map.Entry<String, Object> entry:map.entrySet()) {
				    	if (entry.getKey() != "num" && entry.getValue() != "") {
				    		chk = true;
				    	}
				    }

				    if (chk) {
				    	excelContentList.add(map);
				    }
			    }
			 }

		 } catch( Exception ex ) {

			 CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

		 }

		 return excelContentList;

	 }
	 
	 
	 public List<Map<String,Object>> procExtractExcel2(String excelFileName) throws IOException {

		 //logger.info("SERVICE BEGIN METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());


		 // SET LOCAL VALUE
		 List<Map<String,Object>> excelContentList = new ArrayList<>();  
	
		 File file  = new File(excelFileName);


		 // VALIDATE FILE  
		 if (!file.exists() || !file.isFile() || !file.canRead()) {
	
			 throw new IOException(excelFileName);
	
		 }
	  

		 try {
			 
			 Workbook wb = null;
			 
			 if (excelFileName.indexOf(".xlsx") > -1) {
				 wb = new XSSFWorkbook(new FileInputStream(file));
			 }
			 else {
				 wb = new HSSFWorkbook(new FileInputStream(file));
			 }

			 
			 int sCnt = wb.getNumberOfSheets();
			 
			 for (int i = 0 ; i < 1 ; i++) {
				 
				Sheet sheet = wb.getSheetAt(i);	// i번째 sheet 정보를 얻어옴
			    
			    int rowCnt = sheet.getPhysicalNumberOfRows();	// row 개수 얻어옴
			    
			    //int sRow = Integer.parseInt(getCellContent(sheet.getRow(0).getCell(0)));
			    //Map<String, Object> keyMap = getExcelDataKey(sheet, sheet.getRow(1));
			    
			    //excelContentList.add(keyMap);

			    
			    for (int r = 5 ; r < rowCnt ; r++) {
			    	
				    Row row = sheet.getRow(r);	// row 정보 얻어옴
				    
				    int cellCnt = 0;
				    if(row != null) {
				    	cellCnt = row.getLastCellNum();	// cell 개수 얻어옴
				    }
			        else {
			            continue;
			        }
				    
				    Map<String, Object> map = new HashMap<String, Object>();
				     
				    for(int c = 0 ; c < cellCnt ; c++){
				    
				    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
				    	
				    	if (isMergedRegion(sheet, cell)) {
				    		//map.put((String) keyMap.get("c"+c), getMergedRegionValue(sheet, cell));
				    		map.put(("c_"+c), getMergedRegionValue(sheet, cell));
				    	}
				    	else {
				    		//map.put((String) keyMap.get("c"+c), cell.getStringCellValue());
				    		//map.put((String) keyMap.get("c"+c), getCellContent(cell));
				    		map.put(("c_"+c), getCellContent(cell));
				    	}

				    }
				    
				    excelContentList.add(map);
			    }
			 }

		 } catch( Exception ex ) {

			 CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

		 }

		 //logger.info("SERVICE END METHOD :: " + new Object(){}.getClass().getEnclosingMethod().getName());
		 

		 return excelContentList;

	 }
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 public List<Map<String,Object>> procAddrExcelTemp(String excelFileName) throws IOException {

		 // SET LOCAL VALUE
		 List<Map<String,Object>> excelContentList = new ArrayList<>();  
		 File file  = new File(excelFileName);

		 // VALIDATE FILE  
		 if (!file.exists() || !file.isFile() || !file.canRead()) {
			 throw new IOException(excelFileName);
		 }
	  
		 try {
			 
			 Workbook wb = null;
			 
			 if (excelFileName.indexOf(".xlsx") > -1) {
				 wb = new XSSFWorkbook(new FileInputStream(file));
			 }
			 else {
				 wb = new HSSFWorkbook(new FileInputStream(file));
			 }

			 
			 int sCnt = wb.getNumberOfSheets();
			 
			 for (int i = 0 ; i < 1 ; i++) {
				 
				Sheet sheet = wb.getSheetAt(i);	// i번째 sheet 정보를 얻어옴
			    
			    int rowCnt = sheet.getPhysicalNumberOfRows() + 2;	// row 개수 얻어옴

			    int sRow = 1;
			    
			    for (int r = sRow ; r < rowCnt ; r++) {
			    	
				    Row row = sheet.getRow(r);	// row 정보 얻어옴
				    
				    int cellCnt = 0;
				    if(row != null) {
				    	cellCnt = row.getLastCellNum();	// cell 개수 얻어옴
				    }
			        else {
			            continue;
			        }
				    
				    Map<String, Object> map = new HashMap<String, Object>();
				    
				    map.put("num", (r - sRow)+"");
				     
				    for (int c = 0 ; c < cellCnt ; c++) {
				    
				    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
				    	
				    	String cVal = "";
				    	if (cell != null && isMergedRegion(sheet, cell)) {
				    		cVal = getMergedRegionValue(sheet, cell);
				    	}
				    	else {
				    		if(cell == null) {
				    			cVal = "";
				    		}
				    		else {
				    			cVal = getCellContent(cell);
				    		}
				    	}
				    	
				    	map.put("C"+c, cVal.trim());

				    }
				    
				    boolean chk = false;
				    for(Map.Entry<String, Object> entry:map.entrySet()) {
				    	if (entry.getKey() != "num" && entry.getValue() != "") {
				    		chk = true;
				    	}
				    }

				    if (chk) {
				    	excelContentList.add(map);
				    }
			    }
			 }

		 } catch( Exception ex ) {

			 CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

		 }

		 return excelContentList;

	 }
	 
	 
	 public void CmmExcelDownload(List<Map<String, Object>> list, String[] arrCol, String fileNm, HttpServletResponse response, HttpServletRequest servletRequest){
		 
		 int widthSize = 256;
		 int heightSize = 20;
		 
		 OutputStream fileOut = null;
		 response.setHeader("Content-Disposition", "attachment; filename="+fileNm+".xls"); 
		 
		 HSSFWorkbook wb = new HSSFWorkbook();
		 Sheet sheet = wb.createSheet("Sheet1");
		 
		 Row row = sheet.createRow(0);		
		 row.setHeight((short)(19.5 * heightSize));
		 
		 Cell cell = null;
				 
		 for(int i=0;i<arrCol.length;i++){
			 // 컬럼 크기 셋팅 
			 sheet.setColumnWidth(i, 20 * widthSize);
			 
			 // 헤더 타이틀 (생성) - 인자로 받은 문자열 배열순서대로 셋팅 
			 cell = row.createCell(i);
			 cell.setCellValue(arrCol[i]);
			 setCellStyleTitleCenter(wb, cell);
		 }
		 
		 /* 본문 셀 생성 */
		 createContents(sheet, list, heightSize);
		 
		 
		 setFileNameToResponse(servletRequest, response, fileNm + ".xls");
		 
		 File file = null;
         FileInputStream fis = null;
			
		try{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("osType", NeosConstants.SERVER_OS);
			Map<String, Object> pathMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getBaseUploadPath", para);
			String filePath = pathMp.get("absolPath") + "/uploadTemp/" + "/excelDown/"; 		
            FileOutputStream fout = setFile(filePath, fileNm + ".xls");
            wb.write(fout);
            fout.close(); 
            
			//DRM 체크
			String drmPath = drmService.drmConvert("D", "", "E", filePath, fileNm, "xls");	
			file = new File(drmPath);
		    fis = new FileInputStream(file);

		    String orignlFileName = fileNm + ".xls";

		    String browser = servletRequest.getHeader("User-Agent");
		    
		    //파일 인코딩
		    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
		    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
		    } 
		    else {
		    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
		    } 
		    
		    response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
		    response.setContentLength((int) file.length());

		    response.setContentType(CommonUtil.getContentType(file));
		    response.setHeader("Content-Transfer-Encoding", "binary;");

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
            
		}
		catch (FileNotFoundException e) {
//			System.out.println(e.getMessage());
			logger.debug(e.getMessage());
		}  catch (IOException e){
//			System.out.println(e.getMessage());
			logger.debug(e.getMessage());
		}finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
			
			if(file!=null) {//Null Pointer 역참조
				file.delete();
			}
		}
		 
	 }
	 
	 public void CmmExcelDownloadAddContents(List<Map<String, Object>> list, int[] arrColWidth, String[] arrColName, String fileNm, HttpServletResponse response, HttpServletRequest servletRequest){
		 
		 int heightSize = 20;
		 
		 response.setHeader("Content-Disposition", "attachment; filename="+fileNm+".xls"); 
		 
		 HSSFWorkbook wb = new HSSFWorkbook();
		 HSSFPalette palette = wb.getCustomPalette();
		 Sheet sheet = wb.createSheet("Sheet1");
		 sheet.autoSizeColumn(2);
		 Cell cell = null;
		 
		 Font font = wb.createFont();
		 font.setFontName("맑은 고딕");
		 font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		 font.setFontHeight((short)200);
		 CellStyle style = wb.createCellStyle();
		 style.setFont(font);
		 style.setAlignment(CellStyle.ALIGN_LEFT);
		 style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		 style.setWrapText(true);
		 
		 Row row = sheet.createRow(1);
		 row.setHeight((short)(19.5 * heightSize));
		 cell = row.createCell(0);
		 cell.setCellValue(BizboxAMessage.getMessage("TX800000025","더존 그룹웨어 사용자 사진 업로드 양식"));
		 sheet.addMergedRegion(CellRangeAddress.valueOf("A2:H2"));
		 
		 HSSFRichTextString richString = new HSSFRichTextString(BizboxAMessage.getMessage("TX800000025","더존 그룹웨어 사용자 사진 업로드 양식"));
		 richString.applyFont( 0, 21, setFont(wb, "Gothic", (short)250, HSSFColor.BLACK.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_SINGLE));
		 cell.setCellValue( richString );		 
		 
		 row = sheet.createRow(2);
		 row.setHeight((short)(19.5 * 90));	 
		 cell = row.createCell(0);
		 sheet.addMergedRegion(CellRangeAddress.valueOf("A3:H3"));
		 richString = new HSSFRichTextString("! " + BizboxAMessage.getMessage("TX800000026","필독사항") + " !\n1. " + BizboxAMessage.getMessage("TX800000027","순번, 로그인ID, 사용자명 컬럼은 DB에 사용자 데이터가 있는경우 로그인 ID 와 사용자명 포함한 양식이 다운됩니다.") + "\n2. " + BizboxAMessage.getMessage("TX800000028","사진파일명은 확장자를 포함하여 입력하여 주세요.") + "\n3. " + BizboxAMessage.getMessage("TX800000029","작성한 양식은 [다른이름으로 저장] 하시고 업로드 하셔야 합니다.") + "\n4. " + BizboxAMessage.getMessage("TX800000030","사진 파일의 경로는 [그룹웨어 사용자 사진] 이라는 폴더를 만드신후 사용자 사진을 모두 넣으신후 폴더를 압축하여주세요.") + "\n   (" + BizboxAMessage.getMessage("TX800000031","폴더명칭은 변경하여 사용하여도 무방합니다. / 압축한 폴더를 업로드 합니다.") + ")");
		 richString.applyFont( 0, 8, setFont(wb, "맑은 고딕", (short)180, HSSFColor.RED.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 richString.applyFont( 12, 27, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BLUE.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 richString.applyFont( 32, 39, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BLUE.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 richString.applyFont( 89, 101, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BLUE.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 richString.applyFont( 121, 131, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BLUE.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 richString.applyFont( 206, 218, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BROWN.index, Font.BOLDWEIGHT_BOLD, HSSFFont.U_NONE));
		 cell.setCellValue( richString );		 
		 cell.setCellStyle(style);
		 
		 row = sheet.createRow(6);
		 row.setHeight((short)(19.5 * 25));
		 for(int i=0;i<arrColName.length;i++){
			 // 컬럼 크기 셋팅 
			 sheet.setColumnWidth(i, arrColWidth[i]);
			 
			 // 헤더 타이틀 (생성) - 인자로 받은 문자열 배열순서대로 셋팅 
			 cell = row.createCell(i);
			 cell.setCellValue(arrColName[i]);
			 
			 setCellStyleCustom(
					 wb,													//HSSFWorkbook
					 cell,													//Cell
					 true,													//fontSet
					 "맑은 고딕",												//fontName
					 (short)200,											//fontHeight
					 i == 3 ? HSSFColor.RED.index : HSSFColor.BLACK.index,	//fontColor
					 Font.BOLDWEIGHT_BOLD,									//boldWeight
					 HSSFFont.U_NONE,										//underline
					 true,													//wrapText
					 palette.findSimilarColor(204, 255, 255).getIndex(),	//fillForegroundColor
					 CellStyle.BORDER_THIN,									//borderTop
					 CellStyle.BORDER_THIN,									//borderRight
					 CellStyle.BORDER_THIN,									//borderBottom
					 CellStyle.BORDER_THIN,									//borderLeft
					 CellStyle.ALIGN_CENTER,								//alignment
					 CellStyle.VERTICAL_CENTER								//verticalAlignment
					 );
		 }		 
		 
		 /* 본문 셀 생성 */
		 createContentsStyle(wb, sheet, list, heightSize, setFont(wb, "맑은 고딕", (short)180, HSSFColor.BLACK.index, Font.BOLDWEIGHT_NORMAL, HSSFFont.U_NONE), 6);
		 
		 setFileNameToResponse(servletRequest, response, fileNm + ".xls");
		 
		 File file = null;
         FileInputStream fis = null;
			
		try{
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("osType", NeosConstants.SERVER_OS);
			Map<String, Object> pathMp = (Map<String, Object>) commonSql.select("AttachFileUpload.getBaseUploadPath", para);
			String filePath = pathMp.get("absolPath") + "/uploadTemp/" + "/excelDown/"; 		
            FileOutputStream fout = setFile(filePath, fileNm + ".xls");
            wb.write(fout);
            fout.close(); 
            
			//DRM 체크
			String drmPath = drmService.drmConvert("D", "", "E", filePath, fileNm, "xls");	

			file = new File(drmPath);
		    fis = new FileInputStream(file);

		    String orignlFileName = fileNm + ".xls";
		    
		    String browser = servletRequest.getHeader("User-Agent");
		    
		    //파일 인코딩
		    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Edge")){
		    	orignlFileName = URLEncoder.encode(orignlFileName,"UTF-8").replaceAll("\\+", "%20"); 
		    } 
		    else {
		    	orignlFileName = new String(orignlFileName.getBytes("UTF-8"), "ISO-8859-1"); 
		    } 
		    
		    response.setHeader("Content-Disposition","attachment;filename=\"" + orignlFileName+"\"");	
		    response.setContentType(CommonUtil.getContentType(file));
		    response.setHeader("Content-Transfer-Encoding", "binary;");
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
            
		}
		catch (FileNotFoundException e) {
//			System.out.println(e.getMessage());
			logger.debug(e.getMessage());
		}  catch (IOException e){
//			System.out.println(e.getMessage());
			logger.debug(e.getMessage());
		}finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception ignore) {
					//LOGGER.debug("IGNORE: {}", ignore.getMessage());
				}
			}
			if(file!=null) {//Null Pointer 역참조
			file.delete();
			}
		}
		 
	 }	 
	 
	 private FileOutputStream setFile(String filePath, String filename) throws FileNotFoundException {
	        //엑셀 파일 생성   	
	        //디렉토리 없으면 생성.
	        File fDir = new File(filePath);
	        
	        if(!fDir.exists()){
	        	fDir.mkdirs();
	        }
	            
	       FileOutputStream fout = new FileOutputStream(filePath + filename);

	       return fout;
	    }
	 
	 
	 
	    /**
		 * 가운데, 볼드, 백그라운드 그레이, 센터 정렬, 라인 두껍게 스타일
		 * @param wb
		 * @param cell
		 */
		private void setCellStyleTitleCenter(Workbook wb, Cell cell){
			Font font = wb.createFont();
			font.setFontName("Gothic");
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);
			font.setFontHeight((short)200);
			CellStyle style = wb.createCellStyle();
			style.setFont(font);
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			style.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderLeft(CellStyle.BORDER_THIN);
			style.setAlignment(CellStyle.ALIGN_CENTER);
			style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			cell.setCellStyle(style);
		}
		
		private void setCellStyleCustom(Workbook wb, Cell cell, boolean fontSet, String fontName, short fontHeight, short fontColor, short boldWeight, byte underline, boolean wrapText, short fillForegroundColor, short borderTop, short borderRight, short borderBottom, short borderLeft, short alignment, short verticalAlignment){
			
			CellStyle style = wb.createCellStyle();
			
			if(fontSet){
				Font font = wb.createFont();
				font.setFontName(fontName);	
				font.setBoldweight(boldWeight);
				font.setFontHeight(fontHeight);
				font.setColor(fontColor);
				font.setUnderline(underline);
				style.setFont(font);	
			}
			
			style.setWrapText(wrapText);			
			
			if(fillForegroundColor != -1){
				style.setFillPattern(CellStyle.SOLID_FOREGROUND);
				style.setFillForegroundColor(fillForegroundColor);	
			}
			
			style.setBorderTop(borderTop);
			style.setBorderRight(borderRight);
			style.setBorderBottom(borderBottom);
			style.setBorderLeft(borderLeft);
			style.setAlignment(alignment);
			style.setVerticalAlignment(verticalAlignment);
			cell.setCellStyle(style);
		}
		
		private Font setFont(Workbook wb, String fontName, short fontHeight, short fontColor, short boldWeight, byte underline){
			Font font = wb.createFont();
			font.setFontName(fontName);	
			font.setBoldweight(boldWeight);
			font.setFontHeight(fontHeight);
			font.setColor(fontColor);
			font.setUnderline(underline);
			return font;
		}		
		
		private void createContents( Sheet sheet, List<Map<String, Object>> contentsList, int heightSize){
			if(contentsList != null && contentsList.size() > 0){
				int i =0;
				for(Map<String, Object> contents : contentsList){
					i++;
					Row row = sheet.createRow(i);	
					row.setHeight((short)(17.5 * heightSize));
					Cell cell = null;
					
					int cnt = 0;
					for(Iterator iterator = contents.keySet().iterator();iterator.hasNext();){
						String keyName = (String)iterator.next();
						cell = row.createCell(cnt++);
						cell.setCellValue((String) contents.get(keyName));
					}
				}			
			}
		}
		
		private void createContentsStyle(Workbook wb, Sheet sheet, List<Map<String, Object>> contentsList, int heightSize, Font font, int startRowNum){
			if(contentsList != null && contentsList.size() > 0){

				CellStyle style = wb.createCellStyle();
				style.setFont(font);
				style.setBorderTop(CellStyle.BORDER_THIN);
				style.setBorderRight(CellStyle.BORDER_THIN);
				style.setBorderBottom(CellStyle.BORDER_THIN);
				style.setBorderLeft(CellStyle.BORDER_THIN);
				style.setAlignment(CellStyle.ALIGN_CENTER);
				style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
				
				int i =startRowNum;
				for(Map<String, Object> contents : contentsList){
					i++;
					Row row = sheet.createRow(i);	
					row.setHeight((short)(17.5 * heightSize));
					Cell cell = null;
					
					int cnt = 0;
					for(Iterator iterator = contents.keySet().iterator();iterator.hasNext();){
						String keyName = (String)iterator.next();
						cell = row.createCell(cnt++);
						cell.setCellValue((String) contents.get(keyName));
						cell.setCellStyle(style);
					}
				}			
			}
		}		
		
		private void setFileNameToResponse(HttpServletRequest request, HttpServletResponse response, String fileName)
		{
			String userAgent = request.getHeader("User-Agent");
			if(userAgent.indexOf("MSIE 5.5") >= 0)
			{
				response.setContentType("doesn/matter");
				response.setHeader("Content-Disposition", "filename=\"" + fileName + "\"");
			}
			else
			{
				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");				
			}
		}
		
		
		
		
		
		public List<Map<String,Object>> procDutyPositionExcelTemp(String excelFileName) throws IOException {

			 // SET LOCAL VALUE
			 List<Map<String,Object>> excelContentList = new ArrayList<>();  
			 File file  = new File(excelFileName);

			 // VALIDATE FILE  
			 if (!file.exists() || !file.isFile() || !file.canRead()) {
				 throw new IOException(excelFileName);
			 }
		  
			 try {
				 
				 Workbook wb = null;
				 
				 if (excelFileName.indexOf(".xlsx") > -1) {
					 wb = new XSSFWorkbook(new FileInputStream(file));
				 }
				 else {
					 wb = new HSSFWorkbook(new FileInputStream(file));
				 }

				 
				 int sCnt = wb.getNumberOfSheets();
				 
				 for (int i = 0 ; i < 1 ; i++) {
					 
					Sheet sheet = wb.getSheetAt(i);	// i번째 sheet 정보를 얻어옴
				    
				    int rowCnt = sheet.getPhysicalNumberOfRows() + 3;	// row 개수 얻어옴

				    int sRow = 1;
				    
				    for (int r = sRow ; r < rowCnt ; r++) {
				    	
					    Row row = sheet.getRow(r);	// row 정보 얻어옴
					    
					    int cellCnt = 0;
					    if(row != null) {		    	
					    	cellCnt = row.getLastCellNum();	// cell 개수 얻어옴
					    }
				        else {
				            continue;
				        }
					    
					    Map<String, Object> map = new HashMap<String, Object>();
					    
					    map.put("num", (r - sRow)+"");
					     
					    for (int c = 0 ; c < cellCnt ; c++) {
					    
					    	Cell cell = row.getCell(c);	//cell 정보 얻어옴
					    	
					    	String cVal = "";
					    	if (isMergedRegion(sheet, cell)) {
					    		cVal = getMergedRegionValue(sheet, cell);
					    	}
					    	else {
					    		if(cell == null) {
					    			cVal = "";
					    		}
					    		else {
					    			cVal = getCellContent(cell);
					    		}
					    	}
					    	
					    	map.put("C"+c, cVal.trim());

					    }
					    
					    boolean chk = false;
					    for(Map.Entry<String, Object> entry:map.entrySet()) {
					    	if (entry.getKey() != "num" && entry.getValue() != "") {
					    		chk = true;
					    	}
					    }

					    if (chk) {
					    	excelContentList.add(map);
					    }
				    }
				 }

			 } catch( Exception ex ) {

				 CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

			 }

			 return excelContentList;

		 }

}
