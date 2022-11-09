package neos.cmm.erp.convert.impl;

import java.util.HashMap;
import java.util.Map;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.convert.ErpDataConverter;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.DateUtil;

public class ErpICubeDataConverterImpl implements ErpDataConverter{
	
	@Override
	public Map<String, Object> getBiz(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq         = (String)params.get("syncSeq");   	// 동기화 시퀀스
		String bizSeq          = (String)data.get("bizSeq");   	// 사업장시퀀스
		String groupSeq        = (String)params.get("groupSeq");   	// 그룹시퀀스
		String compSeq         = (String)params.get("compSeq");   	// 회사시퀀스
		String compRegistNum   = (String)data.get("regNb");   	// 사업자번호
		String compNum         = (String)data.get("coNb");   	// 법인번호
		String telNum          = (String)data.get("divTel");   		// 전화
		String faxNum          = (String)data.get("divFax");   		// 팩스
		String homepgAddr      = "";   	// 홈페이지주소
		String zipCode         = (String)data.get("divZip");   		// 우편번호
		
		
		String dtFopen = (String)data.get("openDt");
		if(dtFopen != null) {
			dtFopen = dtFopen.trim();
		}
		String dtTopen  = (String)data.get("closeDt");
		
		String displayYn       = "Y";   	// 기본사업장여부
		
		String today = DateUtil.getToday("yyyyMMdd");
		
		if(EgovStringUtil.isEmpty(dtFopen) ||(!EgovStringUtil.isEmpty(dtTopen) && DateUtil.compare(today, dtTopen, "yyyyMMdd") > 0)) {
			displayYn       = "N";
		}
		
		String nativeLangCode  = (String)params.get("langCode");   	// 주사용언어
		String orderNum        = data.get("orderNum")+"";   	// 정렬순서
		
		String useYn           = displayYn;   		// 사용여부
		
		String editorSeq       = (String)params.get("editorSeq");   	// 등록자시퀀스
		String erpBizSeq       = (String)data.get("divCd");   	// ERP 사업자 시퀀스
		String erpCompSeq      = (String)data.get("coCd");   	// ERP 회사 시퀀스
		
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
		String bizName       = (String)data.get("divNm"); //사업장명
		String ownerName     = (String)data.get("ceoNm"); //대표자명
		String bizCondition  = (String)data.get("business"); //업태
		String item           = (String)data.get("jongmok"); //종목
		String addr           = (String)data.get("divAddr"); //우편주소
		String detailAddr    = (String)data.get("divAddr1"); //상세주소
		String useYn         = "N";//사용여부
		String editorSeq     = (String)params.get("editorSeq"); //
		
		String dtTopen  = (String)data.get("closeDt");
		
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
		String deptCd          = (String)data.get("deptCd"); // 부서별칭
		String groupSeq        = (String)params.get("groupSeq"); // 그룹시퀀스
		String compSeq         = (String)params.get("compSeq"); // 회사시퀀스
		String bizSeq          = (String)data.get("bizSeq"); // 사업장시퀀스
		String parentDeptSeq   = (String)data.get("parentSeq"); // 상위부서시퀀스
		String telNum          = (String)data.get("divTel"); // 전화
		String faxNum          = (String)data.get("divFax"); // 팩스
		String homepgAddr      = ""; // 홈페이지주소
		String zipCode         = (String)data.get("divZip"); // 우편번호
		String susinYn         = "Y"; // 수신여부
		String virDeptYn       = "N"; // 가상부서여부
		String teamYn          = "N"; // 팀부서여부
		String nativeLangCode  = (String)params.get("langCode"); // 주사용언어
		String path            = (String)data.get("path"); // 부서경로
		String ptype           = "1"; // 타입
		String deptLevel       = "1"; // 부서레벨
		String orderNum        = data.get("orderNum")+""; // 정렬순서
		String useYn     	   = (String)data.get("useYn"); // 사용여부
		String editorSeq       = (String)params.get("editorSeq"); // 등록자시퀀스
		String deptManager     = (String)data.get("deptManager"); // 부서 관리자(부서장)
		String erpDeptSeq      = (String)data.get("deptCd"); // ERP 부서 시퀀스
		String erpBizSeq       = (String)data.get("divCd"); // ERP 사업장 시퀀스
		String erpCompSeq      = (String)data.get("coCd"); // ERP 회사 시퀀스
		
		//case when #dtEnd# is null or #dtEnd# = '' then 'Y' when now() >= DATE_FORMAT(#dtStart#, '%Y-%m-%d 00:00:00') and DATE_FORMAT(#dtEnd#, '%Y-%m-%d 23:59:59') >= now() then 'Y' else 'N' end,  
		String dtEnd = (String)data.get("toDt");
		String today = DateUtil.getToday("yyyyMMdd");
		
		if(!EgovStringUtil.isEmpty(dtEnd) && DateUtil.compare(today, dtEnd, "yyyyMMdd") > 0) {
			useYn       = "N";
		} 
		
		useYn = useYn == null ? "Y":useYn;
		
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
		String deptName        = (String)data.get("deptNm"); // 부서명
		String deptDisplayName = (String)data.get("deptNm"); // 부서표시명
		String senderName      = null; // 발신인명
		String addr            = (String)data.get("divAddr"); // 우편주소
		String detailAddr      = (String)data.get("divAddr1"); // 상세주소
		String pathName        = (String)data.get("pathName"); // 부서경로명
		String useYn           = (String)data.get("useYn"); // 사용여부
		String editorSeq       = (String)params.get("editorSeq"); // 등록자시퀀스
		
		String dtEnd = (String)data.get("toDt");
		String today = DateUtil.getToday("yyyyMMdd");
		if(!EgovStringUtil.isEmpty(dtEnd) && DateUtil.compare(today, dtEnd, "yyyyMMdd") > 0) {
			useYn       = "N";
		}
		
		useYn = useYn == null ? "Y":useYn;
		
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
		String result = "";
		
		if(data.get(key) == null){
			result = "";
		} else if(((String)data.get(key)).equals("")) {
			result = "";
		} else {
			result = (String)data.get(key);
		}
	
		if(result.length() > 0){
			return result;
		} else {
			return "";
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEmp(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq             = (String)params.get("syncSeq"); //동기화 시퀀스
		String empSeq              = null; //사용자시퀀스
		String groupSeq            = (String)params.get("groupSeq"); //그룹시퀀스
		String loginId             = (String)data.get("loginId"); //로그인아이디
		String empNum              = null; //사번
		String erpEmpNum           = (String)data.get("empCd"); //erp사번
		String emailAddr           = getStr(data, "emalAdd"); //이메일아이디
		String loginPasswd         = (String)params.get("passwdOption"); //로그인패스워드
		//String apprPasswd          = (String)params.get("passwdOption"); //전자결재패스워드
		String passwdDate          = (String)params.get("passwdOption"); //패스워드변경일자
		String passwdInputFailCount= "0"; //패스워드입력실패카운트
		//String payPasswd           = (String)params.get("passwdOption"); //급여명세패스워드
		String passwdStatusCode    = "P"; //패스워드상태
		String mobileUseYn         = (String)data.get("mobileUseYn"); //모바일 사용여부
		String messengerUseYn      = (String)data.get("messengerUseYn"); //메신저 사용여부
		String checkWorkYn         = (String)data.get("checkWorkYn"); //근태적용여부
		String shift               = (String)data.get("prtyCd"); //근무조
		String jobCode             = "4";						//직무유형은 해당없음 으로 기본 셋팅
		String statusCode          = (String)data.get("emplFg"); //고용형태(정규직,계약직)
		String mainCompSeq         = (String)params.get("compSeq"); //주회사시퀀스
		String dutyCode            = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); //직책
		String positionCode        = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); //직급
		String nativeLangCode      = (String)params.get("langCode"); //주사용언어
		String licenseCheckYn      = (String)data.get("licenseCheckYn"); //라이센스체크여부
		String joinDay             = CommonUtil.dateCheck((String)data.get("joinDt")); //입사일
		String resignDay           = CommonUtil.dateCheck((String)data.get("rtrDt")); //퇴사일
		String genderCode          = (String)data.get("genderFg");//성
		String bday                = CommonUtil.dateCheck((String)data.get("brthDt")); //생일
		String lunarYn             = (String)data.get("lsclFg"); //생일구분
		String workStatus          = (String)data.get("enrlFg"); //재직구분
		String homeTelNum          = (String)data.get("emgcTel"); //집전화번호
		String mobileTelNum        = (String)data.get("tel"); //핸드폰번호
		String weddingYn           = (String)data.get("marryYn"); //결혼유무
		String weddingDay          = null; //결혼기념일
		String privateYn           = (String)data.get("privateYn"); //공개/비공개
		String zipCode             = (String)data.get("rrZip"); //우편번호
		String picFileId           = (String)data.get("erpPicFileId"); //사진파일명
		String signFileId          = (String)data.get("signFileId"); //사인파일명
		String useYn               = (String)data.get("usrYn"); //사용여부
		String lsRoleId            = (String)data.get("lsRoleId"); //전자결재 role 설정
		String editorSeq           = (String)params.get("editorSeq"); //등록자시퀀스
		String erpEmpSeq           = (String)data.get("empCd"); //ERP 사원 시퀀스
		String erpCompSeq          = (String)data.get("coCd"); //ERP 회사 시퀀스
		String erpBizSeq           = (String)data.get("divCd"); //ERP 사업장 시퀀스
		String erpDeptSeq          = (String)data.get("deptCd"); //ERP 부서 시퀀스
		String loginIdType         = (String)params.get("loginIdType"); // loginId 종류
		String bizSeq         	   = (String)data.get("bizSeq"); // bizSeq
		String rowNum			   = (String)data.get("rownum"); //동기화순번
		
		if (loginIdType.equals("1")) {
			loginId = (String)data.get("empCd");
		} else {
			loginId = emailAddr;
			
			int idx = loginId.indexOf("@");
			
			if(loginId.length() > 0) {
				loginId = (String)data.get("emalAdd").toString().substring(0, idx);
			} else {
				loginId = "";
			}
		}
		
		useYn = useYn != null && useYn.equals("1") ? "Y" : "N";
		
		if(bday == null) {
			bday = null;
		} else if(EgovStringUtil.isEmpty(bday)) {
			bday = null;
		}
		
		if(resignDay == null) {
			resignDay = null;
		} else if(EgovStringUtil.isEmpty(resignDay)){
			resignDay = null;
		}
		
		if(joinDay == null) {
			joinDay = null;
		} else if(EgovStringUtil.isEmpty(joinDay)){
			joinDay = null;
		}
		
		if(weddingYn == null) {
			weddingYn = "N";
		} else if(EgovStringUtil.isEmpty(weddingYn)) {
			weddingYn = "N";
		} else if(weddingYn.equals("001")) {
			weddingYn = "Y";
		} else if(weddingYn.equals( "000" )) {
			weddingYn = "N";
		}
		
		if(genderCode.equals("W")) {
			genderCode = "F";
		}
		
		Map<String,Object> empTypeCodeInfo = (Map<String, Object>) params.get("empTypeCodeInfo");
		Map<String,Object> birthdayCodeInfo = (Map<String, Object>) params.get("birthdayCodeInfo");
		Map<String,Object> wsCodeInfo = (Map<String, Object>) params.get("wsCodeInfo");
		Map<String,Object> licenseCodeInfo1 = (Map<String, Object>) params.get("licenseCodeInfo1");
		Map<String,Object> licenseCodeInfo2 = (Map<String, Object>) params.get("licenseCodeInfo2");
		Map<String,Object> checkWorkYn1 = (Map<String, Object>) params.get("checkWorkYnInfo1");
		Map<String,Object> checkWorkYn2 = (Map<String, Object>) params.get("checkWorkYnInfo1");

		licenseCheckYn = "3"; 							// gw 라이선스(기본:비라이선스)
		String cdEmp = data.get("emplFg").toString();				// 고용형태
		String cdDutyType = data.get("htypCd") != null ? data.get("htypCd").toString():null; 	// 직종
		String cdIncom = data.get("enrlFg").toString();			// 재직구분
		if (cdEmp.equals("001")) {	// 상용직;
			licenseCheckYn = licenseCodeInfo1.get(cdDutyType) != null ? licenseCodeInfo1.get(cdDutyType).toString():"3";
			checkWorkYn = checkWorkYn1.get(cdDutyType) != null ? (String)checkWorkYn1.get(cdDutyType):"";
		} else if(cdEmp.equals("002")){	// 일용직
			licenseCheckYn = licenseCodeInfo2.get(cdDutyType) != null ? licenseCodeInfo2.get(cdDutyType).toString():"3";
			checkWorkYn = checkWorkYn2.get(cdDutyType) != null ? (String)checkWorkYn2.get(cdDutyType):"";
		}
		
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
		
		
		if(params.get("erpIuPositionSet").equals("cdDutyStep")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); 
		}else if(params.get("erpIuPositionSet").equals("cdDutyResp")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); 
		}
		
		if(params.get("erpIuDutySet").equals("cdDutyStep")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); 
		}else if(params.get("erpIuDutySet").equals("cdDutyResp")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); 
		}
		
		
		//일용직의 경우 직급/직책값 임시직급/직책으로 셋팅
		if(statusCode.equals("002")) {
			dutyCode = "99999";
			positionCode = "99999";
		}
		
		
		// 재직구분
		workStatus = (String)wsCodeInfo.get(cdIncom);
		// 고용형태
		statusCode = (String)empTypeCodeInfo.get(cdEmp);
		// 생일구분
		lunarYn = (String)birthdayCodeInfo.get(data.get("lsclFg"));
		
		
		Map<String,Object> map = new HashMap<>();
		map.put("syncSeq", syncSeq);
		map.put("empSeq", empSeq);
		map.put("groupSeq", groupSeq);
		map.put("loginId", loginId);
		map.put("empNum", empNum);
		map.put("erpEmpNum", erpEmpNum);
		map.put("emailAddr", emailAddr);
		map.put("loginPasswd", loginPasswd);
		//map.put("apprPasswd", apprPasswd);
		map.put("passwdDate", passwdDate);
		map.put("passwdInputFailCount", passwdInputFailCount);
		//map.put("payPasswd", payPasswd);
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
		map.put("rowNum", rowNum);
		return map;
	}

	@Override
	public Map<String, Object> getEmpMulti(Map<String, Object> data, Map<String, Object> params) {
		String syncSeq    = (String)params.get("syncSeq");   // 동기화 시퀀스
		String empSeq     = (String)data.get("empSeq");   // 사용자시퀀스
		String langCode   = (String)params.get("langCode");   // 언어코드
		String groupSeq   = (String)params.get("groupSeq");   // 그룹시퀀스
		String empName    = (String)data.get("korNm");   // 사용자명
		String addr       = (String)data.get("rsrgAdd");   // 우편주소
		String detailAddr = (String)data.get("rsrdAdd");   // 상세주소
		String mainWork   = null;   // 담당업무
		String useYn      = (String)data.get("usrYn");   // 사용여부
		String editorSeq  = (String)params.get("editorSeq");   // 등록자시퀀스
		String bizSeq     = (String)data.get("bizSeq"); // bizSeq
		
		useYn = useYn != null && useYn.equals("1") ? "Y" : "N";
		
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
		String erpEmpSeq  = (String)data.get("empCd"); //ERP 사원 시퀀스
		String erpCompSeq = (String)data.get("coCd"); //ERP 회사 시퀀스
		String erpBizSeq  = (String)data.get("divCd"); //ERP 사업장 시퀀스
		String erpDeptSeq = (String)data.get("deptCd"); //ERP 부서 시퀀스
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
		String mainDeptYn        = "Y"; // 주부서여부
		String dutyCode          = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); //직책
		String positionCode      = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); //직급
		String telNum            = null;
		String faxNum            = null;
		String zipCode           = (String)data.get("rrZip"); // 우편번
		String orgchartDisplayYn = (String)data.get("orgchartDisplayYn"); // 조직도표시여
		String messengerDisplayYn= (String)data.get("messengerDisplayYn"); // 메신저 표시 여부
		String orderNum          = data.get("orderNum")+""; // 정렬순서
		String useYn             = (String)data.get("usrYn"); // 사용여부
		String editorSeq         = (String)params.get("editorSeq"); // 등록자시퀀스
		String erpEmpSeq         = (String)data.get("empCd"); // ERP 사용자 시퀀스
		String erpCompSeq        = (String)data.get("coCd"); // ERP 회사 시퀀스
		String erpBizSeq         = (String)data.get("divCd"); // ERP 사업장 시퀀스
		String erpDeptSeq        = (String)data.get("deptCd"); // ERP 부서 시퀀스
		String workStatus        = (String)data.get("workStatus");                                      
		String loginIdType		 = (String)data.get("loginIdType");
		String loginId			 = (String)data.get("loginId");
		String statusCode          = (String)data.get("emplFg"); //고용형태(정규직,계약직)
		String emailAddr           = getStr(data, "emalAdd"); //이메일아이디
		
		useYn = useYn != null && useYn.equals("1") ? "Y" : "N";
		
		Map<String,Object> map = new HashMap<>();
		
		
		if(params.get("erpIuPositionSet").equals("cdDutyStep")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); 
		}else if(params.get("erpIuPositionSet").equals("cdDutyResp")) {
			positionCode = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); 
		}
		
		if(params.get("erpIuDutySet").equals("cdDutyStep")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("hclsCd"); 
		}else if(params.get("erpIuDutySet").equals("cdDutyResp")) {
			dutyCode = (String)params.get("compSeq") + "_" + (String)data.get("hrspCd"); 
		}
		
		
		//일용직의 경우 직급/직책값 임시직급/직책으로 셋팅
		if(statusCode.equals("002")) {
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
		String addr       = (String)data.get("rsrgAdd"); // 우편주소
		String detailAddr = (String)data.get("rsrdAdd"); // 상세주소
		String useYn      = (String)data.get("usrYn");         // 사용여부
		String editorSeq  = (String)params.get("editorSeq");   // 등록자시퀀스
		
		useYn = useYn != null && useYn.equals("1") ? "Y" : "N";
		
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
		String erpEmpSeq  = (String)data.get("empCd"); //ERP 사원 시퀀스
		String erpCompSeq = (String)data.get("coCd"); //ERP 회사 시퀀스
		String erpBizSeq  = (String)data.get("divCd"); //ERP 사업장 시퀀스
		String erpDeptSeq = (String)data.get("deptCd"); //ERP 부서 시퀀스
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
		String dpSeq      = (String) (String) params.get("compSeq") + "_" + data.get("cdSysdef"); // 직책직급 시퀀스
		String groupSeq   = (String) params.get("groupSeq"); // 그룹 시퀀
		String compSeq    = (String) params.get("compSeq"); // 회사 시퀀스
		String dpType     = (String) data.get("dpType"); // DUTY : 직책, POSITION : 직급
		String useYn      = (String) data.get("useYN"); // 사용여부(Y,N)
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
		String dpSeq       = (String) params.get("compSeq") + "_" + (String)data.get("cdSysdef"); // 직급직책 시퀀스
		String langCode    = (String)params.get("langCode"); // 다국어 코드
		String groupSeq    = (String)params.get("groupSeq"); // 그룹 시퀀스
		String compSeq     = (String)params.get("compSeq"); // 회사 시퀀스
		String dpType      = (String)data.get("dpType"); // DUTY:직책, POSITION:직급
		String dpName      = (String)data.get("nmSysdef"); // 직급명, 직책명
		String descText    = null; // 설명
		String commentText = null; // 비고
		String useYn       = (String) data.get("useYN"); // 사용여부
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
	public Map<String, Object> getComp(Map<String, Object> map, Map<String, Object> params) {
		return null;
	}

	@Override
	public Map<String, Object> getCompMulti(Map<String, Object> map, Map<String, Object> params) {
		return null;
	}

}
