<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/css/jsTree/style.min.css' />" />

<style>
li.jstree-open>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_open01.png") 0px 0px
		no-repeat !important;
}

li.jstree-closed>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px
		no-repeat !important;
}

li.jstree-leaf>a .jstree-icon.jstree-themeicon {
	margin-left: 5px;
	margin-top: 5px;
	margin-right: -3px;
	background: url("/gw/css/jsTree/ico_folder_fold01.png") 0px 0px
		no-repeat !important;
}

#orgTreeView .jstree-container-ul>.jstree-node {
	background: transparent;
}

#orgTreeView .jstree-container-ul>.jstree-node>.jstree-ocl {
	background: transparent;
}

#orgTreeView .jstree-container-ul>.jstree-open>.jstree-ocl {
	background-position: -36px -4px;
}

#orgTreeView .jstree-container-ul>.jstree-closed>.jstree-ocl {
	background-position: -4px -4px;
}

#orgTreeView .jstree-container-ul>.jstree-leaf>.jstree-ocl {
	background: transparent;
}
</style>

<script type="text/javascript" src="<c:url value='/js/jsTree/jstree.min.js' />"></script>

<script id="treeview-template" type="text/kendo-ui-template">
	#: item.name #
</script>

<c:if test="${ClosedNetworkYn != 'Y'}">
	<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>
</c:if>

