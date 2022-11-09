package api.addr.service;

import java.util.Map;

import api.common.model.APIResponse;

public interface AddrService{

	APIResponse addrGroupList(Map<String, Object> paramMap);

	APIResponse addrList(Map<String, Object> paramMap);
	
	APIResponse addrList2(Map<String, Object> paramMap);

	APIResponse addrInfo(Map<String, Object> paramMap);

	APIResponse InsertAddrInfo(Map<String, Object> paramMap);

	APIResponse faxAddrGroupList(Map<String, Object> paramMap);

	APIResponse faxAddrList(Map<String, Object> paramMap);

	APIResponse addrGroupList2(Map<String, Object> paramMap);

	APIResponse InsertAddrInfo2(Map<String, Object> paramMap);

	APIResponse InsertAddrGroup(Map<String, Object> paramMap);

	APIResponse InsertAddrGroupForGCMS(Map<String, Object> paramMap);

	APIResponse InsertAddrInfoForGCMS(Map<String, Object> paramMap);

	APIResponse AddrGroupTp(Map<String, Object> paramMap);

	APIResponse CreateAddrGroup(Map<String, Object> paramMap);

}
