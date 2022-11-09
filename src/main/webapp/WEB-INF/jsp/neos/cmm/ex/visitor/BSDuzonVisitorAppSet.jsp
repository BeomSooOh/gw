<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">
    	$(document).ready(function(){
    		
    		//버튼이벤트
    		$(function () {
                $("#btnSearch").click(function () { fnGetDataList(); });	//검색버튼1
                $("#btnSearch2").click(function () { fnGetDataList(); });	//검색버튼2
                $("#btnSave").click(function () { fnSave(); });				//저장버튼
                $("#btnSelectUser").click(function () { fnUserPop(); });	//유저선택버튼
                
                //컨트롤 초기화
                fnControlInit();
            });
		    //기본버튼
			$("button").kendoButton();  

			//사용여부
		    $("#combobox_sel").kendoComboBox({
		        dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000002850","예")%>","<%=BizboxAMessage.getMessage("TX000006217","아니오")%>"]
		        },
		        value:"<%=BizboxAMessage.getMessage("TX000002850","예")%>"
		    });
			
		});//document ready end
		
		
		//승인관리 목록 dataSource
		var dataSource = new kendo.data.DataSource({
	     	  serverPaging: true,
	     	  //pageSize: 10,
	     	  filter: {
	     	    field: '1',
	     	    operator: 'neq',
	     	    value: '1'
	     	  },
	     	  transport: {
	     	    read: {
	     	      type: 'post',
	     	      dataType: 'json',
	     	      url: '<c:url value="/cmm/ex/visitor/GetApproverList.do"/>'
	     	    },
	     	    parameterMap: function(data, operation) {		
	     	    	data.comp_seq = 0;
	     	    	data.searchStr = $("#txtSearchStr").val();
	     	    	return data ;
	     	    }
	     	  },
	     	  schema: {
	     	    data: function(response) {
	     	      return response.list;
	     	    }
	     	  }
	     	  
	    });	
		
		
		//컨트롤 초기화
		function fnControlInit() {

	        $("#txtCoNM").text("");
	        $("#txtAppNM").val("")

	        var query = {
       		    //pageSize: 10,
        			page:1
       		  };
        	dataSource.query(query);
	        fnGetDataList();
	    }
		
		//grid셋팅
		function fnGetDataList(){
			var grid = $("#grid").kendoGrid({
				columns: [						
		  			{
				  		title:"<%=BizboxAMessage.getMessage("TX000000018","회사명")%>",
				  		field:"comp_name",
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: left;"},
				  		sortable: false 
		  			},
					{
				  		title:"<%=BizboxAMessage.getMessage("TX000005924","승인자")%>",
				  		field:"emp_name",
						width:100,	
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;"},
				  		sortable: false  
		  			}
				],
			dataSource: dataSource,
    		selectable: "single",
    		height:300,
			groupable: false,
			columnMenu:false,
			editable: false,
			sortable: true,
		    pageable: false,
			dataBound: function(e){ 
				$("#grid tr[data-uid]").css("cursor","pointer").click(function () {
					$("#grid tr[data-uid]").removeClass("k-state-selected");
					$(this).addClass("k-state-selected");
					
					//선택 item
					var selectedItem = e.sender.dataItem(e.sender.select());
					
					//데이타 조회 fucntion 호출
					fnSelectRow(selectedItem);
		            });							
			}		    
			}).data("kendoGrid");
		}
		

		//grid row선택 이벤트
		function fnSelectRow(e){
			var param = {};
			param.comp_seq = e.comp_seq;
			param.searchStr = $("#txtSearchStr").val();

			//선택된 회사 승인자 조회
			$.ajax({
	  		    	type:"post",
	  				url:'<c:url value="/cmm/ex/visitor/GetApproverList.do" />',
	  				datatype:"json",
	  				data: param ,
	  				success:function(data){
	  					//승인자가 있는 경우
	  					if (data.list[0] != null) {
	  	                    $("#txtCoNM").html(e.comp_name);
	  	                    $("#hidCoSeq").val(e.comp_seq);
	  	                    $("#txtAppNM").val(data.list[0].emp_name);
	  	                }
	  					//승인자 지정이 안된경우
	  	                else {
	  	                    $("#txtCoNM").html(e.comp_name);
	  	                  	$("#hidCoSeq").val(e.comp_seq);
	  	                    $("#txtAppNM").val("");
	  	                }
	  				},error : function(data){
	  					alert('error');
	  				}
	  		    	
	  		    });
			
		}
		
	
		//유저 선택팝업
		function fnUserPop(){
			var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
			$("#callback").val("callbackSel");
			frmPop.target = "cmmOrgPop";
			frmPop.method = "post";
			frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
			frmPop.submit();
			pop.focus(); 
		}
		
		//유저 선택 콜백함수
		function callbackSel(data) {
			if(data.returnObj != null){
		   		$("#txtAppNM").val(data.returnObj[0].empName);
		   		$("#hidUserSeq").val(data.returnObj[0].empSeq);
			}			
	  } 
		
	  //저장버튼
	  function fnSave(){
		  if ($("#hidCoSeq").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010884","회사선택 하세요")%>");
	            return false;
	        }

	        if ($("#txtAppNM").val() == "") {
	            alert("<%=BizboxAMessage.getMessage("TX000010883","승인자를 지정하세요")%>");
	            return false;
	        }
	        
	        var param = {};
	        
	        param.nCoSeq = $("#hidCoSeq").val();
	        param.nAppUserSeq = $("#hidUserSeq").val();


	        $.ajax({
	        	type:"post",
	    		url:'<c:url value="/cmm/ex/visitor/SetVisitApproval.do"/>',
	    		datatype:"json",
	            data: param ,
	    		success: function (cnt) {
	    				alert("<%=BizboxAMessage.getMessage("TX000002073","저장되었습니다.")%>.");
	    				fnGetDataList();
	    		    } ,
    		    error: function (result) { 
    		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
   		    		}
	    	});	  
	  }
    </script>


<div class="sub_contents_wrap">

<input type="hidden" id="hidCoSeq" name="hidCoID" />
<input type="hidden" id="hidUserSeq" name="hidUserID" />

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="u" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="callbackSel" />
	<input type="hidden" name="deptSeq" value="4102"/>
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>

<!-- 컨트롤박스 -->
<div class="top_box">
	<dl>
		<dt><%=BizboxAMessage.getMessage("TX000000399","검색어")%></dt>
		<dd><input class="" type="text" value="" style="width:200px" id="txtSearchStr"></dd>
		<dd><input type="button" id="btnSearch2" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" /></dd>
	</dl>
</div>

<div class="posi_re">
	<!-- 컨트롤버튼영역 -->
<div id="" class="controll_btn" style="">
	<button id="btnSearch"><%=BizboxAMessage.getMessage("TX000000899","조회")%></button>
	<button id="btnSave"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
</div>

<p class="tit_p posi_ab" style="top:15px; left:0px;"><%=BizboxAMessage.getMessage("TX000016187","승인관리 목록")%></p>
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
						<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
						<td id="txtCoNM"></td>
					</tr>
					<tr>
						<th><%=BizboxAMessage.getMessage("TX000005924","승인자")%></th>
						<td>
							<input type="text" id="txtAppNM" style="width:130px" readonly="readonly">
									<div class="controll_btn p0">
										<button id="btnSelectUser"><%=BizboxAMessage.getMessage("TX000000265","선택")%></button>
									</div>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->