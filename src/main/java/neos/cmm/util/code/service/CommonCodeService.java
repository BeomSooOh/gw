package neos.cmm.util.code.service;

public interface CommonCodeService {
	
	public Object getCommonDetailCodeFlag1(String code, String detailCode, String field);
	
	public void updateCommonDetail(String code, String detailCode, String flag1, String flag2, String editSeq);
	
}
