package neos.cmm.ex.bizcar.service;

import java.util.List;
import java.util.Map;

public interface BizCarManageService {

	List<Map<String, Object>> getBizCarBookMarkList(Map<String, Object> paramMap);
	
	int deleteBookMarkData(Map<String, Object> paramMap) throws Exception;
	
	public List<Map<String, Object>> getBizCarDataList(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getDetailRowData(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> checkBizCarBatchInfo(Map<String, Object> paramMap);
	
	public void insertBizCarData(Map<String, Object> paramMap);
	
	public void deleteBizCarData(Map<String, Object> paramMap);
	
	public void insertBizCarBatch(Map<String, Object> paramMap);
	
	public void deleteBizCarBatchData(Map<String, Object> paramMap);
	
	public void saveBizCarBatchData(Map<String, Object> paramMap);
	
	public void updateAmtData(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getBizCarDetailList(Map<String, Object> paramMap);	
	
	public List<Map<String, Object>> getDetailViewRowData(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> selectBizCarViewExcelList(Map<String, Object> paramMap);
	
	public void setBizCarUserAddress(Map<String, Object> paramMap);
	
	public Map<String, Object> getBizCarUserAddress(Map<String, Object> paramMap);		
	
	public void reCalculationData(Map<String, Object> paramMap);
	
	public int insertBookMarkData(Map<String, Object> paramMap);
	
	public void bizCarErpSendInsert(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getErpSendInfo(Map<String, Object> paramMap);
	
	public void bizCarErpSendDelete(Map<String, Object> paramMap);
	
	public List<Map<String, Object>> getDivideRowList(Map<String, Object> paramMap);
	
	public void updateDivideRowList(Map<String, Object> paramMap);
	
	public int getMaxSeq();
	
	public int getMaxBmSeq();
	
	public void copyBizCarData(Map<String, Object> paramMap);
	
	public void saveBookMarkList(Map<String, Object> paramMap);
	
	public Map<String, Object> getCarAfterKm(Map<String, Object> paramMap);
	
	public Map<String, Object> getCarNum(Map<String, Object> paramMap);

}
