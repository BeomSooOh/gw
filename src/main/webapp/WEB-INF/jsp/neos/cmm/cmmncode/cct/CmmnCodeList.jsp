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
  * @Class Name  : CmmnCodeList.jsp
  * @Description : 코드유형관리
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2015.06.18   조영욱              최초 생성
  * @ 2016.04.05   이두승              전체 수정
  *
  *  @author np파트 
  *  @since 2015.06.18
  *  @version 1.0
  *
  */
%>

<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000010791","코드유형ID")%> / <%=BizboxAMessage.getMessage("TX000010790","유형명검색")%></dt>
		<dd><input type="text" class=""id="text_input"  style="width:173px;" /></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
</div>

<div class="sub_contents_wrap" style="">
	<div id="" class="controll_btn">
		<button id="" class="k-button"><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
		<button id="" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
	</div>
	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width:50%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 리스트 -->
					<div id="grid"></div>
				</td>
				<td class="twinbox_td">
					<!-- 옵션설정 -->
					<div class="com_ta">
						<table>
							<colgroup>
								<col width="120"/>
								<col width=""/>
							</colgroup>
							<tr>
								<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000010919","유형ID")%></th>
								<td><input class="" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000010918","코드유형명")%></th>
								<td><input class="" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000016","설명")%></th>
								<td><input class="" type="text" value="" style="width:95%"></td>
							</tr>
							<tr>
								<th><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></th>
								<td>
									<input type="radio" name="radio_u1u2" id="radio_u1" class="k-radio" checked="checked">
									<label class="k-radio-label radioSel" for="radio_u1"><%=BizboxAMessage.getMessage("TX000000180","사용")%></label>
									<input type="radio" name="radio_u1u2" id="radio_u2" class="k-radio">
									<label class="k-radio-label radioSel ml10" for="radio_u2"><%=BizboxAMessage.getMessage("TX000001243","미사용")%></label>
								</td>
							</tr>
						</table>
					</div>
					<div class="btn_cen">
						<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->
</div><!-- //iframe wrap -->
</div><!-- //sub_contents -->


<script type="text/javascript">
		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
			
			
			
			    var dataSource = new kendo.data.DataSource({
			    	serverPaging: true,
			         transport: { 
			             read:  {
			                 url: 'CmmCodeListData.do',
			                 dataType: "json",
			                 type: 'post'
			             },
			             parameterMap: function(options, operation) {
			                 /* options.searchKeyword = $("#searchKeyword").val();
			                 	                    
			                 if (operation !== "read" && options.models) {
			                     return {models: kendo.stringify(options.models)};
			                 } */
			                 
			                 return options;
			             }
			         }, 
			         schema:{
			 			data: function(response) {
			 	  	      return response.resultList;
			 	  	    }
			 	  	  }
			     });
		    
		    //grid table
			$("#grid").kendoGrid({
		     	dataSource: dataSource,
		     	sortable: true ,
				selectable: "single",
	   	  		scrollable: true,
	   	  		columnMenu: false,
	   	  		autoBind: true,
				height:556,
			    columns: [
					{
						field:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						width:34, 
						headerTemplate: '<input type="checkbox" id="" />', 
						headerAttributes: {style: "text-align:center;vertical-align:middle;"},
						template: '<input type="checkbox" id="" />',
						attributes: {style: "text-align:center;vertical-align:middle;"},
				  		sortable: false
		  			},
		  			{
				  		field:"CODE", 
				  		title:"<%=BizboxAMessage.getMessage("TX000010919","유형ID")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;"},
				  		sortable: false 
		  			},
				  	{
				  		field:"NAME", 
				  		title:"<%=BizboxAMessage.getMessage("TX000010918","코드유형명")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;"},
				  		sortable: false  
		  			},
		  			{
				  		field:"USE_YN", 
				  		title:"<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;"},
				  		sortable: false
		  			}
				]
			});
		});
	</script>

