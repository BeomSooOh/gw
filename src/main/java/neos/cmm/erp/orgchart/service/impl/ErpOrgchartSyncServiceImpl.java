package neos.cmm.erp.orgchart.service.impl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import api.common.model.APIResponse;
import api.msg.service.MsgService;
import bizbox.orgchart.service.vo.CompMultiVO;
import bizbox.orgchart.service.vo.CompVO;
import bizbox.orgchart.service.vo.EmpDeptMultiVO;
import bizbox.orgchart.service.vo.EmpDeptVO;
import bizbox.orgchart.service.vo.EmpMultiVO;
import bizbox.orgchart.service.vo.EmpVO;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.erp.convert.ErpDataConverter;
import neos.cmm.erp.convert.ErpDataConvertorCreator;
import neos.cmm.erp.dao.ErpOrgchartDAO;
import neos.cmm.erp.dao.ErpOrgchartDAOCreator;
import neos.cmm.erp.orgchart.service.ErpOrgchartSyncService;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.file.service.WebAttachFileService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgchart.OrgChartSupport;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CollectionUtils;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.MessageUtil;
import neos.cmm.util.mailDomainMove;
import neos.cmm.util.code.service.SequenceService;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("ErpOrgchartSyncService")
public class ErpOrgchartSyncServiceImpl implements ErpOrgchartSyncService{

	private Logger logger = Logger.getLogger(this.getClass());
	
	
	@Resource(name="ErpOrgchartDAO")
	ErpOrgchartSyncDAO erpOrgchartDAO;
	
