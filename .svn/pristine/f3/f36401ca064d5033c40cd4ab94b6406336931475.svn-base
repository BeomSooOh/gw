package restful.mobile.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import main.web.BizboxAMessage;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import restful.com.service.AttachFileService;
import restful.mobile.dao.RestfulDAO;
import restful.mobile.service.RestfulService;
import restful.mobile.vo.RestfulVO;


@Service("RestfulService")
public class RestfulServiceImpl implements RestfulService{
	
	@Resource(name = "RestfulDAO")
	RestfulDAO restfulDAO = new RestfulDAO();
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;

	@Override
	public List<RestfulVO> actionLoginMobile(RestfulVO param) {
		List<RestfulVO> list = null;
		try {
			list = restfulDAO.actionLoginMobile(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return list;
	}

	public List<Map<String,Object>> selectLoginVO(RestfulVO param) {
		List<Map<String,Object>> list = null;
		try {
			list = restfulDAO.selectLoginVO(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return list;
	}	
	
    public String selectLoginPassword(RestfulVO param) throws Exception {
    	return restfulDAO.selectLoginPassword(param);
    }

	@Override
	public List<Map<String, Object>> selectOrgImgList(Map<String,Object> vo) {
		return restfulDAO.selectOrgImgList(vo);
	}	
	
	public List<Map<String, Object>> selectOptionListMobile(Map<String, Object> param) {
		List<Map<String, Object>> optionList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> usageOptionList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		param.put("osType", NeosConstants.SERVER_OS);
		param.put("optionLevel", "1");
		param.put("optionGubun", "app");
		
		usageOptionList = restfulDAO.selectUsageOptionListMobile(param);
		optionList = restfulDAO.selectOptionListMobile(param);
		
		// 기본 옵션에서 쪽지, 대화 용량 설정 값 가져오기
		for(Map<String, Object> temp : optionList) {
			Map<String, Object> usage = new HashMap<String, Object>();
			
			// 쪽지 옵션 사용 여부 확인
			if(temp.get("optionId").equals("app200")) {
				if(temp.get("optionValue").equals("1")) {
					// 자식 옵션 호출
					List<Map<String, Object>> childOptions = new ArrayList<Map<String, Object>>();
					param.put("optionLevel", "2");
					param.put("parentId", "app200");
					param.put("optionGubun", "app");
					childOptions = restfulDAO.selectOptionListMobile(param);
					
					for(Map<String, Object> option : childOptions) {
						
						if(option.get("optionId").equals("app201")) {
							usage.put("totalCapac", option.get("optionValue"));
						}
						if(option.get("optionId").equals("app202")) {
							usage.put("limitFileCount", option.get("optionValue"));
						}
						if(option.get("optionId").equals("app203")) {
							usage.put("availCapac", option.get("optionValue"));
						}
					}
					usage.put("groupSeq", param.get("groupSeq"));
					usage.put("pathSeq", "810");
					
					usageOptionList.add(usage);
				}
			}
			
			// 대화 옵션 사용 여부 확인
			if(temp.get("optionId").equals("app300")) {
				if(temp.get("optionValue").equals("1")) {
					// 자식 옵션 호출
					List<Map<String, Object>> childOptions = new ArrayList<Map<String, Object>>();
					param.put("optionLevel", "2");
					param.put("parentId", "app300");
					param.put("optionGubun", "app");
					childOptions = restfulDAO.selectOptionListMobile(param);
					
					for(Map<String, Object> option : childOptions) {
						
						if(option.get("optionId").equals("app301")) {
							usage.put("totalCapac", option.get("optionValue"));
						}
					}
					usage.put("availCapac", "0");
					usage.put("limitFileCount", "0");
					usage.put("groupSeq", param.get("groupSeq"));
					usage.put("pathSeq", "800");
					
					usageOptionList.add(usage);
				}
			}
	
			// 첨부파일 다운로드/뷰어
			if(temp.get("optionId").equals("app600")) {
				
				List<Map<String, Object>> childOptions = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> downViewOptionList = new ArrayList<Map<String, Object>>();
				
				// 자식 옵션 호출
				param.put("optionLevel", "2");
				param.put("parentId", "app600");
				param.put("optionGubun", "app");
				childOptions = restfulDAO.selectOptionListMobile(param);
				
				for(Map<String, Object> option : childOptions) {
					String optionValue = option.get("optionValue").toString();
					Map<String, Object> multiOption = new HashMap<String, Object>();
					
					// 옵션 사용
					if(temp.get("optionValue").equals("1")) {
						
						if(optionValue.equals("999")){			// 미선택
							multiOption.put("docViewer", "0");
							multiOption.put("fileDown", "0");
						} else if(optionValue.equals("0|") || optionValue.equals("0")) {	// 문서뷰어
							multiOption.put("docViewer", "1");
							multiOption.put("fileDown", "0");
						} else if(optionValue.equals("1|") || optionValue.equals("1")) {	// 파일다운
							multiOption.put("docViewer", "0");
							multiOption.put("fileDown", "1");
						} else if(optionValue.equals("1|0|") || optionValue.equals("0|1|")) {	// 문서뷰어, 파일다운
							multiOption.put("docViewer", "1");
							multiOption.put("fileDown", "1");
						}						
						
					}else {
						multiOption.put("docViewer", "0");
						multiOption.put("fileDown", "0");						
					}
					
					if(option.get("optionId").equals("appPathSeq300")) {			// 업무관리
						multiOption.put("moduleCode", "300");
					} else if(option.get("optionId").equals("appPathSeq400")) {	// 일정
						multiOption.put("moduleCode", "400");
						// 임시 (노트/업무보고) 분리 시 삭제
						Map<String, Object> note = new HashMap<String, Object>();
						note.put("moduleCode", "1000");
						note.put("docViewer", multiOption.get("docViewer"));
						note.put("fileDown", multiOption.get("fileDown"));
						downViewOptionList.add(note);

					} else if(option.get("optionId").equals("appPathSeq500")) {	// 게시판
						multiOption.put("moduleCode", "500");
					} else if(option.get("optionId").equals("appPathSeq600")) {	// 문서
						multiOption.put("moduleCode", "600");
					} else if(option.get("optionId").equals("appPathSeq700")) {	// 메일		
						multiOption.put("moduleCode", "700");
					} else if(option.get("optionId").equals("appPathSeq800")) {	// 대화방
						multiOption.put("moduleCode", "800");
					} else if(option.get("optionId").equals("appPathSeq810")) {	// 쪽지
						multiOption.put("moduleCode", "810");
					} else if(option.get("optionId").equals("appPathSeqEa")) {		// 전자결재
						if(param.get("eaType").equals("ea")) {
							multiOption.put("moduleCode", "200");
						} else {
							multiOption.put("moduleCode", "100");
						}
					} else if(option.get("optionId").equals("appPathSeq1200")) {	// 팩스 (예외사용)
						multiOption.put("moduleCode", "1200");
					} else if(option.get("optionId").equals("appPathSeq1300")) {		// 업무보고
						multiOption.put("moduleCode", "1300");
					}
					
					downViewOptionList.add(multiOption);
					
				}
				
				temp.put("optionValue", downViewOptionList);
			}
			
			// 대화 옵션 사용 여부 확인
			if(temp.get("optionId").equals("app300")) {
				if(temp.get("optionValue").equals("1")) {
					// 자식 옵션 호출
					List<Map<String, Object>> childOptions = new ArrayList<Map<String, Object>>();
					param.put("optionLevel", "2");
					param.put("parentId", "app300");
					param.put("optionGubun", "app");
					childOptions = restfulDAO.selectOptionListMobile(param);
					
					for(Map<String, Object> option : childOptions) {
						
						if(option.get("optionId").equals("app301")) {
							usage.put("totalCapac", option.get("optionValue"));
						}
					}
					usage.put("availCapac", "0");
					usage.put("limitFileCount", "0");
					usage.put("groupSeq", param.get("groupSeq"));
					usage.put("pathSeq", "800");
					
					usageOptionList.add(usage);
				}
			}
	
			// 첨부파일 다운로드/뷰어
			if(temp.get("optionId").equals("app610")) {
				
				List<Map<String, Object>> childOptions = new ArrayList<Map<String, Object>>();
				List<Map<String, Object>> extOptionList = new ArrayList<Map<String, Object>>();
				
				// 자식 옵션 호출
				param.put("optionLevel", "2");
				param.put("parentId", "app610");
				param.put("optionGubun", "app");
				childOptions = restfulDAO.selectOptionListMobile(param);
				
				String extOptionValue = "limit▦";
				
				//전체적용 설정일 경우 설정값 가져오기 
				if(temp.get("optionValue").equals("1")) {
					
					for(Map<String, Object> option : childOptions) {
						
						if(option.get("optionId").equals("app611")) {
							extOptionValue = option.get("optionValue").toString();
							break;
						}
					}
				}

				for(Map<String, Object> option : childOptions) {
					
					Map<String, Object> multiOption = new HashMap<String, Object>();
					
					//선택적용 설정일 경우 설정값 가져오기 
					if(temp.get("optionValue").equals("2")) {
						extOptionValue = option.get("optionValue").toString();
					}
					
					String[] extOptionValueArray = extOptionValue.split("▦",-1);
					
					if(extOptionValueArray.length > 1) {
						multiOption.put("type", extOptionValueArray[0]);
						multiOption.put("extStr", extOptionValueArray[1]);						
					}else {
						multiOption.put("type", "limit");
						multiOption.put("extStr", "");							
					}
					
					if(option.get("optionId").equals("app614")) {			// 업무관리
						multiOption.put("moduleCode", "300");
					} else if(option.get("optionId").equals("app615")) {	// 일정
						multiOption.put("moduleCode", "400");
						// 임시 (노트/업무보고) 분리 시 삭제
						Map<String, Object> note = new HashMap<String, Object>();
						note.put("moduleCode", "1000");
						note.put("type", multiOption.get("type"));
						note.put("extStr", multiOption.get("extStr"));
						extOptionList.add(note);

					} else if(option.get("optionId").equals("app617")) {	// 게시판
						multiOption.put("moduleCode", "500");
					} else if(option.get("optionId").equals("app618")) {	// 문서
						multiOption.put("moduleCode", "600");
					} else if(option.get("optionId").equals("app613")) {	// 메일		
						multiOption.put("moduleCode", "700");
					} else if(option.get("optionId").equals("app620")) {	// 대화방
						multiOption.put("moduleCode", "800");
					} else if(option.get("optionId").equals("app619")) {	// 쪽지
						multiOption.put("moduleCode", "810");
					} else if(option.get("optionId").equals("app612")) {		// 전자결재
						if(param.get("eaType").equals("ea")) {
							multiOption.put("moduleCode", "200");
						} else {
							multiOption.put("moduleCode", "100");
						}
					} else if(option.get("optionId").equals("app621")) {	// 팩스 (예외사용)
						multiOption.put("moduleCode", "1200");
					} else if(option.get("optionId").equals("app616")) {		// 업무보고
						multiOption.put("moduleCode", "1300");
					}
					
					if(multiOption.get("moduleCode") != null) {
						extOptionList.add(multiOption);	
					}
				}
				
				temp.put("optionValue", extOptionList);
				
			}
			
			// 패스워드 세분화로인한 예외처리(로그인/결재/급여 패스워드 분리)
			if(temp.get("optionId").equals("cm1014")) {
				
				if(temp.get("optionValue").toString().contains("def")) {
					temp.put("optionValue", "1");
				}else {
					temp.put("optionValue", "0");
				}
			}			
			
		}
		
		// 용량 옵션 값 만들기
		/**
		 * [모바일규약] 100:전자결재영리, 200:전자결재비영리, 300:업무관리, 400:일정, 500:게시판, 600:문서, 700:메일, 800:대화, 810:쪽지, 1300:업무보고
		 * */
		Map<String, Object> result = new HashMap<String, Object>();
		for(Map<String, Object> temp : usageOptionList) {
			
			Map<String, Object> usage = new HashMap<String, Object>();
			
			if(temp.get("pathSeq").equals("100") && param.get("eaType").equals("eap")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("200") && param.get("eaType").equals("ea")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("300")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("400")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
				
				// 임시 (노트/업무보고) 분리 시 삭제
				Map<String, Object> note = new HashMap<String, Object>();
				note.put("moduleCode", "1000");
				note.put("totalCapac", usage.get("totalCapac"));
				note.put("availCapac", usage.get("availCapac"));
				note.put("limitFileCount", usage.get("limitFileCount"));
				resultList.add(note);
				
				Map<String, Object> workReport = new HashMap<String, Object>();
				workReport.put("moduleCode", "1300");
				workReport.put("totalCapac", usage.get("totalCapac"));
				workReport.put("availCapac", usage.get("availCapac"));
				workReport.put("limitFileCount", usage.get("limitFileCount"));
				resultList.add(workReport);
				
			} else if(temp.get("pathSeq").equals("500")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("600")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("700")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("800")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", "0");
				usage.put("availCapac", temp.get("totalCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} else if(temp.get("pathSeq").equals("810")) {
				usage.put("moduleCode", temp.get("pathSeq"));
				usage.put("totalCapac", temp.get("totalCapac"));
				usage.put("availCapac", temp.get("availCapac"));
				usage.put("limitFileCount", temp.get("limitFileCount"));
				resultList.add(usage);
			} 
			
			// 임시 삭제 시 사용
//			else if(temp.get("pathSeq").equals("1300")) {
//				usage.put("moduleCode", temp.get("pathSeq"));
//				usage.put("totalCapac", temp.get("totalCapac"));
//				usage.put("availCapac", temp.get("availCapac"));
//				usage.put("limitFileCount", temp.get("limitFileCount"));
//				resultList.add(usage);
//			} else if(temp.get("pathSeq").equals("1000")) {
//				usage.put("moduleCode", temp.get("pathSeq"));
//				usage.put("totalCapac", temp.get("totalCapac"));
//				usage.put("availCapac", temp.get("availCapac"));
//				usage.put("limitFileCount", temp.get("limitFileCount"));
//				resultList.add(usage);
//			}
				
		}
		result.put("optionId", "usage");
		result.put("optionValue", resultList);
		result.put("optionNm", BizboxAMessage.getMessage("TX800000140","업로드 용량(예외옵션)"));
		result.put("optionLevel", "1");
		optionList.add(result);
		
		// 일정모듈 옵션추가
		String schInviteYn = "N";
		String schAcceptYn = "Y";
		
		Map<String, Object> schOption = restfulDAO.selectSchOptionMobile(param);
		
		if(schOption != null){
			schInviteYn = schOption.get("inviteYn").toString();
			schAcceptYn = schOption.get("acceptYn").toString();
		}
		
		result = new HashMap<String, Object>();
		result.put("optionId", "schInviteYn");
		result.put("optionValue", schInviteYn);
		result.put("optionNm", BizboxAMessage.getMessage("TX800000141","일정초대사용여부"));
		result.put("optionLevel", "1");
		optionList.add(result);	
		
		result = new HashMap<String, Object>();
		result.put("optionId", "schAcceptYn");
		result.put("optionValue", schAcceptYn);
		result.put("optionNm", BizboxAMessage.getMessage("TX800000142","초대수락자동여부"));
		result.put("optionLevel", "1");
		optionList.add(result);		
		
		return optionList;
	}

	public String getPasswdStatusCode(Map<String, Object> params) throws Exception {
		
		if(params.get("passwdStatusCode").equals("I") || params.get("passwdStatusCode").equals("R")){
			return params.get("passwdStatusCode").toString();
		}
		
		String passwdStatusCode = "P";
		
		List<Map<String, Object>> passwdOptionList = new ArrayList<Map<String, Object>>();
		Map<String, Object> passwdParam = new HashMap<String, Object>();
		Map<String, Object> passwdParam1 = new HashMap<String, Object>();
		boolean optionCheck = false;
		
		try {
			passwdParam.put("optionGubun", "cm");
			passwdParam.put("optionLevel", "1");
			passwdParam.put("groupSeq", params.get("groupSeq"));
			passwdOptionList = restfulDAO.selectOptionListMobile(passwdParam);
			
			for(Map<String, Object> temp : passwdOptionList) {
				if(temp.get("optionId").equals("cm200") && !temp.get("optionValue").equals("0")) {
					optionCheck = true;
				}
			}
			
			if(optionCheck){
				
				passwdParam1.put("optionGubun", "cm");
				passwdParam1.put("parentId", "cm200");
				passwdParam1.put("groupSeq", params.get("groupSeq"));
				passwdOptionList = restfulDAO.selectOptionListMobile(passwdParam1);
				
				String inputDueOptionValue = "";
				String passwdAlertOption = "0";
				String passwdChangeOption = "0";				
				String cm201Val = "0|0";
				
				for(Map<String, Object> temp : passwdOptionList) {
					if(temp.get("optionId").equals("cm201")) {
						cm201Val = temp.get("optionValue").toString();
					}
				}
				
    			if(cm201Val != null && !cm201Val.equals("")){
    				
    				if(cm201Val.split("▦").length > 1) {
    					inputDueOptionValue = cm201Val.split("▦")[0];
    					cm201Val = cm201Val.split("▦")[1];
    				}
    				
    				//안내기간, 만료기간 고도화 처리 (수정예정)
    				String[] cm201Array = cm201Val.split("\\|");
    				if(cm201Array.length > 1){
    					passwdAlertOption = cm201Array[0];
    					passwdChangeOption = cm201Array[1];
    				}else{
    					passwdChangeOption = cm201Array[0];
    				}
    			}				

	    		boolean dueYn = false;
	    		boolean alertYn = false;
	    		boolean noticeYn = false;
	    		
	    		if(inputDueOptionValue.equals("m")) {
	    			
	    			Calendar calendar = Calendar.getInstance();
	    			int year = calendar.get(calendar.YEAR);
	    			int month = calendar.get(calendar.MONTH)+1;
	    			int day = calendar.get(calendar.DAY_OF_MONTH);
	    			int lastDay = calendar.getActualMaximum(Calendar.DATE);
	    			int setDay = Integer.parseInt(passwdAlertOption);
	    			
	    			if(lastDay < setDay) {
	    				setDay = lastDay;
	    			}
	    			
	    			SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    			String compareToday = "";
	    			
	    			if(day < setDay) {
	    				
		    			int yearPrev = month == 1 ? year-1 : year;
		    			int monthPrev = month == 1 ? 12 : month-1;
	    				int setDayPrev = Integer.parseInt(passwdAlertOption);
		    			
	    				Calendar prevCal = new GregorianCalendar(year,monthPrev-1 ,1);
	    				lastDay = prevCal.getActualMaximum(prevCal.DATE);
	    				
		    			if(lastDay < setDayPrev) {
		    				setDayPrev = lastDay;
		    			}	    				
	    				
	    				compareToday = yearPrev + "-" + (monthPrev < 10 ? "0" : "") + monthPrev + "-" + (setDay < 10 ? "0" : "") +  + setDayPrev + " 00:00:00";
	    				
	    			}else {
	    				compareToday = year + "-" + (month < 10 ? "0" : "") + month + "-" + (setDay < 10 ? "0" : "") +  + setDay + " 00:00:00";
	    			}
		    		
		    		String passChangeDate = params.get("passwdDate").toString();

		    		Date todayDate = transFormat.parse(compareToday);
		    		Date changeDate = transFormat.parse(passChangeDate);
		    		
		    		if(changeDate.compareTo(todayDate) == -1) {
		    			
		    			dueYn = true;
		    			
		    		}else {
		    			//만료도래알림
		    			Calendar nowCal = new GregorianCalendar(year,month,day);
		    			Calendar nextCal = new GregorianCalendar(year,month,setDay);
		    			
		    			if(day >= setDay) {
		    				
		    				if(month == 12) {
		    					year += 1;
		    					month = 1;
		    				}else {
		    					month += 1;
		    				}
		    				
		    				nextCal.set(year, month, 1);
		    				
		    				lastDay = nextCal.getActualMaximum(nextCal.DATE);
		    				setDay = Integer.parseInt(passwdAlertOption);
		    				
			    			if(lastDay < setDay) {
			    				setDay = lastDay;
			    			}
			    			nextCal.set(year, month, setDay);
		    			}
		    			
			    		// 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
			    		long diff = (nextCal.getTimeInMillis() - nowCal.getTimeInMillis()) / 1000;
			    		long diffDays = diff / (24 * 60 * 60);
			    		
			    		setDay = Integer.parseInt(passwdChangeOption);
			    		
			    		if(diffDays <= setDay) {
			    			noticeYn = true;	
			    		}
		    		}
	    			
	    		}else {
	    			
		    		Date today = new Date();
		    		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    		String compareToday = transFormat.format(today);
		    		String passChangeDate = params.get("passwdDate").toString();

		    		Date todayDate = transFormat.parse(compareToday);
		    		Date changeDate = transFormat.parse(passChangeDate);
		    		
		    		// 시간차이를 시간,분,초를 곱한 값으로 나누면 하루 단위가 나옴
		    		long diff = todayDate.getTime() - changeDate.getTime();
		    		long diffDays = diff / (24 * 60 * 60 * 1000);
		    		
		    		if(!passwdChangeOption.equals("0") && diffDays >= Long.parseLong(passwdChangeOption)) {
		    			dueYn = true;
		    		}else if(!passwdAlertOption.equals("0") && diffDays >= Long.parseLong(passwdAlertOption)) {
		    			alertYn = true;
		    		}
	    			
	    		}
	    		
	    		boolean change = false;
	    		
				if(!dueYn && params.get("passwdStatusCode") != null && params.get("passwdStatusCode").equals("C")){
					return "C";
				}	    		
	    		
	    		if(dueYn){
	    			params.put("passwdStatusCode", "D");
	    			passwdStatusCode = "D";	    			
	    			change = true;
	    		}else if(alertYn){
	    			params.put("passwdStatusCode", "T");
	    			passwdStatusCode = "T";	    			
	    			change = true;
	    		}else if(noticeYn) {
	    			params.put("passwdStatusCode", "N");
	    			passwdStatusCode = "N|" + passwdAlertOption;	    			
	    			change = true;
	    		}				
				
	    		if(change){
	    			commonOptionManageService.changeEmpPwdDate(params);	    			
	    		}
    						
			}			
		}catch(Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return passwdStatusCode;
	}

	@Override
	public Map<String, Object> checkEmpPersonnelCardInfo(Map<String, Object> param) {
		return restfulDAO.checkEmpPersonnelCardInfo(param);
	}

}