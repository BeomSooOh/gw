package neos.cmm.systemx.emp.service.impl;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Service;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.emp.dao.EmpManageDAO;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("EmpManageService")
public class EmpManageServiceImpl implements EmpManageService{
	
	/* 로그 변수 정의 */
	//private org.apache.logging.log4j.Logger LOG = LogManager.getLogger(this.getClass());
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name = "EmpManageDAO")
    private EmpManageDAO empManageDAO;

	private SqlSessionFactory sqlSessionFactory;
	
	@Override
	public Map<String, Object> selectEmpInfo(Map<String, Object> params, PaginationInfo paginationInfo) {
		 
		return commonSql.listOfPaging2(params, paginationInfo, "EmpManage.selectUserInfo");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> selectEmpInfoListNew(Map<String, Object> params) {
		
		return commonSql.list("EmpManage.selectUserInfo", params);
		
	}
	
	@Override
	public Map<String, Object> selectEmpInfoListNewPaging(Map<String, Object> params, PaginationInfo paginationInfo) {
		
		return commonSql.listOfPaging2(params, paginationInfo, "EmpManage.selectUserInfo");
		
	}	
	
	@Override
	public Map<String, Object> selectEmpInfoNew(Map<String, Object> params, PaginationInfo paginationInfo) {
		 
		return commonSql.listOfPaging2(params, paginationInfo, "EmpManage.selectUserInfoNew");
	}	
	
	@Override
	public String selectEmpDuplicate(Map<String, Object> params) {
		return (String) commonSql.select("EmpManage.selectEmpDuplicate", params);
	}

	@Override
	public void updateEmpLoginId(Map<String, Object> params) {
		commonSql.update("EmpManage.updateEmpLoginId", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectEmpInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("EmpManage.selectUserInfo", params);
	}
	
	@Override
	public boolean isPossbileSettleDocument(Map<String, Object> paramMap) throws Exception {
		boolean result = false ;
		List<Map<String, Object>>  docApprovalList = null ;
		
		//생산문서 조회
		docApprovalList = this.possibleSettleDraftDocument(paramMap) ;
		int rowNum = 0 ;
		if( docApprovalList != null ) {
			rowNum  = docApprovalList.size() ;
		}
		if(rowNum > 0 ) {
			paramMap.put("docApprovalList", docApprovalList) ;
			return true ;
		}
		
		return false ;
	}
	
	@Override
    public List<Map<String, Object>> possibleSettleDraftDocument(Map<String, Object> paramMap) throws Exception {
    	List<Map<String, Object>> list = (List<Map<String, Object>>) commonSql.list("ApprovalLineDAO.selectDraftDocKyuljaeline", paramMap) ;
    	return list ;
    }
	
	@Override
	public List<Map<String, Object>> getEmpJobList(Map<String, Object> params) {
		return commonSql.list("EmpManage.getEmpJobList", params);
	}
	
	@Override
	public List<Map<String, Object>> getEmpStatusList(Map<String, Object> params) {
		return commonSql.list("EmpManage.getEmpStatusList", params);
	}

	@Override
	public List<Map<String, Object>> selectEmpAuthList(Map<String, Object> params) {
		return commonSql.list("EmpManage.selectUserAuthList", params);
	}

	
	@Override
	public boolean deleteEmpDept(Map<String, Object> empInfoMap) {
		int result = commonSql.delete("EmpManage.deleteEmpDept", empInfoMap);
		return result >= 0;
	}

	@Override
	public boolean deleteEmpDeptMulti(Map<String, Object> empInfoMap) {
		int result = commonSql.delete("EmpManage.deleteEmpDeptMulti", empInfoMap);
		return result >= 0;
	}

	@Override
	public void updatemyInfoMulti(Map<String, Object> myInfoMap){
		commonSql.update("EmpManage.updatemyInfoMulti", myInfoMap);
	}
	
	@Override
	public void updatemyInfodeptMulti(Map<String, Object> myInfoMap){
		commonSql.update("EmpManage.updatemyInfodeptMulti", myInfoMap);
		commonSql.update("EmpManage.updatemyInfodeptDetail", myInfoMap);
	}
	
	
	@Override
	public void updatemyInfo(Map<String, Object> myInfoMap){
		commonSql.update("EmpManage.updatemyInfo", myInfoMap);
	}
	
	@Override
	public void deletemyInfoAtchFile(Map<String, Object> myInfoMap){
		//기존 첨부파일(이미지,사인) 제거
		commonSql.delete("AttachFileUpload.deleteAttachFile", myInfoMap);
		commonSql.delete("AttachFileUpload.deleteAttachFileDetail", myInfoMap);
	
	}

	@Override
	public void empResignProc(Map<String, Object> params) { //기존 퇴직
	    int isDept = 0;
	    String isAll = EgovStringUtil.isNullToString(params.get("isAll"));
	    commonSql.update("EmpManage.erpEmpResignProc", params);  //isAll 이 N이면 현재 회사만 Y면 모든 겸직 퇴사처리
	    commonSql.update("EmpManage.empDeptResign", params);
	    commonSql.update("EmpManage.empDeptMultiResign", params);
	    isDept = (int) commonSql.select("EmpManage.getErpEmpResignProc", params);
	    
	    if(isAll.equals("Y") || isDept == 0){
	        commonSql.update("EmpManage.empResignProc", params);
	    }
	}
	
	
	
	
	 public void empResignProc2(Map<String,Object> params){
		 	String mailDelYn = EgovStringUtil.isNullToString(params.get("mailDelYn")); //메일계정정보 삭제유무
		 	
	 		List<Map<String, Object>> empCompList = commonSql.list("EmpMange.getEmpCompList", params);
	 		
	 		String mailResignYn = "N";
	 		
	 		
	 		
	 		if(params.get("isAll") != null && empCompList != null){
	 			//모든 부서 퇴사처리가 아니고
	 			//퇴사하는 회사의 메일도메인을 다른 겸직회사에서 사용하고 있는 경우에는
	 			//메일사용자 퇴사처리 안함.
	 			if(!params.get("isAll").equals("Y")){
	 				List<Map<String, Object>> compMailDomainList = commonSql.list("EmpManage.getCompMailDomainList", params);
	 				int cnt = 0;
	 				for(Map<String, Object> mp : compMailDomainList){
	 					if(empCompList.get(0).get("emailDomain").toString().equals(mp.get("emailDomain").toString())){
	 						cnt++;
	 					}
	 				}
	 				if(cnt > 1) {
	 					mailResignYn = "N";
	 				}
	 				else if(cnt == 1) {
	 					mailResignYn = "Y";
	 				}
	 			}
	 		}
	 		
	 		if(empCompList != null){
	 			
	 			if(params.get("isAll").equals("Y") || mailResignYn.equals("Y")){
	 			
		 			for(Map<String, Object> mp : empCompList){		 				
		 				Map<String, Object> map = new HashMap<String, Object>();
		 				
		 				
		 				map.put("domain", (String) mp.get("emailDomain")+"");
						map.put("empSeq", params.get("empSeq")+"");
						map.put("flag", "1");
					
						String url = "";
						
						if(mailDelYn.equals("Y")) {
							url = (String) mp.get("mailUrl")+"deleteUser.do";	//삭제처리
						}
						else {
							url = (String) mp.get("mailUrl")+"resignUser.do";	//퇴사처리
						}
						
						String param = setParam(map);
						
						URL u = null;
						HttpURLConnection  huc = null;
				        String json = "";
				        
				        try {
				            u = new URL(url);
				            huc = (HttpURLConnection)u.openConnection();
				            huc.setRequestMethod("POST");
				            huc.setDoInput(true);
				            huc.setDoOutput(true);
				            huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
				            
				            
				            OutputStream os = huc.getOutputStream();
				            os.write(param.getBytes());
				            os.flush();
				            os.close();
				            
				            InputStream is = huc.getInputStream();
				            Writer writer = new StringWriter();
	
				            char[] buffer = new char[1024];
				            try
				            {
				                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
				                int n;
				                while ((n = reader.read(buffer)) != -1) 
				                {
				                    writer.write(buffer, 0, n);
				                }
				                json = writer.toString();
				            }
				            finally 
				            {
				                is.close();
				                writer.close();
				            }
				            
				        }
				        catch(Exception e) {
				        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				        }
		 			}
	 			}
	 		}
	    	
	 }

	 
	public void empResignProc3(Map<String, Object> params) { //새로 퇴직 step별로 나눔
        int isComp = 0;
        String isAll = EgovStringUtil.isNullToString(params.get("isAll")); //회사정보처리
        commonSql.update("EmpManage.erpEmpResignProc", params);  //isAll 이 N이면 현재 회사만 Y면 모든 겸직 퇴사처리
        isComp = (int) commonSql.select("EmpManage.getErpEmpResignProc", params);
        
        if(isAll.equals("Y") || isComp == 0){
            commonSql.update("EmpManage.empResignProc", params);
        }
        
        if(isAll.equals("N") && isComp != 0){
        	//기본로그인회사 퇴사시 겸직회사중 한군데를 기본로그인회사로 설정.
        	String mainCompSeq = (String) commonSql.select("EmpManage.getMainCompSeq", params);
        	String compSeq = EgovStringUtil.isNullToString(params.get("compSeq"));
        	
        	if(mainCompSeq.equals(compSeq)){
        		commonSql.update("EmpManage.updateEmpMainCompSeq", params);
        	}
        }
        
        
        String isDeptDel = EgovStringUtil.isNullToString(params.get("isDeptDel")); //부서정보처리
        if(isDeptDel.equals("Y")){
            commonSql.delete("EmpManage.empDeptDel", params);
            commonSql.delete("EmpManage.empDeptMultiDel", params);
            commonSql.delete("EmpManage.empCompDel", params);
        }
        else{
        	commonSql.update("EmpManage.empDeptResignProc", params);
        	commonSql.update("EmpManage.empDeptMultiResignProc", params);
        }
	
    }
	
	public void empResignProc5(Map<String, Object> params) { //새로 퇴직 step별로 나눔
        String mustKyulPk = isNullStr(params.get("mustKyulPk"));
        String mustKyulEmpSeq = isNullStr(params.get("mustKyulEmpSeq"));
        String formID = "";
        String actID = "";
        String targetSeq = "";
        if(!mustKyulPk.equals("")){
            String mustPk[] = mustKyulPk.split("\\|");  //1_3000|2_3000
            String mustSeq[] = mustKyulEmpSeq.split("\\|");
            for(int i = 0; i < mustPk.length; i++){
                formID = mustPk[i].split("_")[0];
                actID = mustPk[i].split("_")[1];
                targetSeq = mustSeq[i];
                params.put("formID", formID);
                params.put("actID", actID);
                params.put("targetSeq", targetSeq);
                commonSql.update("EmpManage.updateMustKyuljae", params); //대체자로 업데이트
            }
        }
        commonSql.delete("EmpManage.deleteMustKyuljae", params); //나머지 결재라인 삭제
    }
	
	public void empResignProc6(Map<String, Object> params) { //새로 퇴직 step별로 나눔
        String docPk = isNullStr(params.get("docPk"));
        String docEmpSeq = isNullStr(params.get("docEmpSeq"));
        String pk = "";
        String targetSeq = "";
        if(!docPk.equals("")){
            String arrDocPk[] = docPk.split("\\|"); 
            String arrDocSeq[] = docEmpSeq.split("\\|");
            for(int i = 0; i < arrDocPk.length; i++){
                pk = arrDocPk[i];
                targetSeq = arrDocSeq[i];
                params.put("docPk", pk);
                params.put("targetSeq", targetSeq);
                commonSql.update("EmpManage.updateDocAdm", params); //대체자로 업데이트
            }
        }
        commonSql.delete("EmpManage.deleteDocAdm", params); //나머지 결재라인 삭제
    }
	
	public void empResignProc7(Map<String, Object> params) { //새로 퇴직 step별로 나눔
        String boardPk = isNullStr(params.get("boardPk"));
        String boardEmpSeq = isNullStr(params.get("boardEmpSeq"));
        String pk = "";
        String targetSeq = "";
        if(!boardPk.equals("")){
            String arrBoardPk[] = boardPk.split("\\|");  
            String arrBoardSeq[] = boardEmpSeq.split("\\|");
            for(int i = 0; i < arrBoardPk.length; i++){
                pk = arrBoardPk[i];
                targetSeq = arrBoardSeq[i];
                params.put("boardPk", pk);
                params.put("targetSeq", targetSeq);
                String cnt = (String) commonSql.select("EmpManage.selectBoardAdmCnt", params);
                if(cnt.equals("0")) {
                	commonSql.update("EmpManage.updateBoardAdm", params); //대체자로 업데이트
                }
            }
        }
        commonSql.delete("EmpManage.deleteBoardAdm", params); //나머지 결재라인 삭제
    }
	
	
	public void empResignProc8(Map<String, Object> params) { //마스터권한 퇴직처리
		
		String isMasterAuth = EgovStringUtil.isNullToString(params.get("isMasterAuth")); //마스터권한유무
		
		if(isMasterAuth.equals("Y")){
			String masterAuthDelYn = EgovStringUtil.isNullToString(params.get("masterAuthDelYn")); //마스터권한 설정 값(삭제, 대체자지정)
			
			commonSql.delete("EmpManage.deleteEmpMasterAuth", params);
			
			if(masterAuthDelYn.equals("N"))	{			
				commonSql.insert("EmpManage.insertSubUserMasterAuth", params);	//마스터권한 대체자에게 마스터권한 부여
			}
		}
    }
	

	@Override
	public void InsertBaseAuth(Map<String, Object> params) {
		commonSql.insert("EmpManage.InsertBaseAuth", params);
	}

	@Override
	public void DeleteBaseAuth(Map<String, Object> params) {
		commonSql.delete("EmpManage.DeleteBaseAuth", params);
	}

	@Override
	public List<Map<String, Object>> selectEmpCurAuthList(Map<String, Object> authMap) {
		return commonSql.list("EmpManage.selectUserCurAuthList", authMap);
	}
	
	
	@Override
	public List<Map<String, Object>> selectEmpInfoList(Map<String, Object> params) {
		return commonSql.list("EmpManage.selectEmpInfoList", params);
	}
    
    @Override
    public void updateMailAddr(Map<String, Object> params) {
        empManageDAO.updateMailAddr(params);
    }
	
	@Override
	public HashMap<String, Object> changeEmailData(Map<String, Object> paramMap){
	    HashMap<String, Object> result = new HashMap<String, Object>();
	    Map<String, Object> map = new HashMap<String, Object>();
	    List<Map<String, Object>> empList = empManageDAO.selectEmpInfoList(paramMap);
	    Map<String, Object> groupData = (Map<String, Object>) commonSql.select("EmpManage.selectGroupData", paramMap);
	    Map<String, Object> compData = (Map<String, Object>) commonSql.select("EmpManage.selectEmpMailUseYn", paramMap);

	    String mailUUrl = isNullStr(groupData.get("mailUrl"));
	    String mailDomain = isNullStr(empList.get(0).get("emailDomain"));
	    String mailUrl = isNullStr(paramMap.get("mailUrl"));
	    String mailUseYn = (String) compData.get("compEmailYn");
	    String id = "";
	    if(mailUrl.equals("changeUserId.do")){
	        id = isNullStr(empList.get(0).get("emailAddr"));
	    }else if(mailUrl.equals("createUser.do")){
	        id = isNullStr(paramMap.get("id"));
	    }
	    
	    if(mailUUrl.equals("") || mailUrl.equals("") || id.equals("") || mailDomain.equals("") || !mailUseYn.equals("Y")){
	        result.put("resultCode", "0");
	        result.put("resultMessage", "SUCCESS");
	        return result;
	    }
	    
	    
	    String passWord = isNullStr(paramMap.get("pw"));
	    
	    if(!passWord.equals("")){
	    	passWord = URLEncoder.encode(passWord);
	    }
	    
	    map.put("id", id);
	    map.put("domain", mailDomain);
	    map.put("empSeq", isNullStr(paramMap.get("empSeq")));
	    map.put("empName", isNullStr(paramMap.get("empName")));
	    map.put("pw", passWord);
	    map.put("changeId", isNullStr(paramMap.get("emailAddr")));
	    map.put("flag", isNullStr(paramMap.get("flag")));
	    
	    String param = setParam(map);
        String url = mailUUrl+mailUrl;
        URL u = null;
        HttpURLConnection  huc = null;
        String json = "";
        try {
            u = new URL(url);
            huc = (HttpURLConnection)u.openConnection();
            huc.setRequestMethod("POST");
            huc.setDoInput(true);
            huc.setDoOutput(true);
            huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
            
            OutputStream os = huc.getOutputStream();
            os.write(param.getBytes());
            os.flush();
            os.close();
            
            InputStream is = huc.getInputStream();
            Writer writer = new StringWriter();

            char[] buffer = new char[1024];
            try
            {
                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                int n;
                while ((n = reader.read(buffer)) != -1) 
                {
                    writer.write(buffer, 0, n);
                }
                json = writer.toString();
            }
            finally 
            {
                is.close();
                writer.close();
            }
            
        }
        catch(Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
        }
        
        JSONObject jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(json));
        
        Map<String, Object> retVal = new HashMap<String, Object>();
        String resultCode = isNullStr(jsonObject.get("resultCode"));
        String resultMessage = isNullStr(jsonObject.get("resultMessage"));	
        result.put("resultCode", resultCode);
        result.put("resultMessage", resultMessage);
        return result;
	}
	
	private String setParam(Map<String, Object> paramMap){
	    String param = "";
	    for(String mapKey : paramMap.keySet()){
	        param += mapKey + "=" + paramMap.get(mapKey)+"&";
	    }
	    
	    return param;
	}
	
	private String isNullStr(Object obj){
        String str = EgovStringUtil.isNullToString(obj);
        if(str.equals("null")){
            str = "";
        }
        return str;
    }

    @Override
    public List<Map<String, Object>> getWorkTeamMst(Map<String, Object> params) {        
        return commonSql.list("EmpManage.getWorkTeamMst", params);
    }
    
    @Override
    public void insertTeamWork(Map<String, Object> params){
        Map<String, Object> wtmMap = (Map<String, Object>) commonSql.select("EmpManage.getWorkTeamMem", params);
        if(wtmMap != null){
            commonSql.insert("EmpManage.updateTeamWork", params);
        }else{
            commonSql.insert("EmpManage.insertTeamWork", params);
        }
    }

    @Override
    public List<Map<String, Object>> empResignProcFinish(Map<String, Object> params) {        
    	//step2 메일정보 처리.
        empResignProc2(params);
    	
    	//step3 모든회사 처리할건지 (부서정보처리)
        empResignProc3(params);
        
        //step5 필수결재선 처리
//        empResignProc5(params);
        
        
        //step6 문서함 처리
        empResignProc6(params);
        
        //step7 게시판 처리
        empResignProc7(params);
        
        
        //step8 마스터권한 처리
        empResignProc8(params);
        
        return null;
    }
    
   

    @Override
    public Map<String, Object> empResignInitData(Map<String, Object> params) {
        Map<String, Object> map = new HashMap<String, Object>();
        //step2 모든 회사 데이터
        List<Map<String, Object>> step2 = new ArrayList<Map<String, Object>>();
        step2 = commonSql.list("EmpManage.getCompList", params);
        
        //step6 담당 문서함 조회
        List<Map<String, Object>> step6 = new ArrayList<Map<String, Object>>();
        step6 = commonSql.list("EmpManage.getDocAdm", params);
        
        //step7 담당 게시판 조회
        List<Map<String, Object>> step7 = new ArrayList<Map<String, Object>>();
        step7 = commonSql.list("EmpManage.getBoardAdm", params);
        
        
        map.put("step2", step2);
        map.put("step6", step6);
        map.put("step7", step7);
        
        return map;
    }
    
    @Override
    public Map<String, Object> empResignDocData(Map<String, Object> params) {
        String allComp = isNullStr(params.get("allComp")); //회사 seq가져와서 문서정보 가져오기
        List<HashMap<String, Object>> tmpCo = new ArrayList<HashMap<String, Object>>();
        String compA[] = allComp.split(",");
        params.put("allComp", compA);
        //step4 결재안한 리스트        
        List<HashMap<String, Object>> getEa320Option = commonSql.list("EmpManage.getEa320Option", params);
        String ea320 = isNullStr(String.valueOf(getEa320Option.get(0).get("optionvalue")));
        if(ea320.equals("")){
            ea320 = "0";
        }
        params.put("ea320", ea320);
        
        //step4 결재 양식 필수라인
        List<Map<String, Object>> step4 = new ArrayList<Map<String, Object>>();
        step4 = commonSql.list("EmpManage.getMustLine", params);
        
        //결재문서 조회
        List<Map<String, Object>> step5 = new ArrayList<Map<String, Object>>();
        step5 = commonSql.list("EmpManage.getEaDocMustList", params);
        
        
        
        Map<String, Object> mp = new HashMap<String, Object>();
        
        mp.put("step4", step4);
        mp.put("step5", step5);
        
        return mp;
    }

	@Override
	public List<Map<String, Object>> getEmpInfoList(Map<String, Object> params) {
		return commonSql.list("EmpManage.getEmpInfoList", params);
	}
	
	@Override
	public List<Map<String, Object>> getEmpInfoListNew(Map<String, Object> params) {
		return commonSql.list("EmpManage.getEmpInfoListNew", params);
	}	
	
	@Override
	public String isMailUse(Map<String, Object> params){
	    return (String) commonSql.select("EmpManage.isMailUse", params);
	}
	
	@Override
    public String getMailDomain(Map<String, Object> params){
        return (String) commonSql.select("EmpManage.getMailDomain", params);
    }

	@Override
	public String getbizSeq(Map<String, Object> para) {
		return (String) commonSql.select("EmpManage.getBizSeq", para);
	}

	@Override
	public void updateEmpPicFileId(Map<String, Object> empMap) {
		commonSql.update("EmpManage.updateEmpPicFileId", empMap);
	}

	@Override
	public Map<String, Object> getAttendTimeInfo(Map<String, Object> params) {
		return (Map<String, Object>) commonSql.select("EmpManage.getAttendTimeInfo", params);
	}

	@Override
	public Map<String, Object> updateUserMailPasswd(Map<String, Object> params) throws Exception{
		
		Map<String, Object> mailInfo = (Map<String, Object>) commonSql.select("EmpManage.getMailInfo", params);
		String jsonStr = "";
		HashMap<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!mailInfo.get("compEmailYn").equals("Y")){
			result.put("resultCode", "0");
	        result.put("resultMessage", "SUCCESS");
	        
	        return result;
		}
		
			
		
		if(mailInfo != null){			
			map.put("domain", (String) mailInfo.get("emailDomain")+"");
			map.put("id", params.get("emailAddr")+"");
			map.put("empSeq", params.get("empSeq")+"");
			
			String enpassword = URLEncoder.encode(EgovFileScrty.encryptPassword(params.get("loginPasswdNew")+""),"UTF-8");
			map.put("password", enpassword);
			
			
			String url = (String) mailInfo.get("mailUrl")+"changeUserPasswd.do";
			String param = setParam(map);
			
			URL u = null;
			HttpURLConnection  huc = null;
	        String json = "";
	        
	        try {
	            u = new URL(url);
	            huc = (HttpURLConnection)u.openConnection();
	            huc.setRequestMethod("POST");
	            huc.setDoInput(true);
	            huc.setDoOutput(true);
	            huc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	            
	            
	            OutputStream os = huc.getOutputStream();
	            os.write(param.getBytes());
	            os.flush();
	            os.close();
	            
	            InputStream is = huc.getInputStream();
	            Writer writer = new StringWriter();

	            char[] buffer = new char[1024];
	            try
	            {
	                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
	                int n;
	                while ((n = reader.read(buffer)) != -1) 
	                {
	                    writer.write(buffer, 0, n);
	                }
	                json = writer.toString();
	            }
	            finally 
	            {
	                is.close();
	                writer.close();
	            }
	            
	        }
	        catch(Exception e) {
	        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	        }
	        
	        JSONObject jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(json));
	        
	        Map<String, Object> retVal = new HashMap<String, Object>();
	        String resultCode = isNullStr(jsonObject.get("resultCode"));
	        String resultMessage = isNullStr(jsonObject.get("resultMessage"));	
	        result.put("resultCode", resultCode);
	        result.put("resultMessage", resultMessage);
		}
		else{
			result.put("resultCode", "-1");
	        result.put("resultMessage", BizboxAMessage.getMessage("TX000016537","메일정보가 존재하지 않습니다."));	        
		}
		
		return result;
	}

	@Override
	public String getEmpMasterAuth(Map<String, Object> params) {
		return (String) commonSql.select("EmpManage.getEmpMasterAuth", params);
	}
	
	public void updateErpEmpInfo(Map<String, Object> params, ConnectionVO conVo) {
		connect(conVo);
		
		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession();
		try {
			Map<String, Object> erpParam = new HashMap<String, Object>();
			
			/* ERP 데이터에 맞게 다국어 형식 변환*/
			if(params.get("nativeLangCode").equals("kr")) {
				erpParam.put("LANGKIND", "KOR");
			} else if(params.get("nativeLangCode").equals("en")){
				erpParam.put("LANGKIND", "ENG");
			} else if(params.get("nativeLangCode").equals("cn")) {
				erpParam.put("LANGKIND", "CHS");
			} else if(params.get("nativeLangCode").equals("jp")) {
				erpParam.put("LANGKIND", "JPN");
			}
			
			/* 변경 파라미터 */
			erpParam.put("CO_CD", params.get("CO_CD"));
			erpParam.put("EMP_CD", params.get("erpEmpNum"));
			erpParam.put("KOR_NM", params.get("empName"));
			erpParam.put("ENLS_NM", params.get("empNameEn"));
			erpParam.put("CHN_NM", params.get("empNameCn"));
			erpParam.put("PASS", params.get("loginPasswdNew"));					
			erpParam.put("BRTH_DT", params.get("bday").toString().replace("-", ""));
			erpParam.put("WEDDING_DAY", params.get("weddingDay").toString().replace("-", ""));
			erpParam.put("TEL", params.get("homeTelNum"));
			erpParam.put("RSRG_ADD", params.get("addr"));
			erpParam.put("RSRD_ADD", params.get("detailAddr"));
			erpParam.put("EMGC_TEL", params.get("mobileTelNum"));
		
			session.selectList("updateErpEmpInfo", erpParam);
			session.close();
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		} finally {
			session.close();
		}
	}
	
	// 세션 팩토리 객체를 생성하고 그 결과를 리턴해주는 메서드
	private boolean connect(ConnectionVO conVo) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장
			// String resource = "sample/mybatis/sql/mybatis-config.xml";
			String resource = "egovframework/sqlmap/config/"
					+ conVo.getDatabaseType()
					+ "/erpOrgSync/erpOrgSync-mybatis-config.xml";

			Properties props = new Properties();
			props.put("databaseType", conVo.getDatabaseType());
			props.put("driver", conVo.getDriver());
			props.put("url", conVo.getUrl());
			props.put("username", conVo.getUserId());
			props.put("password", conVo.getPassWord());
			props.put("erpTypeCode", conVo.getSystemType());
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader(resource);
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성
			// sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader,
			// props);
			if (sqlSessionFactory == null) {
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(
						reader, props);
			} else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(
						reader, props);
			}
			result = true;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return result;
	}
	
	public void initPasswordFailcount(Map<String, Object> params) {
		try {
			empManageDAO.initPasswordFailcount(params);
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	public void setUserPortlet(Map<String, Object> params) {
		try {
			empManageDAO.setUserPortlet(params);
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	public void initToken(Map<String, Object> params) {
		try {
			empManageDAO.initToken(params);
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

	public boolean delToken(Map<String, Object> params) {
		try {
			empManageDAO.delToken(params);
		}catch(Exception e) {
			return false;
		}
		
		return true;
	}	
	
}