	@Resource(name="WebAttachFileService")
	WebAttachFileService webAttachFileService;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@Resource(name = "CommonOptionManageService")
	private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "CompManageService")
	private CompManageService compService;
	
	@Resource(name = "FileUploadService")
	private FileUploadService fileUploadService;
	
	@Resource(name="MsgService")
	private MsgService msgService;
	
	@Resource(name = "LicenseService")
	private LicenseService licenseService;
	
	@Override
	public Map<String, Object> selectErpSyncDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return erpOrgchartDAO.selectErpSyncDetailList(params, paginationInfo);
	}

	@Override
	public List<Map<String, Object>> selectErpGwJobCodeList(Map<String, Object> params) {
		
		List<Map<String, Object>> syncWorkCodeList = erpOrgchartDAO.selectErpSyncCodeList(params);
		
		return syncWorkCodeList;
	}

	@Override
	public List<Map<String, Object>> selectErpSyncWorkCodeList(List<Map<String, Object>> erpWorkCodeList,
			Map<String, Object> params) {
		
		/** ERP에서 근무구분 코드가 없을수 있다. 그러면 공통코드에 ERP 근무구분 코드로 조회한다. */
		
		String erpType = (String)params.get("erpType");
		
		if (erpWorkCodeList == null) {
			
			if (erpType.equals("iu")) {
				params.put("code", "ERP020");
			}
			else if(erpType.equals("icube")) {
				params.put("code", "ERP030");
			}
			else if(erpType.equals("gerp")) {
				params.put("code", "ERP040");
			}
			
			params.put("aliasCode", "erpCode");
			params.put("aliasName", "erpCodeName");
			erpWorkCodeList = erpOrgchartDAO.selectCommonCodeList(params);
		}
		
		params.put("codeType", "10");
		List<Map<String, Object>> syncWorkCodeList = erpOrgchartDAO.selectErpSyncCodeList(params);
		
		List<Map<String, Object>> list = CollectionUtils.sum(erpWorkCodeList, syncWorkCodeList, "erpCode");
		
		return list;
	}

	@Override
	public List<Map<String, Object>> selectErpEmpWorkCodeList(Map<String, Object> params) {
		return null;
	}

	@Override
	public List<Map<String, Object>> selectCommonCodeList(Map<String, Object> params) {
		return erpOrgchartDAO.selectCommonCodeList(params);
	}

	@Override
	public List<Map<String, Object>> selectErpSyncJobCodeList(List<Map<String, Object>> codeList,
			Map<String, Object> params) {
		List<Map<String, Object>> syncWorkCodeList = erpOrgchartDAO.selectErpSyncCodeList(params);

		List<Map<String, Object>> list = CollectionUtils.sum(codeList, syncWorkCodeList, "erpCode");
		
		logger.debug("list : " + list);
		return list;
	}

	@Override
	public void deleteErpSyncCodeList(Map<String, Object> params) {
		erpOrgchartDAO.deleteErpSyncCodeList(params);
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void insertErpSyncCodeList(Map<String, Object> params) {
		
		List<Map<String,Object>> list = (List<Map<String, Object>>) params.get("codeList");
		
		String erpType = params.get("erpType").toString();

		if (erpType.equals("iu")) {
			params.put("code", "ERP021");
		} else if (erpType.equals("icube")) {
			params.put("code", "ERP031");
		}
		params.put("aliasCode", "erpCode");
		params.put("aliasName", "erpCodeName");
		params.put("aliasFlag1", "gwCode");
		List<Map<String,Object>> cmmList = erpOrgchartDAO.selectCommonCodeList(params);
		if (cmmList != null) {
			for(Map<String,Object> m : cmmList) {
				m.put("codeType", "1");
			}
			list.addAll(cmmList);
		}
		if (erpType.equals("iu")) {
			params.put("code", "ERP022");
		} else if (erpType.equals("icube")) {
			params.put("code", "ERP032");
		}
		cmmList = erpOrgchartDAO.selectCommonCodeList(params);
		if (cmmList != null) {
			for(Map<String,Object> m : cmmList) {
				m.put("codeType", "2");
			}
			list.addAll(cmmList);
		}
		if (erpType.equals("iu")) {
			params.put("code", "ERP023");
		} else if (erpType.equals("icube")) {
			params.put("code", "ERP033");
		}
		cmmList = erpOrgchartDAO.selectCommonCodeList(params);
		if (cmmList != null) {
			for(Map<String,Object> m : cmmList) {
				m.put("codeType", "3");
			}
			list.addAll(cmmList);
		}


		erpOrgchartDAO.insertErpSyncCodeList(params);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public List<Map<String, Object>> getErpdeptOrgchartListJT(List<Map<String, Object>> list, Map<String, Object> pathMap, Map<String, Object> params) {
		
		Map tree = new HashMap<String, Map<String, Object>>();
		Map burffer = new HashMap<String, Map<String, Object>>();
		
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		Map<String,Object> resultMap = null;
		Map<String,Object> bizResultMap = null;
		String orgListType = params.get("orgListType")+"";
		if(orgListType.equals("temp")) {	// 임시저장인경우 결과를 ERP 조직도에 보여줘야 한다.
			List<Map<String,Object>> tempOrgList = erpOrgchartDAO.selectTmpDeptList(params);
			List<Map<String,Object>> tempBizList = erpOrgchartDAO.selectTmpBizInfoList(params);
			if (tempOrgList != null) {
				resultMap = CollectionUtils.getListToMap(tempOrgList, "id");
			}
			if (tempBizList != null) {
				bizResultMap = CollectionUtils.getListToMap(tempBizList, "bizSeq");
			}
		}
		

		for (Map<String, Object> item : list) {

			Map<String, Object> node = new HashMap<String, Object>();
			
			
			Map<String, Object> nodeState = new HashMap<String, Object>();
			nodeState.put("selected", false);
			nodeState.put("opened", true);
			
			Map<String, Object> nodeTextAttribute = new HashMap<String, Object>();
			
			if(item.get("useYn") != null && item.get("useYn").toString().equals("N")) {
				nodeTextAttribute.put("style", "color:#A6A6A6;");
			}
			
			
			String deptSeq = item.get("id").toString();
			if (item.get("gbnOrg").toString().equals("d")) {
				
				// 부서 경로 설정
				Map<String,Object> m = (Map<String, Object>) pathMap.get(deptSeq); 
				if(m != null) {
					if (m.get("path") != null) {
						String path = m.get("path").toString();
						item.put("path",path);
					}
					if (m.get("pathName") != null) {
						String pathName = m.get("pathName").toString();
						item.put("pathName",pathName);
					}
					if (m.get("parentPath") != null) {
						String parentPath = m.get("parentPath").toString();
						item.put("parentPath",parentPath);
					}
				}
			
			
				// 결과확인 적용하기(임시 저장결과)
				if(resultMap != null) {
					Map<String,Object> result = (Map<String, Object>) resultMap.get(deptSeq);
					if(result != null) {
						int r = CommonUtil.getIntNvl((result.get("deptResultCode")+"").trim());
						int s = CommonUtil.getIntNvl((result.get("deptMultiResultCode")+"").trim());

						if(result.get("bizResultCode") != null && result.get("bizResultCode").equals("2")) {
							nodeTextAttribute.put("style", "color:#FF0000;");
						}
						else if(r == 0 || s == 0 ) {
							nodeTextAttribute.put("style", "color:#00AAF0;");
						}else if(r == 20 || s == 20 || r == 30 || s == 30 ) {
							nodeTextAttribute.put("style", "");
						}else if(r == 2 || s == 2) {
							nodeTextAttribute.put("style", "color:#A6A6A6;");
						}else {
							nodeTextAttribute.put("style", "color:#FF0000;");
						}
					}
				}
			}
			
			
			if (item.get("gbnOrg").toString().equals("b")) {
				// 결과확인 적용하기(임시 저장결과)
				if(bizResultMap != null) {
					Map<String,Object> result = (Map<String, Object>) bizResultMap.get(item.get("id").toString());
					if(result != null) {
						int r = CommonUtil.getIntNvl((result.get("resultCode")+"").trim());
	
						if(r == 0) {
							nodeTextAttribute.put("style", "color:#00AAF0;");
						}else if(r == 2 ) {
							nodeTextAttribute.put("style", "color:#FF0000;");
						}else {
							nodeTextAttribute.put("style", "");
						}
					}
				}
			}

			String text =  item.get("text").toString();
			if(!params.get("includeDeptCode").toString().equals("")){
				text += "(" + item.get("id") + ")";
			}
			
			
			if(params.get("retKey") != null) {
				node.put("batchSeq", item.get("batchSeq").toString());
			}
			
			node.put("id", item.get("orgDiv").toString() + item.get("id").toString());
			node.put("text", text);
			node.put("isFolder", true);
			node.put("state", nodeState);
			node.put("textAttribute", nodeTextAttribute);
			node.put("gbnOrg", item.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq"));
			node.put("parentSeq", item.get("parentSeq"));
			node.put("team_yn", item.get("team_yn") == null || item.get("team_yn").equals("") ? "N" : item.get("team_yn"));
			node.put("children", new ArrayList<Map<String, Object>>());
			
			burffer.put(item.get("path"), node);
			
		}

		ArrayList<String> compSeq = new ArrayList<>();

		for (int i = list.size() - 1; i > -1; i--) {
			
			Map<String, Object> item = list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			String id = item.get("path").toString();
			Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);

			node.put("id", bNode.get("id"));
			node.put("text", bNode.get("text"));
			node.put("gbnOrg", bNode.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq"));
			node.put("parentSeq", item.get("parentSeq"));
			node.put("team_yn", item.get("team_yn") == null || item.get("team_yn").equals("") ? "N" : item.get("team_yn"));
			node.put("state", bNode.get("state"));
			node.put("textAttribute", bNode.get("textAttribute"));
			node.put("children", bNode.get("children"));
			
			

			if (item.get("parentSeq").toString().equals("0")) {
				
				tree.put(node.get("id"), burffer.get(id));
				compSeq.add(0,item.get("id").toString());
			} else {
				
				try{
					((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parentPath"))).get("children")).add(0,node);

				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
			}
		}

		for (String item : compSeq) {
			returnList.add((Map<String, Object>) tree.get("c"+item));
		}
		
		return returnList;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGwdeptOrgchartListJT(Map<String, Object> params) {
		Map tree = new HashMap<String, Map<String, Object>>();
		Map burffer = new HashMap<String, Map<String, Object>>();
		
		List<Map<String, Object>> returnList = new ArrayList<>();
		String queryID = "";
		if(params.get("retKey") == null) {
			queryID = "OrgChart.selectOrgFullListAdmin";
		}
		else {
			queryID = "OrgChart.selectOrgBatchPreviewList";
		}
		
		List<Map<String, Object>> list = commonSql.list(queryID, params);

		for (Map<String, Object> item : list) {

			Map<String, Object> node = new HashMap<String, Object>();
			
			Map<String, Object> nodeState = new HashMap<String, Object>();
			nodeState.put("selected", false);
			nodeState.put("opened", true);			

			String text =  item.get("text") == null ? "" : item.get("text").toString();
			if(!params.get("includeDeptCode").toString().equals("")){
				if(params.get("retKey") == null) {
					text += "(" + item.get("org_cd") + ")";
				}
				else {
					text += "(" + item.get("id") + ")";
				}
			}
			
			if(params.get("retKey") != null) {
				node.put("batchSeq", item.get("batchSeq").toString());
			}

			node.put("id", item.get("orgDiv").toString() + item.get("id").toString());
			node.put("text", text);
			node.put("isFolder", true);
			node.put("gbnOrg", item.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parent_seq"));
			node.put("team_yn", item.get("team_yn"));
			node.put("vir_dept_yn", item.get("vir_dept_yn"));
			node.put("state", nodeState);
			node.put("children", new ArrayList<Map<String, Object>>());
			node.put("originText", item.get("text"));

			burffer.put(item.get("path"), node);
			
		}


		ArrayList<String> compSeq = new ArrayList<>();

		for (int i = list.size() - 1; i > -1; i--) {
			
			Map<String, Object> item = list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			String id = item.get("path").toString();
			Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
			

			node.put("id", bNode.get("id"));
			node.put("text", bNode.get("text"));
			node.put("gbnOrg", bNode.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parent_seq"));
			node.put("team_yn", item.get("team_yn"));
			node.put("state", bNode.get("state"));
			node.put("children", bNode.get("children"));
			node.put("vir_dept_yn", item.get("vir_dept_yn"));
			node.put("originText", bNode.get("originText"));

			if (item.get("parent_seq").toString().equals("0")) {
				tree.put(node.get("id"), burffer.get(id));
				compSeq.add(0,item.get("id").toString());
				
			} else {
				try{
					((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parent_path"))).get("children")).add(0,node);
				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
			}
		}
		for (String item : compSeq) {
			returnList.add((Map<String, Object>) tree.get("c"+item));
		}
		return returnList;
	}
	

	@Override
	public List<Map<String, Object>> selectErpSyncDetailList(Map<String, Object> params) {
		return erpOrgchartDAO.selectErpSyncDetailList(params);
	}

	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getErpdeptOrgchartTestList(HttpServletRequest request,
			List<Map<String, Object>> orgList,	Map<String, Object> params) {
		
		//String erpBizSeqList = null;
		//String erpDeptSeqList = null;
		
		Map<String, Object> bizMap = null;
		Map<String, Object> deptMap = null;
		
		/*
		if (erpBizSeqList.length() > 1) {
			params.put("erpBizSeqList", erpBizSeqList);
			List<Map<String, Object>> bizList = erpOrgchartDAO.selectSyncBizList(params);
			if (bizList != null){
				bizMap = CollectionUtils.getListToMap(bizList, "erpBizSeq");
			}
		}
		if (erpBizSeqList.length() > 1) {
			params.put("erpDeptSeqList", erpDeptSeqList);				
			List<Map<String, Object>> deptList = erpOrgchartDAO.selectSyncDeptList(params);

			if (deptList != null) {
				deptMap = CollectionUtils.getListToMap(deptList, "erpDeptSeq");
			}
		}
		*/
		
		String[] mArr = new String[]{"erp.orgchart.test.sucess", "erp.orgchart.test.fail.dup.biz", "erp.orgchart.test.fail.dup.dept"};

		for(Map<String,Object> m : orgList) {
			String gbnOrg = m.get("gbnOrg")+"";
			if (gbnOrg.equals("d") && deptMap != null){
				Map<String,Object> rMap = (Map<String, Object>) deptMap.get(m.get("id"));
				if (rMap != null) {
					m.putAll(rMap);
				} else {
					m.put("resultCode", "0");
				}
			}
			else if (gbnOrg.equals("b") && bizMap != null){
				Map<String,Object> rMap = (Map<String, Object>) bizMap.get(m.get("id"));
				if (rMap != null) {
					m.putAll(rMap);
				} else {
					m.put("resultCode", "0");
				}
			}
			
			String resultCode = m.get("resultCode")+"";
			if (!EgovStringUtil.isEmpty(resultCode)) {
				m.put("resultCodeName", MessageUtil.getMessage(request,mArr[Integer.parseInt(resultCode.trim())]));
			}

		}
		logger.debug("orgList : " + orgList);

		return orgList;
	}

	@Override
	public List<Map<String, Object>> insertErpdeptOrgchartList(HttpServletRequest request,
			List<Map<String, Object>> orgList, Map<String, Object> pathInfo, Map<String, Object> params) {

		List<Map<String,Object>> list = getErpdeptOrgchartTestList(request, orgList, params);
		
		List<Map<String,Object>> bizList = new ArrayList<>();
		List<Map<String,Object>> deptList = new ArrayList<>();
		
		for(Map<String,Object> map : list) {
			String gbnOrg = map.get("gbnOrg")+"";
			String resultCode = map.get("resultCode")+"";
			map.put("gwGroupSeq", params.get("groupSeq"));
			map.put("gwCompSeq", params.get("compSeq"));
			map.put("syncSeq", params.get("syncSeq"));
			if (resultCode.equals("0")) {
				if (gbnOrg.equals("d")){
					
					String deptSeq = erpOrgchartDAO.insertDept(map);
					map.put("gwDeptSeq", deptSeq);
					erpOrgchartDAO.insertDeptMulti(map);
					erpOrgchartDAO.insertErpDept(map);					
				}
				else if (gbnOrg.equals("b")){
					erpOrgchartDAO.insertTmpBiz(map);
					erpOrgchartDAO.insertTmpBizMulti(map);
					
				}
			}
		}
		
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> setTempdeptOrgchart(Map<String, Object> params) {
		List<Map<String,Object>> list = new ArrayList<>();
		List<Map<String,Object>> erpBizList = (List<Map<String, Object>>) params.get("erpBizList");
		List<Map<String,Object>> erpDeptList = (List<Map<String, Object>>) params.get("erpDeptList");
		Map<String,Object> pathInfo = (Map<String, Object>) params.get("pathInfo");
		
		//String erpType = (String)params.get("erpType");
		
		ErpDataConverter convertor = ErpDataConvertorCreator.newInstance(params);
		
		//결과확인 중복처리를 위한 기존 SyncSeq 데이터 삭제처리
		erpOrgchartDAO.deleteTmpBiz(params);
		erpOrgchartDAO.deleteTmpBizMulti(params);
		erpOrgchartDAO.deleteTmpDept(params);
		erpOrgchartDAO.deleteTmpDeptMulti(params);
		
		//기존 temp테이블 데이터 삭제처리(최근 10일이전 데이터 삭제처리)
		deleteOrgchartTempOld(params.get("groupSeq") + "");
		
		// 임시데이터 저장하기
		for(int i = 0; i < erpBizList.size(); i++) {
			Map<String, Object> map = erpBizList.get(i);
//			map.put("gwGroupSeq", params.get("groupSeq"));
//			map.put("gwCompSeq", params.get("compSeq"));
//			map.put("syncSeq", params.get("syncSeq"));
//			map.put("editorSeq", params.get("editorSeq"));
//			map.put("langCode", params.get("langCode"));
			map.put("orderNum", i);
			map.put("gwBizSeq", map.get("id").toString());
			map.put("dtTopen", params.get("dtTopen") != null ? params.get("dtTopen").toString().trim():null);
			erpOrgchartDAO.insertTmpBiz(convertor.getBiz(map, params));
			erpOrgchartDAO.insertTmpBizMulti(convertor.getBizMulti(map, params));
			list.add(map);
		}
		
		for(int i = 0; i < erpDeptList.size(); i++) {
			Map<String, Object> map = erpDeptList.get(i);
//			map.put("gwGroupSeq", params.get("groupSeq"));
//			map.put("gwCompSeq", params.get("compSeq"));
//			map.put("syncSeq", params.get("syncSeq"));
//			map.put("editorSeq", params.get("editorSeq"));
//			map.put("langCode", params.get("langCode"));
			map.put("dtEnd", params.get("dtEnd") != null ? params.get("dtEnd").toString().trim():null);
			map.put("orderNum", i);
//			map.put("gwDeptSeq", map.get("id").toString());
//			map.put("gwHDept", map.get("parentSeq").toString());
//			map.put("gwBizSeq",map.get("cdCompany").toString()+map.get("cdBizarea").toString());
//			
			String deptSeq = map.get("id").toString();
			
			Map<String,Object> m = (Map<String, Object>) pathInfo.get(deptSeq); 
			if(m != null) {
				if (m.get("path") != null) {
					String path = m.get("path").toString();
					map.put("path",path);
				}
				if (m.get("pathName") != null) {
					String pathName = m.get("pathName").toString();
					map.put("pathName",pathName);
				}
				if (m.get("parentPath") != null) {
					String parentPath = m.get("parentPath").toString();
					map.put("parentPath",parentPath);
				}
			} else {
				map.put("path",map.get("id").toString());
				map.put("pathName",map.get("nmDept").toString());
				map.put("parentPath",null);
			}
			
			erpOrgchartDAO.insertTmpDept(convertor.getDept(map, params));
			erpOrgchartDAO.insertTmpDeptMulti(convertor.getDeptMulti(map, params));
			
			list.add(map);
		}
		
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getErpdeptOrgchartTempListJT(Map<String, Object> params) {
		Map tree = new HashMap<String, Map<String, Object>>();
		Map burffer = new HashMap<String, Map<String, Object>>();
		
		List<Map<String, Object>> returnList = new ArrayList<>();
		
		List<Map<String,Object>> list = new ArrayList<>();
		
		List<Map<String,Object>> compList = erpOrgchartDAO.selectCompList(params);
		if (compList != null) { 
			list.addAll(compList);
		}
		List<Map<String,Object>> bizList = erpOrgchartDAO.selectTmpBizList(params);
		if (bizList != null) {
			list.addAll(bizList);
		}
		List<Map<String,Object>> deptList = erpOrgchartDAO.selectTmpDeptList(params);
		if (deptList != null) {
			list.addAll(deptList);
		}

		for (Map<String, Object> item : list) {

			Map<String, Object> node = new HashMap<String, Object>();
			
			Map<String, Object> nodeState = new HashMap<String, Object>();
			nodeState.put("selected", false);
			nodeState.put("opened", true);
			
			String text =  item.get("text").toString();
			if(!params.get("includeDeptCode").toString().equals("")){
				text += "(" + item.get("id") + ")";
			}
			
			if(params.get("retKey") != null) {
				node.put("batchSeq", item.get("batchSeq").toString());
			}
			node.put("id", item.get("orgDiv").toString() + item.get("id").toString());
			node.put("text", text);
			node.put("isFolder", true);
			node.put("gbnOrg", item.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parentSeq"));
			node.put("team_yn", item.get("team_yn") == null || item.get("team_yn").equals("") ? "N" : item.get("team_yn"));
			node.put("state", nodeState);
			node.put("children", new ArrayList<Map<String, Object>>());
			
			burffer.put(item.get("path"), node);
			
		}

		ArrayList<String> compSeq = new ArrayList<>();

		for (int i = list.size() - 1; i > -1; i--) {
			
			Map<String, Object> item = list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			String id = item.get("path").toString();
			Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
			
			node.put("id", bNode.get("id"));
			node.put("text", bNode.get("text"));
			node.put("gbnOrg", bNode.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parentSeq"));
			node.put("team_yn", item.get("team_yn") == null || item.get("team_yn").equals("") ? "N" : item.get("team_yn"));
			node.put("state", bNode.get("state"));
			node.put("children", bNode.get("children"));

			if (item.get("parentSeq").toString().equals("0")) {
				
				tree.put(node.get("id"), burffer.get(id));
				compSeq.add(0,item.get("id").toString());
				
			} else {
				
				try{
					((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parentPath"))).get("children")).add(0,node);
					
				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
			}
		}

		
		for (String item : compSeq) {
			returnList.add((Map<String, Object>) tree.get("c"+item));
		}
		//System.out.println(returnList);

		return returnList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> setTempEmp(Map<String, Object> params) {
		
		List<Map<String,Object>> typeList = (List<Map<String, Object>>) params.get("typeList");
		List<Map<String,Object>> empList = (List<Map<String, Object>>) params.get("empList");
		
		ErpDataConverter convertor = ErpDataConvertorCreator.newInstance(params);
		
//		String loginIdType = params.get("loginIdType").toString();
		
		Map<String,Object> wsCodeInfo = new HashMap<>();
		Map<String,Object> licenseCodeInfo1 = new HashMap<>();
		Map<String,Object> licenseCodeInfo2 = new HashMap<>();
		Map<String,Object> checkWorkYnInfo1 = new HashMap<>();
		Map<String,Object> checkWorkYnInfo2 = new HashMap<>();
		Map<String,Object> empTypeCodeInfo = new HashMap<>();
		Map<String,Object> genderCodeInfo = new HashMap<>();
		Map<String,Object> birthdayCodeInfo = new HashMap<>();
		
		for(Map<String,Object> map : typeList) {
			String type = map.get("codeType").toString();
			String erpCode = map.get("erpCode").toString();
			String gwCode = map.get("gwCode").toString();
			String gwCode2 = map.get("gwCode2") == null ? "" : map.get("gwCode2").toString();
			int t = Integer.parseInt(type.trim());
			
			switch (t) {
				case 1:		empTypeCodeInfo.put(erpCode, gwCode);	break;
				case 2:		genderCodeInfo.put(erpCode, gwCode);	break;
				case 3:		birthdayCodeInfo.put(erpCode, gwCode);	break;
				case 10:	wsCodeInfo.put(erpCode, gwCode);		break;
				case 20:	licenseCodeInfo1.put(erpCode, gwCode);	checkWorkYnInfo1.put(erpCode, gwCode2);	break;
				case 30:	licenseCodeInfo2.put(erpCode, gwCode); 	checkWorkYnInfo2.put(erpCode, gwCode2); break;
				default:
					break;
			}
		}

		params.put("empTypeCodeInfo", empTypeCodeInfo);
		params.put("genderCodeInfo", genderCodeInfo);
		params.put("birthdayCodeInfo", birthdayCodeInfo);
		params.put("wsCodeInfo", wsCodeInfo);
		params.put("licenseCodeInfo1", licenseCodeInfo1);
		params.put("licenseCodeInfo2", licenseCodeInfo2);
		params.put("checkWorkYnInfo1", checkWorkYnInfo1);
		params.put("checkWorkYnInfo2", checkWorkYnInfo2);

		
		//일용직을 위한 임시 직급/직책 코드값 추가작업
		commonSql.insert("OrgChart.tempDutyPositionInsert", params);
		commonSql.insert("OrgChart.tempDutyPositionMultiInsert", params);
		
		//기존 temp테이블 데이터 삭제처리(최근 10일이전 데이터 삭제처리)
		deleteEmpTempOld(params.get("groupSeq") + "");
		
		try {
			for(int i = 0; i < empList.size(); i++) {
				Map<String,Object> emp = empList.get(i);
				// 겸직정보 입력(주부서)
				if (emp.get("mainDeptYn") == null || emp.get("mainDeptYn").toString().equals("")) {
					emp.put("mainDeptYn", "Y");
				}

				String loginIdType= (String)params.get("loginIdType"); // loginId 종류

				// 사원정보 입력
				Map<String,Object> empMap = convertor.getEmp(emp, params);
				
				//동기화대상 사용자중 메일아이디 중복여부 확인
				String tmpMailIdCheckCnt = (String) commonSql.select("ErpOrgchartDAO.getTmpMailIdCheckCnt", empMap);
				empMap.put("tmpMailIdCheckCnt", tmpMailIdCheckCnt);
				
				emp.put("orderNum", i);
				String empSeq = empMap.get("empSeq")+"";
				if (emp.get("mainDeptYn").toString().equals("Y")) {
					empSeq = erpOrgchartDAO.insertTmpEmp(empMap);
				}

				loginIdType= (String)params.get("loginIdType"); // loginId 종류
				String workStatus = (String)empMap.get("workStatus"); // loginId 종류
				String erpEmpSeq  = (String)empMap.get("noEmp"); //ERP 사원 시퀀스
				String erpCompSeq = (String)empMap.get("cdCompany"); //ERP 회사 시퀀스
				String erpBizSeq  = (String)empMap.get("cdBizarea"); //ERP 사업장 시퀀스
				String erpDeptSeq = (String)empMap.get("cdDept"); //ERP 부서 시퀀스
				String loginId    = (String)empMap.get("loginId"); //
				emp.put("loginIdType", loginIdType);
				emp.put("workStatus", workStatus);
				emp.put("erpEmpSeq", erpEmpSeq);
				emp.put("erpCompSeq", erpCompSeq);
				emp.put("erpBizSeq", erpBizSeq);
				emp.put("erpDeptSeq", erpDeptSeq);
				emp.put("loginId",loginId);

				emp.put("empSeq", empSeq);
				if (emp.get("mainDeptYn").toString().equals("Y")) {
					erpOrgchartDAO.insertTmpEmpMulti(convertor.getEmpMulti(emp, params));
				}

				erpOrgchartDAO.insertTmpEmpDept(convertor.getEmpDept(emp, params));
				erpOrgchartDAO.insertTmpEmpDeptMulti(convertor.getEmpDeptMulti(emp, params));

				//iu 부부서
				//				String gwDeptSeq2 = emp.get("gwDeptSeq2")+"";
				//				if(EgovStringUtil.isEmpty(gwDeptSeq2) == false) {
				//					emp.put("mainDeptYn", "N");
				//					emp.put("gwDeptSeq", gwDeptSeq2);
				//					emp.put("cdDept", emp.get("cdDdept"));
				//					erpOrgchartDAO.insertTmpEmpDept(convertor.getEmpDept(emp, params));
				//					erpOrgchartDAO.insertTmpEmpDeptMulti(convertor.getEmpDeptMulti(emp, params));
			}
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		return empList;
	}

	@Override
	public Map<String, Object> selectTmpEmpList(Map<String, Object> params, PaginationInfo paginationInfo) {
		
		
		
		return erpOrgchartDAO.selectTmpEmpList(params, paginationInfo);
	}

	@Override
	public Map<String, Object> setBiz(Map<String, Object> params) {
		
		Map<String, Object> result = new HashMap<>();
		
		/** 사업장 정보 입력 */
		erpOrgchartDAO.insertBizList(params);
		result.put("resultCode", "0");
		result.put("moreYn", "N");

		List<Map<String,Object>> deptCntList = erpOrgchartDAO.selectTmpDeptTotalCount(params);
		List<Map<String,Object>> empCntList = erpOrgchartDAO.selectTmpEmpTotalCount(params);

		for(Map<String,Object> map : deptCntList) {
			String resultCode = map.get("resultCode")+"";
			if (resultCode.equals("0")) { // 신규 등록
				result.put("deptJoinTotalCount", map.get("resultCodeCnt"));
			}
			if (resultCode.equals("20")) {// 부서 사용안함처리
				result.put("deptModifyTotalCount", map.get("resultCodeCnt"));
			}
		}
		
		int resignCount = 0;
		int noMappingEmpCnt = 0;
		int empModifyCnt = 0;
		
		for(Map<String,Object> map : empCntList) {
			String resultCode = map.get("resultCode")+"";
			if (resultCode.equals("0")) { // 입사
				noMappingEmpCnt =  erpOrgchartDAO.selectNoMappingEmpCnt(params);				
				result.put("empJoinTotalCount", noMappingEmpCnt);
			}
			else if (resultCode.equals("20")) { // 사원정보 변경
				empModifyCnt = erpOrgchartDAO.selectEmpModifyCnt(params);
				result.put("empModifyTotalCount", empModifyCnt);
			}
			else if (resultCode.equals("7")) {
				// 퇴사
				resignCount = Integer.parseInt(map.get("resultCodeCnt").toString().trim());
				result.put("empResignTotalCount", Integer.toString(resignCount));
				result.put("empResignCount", Integer.toString(resignCount));				
			}
		}
		
		return result;
	}

	@Override
	public Map<String, Object> setDept(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		
		//String firstYn = params.get("firstYn")+"";
		
		result.put("moreYn", "N");
		result.put("resultCode", "0");

		/** 부서 정보 입력 */
		erpOrgchartDAO.insertDeptList(params);
		result.put("resultCode", "0");
		
		result.put("moreYn", params.get("moreYn"));
		
		return result;
	}


	@Override
	public Map<String, Object> setEmp(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();


		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int totalCount = EgovStringUtil.zeroConvert(params.get("empJoinTotalCount"));

		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(10);
		paginationInfo.setRecordCountPerPage(10); 
		paginationInfo.setTotalRecordCount(totalCount);

		result.put("resultCode", "0");
		
		// 신규 입사자 처리
		params.put("resultCode", "0");	
		Map<String, Object> empMap = null;
		
		if(params.get("autoYn") == null) {
			params.put("autoYn", "N");
		}
		
		if(params.get("autoYn").toString().equals("Y")) {
			empMap = erpOrgchartDAO.selectTmpEmpList(params);
		} else if(params.get("autoYn").toString().equals("N")){
			empMap = erpOrgchartDAO.selectTmpEmpList(params, paginationInfo);
		}
		 
				
				
		if (empMap != null) {
			@SuppressWarnings("unchecked")
			List<Map<String,Object>> list = (List<Map<String, Object>>) empMap.get("list");
			if (list != null && list.size() > 0) {
				for(Map<String,Object> map : list) {
					
					try {
						
						map.put("firstYn", params.get("firstYn"));
						String empSeq = null;
						boolean bool = false;
	
						EmpVO empVO = erpOrgchartDAO.selectTmpEmp(map);
						
						if(map.get( "edResultCode" ).equals( "6" ) || map.get( "edResultCode" ).equals( "10" ) || map.get( "edResultCode" ).equals( "30" ) || map.get( "edResultCode" ).equals( "40" )||map.get( "edResultCode" ).equals( "50" )) {
							continue;
						}
						
						
						//자동 동기화시 라이센스 확인
						if(params.get("autoYn").toString().equals("Y")) {
							if(empVO.getLicenseCheckYn().equals("1") && params.get("gwSyncYn").toString().equals("N")) {
								continue;
							}
							else if(empVO.getLicenseCheckYn().equals("2") && params.get("mailSyncYn").toString().equals("N")) {
								continue;
							}
						}
						
						
//						try {
//							/** 사진 등록 */
//							if(empVO != null) {
//								if(StringUtils.isNotEmpty(empVO.getPicFileId())) {
//									String erpPicFileId = empVO.getPicFileId();
//									logger.debug("erpPicFileId : " + erpPicFileId);
//									Map<String,Object> p = new HashMap<>();
//									p.put("picFileId", erpPicFileId);
//									p.put("dbUrl", params.get("dbUrl"));
//									p.put("erpCompSeq", map.get("erpCompSeq"));
//									p.put("erpEmpSeq", map.get("erpEmpSeq"));
//									p.put("empSeq", empVO.getEmpSeq());
//									p.put("erpType", params.get("erpType"));
//									p.put("erpOrgchartDAO", params.get("erpOrgchartDAO"));
//									p.put("groupSeq", params.get("groupSeq"));
//									logger.debug("p : " + p);
//									
//									if(params.get("erpType").toString().equals("iu")) {
//										// erpIU 연결테스트
//										boolean connectCheck = isConnected(p);
//										
//										if(connectCheck) {
//											String fileId = getPicFileId(p);
//											logger.debug("fileId : " + fileId);
//											
//											empVO.setPicFileId(fileId);
//										} else {
//											String iuFileServerIP = BizboxAProperties.getCustomProperty("BizboxA.Cust.iuFileServerIP");
//											
//											if(!iuFileServerIP.equals("99")) {
//												p.put("iuFileServerIP", iuFileServerIP);
//												String fileId = getPicFileId(p);
//												logger.debug("fileId : " + fileId);
//												
//												empVO.setPicFileId(fileId);
//											} else {
//												
//												empVO.setPicFileId("");
//											}
//											
//										}
//									} else {
//										String fileId = getPicFileId(p);
//										logger.debug("fileId : " + fileId);
//										
//										empVO.setPicFileId(fileId);
//									}
//									
//								}
//							}
//						}catch(Exception e) {
//							Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncServiceImpl.setEmp.PicfileID Error");
//							e.printStackTrace();	
//						}
	
						//System.out.println("*****************************empSeq : " + empSeq + "***********************************");
							
//						for (Field field : empVO.getClass().getDeclaredFields()) {
//			                field.setAccessible(true);
//							Object value = field.get(empVO); // 필드에 해당하는 값을 가져옵니다.
//							System.out.println(field.getName()+ " : " + value);
//			            }
//						
						
						//입사처리시 최초로그인 비밀번호변경팝업 뜨도록 설정
						//입사처리시 프로필사진 기본 빈값처리
						empVO.setPasswdStatusCode("I");
						empVO.setPicFileId("");
						
						//사용자연동항목 옵션조회
						String syncItem = getCmmOptionValue((String)params.get("compSeq"), "cm1120");
						
						// 1:사진이미지, 2:성벌, 3:입사일자, 4:퇴사일자, 5:생년월이, 6:전화번호, 7:집주소						
						//사용자연동항목 옵션에 따른 사용자정보 null처리
						if(syncItem.indexOf("1") == -1) {
							empVO.setPicFileId(null);
						}
						if(syncItem.indexOf("2") == -1) {
							empVO.setGenderCode(null);
						}
						if(syncItem.indexOf("3") == -1) {
							empVO.setJoinDay(null);
						}
						if(syncItem.indexOf("4") == -1) {
							empVO.setResignDay(null);
						}
						if(syncItem.indexOf("5") == -1) {
							empVO.setBday(null);
						}
						if(syncItem.indexOf("6") == -1) {
							empVO.setMobileTelNum(null);
							empVO.setHomeTelNum(null);
						}
						if(syncItem.indexOf("7") == -1) {
							empVO.setZipCode(null);
						}
						
						String licenseCheckYn = empVO.getLicenseCheckYn();
						
						
						//비라이선스 사용자 정보변경
						if(licenseCheckYn.equals("3")) {
							empVO.setMobileUseYn("N");
							empVO.setMessengerUseYn("N");
						}
						
						empVO.setApprPasswd(null);
						empVO.setPayPasswd(null);
						
						empSeq = OrgChartSupport.getIOrgEditService().InsertEmp(empVO);
						
						String custom = BizboxAProperties.getCustomProperty("BizboxA.Cust.CustErpOrg");
						
						if(!custom.equals("99")) {
							params.put("loginId", empVO.getErpEmpNum());
							params.put("gwEmpSeq", empSeq);
							setCustomData(params);
						}
	
	
						logger.debug("OrgChartSupport.getIOrgEditService().InsertEmp(empVO) : " + empSeq);
	
						if(empSeq == null || empSeq == "-1"){
							continue;
							// return result;
						}
						
						
	
						map.put("langCode", "kr");
						EmpMultiVO empMultiVO = erpOrgchartDAO.selectTmpEmpMulti(map);
						empMultiVO.setUseYn("Y");	//다국어 사용유무 기본값 Y로 설정
						
						//사용자연동항목 옵션에 따른 사용자정보 null처리
						//7:집
						if(syncItem.indexOf("7") == -1) {
							empMultiVO.setAddr(null);
							empMultiVO.setDetailAddr(null);
						}
						
						bool = OrgChartSupport.getIOrgEditService().InsertEmpMulti(empMultiVO);
						
						map.put("langCode", "en");
						empMultiVO = erpOrgchartDAO.selectTmpEmpMulti(map);
						if(empMultiVO != null) {
							empMultiVO.setUseYn("Y");	//다국어 사용유무 기본값 Y로 설정
							
							//사용자연동항목 옵션에 따른 사용자정보 null처리
							//7:집
							if(syncItem.indexOf("7") == -1) {
								empMultiVO.setAddr(null);
								empMultiVO.setDetailAddr(null);
							}
							
							bool = OrgChartSupport.getIOrgEditService().InsertEmpMulti(empMultiVO);
						}
	
						logger.debug("OrgChartSupport.getIOrgEditService().InsertEmpMulti(empMultiVO) : " + bool);
	
						if(!bool){
							//deleteEmpInfo(empSeq, true, true, false, false, false, true);
							return result;
						}
	
						EmpDeptVO empDeptVO = erpOrgchartDAO.selectTmpEmpDept(map);
	
						/** 사업장, 부서 정보 조회 */
						Map<String,Object> bizInfo = erpOrgchartDAO.selectBiz(map);
						Map<String,Object> deptInfo = erpOrgchartDAO.selectDept(map);
						if (bizInfo == null || deptInfo == null) {
							
							logger.debug("bizInfo : " + bizInfo);
							logger.debug("deptInfo : " + deptInfo);
							
							
							// deleteEmpInfo(empSeq, true, true, true, false, false, true);
							
							continue;
						}
						
						//비라이선스 사용자 정보변경
						if(licenseCheckYn.equals("3")) {
							empDeptVO.setMessengerDisplayYn("N");
							empDeptVO.setOrgchartDisplayYn("N");
						}
						
						bool = OrgChartSupport.getIOrgEditService().InsertEmpDept(empDeptVO);
						logger.debug("OrgChartSupport.getIOrgEditService().InsertEmpDept(empDeptVO) : " + bool);		
	
						if(!bool){
							// deleteEmpInfo(empSeq, true, true, true, false, false, true);
							return result;
						}		
	
						EmpDeptMultiVO empDeptMultiVO = erpOrgchartDAO.selectTmpEmpDeptMulti(map);
	
						bool = OrgChartSupport.getIOrgEditService().InsertEmpDeptMulti(empDeptMultiVO);
						logger.debug("OrgChartSupport.getIOrgEditService().InsertEmpDeptMulti(empDeptMultiVO) : " + bool);
	
						if(!bool){
							//deleteEmpInfo(empSeq, true, true, true, true, false, true);
							return result;
						}			
	
						//권한 및 메일계정 추가.
						params.put("deptSeq", empDeptVO.getDeptSeq());
						params.put("empSeq", empSeq);
						commonSql.insert("EmpDeptManage.insertBaseAuth", params);
						
						ErpOrgchartDAO erpOrgchartDAO = (ErpOrgchartDAO)params.get("erpOrgchartDAO");	
						params.put("erpEmpSeq", map.get("erpEmpSeq"));
						erpOrgchartDAO.updateErpEmpGwUpdateDate(params);
					}catch(Exception e) {
						Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncServiceImpl.setEmp Error");
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}
					
				}				
				result.put("moreYn","Y");				
			} else {
				result.put("resultCode", "0");
				result.put("moreYn", "N");
			}
		} else {
			result.put("resultCode", "0");
			result.put("moreYn", "N");
		}
		
		return result;
	}
	
//	private void deleteEmpInfo(String empSeq, boolean Emp, boolean EmpMulti, boolean EmpDept, boolean EmpDeptMulti, boolean UserAuth, boolean EmpComp){
//		
//		Map<String, Object> param = new HashMap<String, Object>();
//		param.put("empSeq", empSeq);
//		
//		if(Emp){
//			commonSql.delete("EmpManage.deleteEmpTemp", param);	
//		}
//		
//		if(EmpMulti){
//			commonSql.delete("EmpManage.deleteEmpMultiTemp", param);	
//		}
//		
//		if(EmpDept){
//			commonSql.delete("EmpManage.deleteEmpDeptTemp", param);	
//		}
//		
//		if(EmpDeptMulti){
//			commonSql.delete("EmpManage.deleteEmpDeptMultiTemp", param);	
//		}
//		
//		if(UserAuth){
//			commonSql.delete("EmpManage.DeleteUserAuthTemp", param);	
//		}		
//		
//		if(EmpComp){
//			commonSql.delete("EmpManage.DeleteEmpComp", param);
//		}
//	}

	@Override
	public Map<String, Object> initOrgchart(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();
		
		String firstYn = params.get("firstYn")+"";
		/** 최초 동기화시 초기화 */
		if (firstYn.equals("Y")) {
			/** 사업장, 부서, 사원정보 삭제 */
			erpOrgchartDAO.deleteOrgchart(params);
		}
		
		result.put("resultCode", "0");
		result.put("moreYn", "N");
		
		return result;
	}

	@Override
	public Map<String, Object> setEmpComp(Map<String, Object> params) {

		Map<String, Object> result = new HashMap<>();

		//근태사용우무 커스텀처리
		if(!BizboxAProperties.getCustomProperty( "BizboxA.erpSyncCustCheckWorkYn" ).equals( "99" )) {
			params.put("erpSyncCustCheckWorkYn", BizboxAProperties.getCustomProperty( "BizboxA.erpSyncCustCheckWorkYn" ));
		}
		
		// 신규 입사자 처리
		erpOrgchartDAO.insertEmpComp(params);
		
		// t_co_emp_comp 보정처리(재직구분, 사용여부등 )
		erpOrgchartDAO.updateEmpCompInfo(params);
		
		//근택적용유무 보정처리 (사용인 회사 제외후 나머지 겸직회사 미사용처리)
		List<Map<String, Object>> empSyncList = erpOrgchartDAO.selectEmpSyncList(params);
		for(Map<String, Object> mp : empSyncList) {
			if(mp.get("checkWorkYn") != null && !mp.get("checkWorkYn").equals("")) {
				if(mp.get("checkWorkYn") != null && mp.get("checkWorkYn").equals("Y")){
					commonSql.update("OrgAdapterManage.setEmpCompCheckWorkYn", mp);	
				}
				commonSql.update("ErpOrgchartDAO.updateEmpCompCheckWorkYn", mp);
			}
		}

		result.put("resultCode", "0");
		result.put("moreYn", "N");

		return result;
	}

	@Override
	public void setErpSync(Map<String, Object> params) {
		erpOrgchartDAO.insertErpSync(params);
	}
	@Override
	public void updateErp(Map<String, Object> params) {
		
		erpOrgchartDAO.updateErp(params);
		
	}

	@Override
	public void setCompDutyPosition(Map<String, Object> params) {
		List<Map<String, Object>> dutyList = (List<Map<String, Object>>) params.get("dutyList");
		List<Map<String, Object>> positionList = (List<Map<String, Object>>) params.get("positionList");
		ErpDataConverter convertor = ErpDataConvertorCreator.newInstance(params);
		if (dutyList != null) {
			for(int i = 0 ; i <dutyList.size(); i++) {
				Map<String,Object> map = dutyList.get(i);
				map.put("dpType", "DUTY");
				map.put("orderNum", i);
				erpOrgchartDAO.insertCompDutyPosition(convertor.getCompDutyPosition(map, params));
				erpOrgchartDAO.insertCompDutyPositionMulti(convertor.getCompDutyPositionMulti(map, params));
			}
		}
		if (positionList != null) {
			for(int i = 0 ; i <positionList.size(); i++) {
				Map<String,Object> map = positionList.get(i);
				map.put("dpType", "POSITION");
				map.put("orderNum", i);
				erpOrgchartDAO.insertCompDutyPosition(convertor.getCompDutyPosition(map, params));
				erpOrgchartDAO.insertCompDutyPositionMulti(convertor.getCompDutyPositionMulti(map, params));
			}
		}
	}

	@Override
	public List<Map<String, Object>> selectSyncFailTmpEmpList(Map<String, Object> params) {
		return erpOrgchartDAO.selectSyncFailTmpEmpList(params);
	}

	@Override
	public List<Map<String, Object>> selectSyncSuccessTmpEmpList(Map<String, Object> params) {
		return erpOrgchartDAO.selectSyncSuccessTmpEmpList(params);
	}

	@Override
	public Map<String, Object> setDeptUpdate(Map<String, Object> params) {
		
		Map<String, Object> result = new HashMap<>();
		List<Map<String, Object>> erpDeptDeleteList = new ArrayList<Map<String, Object>>();
		result.put("resultCode", "0");
		
		result.put("moreYn", "N");
		
		// 미사용 주석처리(21.03.29)
//		if(params.get("erpType").equals("icube")) {
//			// icube일 때
//			ErpOrgchartDAO erpOrgchartDAO = (ErpOrgchartDAO)params.get("erpOrgchartDAO");
//			erpDeptDeleteList = erpOrgchartDAO.selectErpDeptDeleteList(params);
//		} else if(params.get("erpType").equals("iu")) {
//			// iu 일때
//			ErpOrgchartDAO erpOrgchartDAO = (ErpOrgchartDAO)params.get("erpOrgchartDAO");
//			erpDeptDeleteList = erpOrgchartDAO.selectErpDeptDeleteList(params);
//		}
//		
//		if(erpDeptDeleteList != null) {
//			if(erpDeptDeleteList.size() > 0) {
//				for(Map<String, Object> temp : erpDeptDeleteList) {
//					Map<String, Object> deleteDept = new HashMap<String, Object>();
//					deleteDept.put("deptSeq", temp.get("deleteDeptSeq"));
//					deleteDept.put("compSeq", params.get("compSeq"));
//					
//					erpOrgchartDAO.deleteErpDeptSync(deleteDept);
//				}
//			}
//		}
		
		
		erpOrgchartDAO.updateDeptList(params);
		return result;
	}
	
	@Override
	public Map<String, Object> setDeptInfoUpdate(Map<String, Object> params) {
		
		Map<String, Object> result = new HashMap<>();
		
		result.put("resultCode", "0");
		
		result.put("moreYn", "N");
		erpOrgchartDAO.updateDeptInfo(params); 
		
		
		return result;
	}
	

	@Override
	public Map<String, Object> setEmpUpdate(Map<String, Object> params) {
		logger.debug("setEmpUpdate start");
		
		Map<String, Object> result = new HashMap<>();
		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
		String weddingDayReSetList = "";

		PaginationInfo paginationInfo = new PaginationInfo();
		int page = EgovStringUtil.zeroConvert(params.get("page"));
		int totalCount = EgovStringUtil.zeroConvert(params.get("totalCount"));

		paginationInfo.setCurrentPageNo(page);
		paginationInfo.setPageSize(10);
		paginationInfo.setRecordCountPerPage(10); 
		paginationInfo.setTotalRecordCount(totalCount);

		String eaType = params.get("eaType")+"";
		
		//사용자연동항목 옵션조회
		String syncItem = getCmmOptionValue((String)params.get("compSeq"), "cm1120");
		// 1:사진이미지, 2:성벌, 3:입사일자, 4:퇴사일자, 5:생년월이, 6:전화번호, 7:집주소, 8:사원명
		
		// 사원 정보 수정
		params.put("resultCode", "20");	
		Map<String, Object> empMap = null;
		
		if(params.get("autoYn") == null) {
			params.put("autoYn", "N");
		}
		
		if(params.get("autoYn").toString().equals("Y")) {
			empMap = erpOrgchartDAO.selectTmpEmpList(params);
		} else if(params.get("autoYn").toString().equals("N")){
			empMap = erpOrgchartDAO.selectTmpEmpList(params, paginationInfo);
		}
		 
		if(empMap != null) {
			List<Map<String,Object>> list = (List<Map<String, Object>>) empMap.get("list");
			if (list != null && list.size() > 0) {
				for(Map<String,Object> map : list) {
					try {					
						map.put("firstYn", params.get("firstYn"));
						EmpVO empVO = erpOrgchartDAO.selectTmpEmp(map);
						
						logger.debug("empVO : " + empVO);
						
						boolean bool = false;
						if(empVO != null) {
							
							//사용자연동항목 옵션에 따른 사용자정보 null처리
							// 1:사진이미지, 2:성벌, 3:입사일자, 4:퇴사일자, 5:생년월이, 6:전화번호, 7:집주소
							if(syncItem.indexOf("1") == -1) {
								empVO.setPicFileId(null);
							}
							if(syncItem.indexOf("2") == -1) {
								empVO.setGenderCode(null);
							}
							if(syncItem.indexOf("3") == -1) {
								empVO.setJoinDay(null);
							}
							if(syncItem.indexOf("4") == -1) {
								empVO.setResignDay(null);
							}
							if(syncItem.indexOf("5") == -1) {
								empVO.setBday(null);
							}
							if(syncItem.indexOf("6") == -1) {
								empVO.setMobileTelNum(null);
								empVO.setHomeTelNum(null);
							}
							if(syncItem.indexOf("7") == -1) {
								empVO.setZipCode(null);
							}
							
							//비동기항목 null처리
							empVO.setNativeLangCode(null);
							empVO.setPasswdStatusCode(null);
							empVO.setSignFileId(null);
							empVO.setApprPasswd(null);		
							empVO.setLoginPasswd(null);		
							empVO.setPayPasswd(null);
							empVO.setEmailAddr(null);
							empVO.setMessengerUseYn(null);
							empVO.setMobileUseYn(null);
							empVO.setCheckWorkYn(null);
							empVO.setUseYn(null);
							
							
							//주회사여부체크
							Map<String, Object> mp = new HashMap<String, Object>();
							mp.put("empSeq", map.get("empSeq"));
							mp.put("compSeq", params.get("compSeq"));
							mp.put("groupSeq", empVO.getGroupSeq());
							Map<String, Object> mainCompYnInfo = (Map<String, Object>) commonSql.select("ErpOrgchartDAO.selectMainCompYnInfo",mp);
							
							if(mainCompYnInfo.get("mainCompYnCnt").toString().equals("0")) {
								empVO.setMainCompSeq(mainCompYnInfo.get("mainCompSeq").toString());
								empVO.setJoinDay(null);
							}
	
							//로그인아이디는 업데이트제외함
							String loginId = empVO.getLoginId();
							empVO.setLoginId(null);
							bool = OrgChartSupport.getIOrgEditService().UpdateEmp(empVO);
							empVO.setLoginId(loginId);
							logger.debug("UpdateEmp bool : " + bool);
							if(bool) {
								
								if(empVO.getWeddingDay() == null) {
									weddingDayReSetList += "," + empVO.getEmpSeq();
								}
								
								map.put("langCode", "kr");
								EmpMultiVO empMultiVO = erpOrgchartDAO.selectTmpEmpMulti(map);								
								logger.debug("empMultiVO : " + empMultiVO);
								if (empMultiVO != null) {
									empMultiVO.setUseYn("Y");	//다국어 사용유무 기본값 Y로 설정
									
									//사용자연동항목 옵션에 따른 사용자정보 null처리
									//7:집
									if(syncItem.indexOf("7") == -1) {
										empMultiVO.setAddr(null);
										empMultiVO.setDetailAddr(null);
									}
									//8:사원명
									if(syncItem.indexOf("8") == -1) {
										empMultiVO.setEmpName(null);
									}
									
									bool = OrgChartSupport.getIOrgEditService().UpdateEmpMulti(empMultiVO);
									if(!bool) {
										bool = OrgChartSupport.getIOrgEditService().InsertEmpMulti(empMultiVO);
									}
									logger.debug("InsertEmpMulti bool : " + bool);
								}
								
								map.put("langCode", "en");
								empMultiVO = erpOrgchartDAO.selectTmpEmpMulti(map);								
								logger.debug("empMultiVO : " + empMultiVO);
								if (empMultiVO != null) {
									empMultiVO.setUseYn("Y");	//다국어 사용유무 기본값 Y로 설정
									
									//사용자연동항목 옵션에 따른 사용자정보 null처리
									//7:집
									if(syncItem.indexOf("7") == -1) {
										empMultiVO.setAddr(null);
										empMultiVO.setDetailAddr(null);
									}
									//8:사원명
									if(syncItem.indexOf("8") == -1) {
										empMultiVO.setEmpName(null);
									}
									
									bool = OrgChartSupport.getIOrgEditService().UpdateEmpMulti(empMultiVO);
									if(!bool) {
										bool = OrgChartSupport.getIOrgEditService().InsertEmpMulti(empMultiVO);
									}
									logger.debug("InsertEmpMulti bool : " + bool);
								}
							}
						}
						
						EmpDeptVO empDeptVO = erpOrgchartDAO.selectTmpEmpDept(map);
						//비동기항목 null처리
						empDeptVO.setTelNum(null);
						empDeptVO.setFaxNum(null);
						empDeptVO.setZipCode(null);
						empDeptVO.setOrderNum("0");
						
						logger.debug("empDeptVO : " + empDeptVO);
						
						EmpDeptMultiVO empDeptMultiVO = erpOrgchartDAO.selectTmpEmpDeptMulti(map);

						//사용자연동항목 옵션에 따른 사용자정보 null처리
						//7:집
						if(syncItem.indexOf("7") == -1) {
							empDeptMultiVO.setAddr(null);
							empDeptMultiVO.setDetailAddr(null);
						}
						
						logger.debug("empDeptMultiVO : " + empDeptMultiVO);
						
						map.put("compSeq", params.get("compSeq"));
						Map<String,Object> empDeptInfo = erpOrgchartDAO.selectEmpDeptInfo(map);
						logger.debug("empDeptInfo : " + empDeptInfo);
						
						// 사원정보 업데이트
						if (empDeptInfo == null) {	// 부서 변경된 경우 null
							// ERP에서 부서 정보 변경해서 그룹웨어에 업데이트 진행시
							// 영리 결재의 경우 사용자로 체크하기 때문에 결재 진행하는데 문제가 없습니다.
							logger.debug("eaType : " + eaType);
	
							Map<String, Object> tmpEmpDeptInfo = erpOrgchartDAO.selectTmpEmpDeptInfo(map); 
							// 부서변경 시작
							
							logger.debug("tmpEmpDeptInfo : " + tmpEmpDeptInfo);
							
							if (tmpEmpDeptInfo != null) {
								deleteList.add(tmpEmpDeptInfo);
//								Map<String, Object> deleteParam = new HashMap<String, Object>();
//								deleteParam.put("empSeq", map.get("empSeq"));
//								deleteParam.put("oldDeptSeq", tmpEmpDeptInfo.get("oldDeptSeq"));
//								
//								erpOrgchartDAO.deleteEmpDeptForChange(deleteParam);
								
								Map<String, Object> authParam = new HashMap<String, Object>();
								
								authParam.put("compSeq", empDeptVO.getCompSeq());
								authParam.put("deptSeq", empDeptVO.getDeptSeq());
								authParam.put("empSeq", empDeptVO.getEmpSeq());
								authParam.put("targetOldDeptSeq", tmpEmpDeptInfo.get("oldDeptSeq"));
								
								commonSql.update("CompManage.updateEmpAuthMainDept", authParam);	
								
								logger.debug("empDeptVO : " + empDeptVO);
								bool = OrgChartSupport.getIOrgEditService().InsertEmpDept(empDeptVO);
								logger.debug("InsertEmpDept bool : " + bool);
								bool = OrgChartSupport.getIOrgEditService().InsertEmpDeptMulti(empDeptMultiVO);
								logger.debug("InsertEmpDeptMulti bool : " + bool);
								
							} else {
								logger.debug("empDeptInfo is null..error..");
							}
							
							
						} else {
							
							empDeptVO.setOrgchartDisplayYn(null);
							empDeptVO.setMessengerDisplayYn(null);
							empDeptVO.setUseYn(null);
							
							bool = OrgChartSupport.getIOrgEditService().UpdateEmpDept(empDeptVO);
							logger.debug("UpdateEmpDept bool : " + bool);
							bool = OrgChartSupport.getIOrgEditService().UpdateEmpDeptMulti(empDeptMultiVO);
							logger.debug("UpdateEmpDeptMulti bool : " + bool);
						}
						
						ErpOrgchartDAO erpOrgchartDAO = (ErpOrgchartDAO)params.get("erpOrgchartDAO");	
						params.put("erpEmpSeq", map.get("erpEmpSeq"));
						params.put("gwUpdateTime", map.get("gwUpdateTime"));
						erpOrgchartDAO.updateErpEmpGwUpdateDate(params);					
					}catch(Exception e) {
						Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncServiceImpl.setEmpUpdate Error");
						CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					}
					
				}
				

				
				result.put("resultCode", "0");
				if (paginationInfo.getTotalPageCount() == paginationInfo.getCurrentPageNo()) {
					result.put("moreYn", "N");
				} else {
					result.put("moreYn", "Y");
				}
			} else {
				result.put("resultCode", "0");
				result.put("moreYn", "N");
			}
			
		} else {
			result.put("resultCode", "0");
			result.put("moreYn", "N");
			
		}
		
		if(deleteList.size() > 0) {
			result.put("deleteList", deleteList);
		}
		
		if(weddingDayReSetList.length() > 0) {
			weddingDayReSetList = weddingDayReSetList.substring(1);
			result.put("weddingDayReSetList", weddingDayReSetList);
		}
		
		logger.debug("result : " + result);
		logger.debug("setEmpUpdate end");
		
		return result;
	}
	
	@Override
	public void deleteEmpDept(List<Map<String, Object>> params) {

		for(Map<String, Object> temp : params) {
			try {
			Map<String, Object> deleteParam = new HashMap<String, Object>();
			deleteParam.put("empSeq", temp.get("empSeq"));
			deleteParam.put("oldDeptSeq", temp.get("oldDeptSeq"));
			deleteParam.put("newDeptSeq", temp.get("newDeptSeq"));
			deleteParam.put("compSeq", temp.get("compSeq"));
			
			erpOrgchartDAO.updateEmpComp(deleteParam);
			erpOrgchartDAO.deleteEmpDeptForChange(deleteParam);
			
//			commonSql.delete("EmpDeptManage.deleteEmpDeptAuthInit", deleteParam);
			}catch(Exception e) {
				Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncServiceImpl.deleteEmpDept Error");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	/* 커스텀 ERP 연동 */
	public void setCustomData(Map<String, Object> paramMap) {
		
		try{
			String custom = BizboxAProperties.getCustomProperty("BizboxA.Cust.CustErpOrg");
			
			if(!custom.equals("99")) {
				
				ErpOrgchartDAO erpOrgchartDao = null;
				Map<String,Object> dbInfo = getErpDbInfo(paramMap);
				if (dbInfo != null) {
					paramMap.put("erpCompSeq", dbInfo.get("erpCompSeq"));
					paramMap.put("dbUrl", dbInfo.get("url"));
					paramMap.put("erpType", dbInfo.get("erpType"));
				}
				
				
				erpOrgchartDao =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				
				Map<String, Object> customParam = new HashMap<String, Object>();
				customParam.put("cdCompany", dbInfo.get("erpSeq"));
				customParam.put("startSyncTime", paramMap.get("startSyncTime"));
				customParam.put("endSyncTime", paramMap.get("endSyncTime"));
				List<Map<String, Object>> customData = (List<Map<String, Object>>)erpOrgchartDao.selectErpCustom(customParam);
				
				String syncSeq = paramMap.get("syncSeq")+"";
				
				for(Map<String, Object> temp : customData) {
					if(paramMap.get("loginId").toString().equals(temp.get("loginId"))){
						temp.put("empSeq", paramMap.get("gwEmpSeq"));
						temp.put("syncSeq", syncSeq);
						temp.put("erpNum", temp.get("erpNum"));
						temp.put("kicpaNum", temp.get("customNum"));
						temp.put("emailId", temp.get("loginId"));
						
						erpOrgchartDAO.insertCustomData(temp);
					}
				}
			}
			
		}catch(Exception e){
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}
	
	/* ERP 조직도 스케줄러 저장 */
	public void insertErpSyncAutoList(Map<String, Object> params) {
		logger.info("insertErpSyncAutoList start..");
		// {day=mon, time=0, selectOption=everyWeek, compSeq=ICUBETEST, groupSeq=demo}
		String selectOptionType = params.get("selectOption").toString();
		String time = "";
		Map<String, Object> autoParam = new HashMap<String, Object>();
		
		/*
		 * 자동 동기화 스케줄 설정
		 * 설정값 - scheduleType 0:사용안함, 1: 매일, 2: 매주, 3: 매월, 4: 지정한 시간
		 * */
		if(selectOptionType.equals("noUse")) {							// 사용안함
			autoParam.put("scheduleType", "0");
		} else if(selectOptionType.equals("everyDay")) {					// 매일
			autoParam.put("scheduleType", "1");
		} else if(selectOptionType.equals("everyWeek")) {				// 매주
			autoParam.put("scheduleType", "2");
			autoParam.put("scheduleWeek", params.get("week").toString());	// 요일
		} else if(selectOptionType.equals("everyMonth")) {				// 매달
			autoParam.put("scheduleType", "3");
			autoParam.put("scheduleDay", params.get("day").toString());
		} else if(selectOptionType.equals("specialDay")) {
			autoParam.put("scheduleType", "4");
			autoParam.put("specialDay", params.get("date").toString());
		} else if(selectOptionType.equals("repeatInput")) {
			autoParam.put("scheduleType", "5");
			autoParam.put("repeatType", params.get("repeatType").toString());
			autoParam.put("repeatValue", params.get("repeatValue").toString());
		} 

		/*
		 * 시간데이터 만들기
		 * */
		time = params.get("time").toString();
		
		autoParam.put("scheduleTime", time);
		autoParam.put("compSeq", params.get("compSeq").toString());
		autoParam.put("empSeq", params.get("empSeq").toString());
		autoParam.put("groupSeq", params.get("groupSeq").toString());
		
		erpOrgchartDAO.insertErpSyncAutoList(autoParam);
	}
	
	/* ERP 조직도 자동 동기화 설정 값 가져오기 */
	public List<Map<String, Object>> selectErpSyncAutoList(Map<String, Object> params) {

		logger.info("selectErpSyncAutoList start..");
		
		List<Map<String, Object>> erpSycnAutoList = erpOrgchartDAO.selectErpSyncAutoList(params);
		
		return erpSycnAutoList;
	}
	
	/* ERP 조직도 자동 동기화 셋팅값 수정 */
	public void updateErpSyncAutoList(Map<String, Object> params) {
		logger.info("updateErpSyncAutoList start..");
		
		String selectOptionType = params.get("selectOption").toString();
		String time = "";
		Map<String, Object> autoParam = new HashMap<String, Object>();
		
		/*
		 * 자동 동기화 스케줄 설정
		 * 설정값 - scheduleType 0:사용안함, 1: 매일, 2: 매주, 3: 매월, 4: 지정한 시간
		 * */
		if(selectOptionType.equals("noUse")) {							// 사용안함
			autoParam.put("scheduleType", "0");
		} else if(selectOptionType.equals("everyDay")) {					// 매일
			autoParam.put("scheduleType", "1");
		} else if(selectOptionType.equals("everyWeek")) {				// 매주
			autoParam.put("scheduleType", "2");
			autoParam.put("scheduleWeek", params.get("week").toString());	// 요일
		} else if(selectOptionType.equals("everyMonth")) {				// 매달
			autoParam.put("scheduleType", "3");
			autoParam.put("scheduleDay", params.get("day").toString());
		} else if(selectOptionType.equals("specialDay")) {
			autoParam.put("scheduleType", "4");
			autoParam.put("specialDay", params.get("date").toString());
		} else if(selectOptionType.equals("repeatInput")) {
			autoParam.put("scheduleType", "5");
			autoParam.put("repeatType", params.get("repeatType").toString());
			autoParam.put("repeatValue", params.get("repeatValue").toString());
		} 
		
		/*
		 * 시간데이터 만들기
		 * */
		time = params.get("time") == null ? "" : params.get("time").toString();
		
		autoParam.put("scheduleTime", time);
		autoParam.put("compSeq", params.get("compSeq").toString());
		autoParam.put("empSeq", params.get("empSeq").toString());
		autoParam.put("groupSeq", params.get("groupSeq").toString());
		
		erpOrgchartDAO.updateErpSyncAutoList(autoParam);
	}
	
	/*
	 * ERP 조직도 자동동기화 로직
	 * */
	public List<Map<String, Object>> pollingOrgSyncAuto(String groupSeq) throws Exception {
		
		
		/* ERP 조직도 자동동기화 사용여부 확인 */
		List<Map<String, Object>> erpSyncAutoUseCompList = new ArrayList<Map<String, Object>>();
		
		erpSyncAutoUseCompList = erpOrgchartDAO.selectErpSyncAutoUseCompList(groupSeq);
		
		/* 동기화 결과 값 변수 */
		Map<String, Object> result = null;
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		//boolean result = false;
		
		if(erpSyncAutoUseCompList.size() > 0) {	// ERP 자동 동기화 사용중
			try{
				logger.info("serverTimeCheck....");
				/* 서버시간 가져오기 */
				Calendar cal = Calendar.getInstance();
				
				int year = cal.get(Calendar.YEAR);
				int mon = cal.get(Calendar.MONTH) + 1;
				int day = cal.get(Calendar.DAY_OF_MONTH);
				int hour = cal.get(Calendar.HOUR_OF_DAY);
				int min = cal.get(Calendar.MINUTE);
				
				String yyyymmddhhmm = year + (mon < 10 ? "0" + Integer.toString(mon) : Integer.toString(mon))
										+ (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day))
										+ (hour < 10 ? "0" + Integer.toString(hour) : Integer.toString(hour))
										+ (min < 10 ? "0" + Integer.toString(min) : Integer.toString(min));
				
				String serverTime = (hour < 10 ? "0" + Integer.toString(hour) : Integer.toString(hour))
						+ (min < 10 ? "0" + Integer.toString(min) : Integer.toString(min));
				
				/* 
				 * 요일 상수 처리
				 * Sun:1 ~ Sat:7
				 *  */
				final String[] week = { "sun", "mon", "tue", "wed", "thu", "fri", "sat" };

				
				/* ERP 조직도 연동 중인 회사 가져오기 */
				for(Map<String, Object> temp : erpSyncAutoUseCompList) {					
					
					//조직도 동기화 완료전인 상태(orgAutoSyncStatus != C)인 경우 스킵
					//동기화 시간이 1시간이상인 경우 조직도 연동시 오류발생으로 판단하여 상태값 C로 업데이트처리
					if(temp.get("orgAutoSyncStatus") != null && !temp.get("orgAutoSyncStatus").toString().equals("C")) {
	
						String erpSyncTime = "";
						
						if(temp.get( "autoOrgSyncDate" ) == null) {
							erpSyncTime = "1900-01-01";
						} else {
							erpSyncTime = temp.get( "autoOrgSyncDate" ).toString();
						}
						
						SimpleDateFormat f = new SimpleDateFormat("yyyyMMddHHmm");
						Date d1 = f.parse(yyyymmddhhmm);
						Date d2 = f.parse(erpSyncTime);
						long diff = d1.getTime() - d2.getTime();
						long diffmin = (diff / 1000) / 60;
						
						if(diffmin > 60) {
							//조직도 자동 동기화 상태값 진행중으로 변경
							Map<String, Object> mp = new HashMap<String, Object>();
							mp.put("groupSeq", groupSeq);
							mp.put("compSeq", temp.get("compSeq"));
							mp.put("orgAutoSyncStatus", "C");
							commonSql.update("ErpOrgchartDAO.updateOrgAutoSyncStatus", mp);
						}else {
							continue;
						}
					}
					
					String getTime = temp.get("scheduleTime").toString();
					Map<String, Object> params = new HashMap<String, Object>();
					result = new HashMap<String, Object>();
					
					/* 기본 파라미터 제공 */
					params.put("groupSeq", temp.get("groupSeq").toString());
					params.put("compSeq", temp.get("compSeq").toString());
					params.put("editorSeq", temp.get("modifyBy") == null ? temp.get("createBy") : temp.get("modifyBy"));
					params.put("eaType", temp.get("eaType").toString());
					params.put("achrGbn", "hr");
					params.put("autoSyncTime", "Y");
					
					/* 자동동기화 시간 값 비교 */
					if(temp.get("scheduleType").toString().equals("1")) {			// 매일
						logger.info("everyTimeCheck....");
						
						if(serverTime.equals(getTime)) {
							result.put("result", "success");
							result.put("params", params);
						} else {
							/* 동기화 시간 체크 */
							Map<String, Object> erpSyncInfo = new HashMap<String, Object>();
							
							erpSyncInfo = (Map<String, Object>) commonSql.select("ErpManageDAO.selectErpInfo", params);
							
							String erpSyncTime = "";
							
							if(erpSyncInfo.get( "orgSyncDate" ) == null) {
								erpSyncTime = "1900-01-01";
							} else {
								erpSyncTime = erpSyncInfo.get( "autoOrgSyncDate" ).toString();
							}
							
							String reserveTime = Integer.toString(year) + 
									(mon < 10 ? "0" + Integer.toString(mon) : Integer.toString(mon)) +
									(day < 10 ? "0" + Integer.toString(day) : Integer.toString(day)) +
									getTime;
							
							/*
							String realSerTime = Integer.toString(year) + 
									(mon < 10 ? "0" + Integer.toString(mon) : Integer.toString(mon)) +
									(day < 10 ? "0" + Integer.toString(day) : Integer.toString(day)) +
									(hour < 10 ? "0" + Integer.toString(hour) : Integer.toString(hour)) + 
									(min < 10 ? "0" + Integer.toString(min) : Integer.toString(min));
							*/
							
							
							if(Double.parseDouble( erpSyncTime ) < Double.parseDouble( reserveTime )) {
								if( Integer.parseInt( reserveTime.substring( 0, 8 ) ) - Integer.parseInt( erpSyncTime.substring( 0, 8 )) > 1) {
									result.put("result", "success");
									result.put("params", params);
								} else if(Integer.parseInt( reserveTime.substring( 0, 8 ) ) - Integer.parseInt( erpSyncTime.substring( 0, 8 )) == 1) {
									erpSyncTime = erpSyncTime.replaceAll( erpSyncTime.substring( 0, 8 ),  Integer.toString(year) + (mon < 10 ? "0" + Integer.toString(mon) : Integer.toString(mon)) + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day)));
									if(Double.parseDouble( erpSyncTime ) < Double.parseDouble( reserveTime )) {
										result.put("result", "success");
										result.put("params", params);
									} else {
										result.put("result", "error");
										result.put("params", params);
									}
									
								} 
							} else {
								result.put("result", "error");
								result.put("params", params);
							}
						}
						
						//return true;
						//result = erpOrgchartEmpAutoTempStart(params);
					} else if(temp.get("scheduleType").toString().equals("2")) {	// 매주
						logger.info("everyWeekCheck....");
						
						String serverWeek = week[cal.get(Calendar.DAY_OF_WEEK) - 1];
						String getWeek = temp.get("scheduleWeek").toString();
						
						if(serverWeek.equals(getWeek) && serverTime.equals(getTime)) {
							/* ERP 자동 동기화 호출 */
							//result = erpOrgchartEmpAutoTempStart(params);
							result.put("result", "success");
							result.put("params", params);
						} else {
							result.put("result", "error");
							result.put("params", params);
						}
					} else if(temp.get("scheduleType").toString().equals("3")) {	// 매달
						logger.info("everyMonthCheck....");
						
						if(day == Integer.parseInt(temp.get("scheduleDay").toString()) && serverTime.equals(getTime)) {
							//result = erpOrgchartEmpAutoTempStart(params);
							//return true;
							result.put("result", "success");
							result.put("params", params);
						} else {
							result.put("result", "error");
							result.put("params", params);
							
						}
					} else if(temp.get("scheduleType").toString().equals("4")) {	// 특정일
						logger.info("specialDayCheck....");
						
						String getDate = temp.get("specialDay").toString();
						String serverSpecialDay = Integer.toString(year)
								+ "-" + (mon < 10 ? "0" + Integer.toString(mon) : Integer.toString(mon))
								+ "-" + (day < 10 ? "0" + Integer.toString(day) : Integer.toString(day));
						
						/* 특정 시간 비교 */
						if(serverSpecialDay.equals(getDate) && serverTime.equals(getTime)) {
							
							result.put("result", "success");
							result.put("params", params);
						} else {
							//result.put("result", "error");
							//result.put("params", params);
							
							
							result.put("result", "error");
							result.put("params", params);
						}
					}else if(temp.get("scheduleType").toString().equals("5")) {	// 반복
						
						String repeatType = temp.get("repeatType").toString();
						String repeatValue = temp.get("repeatValue").toString();
						
						long repeatTime = 0l;
						
						if(repeatType.equals("h")) {
							repeatTime = Integer.parseInt(repeatValue) * 60;
						}
						else {
							repeatTime = Integer.parseInt(repeatValue);
						}
						
						/* 동기화 시간 체크 */
						Map<String, Object> erpSyncInfo = new HashMap<String, Object>();
						
						erpSyncInfo = (Map<String, Object>) commonSql.select("ErpManageDAO.selectErpInfo", params);
						
						String erpSyncTime = "";
						
						if(erpSyncInfo.get( "orgSyncDate" ) == null) {
							erpSyncTime = "1900-01-01";
						} else {
							erpSyncTime = erpSyncInfo.get( "autoOrgSyncDate" ).toString();
						}
						
						SimpleDateFormat f = new SimpleDateFormat("yyyyMMddHHmm");
						Date d1 = f.parse(yyyymmddhhmm);
						Date d2 = f.parse(erpSyncTime);
						long diff = d1.getTime() - d2.getTime();
						long diffmin = (diff / 1000) / 60;
						
						if(diffmin >= repeatTime) {
							result.put("result", "success");
							result.put("params", params);
						}else {
							result.put("result", "error");
							result.put("params", params);
						}
						
					}else {
						result.put("result", "error");
						result.put("params", params);
					}
					resultList.add(result);
				}
			} catch(Exception E) {
				logger.debug(E.getMessage());
				
			}
		} else {		// ERP 자동 동기화 미사용중 
			logger.info("erpSyncAutoNoUse......");
			result = new HashMap<String, Object>();
			result.put("result", "notUseAutoSync");
			resultList.add(result);
			return resultList;
		}
		return resultList;
	}
	
	public Map<String, Object> erpOrgchartEmpAutoTempStart(Map<String, Object> params) throws Exception{
		logger.info("erpOrgchartSync Start....");
		
		try{
			
			String groupSeq = params.get("groupSeq")+"";
			String compSeq = params.get("compSeq")+"";
			if(!EgovStringUtil.isEmpty(groupSeq) && !EgovStringUtil.isEmpty(compSeq)) {
				/* 부서(사업장) 임시테이블 생성 */
				params.put("value", "erpSyncSeq");
				String erpSyncSeq = sequenceService.getSequence(params);
				params.put("syncSeq", erpSyncSeq);
				params.put("langCode", "kr");
				params.put("syncStatus", "R"); // 준비
				params.put("autoYn", "Y"); //
				params.put("erpSyncDate", params.get("endSyncTime")); // 
				
				
				params.put("achrGbn", "hr");
				Map<String,Object> dbInfo = getErpDbInfo(params);
					
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				params.put("cdCompany", dbInfo.get("erpCompSeq"));
				params.put("erpType", dbInfo.get("erpType"));
				params.put("erpCompSeq", dbInfo.get("erpCompSeq"));
				params.put("dbUrl", dbInfo.get("url"));
				
			
				setErpSync(params);
			
				List<Map<String,Object>> orgList = new ArrayList<>();
				
				List<Map<String,Object>> erpBizList = erpOrgchartDAO.selectErpBizList(params);
				logger.debug("erpBizList : " + erpBizList);
				if(erpBizList != null) {
					orgList.addAll(erpBizList);
				}
	
				List<Map<String,Object>> erpDeptList = erpOrgchartDAO.selectErpDeptList(params);
				logger.debug("erpDeptList : " + erpDeptList);
				if(erpDeptList != null) {
					orgList.addAll(erpDeptList);
				}
				
				List<Map<String,Object>> erpDeptPathList = erpOrgchartDAO.selectErpDeptPathList(params);
				Map<String,Object> pathInfo = CollectionUtils.getListToMap(erpDeptPathList, "deptSeq");
				
				params.put("erpBizList", erpBizList);
				params.put("erpDeptList", erpDeptList);
				params.put("pathInfo", pathInfo);
	
				//List<Map<String,Object>> resultList = setTempdeptOrgchart(params);
				setTempdeptOrgchart(params);
				
				
				/* 사원정보 임시테이블 생성 */
				/** 동기화 시작 시간 조회 */
				String erpSyncTime = erpOrgchartDAO.selectErpCurrentTime();
				params.put("endSyncTime", erpSyncTime);	// 2016-11-25 08:40:44
	
				String orgSyncDate = dbInfo.get("orgSyncDate")+"";
				if (EgovStringUtil.isEmpty(orgSyncDate)) {
					orgSyncDate = "2000-01-01 00:00:00";
					params.put("firstYn", "Y");
				} else {
					params.put("firstYn", "N");
				} 
	
	
				params.put("startSyncTime", orgSyncDate);	// 동기화 마지막 일자
	
				
				/** ERP,그룹웨어 코드 맵핑 데이터 조회 
				 *  재직구분, 라이센스
				 * */
				List<Map<String,Object>> typeList = selectErpGwJobCodeList(params);
	
				params.put("typeList", typeList);
				
				/** ERP 사원 정보 리스트 조회 */
	
				
				PaginationInfo paginationInfo = new PaginationInfo();
				int page = EgovStringUtil.zeroConvert("0");
				
				paginationInfo.setCurrentPageNo(page);
				paginationInfo.setPageSize(100);
				paginationInfo.setRecordCountPerPage(10000); 
				
				Map<String,Object> erpEmpInfo = erpOrgchartDAO.selectErpEmpListOfPage(params, paginationInfo);
				
				logger.debug("erpEmpInfo : " + erpEmpInfo);
				
				@SuppressWarnings("unchecked")
				List<Map<String,Object>> empList = (List<Map<String,Object>>)erpEmpInfo.get("list");
				logger.debug("empList : " + empList);
				
				params.put("empList", empList);
				
				/** ERP 사원정보를 그룹웨어로 동기화시 신규 입사자 로그인 ID 생성 규칙 조회 */
				String optionValue = getCmmOptionValue(compSeq, "cm1102");
				
				if (optionValue != null && !optionValue.equals("0")) {
					params.put("loginIdType", optionValue); //1:erp 사원번호, 2: 이메일
				} else {
					params.put("loginIdType", "1");	// 설정 안되어 있을경우 erp 사원번호 기본값
				}
				
				//resultList = setTempEmp(params);
				setTempEmp(params);
				
	//			return params;
				//test(params, erpOrgchartDAO);
//				/* 데이터 삭제 */
//				params.put("syncStatus", "I"); // 준비
//				params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
//				setErpSync(params);	// 동기화 진행상황 저장
//				result = initOrgchart(params);
//				
//				/* 사업장 */
//				result = setBiz(params);
//				setErpSync(params);
//				
//				/* 부서정보 신규 등록 */
//				result = setDept(params);
//				setErpSync(params);
////				
//////				/* 부서정보 삭제처리(사용안함) */
//////				result = setDeptUpdate(params);
//////				setErpSync(params);
//////				
////				/* 사원정보 */
//////				erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
////				//params.put("eaType", loginVO.getEaType());
//////				params.put("erpOrgchartDAO", erpOrgchartDAO);
//				result = setEmp(params);
//				setErpSync(params);
////				
////				/* 사원정보수정 */
//////				erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
//////				//params.put("eaType", loginVO.getEaType());
//////				params.put("erpOrgchartDAO", erpOrgchartDAO);
//////				result = setEmpUpdate(params);
//////				setErpSync(params);
////				
//////				result = new HashMap<>();
//////				result.put("resultCode", "0");
//////				result.put("moreYn", "N");
//////				
//				result = new HashMap<>();
//				result.put("resultCode", "0");
//				result.put("moreYn", "N");
//////				
//////				/* 사원회사정보 */
//				result = setEmpComp(params);
//				params.put("syncStatus", "C");
//				params.put("orgSyncStatus", "C");
//				params.put("orgSyncDate", params.get("endSyncTime"));
//				
//				setErpSync(params);
//				
//				updateErp(params);
//				
////				erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
//				
//				params.put("timeType", "SS");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
//				params.put("time", "1");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
//				erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
//				
//				List<Map<String,Object>> successEmpList = selectSyncSuccessTmpEmpList(params);
//				
//				params.put("timeType", "MI");
//				params.put("time", "-60"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
//				if (successEmpList != null) {
//					for(Map<String,Object> map : successEmpList) {
//						params.put("erpEmpSeq", map.get("erpEmpSeq"));
//						params.put("erpCompSeq", map.get("erpCompSeq"));
//						erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
//					}
//				}
			}
		} catch(Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			logger.error("! [erpAutoSync] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		return null;
	}

	
	public Map<String, Object> test(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		
//		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
//		def.setName("default-transaction");
//		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
//		
//		TransactionStatus status = transactionManager.getTransaction(def);
//		
//		transactionManager.commit(status);
		
		//String groupSeq = params.get("groupSeq")+"";
		//String compSeq = params.get("compSeq")+"";
		
		params.put("achrGbn", "hr");
		Map<String,Object> dbInfo = getErpDbInfo(params);
			
		ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
		
//		/* 데이터 삭제 */
		params.put("syncStatus", "I"); // 준비
		params.put("syncDate", DateUtil.getToday("yyyy-MM-dd HH:mm:ss")); // 준비
		setErpSync(params);	// 동기화 진행상황 저장
		result = initOrgchart(params);
		
		/* 사업장 */
		result = setBiz(params);
		setErpSync(params);
		
		/* 부서정보 신규 등록 */
		result = setDept(params);
		setErpSync(params);
//		
////		/* 부서정보 삭제처리(사용안함) */
////		result = setDeptUpdate(params);
////		setErpSync(params);
////		
//		/* 사원정보 */
////		erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
//		//params.put("eaType", loginVO.getEaType());
////		params.put("erpOrgchartDAO", erpOrgchartDAO);
		result = setEmp(params);
		setErpSync(params);
//		
//		/* 사원정보수정 */
////		erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
////		//params.put("eaType", loginVO.getEaType());
////		params.put("erpOrgchartDAO", erpOrgchartDAO);
////		result = setEmpUpdate(params);
////		setErpSync(params);
//		
////		result = new HashMap<>();
////		result.put("resultCode", "0");
////		result.put("moreYn", "N");
////		
		result = new HashMap<>();
		result.put("resultCode", "0");
		result.put("moreYn", "N");
////		
////		/* 사원회사정보 */
		result = setEmpComp(params);
		params.put("syncStatus", "C");
		params.put("orgSyncStatus", "C");
		params.put("orgSyncDate", params.get("endSyncTime"));
		
		setErpSync(params);
		
		updateErp(params);
		
//		erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
		
		params.put("timeType", "SS");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
		params.put("time", "1");  // 실패한 데이터 동기화 미완료처리 위해 시간을 동기화시간보다 늦게 설정.
		erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
		
		List<Map<String,Object>> successEmpList = selectSyncSuccessTmpEmpList(params);
		
		params.put("timeType", "MI");
		params.put("time", "-1"); // 60초 전으로 동기화 완료처리. 다음번 동기화 대상이 되지 않음.
		if (successEmpList != null) {
			for(Map<String,Object> map : successEmpList) {
				params.put("erpEmpSeq", map.get("erpEmpSeq"));
				params.put("erpCompSeq", map.get("erpCompSeq"));
				erpOrgchartDAO.updateErpSyncEmpGwUpdateDate(params);
			}
		}
		
		return null;
	}
	
	@Override
	public Map<String, Object> setEmpResign(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		/** 부서 정보 입력 */
		//퇴사처리는 수동으로만 가능하도록 기획변경 되어 주석처리
//		erpOrgchartDAO.setEmpResign(params);
		
		result.put("resultCode", "0");
		result.put("moreYn", "N");
		
		return result;
	}
	
	public Map<String, Object> selectErpSyncResignParam(Map<String, Object> params) {
		Map<String, Object> resignParam = (Map<String, Object>) commonSql.select("EmpManage.selectUserInfo", params);
		
		return resignParam;
	}
	
	public Map<String, Object> getErpDbInfo(Map<String, Object> params) {
		@SuppressWarnings("unchecked")
		Map<String,Object> erpDbInfo = (Map<String, Object>) commonSql.select("ErpManageDAO.selectErpInfo", params);

		return erpDbInfo;
		
	}
	
	public String getCmmOptionValue(String compSeq, String option) {
		/** ERP 옵션 조회 */
		try {
			Map<String,Object> optionParams = new HashMap<>();
			optionParams.put("option", option);
			optionParams.put("compSeq", compSeq);
			Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue(optionParams);
			if (erpOptions != null && erpOptions.get("optionRealValue") != null) {
				return (String)erpOptions.get("optionRealValue");
			}
		}
		catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return null;
	}
	
	public boolean isConnected(Map<String, Object> params) {
		String dbUrl = (String)params.get("dbUrl");
		String validIp = "([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3})";
		Pattern p = Pattern.compile(validIp);
		Matcher m = p.matcher(dbUrl);
		m.find();
		String iuIp = m.group();
		String iuUrl = "http://" + iuIp;
	    try {
	    	URL url = new URL(iuUrl);
            HttpURLConnection urlc = (HttpURLConnection) url
                    .openConnection();
            urlc.setRequestProperty("Connection", "close");
            urlc.setConnectTimeout(1000); // Timeout 2 seconds.
            urlc.connect();

            if (urlc.getResponseCode() == 200) // Successful response.
            {
                return true;
            } else {
                return false;
            }
            
           
	    } catch (Exception e) {
	    	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    }
	    return false;
	}

	@Override
	public Map<String, Object> selectErpSyncCompDetailList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return erpOrgchartDAO.selectErpSyncCompDetailList(params, paginationInfo);
	}

	@Override
	public Map<String, Object> selectTmpCompList(Map<String, Object> params, PaginationInfo paginationInfo) {
		return erpOrgchartDAO.selectTmpCompList(params, paginationInfo);
	}

	@Override
	public List<Map<String, Object>> setTempComp(Map<String, Object> params) {
		List<Map<String,Object>> list = new ArrayList<>();
		List<Map<String,Object>> compList = (List<Map<String, Object>>) params.get("compList");
		
		//String erpType = (String)params.get("erpType");
		
		ErpDataConverter convertor = ErpDataConvertorCreator.newInstance(params);
		
		// 임시데이터 저장하기
		for(int i = 0; i < compList.size(); i++) {
			Map<String, Object> map = compList.get(i);
			map.put("orderNum", i);
			erpOrgchartDAO.insertTmpComp(convertor.getComp(map, params));
			erpOrgchartDAO.insertTmpCompMulti(convertor.getCompMulti(map, params));
			list.add(map);
		}
		
		return list;
	}

	@Override
	public Map<String, Object> setComp(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<>();

		LoginVO loginVO = (LoginVO) params.get("loginVO");

		Map<String,Object> dbInfo = (Map<String, Object>) params.get("dbInfo");
		
		logger.debug("dbInfo : " + dbInfo);

		/** 임시 저장 회사 조회 */
		List<Map<String,Object>> tempCompList = erpOrgchartDAO.selectTmpCompList(params);
		
		logger.debug("tempCompList : " + tempCompList);

		for (Map<String,Object> c : tempCompList) {
			
			logger.debug("c : " + c);
			
			Map<String,Object> tempCompMap = CollectionUtils.convertEgovMapToMap(c);
			
			logger.debug("tempCompMap : " + tempCompMap);

			String sType = null; // 신규 or 저장 타입(I:신규, U:업데이트)

			String resultCode = tempCompMap.get("resultCode")+"";
			if (resultCode.equals("0")) {	// 신규회사
				sType = "I";
			} else if (resultCode.equals("20")) {	// 수정
				sType = "U";
			} else {
				continue;
			}

			CompVO compVO = (CompVO) CollectionUtils.convertMapToObject(tempCompMap, new CompVO());

			CompMultiVO compMultiVO = (CompMultiVO) CollectionUtils.convertMapToObject(tempCompMap, new CompMultiVO());

			String emailDomain = null;
			String tempEmailDomain = compVO.getEmailDomain();
			
			try {

				if(sType.equals("U"))
				{
					/** 회사 정보 가져오기 */
					tempCompMap.put("blockUseYn", "N");
					Map<String,Object> compMap = compService.getComp(tempCompMap);

					if (compMap != null) {
						
						emailDomain = compMap.get("emailDomain") != null && compMap.get("emailDomain").toString().trim().equals("") ? compMap.get("emailDomain").toString() : null;
						
						//String lang = String.valueOf(compMap.get("nativeLangCode"));
						
						/*
						if (EgovStringUtil.isEmpty(lang)) {
						}
						 */

						compMultiVO.setLangCode(loginVO.getLangCode());
						tempCompMap.put("modifySeq", loginVO.getUniqId());
						compVO.setEditerSeq(loginVO.getUniqId());
						compMultiVO.setEditerSeq(loginVO.getUniqId()); 

						/** 회사기본정보 업데이트 */
						OrgChartSupport.getIOrgEditService().UpdateComp(compVO);												


						if(!EgovStringUtil.isEmpty(tempCompMap.get("compName")+"")){
							compMultiVO.setCompName(tempCompMap.get("compName")+"");
							compMultiVO.setLangCode("kr");
							tempCompMap.put("compName", tempCompMap.get("compName")+"");
							tempCompMap.put("langCode", "kr");
							OrgChartSupport.getIOrgEditService().UpdateCompMulti(compMultiVO);
						}
						
						
						/** 그룹 이메일 설정 */
						setCompEmailDomain(tempCompMap, tempEmailDomain, emailDomain);

						//						} 
						/** 회사부가정보 업데이트 */
						result.put("resultCode", "0");


					} else {
						result.put("resultCode", "1");
					}
				}

				//회사 신규 등록
				else if(sType.equals("I")){

					OrgChartSupport.getIOrgEditService().InsertComp(compVO);


					if(!EgovStringUtil.isEmpty(tempCompMap.get("compName")+"")){
						compMultiVO.setCompName(tempCompMap.get("compName")+"");
						compMultiVO.setLangCode("kr");
						OrgChartSupport.getIOrgEditService().InsertCompMulti(compMultiVO);
					}


					tempCompMap.put("empSeq", loginVO.getUniqId());

					//회사 마스터알림 기본값 셋팅					
					compService.setBaseAlarm(tempCompMap);

					// 회사 관리자 알림 기본값 셋팅
					compService.setBaseAlarmAdmin(tempCompMap);


					//메신저 api호출(기본날개메뉴 및 기초정보 셋팅					
					//String url = BizboxAProperties.getProperty("BizboxA.groupware.domin") +"/gw/msg/createMsgMenu";
					Map<String, Object> para = new HashMap<String, Object>();
					para.put("compSeq", compVO.getCompSeq());
					//APIResponse msgResult = msgService.setMsgMenu(para);
					msgService.setMsgMenu(para);

					//회사 신규 등록시 필요 기초데이터 셋팅(프로시저호출-p_baseDateSet)
					para.put("groupSeq", loginVO.getGroupSeq());
					para.put("empSeq", loginVO.getUniqId());
					compService.setBaseDateInfo(para);					

					result.put("resuleCode", "99");

					/** 신규 회사 등록인 경우 erp 연동 정보 등록하기(t_co_erp) */
					Map<String,Object> erpMap = new HashMap<>();
					erpMap.put("groupSeq", compVO.getGroupSeq());
					erpMap.put("compSeq", compVO.getCompSeq());
					erpMap.put("erpCompSeq", tempCompMap.get("erpCompSeq"));
					erpMap.put("achrGbn", "hr");
					erpMap.put("erpTypeCode", dbInfo.get("erpTypeCode"));
					erpMap.put("erpCompName", tempCompMap.get("erpCompName"));
					erpMap.put("databaseType", dbInfo.get("databaseType"));
					erpMap.put("Driver", dbInfo.get("driver"));
					erpMap.put("Url", dbInfo.get("url"));
					erpMap.put("UserID", dbInfo.get("userid"));
					erpMap.put("PassWord", dbInfo.get("password"));
					erpMap.put("empSeq", loginVO.getUniqId());
					erpMap.put("g20Yn", "N");


					compService.dbConnectInfoSave(erpMap);

					/** ERP 연동 사용 옵션 추가 */
					Map<String,Object> optionMap = new HashMap<>();
					optionMap.put("optionId", "cm1100");
					optionMap.put("coId", compVO.getCompSeq());
					optionMap.put("compSeq", compVO.getCompSeq());
					optionMap.put("optionValue", "1");	// 사용
					optionMap.put("empSeq", loginVO.getUniqId());
					commonOptionManageService.setOptionSave(optionMap);
					
					/** 그룹 이메일 설정 */
					setCompEmailDomain(tempCompMap, tempEmailDomain, emailDomain);

				}

			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				result.put("resuleCode", "-1");
			}

		}

		result.put("resultCode", "0");
		result.put("moreYn", "N");

		List<Map<String,Object>> compCntList = erpOrgchartDAO.selectTmpCompTotalCount(params);

		for(Map<String,Object> map : compCntList) {
			String resultCode = map.get("resultCode")+"";
			if (resultCode.equals("0")) { // 신규 등록
				result.put("compJoinTotalCount", map.get("resultCodeCnt"));
			}
			if (resultCode.equals("20")) { // 수정
				result.put("compModifyTotalCount", map.get("resultCodeCnt"));
			}
		}

		/** 전자결재 공통코드 리빌드 */
		EaOptionReBuild("eap");

		return result;
	}

	private void setCompEmailDomain(Map<String, Object> params, String tempEmailDomain, String emailDomain) {
		String regex = "[a-z0-9A-Z]*.[a-zA-Z.]*$";
		
		if (tempEmailDomain != null) {
			boolean bool = Pattern.matches(regex, tempEmailDomain);
			if (!bool) {
				logger.error("mail domain rex error!! : " + tempEmailDomain);
				return;
			}
		}
		
		Map<String,Object> requestMap = new HashMap<>();
		
		Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("EmpManage.selectGroupData", params);
		
		String mailServerUrl = (String)groupInfo.get("mailUrl");
		
		// 메일 설정 없음
		if (tempEmailDomain == null && emailDomain == null) {
			logger.info("mail domain info not..");
			return;
		} 
		// 메일설정 있었으나 삭제됨.
		// 메일설정이 삭제되면 기존 메일 계정들도 모두 삭제되므로 신중하게..처리해야됨. 추후 논의
		else if (tempEmailDomain == null && emailDomain != null) {
			logger.info("mail domain delete..");
		}
		// 메일설정 추가.
		else if (tempEmailDomain != null && emailDomain == null) {
			logger.info("mail domain create..");
			requestMap.put("domain ", tempEmailDomain);
			requestMap.put("groupSeq", params.get("groupSeq"));
			requestMap.put("compSeq", params.get("compSeq"));
			mailDomainMove.mailDomainCreate(mailServerUrl, requestMap);  // 메일도메인 설정 확인
			
		} 
		// 메일이 변경된 경우임..
		else if (!tempEmailDomain.equals(emailDomain)) {
			logger.info("mail domain move..");
			requestMap.put("domainName", emailDomain);
			requestMap.put("changeDomain", tempEmailDomain);
			requestMap.put("domainOld", tempEmailDomain);
			requestMap.put("groupSeq", params.get("groupSeq"));
			requestMap.put("compSeq", params.get("compSeq"));
			
			mailDomainMove.mailDomainMove(mailServerUrl, requestMap);
		} else {
			logger.info(tempEmailDomain + " = " + emailDomain);
		}
		
		
	}
	
	private void EaOptionReBuild(String eaType){
		try{
			String jsonParam =	  "{}";
			
			String apiUrl = BizboxAProperties.getProperty("BizboxA.groupware.domin") + "/" + eaType + "/cmm/system/OptionReBuild.do";			

			JSONObject jsonObject2 = JSONObject.fromObject(JSONSerializer.toJSON(jsonParam));
			HttpJsonUtil httpJson = new HttpJsonUtil();
			httpJson.execute("POST", apiUrl, jsonObject2);
		 }
		 catch (Exception e) {
			 CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		 }
	}

	@Override
	public void setErpCompSync(Map<String, Object> params) {
		erpOrgchartDAO.insertErpCompSync(params);
		
	}

	@Override
	public void setErpCompList(Map<String, Object> params) {
		erpOrgchartDAO.insertErpCompList(params);
	}

	@Override
	public Map<String, Object> getGerpDbInfo(Map<String, Object> params) {
		Map<String,Object> gerpDbInfo = new HashMap<>();

		gerpDbInfo.put("erpTypeCode", "GERP");
		gerpDbInfo.put("erpType", "gerp");
		gerpDbInfo.put("achrGbn", "hr");
		gerpDbInfo.put("compSyncUseYn", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Sync.compSyncUseYn"));
		gerpDbInfo.put("syncGroupSeq", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Sync.GroupSeq"));
		gerpDbInfo.put("databaseType", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Hr.Db.Type"));
		gerpDbInfo.put("driver", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Hr.Db.Driver"));
		gerpDbInfo.put("url", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Hr.Db.Url"));
		gerpDbInfo.put("userid", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Hr.Db.Userid"));
		gerpDbInfo.put("password", BizboxAProperties.getCustomProperty("BizboxA.Gerp.Hr.Db.Password"));

		// 마지막 동기화 시간 t_co_erp 테이블에서 group중 가장 최근 시간 조회
		@SuppressWarnings("unchecked")
		Map<String,Object> map = (Map<String, Object>) commonSql.select("ErpOrgchartDAO.selectLastErpCompSync", params);
		if (map != null && map.get("erpSyncDate") != null) {
			gerpDbInfo.put("erpSyncDate", map.get("erpSyncDate"));
		}

		return gerpDbInfo;

	}

	@Override
	public List<Map<String, Object>> getErpCompList(Map<String, Object> resultMap) {

		List<Map<String,Object>> list = erpOrgchartDAO.selectErpSyncCompList(resultMap);
		
		return list;
	}

	@Override
	public void insertAuthList(List<Map<String, Object>> params) {
		for(Map<String, Object> temp : params) {
			try {
				commonSql.delete("EmpDeptManage.insertBaseAuth", temp);
			}catch(Exception e) {
				Logger.getLogger( ErpOrgchartSyncServiceImpl.class ).error( "ErpOrgchartSyncServiceImpl.insertAuthList Error");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}

	public void updateLicenseValue(Map<String, Object> params) {
		erpOrgchartDAO.updateLicenseValue(params);
	}

	@Override
	public String erpSyncDutyPosiSaveProc(Map<String, Object> params) {
		String resultCode = "1";
		try{
			/** 직급 / 직책  데이터 가져오기 */
			params.put("achrGbn", "hr");
			params.put("langCode", "kr");
			Map<String,Object> dbInfo = getErpDbInfo(params);
			if(dbInfo != null) {
				params.put("cdCompany", dbInfo.get("erpCompSeq"));
				ErpOrgchartDAO erpOrgchartDAO =  ErpOrgchartDAOCreator.newInstanceDao(dbInfo);
				
				params.put("codeType", "40");
				List<Map<String, Object>> list = commonSql.list("ErpOrgchartDAO.getDutyPosionOptionInfo", params);
				
				for(Map<String, Object> mp : list) {
					if(mp.get("gwCode").toString().equals("1")) {
						if(mp.get("erpCode").toString().equals("1")){
							params.put("erpIuPositionSet", "cdDutyStep");
						}else if(mp.get("erpCode").toString().equals("2")){
							params.put("erpIuPositionSet", "cdDutyResp");
						}else if(mp.get("erpCode").toString().equals("3")){
							params.put("erpIuPositionSet", "cdDutyRank");
						}
					}else if(mp.get("gwCode").toString().equals("2")) {
						if(mp.get("erpCode").toString().equals("1")){
							params.put("erpIuDutySet", "cdDutyStep");
						}else if(mp.get("erpCode").toString().equals("2")){
							params.put("erpIuDutySet", "cdDutyResp");
						}else if(mp.get("erpCode").toString().equals("3")){
							params.put("erpIuDutySet", "cdDutyRank");
						}
					}
				}
				
				/* 직책 */
				List<Map<String,Object>> dutyList = erpOrgchartDAO.selectErpDutyCodeList(params);
				if(dutyList != null) {
					params.put("dutyList", dutyList);
				}
				
				/* 직급 */
				List<Map<String,Object>> positionList = erpOrgchartDAO.selectErpPositionCodeList(params);
				if(positionList != null) {
					params.put("positionList", positionList);
					
				}
				
				params.put("erpType", dbInfo.get("erpType"));
				setCompDutyPosition(params);
				
				resultCode = "0";
			}
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return resultCode;
	}

	@Override
	public void setEmpOrderText(Map<String, Object> params) {
		commonSql.update("ErpOrgchartDAO.setEmpOrderText", params);		
	}

	@Override
	public List<Map<String, Object>> selectSyncDutyPosiCodeList(Map<String, Object> params) {
		return erpOrgchartDAO.selectErpSyncCodeList(params);
	}

	@Override
	public String selectErpResignCodeStr(Map<String, Object> params) {
		return (String) commonSql.select("ErpOrgchartDAO.selectErpResignCodeStr", params);
	}

	@Override
	public void setMainCompYn(Map<String, Object> params) {
		List<Map<String, Object>> targetEmpList = commonSql.list("ErpOrgchartDAO.mainCompYnTargetEmpList", params);
		
		for(Map<String, Object> mp : targetEmpList) {
			Map<String, Object> para = new HashMap<>();
			
			para.put("groupSeq", mp.get("groupSeq"));
			para.put("compSeq", mp.get("compSeq"));
			para.put("empSeq", mp.get("empSeq"));
			
			if(mp.get("mainCompYnCnt").toString().equals("0")) {
				if(mp.get("compSeq").toString().equals(mp.get("mainCompSeq").toString())) {
					para.put("mainCompYn", "Y");
				}else {
					para.put("mainCompYn", "N");
				}
			}else{
				if(mp.get("compSeq").toString().equals(mp.get("empMainCompYnSeq").toString())) {
					para.put("mainCompYn", "Y");
				}else {
					para.put("mainCompYn", "N");
				}
			}
			commonSql.update("ErpOrgchartDAO.updateEmpDeptMainCompYn", para);
		}
	
	}

	@Override
	public void reSetWeddingDay(Map<String, Object> paramMap) {
		commonSql.update("ErpOrgchartDAO.reSetWeddingDay", paramMap);		
	}

	@Override
	public void licenseCheck(Map<String, Object> params) throws Exception {
		Map<String, Object> licenseCount = licenseService.LicenseCountShow(params);
		
		//그룹웨어,메일 잔여 라이선스 카운트
		int gwCount = Integer.parseInt(licenseCount.get("totalGwCount").toString()) - Integer.parseInt(licenseCount.get("realGwCount").toString());
		int mailCount = Integer.parseInt(licenseCount.get("totalMailCount").toString()) - Integer.parseInt(licenseCount.get("realMailCount").toString());
		
		//조직도연동 라이선스 카운트 조회
		Map<String, Object> erpSyncLicenseCount = (Map<String, Object>) commonSql.select("ErpOrgchartDAO.getErpSyncLicenseCount", params);
		
		int gwSyncCount = Integer.parseInt(erpSyncLicenseCount.get("gwSyncCount").toString());
		int mailSyncCount = Integer.parseInt(erpSyncLicenseCount.get("mailSyncCount").toString());
		
		if(gwSyncCount > gwCount) {	
			params.put("gwSyncYn", "N");}
		else {	
			params.put("gwSyncYn", "Y");}
		
		if(mailSyncCount > mailCount)	{
			params.put("mailSyncYn", "N");}
		else	{
			params.put("mailSyncYn", "Y");}
		
	}
	
	public void deleteOrgchartTempOld(String groupSeq) {		
		if(groupSeq != null) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupSeq", groupSeq);
			
			commonSql.delete("ErpOrgchartDAO.deleteTmpBizOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpBizMultiOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpDeptOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpDeptMultiOld", params);
		}
	}
	
	
	public void deleteEmpTempOld(String groupSeq) {		
		if(groupSeq != null) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("groupSeq", groupSeq);
			
			commonSql.delete("ErpOrgchartDAO.deleteTmpEmpOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpEmpMultiOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDeptOld", params);
			commonSql.delete("ErpOrgchartDAO.deleteTmpEmpDeptMultiOld", params);
		}
	}
}
