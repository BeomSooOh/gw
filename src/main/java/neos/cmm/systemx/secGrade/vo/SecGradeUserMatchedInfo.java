package neos.cmm.systemx.secGrade.vo;

public class SecGradeUserMatchedInfo {
	private boolean isMatched;//매칭됐는지
	private String originSecId;//입력받은 보안등급코드
	private String matchedSecId;//매칭된 보안등급코드
	public boolean isMatched() {
		return isMatched;
	}
	public void setMatched(boolean isMatched) {
		this.isMatched = isMatched;
	}
	public String getOriginSecId() {
		return originSecId;
	}
	public void setOriginSecId(String originSecId) {
		this.originSecId = originSecId;
	}
	public String getMatchedSecId() {
		return matchedSecId;
	}
	public void setMatchedSecId(String matchedSecId) {
		this.matchedSecId = matchedSecId;
	}
}
