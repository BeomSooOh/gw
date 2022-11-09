package neos.cmm.systemx.ldapAdapter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Async;

import bizbox.orgchart.util.JedisClient;
import cloud.CloudConnetInfo;
import neos.cmm.systemx.ldapAdapter.service.LdapAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.systemx.ldapAdapter.dao.LdapAdapterDAO;

public class LdapAdapterTask {

	@Resource(name="LdapAdapterService")
	public LdapAdapterService ldapManageService;	
	
	@Resource(name = "LdapAdapterDAO")
    private LdapAdapterDAO ldapAdapterDAO;		
	
	/* ERP 조직도 자동 동기화  */
	@Async
	public void pollingLdapOrgSyncAuto() throws Exception{
		
		if(!BizboxAProperties.getProperty("BizboxA.mode").equals("live") || !BizboxAProperties.getProperty("BizboxA.ReserveMessageTimer").equals("0")) {
			return;
		}
		
		if (!BizboxAProperties.getCustomProperty("BizboxA.Cust.LdapUseYn").equals( "Y" ) ) {
			return;
		}		
		
		JedisClient jedis = CloudConnetInfo.getJedisClient();		
		List<Map<String, String>> list = jedis.getCustInfoList();
		
		for(Map<String, String> mp : list){
			
			if(mp.get("OPERATE_STATUS") != null && mp.get("OPERATE_STATUS").equals("20")) {
				Map<String, Object> ldapAutoSyncParams = new HashMap<String, Object>();
				
				//싱크요청 로그저장
				ldapAutoSyncParams.put("inputParam", "");
				ldapAutoSyncParams.put("apiName", "pollingLdapOrgSyncAuto Start");
				ldapAutoSyncParams.put("errorMsg", "");
				ldapAutoSyncParams.put("groupSeq", mp.get("GROUP_SEQ"));
				ldapAdapterDAO.insertLdapApiLog(ldapAutoSyncParams);
				
				Calendar calendar = Calendar.getInstance();
		        java.util.Date date = calendar.getTime();
		        String hhmm = (new SimpleDateFormat("HH").format(date)) + "00";
				ldapAutoSyncParams.put("schTime", hhmm);
				
				List<Map<String,Object>> ldapSchSetInfoList = ldapAdapterDAO.getLdapSchSetInfoList(ldapAutoSyncParams);
				
				if(ldapSchSetInfoList != null && ldapSchSetInfoList.size() > 0){
					
					for(Map<String, Object> ldapSchSetInfo : ldapSchSetInfoList) {
						
						ldapAutoSyncParams.putAll(ldapSchSetInfo);
		
						ldapAutoSyncParams.put("inputParam", ldapSchSetInfo.toString());
						ldapAutoSyncParams.put("apiName", "pollingLdapOrgSyncAuto");
						ldapAutoSyncParams.put("errorMsg", "HHmm : " + hhmm);
						ldapAdapterDAO.insertLdapApiLog(ldapAutoSyncParams);    				
						
						//연결상태 체크
						Map<String, Object> ldapConnectionCheck = ldapManageService.ldapConnectionCheck(ldapSchSetInfo);
						
						if(ldapConnectionCheck.get("resultCode").equals("SUCCESS")){
							//연결 성공
							ldapAutoSyncParams.put("inputParam", ldapSchSetInfo.toString());
							ldapAutoSyncParams.put("apiName", "ldapConnectionCheck");
							ldapAutoSyncParams.put("errorMsg", "SUCCESS");
							ldapAdapterDAO.insertLdapApiLog(ldapAutoSyncParams);
							
							
							List<Map<String,Object>> ldapSyncTargetList = ldapAdapterDAO.selectLdapSyncTargetList(ldapAutoSyncParams);
							
							if(ldapSyncTargetList != null && ldapSyncTargetList.size() > 0){
								
								//동기화 요청테이블 입력
								String newSyncSeq = UUID.randomUUID().toString().replace("-", "");
								ldapAutoSyncParams.put("syncSeq", newSyncSeq);
								ldapAutoSyncParams.put("syncMode", "A");
								ldapAdapterDAO.insertLdapReq(ldapAutoSyncParams);
								
								for(Map<String, Object> ldapSyncTarget : ldapSyncTargetList) {
									ldapAutoSyncParams.putAll(ldapSyncTarget);
									ldapAutoSyncParams.put("syncSeq", newSyncSeq);
									
									if(ldapAutoSyncParams.get("orgDiv").equals("D")){
										ldapManageService.ldapDeptSave(ldapAutoSyncParams);
									}else{
										ldapManageService.ldapEmpSave(ldapAutoSyncParams);
									}
								}
							}
						}else{
							//연결 실패로그 기록
							ldapAutoSyncParams.put("inputParam", ldapSchSetInfo.toString());
							ldapAutoSyncParams.put("apiName", "ldapConnectionCheck");
							ldapAutoSyncParams.put("errorMsg", ldapConnectionCheck.get("result"));
							ldapAdapterDAO.insertLdapApiLog(ldapAutoSyncParams);    
						}
					}
				}				
			}
		}
	}
}
