package api.orgchart.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.ibatis.mapping.Environment;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.ibatis.transaction.TransactionFactory;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.apache.log4j.Logger;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import api.common.dao.APIDAO;
import api.common.model.APIResponse;
import api.common.service.EventService;
import api.common.util.DateUtils;
import api.hdcs.helper.ShellExecHelper;
import api.orgchart.dao.Sqlite;
import api.orgchart.service.ApiOrgchartService;
import cloud.CloudConnetInfo;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.encrypt.Encryptor;
import neos.cmm.encrypt.SEEDEncrypt;
import neos.cmm.erp.dao.ebp.EbpOrgchartDAOImpl;
import neos.cmm.erp.orgchart.service.ErpOrgchartSyncService;
import neos.cmm.systemx.group.service.GroupManageService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;
import neos.cmm.util.FileUtils;
import neos.cmm.util.NeosConstants;
import neos.cmm.util.code.service.SequenceService;

@Service("ApiOrgchartService")
public class ApiOrgchartServiceImpl implements ApiOrgchartService {
	private static Log logger = LogFactory.getLog(ApiOrgchartServiceImpl.class);

	private final static String SQLITE_QUERY_PREPIX = "api.orgchart.dao.Sqlite.";
	private final static String ORGCHART_QUERY_PREPIX = "orgchartDAO.";
	private final static String MOBILE_DOWNLOAD_URL = "/BizboxMobileGateway/file/GetEncrytFileDownload?fileId=";

	@Resource(name="APIDAO")
	private APIDAO apiDAO;

//	@Value("#{bizboxa['BizboxA.groupware.domin']}")
//	private String gwDomain;

	@Resource(name="EventService")
	private EventService eventService;

	@Resource(name="GroupManageService")
	private GroupManageService groupManageService;

    @Resource(name = "commonSql")
    private CommonSqlDAO commonSql;

    @Resource ( name = "OrgAdapterDAO" )
    private OrgAdapterDAO orgAdapterDAO;
    @Resource(name = "OrgAdapterService")
    private OrgAdapterService orgAdapterService;
    @Resource(name = "ErpOrgchartSyncService")
    private ErpOrgchartSyncService erpOrgchartSyncService;
    @Resource(name = "SequenceService")
    private SequenceService sequenceService;

	/** 조직도 보안적용 박스버전 체크 */
	private static final int BOX_VER_SEQ = 470;

	@Override
	public void downloadOrgChart(HttpServletRequest request, HttpServletResponse response, String groupSeq) throws IOException {
		String filePath = null;

		try {
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("groupSeq", groupSeq);
			filePath = (String) apiDAO.select(ORGCHART_QUERY_PREPIX+"getOrgchartPath", mp);
			logger.info("downloadOrgChart groupSeq=" +  groupSeq + ", filePath=" + filePath);
			String fileName[] = filePath.split("/");
			response.reset();
			File file = new File(filePath);
			logger.info("file length = " +  file.length());
			response.setContentType(CommonUtil.getContentType(file));
			response.setHeader("Content-Disposition", "attachment; filename="+ fileName[fileName.length-1]);
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setContentLength((int)file.length());

			OutputStream outputStream = response.getOutputStream();
			FileUtils.copyFile(file, outputStream);
		} catch (FileNotFoundException e) {
			logger.info("downloadOrgChart groupSeq=" +  groupSeq + ", filePath=" + filePath + " not found", e);
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}
	}

	@Override
	public String[] orgChartEidtYn(HttpServletRequest request, HttpServletResponse response, String groupSeq, String orgChartDt, String reqType) throws IOException {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("groupSeq", groupSeq);
		paramMap.put("orgChartDt", orgChartDt);

		@SuppressWarnings("unchecked")
		Map<String,Object> orgChartMap = (Map<String, Object>) apiDAO.select(ORGCHART_QUERY_PREPIX+"getOrgchartInfo", paramMap);

		if(orgChartMap == null || orgChartMap.size() == 0){
			String[] tmp = {"" , "", ""};
			return tmp;
		}
		String resultOrgChartDt = orgChartMap.get("orgChartDt")+"";
		if(EgovStringUtil.isEmpty(resultOrgChartDt)){
			String[] tmp = {"" , "", ""};
			return tmp;
		}

		String orgStatus = orgChartMap.get("orgStatus")+"";

		if (EgovStringUtil.isEmpty(orgStatus)) {
			orgStatus = "0";
		}

		Map<String, Object> groupMap = groupManageService.getGroupInfo(paramMap);
		String mobileDomain = groupMap.get("mobileGatewayUrl")+"";

		if(reqType.equals("messenger") && groupMap.get("messengerGatewayUrl") != null && !groupMap.get("messengerGatewayUrl").equals("")){
			mobileDomain = groupMap.get("messengerGatewayUrl")+"";
		}

		logger.debug("mobileDomain : " + mobileDomain);

		String path = orgChartMap.get("filePath")+"";	// 조직도 저장 경로
		path = path.substring(path.indexOf("/upload"));
		logger.debug("path : " + path);

		String downloadPath = mobileDomain + path;
		logger.debug("downloadPath : " + downloadPath);

		/**
		 * 모바일 API 맞추기 위한 버전 체크
		 * 해당하는 경우 PATH 경로를 암호하여 전달
		 */
		int boxVerSeq = CommonUtil.getIntNvl(groupMap.get("setupVersionSeq")+"");
		logger.debug("boxVerSeq : " + boxVerSeq);
		if(boxVerSeq > BOX_VER_SEQ) {
			logger.debug("path Encrypt start..");
			return getEncryptOrgChartInfo(mobileDomain, orgChartMap.get("filePath")+"", orgStatus, resultOrgChartDt,groupMap.get("mobileId").toString());
		}

		String[] result = new String[4];
		result[0] = downloadPath;
		result[1] = resultOrgChartDt;
		result[2] = orgStatus;

		String zipPath = path.substring(0, path.indexOf("."))+".zip";

		logger.debug("mobileDomain + zipPath : " + mobileDomain + zipPath);

		String oriPath = orgChartMap.get("filePath")+"";
		String zipFilePath = oriPath.substring(0, oriPath.indexOf("."))+".zip";
		if(FileUtils.isNotEmpty(zipFilePath)) {
			result[3] = mobileDomain + zipPath;
		}
		else {
			result[3] = "";
		}

		return result;
	}

	private String[] getEncryptOrgChartInfo(String mobileDomain, String path, String orgStatus, String resultOrgChartDt,String mobileId) {

		String[] pathArr = path.split("/");

		String encryptPath = getEncrypt(path);
		String downloadPath = null;
		if (encryptPath != null) {
			downloadPath = mobileDomain + MOBILE_DOWNLOAD_URL + encryptPath+"&mobileId="+mobileId+"&fileName=/"+pathArr[pathArr.length-1];
		}

		String[] result = new String[4];
		result[0] = downloadPath;
		result[1] = resultOrgChartDt;
		result[2] = orgStatus;

		String zipPath = path.substring(0, path.indexOf("."))+".zip";

		logger.debug("mobileDomain + zipPath : " + mobileDomain + zipPath);

		String[] zipPathArr = zipPath.split("/");

		String zipFilePath = path.substring(0, path.indexOf("."))+".zip";
		if(FileUtils.isNotEmpty(zipFilePath)) {
			encryptPath = getEncrypt(zipPath);
			result[3] = mobileDomain + MOBILE_DOWNLOAD_URL + encryptPath+"&mobileId="+mobileId+"&fileName=/"+zipPathArr[zipPathArr.length-1];
		}
		else {
			result[3] = "";
		}
		
		return result;
	}

	private Map<String,Object> getEncryptOrgChartInfoMap(String mobileDomain, String messengerDomain, String path, String orgStatus, String resultOrgChartDt,String mobileId) {
		Map<String,Object> map = new HashMap<>();

		String[] pathArr = path.split("/");

		map.put("orgChartURL", mobileDomain + MOBILE_DOWNLOAD_URL + getEncrypt(path)+"&mobileId="+mobileId+"&fileName=/"+pathArr[pathArr.length-1]);
		map.put("orgChartMessengerURL", messengerDomain + MOBILE_DOWNLOAD_URL + getEncrypt(path)+"&mobileId="+mobileId+"&fileName=/"+pathArr[pathArr.length-1]);

		String zipPath = path.substring(0, path.indexOf("."))+".zip";

		String[] zipPathArr = zipPath.split("/");

		logger.debug("mobileDomain + zipPath : " + mobileDomain + zipPath);

		String oriPath = path;
		String zipFilePath = oriPath.substring(0, oriPath.indexOf("."))+".zip";
		if(FileUtils.isNotEmpty(zipFilePath)) {
			map.put("orgChartZipURL", mobileDomain + MOBILE_DOWNLOAD_URL + getEncrypt(zipPath)+"&mobileId="+mobileId+"&fileName=/"+zipPathArr[zipPathArr.length-1]);
			map.put("orgChartMessengerZipURL", messengerDomain + MOBILE_DOWNLOAD_URL + getEncrypt(zipPath)+"&mobileId="+mobileId+"&fileName=/"+zipPathArr[zipPathArr.length-1]);
		}
		else {
			map.put("orgChartZipURL", "");
			map.put("orgChartMessengerZipURL", "");
		}

		map.put("orgChartDt", resultOrgChartDt);

		map.put("orgChartStatus", orgStatus);

		return map;
	}

