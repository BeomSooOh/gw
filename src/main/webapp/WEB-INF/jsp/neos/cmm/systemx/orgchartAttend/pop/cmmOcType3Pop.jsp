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
		var rowIdx = 0;
		var empRowIdx = 100000;
		var isfirst = false;
		
		$(document).ready(function() {
			kendo.ui.progress($(".pop_wrap"), true);
			setTimeout("init()", 100);
			
			
		//기본버튼
           $(".controll_btn button").kendoButton();

		//조직도검색 셀렉트
			$("#organ_sel").kendoComboBox({
				dataSource: [
				    { id: 1, name: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>" },
				    { id: 2, name: "<%=BizboxAMessage.getMessage("TX000016055","회사/부서")%>" },
				    { id: 3, name: "<%=BizboxAMessage.getMessage("TX000000277","이름")%>" },
				    { id: 4, name: "<%=BizboxAMessage.getMessage("TX000002932","이메일")%>" }
				],
			  	dataTextField: "name",
			 	dataValueField: "id",
			 	index:0
			});

		//조직도검색 셀렉트
			$("#organ_sel2").kendoComboBox({
				dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000000862","전체")%>","<%=BizboxAMessage.getMessage("TX000016055","회사/부서")%>", "<%=BizboxAMessage.getMessage("TX000000277","이름")%>", "<%=BizboxAMessage.getMessage("TX000002932","이메일")%>"]
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
			select : selectTrip
		});
		
		$("#empListChkAll").click(function(e){
			var ischeck = $(this).is(':checked');
			var arr = $("#empListTable").find(".empchk");
			if (arr.length > 0) {
				for(var i = 0; i < arr.length; i++) {
					if ($(arr[i]).attr("disabled") != 'disabled') {
						$(arr[i]).prop("checked", ischeck);			// 프로퍼티를 변경해야 이벤트가 정상적으로 동작
						if (ischeck == true) {
							selectEmp(arr[i]);
						} 
					}
				} 
			}
		});  
	});
		
	function selectTrip(e) {
		if(getTabType() == 0 && isfirst == false) {
			focusTreeView('${params.focusSeq}');
			isfirst = true;
		} 
	}
		
	function init() {
		// 주소록 
		
		
		// 조직도
		try{
			<c:if test="${not empty orgChartList}">
				orgChartList = ${orgChartList};
				otvInit(orgChartList);
			</c:if>
			//selectedData();
			
			kendo.ui.progress($(".pop_wrap"), false);
		} catch(exception) {
			alert("<%=BizboxAMessage.getMessage("TX000010612","조직도를 생성 중 문제가 발생하였습니다")%>");
		}  finally {
			kendo.ui.progress($(".pop_wrap"), false);
		}
	}
	
	function focusTreeView(seq) {
		var treeview = $("#oTreeview").data("kendoTreeView");
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
	
	function treeAutoScroll(sel) {
		var position = $(sel).offset();
		$('#oTreeview').animate({scrollTop : position.top-200}, 500);
	}
	
	function otvInit(ocList) {
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
		
	   $("#oTreeview").kendoTreeView({
          dataSource: inline,
          select: onSelectTreeOrg,
          dataTextField: ["name"],
          dataValueField: ["seq", "gbn"]
       }); 
	   
	  //kendo.ui.progress($("#treeview"), false);
	}
	
	function onSelectTreeOrg(e) {
	   var item = e.sender.dataItem(e.node);
	   callbackOrgChart(item);	// 반드시 구현
	}
	
	function callbackOrgChart(item) {
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/cmmOcType3InnerEmpList.do" />',
			data:{groupSeq:item.groupSeq, compSeq:item.compSeq, bizSeq:item.bizSeq, deptSeq : item.seq, langCode : $("#langCode").val()},
			datatype:"json",			
			success:function(data){
				$("#divEmpList").html(data);
			}
		});
	} 
	  
	
	function getTabType() {
		var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");  
        return tabStrip.select().index();
	}
	
	function add(type) {
		var checkEmpList = $("#divEmpList").find("input[name=seq]:checked").parent();
		if (checkEmpList != null && checkEmpList.length > 0) {
			for(var i = 0; i < checkEmpList.length; i++) { 
				var row = checkEmpList[i];
				var inpList = $(row).find(".inp_box");
				var inpHtml = "";
				if (inpList != null && inpList.length > 0) {
					for(var y = 0; y < inpList.length; y++) {
						var inp = inpList[y];
						inpHtml += '<input type="hidden" name="'+$(inp).attr("name")+'" class="inp_box" value="'+$(inp).val()+'">';
					} 
				}
				
				var empName = $(row).find("input[name=empName]").val();
				var email = $(row).find("input[name=email]").val();
				var h = '<tr>'
						+	'<td class="le"><input type="checkbox" name="inp_chk" id="chk'+rowIdx+'" class="k-checkbox" />'
						+		'<label class="k-checkbox-label" for="chk'+rowIdx+'" style="padding:0.2em 0 0 10px;"></label>'
						+ inpHtml
						+	'</td>'
						+	'<td class="">'+empName+'</td>'
						+	'<td class="le"><div class="mx150" title="'+email+'">'+email+'</div></td>'
						+'</tr>';
				$("#selEmpListTable"+type).append(h);
				
				$(row).parent().remove();
				
				rowIdx++;
			}
		}
		
		setCount(type);
		
		// checkall 해제
		$("#empListChkAll").prop("checked", "");
		
	}
	
	function remove(type) {
		var checkEmpList = $("#selEmpListTable"+type).find("input[name=inp_chk]:checked").parent();
		if (checkEmpList != null && checkEmpList.length > 0) {
			for(var i = 0; i < checkEmpList.length; i++) { 
				var row = checkEmpList[i];
				var inpList = $(row).find(".inp_box");
				var inpHtml = "";
				if (inpList != null && inpList.length > 0) {
					for(var y = 0; y < inpList.length; y++) {
						var inp = inpList[y];
						inpHtml += '<input type="hidden" name="'+$(inp).attr("name")+'" class="inp_box" value="'+$(inp).val()+'">';
					} 
				}
				
				var compName = $(row).find("input[name=compName]").val();
				var empName = $(row).find("input[name=empName]").val();
				var email = $(row).find("input[name=email]").val();
				
				var h = '<tr>'
						+'<td class="le"><input type="checkbox" name="seq" id="chkbox_'+empRowIdx+'" class="k-checkbox empchk" />'
						+'	<label class="k-checkbox-label" for="chkbox_'+empRowIdx+'" style="padding:0.2em 0 0 10px;"></label>'
						+ inpHtml
						+'</td>'
						+'<td>'+compName+'</td>'
						+'<td class="">'+empName+'</td>'
						+'<td class="le"><div class=".mx120"  title="'+email+'">'+email+'</div></td>'
					+'</tr>';
				
				$("#empListTable").append(h);
				
				$(row).parent().remove();
				
				empRowIdx++;
			}
		}
		
		setCount(type);
	}
	
	function setCount(type) {
		var rowCount = $('#selEmpListTable'+type+' tr').length;
					
		$("#spanCount"+type).html("("+rowCount+")");
	}
	
	function searchKeyword() {
		var tab = getTabType();
		
		var combobox = $("#organ_sel").data("kendoComboBox");
		var item = combobox.dataItem();
		var searchType = item.id;
		
		var searchKeyword = $("#searchKeyword").val();
		
		if (searchKeyword == null || searchKeyword == '') {
			alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%> ");
			return ;
		}
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/cmmOcType3PopSearch.do" />',
			data:{groupSeq:$("#groupSeq").val(), compSeq:$("#compSeq").val(), tabType:tab, searchType:searchType, searchKeyword:searchKeyword, mainDeptYn:'Y', langCode:$("#langCode").val()},
			datatype:"json",			
			success:function(data){
				$("#divEmpList").html(data);
			}
		});
	}
	
	function ok() {
		var data = {};
		var selectedList = [];
		var obj = {};
		for(var y = 1 ; y < 4; y++) {
			selectedList = [];
			obj = {};
			var formdata = $("#selEmpListForm"+y).serializeArray();
			
			for(var i = 0; i < formdata.length; i++) {
				var item = formdata[i];
				if(item.name == "seq" || item.name == "deptSeq") {
					if (i != 0) {
						selectedList.push(obj); 
					} 
					obj = {};
				}
					
				obj[item.name] = item.value;
			}
			selectedList.push(obj);  
			
			data['selectedList'+y] = selectedList;
		}
		
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
	</script>

<input type="hidden" id="groupSeq" name="groupSeq" value="${params.groupSeq}" />
<input type="hidden" id="compSeq" name="compSeq" value="${params.compSeq}" />
<input type="hidden" id="langCode" name="langCode" value="${params.langCode}" />

<div class="pop_wrap email_wrap" style="width:998px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016128","주소록 선택")%></h1>
		<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
	</div>
					
	<div class="pop_con">

	<div class="tab_set">
		<div class="tab_style"  id="tabstrip">

			<ul>
				<li class="k-state-active"><%=BizboxAMessage.getMessage("TX000001491","주소록")%></li>
				<li><%=BizboxAMessage.getMessage("TX000004738","조직도")%></li>
			</ul>


		<div class="organ_tab1">
		<div class="box_left" style="width:240px;">			
			<!-- 조직도-->
			<div class="treeCon" >									
				<div id="aTreeview" class="tree_icon" style="height:475px;"></div>
			</div> 				
		</div><!-- //box_left -->	

		</div><!--// organ_tab1 -->

		
		<div class="organ_tab2">
			<div class="box_left" style="width:240px;">			
			<!-- 조직도-->
			<div class="treeCon" >									
				<div id="oTreeview" class="tree_icon" style="height:475px;"></div>
			</div> 				
		</div><!-- //box_left -->	
		</div><!--// organ_tab2 -->

		</div><!--// tab_div -->
		</div><!--//tab_set  -->

		<div class="fix_div">
		<div class="box_left" style="width:343px;">
			<div class="record_tabSearch">
				<input id="organ_sel" style="width:66px;" />
				<input class="k-textbox input_search" id="searchKeyword" type="text" value="" style="width:205px;" placeholder="">
				<a href="#" onclick="searchKeyword()" class="btn_search"></a>
			</div>

			<div class="br_com_area2">
				<div class="com_ta2 mt10">
				<table>
					<colgroup>
						<col width="35"/>
						<col width="80"/>
						<col width="65"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th class="le">
							<input type="checkbox" name="empListChkAll" id="empListChkAll" class="k-checkbox" />
							<label class="k-checkbox-label" for="empListChkAll" style="padding:0.2em 0 0 10px;"></label>
						</th>
						<th><%=BizboxAMessage.getMessage("TX000000047","회사")%></th>
						<th class=""><%=BizboxAMessage.getMessage("TX000000277","이름")%></th>
						<th class=""><%=BizboxAMessage.getMessage("TX000002932","이메일")%></th>
					</tr>
				</table>
			</div>	
			
			<div id="divEmpList" class="com_ta2 ova_sc"style="height:439px;margin-top:0px;">
				<%-- <table>
					<colgroup>
						<col width="35"/>
						<col width="80"/>
						<col width="65"/>
						<col width=""/>
					</colgroup>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" disabled checked/>
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" disabled />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
					<tr>
						<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
							<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
						</td>
						<td>더존비즈온</td>
						<td class="">홍길동</td>
						<td class="le"><div class=".mx120" title="dragontia@naver.com">dragontia@naver.com</div></td>
					</tr>
				</table> --%>
			</div>			
			</div><!--// br_com_area2 -->
		</div><!-- //box_right2 -->
		
		<div class="trans_tool">
			<ul style="margin-top:77px;">
				<li><a href="#" onclick="add('1')"><img src="<c:url value='/Images/btn/btn_arr01.png' />" alt="" /></a></li>
				<li><a href="#" onclick="remove('1')"><img src="<c:url value='/Images/btn/btn_arr02.png' />" alt="" /></a></li>
			</ul>

			<ul style="margin-top:141px;">
				<li><a href="#" onclick="add('2')"><img src="<c:url value='/Images/btn/btn_arr01.png' />" alt="" /></a></li>
				<li><a href="#" onclick="remove('2')"><img src="<c:url value='/Images/btn/btn_arr02.png' />" alt="" /></a></li>
			</ul>

			<ul style="margin-top:141px;">
				<li><a href="#" onclick="add('3')"><img src="<c:url value='/Images/btn/btn_arr01.png' />" alt="" /></a></li>
				<li><a href="#" onclick="remove('3')"><img src="<c:url value='/Images/btn/btn_arr02.png' />" alt="" /></a></li>
			</ul>
		</div>

		<div class="box_last">
			
			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li><%=BizboxAMessage.getMessage("TX000001467","받는사람")%><span id="spanCount1">(0)</span></li>
					</ul>
				</div>
				<div class="com_ta2 ova_sc" style="height:147px;">
					<form id="selEmpListForm1" name="selEmpListForm1">
					<table id="selEmpListTable1">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<!-- <tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@navernavernaver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr> -->
					</table>
					</form>
				</div><!--// com_ta2 -->
			</div><!--// sm_box -->

			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li><%=BizboxAMessage.getMessage("TX000004364","참조")%><span id="spanCount2">(0)</span></li>
					</ul>
				</div>
				<div class="com_ta2 ova_sc" style="height:149px;">
					<form id="selEmpListForm2" name="selEmpListForm2">
					<table id="selEmpListTable2">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<!-- <tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr> -->
					</table>
					</form>
				</div><!--// com_ta2 -->
			</div><!--// sm_box -->

			<div class="sm_box">
				<div class="option_top">
					<ul>
						<li><%=BizboxAMessage.getMessage("TX000001469","숨은참조")%><span id="spanCount3">(0)</span></li>
					</ul>
				</div>
				<div class="com_ta2 ova_sc" style="height:149px;">
					<form id="selEmpListForm3" name="selEmpListForm3">
					<table id="selEmpListTable3">
						<colgroup>
							<col width="35"/>
							<col width="80"/>
							<col width=""/>
						</colgroup>
						<!-- <tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr>
						<tr>
							<td class="le"><input type="checkbox" name="inp_chk" id="" class="k-checkbox" />
								<label class="k-checkbox-label" for="" style="padding:0.2em 0 0 10px;"></label>
							</td>
							<td class="">홍길동</td>
							<td class="le"><div class="mx150" title="dragontia@naver.com">dragontia@naver.com</div></td>
						</tr> -->
					</table>
					</form>
				</div><!--// com_ta2 -->
			</div><!--// sm_box -->
		</div><!--// box_last -->
	</div><!--// fix_div -->


	</div><!-- //pop_con -->	

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="ok()" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="window.close();" />
		</div>
	</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->


<iframe id="middleFrame" name="middleFrame" height="0" width="0" frameborder="0" scrolling="no"></iframe>
	
<form id="middleForm" name="middleForm" target="middleFrame" method="post">
	<input type="hidden" name="data" id="data" value="">
</form>