package api.mail.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import cloud.CloudConnetInfo;
import api.common.model.APIResponse;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.systemx.emp.service.EmpManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.systemx.orgAdapter.service.OrgAdapterService;

@Service("ApiMailService")
public class ApiMailServiceImpl implements ApiMailService{
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name = "loginService")
    private EgovLoginService loginService;	
	
	@Resource(name="EmpManageService")
    private EmpManageService empManageService;
	
	@Resource(name="OrgAdapterService")
	OrgAdapterService orgAdapterService;	
	
	@Override
	public APIResponse UpdateDomain(Map<String, Object> paramMap) {
		
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			@SuppressWarnings("unchecked")
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			param.put("compSeq", body.get("compSeq"));
			param.put("emailDomain", body.get("emailDomain"));
			param.put("compEmailYn", body.get("compEmailYn"));
			param.put("groupSeq", body.get("groupSeq"));

			
			//메일도메인 변경
			int result = commonSql.update("CompManage.updateEmailDomail", param);
			if(result > 0){
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				response.setResult("");
			}
			else{
				response.setResultCode("UC0000");
				response.setResultMessage(BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다"));
				response.setResult("");
			}
		}catch(Exception e) {
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
			
		return response;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse passwordChange(Map<String, Object> paramMap, HttpServletRequest request) {
		
		/* 변수 선언 */
		APIResponse response = new APIResponse();
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
		boolean passwdSave = false;
		
	
		try {
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
			LoginVO loginVO = new LoginVO();

			/* 기존 비밀번호 체크 */
			String oPWD = new String(org.apache.commons.codec.binary.Base64.decodeBase64(body.get("oPWD").toString().getBytes("UTF-8")), "UTF-8");
			String nPWD = new String(org.apache.commons.codec.binary.Base64.decodeBase64(body.get("nPWD").toString().getBytes("UTF-8")), "UTF-8");

			Map<String, Object> emailInfo = new HashMap<String, Object>();
			if(body.get("empSeq") != null){
				emailInfo.put("empSeq", body.get("empSeq").toString());
			}else if(body.get("loginId") != null){
				emailInfo.put("loginId", body.get("loginId").toString());
			}else if(body.get("emailAddr") != null){
				emailInfo.put("emailAddr", body.get("emailAddr").toString());	
			}
			String loginId0 = loginService.selectMailIdToLoginId(emailInfo);			
			
	        loginVO.setPassword(oPWD);
	        loginVO.setGroupSeq(header.get("groupSeq").toString());
	        loginVO.setId(loginId0);
	        loginVO.setUserSe("USER");

	        // 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
	    	LoginVO resultVO = loginService.actionLogin(loginVO, request);
	    	
	    	// 비밀번호 일치
	    	if(resultVO.getId() != null){
				/* 옵션 확인 */
	    		Map<String, Object> mp = new HashMap<String, Object>();
	    		mp.put("option", "cm20");
	    		mp.put("groupSeq", header.get("groupSeq"));
	    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
	    		String langCode = resultVO.getLangCode();
				
	    		// 메일 싱크를 위한 정보
		    	Map<String, Object> mailParam = new HashMap<String, Object>();
		    	mailParam.put("compSeq", resultVO.getOrganId());
		    	mailParam.put("groupSeq", header.get("groupSeq"));
				
				Map<String, Object> mailInfo = (Map<String, Object>) commonSql.select("EmpManage.getMailInfo", mailParam);
	    		
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
	    					
	    					if(nPWD.length() < Integer.parseInt(min) || nPWD.length() > Integer.parseInt(max)) {
	    						
	    						inputDigitResult = BizboxAMessage.getMessage("TX000010842","최소") + min + BizboxAMessage.getMessage("TX000022609"," 자리 이상 ") + max + BizboxAMessage.getMessage("TX000022610"," 자리 이하로 입력해 주세요.");
	    					}
    					}
    				}
    				
	    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
	    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
	    				if(inputRuleValue.indexOf("0") > -1) {
	    					regExpression = ".*[A-Z]+.*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)", langCode) + ",";
	    					}
	    				} 
	    				
	    				if(inputRuleValue.indexOf("1") > -1) {
    						regExpression = ".*[a-z]+.*";
	    					
    						p = Pattern.compile(regExpression);
    						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("2") > -1) {
    						regExpression = ".*[0-9]+.*";
	    					
    						p = Pattern.compile(regExpression);
    						
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자", langCode) + ",";
	    					}
	    				}
	    				
	    				if(inputRuleValue.indexOf("3") > -1) {
	    					regExpression = ".*[^가-힣a-zA-Z0-9].*";
	    					
	    					p = Pattern.compile(regExpression);
	    					
	    					regExpressionFlag = fnRegExpression(p, nPWD);
	    					
	    					if(!regExpressionFlag) {
	    						inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자", langCode) + ",";
	    					}
	    				}
	    			}
	    			
	    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {			// 입력제한 값 미사용

	    				inputLimitValue = "|" + inputLimitValue + "|";
	    				
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				
	    				params.put("empSeq", body.get("empSeq").toString());
	    				params.put("groupSeq", header.get("groupSeq").toString());
	    				params.put("langCode", langCode);
	    				params.put("compSeq", resultVO.getOrganId());
	    				
	    				/* 사용자 정보 가져오기 */
	    	    		// 사원 정보 (비밀번호 변경 옵션 값에 필요)
	    	    		Map<String, Object> infoMap = empManageService.selectEmpInfo(params, new PaginationInfo());
	    	    		List<Map<String,Object>> list = (List<Map<String, Object>>) infoMap.get("list");
	    	    		Map<String,Object> map = list.get(0);
	    				
	    	    		// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
    					if(inputLimitValue.indexOf("|0|") > -1) {
	    					String loginId = map.get("loginId").toString();
	    					
	    					if(nPWD.indexOf(loginId) > -1) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디", langCode) + ",";
	    					}
	    				}
    					
    					if(inputLimitValue.indexOf("|1|") > -1) {
    						String erpNum = map.get("erpEmpNum") != null ? map.get("erpEmpNum").toString() : "";
	    					
    						
	    					if(nPWD.indexOf(erpNum) > -1 && !erpNum.equals("")) {
	    						inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번", langCode) + ",";
	    					}
	    				}
    					
    					if(inputLimitValue.indexOf("|2|") > -1) {
    						String phoneNum = map.get("mobileTelNum") != null ? map.get("mobileTelNum").toString().replaceAll("-", "") : "";
	    					
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
									if(nPWD.indexOf(middleNum) > -1 || nPWD.indexOf(endNum) > -1) {
										inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화", langCode) + ",";
									}
								}    							
    						}
    						
	    					
	    				} 
    					
    					if(inputLimitValue.indexOf("|3|") > -1) {
    						String birthDay = map.get("bday") != null ? map.get("bday").toString() : "0000-00-00";
	    					
    						if(!birthDay.equals("0000-00-00")) {
    							String[] yearMonthDay = birthDay.split("-");
    							String year = yearMonthDay[0];
    							String monthDay = yearMonthDay[1] + yearMonthDay[2];
    							String residentReg = year.substring(2,4) + monthDay;
    							
    							if(nPWD.indexOf(year) > -1 || nPWD.indexOf(monthDay) > -1 || nPWD.indexOf(residentReg) > -1) {
    								inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일", langCode) + ",";
    							}
    						}
	    				}
    					
	    	    		if(inputLimitValue.indexOf("|4|") > -1) {
	    					int samePass1 = 1; //연속성(+) 카운드
		 				    int samePass2 = 1; //반복성(+) 카운드
		 				    int blockCnt = 3;
		 				    
		 				    if(inputLimitValue.indexOf("|4_4|") > -1) {
		 				    	blockCnt = 4;
		 				    }else if(inputLimitValue.indexOf("|4_5|") > -1) {
		 				    	blockCnt = 5;
		 				    }		 				    
		 				    
		 				    for(int j=1; j < nPWD.length(); j++){
		 				    	
		 				    	int tempA = (int) nPWD.charAt(j-1);
		 				    	int tempB = (int) nPWD.charAt(j);		 				    	
		 				    	
		 				    	if(tempA - (tempB-1) == 0 ) {
		 				    		samePass1++;
		 				    	}else{
		 				    		samePass1 = 1;
		 				    	}
		 				    	
		 				    	if(tempA - tempB == 0) {
		 				    		samePass2++;
		 				    	}else{
		 				    		samePass2 = 1;
		 				    	}
		 				    	
		 				    	if(samePass1 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리 ") + BizboxAMessage.getMessage("TX000022602","연속문자") + ",";
		 				    		break;
		 				    	}
		 				    	
		 				    	if(samePass2 >= blockCnt) {
		 				    		inputLimitResult += blockCnt + BizboxAMessage.getMessage("TX000005067","자리 ") + BizboxAMessage.getMessage("TX000022603","반복문자") + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}
	    	    		
	    	    		if(inputLimitValue.indexOf("|5|") > -1) {
	    	    			if(map.get("prevLoginPasswd").equals(CommonUtil.passwordEncrypt(nPWD))){
	    	    				inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호") + ",";	
	    	    			}
	    				}	    	    		
	    	    		
	    	    		if(inputLimitValue.indexOf("|6|") > -1 && nPWD.length() > 1) {
	    	    			
	    	    			int samePass1 = 1; //연속성(+) 카운드
	    	    			int samePass2 = 1; //연속성(-) 카운드
		 				    int blockCnt = 3;
		 				    String keyArray = "`1234567890-=!@#$%^&*()_+qwertyuiopasdfghjkl;'zxcvbnm,./";
		 				    String newPasswdLow = nPWD.toLowerCase();
		 				    
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
		 				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열") + ",";
		 				    		break;
		 				    	}
		 				    }
	    				}	    	    		
	    			}
	    			
	    			if(!inputBlockTextValue.equals("")){
	    				
	    				inputBlockTextValue = "|" + inputBlockTextValue + "|";
	    				
	    				if(inputBlockTextValue.indexOf("|" + nPWD + "|") != -1){
	    					inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어") + ",";
	    				}
	    			}	    			
	    			
	    			String result = inputDigitResult + inputRuleResult + inputLimitResult;
	    			
	    			if(result.length() == 0) {
	    				passwdSave = true;
	    			} else {
	    				passwdSave = false;
	    			}
	    			
	    			if(passwdSave) {
	    				
	    				Map<String, Object> adapterParam = new HashMap<String,Object>();
	    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
	    				adapterParam.put("callType", "updatePasswd");
	    				adapterParam.put("empSeq", resultVO.getUniqId());
	    				adapterParam.put("compSeq", resultVO.getCompSeq());
	    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
	    				adapterParam.put("createSeq", resultVO.getUniqId());
	    				adapterParam.put("loginPasswdNew", nPWD);	
	    					
	    				orgAdapterService.empSaveAdapter(adapterParam);
	    				
	    				response.setResult("0");
						response.setResultCode("SUCCESS");
						response.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다."));	    				
	    				
		    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
		    				Map<String, Object> params = new HashMap<String, Object>();
		    				params.put("groupSeq", loginVO.getGroupSeq());
		    				orgAdapterService.mailUserSync(params);
		    			}

	    			} else {
	    				response.setResult("1");
		    			response.setResultCode("PW001");
		    			response.setResultMessage(result.substring(0, result.length()-1));
	    			}
	    			
	    		} else if(passwdOptionUseYN.equals("N")) {
	    			
    				Map<String, Object> adapterParam = new HashMap<String,Object>();
    				adapterParam.put("groupSeq", resultVO.getGroupSeq());
    				adapterParam.put("callType", "updatePasswd");
    				adapterParam.put("empSeq", resultVO.getUniqId());
    				adapterParam.put("compSeq", resultVO.getCompSeq());
    				adapterParam.put("deptSeq", resultVO.getOrgnztId());
    				adapterParam.put("createSeq", resultVO.getUniqId());
    				adapterParam.put("loginPasswdNew", nPWD);	
    					
    				orgAdapterService.empSaveAdapter(adapterParam);
	    			
	    			if(mailInfo.get("compEmailYn") != null && mailInfo.get("compEmailYn").equals("Y")){
	    				Map<String, Object> params = new HashMap<String, Object>();
	    				params.put("groupSeq", loginVO.getGroupSeq());
	    				orgAdapterService.mailUserSync(params);
	    			}
	    			
	    			response.setResult("0");
					response.setResultCode("SUCCESS");
					response.setResultMessage(BizboxAMessage.getMessage("TX000014067","비밀번호 변경을 성공했습니다."));
	    		}
	    		
			} else {		// 비밀번호 불일치
				response.setResult("1");
				response.setResultCode("PW000");
				response.setResultMessage(BizboxAMessage.getMessage("TX000002605","비밀번호가 일치하지 않습니다."));
			}
	    	
	    	
	    	
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
			
		return response;
	}
	
	@SuppressWarnings("unchecked")
	public APIResponse passwordChangeCheck(Map<String, Object> paramMap, HttpServletRequest request) {
		
		/* 변수 선언 */
		APIResponse response = new APIResponse();
		Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
		Map<String, Object> header = (Map<String, Object>)paramMap.get("header");
		
		
		LoginVO loginVO = new LoginVO();

		
		/* 옵션정보 */
		try {
			/* 기존 비밀번호 체크 */
			String oPWD = new String(org.apache.commons.codec.binary.Base64.decodeBase64(body.get("pwd").toString().getBytes("UTF-8")), "UTF-8");
			Map<String, Object> emailInfo = new HashMap<String, Object>();
			emailInfo.put("groupSeq", header.get("groupSeq"));
			
			if(body.get("empSeq") != null){
				emailInfo.put("empSeq", body.get("empSeq").toString());
			}else if(body.get("loginId") != null){
				emailInfo.put("loginId", body.get("loginId").toString());
			}else if(body.get("emailAddr") != null){
				emailInfo.put("emailAddr", body.get("emailAddr").toString());	
			}
			String loginId = loginService.selectMailIdToLoginId(emailInfo);

	        loginVO.setPassword(oPWD);
	        loginVO.setGroupSeq(header.get("groupSeq").toString());
	        loginVO.setId(loginId);
	        loginVO.setUserSe("USER");
			
			 // 아이디와 암호화된 비밀번호가 DB와 일치하는지 확인한다.
	    	LoginVO resultVO = loginService.actionLogin(loginVO, request);
			
			Map<String, Object> result = new HashMap<String, Object>();

			String passwdOptionUseYN = "";
			String inputDigitValue = "";
			String inputRuleValue = "";
			String inputLimitValue = "";
			String inputBlockTextValue = "";
			//String inputDueOptionValue = "";
			//String inputAlertValue = "";
			String inputDueValue = "";
			
			/* 결과 오류 변수 선언 */
			String inputDigitResult = "";
			String inputRuleResult = "";
			String inputLimitResult = "";
			String inputDueValueResult = "";

			result.put("passwdStatusCode", resultVO.getPasswdStatusCode());
			result.put("passwdChangeDate", resultVO.getPasswdChangeDate());
			
	    	/* 비밀번호 옵션 체크 */
	    	/* 옵션 확인 */
	    	try{
	    		Map<String, Object> mp = new HashMap<String, Object>();
	    		mp.put("option", "cm20");
	    		mp.put("groupSeq", header.get("groupSeq"));
	    		List<Map<String, Object>> loginOptionValue = commonOptionManageService.getLoginOptionValue(mp);
	    		
	    		
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
	    			
	    			// 비밀번호 만료 일자
	    			if(temp.get("optionId").equals("cm201")) {
	    				inputDueValue = temp.get("optionRealValue").toString();
	    				
        				if(inputDueValue.split("▦").length > 1) {
        					//inputDueOptionValue = inputDueValue.split("▦")[0];
        					inputDueValue = inputDueValue.split("▦")[1];
        				}	    				
	    				
	    				//안내기간, 만료기간 고도화 처리 (수정예정)
	    				String[] cm201Val = inputDueValue.split("\\|");
	    				if(cm201Val.length > 1){
	    					//inputAlertValue  = cm201Val[0];
	    					inputDueValue = cm201Val[1];
	    				}else {
	    					inputDueValue = cm201Val[0];
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
							
							String minStr = BizboxAMessage.getMessage("TX000010842","최소");
							String maxStr = BizboxAMessage.getMessage("TX000002618","최대");
							inputDigitResult = minStr + " " + min + " / " + maxStr + " " + max;
						}
					}
	    			
	    			if(!inputRuleValue.equals("999") && !inputRuleValue.equals("")) {
	    				
	    				// 0:영문(대문자), 1:영문(소문자), 2:숫자, 3:특수문자
	    				if(inputRuleValue.indexOf("0") > -1) {
							inputRuleResult += BizboxAMessage.getMessage("TX000016171","영문(대문자)") + ",";
	    				} 
	    				
	    				if(inputRuleValue.indexOf("1") > -1) {
							inputRuleResult += BizboxAMessage.getMessage("TX000016170","영문(소문자)") + ",";
	    				}
	    				
	    				if(inputRuleValue.indexOf("2") > -1) {
							inputRuleResult += BizboxAMessage.getMessage("TX000008448","숫자") + ",";
	    				}
	    				
	    				if(inputRuleValue.indexOf("3") > -1) {
							inputRuleResult += BizboxAMessage.getMessage("TX000006041","특수문자") + ",";
	    				}	    				
	    				
	    			}
	    			
	    			if(!inputDueValue.equals("0")) {
	    				inputDueValueResult = inputDueValue + BizboxAMessage.getMessage("TX000000437","일");
	    				
	    				Date today = new Date();
			    		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    		String compareToday = transFormat.format(today);
			    		String passChangeDate = resultVO.getPasswdChangeDate();

			    		Date todayDate = transFormat.parse(compareToday);
			    		Date changeDate = transFormat.parse(passChangeDate);
			    		
			    		// 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
			    		long diff = todayDate.getTime() - changeDate.getTime();
			    		long diffDays = diff / (24 * 60 * 60 * 1000);
			    		
			    		if(diffDays >= Long.parseLong(inputDueValue)) {
			    			result.put("passwdStatusCode", "D");
			    		}
	    				
	    			} else {
	    				inputDueValueResult = BizboxAMessage.getMessage("TX000004167","제한없음");
	    			}
	    			
	    			if(!inputLimitValue.equals("999") && !inputLimitValue.equals("")) {
	    				
	    				inputLimitValue = "|" + inputLimitValue + "|";
	    				
	    				// 0:아이디, 1:ERP사번, 2:전화번호, 3:생년월일, 4:연속문자/순차숫자, 5:직전 비밀번호, 6:키보드 일련배열
						if(inputLimitValue.indexOf("|0|") > -1) {
							inputLimitResult += BizboxAMessage.getMessage("TX000000075","아이디") + ",";
	    				}
						
						if(inputLimitValue.indexOf("|1|") > -1) {
							inputLimitResult += BizboxAMessage.getMessage("TX000000106","ERP사번") + ",";
	    				}
						
						if(inputLimitValue.indexOf("|2|") > -1) {
							inputLimitResult += BizboxAMessage.getMessage("TX000000654","휴대전화") + ",";
	    				} 
						
						if(inputLimitValue.indexOf("|3|") > -1) {
							inputLimitResult += BizboxAMessage.getMessage("TX000000083","생년월일") + ",";
	    				}
						
						if(inputLimitValue.indexOf("|4|") > -1) {
							String termLength = "";
							
							if(inputLimitValue.indexOf("|4_3|") > -1) {
								termLength = BizboxAMessage.getMessage("TX000016780","3자리");
							}else if(inputLimitValue.indexOf("|4_4|") > -1) {
								termLength = BizboxAMessage.getMessage("TX000016782","4자리");
							}else if(inputLimitValue.indexOf("|4_5|") > -1) {
								termLength = BizboxAMessage.getMessage("TX000016784","5자리");
							}
							
				    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022602","연속문자") + ",";
				    		inputLimitResult += termLength + BizboxAMessage.getMessage("TX000022603","반복문자") + ",";
	    				}
						
						if(inputLimitValue.indexOf("|5|") > -1) {
				    		inputLimitResult += BizboxAMessage.getMessage("TX000022604","직전 비밀번호") + ",";
	    				}
						
						if(inputLimitValue.indexOf("|6|") > -1) {
				    		inputLimitResult += BizboxAMessage.getMessage("TX000022605","키보드 일련배열") + ",";
	    				}						
	    				
	    			}
	    			
	    			if(!inputBlockTextValue.equals("")){
	    				inputLimitResult += BizboxAMessage.getMessage("TX000022606","추측하기 쉬운단어") + ",";
	    			}
	    			
	    			result.put("useOption" , "Y");
	    			
	    		} else if(passwdOptionUseYN.equals("N")) {
	    			
		    		result.put("useOption" , "N");
	    		}
	    	} catch(Exception e) {
	    		CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
	    	}
	    	
	    	result.put("inputDigitResult", inputDigitResult);
	    	
	    	if(inputRuleResult.length() > 0) {
	    		result.put("inputRuleResult", inputRuleResult.substring(0, inputRuleResult.length() -1));
	    	} else {
	    		result.put("inputRuleResult", "");
	    	}
	    	
	    	if(inputLimitResult.length() > 0) {
	    		result.put("inputLimitResult", inputLimitResult.substring(0, inputLimitResult.length() -1));
	    	} else {
	    		result.put("inputLimitResult", "");
	    	}
	    	
	    	result.put("inputDueValueResult", inputDueValueResult);
	    	
	    	response.setResultCode("0");		// 성공
	    	response.setResultMessage("success");
	    	response.setResult(result);

			
			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			response.setResultCode("-1");		// 오류
			response.setResultMessage("fail");
		}
		
		
		return response;
	}

	/* 
	 * 정규식 확인 메서드
	 * 
	 * */
	
	public boolean fnRegExpression(Pattern regExpression, String modPass) {
		Matcher match = regExpression.matcher(modPass);
		
		boolean result = match.find();
		
		return result;
	}
	
	/* 핸드폰 번호 정규화 */
	public static String phoneFormat(String phoneNo){
		  
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
	
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse getManualUrl() {
		Map<String, Object> param = new HashMap<String, Object>();
		APIResponse response = new APIResponse();
		
		try {
			String buildType = CloudConnetInfo.getBuildType();			
			if(buildType.equals("cloud")){
				//클라우드일 경우 URL 고정값으로 리턴.
				response.setResult("http://manual.bizboxa.com");			
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
				return response;
			}
			
			//그룹정보 가져오기(메뉴얼도메인 포함)
			Map<String, Object> groupInfo = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", param);
			
			if(groupInfo == null){
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("TX800000020","그룹정보를 찾을 수 없습니다."));
			}else{			
				response.setResult(EgovStringUtil.nullConvert(groupInfo.get("manualUrl")+""));			
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}
			
		}catch(Exception e) {
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
			
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse getGwVolume(Map<String, Object> paramMap) {		
		APIResponse response = new APIResponse();
				
		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");			
			Map<String, Object> gwVolumeInfo = (Map<String, Object>) commonSql.select("GroupManage.getGwVolumeInfo", body);
			
			if(gwVolumeInfo == null){
				response.setResultCode("UC0001");
				response.setResultMessage(BizboxAMessage.getMessage("","그룹정보를 찾을 수 없습니다."));
			}else{			
				response.setResult(gwVolumeInfo);			
				response.setResultCode("SUCCESS");
				response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
			}
		}catch(Exception e){
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse setGwVolumeFromMail(Map<String, Object> paramMap) {
		APIResponse response = new APIResponse();

		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");	
			
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", body.get("groupSeq"));			
			para.put("idx", (String) commonSql.select("apiMainDAO.getGwVolumeIdx", para));
			
			para.put("gwVolume", body.get("gwVolume"));
			para.put("mailVolume", body.get("mailVolume"));
			para.put("target", "MAIL");
			
			//계약용량 이력테이블 insert
			commonSql.insert("apiMainDAO.insertGwVolumeHistory", para);
			
			//계약용량 update
			commonSql.update("apiMainDAO.updateGwVolume", para);
			
			response.setResultCode("SUCCESS");
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));

		}catch(Exception e){
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse getDownloadType(Map<String, Object> paramMap) {
		
		APIResponse response = new APIResponse();
		
		//메일모듈 다운로드 뷰어옵션값 조회
		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");
			
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", body.get("groupSeq"));
			
			Map<String, Object> resultMap = (Map<String, Object>) commonSql.select("apiMainDAO.getDownloadType", para);
			
			response.setResultCode("SUCCESS");
			response.setResult(resultMap);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));
		}
		catch(Exception e){
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		return response;
	}

	@SuppressWarnings("unchecked")
	@Override
	public APIResponse getGwGroupInfo(Map<String, Object> paramMap) {
		
		org.apache.log4j.Logger.getLogger( ApiMailServiceImpl.class ).debug( "ApiMailServiceImpl.getGwTitle paramMap : " + paramMap );
		
		APIResponse response = new APIResponse();

		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");	
			
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", body.get("groupSeq"));			
			
			//그룹웨어 타이틀 정보 가져오기
			Map<String, Object> result = (Map<String, Object>) commonSql.select("GroupManage.getGroupInfo", para);
			
			response.setResultCode("SUCCESS");
			response.setResult(result);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));

		}catch(Exception e){
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;
		
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public APIResponse getGwDomain(Map<String, Object> paramMap) {
		
		org.apache.log4j.Logger.getLogger( ApiMailServiceImpl.class ).debug( "ApiMailServiceImpl.getGwDomain paramMap : " + paramMap );
		
		APIResponse response = new APIResponse();

		try{
			Map<String, Object> body = (Map<String, Object>)paramMap.get("body");	
			
			if(body.get("groupSeq") == null || body.get("groupSeq").toString().equals("")) {
				response.setResultCode("ERR001");
				response.setResult(null);
				response.setResultMessage(BizboxAMessage.getMessage("TX000021600","필수 파라미터가 누락되었습니다.") + "(groupSeq)");
				
				return response;
			}else if(body.get("emailDomain") == null || body.get("emailDomain").toString().equals("")) {
				response.setResultCode("ERR002");
				response.setResult(null);
				response.setResultMessage(BizboxAMessage.getMessage("TX000021600","필수 파라미터가 누락되었습니다.") + "(emailDomain)");
				
				return response;
			}
			
			
			Map<String, Object> para = new HashMap<String, Object>();
			para.put("groupSeq", body.get("groupSeq"));		
			para.put("emailDomain", body.get("emailDomain"));	
			
			//그룹웨어 도메인정보 가져오기
			String emailDomain = (String) commonSql.select("CompManage.getGwDomain", para);
			
			Map<String, Object> result = new HashMap<String, Object>();
			result.put("gwDomain", emailDomain == null ? "" : emailDomain);
			
			response.setResultCode("SUCCESS");
			response.setResult(result);
			response.setResultMessage(BizboxAMessage.getMessage("TX000011955","성공하였습니다"));

		}catch(Exception e){
			response.setResultCode("CO0000");
			response.setResultMessage(BizboxAMessage.getMessage("TX000016542","API 요청 처리중 문제가 발생하였습니다."));	
		}
		
		return response;
		
	}
}
