package api.poi.service;

import java.util.List;
import java.util.Map;
import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;


@Service("ExcelService")
public interface ExcelService {

	public List<Map<String, Object>> procExtractExcel(String excelFileName) throws IOException;
	
	public List<Map<String, Object>> procExtractExcel2(String excelFileName) throws IOException;
	
	public List<Map<String, Object>> procExtractExcelTemp(String excelFileName) throws IOException;
	
	public List<Map<String, Object>> procAddrExcelTemp(String excelFileName) throws IOException;
	
	public List<Map<String, Object>> procDutyPositionExcelTemp(String excelFileName) throws IOException;
	
	public void CmmExcelDownload(List<Map<String, Object>> list, String[] arrCol, String fileNm, HttpServletResponse response, HttpServletRequest servletRequest);
	
	public void CmmExcelDownloadAddContents(List<Map<String, Object>> list, int[] arrColWidth, String[] arrColName, String fileNm, HttpServletResponse response, HttpServletRequest servletRequest);

}
