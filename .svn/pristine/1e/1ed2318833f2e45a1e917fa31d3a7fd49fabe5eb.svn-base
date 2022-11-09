package api.common.model;

import org.codehaus.jackson.annotate.JsonIgnore;

public class APIResponse {
	private String resultCode;
	private String resultMessage;
	private Object result;
	
	public String getResultCode() {
		return resultCode;
	}
	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	public String getResultMessage() {
		return resultMessage;
	}
	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}
	public Object getResult() {
		return result;
	}
	public void setResult(Object result) {
		this.result = result;
	}
	
	@JsonIgnore
	public String getResultString() {
		return "resultCode=" + resultCode + ", resultMessage=" + resultMessage;
	}
	
	@Override
	public String toString() {
		return "APIResponse [resultCode=" + resultCode + ", resultMessage=" + resultMessage + ", result=" + result
				+ "]";
	}
}
