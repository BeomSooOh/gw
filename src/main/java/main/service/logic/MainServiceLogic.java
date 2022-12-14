package main.service.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.service.MainService;
import main.service.dao.MainManageDAO;
import main.web.PagingReturnObj;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.dao.MenuManageDAO;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.util.CommonUtil;

@Service("MainService")
public class MainServiceLogic implements MainService{
	
	@Resource(name = "MenuManageDAO")
	private MenuManageDAO menuManageDAO;
	
	@Resource(name = "MainManageDAO")
	private MainManageDAO mainManageDAO;
	
	@Resource(name = "CompManageService")
	private CompManageService compManageService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	private Logger LOG = LogManager.getLogger(this.getClass());
	
	@Override
	public Map<String, Object> userSeSetting(LoginVO loginVO, Map<String, Object> paramMap) {
		
		Map<String,Object> map = new HashMap<String, Object>();
		
		String bodyClass = "";
		String mainPage = "/userMain.do";
		if (loginVO.getUserSe() == null) {
			return null;
		}
		
		if (loginVO.getUserSe().equals("USER")) {
			mainPage = "/userMain.do";
		}
		else if (loginVO.getUserSe().equals("ADMIN")) {
			if(paramMap.get("type") != null && paramMap.get("type").equals("main")){
				bodyClass = "admin main_bg"; 
			}else{
				bodyClass = "admin";
			}
			mainPage = "/adminMain.do";
			
		} else if (loginVO.getUserSe().equals("MASTER")) {
			
			if(paramMap.get("type") != null && paramMap.get("type").equals("main")){
				bodyClass = "admin main_bg"; 
			}else{
				bodyClass = "admin";
			}
			mainPage = "/masterMain.do";
		}

		map.put("bodyClass", bodyClass);
		
		map.put("mainPage", mainPage);
		
		map.put("userSe", loginVO.getUserSe());
		
		map.put("id", loginVO.getId());
		
		
		return map;
		
	}
	
	@Override
	public List<Map<String, Object>> getTopMenuList(LoginVO loginVO) {
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();

		if (loginVO.getUserSe().equals("USER")) {
			String authCode = loginVO.getAuthorCode();
			if (!EgovStringUtil.isEmpty(authCode)) {
				String[] authArr = authCode.split("#");
				Map<String,Object> params = new HashMap<String,Object>();
				params.put("id", loginVO.getId()); 
				params.put("authCodeList", authArr);
				params.put("level", 1);
				params.put("compSeq", loginVO.getCompSeq());
				params.put("langCode", loginVO.getLangCode());
				params.put("startWith", 0);
				params.put("userSe", loginVO.getUserSe());
				list = menuManageDAO.selectMenuTreeList(params);
			}
		}
		else if (loginVO.getUserSe().equals("ADMIN")) {
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("empSeq", loginVO.getUniqId());
			params.put("startWith", 0);
			params.put("langCode", loginVO.getLangCode());
			params.put("level", 1);
			params.put("menuGubun", loginVO.getUserSe());
			params.put("menuAuthType", loginVO.getUserSe());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("userSe", loginVO.getUserSe());
			params.put("id", loginVO.getId());
			list = menuManageDAO.selectAdminMenuTreeListAuth(params);
		} else if (loginVO.getUserSe().equals("MASTER")) {
			Map<String,Object> params = new HashMap<String,Object>();
			params.put("empSeq", loginVO.getUniqId());
			params.put("startWith", 1);
			params.put("langCode", loginVO.getLangCode());
			params.put("level", 1);
			params.put("menuGubun", loginVO.getUserSe());
			params.put("menuAuthType", loginVO.getUserSe());
			params.put("compSeq", loginVO.getCompSeq());
			params.put("userSe", loginVO.getUserSe());
			list = menuManageDAO.selectAdminMenuTreeListAuth(params);
		}
		
		return list;
	}	

	@Override
	public List<Map<String, Object>> getMyMenuList(Map<String, Object> params) {
		
		return menuManageDAO.selectMyMenuList(params);
	}

	@Override
	public void insertMyMenuList(Map<String, Object> param) {
		menuManageDAO.insertMyMenuList(param);
	}

	@Override
	public void deleteMyMenuList(Map<String, Object> params) {
		menuManageDAO.deleteMyMenuList(params);
	}

	@Override
	public Object isMyMenuCheck(List<Map<String, Object>> myMenuList, Map<String, Object> m) {

		String menuNo = m.get("menuNo")+"";
		
		if (menuNo.equals("null")) {
			menuNo = "";
		}
		
		for(Map<String,Object> myMenu : myMenuList) {
			String myMenuNo = myMenu.get("menuNo")+"";
			
			if (myMenuNo.equals(menuNo)) {
				return "checked";
			}
		}
		
		return "";
	}

