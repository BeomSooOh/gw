<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var orgChartList = null;	// 조직도 리스트
	var dupOrgEmpListJson = null;	// 중복 처리할 사용자 리스트
	var dupOrgDeptListJson = null;	// 중복 처리할 부서 리스트
	var deIdx = 0;	// 사용자/부서 선택 테이블 인덱스
	var selIdx = 0;	// 검색 선택 처리 인덱스
	
	var moduleType = "e";	//e : 사원선택, d : 부서선택, ed : 사원, 부서 선택
	var selectType = "s";	//s : 단일선택, m : 다중선택
	
	var mode = '${params.mode}';
	var langCode = '${params.langCode}';
	var groupSeq = '${params.groupSeq}';
	var compSeq = '${params.compSeq}';
	var langCode = '${params.langCode}';
	
	$(document).ready(function() {
		<c:if test="${not empty dupOrgDeptListJson}">
		dupOrgDeptListJson = ${dupOrgDeptListJson};
		</c:if>
		<c:if test="${not empty dupOrgEmpListJson}">
		dupOrgEmpListJson = ${dupOrgEmpListJson};
		</c:if>
		<c:if test="${not empty params.moduleType}">
		moduleType = "${params.moduleType}";
		</c:if>
		<c:if test="${not empty params.selectType}">
		selectType = "${params.selectType}";
		</c:if>
		
		// treeview 처리시 데이터가 많을 경우 화면 멈춤으로 로딩바 보여주기
		// 하지만 여전시 화면이 렉걸리는 현상 문제...kendo ui 속도 이슈..
		kendo.ui.progress($(".pop_con"), true);
		setTimeout("init()", 100);
			
		//기본버튼
        $(".controll_btn button").kendoButton();

		//조직도검색 셀렉트
		$("#organ_sel").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000000862","전체")%>", "<%=BizboxAMessage.getMessage("TX000000286","사용자")%>", "<%=BizboxAMessage.getMessage("TX000000098","부서")%>"]
				},
				value:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>"
		});

		// 조직도 검색
		$("#orgchartSearch").on("click", function(e){
				searchKeyword();
		});
		
		$("#edCheckAll").on("click", function(e){
			if(this.checked) {
				$("#selEmpDeptTable input[name=inp_chk]:checkbox").each(function() {
					$(this).prop("checked", true);
				});
			} else {
				$("#selEmpDeptTable input[name=inp_chk]:checkbox").each(function() {
					$(this).prop("checked", false);
				});
			}
		});
		
		
		$("#delEdBtn").on("click", function(e){
			removeEdTable();
		});
		
		<c:if test="${not empty selectedList}">
		deIdx = ${fn:length(selectedList)};
		</c:if>
		
		$("#okBtn").on("click", ok);
		
		$("#searchKeyword").keydown(function (event) {
           if (event.keyCode == 13) {
               searchKeyword();
           }
       });
		
	});
	
	function searchText() {
		if (getTabType() == 0) {
				searchKeyword();
			} else {
				focusSearch();
			}
	}
	
	// 초기화
	function init() {
		try {
			// treeview
			<c:if test="${not empty orgChartList}">
				orgChartList = ${orgChartList};
				tvInit(orgChartList);
			</c:if>
			
			selectedData();
			
			//closeTreeView();
			
			focusTreeView('${params.focusSeq}');

		
			kendo.ui.progress($(".pop_con"), false);
		
		} catch(exception) {
			alert("<%=BizboxAMessage.getMessage("TX000010612","조직도를 생성 중 문제가 발생하였습니다")%>");
		}  finally {
			kendo.ui.progress($(".pop_con"), false);
		}
	}
	
	// 사용자 중복 처리
	function isDupEmp(item) {
		if (dupOrgEmpListJson != null && dupOrgEmpListJson.length > 0) {
			for(var i = 0 ; i < dupOrgEmpListJson.length; i++) {
				if(dupOrgEmpListJson[i] != null && dupOrgEmpListJson[i].seq == item.seq) {
					alert("["+item.name+"] "+"<%=BizboxAMessage.getMessage("TX000010611","이미 등록된 사원입니다. 　사용된 다른 정보에서 제외하시면 사원을 선택하실 수 있습니다.")%>".replace("　","\n"));
					unCheckTreeview(item.seq);
					return true;
				}
			}
		}
		return false;
	}
	
	// 부서 중복처리
	function isDupDept(item) {
		if (dupOrgDeptListJson != null && dupOrgDeptListJson.length > 0) {
			for(var i = 0 ; i < dupOrgDeptListJson.length; i++) {
				if(dupOrgDeptListJson[i] != null && dupOrgDeptListJson[i].seq == item.seq) {
					alert("["+item.name+"] "+"<%=BizboxAMessage.getMessage("TX000010610","이미 등록된 부서입니다. 　사용된 다른 정보에서 제외하시면 부서를 선택하실 수 있습니다.")%>".replace("　","\n"));
					unCheckTreeview(item.seq);
					return true;
				}
			}
		}
		return false;
	}
	
	// 선택 테이블 삭제 처리
	function removeEdTable() {
		var arr = $("#selEmpDeptForm").find("input[name=inp_chk]:checked");
		if (arr.length > 0) {
			for(var i = 0; i < arr.length; i++) {
				var _tr = $(arr[i]).parent().parent();
				//var seq = $(_tr).find("input[name=seq]").val();
				unCheckTreeview(_tr);
				$(_tr).remove();
			}
		}	
		
		$("#edCheckAll").prop("checked",false);
		
		setCount();
	}
	
	// 트리뷰 uncheck 처리
	function unCheckTreeview(_tr) {
		var seq = $(_tr).find("input[name=seq]").val();
		var name = null;
		var gbn = $(_tr).find("input[name=gbn]").val();
		if(gbn == 'g') {
			name = $(_tr).find("input[name=groupName]").val();
		} else if(gbn == 'c') {
			name = $(_tr).find("input[name=compName]").val();
		} else if(gbn == 'd') {
			name = $(_tr).find("input[name=deptName]").val();
		} else if(gbn == 'm') {
			name = $(_tr).find("input[name=empName]").val();
		} 
		
		var treeview = $("#treeview").data("kendoTreeView");
		var dataItem = treeview.dataSource.get(seq);
		if (dataItem != null && dataItem.uid != null) {
			var node = treeview.findByUid(dataItem.uid);
			
			if(name != dataItem.name) {
				node = treeview.findByText(name);
			}
			
			treeview.dataItem(node).set("checked", false);
			
		}
	}
	
	// 이미 선택된 데이터 체크 처리
	function selectedData() {
		var sOrgEmpListJson = null;
		var sOrgDeptListJson = null;
		<c:if test="${not empty sOrgEmpListJson}">
			sOrgEmpListJson = ${sOrgEmpListJson};
		</c:if>
		<c:if test="${not empty sOrgDeptListJson}">
			sOrgDeptListJson = ${sOrgDeptListJson};
		</c:if>
		
		// 선택된 부서리스트 체크 처리
		var treeview = $("#treeview").data("kendoTreeView");
		var firstNode = null;
		if(sOrgDeptListJson != null) {
			for(var i = 0; i < sOrgDeptListJson.length; i++) {
				var dataItem = treeview.dataSource.get(sOrgDeptListJson[i].seq);
				var node = treeview.findByUid(dataItem.uid);
				treeview.dataItem(node).set("checked", true);
				if(firstNode == null) {
					firstNode = node;
				}
			}
		}
		
		// 선택된 사용자 체크 처리
		if(sOrgEmpListJson != null) {
			if(moduleType != 'd') {
				setTreeViewSelect(sOrgEmpListJson);
			
				for(var i = 0; i < sOrgEmpListJson.length; i++) {
					var dataItem = treeview.dataSource.get(sOrgEmpListJson[i].seq);
					var node = treeview.findByUid(dataItem.uid);
					
					// seq가 uniqu 하지 않음. 그래서 네임도 비교.
					var nodeName = dataItem.name;
					if (nodeName == sOrgEmpListJson[i].seqName) {
					} 
					// seq는 동일하나 네임이 다른경우.
					else {
						dataItem = treeview.findByText(sOrgEmpListJson[i].seqName);
						node = dataItem;
					}
					
					treeview.dataItem(node).set("checked", true);
					
					if(firstNode == null) {
						firstNode = node;
					}
				}
			}
		}
		
		if(firstNode != null) {
			
			treeAutoScroll(firstNode);
			if(selectType == 's') { 
				treeview.select(firstNode);	
			}
		} 
		// 기본선택
		else {
			var n = [{seq:'${loginVO.orgnztId}',deptSeq:'${loginVO.orgnztId}', firstNodeYn:'Y'}];
			setTreeViewSelect(n);
		}
		
		setCount();
		
	}
	
	function closeTreeView() {
		var treeview = $("#treeview").data("kendoTreeView");
		treeview.collapse(".k-item:not(:first)");
	}
	
	function focusTreeView(seq) {
		var treeview = $("#treeview").data("kendoTreeView");
		var datasource = treeview.dataSource;
		
		var dataItem = datasource.get(seq);	
		if (dataItem != null) {									// 부서 정보가 treeview에 있는 확인
			var node = treeview.findByUid(dataItem.uid);		// 해당 node를 가져옴
			if (node != null){	// node 확인
				//treeview.expandTo(dataItem);
				treeview.select(node);							// node를 treeview 선택처리
				treeAutoScroll(node);
			}
		}
	}
	
	// 트리뷰 검색 포커스 처리
	function focusSearch() {
		var tv = $("#treeview").data("kendoTreeView");
	    var term = $("#searchKeyword").val();
	    var tlen = term.length;
	    
		/* $('span.k-in > span.highlight').each(function(){
			$(this).parent().html($(this).parent().html());
	    });  */
		
		if ($.trim(term) == '') { return; }
		var selList = [];
	    $('#treeview span.k-in').each(function(index){
	        var text = $(this).text();
	        $(this).parent().css("color", "");
	        $(this).parent().css("font-weight", "");
	        
	        if (text.indexOf("<span>") > -1) {
	        	text = $(text).text();
	        }
	        var html = '';
	        var q = 0;
	        while ((p = text.indexOf(term,q)) >= 0) 
	        {
	            html = $(this).html();
	            q = p + tlen;
	            
	        }
	        
	        if (q > 0) { 
	            $(this).parent().css("color", "blue");
	        	$(this).parent().css("font-weight", "bold");
	            selList.push(this);
	            $(this).parentsUntil('.k-treeview').filter('.k-item').each(
	                function (index,element) {
	                    tv.expand($(this));
	                    $(this).data('search-term',term);
	                }
	            );
	        }
	        
	        
	    });
	
	    $('#treeview .k-item').each(function(){
	        if ($(this).data('search-term') != term) {
	            tv.collapse($(this));
	        }
	    });
	    
	    if (selList[selIdx] == null) {
	    	selIdx = 0;
	    } 
	    
	    treeAutoScroll(selList[selIdx]);
	    
	    selIdx++;
	}
	
	// 트리뷰 스크롤 자동 이동
	function treeAutoScroll(sel) {
		var position = $(sel).offset();
		$('#treeview').animate({scrollTop : position.top-200}, 500);
		
		
	}
	
	// 검색하기
	function searchKeyword() {
		var searchKeyword = $("#searchKeyword").val();
		var searchType = $("#organ_sel").val();
		
		if (searchKeyword.length == 0) {
			alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>");
			return;
		}
		
		var isGroupAll = '${params.isGroupAll}';
		
		searchItem = {searchType:searchType, nameAndLoginId : searchKeyword, groupSeq:groupSeq, mode:mode, langCode:langCode, isGroupAll:isGroupAll};
		isFirstSelected = false; // 선택 표시 초기화
		
		var list = null;
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
			data:searchItem,
			datatype:"json",
			async:false,
			success:function(data){
				if (data.list) {
					list = data.list;
					 
					
					//focusSearch();
				}
			}
		});
		
		if (list != null) {
			setTreeViewSelect(list);
		}
		
		focusSearch();
	}
	
	// 사용자를 검색하면 결과로 사원 리스트가 오는데
	// 부서정보를 조회하여 해당 treeview에 사원 리스트를 재검색하여 추가
	function setTreeViewSelect(nodes) {
		var treeview = $("#treeview").data("kendoTreeView");
		var datasource = treeview.dataSource;
		
		var l = CommonKendo.getTreeToJson(treeview);
		
		
		for(var i = 0; i < nodes.length; i++) {						// 사원 리스트만큼 반복
			var dataItem = datasource.get(nodes[i].deptSeq);		// 부서 정보로 item 확인
			console.log('nodes[i].deptSeq : ' + nodes[i].deptSeq);
			if (dataItem != null) {									// 부서 정보가 treeview에 있는 확인
				var node = treeview.findByUid(dataItem.uid);		// 해당 node를 가져옴
				console.log('dataItem.uid : ' + dataItem.uid);
				if (node != null && dataItem.nodes.length == 0){	// node 확인
					treeview.select(node);							// node를 treeview 선택처리
					console.log(node);
					setEmpList(dataItem);							// 해당 부서의 사원들을 모두 조회하여 append
					console.log(treeview.select());		
					//treeview.select($());							// 선택 초기화
				}
			}
		}
		treeview.select($());	
		
	}
	
	// 부서의 사원 리스트 조회
	function setEmpList(item) {
		
		// 부서 선택이면 사원정보 없음.
		if(moduleType == 'd') {
			return;
		}
		
		var treeview = $("#treeview").data("kendoTreeView");
		
		var list = null;
		var isGroupAll = '${params.isGroupAll}';
		
		var selectedNode = treeview.select();
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
				data:{groupSeq:item.groupSeq, deptSeq:item.seq, mode:mode, langCode:langCode, isGroupAll:isGroupAll},
				async:false,
				datatype:"json",			
				success:function(data){
					if (data.list) {
						list = data.list;
						for(var i = 0 ; i < list.length; i++) {
							
	                         if (selectedNode.length == 0) {
	                             selectedNode = null;
	                         } 
	                            
	                         // 자식 노드 없음
	                         list[i].hasChildren = false;
	                         //treeview에 추가
	                         treeview.append(list[i], selectedNode);
	                        
						}
					}
			}
		});
		
		return list;
	}
	
	// 트리뷰 초기화	
	function tvInit(ocList) {
		var inline = new kendo.data.HierarchicalDataSource({
	                data: [ocList],
	                schema: {
                        model: {
                        	id: "seq",
                            children: "nodes"
                        } 
                    }
	   });
	
	   if (selectType == 'm') {
		   $("#treeview").kendoTreeView({
			   checkboxes: {
		         /*  checkChildren:true */
		      },
	          dataSource: inline,
	          select: onSelectTree,
	          check: onCheck, 
	          dataTextField: ["name"],
	          dataValueField: ["seq", "gbn"]
	       }); 
	   } else {
		   $("#treeview").kendoTreeView({
	          dataSource: inline,
	          select: onSelectTree,
	          dataTextField: ["name"],
	          dataValueField: ["seq", "gbn"]
	       }); 
	   }
	   
	}
	
	// 트리뷰 선택 처리
	function onSelectTree(e) {
	   var item = e.sender.dataItem(e.node);
	   callbackOrgChart(item);	// 반드시 구현
	   
	     // 단일 체크
    	   if(selectType == 's') {
    		   if(moduleType == 'e' && (item.gbn == 'd' ||item.gbn == 'c' || item.gbn == 'g')) {
    			   return;
    		   }
    		   var rowCount = $('#selEmpDeptTable tr').length;
    		   if (rowCount > 0) {
    			   $("#selEmpDeptTable tbody tr:last").remove();
    		   }
    		   var item = e.sender.dataItem(e.node);
    		   
    		   var isDup = false;
    	   		if (item.gbn == 'd') {
    	   			isDup = isDupDept(item);
    	   		} else if (item.gbn == 'm') {
    	   			isDup = isDupEmp(item);
    	   		}
    	   		if (isDup == false) {
		   			addSelEmpDeptTable(item);
    	   		}
    	   }
	}
	
	// 트리뷰 체크 처리
	function onCheck(e) {
       var item = e.sender.dataItem(e.node);
       
      	var checkedNodes = [],
                treeView = $("#treeview").data("kendoTreeView");

         checkedNodeIds(treeView.dataSource.view(), checkedNodes);

       
       //if (item.checked) {
    	   
    	   // 단일 체크
    	  /*  if(selectType == 's') {
    		   var rowCount = $('#selEmpDeptTable tr').length;
    		   if (rowCount > 0) {
    			    $("#selEmpDeptTable tr").remove();
    		   }
    	   } */
    	   
    	   $("#selEmpDeptTable tr").remove();
    	   
    	   if (checkedNodes.length > 0) {
    			checkedNodes = onCheckSetEmpList(checkedNodes);
    	   }
    	   
    	   checkedNodes = [];
    	   checkedNodeIds(treeView.dataSource.view(), checkedNodes);
    	   
    	   if (checkedNodes.length > 0) {
    		   
    	   		for(var i = 0; i < checkedNodes.length; i++) {
    	   			var isDup = false;
    	   			if (checkedNodes[i] == null) {  
    	   			}
    	   			else if (checkedNodes[i].gbn == 'd') { 
    	   				isDup = isDupDept(checkedNodes[i]);
    	   			} else if (checkedNodes[i].gbn == 'm') {
    	   				isDup = isDupEmp(checkedNodes[i]);
    	   			}
    	   			if (isDup == false) {
		   				addSelEmpDeptTable(checkedNodes[i]);
    	   			}
    	   		}
    	   }
		   
      // } else {
    	   //removeSelEmpDpetTable(item.seq);
       //}
	   setCount();	   
    } 
	
	function onCheckSetEmpList(checkedNodes) {
		var treeview = $("#treeview").data("kendoTreeView");
		if (checkedNodes.length > 0) {
    	   	for(var i = 0; i < checkedNodes.length; i++) {
    	   		if (checkedNodes[i].gbn == 'd') {
    	   			if(moduleType == 'e' || moduleType == 'ed') {
    	   				var dataItem = treeview.dataSource.get(checkedNodes[i].seq);		// 부서 정보로 item 확인
						if (dataItem != null && dataItem.nodes.length == 0) {									// 부서 정보가 treeview에 있는 확인
							var node = treeview.findByUid(dataItem.uid);		// 해당 node를 가져옴
	    	   				treeview.select(node);
    	   					setEmpList(checkedNodes[i]);
    	   					treeview.select($());
						}
    	   			}
    	   		}//if (node != null && dataItem.nodes.length == 0){
    	   	}
		}
	}
	
	// 트리뷰 체크 목록
	function checkedNodeIds(nodes, checkedNodes) {
       for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].checked) {
                checkedNodes.push(nodes[i]);
            }

            if (nodes[i].hasChildren) {
                checkedNodeIds(nodes[i].children.view(), checkedNodes);
            }
        }
    }
	
	// 체크 리스트 테이블 row 삭제
	function removeSelEmpDpetTable(seq) {
		$("#seq"+seq).remove();
	}
	
	// 사용자부서 추가 테이블
	function addSelEmpDeptTable(item) {
		console.log(item);
		 if(moduleType == 'e' && (item.gbn == 'd' ||item.gbn == 'c' || item.gbn == 'g')) {
    	   	return; 
      	 }
		
		
		var name = "<input type=\"hidden\" name=\"seq\" value=\""+item.seq +"\" />";
		var dutyName = " ";
		var seq = item.seq;
		var deptName = "";
		if (item.gbn == 'd') { 
			deptName = item.name;
			seqName = item.compName; 
		} else if (item.gbn == 'c') {
			seqName = item.compName;
		} else if (item.gbn == 'g') {
			seqName = item.name;
		} else if (item.gbn == 'm') {
			deptName = item.deptName;
			if (item.dutyCodeName != null && item.dutyCodeName != 'null') {
				dutyName = item.dutyCodeName;
			}
		} else {
		}
		
		if (item.gbn == 'm') {
			name += item.name + "<input type=\"hidden\" name=\"empName\" value=\""+item.name +"\" />";
			name += "<input type=\"hidden\" name=\"empSeq\" value=\""+item.seq +"\" />";
			name += "<input type=\"hidden\" name=\"deptSeq\" value=\""+item.deptSeq +"\" />";
			name += "<input type=\"hidden\" name=\"compSeq\" value=\""+item.compSeq +"\" />";
			name += "<input type=\"hidden\" name=\"gbn\" value=\"m\" />";
			name += "<input type=\"hidden\" name=\"bizSeq\" value=\""+item.bizSeq +"\" />";
			name += "<input type=\"hidden\" name=\"groupSeq\" value=\""+item.groupSeq +"\" />";
			name += "<input type=\"hidden\" name=\"deptName\" value=\""+deptName +"\" />" ;
			name += "<input type=\"hidden\" name=\"dutyName\" value=\""+dutyName +"\" />" ;
		} 
		else if (item.gbn == 'g') {
			name += seqName + "<input type=\"hidden\" name=\"groupName\" value=\""+seqName +"\" />";
			name += "<input type=\"hidden\" name=\"gbn\" value=\""+item.gbn +"\" />";
			name += "<input type=\"hidden\" name=\"groupSeq\" value=\""+item.groupSeq +"\" />";
		}
		else {
			name += seqName + "<input type=\"hidden\" name=\"compName\" value=\""+seqName +"\" />";
			name += "<input type=\"hidden\" name=\"compSeq\" value=\""+item.compSeq +"\" />";
			name += "<input type=\"hidden\" name=\"deptName\" value=\""+ deptName +"\" />";
			name += "<input type=\"hidden\" name=\"deptSeq\" value=\""+item.deptSeq +"\" />";
			name += "<input type=\"hidden\" name=\"gbn\" value=\""+item.gbn +"\" />";
			name += "<input type=\"hidden\" name=\"bizSeq\" value=\""+item.bizSeq +"\" />";
			name += "<input type=\"hidden\" name=\"groupSeq\" value=\""+item.groupSeq +"\" />";
			name += "<input type=\"hidden\" name=\"pathName\" value=\""+item.pathName +"\" />";
			//deptName = item.name;
		}
		
		var h = "<tr id=\"seq"+seq+"\">" +
						"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk\" id=\"edCheck"+deIdx+"\" class=\"k-checkbox\">" +
							"<label class=\"k-checkbox-label\" for=\"edCheck"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
						"</td>" +
						"<td class=\"le\">"+name+"</td>" +
						"<td class=\"\">"+deptName+"</td>" +
						"<td class=\"\">"+dutyName+"</td>" +
					"</tr>";
		//alert(html);
		$("#selEmpDeptTable").append(h);
		deIdx++;  
		
	}
	
	// 트리뷰에서 부서 선택시 사용자 정보 조회 append 처리
	function callbackOrgChart(item) {
		if(moduleType == 'e' || moduleType == 'ed') {
		} else {
			return;
		}
		
	
		
		if (item.nodes != null && item.nodes.length == 0) {
			var isGroupAll = '${params.isGroupAll}';
				$.ajax({
					type:"post",
					url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
					data:{groupSeq:item.groupSeq, deptSeq : item.seq, mode:mode, langCode:langCode, isGroupAll:isGroupAll},
					datatype:"json",			
					success:function(data){
						var treeview = $("#treeview").data("kendoTreeView");
						var selectedNode = treeview.select();
						if (data.list) {
							var list = data.list;
							for(var i = 0 ; i < list.length; i++) {
								
								selectedNode = treeview.select();
								
			                     if (selectedNode.length == 0) {
			                         selectedNode = null;
			                     } 
			                                              
			                     list[i].hasChildren = false;
			                     treeview.append(list[i], selectedNode);
			 
							}
						}
						 
					}
				});
		} else {
			
			// 반드시 구현
			//getEmpInfo(item);
		}
	}
	
	// 선택 리스트 카운트
	function setCount() {
			
		if(selectType == 'm') { 
			var rowCount = $('#selEmpDeptTable tr').length;
					
			$("#selectEmpCount").html("("+rowCount+")");
		}
	}
	
	// 저장버튼
	function ok() {
		var formId = "selEmpDeptForm";
		
		var data = {};
		
		var selectedList = [];
		var selectedOrgList = [];
		var obj = {};
			var formdata = $("#"+formId).serializeArray();
			
			for(var i = 0; i < formdata.length; i++) {
				var item = formdata[i];
				if(item.name == "seq") {
					if (i != 0) {
						selectedList.push(obj); 
					} 
					obj = {};
				}
					
				obj[item.name] = item.value;
			}
			selectedList.push(obj);  
		
		
		/** 조직도 선택 리스트 */
		if (selectType == 'm') {
			selectedOrgList = CommonKendo.getTreeCheckedList($("#treeview").data("kendoTreeView"));
		} else {
			var treeview = $("#treeview").data("kendoTreeView");
			var dataItem = treeview.dataSource.get(selectedList[0].seq);
			selectedOrgList = selectedList;
		}
		
		data['moduleType'] = moduleType;
		data['selectType'] = selectType;
		data['selectedList'] = selectedList;
		data['selectedOrgList'] = selectedOrgList;
		
		var callback = '${callback}';
		try {
			if (callback) {
				eval('window.opener.' + callback)(data);
			} else {
				opener.callbackSelectUser(data);
			}
		} catch(exception) {
			var callbackUrl = "${params.callbackUrl}";
			var callbackFunction = "${params.callback}";
			data['callback'] = callbackFunction;
			
			$("#data").val(JSON.stringify(data));
			document.middleForm.action = callbackUrl;
			document.middleForm.submit();
			
			//document.getElementById("middleFrame").src = callbackUrl+"?data="+JSON.stringify(data);
		}
		window.close(); 
	};
	
	// 창닫기 처리 
	function popClose() { 
		window.close();
		var callbackUrl = "${params.callbackUrl}";
		if (callbackUrl != null && callbackUrl != '') {
			document.middleForm.action = callbackUrl+"?popClose=1";
			document.middleForm.submit();
		}
	}
		
