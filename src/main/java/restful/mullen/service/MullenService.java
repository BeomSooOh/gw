package restful.mullen.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import api.common.model.APIResponse;
import restful.mobile.vo.ResultVO;
import restful.mullen.vo.MullenAuthStatus;
import restful.mullen.vo.MullenLoginVO;
import restful.mullen.vo.MullenUser;

public interface MullenService {
	//로그인 비밀번호
	public String selectLoginPassword(MullenLoginVO param) throws Exception;
	
	//로그인
	public List<MullenLoginVO> actionLoginMobile(MullenLoginVO param) throws Exception;
	
	//로그인VO
	public List<Map<String,Object>> selectLoginVO(MullenLoginVO vo) throws Exception;
	
	//사용자명변경
	public int modifyUserName(HashMap<String, Object> params) throws Exception;

	//인증메일전송
	public boolean processSendAuthEmail(HashMap<String, Object> params) throws Exception;

	//인증상태확인
	public MullenAuthStatus getAuthStatus(HashMap<String, Object> params) throws Exception;

	//인증메일확인
	public boolean processConfirmAuthEmail(HashMap<String, Object> params) throws Exception;

	//계정등록
	public boolean processRegistAccount(HashMap<String, Object> params, ResultVO response) throws Exception;

	//사용자정보(외부메일사용)
	public MullenUser getEmpSeqByEmailAddr(HashMap<String, Object> params) throws Exception;

	//마이그룹 ID 갱신
	public void processModifyMyGroupId(HashMap<String, Object> params);

	//입사처리(1명)
	public String processAddEmp(HashMap<String, Object> params);

	//입사처리(대량_파일)
	public String processAddBulkEmp(HashMap<String, Object> params);

	//삭제처리(1명)
	public String processDelEmp(HashMap<String, Object> params);

	//삭제처리(대량_파일)
	public String processDelBulkEmp(HashMap<String, Object> params);

	
	//계정등록 / 조직원 추가
	public boolean processAddUser(HashMap<String, Object> params, ResultVO response) throws Exception;

	//계정아이디/멀린코드 중복체크
	public boolean validationCheck(HashMap<String, Object> params, ResultVO response);

	//계정등록여부 확인
	public MullenAuthStatus checkAuthStatus(HashMap<String, Object> params);

	//조직구성 테이블 셋팅
	public boolean setMullenGroupInfo(HashMap<String, Object> params, ResultVO response);

	//조직구성 리스트 조회
	public Object getMullenGroupList(HashMap<String, Object> params);
	
	//핸드폰 번호 변경
	public void updateMobileTelNum(HashMap<String, Object> params);

	//조직원 찾기
	public Object searchMullenUser(HashMap<String, Object> params);

	//구성원 등록 요청
	public void reqGroup(HashMap<String, Object> params);
	
	//구성원 등록 요청 수락/거절
	public boolean reqHandling(HashMap<String, Object> params, APIResponse response);

	//구성원 등록요청 리스트(받은요청, 보낸요청)
	public Object reqList(HashMap<String, Object> params, APIResponse response);
	
	//구성원 나가기
	public void outGroup(HashMap<String, Object> params);

	//groupId 조회
	public Object getGroupId(HashMap<String, Object> params);

	//메일아이디로 계정조회
	public MullenUser getMullenUserInfoByEmailAddr(HashMap<String, Object> params);

	//멀린계정 삭제
	public int deleteUser(HashMap<String, Object> params, ResultVO response);
	
	//멀린 이용약관정보 셋팅
	public void setMullenAgreeMent(MullenLoginVO restVO);

	public void setMullenAgreeMent(Map<String, Object> params);
}
 

