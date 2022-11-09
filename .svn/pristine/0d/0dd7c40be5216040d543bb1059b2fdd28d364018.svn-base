package neos.cmm.systemx.orgAdapter.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import bizbox.orgchart.model.Result;
import bizbox.orgchart.util.JedisClient;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.img.service.FileUploadService;
import neos.cmm.systemx.ldapAdapter.dao.LdapAdapterDAO;
import neos.cmm.systemx.license.service.LicenseService;
import neos.cmm.systemx.orgAdapter.dao.OrgAdapterDAO;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.HttpUtilThread;
import neos.cmm.util.NeosConstants;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import neos.cmm.util.FileUtils;
import cloud.CloudConnetInfo;

@Service ( "OrgAdapterService" )
public class OrgAdapterServiceImpl implements OrgAdapterService {

	protected Logger logger = Logger.getLogger( super.getClass( ) );
	private ConnectionVO conVo = new ConnectionVO( );
	/** EgovMessageSource */
	@Resource ( name = "egovMessageSource" )
	EgovMessageSource egovMessageSource;
	@Resource ( name = "CommonOptionManageService" )
	private CommonOptionManageService commonOptionManageService;
	@Resource ( name = "OrgAdapterDAO" )
	private OrgAdapterDAO orgAdapterDAO;
	@Resource ( name = "LdapAdapterDAO" )
	private LdapAdapterDAO ldapAdapterDAO;
	@Resource ( name = "FileUploadService" )
	private FileUploadService fileUploadService;
	@Resource ( name = "LicenseService" )
	private LicenseService licenseService;
	private SqlSessionFactory sqlSessionFactory;
	@Resource ( name = "wehagoAdapterService" )
	private wehagoAdapterService wehago;
	

