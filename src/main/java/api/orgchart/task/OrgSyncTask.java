package api.orgchart.task;


import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.scheduling.annotation.Async;

import api.common.dao.APIDAO;
import api.orgchart.service.ApiOrgchartService;
import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;

public class OrgSyncTask {
	private static Log logger = LogFactory.getLog(OrgSyncTask.class);
	
	
	@Resource(name="APIDAO")
	private APIDAO apiDAO;

	@Resource(name="ApiOrgchartService")
	ApiOrgchartService apiOrgchartService;
	
	@Async
	public void pollingOrgSync() {
		
		if(!BizboxAProperties.getProperty("BizboxA.mode").equals("live") || !BizboxAProperties.getProperty("BizboxA.ReserveMessageTimer").equals("0")) {
			return;
		}
		
		JedisClient jedis = CloudConnetInfo.getJedisClient();
		
		List<Map<String, String>> list = jedis.getCustInfoList();
		
		logger.debug("OrgSyncTask.pollingOrgSync list : " + list);
		
		for(Map<String, String> mp : list){
			try {
				
				if(mp.get("OPERATE_STATUS") != null && mp.get("OPERATE_STATUS").equals("20")) {
					logger.debug("OrgSyncTask.pollingOrgSync start....");
					logger.debug("jedis Parameter : " + mp);
					apiOrgchartService.pollingOrgSync(mp.get("GROUP_SEQ"), "Y", false);
					logger.debug("OrgSyncTask.pollingOrgSync end.....");
				}
				
			}catch(Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				logger.error("OrgSyncTask.pollingOrgSync error > jedis Parameter : " + mp);
			}
		}
	}
}
