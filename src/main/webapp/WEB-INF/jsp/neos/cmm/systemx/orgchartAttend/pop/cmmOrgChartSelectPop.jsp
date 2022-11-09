<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
	<script type="text/javascript">
	
	 var idx = 0;	// row 복제후 id값 변경을 위해 인덱스 선언
	
		$(document).ready(function() {	
			
			$('#btnText').focus();
			
			//기본버튼
	        $(".controll_btn button").kendoButton();
			
			//검색
			$(".btn_search").click(function(e){
				search();
				
			});

			$('#btnText').on('keypress', function(e) {
				if (e.which == 13) {
					search();
				}
			}); 

			//조직도검색 셀렉트
			$("#organ_sel").kendoComboBox({
				dataTextField: "text",
                dataValueField: "value",
				dataSource : [
					        {text:"<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"0"}, 
					        {text:"<%=BizboxAMessage.getMessage("TX000000277","이름")%>", value:"1"},
					        {text:"<%=BizboxAMessage.getMessage("TX000000075","아이디")%>", value:"2"}
				],
				index: 0
			}); 
			
			$("#removeSelEmpBtn").click(function(e){
				 var arr = $("#selEmpListTable").find("input:checked");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						$(arr[i]).parents("tr").remove();
					}
				 }
				 setCount();
			}); 
			
			$("#empListChkAll").click(function(e){
				 var ischeck = $(this).is(':checked');
				 var arr = $("#empListTable").find(".empchk");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						$(arr[i]).prop("checked", ischeck);			// 프로퍼티를 변경해야 이벤트가 정상적으로 동작
						if (ischeck == true) {
							selectEmp(arr[i]);
						} 
					} 
				 }
			});  
			
			$("#selEmpListChkAll").click(function(e){ 
				 var ischeck = $(this).is(':checked');  
				 var arr = $("#selEmpListTable").find(".selempchk");
				 if (arr.length > 0) {
					for(var i = 0; i < arr.length; i++) {
						$(arr[i]).prop("checked", ischeck); 		// 프로퍼티를 변경해야 이벤트가 정상적으로 동작
					}
				 }
			}); 
			
			$("#okBtn").click(function(e){ 
				
				var formdata = $("#selectForm").serializeArray();
				var data = [];
				var obj = {};
				
				for(var i = 0; i < formdata.length; i++) {
					var item = formdata[i];
					/* if (item.name == 'deptSeq' && i != 0) {
						data.push(obj);
						obj = {};
					} */
					obj[item.name] = item.value;
				}
				
				data.push(obj); 
				 
				opener.callbackSelectUser(data);
				 
				window.close(); 
			}); 
			
			
			var totalCount = "${fn:length(selectEmpList)}";
			
			
			$("#selectEmpCount").html("("+totalCount+")");
			
			idx = parserInt(totalCount); 
				 
		});  
		
		// 선택된 사원 목록 총개 갱신
		function setCount() {
					
			var rowCount = $('#selEmpListTable tr').length;
					
			$("#selectEmpCount").html("("+rowCount+")");
		}
		
		function search() {
			var type = $("#organ_sel").val();
				
				var data = {};
				
				var keyword = $("#btnText").val();
				
				switch (type) { 
					case 0 : 
						data.nameAndLoginId = keyword; 
						break;
					case 1 : data.empName = keyword; 
						break;
					case 2 : data.loginId = keyword; 
						break;
					default: 
						data.nameAndLoginId = keyword; 
						break;
				} 
				
				data.mainDeptYn = $("#mainDeptYn").val();
				
				$.ajax({
					type:"post",
					url:'<c:url value="/cmm/systemx/cmmOrgChartInnerEmpList.do" />',
					data:data,
					datatype:"json",			
					success:function(data){
						$("#empListDiv").html(data);
					} 
				});
			
			
		}
		
	</script>


<script>
	//조직도 callback 구현
	function callbackOrgChart(item) {
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/cmmOrgChartInnerEmpList.do" />',
			data:{groupSeq:item.groupSeq, compSeq:item.compSeq, bizSeq:item.bizSeq, deptSeq : item.seq, mainDeptYn : $("#mainDeptYn").val()},
			datatype:"json",			
			success:function(data){
				$("#empListDiv").html(data);
			}
		});
	} 
	  
</script>

<input type="hidden" id="mainDeptYn" value="${params.mainDeptYn}" />

