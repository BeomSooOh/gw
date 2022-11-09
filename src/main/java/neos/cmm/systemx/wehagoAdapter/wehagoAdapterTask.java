package neos.cmm.systemx.wehagoAdapter;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Async;

import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;
import neos.cmm.systemx.wehagoAdapter.dao.wehagoAdapterDAO;

public class wehagoAdapterTask {

	@Resource(name="wehagoAdapterService")
	public wehagoAdapterService wehagoManageService;	
	
	@Resource(name = "wehagoAdapterDAO")
    private wehagoAdapterDAO wehagoAdapterDAO;		
	
	/* ERP 조직도 자동 동기화  */
	@Async
	public void pollingWehagoOrgSyncAuto(){
		return;
	}
}
