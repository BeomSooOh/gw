package neos.cmm.file.vo;

/**
 * 
 * @title 파일 업로드 팝업 관련 VO
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 6. 7.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 6. 7.  박기환        최초 생성
 *
 */
public class FileUploadVO {

	/**
	 * 파일 업로드 ID
	 */
	private String atchFileId = "";
	
	/**
	 * 이미지 보여주는 div 지정 
	 */
	private String imgDiv = "";
	
	/**
	 * 파일 이름
	 */
	private String imgFile = "";
	
	/**
	 * 팝업창 title
	 */
	private String popupTitle = "";

	/**
	 * 업로드 타입
	 */
	private String uploadType = "";
	
	/**
	 *	실행 메소드 
	 */
	private String commitMethod = "";
	
	/**
	 * atchFileId attribute 값을 리턴한다.
	 * @return atchFileId
	 */
	public String getAtchFileId() {
		return atchFileId;
	}

	/**
	 * atchFileId attribute 값을 설정한다.
	 * @param atchFileId String
	 */
	public void setAtchFileId(String atchFileId) {
		this.atchFileId = atchFileId;
	}

	/**
	 * imgDiv attribute 값을 리턴한다.
	 * @return imgDiv
	 */
	public String getImgDiv() {
		return imgDiv;
	}

	/**
	 * imgDiv attribute 값을 설정한다.
	 * @param imgDiv String
	 */
	public void setImgDiv(String imgDiv) {
		this.imgDiv = imgDiv;
	}

	/**
	 * imgFile attribute 값을 리턴한다.
	 * @return imgFile
	 */
	public String getImgFile() {
		return imgFile;
	}

	/**
	 * imgFile attribute 값을 설정한다.
	 * @param imgFile String
	 */
	public void setImgFile(String imgFile) {
		this.imgFile = imgFile;
	}

	/**
	 * popupTitle attribute 값을 리턴한다.
	 * @return popupTitle
	 */
	public String getPopupTitle() {
		return popupTitle;
	}

	/**
	 * popupTitle attribute 값을 설정한다.
	 * @param popupTitle String
	 */
	public void setPopupTitle(String popupTitle) {
		this.popupTitle = popupTitle;
	}

	/**
	 * uploadType attribute 값을 리턴한다.
	 * @return uploadType
	 */
	public String getUploadType() {
		return uploadType;
	}

	/**
	 * uploadType attribute 값을 설정한다.
	 * @param uploadType String
	 */
	public void setUploadType(String uploadType) {
		this.uploadType = uploadType;
	}

	/**
	 * commitMethod attribute 값을 리턴한다.
	 * @return commitMethod
	 */
	public String getCommitMethod() {
		return commitMethod;
	}

	/**
	 * commitMethod attribute 값을 설정한다.
	 * @param commitMethod String
	 */
	public void setCommitMethod(String commitMethod) {
		this.commitMethod = commitMethod;
	}
	
	
}
