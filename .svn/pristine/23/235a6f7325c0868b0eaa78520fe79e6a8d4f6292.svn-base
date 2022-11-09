<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	//조직도 callback 구현
	
$(document).ready(function () {

    $("#searchKeyword").bind({
        keyup : function(event){
            if(event.keyCode==13){
                searchKeyword();
            }
        }
    });
    
    $("#btnCancle").on("click", function () {
        self.close();
   });    
});
	
 function searchKeyword() {
 	
     var searchKeyword = $("#searchKeyword").val();

     var treeview = $("#orgTreeView").data("kendoTreeView");
     var datasource = treeview.dataSource;
     
     var node = treeview.findByText(searchKeyword);
     var item = treeview.dataItem(node);
     treeview.select(node);
     openerParam(item);
     
 }
	  
</script>
<div class="pop_wrap" style="width:auto;">
    <div class="pop_head">
        <h1><%=BizboxAMessage.getMessage("TX000020258","담당자선택")%></h1>
        <a href="javascript:self.close();" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="닫기" /></a>
    </div>
                    
    <div class="pop_con">
        <div class="Pop_border" style="height:295px;">
            <p class="borderB" style="height:24px; padding:15px;">
                <input class="k-textbox input_search"id="searchKeyword" name="searchKeyword" type="text" value="" style="width:348px;" placeholder="<%=BizboxAMessage.getMessage("TX000010593","담당자검색")%>">
                <a href="#"  onclick="searchKeyword();" class="btn_search"></a>
            </p>
                                            
            <div id="orgTreeView" class="tree_icon" style="height:229px !important;"></div>
        </div>
    </div>  
    <div class="pop_foot">
        <div class="btn_cen pt12">
            <input type="button" id="btnConfirm" value="<%=BizboxAMessage.getMessage("TX000019752","확인")%>" />
            <input type="button" id="btnCancle" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000022128","취소")%>" />
        </div>
    </div><!-- //pop_foot -->
    </div><!-- //pop_wrap -->
<div>

<div id="orgTreeView"></div>

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
   

   $("#orgTreeView").kendoTreeView({
          dataSource: inline,
          select: onSelect,
          dataTextField: ["name"],
          dataValueField: ["seq"]
      }); 
   
   function onSelect(e) {
   	var item = e.sender.dataItem(e.node);
   	openerParam(item);
   	
   }
   function openerParam(item) {
	   
	   $("#btnConfirm").on("click",function () {
	       $("#username",opener.document).val(item.name);
	       $("#empSeq",opener.document).val(item.seq);   
           $("#rel",opener.document).val("M");   
	       self.close();
	   });
   }	   
   
     
	            
</script>

</div>




