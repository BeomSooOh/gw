package neos.cmm.erp.batch.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.Globals;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.batch.service.ErpProjectService;
import neos.cmm.erp.dao.icube.ErpICubeProjectManageDAO;
import neos.cmm.erp.dao.iu.ErpIuProjectManageDAO;
import neos.cmm.systemx.project.service.ProjectManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.service.CommonCodeService;
import neos.cmm.util.code.service.SequenceService;

@Service("ErpProjectService")
public class ErpProjectSeviceImpl implements ErpProjectService{
	
	@Resource(name="ErpIuProjectManageDAO")
	ErpIuProjectManageDAO erpIuProjectManageDAO;
	
	@Resource(name="ErpICubeProjectManageDAO")
	ErpICubeProjectManageDAO erpICubeProjectManageDAO;
	
	@Resource(name="ProjectManageService")
	ProjectManageService projectManageService;
	
	
	@Resource(name="CommonCodeService")
	CommonCodeService commonCodeService;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	
	
	@Override
	public List<Map<String, Object>> selectProjectList(Map<String, Object> params) {
		return erpIuProjectManageDAO.selectProjectList(params);
	}
	
	private String getLastDateTime(String detailCode) {
		String s = commonCodeService.getCommonDetailCodeFlag1("ERP010", detailCode, "FLAG_1")+"";
		if (EgovStringUtil.isEmpty(s)) {
			return null;
		} 
		return s;
	}
	
	public void init() {
		return;
	}
	
	public void end() {
		return;
	}

