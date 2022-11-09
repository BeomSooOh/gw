package restful.fund.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="contents")
public class FundVO implements Serializable {
	private String erpCompSeq = "";
	public List<Map<String, Object>> menuList = new ArrayList<Map<String,Object>>();
	public List<Map<String, Object>> erpBizCode = new ArrayList<Map<String,Object>>();
	
	public String getErpCompSeq() {
		return erpCompSeq;
	}
	public void setErpCompSeq(String erpCompSeq) {
		this.erpCompSeq = erpCompSeq;
	}
	public List<Map<String, Object>> getMenuList() {
		return menuList;
	}
	public void setMenuList(List<Map<String, Object>> menuList) {
		this.menuList = menuList;
	}
	public List<Map<String, Object>> getErpBizCode() {
		return erpBizCode;
	}
	public void setErpBizCode(List<Map<String, Object>> erpBizCode) {
		this.erpBizCode = erpBizCode;
	}
	
	@Override
	public String toString() {
		return "FundVO [erpCompSeq=" + erpCompSeq + ", menuList=" + menuList
				+ ", erpBizCode=" + erpBizCode + "]";
	}
}