<div class="pop_wrap organ_wrap" style="width:580px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000004738","조직도")%></h1>
		<a href="#n" class="clo" onclick="javascript:window.close();"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
	</div>
					
	<div class="pop_con">
		<div class="box_left">
			

			<p class="record_tabSearch">
				<input id="organ_sel" style="width:66px;" />
				<input class="k-textbox input_search" id="btnText" type="text" value="" style="width:120px;" placeholder="">
				<a href="#" class="btn_search" id=""></a>
			</p>

			<!-- 조직도-->
			<div class="treeCon" >									
				<div id="treeview" class="tree_icon" style="height:221px;"></div>
			</div> 		
			
			<!-- 사원목록 -->
			<div class="emp_list">
				<p class="tit"><%=BizboxAMessage.getMessage("TX000013655","사원목록")%></p>
				<div class="com_ta2">
					<table>
						<colgroup>
							<col width="120"/>
							<col width="75"/>
							<col />
						</colgroup>
						<tr>
							<th class="le">
								<input type="checkbox" name="inp_chk" id="empListChkAll" class="k-checkbox">
								<label class="k-checkbox-label" for="empListChkAll" style="margin:0 0 0 10px; padding:0.2em 0 0 1.5em;">
								<%=BizboxAMessage.getMessage("TX000013654","이름/아이디")%>
							</th>
							<th class=""><%=BizboxAMessage.getMessage("TX000000098","부서")%></label></th> 
							<th class=""><%=BizboxAMessage.getMessage("TX000000099","직급")%></label></th>
						</tr>
					</table>
				</div>	
		
		<div class="com_ta2"style="height:128px;" id="empListDiv">
			
		</div>
			
			</div>

			<!-- //사원목록 -->
							
		</div><!-- //box_left -->	

		<div class="box_right2">
		<div class="option_top">
			<ul>
				<li><%=BizboxAMessage.getMessage("TX000013653","선택된 사원 목록")%><span id="selectEmpCount">(0)</span></li>
			</ul>
			
			<div id="" class="controll_btn" style="padding:0px;float:right;">
				<button id="removeSelEmpBtn"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			</div>
		</div>

		<div class="com_ta2">
			<table>
				<colgroup>
					<col width="120"/>
					<col width="75"/>
					<col />
				</colgroup>
				<tr>
					<th class="le">
						<input type="checkbox" name="inp_chk" id="selEmpListChkAll" class="k-checkbox">
						<label class="k-checkbox-label" for="selEmpListChkAll" style="margin:0 0 0 10px; padding:0.2em 0 0 1.5em;">
						<%=BizboxAMessage.getMessage("TX000013654","이름/아이디")%>
					</th>
					<th class=""><%=BizboxAMessage.getMessage("TX000000098","부서")%></label></th>
					<th class=""><%=BizboxAMessage.getMessage("TX000000099","직급")%></label></th> 
				</tr>
			</table>
		</div>	
		
		<div class="com_ta2"style="height:387px;margin-top:0px;" >
			<form id="selectForm" name="selectForm">
				<table id="selEmpListTable">
					<colgroup>
						<col width="120"/>
						<col width="75"/>
						<col />
					</colgroup>
	
					<c:forEach items="${selectEmpList}" var="list" varStatus="c">
						<tr>
							<td class="le">
								<input type="checkbox" id="selchk_${c.count}" name="empSeq" class="k-checkbox selempchk" value="${list.empSeq}">
								<label class="k-checkbox-label" for="selchk_${c.count}" style="margin:0 0 0 10px; padding:0.2em 0 0 1.5em;">
								${list.empName}(${list.loginId})
								<input type="hidden" name="deptSeq" value="${list.deptSeq}">
								<input type="hidden" name="compSeq" value="${list.compSeq}">
							</td>  
							<td class="">${list.deptName}</label></td>
							<td class="">${list.dutyCodeName}</label></td>
						</tr>  
					</c:forEach>
				
				</table>
			</form>
		</div>
		
		</div><!-- //box_right2 -->

	</div><!-- //pop_con -->	

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" id="okBtn"/>
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="javascript:window.close();" />
		</div> 
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->


<!-- <div>
	<label for="searchKeyword">사원검색</label> <span	class="k-textbox k-space-right" style="width:200px;"> 
		<input type="text" id="searchKeyword" name="searchKeyword" value="" /> 
		<a href="#"	class="k-icon k-i-search" onclick="searchKeyword();">&nbsp;</a>
	</span>
</div> -->



<script>
	            var inline = new kendo.data.HierarchicalDataSource({
	                data: [${orgChartList}],
	                schema: {
                        model: {
                        	id: "seq",
                            children: "nodes"
                        } 
                    }
	            });
	            
	           /*  var checkChildren = '${checkChildren}';
	            
	            if (checkChildren == null || checkChildren == '' || checkChildren == 'false') {
	            	checkChildren = false;
	            } else {
	            	checkChildren = true;
	            } */ 
	
	            $("#treeview").kendoTreeView({
	            	/* checkboxes: {
	                    checkChildren: checkChildren
	                }, */
                    dataSource: inline,
                    select: onSelect,
                    dataTextField: ["name"],
                    dataValueField: ["seq", "gbn"]
                }); 
	            
	            function onSelect(e) {
	            	var item = e.sender.dataItem(e.node);
	               	
	               	callbackOrgChart(item);	// 반드시 구현
	            }
	            
            </script>

</div>




