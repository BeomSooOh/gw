package api.drm.service.impl;


import java.io.*;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.util.BizboxAProperties;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.NeosConstants;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.markany.docsafer.inflib.nx.MaDrmDocSafer;
import MarkAny.MaSaferJava.Madec;
import MarkAny.MaSaferJava.Madn;
import api.drm.service.DrmService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Service("DrmService")
public class DrmServiceImpl implements DrmService{
	
	protected Logger logger = Logger.getLogger( super.getClass( ) );
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	public String drmConvert(String action, String groupSeq, String pathSeq, String filePath, String fileName, String fileExt){
		
		filePath = filePath.replace("//", "/");
		String resultPath = filePath + "/" + fileName + (fileExt.equals("") ? "" : "." + fileExt);
		
		if(!BizboxAProperties.getCustomProperty("BizboxA.drmUseYn").equals("Y")){
			return resultPath;
		}
		
		//logger.debug("DrmService.drmConvert : " + action + "|" + groupSeq + "|" + pathSeq + "|" + filePath + "|" + fileName + "|" + fileExt);
		
		Map<String, Object> para = new HashMap<String, Object>();
		
		try{
			
			//마지막 문자열에 /가 포함되있을 경우 제거
			if(filePath != null && !filePath.equals("") && filePath.substring(filePath.length()-1).equals("/")){
				filePath = filePath.substring(0, filePath.length()-1);
			}
			
			if(groupSeq != null && !groupSeq.equals("")){
				para.put("groupSeq", groupSeq);	
			}
			
			para.put("pathSeq", pathSeq);
			para.put("osType", NeosConstants.SERVER_OS);
			
			@SuppressWarnings("unchecked")
			Map<String, Object> drmOption = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathDrmOption", para);
			
			String drmType = drmOption.get("drmType").toString();
			String drmOptionVal1 = drmOption.get("drmOptionVal1").toString();
			String drmOptionVal2 = drmOption.get("drmOptionVal2").toString();
			
			if(drmType.equals("") || drmOptionVal1.equals("") || drmOptionVal2.equals("")){
				return resultPath;
			}			
			Map<String, Object> userInfo = new HashMap<String, Object>();
			
			//drm 사용여부 및 확장자 체크
			if(drmOption != null && drmOption.get("drmUseYn").equals("Y") && (drmOption.get("drmFileExtsn") == null || drmOption.get("drmFileExtsn").equals("")
					// 수정필요..(암호화해야되는 대상 체크 필요)
					// ! 잇는지 체크해서 조건 통과/미통과 여부 체크
					// ! 있는거랑 없는거는 같이 존재 XXX
					|| drmOption.get("drmFileExtsn").toString().contains("|" + fileExt.toLowerCase() + "|"))
					|| !drmOption.get("drmFileExtsn").toString().contains("|!" + fileExt.toLowerCase() + "|")
					){
				
				//업로드시
				if(action.equals("U") && !drmOption.get("drmUpload").equals("")){
	
					//업로드 시 암호화
					if(drmOption.get("drmUpload").equals("E")){
	
						//파수닷컴 솔루션
						if(drmType.equals("fasoo")){
							para.put("fasooDrmEncoding(UE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = fasooDrmEncoding(drmOptionVal1, drmOptionVal2, true, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//소프트캠프 솔루션			
						else if(drmType.equals("sc")){
							para.put("scDrmEncoding(UE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = scDrmEncoding(drmOptionVal1, drmOptionVal2, true, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//마크애니 솔루션
						else if(drmType.equals("ma")) {
							para.put("maDrmEncoding(UE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = maDrmEncoding(drmOptionVal1, drmOptionVal2, true, filePath, fileName + "." + fileExt, userInfo);
							para.put("resultPath", resultPath);
						}
						
					}
					//업로드 시 복호화
					else if(drmOption.get("drmUpload").equals("D")){
	
						//파수닷컴 솔루션
						if(drmType.equals("fasoo")){
							para.put("fasooDrmDecoding(UD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = fasooDrmDecoding(drmOptionVal1, drmOptionVal2, true, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//소프트캠프 솔루션			
						else if(drmType.equals("sc")){
							para.put("scDrmDecoding(UD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = scDrmDecoding(drmOptionVal1, drmOptionVal2, true, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);						
						}
						//마크애니 솔루션
						else if(drmType.equals("ma")) {
							para.put("maDrmDecoding(UD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = maDrmDecoding(drmOptionVal1, true, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);			
						}
					}
					
				}
				//다운로드시
				else if(action.equals("D") && !drmOption.get("drmDownload").equals("")){
	
					//다운로드 시 암호화
					if(drmOption.get("drmDownload").equals("E")){
						
						//파수닷컴 솔루션
						if(drmType.equals("fasoo")){
							para.put("fasooDrmEncoding(DE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = fasooDrmEncoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//소프트캠프 솔루션			
						else if(drmType.equals("sc")){
							para.put("scDrmEncoding(DE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = scDrmEncoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//마크애니 솔루션
						else if(drmType.equals("ma")) {
							para.put("maDrmEncoding(DE)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = maDrmEncoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt, userInfo);
							para.put("resultPath", resultPath);
						}
						
					}
					//다운로드 시 복호화			
					else if(drmOption.get("drmDownload").equals("D")){
						
						//파수닷컴 솔루션
						if(drmType.equals("fasoo")){
							para.put("fasooDrmDecoding(DD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = fasooDrmDecoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);
						}
						//소프트캠프 솔루션			
						else if(drmType.equals("sc")){
							para.put("scDrmDecoding(DD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = scDrmDecoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);						
						}
						//마크애니 솔루션
						else if(drmType.equals("ma")) {
							para.put("maDrmDecoding(DD)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
							resultPath = maDrmDecoding(drmOptionVal1, false, filePath, fileName + "." + fileExt);
							para.put("resultPath", resultPath);	
						}
					}				
					
				}else if(action.equals("V")){
					
					//파수닷컴 솔루션
					if(drmType.equals("fasoo")){
						para.put("fasooDrmDecoding(V)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
						resultPath = fasooDrmDecoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
						para.put("resultPath", resultPath);
					}
					//소프트캠프 솔루션			
					else if(drmType.equals("sc")){
						para.put("scDrmDecoding(V)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
						resultPath = scDrmDecoding(drmOptionVal1, drmOptionVal2, false, filePath, fileName + "." + fileExt);
						para.put("resultPath", resultPath);						
					}
					//마크애니 솔루션
					else if(drmType.equals("ma")) {
						para.put("maDrmDecoding(V)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName + "|" + fileExt);
						resultPath = maDrmDecoding(drmOptionVal1, false, filePath, fileName + "." + fileExt);
						para.put("resultPath", resultPath);		
					}
					
				}
			}
			
		}catch(Exception ex){
			para.put("Exception", ex.getMessage());
			para.put("action", action);
			para.put("pathSeq", pathSeq);
			para.put("filePath", filePath);
			para.put("fileName", fileName);
			para.put("fileExt", fileExt);
			para.put("reqType", "viewSelect");
			para.put("apiTp", "drmConvert");		
			para.put("data", para.toString());
			commonSql.insert("HrExtInterlock.setApiLog", para);			
		}
		
		return resultPath;
	}
	
	public String drmConvertAPI(String action, String groupSeq, String filePath, String fileName, String overWrite){
		
		filePath = filePath.replace("//", "/");
		String resultPath = filePath + "/" + fileName;
		
		if(!BizboxAProperties.getCustomProperty("BizboxA.drmUseYn").equals("Y")){
			return resultPath;
		}
		
		//logger.debug("DrmService.drmConvert : " + action + "|" + groupSeq + "|" + pathSeq + "|" + filePath + "|" + fileName + "|" + fileExt);
		
		Map<String, Object> para = new HashMap<String, Object>();
		
		try{
			
			//마지막 문자열에 /가 포함되있을 경우 제거
			if(filePath != null && !filePath.equals("") && filePath.substring(filePath.length()-1).equals("/")){
				filePath = filePath.substring(0, filePath.length()-1);
			}
			
			if(groupSeq != null && !groupSeq.equals("")){
				para.put("groupSeq", groupSeq);	
			}
			
			para.put("pathSeq", "0");
			para.put("osType", NeosConstants.SERVER_OS);
			
			@SuppressWarnings("unchecked")
			Map<String, Object> drmOption = (Map<String, Object>) commonSql.select("AttachFileUpload.getFilePathDrmOption", para);
			
			Map<String, Object> userInfo = new HashMap<String, Object>();
			
			//drm 사용여부 및 확장자 체크
			if(drmOption != null){
				
				String drmType = drmOption.get("drmType").toString();
				String drmOptionVal1 = drmOption.get("drmOptionVal1").toString();
				String drmOptionVal2 = drmOption.get("drmOptionVal2").toString();
				
				if(drmType.equals("") || drmOptionVal1.equals("") || drmOptionVal2.equals("")){
					return resultPath;
				}
	
				//다운로드 시 암호화
				if(action.equals("E")){
					
					//파수닷컴 솔루션
					if(drmType.equals("fasoo")){
						para.put("fasooDrmEncoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = fasooDrmEncoding(drmOptionVal1, drmOptionVal2, overWrite.equals("Y"), filePath, fileName);
						para.put("resultPath", resultPath);
					}
					//소프트캠프 솔루션			
					else if(drmType.equals("sc")){
						para.put("scDrmEncoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = scDrmEncoding(drmOptionVal1, drmOptionVal2, overWrite.equals("Y"), filePath, fileName);
						para.put("resultPath", resultPath);
					}
					//마크애니 솔루션
					else if(drmType.equals("ma")) {
						para.put("maDrmEncoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = maDrmEncoding(drmOptionVal1, drmOptionVal2, overWrite.equals("Y"), filePath, fileName, userInfo);
						para.put("resultPath", resultPath);
					}
					
				}
				//다운로드 시 복호화			
				else if(action.equals("D")){
					
					//파수닷컴 솔루션
					if(drmType.equals("fasoo")){
						para.put("fasooDrmDecoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = fasooDrmDecoding(drmOptionVal1, drmOptionVal2, overWrite.equals("Y"), filePath, fileName);
						para.put("resultPath", resultPath);
					}
					//소프트캠프 솔루션			
					else if(drmType.equals("sc")){
						para.put("scDrmDecoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = scDrmDecoding(drmOptionVal1, drmOptionVal2, overWrite.equals("Y"), filePath, fileName);
						para.put("resultPath", resultPath);						
					}					
					//마크애니 솔루션
					else if(drmType.equals("ma")) {
						para.put("maDrmDecoding(API)", drmOptionVal1 + "|" + drmOptionVal2 + "|" + filePath + "|" + fileName);
						resultPath = maDrmDecoding(drmOptionVal1, overWrite.equals("Y"), filePath, fileName);
						para.put("resultPath", resultPath);		
					}
				}				
			}
			
		}catch(Exception ex){
			resultPath = "";
			para.put("Exception", ex.getMessage());
			para.put("action", action);
			para.put("filePath", filePath);
			para.put("fileName", fileName);
			para.put("apiTp", "drmConvertAPI");		
			para.put("data", para.toString());
			commonSql.insert("HrExtInterlock.setApiLog", para);
		}
		
		return resultPath;
	}	
	
	private String fasooDrmEncoding(String fasooDrmPath, String fasooDrmKey, boolean overWrite, String fileOrgPath, String fileName){
		
		org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmEncoding 진입..");
		String securityLevel = "d242005988ae455aa4a22f0ff3deb8cd";
		
		if(fasooDrmKey.contains("▦")) {

			String[] fasooDrmKeyStr = fasooDrmKey.split("▦", -1);
			
			fasooDrmKey = fasooDrmKeyStr[0];
			securityLevel = fasooDrmKeyStr[1];
			
		}
		
		String strEncFilePath = fileOrgPath;
		String resultPath = fileOrgPath + "/" + fileName;
		
		if(!overWrite) {
			
			strEncFilePath += "/drmEncTemp";

			//변환파일이 이미 존재할 경우 기존파일 리턴
			if(new File(strEncFilePath + "/" + fileName).exists()){
				return strEncFilePath + "/" + fileName;
			}			
		}
		
		String drmEncOwnId = BizboxAProperties.getCustomProperty("BizboxA.drmEncOwnId");
		
		if(drmEncOwnId.equals("99")) {
			drmEncOwnId = "Groupware";
		}
		
		if(BizboxAProperties.getCustomProperty("BizboxA.drmFedVer").equals("4")){
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmEncoding 4버전 진입..");
			com.fasoo.adk.packager.WorkPackager fed4 = new com.fasoo.adk.packager.WorkPackager();
			fed4.setOverWriteFlag(true);
			int retVal = fed4.GetFileType(resultPath);
			if (retVal == 29) {
				
				if(!overWrite) {
					File desti = new File(strEncFilePath);
					
					if(!desti.exists()) {
						desti.mkdirs();	
					}
				}
				
				boolean	iret = fed4.DoPackagingFsn2(fasooDrmPath, fasooDrmKey, resultPath, strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName, fileName, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, securityLevel);
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 성공 여부 .. >> " + iret);
				if(iret){
					if(overWrite){
						File encFile = new File(fed4.getContainerFilePathName());
						if(encFile.exists()){
							File orgFile = new File(resultPath);
							if(orgFile.exists()){
								orgFile.delete();
							}
							encFile.renameTo(new File(resultPath));
						}
					}else{
						resultPath = strEncFilePath + "/" + fileName;
					}
				}
				else {
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 실패 사유: [" + fed4.getLastErrorNum()+"] "+fed4.getLastErrorStr());					
				}
			}			
		}else {
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmEncoding 5버전 진입..");
			com.fasoo.fcwpkg.packager.WorkPackager fed5 = new com.fasoo.fcwpkg.packager.WorkPackager();
			fed5.setOverWriteFlag(true);
			int retVal = fed5.GetFileType(resultPath);
			if (retVal == 29) {
				
				if(!overWrite) {
					File desti = new File(strEncFilePath);
					
					if(!desti.exists()) {
						desti.mkdirs();	
					}
				}
				
				boolean	iret = fed5.DoPackagingFsn2(fasooDrmPath, fasooDrmKey, resultPath, strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName, fileName, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, drmEncOwnId, securityLevel);
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("5버전 성공 여부 .. >> " + iret);
				if(iret){
					if(overWrite){
						File encFile = new File(fed5.getContainerFilePathName());
						if(encFile.exists()){
							File orgFile = new File(resultPath);
							if(orgFile.exists()){
								orgFile.delete();
							}
							encFile.renameTo(new File(resultPath));
						}
					}else{
						resultPath = strEncFilePath + "/" + fileName;
					}
				}
				else {
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("5버전 실패 사유: [" + fed5.getLastErrorNum()+"] "+fed5.getLastErrorStr());
				}
			}			
		}
		
		return resultPath;
	}
	
	private String fasooDrmDecoding(String fasooDrmPath, String fasooDrmKey, boolean overWrite, String fileOrgPath, String fileName){
		
		org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmDecoding 진입..");
		if(fasooDrmKey.contains("▦")) {
			String[] fasooDrmKeyStr = fasooDrmKey.split("▦", -1);
			fasooDrmKey = fasooDrmKeyStr[0];
		}		
		
		String strDecFilePath = fileOrgPath;
		String resultPath = fileOrgPath + "/" + fileName;
		
		if(!overWrite) {
			
			strDecFilePath += "/drmDecTemp";

			//변환파일이 이미 존재할 경우 기존파일 리턴
			if(new File(strDecFilePath + "/" + fileName).exists()){
				return strDecFilePath + "/" + fileName;
			}		
		}		
		
		if(BizboxAProperties.getCustomProperty("BizboxA.drmFedVer").equals("4")){
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmDecoding 버전4 진입..");
			com.fasoo.adk.packager.WorkPackager fed4 = new com.fasoo.adk.packager.WorkPackager();
			fed4.setOverWriteFlag(true);
			int retVal = fed4.GetFileType(resultPath);
			
			if (retVal == 103 || retVal == 106) {
				
				if(!overWrite) {
					File desti = new File(strDecFilePath);
					
					if(!desti.exists()) {
						desti.mkdirs();	
					}
				}				
				
				boolean	bret = fed4.DoExtract(fasooDrmPath, fasooDrmKey, resultPath, strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName);
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 성공 여부 .. >> " + bret);
				if(bret){
					if(overWrite){
						File encFile = new File(fed4.getContainerFilePathName());
						if(encFile.exists()){
							File orgFile = new File(resultPath);
							if(orgFile.exists()){
								orgFile.delete();
							}
							encFile.renameTo(new File(resultPath));
						}
					}else{
						resultPath = strDecFilePath + "/" + fileName;
					}
				}
				else {
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 실패 사유: [" + fed4.getLastErrorNum()+"] "+fed4.getLastErrorStr());
				}
			}			
		}else {
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("fasooDrmDecoding 버전5 진입..");
			com.fasoo.fcwpkg.packager.WorkPackager fed5 = new com.fasoo.fcwpkg.packager.WorkPackager();
			fed5.setOverWriteFlag(true);
			int retVal = fed5.GetFileType(resultPath);
			
			if (retVal == 103 || retVal == 106) {
				
				if(!overWrite) {
					File desti = new File(strDecFilePath);
					
					if(!desti.exists()) {
						desti.mkdirs();	
					}
				}					
				
				boolean	bret = fed5.DoExtract(fasooDrmPath, fasooDrmKey, resultPath, strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName);
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("5버전 성공 여부 .. >> " + bret);
				if(bret){
					if(overWrite){
						File encFile = new File(fed5.getContainerFilePathName());
						if(encFile.exists()){
							File orgFile = new File(resultPath);
							if(orgFile.exists()){
								orgFile.delete();
							}
							encFile.renameTo(new File(resultPath));
						}
					}else{
						resultPath = strDecFilePath + "/" + fileName;
					}
				
				}
				else if(BizboxAProperties.getCustomProperty("BizboxA.drmFedVer").equals("4|5")) {
					
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("5버전 실패 사유: [" + fed5.getLastErrorNum()+"] "+fed5.getLastErrorStr());
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 시도.. ");
					// FED 4/5 혼용일 경우 4버젼으로 재차 복호화 시도
					com.fasoo.adk.packager.WorkPackager fed4 = new com.fasoo.adk.packager.WorkPackager();
					fed4.setOverWriteFlag(true);
					retVal = fed4.GetFileType(resultPath);
					
					if (retVal == 103 || retVal == 106) {
						bret = fed4.DoExtract(fasooDrmPath, fasooDrmKey, resultPath, strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName);
						org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 성공여부 >> " + bret);
						if(bret) {
							if(overWrite){
								File encFile = new File(fed4.getContainerFilePathName());
								if(encFile.exists()){
									File orgFile = new File(resultPath);
									if(orgFile.exists()){
										orgFile.delete();
									}
									encFile.renameTo(new File(resultPath));
								}
							}else{
								resultPath = strDecFilePath + "/" + fileName;
							}						
						}
						else {
							org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("4버전 실패 사유: [" + fed4.getLastErrorNum()+"] "+fed4.getLastErrorStr());
						}
					}					
				}
			}
		}
		
		return resultPath;
	}	
	
	private String scDrmEncoding(String scPropertiesPath, String scDrmKey, boolean overWrite, String fileOrgPath, String fileName){
		
		String secutirySet = "111001100";
		
		if(scDrmKey.contains("▦")) {

			String[] scDrmKeyStr = scDrmKey.split("▦", -1);
			
			scDrmKey = scDrmKeyStr[0];
			secutirySet = scDrmKeyStr[1];
			
		}
		
		String strEncFilePath = fileOrgPath;
		String resultPath = fileOrgPath + "/" + fileName;
		
		if(!overWrite) {
			
			strEncFilePath += "/drmEncTemp";

			//변환파일이 이미 존재할 경우 기존파일 리턴
			if(new File(strEncFilePath + "/" + fileName).exists()){
				return strEncFilePath + "/" + fileName;
			}			
		}
		
		int retVal = new SCSL.SLBsUtil().isEncryptFile(resultPath);
		
		if (retVal == 0) {
			
			if(!overWrite) {
				File desti = new File(strEncFilePath);
				
				if(!desti.exists()) {
					desti.mkdirs();	
				}
			}
			
			String drmEncOwnId = BizboxAProperties.getCustomProperty("BizboxA.drmEncOwnId");
			
			if(drmEncOwnId.equals("99")) {
				drmEncOwnId = "GroupWare";
			}
				
			SCSL.SLDsFile sFile = new SCSL.SLDsFile();
			sFile.SettingPathForProperty(scPropertiesPath);			
			sFile.SLDsAddUserDAC("SECURITYDOMAIN", secutirySet, 0, 0, 0); 
			
			if(sFile.SLDsEncFileDACV2(scDrmKey, drmEncOwnId, resultPath, strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName, 1) == 0){
				if(overWrite){
					File encFile = new File(strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName);
					if(encFile.exists()){
						File orgFile = new File(resultPath);
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strEncFilePath + "/" + fileName;
				}
			}
		}
		
		return resultPath;
	}		

	private String scDrmDecoding(String scPropertiesPath, String scDrmKey, boolean overWrite, String fileOrgPath, String fileName){
	
		if(scDrmKey.contains("▦")) {
			String[] scDrmKeyStr = scDrmKey.split("▦", -1);
			scDrmKey = scDrmKeyStr[0];
		}		
		
		String strDecFilePath = fileOrgPath;
		String resultPath = fileOrgPath + "/" + fileName;
		
		if(!overWrite) {
			
			strDecFilePath += "/drmDecTemp";

			//변환파일이 이미 존재할 경우 기존파일 리턴
			if(new File(strDecFilePath + "/" + fileName).exists()){
				return strDecFilePath + "/" + fileName;
			}		
		}	
		
		int retVal = new SCSL.SLBsUtil().isEncryptFile(resultPath);
		
		if (retVal == 1) {
			
			if(!overWrite) {
				File desti = new File(strDecFilePath);
				
				if(!desti.exists()) {
					desti.mkdirs();	
				}
			}	
			 
			SCSL.SLDsFile sFile = new SCSL.SLDsFile();
			sFile.SettingPathForProperty(scPropertiesPath);
			
			int desRetVal = sFile.CreateDecryptFileDAC (
					scDrmKey,
					"SECURITYDOMAIN",
					resultPath,
					strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName);
			
			if(desRetVal == 0){
				if(overWrite){
					File encFile = new File(strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName);
					if(encFile.exists()){
						File orgFile = new File(resultPath);
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strDecFilePath + "/" + fileName;
				}
			}			
		}			
		
		return resultPath;
	}		
	
	@SuppressWarnings("resource")
	private String maDrmEncoding(String drmOptionVal1, String drmOptionVal2, boolean overWrite, String fileOrgPath, String fileName, Map<String, Object> userInfo ) throws IOException{
		
		// drmOptionVal1 : v1 or v2
		// v1: 프레시지 적용 시점 버전
		// v2: 아이큐어 적용 시점 버전
		if(drmOptionVal1.equals("v1")) {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			
			String	userId = "";
			String	groupId =  "";
			String	positionId =  "";
			String	companyName = "";
			String	groupName = "";
			String	positionName = "";
			String	userName = "";
			String	deptID = "";
			String	deptName = "";
			
			/**
			 * 사용자 정보 파라미터 세팅
			 */
			try {
				if(loginVO == null) {
					// 임시 처리 --> admin default 처리
					// 프레시지
//					UserId = userInfo.get("loginId").toString();
//					GroupId =  userInfo.get("groupSeq").toString();
//					PositionId =  userInfo.get("positionCode").toString();
//					CompanyName = userInfo.get("compName").toString();
//					UserName = userInfo.get("empName").toString();
//					PositionName = userInfo.get("positionName").toString();
//					DeptID = userInfo.get("deptSeq").toString();
//					DeptName = userInfo.get("deptName").toString();
//					GroupName = new String( "pstrGroupName" );
					
					userId = "admin";
					userName = "관리자";
					groupId =  "fresheasy";
					groupName = new String( "pstrGroupName" );
					companyName = "주식회사 프레시지";
					deptID = "1000-5000000";
					deptName = "기획조정실";
					positionId =  "1000-POSITION";
					positionName = "임시";
				}
				else {
					userId = loginVO.getId();
					userName = loginVO.getName();
					groupId =  loginVO.getGroupSeq();
					groupName = new String( "pstrGroupName" );
					companyName = loginVO.getOrganNm();
					deptID = loginVO.getOrgnztId();
					deptName = loginVO.getOrgnztNm();
					positionId =  loginVO.getPositionCode();
					positionName = loginVO.getPositionNm();
				}
			}
			catch(Exception e) {
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("인사정보 세팅 오류입니다.");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			
			String strEncFilePath = fileOrgPath;
			String resultPath = fileOrgPath + "/" + fileName;
			
			// 추가경로에 암호화 파일 생성
			if(!overWrite) {
				
				strEncFilePath += "/drmEncTemp";

				//변환파일이 이미 존재할 경우 기존파일 리턴
				if(new File(strEncFilePath + "/" + fileName).exists()){
					return strEncFilePath + "/" + fileName;
				}			
				
				// 폴더 없는 경우 생성
				File desti = new File(strEncFilePath);
				if(!desti.exists()) {
					desti.mkdirs();
				}
				
			}
			
			Madn clMadn = null; // 클래스 생성 준비
			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			String strRetCode = "";
			
			long outFileLength = 0;
			File orgFile = new File( resultPath ); // 암호화 대상 평문 파일
			File encFile = new File( strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName ); // 암호화 결과로 생성할 파일

			if( orgFile.length( ) == 0 )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("ERR 파일크기 에러입니다.");
				return "";
			}

			try
			{
				in = new BufferedInputStream( new FileInputStream( orgFile ) );
				out = new BufferedOutputStream( new FileOutputStream( encFile ) );
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("스트림 객체 생성 에러입니다.");
				return "";
			}

			// create instance
			// 암호화 클래스 생성
			try
			{	
				String drmInfoPath = BizboxAProperties.getCustomProperty("BizboxA.DrmInfoDatPath");
				clMadn = new Madn( drmInfoPath ); // 연동 시 절대경로로 변경
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("마크애니 암호화 클래스 생성 에러입니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("MarkAnyDrmInfo.dat 파일의 경로와 권한을 확인 해 주세요.");
				encFile.delete();
				return "";
			}
			
			/**
			 * 인사정보 필수 파라미터 세팅
			 * 1. 세션이 있는 경우 세션의 사용자 정보 세팅
			 * 2. 세션이 없는 경우 파라미터로 전달받은 정보로 세팅
			 */
//			String	pstrUserId = new String( "user02" );
//			String	pstrGroupId =  new String( "pstrGroupId" );
//			String	pstrPositionId =  new String( "pstrPositionId" );
//			String	pstrCompanyName = new String( "프레시지" );
//			String	pstrPositionName = new String( "pstrPositionName" );
//			String	pstrUserName = new String( "drm001" );
//			String	strDeptID = new String( "" );
//			String	strDeptName = new String( "" );
//			String	pstrGroupName = new String( "pstrGroupName" );
			
			String	pstrUserId = userId == null ? "" : userId;
			String	pstrGroupId =  groupId == null ? "" : groupId;
			String	pstrPositionId = positionId == null ? "" : positionId;
			String	pstrCompanyName = companyName == null ? "" : companyName;
			String	pstrPositionName = positionName == null ? "" : positionName;
			String	pstrUserName = userName == null ? "" : userName;
			String	strDeptID = deptID == null ? "" : deptID;
			String	strDeptName = deptName == null ? "" : deptName;
			String	pstrGroupName = groupName == null ? "" : groupName;
			
			// drm_option1, drm_option2 --> t_co_group 테이블 참조
			// drmOptionVal2 : companyId|enterpriseId
			String  pstrCompanyId = new String( drmOptionVal2.split("\\|")[0] );
			String  pstrEnterpriseID = new String( drmOptionVal2.split("\\|")[1] );
			String	strCreatorCompanyId = new String( drmOptionVal2.split("\\|")[0] );
			String	strCreatorDeptId = new String( "mark2" ); //고정
			String	strCreatorGroupId = new String( "mark3" ); //고정
			String	strCreatorPositionId = new String( "mark4" ); //고정
			
			// 고정값
			String	pstrFileName = new String( fileName );
			long plFileSize = orgFile.length( ); // 원본(암호화 대상 파일) 파일 크기를 가져옵니다.
			int		piAclFlag = 0; 
			String	pstrDocLevel = new String( "0" );
			String	pstrOwnerId = new String( "pstrOwnerId" );
			String	pstrGrade =  new String( "pstrGrade" );
			String	pstrFileId = new String( fileName );
			int		piCanSave = 0;
			int		piCanEdit = 0;
			int		piBlockCopy = 0;
			int		piOpenCount = -99;
			int		piPrintCount = -99;
			int		piValidPeriod = -99;
			int		piSaveLog = 1;
			int		piPrintLog = 1;
			
			int		piOpenLog = 1;
			int		piVisualPrint = 1;
			int		piImageSafer = 1;
			int		piRealTimeAcl = 0;
			String	pstrDocumentTitle = new String( "" );
			String	pstrUserIp = new String( "127.0.0.1" );
			String	pstrServerOrigin = new String( "대한민국" );
			int		piExchangePolicy = 1;
			int		piDrmFlag = 0;
			int		iBlockSize = 0;	
			String	strMachineKey = new String( "" );
			String	strFileVersion = new String( "" );
			String	strMultiUserID = new String( "userid;userid2;length_test;userid_markany1234567890;userid_markany1234567890;userid_markany1234567890;userid_markany1234567890;userid_markany1234567890;long_userid_test;" );
			String	strMultiUserName = new String( "strSecurityLevelName;multiusername1;multiusername2;multiusername3;multiusername4;multiusername5;multiusername6;multiusername7;multiusername8;multiusername9;multiusername10;" );
			String	strEnterpriseName = new String( "" );
			String	strPositionLevel = new String( "" );
			String	strSecurityLevel = new String( "1" );
			String	strSecurityLevelName = new String( "" );
			String	strPgCode = new String( "" );
			String	strCipherBlockSize = new String( "16" );
			String	strCreatorID = new String( "" );
			String	strCreatorName = new String( "" );
			String	strOnlineContorl = new String( "0" );
			String	strOfflinePolicy = new String( "" );
			String	strValidPeriodType = new String( "" );
			String	strUsableAlways = new String( "0" );
			String	strPriPubKey = new String( "" );
			String	strFileSize = new String( "4567" );
			String	strHeaderUpdateTime = new String( "" );
			String	strReserved01 = new String( "reserved01" );
			
			String	strReserved02 = new String( "reserved02" );
			String	strReserved03 = new String( "reserved03" );
			String	strReserved04 = new String( "reserved04" );
			String	strReserved05 = new String( "reserved05" );
			
			// 암호화 및 파라미터 점검을 합니다.
			try
			{
				outFileLength = 
					clMadn.lGetEncryptFileSize
					(
						piAclFlag, // ACL 참조 방식( 고정값 0 )
						pstrDocLevel, // 암호화 문서 등급 ( 고정값 0 )
						pstrUserId, // 사용자 ID
						pstrFileName, // 파일 이름
						plFileSize, // 암호화하려는 원본 파일 크기
						pstrOwnerId, // 암호화 대상 파일 소유자
						pstrCompanyId, // 회사코드 ID
						pstrGroupId, // 그룹코드 ID
						pstrPositionId, // 직위코드 ID
						pstrGrade, // 등급
						pstrFileId, // 파일 고유 ID
						piCanSave, // 저장 권한 (가능 1, 불가 0)
						piCanEdit, // 수정 권한 (가능 1, 불가 0)
						piBlockCopy, // 블룩복사 권한 (가능 1, 불가 0)
						piOpenCount,// 열람 가능 회수 (회수 또는 제한없음 -99)
						piPrintCount, // 출력 가능 회수 (회수 또는 제한없음 -99)
						piValidPeriod, // 문서 사용 가능 기간(기간 또는 제한없음 -99)
						piSaveLog, // 저장 로그 (가능 1, 불가 0)
						piPrintLog, // 출력 로그 (가능 1, 불가 0)
						piOpenLog, // 열람 로그 (가능 1, 불가 0)
						piVisualPrint, // 인쇄시 워터마크 적용(적용1, 미적용 0)
						piImageSafer, // 캡쳐방지 적용(적용1, 미적용 0)
						piRealTimeAcl, // 사용하지 않음
						pstrDocumentTitle, // 문서 제목
						pstrCompanyName, // 회사명
						pstrGroupName, // 그룹명
						pstrPositionName, // 직위명
						pstrUserName, // 사용자 이름
						pstrUserIp, // 사용자 PC IP
						pstrServerOrigin, // 시스템명
						
						piExchangePolicy, // 암호화 문서 정책 ( 고정값 1 )
						piDrmFlag, // 암호화 여부( 고정값 0 )
						iBlockSize, // 블럭크기 ( 고정값 0 )
						strMachineKey, // 머신키

						strFileVersion, // 암호화 파일 버전
						strMultiUserID, // 다중 사용자 ID
						strMultiUserName, // 다중 사용명
						pstrEnterpriseID, // 회사 대표 ID(?)
						strEnterpriseName, // 회사 대표명
						strDeptID, // 부서코드 ID
						strDeptName, // 부서명
						strPositionLevel, // 직위레벨
						strSecurityLevel, // 보안레벨
						strSecurityLevelName, // 보안레벨명
						strPgCode, // 사용하지 않음
						strCipherBlockSize, // 사이퍼블럭크기 ( 고정값 16 )
						strCreatorID, // 생성자 ID
						strCreatorName, // 생성자 이름
						strOnlineContorl, // 고정값 0
						strOfflinePolicy, // 고정값
						
						strValidPeriodType, // 고정값
						strUsableAlways, // 고정값 0
						strPriPubKey, // 고정값
						strCreatorCompanyId, // 생성자 회사코드 ID
						strCreatorDeptId, // 생성자 부서코드 ID
						strCreatorGroupId, // 생성자 그룹코드 ID
						strCreatorPositionId, // 생성자 직위코드 ID
						strFileSize, // 원본파일크기
						strHeaderUpdateTime, //	헤더업데이트시간
						strReserved01, // 지정 필드1
						strReserved02, // 지정 필드2
						strReserved03, // 지정 필드3
						strReserved04, // 지정 필드4
						strReserved05, // 지정 필드5
						in
					);
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("lGetEncryptFileSize 암호화 메소드 Exception Error. Exception = [" + e.toString( ) + "]");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("NumberFormat, NullPointer Exception일 경우 MarkAnyDrmInfo.dat 파일의 경로와 권한을 확인 해 주세요.");
				encFile.delete();
				return "";
			}

			// 암호화 준비를 합니다.
			if( outFileLength > 0 )
			{
				// 암호화 합니다.
				strRetCode = clMadn.strMadn( out );
			}
			else // 암호화 시작전 에러가 발생했습니다.
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("암호화 시작 전에 실패 하였습니다.");
				strRetCode = clMadn.strGetErrorCode( );
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("[ErrorCode] = [" + strRetCode + "]"
																				+ "[ErrorDescription] = ["
																				+ clMadn.strGetErrorMessage(strRetCode) + "]");
				
				encFile.delete();
				return "";
			}
			
			if( strRetCode.equals( "00000" ) )
			{	
				// 암호화를 성공하였습니다.
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("암호화에 성공 하였습니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("RetCode = [" + strRetCode + "]");
				
				//overwrite : Y -> 기존파일 지움
				if(overWrite){
					if(encFile.exists()){
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strEncFilePath + "/" + fileName;
				}
				
				return resultPath;
			}
			else
			{
				// 암호화에 실패했습니다.
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("암호화에 실패 하였습니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("[ErrorCode] = [" + strRetCode + "]"
																				+ "[ErrorDescription] = ["
																				+ clMadn.strGetErrorMessage(strRetCode) + "]");
				
				encFile.delete();
				return "";
			}
		}
		else {
			
			String strEncFilePath = fileOrgPath;
			String resultPath = fileOrgPath + "/" + fileName;
			
			// 추가경로에 암호화 파일 생성
			if(!overWrite) {
				
				strEncFilePath += "/drmEncTemp";

				//변환파일이 이미 존재할 경우 기존파일 리턴
				if(new File(strEncFilePath + "/" + fileName).exists()){
					return strEncFilePath + "/" + fileName;
				}			
				
				// 폴더 없는 경우 생성
				File desti = new File(strEncFilePath);
				if(!desti.exists()) {
					desti.mkdirs();
				}
				
			}
			
			int iFileStreamType = 1; // file stream
			
//			String strSoruceFileName = resultPath; 		   // 암호화 대상 파일
//			String strResultFileName = strEncFilePath;	   // 암호화 결과 파일
			
			File orgFile = new File( resultPath ); // 암호화 대상 평문 파일
			
			String encFilePath = strEncFilePath + "/" + (overWrite ? "drmEncTemp_" : "") + fileName;
			File encFile = new File( encFilePath ); // 암호화 결과로 생성할 파일
			
			BufferedInputStream bis = null;
			BufferedOutputStream bos = null;
			
			long lFileSize = 0;
			int iRet = 0;
			
//			File FileSample = new File(strSoruceFileName);
			lFileSize = orgFile.length();
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("lFileSize: " + lFileSize);
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("orgFilePath >> " + resultPath);
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("encFilePath >> " + encFilePath);
			
			// input, ouput stream 생성..
			if( iFileStreamType == 1 ) 
			{
				try
				{
					bis = new BufferedInputStream(new FileInputStream(resultPath));
					bos = new BufferedOutputStream(new FileOutputStream(encFilePath));
				}
				catch( Exception e )
				{	
					resultPath = "";
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("file stream open exception : " + e.toString());
					return resultPath;
				}
			}
			
			String resultCode = "";
			try {
				
				long beforetime = System.currentTimeMillis();
				String drmInfoPath = BizboxAProperties.getCustomProperty("BizboxA.DrmInfoDatPath");
				MaDrmDocSafer drm = new MaDrmDocSafer(drmInfoPath);
				
				if( iFileStreamType == 1 ) 
				{
					iRet = drm.iSetData( MaDrmDocSafer.iSOURCEFILE, bis );
					iRet = drm.iSetData( MaDrmDocSafer.iRESULTFILE, bos );
				}
		
				iRet = drm.iSetData( MaDrmDocSafer.iFILESIZE, String.valueOf(lFileSize) ); // essential
				iRet = drm.iSetData( MaDrmDocSafer.iFILENAME, fileName ); // essential
		
				drm.iPerformance = 0;
				iRet = drm.iMarkAnyDocSafer( MaDrmDocSafer.iDrmEncrypt );
		
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("iRet = [" + iRet + "]");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("iGetDrmError() = [" + drm.iGetDrmError() + "]");  // iGetDrmError : 암호화 결과 리턴 코드
				resultCode = drm.strGetDrmError();
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("strGetDrmError() = [" + resultCode + "]");
				String numberAsString = new DecimalFormat("0.00").format((System.currentTimeMillis() - beforetime) * 0.001);
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("processing time: " + numberAsString + "sec");
			}
			catch(Exception e) {
				resultPath = "";
				encFile.delete();
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			
			// 암호화 성공
			if(resultCode.equals("00000")) {
				
				//overwrite : Y -> 기존파일 지움
				if(overWrite){
					if(encFile.exists()){
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strEncFilePath + "/" + fileName;
				}
			}
			// 암호화 파일 암호화 시도
			else if(resultCode.equals("60042")) {
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("암호화 파일 암호화 시도");
				encFile.delete();
			}
			// 암호화 실패
			else {
				encFile.delete();
				resultPath = "";
			}
			
			if( iFileStreamType == 1 )
			{
				try
				{
					if(bis!=null)bis.close();
					if(bos!=null) {bos.flush();
					bos.close();}
				}
				catch( Exception e )
				{
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("file stream close exception : " + e.toString());
						
				}
			}
			return resultPath;
			
		}
		
	}	
	
	@SuppressWarnings("resource")
	private String maDrmDecoding( String drmOptionVal1, boolean overWrite, String fileOrgPath, String fileName) throws FileNotFoundException{
		
		
		String strDecFilePath = fileOrgPath;
		String resultPath = fileOrgPath + "/" + fileName;
		
		if(!overWrite) {
			
			strDecFilePath += "/drmDecTemp";

			//변환파일이 이미 존재할 경우 기존파일 리턴
			if(new File(strDecFilePath + "/" + fileName).exists()){
				return strDecFilePath + "/" + fileName;
			}		
			
			File desti = new File(strDecFilePath);
			if(!desti.exists()) {
				desti.mkdirs();	
			}
		}	
		
		Madec clMadec = null; // 클래스 생성 준비
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		String strRetCode = "";
		
		// Sample Parameter
		String orgFileName = new String( fileName ); // 복호화 파일 명( 임의의 값 )
		File orgFile = new File( resultPath ); // 복호화 대상 파일
		File encFile = new File( strDecFilePath + "/" + (overWrite ? "drmDecTemp_" : "") + fileName ); // 복호화 결과로 생성할 파일
		long outFileLength = 0;
		
		if(drmOptionVal1.equals("v1")) {
			
			if( orgFile.length( ) == 0 )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("ERR 파일크기 에러입니다.");
				return "";
			}

			try
			{
				in = new BufferedInputStream( new FileInputStream( orgFile ) );
				out = new BufferedOutputStream( new FileOutputStream( encFile ) );
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("스트림 객체 생성 에러입니다.");
				encFile.delete();
				return "";
			}

			// create instance
			// 복호화 클래스 생성
			try
			{
				String drmInfoPath = BizboxAProperties.getCustomProperty("BizboxA.DrmInfoDatPath");
				clMadec = new Madec( drmInfoPath ); // 연동 시 절대경로로 변경
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("마크애니 복호화 클래스 생성 에러입니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("MarkAnyDrmInfo.dat 파일의 경로와 권한을 확인 해 주세요.");
				encFile.delete();
				return "";
			}

			// 복호화 대상 파일의 크기를 가져옵니다.
			long lFileLen = orgFile.length( );

			// 복호화 및 파라미터 점검을 합니다.
			try
			{
				outFileLength = clMadec.lGetDecryptFileSize( orgFileName, lFileLen, in );
			}
			catch( Exception e )
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("lGetDecryptFileSize 복호화 메소드 Exception Error. Exception = [" + e.toString( ) + "]");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("NumberFormat, NullPointer Exception일 경우 MarkAnyDrmInfo.dat 파일의 경로와 권한을 확인 해 주세요.");
				encFile.delete();
				return "";
			}

			// 복호화 준비를 합니다.
			if( outFileLength > 0 )
			{
				// 복호화 합니다.
				strRetCode = clMadec.strMadec( out );
			}
			else // 복호화 시작전 에러가 발생했습니다.
			{
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("복호화 시작 전에 실패 하였습니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("ERR [ErrorCode] = [" + strRetCode + "]"
																				+ "[ErrorDescription] = ["
																				+ clMadec.strGetErrorMessage(strRetCode) + "]");
				encFile.delete();
				return "";
			}

			if( strRetCode.equals( "00000" ) )
			{	
				// 복호화를 성공했습니다.
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("복호화에 성공 하였습니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("RetCode = [" + strRetCode + "]");
				if(overWrite){
					if(encFile.exists()){
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strDecFilePath + "/" + fileName;
				}
				
				return resultPath;
			}
			else
			{
				// 복호화에 실패했습니다.
				encFile.delete( );
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("복호화에 실패 하였습니다.");
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("ERR [ErrorCode] = [" + strRetCode + "]"
																				+ "[ErrorDescription] = ["
																				+ clMadec.strGetErrorMessage(strRetCode) + "]");
				encFile.delete();
				return "";
			}
		}
		else {
			
			int iFileStreamType = 1; // file stream
			
			BufferedInputStream bis = null;
			BufferedOutputStream bos = null;
	
			long lFileSize = 0;
			int iRet = 0;
	
			lFileSize = orgFile.length();
			
			if( iFileStreamType == 1 )
			{
				try
				{
					bis = new BufferedInputStream(new FileInputStream(orgFile));
					bos = new BufferedOutputStream(new FileOutputStream(encFile));
				}
				catch( Exception e )
				{
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("file stream open exception : " + e.toString());
				}
			}
			
			long beforetime = System.currentTimeMillis();
			
			String drmInfoPath = BizboxAProperties.getCustomProperty("BizboxA.DrmInfoDatPath");
			MaDrmDocSafer drm = new MaDrmDocSafer( drmInfoPath );
			
			if( iFileStreamType == 1 )
			{
				iRet = drm.iSetData( MaDrmDocSafer.iSOURCEFILE, bis );
				iRet = drm.iSetData( MaDrmDocSafer.iRESULTFILE, bos );
			}
	
			iRet = drm.iSetData( MaDrmDocSafer.iFILESIZE, String.valueOf(lFileSize) );
			
			drm.iPerformance = 0;
	
			iRet = drm.iMarkAnyDocSafer( MaDrmDocSafer.iDrmDecrypt );
	
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("iRet = [" + iRet + "]");
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("iGetDrmError() = [" + drm.iGetDrmError() + "]");
			String resultCode = drm.strGetDrmError();
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("strGetDrmError() = [" + resultCode + "]");
			String numberAsString = new DecimalFormat("0.00").format((System.currentTimeMillis() - beforetime) * 0.001);
			org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("processing time: " + numberAsString + "sec");
			
			// 복호화 성공
			if(resultCode.equals( "00000")) {
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("DRM 복호화 성공");
				if(overWrite){
					if(encFile.exists()){
						if(orgFile.exists()){
							orgFile.delete();
						}
						encFile.renameTo(new File(resultPath));
					}
				}else{
					resultPath = strDecFilePath + "/" + fileName;
				}
			}
			// 일반 파일 복호화인 경우 return 값
			else if( resultCode.equals("0") ) {
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("일반 파일 복호화 시도");
				encFile.delete();
			}
			// 복호화 실패
			else {
				org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("복호화 실패");
				encFile.delete();
				resultPath = "";
				
			}
			
			if( iFileStreamType == 1 )
			{
				try
				{
					bis.close();
					bos.flush();
					bos.close();
				}
				catch( Exception e )
				{
					org.apache.log4j.Logger.getLogger( DrmServiceImpl.class ).info("file stream close exception : " + e.toString());
				}
			}
			
			return resultPath;
		}
		
	}		

}
