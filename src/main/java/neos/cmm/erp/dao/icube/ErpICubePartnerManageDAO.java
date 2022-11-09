package neos.cmm.erp.dao.icube;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import neos.cmm.erp.dao.ErpICubeDefaultDAO;

@Repository("ErpICubePartnerManageDAO")
public class ErpICubePartnerManageDAO extends ErpICubeDefaultDAO{

	public List<Map<String, Object>> selectPartnerList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpICubePartnerManageDAO.selectPartnerList",params);
	}

	public List<Map<String, Object>> selectPartnerDeleteList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpICubePartnerManageDAO.selectPartnerDeleteList",params);
	}

	public List<Map<String, Object>> selectPartnerDetailList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpICubePartnerManageDAO.selectPartnerDetailList",params);
	}

}
