package neos.cmm.erp.batch.service;

import java.util.List;
import java.util.Map;

public interface ErpPartnerService {
	public List<Map<String,Object>> selectPartnerList(Map<String,Object> params);

	public void syncPartnerFromErp();
}
