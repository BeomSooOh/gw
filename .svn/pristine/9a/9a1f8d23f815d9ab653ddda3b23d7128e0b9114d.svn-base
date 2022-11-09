<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script type="text/javascript">

	$(document).ready(function() {
		//기본버튼
		$(".controll_btn button").kendoButton();
		
		$(".btn_sear").on("click", function() {
			gridRead();
		});
		
		$("#okBtn").on("click", function() {
			
			if($(':radio[name="inp_chk"]:checked').length > 0){
				var selectedObject = {};
				selectedObject.cdPartner = $(':radio[name="inp_chk"]:checked').val();
				selectedObject.lnPartner = $(':radio[name="inp_chk"]:checked').parent().parent().children("td[colName=lnPartner]").html();
				opener.callbackPartner(selectedObject);
			}else{
				opener.callbackPartner(null);
			}
			
			self.close();
		});
		
	    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	  		pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'partnerManageData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	            	 options.compSeq = "${params.compSeq}";
	                 options.sKeyword = $("#sKeyword").val();
	                 options.clsPartner = "";
	                 options.useYn = "Y";
	                 options.svType = "";
	                 options.noCompany = "";
	                    
	                 if (operation !== "read" && options.models) {
	                     return {models: kendo.stringify(options.models)};
	                 }
	                 
	                 return options;
	             }
	         }, 
	         schema:{
	 			data: function(response) {
	 	  	      return response.list;
	 	  	    },
	 	  	    total: function(response) {
	 	  	      return response.totalCount;
	 	  	    }
	 	  	  }
	     	});
		    
		    // 등록, 수정, 보기에서 넘어왔을때 해당 페이지로 이동
		    
			dataSource.query({
		            page: 1,
		            group: dataSource.group(),
		            filter: dataSource.filter(),
		            sort: dataSource.sort(),
		            pageSize: dataSource.pageSize()
		    });
		    
		    //grid table
			$("#grid").kendoGrid({
				columns: [
					{
						field:"", 
						title:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						width:34, 
						headerTemplate: '', 
						headerAttributes: {style: "text-align:center;vertical-align:middle;"},
						template: '<input type="radio" name="inp_chk" id="inp_chk_#=cdPartner#" class="k-radio" value="#=cdPartner#" style="visibility: hidden;"><label class="k-radio-label radioSel" for="inp_chk_#=cdPartner#"></label>',
						attributes: {style: "text-align:center;vertical-align:middle;", clickevent : "N"},
				  		sortable: false
		  			},
		  			{
				  		field:"cdPartner", 
				  		title:"<%=BizboxAMessage.getMessage("TX000000315","거래처코드")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y", colName : "cdPartner"},
				  		sortable: false 
		  			},
				  	{
				  		field:"lnPartner", 
				  		title:"<%=BizboxAMessage.getMessage("TX000000313","거래처명")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y", colName : "lnPartner"},
				  		sortable: false  
		  			},
					{
				  		field:"svTypeNm",
				  		title:"<%=BizboxAMessage.getMessage("TX000010589","정보유형")%>",
				  		width:100,  
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;", clickevent : "Y"},
				  		sortable: false
		  			}
				],
				
				dataSource: dataSource,
				selectable: "single",
				sortable: false ,
	   	  		navigatable: true,
	   	  		pageable: {
					refresh: false,
	   	    		pageSizes: true
	   	  		},
	   	  		scrollable: false,
	   	  		columnMenu: false,
	   	  		autoBind: false,
				dataBound: function(e){
					
					$("#grid td[clickevent='Y']").css("cursor","pointer").click(function () {
						//선택 item
						var selectedItem = e.sender.dataItem(e.sender.select());						
						
						$("#grid tr[data-uid]").removeClass("k-state-selected");
						var checkedVal = $(':radio[name="inp_chk"]:checked').val();
						$(':radio[name="inp_chk"]:checked').attr("checked",false);
						//selectedObject = null;										

						if(checkedVal == null || checkedVal != selectedItem.cdPartner){
							//selectedObject = selectedItem;
							$(this).parent().addClass("k-state-selected");
							$('input:radio[value='+selectedItem.cdPartner+']').click();
						}
		            });
				}
			});		
	});
	
    function gridRead() {
		 var grid = $("#grid").data("kendoGrid");
			grid.dataSource.read();
			grid.refresh();
			grid.dataSource.page(1);
	}	

</script>

	<div class="pop_wrap resources_reservation_wrap" style="border: none;">
		<div class="pop_head">
			<h1><%=BizboxAMessage.getMessage("TX000016389","거래처검색")%></h1>
			<a href="#n" class="clo"><img src="<c:url value='/Images/btn/btn_pop_clo01.png' />" alt="" /></a>
		</div><!-- //pop_head -->
		
		<div class="pop_con" style="min-height: 500px;">
			<div class="com_ta">
				<table >
					<colgroup>
						<col width="177"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000000313","거래처명")%> / <%=BizboxAMessage.getMessage("TX000000315","거래처코드")%></th>
						<td>
							<div class="dod_search">
								<input type="text" id="sKeyword" style="width:350px;" onkeydown="if(event.keyCode==13){javascript:gridRead();}" /><a href="#" class="btn_sear"></a>
							</div>
						</td>
					</tr>
				</table> 
			</div>

			<div class="com_ta2 mt15">
				<div id="grid"></div>			
			</div>


		</div><!-- //pop_con -->
		
		<div class="pop_foot" style="width: 100%;    position: fixed;">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000000078","확인")%>" id="okBtn" />
				<input type="button"  class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="self.close();" />
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->