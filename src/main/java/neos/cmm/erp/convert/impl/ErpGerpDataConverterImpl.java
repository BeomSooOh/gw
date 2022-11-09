package neos.cmm.erp.convert.impl;

import java.util.HashMap;
import java.util.Map;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.convert.ErpDataConverter;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;

public class ErpGerpDataConverterImpl implements ErpDataConverter{
	
	@Override
	public Map<String, Object> getBiz(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq         = (String)params.get("syncSeq");   	// 동기화 시퀀스
		String bizSeq          = (String)data.get("bizSeq");   	// 사업장시퀀스
		String groupSeq        = (String)params.get("groupSeq");   	// 그룹시퀀스
		String compSeq         = (String)params.get("compSeq");   	// 회사시퀀스
		String compRegistNum   = (String)data.get("noBizarea");   	// 사업자번호
		String compNum         = (String)data.get("noCompany");   	// 법인번호
		String telNum          = (String)data.get("noTel");   		// 전화
		String faxNum          = (String)data.get("noFax");   		// 팩스
		String homepgAddr      = null; // gerp 없음. (String)data.get("homepgAddr");   	// 홈페이지주소
		String zipCode         = (String)data.get("noAddr");   		// 우편번호
		
		String dtTopen  = (String)data.get("dtClose");
		
		String displayYn       = "Y";   	// 기본사업장여부
		
		String today = DateUtil.getToday("yyyyMMdd");
		
		if(!EgovStringUtil.isEmpty(dtTopen) && DateUtil.compare(today, dtTopen, "yyyyMMdd") > 0) {
			displayYn       = "N";
		}
		
		String nativeLangCode  = (String)params.get("langCode");   	// 주사용언어
		String orderNum        = "0"; // 없음. data.get("orderNum")+"";   	// 정렬순서
		
		String useYn           = displayYn;   		// 사용여부
		
		String editorSeq       = (String)params.get("editorSeq");   	// 등록자시퀀스
		String erpBizSeq       = (String)data.get("cdBizarea");   	// ERP 사업자 시퀀스
		String erpCompSeq      = (String)data.get("cdCompany");   	// ERP 회사 시퀀스
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("syncSeq", syncSeq);
		map.put("bizSeq", bizSeq);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("compRegistNum", compRegistNum);
		map.put("compNum", compNum);
		map.put("telNum", telNum);
		map.put("faxNum", faxNum);
		map.put("homepgAddr", homepgAddr);
		map.put("zipCode", zipCode);
		map.put("displayYn", displayYn);
		map.put("nativeLangCode", nativeLangCode);
		map.put("orderNum", orderNum);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		map.put("erpBizSeq", erpBizSeq);
		map.put("erpCompSeq", erpCompSeq);
		
		return map;
	}

	@Override
	public Map<String, Object> getBizMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq       = (String)params.get("syncSeq"); //동기화 시퀀스
		String bizSeq        = (String)data.get("bizSeq"); //사업장시퀀스
		String langCode      = (String)params.get("langCode"); //언어코드
		String groupSeq      = (String)params.get("groupSeq"); //그룹시퀀스
		String compSeq       = (String)params.get("compSeq"); //회사시퀀스
		String bizName       = (String)data.get("nmBizarea"); //사업장명
		String ownerName     = (String)data.get("nmMaster"); //대표자명
		String bizCondition  = (String)data.get("nmJob"); //업태
		String item           = (String)data.get("nmJobtype"); //종목
		String addr           = (String)data.get("addrBizH"); //우편주소
		String detailAddr    = (String)data.get("addrBizD"); //상세주소
		String useYn         = "N";//사용여부
		String editorSeq     = (String)params.get("editorSeq"); //
		
		String dtTopen  = (String)data.get("dtClose");
		
		useYn       = "N";   	// 기본사업장여부
		
		String today = DateUtil.getToday("yyyyMMdd");
		
		if(!EgovStringUtil.isEmpty(dtTopen) && DateUtil.compare(today, dtTopen, "yyyyMMdd") > 0) {
			useYn       = "N";
		} else {
			useYn       = "Y";
		}
		
