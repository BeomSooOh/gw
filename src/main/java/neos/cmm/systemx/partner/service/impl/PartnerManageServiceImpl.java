package neos.cmm.systemx.partner.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.partner.service.PartnerManageService;

@Service("PartnerManageService")
public class PartnerManageServiceImpl implements PartnerManageService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectPartnerInfo(Map<String, Object> params) {
		
		return (Map<String, Object>)commonSql.select("PartnerManageDAO.selectPartnerInfo", params);
	}

	@Override
	public void insertPartnerMain(Map<String, Object> params) {
		commonSql.insert("PartnerManageDAO.insertPartnerMain", params);
	}

	@Override
	public void insertPartnerDetail(Map<String, Object> params) {
		commonSql.insert("PartnerManageDAO.insertPartnerDetail", params);
	}

	@Override
	public Map<String, Object> selectPartnerList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "PartnerManageDAO.selectPartnerList");
	}

	@Override
	public void deletePartnerInfo(Map<String, Object> params) {
		commonSql.delete("PartnerManageDAO.deletePartnerMain", params);
		deletePartnerDetail(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectPartnerDetailList(Map<String, Object> params) {
		return commonSql.list("PartnerManageDAO.selectPartnerDetailList", params);
	}

	@Override
	public void deletePartnerDetail(Map<String, Object> params) {
		commonSql.delete("PartnerManageDAO.deletePartnerDetail", params);
		
	}

	@Override
	public List<Map<String, Object>> selectErpPartner(Map<String, Object> params) {
		return commonSql.list("PartnerManageDAO.selectErpPartner", params);
	}

	@Override
	public void updatePartnerMainStatus(Map<String, Object> map) {
		commonSql.update("PartnerManageDAO.updatePartnerMainStatus", map);
		
	}

	@Override
	public void updatePartnerMainFromErp(Map<String, Object> map) {
		commonSql.update("PartnerManageDAO.updatePartnerMainFromErp", map);
		
	}

	@Override
	public void insertPartnerMainFromErp(Map<String, Object> map) {
		commonSql.insert("PartnerManageDAO.insertPartnerMainFromErp", map);
		
	}

	@Override
	public void insertPartnerDetailFromErp(Map<String, Object> map) {
		commonSql.insert("PartnerManageDAO.insertPartnerDetailFromErp", map);
		
	}

	@Override
	public void updatePartnerDetailFromErp(Map<String, Object> map) {
		commonSql.update("PartnerManageDAO.updatePartnerDetailFromErp", map);
		
	}

	@Override
	public void updatePartnerRestore(Map<String, Object> params) {
		commonSql.update("PartnerManageDAO.updatePartnerRestore", params);
		
	}

	@Override
	public Map<String, Object> selectPartnerDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(params, paginationInfo, "PartnerManageDAO.selectPartnerDetailList");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectCompList(Map<String, Object> params) {
		return commonSql.list("PartnerManageDAO.selectCompList", params);
	}	
	
}