	@Override
	public void syncProjectFromErp() {
		
		init();
		
		/** 조회 페이지 크기 구하기 */
		int size = CommonUtil.getIntNvl(commonCodeService.getCommonDetailCodeFlag1("ERP010", "104", "FLAG_1")+"");
		
		Map<String, Object> p = new HashMap<String,Object>();

		/** insert & update sync */
		p.put("lastDt", getLastDateTime("102"));	/** 최종 조회시간 가져오기 */
		erpProjectInsertUpdateSync(p, size);
		
		/** delete sync */
		p.put("lastDt", getLastDateTime("103"));	/** 최종 조회시간 가져오기 */
		erpProjectDeleteSync(p, size);
		
		end();
	}
	
	
	private void erpProjectInsertUpdateSync(Map<String, Object> p, int size) {
		
		int cnt = 1;		// 현재 진행 횟수
		int limitCnt = 10;	// 최대 진행 횟수
		int page = 0;		// 페이지번호
		
		/** 페이지 설정 */
		setPageing(p, size, page);
		
		/** ERP 프로젝트 조회 */
		List<Map<String,Object>> list = getErpProjectList(p);
		
		/** ERP 프로젝트 전체 라인수 */
		int totalCount = 0;
		
		if(list.size() > 0) {
			
			totalCount = CommonUtil.getIntNvl(list.get(0).get("totalCount")+"");
			
			/** 그룹웨어 DB 프로젝트 테이블에 insert */
			insertProjectToGw(list);

			/** 제한된 횟수만큼 동기화 */
			try {
				if (totalCount > size) {
					while(cnt < limitCnt) {
						setPageing(p, size, ++page);
						list = getErpProjectList(p);

						if (list == null || list.size() < 1) {
							break;
						}

						insertProjectToGw(list);
						cnt++;
						
						Thread.sleep(1000);
					}
				}
			} catch (InterruptedException e) {
				//System.out.println("ERP Project Insert Update Sync InterruptedException!!");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	private void erpProjectDeleteSync(Map<String, Object> p, int size) {
		
		int cnt = 1;		// 현재 진행 횟수
		int limitCnt = 10;	// 최대 진행 횟수
		int page = 0;		// 페이지번호
		
		/** 페이지 설정 */
		setPageing(p, size, page);
		
		/** ERP 프로젝트 삭제 리스트 조회 */
		List<Map<String,Object>> list = getErpProjectDeleteList(p);
		
		/** ERP 프로젝트 전체 라인수 */
		int totalCount = 0;
		
		if(list.size() > 0) {
			
			totalCount = CommonUtil.getIntNvl(list.get(0).get("totalCount")+"");
			
			/** 그룹웨어 DB 프로젝트 테이블에 insert */
			deleteProjectToGw(list);

			/** 제한된 횟수만큼 동기화 */
			try {
				if (totalCount > size) {
					while(cnt < limitCnt) {
						setPageing(p, size, ++page);
						list = getErpProjectDeleteList(p);

						if (list == null || list.size() < 1) {
							break;
						}

						deleteProjectToGw(list);
						cnt++;
						
						Thread.sleep(1000);
					}
				}
			} catch (InterruptedException e) {
				//System.out.println("ERP Project Delete Sync InterruptedException!!");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	private void deleteProjectToGw(List<Map<String, Object>> list) {
		String lastDt = null;
		Map<String,Object> lastMap = null;
		if (list != null && list.size() > 0) {
			Map<String,Object> params = new HashMap<String, Object>();
			for(Map<String, Object> map : list) {
				
				/**  그룹웨어에 있는지 확인 */
				params.put("erpNoProject", map.get("noProject"));
				params.put("cdCompany", map.get("cdCompany"));
				List<Map<String, Object>> plist = projectManageService.selectErpProject(params);
				
				/** update */
				if (plist != null && plist.size() > 0) {
					
					map = plist.get(0);
					
					map.put("flagDelete", "d");		// 실제 삭제하지 않고 flag 처리만
					map.put("editSeq", "SYSTEM");
					map.put("erpNoProject", null);	// 맵핑 key 제거
					
					projectManageService.updateProjectMainStatus(map);
				}
				
				lastMap = map;
			}
		}
		
		/** 동기화 성공하면 최종 조회 날짜시간 업데이트 */
		if(lastMap!=null) {//Null Pointer 역참조
		lastDt = lastMap.get("gwDeleteTime")+"";
		}
		if (EgovStringUtil.isEmpty(lastDt)) {
			lastDt = CommonUtil.date(new Date(), "yyyy-MM-dd HH:mm:ss");
		}
		commonCodeService.updateCommonDetail("ERP010", "103", lastDt, null, "SYSTEM");
	}

	/**
	 * ERP 종류에 따라 DAO 프로젝트 삭제 리스트 조회 
	 * @param params
	 * @return
	 */
	private List<Map<String, Object>> getErpProjectDeleteList(Map<String, Object> params) {
		
		List<Map<String,Object>> list = null;
		
		if (Globals.ERP_TYPE.toLowerCase().equals("iu")) {
			list = erpIuProjectManageDAO.selectProjectDeleteList(params);
		}
		else if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
			list = erpICubeProjectManageDAO.selectProjectDeleteList(params);
		}
		
		return list;
	}


	/**
	 * ERP 중 IU, ICUBE 따라 리스트 조회 스위치 메소드
	 * @param params
	 * @return
	 */
	private List<Map<String,Object>> getErpProjectList(Map<String,Object> params) {
		
		List<Map<String,Object>> list =  null;

		if (Globals.ERP_TYPE.toLowerCase().equals("iu")) {
			list = erpIuProjectManageDAO.selectProjectList(params);
		}
		else if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
			list = erpICubeProjectManageDAO.selectProjectList(params);
		}

		return list;
		
	}
	
	/**
	 * 그룹웨어 DB 프로젝트 테이블에 insert
	 * @param list
	 */
	public void insertProjectToGw(List<Map<String,Object>> list) {
		String lastDt = null;
		Map<String,Object> lastMap = null;
		if (list != null && list.size() > 0) {
			Map<String,Object> params = new HashMap<String, Object>();
			for(Map<String, Object> map : list) {
				
				/**  그룹웨어에 있는지 확인 */
				params.put("erpNoProject", map.get("noProject"));
				params.put("cdCompany", map.get("cdCompany"));
				List plist = projectManageService.selectErpProject(params);
				
				map.put("editSeq", "SYSTEM");
				map.put("erpNoProject", map.get("noProject"));
				
				/** icube 진행구분값에 사용안함 값을 그룹웨어 use_yn에 적용하기 */
				if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
					
					setStaProject(map);
				
				}
				
				/** update */
				if (plist != null && plist.size() > 0) {
					projectManageService.updateProjectMainFromErp(map);
				}
				/** insert */
				else {
					/** 프로젝트 번호 생성. 시퀀스번호 + ERP 프로젝트 번호 */
					params.put("value", "project");
					map.put("noProject", sequenceService.getSequence(params)+"_"+map.get("noProject"));
					
					map.put("svType", "ERP");
					
					/** insert시 사용유무에 값 없을경우 기본값 'Y' 설정 */
					String useYn = map.get("useYn")+"";
					if (EgovStringUtil.isEmpty(useYn)) {
						map.put("useYn", "Y");
					}
					
					projectManageService.insertProjectMainFromErp(map);
					projectManageService.insertProjectDetailFromErp(map);
					
				}
				lastMap = map;
			}
		}
		
		
		/** 동기화 성공하면 최종 조회 날짜시간 업데이트 */
		if(lastMap!=null) {//Null Pointer 역참조
		lastDt = lastMap.get("gwInsertTime")+"";
		}
		if (EgovStringUtil.isEmpty(lastDt)) {
			lastDt = CommonUtil.date(new Date(), "yyyy-MM-dd HH:mm:ss");
		}
		commonCodeService.updateCommonDetail("ERP010", "102", lastDt, null, "SYSTEM");
	}
	
	private void setStaProject(Map<String, Object> map) {
		// iu 프로젝트 상태 코드
		/* { text: "작성", value:"001" },
         { text: "검토", value:"002" },
         { text: "승인", value:"003" },
         { text: "진행", value:"100" },
         { text: "완료", value:"999" }*/
		
		String sta = map.get("staProject")+"";
		if (sta.equals("0")) {
			map.put("staProject", "999");
		} else if (sta.equals("1")) {
			map.put("staProject", "100");
		} else if (sta.equals("9")) {
			map.put("useYn", "N");
		}
		
	}

	/**
	 * 페이징 설정
	 * @param params
	 * @param size
	 * @param page
	 */
	private void setPageing(Map<String, Object> params, int size, int page) {
		
		if (size < 1) {
			size = 100;
		}
		
		params.put("startRow", page*size+1);
		params.put("endRow", page*size+size+1);
	}

}
