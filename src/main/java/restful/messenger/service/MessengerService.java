package restful.messenger.service;

import java.util.List;
import java.util.Map;

import restful.messenger.vo.MessengerLoginVO;


public interface MessengerService {
	 
	public List<MessengerLoginVO> actionLoginMobile(MessengerLoginVO param);

	public List<Map<String,Object>> selectLoginVO(MessengerLoginVO vo);	
	
	public String selectLoginPassword(MessengerLoginVO param) throws Exception;
	
	public List<Map<String,Object>> selectOrgImgList(Map<String,Object> vo);

	public String fileSave(List<Map<String, Object>> fileList, Map<String, Object> params) throws Exception;
	
	public List<Map<String,Object>> selectAlertInfo(MessengerLoginVO vo);
	
	public List<Map<String, Object>> selectOptionListMessanger(Map<String, Object> param);
	
	public String getPasswdStatusCode(Map<String, Object> params);
}
 

