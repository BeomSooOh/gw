<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%
/**
 * 
 * @title 권한부여관리 화면
 * @version 
 * @dscription
 *
 */
%>





<%-- <input type="hidden" id="authorCode" name="authorCode" value="<%=request.getParameter("authorCode")%>"> --%>

<div id="treeview2" class="tree_icon" style="height:492px;"></div>
<script>

    //기본버튼
	var inline = new kendo.data.HierarchicalDataSource({
        data: [${treeList}],        
        schema: {
            model: { 
            	id: "seq",
                children: "items"
            }     
        }   
    }); 

    var treeview = $("#treeview2").kendoTreeView({
    	autoBind: true,
    	checkboxes: {
            checkChildren: false
        },
        dataSource: inline,
        select: onSelect, 
        check: onCheck,
        dataTextField: ["name"],
        dataValueField: ["seq", "gbn"],
        messages: {
            retry: "Wiederholen",
            requestFailed: "Anforderung fehlgeschlagen.",
            loading: "Laden..."
          }
    }).data("kendoTreeView");
    
    function onCheck(e) {
    	var chbx = $(e.node).find('.k-checkbox input').filter(":first");
        var state = chbx.is(':checked');
    	 $(e.node).find(".k-group input").prop('checked', state);
    	 
 	        $(e.node).find(".k-group li.k-item").each(function(i,v){
 	        	e.sender.dataSource.getByUid($(v).attr('data-uid')).checked = state;
 	        });
    	
        if(this.parent(e.node) != null && this.parent(e.node).length > 0)
        	setParentCheckBox(e, $(this.parent(e.node)).attr('data-uid'), $(this.parent(e.node)), this);    
    }  
	
    function setParentCheckBox(e, parentUid, target, s){	
 		if(e.sender.dataSource.getByUid(parentUid) != null){ 	
 			$(s.parent(target)).prop('checked', state);
 			e.sender.dataSource.getByUid(parentUid).checked = true;
  			var t = $(s.parent(target));
  			var uid = t.attr('data-uid');
  			setParentCheckBox(e, uid, t, s)
		}
        
        var treeview = $("#treeview2").data("kendoTreeView");
        treeview.updateIndeterminate();
    }
    
    
function onSelect(e) {
	var item = e.sender.dataItem(e.node);
} 


</script>
