package neos.cmm.erp.batch.service;

import java.util.List;
import java.util.Map;

public interface ErpProjectService {
	public List<Map<String,Object>> selectProjectList(Map<String,Object> params);

	public void syncProjectFromErp();
}
