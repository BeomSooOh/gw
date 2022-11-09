package neos.cmm.systemx.partner.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public interface PartnerManageService {

	Map<String, Object> selectPartnerInfo(Map<String, Object> params);

	void insertPartnerMain(Map<String, Object> params);

	void insertPartnerDetail(Map<String, Object> params);

	Map<String, Object> selectPartnerList(Map<String, Object> params, PaginationInfo paginationInfo);

	void deletePartnerInfo(Map<String, Object> params);
	
	void deletePartnerDetail(Map<String, Object> params);

	List<Map<String, Object>> selectPartnerDetailList(Map<String, Object> params);

	List<Map<String, Object>> selectErpPartner(Map<String, Object> params);

	void updatePartnerMainStatus(Map<String, Object> map);

	void updatePartnerMainFromErp(Map<String, Object> map);

	void insertPartnerMainFromErp(Map<String, Object> map);

	void insertPartnerDetailFromErp(Map<String, Object> map);

	void updatePartnerDetailFromErp(Map<String, Object> map);

	void updatePartnerRestore(Map<String, Object> params);

	Map<String, Object> selectPartnerDetailList(Map<String, Object> params, PaginationInfo paginationInfo);
	
	List<Map<String, Object>> selectCompList(Map<String, Object> params);
 
}
