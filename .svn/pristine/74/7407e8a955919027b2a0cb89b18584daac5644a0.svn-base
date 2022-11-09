<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
 * 
 * @title 권한부여관리 화면
 * @version 
 * @dscription 
 * 
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용  
 * -----------  -------  --------------------------------
 * 2015. 6. 04.  송준석        최초 생성
 *
 */
%>

<script>

	$(document).ready(function(){
		//기본버튼
		$(".controll_btn button").kendoButton();
		
// 		$("#btnTree").click(function() {grpTreeInfo();});
// 		$("#btnDel").click(function() {delAuthorUserInfo();});
		
		BindKendoGrid();
	});
		
	// kendo grid 변경 부분 
	function BindKendoGrid(){
		
		var dataSource = new kendo.data.DataSource({
			serverPaging: true,
			transport: {
				read: {
					type: 'post',
					dataType: 'json',
					url: '<c:url value="/cmm/system/authorAssignClassList.do"/>'
				},
				parameterMap: function(data, operation) {
					
					data.searchKeyword = $("#searchClassKeyword").val();
					data.authorCode = $("#authorCode").val();
					data.authorTypeCode = $("#authorTypeCode").val();
					return data ;
				}
			},
			schema: {
				data: function(response) {
					return response.list;
				},
				total: function(response) {
					return response.list.length;
				}
			}
		});	
		
		var titleNm = "";
		
		if( $("#authorTypeCode").val() == "003")
			titleNm = "<%=BizboxAMessage.getMessage("TX000000105","직책")%>";
		else 
			titleNm = "<%=BizboxAMessage.getMessage("TX000000099","직급")%>";
// 		var jsondata = $.parseJSON('${jsonSelectList}');
		
		var grid = $("#list_class").kendoGrid({
			dataSource: dataSource,
			height:459,
			scrollable: true,
			sortable: true,
			filterable: false,
			selectable: 'row',
	        autoBind: true,
	        dataBound: gridDataBound,
	        columns: [
	                  {
	                	  field:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>",
	                	  width:40,
	                	  headerTemplate: '<input type="checkbox" name="checkAll" id="checkAll" class="k-checkbox" onclick="onCheckAll(this)"><label class="k-checkbox-label chkSel2" for="checkAll"></label>',
	                	  headerAttributes: {style: "text-align:center;vertical-align:middle;"},
	                	  template: '<input type="checkbox" name="inp_chk" id="#=CODE_ID#" class="k-checkbox"><label class="k-checkbox-label chkSel2" for="#=CODE_ID#"></label>', //그리드안의 체크박스는 로우별로 아이디가 달라야합니다. 개발 시 아이디를 다르게 넣어주세요.
	                	  attributes: {style: "text-align:center;vertical-align:middle;"},
	                	  sortable: false
	                   },
	                   {
	                	   field: "CODE_NM", title: titleNm,
	                	   headerAttributes: {style: "text-align: center;"},
	                	   attributes: {style: "text-align: center;"}
	                	}  
	        ]
 
	    }).data("kendoGrid");
		
		grid.table.on("click", ".k-checkbox" , function (e) {CommonKendo.setChecked(grid, this);});     
	} // grid end										
	
	// 전체 체크박스 
	function onCheckAll(chkbox) {
		
		var grid = $("#list_user").data("kendoGrid");
			
	    if (chkbox.checked == true) {
	    	checkAll(grid, 'inp_chk', true);
	    	
	    } else {
	    	checkAll(grid, 'inp_chk', false);
	    }
	};	

	/**
	* 체크박스 선택
	* @param checks
	* @param isCheck
	*/
	function checkAll(grid, checks, isCheck){
		var fobj = document.getElementsByName(checks);
		var style = "";
		if(fobj == null) return;
		if(fobj.length){
			for(var i=0; i < fobj.length; i++){
				if(fobj[i].disabled==false){
					fobj[i].checked = isCheck;
					CommonKendo.setChecked(grid, fobj[i]);
				}
			}
		}else{
			if(fobj.disabled==false){
				fobj.checked = isCheck;
			}
		}
	}
	
	function saveAuthor() {
		
		var chkArray = [];
		
		var check = $("#list_class :checkbox[checked=checked]");		
		var checkedLen = check.length;
		
		if(checkedLen==0){
			alert("<%=BizboxAMessage.getMessage("TX000016119","직책/직급를 선택 해 주세요")%>");	
			return;
		}
		
		check.each(function() {
			chkArray.push($(this).val());
		});
		
		var authorCode = $("#authorCode").val();
		var authorTypeCode = $("#authorTypeCode").val();
		var selected;
		selected = chkArray.join(',') + ",";		

		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/system/insertClassAuth.do" />',
			datatype:"json",
			data:{"authorCode":authorCode, "authClass":selected, "authorTypeCode":authorTypeCode},
			success:function(data){
				var result = data.result;
				
				if(result == "insert"){		
					//기관을 저장 하였습니다.
					alert('<spring:message code="userAuthor.regist.success.msg" />');
					//grp_tree();
				}else{
					//sql 에러가 발생했습니다! error code: {0}, error msg: {1}
					alert('<spring:message code="fail.common.sql" />');
					//grp_tree();
				}																		 
			}
		});			
	}	
	
	function selfReload() {

 		BindKendoGrid();
	}	

</script>

	
<form>							

<input type="hidden" id="authorCode" name="authorCode" value="<%=request.getParameter("authorCode")%>">
<input type="hidden" id="authorTypeCode" name="authorTypeCode" value="<%=request.getParameter("authorTypeCode")%>">

	<div class="controll_btn ri_btn">
<!-- 	    <button type="button" id="btnTree">조직도</button> -->
<!-- 		<button type="button" id="btnDel">삭제</button> -->
	</div>
	
	<div class="top_box">
		<dl>
			<dt><%=BizboxAMessage.getMessage("TX000014596","직책/직급")%></dt>
			<dd>
				<div class="dod_search">
				    <input type="text" class="fl" name="searchClassKeyword" id="searchClassKeyword"  style="width:330px;" placeholder="<%=BizboxAMessage.getMessage("TX000000862","전체")%>" value="${searchKeyword}"  />
					<a href="#" onclick="javascript:BindKendoGrid();" class="btn_sear"></a>
				</div>
			</dd>				
		</dl>
		
	 </div>		 
	 <div id="list_class" class="mt15" ></div>			
	 
<!-- 	<div class="content_right" style="width: 400px">	 -->
<!-- 		<div style="width:400px; float:left; margin:0; overflow:auto;"> -->
<!-- 			<table id="list_class" ></table> -->
<!-- 		</div> -->
		
<!-- 		<div id="div_btn" ></div> -->
<!-- 			<script type="text/javascript"> -->
<!-- // 			var msg = ["저장"]; -->
			
<!-- // 			var fn = ["saveAuthor()"]; -->
<!-- // 			var div_btn = "div_btn"; -->
<!-- // 			NeosUtil.makeButonType02(msg, fn, div_btn);																																	 -->
<!-- 			</script> 		 -->
<!-- 	</div> -->
								
</form>
