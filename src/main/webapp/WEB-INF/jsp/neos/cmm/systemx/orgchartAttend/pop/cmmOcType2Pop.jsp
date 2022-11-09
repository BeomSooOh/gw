<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var orgChartList = null;		
	var deIdx = 0;
	var selIdx = 0;
	var poIdx = 0;
	var duIdx = 0;
	
	var mode = '${params.mode}';
	var langCode = '${params.langCode}';
	var groupSeq = '${params.groupSeq}';
	var compSeq = '${params.compSeq}';
	var langCode = '${params.langCode}';
	
	var stOrgEmpDeptList = null;
	var stOrgPositionList = null;
	var stOrgDutyList = null;
	
	$(document).ready(function() {
		kendo.ui.progress($(".pop_wrap"), true);
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

		//탭
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: ""
				}
			},
			select:onTabSelect
		});
		
		//$("#tabstrip").val("사용자");
		
		// 조직도 검색
		$("#orgchartSearch").on("click", function(e){
			searchText();
			
		});
		// 직책, 직급 검색
		$(".btn_search").on("click", function(e){
			if (getTabType() != 0) {
				getCompDPList();
			}
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
		
		$("#poCheckAll").on("click", function(e){
			if(this.checked) {
				$("#selPositionTable input[name=dpSeq]:checkbox").each(function() {
					$(this).prop("checked", true);
				});
			} else {
				$("#selPositionTable input[name=dpSeq]:checkbox").each(function() {
					$(this).prop("checked", false);
				});
			}
		});
		$("#duCheckAll").on("click", function(e){
			if(this.checked) {
				$("#selDutyTable input[name=dpSeq]:checkbox").each(function() {
					$(this).prop("checked", true);
				});
			} else {
				$("#selDutyTable input[name=dpSeq]:checkbox").each(function() {
					$(this).prop("checked", false);
				});
			}
		});
		
		
		$("#delEdBtn").on("click", function(e){
			removeEdTable();
		});
		
		<c:if test="${not empty poList}">
		poIdx = ${fn:length(poList)};
		</c:if>
		<c:if test="${not empty duList}">
		duIdx = ${fn:length(duList)};
		</c:if>
		<c:if test="${not empty selectedList}">
		deIdx = ${fn:length(selectedList)};
		</c:if>
		<c:if test="${not empty type}">
		focusTab(${type});
		</c:if>
		<c:if test="${empty type}">
		focusTab(0);
		</c:if>
		
		$("#okBtn").on("click", ok);
		
		$("#searchKeyword").keydown(function (event) {
                if (event.keyCode == 13) {
                    searchText();
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
	
	function init() {
		
		// treeview
		try{
			<c:if test="${not empty orgChartList}">
				orgChartList = ${orgChartList};
				tvInit(orgChartList);
			</c:if>
			selectedData();
			
			focusTreeView('${params.focusSeq}');
			
			kendo.ui.progress($(".pop_wrap"), false);
		} catch(exception) {
			alert("<%=BizboxAMessage.getMessage("TX000010612","조직도를 생성 중 문제가 발생하였습니다")%>");
		}  finally {
			kendo.ui.progress($(".pop_wrap"), false);
		}
	}
		
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
		
		if(firstNode != null) {
			treeAutoScroll(firstNode);
		}
			
		
		setCount();
		
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
		
	function focusTab(type) {
		var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");  
        tabStrip.select(type);
	}
	
	function getTabType() {
		var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");  
        return tabStrip.select().index();
	}
		
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
	
	function treeAutoScroll(sel) {
		var position = $(sel).offset();
		$('#treeview').animate({scrollTop : position.top-200}, 500);
	}
		
	function searchKeyword() {
		var searchKeyword = $("#searchKeyword").val();
		var searchType = $("#organ_sel").val();
		
		if (searchKeyword.length == 0) {
			alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>");
			return;
		}
		
		searchItem = {nameAndLoginId : searchKeyword, groupSeq:groupSeq, mode:mode, langCode:langCode};
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
					treeview.select($());							// 선택 초기화
				}
			}
		}
		
	}
	
	// 부서의 사원 리스트 조회
	function setEmpList(item) {
		if(getTabType() != 0) {
			return;
		}
		
		var treeview = $("#treeview").data("kendoTreeView");
		
		var list = null;
		
		var selectedNode = treeview.select();
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
				data:{groupSeq:item.groupSeq, deptSeq:item.seq, mode:mode, langCode:langCode},
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
		
		
	function onTabSelect(e) {
		tab = $(e.item).find("> .k-link").text();
		
		
		if (orgChartList != null) {
			
			kendo.ui.progress($(".pop_wrap"), true);
			setTimeout("tvReset()", 100);
			
			resetSelect();
			
			$('#treeview').animate({scrollTop : 0}, 0);
			
		}
		
		$("#searchKeyword").val("");
		$("#poSearch").val("");
		$("#duSearch").val("");
		/* if (getTabType() != 0) {
			//getCompDPList();
		} */
		
		
		setCount();
	}
	
	function resetSelect() {
		$("#selEmpDeptTable").empty();
		
		$("input[name=dpSeq]:checkbox").each(function() {
			$(this).removeAttr("checked");
		});
	}
	
	function tvReset() {
		try {
			CommonKendo.setTreeviewAllCheck($("#treeview").data("kendoTreeView"), false, true);
			kendo.ui.progress($(".pop_wrap"), false);
		} catch(exception) {
			alert("<%=BizboxAMessage.getMessage("TX000010609","조직도 정보 리셋중 문제가 발생하였습니다")%>");
		}  finally {
			kendo.ui.progress($(".pop_wrap"), false);
		}
		
	}
		
	function tvInit(ocList) {
		//kendo.ui.progress($("#treeview"), true);
		
		
		var inline = new kendo.data.HierarchicalDataSource({
	                data: [ocList],
	                schema: {
                        model: {
                        	id: "seq",
                            children: "nodes"
                        } 
                    }
	   });
		
	   $("#treeview").kendoTreeView({
	   	  checkboxes: {
	           checkChildren:true
	      },
          dataSource: inline,
          select: onSelectTree,
          check: onCheck,
          dataTextField: ["name"],
          dataValueField: ["seq", "gbn"]
       }); 
	   
	  //kendo.ui.progress($("#treeview"), false);
	}
	   
	function onSelectTree(e) {
	   var item = e.sender.dataItem(e.node);
	   callbackOrgChart(item);	// 반드시 구현
	   
	}
	
	function onCheck(e) {
       var item = e.sender.dataItem(e.node);
       if (item.checked) {
		   addSelEmpDeptTable(item);
       } else {
    	   removeSelEmpDpetTable(item.seq);
       }
       
       var checkedNodes = [],
                treeView = $("#treeview").data("kendoTreeView");

       checkedNodeIds(treeView.dataSource.view(), checkedNodes);
       
       if(getTabType() == 0){
    	   $("#selEmpDeptTable tr").remove();
    	   
    	   if (checkedNodes.length > 0) {
    			onCheckSetEmpList(checkedNodes);
    	   }
    	   
    	   checkedNodes = [];
    	   checkedNodeIds(treeView.dataSource.view(), checkedNodes);
    	   
    	   if (checkedNodes.length > 0) {
    	   		for(var i = 0; i < checkedNodes.length; i++) {
		   			addSelEmpDeptTable(checkedNodes[i]);
    	   		}
    	   }
       }
       
	  /*  alert("item.seq:"+item.seq + ", item.parentSeq:"+item.parentSeq+ ", item.gbn:"+item.gbn
			   + ", item.name:"+item.name+ ", item.groupSeq:"+item.groupSeq+ ", item.compSeq:"+item.compSeq+ ", item.deptSeq:"+item.deptSeq); */
		
		setCount();	   
    } 
	
	function onCheckSetEmpList(checkedNodes) {
		var treeview = $("#treeview").data("kendoTreeView");
		if (checkedNodes.length > 0) {
    	   	for(var i = 0; i < checkedNodes.length; i++) {
    	   		if (checkedNodes[i].gbn == 'd') {
    	   				var dataItem = treeview.dataSource.get(checkedNodes[i].seq);		// 부서 정보로 item 확인
						if (dataItem != null && dataItem.nodes.length == 0) {									// 부서 정보가 treeview에 있는 확인
							var node = treeview.findByUid(dataItem.uid);		// 해당 node를 가져옴
	    	   				treeview.select(node);
    	   					setEmpList(checkedNodes[i]);
    	   					treeview.select($());
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
                	if (nodes[i].checked) {
                		continue;
                	}
                	
                    checkedNodeIds(nodes[i].children.view(), checkedNodes);
                }
            }
    }
	
	function removeSelEmpDpetTable(seq) {
		$("#seq"+seq).remove();
	}
	
	function addSelEmpDeptTable(item) {
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
			//deptName = item.name;
		}
		
		 var h = "<tr id=\"seq"+seq+"\">" +
						"<td class=\"le\"><input type=\"checkbox\" name=\"inp_chk\" id=\"edCheck"+deIdx+"\" class=\"k-checkbox\">" +
							"<label class=\"k-checkbox-label\" for=\"edCheck"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
						"</td>" +
						"<td class=\"le\">"+name+"</td>" +
						"<td class=\"le\">"+deptName+"</td>" +
						"<td class=\"\">"+dutyName+"</td>" +
					"</tr>";
		//alert(html);
		$("#selEmpDeptTable").append(h);
		deIdx++;  
		
	}
	   
	function callbackOrgChart(item) {
		
		if (getTabType() == 0 && item.nodes != null && item.nodes.length == 0) {
				$.ajax({
					type:"post",
					url:'<c:url value="/cmm/systemx/getEmpListNodes.do" />',
					data:{groupSeq:item.groupSeq, deptSeq : item.seq, mode:mode, langCode:langCode},
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
	
	function setCount() {
					
			var rowCount = $('#selEmpDeptTable tr').length;
					
			$("#selectEmpCount").html("("+rowCount+")");
	}
	
	
	function getCompDPList() {
		var notInDpSeqList = "";
		var dpName = ""; 
		var type = null;
		if (getTabType() == 1) {
			type = "POSITION";
			dpName = $("#poSearch").val();
			if ($.trim(dpName) == '') { alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>"); return; }
			//$("#selPositionTable");
			
			// var ischeck = $(this).is(':checked');  
				 var arr = $("#selPositionTable").find("input[name=dpSeq]:checked");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						
						notInDpSeqList += "'"+$(arr[i]).val()+"'";
						
						if (i < arr.length-1) {
							notInDpSeqList += ",";
						}
					}
				 }
				 
				 arr = $("#selPositionTable").find("input[name=dpSeq]");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						if($(arr[i]).is(":checked") == false) {
							$(arr[i]).parent().parent().remove();
						}
						 
					}
				 }
			
			
		} else {
			type = "DUTY";
			dpName = $("#duSearch").val();
			if ($.trim(dpName) == '') { alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>"); return; }
			var arr = $("#selDutyTable").find("input[name=dpSeq]:checked");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						
						notInDpSeqList += "'"+$(arr[i]).val()+"'";
						
						if (i < arr.length-1) {
							notInDpSeqList += ",";
						}
						
					}
				 }
				 
				 
				 arr = $("#selDutyTable").find("input[name=dpSeq]");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						if($(arr[i]).is(":checked") == false) {
							$(arr[i]).parent().parent().remove();
						}
						 
					}
				 }
		}
		
		var compSeq = $("#compSeq").val();
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/getCompDPListJson.do" />',
			datatype:"json",
			data: {compSeq:compSeq, dpType:type, notInDpSeqList:notInDpSeqList, dpName:dpName, groupSeq:groupSeq, compSeq:compSeq, mode:mode, langCode:langCode},
			async: false,
			success:function(data){
				var list = data.list;
				if (list) {
					for(var y = 0; y < list.length; y++) {
						var dpIdx = 0;
						
						if (getTabType() == 1) {
							dpIdx = duIdx;
							duIdx++;
						}	
						
						else {
							dpIdx = poIdx;
							poIdx++;
						}
						
						var h = '<tr>'+
							'<td class="le">'+
								'<input type="checkbox" name="dpSeq" id="duCheck'+dpIdx+'" class="k-checkbox" value="'+list[y].dpSeq+'">'+
								'<label class="k-checkbox-label" for="duCheck'+dpIdx+'" style="padding:0.2em 0 0 10px;"></label>'+
								'<input type="hidden" name="dpType" value="'+list[y].dpType+'" >'+
								'<input type="hidden" name="dpName" value="'+list[y].dpName+'" >'+
							'</td>'+
							'<td>'+list[y].dpName+'</td>'+
							'</tr>';
							
						if (getTabType() == 1) {
							$("#selPositionTable").append(h);
						}	
						
						else {
							$("#selDutyTable").append(h);
						}
							
					}
				}
			},		 	
			error : function(e){	//error : function(xhr, status, error) {
			}
		});	
	}
		
		
	function ok() {
		var formId = null;
		var tab = getTabType();
		if (tab == 0) {
			formId = "selEmpDeptForm";
		} else if(tab == 1) {
			formId = "selPositionForm";
		} else if(tab == 2) {
			formId = "selDutyForm";
		}
		
		var data = {};
		
		var selectedList = [];
		var selectedOrgList = [];
		var obj = {};
		if(tab == 0) {
			var formdata = $("#"+formId).serializeArray();
			
			for(var i = 0; i < formdata.length; i++) {
				var item = formdata[i];
				if(item.name == "seq" || item.name == "dpSeq") {
					if (i != 0) {
						selectedList.push(obj); 
					} 
					obj = {};
				}
					
				obj[item.name] = item.value;
			}
			selectedList.push(obj);  
		} else {
			var arr = $("#"+formId).find("input[name=dpSeq]:checked");
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					obj = {};
					var _tr = $(arr[i]).parent().parent();
					obj['dpSeq'] = $(_tr).find('input[name=dpSeq]').val();
					obj['dpType'] = $(_tr).find('input[name=dpType]').val();
					obj['dpName'] = $(_tr).find('input[name=dpName]').val();
					selectedList.push(obj);  
				}
			}
		}
		
		
		/** 조직도 선택 리스트 */
		selectedOrgList = CommonKendo.getTreeCheckedList($("#treeview").data("kendoTreeView"));
		
		data['type'] = tab;
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
	