<script>
	var deptCaptain = "";		// 부서장 선택여부 (SK D&D)
	var varDeptSeq = "";	
	var orgSyncFromErp = new kendo.data.ObservableObject({"visibled": ""}); /* ERP 조직도 연동 버튼 활성화 여부 */
	var tabType = "-1";		//현재 탭 index
	var isTypeChange = false;
	var eaType = "${loginVO.eaType}";
	orgSyncFromErp.bind('change', function (e) {
		if(this.get('visibled')){
			$('#erpDept').show();
		} else {
			$('#erpDept').hide();
		}
	})
	
	$(document).ready(function(){
		orgSyncFromErp.set('visibled', false); /* ERP 회사 맵핑 후 설정 가능 */
		$("#combo_use").kendoComboBox();
		$("#combo_use").data("kendoComboBox").value("ALL");
// 		$("#combo_use").kendoComboBox({
// 	        dataSource : {
// 				data : ["전체","사용"]
// 	        },
// 	        value:"전체"
// 	    });
		
		$("#appendDept").click(appendDept);
		$("#removeDept").click(removeDept);
		$("#newDept").click(newDept);
		$("#saveDeptInfoBtn").click(saveDept);
		$("#excelDept").click(excelDept);
		
		
		compComInit();
		
		deptManageTreeInit();
	
		getDeptInfo('','d');
	});
	
	//회사선택 selectBox
	function compComInit() {
		<c:if test="${not empty compListJson}">
		    $("#com_sel").kendoComboBox({
		    	dataTextField: "compName",
	            dataValueField: "compSeq",
		        dataSource :${compListJson},
		        value:"${params.compSeq}",
		        change: compChange,
		        filter: "contains",
		        suggest: true,
	        	index: 0
		    });
		    
// 		    var deptComData = $("#com_sel").data("kendoComboBox");
		    
// 		    deptComData.dataSource.insert(0, { compName: "전체", compSeq: "" });
// 		    deptComData.refresh();
// 		    deptComData.select(0);
		</c:if>
	}
	
	function setLiAttr(n){
		for(var i=0;i<n.children.length;i++){
			setLiAttr(n.children[i]);	
		}
		n.li_attr['class'] = n.tIcon;
		return;
	}
	
	
	// 조직도 트리 생성
	function deptManageTreeInit() {
		$("#orgTreeView").attr('class','jstreeSet tree_auto'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
		var compSeq = $("#com_sel").val() || '';
		var searchDept = $("#hidSearchDept").val();
		var useYn = $("#combo_use").val();
		var bizDisplayYn = document.getElementById("bizDisplayYn").checked ? "N" : "Y" ;
		
        $('#orgTreeView').jstree({ 
        	'core' : { 
        		'data' : {
            		'url' : '<c:url value="/cmm/systemx/deptManageOrgChartListJT.do" />',
            		//'url' : '<c:url value="/cmm/systemx/orgChartListJT.do" />',
            		'cache' : false,
            		'dataType': 'JSON',
	        			'data' : function (node) { 
	        				return {'parentSeq' : (node.id == "#" ? 0 : node.id), 'compSeq' : compSeq, 'searchDept' : searchDept, 'deptSeq' : varDeptSeq, 'includeDeptCode' : true, useYn : useYn, bizDisplayYn : bizDisplayYn};
	        				//return {'parentSeq' : (node.id == "#" ? 0 : node.id)}
	        			},
	        			'success' : function (n) {
	        				//트리 클릭시 조회 로직을 타기 때문에 조회가 성공하면 검색조건 초기화
	        				$("#hidSearchDept").val('');
	        				
	        				setLiAttr(n[0]);
// 	        				for(var i = 0; i < n.length; i++)
// 	        			    {
// 	        					n[i].li_attr['class'] = n[i].tIcon;	        					
// 	        			    }
	        			    return n;
	        			}
        		},
        		'animation' : false 
        	}
        })
        .bind("loaded.jstree", function (event, data) {
			//console.log("loaded.jstree");
        	// load후 처리될 event를 적어줍니다.
        	//fnMyDeptInfo();

        	$(this).jstree("open_all");
        	fnSetScrollToNode(varDeptSeq);
		})
// 		.bind('ready.jstree', function(event, data) {
// 			  var $tree = $(this);
// 			  $($tree.jstree().get_json($tree, {
// 			      flat: true
// 			    }))
// 			    .each(function(index, value) {
// 			      var node = $("#orgTreeView").jstree().get_node(this.id);
// 			      node.li_attr['class'] = node.li_attr.css;	  
// 			    });
// 			})
		.bind("select_node.jstree", function (event, data) {
			// node가 select될때 처리될 event를 적어줍니다.​
			if(!isTypeChange){
				var dataList = data.node.original;
				var seq = OJT_fnGetCompensId(dataList.id);
				var org = dataList.gbnOrg;
				//alert(JSON.stringify(dataList));			
				getDeptInfo(seq, org);				
			}else{
				
			}
		});
		/*
		.bind("open_node.jstree", function (event, data) {
			console.log("open_node.jstree");
			// node가 open 될때 처리될 event를 적어줍니다.​
		})
		.bind("dblclick.jstree", function (event) {
			console.log("dblclick.jstree");
			// node가 더블클릭 될때 처리될 event를 적어줍니다.​​
		});
		*/
	}
	
	/* [노드 아이디 반환] 노드 아이디 보정하여 반환
	---------------------------------------------------------*/
	function OJT_fnGetCompensId(id){
		return id.substring(1);
	}
	
	
	
	function deptManageTreeInit2() {
		$("#orgTreeView").attr('class','jstreeSet tree_auto'); //회사변경시 클래스가 사라져 스크롤이 생기지않아 강제로 넣어줌
		var compSeq = $("#com_sel").val() || '';
		var searchDept = $("#hidSearchDept").val();
		
		
        $('#orgTreeView').jstree({ 
        	'core' : { 
        		'data' : {
            		'url' : '<c:url value="/cmm/systemx/deptManageOrgChartListForAdmin.do" />',
            		'cache' : false,
            		'dataType': 'JSON',
	        			'data' : function (node) { 
	        				return {
	        					'parentSeq' : (node.id == "#" ? 0 : node.id), 
	        					'gbnOrg' : (node.id == "#" ? 'b' : node.original.gbnOrg), 
	        					'compSeq' : compSeq, 
	        					'searchDept' : searchDept,
	        					'deptSeq' : sseqq, 
	        					'includeDeptCode' : true
	        				};
	        			},
	        			'success' : function (n) {
	        				$("#hidSearchDept").val('');
	        				
	        				for(var i = 0; i < n.length; i++)
	        			    {
	        					n[i].li_attr['class'] = n[i].tIcon;
	        			    }
	        			    return n;
	        			}
        		},
        		'animation' : false 
        	}
        })
        .bind("loaded.jstree", function (event, data) {
			//console.log("loaded.jstree");
        	// load후 처리될 event를 적어줍니다.
        	//fnMyDeptInfo();
		})
		.bind("select_node.jstree", function (event, data) {
			// node가 select될때 처리될 event를 적어줍니다.​
			var dataList = data.node.original;
			var seq = OJT_fnGetCompensId(dataList.id);
			var org = dataList.gbnOrg;
			//alert(JSON.stringify(dataList));
			
			getDeptInfo(seq, org);
		});
	}
	
	//회사 변경 이벤트
	function compChange() {
		$('#orgTreeView').jstree("destroy").empty();
		tabType = "-1";
		getDeptInfo('','d');
		deptManageTreeInit();
	}

   		
	//조직도  callback 구현
	function callbackOrgChart(e) {
		var item = e.sender.dataItem(e.node);

		getDeptInfo(item.seq, item.gbnOrg)
	}
	
	//부서정보 조회 view 구현
	function getDeptInfo(seq, gbnOrg) {
		$("#newMode").val("false");		
		var data = {};
		data.deptSeq = seq;
		data.gbnOrg = gbnOrg;
		
		if(gbnOrg == "c"){
			data.deptSeq = '';
			data.gbnOrg = 'd';
		}
		
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/systemx/deptInfo.do" />',
			data: data,
			datatype:"text",			
			success:function(data){
				$('#deptInfo').html(data);
				if(tabType != "-1"){
					 $("#tabstrip").kendoTabStrip().data("kendoTabStrip").select(tabType);   
				}				
				if(seq != ""){
					$('#deptType').data('kendoComboBox').enable(false);
				}
			}
		});
	}
	
	var searchCount = ''; //검색횟수
	var searchDeptNm = ''; //검색내용
	//Tree 검색
	function searchDept() {
		
		$('#orgTreeView').jstree("deselect_all");
	
		var searchDept = $("#txtSearch").val();
		if(searchDept == ''){
			alert("<%=BizboxAMessage.getMessage("TX000015495","검색어를 입력하세요.")%>");
			return;
		}
		
		//처음검색일때
		if(searchDeptNm == ''){
			searchDeptNm = searchDept;
			searchCount = 0;
		}
		
		//검색내용이 바뀌면 초기화
		if(searchDeptNm != searchDept){
			searchDeptNm = searchDept;
			searchCount = 0;
		}
		
		var param = {};
		param.searchDept = searchDept; 
		param.compSeq = $("#com_sel").val() || $("#compSeq").val() || '';
		$.ajax({
			type: "post"
			, url: '<c:url value="/cmm/systemx/GetSearchDeptList.do" />'
			, dataType: "json"
			, data: param
			, success: function (result) {
				var result = result.list;
				if(result.length > 0) {
 					//$('#orgTreeView').jstree("close_all");
					
					for(i=0; i<result.length; i++){
						if(searchCount == i){
							var nodeDepth = result[i].deptPath;
							var selectedNode = i;
							var orgGbn = result[i].empDeptFlag;
							fnSearchNode(nodeDepth, searchCount, selectedNode);
						}
					}
				}
				//검색 내용이 같다면 카운터+1
				if(searchDeptNm == $("#txtSearch").val()){
					searchCount = searchCount + 1;
				}
				
				//검색횟수가 검색한 부서개수와 같다면 처음 부서로 조회하기위해 0으로 변경
				if(searchCount == result.length){
					searchCount = 0;
				}
				
			
			}
			, error: function (err) {
				searchCount = '';
				searchDeptNm = '';
				//alert(JSON.stringify(err));
			}
		});
	}
	
	/* [트리 검색] 대상 노드 탐색, 하이라이팅
	---------------------------------------------------------*/
	function fnSearchNode(nodeDepth, searchCount, selectedNode) {
		//alert(nodeDepth);
		var l = nodeDepth.split("|");
		var pocusNode = '';
		//$('#orgTreeView').jstree("deselect_all");
		for (var i = 0; i < l.length; i++) {
			var orgGbn = 'c';
			if(i == 0){
				// 노드가 회사인 경우.
				orgGbn = 'c';
			}else{
				// 노드가 부서인 경우
				orgGbn = 'd';
			}
			
			$('#orgTreeView').jstree("open_node", $("#"+ orgGbn + l[i]));
			
			if (searchCount == selectedNode && i === (l.length - 1)) {
				$('#orgTreeView').jstree("select_node", $("#"+ orgGbn + l[i]));
				pocusNode = orgGbn+l[i];
				var jstree = document.getElementById('orgTreeView');
				
				console.log("searchCount= "+searchCount+" / pocusNode= "+pocusNode+" / getPosition=" +getPosition(document.getElementById(pocusNode)).y);
		 		
		 		//$("#orgTreeView").scrollTop(1000);
		 		$("#orgTreeView").animate({scrollTop:getPosition(document.getElementById(pocusNode)).y - jstree.offsetHeight / 2 },1000 ); // 이동
			}
		}
 		
	}
	
	
	function fnSetScrollToNode(nodeId) {
		var jstree = document.getElementById('orgTreeView');
		var toY = getPosition(document.getElementById("d"+nodeId)).y;
		var offset = jstree.offsetHeight / 2;
		var topV = toY - offset;
		
		// alert('y : ' +  toY + '\nx : ' + offset + '\ntopV : ' + topV );
		
		$(".jstreeSet").animate({
			scrollTop : (toY/2)
		}, 200); // 이동
	}
	
	//get position of element
	function getPosition(element) {
	    var xPosition = 0;
	    var yPosition = 0;

	    while (element)
	    {
	        xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft);
	        yPosition += (element.offsetTop - element.scrollTop + element.clientTop);
	        element = element.offsetParent;
	    }
	    return { x: xPosition, y: yPosition };
	}
	
	function removeDept() {
		var selectedElms = $('#orgTreeView').jstree("get_selected", true);
		var length = selectedElms.length;
		var compSeq = $("#com_sel").val() || $("#compSeq").val() || '';
		
		if($("#deptType").data("kendoComboBox").value() == "B"){
			if($("#bizSeq").val() == $("#compSeq").val()){
				alert("<%=BizboxAMessage.getMessage("TX900000273","기본 사업장은 삭제 불가능합니다.")%>");
				return false;
			}
		}
		
		
		if(length < 1){
			return;
		}
		if($("#deptSeq2").val() == ''){
			return;
		}
		
        var item = selectedElms[length-1];
// 20220603 알림내용추가        
//        if (confirm("<%=BizboxAMessage.getMessage("TX000010742","{0}를 삭제 하시겠습니까? ")%>".replace("{0}","["+$("#" + item.id).text()+"]")) == false) {
        if (confirm("<%=BizboxAMessage.getMessage("TX000010742","{0}를 삭제 하시겠습니까? 부서삭제시 기록물철 열람이 불가합니다.")%>".replace("{0}","["+$("#" + item.id).text()+"]")) == false) {

        	return;	
		}
        
        varDeptSeq = item.parent.substring(1);
        var deptType = $("#deptType").data("kendoComboBox").value();
        $.ajax({
   			type:"post",
   			url:"deptRemoveProc.do",
   			datatype:"text",
   			async:false,
   			data: {deptSeq : item.id.substring(1), compSeq : compSeq, deptType : deptType, bizSeq : $("#bizSeq").val()},
   			success:function(data){
            	alert(data.result);
            	$("#bs_sel").val('');
   				$("#parentDeptSeq").val('');
   				fnControllInit();
            	compChange();
   			},			
   			error : function(e){
   				alert("error");	
   			}
    	});
        
	}
        
	function saveDept() {
		var saveFlag = $("#newMode").val();
		
		if($("#chkSeq").val() == "false"){
			alert("<%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다")%>");
     		return;
 		}
		
		// 영리일 경우에만 약칭 제한 체크
		if (eaType == "eap") {
    		if($("#deptType").data("kendoComboBox").value() != "B") {
    			if($("#deptNickname").val() != "" && $("#deptNickname").val() != null){
    				var deptNickName = $("#deptNickname").val();
    				
    				if(!isNicknameChecked(deptNickName)) {
    			    	alert("부서약칭에 입력 제한 값이 입력되었습니다.\n    기호는 마지막에 입력 될 수 없습니다.\n             ([- / . , ~])");
    					return false;
    			    }
    			}
    		}
    		else {
    			if($("#bizNickname").val() != "" && $("#bizNickname").val() != null){
    				var bizNickName = $("#bizNickname").val();
    
    				if(!isNicknameChecked(bizNickName)) {
    			    	alert("사업장약칭에 입력 제한 값이 입력되었습니다.\n    기호는 마지막에 입력 될 수 없습니다.\n             ([- / . , ~])");
    					return false;
    			    }	
    			}
    		}
		}
			
		
		
		if($("#deptType").data("kendoComboBox").value() == "B"){
			if($("#fileUpload01").val() != ""){
				var formData = new FormData();
		 			var pic = $("#fileUpload01")[0];    				
		 			
		 			formData.append("file", pic.files[0]);
		 			formData.append("pathSeq", "900");	//이미지 폴더
		 			formData.append("relativePath", "bizSeal"); // 상대 경로
					 
		 			$.ajax({
		                 url: _g_contextPath_ + "/cmm/file/profileUploadProc.do",
		                 type: "post",
		                 dataType: "json",
		                 data: formData,
		                 async:false,
		                 // cache: false,
		                 processData: false,
		                 contentType: false,
		                 success: function(data) {
		                	$("#IMG_BIZ_SEAL_fileID").val(data.fileId);
		  					$("#IMG_BIZ_SEAL_newYN").val("Y");								
		                 },
		                 error: function (result) { 
		 		    			alert("<%=BizboxAMessage.getMessage("TX000006510","실패")%>");
		 		    			return false;
		 		    		}
		             });
			}
		}
		
		
		if(saveFlag == "false"){
			saveDeptInfo();
		}
		else{
			appendDept();
		}
	}

    //약칭 제한값 체크 함수
    function isNicknameChecked(val) {
        var noLastText = ['-', '/', '.', ',', '~']
        var lastText = val.charAt(val.length - 1);
        // '년도', '월', '일' 글자X
        // 제한값 제거처리(2021-01-25 정유민사원 협의 - UBA-71441)
//         if (val.indexOf('년도') > -1 || val.indexOf('월') > -1 || val.indexOf('일') > -1) {
//         	return false
//         }
        // - / . , ~ 마지막X
        if (noLastText.indexOf(lastText) > -1) {
        	return false
        }
        return true;
    }
	
	function appendDept() {
		var text1 = $("#deptSeq2").val();
        if ($("#deptCd").val() == null || $("#deptCd").val() == '') {
        	if($("#deptType").data("kendoComboBox").value() != "B")
        		alert("<%=BizboxAMessage.getMessage("TX000010741","부서코드 입력해 주세요")%>");
        	else
        		alert("<%=BizboxAMessage.getMessage("TX000007109","사업장코드 입력해 주세요")%>");
    		return;	
    	}
        
		var text2 = $("#deptName").val();
        if (text2 == null || text2 == '') {
        	if($("#deptType").data("kendoComboBox").value() != "B")
        		alert("<%=BizboxAMessage.getMessage("TX000010740","부서명을 입력해 주세요")%>");
        	else
        		alert("<%=BizboxAMessage.getMessage("TX000007110","사업장명을 입력해 주세요")%>");
    		return;	
    	}
        
        var chkSeq = $("#chkSeq").val();
        if (chkSeq == null || chkSeq == 'false') {
        	alert("<%=BizboxAMessage.getMessage("TX000010757","코드가 중복되었습니다")%>");
    		return;	
    	}
        
        var selectedElms = $('#orgTreeView').jstree("get_selected", true);
		var length = selectedElms.length;
		var compSeq = $("#com_sel").val() || $("#compSeq").val() || '';
		
		if(length < 1 || ($("#compSeq").val() == "" && $("#deptType").data("kendoComboBox").value() != "B")){
			alert("<%=BizboxAMessage.getMessage("TX000010739","상위부서 정보가 없습니다. 다시 시도해 주세요.")%>");
			return;
		}
        
		var item = selectedElms[length-1];
		$('#teamYn').data('kendoComboBox').enable(true);
		
		var data = {};
		data.deptSeq2 = text1;
		data.deptName = text2;
		data.deptNameEn = $("#deptNameEn").val();
		data.deptNameJp = $("#deptNameJp").val();
		data.deptNameCn = $("#deptNameCn").val();
		
		data.gbnOrg = item.gbnOrg;
		
		data.pGroupSeq = $("#groupSeq").val();
		data.pCompSeq = $("#compSeq").val();
		data.pBizSeq = $("#bizSeq").val();
		data.pDeptSeq = $("#deptSeq").val();
		data.deptDisplayName = $("#deptAcr").val();
		data.orderNum = $("#orderNum").val();
		data.deptCd = $("#deptCd").val();
		data.teamYn = $('#teamYn').data('kendoComboBox').value();
		data.deptNickname = $("#deptNickname").val();
		data.bizSealFileId = $("#IMG_BIZ_SEAL_fileID").val();
		data.senderName = $("#senderName").val();
		data.deptType = $('#deptType').data('kendoComboBox').value();
		data.bizDisplay = $("#bizDisplay").data("kendoComboBox").value();
		data.faxNum = $("#faxNum").val();
		
		if($("#standardCode").length > 0){
			data.standardCode = $("#standardCode").val();
		}
		
		var useYn = "Y";
		if(document.getElementById("use_radio_u2").checked){
			useYn = "N";
		}
		data.useYn = useYn;
		
		if(data.pGroupSeq == '' || data.pCompSeq == ''){
			data.pCompSeq = OJT_fnGetCompensId(item.id);
			data.gbnOrg = "c";	
		}
		
		// 코드추가
		
		data.captainEmpSeq = $("#captainEmpSeq").val();
		data.captainDeptSeq = $("#captainDeptSeq").val();
		
		data.parentItem = JSON.stringify(item);
		varDeptSeq = text1;
		
		data.zipCode = $("#zipCode").val();
		data.addr = $("#addr").val();
		data.detailAddr = $("#detailAddr").val();
		if($("#deptDisplayYn").val() == "on")
			data.deptDisplayYn = "N";
		else
			data.deptDisplayYn = "Y";
		
		if($('#teamYn').data('kendoComboBox').value() != "T")
			data.deptDisplayYn = "Y";
		
		if($("#deptType").data("kendoComboBox").value() == "B"){		
			data.deptNickname = $("#bizNickname").val();
			data.compRegistNum = $("#compRegistNum").val();
			data.compNum = $("#compNum").val();
			data.ownerName = $("#ownerName").val();		
			data.bizNickname = $("#bizNickname").val();
		}
		
    	$.ajax({
    		type: "post",
    		url: "deptInsertProc.do",
    		datatype: "text",
    		data: data,
    		async:false,
    		success: function(data){
            	alert(data.result);
            	$("#bs_sel").val('');
  					$("#parentDeptSeq").val('');
				fnControllInit();
   				compChange();     			
    		},
    		error : function(e){
    			alert("error");	
    		}
    	});
    	
	}

	function saveDeptInfo() {
		var erpOrgFlag = false;	
	
		if($("#parentDeptSeq").val() == ''){
			alert("<%=BizboxAMessage.getMessage("TX000010739","상위부서 정보가 없습니다. 다시 시도해 주세요.")%>");
    		return;
		}
		
		
		var text1 = $("#deptSeq2").val();
        if ($("#deptCd").val() == null || $("#deptCd").val() == '') {
        	if($("#deptType").data("kendoComboBox").value() != "B")
        		alert("<%=BizboxAMessage.getMessage("TX000010741","부서코드 입력해 주세요")%>");
        	else
        		alert("<%=BizboxAMessage.getMessage("TX000007109","사업장코드 입력해 주세요")%>");
    		return;	
    	}
        
		var text2 = $("#deptName").val();
        if (text2 == null || text2 == '') {
        	if($("#deptType").data("kendoComboBox").value() != "B")
        		alert("<%=BizboxAMessage.getMessage("TX000010740","부서명을 입력해 주세요")%>");
        	else
        		alert("<%=BizboxAMessage.getMessage("TX000007110","사업장명을 입력해 주세요")%>");
    		return;	
    	}

// 		var text1 = $("#deptSeq2").val();
//         if (text1 == null || text1 == '') {
//     		return;	
//     	}
		if($("input[name='useYn']").attr("disabled")) {
			erpOrgFlag = true;	
		
			$("input[name='useYn']").removeAttr("disabled");
			$("#teamYn").removeAttr('disabled');
			$("input[name='teamYn_input']").removeAttr("disabled");	
		} else {
			erpOrgFlag = false;
		}
		
		
		
		var empDeptOrderList = "";
		$("#userInfo").find("input[type=text]").each(function(){			
			empDeptOrderList += "," + this.id + "|" + this.value;
		});
		if(empDeptOrderList.length > 0)
			$("#empDeptOrderList").val(empDeptOrderList.substring(1));

		$('#teamYn').data('kendoComboBox').enable(true);
		
		var formData = $("#basicForm").serialize();		
		formData += "&deptType=" +  $("#deptType").data("kendoComboBox").value();
		
		$.ajax({
				type:"post",
				url:"deptInfoSaveProc.do",
				datatype:"text",
				data: formData,
				async:false,
				success:function(data){
	            	alert(data.result);
	            	$("#bs_sel").val('');
						$("#parentDeptSeq").val('');
					fnControllInit();
					compChange();   
				},			
				error : function(e){
					alert("<%=BizboxAMessage.getMessage("TX000015075","현재 통신상태가 원할하지 않습니다. 잠시 후 다시 시도 해주세요.")%>");
				}			
		});	

	}
		
	function fnControllInit(){
		$("#info").html('');
		$("#newMode").val("false");
		$("#deptSeq2").val("");
		$("#deptName").val("");
		$("#deptNameEn").val("");
		$("#deptNameJp").val("");
		$("#deptNameCn").val("");
		$("#deptAcr").val("");
		$("#orderNum").val("");
		$("#zipCode").val("");
		$("#addr").val("");
		$("#detailAddr").val("");
		$("#compRegistNum").val("");
		$("#compNum").val("");
		$("#faxNum").val("");
		$("#ownerName").val("");
		
		$("#deptSeq2").attr("disabled", false);
		
		document.getElementById("use_radio_u1").checked = true;
		$("#deptUseYn").hide();
		
		$("#btnDeptPop").hide();
	}
    	
	function newDept() {
		
		if(document.getElementById("use_radio_u2").checked){
			if($("#deptType").data("kendoComboBox").value() != "B")
				alert("<%=BizboxAMessage.getMessage("TX900000277","미사용 부서하위에는 추가 할 수 없습니다.")%>");
			else
				alert("<%=BizboxAMessage.getMessage("TX900000278","미사용 사업장하위에는 추가 할 수 없습니다.")%>");
			return false;
		}	
		
		if(!isTypeChange){
			
			$("#deptType").data("kendoComboBox").value("D");
			$("#teamYn").data("kendoComboBox").value("N");
			document.getElementById("deptDisplayYn").checked = false;
			dllOnChange();
			$(".comp_type").hide();	
			$("#deptDetailType").show();
			
			$("#bizDisplayZone").hide();
			
			//getDeptInfo('','d');
			$("#newMode").val("true");
			
			//$("#deptSeq").val("0");
			//$("#bizSeq").val("0");
			//$("#parentDeptSeq").val("0");
			$('#deptType').data('kendoComboBox').enable(true);
			$('#bizDisplay').data('kendoComboBox').value("Y");
			
			$("#deptSeq2").val("");
			$("#deptName").val("");
			$("#deptNameEn").val("");
			$("#deptNameJp").val("");
			$("#deptNameCn").val("");
			$("#deptAcr").val("");
			$("#orderNum").val("");
			$("#zipCode").val("");
			$("#addr").val("");
			$("#detailAddr").val("");
			$("#compRegistNum").val("");
			$("#compNum").val("");
			$("#faxNum").val("");
			$("#ownerName").val("");
			$("#deptCd").val("");
			$("#userInfo").html("");
			$("#deptSeq2").attr("disabled", false);
			$("#deptNickname").val("");
			$("#bizNickname").val("");
			$("#senderName").val("");
			
			var innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000067","부서코드")%>"; 
			$("#deptSeqZone").html(innerHtml);
			innerHtml = "<img src=\"<c:url value='/Images/ico/ico_check01.png'/>\" alt=\"\" />" + "<%=BizboxAMessage.getMessage("TX000000068","부서명")%>";
			$("#deptNmZone").html(innerHtml);
			innerHtml = "<%=BizboxAMessage.getMessage("TX000000069","부서약칭")%>";
			$("#nickNameZone").html(innerHtml);
			
			document.getElementById("use_radio_u1").checked = true;			
		}
		$("#deptUseYn").hide();
		$("#tabstrip").kendoTabStrip().data("kendoTabStrip").select("0");
		/*
		var aaa = document.getElementById("teamYn");
		while(aaa.options.length > 0){
			selectObject.remove(0); 
		}
		*/
		/*
		//$('#teamYn').children("[value='T']").remove();
		var str = document.createElement("");
		var aaa = document.getElementById('teamYn');
		//var se = document.getElementById('sel_id');

		  // 옵션 지우기 
		  for(var i = str.length-1 ; i>=1 ; i--){
			  aaa.options[i] =null;
		  }
		*/
// 		test();
		/*
		for(var i = $("#teamYn").options.length-1 ; i>=0 ; i--){
			$("#teamYn").options[i] = null;
		}
		*/
		
		var selectedElms = $('#orgTreeView').jstree("get_selected", true);
		var length = selectedElms.length;
		var compSeq = $("#com_sel").val() || $("#compSeq").val() || '';
		
		if(length < 1 ){
			alert("<%=BizboxAMessage.getMessage("TX000010739","상위부서 정보가 없습니다. 다시 시도해 주세요.")%>");
			return;
		}
		
		if($("#parentDeptSeq").val() == '' && selectedElms[0].id.substring(0,1) != 'c'){
			alert("<%=BizboxAMessage.getMessage("TX000010739","상위부서 정보가 없습니다. 다시 시도해 주세요.")%>");
			return;	
		}
		
		if(selectedElms[0].id.substring(0,1) == 'b'){
			$("#bizSeq").val(selectedElms[0].id.substring(1));
			$("#deptSeq").val("0");
		}
// 		if($("#parentDeptSeq").val() == ''){
// 			alert("상위부서 정보가 없습니다. 다시 시도해 주세요.");
// 			return;
// 		}
        
		$("#btnDeptPop").hide();
		var item = selectedElms[length-1];			
		$("#bs_sel").val(item.text);	
		
		
// 		$("#bs_sel").kendoComboBox({
// 	        dataSource : {
// 				data : [item.text]
// 	        },
// 	        value:item.text
// 	    });		


		$('#teamYn').data('kendoComboBox').enable(true);
		
		
		var ddl =  $("#teamYn").data("kendoComboBox");
		if(ddl.dataSource.data().length == "3"){			
			ddl.dataSource.add({ text: "<%=BizboxAMessage.getMessage("TX900000279","결재전용부서")%>", value: "E" });
		}
		
		
		
	}
	
	String.prototype.trim = function() {     
		return this.replace(/(^\s*)|(\s*$)/gi, ""); 
	}
	
	function excelDept(){
		openWindow2("deptRegBatchPop.do", "deptRegBatchPop", 1000, 505, 0);
	}
	
	function deptPop(){
		$("#compFilter").val($("#com_sel").val());		

		var pop = window.open("", "cmmOrgPop", "width=799,height=769,scrollbars=no");
		$("#callback").val("callbackFunction");
		$("input[seq='deptFlag']").val($("#parentDeptSeq").val());
		frmPop.target = "cmmOrgPop";
		frmPop.method = "post";
		//frmPop.action = "<c:url value='/html/common/cmmOrgPop.jsp'/>";
		frmPop.action = "<c:url value='/systemx/orgChart.do'/>";
		frmPop.submit();
		pop.focus(); 
	}
	
	function callbackFunction(data){
		if(data.returnObj[0].deptName != ""){
			if($("#deptSeq").val() == data.returnObj[0].selectedId){
				alert("<%=BizboxAMessage.getMessage("TX000010738","현재 부서와 상위부서가 동일합니다. 다시 시도해 주세요.")%>");
				return false;
			}
			
			
			$("#bs_sel").val(data.returnObj[0].deptName);
			if(data.returnObj[0].empDeptGb == "c")
				$("#parentDeptSeq").val("0");
			else if(data.returnObj[0].empDeptGb == "b"){
				$("#parentDeptSeq").val("0");
				$("#bizSeq").val(data.returnObj[0].selectedId);				
			}
			else
				$("#parentDeptSeq").val(data.returnObj[0].selectedId);
			
			$("#isChangeParentSeq").val("Y");
		}
	}
	
