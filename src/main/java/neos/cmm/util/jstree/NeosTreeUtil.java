package neos.cmm.util.jstree;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.utl.fcc.service.EgovStringUtil;

/**
 * 
 * @title jSTree의 json 규격에 맞게 변환 해주는 객체
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 5. 4.
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2012. 5. 4.  박기환        최초 생성
 *
 */
@Repository("treeUtil")
public class NeosTreeUtil {

	/**
     * 트리구조를 만든다.
     * 
     * @param String startId 
     * @return ModelAndView mv
     * @throws Exception
     */
	public ArrayList<NeosJsTree> makeTree(List<TreeDaoVO> resultTree){
		
		int resultCount = resultTree.size();
		ArrayList<NeosJsTree> nodeList = new ArrayList<NeosJsTree>();
		NeosJsTree parNode = null;
		
		for(int i=0;i<resultCount;i++){
			
			TreeDaoVO treeVO = resultTree.get(i);
			
			if(i==0){	//최상위 메뉴
				
				parNode = new NeosJsTree(treeVO);
				
				nodeList.add(parNode);
										
				setChildNode(parNode, treeVO.getContentId(), resultTree);
			}
		}
		
		return nodeList;
	}
	
	/**
     * 하위 트리구조를 만든다.
     * 
     * @param String startId 
     * @return ModelAndView mv
     * @throws Exception
     */	
	public void setChildNode(NeosJsTree parNode, String parId, List<TreeDaoVO> resultTree){
		
		ArrayList<NeosJsTree> jstree = new ArrayList<NeosJsTree>();
		parNode.setChildren(jstree);
		
		NeosJsTree childNode = null;
		
		int resultTreeCount = resultTree.size();
		
		
		for(int i=0;i<resultTreeCount;i++){
									
			TreeDaoVO treeVO = resultTree.get(i);
			
			if( !EgovStringUtil.isEmpty(treeVO.getUpperContentId()) && treeVO.getUpperContentId().equals(parId)){
				childNode = new NeosJsTree(treeVO);
				
				parNode.setAddChildren(childNode);

				setChildNode(childNode, treeVO.getContentId(), resultTree);
			}
						
		}
		
	}
}
