package neos.cmm.util;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import egovframework.com.utl.fcc.service.EgovFormBasedUUID;

public class NeosExcelView extends AbstractExcelView{
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String sExcelName = (String) model.get("ExcelName");

		List<String> lColName = (List<String>) model.get("ColName");
		List<String[]> lColValue = (List<String[]>) model.get("ColValue");
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename="
				+ sExcelName + ".xls");
		
		HSSFSheet sheet = workbook.createSheet(sExcelName);
		String excelSecretYN =  (String)model.get("excelSecretYN") ;
		if("Y".equals(excelSecretYN)) {
			sheet.protectSheet(EgovFormBasedUUID.randomUUID().toString());
		}
		
		// 상단 메뉴명 생성
		HSSFRow menuRow = sheet.createRow(0);
		for (int i = 0; i < lColName.size(); i++) {
			HSSFCell cell = menuRow.createCell(i);
			cell.setCellValue(new HSSFRichTextString(lColName.get(i)));
		}

		HSSFCellStyle styleCenter = workbook.createCellStyle();
		styleCenter.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		if("Y".equals(excelSecretYN)) {
			styleCenter.setLocked(true);
		}
		
		// 내용 생성
		for (int i = 0; i < lColValue.size(); i++) {
			// 메뉴 ROW가 있기때문에 +1을 해준다.
			HSSFRow row = sheet.createRow(i+1);
			for (int j = 0; j < lColValue.get(i).length; j++) {
				HSSFCell cell = row.createCell(j);
				String temp = null;
				if(lColValue.get(i)[j] == null){
					temp = lColValue.get(i)[j];
				}else{
					temp = lColValue.get(i)[j].replace("null", "");
				}
				cell.setCellValue(new HSSFRichTextString(temp));
			}
		}
		
		if(model.get("add") != null){
			List<String> lColName2 = (List<String>) model.get("ColName2");
			List<String[]> lColValue2 = (List<String[]>) model.get("ColValue2");
			// 상단 메뉴명 생성
			menuRow = sheet.createRow(lColValue.size()+1);
			for (int i = 0; i < lColName2.size(); i++) {
				HSSFCell cell = menuRow.createCell(i);
				cell.setCellValue(new HSSFRichTextString(lColName2.get(i)));
			}
			// 내용 생성
			for (int i = 0; i < lColValue2.size(); i++) {
				// 메뉴 ROW가 있기때문에 +1을 해준다.
				HSSFRow row = sheet.createRow(i+lColValue.size()+2);
				for (int j = 0; j < lColValue2.get(i).length; j++) {
					HSSFCell cell = row.createCell(j);
					String temp = null;
					if(lColValue2.get(i)[j] == null){
						temp = lColValue2.get(i)[j];
					}else{
						temp = lColValue2.get(i)[j].replace("null", "");
					}
					cell.setCellValue(new HSSFRichTextString(temp));
					cell.setCellStyle(styleCenter);
					styleCenter.setWrapText(true);
				}
			}
		}

	}

}
