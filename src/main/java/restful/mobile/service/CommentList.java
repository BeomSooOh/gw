package restful.mobile.service;

import javax.xml.bind.annotation.XmlRootElement;

import restful.mobile.vo.CommentListVO;
import restful.mobile.vo.ResultVO;

@XmlRootElement(name="content")
public class CommentList extends ResultVO {
	/**
	 * 
	 */
	private static final long serialVersionUID = 622306958972103940L;
	CommentListVO result = new CommentListVO();

	public CommentListVO getResult() {
		return result;
	}
	public void setResult(CommentListVO result) {
		this.result = result;
	}
	
}
