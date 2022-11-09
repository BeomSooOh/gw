package restful.mobile.vo;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="contents")
public class AppCntVO implements Serializable {

	private int appCnt = 0;

	public int getAppCnt() {
		return appCnt;
	}

	public void setAppCnt(int appCnt) {
		this.appCnt = appCnt;
	}
	
}
