package restful.mobile.vo;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="content")
public class ResultVO implements Serializable{
	
	private String resultCode = "";		  				// 결과코드
	private String resultMessage = "";					// 결과메시지
	private String tId = "";								// 호출 서비스
	
	public String getResultCode() {
		return resultCode;
	}
	public String getResultMessage() {
		return resultMessage;
	}
	public String gettId() {
		return tId;
	}
	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}
	public void settId(String tId) {
		this.tId = tId;
	}
}
