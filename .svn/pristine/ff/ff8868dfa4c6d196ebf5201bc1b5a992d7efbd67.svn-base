package restful.fund.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import restful.fund.dao.FundDAO;
import restful.fund.service.FundService;

@Service("FundService")
public class FundServiceImpl implements FundService {

	@Resource(name = "FundDAO")
	private FundDAO fundDAO;

	public List<Map<String, Object>> getSmartMenuAuthList(Map<String, Object> params) throws Exception {
		Map<String, Object> returnObj = new HashMap<String,Object>();
		List<String> compSeqList = new ArrayList<String>();
		
		List<Map<String, Object>> originData = fundDAO.getSmartMenuAuthList(params);
		
		if(originData.size() > 0) {
			/* Lv 1*/
			for(int i=0; i<originData.size(); i++) {
				String compSeq = originData.get(i).get("compSeq").toString();
				
				if(returnObj.get(compSeq) == null){
					compSeqList.add(compSeq);
					returnObj.put(compSeq, new HashMap<String, Object>());
				}
			}
			
			/* Lv 2*/
			for(int i=0; i<originData.size(); i++) {
				String compSeq = originData.get(i).get("compSeq").toString();
				String erpCompName = originData.get(i).get("erpCompName").toString();
				String erpCompSeq = originData.get(i).get("erpCompSeq").toString();
				String deptSeq = originData.get(i).get("deptSeq").toString();

				Map<String, Object> menuObj = (Map<String, Object>) returnObj.get(compSeq); 
				
				menuObj.put("compSeq", compSeq);
				menuObj.put("erpCompName", erpCompName);
				menuObj.put("erpCompSeq", erpCompSeq);
				menuObj.put("deptSeq", deptSeq);
				menuObj.put("menuList", new ArrayList<Map<String, Object>>());
				menuObj.put("erpBizList", new ArrayList<Map<String, Object>>());
			}
			
			/* Lv 3, 4*/
			List<String> bizKeys = new ArrayList<String>();
			List<String> menuKeys = new ArrayList<String>();
			
			
			for(int i=0; i<originData.size(); i++) {
				String compSeq = originData.get(i).get("compSeq").toString();
				String erpCompSeq = originData.get(i).get("erpCompSeq").toString();
				String erpBizSeq = originData.get(i).get("erpBizSeq").toString();
				String menuType = originData.get(i).get("menuType").toString();
				
				Map<String, Object> menuObj = (Map<String, Object>) returnObj.get(compSeq); 
				Map<String, Object> menuItem = new HashMap<String, Object>();
				Map<String, Object> erpBizItem = new HashMap<String, Object>();
				
				String bizKey = compSeq + "|" + erpBizSeq;
				menuItem.put("menuCode", originData.get(i).get("menuType"));
				menuItem.put("menuNm", originData.get(i).get("menuName"));
				menuItem.put("useYN", originData.get(i).get("useYN"));
				
				if(!bizKeys.contains(bizKey)) {
					bizKeys.add(bizKey);
					((List<Map<String, Object>>)menuObj.get("erpBizList")).add(erpBizItem);
				}
				
				String menuKey = compSeq + "|" + menuType;
				erpBizItem.put("erpBizSeq", originData.get(i).get("erpBizSeq").toString().substring(1));
				erpBizItem.put("erpBizName", originData.get(i).get("erpBizName"));
				
				if(!menuKeys.contains(menuKey)) {
					menuKeys.add(menuKey);
					((List<Map<String, Object>>)menuObj.get("menuList")).add(menuItem);
				}
				
			}
			
			List<Map<String, Object>> authList = new ArrayList<Map<String,Object>>();
			
			for(String item : compSeqList) {
				authList.add((Map<String, Object>)returnObj.get(item));
			}

			return authList;
			
		}

		return null;
	}
}
