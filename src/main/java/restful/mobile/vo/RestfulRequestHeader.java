package restful.mobile.vo;

public class RestfulRequestHeader {

	private String groupSeq;
	private String empSeq;
	private String tId;
	private String pId;

	public String getGroupSeq() {
		return groupSeq;
	}
	public void setGroupSeq(String groupSeq) {
		this.groupSeq = groupSeq;
	}

	public String getEmpSeq() {
		return empSeq;
	}
	public void setEmpSeq(String empSeq) {
		this.empSeq = empSeq;
	}

	public String gettId() {
		return tId;
	}
	public void settId(String tId) {
		this.tId = tId;
	}

	public String getpId() {
		return pId;
	}
	public void setpId(String pId) {
		this.pId = pId;
	}	
	
	
	@Override
	public String toString() {
		return "RestfulRequestHeader [groupSeq=" + groupSeq + ", empSeq=" + empSeq
				+ ", tId=" + tId + ", pId=" + pId + "]";
	}
}
