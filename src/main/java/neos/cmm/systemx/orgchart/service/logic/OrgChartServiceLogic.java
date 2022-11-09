package neos.cmm.systemx.orgchart.service.logic;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import main.web.BizboxAMessage;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.orgchart.OrgChartNode;
import neos.cmm.systemx.orgchart.OrgChartTree;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.CommonUtil;

@Service("OrgChartService")
public class OrgChartServiceLogic implements OrgChartService{
	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;
	
	@Override
	public Map<String, Object> getGroupInfo(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("OrgChart.selectGroupInfo", paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getCompLangList(Map<String, Object> paramMap) {
		return commonSql.list("OrgChart.getCompLangList", paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getGroupLangList(Map<String, Object> paramMap) {
		return commonSql.list("OrgChart.getGroupLangList", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectUserPositionList(
			Map<String, Object> paramMap) throws Exception {
		return commonSql.list("OrgChart.selectUserPositionList", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectCompBizDeptList(Map<String, Object> paramMap) {
		return commonSql.list("OrgChart.selectCompBizDeptList", paramMap);
	}

	@Override
	public List<Map<String, Object>> selectCompBizDeptListAdmin(Map<String, Object> paramMap) {
		return commonSql.list("OrgChart.selectCompBizDeptListAdmin", paramMap);
	}
	
	@Override
	public OrgChartTree getOrgChartTree(List<Map<String, Object>> list, Map<String, Object> params) {
		List<OrgChartNode> pList = new ArrayList<OrgChartNode>();

		String groupSeq = "";
		String bizSeq = "";
		String compSeq = "";
		String deptSeq = "";
		String pathName = "";
		int  orderNum = 0;

		/** 회사시퀀스가 처리 */
		String reqCompSeq = params.get("compSeq")+"";
		
		String isGroupAll = params.get("isGroupAll")+"";
		
		boolean isExpanded = false;
		
		String compName = null;
		for(Map map : list) {
			String seq = null;
			String name = null;
			String gbnOrg = String.valueOf(map.get("gbnOrg"));
			groupSeq = String.valueOf(map.get("grpSeq"));
			bizSeq = String.valueOf(map.get("bizSeq"));
			compSeq = String.valueOf(map.get("compSeq"));
			deptSeq = String.valueOf(map.get("deptSeq"));
			pathName = String.valueOf(map.get("pathName"));
			orderNum = CommonUtil.getIntNvl(String.valueOf(map.get("order")));

			if (gbnOrg.equals("c")) {
				seq = String.valueOf(map.get("compSeq"));
				name = String.valueOf(map.get("compName"));		
			} else if (gbnOrg.equals("b")) {
				seq = String.valueOf(map.get("bizSeq"));
				name = String.valueOf(map.get("bizName"));
			} else if (gbnOrg.equals("d")) {
				seq = String.valueOf(map.get("deptSeq"));
				name = String.valueOf(map.get("deptName"));
			}

			String parentSeq = String.valueOf(map.get("compSeq"));
			String path = String.valueOf(map.get("path"));
			String[] pathArr = path.split("\\|");
			if (pathArr.length == 1) {
				parentSeq = String.valueOf(params.get("groupSeq"));
			} else {
				parentSeq = pathArr[pathArr.length-2];
			}
			
			OrgChartNode node = null;

			node = new OrgChartNode(groupSeq, bizSeq, compSeq, deptSeq, seq, parentSeq, name, gbnOrg);
			if (EgovStringUtil.isEmpty(reqCompSeq)) {
				//
			} else {
				String c =  String.valueOf(map.get("compSeq"));
				if (reqCompSeq.equals(c)) {

					if (EgovStringUtil.isEmpty(compName) && gbnOrg.equals("c")) {
						compName = name;
					}
				}
			}

			/** 로그인 회사외에 다른 회사 모드 펼침 닫기 */
			isExpanded = true;
			node.setExpanded(isExpanded);
			node.setOrderNum(orderNum);
			node.setPathName(pathName);
			node.setCompName(String.valueOf(map.get("compName")));
			
			if (node != null) {
				node.setSpriteCssClass("folder");
			}
			
			pList.add(node);
		}

		OrgChartTree menu = null;
		if (EgovStringUtil.isEmpty(reqCompSeq) || isGroupAll.equals("Y")) {
			menu = new OrgChartTree(String.valueOf(params.get("groupSeq")), "0", String.valueOf(params.get("groupName")), "g");
		} else {
			menu = new OrgChartTree(reqCompSeq, "0", compName, "c");
		} 

		menu.addAll(pList);
		return menu;
	}

	public List<Map<String, Object>> getOrgChartTreeJT(List<Map<String, Object>> list, Map<String, Object> params) {
		List<Map<String, Object>> tree = new ArrayList<Map<String, Object>>();
		
		if (params.get("parentSeq").equals("0")) {
			//[최초호출]
			
			//자신의 부서 path 가져오기
			List<Map<String, Object>> myPathList = commonSql.list("OrgChart.getMyPathAdmin", params);
			String myPath = myPathList.get(0).get("path").toString();
			String[] myPathArr = myPath.split("\\|");
			
			//루트
			List<Map<String, Object>> root = list;
			List<Map<String, Object>> cList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
			int len = myPathArr.length - 1;
			
			//루트 하위의 자신의 부서리스트 모두 가져오기
			for (int i=len; i >= 0; i--) {
				if (i == len) {
					params.put("parentSeq", myPathArr[i]);
					cList = getCompBizDeptList(params);
				}
				
				if (i != 0) {					
					params.put("parentSeq", myPathArr[i-1]);
					pList = getCompBizDeptList(params);
				} else {
					pList = root;
				}
								
				for (int j=0; j<pList.size(); j++) {
					if (pList.get(j).get("id").equals(myPathArr[i])) {
						pList.get(j).put("children", cList);
						
						Map<String, Object> state = new HashMap<String, Object>();
						state.put("opened", true);
						state.put("selected", false);						
						if (params.get("deptSeq").equals(pList.get(j).get("id"))) {
							state.put("selected", true);
						}
						pList.get(j).put("state", state);
						
						cList = pList;
					}
				}
			} 			
			
			tree = pList;
		} else {
			//[부서클릭시마다호출]
			
			tree = list;
		}
		
		return tree;
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getdeptManageOrgChartListJT(Map<String, Object> params) {
		
		Map tree = new HashMap<String, Map<String, Object>>();
		Map burffer = new HashMap<String, Map<String, Object>>();
		
		List<Map<String, Object>> returnList = new ArrayList<>();
		String queryID = "";
		if(params.get("retKey") == null) {
			queryID = "OrgChart.selectOrgFullListAdmin";
		}
		else {
			queryID = "OrgChart.selectOrgBatchPreviewList";
		}
		List<Map<String, Object>> list = commonSql.list(queryID, params);

		for (Map<String, Object> item : list) {

			Map<String, Object> node = new HashMap<String, Object>();
			
			Map<String, Object> nodeState = new HashMap<String, Object>();
			nodeState.put("selected", item.get("selected").toString().equals("1"));
			nodeState.put("opened", item.get("opened").toString().equals("1"));
			
			Map<String, Object> fIcon = new HashMap<String, Object>();
			String fColor = "comp_li";
			if (item.get("gbnOrg").toString().equals("b")) {
				fColor = "busi_li";
			}
			else if (item.get("gbnOrg").toString().equals("d")) {
				fColor = "";
				if (item.get("team_yn").toString().equals("Y")) {
					fColor = "col_green";
				}
				else if (item.get("vir_dept_yn").toString().equals("Y")) {
					fColor = "col_brown";
				}
				if (item.get("use_yn") != null && item.get("use_yn").toString().equals("N")) {
					fColor = "col_disabled";
				}
			}
			

			String text =  item.get("text") == null ? "" : item.get("text").toString();
			if(!params.get("includeDeptCode").toString().equals("")){
				if(params.get("retKey") == null) {
					text += "(" + item.get("org_cd") + ")";
				}
				else {
					text += "(" + item.get("id") + ")";
				}
			}
			
			//사용유무 N값인 노드 gray처리
			if(item.get("use_yn") != null && item.get("use_yn").toString().equals("N")) {
				text = "<em class=\"text_gray\" style=\"font-weight: bold;\">" + text + "</em>";
			}
			
			
			fIcon.put("class", fColor);
			node.put("tIcon", fColor);
			node.put("li_attr", fIcon);
			
			if(params.get("retKey") != null) {
				node.put("batchSeq", item.get("batchSeq").toString());
			}

			node.put("id", item.get("orgDiv").toString() + item.get("id").toString());
			node.put("text", text);
			node.put("gbnOrg", item.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parent_seq"));
			node.put("team_yn", item.get("team_yn"));
			node.put("vir_dept_yn", item.get("vir_dept_yn"));
			node.put("state", nodeState);
			node.put("children", new ArrayList<Map<String, Object>>());
			node.put("originText", item.get("text"));

			burffer.put(item.get("path"), node);
			
		}


		ArrayList<String> compSeq = new ArrayList<>();

		for (int i = list.size() - 1; i > -1; i--) {
			
			Map<String, Object> item = list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			String id = item.get("path").toString();
			Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
			
			Map<String, Object> fIcon = new HashMap<String, Object>();
			String fColor = "comp_li";
			if (bNode.get("gbnOrg").toString().equals("b")) {
				fColor = "busi_li";
			}
			else if (bNode.get("gbnOrg").toString().equals("d")) {
				fColor = "";
				if (item.get("team_yn").toString().equals("Y")) {
					fColor = "col_green";
				}
				else if (item.get("vir_dept_yn").toString().equals("Y")) {
					fColor = "col_brown";
				}
				if (item.get("use_yn") != null && item.get("use_yn").toString().equals("N")) {
					fColor = "col_disabled";
				}
			}
			
			fIcon.put("class", fColor);
			fIcon.put("css", fColor);
			node.put("tIcon", fColor);
			node.put("li_attr", fIcon);
			
			node.put("id", bNode.get("id"));
			node.put("text", bNode.get("text"));
			node.put("gbnOrg", bNode.get("gbnOrg"));
			node.put("compSeq", item.get("compSeq"));
			node.put("bizSeq", item.get("bizSeq") == null ? "" : item.get("bizSeq"));
			node.put("parentSeq", item.get("parent_seq"));
			node.put("team_yn", item.get("team_yn"));
			node.put("state", bNode.get("state"));
			node.put("children", bNode.get("children"));
			node.put("vir_dept_yn", item.get("vir_dept_yn"));
			node.put("originText", bNode.get("originText"));

			if (item.get("parent_seq").toString().equals("0")) {
				
				tree.put(node.get("id"), burffer.get(id));
				compSeq.add(0,item.get("id").toString());
				
			} else {
				
				try{
					
					((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parent_path"))).get("children")).add(0,node);
					
				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
				}
				
			}
		}

		
		for (String item : compSeq) {
//			returnList.add((Map<String, Object>) tree.get(item));
			returnList.add((Map<String, Object>) tree.get("c"+item));
		}
//		System.out.println(returnList);
		
		return returnList;
		
	}
	
	@Override
	public List<Map<String, Object>> getEmpSelectedList(Map<String, Object> params) {
		return commonSql.list("OrgChart.getEmpSelectedList", params);
	}

	@Override
	public List<Map<String, Object>> getDeptSelectedList(Map<String, Object> params) {
		return commonSql.list("OrgChart.getDeptSelectedList", params);
	}

	
	@Override
	public List<Map<String, Object>> getAddrGroupList(Map<String, Object> params) {
		return commonSql.list("AddrManageService.GetCmmPopAddrGroupList", params);
	}

	@Override
	public List<Map<String, Object>> getAddrList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonSql.list("AddrManageService.GetCmmAddrList", params);
	}

	@Override
	public List<Map<String, Object>> getEmpList(Map<String, Object> params) {
		return commonSql.list("OrgChart.getEmpList", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompBizDeptList(Map<String, Object> params) {
		
		List<Map<String, Object>> list = commonSql.list("OrgChart.getCompBizDeptList", params);
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			String gbnOrg = String.valueOf(list.get(i).get("gbn_org"));
			boolean opened = false;
			boolean selected = false;	
			
			//id
			node.put("id", list.get(i).get("id"));
			
			//org
			node.put("orgSeq", gbnOrg);
			
			//text
			if (gbnOrg.equals("c")) {
				node.put("text", (String.valueOf(list.get(i).get("comp_name"))));
			} else if (gbnOrg.equals("b")) {
				node.put("text", (String.valueOf(list.get(i).get("biz_name"))));
			} else if (gbnOrg.equals("d")) {
				node.put("text", (String.valueOf(list.get(i).get("dept_name"))));
			}
			
			//icon
			//if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
			//	node.put("icon", "/eap/css/jsTree/ico_tree_LastFolder.png");
			//}
			
			//state
			Map<String, Object> state = new HashMap<String, Object>();
			state.put("opened", opened);
			state.put("selected", selected);
			node.put("state", state);
			
			//children
			if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
				node.put("children", false);
			} else {
				node.put("children", true);
			}			
			
			//li_attr
			
			//a_attr
			
			pList.add(node);
		}
		
		return pList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompBizDeptListAdmin(Map<String, Object> params) {
		
		List<Map<String, Object>> list = commonSql.list("OrgChart.getCompBizDeptListAdmin", params);
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			String gbnOrg = String.valueOf(list.get(i).get("gbn_org"));
			boolean opened = false;
			boolean selected = false;	
			
			//id
			node.put("id", list.get(i).get("id"));
			
			//org
			node.put("orgSeq", gbnOrg);
			
			//text
			if (gbnOrg.equals("c")) {
				node.put("text", (String.valueOf(list.get(i).get("comp_name"))));
			} else if (gbnOrg.equals("b")) {
				node.put("text", (String.valueOf(list.get(i).get("biz_name"))));
			} else if (gbnOrg.equals("d")) {
				node.put("text", (String.valueOf(list.get(i).get("dept_name"))));
			}
			
			//icon
			//if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
			//	node.put("icon", "/eap/css/jsTree/ico_tree_LastFolder.png");
			//}
			
			//state
			Map<String, Object> state = new HashMap<String, Object>();
			state.put("opened", opened);
			state.put("selected", selected);
			node.put("state", state);
			
			//children
			if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
				node.put("children", false);
			} else {
				node.put("children", true);
			}			
			
			//li_attr
			
			//a_attr
			
			pList.add(node);
		}
		
		return pList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompList(Map<String, Object> params) {
		
		List<Map<String, Object>> list = commonSql.list("OrgChart.getCompList", params);
		
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		String parentId = "root";
		
		if(params.get("selectItem") == null || !params.get("selectItem").equals("s")){
			//root
			List<Map<String, Object>> root = new ArrayList<Map<String, Object>>();
			Map<String, Object> rootNode = new HashMap<String, Object>();
			rootNode.put("text", params.get("groupName"));
			rootNode.put("id", "root");
			rootNode.put("parent", "#");
			root.add(rootNode);
			pList.addAll(root);			
		}else{
			parentId = "#";
		}
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			//id
			node.put("id", list.get(i).get("id"));
			node.put("text", list.get(i).get("text"));
			node.put("parent", parentId);
			node.put("children", false);
			pList.add(node);
		}
		return pList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetUserDeptProfileListForDept(Map<String, Object> param) {
		
		//겸직미사용 팝업
		if(param.get("empUniqYn") != null && param.get("empUniqYn").equals("Y")){
			return commonSql.list("OrgChart.selectUserProfileListEmpUniq", param);
		}

		String selectMode = param.get("selectMode").toString();
		
		if(selectMode.equals("u") && param.get("isCheckAllDeptEmpShow").toString().equals("true")){
			return commonSql.list("OrgChart.selectUserDeptExtendProfileList", param);
		} else if(selectMode.equals("u") && param.get("isCheckAllDeptEmpShow").toString().equals("false")){
			return commonSql.list("OrgChart.selectUserProfileList", param);
		}else if(selectMode.equals("d")){
			return commonSql.list("OrgChart.selectDeptProfileList", param);
		} else if(selectMode.equals("ud") && param.get("isCheckAllDeptEmpShow").toString().equals("true")){
			return commonSql.list("OrgChart.selectUserDeptExtendProfileList", param);
		} else if(selectMode.equals("ud") && param.get("isCheckAllDeptEmpShow").toString().equals("false")){
			return commonSql.list("OrgChart.selectUserDeptProfileList", param);
		} else if(selectMode.equals("od")){
			return commonSql.list("OrgChart.selectOnlyDeptProfileList", param);
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetUserDeptProfileListForDeptAttend(Map<String, Object> param) {
		return commonSql.list("OrgChart.selectUserDeptExtendProfileListAttend", param);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetFilterdUserDeptProfileListForDept(Map<String, Object> param) {
		
		param.put("groupSeq", param.get("groupSeq"));
		param.put("langCode", param.get("langCode"));
		
		/* Data Access Area */
		String selectMode = param.get("selectMode").toString();
		
		if(selectMode.equals("u")){
			return commonSql.list("OrgChart.selectFilterdUserProfileList", param);
		}else if(selectMode.equals("d")){
			return commonSql.list("OrgChart.selectFilterdDeptProfileList", param);
		}else if(selectMode.equals("udd")){
			return commonSql.list("OrgChart.selectFilterdDeptProfileList", param);
		}else if(selectMode.equals("udu")){
			return commonSql.list("OrgChart.selectFilterdUserProfileList", param);
		}else if(selectMode.equals("oc")){
			return commonSql.list("OrgChart.selectFilterdCompProfileList", param);
		}
		return null;
	}
    
    @Override
    public List<Map<String, Object>> GetFilterdUserDeptProfileListForDeptAttend(Map<String, Object> param) {
        
        param.put("groupSeq", param.get("groupSeq"));
        param.put("langCode", param.get("langCode"));
        
        /* Data Access Area */
        String selectMode = param.get("selectMode").toString();
        
        if(selectMode.equals("u")){
            return commonSql.list("OrgChart.selectFilterdUserProfileListAttend", param);
        }
//        else if(selectMode.equals("d")){
//            return commonSql.list("OrgChart.selectFilterdDeptProfileList", param);
//        }else if(selectMode.equals("udd")){
//            return commonSql.list("OrgChart.selectFilterdDeptProfileList", param);
//        }else if(selectMode.equals("udu")){
//            return commonSql.list("OrgChart.selectFilterdUserProfileList", param);
//        }else if(selectMode.equals("oc")){
//            return commonSql.list("OrgChart.selectFilterdCompProfileList", param);
//        }
        return null;
    }
	
	@Override
	public List<Map<String, Object>> GetSelectedUserDeptProfileListForDept(Map<String, Object> param) {
		
		if(param.get("empUniqYn") != null && param.get("empUniqYn").equals("Y")){
			//사원기준 조직도팝업
			return commonSql.list("OrgChart.selectedEmpDeptProfileListEmpUniq", param);
		}else{
			return commonSql.list("OrgChart.selectedEmpDeptProfileList", param);	
		}
		
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetUserDeptList(Map<String, Object> params) {
		List<Map<String, Object>> list = commonSql.list("OrgChart.getCompBizDeptList", params);
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			String gbnOrg = String.valueOf(list.get(i).get("gbn_org"));
			boolean opened = false;
			boolean selected = false;	
			
			//id
			node.put("id", list.get(i).get("id"));
			
			//text
			if (gbnOrg.equals("c")) {
				node.put("text", (String.valueOf(list.get(i).get("comp_name"))));	
			} else if (gbnOrg.equals("b")) {
				node.put("text", (String.valueOf(list.get(i).get("biz_name"))));
			} else if (gbnOrg.equals("d")) {
				node.put("text", (String.valueOf(list.get(i).get("dept_name"))));
			}
			
			//state
			Map<String, Object> state = new HashMap<String, Object>();
			state.put("opened", opened);
			state.put("selected", selected);
			node.put("state", state);
			
			//children
			if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
				node.put("children", false);
			} else {
				node.put("children", true);
			}
			
			pList.add(node);
		}
		
		return pList;
	}
	
	public List<Map<String, Object>> GetUserDeptListJSTree(List<Map<String, Object>> list, Map<String, Object> params) {
		List<Map<String, Object>> tree = new ArrayList<Map<String, Object>>();
		
		if (params.get("parentSeq").equals("0")) {
			//[최초호출]
			
			//자신의 부서 path 가져오기
			List<Map<String, Object>> myPathList = commonSql.list("OrgChart.getMyPath", params);
			String myPath = myPathList.get(0).get("path").toString();
			String[] myPathArr = myPath.split("\\|");
			
			//루트
			List<Map<String, Object>> root = list;
			List<Map<String, Object>> cList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
			int len = myPathArr.length - 1;
			
			//루트 하위의 자신의 부서리스트 모두 가져오기
			for (int i=len; i >= 0; i--) {
				if (i == len) {
					params.put("parentSeq", myPathArr[i]);
					cList = GetUserDeptPathList(params);
				}
				
				if (i != 0) {					
					params.put("parentSeq", myPathArr[i-1]);
					pList = GetUserDeptPathList(params);
				} else {
					pList = root;
				}
								
				for (int j=0; j<pList.size(); j++) {
					if (pList.get(j).get("id").equals(myPathArr[i])) {
						pList.get(j).put("children", cList);
						
						Map<String, Object> state = new HashMap<String, Object>();
						state.put("opened", true);
						state.put("selected", false);						
						if (params.get("deptSeq").equals(pList.get(j).get("id"))) {
							state.put("selected", true);
						}
						pList.get(j).put("state", state);
						
						cList = pList;
					}
				}
			} 			
			
			tree = pList;
		} else {
			//[부서클릭시마다호출]
			
			tree = list;
		}
		
		return tree;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetUserDeptPathList(Map<String, Object> params) {
		
		List<Map<String, Object>> list = commonSql.list("OrgChart.getCompBizDeptList", params);
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			String gbnOrg = String.valueOf(list.get(i).get("gbn_org"));
			boolean opened = false;
			boolean selected = false;	
			
			//id
			node.put("id", list.get(i).get("id"));
			
			//text
			if (gbnOrg.equals("c")) {
				node.put("text", (String.valueOf(list.get(i).get("comp_name"))));	
			} else if (gbnOrg.equals("b")) {
				node.put("text", (String.valueOf(list.get(i).get("biz_name"))));
			} else if (gbnOrg.equals("d")) {
				node.put("text", (String.valueOf(list.get(i).get("dept_name"))));
			}
			
			//icon
			//if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
			//	node.put("icon", "/eap/css/jsTree/ico_tree_LastFolder.png");
			//}
			
			//state
			Map<String, Object> state = new HashMap<String, Object>();
			state.put("opened", opened);
			state.put("selected", selected);
			node.put("state", state);
			
			//children
			if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
				node.put("children", false);
			} else {
				node.put("children", true);
			}			
			
			//li_attr
			
			//a_attr
			
			pList.add(node);
		}
		
		return pList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String GetOrgMyDeptPath(Map<String, Object> params) {
		// 자신의 부서 path 가져오기
		List<Map<String, Object>> myPathList = commonSql.list("OrgChart.getMyPath", params);
		String returnPath = "";
		try{
			returnPath =myPathList.get(0).get("path").toString(); 
		}catch(java.lang.IndexOutOfBoundsException ex){
			returnPath = "-1";
		}
		return returnPath;
	}
	@SuppressWarnings("unchecked")
	@Override
	public String GetOrgMyDeptPathAdmin(Map<String, Object> params) {
		// 자신의 부서 path 가져오기
		List<Map<String, Object>> myPathList = commonSql.list("OrgChart.getMyPathAdmin", params);
		String returnPath = "";
		try{
			returnPath =myPathList.get(0).get("path").toString(); 
		}catch(java.lang.IndexOutOfBoundsException ex){
			returnPath = "-1";
		}
		return returnPath;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetOrgFullList(Map<String, Object> params) {

		String compFilter = params.get("compFilter").toString().replace("'", "");
		
		boolean partYn = params.get("partYn") != null  && params.get("partYn").equals("Y");
		
		if(!compFilter.equals("")){
			String[] comps = compFilter.split(",");
			compFilter = "";
			
			for(int i = 0; i < comps.length; i++){
				compFilter += ", '" + comps[i] + "'";
			}
			compFilter = compFilter.substring(1);
			params.put("compFilter", compFilter);
		}
		
		Map tree = new HashMap<String, Map<String, Object>>();
		Map burffer = new HashMap<String, Map<String, Object>>();
			
		List<Map<String, Object>> list = commonSql.list("OrgChart.selectOrgPartList", params);
		
		List<Map<String, Object>> returnList = new ArrayList<>();

		for (Map<String, Object> item : list) {

			Map<String, Object> node = new HashMap<String, Object>();
			Map<String, Object> nodeState = new HashMap<String, Object>();
			nodeState.put("selected", item.get("selected").toString().equals("1"));
			nodeState.put("opened", item.get("opened").toString().equals("1"));
			
			if(partYn) {
				node.put("childrenOpenYn", item.get("opened").toString().equals("1") ? "Y" : "N");
			}
			
			Map<String, Object> fIcon = new HashMap<String, Object>();
			
			String fColor = "dept_li";
			
			if (item.get("orgDiv").equals("c")) {
				fColor = "comp_li";
			}
			else if (item.get("orgDiv").equals("b")) {
				fColor = "busi_li";
			}
			
			fIcon.put("class", fColor);

			String text = item.get("text") == null ? "" : item.get("text").toString();
			if(!params.get("includeDeptCode").toString().equals("")){
				text += "(" + item.get("orgCd") + ")";
			}
			if(params.get("innerReceiveFlag") != null && params.get("innerReceiveFlag").toString().equals("Y") && item.get("innerReceiveYn").toString().equals("N")){
				text = "<span class=\"text_gray f11 mt5\">" + item.get("text").toString() + "(" + BizboxAMessage.getMessage("TX000008169","수신불가") + ")" + "</span>";
			}
			
			// 여기 구분 값이 필요함.
			node.put("id", item.get("orgDiv").toString() + item.get("id").toString());
			node.put("text",text);
			node.put("state", nodeState);
			node.put("tIcon", fColor);
			node.put("li_attr", fIcon);
			
			if(partYn) {
				node.put("children", item.get("opened").toString().equals("1") ? new ArrayList<Map<String, Object>>() : (item.get("orgDiv").equals("c")));
			}else {
				node.put("children", new ArrayList<Map<String, Object>>());	
			}

			burffer.put(item.get("path"), node);
		}

		ArrayList<String> subArray = new ArrayList<>();
		
		String parentDeptPath = "";
		
		if(partYn && params.get("parentDeptPath") != null && !params.get("parentDeptPath").equals("")) {
			parentDeptPath = params.get("parentDeptPath").toString() + "|";
		}

		for (int i = list.size() - 1; i > -1; i--) {
			
			Map<String, Object> item = list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			String id = item.get("path").toString();
			Map<String, Object> bNode = (Map<String, Object>) burffer.get(id);
			
			node.put("id", bNode.get("id"));
			node.put("text", bNode.get("text"));
			node.put("state", bNode.get("state"));
			node.put("tIcon", bNode.get("tIcon"));
			node.put("li_attr", bNode.get("li_attr"));			
			node.put("children", bNode.get("children"));
			
			if((partYn && !parentDeptPath.equals("") && parentDeptPath.equals(item.get("parent_path"))) || item.get("parent_seq").toString().equals("0")) {
				tree.put(node.get("id"), burffer.get(id));
				subArray.add(0,item.get("orgDiv").toString() + item.get("id").toString());
			} else { 
				try{
					
					if(!partYn || ((Map<String, Object>) burffer.get(item.get("parent_path"))).get("childrenOpenYn").equals("Y")) {
						((ArrayList<Map<String, Object>>) ((Map<String, Object>) burffer.get(item.get("parent_path"))).get("children")).add(0,node);	
					}else {
						((Map<String, Object>) burffer.get(item.get("parent_path"))).put("children", true);
					}
						
				}catch(Exception e){
					CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
					//System.out.println("****  Can't find id : " + item.get("parent_seq") + "  ***");
				}
			}
		}

		for (String item : subArray) {
			returnList.add((Map<String, Object>) tree.get(item));
		}		

		return returnList;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> GetSearchDeptListAdmin(Map<String, Object> params) {
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		try {
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
			params.put("group_seq", loginVO.getGroupSeq());
			params.put("lang_code", loginVO.getLangCode());
			resultList = commonSql.list("OrgChart.selectFilterdDeptProfileListAdmin", params);
		} catch (Exception e) {
			resultList = new ArrayList<Map<String, Object>>();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return resultList;
	}	
	

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCompBizDeptListForAdmin(Map<String, Object> params) {
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		if (params.get("gbnOrg") != null) {
			if(params.get("gbnOrg").toString().equals("c")) {
				list = commonSql.list("OrgChart.getBizListForAdmin", params);
			}
			else{
				String pSeq = (String) params.get("parentSeq");
				if(params.get("gbnOrg").toString().equals("b") && !pSeq.equals("0")) {
					pSeq = pSeq.substring(1, pSeq.length());
					
					params.put("parentSeq", pSeq);
				}
				
				list = commonSql.list("OrgChart.getCompBizDeptListForAdmin", params);
			}
		}
		else {
			list = commonSql.list("OrgChart.getCompBizDeptListForAdmin", params);
		}
		
		List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i<list.size(); i++) {
			Map<String, Object> node = new HashMap<String, Object>();
			String bizSeq = String.valueOf(list.get(i).get("biz_seq"));
			String gbnOrg = String.valueOf(list.get(i).get("gbn_org"));
			boolean opened = false;
			boolean selected = false;	
			
			node.put("id", list.get(i).get("id"));
			node.put("bizSeq", bizSeq);
			node.put("gbnOrg", gbnOrg);
			//node.put("deptSeq", list.get(i).get("deptSeq"));
			
			Map<String, Object> fIcon = new HashMap<String, Object>();
			String fColor = "comp_li";
			if (gbnOrg.equals("b")) {
				fColor = "busi_li";
			}
			else if (gbnOrg.equals("d")) {
				fColor = "";
				if (list.get(i).get("team_yn").toString().equals("Y")) {
					fColor = "col_green";
				}
			}
			fIcon.put("class", fColor);
			
			node.put("tIcon", fColor);
			node.put("li_attr", fIcon);
			
			//text
			if (gbnOrg.equals("c")) {
				node.put("text", (String.valueOf(list.get(i).get("comp_name"))));
			} else if (gbnOrg.equals("b")) {
				node.put("text", (String.valueOf(list.get(i).get("biz_name"))));
			} else if (gbnOrg.equals("d")) {
				node.put("text", (String.valueOf(list.get(i).get("dept_name"))));
			}
			
			//state
			Map<String, Object> state = new HashMap<String, Object>();
			state.put("opened", opened);
			state.put("selected", selected);
			node.put("state", state);
			
			//children
			if (String.valueOf(list.get(i).get("children_cnt")).equals("0")) {
				node.put("children", false);
			} else {
				node.put("children", true);
			}
			
			pList.add(node);
		}
		//System.out.println("ret===============> "+pList);
		
		return pList;
	}
	

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOrgChartTreeForAdmin(List<Map<String, Object>> list, Map<String, Object> params) {
		
		List<Map<String, Object>> tree = new ArrayList<Map<String, Object>>();
		
		if (params.get("parentSeq").equals("0")) {
			//[최초호출]
			
			//자신의 부서정보 가져오기
			List<Map<String, Object>> myPathList = commonSql.list("OrgChart.getMyPathAdmin", params);
			String myPath = myPathList.get(0).get("path").toString();
			String[] myPathArr = myPath.split("\\|");
			
			//루트
			List<Map<String, Object>> root = list;
			//List<Map<String, Object>> cList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> pList = new ArrayList<Map<String, Object>>();
			int len = myPathArr.length - 1;
			
			//루트 하위의 자신의 부서리스트 모두 가져오기
			for (int i=len; i >= 0; i--) {
				if (i == len) {
					params.put("parentSeq", myPathArr[i]);
					//cList = getCompBizDeptList(params);
				}
				
				if (i != 0) {					
					params.put("parentSeq", myPathArr[i-1]);
					pList = getCompBizDeptList(params);
				} else {
					pList = root;
				}
			}		
			
			tree = pList;
			
		} else {
			
			//[부서클릭시마다호출]
			tree = list;
			
		}
		
		
		return tree;
	}

	@Override
	public List<Map<String, Object>> getUserInfoList(Map<String, Object> params) {
		return commonSql.list("OrgChart.getUserInfoList", params);
	}
	
	@Override
	public List<Map<String, Object>> getUserFormList(Map<String, Object> params) {
		return commonSql.list("OrgChart.getUserFormList", params);
	}	
	
	public List<Map<String, Object>> GetBizProfileListForBiz(Map<String, Object> param) {

		return commonSql.list("OrgChart.selectBizProfileList", param);
		
	}
	
	@Override
	public List<Map<String, Object>> GetFilterdBizProfileListForBiz(Map<String, Object> param) {
		
		param.put("groupSeq", param.get("groupSeq"));
		param.put("langCode", param.get("langCode"));
		
		/* Data Access Area */
		String selectMode = param.get("selectMode").toString();
		
		if(selectMode.equals("b")){
			return commonSql.list("OrgChart.selectFilterdBizProfileList", param);
		}
		return null;
	}
	
	@Override
	public List<Map<String, Object>> GetSelectedBizProfileListBiz(Map<String, Object> param) {
				
		/* Data Access Area */
		return commonSql.list("OrgChart.selectedBizProfileList", param);
	}
}
