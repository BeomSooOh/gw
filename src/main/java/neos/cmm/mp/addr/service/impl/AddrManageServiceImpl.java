package neos.cmm.mp.addr.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.mp.addr.service.AddrManageService;

import org.springframework.stereotype.Service;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Service("AddrManageService")
public class AddrManageServiceImpl implements AddrManageService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public void InsertAddrGroupInfo(Map<String, Object> paramMap) {
		//주소록 그룹 기본정보 저장.
		if(paramMap.get("addr_group_id").toString().equals("0")){
			Object addrGroupID = commonSql.select("AddrManageService.GetAddrGroupID", paramMap);
			
			if(addrGroupID == null) {
				addrGroupID = "0";
			}
			paramMap.put("addr_group_id", Integer.parseInt(addrGroupID.toString()) + 1);
			commonSql.insert("AddrManageService.InsrtAddrGroupInfo", paramMap);
		}
		else{
			commonSql.update("AddrManageService.UpdateAddrGroupInfo", paramMap);
			
			//주소록 그룹 변경되는 구분(개인,회사,공용)값에따라 
			//해당그룹에 등록되어있는 주소록 구분값도 변경처리
			commonSql.update("AddrManageService.UpdateAddrInfo", paramMap);
		}
		
		if(paramMap.get("addr_group_tp").toString().equals("20") || (paramMap.get("addr_group_tp").toString().equals("10")) || (paramMap.get("addr_group_tp").toString().equals("50")))
		{
			//공개범위 저장 (그룹구분이 공용(부서,회사)일 경우만)
			String[] selectedItems = paramMap.get("selectedItems").toString().split(",");

			//기존 공개범위 삭제 후 insert
			commonSql.delete("AddrManageService.DeleteAddrPublicID", paramMap);
			for(int i=0;i<selectedItems.length;i++){
				
				String sGbn = "";
				String seq = "";
				String addrDeptSeq = "";
				
				Object addrPublicID = commonSql.select("AddrManageService.GetAddrPublicID", paramMap);
				
				if(addrPublicID == null) {
						addrPublicID = "0";
				}
				
				String[] selectInfo = selectedItems[i].split("\\|");
				
				if(selectInfo.length != 1){
					sGbn = selectInfo[4];
					addrDeptSeq = selectInfo[2];
					if(sGbn.equals("d")){
						seq = selectInfo[2];
					}else if(sGbn.equals("u")){
						seq = selectInfo[3];
						sGbn = "m";
					}else if(sGbn.equals("c")){
						seq = selectInfo[1];
						sGbn = "c";
						addrDeptSeq = "";
					}
				}else{
					seq = selectInfo[0];
					sGbn = "c";
				}
				
				
				paramMap.put("addr_public_id", Integer.parseInt(addrPublicID.toString()));
				paramMap.put("gbnInfo", sGbn);
				paramMap.put("seqInfo", seq);
				paramMap.put("addrDeptSeq", addrDeptSeq);
				
				commonSql.insert("AddrManageService.InsertAddrPublicInfo", paramMap);
			}
		}
		
	}

	@Override
	public Map<String, Object> GetAddrGroupList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(paramMap, paginationInfo, "AddrManageService.GetAddrGroupList");
	}

	@Override
	public void DeleteAddrGroupInfo(Map<String, Object> paramMap) {
		//주소록그룹 정보 삭제
		commonSql.delete("AddrManageService.DeleteAddrGroupInfo", paramMap);
		
		//공개범위 삭제(그룹구분이 공용(부서,회사)일 경우만)
		if(paramMap.get("addr_group_tp").toString().equals("20") || paramMap.get("addr_group_tp").toString().equals("10") || paramMap.get("addr_group_tp").toString().equals("50")) {
			commonSql.delete("AddrManageService.DeleteAddrPublicInfo", paramMap);
		}
	}
	
	
	@Override
	public void DeleteAddrGroupListInfo(Map<String, Object> paramMap) {
		//주소록 정보 삭제
		commonSql.delete("AddrManageService.DeleteAddrList", paramMap);
		
		//주소록 그룹 정보 삭제
		commonSql.delete("AddrManageService.DeleteAddrGroupList", paramMap);
		
		//공개범위 삭제(그룹구분이 공용(부서,회사)일 경우만)
		commonSql.delete("AddrManageService.DeleteAddrPublicList", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetGroupList(Map<String, Object> paramMap) {
		return commonSql.list("AddrManageService.GetGroupList", paramMap);
	}

	@Override
	public Map<String, Object> GetAddrList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(paramMap, paginationInfo, "AddrManageService.GetAddrList");
	}

	@Override
	public void InsertAddrInfo(Map<String, Object> paramMap) {
		if(paramMap.get("addrSeq").toString().equals("0")){
			Object addrSeq = commonSql.select("AddrManageService.GetAddrID", paramMap);
				if(addrSeq == null) {
						addrSeq = "0";
				}
			paramMap.put("addrSeq", Integer.parseInt(addrSeq.toString()));
		}
		commonSql.insert("AddrManageService.InsertAddrInfo", paramMap);
		
		if(paramMap.get("empPhotoOld") != null){
			if(!paramMap.get("empPhotoOld").toString().equals("") && paramMap.get("empPhoto").toString().equals("")){
				commonSql.delete("AddrManageService.DeleteFileInfo", paramMap);
				commonSql.delete("AddrManageService.DeleteFileDetailInfo", paramMap);
			}
		}
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> GetAddrInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AddrManageService.GetAddrInfo", paramMap);
	}

	@Override
	public void DeleteAddrInfo(Map<String, Object> paramMap) {
		commonSql.delete("AddrManageService.DeleteAddrInfo", paramMap);
		
		if(paramMap.get("empPhotoOld") != null){
			if(!paramMap.get("empPhotoOld").toString().equals("") || paramMap.get("empPhoto").toString().equals("")){
				commonSql.delete("AddrManageService.DeleteFileInfo2", paramMap);
				commonSql.delete("AddrManageService.DeleteFileDetailInfo2", paramMap);
			}
		}
	}
	
	@Override
	public void DeleteAddrListInfo(Map<String, Object> paramMap) {
		commonSql.delete("AddrManageService.DeleteAddrListInfo", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetAddrGroupList(Map<String, Object> paramMap) {
		return commonSql.list("AddrManageService.AddrGroupPublicList", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetAddrPublic(Map<String, Object> paramMap) {
		return commonSql.list("AddrManageService.GetAddrPublic", paramMap);
	}

	@Override
	public String getCompName(Map<String, Object> paramMap) {
		Object result = commonSql.select("AddrManageService.GetCompName", paramMap);
		String compName = "";
		if(result != null) {
			compName = result.toString();
		}
		return compName;
	}

	@Override
	public String getEmpName(Map<String, Object> paramMap) {
		Object result = commonSql.select("AddrManageService.GetEmpName", paramMap);
		String empName = "";
		if(result != null) {
			empName = result.toString();
		}
		return empName;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPartnerList(Map<String, Object> paramMap) {
		return commonSql.list("AddrManageService.getPartnerList", paramMap);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGroupInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("AddrManageService.getGroupInfo", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompanyNames(Map<String, Object> paramMap) {
		return commonSql.list("AddrManageService.getCompanyNames", paramMap);
	}

	@Override
	public Map<String, Object> selectContactInfo(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		
		return commonSql.listOfPaging2(paramMap, paginationInfo, "AddrManageService.selectContactInfo");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> selectSpecificContactInfo(Map<String, Object> paramMap){
		return (Map<String, Object>) commonSql.select("AddrManageService.selectSpecificContactInfo",paramMap);
	}
}