</script>

<input type="hidden" id="hidSearchDept" value="" />
<input type="hidden" id="hidSelectComp" value="" />
<input type="hidden" id="newMode" value="false" />

<div class="top_box">
	<dl class="dl1">
		<dt><%=BizboxAMessage.getMessage("TX000000614","회사선택")%></dt>
		<dd>
			<input id="com_sel" style="width: 100%">
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000068","부서명")%></dt>
		<dd style="width: 190px;">
			<input id="txtSearch" class="" type="text" value="" placeholder=""
				style="width: 162px;" placeholder="<%=BizboxAMessage.getMessage("TX000001289","검색")%>" onkeydown="if(event.keyCode==13){javascript:searchDept();}"> <a href="#"
				class="btn_search" id="btnSearch" onclick="searchDept()"></a>
		</dd>
		<dt><%=BizboxAMessage.getMessage("TX000000028","사용여부")%></dt>
		<dd>
<!-- 			<input id="combo_use" style="width: 100px;" /> -->
			<select id="combo_use" name="combo_use" style="width:100px" onchange="javascripy:$('#orgTreeView').jstree('destroy').empty();deptManageTreeInit();">
				<option value="ALL"><%=BizboxAMessage.getMessage("TX000000862","전체")%></option>
				<option value="Y"><%=BizboxAMessage.getMessage("TX000000180","사용")%></option>
			</select>
		</dd>
	</dl>
