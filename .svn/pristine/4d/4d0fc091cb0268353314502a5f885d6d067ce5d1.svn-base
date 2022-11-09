<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>주소록 선택</title>
    
   
	<script id="treeview-template" type="text/kendo-ui-template">
            #: item.text #
	</script>
    
	<script type="text/javascript">
	var deIdx = 0;	// 사용자/부서 선택 테이블 인덱스
	var selIdx = 0;	// 검색 선택 처리 인덱스
	
	var mode = '${params.mode}';
	var langCode = '${params.langCode}';
	var groupSeq = '${params.groupSeq}';
	var compSeq = '${params.compSeq}';
	var empSeq = '${params.empSeq}';
	var deptSeq = '${params.deptSeq}';
	var adminAuth = '${params.adminAuth}';

	var moduleType = "f";	//f : 팩스번호, e : 이메일, t : 전화번호
	var selectType = "s";	//s : 단일선택, m : 다중선택
	
	var selectedAddrGroupSeq = "0";
	
	var defaultInfo = {};
	defaultInfo.callback = "";
	defaultInfo.callbackParam = "";
	defaultInfo.compFilter = "";
	defaultInfo.compSeq = compSeq;
	defaultInfo.deptSeq = deptSeq;
	defaultInfo.empSeq = empSeq;
	defaultInfo.groupSeq = groupSeq;
	defaultInfo.includeDeptCode = "";
	defaultInfo.initMode = "";
	defaultInfo.langCode = langCode;
	//defaultInfo.nodeChangeEvent = "";
	defaultInfo.noUseCompSelect = "";
	defaultInfo.noUseDefaultNodeInfo = "";
	defaultInfo.noUseDeleteBtn = "";
	defaultInfo.selectedId = "";
	defaultInfo.selectedItems = "";
	defaultInfo.selectItem = "m";
	defaultInfo.selectMode = "u";
	
	
	
		$(document).ready(function() {
			
			var paramSet = {};
			paramSet.groupSeq = groupSeq;
			paramSet.empSeq = empSeq || '';
			paramSet.deptSeq = deptSeq || '';
			paramSet.compSeq = compSeq || '';
			
			paramSet.selectMode = 'd';
			paramSet.selectItem = 'm';

			paramSet.nodeChageEvent = 'fnNodeSelect';

			paramSet.langCode = langCode || '';
			paramSet.initMode = '';
			/** 정의 : /orgchart/include/orgJsTree.jsp  **/
			OJT_documentReady(paramSet);
			
			<c:if test="${not empty params.moduleType}">
				moduleType = "${params.moduleType}";
			</c:if>
			<c:if test="${not empty selectedList}">
				deIdx = deIdx + ${fn:length(selectedList)};
			</c:if>
			<c:if test="${not empty selectedAddrList}">
				deIdx = deIdx + ${fn:length(selectedAddrList)};
			</c:if>
			$("#okBtn").on("click", ok);
			
			//탭
			$("#tabstrip").kendoTabStrip({
				animation:  {
					open: {
						effects: ""
					}
				}
			});
			
			var data = [{ text: "<%=BizboxAMessage.getMessage("TX000000141","사원")%>", value: "u" }, { text: "<%=BizboxAMessage.getMessage("TX000000098","부서")%>", value: "d" }];
			$("#em_sel").kendoDropDownList({
				dataTextField: "text"
				, dataValueField: "value"
				, dataSource: data
			});
			
			
			//그리드별 체크박스 전체체크 (1~4)
			$("#edCheckAll_1").on("click", function(e){
				if(this.checked) {
					$("#selectEmpTable1 input[name=inp_chk_1]:checkbox").each(function() {
						if(!$(this)[0].disabled)
							$(this).prop("checked", true);
					});
				} else {
					$("#selectEmpTable1 input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", false);
					});
				}
			});
			
			
			$("#edCheckAll_2").on("click", function(e){
				if(this.checked) {
					$("#selectEmpTable2 input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", true);
					});
				} else {
					$("#selectEmpTable2 input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", false);
					});
				}
			});
			
			
			$("#edCheckAll_3").on("click", function(e){
				if(this.checked) {
					$("#selectEmpTable3 input[name=inp_chk_1]:checkbox").each(function() {
						if(!$(this)[0].disabled)
							$(this).prop("checked", true);
					});
				} else {
					$("#selectEmpTable3 input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", false);
					});
				}
			});
			
			$("#edCheckAll_4").on("click", function(e){
				if(this.checked) {
					$("#selectEmpTable4 input[name=inp_chk_1]:checkbox").each(function() {
						$(this).prop("checked", true);
					});
				} else {
					$("#selectEmpTable4 input[name=inp_chk_1]:checkbox").each(function() { 
						$(this).prop("checked", false);
					});
				}
			});
			
			
			if("${params.moduleType}" == "f"){
				//조직도검색 셀렉트
				$("#searchDiv1").kendoComboBox({
					dataSource : {
						data : ["<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>","<%=BizboxAMessage.getMessage("TX000000277","이름")%>","<%=BizboxAMessage.getMessage("TX000000047","회사")%>","<%=BizboxAMessage.getMessage("TX000000074","팩스번호")%>"]
					},
					value:"<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>",
					change: fnGroupSearch
				});
			}
			else if("${params.moduleType}" == "m"){
				//조직도검색 셀렉트
				$("#searchDiv1").kendoComboBox({
					dataSource : {
						data : ["<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>","<%=BizboxAMessage.getMessage("TX000000277","이름")%>","<%=BizboxAMessage.getMessage("TX000000047","회사")%>","<%=BizboxAMessage.getMessage("TX000002932","이메일")%>"]
					},
					value:"<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>",
					change: fnGroupSearch
				});
			}
			else if("${params.moduleType}" == "t"){
				//조직도검색 셀렉트
				$("#searchDiv1").kendoComboBox({
					dataSource : {
						data : ["<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>","<%=BizboxAMessage.getMessage("TX000000277","이름")%>","<%=BizboxAMessage.getMessage("TX000000047","회사")%>","<%=BizboxAMessage.getMessage("TX000000654","휴대전화")%>"]
					},
					value:"<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>",
					change: fnGroupSearch
				});
			}
			

			//조직도검색 셀렉트
			$("#searchDiv2").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000000141","사원")%>","<%=BizboxAMessage.getMessage("TX000000098","부서")%>"]
				},
				value:"<%=BizboxAMessage.getMessage("TX000000141","사원")%>"
			});

			// 조직도 검색
			$("#searchButton2").on("click", function(e){

					if ($("#txtSearch2").val().length == 0) {
						alert("검색어를 입력하세요.");
						return;
					}

					if($("#searchDiv2").val() == "<%=BizboxAMessage.getMessage("TX000000098","부서")%>")
						searchKeyword();
					else{
						 
						 var tblParam = {};
						 tblParam.mode = mode;
						 tblParam.langCode = langCode;
						 tblParam.txtEmpNm = $("#txtSearch2").val();
							
							$.ajax({
					        	type:"post",
					    		url:'<c:url value="/cmm/systemx/getEmpList.do"/>',
					    		datatype:"json",
					            data: tblParam ,
					    		success: function (data) {
						    			var result = data.list;
										$("#selectEmpTable3 tr").remove();
										for(var i=0;i<result.length;i++){
											addselectEmpTable2(result[i]);
										}
										setcount();
										setDisabled2();
										setSelectedEmpInfo();
					    		    } ,
							    error: function (result) { 
							    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
						    		}
					    	});
					}
			});

			//기본버튼
	           $(".controll_btn button").kendoButton();
			

			
			
			//주소록그룹 트리 
			treeRead();
			
			<c:if test="${not empty orgChartList}">
				//조직도 트리
				orgChartList = ${orgChartList};
				tvInit(orgChartList);
			</c:if>
			
			
			$('#btnEmpSearch').click(function () {
				OJTC_fnSearch(defaultInfo);
			});
			
			$('#txtSearch1').keydown(function (event) {				
				if (event.keyCode === 13) {
					event.returnValue = false;
					event.cancelBubble = true;
					fnGroupSearch();
				}
			});
			
			
			/* 엔터 검색 기능 적용 */
			OJTC_fnSetKeyPressEvent();	
			setcount();
			
			
			$('#txtSearch1').on('keyup', function () {
				if($("#searchDiv1").val() == "<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>"){
				
					$('span.k-in > em.text_blue').each(function(){
				    	$(this).attr("class","");
				    	$(this).attr("style","");
				    });
				  
				    if ($.trim($(this).val()) == '') { return; }
	
				    var term = this.value.toUpperCase();
				    var tlen = term.length;
	
				    $('#treeview span.k-in').each(function(){
				        var text = $(this).text();
				        if($(this).find(".rootfolder").length == 0){
					        var p = text.toUpperCase().indexOf(term);
					        if (p >= 0) {
					            var s1='', s2='';
					        
					            var high = '<em class="text_blue" style="font-weight: bold;">' + text.substr(p,tlen) + '</em>';
				
					            if (p >= 0) {
					                s1 = '<span class="k-sprite folder"></span>' + text.substr(0,p);
					            }
				
					            if (p+tlen < text.length) {
					                s2 = text.substring(p+tlen)
					            }
				
					            $(this).html(s1+high+s2);
					        }
	
				        }
				    });
				}
				else{
					$('span.k-in > em.text_blue').each(function(){
				    	$(this).attr("class","");
				    	$(this).attr("style","");
				    });
				}
			});
		});
		
	
	
		/* [ 검색 ] 키보드 입력 이벤트 정의
		-----------------------------------------------*/
		function OJTC_fnSetKeyPressEvent() {
			$('#text_input').keydown(function (event) {
				
				if (event.keyCode === 13) {
					event.returnValue = false;
					event.cancelBubble = true;
					OJTC_fnSearch(defaultInfo);
				}else{
					OJTC_fnSetResultCnt({ fullCount: 0, resultCount: 0 });	
				}
			});
		}
	
		/* [ 검색 ] 데이터 검색
		 * filterData : 이전의 검색이력, 중복 검색 방지
		-----------------------------------------------*/
		function OJTC_fnSearch(defaultInfo) {
			if (!$('.txt_search_filter:visible').val()) { 
				OJTC_fnSetResultCnt({ fullCount: 0, resultCount: 0 });
				alert('<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>');  
			return; }

			//검색 api 호출
			var filter = $('.txt_search_filter:visible').val() || '';
			var selectMode = defaultInfo.selectMode === 'ud' ? ('ud'+ $("#em_sel").val()) : defaultInfo.selectMode !== $("#em_sel").val() ? 'd' : 'u';
			
			// 회사 조직도 선택 팝업 예외처리
			if(defaultInfo.selectMode === 'oc') selectMode = 'oc';
			
			var searchResult = {};
			searchResult = OJT_fnSearchItem(defaultInfo,selectMode, filter);
				
			if (searchResult.isSuccess && searchResult.hasResult) {
				defaultInfo.selectedId = searchResult.deptSeq;
			} else if (searchResult.isSuccess && (!searchResult.hasResult)) {
				alert('<%=BizboxAMessage.getMessage("TX000007470","검색 결과가 없습니다.")%>');
			}

			// 검색 결과 갯수 설정
			OJTC_fnSetResultCnt({ fullCount: searchResult.fullCount, resultCount: searchResult.resultCount });
		}
	
		
		/* [ 검색 결과 ] 사용자,부서 검색후의 카운팅 표기
		-----------------------------------------------*/
		function OJTC_fnSetResultCnt(param) {
			var fullCnt = param.fullCount || '0';
			if(fullCnt == 0) { $('.span_result_cnt').html(''); return; }
			
			var resultCnt = param.resultCount || '0';
			var dispVal = resultCnt + '/' + fullCnt;
			$('.span_result_cnt').html(dispVal);
		}
		
		
	
	
		function setSelectedEmpInfo(){
			for(var i=0;i<$('#selectEmpTable4 tr').length;i++){
				$("#" + $('#selectEmpTable4 tr')[i].id).addClass("on");
			}
			
			$("tr[name=selectedEmp]").removeClass();
		}
		
		
		function setSelectedAddrInfo(){
			for(var i=0;i<$('#selectEmpTable2 tr').length;i++){
				$("#" + $('#selectEmpTable2 tr')[i].id).addClass("on");
			}
			
			$("tr[name=selectedAddr]").removeClass();
		}
	
	
	
		function fnNodeSelect(data){
			//fnSetScrollToNode(data.selectedId);
			callbackOrgChart(data);
		}
	
		// 부서 노드 클릭 시 부서원 정보 가져오기
		function callbackOrgChart(data) {
			var dept = data.selectedId;	

			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/userProfileInfo.do" />',
				data:{deptSeq:dept},
				datatype:"json",			
				success:function(data){
					if(data != null || data !="") {
						$("#selectEmpTable3 tr").remove();
						for(var i=0;i<data.list.length;i++)
							addselectEmpTable2(data.list[i]);						
						setcount();
						setDisabled2();		
						setSelectedEmpInfo();
					} else {
						alert("<%=BizboxAMessage.getMessage("TX000010608","데이터가 존재하지 않습니다")%>");
					}
					
				}
			});
		}
		
		// 팀별 유저 정보 그려주기
		function fnUserInfoDraw(userInfo) {
			var tag = '';

			for(var i=0; i<userInfo.length; i++) {		
				var dept = userInfo[i].pathName.split("|");
				var len = dept.length - 2;
				var displayDept = dept[len];
				
				tag += '<tr onclick="fnClickUserInfo(\''+userInfo[i].seq+'\')">';
//	 			tag += '<td>';
//	 			tag += '<input type="checkbox" name="chk" id="' + userInfo[i].seq + '" class="k-checkbox">';
//	 			tag += '<label class="k-checkbox-label bdChk" for="' + userInfo[i].seq + '"></label>';
//	 			tag += '</td>';
				tag += '<td>' + userInfo[i].deptName + '</td>';
				tag += '<td>' + userInfo[i].positionCodeName + '</td>';
				tag += '<td>' + userInfo[i].dutyCodeName + '</td>';
				tag += '<td>' + userInfo[i].name + '</td>';
				tag += '<td>' + userInfo[i].telNum + '</td>';
				tag += '<td>' + userInfo[i].mobileTelNum + '</td>';
				tag += '</tr>';
				
			}
			
			
			$("#userInfo").html(tag);
		}
		
		
		

		// 트리뷰 초기화	(조직도)
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
			   $("#treeview2").kendoTreeView({
		          dataSource: inline,
		          select: onSelectTree,
		          dataTextField: ["name"],
		          dataValueField: ["seq", "gbn"]
		       }); 
		}
	
		
		function onSelectTree(e) {
			 var item = e.sender.dataItem(e.node);
			 
			 var NodesSeq = [], NodesNm = [], NodesGbn = [];
			 
			 NodesSeq.push(item.seq);
			 NodesNm.push(item.name);
			 NodesGbn.push(item.gbn);
			 
			 if(item.hasChildren > 0)
			 	checkedNode(item.nodes, NodesSeq, NodesNm, NodesGbn);
			 
			 var seqList = "";
			 
			 for(var i=0;i<NodesSeq.length;i++){
				 seqList += ",'" + NodesSeq[i] + "'";
			 }
			 seqList = seqList.substring(1);
			 
			 var tblParam = {};
			 tblParam.seqList = seqList;
			 tblParam.mode = mode;
			 tblParam.langCode = langCode;
				
				$.ajax({
		        	type:"post",
		    		url:'<c:url value="/cmm/systemx/getEmpList.do"/>',
		    		datatype:"json",
		            data: tblParam ,
		    		success: function (data) {
			    			var result = data.list;
							
							for(var i=0;i<result.length;i++){
								addselectEmpTable2(result[i]);
							}
							setSelectedEmpInfo();
							
		    		    } ,
				    error: function (result) { 
				    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
			    		}
		    	});
			
		}
		
		
		function checkedNode(nodes, NodesSeq, NodesNm, NodesGbn){
			for (var i = 0; i < nodes.length; i++) {
				NodesSeq.push(nodes[i].seq);
				NodesNm.push(nodes[i].name);
				NodesGbn.push(nodes[i].gbn);

            	 if (nodes[i].hasChildren) 
            		 checkedNode(nodes[i].children.view(), NodesSeq, NodesNm, NodesGbn);
	        }
		}
		

	   function fnGroupSearch(){
		   if($("#searchDiv1").val() == "<%=BizboxAMessage.getMessage("TX000000002","그룹명")%>"){

		   }
		   else{
			   var tblParam = {};			   
				tblParam.adminAuth = adminAuth;
			    tblParam.searchDiv = $("#searchDiv1").val();
			    tblParam.txtSearch = $("#txtSearch1").val();
			    tblParam.compSeq = compSeq;
			    tblParam.langCode = langCode;
			    tblParam.deptSeq = deptSeq;
			    tblParam.empSeq = empSeq;
			    tblParam.searchDiv = $("#searchDiv1").val();
			    tblParam.txtSearch = $("#txtSearch1").val();
			    tblParam.groupSeq = selectedAddrGroupSeq;
				   
				$.ajax({
					type:"post",
					url:'<c:url value="/cmm/systemx/getAddrListNodes.do" />',
					datatype:"json",	
					data:tblParam,				
					success:function(data){		
						var result = data.list;
						$("#selectEmpTable1 tr").remove();
						for(var i=0;i<result.length;i++){
							addselectEmpTable1(result[i]);
						}
						setDisabled1();
						setcount();
					}
				});
		   }
	   }
	   
	   function InitSearch(treeViewId, searchInputId) {

		   $('span.k-in > em.text_blue').each(function(){
		    	$(this).attr("class","");
		    	$(this).attr("style","");
		    });
		  
		    if ($.trim($(this).val()) == '') { return; }

		    var term = this.value.toUpperCase();
		    var tlen = term.length;

		    $('#treeview span.k-in').each(function(){
		        var text = $(this).text();
		        if($(this).find(".rootfolder").length == 0){
			        var p = text.toUpperCase().indexOf(term);
			        if (p >= 0) {
			            var s1='', s2='';
			        
			            var high = '<em class="text_blue" style="font-weight: bold;">' + text.substr(p,tlen) + '</em>';
		
			            if (p >= 0) {
			                s1 = '<span class="k-sprite folder"></span>' + text.substr(0,p);
			            }
		
			            if (p+tlen < text.length) {
			                s2 = text.substring(p+tlen)
			            }
		
			            $(this).html(s1+high+s2);
			        }

		        }
		    });
		}

	   
	   
	
		function treeRead(){
			
			var homogeneous = new kendo.data.HierarchicalDataSource({
		        transport: {
		            read: {
		                url: '<c:url value="/cmm/systemx/getAddrGroupListNodes.do" />',
		                dataType: "jsonp",
		            },
		            	parameterMap: function(data, operation) {
		     	    	data.mode = mode;
		     	    	data.langCode = langCode;
		     	    	data.empSeq = empSeq;
		     	    	data.compSeq = compSeq;
		     	    	data.deptSeq = deptSeq;
		     	    	data.adminAuth = adminAuth;
		     	    	data.txtSearchGroupNm = $("#txtSearch1").val();
		     	    	return data ;
		     	    }
		        },  
		        schema: {
		            model: {
		            	children: "nodes"
		            } 
		        } 
		    });   
		
			$("#treeview").kendoTreeView({
			    dataSource: homogeneous,
			    dataTextField: "group_nm",
			    dataSpriteCssClassField : "folder",
			    loadOnDemand: false,
			    select: fnSetArrdGroupInfo
			}); 
		}
		
		function fnSetArrdGroupInfo(e){
			var tblParam = {};
			tblParam.groupSeq = $("#treeview").data("kendoTreeView").dataItem(e.node).group_seq;
			selectedAddrGroupSeq = $("#treeview").data("kendoTreeView").dataItem(e.node).group_seq;
			tblParam.adminAuth = adminAuth;
		    tblParam.searchDiv = $("#searchDiv1").val();
		    tblParam.txtSearchKeyword = $("#txtSearch1").val();
		    tblParam.compSeq = compSeq;
		    tblParam.langCode = langCode;
		    tblParam.deptSeq = deptSeq;
		    tblParam.empSeq = empSeq;
		    tblParam.searchDiv = $("#searchDiv1").val();
		    tblParam.txtSearch = $("#txtSearch1").val();
		    
			$.ajax({
				type:"post",
				url:'<c:url value="/cmm/systemx/getAddrListNodes.do" />',
				datatype:"json",	
				data:tblParam,				
				success:function(data){		
					var result = data.list;
					$("#selectEmpTable1 tr").remove();
					for(var i=0;i<result.length;i++){
						addselectEmpTable1(result[i]);
					}
					setDisabled1();
					setcount();
					setSelectedAddrInfo();
				}
			});
		}
		
		
		
		
		//주소록그룹 선택시 주소록 그리드에 추가.
		function addselectEmpTable1(item){
			console.log(item);
	
			var info = "<input type=\"hidden\" name=\"group_seq\" value=\""+item.addr_group_seq +"\" />";
			info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+item.addr_seq +"\" />";
			info += "<input type=\"hidden\" name=\"group_nm\" value=\""+item.group_nm +"\" />";
			info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+item.addr_nm +"\" />";
			info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+item.comp_nm +"\" />";
			info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+item.emp_nm +"\" />";
			info += "<input type=\"hidden\" name=\"fax_num\" value=\""+item.comp_fax +"\" />";
			info += "<input type=\"hidden\" name=\"tel_num\" value=\""+item.comp_tel +"\" />";
			info += "<input type=\"hidden\" name=\"e_mail\" value=\""+item.e_mail +"\" />";
			
			var empNm = "";
			var compFax = " ";
			var seq = item.addr_seq;
			
// 			empNm = item.emp_nm + "<input type=\"hidden\" name=\"deptName\" value=\""+item.emp_nm +"\" />" ;
// 			compFax = item.comp_fax + "<input type=\"hidden\" name=\"dutyName\" value=\""+item.comp_fax +"\" />" ;

			 var h = "<tr id=\"seq"+seq+"\" ondblclick='addAddrInfo(\"" + seq + "\")'>" + info +
							"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
								"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
							"</td>" +
							"<td class=\"\">"+isNull(item.comp_nm)+"</td>" +
							"<td class=\"\">"+isNull(item.emp_nm)+"</td>";
			if("${params.moduleType}" == 'f'){
				h += 		"<td class=\"\">"+isNull(item.comp_fax)+"</td>" +
				"</tr>";
			}
			else if("${params.moduleType}" == 't'){
				h += 		"<td class=\"\">"+isNull(item.comp_tel)+"</td>" +
				"</tr>";
			}
			else if("${params.moduleType}" == 'm'){
				h += 		"<td class=\"\">"+isNull(item.e_mail)+"</td>" +
				"</tr>";
			}
				
			//alert(html);
			$("#selectEmpTable1").append(h);
			deIdx++;  
			
		}
		
		
		//조직도 부서 선택시  그리드에 추가.
		function addselectEmpTable2(item){
			console.log(item);

			var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+item.deptSeq +"\" />";
			info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+item.compSeq +"\" />";
			info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+item.seq +"\" />";
			info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+item.compName +"\" />";
			info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+item.deptName +"\" />";
			info += "<input type=\"hidden\" name=\"group_seq\" value=\""+item.groupSeq +"\" />";
			info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+item.name +"\" />";
			info += "<input type=\"hidden\" name=\"fax_num\" value=\""+item.faxNum +"\" />";
			info += "<input type=\"hidden\" name=\"tel_num\" value=\""+item.mobileTelNum +"\" />";
			info += "<input type=\"hidden\" name=\"e_mail\" value=\""+item.emailAddr +"\" />";
			
			
			
			var empNm = "";
			var compFax = " ";
			var seq = item.seq;
		
			
			var h = "<tr id=\"seq"+seq+"\" ondblclick='addEmpInfo(\"" + seq + "\")'>" + info +
							"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
								"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
							"</td>" +
							"<td class=\"\">"+isNull(item.compName)+"</td>" +
							"<td class=\"\">"+isNull(item.name)+"</td>";
			if("${params.moduleType}" == 'f'){
				h += 		"<td class=\"\">"+isNull(item.faxNum)+"</td>" +
				"</tr>";
			}
			else if("${params.moduleType}" == 't'){
				h += 		"<td class=\"\">"+isNull(item.mobileTelNum)+"</td>" +
				"</tr>";
			}
			else if("${params.moduleType}" == 'm'){
				h += 		"<td class=\"\">"+isNull(item.emailAddr)+"</td>" +
				"</tr>";
			}	
			//alert(html);
			$("#selectEmpTable3").append(h);
			deIdx++;  
		}
		
		
		//주소록정보추가(더블클릭)
		function addAddrInfo(target){
			var arr = $("#seq"+target).find("input[name=inp_chk_1]");
			
			var groupSeqList = $("#seq"+target).find("input[name=group_seq]:hidden");
			var addrSeqList = $("#seq"+target).find("input[name=addr_seq]:hidden");
			var groupNmList = $("#seq"+target).find("input[name=group_nm]:hidden");
			var addrNmList = $("#seq"+target).find("input[name=addr_nm]:hidden");
			var compNmList = $("#seq"+target).find("input[name=comp_nm]:hidden");
			var empNmList = $("#seq"+target).find("input[name=emp_nm]:hidden");
			var faxNumList = $("#seq"+target).find("input[name=fax_num]:hidden");
			var telNumList = $("#seq"+target).find("input[name=tel_num]:hidden");
			var emailList = $("#seq"+target).find("input[name=e_mail]:hidden");
			
			
			
			
			if (arr.length > 0 && arr[0].disabled == false) {
				$("#seq" + target).addClass("on");
				for(var i = 0; i < arr.length; i++) {
					var cnt = 0;
					var groupSeqChkList = $("#selectEmpForm2").find("input[name=group_seq]:hidden");
					var addrSeqChkList = $("#selectEmpForm2").find("input[name=addr_seq]:hidden");
					
					for(var j=0;j<groupSeqChkList.length;j++){
						if((groupSeqList[i].value == groupSeqChkList[j].value) && (addrSeqList[i].value == addrSeqChkList[j].value))
							cnt++;
					}
					
					if(cnt == 0){
// 						var _tr = $(arr[i]).parent().parent();
// 						var html = "<tr>" + _tr.html();
// 						html += "</tr>";
// 	// 					$(_tr).remove();
// 						$("#selectEmpTable2").append(html);

						var info = "<input type=\"hidden\" name=\"group_seq\" value=\""+groupSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+ addrSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_nm\" value=\""+ groupNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+ addrNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+ compNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+ empNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"fax_num\" value=\""+ faxNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"tel_num\" value=\""+ telNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"e_mail\" value=\""+ emailList[i].value +"\" />";

						var seq = addrSeqList[i].value;
						
						
						 var h = "<tr id=\"seq"+seq+"\" name=\"selectedAddr\">" + info +
										"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
											"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
										"</td>" +
										"<td class=\"\">"+ isNull(compNmList[i].value) +"</td>" +
										"<td class=\"\">"+ isNull(empNmList[i].value) +"</td>";
										
										"<td class=\"\">"+ isNull(faxNumList[i].value) +"</td>" +
									"</tr>";
						if("${params.moduleType}" == 'f'){
							h += 		"<td class=\"\">"+isNull(faxNumList[i].value)+"</td>" +
							"</tr>";
						}
						else if("${params.moduleType}" == 't'){
							h += 		"<td class=\"\">"+isNull(telNumList[i].value)+"</td>" +
							"</tr>";
						}
						else if("${params.moduleType}" == 'm'){
							h += 		"<td class=\"\">"+isNull(emailList[i].value)+"</td>" +
							"</tr>";
						}
						//alert(html);
						$("#selectEmpTable2").append(h);
						deIdx++; 
					}
				}
			}	
			$("#edCheckAll_1").prop("checked",false);
			
			setcount();
		}
		
		
		//사원정보추가(더블클릭)
		function addEmpInfo(target){
			
			
			var arr = $("#seq"+target).find("input[name=inp_chk_1]");

			
			
			var deptSeqList = $("#seq"+target).find("input[name=dept_seq]:hidden");
			var compSeqList = $("#seq"+target).find("input[name=comp_seq]:hidden");
			var empSeqList = $("#seq"+target).find("input[name=emp_seq]:hidden");
			var compNmList = $("#seq"+target).find("input[name=comp_nm]:hidden");
			var deptNmList = $("#seq"+target).find("input[name=dept_nm]:hidden");
			var groupSeqList = $("#seq"+target).find("input[name=group_seq]:hidden");
			var empNmList = $("#seq"+target).find("input[name=emp_nm]:hidden");
			var faxNumList = $("#seq"+target).find("input[name=fax_num]:hidden");
			var telNumList = $("#seq"+target).find("input[name=tel_num]:hidden");
			var emailList = $("#seq"+target).find("input[name=e_mail]:hidden");
			
			
			
			
			
			if(arr.length > 0 && arr[0].disabled == false){
				$("#seq" + target).addClass("on");
				for(var i = 0; i < 1; i++) {
					var cnt = 0;
					var deptSeqChkList = $("#selectEmpForm4").find("input[name=dept_seq]:hidden");
					var empSeqChkList = $("#selectEmpForm4").find("input[name=emp_seq]:hidden");
					
					for(var j=0;j<deptSeqChkList.length;j++){
						if((deptSeqList[i].value == deptSeqChkList[j].value) && (empSeqList[i].value == empSeqChkList[j].value))
							cnt++;
					}
					
					if(cnt == 0){
// 						var _tr = $(arr[i]).parent().parent();
// 						var html = "<tr>" + _tr.html();
// 						html += "</tr>";
// 	// 					$(_tr).remove();
// 						$("#selectEmpTable2").append(html);

						var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+deptSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+compSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+empSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+compNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+deptNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_seq\" value=\""+groupSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+empNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"fax_num\" value=\""+faxNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"tel_num\" value=\""+telNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"e_mail\" value=\""+emailList[i].value +"\" />";
						
						
						
						var empNm = "";
						var compFax = " ";
						var seq = empSeqList[i].value;
						
				
						
						 var h = "<tr id=\"seq"+seq+"\" name=\"selectedEmp\">" + info +
										"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
											"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
										"</td>" +
										"<td class=\"\">"+isNull(compNmList[i].value)+"</td>" +
										"<td class=\"\">"+isNull(empNmList[i].value)+"</td>";
										
						 if("${params.moduleType}" == 'f'){
								h += 		"<td class=\"\">"+isNull(faxNumList[i].value)+"</td>" +
								"</tr>";
							}
							else if("${params.moduleType}" == 't'){
								h += 		"<td class=\"\">"+isNull(telNumList[i].value)+"</td>" +
								"</tr>";
							}
							else if("${params.moduleType}" == 'm'){
								h += 		"<td class=\"\">"+isNull(emailList[i].value)+"</td>" +
								"</tr>";
							}
						//alert(html);
						$("#selectEmpTable4").append(h);
						deIdx++;   
					}
				}
			}	
			$("#edCheckAll_3").prop("checked",false);
			
			setcount();
		}
		
		//삭제버튼
		function delSelList(target){
			var arr = $("#"+target).find("input[name=inp_chk_1]:checked");
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					//$("#" + arr.parent().parent()[i].id).removeClass();
					var _tr = $(arr[i]).parent().parent();
					$("#"+_tr[0].id).removeClass();
					$(_tr).remove();
				}
			}	
			setcount();
		}
		
		
		//팩스,전화번호,이메일이 없을시 체크박스 비활성화(주소록그룹)
		function setDisabled1(){
			var chkBoxList = $("#selectEmpForm1").find("input[name=inp_chk_1]:checkbox");
			var chkValueList;
			
			if("${params.moduleType}" == 'f'){
				chkValueList = $("#selectEmpForm1").find("input[name=fax_num]:hidden");
			}
			else if("${params.moduleType}" == 't'){
				chkValueList = $("#selectEmpForm1").find("input[name=tel_num]:hidden");
			}
			else if("${params.moduleType}" == 'm'){
				chkValueList = $("#selectEmpForm1").find("input[name=e_mail]:hidden");
			}	
			for(var i=0;i<chkBoxList.length;i++){
				if(chkValueList[i].value == "" || chkValueList[i].value == "null")
					chkBoxList[i].disabled = true;
			}
		}
		
		
		//팩스,전화번호,이메일이 없을시 체크박스 비활성화(조직도)
		function setDisabled2(){
			var chkBoxList = $("#selectEmpForm3").find("input[name=inp_chk_1]:checkbox");
			var chkValueList;
			
			if("${params.moduleType}" == 'f'){
				chkValueList = $("#selectEmpForm3").find("input[name=fax_num]:hidden");
			}
			else if("${params.moduleType}" == 't'){
				chkValueList = $("#selectEmpForm3").find("input[name=tel_num]:hidden");
			}
			else if("${params.moduleType}" == 'm'){
				chkValueList = $("#selectEmpForm3").find("input[name=e_mail]:hidden");
			}	
			for(var i=0;i<chkBoxList.length;i++){
				if(chkValueList[i].value == "" || chkValueList[i].value == "null")
					chkBoxList[i].disabled = true;
			}
		}
		
		
		
		//주소록그룹 반영
		function fnConfirm1(){
			var arr = $("#selectEmpForm1").find("input[name=inp_chk_1]:checked");
			
			
			var groupSeqList = arr.parent().parent().find("input[name=group_seq]:hidden");
			var addrSeqList = arr.parent().parent().find("input[name=addr_seq]:hidden");
			var groupNmList = arr.parent().parent().find("input[name=group_nm]:hidden");
			var addrNmList = arr.parent().parent().find("input[name=addr_nm]:hidden");
			var compNmList = arr.parent().parent().find("input[name=comp_nm]:hidden");
			var empNmList = arr.parent().parent().find("input[name=emp_nm]:hidden");
			var faxNumList = arr.parent().parent().find("input[name=fax_num]:hidden");
			var telNumList = arr.parent().parent().find("input[name=tel_num]:hidden");
			var emailList = arr.parent().parent().find("input[name=e_mail]:hidden");
			
			
			
			
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					var cnt = 0;
					$("#seq" + addrSeqList[i].value).addClass("on");
					var groupSeqChkList = $("#selectEmpForm2").find("input[name=group_seq]:hidden");
					var addrSeqChkList = $("#selectEmpForm2").find("input[name=addr_seq]:hidden");
					
					for(var j=0;j<groupSeqChkList.length;j++){
						if((groupSeqList[i].value == groupSeqChkList[j].value) && (addrSeqList[i].value == addrSeqChkList[j].value))
							cnt++;
					}
					
					if(cnt == 0){
// 						var _tr = $(arr[i]).parent().parent();
// 						var html = "<tr>" + _tr.html();
// 						html += "</tr>";
// 	// 					$(_tr).remove();
// 						$("#selectEmpTable2").append(html);

						var info = "<input type=\"hidden\" name=\"group_seq\" value=\""+groupSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_seq\" value=\""+ addrSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_nm\" value=\""+ groupNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"addr_nm\" value=\""+ addrNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+ compNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+ empNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"fax_num\" value=\""+ faxNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"tel_num\" value=\""+ telNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"e_mail\" value=\""+ emailList[i].value +"\" />";

						var seq = addrSeqList[i].value;
						
						
						 var h = "<tr id=\"seq"+seq+"\" name=\"selectedAddr\">" + info +
										"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
											"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
										"</td>" +
										"<td class=\"\">"+ isNull(compNmList[i].value) +"</td>" +
										"<td class=\"\">"+ isNull(empNmList[i].value) +"</td>";
										
										"<td class=\"\">"+ isNull(faxNumList[i].value) +"</td>";
						if("${params.moduleType}" == 'f'){
							h += 		"<td class=\"\">"+isNull(faxNumList[i].value)+"</td>" +
							"</tr>";
						}
						else if("${params.moduleType}" == 't'){
							h += 		"<td class=\"\">"+isNull(telNumList[i].value)+"</td>" +
							"</tr>";
						}
						else if("${params.moduleType}" == 'm'){
							h += 		"<td class=\"\">"+isNull(emailList[i].value)+"</td>" +
							"</tr>";
						}
						//alert(html);
						$("#selectEmpTable2").append(h);
						deIdx++; 
					}
				}
			}	
			$("#edCheckAll_1").prop("checked",false);
			
			setcount();
		}
		
		
		
		//조직도 반영
		function fnConfirm2(){
			var arr = $("#selectEmpForm3").find("input[name=inp_chk_1]:checked");
			
			var deptSeqList = arr.parent().parent().find("input[name=dept_seq]:hidden");
			var compSeqList = arr.parent().parent().find("input[name=comp_seq]:hidden");
			var empSeqList = arr.parent().parent().find("input[name=emp_seq]:hidden");
			var compNmList = arr.parent().parent().find("input[name=comp_nm]:hidden");
			var deptNmList = arr.parent().parent().find("input[name=dept_nm]:hidden");
			var groupSeqList = arr.parent().parent().find("input[name=group_seq]:hidden");
			var empNmList = arr.parent().parent().find("input[name=emp_nm]:hidden");
			var faxNumList = arr.parent().parent().find("input[name=fax_num]:hidden");
			var telNumList = arr.parent().parent().find("input[name=tel_num]:hidden");
			var emailList = arr.parent().parent().find("input[name=e_mail]:hidden");
			
			
			
			
			
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					$("#seq" + empSeqList[i].value).addClass("on");
					var cnt = 0;
					var deptSeqChkList = $("#selectEmpForm4").find("input[name=dept_seq]:hidden");
					var empSeqChkList = $("#selectEmpForm4").find("input[name=emp_seq]:hidden");
					
					for(var j=0;j<deptSeqChkList.length;j++){
						if((deptSeqList[i].value == deptSeqChkList[j].value) && (empSeqList[i].value == empSeqChkList[j].value))
							cnt++;
					}
					
					if(cnt == 0){
// 						var _tr = $(arr[i]).parent().parent();
// 						var html = "<tr>" + _tr.html();
// 						html += "</tr>";
// 	// 					$(_tr).remove();
// 						$("#selectEmpTable2").append(html);

						var info = "<input type=\"hidden\" name=\"dept_seq\" value=\""+deptSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_seq\" value=\""+compSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_seq\" value=\""+empSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"comp_nm\" value=\""+compNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"dept_nm\" value=\""+deptNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"group_seq\" value=\""+groupSeqList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"emp_nm\" value=\""+empNmList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"fax_num\" value=\""+faxNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"tel_num\" value=\""+telNumList[i].value +"\" />";
						info += "<input type=\"hidden\" name=\"e_mail\" value=\""+emailList[i].value +"\" />";
						
						
						
						var empNm = "";
						var compFax = " ";
						var seq = empSeqList[i].value;
						
				
						
						 var h = "<tr id=\"seq"+seq+"\" name=\"selectedEmp\">" + info +
										"<td class=\"\"><input type=\"checkbox\" name=\"inp_chk_1\" id=\"edCheck_1_"+deIdx+"\" class=\"k-checkbox\">" +
											"<label class=\"k-checkbox-label\" for=\"edCheck_1_"+deIdx+"\" style=\"padding:0.2em 0 0 10px;\"></label>" +
										"</td>" +
										"<td class=\"\">"+isNull(compNmList[i].value)+"</td>" +
										"<td class=\"\">"+isNull(empNmList[i].value)+"</td>";
										
						 if("${params.moduleType}" == 'f'){
								h += 		"<td class=\"\">"+isNull(faxNumList[i].value)+"</td>" +
								"</tr>";
							}
							else if("${params.moduleType}" == 't'){
								h += 		"<td class=\"\">"+isNull(telNumList[i].value)+"</td>" +
								"</tr>";
							}
							else if("${params.moduleType}" == 'm'){
								h += 		"<td class=\"\">"+isNull(emailList[i].value)+"</td>" +
								"</tr>";
							}
						//alert(html);
						$("#selectEmpTable4").append(h);
						deIdx++;   
					}
				}
			}	
			$("#edCheckAll_3").prop("checked",false);
			
			setcount();
		}
		
		
		
		
		
		
		
		
		
		
		
		//선택,반영된 목록 카운트 셋팅
		function setcount(){
			
			var rowCount1 = $('#selectEmpTable1 tr').length;
			var rowCount2 = $('#selectEmpTable2 tr').length;
			var rowCount3 = $('#selectEmpTable3 tr').length;
			var rowCount4 = $('#selectEmpTable4 tr').length;
			
			$("#selectCount1").html("("+rowCount1+")");
			$("#selectedCount1").html("("+rowCount2+")");
			$("#selectCount2").html("("+rowCount3+")");
			$("#selectedCount2").html("("+rowCount4+")");
		}
		
		
		
		// 검색하기
		function searchKeyword() {
			var searchKeyword = $("#txtSearch2").val();
			var searchType = $("#searchDiv2").val();
			
			if (searchKeyword.length == 0) {
				alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>");
				return;
			}
			
			searchItem = {searchType:searchType, nameAndLoginId : searchKeyword, groupSeq:groupSeq, compSeq:compSeq, mode:mode, langCode:langCode};
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
			var treeview = $("#treeview2").data("kendoTreeView");
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
						//setEmpList(dataItem);							// 해당 부서의 사원들을 모두 조회하여 append
						console.log(treeview.select());		
						treeview.select($());							// 선택 초기화
					}
				}
			}
			
		}
		
		
		
		
		
		
