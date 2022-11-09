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
 * @title 기관/부서 선택 팝업
 * @version
 * @dscription
 */
%>	
<script>

    /**
     *   트리 검색
     */
     function keywordSearch(){
         var treeSearch = $("#searchKeyword").val();
         
         if(treeSearch !== "") {
             $("#treeview .k-group .k-group .k-in").closest("li").hide();
             $("#treeview .k-group .k-group .k-in:contains(" + treeSearch + ")").each(function() {
                 $(this).parents("ul, li").each(function () {
                     $(this).show();
                 });
             });
         } else {
             $("#treeview .k-group").find("ul").show();
             $("#treeview .k-group").find("li").show();
             
         }                                     
     }    
    
     //콜백 함수 호출      
     function callbackOrgChart(data) { 
    	 
    	 $("#btnConfirm").click(function () {
        	 opener.callBackDeptItems(data);  
			 window.close();   		 
    	 })
     }   
       
       
    	   
       
	</script>

	<input type="hidden" id="selectItems" value="">
<body>
<div class="pop_wrap" style="width: 100%;height: 522px;">
    <div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000016071","회사/부서 선택")%></h1>
		      <a href="javascript:window.close();" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div>
    <div class="pop_con">

        <div class="Pop_border" style="height:395px;">
            <p class="borderB" style="height:24px; padding:15px;">
                <input class="k-textbox input_search" id="searchKeyword" type="text" value="" style="width:184px;" placeholder="<%=BizboxAMessage.getMessage("TX000005142","조직검색")%>"  onKeyDown="javascript:if (event.keyCode == 13) { keywordSearch(); }">
                <a href="javascript:keywordSearch();" class="btn_search"></a>
            </p>
                                            
            <div id="treeview" class="tree_icon" style="height:329px !important;">
                <jsp:include page='/systemx/orgChartList.do'></jsp:include>
            </div>
        </div>
        		
	</div>

    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" id="btnConfirm" onclick="fnConfirm();"  value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" />
            <input type="button" onclick="javascript:window.close();" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" />
        </div>
    </div><!-- //pop_foot -->
    </div><!-- //pop_wrap -->
    
</body>