</script>
	
<input type="hidden" id="compSeq" name="compSeq" value="${compSeq}" />	
	
<div class="pop_wrap organ_wrap" style="width:670px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000004738","조직도")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>
					
	<div class="pop_con">
			<div class="box_left" style="width:270px;">			
	
				<p class="record_tabSearch">
					<input id="organ_sel" style="width:66px;" />
					<input class="k-textbox input_search" id="searchKeyword" type="text" value="" style="width:145px;" placeholder="">
					<a href="#" class="btn_search" id="orgchartSearch" ></a>
				</p>
	
				<!-- 조직도-->
				<div class="treeCon brbn" >									
					<div id="treeview" class="tree_icon" style="height:417px;"></div>
				</div> 		
						
			</div><!-- //box_left -->	

			<div class="box_right2" style="width:330px;">
				<div class="option_top">
					<ul>
						<li>
							<c:choose>
								<c:when test="${params.moduleType == 'e'}"><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%></c:when>
								<c:when test="${params.moduleType == 'd'}"><%=BizboxAMessage.getMessage("TX000016201","선택된 부서 목록")%></c:when>
								<c:when test="${params.moduleType == 'ed'}"><%=BizboxAMessage.getMessage("TX000016200","선택된 부서/사원 목록")%></c:when>
								<c:otherwise><%=BizboxAMessage.getMessage("TX000016200","선택된 부서/사원 목록")%></c:otherwise>
							</c:choose>
							<c:if test="${params.selectType == 'm'}">
							<span id="selectEmpCount">(0)</span>
							</c:if>
						</li>
					</ul>
					
					<div id="" class="controll_btn" style="padding:0px;float:right;">
						<button id="delEdBtn" type="button">삭제</button>
					</div>
				</div>
	
				<div class="com_ta2">
					<table>
						<colgroup>
							<col width="35"/>
							<col width="120"/>
							<col width="85"/>
							<col />
						</colgroup>
						<tr>
							<th class="">
								<input type="checkbox" name="inp_chk" id="edCheckAll" class="k-checkbox">
								<label class="k-checkbox-label" for="edCheckAll" style="padding:0.2em 0 0 10px;"></label>
							</th>
							<th class="le"><%=BizboxAMessage.getMessage("TX000016069","회사/이름(아이디)")%></th>
							<th class=""><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
							<th class=""><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
						</tr>
					</table>
				</div>	
				
				<!-- 개인/부서 선택 리스트 -->
				<form id="selEmpDeptForm">
				<div class="com_ta2 ova_sc"style="height:387px;margin-top:0px;">
					<table id="selEmpDeptTable">
						<colgroup>
							<col width="35"/>
							<col width="120"/>
							<col width="85"/>
							<col />
						</colgroup>
	
						<c:forEach items="${selectedList}" var="selList" varStatus="c">
							<c:if test="${selList.gbn == 'm'}">
								<tr id="seq${selList.seq}">
									<td class="">
										<input name="inp_chk" class="k-checkbox" id="edCheck${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck${c.count}"></label>
									</td>
									<td class="le">
										<input name="seq" type="hidden" value="${selList.seq}">${selList.seqName}<input name="empName" type="hidden" value="${selList.seqName}">
										<input name="empSeq" type="hidden" value="${selList.empSeq}"><input name="deptSeq" type="hidden" value="${selList.deptSeq}">
										<input name="compSeq" type="hidden" value="${selList.compSeq}"><input name="gbn" type="hidden" value="${selList.gbn}">
										<input name="bizSeq" type="hidden" value="${selList.bizSeq}"><input name="groupSeq" type="hidden" value="${selList.groupSeq}">
									</td>
									<td class="">${selList.deptName}<input name="deptName" type="hidden" value="${selList.deptName}"></td>
									<td>${selList.dutyName}<input name="dutyName" type="hidden" value="${selList.dutyName}"></td>
								</tr>
							</c:if>
							
							<c:if test="${selList.gbn != 'm'}">
								<tr id="seq${selList.seq}">
									<td class="">
										<input name="inp_chk" class="k-checkbox" id="edCheck${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck${c.count}"></label>
									</td>
									<td class="le">
										<input name="seq" type="hidden" value="${selList.seq}">
										<c:if test="${selList.gbn != 'g'}">
										${selList.compName}
										<input name="compName" type="hidden" value="${selList.compName}">
										<input name="compSeq" type="hidden" value="${selList.compSeq}"> 
										</c:if>
										<c:if test="${selList.gbn == 'g'}">
										${selList.seqName}
										<input name="groupName" type="hidden" value="${selList.seqName}">
										</c:if>
										<c:if test="${selList.gbn == 'd'}">
										<input name="deptName" type="hidden" value="${selList.deptName}">
										<input name="deptSeq" type="hidden" value="${selList.seq}">
										</c:if>
										<input name="gbn" type="hidden" value="${selList.gbn}">
										<input name="bizSeq" type="hidden" value="${selList.bizSeq}">
										<input name="groupSeq" type="hidden" value="${selList.groupSeq}">
									</td>
									<td class="">${selList.deptName}</td>
									<td> </td>
								</tr>
							</c:if>
						</c:forEach>
					</table>
				</div>
				</form>
			</div><!-- //box_right2 -->
			
		</div><!-- //pop_con -->		
  
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="okBtn" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
				<input type="button" class="gray_btn" onclick="popClose()" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
			</div>
		</div><!-- //pop_foot -->
		
	</div><!-- //pop_wrap --> 
	
	<iframe id="middleFrame" name="middleFrame" height=0 width=0 frameborder=0 scrolling=no></iframe>
	
	<form id="middleForm" name="middleForm" target="middleFrame" method="post">
		<input type="hidden" name="data" id="data" value="">
	</form>
	