</div>

<!-- 컨텐츠내용영역 -->
<div class="sub_contents_wrap">
	<div class="posi_re">
		<!-- 컨트롤버튼영역 -->
		<div id="" class="controll_btn">
			<button id="erpDept" class="k-button"><%=BizboxAMessage.getMessage("TX000007170","ERP 조직도 연동")%></button>
			<button id="excelDept" class="k-button"><%=BizboxAMessage.getMessage("TX000006323","일괄등록")%></button>
			<button id="newDept" class="k-button"><%=BizboxAMessage.getMessage("TX000003101","신규")%></button>
			<button id="saveDeptInfoBtn" class="k-button"><%=BizboxAMessage.getMessage("TX000001256","저장")%></button>
			<button id="removeDept" class="k-button"><%=BizboxAMessage.getMessage("TX000000424","삭제")%></button>
			<!--<input type="text" id="appendNodeText" style="width:76px;"/>
			<input type="button" id="saveDeptInfoBtn" class="deptBtn" value="저장">-->
		</div>

		<p class="tit_p posi_ab" style="top: 15px; left: 0px;"><%=BizboxAMessage.getMessage("TX000016245","부서정보")%></p>
		<p class="posi_ab" style="top:15px; left:100px;"><input type="checkbox" name="bizDisplayYn" id="bizDisplayYn" class="k-checkbox" onclick="compChange();"/>
		<label class="k-checkbox-label bdChk2" for="bizDisplayYn" ><%=BizboxAMessage.getMessage("TX900000280","사업장 숨김")%></label></p>
	</div>

	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width: 40%;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td p0">
					<div class="treeCon" style="max-height:630px;">
						<div id="orgTreeView" class="jstreeSet tree_auto" style="max-height:600px;"></div>
					</div>
				</td>
				<td class="twinbox_td p0">
					<div class="" id="deptInfo">
						<jsp:include page='/systemx/deptInfo.do'></jsp:include>
					</div>
				</td>
			</tr>
		</table>
	</div>	
</div>
<!-- //sub_contents_wrap -->

<form id="form" name="form" method="get" action="deptManageView.do">
	<input type="hidden" id="compSeq" name="compSeq"
		value="${params.compSeq}">
</form>

<form id="frmPop" name="frmPop">
	<input type="hidden" name="popUrlStr" id="txt_popup_url" value="/gw/systemx/orgChart.do"><br>
	<input type="hidden" name="selectMode" value="od" /><br>
	<input type="hidden" name="selectItem" value="s" /><br>
	<input type="hidden" id="callback" name="callback" value="" />
	<input type="hidden" name="deptSeq" value="" seq="deptFlag"/>
	<input type="hidden" id="compFilter" name="compFilter" value=""/>
	<input type="hidden" name="noUseDefaultNodeInfo" value="true"/>
	<input type="hidden" name="includeDeptCode" value="true"/>	
	<input type="hidden" name="callbackUrl" value="<c:url value='/html/common/callback/cmmOrgPopCallback.jsp' />"/> 
</form>
