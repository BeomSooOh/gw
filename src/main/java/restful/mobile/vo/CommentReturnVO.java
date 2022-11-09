package restful.mobile.vo;

import java.io.Serializable;
import javax.xml.bind.annotation.XmlRootElement;
//import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="contents")
public class CommentReturnVO implements Serializable {

	private int returnCode = 1;

	public int getReturnCode() {
		return returnCode;
	}

	public void setReturnCode(int returnCode) {
		this.returnCode = returnCode;
	}	
	
}
