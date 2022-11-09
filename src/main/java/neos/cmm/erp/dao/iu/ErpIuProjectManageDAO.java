package neos.cmm.erp.dao.iu;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import neos.cmm.erp.dao.ErpIuDefaultDAO;

@Repository("ErpIuProjectManageDAO")
public class ErpIuProjectManageDAO extends ErpIuDefaultDAO {
	
	public List<Map<String,Object>> selectProjectList(Map<String,Object> params) {
		return (List<Map<String, Object>>) list("ErpIuProjectManageDAO.selectProjectList",params);
	}

	public List<Map<String, Object>> selectProjectDeleteList(Map<String, Object> params) {
		return (List<Map<String, Object>>) list("ErpIuProjectManageDAO.selectProjectDeleteList",params);
	}
	
}
