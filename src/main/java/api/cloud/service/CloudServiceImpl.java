package api.cloud.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import api.common.model.APIResponse;


@Service("CloudService")
public class CloudServiceImpl implements CloudService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public APIResponse setGwVolumeFromGCMS(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		try{			
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			String groupSeq = (String) body.get("groupSeq");
			float volLimit = Float.parseFloat(body.get("volLimit").toString());
			
			if(volLimit < 0){
				//그룹웨어 계약용량 오류
				return response;
			}else{
				Map<String, Object> para = new HashMap<String, Object>();
				para.put("groupSeq", groupSeq);
				para.put("volLimit", volLimit);
				para.put("idx", (String) commonSql.select("apiMainDAO.getGwVolumeIdx", para));		
				
				Map<String, Object> oldVolume = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", para);
				
				if(oldVolume == null || groupSeq.equals("")){
					response.setResultCode("FAIL");
					response.setResultMessage(BizboxAMessage.getMessage("TX800000001","그룹정보(groupSeq)를 찾을 수 없습니다."));
					return response;
				}
				
				float oldMailVolume = oldVolume.get("mailVolume") == null || oldVolume.get("mailVolume").equals("") ? 0 :  Float.parseFloat(oldVolume.get("mailVolume").toString());
				
				volLimit -=  oldMailVolume;
				
				para.put("gwVolume", volLimit);
				para.put("mailVolume", oldMailVolume);
				para.put("target", "GCMS");
				
				//계약용량 이력테이블 insert
				commonSql.insert("apiMainDAO.insertGwVolumeHistory", para);
				
				//계약용량 update
				commonSql.update("apiMainDAO.updateGwVolume", para);
				
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}
			
			
		}catch(Exception e){
			response.setResultCode("FAIL");
			response.setResultMessage(e.getMessage());
		}	
		return response;
	}
	
	static String bizboxCloudNoticeInfo = "";
	
	public void setBizboxCloudNoticeInfo(String val) {
		bizboxCloudNoticeInfo = val;
	}
	
	public String getBizboxCloudNoticeInfo() {
		return bizboxCloudNoticeInfo;
	}

}
