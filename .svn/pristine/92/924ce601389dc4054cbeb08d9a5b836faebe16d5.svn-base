package restful.messenger.service.impl;

import java.io.File;
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

import egovframework.com.utl.fcc.service.EgovDateUtil;
import neos.cmm.systemx.commonOption.service.CommonOptionManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.FileUtils;
import neos.cmm.util.ImageUtil;
import neos.cmm.util.code.service.SequenceService;
import restful.com.service.AttachFileService;
import restful.messenger.dao.MessengerDAO;
import restful.messenger.service.MessengerService;
import restful.messenger.vo.MessengerLoginVO;


@Service("MessengerService")
public class MessengerServiceImpl implements MessengerService{
	
	@Resource(name = "MessengerDAO")
	MessengerDAO restfulDAO = new MessengerDAO();
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	@Resource(name="AttachFileService")
	AttachFileService attachFileService;
	
	@Resource(name="CommonOptionManageService")
    private CommonOptionManageService commonOptionManageService;

	@Override
	public List<MessengerLoginVO> actionLoginMobile(MessengerLoginVO param) {
		List<MessengerLoginVO> list = null;
		try {
			list = restfulDAO.actionLoginMobile(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return list;
	}

	public List<Map<String,Object>> selectLoginVO(MessengerLoginVO param) {
		List<Map<String,Object>> list = null;
		try {
			list = restfulDAO.selectLoginVO(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return list;
	}	
	
    public String selectLoginPassword(MessengerLoginVO param) throws Exception {    
    	return restfulDAO.selectLoginPassword(param);
    }

	@Override
	public List<Map<String, Object>> selectOrgImgList(Map<String,Object> vo) {
		return restfulDAO.selectOrgImgList(vo);
	}

	@Override
	public String fileSave(List<Map<String, Object>> fileList, Map<String, Object> params) throws Exception {
		
		String path = params.get("path")+"";
		String pathSeq = params.get("pathSeq")+"";
		String relativePath = params.get("relativePath")+"";
		String empSeq = params.get("empSeq")+"";
		
		/** File Id 생성(성공시 return) */
		params.put("value", "atchfileid");
		String fileId = sequenceService.getSequence(params);
		int fileSn = 0;
		int size = 0;
		List<Map<String,Object>> saveFileList = new ArrayList<Map<String,Object>>();
		Map<String,Object> newFileInfo = null;
		
		for(Map<String,Object> map : fileList) {
			String orginFileName = map.get("originalFileName")+"";
			String downloadUrl = map.get("downloadUrl")+"";
			String fileExt = map.get("fileExtsn")+"";
			
			/* 확장자 */
//			int index = orginFileName.lastIndexOf(".");
			
//			String fileExt = orginFileName.substring(index + 1);
//			fileExt = fileExt.toLowerCase();												// 확장자
//			orginFileName = orginFileName.substring(0, index);

			String newName =  EgovDateUtil.today("yyyyMMdd_HHmmss") +"_"+fileId+"_"+fileSn;	// 저장할 파일명
			
			String saveFilePath = path+relativePath+File.separator+newName+"."+fileExt;
			
			File file = FileUtils.getUrlFileDownload(downloadUrl, saveFilePath);
			
			
			/** 이미지일때 썸네일 이미지 저장
			 *  파일명_small.확장자
			 *  */
			String imgExt = "jpeg|bmp|gif|jpg|png";
			if (imgExt.indexOf(fileExt) != -1) {
				String imgSizeType = "thum";			//일단 썸네일 사이즈만
				int imgMaxWidth = 420;
				int imgRate = 1;
				ImageUtil.saveCropImage(new File(path+relativePath+File.separator+newName+"_"+imgSizeType+"."+fileExt), new File(saveFilePath), imgMaxWidth, imgRate);
			}
			
			
			
			if (file != null) {
				newFileInfo = new HashMap<String,Object>();
				newFileInfo.put("fileId", fileId);
				newFileInfo.put("fileSn", fileSn);
				newFileInfo.put("pathSeq", pathSeq);
				newFileInfo.put("fileStreCours", relativePath);
				newFileInfo.put("streFileName", newName);
				newFileInfo.put("orignlFileName", orginFileName);
				newFileInfo.put("fileExtsn", fileExt);
				newFileInfo.put("fileSize", file.length());
				newFileInfo.put("createSeq", empSeq);
				saveFileList.add(newFileInfo);
				fileSn++;
			}
		}
				
		String resultFileId = null;
		
		/** DB Insert */
		if (saveFileList.size() > 0) {
			resultFileId = attachFileService.insertAttachFile(saveFileList);
		}
		
		return resultFileId;
	}

	public List<Map<String,Object>> selectAlertInfo(MessengerLoginVO param) {
		List<Map<String,Object>> list = null;
		
		try {
			list = restfulDAO.selectAlertInfo(param);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return list;
	}	
	
	public List<Map<String, Object>> selectOptionListMessanger(Map<String, Object> params) {
		List<Map<String, Object>> optionList = new ArrayList<Map<String, Object>>();
		
		// 기본 옵션 가져오기
		Map<String, Object> p = new HashMap<String, Object>();
		p.put("groupSeq", params.get("groupSeq"));
		optionList = restfulDAO.selectOptionListMessanger(p);
		
		for(Map<String, Object> option : optionList) {
			
			if(option.get("optionId").equals("msg1600")) {
				
				List<Map<String, Object>> downViewerList = new ArrayList<Map<String, Object>>();
				
				String pathSeq800 = "";
				String pathSeq810 = "";
				
				if(option.get("optionValue").equals("1")) {	
					
					for(Map<String, Object> item : optionList) {
						
						if(item.get("optionId").equals("pathSeq800")) {
							pathSeq800 = item.get("optionValue").toString();
						}else if(item.get("optionId").equals("pathSeq810")) {
							pathSeq810 = item.get("optionValue").toString();
						}
					}
				}
				
				Map<String, Object> multiOption = new HashMap<String, Object>();
				multiOption.put("moduleCode", "800");
				if(pathSeq800.equals("0|") || pathSeq800.equals("0")) {	// 문서뷰어
					multiOption.put("docViewer", "1");
					multiOption.put("fileDown", "0");
				} else if(pathSeq800.equals("1|") || pathSeq800.equals("1")) {	// 파일다운
					multiOption.put("docViewer", "0");
					multiOption.put("fileDown", "1");
				} else if(pathSeq800.equals("1|0|") || pathSeq800.equals("0|1|")) {	// 문서뷰어, 파일다운
					multiOption.put("docViewer", "1");
					multiOption.put("fileDown", "1");
				}else {
					multiOption.put("docViewer", "0");
					multiOption.put("fileDown", "0");					
				}
				downViewerList.add(multiOption);
				
				multiOption = new HashMap<String, Object>();
				multiOption.put("moduleCode", "810");
				if(pathSeq810.equals("0|") || pathSeq810.equals("0")) {	// 문서뷰어
					multiOption.put("docViewer", "1");
					multiOption.put("fileDown", "0");
				} else if(pathSeq810.equals("1|") || pathSeq810.equals("1")) {	// 파일다운
					multiOption.put("docViewer", "0");
					multiOption.put("fileDown", "1");
				} else if(pathSeq810.equals("1|0|") || pathSeq810.equals("0|1|")) {	// 문서뷰어, 파일다운
					multiOption.put("docViewer", "1");
					multiOption.put("fileDown", "1");
				}else {
					multiOption.put("docViewer", "0");
					multiOption.put("fileDown", "0");					
				}
				
				downViewerList.add(multiOption);				
				
				option.put("optionValue", downViewerList);
				
			} else if(option.get("optionId").equals("msg1610")) {
				
				List<Map<String, Object>> extOptionList = new ArrayList<Map<String, Object>>();
				
				String extOptionValue800 = "limit▦";
				String extOptionValue810 = "limit▦";
				
				//전체적용 설정일 경우 설정값 가져오기 
				if(option.get("optionValue").equals("1")) {
					
					for(Map<String, Object> item : optionList) {
						
						if(item.get("optionId").equals("msg1611")) {
							extOptionValue800 = item.get("optionValue").toString();
							extOptionValue810 = extOptionValue800;
							break;
						}
					}
					
				}else if(option.get("optionValue").equals("2")) {
					
					//선택적용 설정일 경우 설정값 가져오기 
					for(Map<String, Object> item : optionList) {
						
						if(item.get("optionId").equals("msg1612")) {
							extOptionValue810 = item.get("optionValue").toString();
						}else if(item.get("optionId").equals("msg1613")) {
							extOptionValue800 = item.get("optionValue").toString();
						}
					}					
				}

				Map<String, Object> multiOption = new HashMap<String, Object>();
				multiOption.put("moduleCode", "800");

				String[] extOptionValueArray = extOptionValue800.split("▦",-1);
				
				if(extOptionValueArray.length > 1) {
					multiOption.put("type", extOptionValueArray[0]);
					multiOption.put("extStr", extOptionValueArray[1]);						
				}else {
					multiOption.put("type", "limit");
					multiOption.put("extStr", "");							
				}				
				
				extOptionList.add(multiOption);
				
				multiOption = new HashMap<String, Object>();
				multiOption.put("moduleCode", "810");

				extOptionValueArray = extOptionValue810.split("▦",-1);
				
				if(extOptionValueArray.length > 1) {
					multiOption.put("type", extOptionValueArray[0]);
					multiOption.put("extStr", extOptionValueArray[1]);						
				}else {
					multiOption.put("type", "limit");
					multiOption.put("extStr", "");							
				}					
				
				extOptionList.add(multiOption);				
				
				option.put("optionValue", extOptionList);
				
			} else if(option.get("optionId").equals("msg1800")) {
				List<Map<String, Object>> downViewerList = new ArrayList<Map<String, Object>>();
				
				String optionValue = option.get("optionValue").toString();
				Map<String, Object> talkOption = new HashMap<String, Object>();
				Map<String, Object> msgOption = new HashMap<String, Object>();
				
				// 옵션 값 나누기 
				if(optionValue.equals("999")){			// 미선택
					talkOption.put("docViewer", "0");
					talkOption.put("fileDown", "0");
					
					msgOption.put("docViewer", "0");
					msgOption.put("fileDown", "0");
				} else if(optionValue.equals("0|") || optionValue.equals("0")) {	// 문서뷰어
					talkOption.put("docViewer", "1");
					talkOption.put("fileDown", "0");
					
					msgOption.put("docViewer", "1");
					msgOption.put("fileDown", "0");
				} else if(optionValue.equals("1|") || optionValue.equals("1")) {	// 파일다운
					talkOption.put("docViewer", "0");
					talkOption.put("fileDown", "1");
					
					msgOption.put("docViewer", "0");
					msgOption.put("fileDown", "1");
				} else if(optionValue.equals("1|0|") || optionValue.equals("0|1|")) {	// 문서뷰어, 파일다운
					talkOption.put("docViewer", "1");
					talkOption.put("fileDown", "1");
					
					msgOption.put("docViewer", "1");
					msgOption.put("fileDown", "1");
				}				
				
				
				talkOption.put("moduleCode", "800");			// 대화방
				downViewerList.add(talkOption);
			
				msgOption.put("moduleCode", "810");			// 쪽지
				downViewerList.add(msgOption);
				
				
				option.put("optionValue", downViewerList);
			}else if(option.get("optionId").equals("msg2000")){
				if(option.get("optionValue").toString().equals("0|")){
					option.put("optionValue", "1");
				}else if(option.get("optionValue").toString().equals("1|")){
					option.put("optionValue", "2");
				}else if(option.get("optionValue").toString().equals("0|1|")){
					option.put("optionValue", "3");
				}else{
					option.put("optionValue", "0");
				}
			}
		}
		
		return optionList;
	}
	
	public String getPasswdStatusCode(Map<String, Object> params) {
		
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
			passwdOptionList = restfulDAO.selectOptionListMessenger(passwdParam);
			
			for(Map<String, Object> temp : passwdOptionList) {
				if(temp.get("optionId").equals("cm200") && !temp.get("optionValue").equals("0")) {
					optionCheck = true;
				}
			}
			
			if(optionCheck){
				
				passwdParam1.put("optionGubun", "cm");
				passwdParam1.put("parentId", "cm200");
				passwdParam1.put("groupSeq", params.get("groupSeq"));
				passwdOptionList = restfulDAO.selectOptionListMessenger(passwdParam1);
				
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
	    			passwdStatusCode = "N";	    			
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
	
}