		Map<String,Object> map = new HashMap<>();
		map.put("syncSeq", syncSeq);
		map.put("bizSeq", bizSeq);
		map.put("langCode", langCode);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("bizName", bizName);
		map.put("ownerName", ownerName);
		map.put("bizCondition", bizCondition);
		map.put("item", item);
		map.put("addr", addr);
		map.put("detailAddr", detailAddr);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		return map;
	}

	@Override
	public Map<String, Object> getDept(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq         = (String)params.get("syncSeq"); // 동기화 시퀀스
		String deptSeq         = (String)data.get("deptSeq"); // 부서시퀀스
		String deptCd          = (String)data.get("cdDept"); // 부서별칭
		String groupSeq        = (String)params.get("groupSeq"); // 그룹시퀀스
		String compSeq         = (String)params.get("compSeq"); // 회사시퀀스
		String bizSeq          = (String)data.get("bizSeq"); // 사업장시퀀스
		String parentDeptSeq   = (String)data.get("parentSeq"); // 상위부서시퀀스
		String telNum          = (String)data.get("noTel"); // 전화
		String faxNum          = (String)data.get("noFax"); // 팩스
		String homepgAddr      = null; // 없음(String)data.get("homepgAddr"); // 홈페이지주소
		String zipCode         = null; // 없음(String)data.get("adsNo"); // 우편번호
		String susinYn         = "Y"; // 수신여부
		String virDeptYn       = "N"; // 가상부서여부
		String teamYn          = "N"; // 팀부서여부
		String nativeLangCode  = (String)params.get("langCode"); // 주사용언어
		String path            = (String)data.get("path"); // 부서경로
		String ptype           = "1"; // 타입
		String deptLevel       = data.get("lvDept")+""; // 부서레벨
		String orderNum        = data.get("orderNum")+""; // 정렬순서
		String useYn           = "Y"; // 사용여부
		String editorSeq       = (String)params.get("editorSeq"); // 등록자시퀀스
		String deptManager     = null; // 없음(String)data.get("deptManager"); // 부서 관리자(부서장)
		String erpDeptSeq      = (String)data.get("cdDept"); // ERP 부서 시퀀스
		String erpBizSeq       = (String)data.get("cdBizarea"); // ERP 사업장 시퀀스
		String erpCompSeq      = (String)data.get("cdCompany"); // ERP 회사 시퀀스
		
		//case when #dtEnd# is null or #dtEnd# = '' then 'Y' when now() >= DATE_FORMAT(#dtStart#, '%Y-%m-%d 00:00:00') and DATE_FORMAT(#dtEnd#, '%Y-%m-%d 23:59:59') >= now() then 'Y' else 'N' end,  
		String dtEnd = (String)data.get("dtEnd");
		String today = DateUtil.getToday("yyyyMMdd");
		
		if(!EgovStringUtil.isEmpty(dtEnd) && DateUtil.compare(today, dtEnd, "yyyyMMdd") > 0) {
			useYn       = "N";
		}
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("syncSeq", syncSeq);
		map.put("deptSeq", deptSeq);
		map.put("deptCd", deptCd);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("bizSeq", bizSeq);
		map.put("parentDeptSeq", parentDeptSeq);
		map.put("telNum", telNum);
		map.put("faxNum", faxNum);
		map.put("homepgAddr", homepgAddr);
		map.put("zipCode", zipCode);
		map.put("susinYn", susinYn);
		map.put("virDeptYn", virDeptYn);
		map.put("teamYn", teamYn);
		map.put("nativeLangCode", nativeLangCode);
		map.put("path", path);
		map.put("ptype", ptype);
		map.put("deptLevel", deptLevel);
		map.put("orderNum", orderNum);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		map.put("deptManager", deptManager);
		map.put("erpDeptSeq", erpDeptSeq);
		map.put("erpBizSeq", erpBizSeq);
		map.put("erpCompSeq", erpCompSeq);
		
		return map;
	}

	@Override
	public Map<String, Object> getDeptMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq         = (String)params.get("syncSeq"); // 동기화 시퀀스
		String deptSeq         = (String)data.get("deptSeq"); // 부서시퀀스
		String langCode        = (String)params.get("langCode"); // 언어코드
		String groupSeq        = (String)params.get("groupSeq"); // 그룹시퀀스
		String compSeq         = (String)params.get("compSeq"); // 회사시퀀스
		String bizSeq          = (String)data.get("bizSeq"); // 사업장시퀀스
		String deptName        = (String)data.get("nmDept"); // 부서명
		String deptDisplayName = (String)data.get("nmDept"); // 부서표시명
		String senderName      = null; // 발신인명
		String addr            = null; // 없음 (String)data.get("adsH"); // 우편주소
		String detailAddr      = null; // 없음(String)data.get("adsD"); // 상세주소
		String pathName        = (String)data.get("pathName"); // 부서경로명
		String useYn           = "Y"; // 사용여부
		String editorSeq       = (String)params.get("editorSeq"); // 등록자시퀀스
		
		String dtEnd = (String)data.get("dtEnd");
		String today = DateUtil.getToday("yyyyMMdd");
		if(!EgovStringUtil.isEmpty(dtEnd) && DateUtil.compare(today, dtEnd, "yyyyMMdd") > 0) {
			useYn       = "N";
		}
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("syncSeq", syncSeq);
		map.put("deptSeq", deptSeq);
		map.put("langCode", langCode);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("bizSeq", bizSeq);
		map.put("deptName", deptName);
		map.put("deptDisplayName", deptDisplayName);
		map.put("senderName", senderName);
		map.put("addr", addr);
		map.put("detailAddr", detailAddr);
		map.put("pathName", pathName);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		
		return map;
	}

	private String getStr(Map<String, Object> data, String key){
		Object o = data.get(key);
		
		if(o == null || (o+"").trim().toLowerCase().equals("null")) {
			return "";
		} else {
			return o+"";
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEmp(Map<String, Object> data, Map<String, Object> params) {
		Map<String,Object> map = new HashMap<>();
		
		try{
			String syncSeq             = (String)params.get("syncSeq"); //동기화 시퀀스
			String empSeq              = null; //사용자시퀀스
			String groupSeq            = (String)params.get("groupSeq"); //그룹시퀀스
			String loginId             = (String)data.get("loginId"); //로그인아이디
			String empNum              = null; //사번
			String erpEmpNum           = (String)data.get("noEmp"); //erp사번
			String emailAddr           = getStr(data, "nmEmail"); //이메일아이디
			String loginPasswd         = "1111"; //로그인패스워드
			String apprPasswd          = "1111"; //전자결재패스워드
			String passwdDate          = null; //패스워드변경일자
			String passwdInputFailCount= "0"; //패스워드입력실패카운트
			String payPasswd           = "1111"; //급여명세패스워드
			String passwdStatusCode    = null; //패스워드상태
			String mobileUseYn         = (String)data.get("mobileUseYn"); //모바일 사용여부
			String messengerUseYn      = (String)data.get("messengerUseYn"); //메신저 사용여부
			String checkWorkYn         = (String)data.get("checkWorkYn"); //근태적용여부
			String shift               = (String)data.get("shift"); //근무조
			String jobCode             = "4";						//직무유형은 해당없음 으로 기본 셋팅
			String statusCode          = (String)data.get("cdEmp"); //고용형태(정규직,계약직)
			String mainCompSeq         = (String)params.get("compSeq"); //주회사시퀀스
			String dutyCode            = (String)data.get("cdDutyResp"); //직책
			String positionCode        = (String)data.get("cdDutyStep"); //직급
			String nativeLangCode      = (String)params.get("langCode"); //주사용언어
			String licenseCheckYn      = (String)data.get("licenseCheckYn"); //라이센스체크여부
			String joinDay             = (String)data.get("dtEnter"); //입사일
			String resignDay           = (String)data.get("dtRetire"); //퇴사일
			String genderCode          = null; //성별코드
			String bday                = (String)data.get("dtBirth"); //생일
			String lunarYn             = (String)data.get("cdDay"); //생일구분
			String workStatus          = (String)data.get("workStatus"); //재직구분
			String homeTelNum          = (String)data.get("noTel"); //집전화번호
			String mobileTelNum        = (String)data.get("noTel"); //핸드폰번호
			String weddingYn           = (String)data.get("ynMarry"); //결혼유무
			String weddingDay          = (String)data.get("dtMarry"); //결혼기념일
			String privateYn           = (String)data.get("privateYn"); //공개/비공개
			String zipCode             = (String)data.get("noPostCur"); //우편번호
			String picFileId           = (String)data.get("erpPicFileId"); //사진파일명
			String signFileId          = (String)data.get("signFileId"); //사인파일명
			String useYn               = (String)data.get("ynUse"); //사용여부
			String lsRoleId            = (String)data.get("lsRoleId"); //전자결재 role 설정
			String editorSeq           = (String)params.get("editorSeq"); //등록자시퀀스
			String erpEmpSeq           = (String)data.get("noEmp"); //ERP 사원 시퀀스
			String erpCompSeq          = (String)data.get("cdCompany"); //ERP 회사 시퀀스
			String erpBizSeq           = (String)data.get("cdBizarea"); //ERP 사업장 시퀀스
			String erpDeptSeq          = (String)data.get("cdDept"); //ERP 부서 시퀀스
			String loginIdType         = (String)params.get("loginIdType"); // loginId 종류
			String bizSeq         	   = (String)data.get("bizSeq"); // bizSeq
			String noGemp         	   = (String)data.get("noGemp"); // noGemp
			

			if(params.get("erpIuPositionSet").equals("cdDutyStep")) {
				positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyStep"); 
			}else if(params.get("erpIuPositionSet").equals("cdDutyResp")) {
				positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyResp"); 
			}else if(params.get("erpIuPositionSet").equals("cdDutyRank")) {
				positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyRank"); 
			}
			
			if(params.get("erpIuDutySet").equals("cdDutyStep")) {
				dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyStep"); 
			}else if(params.get("erpIuDutySet").equals("cdDutyResp")) {
				dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyResp"); 
			}else if(params.get("erpIuDutySet").equals("cdDutyRank")) {
				dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyRank"); 
			}
			
			
			Map<String,Object> empTypeCodeInfo = (Map<String, Object>) params.get("empTypeCodeInfo");
			Map<String,Object> genderCodeInfo = (Map<String, Object>) params.get("genderCodeInfo");
			Map<String,Object> birthdayCodeInfo = (Map<String, Object>) params.get("birthdayCodeInfo");
			Map<String,Object> wsCodeInfo = (Map<String, Object>) params.get("wsCodeInfo");

			licenseCheckYn = "1"; 	// GERP는 무조건 라이센스 보유로 처리
			String cdEmp = data.get("cdEmp").toString();				// 고용형태
			String cdIncom = data.get("cdIncom").toString();			// 재직구분

			if(licenseCheckYn.equals("1")) {
				mobileUseYn = "Y";
				messengerUseYn = "Y";
				data.put("messengerDisplayYn", "Y");
				data.put("orgchartDisplayYn", "Y");
			} else {
				mobileUseYn = "N";
				messengerUseYn = "N";
				data.put("messengerDisplayYn", "N");
				data.put("orgchartDisplayYn", "N");
			}
			
			//일용직의 경우 직급/직책값 임시직급/직책으로 셋팅
			if(statusCode.equals("2")) {
				dutyCode = "99999";
				positionCode = "99999";
			}
			
			// 재직구분
			workStatus = (String)wsCodeInfo.get(cdIncom);
			// 고용형태
			statusCode = (String)empTypeCodeInfo.get(cdEmp);
			// 성별
			genderCode = (String)genderCodeInfo.get(data.get("cdSex"));
			// 생일구분
			lunarYn = (String)birthdayCodeInfo.get(data.get("cdDay"));
			
			
			
			map.put("syncSeq", syncSeq);
			map.put("empSeq", empSeq);
			map.put("groupSeq", groupSeq);
			map.put("loginId", loginId);
			map.put("empNum", empNum);
			map.put("erpEmpNum", erpEmpNum);
			map.put("emailAddr", emailAddr);
			map.put("loginPasswd", loginPasswd);
			map.put("apprPasswd", apprPasswd);
			map.put("passwdDate", passwdDate);
			map.put("passwdInputFailCount", passwdInputFailCount);
			map.put("payPasswd", payPasswd);
			map.put("passwdStatusCode", passwdStatusCode);
			map.put("mobileUseYn", mobileUseYn);
			map.put("messengerUseYn", messengerUseYn);
			map.put("checkWorkYn", checkWorkYn);
			map.put("shift", shift);
			map.put("jobCode", jobCode);
			map.put("statusCode", statusCode);
			map.put("mainCompSeq", mainCompSeq);
			map.put("dutyCode", dutyCode);
			map.put("positionCode", positionCode);
			map.put("nativeLangCode", nativeLangCode);
			map.put("licenseCheckYn", licenseCheckYn);
			map.put("joinDay", joinDay);
			map.put("resignDay", resignDay);
			map.put("genderCode", genderCode);
			map.put("bday", bday);
			map.put("lunarYn", lunarYn);
			map.put("workStatus", workStatus);
			map.put("homeTelNum", homeTelNum);
			map.put("mobileTelNum", mobileTelNum);
			map.put("weddingYn", weddingYn);
			map.put("weddingDay", weddingDay);
			map.put("privateYn", privateYn);
			map.put("zipCode", zipCode);
			map.put("picFileId", picFileId);
			map.put("signFileId", signFileId);
			map.put("useYn", useYn);
			map.put("lsRoleId", lsRoleId);
			map.put("editorSeq", editorSeq);
			map.put("erpEmpSeq", erpEmpSeq);
			map.put("erpCompSeq", erpCompSeq);
			map.put("erpBizSeq", erpBizSeq);
			map.put("erpDeptSeq", erpDeptSeq);
			map.put("loginIdType", loginIdType);
			map.put("bizSeq", bizSeq);
			map.put("noGemp", noGemp);
		} catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return map;
	}

	@Override
	public Map<String, Object> getEmpMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq    = (String)params.get("syncSeq");   // 동기화 시퀀스
		String empSeq     = (String)data.get("empSeq");   // 사용자시퀀스
		String langCode   = (String)params.get("langCode");   // 언어코드
		String groupSeq   = (String)params.get("groupSeq");   // 그룹시퀀스
		String empName    = (String)data.get("nmKor");   // 사용자명
		String addr       = (String)data.get("addrCur1");   // 우편주소
		String detailAddr = (String)data.get("addrCur2");   // 상세주소
		String mainWork   = null;   // 담당업무
		String useYn      = (String)data.get("ynUse");   // 사용여부
		String editorSeq  = (String)params.get("editorSeq");   // 등록자시퀀스
		String bizSeq     = (String)data.get("bizSeq"); // bizSeq
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("syncSeq", syncSeq);
		map.put("empSeq", empSeq);
		map.put("langCode", langCode);
		map.put("groupSeq", groupSeq);
		map.put("empName", empName);
		map.put("addr", addr);
		map.put("detailAddr", detailAddr);
		map.put("mainWork", mainWork);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		
		/** query 에서 사용하는 필드 */
		String loginIdType= (String)params.get("loginIdType"); // loginId 종류
		String workStatus = (String)data.get("workStatus"); // loginId 종류
		String erpEmpSeq  = (String)data.get("noEmp"); //ERP 사원 시퀀스
		String erpCompSeq = (String)data.get("noCompany"); //ERP 회사 시퀀스
		String erpBizSeq  = (String)data.get("cdBizarea"); //ERP 사업장 시퀀스
		String erpDeptSeq = (String)data.get("cdDept"); //ERP 부서 시퀀스
		String loginId    = (String)data.get("loginId"); //
		map.put("loginIdType", loginIdType);
		map.put("workStatus", workStatus);
		map.put("erpEmpSeq", erpEmpSeq);
		map.put("erpCompSeq", erpCompSeq);
		map.put("erpBizSeq", erpBizSeq);
		map.put("erpDeptSeq", erpDeptSeq);
		map.put("loginId", loginId);
		map.put("bizSeq", bizSeq);
		
		return map;
	}

	@Override
	public Map<String, Object> getEmpDept(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq           = (String)params.get("syncSeq"); // 동기화 시퀀스
		String deptSeq           = (String)data.get("deptSeq"); // 부서시퀀스
		String empSeq            = (String)data.get("empSeq"); // 사용자시퀀스
		String groupSeq          = (String)params.get("groupSeq"); // 그룹시퀀스
		String compSeq           = (String)params.get("compSeq"); // 회사시퀀스
		String bizSeq            = (String)data.get("bizSeq"); // 사업장시퀀스
		String mainDeptYn        = (String)data.get("mainDeptYn"); // 주부서여부
		String dutyCode          = (String)data.get("cdDutyStep"); // 직책
		String positionCode      = (String)data.get("cdDutyResp"); // 직급
		String telNum            = (String)data.get("noTel"); // 사무실전화
		String faxNum            = null; // 없음(String)data.get("faxNum"); // 팩스번호
		String zipCode           = (String)data.get("noPostCur"); // 우편번
		String orgchartDisplayYn = (String)data.get("orgchartDisplayYn"); // 조직도표시여
		String messengerDisplayYn= (String)data.get("messengerDisplayYn"); // 메신저 표시 여부
		String orderNum          = "0"; // 없음 data.get("orderNum")+""; // 정렬순서
		String useYn             = (String)data.get("ynUse"); // 사용여부
		String editorSeq         = (String)params.get("editorSeq"); // 등록자시퀀스
		String erpEmpSeq         = (String)data.get("noEmp"); // ERP 사용자 시퀀스
		String erpCompSeq        = (String)data.get("cdCompany"); // ERP 회사 시퀀스
		String erpBizSeq         = (String)data.get("cdBizarea"); // ERP 사업장 시퀀스
		String erpDeptSeq        = (String)data.get("cdDept"); // ERP 부서 시퀀스
		String workStatus        = (String)data.get("workStatus");                                      
		String loginIdType		 = (String)data.get("loginIdType");
		String loginId			 = (String)data.get("loginId");
		String statusCode          = (String)data.get("cdEmp"); //고용형태(정규직,계약직)
		String emailAddr           = getStr(data, "nmEmail"); //이메일아이디
		
		Map<String,Object> map = new HashMap<>();
		
		if(params.get("erpIuPositionSet").equals("cdDutyStep")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyStep"); 
		}else if(params.get("erpIuPositionSet").equals("cdDutyResp")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyResp"); 
		}else if(params.get("erpIuPositionSet").equals("cdDutyRank")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyRank"); 
		}
		
		if(params.get("erpIuDutySet").equals("cdDutyStep")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyStep"); 
		}else if(params.get("erpIuDutySet").equals("cdDutyResp")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyResp"); 
		}else if(params.get("erpIuDutySet").equals("cdDutyRank")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("cdDutyRank"); 
		}
		
		
		//일용직의 경우 직급/직책값 임시직급/직책으로 셋팅
		if(statusCode.equals("2")) {
			dutyCode = "99999";
			positionCode = "99999";
		}
		
		map.put("syncSeq", syncSeq);
		map.put("deptSeq", deptSeq);
		map.put("empSeq", empSeq);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("bizSeq", bizSeq);
		map.put("mainDeptYn", mainDeptYn);
		map.put("dutyCode", dutyCode);
		map.put("positionCode", positionCode);
		map.put("telNum", telNum);
		map.put("faxNum", faxNum);
		map.put("zipCode", zipCode);
		map.put("orgchartDisplayYn", orgchartDisplayYn);
		map.put("messengerDisplayYn", messengerDisplayYn);
		map.put("orderNum", orderNum);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		map.put("erpEmpSeq", erpEmpSeq);
		map.put("erpCompSeq", erpCompSeq);
		map.put("erpBizSeq", erpBizSeq);
		map.put("erpDeptSeq", erpDeptSeq);
		map.put("workStatus", workStatus);
		map.put("loginIdType", loginIdType);
		map.put("loginId", loginId);
		map.put("emailAddr", emailAddr);
		
		return map;
	}

	@Override
	public Map<String, Object> getEmpDeptMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq    = (String)params.get("syncSeq");     // 동기화 시퀀스
		String deptSeq    = (String)data.get("deptSeq");     // 부서시퀀스
		String empSeq     = (String)data.get("empSeq");        // 사용자시퀀스
		String langCode   = (String)params.get("langCode");      // 언어코드
		String groupSeq   = (String)params.get("groupSeq");    // 그룹시퀀스
		String compSeq    = (String)params.get("compSeq");     // 회사시퀀스
		String bizSeq     = (String)data.get("bizSeq");      // 사업장시퀀스
		String addr       = (String)data.get("addrCur1"); // 우편주소
		String detailAddr = (String)data.get("addrCur2"); // 상세주소
		String useYn      = (String)data.get("ynUse");         // 사용여부
		String editorSeq  = (String)params.get("editorSeq");   // 등록자시퀀스
		
		
		Map<String,Object> map = new HashMap<>();
		map.put("syncSeq", syncSeq);
		map.put("deptSeq", deptSeq);
		map.put("empSeq", empSeq);
		map.put("langCode", langCode);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("bizSeq", bizSeq);
		map.put("addr", addr);
		map.put("detailAddr", detailAddr);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		
		/** query 에서 사용하는 필드 */
		String loginIdType= (String)params.get("loginIdType"); // loginId 종류
		String workStatus = (String)data.get("workStatus"); // loginId 종류
		String erpEmpSeq  = (String)data.get("noEmp"); //ERP 사원 시퀀스
		String erpCompSeq = (String)data.get("noCompany"); //ERP 회사 시퀀스
		String erpBizSeq  = (String)data.get("cdBizarea"); //ERP 사업장 시퀀스
		String erpDeptSeq = (String)data.get("cdDept"); //ERP 부서 시퀀스
		String loginId    = (String)data.get("loginId"); //
		map.put("loginIdType", loginIdType);
		map.put("workStatus", workStatus);
		map.put("erpEmpSeq", erpEmpSeq);
		map.put("erpCompSeq", erpCompSeq);
		map.put("erpBizSeq", erpBizSeq);
		map.put("erpDeptSeq", erpDeptSeq);
		map.put("loginId", loginId);
		
		return map;
	}

	@Override
	public Map<String,Object> getCompDutyPosition(Map<String, Object> data, Map<String, Object> params) {
		String dpSeq      = (String) data.get("cdSysdef"); // 직책직급 시퀀스
		String groupSeq   = (String) params.get("groupSeq"); // 그룹 시퀀
		String compSeq    = (String) params.get("compSeq"); // 회사 시퀀스
		String dpType     = (String) data.get("dpType"); // DUTY : 직책, POSITION : 직급
		String useYn      = "Y"; // 사용여부(Y,N)
		String orderNum   = data.get("orderNum")+""; // 정렬순서
		String editorSeq  = (String) params.get("editorSeq"); // 
		
		Map<String,Object> map = new HashMap<>();
		map.put("dpSeq", dpSeq);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("dpType", dpType);
		map.put("useYn", useYn);
		map.put("orderNum", orderNum);
		map.put("editorSeq", editorSeq);
		
		
		return map;
	}

	@Override
	public Map<String,Object> getCompDutyPositionMulti(Map<String, Object> data, Map<String, Object> params) {
		String dpSeq       = (String)data.get("cdSysdef"); // 직급직책 시퀀스
		String langCode    = (String)params.get("langCode"); // 다국어 코드
		String groupSeq    = (String)params.get("groupSeq"); // 그룹 시퀀스
		String compSeq     = (String)params.get("compSeq"); // 회사 시퀀스
		String dpType      = (String)data.get("dpType"); // DUTY:직책, POSITION:직급
		String dpName      = (String)data.get("nmSysdef"); // 직급명, 직책명
		String descText    = null; // 설명
		String commentText = null; // 비고
		String useYn       = "Y"; // 사용여부
		String editorSeq  = (String) params.get("editorSeq"); //
		
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("dpSeq", dpSeq);
		map.put("langCode", langCode);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("dpType", dpType);
		map.put("dpName", dpName);
		map.put("descText", descText);
		map.put("commentText", commentText);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		
		return map;
	}

	@Override
	public Map<String, Object> getComp(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq          = getStr(params, "syncSeq");   	// 동기화 시퀀스
		String groupSeq         = getStr(params, "groupSeq");
		String compSeq          = groupSeq+getStr(data, "cdCompany");	// 그룹시퀀스 + ERP회사코드
		String compCd           = groupSeq+getStr(data, "cdCompany");
		String parentCompSeq    = (data.get("cdUpcompany") != null && !data.get("cdUpcompany").equals("") ? groupSeq : "0") + getStr(data, "cdUpcompany");	// 모기업 코드
		String loginType        = "B";	// 기본 B타입
		String compRegistNum    = getStr(data, "noCompany");
		String compNum          = getStr(data, "noCor");
		String standardCode     = null;
		String erpUse           = "Y";
		String telNum           = getStr(data, "noTel");
		String faxNum           = getStr(data, "noFax");
		String homepgAddr       = null;
		String compMailUrl      = null;
		String compDomain       = getStr(params, "compDomain");
		String emailAddr        = null;
		String emailDomain      = getStr(data, "nmEmail");
		String zipCode          = getStr(data, "noPost");
		String smsUse           = "N";
		String smsId            = null;
		String smsPasswd        = null;
		String nativeLangCode   = "kr";					// 다국어 처리 필요..
		String orderNum         = getStr(data, "orderNum");
		String useYn            = "Y";
		String eaType           = "eap"; 				// 영리만 진행.
		String editorSeq  		= getStr(params, "editorSeq"); 
		String compEmailYn      = "N";
		String erpUseYn         = "Y";
		String smsUseYn         = "N";
		String erpCompSeq       = getStr(data, "cdCompany");
		String resultCode       = getStr(data, "resultCode");
		
		Map<String, Object> map = new HashMap<>();
		map.put("syncSeq", syncSeq);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("compCd", compCd);
		map.put("parentCompSeq", parentCompSeq);
		map.put("loginType", loginType);
		map.put("compRegistNum", compRegistNum);
		map.put("compNum", compNum);
		map.put("standardCode", standardCode);
		map.put("erpUse", erpUse);
		map.put("telNum", telNum);
		map.put("faxNum", faxNum);
		map.put("homepgAddr", homepgAddr);
		map.put("compMailUrl", compMailUrl);
		map.put("compDomain", compDomain);
		map.put("emailAddr", emailAddr);
		map.put("emailDomain", emailDomain);
		map.put("zipCode", zipCode);
		map.put("smsUse", smsUse);
		map.put("smsId", smsId);
		map.put("smsPasswd", smsPasswd);
		map.put("nativeLangCode", nativeLangCode);
		map.put("orderNum", orderNum);
		map.put("useYn", useYn);
		map.put("eaType", eaType);
		map.put("editorSeq", editorSeq);
		map.put("compEmailYn", compEmailYn);
		map.put("erpUseYn", erpUseYn);
		map.put("smsUseYn", smsUseYn);
		map.put("erpCompSeq", erpCompSeq);
		map.put("resultCode", resultCode);
		
		return map;
	}

	@Override
	public Map<String, Object> getCompMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq            = getStr(params, "syncSeq");   	// 동기화 시퀀스
		String groupSeq           = getStr(params, "groupSeq"); //       
		String compSeq            = groupSeq+getStr(data, "cdCompany"); //
		String langCode           = "kr"; //       
		String compName           = getStr(data, "nmCompany"); //       
		String compDisplayName    = getStr(data, "nmCompany"); //              
		String ownerName          = getStr(data, "nmCeo"); //        
		String senderName         = null; //         
		String bizCondition       = null; //           
		String item               = null; //   
		String addr               = getStr(data, "addrBase1"); //
		String detailAddr         = getStr(data, "addrBase2"); //
		String useYn              = "Y"; //    
		String editorSeq  		  = getStr(params, "editorSeq"); //  
		String compNickname       = null; //           
		String erpCompSeq         = getStr(data, "cdCompany"); //         
		String erpCompName        = getStr(data, "nmCompany"); //         
		String resultCode         = getStr(data, "resultCode"); //         
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("syncSeq", syncSeq);
		map.put("groupSeq", groupSeq);
		map.put("compSeq", compSeq);
		map.put("langCode", langCode);
		map.put("compName", compName);
		map.put("compDisplayName", compDisplayName);
		map.put("ownerName", ownerName);
		map.put("senderName", senderName);
		map.put("bizCondition", bizCondition);
		map.put("item", item);
		map.put("addr", addr);
		map.put("detailAddr", detailAddr);
		map.put("useYn", useYn);
		map.put("editorSeq", editorSeq);
		map.put("compNickname", compNickname);
		map.put("erpCompSeq", erpCompSeq);
		map.put("erpCompName", erpCompName);
		map.put("resultCode", resultCode);
		
		return map;
	}

}