	@Override
	public Map<String, Object> compSaveAdapter ( Map<String, Object> paramMap ) throws Exception {
		
		logger.debug("OrgAdapterService.compSaveAdapter : " + paramMap);
		
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		
		if ( paramMap.get( "order" ) != null ) {
			paramMap.put( "orderNum", paramMap.get( "order" ) );
		}
		
		innerParam.putAll( paramMap );
		
		boolean standardCodesReset = false;
		
		if ( innerParam.get( "compSeq" ) == null || innerParam.get( "compSeq" ).equals( "" ) ) {
			//신규등록
			if ( innerParam.get( "compName" ) == null || innerParam.get( "compName" ).equals( "" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000007108", "회사명을 입력하세요." ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0005" );
				return resultMap;
			}
			innerParam.put( "name", "orgchart" );
			
			String newCompSeq = "";
			
			if(innerParam.get("compSeqDef") != null && !innerParam.get("compSeqDef").equals("")) {
				
				Map<String, Object> sDefParam = new HashMap<String, Object>( );
				sDefParam.putAll( paramMap );
				sDefParam.put("compSeq", innerParam.get("compSeqDef"));
		
				if(orgAdapterDAO.getCompCnt(sDefParam).equals("0")) {
					newCompSeq = innerParam.get("compSeqDef").toString();
				}else {
					resultMap.put( "result", BizboxAMessage.getMessage("TX800000071","compSeqDef 중복키가 존재합니다.") );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0004" );
					return resultMap;					
				}
				
			}else {
				newCompSeq = orgAdapterDAO.getOrgSequence( innerParam );	
			}
			
			logger.debug("OrgAdapterService.compSaveAdapter newCompSeq : " + newCompSeq);
			
			if(innerParam.get("useYn") == null) {
				innerParam.put( "useYn", "Y" );
			}
			
			if(innerParam.get("eaType") == null || innerParam.get("eaType").equals("")) {
				innerParam.put( "eaType", "eap" );
			}
			
			if(innerParam.get("compDomain") == null || innerParam.get("compDomain").equals("")) {
				
				if(innerParam.get("orgAdapterRequestDomain") != null) {
					innerParam.put( "compDomain", innerParam.get("orgAdapterRequestDomain") );
				}
				
			}	
			
			innerParam.put( "compSeq", newCompSeq );
			paramMap.put( "compSeq", newCompSeq );
			innerParam.put( "parentCompSeq", "0" );
			innerParam.put( "compEmailYn", "N" );
			innerParam.put( "loginType", "B" );
			
			logger.debug("OrgAdapterService.compSaveAdapter.insertComp : " + innerParam);

			//insertComp
			try {
				orgAdapterDAO.insertComp( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertComp Fail] > " + e.getMessage() );
				return resultMap;
			}
			
			logger.debug("OrgAdapterService.compSaveAdapter.insertCompMulti : " + innerParam);

			//insertCompMulti(en)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameEn" ) + "" ) ) {
				innerParam.put( "compName", paramMap.get( "compNameEn" ) + "" );
				innerParam.put( "langCode", "en" );
				try {
					orgAdapterDAO.insertCompMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(en) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertCompMulti(jp)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameJp" ) + "" ) ) {
				innerParam.put( "compName", paramMap.get( "compNameJp" ) + "" );
				innerParam.put( "langCode", "jp" );
				try {
					orgAdapterDAO.insertCompMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(jp) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertCompMulti(cn)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameCn" ) + "" ) ) {
				innerParam.put( "compName", paramMap.get( "compNameCn" ) + "" );
				innerParam.put( "langCode", "cn" );
				try {
					orgAdapterDAO.insertCompMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(cn) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertCompMulti(kr)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compName" ) + "" ) ) {
                innerParam.put( "compName", paramMap.get( "compName" ) + "" );
				innerParam.put( "langCode", "kr" );
				try {
					logger.debug("OrgAdapterService.compSaveAdapter.insertCompMulti : " + innerParam);
					orgAdapterDAO.insertCompMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			
			//insertBiz
			innerParam.put( "bizSeq", newCompSeq );
			innerParam.put( "bizCd", newCompSeq );
			innerParam.put( "displayYn", "N" );
			innerParam.put( "nativeLangCode", "kr" );
			
			try {
				logger.debug("OrgAdapterService.compSaveAdapter.insertBiz : " + innerParam);
				orgAdapterDAO.insertBiz( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBiz Fail] > " + e.getMessage() );
				return resultMap;
			}
			
			//insertBizMulti(en)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameEn" ) + "" ) ) {
				innerParam.put( "bizName", paramMap.get( "compNameEn" ) + "" );
				innerParam.put( "langCode", "en" );
				try {
					orgAdapterDAO.insertBizMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(en) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			
			//insertBizMulti(jp)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameJp" ) + "" ) ) {
				innerParam.put( "bizName", paramMap.get( "compNameJp" ) + "" );
				innerParam.put( "langCode", "jp" );
				try {
					orgAdapterDAO.insertBizMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(jp) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			
			//insertBizMulti(cn)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compNameCn" ) + "" ) ) {
				innerParam.put( "bizName", paramMap.get( "compNameCn" ) + "" );
				innerParam.put( "langCode", "cn" );
				try {
					orgAdapterDAO.insertBizMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(cn) Fail] > "  + e.getMessage() );
					return resultMap;
				}
			}	
			
			//insertBizMulti(kr)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "compName" ) + "" ) ) {
				innerParam.put( "bizName", paramMap.get( "compName" ) + "" );
				innerParam.put( "langCode", "kr" );
				try {
					logger.debug("OrgAdapterService.compSaveAdapter.insertBizMulti : " + innerParam);
					orgAdapterDAO.insertBizMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}			
			
			logger.debug("OrgAdapterService.compSaveAdapter.insertBasicData : " + innerParam);
			//기초데이터 세팅
			try {
				orgAdapterDAO.insertBasicData( innerParam );
			}
			catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				/*
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBasicData Fail] > "  + e.getMessage() );
				return resultMap;
				*/				
			}
			
			//정부기준코드 Redis 갱신체크
			if(innerParam.get("standardCode") != null && !innerParam.get("standardCode").equals("")) {
				standardCodesReset = true;	
			}
			
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000016584", "등록이 완료 되었습니다" ) );
		}
		else {
			//수정
			Map<String, Object> compInfo = orgAdapterDAO.selectCompInfo(innerParam);
			
			if(compInfo == null) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000001894", "회사코드가 존재하지 않습니다." ) );
				return resultMap;
			}
			
			//정부기준코드 Redis 갱신체크
			if(innerParam.get("standardCode") != null) {
				String oldStandardCode = compInfo.get("standardCode") == null ? "" : compInfo.get("standardCode").toString();
				
				if(!innerParam.get("standardCode").equals(oldStandardCode)) {
					standardCodesReset = true;	
				}
			}		
			
			if ( orgAdapterDAO.updateComp( innerParam ) < 1 ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateComp Fail]" );
				return resultMap;
			}
			
			if(innerParam.get("useYn") == null) {
				innerParam.put( "useYn", "Y" );
			}
			
			//insertCompMulti(en)
			if ( paramMap.get( "compNameEn" ) != null ) {
				innerParam.put( "compName", paramMap.get( "compNameEn" ) );
				innerParam.put( "langCode", "en" );
				try {
					orgAdapterDAO.deleteCompMulti( innerParam );
					if ( !paramMap.get( "compNameEn" ).equals( "" ) ) {
						orgAdapterDAO.insertCompMulti( innerParam );
					}
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(en) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertCompMulti(jp)
			if ( paramMap.get( "compNameJp" ) != null ) {
				innerParam.put( "compName", paramMap.get( "compNameJp" ) );
				innerParam.put( "langCode", "jp" );
				try {
					orgAdapterDAO.deleteCompMulti( innerParam );
					if ( !paramMap.get( "compNameJp" ).equals( "" ) ) {
						orgAdapterDAO.insertCompMulti( innerParam );
					}
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(jp) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertCompMulti(cn)
			if ( paramMap.get( "compNameCn" ) != null ) {
				innerParam.put( "compName", paramMap.get( "compNameCn" ) );
				innerParam.put( "langCode", "cn" );
				try {
					orgAdapterDAO.deleteCompMulti( innerParam );
					if ( !paramMap.get( "compNameCn" ).equals( "" ) ) {
						orgAdapterDAO.insertCompMulti( innerParam );
					}
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertCompMulti(cn) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			
			//updateCompMulti(kr)
			try {
				
				if ( !EgovStringUtil.isEmpty( paramMap.get( "compName" ) + "" ) ) {
					innerParam.put( "compName", paramMap.get( "compName" ) );
				}else {
					innerParam.remove("compName");
				}				
				
				orgAdapterDAO.updateCompMulti( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateCompMulti(kr) Fail] > " + e.getMessage() );
				return resultMap;
			}	
			
			resultMap.put( "result", BizboxAMessage.getMessage("TX000009866","정상적으로 수정 되었습니다.") );
		}
		
		//부서 경로(path, pathName재설정 - 회사명이 변경 된 경우가 있을수 있어 처리 필요)
		orgAdapterDAO.updateDeptPathName(innerParam);
		
		//인감정보 insert/update
		String displayText = null;
		
		if ( innerParam.get( "displayText" ) != null ) {
			displayText = innerParam.get( "displayText" ).toString( );
		}
		
		innerParam.remove( "displayText" );
		
		if(innerParam.get( "fileList" ) != null && !innerParam.get( "fileList" ).equals("")) {
			
			String fileList = innerParam.get( "fileList" ).toString( );
			String[] arrCompStamp = fileList.split( "," );
			
			for ( int i = 0; i < fileList.split( "," ).length; i++ ) {
				String[] compStampInfo = arrCompStamp[i].split( "\\|" );
				if ( compStampInfo.length < 3 ) {
					continue;
				}
				String imgType = compStampInfo[0];
				String fileId = compStampInfo[1];
				String newYN = compStampInfo[2];
				if ( innerParam.get( "osType" ) == null ) {
					innerParam.put( "osType", "" );}
				if ( innerParam.get( "appType" ) == null ) {
					innerParam.put( "appType", "" );}
				if ( innerParam.get( "dispMode" ) == null ) {
					innerParam.put( "dispMode", "" );}
				if ( innerParam.get( "dispType" ) == null ) {
					innerParam.put( "dispType", "" );}
				innerParam.put( "modifySeq", innerParam.get( "createSeq" ).toString( ) );
				innerParam.put( "imgType", imgType );
				innerParam.put( "fileId", fileId );
				innerParam.put( "orgSeq", innerParam.get( "compSeq" ).toString( ) );
				if ( newYN.equals( "Y" ) || (fileId.equals( "0" ) && newYN.equals( "N" )) ) {
					Object sOrgImgChk = fileUploadService.selectOrgImg( innerParam );
					if ( sOrgImgChk != null ) {
						String sfileId = sOrgImgChk.toString( );
						innerParam.put( "file_Id", sfileId );
						fileUploadService.deleteFile( innerParam ); //이미 등록되어 있는 로고인 경우 기존 첨부파일 내역 삭제;
					}
				}
				/** db t_co_org_img table insert */
				if ( !fileId.equals( "0" ) && newYN.equals( "Y" ) ) {
					fileUploadService.insertOrgImg( innerParam );
				}
				else if ( newYN.equals( "N" ) && fileId.equals( "0" ) ) {
					fileUploadService.deleteOrgImg( innerParam );
				}
			}
			
		}
		
		if ( displayText != null ) {
			innerParam.clear( );
			if ( innerParam.get( "osType" ) == null ) {
				innerParam.put( "osType", "" );}
			if ( innerParam.get( "appType" ) == null ) {
				innerParam.put( "appType", "" );}
			if ( innerParam.get( "dispMode" ) == null ) {
				innerParam.put( "dispMode", "" );}
			if ( innerParam.get( "dispType" ) == null ) {
				innerParam.put( "dispType", "" );}
			innerParam.put( "displayText", displayText );
			innerParam.put( "orgSeq", paramMap.get( "compSeq" ).toString( ) );
			innerParam.put( "imgType", "TEXT_COMP_STAMP4" );
			innerParam.put( "fileId", "" );
			if ( innerParam.get( "displayText" ).toString( ).equals( "" ) ) {
				fileUploadService.deleteOrgImg( innerParam );
			}
			else {
				fileUploadService.insertOrgImg( innerParam );
			}
		}
		
		//정부기준코드 설정변경 시 Redis세팅값 갱신
		if(standardCodesReset) {
			
			logger.debug("OrgAdapterService.compSaveAdapter.setStandardCodes : TRUE");

			List<String> standardCodeList = new ArrayList<String>();
			
			List<Map<String, Object>> selectStandardCodeList = orgAdapterDAO.selectStandardCodeList(paramMap);

    		for(Map<String, Object> selectStandardCode : selectStandardCodeList) {
    			standardCodeList.add(selectStandardCode.get("standardCode").toString());
    		}
			
            JedisClient jedis = CloudConnetInfo.getJedisClient();
            Result standardResult = jedis.setStandardCodes(standardCodeList, paramMap.get("groupSeq").toString());
            
            String standardResultCode = standardResult.getResultCode() == null ? "0" : standardResult.getResultCode();
            
            if(standardResultCode.equals("0")) {
            	
            	logger.debug("OrgAdapterService.compSaveAdapter.setStandardCodes : SUCCESS");
            	
            }else if(standardResultCode.equals("ORGSD002")) {
            	
            	logger.error("OrgAdapterService.compSaveAdapter.setStandardCodes : FAIL(" + standardResultCode + ") > " + standardResult.getResult().toString());
            	
				throw new Exception("정부기준코드가 유효하지 않습니다. 관리자에게 문의 바랍니다.");
            }else {
            	
            	logger.error("OrgAdapterService.compSaveAdapter.setStandardCodes : FAIL(" + standardResultCode + ")");
            	
            	throw new Exception("정부 기준 코드를 저장할 수 없습니다. 관리자에게 문의 바랍니다.");
            }
            
		}
		
		logger.debug("OrgAdapterService.compSaveAdapter : SUCCESS");
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	@Override
	public Map<String, Object> compRemoveAdapter ( Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		String compSeq = String.valueOf( paramMap.get( "compSeq" ) );
		if ( EgovStringUtil.isEmpty( compSeq ) ) {
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000001894", "회사코드가 존재하지 않습니다." ) );
			return resultMap;
		}
		else {
			if ((paramMap.get("forceDelete") == null || !paramMap.get("forceDelete").equals("Y")) && !orgAdapterDAO.getCompDeptCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0006" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000006191", "하위부서가 존재하여 삭제할 수 없습니다." ) );
			}
			else {
				orgAdapterDAO.deleteComp( paramMap );
				orgAdapterDAO.deleteCompMulti( paramMap );
				//사업장 정보 삭제
				orgAdapterDAO.deleteBiz( paramMap );
				orgAdapterDAO.deleteBizMulti( paramMap );
				//기타데이터 삭제
				orgAdapterDAO.deleteCompPack( paramMap );
				resultMap.put( "resultCode", "SUCCESS" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000001985", "삭제가 완료되었습니다." ) );
			}
		}
		return resultMap;
	}

	@Override
	public Map<String, Object> deptSaveAdapter ( Map<String, Object> paramMap ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		
		//기초데이터 보정
		if ( paramMap.get( "pCompSeq" ) != null && !paramMap.get( "pCompSeq" ).equals( "" ) ) {
			paramMap.put( "compSeq", paramMap.get( "pCompSeq" ) );
		}
		if ( paramMap.get( "pBizSeq" ) != null && !paramMap.get( "pBizSeq" ).equals( "" ) ) {
			paramMap.put( "bizSeq", paramMap.get( "pBizSeq" ) );
		}
		if ( paramMap.get( "pDeptSeq" ) != null && !paramMap.get( "pDeptSeq" ).equals( "" ) ) {
			paramMap.put( "parentDeptSeq", paramMap.get( "pDeptSeq" ) );
		}
		if ( paramMap.get( "IMG_BIZ_SEAL_fileID" ) != null ) {
			paramMap.put( "sealFileId", paramMap.get( "IMG_BIZ_SEAL_fileID" ) );
		}
		if ( paramMap.get( "bizSealFileId" ) != null ) {
			paramMap.put( "sealFileId", paramMap.get( "bizSealFileId" ) );
		}
		if ( paramMap.get( "deptCd" ) != null && !paramMap.get( "deptCd" ).equals( "" ) ) {
			paramMap.put( "bizCd", paramMap.get( "deptCd" ) );
		}
		if ( paramMap.get( "bizDisplay" ) != null && !paramMap.get( "bizDisplay" ).equals( "" ) ) {
			paramMap.put( "displayYn", paramMap.get( "bizDisplay" ) );
		}
		if ( paramMap.get( "innerReceiveYn" ) == null || paramMap.get( "innerReceiveYn" ).equals( "" ) ) {
			paramMap.put( "innerReceiveYn", "Y" );
		}
		if ( paramMap.get( "virDeptYn" ) == null || paramMap.get( "virDeptYn" ).equals( "" ) ) {
			if ( paramMap.get( "teamYn" ) != null && paramMap.get( "teamYn" ).equals( "T" ) ) {
				paramMap.put( "virDeptYn", "Y" );
			}
			else {
				paramMap.put( "virDeptYn", "N" );
			}
		}
		if ( paramMap.get( "teamYn" ) != null && (paramMap.get( "teamYn" ).equals( "T" ) || paramMap.get( "teamYn" ).equals( "E" )) ) {
			if ( paramMap.get( "deptDisplayYn" ) != null && !paramMap.get( "deptDisplayYn" ).equals( "" ) ) {
				if ( paramMap.get( "deptDisplayYn" ).equals( "on" ) ) {
					paramMap.put( "displayYn", "N" );
				}
				else {
					paramMap.put( "displayYn", paramMap.get( "deptDisplayYn" ) );
				}
			}
			if ( paramMap.get( "teamYn" ).equals( "E" ) ) {
				paramMap.put( "eaYn", "Y" );
			}
			else {
				paramMap.put( "eaYn", "N" );
			}
			paramMap.put( "teamYn", "N" );
		}
		else {
			paramMap.put( "displayYn", "Y" );
			paramMap.put( "eaYn", "N" );
		}
		paramMap.put( "nativeLangCode", "kr" );
		//내부파라미터 SET
		innerParam.putAll( paramMap );
		//사업장
		if ( innerParam.get( "deptType" ) != null && innerParam.get( "deptType" ).equals( "B" ) ) {
			if ( innerParam.get( "bizDisplay" ) != null && !innerParam.get( "bizDisplay" ).equals( "" ) ) {
				innerParam.put( "displayYn", innerParam.get( "bizDisplay" ) );
			}
			
			if(innerParam.get("bizSeq") != null && !innerParam.get("bizSeq").equals("") && (innerParam.get( "deptSeq" ) == null || innerParam.get( "deptSeq" ).equals( "" ))) {
				innerParam.put( "deptSeq", innerParam.get( "bizSeq" ) );
			}
			
			if ( innerParam.get( "deptSeq" ) == null || innerParam.get( "deptSeq" ).equals( "" ) ) {
				//사업장 신규등록
				if ( paramMap.get( "deptName" ) == null || paramMap.get( "deptName" ).equals( "" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000007110", "사업장명을 입력하세요." ) );
					resultMap.put( "resultDetailCode", "UC0005" );
					resultMap.put( "resultCode", "fail" );
					return resultMap;
				}
				innerParam.put( "name", "orgchart" );
				
				String newBizSeq = "";
				
				if(innerParam.get("deptSeqDef") != null && !innerParam.get("deptSeqDef").equals("")) {
					
					Map<String, Object> sDefParam = new HashMap<String, Object>( );
					sDefParam.putAll( paramMap );
					sDefParam.put("bizSeq", innerParam.get("deptSeqDef"));
					
					if(orgAdapterDAO.getBizCnt(sDefParam).equals("0")) {
						newBizSeq = innerParam.get("deptSeqDef").toString();
					}else {
						resultMap.put( "result", BizboxAMessage.getMessage("TX800000072","bizSeqDef 중복키가 존재합니다.") );
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0004" );
						return resultMap;					
					}
					
				}else {
					newBizSeq = orgAdapterDAO.getOrgSequence( innerParam );	
				}	
				
				if(innerParam.get("useYn") == null) {
					innerParam.put( "useYn", "Y" );
				}
				
				innerParam.put( "bizSeq", newBizSeq );
				//insertBiz
				try {
					orgAdapterDAO.insertBiz( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBiz Fail] > " + e.getMessage() );
					return resultMap;
				}
				//insertBizMulti(en)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameEn" ) + "" ) ) {
					innerParam.put( "bizName", paramMap.get( "deptNameEn" ) + "" );
					innerParam.put( "langCode", "en" );
					try {
						orgAdapterDAO.insertBizMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertBizMulti(jp)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameJp" ) + "" ) ) {
					innerParam.put( "bizName", paramMap.get( "deptNameJp" ) + "" );
					innerParam.put( "langCode", "jp" );
					try {
						orgAdapterDAO.insertBizMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(jp) Fail] > "  + e.getMessage() );
						return resultMap;
					}
				}
				//insertBizMulti(cn)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameCn" ) + "" ) ) {
					innerParam.put( "bizName", paramMap.get( "deptNameCn" ) + "" );
					innerParam.put( "langCode", "cn" );
					try {
						orgAdapterDAO.insertBizMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				////insertBizMulti(kr)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptName" ) + "" ) ) {
					innerParam.put( "bizName", paramMap.get( "deptName" ) );
					innerParam.put( "langCode", "kr" );
					try {
						orgAdapterDAO.insertBizMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(kr) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}				
			}
			else {
				//수정
				if ( paramMap.get( "deptName" ) != null && paramMap.get( "deptName" ).equals( "" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000007110", "사업장명을 입력하세요." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0005" );
					return resultMap;
				}
				//updateBiz
				//bizSeq체크
				if ( orgAdapterDAO.getBizCnt( innerParam ).equals( "0" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000001799", "해당하는 사업장이 존재하지 않습니다." ) );
					return resultMap;
				}
				try {
					orgAdapterDAO.updateBiz( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateBiz Fail] > " + e.getMessage() );
					return resultMap;
				}
				
				if(innerParam.get("useYn") == null) {
					innerParam.put( "useYn", "Y" );
				}
				
				//insertBizMulti(en)
				if ( paramMap.get( "deptNameEn" ) != null ) {
					innerParam.put( "bizName", paramMap.get( "deptNameEn" ) + "" );
					innerParam.put( "langCode", "en" );
					try {
						orgAdapterDAO.deleteBizMulti( innerParam );
						if ( !paramMap.get( "deptNameEn" ).equals( "" ) ) {
							orgAdapterDAO.insertBizMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertBizMulti(jp)
				if ( paramMap.get( "deptNameEn" ) != null ) {
					innerParam.put( "bizName", paramMap.get( "deptNameJp" ) + "" );
					innerParam.put( "langCode", "jp" );
					try {
						orgAdapterDAO.deleteBizMulti( innerParam );
						if ( !paramMap.get( "deptNameJp" ).equals( "" ) ) {
							orgAdapterDAO.insertBizMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertBizMulti(cn)
				if ( paramMap.get( "deptNameCn" ) != null ) {
					innerParam.put( "bizName", paramMap.get( "deptNameCn" ) + "" );
					innerParam.put( "langCode", "cn" );
					try {
						orgAdapterDAO.deleteBizMulti( innerParam );
						if ( !paramMap.get( "deptNameCn" ).equals( "" ) ) {
							orgAdapterDAO.insertBizMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertBizMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				
				//updateBizMulti(kr)
				try {
					
					if ( !EgovStringUtil.isEmpty( paramMap.get( "deptName" ) + "" ) ) {
						innerParam.put( "bizName", paramMap.get( "deptName" ) );
					}else {
						innerParam.remove("bizName");
					}
					
					orgAdapterDAO.updateBizMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateBizMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}				
			}
			
			//부서 경로(path, pathName) 재설정 - 사업장명이 변경 된 경우가 있을수 있어 처리 필요
			orgAdapterDAO.updateDeptPathName(innerParam);
		}
		else {
			//부서유형 체크
			//상위부서 = '임시' 일경우 하위부서로 '임시'만 등록가능
			//상위부서 = '팀' 일경우 하위부서로 '팀'만 등록가능
			if (innerParam.get( "parentDeptSeq" ) != null && !innerParam.get( "parentDeptSeq" ).equals( "0" ) ) {
				Map<String, Object> map = new HashMap<String, Object>( );
				map.put( "deptSeq", innerParam.get( "parentDeptSeq" ) );
				map = orgAdapterDAO.selectDeptInfo( map );
				if ( map == null ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "DSA0002" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010753", "상위부서코드오류" ) );
					return resultMap;
				}
				
				//상위부서 사업장코드 갱신
				innerParam.put("bizSeq", map.get("bizSeq"));
				
				String pVirDeptYn = map.get( "virDeptYn" ) + "";
				String pTeamYn = map.get( "teamYn" ) + "";
				String pEaYn = map.get( "eaYn" ) + "";
				if ( pVirDeptYn.equals( "Y" ) && !innerParam.get( "virDeptYn" ).equals( "Y" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "DSA0001" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000011785", "임시부서 하위에는 임시부서만 등록가능합니다" ) );
					return resultMap;
				}
				if ( pTeamYn.equals( "Y" ) && !innerParam.get( "teamYn" ).equals( "Y" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "DSA0001" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000016534", "팀 하위에는 팀만 등록가능합니다." ) );
					return resultMap;
				}
				if ( pEaYn.equals( "Y" ) && (paramMap.get( "eaYn" ) == null || !paramMap.get( "eaYn" ).equals( "Y" )) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "DSA0001" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX800000073", "결재전용부서 하위에는 결재전용부서만 등록 할 수 있습니다." ) );
					return resultMap;
				}
			}
			//부서
			if ( innerParam.get( "deptSeq" ) == null || innerParam.get( "deptSeq" ).equals( "" ) ) {
				//부서 신규등록
				
				//parentDeptSeq보정
				if(innerParam.get( "parentDeptSeq" ) == null || innerParam.get( "parentDeptSeq" ).equals("")){
					innerParam.put("parentDeptSeq", "0");
				}
				
				//bizSeq보정
				if(innerParam.get( "bizSeq" ) == null || innerParam.get( "bizSeq" ).equals("")){
					if(innerParam.get( "compSeq" ) != null && !innerParam.get( "compSeq" ).equals( "" )){
						innerParam.put("bizSeq", innerParam.get( "compSeq" ));	
					}
				}				
				
				if ( paramMap.get( "deptName" ) == null || paramMap.get( "deptName" ).equals( "" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000006187", "부서명은 필수 입력입니다." ) );
					resultMap.put( "resultDetailCode", "UC0005" );
					resultMap.put( "resultCode", "fail" );
					return resultMap;
				}
				innerParam.put( "name", "orgchart" );
				
				String newDeptSeq = "";
				
				if(innerParam.get("deptSeqDef") != null && !innerParam.get("deptSeqDef").equals("")) {
					
					Map<String, Object> sDefParam = new HashMap<String, Object>( );
					sDefParam.putAll( paramMap );
					sDefParam.put("deptSeq", innerParam.get("deptSeqDef"));
					
					if(orgAdapterDAO.getDeptCnt(sDefParam).equals("0")) {
						newDeptSeq = innerParam.get("deptSeqDef").toString();
					}else {
						resultMap.put( "result", BizboxAMessage.getMessage("TX800000074","deptSeqDef 중복키가 존재합니다.") );
						resultMap.put( "resultDetailCode", "UC0004" );
						resultMap.put( "resultCode", "fail" );
						return resultMap;					
					}
					
				}else {
					newDeptSeq = orgAdapterDAO.getOrgSequence( innerParam );	
				}	
				
				if(innerParam.get("useYn") == null) {
					innerParam.put( "useYn", "Y" );
				}
				
				resultMap.put( "newDeptSeq", newDeptSeq);
				innerParam.put( "deptSeq", newDeptSeq );
				if ( innerParam.get( "teamYn" ) != null && innerParam.get( "teamYn" ).equals( "Y" ) ) {
					innerParam.put( "displayDeptSeq", innerParam.get( "parentDeptSeq" ) );
					innerParam.put( "ptype", "0" );
				}
				else {
					innerParam.put( "displayDeptSeq", innerParam.get( "deptSeq" ) );
					innerParam.put( "ptype", "1" );
				}
				//insertDept
				try {
					orgAdapterDAO.insertDept( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDept Fail] > " + e.getMessage() );
					return resultMap;
				}
				//insertDeptMulti(en)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameEn" ) + "" ) ) {
					innerParam.put( "deptName", paramMap.get( "deptNameEn" ) + "" );
					innerParam.put( "langCode", "en" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.insertDeptMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDeptMulti(jp)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameJp" ) + "" ) ) {
					innerParam.put( "deptName", paramMap.get( "deptNameJp" ) + "" );
					innerParam.put( "langCode", "jp" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.insertDeptMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDeptMulti(cn)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptNameCn" ) + "" ) ) {
					innerParam.put( "deptName", paramMap.get( "deptNameCn" ) + "" );
					innerParam.put( "langCode", "cn" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.insertDeptMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				////insertDeptMulti(kr)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "deptName" ) + "" ) ) {
					innerParam.put( "deptName", paramMap.get( "deptName" ) );
					innerParam.put( "langCode", "kr" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.insertDeptMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(kr) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}				
				
				if ( BizboxAProperties.getCustomProperty( "BizboxA.Cust.LdapUseYn" ).equals( "Y" ) ) {
					//AD연동 I/F테이블에 INSERT
					innerParam.put( "deptName", paramMap.get( "deptName" ) );
					innerParam.put( "syncType", "I" );
					ldapAdapterDAO.insertOrgAdapterResultDept( innerParam );
				}
				
				//위하고 조직도 연동 Sync
				wehago.wehagoInsertOrgChartOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), newDeptSeq, "I");
				
			}
			else {
				//부서 수정
				if ( paramMap.get( "deptName" ) != null && paramMap.get( "deptName" ).equals( "" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000006187", "부서명은 필수 입력입니다." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0005" );
					return resultMap;
				}
				if ( orgAdapterDAO.getDeptCnt( innerParam ).equals( "0" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010698", "부서코드없음" ) );
					return resultMap;
				}
				//결재전용 부서로 변경시 하위 부서가 존재하면 변경불가.
				if ( paramMap.get( "eaYn" ) != null && paramMap.get( "eaYn" ).equals( "Y" ) ) {
					int cnt = orgAdapterDAO.selectChildDeptCount( paramMap );
					if ( cnt > 0 ) {
						resultMap.put( "result", BizboxAMessage.getMessage( "TX800000152", "하위부서가 존재할 경우 결재전용부서로 변경할 수 없습니다." ) );
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "DSA0001" );
						return resultMap;
					}
				}
				if ( innerParam.get( "teamYn" ) != null && innerParam.get( "teamYn" ).equals( "Y" ) ) {
					innerParam.put( "displayDeptSeq", innerParam.get( "parentDeptSeq" ) );
					innerParam.put( "ptype", "0" );
				}
				else {
					innerParam.put( "displayDeptSeq", innerParam.get( "deptSeq" ) );
					innerParam.put( "ptype", "1" );
				}
				
				// 상위 부서의 사용 여부가 N일때, 변경부서의 사용여부값을 Y로 변경할시 변경불가.
				if ( paramMap.get( "parentDeptSeq" ) != null && !paramMap.get( "parentDeptSeq" ).equals( "0" ) && paramMap.get( "useYn" ).equals( "Y" )) {
				    Map<String, Object> parentMap = new HashMap<String, Object>( );
				    parentMap.put("deptSeq", paramMap.get( "parentDeptSeq" ));
				    parentMap = orgAdapterDAO.selectDeptInfo( parentMap );
				    
				    if (parentMap.get("useYn") != null && parentMap.get("useYn").equals("N")) {
				        resultMap.put( "result", BizboxAMessage.getMessage( "", "상위부서의 사용여부가 N일 경우에는 해당 부서의 사용여부를 Y로 변경 할 수 없습니다." ) );
                        resultMap.put( "resultCode", "fail" );
                        resultMap.put( "resultDetailCode", "UC0002" );
                        return resultMap;
				    }
				}
				
				//updateDept
				try {
					orgAdapterDAO.updateDept( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateDept Fail] > " + e.getMessage() );
					return resultMap;
				}
				
				if(innerParam.get("useYn") == null) {
					innerParam.put( "useYn", "Y" );
				}
				
				//insertDeptMulti(en)
				if ( paramMap.get( "deptNameEn" ) != null ) {
					innerParam.put( "deptName", paramMap.get( "deptNameEn" ) + "" );
					innerParam.put( "langCode", "en" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.deleteDeptMulti( innerParam );
						if ( !paramMap.get( "deptNameEn" ).equals( "" ) ) {
							orgAdapterDAO.insertDeptMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDeptMulti(jp)
				if ( paramMap.get( "deptNameJp" ) != null ) {
					innerParam.put( "deptName", paramMap.get( "deptNameJp" ) + "" );
					innerParam.put( "langCode", "jp" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.deleteDeptMulti( innerParam );
						if ( !paramMap.get( "deptNameJp" ).equals( "" ) ) {
							orgAdapterDAO.insertDeptMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDeptMulti(cn)
				if ( paramMap.get( "deptNameCn" ) != null ) {
					innerParam.put( "deptName", paramMap.get( "deptNameCn" ) + "" );
					innerParam.put( "langCode", "cn" );
					//부서약칭 미입력시 부서명과 동일하게 입력되도록 수정
					if ( EgovStringUtil.isEmpty( innerParam.get( "deptNickname" ) + "" ) ) {
						innerParam.put( "deptNickname", innerParam.get( "deptName" ) );
					}
					try {
						orgAdapterDAO.deleteDeptMulti( innerParam );
						if ( !paramMap.get( "deptNameCn" ).equals( "" ) ) {
							orgAdapterDAO.insertDeptMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDeptMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				
				//updateDeptMulti(kr)
				try {
					
					if ( !EgovStringUtil.isEmpty( paramMap.get( "deptName" ) + "" ) ) {
						innerParam.put( "deptName", paramMap.get( "deptName" ) );
					}else {
						innerParam.remove("deptName");
					}					
					
					orgAdapterDAO.updateDeptMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateDeptMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}					
				
				//하위부서정보 보정
				orgAdapterDAO.updateChildDeptInfo( innerParam );
				//부서원 정렬 적용
				if ( innerParam.get( "empDeptOrderList" ) != null && !innerParam.get( "empDeptOrderList" ).equals( "" ) ) {
					String[] arrEmpInfoList = innerParam.get( "empDeptOrderList" ).toString( ).split( "," );
					for ( int i = 0; i < arrEmpInfoList.length; i++ ) {
						String[] empInfo = arrEmpInfoList[i].split( "\\|" );
						Map<String, Object> mp = new HashMap<String, Object>( );
						mp.put( "deptSeq", empInfo[0] );
						mp.put( "empSeq", empInfo[1] );
						if ( empInfo.length == 2 ) {
							mp.put( "orderNum", "100" );
						}
						else {
							mp.put( "orderNum", empInfo[2] );
						}
						orgAdapterDAO.updateEmpDeptOrderNum( mp );
					}
				}
				//결재전용부서로 변경시 해당부서 사용자 조직도표시여부 N으로 일괄변경 (orgchart_display_yn, messenger_display_yn)
				if ( innerParam.get( "eaYn" ) != null && innerParam.get( "eaYn" ).equals( "Y" ) ) {
					orgAdapterDAO.updateEmpDeptDisplayInfo( innerParam );
				}
				if ( BizboxAProperties.getCustomProperty( "BizboxA.Cust.LdapUseYn" ).equals( "Y" ) ) {
					//AD연동 I/F테이블에 INSERT
					innerParam.put( "deptName", paramMap.get( "deptName" ) );
					innerParam.put( "syncType", "U" );
					ldapAdapterDAO.insertOrgAdapterResultDept( innerParam );
				}
				
				//위하고 조직도 연동 Sync
				wehago.wehagoInsertOrgChartOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), innerParam.get("deptSeq").toString(), "U");
			}
		}
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000016584", "등록이 완료 되었습니다" ) );
		resultMap.put( "resultCode", "SUCCESS" );
				
		return resultMap;
	}

	@Override
	public Map<String, Object> deptRemoveAdapter ( Map<String, Object> paramMap ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		if ( paramMap.get( "deptType" ) != null && paramMap.get( "deptType" ).equals( "B" ) ) {
			//사업장 삭제
			if ( (paramMap.get( "bizSeq" ) == null || paramMap.get( "bizSeq" ).equals( "" )) && (paramMap.get( "deptSeq" ) != null && !paramMap.get( "deptSeq" ).equals( "" )) ) {
				paramMap.put( "bizSeq", paramMap.get( "deptSeq" ) );
			}
			if ( orgAdapterDAO.getBizCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000001799", "해당하는 사업장이 존재하지 않습니다." ) );
				return resultMap;
			}
			if ( !orgAdapterDAO.getBizDeptCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000006191", "사업장 하위부서가 존재하여 삭제할 수 없습니다." ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0006" );
				return resultMap;
			}
			orgAdapterDAO.deleteBiz( paramMap );
			orgAdapterDAO.deleteBizMulti( paramMap );
		}
		else {
			//부서 삭제
			if ( orgAdapterDAO.getDeptCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000010698", "부서코드없음" ) );
				return resultMap;
			}
			if ( !orgAdapterDAO.getDeptChildCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000006191", "하위부서가 존재하여 삭제할 수 없습니다." ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0006" );
				return resultMap;
			}
			if ( !orgAdapterDAO.getDeptEmpCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000011783", "사용자가 존재하여 삭제할수 없습니다" ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0006" );
				return resultMap;
			}
			if ( !orgAdapterDAO.getDeptEmpResignCnt( paramMap ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "", "부서정보를 삭제하지 않은 퇴사자가 존재하여 부서를 삭제할 수 없습니다." ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0006" );
				return resultMap;
			}
			
			//위하고 조직도 연동 Sync
			wehago.wehagoInsertOrgChartOneSync(paramMap.get("groupSeq").toString(), paramMap.get("compSeq").toString(), paramMap.get("deptSeq").toString(), "D");
			
			orgAdapterDAO.deleteDept( paramMap );
			orgAdapterDAO.deleteDeptMulti( paramMap );
			
			// 접근가능IP 부서 삭제
			paramMap.put("ipDiv", "dept");
			orgAdapterDAO.deleteAccessIpRelate(paramMap);
			
			if ( BizboxAProperties.getCustomProperty( "BizboxA.Cust.LdapUseYn" ).equals( "Y" ) ) {
				//AD연동 I/F테이블에 INSERT
				paramMap.put( "syncType", "D" );
				ldapAdapterDAO.insertOrgAdapterResultDept( paramMap );
			}
			
		}
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000001985", "삭제가 완료되었습니다." ) );
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	public Map<String, Object> empSaveAdapter ( Map<String, Object> paramMap ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		innerParam.putAll( paramMap );
		innerParam.put( "syncType", "U" );
		//데이터보정
		if ( innerParam.get( "callType" ) == null || innerParam.get( "callType" ).equals( "" ) ) {
			innerParam.put( "callType", "saveEmp" );
		}
		if ( innerParam.get( "lunarYn" ) != null && innerParam.get( "lunarYn" ).equals( "" ) ) {
			innerParam.put( "bday", "" );
		}
		if ( innerParam.get( "useYn" ) != null && innerParam.get( "useYn" ).equals( "" ) ) {
			innerParam.put( "useYn", "Y" );
		}
		if ( innerParam.get( "weddingYn" ) != null && !innerParam.get( "weddingYn" ).equals( "Y" ) ) {
			innerParam.put( "weddingYn", "N" );
			innerParam.put( "weddingDay", "" );
		}
		if ( innerParam.get( "outEmail" ) != null ) {
			innerParam.put( "outMail", innerParam.get( "outEmail" ) );
		}
		if ( innerParam.get( "outDomainText" ) != null ) {
			innerParam.put( "outDomain", innerParam.get( "outDomainText" ) );
		}
		if ( innerParam.get( "loginPasswdNew" ) != null && !innerParam.get( "loginPasswdNew" ).equals( "" ) ) {
			paramMap.put( "loginPasswd", innerParam.get( "loginPasswdNew" ) );
			innerParam.put( "loginPasswd", CommonUtil.passwordEncrypt( innerParam.get( "loginPasswdNew" ).toString( ) ) );
		}
		if ( innerParam.get( "apprPasswdNew" ) != null && !innerParam.get( "apprPasswdNew" ).equals( "" ) ) {
			innerParam.put( "apprPasswd", CommonUtil.passwordEncrypt( innerParam.get( "apprPasswdNew" ).toString( ) ) );
		}
		if ( innerParam.get( "payPasswdNew" ) != null && !innerParam.get( "payPasswdNew" ).equals( "" ) ) {
			innerParam.put( "payPasswd", CommonUtil.passwordEncrypt( innerParam.get( "payPasswdNew" ).toString( ) ) );
		}
		if ( innerParam.get( "checkWork" ) != null && !innerParam.get( "checkWork" ).equals( "" ) ) {
			innerParam.put( "checkWorkYn", innerParam.get( "checkWork" ) );
		}
		if ( innerParam.get( "erpEmpNum" ) != null ) {
			innerParam.put( "erpEmpSeq", innerParam.get( "erpEmpNum" ) );
		}
		if ( innerParam.get( "bizSeq" ) == null || innerParam.get( "bizSeq" ).equals( "" ) ) {
			if ( innerParam.get( "deptSeq" ) != null && !innerParam.get( "deptSeq" ).equals( "" ) ) {
				innerParam.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( innerParam ) );
			}
		}
		if ( innerParam.get( "compSeq" ) != null && !innerParam.get( "compSeq" ).equals( "" ) && (innerParam.get( "eaType" ) == null || innerParam.get( "eaType" ).equals( "" )) ) {
			innerParam.put( "eaType", orgAdapterDAO.getCompEaType( innerParam ) );
		}
		if ( (innerParam.get( "mainDeptYn" ) == null || innerParam.get( "mainDeptYn" ).equals( "" )) && !innerParam.get( "callType" ).equals( "saveMyEmp" ) /*&& !innerParam.get( "callType" ).equals( "updateEmp" )*/) {
			innerParam.put( "mainDeptYn", "Y" );
		}
		if ( innerParam.get( "nativeLangCode" ) != null ) {
			
			if(innerParam.get( "nativeLangCode" ).equals("")) {
				innerParam.put( "nativeLangCode", "kr" );	
			}else {
				innerParam.put( "nativeLangCode", innerParam.get( "nativeLangCode" ).toString().toLowerCase() );	
			}
		}			
		
		//패스워드 변경
		if ( innerParam.get( "callType" ).equals( "updatePasswd" ) ) {
			//updateEmp
			if ( orgAdapterDAO.updateEmp( innerParam ) < 1 ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmp Fail]" );
				return resultMap;
			}
		}
		else if ( innerParam.get( "callType" ).equals( "saveEmp" ) && (innerParam.get( "empSeq" ) == null || innerParam.get( "empSeq" ).equals( "" )) ) {
			innerParam.put( "syncType", "I" );
			
			Map<String, Object> empDuplicateParam = new HashMap<String, Object>( );
			empDuplicateParam.putAll(paramMap);
			
			if(paramMap.get("loginId") != null && !paramMap.get("loginId").equals("")){

				empDuplicateParam.put("emailAddr", "");
				String loginIdDuplicate = orgAdapterDAO.getEmpDuplicate( empDuplicateParam );
				
				if(loginIdDuplicate.equals("1")){
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010697", "로그인계정 중복" ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0001" );
					return resultMap;				
				}else if(loginIdDuplicate.equals("2")){
					resultMap.put( "result", BizboxAMessage.getMessage( "TX800000075", "추측하기 쉬운 로그인계정" ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0002" );
					return resultMap;
				}				
				
			}else{
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000010808", "로그인 아이디는 필수입니다" ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "ESA0003" );
				return resultMap;					
			}
			
			if(paramMap.get("emailAddr") != null && !paramMap.get("emailAddr").equals("")){

				empDuplicateParam.put("loginId", "");
				empDuplicateParam.put("emailAddr", paramMap.get("emailAddr"));
				String loginIdDuplicate = orgAdapterDAO.getEmpDuplicate( empDuplicateParam );
				
				//메일계정 한글여부 체크
				boolean emailAddrValidation = Pattern.matches(".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*", paramMap.get("emailAddr").toString());
				if(emailAddrValidation) {
					resultMap.put( "result", BizboxAMessage.getMessage( "", "메일계정 오류(한글포함)" ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0014" );
					return resultMap;	
				}
				
				if(loginIdDuplicate.equals("1")){
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010696", "메일계정 중복" ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0004" );
					return resultMap;				
				}else if(loginIdDuplicate.equals("2")){
					resultMap.put( "result", BizboxAMessage.getMessage( "TX800000076", "추측하기 쉬운 메일계정" ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0005" );
					return resultMap;
				}				
				
			}		
			
			//신규입사처리
			if ( innerParam.get( "empName" ) == null || innerParam.get( "empName" ).equals( "" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002056", "사원명은 필수 입력입니다." ) );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0005" );
				return resultMap;
			}
			//라이센스 체크
			if ( innerParam.get( "licenseCheckYn" ) == null || innerParam.get( "licenseCheckYn" ).equals( "" ) ) {
				innerParam.put( "licenseCheckYn", "1" );
			}
			
			if ( !innerParam.get( "licenseCheckYn" ).equals( "3" ) ) {
				innerParam.put( "type", "addEmp" );
				innerParam.put( "licenseCheck", "Y" );
				if ( innerParam.get( "licenseCheckYn" ).equals( "2" ) ) {
					innerParam.put( "licenseAddGubun", "mail" );
				}
				else {
					innerParam.put( "licenseAddGubun", "gw" );
				}
				Map<String, Object> licenseCountCheck = new HashMap<String, Object>( );
				licenseCountCheck = licenseService.LicenseAddCheck( innerParam );
				if ( licenseCountCheck.get( "resultCode" ).equals( "-4" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000019398", "그룹웨어 라이센스 수가 초과되었습니다." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0007" );
					return resultMap;
				}
				if ( licenseCountCheck.get( "resultCode" ).equals( "-5" ) ) {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000019399", "메일 라이센스 수가 초과되었습니다." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "ESA0007" );
					return resultMap;
				}
			}else{
				innerParam.put( "useYn", "N" );
				
				//sh_modi_20221014 비라이선스사용자의 경우 mainCompYn이 Null로 설정되는것을 'Y'로 변경하기 위하여 추가
				innerParam.put( "mainCompYn", "Y" );
				
			}
			
			//부서코드여부 체크
			if ( innerParam.get( "deptSeq" ) == null || orgAdapterDAO.getDeptCnt( innerParam ).equals( "0" ) ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000010698", "부서코드없음" ) );
				return resultMap;
			}			
			
			//라이센스체크 완료
			innerParam.put( "name", "orgchart" );
			
			String newEmpSeq = "";
			
			if(innerParam.get("empSeqDef") != null && !innerParam.get("empSeqDef").equals("")) {
				
				Map<String, Object> sDefParam = new HashMap<String, Object>( );
				sDefParam.putAll( paramMap );
				
				if(orgAdapterDAO.getEmpDefCnt(sDefParam).equals("0")) {
					newEmpSeq = innerParam.get("empSeqDef").toString();
				}else {
					resultMap.put( "result", BizboxAMessage.getMessage("TX800000077","empSeqDef 중복키가 존재합니다.") );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0004" );
					return resultMap;					
				}
				
			}else {
				newEmpSeq = orgAdapterDAO.getOrgSequence( innerParam );	
			}	
			
			if ( innerParam.get( "useYn" ) == null || innerParam.get( "useYn" ).equals( "" ) ) {
				innerParam.put( "useYn", "Y" );
			}
			
			if ( innerParam.get( "nativeLangCode" ) == null || innerParam.get( "nativeLangCode" ).equals( "" ) ) {
				innerParam.put( "nativeLangCode", "kr" );
			}
			
			if ( innerParam.get( "loginPasswd" ) == null || innerParam.get( "loginPasswd" ).equals( "" ) ) {
				
				Map<String, Object> groupInfo = orgAdapterDAO.selectGroupInfo(innerParam);
				
				if(groupInfo != null) {
					innerParam.put( "loginPasswd", groupInfo.get("masterPasswd") );
				}
				
			}			
			
			innerParam.put( "empSeq", newEmpSeq );
			paramMap.put( "empSeq", newEmpSeq );
			resultMap.put( "newEmpSeq", newEmpSeq );
			innerParam.put( "passwdInputFailCount", "0" );
			innerParam.put( "passwdDate", EgovDateUtil.today( "yyyy-MM-dd HH:mm:ss" ) );
			innerParam.put( "mainCompLoginYn", "Y" );
			innerParam.put( "privateYn", "Y" );
			innerParam.put( "mainDeptYn", "Y" );
			innerParam.put( "mainCompSeq", innerParam.get( "compSeq" ) );
			//insertEmp
			try {
				orgAdapterDAO.insertEmp( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmp Fail] > " + e.getMessage() );
				return resultMap;
			}
			//insertEmpMulti(kr)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "empName" ) + "" ) ) {
				innerParam.put( "empName", paramMap.get( "empName" ) );
				innerParam.put( "langCode", "kr" );
				try {
					orgAdapterDAO.insertEmpMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertEmpMulti(en)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "empNameEn" ) + "" ) ) {
				innerParam.put( "empName", paramMap.get( "empNameEn" ) + "" );
				innerParam.put( "langCode", "en" );
				try {
					orgAdapterDAO.insertEmpMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(en) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertEmpMulti(jp)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "empNameJp" ) + "" ) ) {
				innerParam.put( "empName", paramMap.get( "empNameJp" ) + "" );
				innerParam.put( "langCode", "jp" );
				try {
					orgAdapterDAO.insertEmpMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(jp) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}
			//insertEmpMulti(cn)
			if ( !EgovStringUtil.isEmpty( paramMap.get( "empNameCn" ) + "" ) ) {
				innerParam.put( "empName", paramMap.get( "empNameCn" ) + "" );
				innerParam.put( "langCode", "cn" );
				try {
					orgAdapterDAO.insertEmpMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(cn) Fail] > " + e.getMessage() );
					return resultMap;
				}
			}

			//insertEmpDept
			try {
				if ( innerParam.get( "orderNum" ) == null || innerParam.get( "orderNum" ).equals( "" ) ) {
					innerParam.put( "orderNum", "100" );
				}
				
				if ( innerParam.get( "orgchartDisplayYn" ) == null || innerParam.get( "orgchartDisplayYn" ).equals( "" ) ) {
					innerParam.put( "orgchartDisplayYn", "Y" );
				}
				
				if ( innerParam.get( "messengerDisplayYn" ) == null || innerParam.get( "messengerDisplayYn" ).equals( "" ) ) {
					innerParam.put( "messengerDisplayYn", "Y" );
				}
				
				//메일, 비라이선스일 경우 메신저/모바일 조직도표시여부 N셋팅
				if ( innerParam.get( "licenseCheckYn" ) == null || !innerParam.get( "licenseCheckYn" ).equals( "1" ) ) {
					innerParam.put( "messengerDisplayYn", "N" );
				}
				
				orgAdapterDAO.insertEmpDept( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpDept Fail] > " + e.getMessage() );
				return resultMap;
			}
			//insertEmpDeptMulti
			try {
				innerParam.put( "langCode", "kr" );
				orgAdapterDAO.insertEmpDeptMulti( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpDeptMulti Fail] > " + e.getMessage() );
				return resultMap;
			}
			//insertEmpComp
			try {
				orgAdapterDAO.insertEmpComp( innerParam );
			}
			catch ( Exception e ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpComp Fail] > " + e.getMessage() );
				return resultMap;
			}
			//insertEmpCalendar
			try {
				orgAdapterDAO.insertEmpCalendar( innerParam );
			}
			catch ( Exception e ) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				/*
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0003" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpCalendar Fail] > " + e.getMessage() );
				return resultMap;
				*/
			}
			//기본부여권한 추가
			if ( innerParam.get( "authCodeList" ) == null ) {
				innerParam.put( "authorCode", "" );
				orgAdapterDAO.insertEmpBaseAuth( innerParam );
			}
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000016584", "등록이 완료 되었습니다" ) );
			
			//위하고 조직도 연동 Sync
			wehago.wehagoInsertEmpOneSync(paramMap.get("groupSeq").toString(), paramMap.get("compSeq").toString(), newEmpSeq, "I");

		}
		else {
			//사원정보 수정 및 사원부서 매핑(추가/수정)
			//라이센스 체크
			Map<String, Object> empInfo = orgAdapterDAO.selectEmpInfo( innerParam );
			if ( empInfo == null ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000009312", "사용자 정보가 존재하지  않습니다" ) );
				resultMap.put( "resultDetailCode", "UC0002" );
				resultMap.put( "resultCode", "fail" );
				return resultMap;
			}
			//부서코드 체크
			if ( innerParam.get( "deptSeqNew" ) != null && !innerParam.get( "deptSeqNew" ).equals( "" ) ) {
				Map<String, Object> deptCntCheck = new HashMap<String, Object>( );
				deptCntCheck.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
				if ( orgAdapterDAO.getDeptCnt( deptCntCheck ).equals( "0" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010698", "부서코드없음" ) );
					return resultMap;
				}
			}
			else if ( innerParam.get( "deptSeq" ) != null && !innerParam.get( "deptSeq" ).equals( "" ) ) {
				if ( orgAdapterDAO.getDeptCnt( innerParam ).equals( "0" ) ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000010698", "부서코드없음" ) );
					return resultMap;
				}
			}
			
			if ( innerParam.get( "licenseCheckYn" ) == null || innerParam.get( "licenseCheckYn" ).equals( "" ) ) {
				innerParam.put( "licenseCheckYn", empInfo.get( "licenseCheckYn" ) );
			}
			
			//비라이센스는 미사용 디폴트처리
			if(innerParam.get( "licenseCheckYn" ).equals("3")){
				innerParam.put( "useYn", "N" );
			}			
			
			Map<String, Object> empCompInfo = orgAdapterDAO.selectEmpCompInfo( innerParam );
			if ( innerParam.get( "useYn" ) == null || innerParam.get( "useYn" ).equals( "" ) ) {
				if ( empCompInfo != null ) {
					innerParam.put( "useYn", empCompInfo.get( "useYn" ) );
				}
				else {
					innerParam.put( "useYn", "Y" );
				}
			}
			if ( innerParam.get( "workStatus" ) == null || innerParam.get( "workStatus" ).equals( "" ) ) {
				if ( empCompInfo != null ) {
					innerParam.put( "workStatus", empCompInfo.get( "workStatus" ) );
				}
				else {
					innerParam.put( "workStatus", "999" );
				}
			}
			if ( !innerParam.get( "licenseCheckYn" ).equals( "3" ) && !innerParam.get( "workStatus" ).equals( "001" ) && innerParam.get( "useYn" ) != null && innerParam.get( "useYn" ).equals( "Y" ) ) {
				
				if (empInfo.get( "licenseCheckYn" ).equals( "3" ) || empInfo.get( "workStatus" ).equals( "001" ) || empInfo.get( "useYn" ).equals( "N" ) || (empInfo.get( "licenseCheckYn" ).equals( "2" ) && innerParam.get( "licenseCheckYn" ).equals( "1" ))) {
					//미사용 > 사용 || 퇴직 > 재직 || 메일 > 그룹웨어 || 비라이센스 > 메일 or 그룹웨어
					if ( (empInfo.get( "useYn" ).equals( "N" ) && innerParam.get( "useYn" ).equals( "Y" )) || (empInfo.get( "workStatus" ).equals( "001" ) && !innerParam.get( "workStatus" ).equals( "001" )) || (empInfo.get( "licenseCheckYn" ).equals( "2" ) && innerParam.get( "licenseCheckYn" ).equals( "1" )) || (empInfo.get( "licenseCheckYn" ).equals( "3" ) && !innerParam.get( "licenseCheckYn" ).equals( "3" )) ) {
						innerParam.put( "type", "addEmp" );
						innerParam.put( "licenseCheck", "Y" );
						if ( innerParam.get( "licenseCheckYn" ).equals( "2" ) ) {
							innerParam.put( "licenseAddGubun", "mail" );
						}
						else {
							//메일 > 그룹웨어 라이센스 이동일 경우 							
							if(empInfo.get( "licenseCheckYn" ).equals( "2" )) {
								innerParam.put( "licenseAddGubunExt", "mail2gw" );	
							}
							
							innerParam.put( "licenseAddGubun", "gw" );	
						}
						
						Map<String, Object> licenseCountCheck = new HashMap<String, Object>( );
						licenseCountCheck = licenseService.LicenseAddCheck( innerParam );
						if ( licenseCountCheck.get( "resultCode" ).equals( "-4" ) ) {
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000019398", "그룹웨어 라이센스 수가 초과되었습니다." ) );
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "ESA0007" );
							return resultMap;
						}
						if ( licenseCountCheck.get( "resultCode" ).equals( "-5" ) ) {
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000019399", "메일 라이센스 수가 초과되었습니다." ) );
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "ESA0007" );
							return resultMap;
						}
					}
				}
			}
			//사원부서매핑이 아닌경우(일반 사용자 수정)
			if ( innerParam.get( "callType" ).equals( "saveEmp" ) || innerParam.get( "callType" ).equals( "updateEmp" ) || innerParam.get( "callType" ).equals( "saveMyEmp" ) ) {
				//updateEmp
				if ( orgAdapterDAO.updateEmp( innerParam ) < 1 ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmp Fail]" );
					return resultMap;
				}

				//updateEmpMulti(kr)
				try {
					orgAdapterDAO.updateEmpMulti( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpMulti(kr) Fail] > " + e.getMessage() );
					return resultMap;
				}
				
				//insertEmpMulti(en)
				if ( paramMap.get( "empNameEn" ) != null ) {
					innerParam.put( "empName", paramMap.get( "empNameEn" ) );
					innerParam.put( "langCode", "en" );
					try {
						orgAdapterDAO.deleteEmpMulti( innerParam );
						if ( !paramMap.get( "empNameEn" ).equals( "" ) ) {
							orgAdapterDAO.insertEmpMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertEmpMulti(jp)
				if ( paramMap.get( "empNameJp" ) != null ) {
					innerParam.put( "empName", paramMap.get( "empNameJp" ) );
					innerParam.put( "langCode", "jp" );
					try {
						orgAdapterDAO.deleteEmpMulti( innerParam );
						if ( !paramMap.get( "empNameJp" ).equals( "" ) ) {
							orgAdapterDAO.insertEmpMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertEmpMulti(en)
				if ( paramMap.get( "empNameCn" ) != null ) {
					innerParam.put( "empName", paramMap.get( "empNameCn" ) );
					innerParam.put( "langCode", "cn" );
					try {
						orgAdapterDAO.deleteEmpMulti( innerParam );
						if ( !paramMap.get( "empNameCn" ).equals( "" ) ) {
							orgAdapterDAO.insertEmpMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
			}
			//부서매핑 추가
			if ( innerParam.get( "deptSeq" ) == null || innerParam.get( "deptSeq" ).equals( "" ) ) {
				if ( innerParam.get( "deptSeqNew" ) != null && !innerParam.get( "deptSeqNew" ).equals( "" ) ) {
					//부서매핑 추가
					innerParam.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
					innerParam.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( innerParam ) );
					//추가할 부서매핑 체크
					boolean newEmpDeptYn = false;
					if ( !orgAdapterDAO.getNewEmpDeptCnt( innerParam ).equals( "0" ) ) {
						newEmpDeptYn = true;
					}
					if ( newEmpDeptYn ) {
						//해당부서 매핑정보 있을경우 업데이트
						//주부서 > 부부서 수정일 경우 처리불가
						if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "N" ) ) {
							Map<String, Object> oldEmpDept = orgAdapterDAO.selectEmpDeptInfo( innerParam );
							if ( oldEmpDept != null && oldEmpDept.get( "mainDeptYn" ).equals( "Y" ) ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "ESA0006" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000010645", "주부서만 있는 경우 부부서로 변경 할 수 없습니다" ) );
								return resultMap;
							}
						}
						Map<String, Object> oldEmpDeptInfo = orgAdapterDAO.selectEmpDept( innerParam );
						Map<String, Object> empDeptToEa = new HashMap<String, Object>( );
						empDeptToEa.put( "compSeq", innerParam.get( "compSeq" ) );
						empDeptToEa.put( "deptSeq", innerParam.get( "deptSeq" ) );
						empDeptToEa.put( "empSeq", innerParam.get( "empSeq" ) );
						empDeptToEa.put( "deptSeqNew", innerParam.get( "deptSeq" ) );
						if ( innerParam.get( "createSeq" ) != null && !innerParam.get( "createSeq" ).equals( "" ) ) {
							empDeptToEa.put( "createSeq", innerParam.get( "createSeq" ) );
						}
						//부서수정여부 세팅
						empDeptToEa.put( "deptChange", "N" );
						//직급수정여부 세팅
						if ( innerParam.get( "positionCode" ) != null && (oldEmpDeptInfo.get( "positionCode" ) == null || !oldEmpDeptInfo.get( "positionCode" ).equals( innerParam.get( "positionCode" ) )) ) {
							empDeptToEa.put( "positionChange", "Y" );
						}
						else {
							empDeptToEa.put( "positionChange", "N" );
						}
						//직책수정여부 세팅
						if ( innerParam.get( "dutyCode" ) != null && (oldEmpDeptInfo.get( "dutyCode" ) == null || !oldEmpDeptInfo.get( "dutyCode" ).equals( innerParam.get( "dutyCode" ) )) ) {
							empDeptToEa.put( "dutyChange", "Y" );
						}
						else {
							empDeptToEa.put( "dutyChange", "N" );
						}
						
						//메일, 비라이선스일 경우 메신저/모바일 조직도표시여부 N셋팅
						if ( innerParam.get( "licenseCheckYn" ) == null || !innerParam.get( "licenseCheckYn" ).equals( "1" ) ) {
							innerParam.put( "messengerDisplayYn", "N" );
						}
						
						//updateEmpDept
						if ( orgAdapterDAO.updateEmpDept( innerParam ) < 1 ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDept Fail]" );
							return resultMap;
						}
						//updateEmpDeptMulti
						if ( orgAdapterDAO.updateEmpDeptMulti( innerParam ) < 1 ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDeptMulti Fail]" );
							return resultMap;
						}
						//전자결재 진행문서 보정
						if ( innerParam.get( "eaType" ) != null && innerParam.get( "eaType" ).equals( "eap" ) ) {
							if ( empDeptToEa.get( "positionChange" ).equals( "Y" ) || empDeptToEa.get( "dutyChange" ).equals( "Y" ) ) {
								orgAdapterDAO.updateEaProgressInfo( empDeptToEa );
							}
						}
					}
					else {
						//해당부서 매핑정보 없을경우 Insert
						//insertEmpDept
						try {
							
							if ( innerParam.get( "orgchartDisplayYn" ) == null || innerParam.get( "orgchartDisplayYn" ).equals( "" ) ) {
								innerParam.put( "orgchartDisplayYn", "Y" );
							}
							
							if ( innerParam.get( "messengerDisplayYn" ) == null || innerParam.get( "messengerDisplayYn" ).equals( "" ) ) {
								innerParam.put( "messengerDisplayYn", "Y" );
							}							
							
							orgAdapterDAO.insertEmpDept( innerParam );
						}
						catch ( Exception e ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertNewEmpDept Fail] > " + e.getMessage() );
							return resultMap;
						}
						//insertEmpDeptMulti
						try {
							innerParam.put( "langCode", "kr" );
							orgAdapterDAO.insertEmpDeptMulti( innerParam );
						}
						catch ( Exception e ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertNewEmpDeptMulti Fail] > " + e.getMessage() );
							return resultMap;
						}
					}
					if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "Y" ) ) {
						if ( orgAdapterDAO.getEmpCompCnt( innerParam ).equals( "0" ) ) {
							//insertEmpComp
							try {
								orgAdapterDAO.insertEmpComp( innerParam );
							}
							catch ( Exception e ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpComp Fail] > " + e.getMessage() );
								return resultMap;
							}
						}
						else {
							//updateEmpComp
							if ( orgAdapterDAO.updateEmpComp( innerParam ) < 1 ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpComp Fail]" );
								return resultMap;
							}
						}
						
						//기본부여권한 추가(영리/비영리)
						if ( innerParam.get( "authCodeList" ) == null ) {
							innerParam.put( "authorCode", "" );
							orgAdapterDAO.insertEmpBaseAuth( innerParam );
						}						
					}
					else {
						//부부서에 기본부여권한 추가(비영리)
						if ( innerParam.get( "eaType" ) != null && innerParam.get( "eaType" ).equals( "ea" ) && innerParam.get( "authCodeList" ) == null ) {
							innerParam.put( "authorCode", "" );
							orgAdapterDAO.insertEmpBaseAuth( innerParam );
						}
					}
				}
				else {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000001954", "부서가 존재하지 않습니다. 다시 입력해 주십시오." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					return resultMap;
				}
			}
			else if ( innerParam.get( "deptSeqNew" ) != null && !innerParam.get( "deptSeqNew" ).equals( "" ) && innerParam.get( "deptSeq" ) != null && !innerParam.get( "deptSeq" ).equals( innerParam.get( "deptSeqNew" ) ) ) {
				//부서이동 시(사원정보관리 or 사원부서매핑)
				//주부서 > 부부서 수정일 경우 처리불가
				if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "N" ) ) {
					Map<String, Object> oldEmpDept = orgAdapterDAO.selectEmpDeptInfo( innerParam );
					if ( oldEmpDept != null && oldEmpDept.get( "mainDeptYn" ).equals( "Y" ) ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "ESA0006" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000010645", "주부서만 있는 경우 부부서로 변경 할 수 없습니다" ) );
						return resultMap;
					}
				}
				else {
					Map<String, Object> oldEmpDept = orgAdapterDAO.selectEmpDeptInfo( innerParam );
					if ( oldEmpDept != null ) {
						innerParam.put( "mainDeptYn", oldEmpDept.get( "mainDeptYn" ) );
					}
				}
				boolean oldEmpDeptYn = false;
				boolean newEmpDeptYn = false;
				//기존매핑부서정보 체크
				if ( !orgAdapterDAO.getEmpDeptCnt( innerParam ).equals( "0" ) ) {
					oldEmpDeptYn = true;
				}
				//변경할부서정보 체크
				if ( !orgAdapterDAO.getNewEmpDeptCnt( innerParam ).equals( "0" ) ) {
					newEmpDeptYn = true;
				}
				//기존부서정보가 있고 변경할 부서정보가 없을 경우(정상 이동)
				if ( oldEmpDeptYn && !newEmpDeptYn ) {
					//empDept, empDeptMulti 복사
					Map<String, Object> oldEmpDeptInfo = orgAdapterDAO.selectEmpDept( innerParam );
					Map<String, Object> oldEmpDept = new HashMap<String, Object>( );
					Map<String, Object> empDeptToDel = new HashMap<String, Object>( );
					empDeptToDel.put( "compSeq", innerParam.get( "compSeq" ) );
					empDeptToDel.put( "deptSeq", innerParam.get( "deptSeq" ) );
					empDeptToDel.put( "empSeq", innerParam.get( "empSeq" ) );
					empDeptToDel.put( "deptSeqNew", innerParam.get( "deptSeqNew" ) );
					if ( innerParam.get( "createSeq" ) != null && !innerParam.get( "createSeq" ).equals( "" ) ) {
						empDeptToDel.put( "createSeq", innerParam.get( "createSeq" ) );
					}
					//부서수정여부 세팅
					empDeptToDel.put( "deptChange", "Y" );
					//직급수정여부 세팅
					if ( innerParam.get( "positionCode" ) != null && (oldEmpDeptInfo.get( "positionCode" ) == null || !oldEmpDeptInfo.get( "positionCode" ).equals( innerParam.get( "positionCode" ) )) ) {
						empDeptToDel.put( "positionChange", "Y" );
					}
					else {
						empDeptToDel.put( "positionChange", "N" );
					}
					//직책수정여부 세팅
					if ( innerParam.get( "dutyCode" ) != null && (oldEmpDeptInfo.get( "dutyCode" ) == null || !oldEmpDeptInfo.get( "dutyCode" ).equals( innerParam.get( "dutyCode" ) )) ) {
						empDeptToDel.put( "dutyChange", "Y" );
					}
					else {
						empDeptToDel.put( "dutyChange", "N" );
					}
					oldEmpDept.putAll( oldEmpDeptInfo );
					oldEmpDept.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
					oldEmpDept.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( oldEmpDept ) );
					oldEmpDept.put( "deptZipCode", oldEmpDept.get( "zipCode" ) );
					try {
						orgAdapterDAO.insertEmpDept( oldEmpDept );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertNewEmpDept Fail] > " + e.getMessage() );
						return resultMap;
					}
					Map<String, Object> oldEmpDeptMultiInfo = orgAdapterDAO.selectEmpDeptMulti( innerParam );
					Map<String, Object> oldEmpDeptMulti = new HashMap<String, Object>( );
					if ( oldEmpDeptMultiInfo != null ) {
						oldEmpDeptMulti.putAll( oldEmpDeptMultiInfo );
						oldEmpDept.put( "deptZipCode", oldEmpDept.get( "zipCode" ) );
						oldEmpDeptMulti.put( "deptAddr", oldEmpDeptMulti.get( "addr" ) );
						oldEmpDeptMulti.put( "deptDetailAddr", oldEmpDeptMulti.get( "detailAddr" ) );
					}
					else {
						oldEmpDeptMulti.putAll( innerParam );
					}
					oldEmpDeptMulti.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
					oldEmpDeptMulti.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( oldEmpDeptMulti ) );
					oldEmpDeptMulti.put( "langCode", "kr" );
					try {
						orgAdapterDAO.insertEmpDeptMulti( oldEmpDeptMulti );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertNewEmpDeptMulti Fail] > " + e.getMessage() );
						return resultMap;
					}
					innerParam.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
					innerParam.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( innerParam ) );
					//updateEmpDept
					if ( orgAdapterDAO.updateEmpDept( innerParam ) < 1 ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateNewEmpDept Fail]" );
						return resultMap;
					}
					//updateEmpDeptMulti
					if ( orgAdapterDAO.updateEmpDeptMulti( innerParam ) < 1 ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateNewEmpDeptMulti Fail]" );
						return resultMap;
					}
					if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "Y" ) ) {
						if ( orgAdapterDAO.getEmpCompCnt( innerParam ).equals( "0" ) ) {
							//insertEmpComp
							try {
								orgAdapterDAO.insertEmpComp( innerParam );
							}
							catch ( Exception e ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpComp Fail]" );
								return resultMap;
							}
						}
						else {
							//updateEmpComp
							if ( orgAdapterDAO.updateEmpComp( innerParam ) < 1 ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpComp Fail]" );
								return resultMap;
							}
						}
					}
					//기존부서정보 삭제
					orgAdapterDAO.deleteEmpDeptMulti( empDeptToDel );
					orgAdapterDAO.deleteEmpDept( empDeptToDel );
					//권한 부서시퀀스 업데이트
					orgAdapterDAO.deleteEmpAuth( oldEmpDept );
					orgAdapterDAO.updateEmpBaseAuth( empDeptToDel );
					
					// 접근가능IP 설정 부서 업데이트 처리
					orgAdapterDAO.updateAccessIpRelate( empDeptToDel );
					
					//전자결재 진행문서 보정
					if ( innerParam.get( "eaType" ) != null && innerParam.get( "eaType" ).equals( "eap" ) ) {
						orgAdapterDAO.updateEaProgressInfo( empDeptToDel );
					}
				}
				else if ( newEmpDeptYn ) {
					innerParam.put( "deptSeq", innerParam.get( "deptSeqNew" ) );
					innerParam.put( "bizSeq", orgAdapterDAO.getDeptBizSeq( innerParam ) );
					//주부서 > 부부서 수정일 경우 처리불가
					if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "N" ) ) {
						Map<String, Object> oldEmpDept = orgAdapterDAO.selectEmpDeptInfo( innerParam );
						if ( oldEmpDept != null && oldEmpDept.get( "mainDeptYn" ).equals( "Y" ) ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "ESA0006" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000010645", "주부서만 있는 경우 부부서로 변경 할 수 없습니다" ) );
							return resultMap;
						}
					}
					//일반 수정
					Map<String, Object> oldEmpDeptInfo = orgAdapterDAO.selectEmpDept( innerParam );
					Map<String, Object> empDeptToEa = new HashMap<String, Object>( );
					empDeptToEa.put( "compSeq", innerParam.get( "compSeq" ) );
					empDeptToEa.put( "deptSeq", innerParam.get( "deptSeq" ) );
					empDeptToEa.put( "empSeq", innerParam.get( "empSeq" ) );
					empDeptToEa.put( "deptSeqNew", innerParam.get( "deptSeq" ) );
					if ( innerParam.get( "createSeq" ) != null && !innerParam.get( "createSeq" ).equals( "" ) ) {
						empDeptToEa.put( "createSeq", innerParam.get( "createSeq" ) );
					}
					//부서수정여부 세팅
					empDeptToEa.put( "deptChange", "N" );
					//직급수정여부 세팅
					if ( innerParam.get( "positionCode" ) != null && (oldEmpDeptInfo.get( "positionCode" ) == null || !oldEmpDeptInfo.get( "positionCode" ).equals( innerParam.get( "positionCode" ) )) ) {
						empDeptToEa.put( "positionChange", "Y" );
					}
					else {
						empDeptToEa.put( "positionChange", "N" );
					}
					//직책수정여부 세팅
					if ( innerParam.get( "dutyCode" ) != null && (oldEmpDeptInfo.get( "dutyCode" ) == null || !oldEmpDeptInfo.get( "dutyCode" ).equals( innerParam.get( "dutyCode" ) )) ) {
						empDeptToEa.put( "dutyChange", "Y" );
					}
					else {
						empDeptToEa.put( "dutyChange", "N" );
					}
					//updateEmpDept
					if ( orgAdapterDAO.updateEmpDept( innerParam ) < 1 ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDept Fail]" );
						return resultMap;
					}
					//updateEmpDeptMulti
					if ( orgAdapterDAO.updateEmpDeptMulti( innerParam ) < 1 ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDeptMulti Fail]" );
						return resultMap;
					}
					if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "Y" ) ) {
						if ( orgAdapterDAO.getEmpCompCnt( innerParam ).equals( "0" ) ) {
							//insertEmpComp
							try {
								orgAdapterDAO.insertEmpComp( innerParam );
							}
							catch ( Exception e ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpComp Fail]" );
								return resultMap;
							}
						}
						else {
							//updateEmpComp
							if ( orgAdapterDAO.updateEmpComp( innerParam ) < 1 ) {
								resultMap.put( "resultCode", "fail" );
								resultMap.put( "resultDetailCode", "UC0003" );
								resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpComp Fail]" );
								return resultMap;
							}
						}
					}
					//전자결재 진행문서 보정
					if ( innerParam.get( "eaType" ) != null && innerParam.get( "eaType" ).equals( "eap" ) ) {
						if ( empDeptToEa.get( "positionChange" ).equals( "Y" ) || empDeptToEa.get( "dutyChange" ).equals( "Y" ) ) {
							orgAdapterDAO.updateEaProgressInfo( empDeptToEa );
						}
					}
				}
				else {
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000001954", "부서가 존재하지 않습니다. 다시 입력해 주십시오." ) );
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0002" );
					return resultMap;
				}
				//기본부여권한 추가(비영리)
				if ( innerParam.get( "authCodeList" ) == null ) {
					innerParam.put( "authorCode", "" );
					orgAdapterDAO.insertEmpBaseAuth( innerParam );
				}
				//기타정보 보정
				orgAdapterDAO.updateDeptMovePack( innerParam );
			}
			else {
				//일반 수정
				//주부서 > 부부서 수정일 경우 처리불가
				if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "N" ) ) {
					Map<String, Object> oldEmpDept = orgAdapterDAO.selectEmpDeptInfo( innerParam );
					if ( oldEmpDept != null && oldEmpDept.get( "mainDeptYn" ).equals( "Y" ) ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "ESA0008" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000010644", "주부서 등록 후 부부서를 등록해 주세요" ) );
						return resultMap;
					}
				}
				Map<String, Object> oldEmpDeptInfo = orgAdapterDAO.selectEmpDept( innerParam );
				Map<String, Object> empDeptToEa = new HashMap<String, Object>( );
				empDeptToEa.put( "compSeq", innerParam.get( "compSeq" ) );
				empDeptToEa.put( "deptSeq", innerParam.get( "deptSeq" ) );
				empDeptToEa.put( "empSeq", innerParam.get( "empSeq" ) );
				empDeptToEa.put( "deptSeqNew", innerParam.get( "deptSeq" ) );
				if ( innerParam.get( "createSeq" ) != null && !innerParam.get( "createSeq" ).equals( "" ) ) {
					empDeptToEa.put( "createSeq", innerParam.get( "createSeq" ) );
				}
				//부서수정여부 세팅
				empDeptToEa.put( "deptChange", "N" );
				//직급수정여부 세팅
				if ( innerParam.get( "positionCode" ) != null && (oldEmpDeptInfo.get( "positionCode" ) == null || !oldEmpDeptInfo.get( "positionCode" ).equals( innerParam.get( "positionCode" ) )) ) {
					empDeptToEa.put( "positionChange", "Y" );
				}
				else {
					empDeptToEa.put( "positionChange", "N" );
				}
				//직책수정여부 세팅
				if ( innerParam.get( "dutyCode" ) != null && (oldEmpDeptInfo.get( "dutyCode" ) == null || !oldEmpDeptInfo.get( "dutyCode" ).equals( innerParam.get( "dutyCode" ) )) ) {
					empDeptToEa.put( "dutyChange", "Y" );
				}
				else {
					empDeptToEa.put( "dutyChange", "N" );
				}
				
				//workStatus가 퇴사일 경우 useYn > N
				if ( innerParam.get( "workStatus" ) != null && innerParam.get( "workStatus" ).equals( "001" ) ) {
					innerParam.put("useYn", "N");
				}
				
				//updateEmpDept
				if ( orgAdapterDAO.updateEmpDept( innerParam ) < 1 ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDept Fail]" );
					return resultMap;
				}
				//updateEmpDeptMulti
				if ( orgAdapterDAO.updateEmpDeptMulti( innerParam ) < 1 ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpDeptMulti Fail]" );
					return resultMap;
				}
				//updateEmpComp
				if ( innerParam.get( "mainDeptYn" ) != null && innerParam.get( "mainDeptYn" ).equals( "Y" ) ) {
					
					if ( orgAdapterDAO.getEmpCompCnt( innerParam ).equals( "0" ) ) {
						//insertEmpComp
						try {
							orgAdapterDAO.insertEmpComp( innerParam );
						}
						catch ( Exception e ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertEmpComp Fail]" );
							return resultMap;
						}
					}
					else {
						//updateEmpComp
						if ( orgAdapterDAO.updateEmpComp( innerParam ) < 1 ) {
							resultMap.put( "resultCode", "fail" );
							resultMap.put( "resultDetailCode", "UC0003" );
							resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateEmpComp Fail]" );
							return resultMap;
						}
					}
					
					//퇴사정보 업데이트
					if(innerParam.get("workStatus") != null && innerParam.get("workStatus").equals("001")){
						orgAdapterDAO.updateEmpResignInfo(innerParam);
					}
					
				}
				
				//전자결재 진행문서 보정
				if ( innerParam.get( "eaType" ) != null && innerParam.get( "eaType" ).equals( "eap" ) ) {
					if ( empDeptToEa.get( "positionChange" ).equals( "Y" ) || empDeptToEa.get( "dutyChange" ).equals( "Y" ) ) {
						orgAdapterDAO.updateEaProgressInfo( empDeptToEa );
					}
				}
				
				//부부서 > 주부서 변경 시 기본권한 세팅
				if(oldEmpDeptInfo.get("mainDeptYn") != null && oldEmpDeptInfo.get("mainDeptYn").equals("N") && innerParam.get("mainDeptYn") != null && innerParam.get("mainDeptYn").equals("Y")){
					orgAdapterDAO.insertEmpBaseAuth(innerParam);
				}
					
			}
			
			//위하고 조직도 연동 Sync
			if(innerParam.get("mainDeptYn") != null && innerParam.get("mainDeptYn").equals("Y")) {
				
				if((innerParam.get("deptSeqNew") != null && !innerParam.get("deptSeqNew").equals("")) ||
				(innerParam.get("positionCode") != null && !innerParam.get("positionCode").equals("")) ||
				(innerParam.get("dutyCode") != null && !innerParam.get("dutyCode").equals(""))) {
					wehago.wehagoInsertEmpOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), innerParam.get("empSeq").toString(), "M");		
				}
				
			}
			
			//프로필 이미지 제거
			//프로필 이미 선택을 하든 안하든 일단 기존 프로필 이미지를 제거 후 업로드.
			if ( innerParam.get( "picFileId" ) != null && innerParam.get( "picFileId" ).equals( "" ) && innerParam.get( "Old_picFileId" ) != null && !innerParam.get( "Old_picFileId" ).equals( "" ) ) {
				innerParam.put( "pathSeq", "910" );
				innerParam.put( "osType", NeosConstants.SERVER_OS );
				Map<String, Object> groupPathList = orgAdapterDAO.selectGroupPath( innerParam );
				if ( groupPathList != null ) {
					//프로필 저장 경로 셋팅
					String filePath = groupPathList.get( "absolPath" ).toString( ) + "/" + innerParam.get( "groupSeq" ).toString( ) + "/";
					File path = new File( filePath );
					File[] fileList = path.listFiles( );
					if ( fileList != null ) {
						for ( File file : fileList ) {
							//프로필 저장 폴더 자신의 프로필이미지(썸네일)삭제. 원본파일은 유지.
							if ( file.getName( ).startsWith( innerParam.get( "empSeq" ).toString( ) + "_thum." ) ) {
								file.delete( );
							}
						}
					}
				}
			}
			
			//프로필 이미지 FTP 전송
			if(innerParam.get( "picFileId" ) != null && !innerParam.get( "picFileId" ).equals( "" ) && (innerParam.get( "Old_picFileId" ) == null || !innerParam.get( "Old_picFileId" ).equals(innerParam.get( "picFileId" )))) {
				ftpProfileSync(innerParam);
			}
			
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000001984", "수정이 완료되었습니다." ) );
		}
		//권한추가 (기존권한 삭제후 등록).
		if ( innerParam.get( "authCodeList" ) != null ) {
			String sAuthCodeList = innerParam.get( "authCodeList" ).toString( );
			orgAdapterDAO.deleteEmpAuth( innerParam );
			if ( !sAuthCodeList.equals( "" ) ) {
				String[] arrAuthCodeList = sAuthCodeList.split( "," );
				for ( int i = 0; i < arrAuthCodeList.length; i++ ) {
					innerParam.put( "authorCode", arrAuthCodeList[i] );
					orgAdapterDAO.insertEmpBaseAuth( innerParam );
				}
			}
		}
		resultMap.put( "erpType", "N" );
		/* erp 조직도 연동 */
		innerParam.put( "option", "cm1100" );
		Map<String, Object> erpOptions = commonOptionManageService.getErpOptionValue( innerParam );
		if ( erpOptions.get( "optionRealValue" ).equals( "1" ) ) {
			try {
				innerParam.put( "option", "cm1104" );
				Map<String, Object> sERPUpdateYN = commonOptionManageService.getErpOptionValue( innerParam );
				if ( sERPUpdateYN.get( "optionRealValue" ).equals( "1" ) ) {
					/* ERP 연동 데이터 가져오기 */
					innerParam.put( "erpGubun", "hr" );
					Map<String, Object> erpSettingInfo = orgAdapterDAO.selectErpInfo( innerParam );
					if ( erpSettingInfo != null ) {
						String driver = erpSettingInfo.get( "driver" ).toString( );
						String dataType = erpSettingInfo.get( "databaseType" ).toString( );
						String userId = erpSettingInfo.get( "userid" ).toString( );
						String password = erpSettingInfo.get( "password" ).toString( );
						String systemType = erpSettingInfo.get( "erpTypeCode" ).toString( );
						String url = erpSettingInfo.get( "url" ).toString( );
						conVo.setDatabaseType( dataType );
						conVo.setDriver( driver );
						conVo.setPassWord( password );
						conVo.setSystemType( systemType );
						conVo.setUrl( url );
						conVo.setUserId( userId );
						resultMap.put( "erpType", systemType );
						if ( systemType.equals( "iCUBE" ) ) {
							innerParam.put( "CO_CD", erpSettingInfo.get( "erpCompSeq" ) );
							updateErpEmpInfo( innerParam, conVo );
						}
					}
				}
			}
			catch ( Exception e ) {
//				StringWriter sw = new StringWriter( );
//				e.printStackTrace( new PrintWriter( sw ) );
//				String exceptionAsStrting = sw.toString( );
				logger.error( "! [EmpManage] ERROR - " + e );
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		//사원정보 보정(OrderText, EmpInfo, CheckWorkYn)
		orgAdapterDAO.updateEmpDeptCompCalibrate( innerParam );
		resultMap.put( "groupSeq", innerParam.get( "groupSeq" ) );
		resultMap.put( "compSeq", innerParam.get( "compSeq" ) );
		resultMap.put( "deptSeq", innerParam.get( "deptSeq" ) );
		resultMap.put( "empSeq", innerParam.get( "empSeq" ) );
		resultMap.put( "resultCode", "SUCCESS" );
		if ( BizboxAProperties.getCustomProperty( "BizboxA.Cust.LdapUseYn" ).equals( "Y" ) ) {
			//AD연동 I/F테이블에 INSERT
			Map<String, Object> adParamMap = new HashMap<String, Object>( );
			adParamMap.putAll( innerParam );
			adParamMap.put( "empName", paramMap.get( "empName" ) );
			adParamMap.put( "loginPasswd", paramMap.get( "loginPasswd" ) );
			ldapAdapterDAO.insertOrgAdapterResultEmp( adParamMap );
		}
		return resultMap;
	}

	public void updateErpEmpInfo ( Map<String, Object> params, ConnectionVO conVo ) {
		connect( conVo );
		// 세션팩토리를 이용해서 세션 객체를 생성
		SqlSession session = sqlSessionFactory.openSession( );
		try {
			Map<String, Object> erpParam = new HashMap<String, Object>( );
			/* ERP 데이터에 맞게 다국어 형식 변환 */
			if ( params.get( "nativeLangCode" ).equals( "kr" ) ) {
				erpParam.put( "LANGKIND", "KOR" );
			}
			else if ( params.get( "nativeLangCode" ).equals( "en" ) ) {
				erpParam.put( "LANGKIND", "ENG" );
			}
			else if ( params.get( "nativeLangCode" ).equals( "cn" ) ) {
				erpParam.put( "LANGKIND", "CHS" );
			}
			else if ( params.get( "nativeLangCode" ).equals( "jp" ) ) {
				erpParam.put( "LANGKIND", "JPN" );
			}
			/* 변경 파라미터 */
			erpParam.put( "CO_CD", params.get( "CO_CD" ) );
			erpParam.put( "EMP_CD", params.get( "erpEmpNum" ) );
			erpParam.put( "KOR_NM", params.get( "empName" ) );
			erpParam.put( "ENLS_NM", params.get( "empNameEn" ) );
			erpParam.put( "CHN_NM", params.get( "empNameCn" ) );
			erpParam.put( "PASS", params.get( "loginPasswdNew" ) );
			erpParam.put( "BRTH_DT", params.get( "bday" ).toString( ).replace( "-", "" ) );
			erpParam.put( "WEDDING_DAY", params.get( "weddingDay" ).toString( ).replace( "-", "" ) );
			erpParam.put( "TEL", params.get( "homeTelNum" ) );
			erpParam.put( "RSRG_ADD", params.get( "addr" ) );
			erpParam.put( "RSRD_ADD", params.get( "detailAddr" ) );
			erpParam.put( "EMGC_TEL", params.get( "mobileTelNum" ) );
			session.selectList( "updateErpEmpInfo", erpParam );
			session.close( );
		}
		catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}
		finally {
			session.close( );
		}
	}

	// 세션 팩토리 객체를 생성하고 그 결과를 리턴해주는 메서드
	private boolean connect ( ConnectionVO conVo ) {
		boolean result = false;
		try {
			// 환경 설정 파일의 경로를 문자열로 저장
			// String resource = "sample/mybatis/sql/mybatis-config.xml";
			String resource = "egovframework/sqlmap/config/" + conVo.getDatabaseType( ) + "/erpOrgSync/erpOrgSync-mybatis-config.xml";
			Properties props = new Properties( );
			props.put( "databaseType", conVo.getDatabaseType( ) );
			props.put( "driver", conVo.getDriver( ) );
			props.put( "url", conVo.getUrl( ) );
			props.put( "username", conVo.getUserId( ) );
			props.put( "password", conVo.getPassWord( ) );
			props.put( "erpTypeCode", conVo.getSystemType( ) );
			// 문자열로 된 경로의파일 내용을 읽을 수 있는 Reader 객체 생성
			Reader reader = Resources.getResourceAsReader( resource );
			// reader 객체의 내용을 가지고 SqlSessionFactory 객체 생성
			// sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader,
			// props);
			if ( sqlSessionFactory == null ) {
				sqlSessionFactory = new SqlSessionFactoryBuilder( ).build( reader, props );
			}
			else {
				sqlSessionFactory = null;
				sqlSessionFactory = new SqlSessionFactoryBuilder( ).build( reader, props );
			}
			result = true;
		}
		catch ( Exception e ) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return result;
	}

	@Override
	public Map<String, Object> empDeptRemoveAdapter ( Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		innerParam.putAll( paramMap );
		//		innerParam.put("compSeq", ""); 
		if ( orgAdapterDAO.getEmpDeptAllCnt( innerParam ).equals( "1" ) ) {
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "ESA0009" );
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000018688", "1개의 부서맵핑은 필수 입니다.　변경할 부서를 등록 하신 후 삭제하여 주세요." ) );
			return resultMap;
		}
		//부부서->주부서 변경시 결재전용부서만 있는경우는 주부서로 변경 불가.
		if ( paramMap.get( "mainDeptYn" ) != null && paramMap.get( "mainDeptYn" ).equals( "Y" ) ) {
			List<Map<String, Object>> list = orgAdapterDAO.selectEmpDeptInfoForEaYn( paramMap );
			if ( list.size( ) == 1 ) {
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "ESA0010" );
				resultMap.put( "result", BizboxAMessage.getMessage( "TX800000078", "해당 부서정보 삭제 시, 결재전용부서는 주부서가 될 수 없어 삭제불가합니다. (해당 부서 삭제를 원하시는 경우 부서를 추가하신 후 삭제하여 주세요.)" ) );
				return resultMap;
			}
		}
		orgAdapterDAO.deleteEmpDeptMulti( paramMap );
		orgAdapterDAO.deleteEmpDept( paramMap );
		orgAdapterDAO.deleteEmpAuth( paramMap );
		//주부서를 삭제할 경우 부부서중 하나를 주부서로 변경.
		if ( paramMap.get( "mainDeptYn" ).equals( "Y" ) ) {
			orgAdapterDAO.setEmpDeptCompCalibrate( paramMap );
		}
		orgAdapterDAO.setEmpCalibrate( paramMap );
		
		// 접근가능IP 설정 수정
		// 주부서 삭제시 = 부부서중 주부서로 바뀐 dept_Seq로 업데이트
		// 부부서 삭제시 = 주부서 dept_Seq로 업데이트
		//  ==> 주부서를 조회해서 dept_seq 업데이트
        Map<String, Object> mainDept = orgAdapterDAO.selectEmpMainDept( paramMap );
        if (mainDept != null) {
            innerParam.put("deptSeqNew", mainDept.get("deptSeq"));
            orgAdapterDAO.updateAccessIpRelate( innerParam );
        }
		
		resultMap.put( "empDeptCnt", orgAdapterDAO.getEmpDeptAllCnt( paramMap ) );
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000001985", "삭제가 완료되었습니다." ) );
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	@Override
	public Map<String, Object> empLoginEmailIdModifyAdapter ( Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		if ( paramMap.get( "loginId" ) != null && !paramMap.get( "loginId" ).equals( "" ) ) {
			innerParam.put( "loginId", paramMap.get( "loginId" ) );
			if ( !orgAdapterDAO.getEmpCnt( innerParam ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000010721", "변경하려는 ID가 존재합니다. 관리자에게 문의 바랍니다." ) + " [" + paramMap.get( "loginId" ).toString( ) + "]" );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "ESA0011" );
				return resultMap;
			}
		}
		else {
			paramMap.remove( "loginId" );
		}
		if ( paramMap.get( "emailAddr" ) != null && !paramMap.get( "emailAddr" ).equals( "" ) ) {
			innerParam = new HashMap<String, Object>( );
			innerParam.put( "emailAddr", paramMap.get( "emailAddr" ) );
			if ( !orgAdapterDAO.getEmpCnt( innerParam ).equals( "0" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage( "TX000010721", "변경하려는 ID가 존재합니다. 관리자에게 문의 바랍니다." ) + " [" + paramMap.get( "emailAddr" ).toString( ) + "]" );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "ESA0012" );
				return resultMap;
			}
		}
		else {
			paramMap.remove( "emailAddr" );
		}
		if ( orgAdapterDAO.updateEmp( paramMap ) < 1 ) {
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000010723", "변경하려는 ID가 없습니다. 관리자에게 문의 바랍니다." ) );
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "ESA0013" );
			return resultMap;
		}
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000001984", "수정이 완료되었습니다." ) );
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	@SuppressWarnings ( "unused" )
	@Override
	public Map<String, Object> empRemoveAdapter ( Map<String, Object> paramMap ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		innerParam.putAll( orgAdapterDAO.selectEmpInfo( paramMap ) );
		innerParam.put( "createSeq", paramMap.get( "createSeq" ) );
		if ( innerParam != null ) {
			innerParam.put( "useYn", "D" );
			innerParam.put( "workStatus", "001" );
			innerParam.put( "loginId", (String) innerParam.get( "loginId" ) + "▦" + (String) innerParam.get( "empSeq" ) );
			innerParam.put( "emailAddr", (String) innerParam.get( "emailAddr" ) + "▦" + (String) innerParam.get( "empSeq" ) );
			innerParam.put( "empNum", "" );
			innerParam.put( "erpEmpNum", "" );
			innerParam.put( "juminNb", "" );
			innerParam.put( "outMail", "" );
			innerParam.put( "outDomain", "" );
			innerParam.put( "bday", "" );
			innerParam.put( "weddingDay", "" );
			innerParam.put( "homeTelNum", "" );
			innerParam.put( "mobileTelNum", "" );
			innerParam.put( "zipCode", "" );
			orgAdapterDAO.updateEmp( innerParam );
			orgAdapterDAO.deleteEmpAuth( innerParam );
			orgAdapterDAO.deleteEmpDeptMulti( innerParam );
			orgAdapterDAO.deleteEmpDept( innerParam );
			orgAdapterDAO.deleteEmpComp( innerParam );
			
			//위하고 조직도 연동 Sync
			wehago.wehagoInsertEmpOneSync(paramMap.get("groupSeq").toString(), "", paramMap.get("empSeq").toString(), "D");
			
		}
		else {
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000009312", "사용자 정보가 존재하지  않습니다" ) );
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			return resultMap;
		}
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000001985", "삭제가 완료되었습니다." ) );
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	@Override
	public Map<String, Object> empResignProcFinish ( Map<String, Object> paramMap ) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		innerParam.putAll( paramMap );
		if ( innerParam.get( "isAll" ) == null || innerParam.get( "isAll" ).equals( "" ) ) {
			innerParam.put( "isAll", "N" );
		}
		else if ( orgAdapterDAO.getEmpCompWorkCnt( innerParam ).equals( "1" ) ) {
			innerParam.put( "isAll", "Y" );
		}
		if ( innerParam.get( "mailDelYn" ) == null || innerParam.get( "mailDelYn" ).equals( "" ) ) {
			innerParam.put( "mailDelYn", "N" );
		}
		if ( innerParam.get( "isDeptDel" ) == null || innerParam.get( "isDeptDel" ).equals( "" ) ) {
			innerParam.put( "isDeptDel", "N" );
		}
		if ( innerParam.get( "resignDate" ) != null && !innerParam.get( "resignDate" ).equals( "" ) ) {
			innerParam.put( "resignDay", innerParam.get( "resignDate" ) );
		}else{
			innerParam.put( "resignDay", new SimpleDateFormat("yyyy-MM-dd").format(new Date()) );
		}
		
		//메일계정 삭제처리
		if(paramMap.get("mailDelYn") != null && paramMap.get("mailDelYn").equals("Y")){
			List<Map<String, Object>> selectEmpMailResignList = orgAdapterDAO.selectEmpMailResignList( paramMap );
			if ( selectEmpMailResignList != null && selectEmpMailResignList.size( ) > 0 && ((paramMap.get( "isAll" ).equals( "N" ) && selectEmpMailResignList.size( ) == 1) || paramMap.get( "isAll" ).equals( "Y" )) ) {
				for ( Map<String, Object> info : selectEmpMailResignList ) {
					sendEmailApi( info );
				}
			}
		}
		
		//퇴사정보 업데이트
		orgAdapterDAO.updateEmpResignInfo(innerParam);	
        
		//변경할 데이터 조회 - 주회사 세팅 체크를 위해
		Map<String, Object> empDeptMap = orgAdapterDAO.selectEmpDept(paramMap);
		
		//부서정보 삭제처리
		innerParam.put( "deptSeq", "" );
		if ( innerParam.get( "isAll" ).equals( "Y" ) ) {
			innerParam.put( "compSeq", "" );
		}
		if ( innerParam.get( "isDeptDel" ).equals( "Y" ) ) {
			//부서매핑정보 삭제
			orgAdapterDAO.deleteEmpDeptMulti( innerParam );
			orgAdapterDAO.deleteEmpDept( innerParam );
			orgAdapterDAO.deleteEmpComp( innerParam );
		}
		else {
			//재직 및 사용여부 업데이트
			orgAdapterDAO.setEmpResign( innerParam );
		}
		orgAdapterDAO.deleteEmpAuth( innerParam );
		orgAdapterDAO.setEmpCalibrate( innerParam );

		// 접근가능IP 설정 삭제 
		innerParam.put("ipDiv", "emp");
		orgAdapterDAO.deleteAccessIpRelate( innerParam );

        /* ※ 주회사 재 셋팅
         *   부서정보 퇴사 or 삭제(isDeptDel=Y, N)
         *    ㄱ. 겸직모두(isAll=Y) > 주회사 처리 X
         *    ㄴ. 선택회사만(isAll=N) 
         *     현재 삭제처리중인 겸직정보(empDeptMap)
         *      a. 주회사
         *       emp 겸직 갯수 확인(empCompCnt)
         *        겸직 X > 주회사 처리 X
         *        겸직 O 일때  > 주회사 처리
         *      b. 부회사 > 주회사 처리 X
         **/
		int empCompCnt = Integer.parseInt(orgAdapterDAO.getEmpCompWorkUseY(innerParam));
	    if ( !innerParam.get( "isAll" ).equals( "Y" ) && empDeptMap.get("mainCompYn").equals("Y") && empCompCnt > 1 ) {
		    orgAdapterDAO.setEmpMainCompYn( innerParam );
		}
		
		//문서함 처리
		if ( innerParam.get( "isAll" ).equals( "Y" ) && innerParam.get( "docPk" ) != null && !innerParam.get( "docPk" ).equals( "" ) && innerParam.get( "docEmpSeq" ) != null && !innerParam.get( "docEmpSeq" ).equals( "" ) ) {
			String arrDocPk[] = innerParam.get( "docPk" ).toString( ).split( "\\|" );
			String arrDocSeq[] = innerParam.get( "docEmpSeq" ).toString( ).split( "\\|" );
			for ( int i = 0; i < arrDocPk.length; i++ ) {
				innerParam.put( "docPk", arrDocPk[i] );
				innerParam.put( "targetSeq", arrDocSeq[i] );
				if ( orgAdapterDAO.getDocAdmCnt( innerParam ).equals( "0" ) ) {
					orgAdapterDAO.updateDocAdm( innerParam ); //대체자로 업데이트
				}
			}
			orgAdapterDAO.deleteDocAdm( innerParam ); //나머지 결재라인 삭제				
		}
		//게시함 처리
		if ( innerParam.get( "isAll" ).equals( "Y" ) && innerParam.get( "boardPk" ) != null && !innerParam.get( "boardPk" ).equals( "" ) && innerParam.get( "boardEmpSeq" ) != null && !innerParam.get( "boardEmpSeq" ).equals( "" ) ) {
			String arrDocPk[] = innerParam.get( "boardPk" ).toString( ).split( "\\|" );
			String arrDocSeq[] = innerParam.get( "boardEmpSeq" ).toString( ).split( "\\|" );
			for ( int i = 0; i < arrDocPk.length; i++ ) {
				innerParam.put( "boardPk", arrDocPk[i] );
				innerParam.put( "targetSeq", arrDocSeq[i] );
				if ( orgAdapterDAO.getBoardAdmCnt( innerParam ).equals( "0" ) ) {
					orgAdapterDAO.updateBoardAdm( innerParam ); //대체자로 업데이트
				}
			}
			orgAdapterDAO.deleteBoardAdm( innerParam ); //나머지 결재라인 삭제				
		}
		
		
		//대화방 나가기(육군본부 예외처리)
		if(innerParam.get( "isAll" ).equals("Y")){
			empLeaveAllTalk(innerParam);
		}
		
		//마스터권한 처리
		if ( innerParam.get( "isMasterAuth" ) != null && innerParam.get( "isMasterAuth" ).equals( "Y" ) ) {
			//마스터권한 삭제
			if ( innerParam.get( "isAll" ).equals( "Y" ) || (innerParam.get( "masterSubEmpSeq" ) != null && !innerParam.get( "masterSubEmpSeq" ).equals( "" )) ) {
				orgAdapterDAO.deleteEmpOption( innerParam );
			}
			//대체자 부여
			if ( innerParam.get( "masterSubEmpSeq" ) != null && !innerParam.get( "masterSubEmpSeq" ).equals( "" ) ) {
				innerParam.put( "empSeq", innerParam.get( "masterSubEmpSeq" ) );
				innerParam.put( "masterUseYn", "Y" );
				if ( orgAdapterDAO.getEmpOptionCnt( innerParam ).equals( "0" ) ) {
					//신규등록
					orgAdapterDAO.insertEmpOption( innerParam );
				}
				else {
					//업데이트
					orgAdapterDAO.updateEmpOption( innerParam );
				}
			}
		}
		
		
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000017945", "퇴사처리가 완료되었습니다." ) );
		resultMap.put( "resultCode", "SUCCESS" );
		if ( BizboxAProperties.getCustomProperty( "BizboxA.Cust.LdapUseYn" ).equals( "Y" ) ) {
			//AD연동 I/F테이블에 INSERT
			Map<String, Object> adParamMap = new HashMap<String, Object>( );
			adParamMap.putAll( innerParam );
			adParamMap.put( "syncType", "D" );
			
			if(paramMap.get("compSeq") != null && innerParam.get("compSeq").equals("") && !paramMap.get("compSeq").equals("")){
				adParamMap.put( "compSeq", paramMap.get("compSeq") );
			}
			
			ldapAdapterDAO.insertOrgAdapterResultEmp( adParamMap );
		}
		
		//위하고 조직도 연동 Sync
		if(innerParam.get("compSeq") == null) {
			innerParam.put("compSeq", "");
		}
			
		wehago.wehagoInsertEmpOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), innerParam.get("empSeq").toString(), "R");
		
		return resultMap;
	}
	
	@Override
	public Map<String, Object> empLoginPasswdResetProc ( Map<String, Object> paramMap ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		
		orgAdapterDAO.empLoginPasswdResetProc(paramMap);
		
		resultMap.put( "resultCode", "SUCCESS" );
		
		return resultMap;
	}
	
	@Override
	public Map<String, Object> empPasswdChangeProc ( Map<String, Object> paramMap ) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		
		if(paramMap.get("passwdNew") == null || paramMap.get("passwdNew").equals("")) {
			//패스워드 미입력
    		resultMap.put( "result", BizboxAMessage.getMessage("TX800000079","패스워드 미입력") );
			resultMap.put( "resultDetailCode", "UC0003" );
			resultMap.put( "resultCode", "fail" );
			return resultMap;   			
		}
		
		//기존패스워드 체크 및 사용자정보 조회 
		if(paramMap.get("passwdOld") == null || paramMap.get("passwdOld").equals("")) {
			paramMap.put("encPasswdOld", "");
		}else {
			paramMap.put("encPasswdOld", CommonUtil.passwordEncrypt( paramMap.get( "passwdOld" ).toString()));
		}
		
		Map<String, Object> passwdCheck = orgAdapterDAO.selectEmpPasswdCheck(paramMap);
		
		if(passwdCheck == null) {
			//사용자정보 조회실패 
    		resultMap.put( "result", BizboxAMessage.getMessage("TX800000055","사용자정보 없음") );
			resultMap.put( "resultDetailCode", "UC0002" );
			resultMap.put( "resultCode", "fail" );
			return resultMap; 			
			
		}
		
		if(paramMap.get("passwdOld") != null && !paramMap.get("passwdOld").equals("") && passwdCheck.get("checkYn").equals("N")) {
			//기존패스워드 불일치 
    		resultMap.put( "result", BizboxAMessage.getMessage("TX800000080","기존 패스워드 불일치") );
			resultMap.put( "resultDetailCode", "UC0004" );
			resultMap.put( "resultCode", "fail" );
			return resultMap; 				
			
		}
		
		if(paramMap.get("checkPolicy") != null && paramMap.get("checkPolicy").equals("Y")) {
			
			/* 옵션 확인 */
    		Map<String, Object> mp = new HashMap<String, Object>();
    		mp.put("option", "cm20");
    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
			
    		// 메일 싱크를 위한 정보
	    	String passwdNew = paramMap.get("passwdNew").toString();
	    	String langCode = passwdCheck.get("langCode").toString();
	    	
			String passwdOptionUseYN = "";
			String inputDigitValue = "";
			String inputRuleValue = "";
			String inputLimitValue = "";
			String inputBlockTextValue = "";
			String regExpression = "";
			
			/* 결과 오류 변수 선언 */
			String inputDigitResult = "";
			String inputRuleResult = "";
			String inputLimitResult = "";
			
			boolean regExpressionFlag = false;
    		
    		for(Map<String, Object> temp : loginOptionValue) {
    			// 비밀번호 설정규칙 사용 여부
    			if(temp.get("optionId").equals("cm200")) {
    				if(temp.get("optionRealValue").equals("0")) {			// 비밀번호 설정 옵션 미사용
    					passwdOptionUseYN = "N";
    					break;
    				} else if(temp.get("optionRealValue").equals("1")) {	// 비밀번호 설정 옵션 사용
    					passwdOptionUseYN = "Y";
    				}
    			}
    			
    			// 비밀번호 입력 자리수 설정
    			if(temp.get("optionId").equals("cm202")) {
    				inputDigitValue = temp.get("optionRealValue").toString();
    			}
    			
    			// 입력규칙값
				if(temp.get("optionId").equals("cm203")) {
					inputRuleValue = temp.get("optionRealValue").toString();
    			}

    			// 입력제한값
				if(temp.get("optionId").equals("cm204")) {
					inputLimitValue = temp.get("optionRealValue").toString();
				}
				
    			// 입력제한단어
				if(temp.get("optionId").equals("cm205")) {
					inputBlockTextValue = temp.get("optionRealValue").toString();
				}					
    		}
    		
    		Pattern p = null;		// 정규식
    		
    		// 비밀번호 설정 옵션값 체크
    		if(passwdOptionUseYN.equals("Y")) {
    			// 자릿수 설정
				if(!inputDigitValue.equals("")) {
					String[] digit = inputDigitValue.split("\\|");
					
					if(digit.length > 1 && !digit[0].equals("") && !digit[1].equals("")){
					
    					String min = digit[0];
    					String max = digit[1];
    					
    					if(max.equals("0")) {
    						max = "16";
    					}
    					
    					if(passwdNew.length() < Integer.parseInt(min) || passwdNew.length() > Integer.parseInt(max)) {
    						
    						inputDigitResult = BizboxAMessage.getMessage("TX000010842", "최소") + min + " " + BizboxAMessage.getMessage("TX000022609","자리 이상 ") + max + " " + BizboxAMessage.getMessage("TX000022610","자리 이하로 입력해 주세요.");

    					}
					}
				}
				
    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
    				if(inputRuleValue.indexOf("0") > -1) {
    					regExpression = ".*[A-Z]+.*";
    					
    					p = Pattern.compile(regExpression);
    					
    					regExpressionFlag = fnRegExpression(p, passwdNew);
    					
    					if(!regExpressionFlag) {
    						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)", passwdNew) + ",";
    					}
    				} 
    				
    				if(inputRuleValue.indexOf("1") > -1) {
						regExpression = ".*[a-z]+.*";
    					
						p = Pattern.compile(regExpression);
						
    					regExpressionFlag = fnRegExpression(p, passwdNew);
    					
    					if(!regExpressionFlag) {
    						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)", passwdNew) + ",";
    					}
    				}
    				
    				if(inputRuleValue.indexOf("2") > -1) {
						regExpression = ".*[0-9]+.*";
    					
						p = Pattern.compile(regExpression);
						
    					regExpressionFlag = fnRegExpression(p, passwdNew);
    					
    					if(!regExpressionFlag) {
    						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자", langCode) + ",";
    					}
    				}
    				
    				if(inputRuleValue.indexOf("3") > -1) {
    					regExpression = ".*[^가-힣a-zA-Z0-9].*";
    					
    					p = Pattern.compile(regExpression);
    					
    					regExpressionFlag = fnRegExpression(p, passwdNew);
    					
    					if(!regExpressionFlag) {
    						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자", langCode) + ",";
    					}
    				}
    			}
    			
    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {			// 입력제한 값 미사용

    				inputLimitValue = "|" + inputLimitValue + "|";
    				
    	    		// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
					if(inputLimitValue.indexOf("|0|") > -1) {
    					String loginId = passwdCheck.get("loginId").toString();
    					
    					if(passwdNew.indexOf(loginId) > -1) {
    						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디", langCode) + ",";
    					}
    				}
					
					if(inputLimitValue.indexOf("|1|") > -1) {
						String erpNum = passwdCheck.get("erpEmpNum").toString();
    					
						
    					if(passwdNew.indexOf(erpNum) > -1 && !erpNum.equals("")) {
    						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번", langCode) + ",";
    					}
    				}
					
					if(inputLimitValue.indexOf("|2|") > -1) {
						String phoneNum = passwdCheck.get("mobileTelNum").toString().replaceAll("-", "");
    					
						String phoneNumPattern = "";
						String[] phoneArray = null;
						String middleNum = "";
						String endNum = "";
						
						if(!phoneNum.equals("")) {
							phoneNumPattern = phoneFormat(phoneNum);
							phoneArray = phoneNumPattern.split("-");
							
							if(phoneArray.length > 2) {
								middleNum = phoneArray[1];
								endNum = phoneArray[2];
							} else if(phoneArray.length == 1 && phoneArray[0].length() > 3){
								middleNum = phoneArray[0];
								endNum = phoneArray[0];
							}
							
							if(!middleNum.equals("") && !endNum.equals("")){
								if(passwdNew.indexOf(middleNum) > -1 || passwdNew.indexOf(endNum) > -1) {
									inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화", langCode) + ",";
								}
							}    							
						}
    				} 
					
					if(inputLimitValue.indexOf("|3|") > -1) {
						String birthDay = passwdCheck.get("bday").toString();
    					
						if(!birthDay.equals("0000-00-00")) {
							String[] yearMonthDay = birthDay.split("-");
							String year = yearMonthDay[0];
							String monthDay = yearMonthDay[1] + yearMonthDay[2];
							String residentReg = year.substring(2,4) + monthDay;
							
							if(passwdNew.indexOf(year) > -1 || passwdNew.indexOf(monthDay) > -1 || passwdNew.indexOf(residentReg) > -1) {
								inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일", langCode) + ",";
							}
						}
    				}
					
    	    		if(inputLimitValue.indexOf("|4|") > -1) {
    					int nSamePass1 = 1; //연속성(+) 카운드
	 				    int nSamePass2 = 1; //반복성(+) 카운드
	 				    int blockCnt = 3;
	 				    
	 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
	 				    	blockCnt = 4;
	 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
	 				    	blockCnt = 5;
	 				    }		 				    
	 				    
	 				    for(int j=1; j < passwdNew.length(); j++){
	 				    	int tempA = (int) passwdNew.charAt(j-1);
	 				    	int tempB = (int) passwdNew.charAt(j);
	 				    	
	 				    	if(tempA - (tempB-1) == 0 ) {
	 				    		nSamePass1++;
	 				    	}else{
	 				    		nSamePass1 = 1;
	 				    	}
	 				    	
	 				    	if(tempA - tempB == 0) {
	 				    		nSamePass2++;
	 				    	}else{
	 				    		nSamePass2 = 1;
	 				    	}
	 				    	
	 				    	if(nSamePass1 >= blockCnt) {
	 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022602","연속문자", langCode) + ",";
	 				    		break;
	 				    	}
	 				    	
	 				    	if(nSamePass2 >= blockCnt) {
	 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리") + " " + BizboxAMessage.getMessage("TX000022603","반복문자", langCode) + ",";
	 				    		break;
	 				    	}
	 				    }
    				}
    	    		
    	    		if(inputLimitValue.indexOf("|5|") > -1) {
    	    			if(passwdCheck.get("prevLoginPasswd").equals(CommonUtil.passwordEncrypt(passwdNew))){
    	    				inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호", langCode) + ",";	
    	    			}
    				}	    	    		
    	    		
    	    		if(inputLimitValue.indexOf("|6|") > -1 && passwdNew.length() > 1) {
    	    			
    	    			int samePass1 = 1; //연속성(+) 카운드
    	    			int samePass2 = 1; //연속성(-) 카운드
	 				    int blockCnt = 3;
	 				    String keyArray = "`1234567890-=!@#$%^&*()_+qwertyuiopasdfghjkl;'zxcvbnm,./";
	 				    String newPasswdLow = passwdNew.toLowerCase();
	 				    
	 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
	 				    	blockCnt = 4;
	 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
	 				    	blockCnt = 5;
	 				    }
	 				    
	 				    for(int j=1; j < newPasswdLow.length(); j++){
	 				    	int tempA = keyArray.indexOf(newPasswdLow.charAt(j-1));
	 				    	int tempB = keyArray.indexOf(newPasswdLow.charAt(j));
	 				    	
	 				    	if(tempA == -1 || tempB == -1){
	 				    		samePass1 = 1;
	 				    		samePass2 = 1;
	 				    	}else{
	 				    		
	 				    		if((tempB-tempA) == 1){
	 				    			samePass1++;
	 				    		}else{
	 				    			samePass1 = 1;
	 				    		}
	 				    		
	 				    		if((tempA-tempB) == 1){
	 				    			samePass2++;
	 				    		}else{
	 				    			samePass2 = 1;
	 				    		}		 				    		
	 				    	}
	 				    	
	 				    	if(samePass1 >= blockCnt || samePass2 >= blockCnt) {
	 				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열", langCode) + ",";
	 				    		break;
	 				    	}
	 				    }
    				}	    	    		
    			}
    			
    			if(!inputBlockTextValue.equals("")){
    				
    				inputBlockTextValue = "|" + inputBlockTextValue + "|";
    				
    				if(inputBlockTextValue.indexOf("|" + passwdNew + "|") != -1){
    					inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어", langCode) + ",";
    				}
    			}
    			
    			String result = inputDigitResult + inputRuleResult + inputLimitResult;
    			
    			if(!result.equals("")) {
    				
		    		resultMap.put( "result", result );
					resultMap.put( "resultDetailCode", "UC0005" );
					resultMap.put( "resultCode", "fail" );
					return resultMap;
    				
    			}
    		}			
		}
		
		innerParam.put("empSeq", passwdCheck.get("empSeq"));
		innerParam.put("createSeq", "orgApi");
		
		if(paramMap.get("type").equals("def")) {
			innerParam.put("loginPasswd", CommonUtil.passwordEncrypt(paramMap.get("passwdNew").toString()));
		}else if(paramMap.get("type").equals("app")) {
			innerParam.put("apprPasswd", CommonUtil.passwordEncrypt(paramMap.get("passwdNew").toString()));
		}else {
			innerParam.put("payPasswd", CommonUtil.passwordEncrypt(paramMap.get("passwdNew").toString()));
		}
		
		orgAdapterDAO.updateEmp(innerParam);
		resultMap.put( "result", BizboxAMessage.getMessage("TX000011955","성공하였습니다.") );
		resultMap.put( "resultCode", "SUCCESS" );
		
		return resultMap;
	}	
	
	private String phoneFormat(String phoneNo){
		  
		   if (phoneNo.length() == 0){
		    return phoneNo;
		      }
		   
		      String strTel = phoneNo;
		      String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
		                           "051", "052", "053", "054", "055", "061", "062",
		                           "063", "064", "010", "011", "012", "013", "015",
		                           "016", "017", "018", "019", "070", "050"};
		      
		      if (strTel.length() < 9) {
		          return strTel;
		      } else if (strTel.substring(0,2).equals(strDDD[0])) {
		          strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
		               + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else if(strTel.substring(0, 3).equals(strDDD[26])){
		    	  strTel = strTel.substring(0,4) + '-' + strTel.substring(4, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		      } else {
		          for(int i=1; i < strDDD.length; i++) {
		              if (strTel.substring(0,3).equals(strDDD[i])) {
		                  strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
		                   + '-' + strTel.substring(strTel.length() -4, strTel.length());
		              }
		          }
		      }
		      return strTel;
		 }	
	
	private boolean fnRegExpression(Pattern regExpression, String modPass) {
		Matcher match = regExpression.matcher(modPass);
		
		boolean result = match.find();
		
		return result;
	}	

	private boolean sendEmailApi ( Map<String, Object> paramMap ) {
		URL u = null;
		HttpURLConnection huc = null;
		try {
			u = new URL( paramMap.get( "url" ).toString( ) );
			paramMap.remove( "url" );
			huc = (HttpURLConnection) u.openConnection( );
			huc.setRequestMethod( "POST" );
			huc.setDoInput( true );
			huc.setDoOutput( true );
			huc.setRequestProperty( "Content-Type", "application/x-www-form-urlencoded" );
			String param = setParam( paramMap );
			OutputStream os = huc.getOutputStream( );
			os.write( param.getBytes( ) );
			os.flush( );
			os.close( );
			InputStream is = huc.getInputStream( );
			Writer writer = new StringWriter( );
			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader( new InputStreamReader( is, "UTF-8" ) );
				int n;
				while ( (n = reader.read( buffer )) != -1 ) {
					writer.write( buffer, 0, n );
				}
				return true;
			}
			finally {
				is.close( );
				writer.close( );
			}
		}
		catch ( Exception e ) {
			return false;
		}
	}

	private String setParam ( Map<String, Object> paramMap ) {
		String param = "";
		for ( String mapKey : paramMap.keySet( ) ) {
			param += mapKey + "=" + paramMap.get( mapKey ) + "&";
		}
		return param;
	}
	
	public void mailUserSync(Map<String, Object> params){
		
		String mailDomail = null;
		String groupSeq = "";
		
		if(params.get("groupSeq") != null){
			groupSeq = params.get("groupSeq").toString();
		}
		
		Map<String, Object> groupInfo = orgAdapterDAO.selectGroupInfo( params );
		
		if (groupInfo != null && groupInfo.get("mailUrl") != null && !groupInfo.get("mailUrl").equals("")) {
			mailDomail = groupInfo.get("mailUrl")+"";

			try {
				
				HttpUtilThread http = new HttpUtilThread("POST", mailDomail+"userSync.do?groupSeq=" + groupSeq, new HashMap<String, String>());
				http.start();
				
			} catch (Exception e) {
				logger.debug("mailOrgSync error : " + e.getMessage());
			}
		}
	}
	
	public void mailCompDelete(Map<String, Object> params){
		
		if(params.get("groupSeq") != null && params.get("groupSeq") != null){
						
			Map<String, Object> groupInfo = orgAdapterDAO.selectGroupInfo( params );
			Map<String, Object> compInfo = orgAdapterDAO.selectCompInfo( params );
			
			if (groupInfo != null && compInfo != null && compInfo.get("compEmailYn") != null && compInfo.get("compEmailYn").equals("Y") && compInfo.get("emailDomain") != null && !compInfo.get("emailDomain").equals("") && groupInfo.get("mailUrl") != null && !groupInfo.get("mailUrl").equals("")) {
				
				try {

					HttpUtilThread http = new HttpUtilThread("POST", groupInfo.get("mailUrl").toString()+"deleteCompany.do?groupSeq=" + params.get("groupSeq").toString() + "&compSeq=" + params.get("compSeq").toString() + "&domainName=" + compInfo.get("emailDomain").toString(), new HashMap<String, String>());
					http.start();
					
				} catch (Exception e) {
					logger.debug("mailOrgSync error : " + e.getMessage());
				}
			}
		}
	}	
	
	@SuppressWarnings("static-access")
	public void empLeaveAllTalk(Map<String, Object> params){
		
		Map<String, Object> empNameInfo = orgAdapterDAO.selectEmpMultiLangName( params );
		
		if (empNameInfo != null && empNameInfo.get("messengerUrl") != null && !empNameInfo.get("messengerUrl").equals("")) {
			
			JSONObject messengerParam = new JSONObject();
			
			JSONObject header = new JSONObject();
			header.put("groupSeq", empNameInfo.get("groupSeq"));
			header.put("empSeq", empNameInfo.get("empSeq"));
			JSONObject body = new JSONObject();
			body.put("groupSeq", empNameInfo.get("groupSeq"));
			JSONArray users = new JSONArray();
			JSONObject user = new JSONObject();
			user.put("empSeq", empNameInfo.get("empSeq"));
			user.put("empName", empNameInfo.get("empNameKr"));
			user.put("empNameEn", empNameInfo.get("empNameEn"));
			user.put("empNameJp", empNameInfo.get("empNameJp"));
			user.put("empNameCn", empNameInfo.get("empNameCn"));
			users.add(user);
			body.put("users", users);
			messengerParam.put("apiName", "EmpLeaveCompany");
			messengerParam.put("header", header);
			messengerParam.put("body", body);
			
			try{
				HttpJsonUtil httpJson = new HttpJsonUtil();
				httpJson.execute("POST", empNameInfo.get("messengerUrl").toString() + "/messenger/MobileTalk/EmpLeaveCompany", messengerParam);
			}catch(Exception e){
				logger.debug("OrgAdapterService.empLeaveAllTalk error : " + e.getMessage());
			}		
		}
	}
	
	@Override
	public Map<String, Object> dutyPositionSaveAdapter ( Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		Map<String, Object> innerParam = new HashMap<String, Object>( );
		
		innerParam.putAll( paramMap );
		
		if(innerParam.get("dpType") == null || innerParam.get("dpType").equals("")) {
			//구분코드없음 
			resultMap.put( "result", BizboxAMessage.getMessage("TX800000081","구분코드를 입력은 필수입니다.") );
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			return resultMap;			
		}else {
			innerParam.put("dpType", innerParam.get("dpType").toString().toUpperCase()); 
		}
		
		if(!innerParam.get("dpType" ).equals("DUTY") && !innerParam.get("dpType" ).equals("POSITION")) {
			resultMap.put( "result", BizboxAMessage.getMessage("TX800000082","구분코드가 유효하지 않습니다.") );
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			return resultMap;	
		}
		
		if(innerParam.get("dpSeqDef") != null && !innerParam.get("dpSeqDef").equals("")) {
			//신규등록
			if ( innerParam.get("dpName" ) == null || innerParam.get( "dpName" ).equals( "" ) ) {
				resultMap.put( "result", BizboxAMessage.getMessage("TX800000083","직급/직책명은 필수입니다.") );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0005" );
				return resultMap;
			}		
			
			if(innerParam.get("useYn") == null || innerParam.get("useYn").equals("")) {
				innerParam.put("useYn", "Y");
			}else if(!innerParam.get("useYn").equals("Y") && !innerParam.get("useYn").equals("N")) {
				resultMap.put( "result", BizboxAMessage.getMessage("TX800000084","사용여부가 유효하지 않습니다.") );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				return resultMap;				
			}
			
			if(innerParam.get("compSeq") == null || innerParam.get("compSeq").equals("")) {
				innerParam.put("compSeq", "0");
			}
			
			innerParam.put("dpSeq", innerParam.get("dpSeqDef"));
			
			if(orgAdapterDAO.getDutyPositionCnt(innerParam).equals("0")) {

				//insertDutyPosition
				try {
					orgAdapterDAO.insertDutyPosition( innerParam );
				}
				catch ( Exception e ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPosition Fail] > " + e.getMessage() );
					return resultMap;
				}
				
				//insertDutyPositionMulti(kr)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "dpName" ) + "" ) ) {
					innerParam.put( "langCode", "kr" );
					try {
						orgAdapterDAO.insertDutyPositionMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(kr) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(en)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "dpNameEn" ) + "" ) ) {
					innerParam.put( "dpName", paramMap.get( "dpNameEn" ) + "" );
					innerParam.put( "langCode", "en" );
					try {
						orgAdapterDAO.insertDutyPositionMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(jp)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "dpNameJp" ) + "" ) ) {
					innerParam.put( "dpName", paramMap.get( "dpNameJp" ) + "" );
					innerParam.put( "langCode", "jp" );
					try {
						orgAdapterDAO.insertDutyPositionMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(cn)
				if ( !EgovStringUtil.isEmpty( paramMap.get( "dpNameCn" ) + "" ) ) {
					innerParam.put( "dpName", paramMap.get( "dpNameCn" ) + "" );
					innerParam.put( "langCode", "cn" );
					try {
						orgAdapterDAO.insertDutyPositionMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				
				//위하고 조직도 연동 Sync
				wehago.wehagoInsertDutyPositionOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), innerParam.get("dpSeq").toString(), innerParam.get("dpType").toString(), "I");
				
			}else {
				resultMap.put( "result", BizboxAMessage.getMessage("TX800000085","dpDef 중복키가 존재합니다.") );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0004" );
				return resultMap;					
			}			
			
		}else if(innerParam.get("dpSeq") != null && !innerParam.get("dpSeq").equals("")) {
			//수정
			if(orgAdapterDAO.getDutyPositionCnt(innerParam).equals("0")) {
				
				resultMap.put( "result", BizboxAMessage.getMessage("TX800000086","직급/직책코드가 유효하지 않습니다.") );
				resultMap.put( "resultCode", "fail" );
				resultMap.put( "resultDetailCode", "UC0002" );
				return resultMap;					
				
			}else {
				
				if ( orgAdapterDAO.updateDutyPosition( innerParam ) < 1 ) {
					resultMap.put( "resultCode", "fail" );
					resultMap.put( "resultDetailCode", "UC0003" );
					resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[updateDutyPosition Fail]" );
					return resultMap;
				}
				//insertDutyPositionMulti(kr)
				if ( paramMap.get( "dpName" ) != null ) {
					if ( paramMap.get( "dpName" ).equals( "" ) ) {
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000007108", "직급/직책명을 입력하세요." ) );
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						return resultMap;
					}
					innerParam.put( "langCode", "kr" );
					try {
						orgAdapterDAO.deleteDutyPositionMulti( innerParam );
						orgAdapterDAO.insertDutyPositionMulti( innerParam );
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(kr) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(en)
				if ( paramMap.get( "dpNameEn" ) != null ) {
					innerParam.put( "dpName", paramMap.get( "dpNameEn" ) );
					innerParam.put( "langCode", "en" );
					try {
						orgAdapterDAO.deleteDutyPositionMulti( innerParam );
						if ( !paramMap.get( "dpNameEn" ).equals( "" ) ) {
							orgAdapterDAO.insertDutyPositionMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(en) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(jp)
				if ( paramMap.get( "dpNameJp" ) != null ) {
					innerParam.put( "dpName", paramMap.get( "dpNameJp" ) );
					innerParam.put( "langCode", "jp" );
					try {
						orgAdapterDAO.deleteDutyPositionMulti( innerParam );
						if ( !paramMap.get( "dpNameJp" ).equals( "" ) ) {
							orgAdapterDAO.insertDutyPositionMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(jp) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				//insertDutyPositionMulti(cn)
				if ( paramMap.get( "dpNameCn" ) != null ) {
					innerParam.put( "dpName", paramMap.get( "dpNameCn" ) );
					innerParam.put( "langCode", "cn" );
					try {
						orgAdapterDAO.deleteDutyPositionMulti( innerParam );
						if ( !paramMap.get( "dpNameCn" ).equals( "" ) ) {
							orgAdapterDAO.insertDutyPositionMulti( innerParam );
						}
					}
					catch ( Exception e ) {
						resultMap.put( "resultCode", "fail" );
						resultMap.put( "resultDetailCode", "UC0003" );
						resultMap.put( "result", BizboxAMessage.getMessage( "TX000002003", "작업이 실패했습니다." ) + "[insertDutyPositionMulti(cn) Fail] > " + e.getMessage() );
						return resultMap;
					}
				}
				
				//위하고 조직도 연동 Sync
				wehago.wehagoInsertDutyPositionOneSync(innerParam.get("groupSeq").toString(), innerParam.get("compSeq").toString(), innerParam.get("dpSeq").toString(), innerParam.get("dpType").toString(), "I");
				
			}			
			
		}else {
			resultMap.put( "result", BizboxAMessage.getMessage("TX800000087","직급/직책코드는 필수입니다.") );
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			return resultMap;				
		}

		resultMap.put( "result", BizboxAMessage.getMessage( "TX000016584", "등록이 완료 되었습니다" ) );
		resultMap.put( "resultCode", "SUCCESS" );
		return resultMap;
	}

	@Override
	public Map<String, Object> dutyPositionRemoveAdapter ( Map<String, Object> paramMap ) {
		Map<String, Object> resultMap = new HashMap<String, Object>( );
		
		if(paramMap.get("dpType") != null && !paramMap.get("dpType").equals("") && ((paramMap.get("allDeleteYn") != null && paramMap.get("allDeleteYn").equals("Y") && paramMap.get("compSeq") != null && !paramMap.get("compSeq").equals("")) || (paramMap.get("dpSeq") != null && !paramMap.get("dpSeq").equals("")))) {

			paramMap.put("dpType", paramMap.get("dpType").toString().toUpperCase());
			
			//위하고 조직도 연동 Sync
			// 삭제 후에 데이터 조회시 조회 목록이 없기 떄문에 삭제 이전에 수행되도록 수정
			wehago.wehagoInsertDutyPositionOneSync(paramMap.get("groupSeq").toString(), "", paramMap.get("dpSeq").toString(), paramMap.get("dpType").toString(), "D");
			
			orgAdapterDAO.deleteDutyPosition( paramMap );
			orgAdapterDAO.deleteDutyPositionMulti( paramMap );
			
		}else {
			resultMap.put( "resultCode", "fail" );
			resultMap.put( "resultDetailCode", "UC0002" );
			resultMap.put( "result", BizboxAMessage.getMessage( "TX000001894", "직급/직책코드가 존재하지 않습니다." ) );
			return resultMap;			
		}
		
		resultMap.put( "resultCode", "SUCCESS" );
		resultMap.put( "result", BizboxAMessage.getMessage( "TX000001985", "삭제가 완료되었습니다." ) );		
		
		return resultMap;
	}
	
	public void ftpProfileSync(Map<String, Object> paramMap) throws IOException {
		
		if(!BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncYn" ).equals( "Y" )) {
			return;
		}
		
		paramMap.put("osType", NeosConstants.SERVER_OS);
		
		List<Map<String, Object>> targetList = orgAdapterDAO.selectFtpProfileSyncList( paramMap );
		
		if ( targetList != null ) {
			
			String ftpProfileSyncType = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncType" );
			String ftpProfileSyncIp = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncIp" );
			String ftpProfileSyncPort = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncPort" );
			String ftpProfileSyncId = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncId" );
			String ftpProfileSyncPw = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncPw" );
			String ftpProfileSyncPath = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncPath" );
			String ftpProfileSyncName = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncName" );
			String ftpProfileSyncExt = BizboxAProperties.getCustomProperty( "BizboxA.Cust.ftpProfileSyncExt" );
			String imgServerPath = targetList.get(0).get("imgPath").toString();
			
			if(ftpProfileSyncType.equals("local")) {
				
				//웹서버경로에 복사
				
				for ( Map<String, Object> target : targetList ) {
					
					if(target.get(ftpProfileSyncName) != null && !target.get(ftpProfileSyncName).equals("")) {
						
						String fromImgPath = imgServerPath + "/" + target.get("imgName").toString();
						String targetImgName = ftpProfileSyncPath + "/" + target.get(ftpProfileSyncName).toString() + "." + ftpProfileSyncExt;
						
						File imgFile = new File(fromImgPath);
						
						if(imgFile.exists()) {
							try {
								FileUtils.copyIO(fromImgPath, targetImgName);
							} catch (Exception e) {
								logger.debug("ftpProfileSync Exception > " + e.getMessage());
							}
						}
					}
				}	
				
			}else {
				
				//타 FTP서버에 저장

				FTPClient ftpClient = new FTPClient();
				FileInputStream fin = null;
				
				try
				{
					
					ftpClient.setControlEncoding("euc-kr");
					ftpClient.connect(ftpProfileSyncIp, Integer.parseInt(ftpProfileSyncPort));
					ftpClient.login(ftpProfileSyncId, ftpProfileSyncPw);
					
					if (imgServerPath.length() != 0)
					{
						ftpClient.changeWorkingDirectory(imgServerPath);
					}

					ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
					
					int reply = ftpClient.getReplyCode();
					if (!FTPReply.isPositiveCompletion(reply))
					{
						ftpClient.disconnect();
						logger.debug("ftpProfileSync > FTP server refused connection");
						return;
					} 
					else
					{
						logger.debug("ftpProfileSync > FTP server connection success");
					}
					
					Charset cset = Charset.defaultCharset();
					String csetName = cset.name();
					logger.debug("default charset:" + csetName);
					logger.debug("system default encoding : " + System.getProperty("file.encoding"));
					
					
					for ( Map<String, Object> target : targetList ) {
						
						if(target.get(ftpProfileSyncName) != null && !target.get(ftpProfileSyncName).equals("")) {
							
							String fromImgName = target.get("imgName").toString();
							String targetImgName = target.get(ftpProfileSyncName).toString() + "." + ftpProfileSyncExt;
							
							File imgFile = new File(imgServerPath + "/" + fromImgName);
							
							if(imgFile.exists()) {
							
								fin = new FileInputStream(imgServerPath + "/" + fromImgName);
								
								if (ftpClient.storeFile(ftpProfileSyncPath + "/" + targetImgName, fin)) 
								{
									logger.debug("ftpProfileSync > " + targetImgName + " put finshied");
								}
								else 
								{
									logger.debug("ftpProfileSync > " + targetImgName + " put failed");
								}							
							}
						}
					}				
					
					ftpClient.logout();
					ftpClient.disconnect();
				}
				catch (Exception e) {
					logger.debug("ftpProfileSync Exception > " + e.getMessage());
					return;
				}finally{
					if(fin != null){
						fin.close();
					}
					
					if(ftpClient != null){
						if(ftpClient.isConnected()){
							ftpClient.logout();
							ftpClient.disconnect();
						}
					}
				}				
			}
		}
	}
	
}