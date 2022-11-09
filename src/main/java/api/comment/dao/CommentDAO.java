package api.comment.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import api.comment.vo.CommentVO;

@Repository("CommentDAO")
public class CommentDAO extends EgovComAbstractDAO {
	
	
	/**
	 * 통합댓글 등록
	 * @param - 조회할 정보가 담긴 CommentVO
	 * @return 조회결과
	 * @exception Exception
	 */
	@SuppressWarnings("unchecked")
	public void insertComment(CommentVO vo) throws Exception {
		insert("CommentDAO.insertComment", vo);
	}
	
	/**
	 * 통합댓글 수정
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public void updateComment(CommentVO vo) throws Exception {
		insert("CommentDAO.updateComment", vo);
	}
	
	/**
	 * 통합댓글 삭제
	 * @param - 삭제 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public int deleteComment(CommentVO vo) throws Exception {
		return update("CommentDAO.deleteComment", vo);
	}
	
	/**
	 * 통합대댓글 삭제
	 * @param - 삭제 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public int deleteReComment(CommentVO vo) throws Exception {
		return update("CommentDAO.deleteReComment", vo);
	}
	
	/**
	 * 통합댓글 조회여부 업데디트
	 * @param - 삭제 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public void updateCommentViwe(CommentVO vo) throws Exception {
		insert("CommentDAO.updateCommentViwe", vo);
	}
	
	/**
	 * 상위 댓글 조회 여부 확인 
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public String selectCommentViewYn(CommentVO vo) throws Exception {
		
		return (String) select("CommmentDAO.selectCommentViewYn", vo);
	}
	
	/**
	 * 통합댓글 시퀀스 조회
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public String selectCommentSeq(CommentVO vo) throws Exception {
		
		return (String) select("CommmentDAO.selectCommentSeq", vo);
	}
	
	/**
	 * 통합대댓글 시퀀스 조회
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public String selectReCommentSeq(CommentVO vo) throws Exception {
		return (String) select("CommmentDAO.selectReCommentSeq", vo);
	}
	
	/**
	 * 통합댓글 정렬 시퀀스 조회
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public String selectSortCommentSeq(CommentVO vo) throws Exception {
		
		return (String) select("CommmentDAO.selectSortCommentSeq", vo);
	}
	
	/**
	 * 통합대댓글 시퀀스 조회
	 * @param - 등록 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public String selectSortReCommentSeq(CommentVO vo) throws Exception {
		return (String) select("CommmentDAO.selectSortReCommentSeq", vo);
	}
	
	/**
	 * 통합댓글카운트 더하기
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public void addCommentCnt(CommentVO vo) throws Exception {
		update("CommentDAO.addCommentCnt", vo);
	}
	
	/**
	 * 사용자명 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectEmpName(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectEmpName", vo);
	}
	
	/**
	 * 부서명 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectDeptName(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectDeptName", vo);
	}
	
	/**
	 * 회사명 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCompName(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectCompName", vo);
	}
	
	/**
	 * 직책명 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectDutyName(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectDutyName", vo);
	}
	
	/**
	 * 직급명 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectPostitionName(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectPositionName", vo);
	}
	
	/**
	 * 댓글 리스트 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectCommentList(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectCommentList", vo);
	}
	
	/**
	 * 댓글 리스트 조회(최신순)
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectSortCommentList(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectSortCommentList", vo);
	}
	
	/**
	 * 댓글 리스트 조회(특정 댓글,대댓글 조회)
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectOneCommentList(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectOneCommentList", vo);
	}
	
	/**
	 * 댓글 리스트 조회(최신순)(특정 댓글,대댓글 조회)
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectOneSortCommentList(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectOneSortCommentList", vo);
	}
	
	/**
	 * 댓글 카운트
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public Map<String, Object> selectCommentCount(CommentVO vo) throws Exception {
		return (Map<String, Object>) select("CommentDAO.selectCommentCount", vo);
	}
	
	/**
	 * 부서내 사용자 리스트 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<String> selectDeptEmpList(Map<String,Object> vo) throws Exception {
		return (List<String>)list("CommentDAO.selectDeptEmpList", vo);
	}
	
	
	
	/**
	 * 조직도 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectOrgchartList(CommentVO vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.selectOrgchartList", vo);
	}
	
	
	/**
	 * 조직도 조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public List<Map<String, Object>> selectFileList(Map<String,Object> vo) throws Exception {
		return (List<Map<String, Object>>)list("CommentDAO.getFileList", vo);
	}
	
	
	/**
	 * 댓글 모듈조회
	 * @param - 정보가 담긴 CommentVO
	 * @exception Exception
	 */
	public Map<String, Object> selectModuleInfo(CommentVO vo) throws Exception {
		return (Map<String, Object>) select("CommentDAO.selectModuleInfo", vo);
	}

	public String checkAdminMasterAuth(Map<String, Object> param) {
		return (String) select("CommentDAO.checkAdminMasterAuth", param);
	}
	
	
}
