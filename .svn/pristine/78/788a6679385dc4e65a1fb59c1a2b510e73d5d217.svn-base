package neos.cmm.util.jstree;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 
 * @title jsTree 자바 객체 몸통 부분
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
public class NeosJsTree implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private Attr attr;

	private Data data;

	private String state;

	public ArrayList<NeosJsTree> children;

	
	public NeosJsTree(){
		
	}
	
	public NeosJsTree(TreeDaoVO treeVO){
		attr = new Attr(treeVO);												
		data = new Data(treeVO);
		setState(treeVO.getState());
	}
	
	public Attr getAttr() {
		return attr;
	}

	public void setAttr(Attr attr) {
		this.attr = attr;
	}

	public Data getData() {
		return data;
	}

	public void setData(Data data) {
		this.data = data;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public ArrayList<NeosJsTree> getChildren() {
		return children;
	}

	public void setChildren(ArrayList<NeosJsTree> children) {
		this.children = children;
	}
	
	public void setAddChildren(NeosJsTree childNode){
		this.children.add(childNode);
	}
}