	private String getEncrypt(String path) {
		Encryptor en = new SEEDEncrypt();

		String s = null;

		try {
			s = en.encrypt(path);
		} catch (InvalidKeyException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (UnsupportedEncodingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (NoSuchAlgorithmException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (NoSuchPaddingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (InvalidAlgorithmParameterException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (IllegalBlockSizeException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		} catch (BadPaddingException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		return s;

	}

	@SuppressWarnings("unchecked")
	@Override
	public Object selectGroupList(Map<String,Object> paramMap) {

		List<Map<String, Object>> data = (List<Map<String, Object>>) apiDAO.list(ORGCHART_QUERY_PREPIX+"selectGroupList", paramMap);
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("groupList", data);
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object selectCompBizDeptList(Map<String,Object> paramMap) {

		Map<String,Object> data = selectData(paramMap);

		List<Map<String, Object>> list = (List<Map<String, Object>>) apiDAO.list(ORGCHART_QUERY_PREPIX+"selectCompBizDeptList",data);

		Map<String,Object> result = new HashMap<String,Object>();
		result.put("orgList", list);
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Object selectEmpList(HttpServletRequest request, Map<String, Object> paramMap) {

		Map<String,Object> data = selectData(paramMap);

		String domain = (String) apiDAO.select(ORGCHART_QUERY_PREPIX+"selectCompDomain", data);
		String path = request.getScheme() + "://" + domain + request.getContextPath() + "/cmm/file/attachFileDownloadProc.do?pathSeq=0&dataType=json&groupSeq=" + data.get("groupSeq");


		List<Map<String, Object>> list = (List<Map<String, Object>>) apiDAO.list(ORGCHART_QUERY_PREPIX+"selectEmpList",data);

		for(Map<String,Object>empInfo:list) {
			String url = "";
			if(empInfo.get("picFileId") != null) {
				url = path + "&empSeq=" + empInfo.get("empSeq") + "&fileId=" + empInfo.get("picFileId") + "&fileSn=0";
			}
			empInfo.remove("picFileId");
			empInfo.put("picURL", url);
		}
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("empList", list);

		return result;

	}

	@SuppressWarnings("unchecked")
	@Override
	public Object insertEmpNum(Map<String,Object> paramMap) {

		Map<String,Object> data = selectData(paramMap);

		List<Map<String, Object>> empList = (List<Map<String, Object>>) data.get("empList");
		if(empList != null) {
			for(Map<String,Object>empInfo : empList) {
				empInfo.put("groupSeq", data.get("groupSeq"));
				apiDAO.insert(ORGCHART_QUERY_PREPIX+"insertEmpNum", empInfo);
				empInfo.remove("groupSeq");
			}
		}

		Map<String,Object> result = new HashMap<String,Object>();
		return result;
	}

	@SuppressWarnings("unchecked")
	private Map<String,Object> selectData(Map<String,Object> paramMap) {
		Map<String,Object> header = (Map<String, Object>) paramMap.get("header");
		Map<String,Object> data = (Map<String, Object>) paramMap.get("body");
		data.put("groupSeq", header.get("groupSeq"));
		return data;
	}

	@Override
	public int pollingOrgSync(String groupSeq, String isEventSend, boolean foceReq) {
		
		logger.info("[pollingOrgSync] call seq : 1 > groupSeq["+groupSeq+"], isEventSend["+isEventSend+"], foceReq["+foceReq+"]");

		List<Map<String, Object>> taskList = null;
		
		Map<String, Object> para = new HashMap<String, Object>();
		para.put("groupSeq", groupSeq);
		
		if(foceReq) {
			Map<String,Object> m = new HashMap<>();
			m.put("groupSeq", groupSeq);
			m.put("updateStatus", "99");	// 1회성 요청은 최종 변경 상태값이 "0" 일수 있으므로 "전체변경 :99" 로 설정한다.
			taskList = new ArrayList<>();
			taskList.add(m);
			
		}else {
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> list = (List<Map<String, Object>>) apiDAO.list(ORGCHART_QUERY_PREPIX+"getOrgSyncTaskList", para);

			if (list != null) {
				taskList = new ArrayList<>();

				for(Map<String,Object> map : list) {
					
					int syncCycleTime = CommonUtil.getIntNvl(map.get("syncCycleTime")+"");

					if (syncCycleTime == 0) {
						syncCycleTime = 5;	// 기본 5분
					}

					/**
					 * 주기는 24시간을 기준으로 하기 때문에 24시간 안에서 정확하게 주기가 동작하려면
					 * 5분 , 10분, 15분, 20분, 30분...1시간, 2시간, 4시간, 6시간, 8시간, 12시간 까지 설정이 가능한다.
					 * 0시 정각은 무조건 동기화가 진행된다.
					 * 나머지 설정시간도 동작은 하지만 0시을 기준으로 정확한 주기가 안될 수 있다.
					 */
					
					int curMin = (DateUtil.getHour()*60) + DateUtil.getMinute();
					
					if (curMin % syncCycleTime == 0) {
						if(taskList!=null) {//Null Pointer 역참조
						taskList.add(map);
						}
					}
				}
			}	
		}

		int count = 0;
		List<Map<String, Object>> syncComList = new ArrayList<Map<String,Object>>();
		if(taskList!=null) {//Null Pointer 역참조
			for(Map<String, Object> task : taskList){
	
				// 조직도 동기화 시간 파일명과 맞추기 위해 동기화 시작시간을 db에서 조회하여 셋팅
				@SuppressWarnings("unchecked")
				Map<String,Object> curTimeMap = (Map<String, Object>) apiDAO.select(ORGCHART_QUERY_PREPIX+"selectCurrentTime", para);
				
				String currentTime = null;
				String regDate = null;
	
				if (curTimeMap != null) {
					currentTime = curTimeMap.get("cTime")+"";
					regDate = curTimeMap.get("rTime")+"";
				} else {
					currentTime = DateUtils.getCurrentTime("yyyyMMddHHmmss");
					regDate = DateUtils.getCurrentTime("yyyy-MM-dd HH:mm:ss");
				}
	
				task.put("currentTime", currentTime);
				task.put("regDate", regDate);
	
				/** 조직도 저장경로 조회 */
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("groupSeq", task.get("groupSeq"));
				param.put("pathSeq", "1");	// 조직도 경로
				param.put("osType", NeosConstants.SERVER_OS);
				Map<String, Object> pathInfoMap = groupManageService.selectPathInfo(param);
	
				if (pathInfoMap != null) {
					task.put("path", pathInfoMap.get("absolPath"));	// 조직도 저장 경로
				}
	
				if (task.get("path") == null || task.get("path").equals("")) {
					continue;
				}
	
				/** group 주언어 조회 */
				String langCode = groupManageService.selectGroupLangCode(param);
				if (StringUtils.isEmpty(langCode)) {
					langCode = "kr";
				}
				task.put("langCode", langCode);
	
				// 조직도 동기화 진행 중 으로 업데이트
				task.put("taskStatus", "2");
				apiDAO.update(ORGCHART_QUERY_PREPIX+"updateOrgSyncTask", task);
	
				String filePath = processOrgSync(task);
	
				if(filePath == null) {
					/** 조직도 파일 생성시 실패하면 다시 동기화 할수 있도록 상태를 1로 변경 */
					task.put("taskStatus", "1");
					apiDAO.update(ORGCHART_QUERY_PREPIX+"updateOrgSyncTask", task);
					return -1;
				}
	
				task.put("filePath", filePath);
	
				/** 조직도 생성 서버 ip 셋팅 */
				task.put("regIp", getIpList());
	
				/** 최종 변경 상태 값 저장 */
				task.put("orgStatus", task.get("updateStatus"));
	
				apiDAO.update(ORGCHART_QUERY_PREPIX+"updateOrgSyncTaskComplete", task);
	
				syncComList.add(task);
				count++;
			}
		}

		if(0 == count) {
			logger.info("[pollingOrgSync] 조직도 동기화 대상이 존재하지 않습니다.............");
		}
		else {
			if (isEventSend == null || !isEventSend.equals("N")) {
				eventOrgSync(syncComList);
			}
			
			//mailSync 호출
			orgAdapterService.mailUserSync(para);
		}

		return count;

	}


	/**
	 * 조직도 변경 알림 이벤트
	 * @param task
	 */
	private void eventOrgSync(List<Map<String, Object>> syncComList) {

		List<Map<String, Object>> reqList = new ArrayList<Map<String,Object>>();

		if (syncComList != null) {
			for(Map<String,Object> map : syncComList) {

				Map<String,Object> params = new HashMap<String, Object>();

				params.put("groupSeq", map.get("groupSeq"));

				Map<String, Object> groupMap = groupManageService.getGroupInfo(params);
				String mobileDomain = groupMap.get("mobileGatewayUrl")+"";
				String messengerDomain = groupMap.get("messengerGatewayUrl") == null || groupMap.get("messengerGatewayUrl").equals("") ? mobileDomain : groupMap.get("messengerGatewayUrl") + "";
				logger.debug("mobileDomain : " + mobileDomain);

				if(EgovStringUtil.isEmpty(mobileDomain)) {
					mobileDomain = "Http://localhost";
				}
				if(EgovStringUtil.isEmpty(messengerDomain)) {
					messengerDomain = "Http://localhost";
				}

				String path = map.get("filePath")+"";	// 조직도 저장 경로
				path = path.substring(path.indexOf("/upload"));
				logger.debug("path : " + path);
				logger.debug("mobileDomain + path : " + mobileDomain + path);

				/**
				 * 모바일 API 맞추기 위한 버전 체크
				 * 해당하는 경우 PATH 경로를 암호하여 전달
				 */
				int boxVerSeq = CommonUtil.getIntNvl(groupMap.get("setupVersionSeq")+"");
				logger.debug("boxVerSeq : " + boxVerSeq);
				if(boxVerSeq > BOX_VER_SEQ) {
					logger.debug("path Encrypt start..");

					params = getEncryptOrgChartInfoMap(mobileDomain, messengerDomain, map.get("filePath")+"", map.get("orgStatus")+"", map.get("currentTime")+"",groupMap.get("mobileId").toString());

					// groupSeq 다시 셋팅해줘야 한다.
					params.put("groupSeq", map.get("groupSeq"));

				} else {
					String zipPath = path.substring(0, path.indexOf("."))+".zip";

					logger.debug("mobileDomain + zipPath : " + mobileDomain + zipPath);

					params.put("orgChartURL", mobileDomain+path);
					params.put("orgChartMessengerURL", messengerDomain+path);

					String oriPath = map.get("filePath")+"";
					String zipFilePath = oriPath.substring(0, oriPath.indexOf("."))+".zip";
					if(FileUtils.isNotEmpty(zipFilePath)) {
						params.put("orgChartZipURL", mobileDomain+zipPath);
						params.put("orgChartMessengerZipURL", messengerDomain+zipPath);
					}
					else {
						params.put("orgChartZipURL", "");
						params.put("orgChartMessengerZipURL", "");
					}


					params.put("orgChartDt", map.get("currentTime"));

					params.put("orgChartStatus", map.get("orgStatus"));
				}

				reqList.add(params);
			}
		}

		Map<String,Object> request = new HashMap<String,Object>();
		request.put("syncInfoList", reqList);


		try {

			logger.debug("eventOrgSync request : " + request);

			eventService.eventOrgSync(request);
		} catch (IOException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
	}

	private String processOrgSync(Map<String, Object> param){

		String path = param.get("path")+"";

		/** 조직도 저장 경로 체크 */
		if (EgovStringUtil.isEmpty(path)) {
			path = "/home/upload/orgchart";
		}

		String groupSeq = param.get("groupSeq")+"";

		path = path + File.separator + groupSeq + File.separator;
		
		File file = new File(path);
		
		if(!file.isDirectory()) {
			file.mkdirs();
		}

		String currentTime = param.get("currentTime")+"";

		String random = EgovStringUtil.getRandomStr('a', 'z')
				+ EgovStringUtil.getRandomStr('a', 'z')
				+ EgovStringUtil.getRandomStr('a', 'z')
				+ EgovStringUtil.getRandomStr('a', 'z');
		
		String dbFileName = "orgchart_" + param.get("groupSeq") + "_" + currentTime + "_" + random +".sqlite";

		String dbFilePath = path + dbFileName;
		String dbTempPath = System.getProperty("java.io.tmpdir") + File.separator + dbFileName;

		SqlSession sqlite = null;
		DataSource dataSource = null;
		TransactionFactory transactionFactory = null;
		Environment environment = null;
		Configuration configuration = null;
		SqlSessionFactory orgchartDAOFactory = null;

		try{
			dataSource = new PooledDataSource("org.sqlite.JDBC", "jdbc:sqlite:" + dbTempPath, "", "");
			transactionFactory = new JdbcTransactionFactory();
			environment = new Environment("development", transactionFactory, dataSource);
			configuration = new Configuration(environment);
			configuration.addMapper(Sqlite.class);
			orgchartDAOFactory = new SqlSessionFactoryBuilder().build(configuration);
			sqlite = orgchartDAOFactory.openSession();

			// DB 파일, 테이블 생성
			makeDBAndTable(sqlite);

			// Data 넣기
			insertData(sqlite, param);

			logger.debug("[pollingOrgSync] file create end..");

		} catch(Exception e){
			logger.error("[pollingOrgSync] file create error...", e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			dbTempPath = null;
		} finally {
			
			if (sqlite != null) {
				sqlite.close();
			}
			try {
				if(dataSource != null && dataSource.getConnection() != null) {
					Connection conn = dataSource.getConnection();
					conn.close();
				}
			} catch (SQLException e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}

		if (dbTempPath != null) {
			try {
				/**
				 * 조직도 파일을 temp 폴더에 생성하였다.
				 * linux의 경우 /tomcat/temp/ 밑에 생성이 된다. 해당 파일을 upload 폴더 쪽으로 이동.
				 * linux 경우 이동이 되나 windows에서는 이동이 되지 않는다.
				 * 그래서 copy를 추가함.
				 *
				 */
				logger.debug("[pollingOrgSync] file move dbTempPath : " + dbTempPath +", dbFilePath : " + dbFilePath);
				FileUtils.moveTransfer(dbTempPath, dbFilePath);
			} catch (Exception e1) {
				logger.error("[pollingOrgSync] FileUtils.moveTransfer error...");
				logger.error(e1);

				logger.debug("[pollingOrgSync] FileUtils.copyTransfer start...");

				/**
				 * 이동 중 Exception이 발생하면 복사로 한다.
				 */
				try {
					FileUtils.copyTransfer(dbTempPath, dbFilePath);
				} catch (Exception e) {
					logger.error("[pollingOrgSync] FileUtils.copyTransfer error...");
					logger.error(e);
				}
			}

			String zipFilePath = path + "orgchart_"
					+ param.get("groupSeq") + "_" + currentTime + "_" + random +".zip";

			try {
				FileUtils.createZipFile(zipFilePath, dbFilePath);
			} catch (IOException e) {
				logger.error(e);
				logger.error("[pollingOrgSync] FileUtils.createZipFile error...");

				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			try {
				//파일정리
				File[] fileList = file.listFiles();
				List<String> delFileList = new ArrayList<String>();
				List<String> delFolderList = new ArrayList<String>();
				int newFileCnt = 0;
				
				DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyyMMddHHmm");
				DateTime nowDate = formatter.parseDateTime(currentTime.substring(0, 12)).minusHours(48);
				
				Double checkDate = Double.parseDouble(nowDate.toString(formatter));
				
				//파일,폴더리스트 조회
		        for(File fileInfo : fileList) {
		        	
		        	if(fileInfo.isFile()) {
		        		
		        		String fileName = fileInfo.getName();
		        		
		        		if(fileName.contains("orgchart_")) {
		        			
		        			String[] pppp = fileName.split("_");
		        			
		        			if(pppp.length > 2 && pppp[2].length() > 11 && isNumeric(pppp[2].substring(0, 12))) {
		        				
		        				if(Double.parseDouble(pppp[2].substring(0, 12)) < checkDate) {
		        					delFileList.add(fileInfo.getPath());
		        				}else {
		        					newFileCnt++;
		        				}
		        			}
		        		}
		        	}else if(fileInfo.getName().length() == 6) {
		        		delFolderList.add(fileInfo.getPath());
		        	}
		        }
		        
		        if(newFileCnt > 10) {
		        	//폴더삭제
		        	if(delFolderList.size() > 0) {
		        		try {
			        		for(String delFolderPath : delFolderList) {
			        			ShellExecHelper.executeCommand("rm -rf " + delFolderPath);	
			        		}
						} catch (Exception e) {
							CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
						}
		        	}
		        	//파일삭제
		        	if(delFileList.size() > 0) {
		        		for(String delFilePath : delFileList) {
		        			File delFile = new File(delFilePath);
		        			delFile.delete();
		        		}
		        	}
		        }				
			} catch (Exception e) {
				logger.error("[pollingOrgSync] 파일정리오류");
				logger.error(e);
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}

		} else {
			dbFilePath = null;
		}

		return dbFilePath;
	}
	
	private boolean isNumeric(String str){  
		try  
		{  
			Double.parseDouble(str);  
		}  
		catch(NumberFormatException nfe)  
		{  
			return false;  
		}  
		return true;  
	} 	

	private void makeDBAndTable(SqlSession sqlite) throws Exception{
		logger.debug("makeDBAndTable start.. ");
		sqlite.update(SQLITE_QUERY_PREPIX+"createCompTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createCompMultiTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createBizTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createBizMultiTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createDeptTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createDeptMultiTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpMultiTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpDeptTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpDeptMultiTable"); // emp_dept_multi
		sqlite.update(SQLITE_QUERY_PREPIX+"createCompDutyPositionTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createCompDutyPositionMultiTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createCompEmpSortTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createGrouppingTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createGrouppingCompTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpCompTable");
		sqlite.update(SQLITE_QUERY_PREPIX+"createEmpResignTable");
		logger.debug("makeDBAndTable end.. ");
	}

	private void insertData(SqlSession sqlite, Map<String, Object> param) throws Exception{
		logger.debug("comp start.. ");
		// 회사

		selectInsertSqlite(sqlite, param, "getCompList", "addCompData", 1);

		logger.debug("compMulti start.. ");
		selectInsertSqlite(sqlite, param, "getCompMultiList", "addCompMultiData", 1);

		logger.debug("biz start.. ");
		// 사업장
		selectInsertSqlite(sqlite, param, "getBizList", "addBizData", 1);

		logger.debug("bizMulti start.. ");
		selectInsertSqlite(sqlite, param, "getBizMultiList", "addBizMultiData", 1);

		logger.debug("dept start.. ");
		// 부서
		selectInsertSqlite(sqlite, param, "getDeptList", "addDeptData", 1);

		logger.debug("deptMulti start.. ");
		selectInsertSqlite(sqlite, param, "getDeptMultiList", "addDeptMultiData", 1);

		logger.debug("emp start.. ");
		// 사용자
		selectInsertSqlite(sqlite, param, "getEmpList", "addEmpData", 1);

		logger.debug("empMulti start.. ");
		selectInsertSqlite(sqlite, param, "getEmpMultiList", "addEmpMultiData", 1);

		logger.debug("empDept start.. ");
		selectInsertSqlite(sqlite, param, "getEmpDeptList", "addEmpDeptData", 1);

		logger.debug("empDeptMulti start.. ");
		// emp_dept_multi
		selectInsertSqlite(sqlite, param, "getEmpDeptMultiList", "addEmpDeptMultiData", 1);

		logger.debug("compDutyPosition start.. ");
		// 직급, 직책
		selectInsertSqlite(sqlite, param, "getCompDutyPositionList", "addCompDutyPositionData", 1);

		logger.debug("compDutyPositionMulti start.. ");
		selectInsertSqlite(sqlite, param, "getCompDutyPositionMultiList", "addCompDutyPositionMultiData", 1);

		logger.debug("compEmpSort start.. ");
		// 정렬 순서
		selectInsertSqlite(sqlite, param, "getCompEmpSortList", "addCompEmpSortData", 1);

		logger.debug("groupping start.. ");
		// 그룹핑 정보
		selectInsertSqlite(sqlite, param, "getGrouppingList", "addGrouppingData", 1);

		logger.debug("grouppingComp start.. ");
		selectInsertSqlite(sqlite, param, "getGrouppingCompList", "addGrouppingCompData", 1);

		logger.debug("empComp start.. ");
		// 사용자 회사 정보
		selectInsertSqlite(sqlite, param, "getEmpCompList", "addEmpCompData", 1);

		logger.debug("empResign start.. ");
		// 사용자 회사 정보
		selectInsertSqlite(sqlite, param, "getEmpResignList", "addEmpResignData", 1);
	}

	@SuppressWarnings("unchecked")
	private void selectInsertSqlite(SqlSession sqlite, Map<String, Object> param, String sourceSql, String targetSql, int page ) {
		try{
			logger.debug("selectInsertSqlite start.. param=" + param + ", sourceSql=" + sourceSql + ", targetSql=" + targetSql + ", page=" + page);
			List<Map<String,Object>> list = apiDAO.list(ORGCHART_QUERY_PREPIX+sourceSql, param);
			logger.debug("selectInsertSqlite list.size : " + list.size());

			if (list != null && list.size() > 0) {
				setSqlite(sqlite, list, SQLITE_QUERY_PREPIX+targetSql, 1);
			}
			sqlite.commit();
		}catch(Exception e){
			logger.error("Sql 파일에 데이터 저장 중 오류가 발생했습니다. param=" + param + ", sourceSql=" + sourceSql + ", targetSql=" + targetSql + ", page=" + page, e);
			throw e;
		}
	}

	private void setSqlite(SqlSession sqlite, List<Map<String,Object>> list, String query, int subPage) {
		int pageSize = 20;

		int endPoint = subPage * pageSize;

		boolean isMore = true;

		if (list.size() <= endPoint) {
			endPoint = list.size();
			isMore = false;
		}

		List<Map<String,Object>> subList = list.subList((subPage-1) * pageSize, endPoint);

		if (subList != null && subList.size() > 0) {

			Map<String,Object> p = new HashMap<>();
			p.put("dataList", subList);
			sqlite.insert(query, p);

			if (isMore) {
				setSqlite(sqlite, list, query, ++subPage);
			}
		}

	}

	@Override
	public void downloadOrgChartZip(HttpServletRequest request, HttpServletResponse response, String groupSeq) throws IOException {
		String filePath = null;
		String zipFilePath = null;

		try {
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("groupSeq", groupSeq);
			filePath = (String) apiDAO.select(ORGCHART_QUERY_PREPIX+"getOrgchartPath", mp);

			logger.info("downloadOrgChart groupSeq=" +  groupSeq + ", filePath=" + filePath);

			zipFilePath = filePath.substring(0, filePath.indexOf("."))+".zip";

			String fileName[] = zipFilePath.split("/");
			response.reset();
			File file = new File(zipFilePath);
			logger.info("file length = " +  file.length());
			logger.info("fileName[fileName.length-1] = " +  fileName[fileName.length-1]);
			response.setContentType(CommonUtil.getContentType(file));
			response.setHeader("Content-Disposition", "attachment; filename="+ fileName[fileName.length-1]);
			response.setHeader("Content-Transfer-Encoding", "binary");
			response.setContentLength((int)file.length());

			OutputStream outputStream = response.getOutputStream();
			FileUtils.copyFile(file, outputStream);
		} catch (FileNotFoundException e) {
			logger.info("downloadOrgChart groupSeq=" +  groupSeq + ", zipFilePath=" + zipFilePath + " not found", e);
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

	}

	private String getIpList() {
		String ipList = null;
		try {
			Enumeration<NetworkInterface> nienum = NetworkInterface.getNetworkInterfaces();
			while (nienum.hasMoreElements()) {
				NetworkInterface ni = nienum.nextElement();
				Enumeration<InetAddress> kk= ni.getInetAddresses();
				while (kk.hasMoreElements()) {
					InetAddress inetAddress = kk.nextElement();
					String ip = inetAddress.getHostAddress();

					if (!ip.equals("127.0.0.1") && !ip.equals("0:0:0:0:0:0:0:1") && !ip.equals("::1")) {
						if (ipList == null) {
							ipList = ip;
						} else {
							ipList += ","+ip;
						}
					}
				}
			}

		} catch (SocketException e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		/** db 컬럼에 128 바이트까지지만 100자리로 자른다. */
		if (ipList != null && ipList.length() > 100) {
			ipList = ipList.substring(0, 100);
		}

		return ipList;
	}


    @SuppressWarnings("unchecked")
	@Override
    public APIResponse ebpSyncOrgchartAll(Map<String, Object> body) {
        logger.debug("ebpSyncOrgchartAll start : " + body);

        // sync 요청시간(웹서버 기준)
        String requestTime = DateUtil.getToday("yyyy-MM-dd HH:mm:ss");
        body.put("requestTime", requestTime);
        logger.debug("ebpSyncOrgchartAll request time = " + requestTime);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("groupSeq", body.get("groupSeq"));
        param.put("compSeq", body.get("compSeq"));
        param.put("serverDomain", body.get("serverDomain"));
        param.put("apiTp", "ebpSyncOrgchartAll");
        param.put("reqType", "param");
        param.put("erpCompSeq", body.get("erpCompSeq"));

        APIResponse response = new APIResponse();

        if (commonSql.select("EbpOrgchart.selectGroupCnt", param).equals("0")) {
            logger.debug("not group = " + param);
            response.setResultCode("UC0009");
            response.setResultMessage("group_seq가 존재하지 않습니다.");
            response.setResult(body);

            body.put("responseResultString", response.getResultString());
            body.put("responseResult", response.getResult().toString());
            param.put("reqType", "result");
            param.put("data", body.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);

            return response;
        }

        try {
            /*
             * oracle connect - erp 연동 부분 사용
             * 권한 관련 테이블 초기화
             * 조직도 관련 테이블 초기화
             * ERP 권한 조회 - 쿼리만 들어가면 ok 되도록
             * ERP 회사 - 사업장 - 부서 - 직급/직책 - 사용자 조회 - 쿼리만 들어가면 ok 되도록
             * alpha insert - orgadapter 함수사용
             * 권한-사용자 매핑, 관리자?, 마스터
             */

            Map<String, Object> dbInfo = new HashMap<String, Object>();
            dbInfo.put("databaseType", "oracle");
            dbInfo.put("compSeq", "ebp");
            dbInfo.put("achrGbn", "etc");

            dbInfo = erpOrgchartSyncService.getErpDbInfo(dbInfo);

            logger.debug("db 접속정보 : " + dbInfo);
            body.put("dbInfo", dbInfo.toString());
            param.put("data", body.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);

            EbpOrgchartDAOImpl ebpDAO = new EbpOrgchartDAOImpl();
            ebpDAO.setSqlSession(dbInfo);

            
            if(body.get("isDelYn") == null || body.get("isDelYn").equals("Y")) {
	            // 조직도 관련 테이블 초기화
	            // t_co_comp,multi | t_co_biz,multi | t_co_dept,multi | t_co_comp_duty_position,multi
	            // t_co_emp,multi | t_co_emp_dept,multi | t_co_emp_comp
	            body.put("deleteAllCompMultiCnt", commonSql.delete("EbpOrgchart.deleteAllCompMulti", param));
	            body.put("deleteAllCompCnt", commonSql.delete("EbpOrgchart.deleteAllComp", param));
	            body.put("deleteAllBizMultiCnt", commonSql.delete("EbpOrgchart.deleteAllBizMulti", param));
	            body.put("deleteAllBizCnt", commonSql.delete("EbpOrgchart.deleteAllBiz", param));
	            body.put("deleteAllDeptMultiCnt", commonSql.delete("EbpOrgchart.deleteAllDeptMulti", param));
	            body.put("deleteAllDeptCnt", commonSql.delete("EbpOrgchart.deleteAllDept", param));
	            body.put("deleteAllDutyPositionMultiCnt", commonSql.delete("EbpOrgchart.deleteAllDutyPositionMulti", param));
	            body.put("deleteAllDutyPositionCnt", commonSql.delete("EbpOrgchart.deleteAllDutyPosition", param));
	            body.put("deleteAllEmpOptionCnt", commonSql.delete("EbpOrgchart.deleteAllEmpOption", param));
	            body.put("deleteAllEmpCompCnt", commonSql.delete("EbpOrgchart.deleteAllEmpComp", param));
	            body.put("deleteAllEmpDeptMultiCnt", commonSql.delete("EbpOrgchart.deleteAllEmpDeptMulti", param));
	            body.put("deleteAllEmpDeptCnt", commonSql.delete("EbpOrgchart.deleteAllEmpDept", param));
	            body.put("deleteAllEmpMultiCnt", commonSql.delete("EbpOrgchart.deleteAllEmpMulti", param));
	            body.put("deleteAllEmpCnt", commonSql.delete("EbpOrgchart.deleteAllEmp", param)); // delete count 들어오는지 테스트용
	
	            // 권한 관련 테이블 초기화
	            // t_co_authcode,multi | t_co_auth_relate | t_co_menu_auth
	            body.put("deleteAllMenuAuthCnt", commonSql.delete("EbpOrgchart.deleteAllMenuAuth", param));
	            body.put("deleteAllAuthcodeMultiCnt", commonSql.delete("EbpOrgchart.deleteAllAuthcodeMulti", param));
	            body.put("deleteAllAuthcodeCnt", commonSql.delete("EbpOrgchart.deleteAllAuthcode", param));
	            body.put("deleteAllAuthRelateCnt", commonSql.delete("EbpOrgchart.deleteAllAuthRelate", param));
            }

            String groupSeq = (String) body.get("groupSeq");
            param.put("groupSeq", groupSeq);

            // 상시로그테이블 현재 쌓여있는 데이터까지 전체 APLY_YN=Y update를 위한 MAX(RECORD_SQ) 값
            param.put("queryid", "selectSyncListMaxSq");
            String maxRecordSq = String.valueOf(ebpDAO.selectOne(param).get("maxRecordSq"));

            if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSyncFlage").equals("99")) {
            	param.put("ebpSyncFlage", BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSyncFlage"));
            }
            
            // 조직도 조회시 커스텀 조건 처리 추가(21.12.24)
            this.FNCustomQueryCheck(param);
            
            // 조직도 커스텀 디비 옵션값 처리 추가(22.03.08)
            this.FNCustomOptionCheck(param);
            
            // 조직도 관련 테이블 추가
            param.put("queryid", "selectCompList");
            List<Map<String,Object>> compList = ebpDAO.selectList(param); // 회사
            param.put("queryid", "selectBizList");
            List<Map<String,Object>> bizList = ebpDAO.selectList(param); // 사업장
            param.put("queryid", "selectDeptList");
            List<Map<String,Object>> deptList = ebpDAO.selectList(param); // 부서
            param.put("queryid", "selectDutyPositionList");
            List<Map<String,Object>> dpList = ebpDAO.selectList(param); // 직급, 직책
            param.put("queryid", "selectEmpList");
            List<Map<String,Object>> empList = ebpDAO.selectList(param); // 사원

            // 회사
            // 회사 데이터로 biz 추가
            logger.debug("EbpOrgchart compSaveAdapter start : " + compList.size());
            for(Map<String,Object> loopMap : compList) {
                loopMap.put("compSeq", "");
                response = ebpOrgAdapter("compSaveAdapter", loopMap);

                if (!response.getResultCode().equals("SUCCESS")) {
                    param.put("reqType", "compSaveAdapter-fail");
                    param.put("data", response.getResultString() + " : " + response.getResult().toString());
                    commonSql.insert("EbpOrgchart.setApiLog", param);
                }
                
                // DB_NEOS 오류 수정(22.05.10)
                loopMap.put("DB_NEOS", param.get("DB_NEOS"));
                // 회사별 임시 직급, 직책 생성
                loopMap.put("dpType", "DUTY");
                commonSql.insert("EbpOrgchart.insertTmpDutyPosition", loopMap);
                commonSql.insert("EbpOrgchart.insertTmpDutyPositionMulti", loopMap);
                loopMap.put("dpType", "POSITION");
                commonSql.insert("EbpOrgchart.insertTmpDutyPosition", loopMap);
                commonSql.insert("EbpOrgchart.insertTmpDutyPositionMulti", loopMap);
            }
            param.put("reqType", "compSaveAdapter");
            param.put("data", compList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart compSaveAdapter end");

            // 사업장 -> deptSaveAdapter 안에 biz 관련 코드 있음. deptType = "B"
            logger.debug("EbpOrgchart bizSaveAdapter start : " + bizList.size());
            for(Map<String,Object> loopMap : bizList) {
                loopMap.put("deptSeq", "");
                response = ebpOrgAdapter("deptSaveAdapter", loopMap);

                if (!response.getResultCode().equals("SUCCESS")) {
                    param.put("reqType", "bizSaveAdapter-fail");
                    param.put("data", response.getResultString() + " : " + response.getResult().toString());
                    commonSql.insert("EbpOrgchart.setApiLog", param);
                }
            }
            param.put("reqType", "bizSaveAdapter");
            param.put("data", bizList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart bizSaveAdapter end");

            // 부서
            logger.debug("EbpOrgchart deptSaveAdapter start : " + deptList.size());
            for(Map<String,Object> loopMap : deptList) {
                loopMap.put("deptSeq", "");
                response = ebpOrgAdapter("deptSaveAdapter", loopMap);

                if (!response.getResultCode().equals("SUCCESS")) {
                    param.put("reqType", "deptSaveAdapter-fail");
                    param.put("data", response.getResultString() + " : " + response.getResult().toString());
                    commonSql.insert("EbpOrgchart.setApiLog", param);
                }
            }
            param.put("reqType", "deptSaveAdapter");
            param.put("data", deptList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart deptSaveAdapter end");

            // 직급, 직책
            logger.debug("EbpOrgchart dutyPositionSaveAdapter start : " + dpList.size());
            for(Map<String,Object> loopMap : dpList) {
                loopMap.put("dpSeq", "");
                response = ebpOrgAdapter("dutyPositionSaveAdapter", loopMap);

                if (!response.getResultCode().equals("SUCCESS")) {
                    param.put("reqType", "dutyPositionSaveAdapter-fail");
                    param.put("data", response.getResultString() + " : " + response.getResult().toString());
                    commonSql.insert("EbpOrgchart.setApiLog", param);
                }
            }
            param.put("reqType", "dutyPositionSaveAdapter");
            param.put("data", dpList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart dutyPositionSaveAdapter end");

            // 사원
            // deptSeq 값이 없거나 해당 deptSeq가진 부서가 없으면 추가 안됨(orgAdapter)
            // 1111 암호화 : D/4avRoIIVNTwjPW4AlhPpXuxCU4Mqdhryj/N6xaFQw=
            String nowEmpSeq = ""; // 겸직 정보를 찾기 위해서 사용 -> 조회쿼리에 empSeq로 orderby 필요
            logger.debug("EbpOrgchart empSaveAdapter start : " + empList.size());
            
            for(Map<String,Object> loopMap : empList) {
                loopMap.put("empSeq", "");
                if (nowEmpSeq.equals(loopMap.get("empSeqDef"))) {
                    loopMap.put("empSeq", loopMap.get("empSeqDef"));
                    loopMap.put("deptSeqNew", loopMap.get("deptSeq"));
                    loopMap.put("deptSeq", "");
                    loopMap.put("callType", "addEmpDept"); // 1626행 안걸리고 1777행 걸려야됨
                }
                
                if(!"".equals(param.get("passwd"))) {
                	loopMap.put("loginPasswdNew", param.get("passwd"));
                	loopMap.put("apprPasswdNew", param.get("passwd"));
                	loopMap.put("payPasswdNew", param.get("passwd"));
                }
                
                response = ebpOrgAdapter("empSaveAdapter", loopMap);
                nowEmpSeq = (String) loopMap.get("empSeqDef");

                if (!response.getResultCode().equals("SUCCESS")) {
                    param.put("reqType", "empSaveAdapter-fail");
                    param.put("data", response.getResultString() + " : " + response.getResult().toString());
                    commonSql.insert("EbpOrgchart.setApiLog", param);
                }
            }
            commonSql.insert("EbpOrgchart.updateEmpPasswdStatusCodeAll", param);

            param.put("reqType", "empSaveAdapter");
            param.put("data", empList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart empSaveAdapter end");

            // 권한관련
            param.put("queryid", "selectAuthList");
            List<Map<String,Object>> authList = ebpDAO.selectList(param); // 권한
            logger.debug("EbpOrgchart insertAuthcode/insertAuthcodeMulti start : " + authList.size());
            for(Map<String,Object> loopMap : authList) {
                commonSql.insert("EbpOrgchart.insertAuthcode", loopMap);
                commonSql.insert("EbpOrgchart.insertAuthcodeMulti", loopMap);
            }
            param.put("reqType", "selectAuthList");
            param.put("data", authList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart insertAuthcode/insertAuthcodeMulti end");

            param.put("queryid", "selectAuthRelateList");
            List<Map<String,Object>> authRelateList = ebpDAO.selectList(param); // 권한 매핑
            logger.debug("EbpOrgchart insertAuthRelate start : " + authRelateList.size());
            for(Map<String,Object> loopMap : authRelateList) {
                commonSql.insert("EbpOrgchart.insertAuthRelate", loopMap);

                // author_tp = "M" 이면 t_co_emp_option 추가
                if (loopMap.get("authorTp").equals("M") || loopMap.get("authorTp") == "M") {
                    commonSql.insert("EbpOrgchart.insertEmpOption", loopMap);
                }
            }
            param.put("reqType", "selectAuthRelateList");
            param.put("data", authRelateList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart insertAuthRelate end");

            // 메뉴 권한 매핑
            param.put("queryid", "selectMenuAuthList");
            List<Map<String,Object>> menuAuthList = ebpDAO.selectList(param); // 권한 매핑
            logger.debug("EbpOrgchart.insertMenuAuth start : " + menuAuthList.size());
            for(Map<String,Object> loopMap : menuAuthList) {
                commonSql.insert("EbpOrgchart.insertMenuAuth", loopMap);
            }
            param.put("reqType", "selectMenuAuthList");
            param.put("data", menuAuthList.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);
            logger.debug("EbpOrgchart.insertMenuAuth end");

            // 전체 동기화 완료후 CI_TBHST_INFO 테이블 전체 데이터 동기화 완료처리
            // sq를 시작전에 조회하고 전체 처리 후에 update
            param.put("queryid", "updateSyncAplyComplete");
            param.put("syncAll", "Y");
            param.put("updateId", "ebpOrgchartSyncAll");
            param.put("recordSq", maxRecordSq);
            ebpDAO.update(param); // sync 적용 완료 Y 처리

            // 전체 완료
            response.setResultCode("SUCCESS");
            response.setResultMessage("등록이 완료 되었습니다");
            response.setResult("ebpSyncOrgchartAll End");

        } catch (Exception e) {
            logger.debug("ebpSyncOrgchartAll Exception : " + e.getMessage());
            response.setResultCode("UC0000");
            response.setResult("Exception");
            response.setResultMessage(e.getMessage());
        }

        logger.debug("ebpSyncOrgchartAll end : " + response.getResultString());

        body.put("responseResultString", response.getResultString());
        body.put("responseResult", response.getResult().toString());
        param.put("reqType", "result");
        param.put("data", body.toString());
        commonSql.insert("EbpOrgchart.setApiLog", param);

        return response;
    }

    @SuppressWarnings("unchecked")
	@Override
    public APIResponse ebpSyncOrgchart(Map<String, Object> body) {

        logger.debug("ebpSyncOrgchart start : " + body);

        // sync 요청시간(웹서버 기준)
        String requestTime = DateUtil.getToday("yyyy-MM-dd HH:mm:ss"); // ex) 2019-04-05 19:28:04
        body.put("requestTime", requestTime);
        logger.debug("ebpSyncOrgchart request time = " + requestTime);

        Map<String, Object> param = new HashMap<String, Object>();
        param.put("groupSeq", body.get("groupSeq"));
        param.put("apiTp", "ebpSyncOrgchart");
        param.put("reqType", "param");
        param.put("erpCompSeq", body.get("erpCompSeq"));

        APIResponse response = new APIResponse();

        if (commonSql.select("EbpOrgchart.selectGroupCnt", param).equals("0")) {
            logger.debug("not group = " + param);
            response.setResultCode("UC0009");
            response.setResultMessage("group_seq가 존재하지 않습니다.");
            response.setResult(body);

            body.put("responseResultString", response.getResultString());
            body.put("responseResult", response.getResult().toString());
            param.put("reqType", "result");
            param.put("data", body.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);

            return response;
        }

        try {
            /*
             * oracle connect - erp 연동 부분 사용
             * CI_TBHST_INFO에서 APLY_YN = 'N' 조회
             * t_co_group_api_history에 조회 내용 입력
             * alpha insert - orgadapter 함수사용
             * t_co_group_api_history에 insert 결과 입력
             */
            Map<String, Object> dbInfo = new HashMap<String, Object>();
            dbInfo.put("databaseType", "oracle");
            dbInfo.put("compSeq", "ebp");
            dbInfo.put("achrGbn", "etc");

            dbInfo = erpOrgchartSyncService.getErpDbInfo(dbInfo);

            logger.debug("db 접속정보 : " + dbInfo);
            body.put("dbInfo", dbInfo.toString());
            param.put("data", body.toString());
            commonSql.insert("EbpOrgchart.setApiLog", param);

            EbpOrgchartDAOImpl ebpDAO = new EbpOrgchartDAOImpl();
            ebpDAO.setSqlSession(dbInfo);

            String groupSeq = (String) param.get("groupSeq");

            // 연동 log table 확인
            // 20190507 변경 -  조회한 데이터중
            param.put("queryid", "selectSyncList");
            List<Map<String,Object>> syncList = ebpDAO.selectList(param); // 회사
            logger.debug("ebpSyncOrgchart Sync List Count : " + syncList.size());

            if (syncList.size() == 0) {
                response.setResultCode("ER0000");
                response.setResultMessage("NO SYNC DATA");
                response.setResult(syncList);

                // 건당  t_co_group_api_history 테이블에 response 입력
                body.put("responseResultString", response.getResultString());
                body.put("responseResult", response.getResult().toString());
                param.put("reqType", "result");
                param.put("data", body.toString());
                commonSql.insert("EbpOrgchart.setApiLog", param);

                return response;
            }

            param.put("reqType", "selectSyncList");
            param.put("data", syncList.toString());
            logger.debug("ebpSyncOrgchart param : " + param);
            commonSql.insert("EbpOrgchart.setApiLog", param);

            // I or U : 데이터 확인 -> 있으면 UPDATE, 없으면 INSERT
            // D : 데이터 확인 -> 있으면 USE_YN = N | 사용자 workStatus = 001, 없으면 END
            // I or U일때는 ERP쪽에 데이터가 남아 있어 eventKey로 조회가 가능하지만, D일경우 ERP에 이미 삭제가 되었을 경우도 있어 ERP에 조회 X
            // 회사, 사업장, 부서 , 직급, 직책 : selectone | 사용자, 권한 : selectList
            for(Map<String,Object> loopMap : syncList) {
            	
            	boolean flag = true;
            	
                loopMap.put("groupSeq", groupSeq);

                // 조직도 조회시 커스텀 조건 처리 추가(21.12.24)
                this.FNCustomQueryCheck(loopMap);
                
                // 조직도 커스텀 디비 옵션값 처리 추가(22.03.08)
                this.FNCustomOptionCheck(loopMap);
                
                switch ((String)loopMap.get("tableId")) {
                // 회사
                case "CI_COMPANY" :
                	try {
	                	loopMap.put("evntKeyValTxt", loopMap.get("evntKeyValTxt").toString().split("\\|")[0]);
	                	
	                    Map<String, Object> compList = new HashMap<String, Object>();
	                    if (loopMap.get("evntFg").equals("D")) {
	                        //System.out.println("CI_COMPANY -------------------- D");
	                        compList.put("groupSeq", groupSeq);
	                        compList.put("compSeq", loopMap.get("evntKeyValTxt"));
	                        if ( orgAdapterDAO.getCompCnt( compList ).equals( "0" ) ) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당  회사 데이터 없음. comp_seq:" + compList.get("compSeq"));
	                        	flag = false;
	                        }
	                        else {
	                            commonSql.update("EbpOrgchart.deleteComp", compList);
	                            commonSql.update("EbpOrgchart.deleteCompMulti", compList);
	
	                            response.setResult(compList);
	                            response.setResultCode("SUCCESS");
	                            response.setResultMessage("회사 삭제 동기화 완료");
	                        }
	                    }
	                    else {
	                        //System.out.println("CI_COMPANY -------------------- I or U");
	                        loopMap.put("queryid", "selectCompList");
	                        compList = ebpDAO.selectOne(loopMap);
	
	                        // ERP 데이터 null 여부
	                        if (compList == null || compList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 comp_seq 회사 없음. comp_seq:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        if ( orgAdapterDAO.getCompCnt( compList ).equals( "0" ) ) {
		                            compList.put("compSeq", ""); // compSeqDef로 신규 등록
		                        }
		                        else {
		                            compList.put("compSeqDef", "");
		                            compList.put("useYn", null);
		                            
		                            try {
		                            	
		                            	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustomColumns").equals("99")) {
				                            /**
				                             * 2022-04-06 김택주 연구원
				                             * 최초 ERP10 연동 이후 ERP10 연동 시 변경되면 안되는 컬럼들 제거
				                             */
				                            String[] removeColumnList = new String[] {
				                            			"eaType", // 비영리회사가 영리로 계속 고정 업데이트되어 eaType은 업데이트 제외 (21.12.21)
				                            			"compEmailYn", // 회사 수정시 compEmailYn, smsUseYn 사용여부가 N으로 고정 업데이터 되어 해당 컬럼 업데이트 제외(22.02.14)
				                            			"smsUseYn", 
				                            			
				                            			// 김봉진 차장님 요청
				                            			"parentCompSeq",
				                            			"standardCompSeq", 
				                            			"erpUse", 
				                            			"homepgAddr",
				                            			"compMailUrl",
				                            			"emailDomain",
				                            			"smsId",
				                            			"smsPasswd",
				                            			"nativeLangCode",
				                            			"orderNum",
				                            			"useYn",
				                            			"createSeq",
				                            			"createDate",
				                            			"erpUseYN",
				                            			"smsUseYN",
				                            			"langCode",
				                            			"senderName",
				                            			"compNickname",
				                            			"erpUseYn"
				                            };
			                            
				                            // 회사 정보 리스트에서 위 컬럼 내용들 존재할경우 제거
				                            for(int i = 0, len = removeColumnList.length; i < len; i++) {
				                            	removeNonInterlockingColumns(compList, removeColumnList[i]);
				                            }
		                            	}
		                            
			                        }catch(Exception e) {
	    	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart 회사 변경되지않을컬럼 수정중 에러: " + compList.toString());
	                            	}
		                            
		                            // 비영리회사가 영리로 계속 고정 업데이트되어 eaType은 업데이트 제외 (21.12.21)
		                            if(compList.containsKey("eaType")) {
		                                compList.remove("eaType");
		                            }
		                            // 회사 수정시 compEmailYn, smsUseYn 사용여부가 N으로 고정 업데이터 되어 해당 컬럼 업데이트 제외(22.02.14)
		                            if(compList.containsKey("compEmailYn")) {
		                            	compList.remove("compEmailYn");
		                            }
		                            if(compList.containsKey("smsUseYn")) {
		                            	compList.remove("smsUseYn");
		                            }
		                        }
		                        response = ebpOrgAdapter("compSaveAdapter", compList);
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                // 사업장 deptType = "B": orgAdapter 사용을 위해, evntKeyValTxt = 1000
                case "MA_BIZAREA_MST" :
                	try {
	                    Map<String, Object> bizList = new HashMap<String, Object>();
	                    loopMap.put("evntKeyValTxt", loopMap.get("evntKeyValTxt").toString().split("\\|")[0]);
	                    String bizSeq = loopMap.get("companyCd") + "-" + loopMap.get("evntKeyValTxt");
	
	                    if (loopMap.get("evntFg").equals("D")) {
	                        //System.out.println("MA_BIZAREA_MST -------------------- D");
	                        bizList.put("groupSeq", groupSeq);
	                        bizList.put("bizSeq", bizSeq);
	                        if ( orgAdapterDAO.getBizCnt( bizList ).equals( "0" ) ) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당  사업장 데이터 없음. biz_seq:" + bizList.get("bizSeq"));
	                        	flag = false;
	                        }
	                        else {
	                            commonSql.update("EbpOrgchart.deleteBiz", bizList);
	                            commonSql.update("EbpOrgchart.deleteBizMulti", bizList);
	
	                            response.setResult(bizList);
	                            response.setResultCode("SUCCESS");
	                            response.setResultMessage("사업장 삭제 동기화 완료");
	                        }
	                    }
	                    else {
	                        //System.out.println("MA_BIZAREA_MST -------------------- I or U");
	                        loopMap.put("queryid", "selectBizList");
	                        bizList = ebpDAO.selectOne(loopMap);
	
	                        // ERP 데이터 null 여부
	                        if (bizList == null || bizList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 biz_seq 사업장 없음. biz_seq:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        bizList.put("bizSeq", bizList.get("deptSeq"));
		                        logger.debug("bizList : " + bizList);
		
		                        if ( orgAdapterDAO.getBizCnt( bizList ).equals( "0" ) ) {
		                            bizList.put("deptSeq", "");
		                            bizList.put("bizSeq", ""); // deptSeqDef로  biz_seq 신규 등록
		                        }
		                        else {
		                            bizList.put("deptSeqDef", "");
		                            
		                            try {
		                            	
		                            	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustomColumns").equals("99")) {
	
				                            /**
				                             * 2022-04-06 김택주 연구원
				                             * 김봉진 차장님 요청
				                             * 최초 ERP10 연동 이후 ERP10 연동 시 변경되면 안되는 컬럼들 제거
				                             */
				                            String[] removeColumnList = new String[] {
				                            		
				                            		"compNum",
				                            		"homepgAddr",
				                            		"nativeLangCode",
				                            		"sealFileId",
				                            		"createSeq",
				                            		"createDate",
				                            		"langCode",
				                            		"senderName",
				                            		"bizNickname"
				                            };
				                            
				                            for(int i = 0, len = removeColumnList.length; i < len; i++) {
				                            	removeNonInterlockingColumns(bizList, removeColumnList[i]);
				                            }
		                            	}
		                            
			                        }catch(Exception e) {
	    	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart 사업장 변경되지않을컬럼 수정중 에러: " + bizList.toString());
	                            	}
		                        }
		                       
		                        response = ebpOrgAdapter("deptSaveAdapter", bizList);
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                // 부서 evntKeyValTxt = 802030,20150101
                case "MA_DEPT_MST" :
                	try {
	                    Map<String, Object> deptList = new HashMap<String, Object>();
	
	                    String dEvntKeyValTxt = (String) loopMap.get("evntKeyValTxt");
	                    String [] dTokens = dEvntKeyValTxt.split("\\|");
	                    loopMap.put("deptCd", dTokens[0].trim());
	                    loopMap.put("deptStartDt", dTokens[1].trim());
	                    //System.out.println("deptSeq:" + dTokens[0].trim() + ", deptStartDt:" + dTokens[1].trim());
	
	                    String deptSeq = loopMap.get("companyCd") + "-" + loopMap.get("deptCd");
	
	                    if (loopMap.get("evntFg").equals("D")) {
	                        //System.out.println("MA_DEPT_MST -------------------- D");
	                        deptList.put("deptSeq", deptSeq);
	                        deptList.put("groupSeq", groupSeq);
	                        if ( orgAdapterDAO.getDeptCnt( deptList ).equals( "0" ) ) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당  부서 데이터 없음. dept_seq:" + deptList.get("deptSeq"));
	                        	flag = false;
	                        }
	                        else {
	                            commonSql.update("EbpOrgchart.deleteDept", deptList);
	                            commonSql.update("EbpOrgchart.deleteDeptMulti", deptList);
	
	                            response.setResult(deptList);
	                            response.setResultCode("SUCCESS");
	                            response.setResultMessage("부서 삭제 동기화 완료");
	                        }
	                    }
	                    else {
	                        //System.out.println("MA_DEPT_MST -------------------- I or U");
	                        loopMap.put("queryid", "selectDeptList");
	                        deptList = ebpDAO.selectOne(loopMap);
	
	                        // ERP 데이터 null 여부
	                        if (deptList == null || deptList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 dept_seq 부서 없음. dept_seq:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        logger.debug("deptList : " + deptList);
		
		                        if ( orgAdapterDAO.getDeptCnt( deptList ).equals( "0" ) ) {
		                            deptList.put("deptSeq", "");// deptSeqDef로 신규 등록
		                        }
		                        else {
		                            deptList.put("deptSeqDef", "");
		                            
		                            try {
		                            	
		                            	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustomColumns").equals("99")) {

				                            /**
				                             * 2022-04-06 김택주 연구원
				                             * 김봉진 차장님 요청
				                             * 최초 ERP10 연동 이후 ERP10 연동 시 변경되면 안되는 컬럼들 제거
				                             */
				                            String[] removeColumnList = new String[] {
				                            		
				                            		"homepgAddr",
				                            		"zipCode",
				                            		"susinYn",
				                            		"virDeptYn",
				                            		"teamYn",
				                            		"eaYn",
				                            		"nativeLangCode",
				                            		"path",
				                            		"ptype",
				                            		"deptLevel",
				                            		"innerReceiveYn",
				                            		"createSeq",
				                            		"createDate",
				                            		"displayYn",
				                            		"standardCode",
				                            		"langCode",
				                            		"senderName",
				                            		"addr",
				                            		"detailAddr",
				                            		"pathName",
				                            		"deptNickname"
				                            };
				                            
				                            for(int i = 0, len = removeColumnList.length; i < len; i++) {
				                            	removeNonInterlockingColumns(deptList, removeColumnList[i]);
				                            }
		                            	}
		                            
			                        }catch(Exception e) {
	    	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart 부서 변경되지않을컬럼 수정중 에러: " + deptList.toString());
	                            	}

		                        }
		
		                        response = ebpOrgAdapter("deptSaveAdapter", deptList);
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                // 직위(POSI_CD) - evntKeyValTxt = HR,P00640,11
                // 직급(PSTN_CD) - evntKeyValTxt = HR,P00650,11
                // 직책(ODTY_CD) - evntKeyValTxt = HR,P00980,11
                case "MA_CODEDTL" :
                	try {
	                    String pEventKey = (String) loopMap.get("evntKeyValTxt");
	                    String [] pTokens = pEventKey.split("\\|");
	                    loopMap.put("moduleCd", pTokens[0].trim());
	                    loopMap.put("fieldCd", pTokens[1].trim());
	                    loopMap.put("sysdefCd", pTokens[2].trim());
	                    //System.out.println("moduleCd:" + pTokens[0].trim() + ", fieldCd:" + pTokens[1].trim() + ", sysdefCd:" + pTokens[2].trim());
	
	                    String dpSeq = loopMap.get("companyCd") + "-" + loopMap.get("sysdefCd");
	                    String dpType = loopMap.get("fieldCd").equals("P00650")?"POSITION":"DUTY";
	
	                    Map<String, Object> dutyPositionList = new HashMap<String, Object>();
	
	                    if (loopMap.get("evntFg").equals("D")) {
	                        //System.out.println("MA_CODEDTL -------------------- D");
	                        dutyPositionList.put("groupSeq", groupSeq);
	                        dutyPositionList.put("dpSeq", dpSeq);
	                        dutyPositionList.put("dpType", dpType);
	                        if ( orgAdapterDAO.getDutyPositionCnt( dutyPositionList ).equals( "0" ) ) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당  직급 / 직책 데이터 없음. dp_seq:" + dutyPositionList.get("dpSeq")
	                            + ", dp_type:" + dutyPositionList.get("dpType"));
	                        	flag = false;
	                        }
	                        else {
	                            commonSql.update("EbpOrgchart.deleteDutyPosition", dutyPositionList);
	                            commonSql.update("EbpOrgchart.deleteDutyPositionMulti", dutyPositionList);
	
	                            response.setResult(dutyPositionList);
	                            response.setResultCode("SUCCESS");
	                            response.setResultMessage("직급, 직책 삭제 동기화 완료");
	                        }
	                    }
	                    else {
	                        //System.out.println("MA_CODEDTL -------------------- I or U");
	                        loopMap.put("queryid", "selectDutyPositionList");
	                        dutyPositionList = ebpDAO.selectOne(loopMap);
	
	                        // ERP 데이터 null 여부
	                        if (dutyPositionList == null || dutyPositionList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 dp_seq, dp_type 직급  / 직책 없음. dp_type,dp_seq:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        logger.debug("dutyPositionList : " + dutyPositionList);
		
		                        if ( orgAdapterDAO.getDutyPositionCnt( dutyPositionList ).equals( "0" ) ) {
		                            dutyPositionList.put("dpSeq", ""); // dpSeqDef로 신규 등록
		                        }
		                        else {
		                            dutyPositionList.put("dpSeqDef", "");
		                        }
		
		                        response = ebpOrgAdapter("dutyPositionSaveAdapter", dutyPositionList);
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                // 사용자
                case "HR_EMP_MST" :
                	try {
	                    Map<String, Object> empMap = new HashMap<String, Object>();
	                    loopMap.put("evntKeyValTxt", loopMap.get("evntKeyValTxt").toString().split("\\|")[0]);
	                    
	                    String erpEmpSeq = (String) loopMap.get("evntKeyValTxt");
	                    String erpCompSeq = (String) loopMap.get("companyCd");
	                    
	                    // 겸직으로 인해 여러건 조회될수 있음
	                    // 겸직 생각 X > 사원 D로 들어오면 무조건 use_yn:N, work_status:001, login_id/email_addr : ▦ 추가
	                    // t_co_emp만 use_yn D로 입력, login_id/email_addr + ▦ + emp_seq 되도록 수정(22.02.14)
	                    // 사용자-권한 매핑은 일단 삭제X
	                    if (loopMap.get("evntFg").equals("D")) {
	                        //System.out.println("HR_EMP_MST -------------------- D");
	                        empMap.put("erpEmpSeq", erpEmpSeq);
	                        empMap.put("erpCompSeq", erpCompSeq);
	                        empMap.put("groupSeq", groupSeq);
	                        
	                        Map<String, Object> getEmpInfoMap = orgAdapterDAO.getEmpInfo(empMap);
	                        
	                        if ( getEmpInfoMap == null ) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당  사원 데이터 없음. emp_seq:" + empMap.get("empSeqDef"));
	                        	flag = false;
	                        }
	                        else {
	                            empMap.put("empSeq", getEmpInfoMap.get("empSeq"));
	                            commonSql.update("EbpOrgchart.deleteEmp", empMap);
	                            commonSql.update("EbpOrgchart.deleteEmpMulti", empMap);
	                            commonSql.update("EbpOrgchart.deleteEmpDept", empMap);
	                            commonSql.update("EbpOrgchart.deleteEmpDeptMulti", empMap);
	                            commonSql.update("EbpOrgchart.deleteEmpComp", empMap);
	                            //                            commonSql.update("EbpOrgchart.deleteAllAuthRelate", empMap);
	
	                            response.setResult(empMap);
	                            response.setResultCode("SUCCESS");
	                            response.setResultMessage("사용자 삭제 동기화 완료");
	                        }
	                    }
	                    else {
	                        //System.out.println("HR_EMP_MST -------------------- I or U");
	                        
	                        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSyncFlage").equals("99")) {
	                        	loopMap.put("ebpSyncFlage", BizboxAProperties.getCustomProperty("BizboxA.Cust.ebpSyncFlage"));
	                        }
	                        
	                        /**
	                         * 2022-04-29 SK핀크스 요청
	                         * 고용형태 기본 '4': 해당없음 이 아닌 '1': 정규직으로 저장될 수 있도록 옵션 처리
	                         */
	                        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10StatusCode").equals("99")) {
	                        	loopMap.put("erp10StatusCode", "Y");
	                        }
	                        
	                        /**
	                         * 2022-04-29 SK핀크스 요청
	                         * 전화번호 기존 mobileTelNum에만 저장되는것을 집 전화번호(homeTelNum) 까지 저장 될 수 있도록 옵션 처리
	                         */
	                        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10HomeTelNum").equals("99")) {
	                        	loopMap.put("erp10HomeTelNum", "Y");
	                        }
	                        
	                        /**
	                         * 2022-05-04 SK핀크스 요청
	                         * 회사 전화번호 연동 처리 패키지화 될수 없으므로 옵션으로 처리
	                         * ERP10 회사 전화번호가 들어있는 테이블이 사용자가 수정할때마다 계속 데이터가 쌓이며 회사전화번호를 구분할 수 있는 값이 고객사마다 다름
	                         */
	                        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10SKpinx").equals("99")) {
	                        	loopMap.put("erp10SKpinx", "Y");
	                        }
	                        
	                        loopMap.put("queryid", "selectEmpList");
	                        List<Map<String,Object>> empList = ebpDAO.selectList(loopMap); // 사원
	
	                        // ERP 데이터 null 여부
	                        if (empList == null || empList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 emp_seq 부서 없음. emp_seq:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        logger.debug("empList : " + empList);
		
		                        //String nowEmpSeq = ""; // 겸직 정보를 찾기 위해서 사용 -> 조회쿼리에 empSeq로 orderby 필요
		                        for(Map<String,Object> empListMap : empList) {
		                            // uc 갯수 확인
		                            if ( orgAdapterDAO.getEmpDefCnt( empListMap ).equals( "0" ) ) {
		                                empListMap.put("empSeq", "");// empSeqDef로 신규 등록
		                                
		                                //기본비밀번호 셋팅(옵션 - derp0001)
		                                if(!"".equals(loopMap.get("passwd"))) {
		                                	empListMap.put("loginPasswdNew", loopMap.get("passwd"));
		                                	empListMap.put("apprPasswdNew", loopMap.get("passwd"));
		                                	empListMap.put("payPasswdNew", loopMap.get("passwd"));
		                                }
		                            }else {
		                            	//사용자 수정일경우 미연동항목 null처리
		                            	empListMap.put("nativeLangCode", null);
		                            	empListMap.put("passwdStatusCode",null);
		                            	empListMap.put("signFileId",null);
		                            	empListMap.put("picFileId",null);
		                            	empListMap.put("checkWorkYn", null);
		                            	empListMap.put("loginPasswdNew", null);
		                            	empListMap.put("apprPasswdNew", null);
		                            	empListMap.put("payPasswdNew", null);
		                            	empListMap.put("loginPasswd", null);
		                            	empListMap.put("apprPasswd", null);
		                            	empListMap.put("payPasswd", null);
		                            	empListMap.put("emailAddr", null);
		                            	empListMap.put("messengerUseYn", null);
		                            	empListMap.put("mobileUseYn", null);
		                            	empListMap.put("mainCompSeq", null);
		                            	empListMap.put("mainCompLoginYn", null);
		                            	empListMap.put("mainCompYn", null);
		                            	// 외부메일 최초 동기화 이후 동기화로 삭제 안되도록 처리(21.12.28 -이돈행부장 요청)
		                            	empListMap.put("outMail", null);
		                            	empListMap.put("outDomain", null);
		                            	
		                            	
		                            	try {
		                            		
			                            	if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustomColumns").equals("99")) {

			                            		/**
			                            		 * 2022-04-06 김택주 연구원
			                            		 * 김봉진 차장님 요청
			                            		 * 최초 ERP10 연동 이후 ERP10 연동 시 변경되면 안되는 컬럼들 제거
			                            		 */
			                            		empListMap.put("passwdDate", null);
			                            		empListMap.put("passwdInputFailCount", null);
			                            		empListMap.put("shift", null);
			                            		empListMap.put("jobCode", null);
			                            		empListMap.put("statusCode", null);
			                            		empListMap.put("passwdDate", null);
			                            		empListMap.put("licenseCheckYn", null);
			                            		empListMap.put("workStatus", null);
			                            		empListMap.put("homeTelNum", null);
			                            		empListMap.put("privateYn", null);
			                            		empListMap.put("useYn", null);
			                            		empListMap.put("lsRoleId", null);
			                            		empListMap.put("createSeq", null);
			                            		empListMap.put("createDate", null);
			                            		empListMap.put("springSecu", null);
			                            		empListMap.put("springDate", null);
			                            		empListMap.put("signType", null);
			                            		empListMap.put("blockDate", null);
			                            		empListMap.put("lastLoginDate", null);
			                            		empListMap.put("prevLoginPasswd", null);
			                            		empListMap.put("lastResignDay", null);
			                            		empListMap.put("lastEmpName", null);
			                            		empListMap.put("lastDeptSeq", null);
			                            		empListMap.put("lastDeptName", null);
			                            		empListMap.put("lastDeptPath", null);
			                            		empListMap.put("langCode", null);
			                            		empListMap.put("mainWork", null);
			                            		empListMap.put("gerpNoGemp", null);
			                            		empListMap.put("mailDelYn", null);
			                            		//empListMap.put("telNum", null);
			                            		empListMap.put("faxNum", null);
			                            		empListMap.put("orgchartDisplayYn", null);
			                            		empListMap.put("messengerDisplayYn", null);
			                            		empListMap.put("eaDisplayYn", null);
			                            		empListMap.put("orderNum", null);
			                            		empListMap.put("orderText", null);
			                            	}
		                            	}catch(Exception e) {
		    	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart 사용자 변경되지않을컬럼 수정중 에러: " + empListMap.toString());
		                            	}


		                            	//기존 부서정보 조회
		                            	Object empMainDeptInfo = commonSql.select("OrgAdapterManage.selectEmpMainDeptInfo", empListMap );
		                            	
		                            	if(empMainDeptInfo == null) {
		                            		empListMap.put("deptSeqNew", empListMap.get("deptSeq"));	                            	
		                            		empListMap.put("deptSeq", "");		                            		
		                            	}else {	                            	
			                            	empListMap.put("deptSeqNew", empListMap.get("deptSeq"));	                            	
		                            		empListMap.put("deptSeq", ((Map<String, Object>)empMainDeptInfo).get("deptSeq"));
		                            	}
		                            	
		                            }
		                            
		                            response = ebpOrgAdapter("empSaveAdapter", empListMap);
		                            //nowEmpSeq = (String) empListMap.get("empSeqDef");
		                        }
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                // 권한 (권한코드 : BASAUT00400 | 사용자-권한 : BASAUT00500 | 메뉴-권한 : BASAUT00200, BASAUT00600)
                case "MA_GROUP_MST" :
                	try {
	                    Map<String, Object> authMap = new HashMap<String, Object>();
	                    loopMap.put("evntKeyValTxt", loopMap.get("evntKeyValTxt").toString().split("\\|")[0]);
	                    
	                    String authorUCode = loopMap.get("companyCd") + "-U-" + loopMap.get("evntKeyValTxt");
	                    String authorACode = loopMap.get("companyCd") + "-A-" + loopMap.get("evntKeyValTxt");
	                    String authorMCode = loopMap.get("companyCd") + "-M-" + loopMap.get("evntKeyValTxt");
	
	                    authMap.put("authorUCode", authorUCode);
	                    authMap.put("authorACode", authorACode);
	                    authMap.put("authorMCode", authorMCode);
	                    authMap.put("compSeq", loopMap.get("companyCd"));
	                    authMap.put("groupSeq", groupSeq);
	
	                    authMap.put("codeMultiple", "N");
	
	                    // 권한코드의 경우 companyCd와 menugrpCd만 들어오기 때문에  I,U,D 로 구분하여 처리할 수 있지만
	                    // 사용자매핑 | 메뉴매핑 의 경우에는 개별적인 구분값(userId or menuCd)이 없기 때문에 I,U,D 구분없이 All Delete > Select Insert 로 실행 하는것으로 작성
	
	                    // 권한코드 BASAUT00400
	                    if (loopMap.get("evntOcrnFgCd").equals("BASAUT00400")) {
	                        // D
	                        if (loopMap.get("evntFg").equals("D")) {
	                            //System.out.println("MA_GROUP_MST-AUTHCODE -------------------- D");
	
	                            if (commonSql.select("EbpOrgchart.getAuthcodeCnt", authMap).equals("0")) {
	                            	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error UC 해당 권한 데이터 없음. author-U-code:" + authMap.get("authorUCode")
	                                + " author-A-code:" + authMap.get("authorACode") + " author-M-code:" + authMap.get("authorMCode"));
	                            	flag = false;
	                            }
	                            else {
	                                authMap.put("codeMultiple", "Y");
	                                commonSql.update("EbpOrgchart.deleteAuthcode", authMap);
	
	                                response.setResult(authMap);
	                                response.setResultCode("SUCCESS");
	                                response.setResultMessage("권한 코드 삭제 동기화 완료");
	                            }
	                        }
	                        // I or U
	                        else {
	                            //System.out.println("MA_GROUP_MST-AUTHCODE -------------------- I or U");
	
	                            param.put("queryid", "selectAuthList");
	                            List<Map<String,Object>> authList = ebpDAO.selectList(param); // 권한 코드
	
	                            // ERP 데이터 null 여부
	                            if (authList == null || authList.isEmpty()) {
	                            	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 author_code 권한 코드 없음. MENUGRP_CD:" + loopMap.get("evntKeyValTxt"));
	                            	flag = false;
	                            }else {
		                            logger.debug("authList : " + authList);
		
		                            for(Map<String,Object> authListMap : authList) {
		                                commonSql.insert("EbpOrgchart.insertAuthcode", authListMap);
		                                commonSql.insert("EbpOrgchart.insertAuthcodeMulti", authListMap);
		                            }
		
		                            response.setResult(authList);
		                            response.setResultCode("SUCCESS");
		                            response.setResultMessage("권한 코드 매핑 동기화 완료");
	                            }
	                        }
	                    }
	                    // 사용자-권한 매핑 BASAUT00500
	                    else if (loopMap.get("evntOcrnFgCd").equals("BASAUT00500")) {
	                        //System.out.println("MA_GROUP_MST-AUTH_RELATE -------------------- I or U or D");
	
	                        loopMap.put("queryid", "selectAuthRelateList");
	                        List<Map<String,Object>> authRelateList = ebpDAO.selectList(loopMap); // 사용자-권한 매핑
	
	                        // ERP 데이터 null 여부
	                        if (authRelateList == null || authRelateList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 MENUGRP_CD 권한 사용자-권한 매핑 데이터 없음. MENUGRP_CD:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        logger.debug("authRelateList : " + authRelateList);
		
		                        // U,A,M 전부 삭제
		                        authMap.put("codeMultiple", "Y");
		                        commonSql.delete("EbpOrgchart.deleteAllAuthRelate", authMap);
		
		                        for(Map<String,Object> authRelateListMap : authRelateList) {
		                            commonSql.insert("EbpOrgchart.insertAuthRelate", authRelateListMap);
		
		                            // author_tp = "M" 이면 t_co_emp_option 추가
		                            if (authRelateListMap.get("authorTp").equals("M") || authRelateListMap.get("authorTp") == "M") {
		                                commonSql.insert("EbpOrgchart.insertEmpOption", authRelateListMap);
		                            }
		                        }
		
		                        response.setResult(authRelateList);
		                        response.setResultCode("SUCCESS");
		                        response.setResultMessage("사용자-권한 매핑 동기화 완료");
	                        }
	                    }
	                    // 메뉴-권한 BASAUT00200, BASAUT00600
	                    else {
	                        //System.out.println("MA_GROUP_MST-MENU_AUTH -------------------- I or U or D");
	
	                        loopMap.put("queryid", "selectMenuAuthList");
	                        List<Map<String,Object>> menuAuthList = ebpDAO.selectList(loopMap); // 메뉴-권한 매핑
	
	                        // ERP 데이터 null 여부
	                        if (menuAuthList == null || menuAuthList.isEmpty()) {
	                        	Logger.getLogger( CloudConnetInfo.class ).error("ApiOrgchartServiceImpl.ebpSyncOrgchart Error ERP 해당 MENUGRP_CD 권한 메뉴-권한 매핑 데이터 없음. MENUGRP_CD:" + loopMap.get("evntKeyValTxt"));
	                        	flag = false;
	                        }else {
		                        logger.debug("menuAuthList : " + menuAuthList);
		
		                        // U,A,M 전부 삭제
		                        authMap.put("codeMultiple", "Y");
		                        commonSql.delete("EbpOrgchart.deleteAllMenuAuth", authMap);
		
		                        for(Map<String,Object> menuAuthListMap : menuAuthList) {
		                            commonSql.insert("EbpOrgchart.insertMenuAuth", menuAuthListMap);
		                        }
		
		                        response.setResult(menuAuthList);
		                        response.setResultCode("SUCCESS");
		                        response.setResultMessage("메뉴-권한 매핑 동기화 완료");
	                        }
	                    }
	                    
	                    if(flag) {
	    	                loopMap.put("queryid", "updateSyncAplyComplete");
	    	                loopMap.put("updateId", "ebpOrgchartSync");
	    	                loopMap.put("syncAll", "N");
	    	                ebpDAO.update(loopMap); // sync 적용 완료 Y 처리
	                    }
	                    
	                    break;
                	}catch(Exception e) {
                		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
                	}
                default :
                    response.setResult(loopMap);
                    response.setResultCode("ERROR");
                    response.setResultMessage("동기화 대상을 찾을 수 없습니다.");
                    break;
                }

                // 한건 완료 후 recode_sq로 ERP 로그테이블에 적용 여부 표시 필요
                // 수정필요 - 같은 데이터 I, U 가 여러건이 한번에 들어올때 U 한번만 처리하고 해당 데이터 전체 Y 업데이트 필요
                //   ㄴ 조회시 묶음데이터로 가지고와서 업데이트시에
                //     APLY_YN=N이면서 RECORD_SQ 보다 작거나 같고, TABLE_ID|EVNT_KEY_VAL_TXT|COMPANY_CD 가 같은 데이터 전부 update
                // response.getResultCode() 가 SUCCESS가 아니라면 break;

            }
            
            // 종료일자 지난 부서 일괄 미사용처리(ERP10 이력테이블 셋팅불가로인한 일괄처리)
            param.put("queryid", "selectDeptList");
            param.put("deptDisableFlag", "Y");
            param.remove("evntKeyValTxt");
            List<Map<String,Object>> deptDisableList = ebpDAO.selectList(param); //미사용 대상 부서 전체조회
            
            for(Map<String,Object> loopMap : deptDisableList) {
            	Map<String, Object> map = new HashMap<String, Object>();
            	map.put("groupSeq", param.get("groupSeq"));
            	map.put("deptSeq", loopMap.get("deptSeq"));
            	map.put("useYn", "N");
                commonSql.update("OrgAdapterManage.updateDept", loopMap);
            }
            
            //부서 정렬 보정처리(erp dept_cd 순 정렬처리)
            List<Map<String, Object>> deptOrderNumList = commonSql.list("EbpOrgchart.selectDeptOrderNumList", param);
            for(Map<String,Object> loopMap : deptOrderNumList) {
            	Map<String, Object> map = new HashMap<String, Object>();
            	map.put("groupSeq", param.get("groupSeq"));
            	map.put("deptSeq", loopMap.get("deptSeq"));
            	map.put("orderNum", loopMap.get("orderNum"));
                commonSql.update("EbpOrgchart.updateDeptOrderNum", loopMap);
            }

        } catch (Exception e) {
        	CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
            logger.debug("ebpSyncOrgchart Exception : " + e.getMessage());
            response.setResultCode("UC0000");
            response.setResult("Exception");
            response.setResultMessage(e.getMessage());
        }

        // 건당  t_co_group_api_history 테이블에 response 입력
        body.put("responseResultString", response.getResultString());
        body.put("responseResult", response.getResult());
        param.put("reqType", "result");
        param.put("data", body.toString());

        commonSql.insert("EbpOrgchart.setApiLog", param);
        logger.debug("ebpSyncOrgchart end : " + param);

        return response;
    }

    @Override
    public APIResponse ebpOrgAdapter(String apiTp, Map<String, Object> paramMap) {

        logger.debug("ebpSyncOrgchart.orgAdapter(0) Call : " + paramMap.toString());
        logger.debug("ebpSyncOrgchart.orgAdapter(1) apiTp : " + apiTp);

        APIResponse response = new APIResponse();

        try {
            Map<String, Object> result = new HashMap<String, Object>();

            paramMap.put("createSeq", "orgAdapter");

            if(apiTp.equals("compSaveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.compSaveAdapter body : " + paramMap);
                result = orgAdapterService.compSaveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.compSaveAdapter result : " + result);
            }
            else if(apiTp.equals("compRemoveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.compRemoveAdapter body : " + paramMap);
                result = orgAdapterService.compRemoveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.compRemoveAdapter result : " + result);
            }
            else if(apiTp.equals("deptSaveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.deptSaveAdapter body : " + paramMap);
                result = orgAdapterService.deptSaveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.deptSaveAdapter result : " + result);
            }
            else if(apiTp.equals("deptRemoveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.deptRemoveAdapter body : " + paramMap);
                result = orgAdapterService.deptRemoveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.deptRemoveAdapter result : " + result);
            }
            else if(apiTp.equals("empDeptRemoveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empDeptRemoveAdapter body : " + paramMap);
                result = orgAdapterService.empDeptRemoveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empDeptRemoveAdapter result : " + result);
            }
            else if(apiTp.equals("empLoginEmailIdModifyAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empLoginEmailIdModifyAdapter body : " + paramMap);
                result = orgAdapterService.empLoginEmailIdModifyAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empLoginEmailIdModifyAdapter result : " + result);
            }
            else if(apiTp.equals("empLoginPasswdResetProc")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empLoginPasswdResetProc body : " + paramMap);
                result = orgAdapterService.empLoginPasswdResetProc(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empLoginPasswdResetProc result : " + result);
            }
            else if(apiTp.equals("empPasswdChangeProc")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empPasswdChangeProc body : " + paramMap);
                result = orgAdapterService.empPasswdChangeProc(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empPasswdChangeProc result : " + result);
            }
            else if(apiTp.equals("empRemoveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empRemoveAdapter body : " + paramMap);
                result = orgAdapterService.empRemoveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empRemoveAdapter result : " + result);
            }
            else if(apiTp.equals("empResignProcFinishAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empResignProcFinish body : " + paramMap);
                result = orgAdapterService.empResignProcFinish(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empResignProcFinish result : " + result);
            }
            else if(apiTp.equals("empSaveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.empSaveAdapter body : " + paramMap);
                result = orgAdapterService.empSaveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.empSaveAdapter result : " + result);
            }
            else if(apiTp.equals("dutyPositionSaveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.dutyPositionSaveAdapter body : " + paramMap);
                result = orgAdapterService.dutyPositionSaveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.dutyPositionSaveAdapter result : " + result);
            }
            else if(apiTp.equals("dutyPositionRemoveAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.dutyPositionRemoveAdapter body : " + paramMap);
                result = orgAdapterService.dutyPositionRemoveAdapter(paramMap);
                logger.debug("ebpSyncOrgchart.orgAdapter.dutyPositionRemoveAdapter result : " + result);
            }
            else if(apiTp.equals("mailUserSyncAdapter")) {
                logger.debug("ebpSyncOrgchart.orgAdapter.mailUserSync body : " + paramMap);
                orgAdapterService.mailUserSync(paramMap);
                result.put("resultCode", "SUCCESS");
                result.put("result", "메일서버 조직도 동기화 완료");
            }
            else {
                logger.debug("ebpSyncOrgchart.orgAdapter 잘못된 API경로입니다. apiTp : " + apiTp);
                result.put("resultCode", "-999");
                result.put("result", "잘못된 API경로입니다.");
            }

            if(result.get("resultCode").equals("SUCCESS")){
                response.setResultCode(result.get("resultCode").toString());

            }
            else{
                if(result.get("resultDetailCode") != null) {
                    response.setResultCode(result.get("resultDetailCode").toString());
                }
                else {
                    response.setResultCode("UC0000");
                }
            }

            logger.debug("ebpSyncOrgchart.orgAdapter(2) End : " + result.get("result").toString());
            response.setResultMessage(result.get("result").toString());
            response.setResult(paramMap);

        }catch(Exception e) {
            logger.debug("ebpSyncOrgchart.orgAdapter Exception : " + e.getMessage());
            response.setResultCode("UC0000");
            response.setResult("Exception");
            response.setResultMessage(e.getMessage());
        }
        
    	Logger.getLogger( this.getClass() ).debug( "ebpOrgAdapter apiTp : " + apiTp );
    	Logger.getLogger( this.getClass() ).debug( "ebpOrgAdapter params : " + paramMap );
        Logger.getLogger( this.getClass() ).debug( "ebpOrgAdapter response : " + response.toString() );

        return response;
    }
    
    // 조직도 조회시 커스텀 조건 처리 추가(21.12.24)
    public void FNCustomQueryCheck(Map<String, Object> param) {
        // bizboxa.custom.properties
    	// 예시) BizboxA.Cust.erp10CustEmpQuery = AND a.EMP_TP='1'
        System.out.println("ERP10 CUSTOM QUERY CHECK START");
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustCompQuery").equals("99")) {
            String erp10CustCompQuery = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustCompQuery");
            param.put("custCompQuery", erp10CustCompQuery);
        }
        
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustBizQuery").equals("99")) {
        	String erp10CustBizQuery = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustBizQuery");
        	param.put("custBizQuery", erp10CustBizQuery);
        }
        
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustDeptQuery").equals("99")) {
        	String erp10CustDeptQuery = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustDeptQuery");
        	param.put("custDeptQuery", erp10CustDeptQuery);
        }
        
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustDPQuery").equals("99")) {
        	String erp10CustDPQuery = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustDPQuery");
        	param.put("custDPQuery", erp10CustDPQuery);
        }
        
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustEmpQuery").equals("99")) {
        	String erp10CustEmpQuery = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustEmpQuery");
        	param.put("custEmpQuery", erp10CustEmpQuery);
        }

    	// 예시) BizboxA.Cust.erp10CustEmpSeq = GU / GE / G / U / E
        // default = GU
        // GU = GMP_NO + "_" + USER_ID
        // GE = GMP_NO + "_" + COMPANY_CD + "_" + EMP_NO (HR_EMP_MST PK - COMPANY_CD + EMP_NO)
        // G = GMP_NO
        if(!BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustEmpSeq").equals("99")) {
        	String erp10CustEmpSeq = BizboxAProperties.getCustomProperty("BizboxA.Cust.erp10CustEmpSeq");
        	param.put("custEmpSeq", erp10CustEmpSeq);
        }
        System.out.println("ERP10 CUSTOM QUERY CHECK END: "+ param);
    }
    
    // ERP10 직급/직책/직위 관련 커스텀 처리(22.03.11)
    public void FNCustomOptionCheck(Map<String, Object> param) {
        System.out.println("ERP10 CUSTOM OPTION CHECK START");
        Map<String, Object> optionValue = new HashMap<String, Object>();
        Map<String, Object> tmpMap = new HashMap<String, Object>();
        tmpMap.put("groupSeq", param.get("groupSeq"));
        tmpMap.put("compSeq", "0");
        
        // 초기비밀번호 옵션 조회
        tmpMap.put("option", "derp0001");
        optionValue = (Map<String, Object>) commonSql.select("CommonOptionDAO.selectGroupOptionValue", tmpMap);
        String passwd = (String) (optionValue == null ? "" : optionValue.get("optionRealValue"));
        param.put("passwd", passwd);
        
        /* ERP10 직급/직책/직위  > Alpha 직급/직책 매핑 커스텀처리
         * - derp0002 : Alpha 직책(duty) 입력 [default : 1]
         * - derp0003 : Alpha 직급(position) 입력 [default : 2]
         *  ㄴ 1 : 직책코드(ODTY_CD) P00980
         *  ㄴ 2 : 직급코드(PSTN_CD) P00650
         *  ㄴ 3 : 직위코드(POSI_CD) P00640
         */
        tmpMap.put("option", "derp0002");
        optionValue = (Map<String, Object>) commonSql.select("CommonOptionDAO.selectGroupOptionValue", tmpMap);
        String dutyOption = (String) (optionValue == null ? "1" : optionValue.get("optionRealValue"));
        param.put("dutyOption", dutyOption);
        
        tmpMap.put("option", "derp0003");
        optionValue = (Map<String, Object>) commonSql.select("CommonOptionDAO.selectGroupOptionValue", tmpMap);
        String poitionOption = (String) (optionValue == null ? "2" : optionValue.get("optionRealValue"));
        param.put("poitionOption", poitionOption);

        System.out.println("ERP10 CUSTOM OPTION CHECK END: "+ param);
    }

    // TODO 개발 진행중
//	@Override
//	public APIResult erp10SyncTestapi(Map<String, Object> dataParam) {
//		APIResult result = new APIResult();
//
//		try {
//	        // 조직도 커스텀 디비 옵션값 처리 추가(22.03.08)
//	        this.FNCustomOptionCheck(dataParam);
//	        
//	        result.setResultCode(0);
//	        result.setResultMsg("TEST SUCESS");
//	        result.setResultData(dataParam);
//		} catch (Exception e) {
//			e.printStackTrace();
//	        result.setResultCode(-1);
//	        result.setResultMsg("TEST FAIL");
//	        result.setResultData(dataParam);
//		}
//
//		return result;
//	}

    // DERP-UC 로그인 세션처리를 위하여 DERP의 loginId(USER_ID)로 GEMP_NO를 찾는 함수
    @Override
    public String ebpFindGempnoToLoginid(String loginId) {
        String gempNo = "";
        logger.debug("ebpFindGempnoToLoginid start : " + loginId);

        try {
            /*
             * derp 연결
             * derp loginId(USER_ID)로 GEMP_NO 검색
             * return gempNo(UC의 login_id)
             */
            Map<String, Object> dbInfo = new HashMap<String, Object>();
            dbInfo.put("databaseType", "oracle");
            dbInfo.put("compSeq", "ebp");
            dbInfo.put("achrGbn", "etc");

            dbInfo = erpOrgchartSyncService.getErpDbInfo(dbInfo);

            logger.debug("db 접속정보 : " + dbInfo);

            EbpOrgchartDAOImpl ebpDAO = new EbpOrgchartDAOImpl();
            ebpDAO.setSqlSession(dbInfo);

            Map<String, Object> param = new HashMap<String, Object>();
            param.put("queryid", "selectFindGempnoToLoginid");
            param.put("loginId", loginId);


            if (!ebpDAO.selectOne(param).isEmpty()) {
                gempNo = ebpDAO.selectOne(param).get("GEMP_NO").toString();
            }
            else {
                gempNo = "";
            }

            logger.debug("gempNo : " + gempNo);

        } catch (Exception e) {
            logger.debug("ebpFindGempnoToLoginid Exception : " + e.getMessage());
            gempNo = "";
        }

        logger.debug("ebpFindGempnoToLoginid end : " + gempNo);

        return gempNo;
    }

	@Override
	public void removeNonInterlockingColumns(Map<String, Object> params, String removeColumn) {

		try {
			logger.debug("ApiOrgchartService removeNonInterlockingColumns params: " + params.toString() + " | removeColumn: " + removeColumn);
			
			if(params.containsKey(removeColumn)) {
				params.remove(removeColumn);
			}
			
		}catch(Exception e) {
			logger.error("ApiOrgchartService removeNonInterlockingColumns ERR: " + e);
			logger.error("ApiOrgchartService removeNonInterlockingColumns params: " + params.toString() + " | removeColumn: " + removeColumn);
		}
	}
    
    
}
