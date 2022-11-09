package neos.cmm.util.jstree;

import java.io.Serializable;

/**
 * 
 * @title jsTree 내에 attr 부분
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 5. 3.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 3.  박기환        최초 생성
 *
 */
public class Data implements Serializable {
	
	private static final long serialVersionUID = 1L;				

	private String title;
	
	private Attr attr;

	public Data(){
		
	}
	
	public Data(TreeDaoVO treeVO) {
		this.setData(treeVO);
	}		
	
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Attr getAttr() {
		return attr;
	}

	public void setAttr(Attr attr) {
		this.attr = attr;
	}
	
	public void setData(TreeDaoVO treeVO){
		
		attr = new Attr(treeVO);
		
		this.setAttr(attr);
		this.setTitle(treeVO.getContentNm());		
	}
	
}