<div class="pop_wrap" style="width:667px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000004738","조직도")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>
					
	<div class="pop_con">

		<div class="tab_set" style="height:526px;">

			<!-- box_left -->
			<div class="box_left brn ml0" style="width:270px; border-right:1px solid #dcdcdc !important;">	
				<p class="record_tabSearch">
					<input id="organ_sel" style="width:66px;" />
					<input class="k-textbox input_search" id="searchKeyword" type="text" value="" style="width:145px;" placeholder="">
					<a href="#" class="btn_search" id="orgchartSearch"></a>
				</p>
	
				<!-- 조직도-->
				<div class="treeCon brbn" >									
					<div id="treeview" class="tree_icon" style="height:460px;"></div>
				</div> 		
						
			</div><!-- //box_left -->	

			<div class="brn"  style="float:left; width:360px;">

				<div class="tab_style"  id="tabstrip">
					<ul>
						<li><%=BizboxAMessage.getMessage("TX000015474","개인/부서")%></li>
						<li><%=BizboxAMessage.getMessage("TX000000105","직책")%></li>
						<li><%=BizboxAMessage.getMessage("TX000000099","직급")%></li>
					</ul>

					<!-- 개인/부서 -->
					<div class="organ_tab1 ml15 mt15" style="width:330px;">
						<div class="option_top">

							<ul>
								<li><%=BizboxAMessage.getMessage("TX000016200","선택된 부서/사원 목록")%><span id="selectEmpCount">(0)</span></li>
							</ul>
							
							<div id="" class="controll_btn" style="padding:0px;float:right;">
								<button id="delEdBtn" type="button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
							</div>
						</div>
	
						<div class="com_ta2 mt15">
							<table>
								<colgroup>
									<col width="35"/>
									<col width="125"/>
									<col width="100"/>
									<col />
								</colgroup>
								<tr>
									<th class="le">
										<input type="checkbox" name="inp_chk" id="edCheckAll" class="k-checkbox">
										<label class="k-checkbox-label" for="edCheckAll" style="padding:0.2em 0 0 10px;"></label>
									</th>
									<th><%=BizboxAMessage.getMessage("TX000016069","회사/이름(아이디)")%></th>
									<th class=""><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>
									<th class=""><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
								</tr>
							</table>
						</div>	
				
						<!-- 개인/부서 선택 리스트 -->
						<form id="selEmpDeptForm">
						<div class="com_ta2 ova_sc"style="height:370px;margin-top:0px;">
							<table id="selEmpDeptTable">
								<colgroup>
									<col width="35"/>
									<col width="125"/>
									<col width="100"/>
									<col />
								</colgroup>
			
								<c:forEach items="${selectedList}" var="selList" varStatus="c">
									<c:if test="${selList.gbn == 'm'}">
										<tr id="seq${selList.seq}">
											<td class="le">
												<input name="inp_chk" class="k-checkbox" id="edCheck${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck${c.count}"></label>
											</td>
											<td class="le">
												<input name="seq" type="hidden" value="${selList.seq}">${selList.seqName}<input name="empName" type="hidden" value="${selList.seqName}">
												<input name="empSeq" type="hidden" value="${selList.empSeq}"><input name="deptSeq" type="hidden" value="${selList.deptSeq}">
												<input name="compSeq" type="hidden" value="${selList.compSeq}"><input name="gbn" type="hidden" value="${selList.gbn}">
												<input name="bizSeq" type="hidden" value="${selList.bizSeq}"><input name="groupSeq" type="hidden" value="${selList.groupSeq}">
											</td>
											<td class="le">${selList.deptName}<input name="deptName" type="hidden" value="${selList.deptName}"></td>
											<td>${selList.dutyName}<input name="dutyName" type="hidden" value="${selList.dutyName}"></td>
										</tr>
									</c:if>
									
									<c:if test="${selList.gbn != 'm'}">
										<tr id="seq${selList.seq}">
											<td class="le">
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
												
												<!-- 2016.04.13 이전 소스 -->
												<%-- <input name="seq" type="hidden" value="${selList.seq}">${selList.seqName}<input name="compName" type="hidden" value="${selList.seqName}">
												<input name="compSeq" type="hidden" value="${selList.compSeq}">
												<input name="deptName" type="hidden" value="${selList.deptName}">
												<input name="deptSeq" type="hidden" value="${selList.seq}">
												<input name="gbn" type="hidden" value="${selList.gbn}">
												<input name="bizSeq" type="hidden" value="${selList.bizSeq}">
												<input name="groupSeq" type="hidden" value="${selList.groupSeq}"> --%>
												
											</td>
											<td class="le">${selList.deptName}</td>
											<td> </td>
										</tr>
									</c:if>
								</c:forEach>
							</table>
						</div>
					</form>
			</div><!--// organ_tab1 -->
			
			<!-- 직책 -->
			<div class="organ_tab2  ml15 mt15" style="width:330px;">
			
				<p class="record_tabSearch">
					<input class="k-textbox input_search" id="poSearch" type="text" value="" style="width:305px;" placeholder="">
					<a href="#" class="btn_search"></a>
				</p>
				
				<div class="pt15">
					<div class="com_ta2">
						<table>
							<colgroup>
								<col width="35"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th class="le">

						<input type="checkbox" name="inp_chk" id="poCheckAll" class="k-checkbox">
						<label class="k-checkbox-label" for="poCheckAll" style="padding:0.2em 0 0 10px;"></label>
					</th>
								<th><%=BizboxAMessage.getMessage("TX000004968","직책명")%></th>
							</tr>
						</table>
					</div>
				
					<!-- 직책 선택 리스트 -->
					<form id="selPositionForm">
					<div class="com_ta2 ova_sc" style="height:370px;">
						<table id="selPositionTable">
							<colgroup>
								<col width="35"/>
								<col width=""/>
							</colgroup>
							
							<c:forEach items="${poList}" var="poList" varStatus="i">
							<tr>
								<td class="le">
									<input type="checkbox" name="dpSeq" id="poCheck${i.count}" class="k-checkbox" ${poList.checked} value="${poList.dpSeq}">
									<label class="k-checkbox-label" for="poCheck${i.count}" style="padding:0.2em 0 0 10px;"></label>
									<input type="hidden" name="dpType" value="${poList.dpType}" >
									<input type="hidden" name="dpName" value="${poList.dpName}" >
								</td> 
								<td>${poList.dpName}</td>
							</tr>
							</c:forEach> 
							
						</table>
					</div>
					</form>
				</div>
			</div><!--// organ_tab2-->	
		
			<!-- 직급 -->
			<div class="organ_tab3  ml15 mt15" style="width:330px;">			
				<p class="record_tabSearch">
					<input class="k-textbox input_search" id="duSearch" type="text" value="" style="width:305px;" placeholder="">
					<a href="#" class="btn_search"></a>
				</p>
			
				<div class="pt15">
					<div class="com_ta2">
						<table>
							<colgroup>
								<col width="35"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th class="le">
				
									<input type="checkbox" name="inp_chk" id="duCheckAll" class="k-checkbox">
									<label class="k-checkbox-label" for="duCheckAll" style="padding:0.2em 0 0 10px;"></label>
								</th>
								<th><%=BizboxAMessage.getMessage("TX000016122","직급명")%></th>
							</tr>
						</table>
					</div>
	
					
					<!-- 직급선택 리스트 -->
					<form id="selDutyForm">
					<div class="com_ta2 ova_sc" style="height:370px;">
						<table id="selDutyTable">
							<colgroup>
								<col width="35"/>
								<col width=""/>
							</colgroup>
							<c:forEach items="${duList}" var="duList" varStatus="c">
							<tr>
								<td class="le">
									<input type="checkbox" name="dpSeq" id="duCheck${c.count}" class="k-checkbox" ${duList.checked} value="${duList.dpSeq}">
									<label class="k-checkbox-label" for="duCheck${c.count}" style="padding:0.2em 0 0 10px;"></label>
									<input type="hidden" name="dpType" value="${duList.dpType}" >
									<input type="hidden" name="dpName" value="${duList.dpName}" >
								</td>
								<td>${duList.dpName}</td>
							</tr>
							</c:forEach>
						</table>
					</div>
					</form>
				</div><!--// br_com_area2 -->
			</div><!--// organ_tab3-->		
			</div><!--// tab_div -->
		</div><!--//Pop_border  -->
	
		</div><!-- //pop_con -->	 
	</div>

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" id="okBtn" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="popClose()" />
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->

<iframe id="middleFrame" name="middleFrame" height=0 width=0 frameborder=0 scrolling=no></iframe>
	
	<form id="middleForm" name="middleForm" target="middleFrame" method="post">
		<input type="hidden" name="data" id="data" value="">
	</form>