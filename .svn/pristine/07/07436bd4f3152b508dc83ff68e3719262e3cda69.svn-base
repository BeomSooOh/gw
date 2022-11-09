package neos.cmm.util;

import java.util.Calendar;
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
import org.apache.poi.hssf.util.CellRangeAddress;

import main.web.BizboxAMessage;

public class ScheduleExcelView extends NeosExcelView{

	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		String sExcelName = (String) model.get("ExcelName");

		@SuppressWarnings("unchecked")
		List<String> sColName = (List<String>) model.get("ColName");
		@SuppressWarnings("unchecked")
		List<String[]> sColValue = (List<String[]>) model.get("ColValue");

		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename="
				+ sExcelName + ".Xls");

		HSSFSheet sSheet = workbook.createSheet(sExcelName);
		//Sheet.setColumnWidth(2, 6900);
		//Sheet.setColumnWidth(3, 7900);
		// 상단 메뉴명 생성
		HSSFRow sMenuRow = sSheet.createRow(0);
		for (int i = 0; i < sColName.size(); i++) {
			HSSFCell cell = sMenuRow.createCell(i);
			cell.setCellValue(new HSSFRichTextString(sColName.get(i)));
		}
		HSSFCellStyle styleCenter = workbook.createCellStyle();
		styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		HSSFCellStyle styleLeft = workbook.createCellStyle();
		styleLeft.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		// 내용 생성
		for (int i = 0; i < sColValue.size(); i++) {
			// 메뉴 ROW가 있기때문에 +1을 해준다.
			HSSFRow sRow = sSheet.createRow(i+1);
			for (int j = 0; j < sColValue.get(i).length; j++) {
				HSSFCell sCell = sRow.createCell(j);
				String temp = null;
				if(sColValue.get(i)[j] == null){
					temp = sColValue.get(i)[j];
				}else{
					temp = sColValue.get(i)[j].replace("null", "");
				}
				
				if(j == 0){
					if(temp != null) {
						temp = getWeekDay(temp);
					}
					sCell.setCellStyle(styleCenter);
				}else if(j == 1){
					temp = getGubunTextMap(temp);
					sCell.setCellStyle(styleLeft);
				}else{
					sCell.setCellStyle(styleLeft);
				}
				sCell.setCellValue(new HSSFRichTextString(temp));
				sSheet.autoSizeColumn((short)j);
				sSheet.setColumnWidth(j, (sSheet.getColumnWidth(j))+1024 );
			}			
		}
		
		@SuppressWarnings("unchecked")
		List<Integer> merge = (List<Integer>)model.get("merge");
		int prev = 0;
		for(int i = 0;i < merge.size();i++){
			if(i == 0) {
				prev = 0;
			}
			int cnt = merge.get(i).intValue()-1;

			if(cnt - prev > 1){
				sSheet.addMergedRegion(new CellRangeAddress(prev,cnt-1,0,0));
			}
				
			prev = cnt;
		}
	}
	
	public String getWeekDay(String strDate){
    	String rtn = "";
    	String[] dayNameList = {BizboxAMessage.getMessage("TX000005656","일"),BizboxAMessage.getMessage("TX000005657","월"),BizboxAMessage.getMessage("TX000005658","화"),BizboxAMessage.getMessage("TX000005659","수"),BizboxAMessage.getMessage("TX000005660","목"),BizboxAMessage.getMessage("TX000005661","금"),BizboxAMessage.getMessage("TX000005662","토")};
		Calendar cal = Calendar.getInstance( ) ;
		
		int year = new Integer(strDate.substring(0,4)).intValue();
		int month = new Integer(strDate.substring(4,6)).intValue() -1;
		int date = new Integer(strDate.substring(6,8)).intValue();
		
		cal.set(year, month, date);
		
		rtn = strDate.substring(4,6) + "." + strDate.substring(6,8) + "(" + dayNameList[cal.get(cal.DAY_OF_WEEK)-1] + ")";
		return rtn;
	}
	
	public String getGubunTextMap(String gubun){
		String rtn = "";
		if(gubun.equals("10")){
			rtn = BizboxAMessage.getMessage("TX000000785","교육");
		}else if(gubun.equals("20")){
			rtn = BizboxAMessage.getMessage("TX000011318","회의");
		}else if(gubun.equals("60")){
			rtn = BizboxAMessage.getMessage("TX000008373","행사");
		}else{
			rtn = BizboxAMessage.getMessage("TX000005400","기타");
		}
		
		return rtn;
	}
}
