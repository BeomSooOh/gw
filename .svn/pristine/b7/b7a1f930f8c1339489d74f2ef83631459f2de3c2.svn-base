package neos.cmm.systemx.cert.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.sun.star.uno.Exception;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.cert.service.CertManageService;


@Service ( "CertManageService" )
public class CertManageServiceImpl implements CertManageService {

	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;

	@SuppressWarnings ( "unchecked" )
	@Override
	public List<Map<String, Object>> getCertificateList ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.getCertificateList", params );
	}

	@SuppressWarnings ( "unchecked" )
	@Override
	/**
	 * List<Map<String, Object>> 사용자 선택 가능한 증명서구분 조회
	 * - param : groupSeq, compSeq, empSeq, langCode
	 * - result : formSeq, formNm, compSeq
	 * - table : t_co_certificate_form
	 */
	public List<Map<String, Object>> getCertificateUserList ( Map<String, Object> params ) throws Exception {
		if ( String.valueOf( params.containsKey( "groupSeq" ) ).equals( "" ) ) {
			throw new Exception( "필수 파라미터가 누락되었습니다.[groupSeq]" );
		}
		if ( String.valueOf( params.containsKey( "compSeq" ) ).equals( "" ) ) {
			throw new Exception( "필수 파라미터가 누락되었습니다.[compSeq]" );
		}
		if ( String.valueOf( params.containsKey( "empSeq" ) ).equals( "" ) ) {
			throw new Exception( "필수 파라미터가 누락되었습니다.[empSeq]" );
		}
		if ( String.valueOf( params.containsKey( "langCode" ) ).equals( "" ) ) {
			throw new Exception( "필수 파라미터가 누락되었습니다.[langCode]" );
		}
		return commonSql.list( "CertManageDAO.getCertificateUserList", params );
	}

	@Override
	public Map<String, Object> getCertificateFormInfo ( Map<String, Object> params ) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.getCertificateFormInfo", params );
	}

	@Override
	public Map<String, Object> getCertificateDefaultInfo ( Map<String, Object> params ) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.getCertificateDefaultInfo", params );
	}

	@Override
	public Map<String, Object> getCertificateInfo ( Map<String, Object> params ) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.getCertificateInfo", params );
	}
	
	@Override
	public Map<String, Object> getCertFormLangCode ( Map<String, Object> params ) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.getCertFormLangCode", params );
	}

	@Override
	public Map<String, Object> selectCertificateList ( Map<String, Object> params, PaginationInfo paginationInfo ) {
		return commonSql.listOfPaging2( params, paginationInfo, "CertManageDAO.selectCertificateList" );
	}

	@Override
	public List<Map<String, Object>> selectCertificatePresentCondition ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.selectCertificatePresentCondition", params );
	}

	@Override
	public void requestCertificate ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.requestCertificate", paramMap );
	}

	@Override
	public void apprCertificate ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.apprCertificate", paramMap );
	}

	@Override
	public void setCertificatePrintInfo ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.setCertificatePrintInfo", paramMap );
	}

	@Override
	public String getCerSeq ( Map<String, Object> params ) {
		return (String) commonSql.select( "CertManageDAO.getCerSeq", params );
	}

	@Override
	public String getCertificateCompForm ( Map<String, Object> params ) {
		return (String) commonSql.select( "CertManageDAO.getCertificateCompForm", params );
	}

	@Override
	public int getCerNo ( Map<String, Object> params ) {
		return (int) commonSql.select( "CertManageDAO.getCerNo", params );
	}

	@Override
	public String getFormSeq ( Map<String, Object> params ) {
		return (String) commonSql.select( "CertManageDAO.getFormSeq", params );
	}

	@Override
	public void updateCertificateForm ( Map<String, Object> paramMap ) {
		
		String formSeq = (String) commonSql.select( "CertManageDAO.getCertificateCompForm", paramMap );
		
		if(formSeq == null){
			commonSql.insert( "CertManageDAO.insertCertificateForm", paramMap );	
		}else{
			commonSql.update( "CertManageDAO.updateCertificateForm", paramMap );	
		}
		
	}

	@Override
	public void updateCertificateFormDefault ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.updateCertificateFormDefault", paramMap );
	}

	@Override
	public void insertCertificateCompForm ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.insertCertificateCompForm", paramMap );
	}

	@Override
	public List<Map<String, Object>> selectCertificateAdminList ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.selectCertificateAdminList", params );
	}

	@Override
	public Map<String, Object> selectCertificateUserInfo ( Map<String, Object> params ) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.selectCertificateUserInfo", params );
	}

	@Override
	public List<Map<String, Object>> getCertificateStatusList ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.getCertificateStatusList", params );
	}

	@Override
	public List<Map<String, Object>> getCertificateSubmitList ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.getCertificateSubmitList", params );
	}

	@Override
	public List<Map<String, Object>> getCertificateUseYn ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.getCertificateUseYn", params );
	}

	@Override
	public List<Map<String, Object>> getCertificateAlarmList ( Map<String, Object> params ) {
		return commonSql.list( "CertManageDAO.getCertificateAlarmList", params );
	}

	@Override
	public void setCertificateUseYn ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.setCertificateUseYn", paramMap );
	}

	@Override
	public void setCertificateAlarmReset ( Map<String, Object> paramMap ) {
		commonSql.insert( "CertManageDAO.setCertificateAlarmReset", paramMap );
	}

	@Override
	public void setCertificateAlarm ( Map<String, String> paramMap ) {
		commonSql.insert( "CertManageDAO.setCertificateAlarm", paramMap );
	}

	@Override
	public Map<String, Object> getEmpDutyPosiInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select( "CertManageDAO.getEmpDutyPosiInfo", paramMap );
	}
}
