package neos.migration.suite.service.impl;

import java.io.BufferedReader; 
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.eclipse.jetty.util.log.Log;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.NeosConstants;
import neos.migration.suite.dao.ExecuteAlphaDAO;
import neos.migration.suite.dao.ExecuteSuiteDAO;
import neos.migration.suite.service.ExecuteMigService;
import neos.migration.suite.vo.SuiteBaseInfoVO;
import neos.migration.suite.vo.SuiteDBCnntVO;


@Service("ExecuteMigService")
public class ExecuteMigServiceImpl implements ExecuteMigService {
	
	private Logger LOG = LogManager.getLogger(this.getClass());
	
	private String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	
	@Resource(name = "ExecuteSuiteDAO")
	private ExecuteSuiteDAO executeSuiteDAO;
	
	@Resource(name = "ExecuteAlphaDAO")
	private ExecuteAlphaDAO executeAlphaDAO;
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	
	@Override
	public Map<String, Object> selectSuiteCompanyInfoB(SuiteDBCnntVO suiteDBCnntVO) {
		
		return executeSuiteDAO.selectSuiteCompanyInfoB(suiteDBCnntVO);
	}

	@Override
	public Map<String, Object> selectSuiteCompanyInfoC(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {

		return executeSuiteDAO.selectSuiteCompanyInfoC(suiteDBCnntVO, suiteBaseInfoVO);
	}
	
	@Override
	public Map<String, Object> getSuiteServerInfo(Map<String, Object> paramMap) {

		Map<String, Object> result = executeAlphaDAO.getSuiteInfo(paramMap);
		return result;
	}
	
	public Map<String, Object> selectSuiteDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO, Map<String, Object> param){
	
		return executeSuiteDAO.selectSuiteDocCount(suiteDBCnntVO, suiteBaseInfoVO, param);
		
	}
	
	@Override
	public List<Map<String, Object>> selectAlphaDocBoxList(Map<String, Object> params) {
		
		return executeAlphaDAO.selectAlphaDocBoxList(params);
	}

	@Override
	public List<Map<String, Object>> selectSuiteDocId(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> params) {
		return executeSuiteDAO.selectSuiteDocId(suiteDBCnntVO, params);
	}

	@Override
	public String convertDocIdList(List<Map<String, Object>> selectSuiteDocIdList) {
		
		String result = "";
		
		for(int i = 0, len = selectSuiteDocIdList.size(); i < len; i++) {
			result += "'" + selectSuiteDocIdList.get(i).get("docId") + "',";
		}
		
		if(result.length() > 0) {			
			result = result.substring(0, result.length() - 1);
		}else {
			result = "''";
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectAlphaElecDocList(Map<String, Object> params) {
		return executeAlphaDAO.selectAlphaElecDocList(params);
	}

	@Override
	public Map<String, Object> selectAuthApproveDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {
		
		return executeSuiteDAO.selectAuthApproveDocCount(suiteDBCnntVO, suiteBaseInfoVO);
	}

	@Override
	public Map<String, Object> selectViewDocCount(SuiteDBCnntVO suiteDBCnntVO, SuiteBaseInfoVO suiteBaseInfoVO) {
		
		return executeSuiteDAO.selectViewDocCount(suiteDBCnntVO, suiteBaseInfoVO);
	}

	@Override
	public List<Map<String, Object>> selectAuthApproveDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return executeSuiteDAO.selectAuthApproveDocList(suiteDBCnntVO, param);
	}

	@Override
	public String convertDocIdListToStr(String[] selectSuiteDocIdList) {

		String result = "";
		
		for(int i = 0, len = selectSuiteDocIdList.length; i < len; i++) {
			result += "'" + selectSuiteDocIdList[i] + "',";
		}
		
		if(result.length() > 0) {			
			result = result.substring(0, result.length() - 1);
		}else {
			result = "''";
		}
		
		return result;
	}

	@Override
	public List<Map<String, Object>> selectViewDocList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return executeSuiteDAO.selectViewDocList(suiteDBCnntVO, param);
	}

	@Override
	public List<Map<String, Object>> selectElecDocArtList(Map<String, Object> param) {
		return executeAlphaDAO.selectElecDocArtList(param);
	}

	@Override
	public void insertAlphaAuthApproveDoc(Map<String, Object> param) {
		executeAlphaDAO.insertAlphaAuthApproveDoc(param);
	}

	@Override
	public void insertAlphaViewDoc(Map<String, Object> param) {
		executeAlphaDAO.insertAlphaViewDoc(param);
		
	}

	@Override
	public void deleteBpmArt(Map<String, Object> param) {
		executeAlphaDAO.deleteBpmArt(param);
	}

	@Override
	public void deleteBpmArtPerm(Map<String, Object> param) {
		executeAlphaDAO.deleteBpmArtPerm(param);
	}

	@Override
	public void deleteBpmAttachFile(Map<String, Object> param) {
		executeAlphaDAO.deleteBpmAttachFile(param);
		
	}

	@Override
	public void deleteBpmReadRecord(Map<String, Object> param) {
		executeAlphaDAO.deleteBpmReadRecord(param);
		
	}

	@Override
	public List<Map<String, Object>> selectSuiteBoardCommentList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return executeSuiteDAO.selectSuiteBoardCommentList(suiteDBCnntVO, param);
	}

	@Override
	public List<Map<String, Object>> selectSuiteDocCommentList(SuiteDBCnntVO suiteDBCnntVO, Map<String, Object> param) {
		return executeSuiteDAO.selectSuiteDocCommentList(suiteDBCnntVO, param);
	}

	@Override
	public void createCommentTableBackup(Map<String, Object> param) {
		executeAlphaDAO.createCommentTableBackup(param);
		
	}

	@Override
	public void createCommentCountTableBackup(Map<String, Object> param) {
		executeAlphaDAO.createCommentCountTableBackup(param);
		
	}

	@Override
	public void updateDocIdTmigInfo(Map<String, Object> param) {
		executeAlphaDAO.updateDocIdTmigInfo(param);
	}

	@Override
	public Map<String, Object> selectTmigInfoDoc(Map<String, Object> param) {
		return executeAlphaDAO.selectTmigInfoDoc(param);
	}

	@Override
	public void updateFailDocId(Map<String, Object> param) {
		executeAlphaDAO.updateFailDocId(param);
		
	}
}
