package neos.cmm.menu.service.logic;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.menu.service.dao.MenuManageDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.JsonUtil;
import neos.cmm.util.BizboxAProperties;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;

import neos.cmm.util.AESCipher;
import neos.cmm.util.Secure;

@Service("MenuManageService")
public class MenuManageServiceLogic implements MenuManageService {

	@Resource(name = "MenuManageDAO")
	private MenuManageDAO menuManageDAO;
	
	@Resource(name = "commonSql")
	 private CommonSqlDAO commonSql;
    
	@Override
	public int getChildCnt(Map<String, Object> paramMap) throws Exception {
    	
    	Integer chlidCnt = 999;
        
    	try{
    		chlidCnt = menuManageDAO.getMenuChlidCnt(paramMap);
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
    	return chlidCnt;
	}
	
	public Map<String, Object> menuInfoView(Map<String, Object> paramMap) throws Exception {
		return menuManageDAO.menuInfoView(paramMap);
	}    

    /**
     * 메뉴 정보를 등록한다.
     * 
     * @param Map<String, Object> paramMap
     * @return void 
     * @throws Exception
     */

    public String insertMenu(Map<String, Object> paramMap) throws Exception {

		String orgIds = EgovStringUtil.isNullToString(paramMap.get("orgIds"));
		String menuOrdr = EgovStringUtil.isNullToString(paramMap.get("menuOrdr"));
		String publicYn = EgovStringUtil.isNullToString(paramMap.get("publicYn"));
		String upperMenuNo = EgovStringUtil.isNullToString(paramMap.get("upperMenuNo"));
		String orgIdsArry[] = null;
		if(!orgIds.equals("")){
			orgIdsArry = orgIds.split(",");			
		}
		
		Integer menuNo = menuManageDAO.getMenuNo(paramMap); 
		
		paramMap.put("menuNo", menuNo);
		
		if(menuOrdr.equals("")){
			paramMap.put("menuOrdr", menuNo);
		}
		
		//대메뉴 추가일 경우
		if(upperMenuNo.equals("0")) {
			paramMap.put("menuImgClass", "et");
			paramMap.put("menuGubun", menuNo);
		}
		
		//메뉴 기본정보 입력
    	menuManageDAO.insertMenu(paramMap);
       
        String jsonArray = paramMap.get("menuNmList")+"";
    	List<Map<String,Object>> menuNameList = JsonUtil.getJsonToArray(jsonArray, new String[]{"menuNm","langKind"});
    	
    	for(Map<String,Object> map : menuNameList ) {
    		if(!EgovStringUtil.isEmpty(map.get("menuNm")+"")){
	    		paramMap.put("menuNm", map.get("menuNm"));
	    		paramMap.put("langKind", map.get("langKind"));

				//메뉴 상세 정보 입력
	    		menuManageDAO.insertMenuMulti(paramMap);
    		}
    	} 
    	
    	if(!publicYn.equals("Y")){
			if (orgIdsArry != null && orgIdsArry.length > 0) {			
				
				paramMap.put("arrCompList", orgIdsArry);   
				menuManageDAO.insertMenuComp(paramMap);
			}
    	}

     	return "success";
    }
    
    
    /**
     * 메뉴 정보를 수정한다.
     * 
     * @param Map<String, Object> paramMap
     * @return void
     * @throws Exception
     */

    public String updateMenu(Map<String, Object> paramMap) throws Exception {

    	String orgIds = EgovStringUtil.isNullToString(paramMap.get("orgIds"));
    	String publicYn = EgovStringUtil.isNullToString(paramMap.get("publicYn"));
    	
		String orgIdsArry[] = null;
		if(!orgIds.equals("")){
			orgIdsArry = orgIds.split(",");			
		}

//       try{
    		//메뉴정보등록
	    	menuManageDAO.updateMenu(paramMap); 
	     	String jsonArray = paramMap.get("menuNmList")+"";
	     	List<Map<String,Object>> menuNameList = JsonUtil.getJsonToArray(jsonArray, new String[]{"menuNm","langKind"});
	     	
	     	for(Map<String,Object> map : menuNameList ) {
	     		
	     		if(!EgovStringUtil.isEmpty(map.get("menuNm")+"")){
		     		paramMap.put("menuNm", map.get("menuNm"));
		     		paramMap.put("langKind", map.get("langKind"));
		     		//메뉴 상세정보 등록
		     		menuManageDAO.updateMenuMulti(paramMap);
	     		}else{
	     			Map<String, Object> para = new HashMap<String, Object>();
	     			para.put("menuNo", paramMap.get("menuNo"));
	     			para.put("langCode", map.get("langKind"));
	     			commonSql.delete("MenuManageDAO.delMenuMulti", para);
	     		}
	     		
	     	}
	     	
	    	
	    	if(!publicYn.equals("Y")){
		    	//t_co_menu_comp 삭제
		    	menuManageDAO.deleteMenuComp(paramMap);
				if (orgIdsArry != null && orgIdsArry.length > 0) {			
					
					paramMap.put("arrCompList", orgIdsArry);   
					menuManageDAO.insertMenuComp(paramMap);
				}
	    	}
	    	
	    	return "success";
 		
//    	}catch(Exception e) {
//    		e.printStackTrace();
//		 return "fail";
//    	}
    	
     	//회사별 메뉴권한 입력		
    	
    }

    /**
     * 메뉴 정보를 삭제한다.
     * 
     * @param organVO
     * @throws Exception
     */

    public String deleteMenu(Map<String, Object> paramMap) throws Exception{
        
    	String result = "";
//    	try{
    		menuManageDAO.deleteMenu(paramMap);
    		result = "success";
//    	}catch(Exception e){
//    		result = "fail";
//    		
//    	}
    	return result;
    }
 
	@Override
	public List<Map<String, Object>> selectMenuTreeList(
			Map<String, Object> paramMap) {
		return menuManageDAO.selectMenuTreeList(paramMap);
	}
	
	@Override
	public Map<String, Object> selectFirstMenuInfo(Map<String,Object> paramMap) {
		return menuManageDAO.selectFirstMenuInfo(paramMap);
	}

	@Override
	public List<Map<String, Object>> selectAdminMenuTreeListAuth(
			Map<String, Object> params) {
		return menuManageDAO.selectAdminMenuTreeListAuth(params);
	}

	@Override
	public Map<String, Object> selectFirstAdminMenuInfo(Map<String, Object> params) {
		return menuManageDAO.selectFirstAdminMenuInfo(params);
	}

	@Override
	public List<Map<String, Object>> selectMenuListOfUrl(
			Map<String, Object> params) {
		return menuManageDAO.selectMenuListOfUrl(params);
	}

	@Override
	public List<Map<String, Object>> selectMenuAdminListOfUrl(Map<String, Object> params) {
		return menuManageDAO.selectMenuAdminListOfUrl(params);
	} 

	@Override
	public List<Map<String, Object>> getOuterMenuList(Map<String,Object> params) {
		
		params.put("tId", "gw-getMenuTreeList-do");
		params.put("fields", new String[]{"dir_cd", "dir_nm", "dir_lvl", "dir_form", "total_art_cnt", "not_read_cnt", "leaf_yn","cat_seq_no"});

		return CommonUtil.getJsonToBoardList(params, params.get("edmsUrl")+"/edms/board/boardDirList.do");
	}
	
	

	@Override
	public List<Map<String, Object>> getSiteMapList(List<Map<String, Object>> menuList,
			List<Map<String, Object>> boardList) {
		
		List<Map<String, Object>> mList = new ArrayList<Map<String,Object>>();
		
		String boardNo = "501000000";						// 게시판 2레벨 메뉴번호
		String boardGubun = "MENU005";						// 게시판 구분코드
		String boardUrl = "/board/viewBoard.do?boardNo=";	// 게시판 url
		
		for(Map<String,Object> map : menuList) {
			
			mList.add(map);
			
			String menuNo = map.get("menuNo")+"";
			/** EDMS 게시판  메뉴리스트에 추가하기 */
			if(boardList != null && boardList.size() > 0 && menuNo.equals(boardNo)) {
				int no =  Integer.parseInt(menuNo);												// 부모 메뉴번호
				for(Map<String,Object> menuMap : boardList) {
					//boardNo", "not_read_cnt", "total_art_cnt", "board_title"
					int seq = CommonUtil.getIntNvl(String.valueOf(menuMap.get("boardNo")));	// 게시판 시퀀스 번호
	
					Map<String,Object> boardMenuMap = new HashMap<String,Object>();
					boardMenuMap.put("menuGubun", boardGubun);
					boardMenuMap.put("menuNo", no+seq);
					boardMenuMap.put("upperMenuNo", boardNo);
					boardMenuMap.put("ord", no+seq);
					boardMenuMap.put("urlPath", boardUrl+seq);
					boardMenuMap.put("name", menuMap.get("board_title")+"");
					boardMenuMap.put("lvl", 3);
					boardMenuMap.put("urlGubun", "edms");
					boardMenuMap.put("isChecked", "");
					
					mList.add(boardMenuMap);
				}
			}
		}
		
		return mList;
	}

	@Override
	public List<Map<String, Object>> selectMenuListOfMenuNo(Map<String, Object> params) {
		return menuManageDAO.selectMenuListOfMenuNo(params);
	}

	@Override
	public List<Map<String, Object>> selectEaEmpMenuTreeList(Map<String, Object> paramMap) {
		return menuManageDAO.selectEaEmpMenuTreeList(paramMap);
	}
	@Override
	public List<Map<String, Object>> selectMenuJsTreeList(Map<String, Object> params) {
		return menuManageDAO.selectMenuJsTreeList(params);
	}
	@Override
	public List<Map<String, Object>> selectAdminMenuJsTreeList(Map<String, Object> params) {
		return menuManageDAO.selectAdminMenuJsTreeList(params);
	}
	@Override
	public List<Map<String, Object>> selectEAPrivateMenuTreeList(Map<String, Object> params) {
		return menuManageDAO.selectEAPrivateMenuTreeList(params);
	}
	@Override
	public List<Map<String, Object>> callApiMenuList(Map<String, Object> params, String apiUrl ,String[] fields) {
		
		params.put("tId", "gw-getMenuTreeList-do");
		params.put("fields",fields);

		return CommonUtil.getJsonToBoardList(params, apiUrl);
	}

	@Override
	public List<Map<String, Object>> selectMenuComboBoxList(Map<String, Object> paramMap) {
		
		return menuManageDAO.selectMenuComboBoxList(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> selectMenuComboBoxSubList(Map<String, Object> paramMap) {
		
		return menuManageDAO.selectMenuComboBoxSubList(paramMap);
	}	

	@Override
	public List<Map<String, Object>> selsetMenuOpenCompList(Map<String, Object> paramMap) {
		return  menuManageDAO.selsetMenuOpenCompList(paramMap);
	}

	
	// 시스템설정 메뉴 권한 체크 (임시적으로 시스템설정 메뉴만 사용)
	// 시스템설정 메뉴는 관리자,마스터 전용 메뉴이기때문에  loginVO.getUserSe() == "USER" 인 경우는 무조건 false반환
	// 사용자가 직접 해당 메뉴 url을 치고 접속하는 보안이슈로 추가된 부분.
	@Override
	public boolean checkIsAuthMenu(Map<String, Object> paramMap, LoginVO loginVO){
		if(paramMap.get("menu_no") == null || loginVO.getUserSe().equals("USER")){
			return false;
		}
		
		if(loginVO.getUserSe().equals("ADMIN")){
			//해당메뉴 권한조회
			Map<String, Object> authParaMap = new HashMap<String, Object>();
			authParaMap.put("menuNo", paramMap.get("menu_no"));
			authParaMap.put("compSeq", loginVO.getCompSeq());
			authParaMap.put("empSeq", loginVO.getUniqId());
			int isAuthMenu = (int) commonSql.select("MenuManageDAO.getIsAuthMenuCnt", authParaMap);
			if(isAuthMenu == 0) {
				return false;
			}
			else {
				return true;
			}
		}
		
		else {
			return true;
		}
	}
	
	@Override
	public String insertMenuHistory(Map<String, Object> params) {
		String result = null;
		menuManageDAO.insertMenuHistory(params);
		result = "success";
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String,Object> getMenuSSOLinkInfo(Map<String, Object> params, LoginVO loginVO) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		Map<String, Object> result = new HashMap<>();
		
		Map<String,Object> ssoInfo = new HashMap<String,Object>();
		
		if(params.get("paramTp") != null && params.get("paramTp").equals("cloud")){
			ssoInfo.putAll(params);
		}else{
			ssoInfo = (Map<String,Object>) commonSql.select("PortalManageDAO.selectSSoInfo", params);			
		}
		
		if(ssoInfo != null) {

			//ERP-iu Web SSO연동
			if(ssoInfo.get("ssoEtcCtlValue") != null && ssoInfo.get("ssoEtcCtlValue").toString().contains("ErpSSOParam")){
				
				String erpGroupCode = BizboxAProperties.getCustomProperty("BizboxA.Cust.ErpGroupCode");
				
				String[] ssoEtcCtlValue = ssoInfo.get("ssoEtcCtlValue").toString().split("\\|");
				
				if(ssoEtcCtlValue.length > 1 && !ssoEtcCtlValue[1].equals("")) {
					erpGroupCode = ssoEtcCtlValue[1];
				}else if(erpGroupCode.equals("99")) {
					erpGroupCode = "WEB";
				}
				
				String erpEmpInfoType = BizboxAProperties.getCustomProperty("BizboxA.Cust.ErpEmpInfoType");
				
				if(ssoEtcCtlValue.length > 2 && !ssoEtcCtlValue[2].equals("")) {
					erpEmpInfoType = ssoEtcCtlValue[2];
				}				
				
				if(erpEmpInfoType.equals("loginId")){
					erpEmpInfoType = loginVO.getId();
				}else if(erpEmpInfoType.equals("emailAddr")){
					erpEmpInfoType = loginVO.getEmail();
				}else{
					erpEmpInfoType = loginVO.getErpEmpCd();
				}
				
				SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
				String plainToken = format.format(new Date()) + "|" + loginVO.getErpCoCd() + "|" + erpGroupCode + "|" + erpEmpInfoType;
				
				com.duzon.ctd.sso.SingleSignOn sso = new com.duzon.ctd.sso.SingleSignOn();
				plainToken = sso.encryptString(plainToken, "DUZONBIZONERPIU=");
				ssoInfo.put("ssoEtcCtlValue", plainToken);
			}
			
			String timeLink = "";
			if(ssoInfo.get("ssoTimeLink").equals("01")){
				SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
				timeLink = format.format(new Date()); 
			}else if(ssoInfo.get("ssoTimeLink").equals("02")){
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				timeLink = format.format(new Date());
			}else if(ssoInfo.get("ssoTimeLink").equals("03")){
				Timestamp timestamp = new Timestamp(System.currentTimeMillis());
				timeLink = Long.toString(timestamp.getTime());
			}
			
			String ssoUrl = (String)params.get("url");
			
			String ssoEncryptType = ssoInfo.get("ssoEncryptType") == null ? "" : ssoInfo.get("ssoEncryptType").toString();
			String ssoEncryptScope = StringUtils.rightPad(ssoInfo.get("ssoEncryptScope") == null ? "" : ssoInfo.get("ssoEncryptScope").toString(), 6, "0"); 
			String ssoEncryptKey = ssoInfo.get("ssoEncryptKey") == null ? "" : ssoInfo.get("ssoEncryptKey").toString();
			String ssoCtlValue = "";
			
			if(ssoInfo.get("ssoType").equals("GET")){
				
				if(ssoUrl.indexOf("?") == -1){
					ssoUrl += "?";
				}
				
				if(ssoInfo.get("ssoEmpCtlName") != null && !ssoInfo.get("ssoEmpCtlName").equals("")){
					
					ssoCtlValue = loginVO.getUniqId();
					
					if(ssoEncryptScope.substring(0,1).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoEmpCtlName") + "=" + URLEncoder.encode(ssoCtlValue, "UTF-8");
					
				}
				
				if(ssoInfo.get("ssoLogincdCtlName") != null && !ssoInfo.get("ssoLogincdCtlName").equals("")){
					
					ssoCtlValue = loginVO.getId();
					
					if(ssoEncryptScope.substring(1,2).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoLogincdCtlName") + "=" + URLEncoder.encode(ssoCtlValue, "UTF-8");					

				}
				
				if(ssoInfo.get("ssoCoseqCtlName") != null && !ssoInfo.get("ssoCoseqCtlName").equals("")){
					
					ssoCtlValue = loginVO.getCompSeq();
					
					if(ssoEncryptScope.substring(2,3).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoCoseqCtlName") + "=" + URLEncoder.encode(ssoCtlValue, "UTF-8");						
					
				}
				
				if(ssoInfo.get("ssoErpempnoCtlName") != null && !ssoInfo.get("ssoErpempnoCtlName").equals("")){
					
					ssoCtlValue = loginVO.getErpEmpCd() == null ? "" : loginVO.getErpEmpCd();
					
					if(!ssoCtlValue.equals("") && ssoEncryptScope.substring(3,4).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoErpempnoCtlName") + "=" + URLEncoder.encode(ssoCtlValue, "UTF-8");							
				
				}
				
				if(ssoInfo.get("ssoErpcocdCtlName") != null && !ssoInfo.get("ssoErpcocdCtlName").equals("")){
					
					ssoCtlValue = loginVO.getErpCoCd() == null ? "" : loginVO.getErpCoCd();
					
					if(!ssoCtlValue.equals("") && ssoEncryptScope.substring(4,5).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoErpcocdCtlName") + "=" + URLEncoder.encode(ssoCtlValue, "UTF-8");						
				
				}
				
				if(ssoInfo.get("ssoEtcCtlName") != null && !ssoInfo.get("ssoEtcCtlName").equals("")){
					
					String ssoEtcCtlValue = ssoInfo.get("ssoEtcCtlValue") == null ? "" : (String)ssoInfo.get("ssoEtcCtlValue");
					
					if(!ssoEtcCtlValue.equals("")){
						
						//치환
						if(ssoEtcCtlValue.contains("$log_id$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$log_id$", loginVO.getId() == null ? "" : loginVO.getId());
						}
						
						if(ssoEtcCtlValue.contains("$emp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$emp_cd$", loginVO.getUniqId() == null ? "" : loginVO.getUniqId());
						}
						
						if(ssoEtcCtlValue.contains("$comp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$comp_cd$", loginVO.getCompSeq() == null ? "" : loginVO.getCompSeq());
						}
						
						if(ssoEtcCtlValue.contains("$erp_id$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$erp_id$", loginVO.getErpEmpCd() == null ? "" : loginVO.getErpEmpCd());
						}
						
						if(ssoEtcCtlValue.contains("$erp_comp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$erp_comp_cd$", loginVO.getErpCoCd() == null ? "" : loginVO.getErpCoCd());
						}
						
						if(ssoEtcCtlValue.contains("$time_stamp$")){
							Timestamp timestamp = new Timestamp(System.currentTimeMillis());
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$time_stamp$", Long.toString(timestamp.getTime()));
						}
						
						if(ssoEtcCtlValue.contains("$yyyyMMddHHmmss$")){
							SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$yyyyMMddHHmmss$", format.format(new Date()));
						}
						
						if(ssoEtcCtlValue.contains("$y-M-d H:m:s$")){
							SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$yyyy-MM-dd HH:mm:ss$", format.format(new Date()));
						}
						
						//암호화옵션 사용여부체크
						if(!ssoEtcCtlValue.equals("") && ssoEncryptScope.substring(5,6).equals("1")){

							ssoEtcCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, ssoEtcCtlValue);
							
						}else if(ssoEtcCtlValue.contains("$DZ_SECURE_ENC$")){
							ssoEtcCtlValue = Secure.encode(ssoEtcCtlValue.replace("$DZ_SECURE_ENC$", ""));
						}
						
						//URL Encode
						ssoEtcCtlValue = URLEncoder.encode(ssoEtcCtlValue, "UTF-8");
					}
					
					ssoUrl += "&" + (String)ssoInfo.get("ssoEtcCtlName") + "=" + ssoEtcCtlValue;
					
				}
				
				ssoUrl = ssoUrl.replace("?&", "?");
				
				result.put("ssoUrl",ssoUrl);
			}else{
				
				String ssoPostParam = "ssoPostUrl|" + ssoUrl;
				
				if(ssoInfo.get("ssoEmpCtlName") != null && !ssoInfo.get("ssoEmpCtlName").equals("")){
					
					ssoPostParam += "▦ssoEmpCtlName|" + (String)ssoInfo.get("ssoEmpCtlName");
					
					ssoCtlValue = loginVO.getUniqId();
					
					if(ssoEncryptScope.substring(0,1).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoPostParam += "▦ssoEmpCtlVal|" + ssoCtlValue;

				}
				
				if(ssoInfo.get("ssoLogincdCtlName") != null && !ssoInfo.get("ssoLogincdCtlName").equals("")){
					ssoPostParam += "▦ssoLogincdCtlName|" + (String)ssoInfo.get("ssoLogincdCtlName");
					
					ssoCtlValue = loginVO.getId();
					
					if(ssoEncryptScope.substring(1,2).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoPostParam += "▦ssoLogincdCtlVal|" + ssoCtlValue;					

				}
				
				if(ssoInfo.get("ssoCoseqCtlName") != null && !ssoInfo.get("ssoCoseqCtlName").equals("")){
					ssoPostParam += "▦ssoCoseqCtlName|" + (String)ssoInfo.get("ssoCoseqCtlName");
					
					ssoCtlValue = loginVO.getCompSeq();
					
					if(ssoEncryptScope.substring(2,3).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoPostParam += "▦ssoCoseqCtlVal|" + ssoCtlValue;	

				}
				
				if(ssoInfo.get("ssoErpempnoCtlName") != null && !ssoInfo.get("ssoErpempnoCtlName").equals("")){
					ssoPostParam += "▦ssoErpempnoCtlName|" + (String)ssoInfo.get("ssoErpempnoCtlName");
					
					ssoCtlValue = loginVO.getErpEmpCd() == null ? "" : loginVO.getErpEmpCd();
					
					if(!ssoCtlValue.equals("") && ssoEncryptScope.substring(3,4).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoPostParam += "▦ssoErpempnoCtlVal|" + ssoCtlValue;

				}
				
				if(ssoInfo.get("ssoErpcocdCtlName") != null && !ssoInfo.get("ssoErpcocdCtlName").equals("")){
					ssoPostParam += "▦ssoErpcocdCtlName|" + (String)ssoInfo.get("ssoErpcocdCtlName");
					
					ssoCtlValue = loginVO.getErpCoCd() == null ? "" : loginVO.getErpCoCd();
					
					if(!ssoCtlValue.equals("") && ssoEncryptScope.substring(4,5).equals("1")) {
						ssoCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, timeLink + ssoCtlValue);
					}
					
					ssoPostParam += "▦ssoErpcocdCtlVal|" + ssoCtlValue;					
					
				}
				
				if(ssoInfo.get("ssoEtcCtlName") != null && !ssoInfo.get("ssoEtcCtlName").equals("")){
					
					String ssoEtcCtlValue = ssoInfo.get("ssoEtcCtlValue") == null ? "" : (String)ssoInfo.get("ssoEtcCtlValue");
					
					if(!ssoEtcCtlValue.equals("")){
						
						//치환
						if(ssoEtcCtlValue.contains("$login_id$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$login_id$", loginVO.getId() == null ? "" : loginVO.getId());
						}
						
						if(ssoEtcCtlValue.contains("$emp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$emp_cd$", loginVO.getUniqId() == null ? "" : loginVO.getUniqId());
						}
						
						if(ssoEtcCtlValue.contains("$comp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$comp_cd$", loginVO.getCompSeq() == null ? "" : loginVO.getCompSeq());
						}
						
						if(ssoEtcCtlValue.contains("$erp_emp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$erp_emp_cd$", loginVO.getErpEmpCd() == null ? "" : loginVO.getErpEmpCd());
						}
						
						if(ssoEtcCtlValue.contains("$erp_comp_cd$")){
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$erp_comp_cd$", loginVO.getErpCoCd() == null ? "" : loginVO.getErpCoCd());
						}
						
						if(ssoEtcCtlValue.contains("$time_stamp$")){
							Timestamp timestamp = new Timestamp(System.currentTimeMillis());
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$time_stamp$", Long.toString(timestamp.getTime()));
						}
						
						if(ssoEtcCtlValue.contains("$yyyyMMddHHmmss$")){
							SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$yyyyMMddHHmmss$", format.format(new Date()));
						}
						
						if(ssoEtcCtlValue.contains("$yyyy-MM-dd HH:mm:ss$")){
							SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							ssoEtcCtlValue = ssoEtcCtlValue.replace("$yyyy-MM-dd HH:mm:ss$", format.format(new Date()));
						}					
						
						//암호화옵션 사용여부체크
						if(!ssoEtcCtlValue.equals("") && ssoEncryptScope.substring(5,6).equals("1")) {
							ssoEtcCtlValue = getAesEnc(ssoEncryptType, ssoEncryptKey, ssoEtcCtlValue);
						}
			
					}
					
					ssoPostParam += "▦ssoEtcCtlYn|Y" + "▦ssoEtcCtlName|" + (String)ssoInfo.get("ssoEtcCtlName") + "▦ssoEtcCtlValue|" + ssoEtcCtlValue;
				}else{
					ssoPostParam += "▦ssoEtcCtlYn|N";
				}
				
				result.put("ssoUrl","/gw/cmm/ssoPostView.do?ssoPostParam=" + URLEncoder.encode(AESCipher.AES_Encode(new SimpleDateFormat("yyyyMMddHHmm").format(new Date()) + ssoPostParam)));
			}
		}else {
			result.put("ssoUrl", params.get("url"));
		}
		
		return result;
	}	
	
	public String getAesEnc(String ssoEncryptType, String ssoEncryptKey, String val) throws InvalidKeyException, UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
		
		if(ssoEncryptType.equals("AES128")){
			//AES128_CBC
			val = AESCipher.AES128_Encode(val, ssoEncryptKey);
		}else if(ssoEncryptType.equals("AES128_ECB")){
			//AES128_ECB
			val = AESCipher.AES128EX_Encode(val, ssoEncryptKey);
		}else if(ssoEncryptType.equals("AES256")){
			//AES256_CBC
			val = AESCipher.AES256_Encode(val, ssoEncryptKey);
		}
		
		return val;
	}
	
	public boolean checkMenuAuth(LoginVO loginVO, String urlPath) {
		// 필수 파라미터 : compSeq, deptSeq, empSeq, eaType, menuNo, userSe
		boolean isAuth = true;
		
		Map<String, Object> params = new HashMap<>();
		
		params.put("groupSeq", loginVO.getGroupSeq());
		params.put("compSeq", loginVO.getOrganId());
		params.put("deptSeq", loginVO.getOrgnztId());
		params.put("empSeq", loginVO.getUniqId());
		params.put("eaType", loginVO.getEaType());
		params.put("userSe", loginVO.getUserSe());
		params.put("urlPath", urlPath);
		
		if(loginVO.getUserSe().equals("MASTER"))	{
			return true;
		}
		
		if(params.get("urlPath") != null && !params.get("urlPath").toString().equals("")) {
			isAuth = (int)commonSql.select("MenuManageDAO.checkMenuAuth", params) > 0;
		}
		
		return isAuth;
	}
	
}
