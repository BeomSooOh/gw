package neos.cmm.systemx.secondCertificate.service.impl;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.secondCertificate.service.SecondCertificateService;
import neos.cmm.util.AESCipher;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.NeosConstants;
import net.sf.json.JSONObject;

@Service("SecondCertificateService")
public class SecondCertificateServiceImpl implements SecondCertificateService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	public Map<String, Object> setQrCodeInfo(Map<String, Object> params)
			throws Exception {
		
		String qrData = "";
		String type = (String) (params.get("type") == null ? 'L' : params.get("type"));
		String devType = params.get("devType") == null ? "" : params.get("devType").toString();
		String sUUID = commonSql.select("MsgDAO.getToken", params) + "";
		sUUID = sUUID.replaceAll("-", "");
		
		Map<String, Object> keyMap = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKeyNum", params);
		String keyNum =  keyMap.get("keyNum") + "";
		
		params.put("keyNum", keyNum);
		Map<String, Object> keyInfoMap = (Map<String, Object>) commonSql.select("SecondCertManage.getSecondCertKey", params);
		String key = keyInfoMap.get("key") + "";
		
		
		if(type.equals("L")){
			//이차 인증기기 등록여부 확인.
			params.put("status", "P");
			if(devType.equals("1")) {
				params.put("devType", devType);
			}
			List<Map<String, Object>> devList = commonSql.list("SecondCertManage.selectSecondCertDeviceList", params);
			
			if(devList.size() > 0 || (params.get("msgYn") != null && params.get("msgYn").toString().equals("Y"))){
				//이차인증
				type = "L";
				qrData += "#bmv2;";
			}else{
				//인증기기 리스트중 핀번호확인 전인 리스트는 모두 삭제처리
				commonSql.delete("SecondCertManage.deleteDeviceList", params);
				
				//기기등록
				type = "D";				
				if(devType.equals("1")) {
					qrData += "#bmv1;";			//인증기기
				}
				else {
					qrData += "#bmv3;";			//사용기기
				}
			}
		}else{
			//인증기기 리스트중 핀번호확인 전인 리스트는 모두 삭제처리
			commonSql.delete("SecondCertManage.deleteDeviceList", params);
			
			if(devType.equals("1")) {
				qrData += "#bmv1;";
			}
			else {
				qrData += "#bmv3;";
			}
		}
		
		params.put("keyNum", keyNum);
		params.put("UUID", sUUID);
		params.put("status", "R");		
		params.put("type", type);
		
		//qr코드 생성시 해당 사용자에대한 기존 인증시퀀스 정보는 모두 제거후 등록
		commonSql.delete("SecondCertManage.deleteSecondCertInfo", params);
		commonSql.insert("SecondCertManage.insertSecondCertInfo", params);
		
		String seq = (String) commonSql.select("SecondCertManage.getSecondCertSeq", params);
		
		qrData += seq + ";" + keyNum + ";" + AESCipher.AES256_Encode(sUUID, key);
		
		//qr코드 저장경로 지정
		params.put("osType", NeosConstants.SERVER_OS);
		params.put("pathSeq", "900");
		Map<String, Object> pathMap = (Map<String, Object>) commonSql.select("AttachFileUpload.selectGroupPathInfo", params);
		
		String path = pathMap.get("absolPath") + "";
		String empSeq = params.get("empSeq") + "";
		
		if(type.equals("L")) {
			path = path + "/scQrImg/" + params.get("empSeq") + "/";
		}
		else if(type.equals("D")) {
			path = path + "/scQrImg/" + params.get("empSeq") + "/device/";
		}
		
		try {
			File file = null;
			// 큐알이미지를 저장할 디렉토리 지정
			file = new File(path);
			if (!file.exists()) {
				file.mkdirs();
			}
			// 코드인식시 데이터 셋팅
			String codeurl = new String(qrData.getBytes("UTF-8"),"ISO-8859-1");
			// 큐알코드 바코드 생상값
			int qrcodeColor = 0xff000000;
			// 큐알코드 배경색상값
			int backgroundColor = 0xFFFFFFFF;

			QRCodeWriter qrCodeWriter = new QRCodeWriter();
			// 3,4번째 parameter값 : width/height값 지정
			BitMatrix bitMatrix = qrCodeWriter.encode(codeurl,BarcodeFormat.QR_CODE, 230, 230);
			//
			MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor, backgroundColor);
			BufferedImage bufferedImage = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);
			
			path = path + empSeq + ".png";
			
			// ImageIO를 사용한 바코드 파일쓰기
			ImageIO.write(bufferedImage, "png", new File(path));

		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		if(NeosConstants.SERVER_OS.equals("linux")){
			path = path.substring(path.indexOf("/", 2));
		}
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("qrData", path);
		result.put("seq", seq);
		result.put("type", type);
		
		return result;
	}

	
	public void secondCertTokenLogOut(Map<String, Object> params){			
			//API호출
			//token으로 사용자 시퀀스 가져오기
			JSONObject jsonObj = new JSONObject();
			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			
			header.put("companyId", "");
			header.put("userId", "");
			header.put("token", "");
			header.put("tId", "");
			header.put("pId", "");
			header.put("appType", params.get("appType"));
			body.put("groupSeq", params.get("groupSeq"));
			body.put("token", params.get("token"));
			
			jsonObj.put("header", header);
			jsonObj.put("body", body);
	
			String apiUrl = params.get("oneffice_token_api_url").toString() + "/BizboxMobileGateway/service/LogoutTokenRemote";
			
			try{
				Logger.getLogger( SecondCertificateServiceImpl.class ).debug( "SecondCertificateServiceImpl secondCertTokenLogOut.  jsonObj : " + jsonObj + "    apiUrl : " + apiUrl);
				callApiToMap(jsonObj, apiUrl);
			}catch(Exception e){
				Logger.getLogger( SecondCertificateServiceImpl.class ).error( "SecondCertificateServiceImpl secondCertTokenLogOut.  jsonObj : " + jsonObj + "    apiUrl : " + apiUrl);
				Logger.getLogger( SecondCertificateServiceImpl.class ).error( "SecondCertificateServiceImpl secondCertTokenLogOut.  error : " + e);
			}
	}
	
	 public Map<String, Object> callApiToMap(JSONObject jsonObject, String url) throws JsonParseException, JsonMappingException, IOException{
		 HttpJsonUtil httpJson = new HttpJsonUtil();
		 @SuppressWarnings("static-access")
		 String returnStr = httpJson.execute("POST", url, jsonObject);
		 ObjectMapper om = new ObjectMapper();
		 Map<String, Object> m = om.readValue(returnStr, new TypeReference<Map<String, Object>>(){});
		 return m;
	 }	
	
}
