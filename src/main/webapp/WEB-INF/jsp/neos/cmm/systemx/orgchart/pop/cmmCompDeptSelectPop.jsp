<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">
	var item = null; // 부서 정보
	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();

		//회사선택 셀렉트박스
	    $("#regi_sel").kendoComboBox({
	        dataSource : {
				data : ["","..."]
	        },
	        value:""
	    });
	    // 조직도
	    var inline = new kendo.data.HierarchicalDataSource({
	                data: [${orgChartList}],
	                schema: {
                        model: {
                        	id: "seq",
                            children: "nodes"
                        } 
                    }
	    });
	    
	     $("#treeview").kendoTreeView({
                    dataSource: inline,
                    select: onSelect,
                    dataTextField: ["name"],
                    dataValueField: ["seq", "gbn"]
         }); 
	     
	     $("input[name=compSeqRadio]:radio").on("click", function() {
	    	 setTreeview($(this).val());
	     });
	     
	     $("#cancelBtn").on("click", function() {
	    	 window.close();
	     });
	     $("#okBtn").on("click", ok);
	     
	     setSelectTreeview('${params.deptSeq}');
	 
	});
	
	function setSelectTreeview(deptSeq) {
		var treeview = $("#treeview").data("kendoTreeView");
		var dataItem = treeview.dataSource.get(deptSeq);
		if (dataItem != null && dataItem != undefined) {
			var node = treeview.findByUid(dataItem.uid);
			if (node != null && node != undefined) {
				treeview.select(node);
				// 스크롤 이동
				var position = $(".k-state-selected").offset();
				//console.log(position);
				$('#treeview').animate({scrollTop : position.top-400}, 300);
			}
		}
	}
	
	function setTreeview(compSeq) {
		$("#compSeq").val(compSeq);
		$.ajax({
			type:"post",
			url:'<c:url value="/systemx/orgChartListJsonData.do" />',
			datatype:"json",
			data: {compSeq:compSeq},
			async: false,
			success:function(data){
				
				var treeview = $("#treeview").data("kendoTreeView"); 
				treeview.remove(".k-item");
    			treeview.unbind("select");
				
    			treeview.append(data.orgChartList);
    			treeview.bind("select", onSelect); 
    			
    			setSelectTreeview($("#deptSeq").val());
			},			
			error : function(e){	//error : function(xhr, status, error) {
				console.log(e);
			}
		});	
	}
	
	function onSelect(e) {
		item = e.sender.dataItem(e.node);
		item.empSeq = '${params.empSeq}'
	}
	
	// 확인버튼 처리
	function ok() {
		var callback = '${params.callback}';
		if (callback) {
			if (item == null) {
				var treeview = $("#treeview").data("kendoTreeView");
				var dataItem = treeview.dataSource.get($("#deptSeq").val());
				item = dataItem;
			}
			if (item == null || item == {} || item == undefined) {
				alert("<%=BizboxAMessage.getMessage("TX000010614","선택한 부서가 없습니다. 부서를 선택하세요")%>");
			} else {
				var bool = checkEmpDept();
				if (bool) {
					item.compName = getCompName();
					item.empSeq = $("#empSeq").val();
				
					eval('window.opener.' + callback)(item);
					
					window.close();
				} else {
					alert("<%=BizboxAMessage.getMessage("TX000010613","겸직 부서가 중복입니다. 다른 부서를 선택해주세요")%>");
				}
			}
		}
	}
	
	// 겸직 부서 중복 체크
	function checkEmpDept() {
		var bool = false;
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/empListData.do" />',
			datatype:"json",
			data: {empSeq:item.empSeq, deptSeq:item.deptSeq, isNoPage:'true'},
			async: false,
			success:function(data){
				if(data.list == null || data.list == '') {
					bool = true;
				}
			},			
			error : function(e){	//error : function(xhr, status, error) {
				console.log(e);
			}
		});	
		return bool;	
	}
	
	function getCompName() {
		var r = $(":radio[name=compSeqRadio]:checked");
		var compName = $(r).parent().parent().find("#compName").html();
		return compName;
	}
</script>
<script id="treeview-template" type="text/kendo-ui-template">
        #: item.text #
</script>

	<div class="pop_wrap" style="width:636px;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016070","회사/부서선택")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
		</div><!-- //pop_head -->
		
		<div class="pop_con">
			<div class="comp_left">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></p>
				<div class="box_div">
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="99"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000016067","회사검색")%></th>
								<td>
									<form id="searchForm" name="searchForm" method="POST" action="cmmCompDeptSelectPop.do">
										<input type="hidden" name="callback" class="" value="${params.callback}" >
										<input type="hidden" name="compSeq" class="" value="${params.compSeq}" >
										<input type="hidden" name="deptSeq" id="deptSeq" class="" value="${params.deptSeq}" >
										<input type="hidden" name="empSeq" id="empSeq" class="" value="${params.empSeq}" >
									<div class="dod_search">
										<input type="text" name="compName" class="" id="text_input" value="${params.compName}" style="width:123px;" placeholder="<%=BizboxAMessage.getMessage("TX000016064","회사명 검색")%>" /><a href="#" class="btn_sear" onclick="document.searchForm.submit();"></a>
									</div>
									</form>
								</td>
							</tr>
						</table>
					</div>

					<div class="com_ta2 ova_sc_all mt15" style="height:358px;">
						<table>
							<colgroup>
								<col width="37"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th></th>
								<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
							</tr>
							
							<c:forEach items="${compList}" var="list" varStatus="c">
							<tr>
								<td>
									<input type="radio" name="compSeqRadio" id="radio_u${c.count}" value="${list.compSeq}" class="k-radio" <c:if test="${params.compSeq == list.compSeq}">checked</c:if>>
									<label class="k-radio-label radioSel" for="radio_u${c.count}"></label>
								</td>
								<td id="compName">${list.compName}</td>
							</tr>
							</c:forEach>
						</table>
					</div>
				</div>
			</div>

			<div class="divi_right">
				<p class="tit_p"><%=BizboxAMessage.getMessage("TX000002687","부서선택")%></p>
				<div class="box_div p0">
					<div id="treeview" class="tree_icon" style="height:430px;"></div>
				</div>
			</div>
		</div><!-- //pop_con -->
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" id="okBtn" />
				<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" id="cancelBtn" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->