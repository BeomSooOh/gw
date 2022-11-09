<%@page	import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="main.web.BizboxAMessage"%>
<%
/**
 * 
 * @title 양식리스트 팝업
 * @author UC개발부 개발1팀 이혜영
 * @since 2016. 02. 22.
 * @version v1.0 
 * @dscription 
 */
%>
    <script id="treeview-template" type="text/kendo-ui-template">
            #: item.name #
	</script>
	<script type="text/javascript">
		$(document).ready(function() {	

	        var dataSource = new kendo.data.HierarchicalDataSource({
	            transport: {
	              read: {
	            	  //url:'<c:url value="/admin/form/getFormTree.do?tiVisible=Y" />',
           			  url:'/ea/admin/form/getFormTree.do?tiVisible=Y',
	                  dataType: "json"
	              }
	            },
	            schema: {
	              model: {
	                  id: "seq", 
	                  children: "items"
	              }
	              ,data: function(response) {
	            	  var parameter = getQuery();
	            	  var formIdList = parameter.formIdList.split(',');
	            	  
	            	  for(var index = 0; index < response.treeList[0].items.length; index++) {
	            		  var folder = response.treeList[0].items[index].items;
	            		  
	            		  for(var childIndex = 0; childIndex < folder.length; childIndex++) {
	            			  var item = folder[childIndex];
	            			  for(var formIdIndex = 0; formIdIndex < formIdList.length; formIdIndex++) {
	    	       			  	if(item.seq == formIdList[formIdIndex]) {
	    							item.checked = true;
	    							break;
	    	       				}
	            			  }
	            		  }
	            	  }
	            	  
	                  return response.treeList;
	              }
	            }
	          });
	        
			/// 양식트리
			$("#treeview").kendoTreeView({
				checkboxes: {
		             checkChildren: true
		         },
				template: kendo.template($("#treeview-template").html()),
				dataSource : dataSource,
				dataTextField: ["name"],
				dataValueField: ["seq", "urlPath", "expanded", "spriteCssClass"]
			});    
	
			//기본버튼
	        $(".controll_btn button").kendoButton();
						
		});
		
		function formOpen_main (e) {
			var item = e.sender.dataItem(e.node);
			var template_key = item.seq;
			var formInfo = getFormDetailInfo(item.seq);
			
			var C_CIKIND = formInfo.C_CIKIND;
			
			var intLeft = screen.width / 2 - intWidth / 2;
		    var intTop = screen.height / 2 - intHeight / 2 - 40;
			var intWidth  = formInfo.C_ISURLWIDTH;
			var intHeight = formInfo.C_ISURLHEIGHT;
			
			var target = "AppForm";
			if(formInfo.C_LNKCODE == "LNK001"){ /** 연동여부 ***/
				var obj = {
					template_key : template_key,
					c_cikind : C_CIKIND
			    };
					
			    var param = NeosUtil.makeParam(obj);
			    var dataParam = formInfo.C_URLPARAM || "";
			    var url = formInfo.C_TIREGISTPAGEURL + "?" + param + "&" + dataParam;
		        
			    if(formInfo.C_ISURLPOP == "1"){ // 팝업여부
			    	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
			    }else{
			    	document.location.href = url;
			    }
			}else if (formInfo.C_LNKCODE == "LNK002"){
					if (formInfo.C_TIREGISTPAGEURL != "") {
			        	/* interlock_url dp "?" 가 포함된 경우와 포함되지 않은 경우 처리 */
			     		var connector = (formInfo.C_TIREGISTPAGEURL.indexOf("?") < 0 ? "?" : "&");
			        	url = formInfo.C_TIREGISTPAGEURL + connector + "form_id=" + template_key + "&form_tp=" + formInfo.FORM_D_TP + "&doc_width=" + formInfo.C_ISURLWIDTH + "&eaType=ea";
			        	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop );
			        }else{
			    		var obj = {template_key : template_key};
			    		var param = NeosUtil.makeParam(obj);
			    		neosPopup('POP_DOCWRITE_MAIN', param) ;
			        }        
			}else{
				var obj = {template_key : template_key};
				var param = NeosUtil.makeParam(obj);
				neosPopup('POP_DOCWRITE_MAIN', param) ;
			}
			
		}

		function getFormDetailInfo(c_tikeycode){
			var data = {c_tikeycode : c_tikeycode};
			var result = {};
		    $.ajax({
		        type:"post",
		        url:'<c:url value="/neos/edoc/eapproval/reportstoragebox/getFormInfo.do" />',
		        datatype:"json",
		        data : data,
		        async : false,
		        success:function(data){       
		        	result = data.result;
		            
		        }   
		    });
		    return result;
		}
		
		/**
		 *   트리 검색
		 */
		 function keywordSearch(){
		         var treeSearch = $("#treeSearch").val();
		         
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
		
		 function fnSave(){
			treeCheckList = CommonKendo.getTreeCheckedToJson($("#treeview").data("kendoTreeView"));
			
			opener.eaNonFormCallBack(treeCheckList);
			self.close();
		}
		 
		function fnClose(){
		 	self.close();
		}
		
		/**
		 * 파라미터 조회
		 */
		function getQuery(){
		    var url = document.location.href;
		    var qs = url.substring(url.indexOf('?') + 1).split('&');
		    for(var i = 0, result = {}; i < qs.length; i++){
		        qs[i] = qs[i].split('=');
		        result[qs[i][0]] = decodeURIComponent(qs[i][1]);
		    }
		    return result;
		}

	</script>
	
	<div class="pop_head">
	<h1><%=BizboxAMessage.getMessage("TX900000096","결재양식등록")%></h1>
	<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
</div> 
 
 

	<div class="pop_con">

		<div class="com_ta">
			<table>
				<colgroup>
					<col width="99"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000009645","양식함 명")%></th>
					<td>
						<div class="dod_search">
							<input type="text" class="" id="treeSearch" style="width:190px;"}"/>
							<a href="#" id="treeSearchBtn" class="btn_sear"></a>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div style="height: 20px"></div>
		
		<!-- 트리영역 -->

		<div id="treeview" class="tree_icon" style="width:100%;"></div>
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" onclick="fnSave()"/> 
				<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000002947","취소")%>" onclick="fnClose();"/>
			</div>
		</div>
			


	</div>
<%-- 	
	<div class="pop_wrap_dir" style="width:400px;">

		
		<div class="pop_con">
			<div class="box_div">
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="99"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000173","양식명")%></th>
							<td>
								<div class="dod_search">
									<input type="text" class="" name="treeSearch" id="treeSearch" style="width:190px;" onfocusin="javascript:clearContent(this);" onfocusout="javascript:checkContent(this);" onKeyDown="javascript:if (event.keyCode == 13) { keywordSearch(); return false; }"/>
									<a href="#" class="btn_sear" onclick="keywordSearch();"></a>
								</div>
							</td>
						</tr>
					</table>
				</div>
				<!-- 트리영역 -->
				<div id="" class="Pop_border scroll_on mt10" style="height:381px;">
					<div id="treeview" class="tree_icon" style="height:370px;"></div>
				</div>
			</div>
		</div>
		
<!-- 		<div class="pop_foot"> -->
<!-- 			<div class="btn_cen pt12"> -->
<!-- 				<input type="button" value="확인" /> -->
<!-- 				<input type="button"  class="gray_btn" value="취소" /> -->
<!-- 			</div> -->
<!-- 		</div>//pop_foot -->
	</div><!-- //pop_wrap -->
--%>