	@Override
	public Map<String, Object> selectMainPortlet(Map<String, Object> params) {
		
		List<Map<String,Object>> list = mainManageDAO.selectMainPortlet(params);
		
		if (list != null && list.size() > 0) {
			return list.get(0);
		}
		
		return new HashMap<String,Object>();
	}

	@Override
	public List<Map<String, Object>> selectMainPortletList(Map<String, Object> params) {
		return mainManageDAO.selectMainPortlet(params);
	}

	@Override
	public List<Map<String, Object>> selectAlertReceiverList(Map<String, Object> params) {
		return mainManageDAO.selectAlertReceiverList(params);
	}

	@Override
	public Map<String, Object> selectAlertReceiverReadCnt(Map<String, Object> params) {
		return mainManageDAO.selectAlertReceiverReadCnt(params);
	}

	@Override
	public int updateAlertReceiver(Map<String, Object> params) {
		return mainManageDAO.updateAlertReceiver(params);
	}

	@Override
	public String selectAdminAuthCnt(Map<String, Object> params) {
		return mainManageDAO.selectAdminAuthCnt(params);
	}
	
	@Override
	public String selectMasterAuthCnt(Map<String, Object> params) {
		return mainManageDAO.selectMasterAuthCnt(params);
	}
	
	@Override
	public Map<String, Object> selectTokenInfo(Map<String, Object> params) {
		return mainManageDAO.selectTokenInfo(params);
	}
	
	@Override
	public Map<String, Object> selectLinkMenuInfo(Map<String, Object> params) throws Exception {
		return mainManageDAO.selectLinkMenuInfo(params);
	}	
	
	@Override
	public Map<String, Object> selectCustInfo(Map<String, Object> params) {
		return mainManageDAO.selectCustInfo(params);
	}	

	@Override
	public Map<String, Object> testSQL(Map<String, Object> params) {
		return mainManageDAO.testSQL(params);
	}

	@Override
	public void deleteAlert(Map<String, Object> params) {
		mainManageDAO.deleteAlert(params);
	}

	@Override
	public void deleteAlertReceiver(Map<String, Object> params) {
		mainManageDAO.deleteAlertReceiver(params);
	}

	@Override
	public void alertRemoveNew(Map<String, Object> params) {
		mainManageDAO.alertRemoveNew(params);
	}
	
	@Override
	public PagingReturnObj tsearchList(Map<String,String> params, String listType){
		LOG.info("tsearchList-start. listType=" + listType);
		PagingReturnObj result = new PagingReturnObj();
		try{
			LOG.info("tsearchList-end. listType=" + listType);
		}catch(Exception e){
			LOG.error("tsearchList-error. listType=" + listType, ", params : "+params, e);
			CommonUtil.printStatckTrace(e);//?????????????????? ?????? ????????????
		}
		//mainManageDAO.tsearchList(params, listType, cntDiv);
		//result.setResultgrid(this.campaignDAO.selectList(param));
		//result.setTotalcount(this.campaignDAO.selectCount(param));
		return result;
	}
	
	@Override
	public PagingReturnObj tsearchHrList(Map<String,String> params, String listType){
		LOG.info("tsearchHrList-start. listType=" + listType);
		PagingReturnObj result = new PagingReturnObj();
		try{
			LOG.info("tsearchHrList-end. listType=" + listType);
		}catch(Exception e){
			LOG.error("tsearchHrList-error. listType=" + listType, ", params : " +params, e);
		}
		//mainManageDAO.tsearchList(params, listType, cntDiv);
		//result.setResultgrid(this.campaignDAO.selectList(param));
		//result.setTotalcount(this.campaignDAO.selectCount(param));
		return result;
	}

	@Override
	public void mailAlertRemoveNew(Map<String, Object> params) {
		commonSql.update("MainManageDAO.mailAlertRemoveNew", params);
	}

	@Override
	public List<Map<String, Object>> getAlaramCompList(Map<String, Object> params) {
		return commonSql.list("MainManageDAO.getAlaramCompList", params);
	}

	@Override
	public Map<String, Object> getCompMailDomain(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("MainManageDAO.getCompMailDomain", params);
	}
	
	@Override
	public String getDeptPathTotalSearch(Map<String, Object> params) {
		return (String) commonSql.select("MainManageDAO.getDeptPathTotalSearch", params);
	}
	
	@Override
	public String getTotalSearchMailDomain(Map<String, String> params) {
		return (String) commonSql.select("MainManageDAO.getTotalSearchMailDomain", params);
	}
	
	@Override
	public List<String> getTotalSearchMenuAuth(Map<String, String> params) {
		return commonSql.list("MainManageDAO.getTotalSearchMenuAuth", params);
	}
	
}
