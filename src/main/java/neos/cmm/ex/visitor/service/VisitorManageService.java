package neos.cmm.ex.visitor.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface VisitorManageService {

	Map<String, Object> getVisitorList(Map<String, Object> paramMap, PaginationInfo paginationInfo);

	void insertVisitor(Map<String, Object> paramMap);

	void DeleteVisitor(Map<String, Object> paramMap) throws Exception;

	Map<String, Object> GetVisitor(Map<String, Object> paramMap);

	List<Map<String, Object>> GetApproverList(Map<String, Object> paramMap);

	void CheckVisitor(Map<String, Object> paramMap);

	List<Map<String, Object>> GetVisitorWeekList(Map<String, Object> paramMap);

	Map<String, Object> GetVisitorListApp(Map<String, Object> paramMap, PaginationInfo paginationInfo);

	void SetVisitorApp(Map<String, Object> paramMap);

	void SetVisitApproval(Map<String, Object> paramMap);

	Map<String,Object> GetAppInfo(Map<String, Object> paramMap);
	
	Map<String, Object> sendMMSQrImage(Map<String, Object> paramMap);

	Map<String, Object> InsertVisitorExt(Map<String, Object> paramMap);

	void UpdateDocId(Map<String, Object> reqeust);

	Map<String, Object> getVisitorPopContent(Map<String, Object> paramMap);

	/* 전자결재 외부연동 API*/
	void UpdateAppvDocSts(Map<String, Object> request);

	Map<String, Object> getRNoList(Map<String, Object> paramMap);

	Map<String, Object> updateVisitor(Map<String, Object> paramMap) throws Exception;

	int checkEapDoc(Map<String, Object> request);

	void deleteReqData(Map<String, Object> request);

	void DeleteVisitorByAppv(Map<String, Object> request);

	Map<String, Object> getQrListTotalCount(Map<String, Object> request);

	Map<String, Object> InsertVisitorNew(Map<String, Object> paramMap) ;

	Map<String, Object> getNormalVisitorList(Map<String, Object> paramMap, PaginationInfo paginationInfo);

	Map<String, Object> getVisitorNew(Map<String, Object> paramMap) throws Exception;

	String getEmpTelNum(Map<String, Object> request);

	Map<String, Object> CheckVisitorNew(Map<String, Object> paramMap);

	Map<String, Object> CheckVisitCard(Map<String, Object> paramMap);

	String getEaDocFormId(Map<String, Object> paramMap);

	int getEaDocId(Map<String, Object> request);
	
	Map<String, Object> insertSchedule(Map<String, Object> paramMap);

	Map<String, Object> checkCalendar(Map<String, Object> paramMap);
	
	Map<String, Object> tMapConnect(Map<String, Object> paramMap) throws Exception;

	Map<String, Object> tMapConnectSetting(Map<String, Object> rNoListAndQrSendYn) throws Exception;

	Map<String, Object> checkVisitCarNo(Map<String, Object> paramMap);

	void DeleteVisitorNew(Map<String, Object> paramMap) throws Exception;

	Map<String, Object> getTmapList(Map<String, Object> paramMap) throws Exception;

	List<Map<String, Object>> getQrPlaceCertificationData(Map<String, Object> paramMap);
}
