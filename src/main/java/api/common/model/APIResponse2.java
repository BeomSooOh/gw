package api.common.model;

import org.codehaus.jackson.annotate.JsonIgnore;

public class APIResponse2 {
	private int resultCode;
	private String resultMsg;
	private Object resultData;
	
	public int getResultCode() {
		return resultCode;
	}
	public void setResultCode(int resultCode) {
		this.resultCode = resultCode;
	}
	public String getResultMessage() {
		return resultMsg;
	}
	public void setResultMessage(String resultMessage) {
		this.resultMsg = resultMessage;
	}
	public Object getResult() {
		return resultData;
	}
	public void setResult(Object result) {
		this.resultData = result;
	}
	
	@JsonIgnore
	public String getResultString() {
		return "resultCode=" + resultCode + ", resultMessage=" + resultMsg;
	}
}