// 		// 트리뷰 검색 포커스 처리
		function focusSearch() {
			var tv = $("#treeview2").data("kendoTreeView");
		    var term = $("#txtSearch2").val();
		    var tlen = term.length;
		    
			/* $('span.k-in > span.highlight').each(function(){
				$(this).parent().html($(this).parent().html());
		    });  */
			
			if ($.trim(term) == '') { return; }
			var selList = [];
		    $('#treeview2 span.k-in').each(function(index){
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
		
		    $('#treeview2 .k-item').each(function(){
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
			$('#treeview2').animate({scrollTop : position.top-200}, 500);
		}
		
		//저장버튼
		function ok(){
			var formId1 = "selectEmpForm2";
			var formId2 = "selectEmpForm4";
			
			var data = {};
			
			var selectedAddrList = [];
			var selectedList = [];
			
			var obj = {};
			var cnt = 0;
			var formdata1 = $("#"+formId1).serializeArray();
			var formdata2 = $("#"+formId2).serializeArray();
			
			for(var i = 0; i < formdata1.length; i++) {
				var item = formdata1[i];
				if(item.name == "group_seq") {
					if (i != 0) {
						selectedAddrList.push(obj); 
					} 
					obj = {};
				}
				obj[item.name] = item.value;
				cnt++;
			}
			if(cnt > 0)
				selectedAddrList.push(obj);  
			
			cnt = 0;
			obj = {};
			
			for(var i = 0; i < formdata2.length; i++) {
				var item = formdata2[i];
				if(item.name == "dept_seq") {
					if (i != 0) {
						selectedList.push(obj); 
					} 
					obj = {};
				}
					
				obj[item.name] = item.value;
				cnt++;
			}
			if(cnt > 0)
				selectedList.push(obj); 
			
			
			
			
			data['moduleType'] = moduleType;
			data['selectedAddrList'] = selectedAddrList;
			data['selectedList'] = selectedList;
			
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
				var form = document.targetForm;
			    form.target = "_self";			    
 			    form.action = callbackUrl;;
			    form.submit();

// 				document.getElementById("middleFrame").src = callbackUrl+"?data="+escape(JSON.stringify(data));
			}
			window.close(); 
			
			
			
		}
		
		function fnclose(){
			var data = {};
			var callbackUrl = "${params.callbackUrl}";
			var callbackFunction = "${params.callback}";
			document.getElementById("middleFrame").src = callbackUrl+"?data="+JSON.stringify(data);
			
			window.close();
		}


		//null값 체크(''공백 반환)
		function isNull(obj){
			return (typeof obj != "undefined" && obj != null && obj != "null") ? obj : "";
		}
	</script>
</head>
<body>
	<div class="pop_wrap" style="width:844px;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016128","주소록 선택")%></h1>
			<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div>	
		
			
		<div class="pop_con">
			
		<div class="tab_set">
			<div class="tab_style" id="tabstrip">
				<!-- tab -->
				<ul>
					<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000001491","주소록")%></li>
					<li><%=BizboxAMessage.getMessage("TX000004738","조직도")%></li>
				</ul>
				
				<!-- tab1 ---------------------------------------------------------------------------------------------------------------------------->
				<div class="tab1 p15 ovh">
					<div class="top_box">
						<div class="top_box_in">
							<input id="searchDiv1" style="width:100px;"/>
							<input type="text" class="" id="txtSearch1" style="width:200px; text-indent:4px;"/>
							<a href="#n" class="btn_sear btn_search" onclick="fnGroupSearch()" id="searchButton1"></a>							
						</div>
					</div>
	
					<div class="fl mt10" style="width:270px;">
						<p class="tit_p mt6 mb14"><%=BizboxAMessage.getMessage("TX000016361","그룹카테고리")%></p>
						<div class="box_div p0">
							<div id="treeview" class="tree_icon" style="height:451px;"></div>
						</div>
					</div>
	
					<!-- 사용자목록 -->
					<div class="fl ml10" style="width:500px;">
						<div class="mt10">
							<div class="clear mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li">사용자 목록<span id="selectCount1">(0)</span></li>
									</ul>

									<div id="" class="controll_btn p0 fr">
										<button id="" onclick="fnConfirm1();">반영</button>
									</div>
								</div>
							</div>
						

						<div class="com_ta2 sc_head">
							<table>
								<colgroup>
									<col width="50"/>
									<col width="150"/>
									<col width="150"/>
									<col width=""/>
								</colgroup>
								<tr>
									<th class="">
										<input type="checkbox" name="inp_chk" id="edCheckAll_1" class="k-checkbox">
										<label class="k-checkbox-label bdChk2" for="edCheckAll_1"></label>
									</th>
									<th class=""><%=BizboxAMessage.getMessage("TX000016055","회사/부서")%></th>
									<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
									<c:if test="${params.moduleType == 'f'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
									</c:if>
									<c:if test="${params.moduleType == 'm'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
									</c:if>
									<c:if test="${params.moduleType == 't'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
									</c:if>
								</tr>
							</table>
						</div>

						<form id="selectEmpForm1">
							<div class="com_ta2 ova_sc2 bg_lightgray" style="height:162px;">
								<table id="selectEmpTable1">
									<colgroup>
										<col width="50"/>
										<col width="150"/>
										<col width="150"/>
										<col width=""/>
									</colgroup>
								</table>
							</div>
						</form>
						
						
						
						
						
						
						
						
	
						<div class="mt30" >	
								<div class="clear mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX000016273","반영된 목록")%><span id="selectedCount1">(0)</span></li>
										</ul>
										
										<div id="" class="controll_btn" style="padding:0px;float:right;">
											<button onclick="delSelList('selectEmpTable2')"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
										</div>
									</div>
								</div>
								<!-- 테이블 -->
						<div class="com_ta2 sc_head">
							<table>
								<colgroup>
									<col width="50"/>
									<col width="150"/>
									<col width="150"/>	
									<col width=""/>
								</colgroup>
								<tr>
									<th>
										<input type="checkbox" name="inp_chk" id="edCheckAll_2" class="k-checkbox">
										<label class="k-checkbox-label bdChk2" for="edCheckAll_2"></label>
									</th>
									<th class=""><%=BizboxAMessage.getMessage("TX000016055","회사/부서")%></th>
									<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
									<c:if test="${params.moduleType == 'f'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
									</c:if>
									<c:if test="${params.moduleType == 'm'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
									</c:if>
									<c:if test="${params.moduleType == 't'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
									</c:if>
								</tr>
							</table>
						</div>

						<form id="selectEmpForm2">
							<div class="com_ta2 ova_sc2 bg_lightgray" style="height:162px;">
								<table id="selectEmpTable2">
									<colgroup>
										<col width="50"/>
										<col width="150"/>
										<col width="150"/>
										<col width=""/>
									</colgroup>
									<c:forEach items="${selectedAddrList}" var="selList" varStatus="c">
										<tr id="seq${selList.addrSeq}" name="selectedAddr">
											<input type="hidden" name="group_seq" value="${selList.addrGroupSeq}"/>
											<input type="hidden" name="addr_seq" value="${selList.addrSeq}"/>
											<input type="hidden" name="group_nm" value="${selList.groupNm}"/>
											<input type="hidden" name="addr_nm" value=""/>
											<input type="hidden" name="comp_nm" value="${selList.compNm}"/>
											<input type="hidden" name="emp_nm" value="${selList.empNm}"/>
											<input type="hidden" name="fax_num" value="${selList.empFax}"/>
											<input type="hidden" name="tel_num" value="${selList.empTel}"/>
											<input type="hidden" name="e_mail" value="${selList.empEmail}"/>
											<td class="">
												<input name="inp_chk_1" class="k-checkbox" id="edCheck_1_a${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck_1_a${c.count}"></label>
											</td>
											<td class="">${selList.compNm}</td>
											<td class="">${selList.empNm}</td>
											<c:if test="${params.moduleType == 'f'}">
												<td>${selList.empFax}</td>
											</c:if>
											<c:if test="${params.moduleType == 't'}">
												<td>${selList.empTel}</td>
											</c:if>
											<c:if test="${params.moduleType == 'e'}">
												<td>${selList.empEmail}</td>
											</c:if>
										</tr>
									</c:forEach>
								</table>
							</div>
						</form>
						</div>
						</div>
					</div>
				</div><!--// tab1 -->
				
				<div class="tab2 p15 ovh">
					<div class="top_box">
						<!-- 사원/부서 선택 선택 -->
						<div class="top_box_in  orgChartTopBox" id="div_org_search_u">
							<div id="" class="dod_search posi_re">
								<input id="em_sel" style="width: 100px;" /> <input type="text"
																				 class="txt_search_filter" id="text_input"
																				 style="width: 278px; text-indent: 4px;" /> <span class="posi_ab text_gray span_result_cnt"
																																					   style="top: 5px; right: 386px;"></span>
								<!-- 부서일때 -->
								<a href="#n" class="btn_sear btn_search" id="btnEmpSearch"></a>
							</div>
						</div>
					</div>
					
					<div class="fl mt10" style="width:270px;">
						<p class="tit_p mt6 mb14"><%=BizboxAMessage.getMessage("TX000004738","조직도")%></p>
						<div class="box_div p0">
							<!-- <div id="treeview2" class="tree_icon" style="height:451px;"></div> -->
							
							<jsp:include page="../include/orgJsTree.jsp" flush="false" />
							
						</div>
					</div>
	
					<div class="fl ml10" style="width:500px;">
						<div class="mt10">
							<div class="clear mb10">
								<div class="option_top">
									<ul>
										<li class="tit_li"><%=BizboxAMessage.getMessage("TX000016028","사용자 목록")%><span id="selectCount2">(0)</span></li>
									</ul>								
									<div id="" class="controll_btn p0 fr">
										<button id="" onclick="fnConfirm2();"><%=BizboxAMessage.getMessage("TX000000423","반영")%></button>
									</div>
								</div>
							</div>
							<div class="com_ta2 sc_head">
								<table>
									<colgroup>
										<col width="50"/>
										<col width="150"/>
										<col width="150"/>
										<col width=""/>
									</colgroup>
									<tr>
										<th>
											<input type="checkbox" name="inp_chk" id="edCheckAll_3" class="k-checkbox">
											<label class="k-checkbox-label bdChk2" for="edCheckAll_3"></label>
										</th>
										<th class=""><%=BizboxAMessage.getMessage("TX000016055","회사/부서")%></th>
										<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
										<c:if test="${params.moduleType == 'f'}">
											<th class=""><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
										</c:if>
										<c:if test="${params.moduleType == 'm'}">
											<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
										</c:if>
										<c:if test="${params.moduleType == 't'}">
											<th class=""><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
										</c:if>
									</tr>
								</table>
							</div>

							<form id="selectEmpForm3">
								<div class="com_ta2 ova_sc2 bg_lightgray" style="height:162px;">
									<table id="selectEmpTable3">
										<colgroup>
											<col width="50"/>
											<col width="150"/>
											<col width="150"/>
											<col width=""/>
										</colgroup>	
									</table>
								</div>
							</form>

						<div class="mt30" >	
								<div class="clear mb10">
									<div class="option_top">
										<ul>
											<li class="tit_li"><%=BizboxAMessage.getMessage("TX000016273","반영된 목록")%><span id="selectedCount2">(0)</span></li>
										</ul>
										
										<div id="" class="controll_btn p0 fr">
											<button onclick="delSelList('selectEmpTable4')"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
										</div>
									</div>
								</div>
								<!-- 테이블 -->
								<div class="com_ta2 sc_head">
							<table>
								<colgroup>
									<col width="50"/>
									<col width="150"/>
									<col width="150"/>
									<col width=""/>
								</colgroup>
								<tr>
									<th>
										<input type="checkbox" name="inp_chk" id="edCheckAll_4" class="k-checkbox">
										<label class="k-checkbox-label bdChk2" for="edCheckAll_4"></label>
									</th>
									<th class=""><%=BizboxAMessage.getMessage("TX000016055","회사/부서")%></th>
									<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
									<c:if test="${params.moduleType == 'f'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000074","팩스번호")%></th>
									</c:if>
									<c:if test="${params.moduleType == 'm'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
									</c:if>
									<c:if test="${params.moduleType == 't'}">
										<th class=""><%=BizboxAMessage.getMessage("TX000000654","휴대전화")%></th>
									</c:if>
								</tr>
							</table>
						</div>

						<form id="selectEmpForm4">
							<div class="com_ta2 ova_sc2 bg_lightgray"style="height:162px;">
								<table id="selectEmpTable4">
									<colgroup>
									<col width="50"/>
									<col width="150"/>
									<col width="150"/>
									<col width=""/>
								</colgroup>
								<c:forEach items="${selectedList}" var="selList" varStatus="c">
										<tr id="seq${selList.empSeq}">
											<input type="hidden" name="dept_seq" value="${selList.deptSeq}"/>
											<input type="hidden" name="comp_seq" value="${selList.compSeq}"/>
											<input type="hidden" name="emp_seq" value="${selList.empSeq}"/>
											<input type="hidden" name="comp_nm" value="${selList.compName}"/>
											<input type="hidden" name="dept_nm" value=""/>
											<input type="hidden" name="group_seq" value="${selList.groupSeq}"/>
											<input type="hidden" name="emp_nm" value="${selList.empName}"/>
											<input type="hidden" name="fax_num" value="${selList.faxNum}"/>
											<input type="hidden" name="tel_num" value="${selList.telNum}"/>
											<input type="hidden" name="e_mail" value="${selList.emailAddr}"/>
											<td class="">
												<input name="inp_chk_1" class="k-checkbox" id="edCheck_1_o${c.count}" type="checkbox"><label class="k-checkbox-label" style="padding: 0.2em 0px 0px 10px;" for="edCheck_1_o${c.count}"></label>
											</td>
											<td class="">${selList.compName}</td>
											<td class="">${selList.empName}</td>
											<c:if test="${params.moduleType == 'f'}">
												<td>${selList.faxNum}</td>
											</c:if>
											<c:if test="${params.moduleType == 't'}">
												<td>${selList.mobileTelNum}</td>
											</c:if>
											<c:if test="${params.moduleType == 'e'}">
												<td>${selList.emailAddr}</td>
											</c:if>
										</tr>
									</c:forEach>
									
								</table>
							</div>
						</form>
						</div>
					</div>
					</div>
				</div><!--// tab2 -->

		</div><!--// tab_style -->
		</div><!--// tab_set -->

		</div><!--// pop_con -->
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" id="okBtn" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
				<input type="button" class="gray_btn" onclick="fnclose();" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
			</div>
		</div><!-- //pop_foot -->
	</div><!--// pop_wrap -->
	<base target="_self"/>
	<iframe id="middleFrame" height=0 width=0 frameborder=0 scrolling=no></iframe>
	<form id="targetForm" name="targetForm" method="post">
		<input type="hidden" name="data" id="data" value="">
	</form>	
</body>	
</html>