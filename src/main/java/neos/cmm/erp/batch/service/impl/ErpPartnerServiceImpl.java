package neos.cmm.erp.batch.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.Globals;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.batch.service.ErpPartnerService;
import neos.cmm.erp.dao.icube.ErpICubePartnerManageDAO;
import neos.cmm.erp.dao.iu.ErpIuPartnerManageDAO;
import neos.cmm.systemx.partner.service.PartnerManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.service.CommonCodeService;
import neos.cmm.util.code.service.SequenceService;

@Service("ErpPartnerService")
public class ErpPartnerServiceImpl implements ErpPartnerService{
	
	@Resource(name="ErpIuPartnerManageDAO")
	ErpIuPartnerManageDAO erpIuPartnerManageDAO;
	
	@Resource(name="ErpICubePartnerManageDAO")
	ErpICubePartnerManageDAO erpICubePartnerManageDAO;
	
	@Resource(name="PartnerManageService")
	PartnerManageService partnerManageService;
	
	@Resource(name="CommonCodeService")
	CommonCodeService commonCodeService;
	
	@Resource(name="SequenceService")
	SequenceService sequenceService;
	

	@Override
	public List<Map<String, Object>> selectPartnerList(Map<String, Object> params) {
		return erpIuPartnerManageDAO.selectPartnerList(params);
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
	public void syncPartnerFromErp() {
		
		init();
		
		/** 조회 페이지 크기 구하기 */
		int size = CommonUtil.getIntNvl(commonCodeService.getCommonDetailCodeFlag1("ERP010", "204", "FLAG_1")+"");
		
		Map<String, Object> p = new HashMap<String,Object>();

		/** insert & update sync */
		p.put("lastDt", getLastDateTime("202"));	/** 최종 조회시간 가져오기 */
		erpPartnerInsertUpdateSync(p, size);
		
		/** delete sync */
		p.put("lastDt", getLastDateTime("203"));	/** 최종 조회시간 가져오기 */
		erpPartnerDeleteSync(p, size);
		
		/** icube 경우 거래처 담당자가 여러명이어서 테이블이 별도임.
		 * 거래처 상세 리스트 동기화하기
		 *  */
		if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
			p.put("lastDt", getLastDateTime("206"));	/** 최종 조회시간 가져오기 */
			erpICubePartnerDetailSync(p, size);
		}
		
		end();
	}
	
	
	private void erpICubePartnerDetailSync(Map<String, Object> p, int size) {
		int cnt = 1;		// 현재 진행 횟수
		int limitCnt = 10;	// 최대 진행 횟수
		int page = 0;		// 페이지번호
		
		/** 페이지 설정 */
		setPageing(p, size, page);
		
		/** ERP 거래처 상세 조회 */
		List<Map<String,Object>> list = getErpICubePartnerDetailList(p);
		
		/** ERP 거래처 전체 라인수 */
		int totalCount = 0;
		
		if(list.size() > 0) {
			
			totalCount = CommonUtil.getIntNvl(list.get(0).get("totalCount")+"");
			
			/** 그룹웨어 DB 거래처 상세 테이블에 insert */
			insertICubePartnerDetailToGw(list);

			/** 제한된 횟수만큼 동기화 */
			try {
				if (totalCount > size) {
					while(cnt < limitCnt) {
						setPageing(p, size, ++page);
						list = getErpICubePartnerDetailList(p);

						if (list == null || list.size() < 1) {
							break;
						}

						insertICubePartnerDetailToGw(list);
						cnt++;
						
						Thread.sleep(1000);
					}
				}
			} catch (InterruptedException e) {
				//System.out.println("ERP ICube Partner Detail Insert Update Sync InterruptedException!!");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
		
	}

	private void insertICubePartnerDetailToGw(List<Map<String, Object>> list) {
		String lastDt = null;
		Map<String,Object> lastMap = null;
		if (list != null && list.size() > 0) {
			Map<String,Object> params = new HashMap<String, Object>();
			for(Map<String, Object> map : list) {
				
				/**  그룹웨어에 있는지 확인 */
				params.put("erpCdPartner", map.get("cdPartner"));
				List<Map<String,Object>> plist = partnerManageService.selectErpPartner(params);

				if (plist != null && plist.size() > 0) {
					
					params.put("noSeq", map.get("noSeq"));
					List<Map<String,Object>> dlist = partnerManageService.selectErpPartner(params);

					map.put("editSeq", "SYSTEM");
					map.put("erpCdPartner", map.get("cdPartner"));

					/** update */
					if (dlist != null && dlist.size() > 0) {
						// update는 하지 않음.
						// 그룹웨어에서 정보를 수정할수도 있음.
					} 
					/** insert */
					else {
						map.put("noProject", plist.get(0).get("noProject"));
						map.put("svType", "ERP");
						partnerManageService.insertPartnerDetailFromErp(map);
					}
					lastMap = map;
				}
			}
		}
		
		/** 동기화 성공하면 최종 조회 날짜시간 업데이트 */
		if (lastMap != null) {
			lastDt = lastMap.get("gwInsertTime")+"";
			if (EgovStringUtil.isEmpty(lastDt)) {
				lastDt = CommonUtil.date(new Date(), "yyyy-MM-dd HH:mm:ss");
			}
			commonCodeService.updateCommonDetail("ERP010", "206", lastDt, null, "SYSTEM");
		}
	}

	private void erpPartnerInsertUpdateSync(Map<String, Object> p, int size) {
		
		int cnt = 1;		// 현재 진행 횟수
		int limitCnt = 10;	// 최대 진행 횟수
		int page = 0;		// 페이지번호
		
		/** 페이지 설정 */
		setPageing(p, size, page);
		
		/** ERP 거래처 조회 */
		List<Map<String,Object>> list = getErpPartnerList(p);
		
		/** ERP 거래처 전체 라인수 */
		int totalCount = 0;
		
		if(list.size() > 0) {
			
			totalCount = CommonUtil.getIntNvl(list.get(0).get("totalCount")+"");
			
			/** 그룹웨어 DB 거래처 테이블에 insert */
			insertPartnerToGw(list);

			/** 제한된 횟수만큼 동기화 */
			try {
				if (totalCount > size) {
					while(cnt < limitCnt) {
						setPageing(p, size, ++page);
						list = getErpPartnerList(p);

						if (list == null || list.size() < 1) {
							break;
						}

						insertPartnerToGw(list);
						cnt++;
						
						Thread.sleep(1000);
					}
				}
			} catch (InterruptedException e) {
				//System.out.println("ERP Partner Insert Update Sync InterruptedException!!");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	private void erpPartnerDeleteSync(Map<String, Object> p, int size) {
		
		int cnt = 1;		// 현재 진행 횟수
		int limitCnt = 10;	// 최대 진행 횟수
		int page = 0;		// 페이지번호
		
		/** 페이지 설정 */
		setPageing(p, size, page);
		
		/** ERP 거래처 삭제 리스트 조회 */
		List<Map<String,Object>> list = getErpPartnerDeleteList(p);
		
		/** ERP 거래처 전체 라인수 */
		int totalCount = 0;
		
		if(list.size() > 0) {
			
			totalCount = CommonUtil.getIntNvl(list.get(0).get("totalCount")+"");
			
			/** 그룹웨어 DB 거래처 테이블에 insert */
			deletePartnerToGw(list);

			/** 제한된 횟수만큼 동기화 */
			try {
				if (totalCount > size) {
					while(cnt < limitCnt) {
						setPageing(p, size, ++page);
						list = getErpPartnerDeleteList(p);

						if (list == null || list.size() < 1) {
							break;
						}

						deletePartnerToGw(list);
						cnt++;
						
						Thread.sleep(1000);
					}
				}
			} catch (InterruptedException e) {
				//System.out.println("ERP Partner Delete Sync InterruptedException!!");
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}
	
	private void deletePartnerToGw(List<Map<String, Object>> list) {
		String lastDt = null;
		Map<String,Object> lastMap = null;
		if (list != null && list.size() > 0) {
			Map<String,Object> params = new HashMap<String, Object>();
			for(Map<String, Object> map : list) {
				
				/**  그룹웨어에 있는지 확인 */
				params.put("erpCdPartner", map.get("cdPartner"));
				List<Map<String, Object>> plist = partnerManageService.selectErpPartner(params);
				
				/** update */
				if (plist != null && plist.size() > 0) {
					
					map = plist.get(0);
					
					map.put("flagDelete", "d");		// 실제 삭제하지 않고 flag 처리만
					map.put("editSeq", "SYSTEM");
					map.put("erpCdPartner", null);	// 맵핑 key 제거
					
					partnerManageService.updatePartnerMainStatus(map);
				}
				
				lastMap = map;
			}
		}
		
		/** 동기화 성공하면 최종 조회 날짜시간 업데이트 */
		if (lastMap != null) {
			lastDt = lastMap.get("gwDeleteTime")+"";
			if (EgovStringUtil.isEmpty(lastDt)) {
				lastDt = CommonUtil.date(new Date(), "yyyy-MM-dd HH:mm:ss");
			}
			commonCodeService.updateCommonDetail("ERP010", "203", lastDt, null, "SYSTEM");
		}
		
	}


	private List<Map<String, Object>> getErpPartnerDeleteList(Map<String, Object> params) {
		List<Map<String,Object>> list = null;
		if (Globals.ERP_TYPE.toLowerCase().equals("iu")) {
			list = erpIuPartnerManageDAO.selectPartnerDeleteList(params);
		}
		else if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
			list = erpICubePartnerManageDAO.selectPartnerDeleteList(params);
		}

		return list;
	}


	/**
	 * ERP 중 IU, ICUBE 따라 리스트 조회 스위치 메소드
	 * @param params
	 * @return
	 */
	private List<Map<String,Object>> getErpPartnerList(Map<String,Object> params) {
		List<Map<String,Object>> list = null; 
		if (Globals.ERP_TYPE.toLowerCase().equals("iu")) {
			list = erpIuPartnerManageDAO.selectPartnerList(params);
		}
		else if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
			list = erpICubePartnerManageDAO.selectPartnerList(params);
		}

		return list;
		
	}
	
	private List<Map<String, Object>> getErpICubePartnerDetailList(Map<String,Object> params) {
		List<Map<String,Object>> list = erpICubePartnerManageDAO.selectPartnerDetailList(params);
		return list;
	}
	
	/**
	 * 그룹웨어 DB 거래처 테이블에 insert
	 * @param list
	 */
	public void insertPartnerToGw(List<Map<String,Object>> list) {
		String lastDt = null;
		Map<String,Object> lastMap = null;
		if (list != null && list.size() > 0) {
			Map<String,Object> params = new HashMap<String, Object>();
			for(Map<String, Object> map : list) {
				
				/**  그룹웨어에 있는지 확인 */
				params.put("erpCdPartner", map.get("cdPartner"));
				List plist = partnerManageService.selectErpPartner(params);
				
				map.put("noSeq", "0");
				map.put("editSeq", "SYSTEM");
				map.put("erpCdPartner", map.get("cdPartner"));
				
				/** 거래처명이 null 경우도 있음. */
				String lnPartner = map.get("lnPartner")+"";
				if (EgovStringUtil.isEmpty(lnPartner)) {
					map.put("lnPartner", "no name");
				}
				
				/** icube 거래형태 코드를 iu 거래분 */
				if (Globals.ERP_TYPE.toLowerCase().equals("icube")) {
					setClsPartner(map);
				}
				
				/** update */
				if (plist != null && plist.size() > 0) {
					partnerManageService.updatePartnerMainFromErp(map);
				} 
				/** insert */
				else {
					map.put("value", "partner");
					map.put("cdPartner", sequenceService.getSequence(map)+"_"+map.get("cdPartner"));
					map.put("svType", "ERP");
					partnerManageService.insertPartnerMainFromErp(map);

					if (Globals.ERP_TYPE.toLowerCase().equals("iu")) {
						partnerManageService.insertPartnerDetailFromErp(map);
					}

				}
				lastMap = map;
			}
		}
		
		
		/** 동기화 성공하면 최종 조회 날짜시간 업데이트 */
		if (lastMap != null) {
			lastDt = lastMap.get("gwInsertTime")+"";
			if (EgovStringUtil.isEmpty(lastDt)) {
				lastDt = CommonUtil.date(new Date(), "yyyy-MM-dd HH:mm:ss");
			}
			commonCodeService.updateCommonDetail("ERP010", "202", lastDt, null, "SYSTEM");
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
	
	private void setClsPartner(Map<String,Object> map) {
		// iU 코드
		/*{ text: "매입", value:"001" },
        { text: "매출", value:"002" },
        { text: "통합", value:"003" },
        { text: "기타", value:"004" }*/
		int c = CommonUtil.getIntNvl(map.get("clsPartner")+"");
		String clsPartner = null;
		switch (c) {
		case 1:
			clsPartner = "002";
			break;
		case 2:
			clsPartner = "001";
			break;
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			clsPartner = "004";
			break;
		default:
			break;
		}
		
		map.put("clsPartner", clsPartner);
	}

}
