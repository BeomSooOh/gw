package neos.cmm.popup.web;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.db.CommonSqlDAO;

import javax.annotation.Resource;
import javax.crypto.*;
import javax.crypto.spec.*;
import sun.misc.BASE64Decoder;
import java.net.URLDecoder;

@Controller
public class CmmPopupController {
	
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;		
	
	/**
	 * 공용 파일 업로드 팝업
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/popup/cmmFileUploadPop.do")
    public ModelAndView cmmFileUploadPop(@RequestParam Map<String,Object> paramMap) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	paramMap.put("title", CommonCodeUtil.getCodeName(paramMap.get("code")+"", paramMap.get("detailCode")+"", loginVO.getLangCode()));
    	
    	mv.addAllObjects(paramMap);
    	
    	mv.setViewName("/neos/cmm/popup/cmmFileUploadPop");
    	
    	return mv;
    }
	
	@RequestMapping("/cmm/popup/cmmFileDownloadPop.do")
    public ModelAndView cmmFileDownloadPop(@RequestParam Map<String,Object> paramMap) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	
    	LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
    	
    	paramMap.put("compSeq", loginVO.getCompSeq());
    	
    	if(paramMap.get("fileId") != null){
    		paramMap.put("fileUrl", "/gw/cmm/file/fileDownloadProc.do?fileId=" + paramMap.get("fileId").toString());
    	}else{
    		paramMap.put("fileUrl", URLDecoder.decode(paramMap.get("fileUrl").toString()));
    	}
    	
		//activeX 사용유무 설정값 가져오기
    	paramMap.put("optionId", "cm410");
		Object option = commonSql.select("CmmnCodeDetailManageDAO.getOptionSetValue", paramMap);
		
		if(option == null) {
			paramMap.put("activxYn", "N");
		}
		
		else{
			if(option.equals("1")){
				paramMap.put("activxYn", "Y");
				if(loginVO != null) {
					paramMap.put("loginId", loginVO.getId());
				}
			}
			else {
				paramMap.put("activxYn", "N");
			}
		}    	
    	
    	mv.addAllObjects(paramMap);
    	
    	mv.setViewName("/neos/cmm/popup/cmmFileDownloadPop");
    	
    	return mv;
    }	
	
    public static String Decrypt(String text, String key) throws Exception
    {
              Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
              byte[] keyBytes= new byte[16];
              byte[] b= key.getBytes("UTF-8");
              int len= b.length;
              if (len > keyBytes.length) {
            	  len = keyBytes.length;
              }
              System.arraycopy(b, 0, keyBytes, 0, len);
              SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");
              IvParameterSpec ivSpec = new IvParameterSpec(keyBytes);
              cipher.init(Cipher.DECRYPT_MODE,keySpec,ivSpec);

              BASE64Decoder decoder = new BASE64Decoder();
              byte [] results = cipher.doFinal(decoder.decodeBuffer(text));
              return new String(results,"UTF-8");
    }
	
	/**
	 * 공용 텍스트 입력 팝업
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/cmm/popup/cmmTextInputPop.do")
    public ModelAndView cmmTextInputPop(@RequestParam Map<String,Object> paramMap) throws Exception {
    	ModelAndView mv = new ModelAndView();
    	
    	mv.addAllObjects(paramMap);
    	
    	mv.setViewName("/neos/cmm/popup/cmmTextInputPop");
    	
    	return mv;
	}
}
