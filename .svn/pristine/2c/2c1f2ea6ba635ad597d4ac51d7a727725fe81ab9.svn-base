package neos.cmm.encrypt;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.GeneralSecurityException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.sun.star.security.KeyException;

import egovframework.com.cmm.EgovMessageSource;
import neos.cmm.util.CommonUtil;

@Service("KOHISeed")
public class KOHISeed implements Encryptor{

    @Resource(name="egovMessageSource")
    EgovMessageSource egovMessageSource;
    
	@Override
	public String encrypt(String plainText)
			throws UnsupportedEncodingException, InvalidKeyException,
			NoSuchAlgorithmException, NoSuchPaddingException,
			InvalidAlgorithmParameterException, IllegalBlockSizeException,
			BadPaddingException {
		String returnStr = callWebService(plainText, "0");
		return returnStr;
	}

	@Override
	public String decrypt(String encryptedText) throws KeyException,
			GeneralSecurityException, GeneralSecurityException,
			InvalidAlgorithmParameterException, IllegalBlockSizeException,
			BadPaddingException, IOException {
		String returnStr = callWebService(encryptedText, "1");
		return returnStr;
	}

	
	private String callWebService(String text,String mode){
	String url = egovMessageSource.getMessage("Globals.getMenusso");
		
		
		String resultStr = "";
		String returnStr = "";
		try {
			URL iurl = new URL(url);
			HttpURLConnection uc = (HttpURLConnection)iurl.openConnection();		
			uc.addRequestProperty("Content-Type", "text/xml; charset=utf-8");
			uc.setRequestMethod("POST");
			uc.addRequestProperty("SOAPAction", "http://localhost/GPMIS_V1.5/WService/KOHI_GW");
			uc.addRequestProperty("Host", "pms.gntsoft.com");
			uc.setDoOutput(true);
			uc.setDoInput(true);
			
			String data ="<?xml version='1.0' encoding='utf-8'?>" +
			"<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>" +
			"  <soap:Body>" +
			"    <KOHI_GW xmlns='http://localhost/GPMIS_V1.5/WService/'>" +
			"      <str_P1>KOHI0</str_P1>" +
			"      <str_P2>CO000015</str_P2>" +
			"      <str_P3>"+text+"</str_P3>" +
			"      <str_P4>"+mode+"</str_P4>" +
			"      <str_P5>string</str_P5>" +
			"    </KOHI_GW>" +
			"  </soap:Body>" +
			"</soap:Envelope>";				
			
			byte[] out =data.getBytes("UTF-8");
			uc.addRequestProperty("Content-Length", out.length + "");
			OutputStream outStream = 	uc.getOutputStream();
			outStream.write(out);
			outStream.flush();
			outStream.close();
			
			uc.connect();
			InputStream stream = uc.getInputStream();
            int len = uc.getContentLength();
            byte[] resultContent = new byte[len];
            stream.read(resultContent, 0, len);
            
            resultStr = new String(resultContent, "UTF-8");
            
			DocumentBuilderFactory fac = DocumentBuilderFactory.newInstance();
			//부적절한 XML 외부 개체 참조 (XXE 공격)
			fac.setFeature("http://xml.org/sax/features/external-general-entities", false);
			fac.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
			fac.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
			DocumentBuilder builder = fac.newDocumentBuilder();
			
			Document doc = builder.parse(new InputSource(new StringReader(resultStr)));
			Element root = doc.getDocumentElement();
			NodeList result = root.getElementsByTagName("KOHI_GWResult");
			returnStr = result.item(0).getTextContent();            
					
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		
		
		
		
		return returnStr;
	}
	
}
