package api.common.exception;

public class APIException extends RuntimeException {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3254595443149980209L;

	private String errorCode;
	
	private String errorMessage;

	public APIException(String errorCode) {
		super();
		this.errorCode = errorCode;
	}

	public APIException(String errorCode, String errorMessage) {
		super();
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
}
