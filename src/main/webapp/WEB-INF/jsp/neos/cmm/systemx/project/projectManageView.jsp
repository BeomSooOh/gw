<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<!-- script-->
    <script id="treeview-template" type="text/kendo-ui-template">
            #: item.text #
	</script>
	
	<script id="treeview-restore-btn" type="text/kendo-ui-template">
		# if (flagDelete == 'd') { #
        	<button class="k-button" type="button" onclick="onclickRestore('#=noProject#','#=cdCompany#')" >복원</button>
    	# }#
	</script>

    <script type="text/javascript">
		$(document).ready(function() {
			//기본버튼
		    $(".controll_btn button").kendoButton();
		    
		    //기간검색 셀렉트박스
		    var dateTypeSelData = [
                        { text: "<%=BizboxAMessage.getMessage("TX000010581","프로젝트기간")%>", value:"1" },
                        { text: "<%=BizboxAMessage.getMessage("TX000004254","계약일")%>", value:"2" }
                    ];
		    $("#search_01_sel").kendoComboBox({
		       dataSource : dateTypeSelData,
		        dataTextField: "text",
                dataValueField: "value",
		        index: 0
		    });
		    			
			//상태 셀렉트박스
			var staProjectSelData = [
                        { text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"" },
                        { text: "<%=BizboxAMessage.getMessage("TX000006808","작성")%>", value:"001" },
                        { text: "<%=BizboxAMessage.getMessage("TX000011889","검토")%>", value:"002" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000798","승인")%>", value:"003" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000735","진행")%>", value:"100" },
                        { text: "<%=BizboxAMessage.getMessage("TX000001288","완료")%>", value:"999" }
            ];
			
			$("#search_03_sel").kendoComboBox({
		        dataSource : staProjectSelData,
		        dataTextField: "text",
                dataValueField: "value",
		        index: 0
		    });

			//사용여부 셀렉트박스
			var useYntSelData = [
                        { text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000180","사용")%>", value:"Y" },
                        { text: "<%=BizboxAMessage.getMessage("TX000001243","미사용")%>", value:"N" }
            ];
			
			$("#search_04_sel").kendoComboBox({
		        dataSource : useYntSelData,
		        dataTextField: "text",
                dataValueField: "value",
		        index: 0
		    });
			
			
			/*
			//사용여부 셀렉트박스
			var delSelData = [
                        { text: "<%=BizboxAMessage.getMessage("TX000000862","전체")%>", value:"" },
                        { text: "<%=BizboxAMessage.getMessage("TX000000424","삭제")%>", value:"d" },
                        { text: "<%=BizboxAMessage.getMessage("TX000003140","복원")%>", value:"r" }
            ];
			
			//삭제 셀렉트박스
			$("#search_05_sel").kendoComboBox({
		        dataSource : delSelData,
		        dataTextField: "text",
                dataValueField: "value",
		        value : 0
		    });*/

		    
		    //시작날짜
		    $("#from_date").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR" 
		    });
		    
		    //종료날짜
		    $("#to_date").kendoDatePicker({
		    	format: "yyyy-MM-dd",
		    	culture : "ko-KR" 
		    });
		    
		    //추가버튼
		    $("#addBtn").on("click", function(e) {
		    	reg("");
		    });
		    
		    $(".search").on("click", function(e) {
		    	gridRead();
		    });
		    
		    // 삭제
		    $("#delBtn").on("click", function(e){
		    	if(confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
			    	document.form.action = 'projectDelProc.do';
			    	document.form.submit();
		    	}		    	
		    });
		    
		    $("#syncBtn").on("click", function(e){
		    	projectSync();
		    });
		    
		    $("#setBtn").on("click", function(e){
		    	projectSyncPop();
		    });
		    
		    var dataSource = new kendo.data.DataSource({
	    	serverPaging: true,
	  		pageSize: 10,
	         transport: { 
	             read:  {
	                 url: 'projectManageData.do',
	                 dataType: "json",
	                 type: 'post'
	             },
	             parameterMap: function(options, operation) {
	                 options.sKeyword = $("#text_input").val();
	                 options.sDatetype = $("#search_01_sel").val();
	                 options.sdProject = $("#from_date").val();
	                 options.edProject = $("#to_date").val();
	                 options.lnPartner = $("#lnPartner").val();
	                 options.staProject = $("#search_03_sel").val();
	                 options.useYn = $("#search_04_sel").val();
	                    
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
		    var page = parseInt('${params.page}') || 1;
		    
			dataSource.query({
		            page: page,
		            group: dataSource.group(),
		            filter: dataSource.filter(),
		            sort: dataSource.sort(),
		            pageSize: dataSource.pageSize()
		    });
		    
		    
		    //grid table
			$("#grid").kendoGrid({
				columns: [
					{
						field: "", title:"<%=BizboxAMessage.getMessage("TX000000265","선택")%>", 
						width:34, 
						headerTemplate: '<input type="checkbox" id="chkAll" onclick="onCheckAll(this)" />', 
						headerAttributes: {style: "text-align:center;vertical-align:middle;"},
						template: '<input type="checkbox" name ="chkNoProject"  value="#=noProject#" #= svType == "ERP" ? disabled="disabled" : "" # />',
						attributes: {style: "text-align:center;vertical-align:middle;"},
				  		sortable: false
		  			},
		  			{
				  		field: "noProject", title:"<%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%>", 
						width:120,
						headerTemplate: '<a class="k-link" href="#"><%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%><span class="k-icon k-i-arrow-d"></span></a>', 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
				  	{
				  		field: "nmProject", title:"<%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
		  			{
				  		field: "stEdDate", title:"<%=BizboxAMessage.getMessage("TX000010581","프로젝트기간")%>", 
						width:160, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
		  			{
				  		field: "svTypeNm", title:"<%=BizboxAMessage.getMessage("TX000010589","정보유형")%>",
				  		width:110, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
					{
				  		field: "staProjectNm", title:"<%=BizboxAMessage.getMessage("TX000003636","단계")%>",
				  		width:70, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
					{
				  		field: "useYnNm", title:"<%=BizboxAMessage.getMessage("TX000000028","사용여부")%>",
				  		width:80, 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			},
		  			{
				  		field: "lnPartner", title:"<%=BizboxAMessage.getMessage("TX000000313","거래처명")%>", 
				  		headerAttributes: {style: "text-align: center;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer;", name:"clickAction"}
		  			}
		  			/*,
		  			{
				  		field:"flagDelete", title:"<%=BizboxAMessage.getMessage("TX000003140","복원")%>",
						width:100,  
				  		headerAttributes: {style: "text-align: center;line-height: 18px;"}, 
				  		attributes: {style: "text-align: center;cursor:pointer; ", name:"clickAction"},
				  		template : $("#treeview-restore-btn").html()
		  			}*/
				],
				
				dataSource: dataSource,
				selectable: "single",
				groupable: false,
				columnMenu:false,
				editable: false,
				sortable: true,
			    pageable: true,
				dataBound: function(e){ 
					
					gridDataBound(e);
					
					$("#grid [name='clickAction']").click(function () {
						//선택 item
						var selectedItem = e.sender.dataItem(e.sender.select());
						//데이타 조회 fucntion 호출
						projectInfo(selectedItem.noProject);
			            });							
				}	
			});
		});
		
		// data 갱신후 호출
		function gridDataBound(e) {
			var grid = $("#grid").data("kendoGrid");
        	var data = grid.dataSource.data();
        	
        	// ERP에서 삭제된 데이터 텍스트 색상 어둡게 변경
        	$.each(data, function (i, row) {
	            var status = row.flagDelete;
	            if (status == 'd') {
	                $('tr[data-uid="' + row.uid + '"] ').css("color", "#CCCCCC"); //green
	            }
        	});
		}
		
		 //check all
		function onCheckAll(chkbox) {
		    if (chkbox.checked == true) {
		    	checkAll('chkNoProject', true)
		    } else {
		    	checkAll('chkNoProject', false)
		    } 
		};
		
		function getPageInfo() {
			var grid = $("#grid").data("kendoGrid");
			var currentPage = grid.dataSource.page();	
			$("#page").val(currentPage);
		}
		
		function reg(noProject) {
			location.href="projectRegView.do?noProject="+noProject;
		}
		
		function projectInfo(noProject) {
			getPageInfo();
			$("#noProject").val(noProject);
			//location.href="projectInfoView.do?noProject="+noProject;
			document.form.action="projectInfoView.do";
			document.form.submit(); 
		}
		
		function gridRead() {
		 var grid = $("#grid").data("kendoGrid");
			grid.dataSource.read();
			grid.refresh();
		 }
		
		// 복원 처리
		function onclickRestore(no, cdCompany) {
			if (confirm("<%=BizboxAMessage.getMessage("TX000010588","선택한 정보를 복원하시겠습니까?")%>")) {
				restore(no, cdCompany);
			}
		}
			
		function restore(no, cdCompany) {
			$.ajax({
			 			type:"post",
			 			url:"projectRestoreProc.do",
			 			datatype:"json",
			 			data: {noProject:no, cdCompany:cdCompany},
			 			success:function(data){
			 				alert("<%=BizboxAMessage.getMessage("TX000010587","선택한 정보가 복원되었습니다")%>");
			 				gridRead();
			 			},			
			 			error : function(e){	//error : function(xhr, status, error) {
			 				//alert("error");	
			 			}
			 	});	
		}
			
		function projectSync() {
			$.ajax({
			 	type:"post",
			 	url:"projectSyncProc.do",
			 	datatype:"json",
			 	success:function(data){
			 		if (data.result == '1') {
			 			alert("<%=BizboxAMessage.getMessage("TX000016423","ERP 프로젝트 정보를 그룹웨어 프로젝트 정보로 동기화하였습니다.")%>");
			 			gridRead();
			 		} else {
			 			alert("<%=BizboxAMessage.getMessage("TX000010585","현재 동기화가 진행중입니다")%>");
			 		}
			 	},			
			 	error : function(e){	//error : function(xhr, status, error) {
			 		//alert("error");	
			 	}
			});	
		}
			
		function projectSyncPop() {
			var url = "projectSyncPop.do";
	    	var pop = window.open(url, "projectSyncPop", "width=356,height=252,scrollbars=no");
	    	pop.focus();   
		}
		
	</script>

<form id="form" name="form" method="post" >
	<input type="hidden" id="noProject" name="noProject" value="" />
	<input type="hidden" name="pageSize" value="${params.pageSize}" />
	<input type="hidden" name="redirectPage" value="${params.redirectPage}" />
	<input type="hidden" id="page" name="page" value="${params.page}" />

<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000000352","프로젝트명")%> / <%=BizboxAMessage.getMessage("TX000000528","프로젝트코드")%></dt>
		<dd><input type="text" class="" id="text_input" name="sKeyword" style="width:173px;" value="${params.sKeyword}" /></dd>
		<dd><input type="button" id="searchButton" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" class="search" /></dd>
	</dl>
	<span class="btn_Detail"><%=BizboxAMessage.getMessage("TX000005724","상세검색")%> <img id="all_menu_btn" src="<c:url value='/Images/ico/ico_btn_arr_down01.png'/>" /></span>
</div>

<div class="SearchDetail">
	<dl>
		<dd class="mr20">
			<input id="search_01_sel" name="sDatetype" style="width:110px;" value="${params.sDatetype}" />
			<input id="from_date" name="sdProject" class="dpWid" value="${params.pasdProjecteSize}" />
			~
			<input id="to_date" name="edProject" class="dpWid" value="${params.edProject}" />
		</dd>
		
		<dt><%=BizboxAMessage.getMessage("TX000000520","거래처")%></dt>
		<dd style="width:170px">
			<input class="" type="text" value="${params.lnPartner}" name="lnPartner" id="lnPartner" style="width:138px">
			<a href="#" class="btn_ico_search"></a>
		</dd>
		<dd><input id="" class="btn_search search" type="button" value="<%=BizboxAMessage.getMessage("TX000001289","검색")%>"/></dd>
	</dl>
</div>


<div class="sub_contents_wrap">

	<div class="btn_div">
		<div class="left_div">							
			<span class="mr5 ml10"><%=BizboxAMessage.getMessage("TX000003636","단계")%></span>
			<input id="search_03_sel" name="staProject" style="width:80px;" value="${params.staProject}"  />
			<span class="mr5 ml10"><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></span>
			<input id="search_04_sel" name="useYn" style="width:80px;" value="${params.useYn}"  />
			
			<!-- 
			<span class="mr5 ml10"><%=BizboxAMessage.getMessage("TX000016254","복원여부")%></span>
			<input id="search_05_sel" name="flagDelete" style="width:80px;" value="${params.flagDelete}"/>
			 -->
		</div>

		<div class="right_div">
			<div id="" class="controll_btn" style="padding:0px;">
			
				<c:if test="${isSyncAuto == 'N'}">
				<button style="display:none;" id="syncBtn" class="k-button" type="button"><%=BizboxAMessage.getMessage("TX000016429","ERP 싱크")%></button>
				</c:if>
				<button id="addBtn" class="k-button" type="button" ><%=BizboxAMessage.getMessage("TX000000446","추가")%></button>
				<button id="delBtn" class="k-button" type="button" ><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
				<button style="display:none;" id="setBtn" class="k-button" type="button"><%=BizboxAMessage.getMessage("TX000006520","설정")%></button>
			</div>
		</div>
	</div>

	<!-- 리스트 -->
	<div id="grid"></div>
</div><!-- //sub_contents_wrap -->

</form>	