package neos.cmm.systemx.cert.service;

import java.util.List;
import java.util.Map;

import com.sun.star.uno.Exception;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


public interface CertManageService {

	List<Map<String, Object>> getCertificateList ( Map<String, Object> params );

	List<Map<String, Object>> getCertificateUserList ( Map<String, Object> params ) throws Exception;

	Map<String, Object> getCertificateFormInfo ( Map<String, Object> params );

	Map<String, Object> getCertificateDefaultInfo ( Map<String, Object> params );

	Map<String, Object> getCertificateInfo ( Map<String, Object> params );
	
	Map<String, Object> getCertFormLangCode ( Map<String, Object> params );

	Map<String, Object> selectCertificateList ( Map<String, Object> params, PaginationInfo paginationInfo );

	List<Map<String, Object>> selectCertificatePresentCondition ( Map<String, Object> params );

	void requestCertificate ( Map<String, Object> params );

	List<Map<String, Object>> selectCertificateAdminList ( Map<String, Object> params );

	Map<String, Object> selectCertificateUserInfo ( Map<String, Object> params );

	void apprCertificate ( Map<String, Object> params );

	void setCertificatePrintInfo ( Map<String, Object> params );

	String getCerSeq ( Map<String, Object> params );

	String getFormSeq ( Map<String, Object> params );

	int getCerNo ( Map<String, Object> params );

	void updateCertificateForm ( Map<String, Object> params );

	void updateCertificateFormDefault ( Map<String, Object> params );

	void insertCertificateCompForm ( Map<String, Object> params );

	String getCertificateCompForm ( Map<String, Object> params );

	List<Map<String, Object>> getCertificateStatusList ( Map<String, Object> params );

	List<Map<String, Object>> getCertificateSubmitList ( Map<String, Object> params );

	List<Map<String, Object>> getCertificateUseYn ( Map<String, Object> params );

	List<Map<String, Object>> getCertificateAlarmList ( Map<String, Object> params );

	void setCertificateUseYn ( Map<String, Object> params );

	void setCertificateAlarmReset ( Map<String, Object> params );

	void setCertificateAlarm ( Map<String, String> params );

	Map<String, Object> getEmpDutyPosiInfo(Map<String, Object> paramMap);
}
