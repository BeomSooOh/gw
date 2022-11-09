<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

<script>
	$(document).ready(function(){
	    //기본버튼
		$("button").kendoButton();    			
		
		//탭
		$("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			}
		});
		
		$("#btnDeptZip").click(fnZipPop);
		$("#teamYn").kendoComboBox();
		fnParentDeptList();
		
		if($("#parentDeptSeq").val() == '')
			$("#btnDeptPop").hide();
		else
			$("#btnDeptPop").show();
	});
	
	
	function fnParentDeptList() {
		$("#bs_sel").val('${deptMap.parentDeptName}');
		$("#parentDeptSeq").val('${deptMap.parentDeptSeq}');
		
		if("${deptMap.deptType}" == "D"){
			$('#teamYn').data('kendoComboBox').value("N")
		}
		else if("${deptMap.deptType}" == "T"){
			$('#teamYn').data('kendoComboBox').value("Y")	
		}
		else if("${deptMap.deptType}" == "V"){
			$('#teamYn').data('kendoComboBox').value("T")
		}
		
// 		var qType = "D";
// 		var pSeq = '${deptMap.parentDeptSeq}';
// 		if(pSeq == "0"){
// 			qType = "C";
// 		}
		
//     	var param = {};
//     	param.qType = qType;
//     	param.compSeq = '${deptMap.compSeq}';
//     	param.deptSeq = '${deptMap.parentDeptSeq}';
//     	param.useYn = 'Y';
    	
//     	$.ajax({
//     		type : "post",
//     		url : '<c:url value="/cmm/systemx/getParentDept.do" />',
//     		data : param,
//     		datatype : "json",
//     		success : function(data){
//     			if(data != null || data != "") {
//     				setParentDeptList(data.parentList);
//     			}
//     		}
//     	});
    }
	
	
	function setParentDeptList(parentList) {
	    $("#bs_sel").kendoComboBox({
	    	dataTextField: "deptName",
            dataValueField: "deptSeq",
	        dataSource: parentList,
	        value: '${deptMap.parentDeptSeq}',
	        change: deptChange,
	        filter: "contains",
	        suggest: true
	    });
	    
	    //var deptComData = $("#bs_sel").data("kendoComboBox");
	    //deptComData.select(0);
	}
	
	
	function deptChange() {
		//alert($("#bs_sel").val());
		$("#parentDeptSeq").val($("#bs_sel").val());
	}


	function fnZipPop() {
		new daum.Postcode({
            oncomplete: function(data) {
            	
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수 

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

             	// 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('deptZipCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('deptAddr').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('deptDetailAddr').focus();
                	
            }
        }).open();
    }
	
	
	function checkDeptSeq(id) {
		if (id == ""){
			$("#info").prop("class", "");
            $("#info").html("");
            $("#chkSeq").val("false");
		}
        if (id != null && id != '') {
        	if(id == "0"){
            	$("#info").prop("class", "fl text_red f11 mt5 ml10");
                $("#info").html("! 사용 불가능한 코드 입니다.");
                $("#chkSeq").val("false");
            }
        	else{
	            $.ajax({
	                type: "post",
	                url: "checkDeptSeq.do",
	                datatype: "text",
	                data: { deptSeq: id },
	                success: function (data) {
	                    if (data.result == "1") {
	                    	$("#info").prop("class", "fl text_blue f11 mt5 ml10");
	                        $("#info").html("* 사용 가능한 코드 입니다.");
	                        $("#chkSeq").val("true");
	                    }                    
	                    else {
	                    	$("#info").prop("class", "fl text_red f11 mt5 ml10");
	                        $("#info").html("! 코드가 중복되었습니다.");
	                        $("#chkSeq").val("false");
	                    }
	                    
	                    
	                },
	                error: function (e) {	//error : function(xhr, status, error) {
	                    alert("error");
	                }
	            });
            }
        }      
    }
	
        
 	function test() {
 		$("#teamYn").kendoComboBox({
             dataTextField: "text",
             dataValueField: "value",                
             dataSource: [
             	{ text: "Item1", value: "1" },
             	{ text: "Item2", value: "2" }
             ]
        });
		
 		alert($("#teamYn").val());
 	}

 	
	function openPopEmpSort() {
		var url = "<c:url value='/cmm/systemx/deptCompEmpSortPop.do'/>";             
        var popup = window.open(url+"?compSeq=${deptMap.compSeq}", "compEmpSortPop", 'toolbar=no, scrollbar=no, width=260, height=150, resizable=no, status=no');
        popup.focus();
        //<button id="sortBtn" onclick="openPopEmpSort()">사용자 정렬</button>
	}
</script>


<form id="basicForm" name="basicForm"  onsubmit="return false;">
	<input type="hidden" id="chkSeq" name="chkSeq" value="false" />
	<input type="hidden" id="deptSeq" name="deptSeq" value="${deptMap.deptSeq}" />
	<input type="hidden" id="groupSeq" name="groupSeq" value="${deptMap.groupSeq}" />
	<input type="hidden" id="bizSeq" name="bizSeq" value="${deptMap.bizSeq}" />
	<input type="hidden" id="compSeq" name="compSeq" value="${deptMap.compSeq}" />
	<input type="hidden" id="parentDeptSeq" name="parentDeptSeq" value="${deptMap.parentDeptSeq}" />
	
	
	<div class="tab_div brn" id="tabstrip">
		<ul>
			<li class="k-state-active">기본정보</li>
			<li>부서원정보</li>
		</ul>
		<!-- 기본정보 탭 -->
		<div class="tab_div_in">
			<div class="com_ta">
				<table>
					<colgroup>
						<col width="110"/>
						<col width="90"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 상위부서</th>
						<td colspan="2">
							<input type="text" id="bs_sel" style="width:92%" readonly="readonly"/>
							<button id="btnDeptPop" class="k-button" onclick="deptPop();">선택</button>
						</td>
					</tr>
					<tr>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 부서코드</th>
						<td colspan="2">
							<input class="fl" type="text" id="deptSeq2" name="deptSeq" value="${deptMap.deptSeq}" style="width:162px" onkeyup="checkDeptSeq(this.value);" disabled/>
							<p id="info" class="fl text_blue f11 mt5 ml10"></p>	
							<!-- <p class="fl text_red f11 mt5 ml10">! 코드가 중복되었습니다.</p>  사용 안할경우 p태그 주석처리-->
							<!-- <p class="fl text_blue f11 mt5 ml10">* 사용 가능한 코드 입니다.</p>  사용 안할경우 p태그 주석처리-->
						</td>
					</tr>
					<tr>
						<th rowspan="4"><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 부서명</th>
						<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> 한국어</th>
						<td><input type="text" id="deptName" name="deptName" value="${deptMap.deptName}" style="width:90%" /></td>
					</tr>
					<tr>
						<th>영&nbsp;&nbsp;어</th>
						<td><input class="" type="text" id="deptNameEn" name="deptNameEn" value="${deptMap.deptNameEn}" style="width:90%" disabled></td>
					</tr>
					<tr>
						<th>일본어</th>
						<td><input class="" type="text" id="deptNameJp" name="deptNameJp" value="${deptMap.deptNameJp}" style="width:90%" disabled></td>
					</tr>
					<tr>
						<th>중국어</th>
						<td><input class="" type="text" id="deptNameCn" name="deptNameCn" value="${deptMap.deptNameCn}" style="width:90%" disabled></td>
					</tr>
					
					<tr>
						<th>부서유형</th>
						<td colspan="2">
							<!--<input id="combo_sel_4" style="width:162px" />-->
							<select id="teamYn" name="teamYn"  class="mr10" style="width:162px" > 
								<option value="N" <c:if test="${deptMap.deptType == 'D'}">selected</c:if> >부서</option>
								<option value="Y" <c:if test="${deptMap.deptType == 'T'}">selected</c:if> >팀</option>
			                  	<option value="T" <c:if test="${deptMap.deptType == 'V'}">selected</c:if> >임시</option>
			                  	<option value="B" <c:if test="${deptMap.deptType == 'B'}">selected</c:if> >사업장</option>
							</select>
							<!-- 부서유형 임시부서 선택시 활성화 
							<input type="checkbox" id="org_chk" class="k-checkbox">
							<label class="k-checkbox-label radioSel ml10" for="org_chk">조직도 표시</label>
							-->
						</td>
					</tr>
					<tr id="deptAcronym">
						<th>부서약칭</th>
						<td colspan="2"><input class="" type="text" id="deptAcr" name="deptDisplayName" value="${deptMap.deptDisplayName}" style="width:92%"></td>
					</tr>
					<tr id="deptUseYn">
						<th>사용여부</th>
						<td colspan="2">
							<input type="radio" name="useYn" id="use_radio_u1" value="Y" class="k-radio" checked="checked"/>
							<label class="k-radio-label radioSel" for="use_radio_u1">사용</label>
							<input type="radio" name="useYn" id="use_radio_u2" value="N" class="k-radio" <c:if test="${deptMap.useYn == 'N'}">checked</c:if> />
							<label class="k-radio-label radioSel" for="use_radio_u2" style="margin:0 0 0 10px;">사용안함</label>
						</td>
					</tr>
					<tr>
						<th>정렬</th>
						<td colspan="2"><input class="" type="text" id="orderNum" name="orderNum" value="${deptMap.orderNum}" style="width:92%" onkeydown='return onlyNumber(event)' onkeyup='removeChar(event)'></td>
					</tr>
					
					<!-- 부서유형 사업장 선택시 comp_type 클래스를 show 처리해주세요. 기본 hide -->
					<tr class="comp_type">
						<th colspan="3">사업장 추가 정보</th>
					</tr>
					<tr class="comp_type">
						<th>사업장 주소</th>
						<td colspan="2">
							<input type="text" id="deptZipCode" name="zipCode"  value="${deptMap.zipCode}" style="width:88px;">
							<div class="controll_btn p0">
								<button id="btnDeptZip">우편번호</button>
							</div>
							<br />
							<input type="text" value="" style="width:92%" id="deptAddr" name="addr" class="mt5" value="${deptMap.addr}"/>
							<input type="text" value="" style="width:92%" id="deptDetailAddr" name="detailAddr" class="mt5" value="${deptMap.detailAddr}"/>
						</td>
					</tr>
					<tr class="comp_type">
						<th>사업자번호</th>
						<td colspan="2"><input class="" type="text" id="compRegistNum" name="compRegistNum" value="${deptMap.compRegistNum}" style="width:92%"></td>
					</tr>
					<tr class="comp_type">
						<th>법인번호</th>
						<td colspan="2"><input class="" type="text" id="compNum" name="compNum" value="${deptMap.compNum}" style="width:92%"></td>
					</tr>
					<tr class="comp_type">
						<th>대표자명</th>
						<td colspan="2"><input class="" type="text" id="ownerName" name="ownerName" value="${deptMap.ownerName}" style="width:92%"></td>
					</tr>
				</table>
			</div>
		</div>
		
		
		<!-- 부서원정보 탭 -->
		<div class="tab_div_in">
			<!-- 테이블 -->
			<div class="com_ta2">
				<table>
					<colgroup>
						<col width="140"/>
						<col width="140"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th>직급</th>
						<th>직책</th>
						<th>사원명(ID)</th>
					</tr>
				</table>
			</div>
			<div class="com_ta2 bg_lightgray ova_sc" style="height: 185px">
				<table>
					<colgroup>
						<col width="140" />
						<col width="140" />
						<col width="" />
					</colgroup>
					<tbody id="userInfo">
							
					</tbody>
				</table>
			</div>
		</div>
	</div>
	

 <script>
<<<<<<< .mine
	$(document).ready(function() {
    	
    	$("#zipCode").kendoMaskedTextBox({
			mask: "000-000"
		});
=======

    $(document).ready(function() {
	     /* $(".file_stemp").kendoUpload({
	         async: {
	             saveUrl: '<c:url value="/cmm/systemx/orgUploadImage.do" />',
	             removeUrl: '<c:url value="/cmm/systemx/compRemoveImage.do" />',
	             autoUpload: true
	         },
	         multiple: false,
	         upload:function(e) {
			 var inputName =  $(e.sender).attr("name");
			 var img_seq = $('#'+inputName).val();
			 var dept_seq = '${deptMap.deptSeq}';
	         e.sender.options.async.saveUrl = '<c:url value="/cmm/systemx/orgUploadImage.do" />'+"?imgSeq=" + img_seq+"&orgSeq="+dept_seq;
	         }

       }); */	  
       
      $("#zipCode").kendoMaskedTextBox({
          mask: "000-000"
      });
>>>>>>> .r10696
<<<<<<< .mine
                
		$("#teamYn").kendoComboBox({
			change: fnTypeSelect
	  	});
=======
// 	  $("#teamYn").kendoComboBox({
// 			  change: fnTypeSelect
// 	  });
>>>>>>> .r10696
	  
	  	$("#nativeLangCode").kendoComboBox();
	  
<<<<<<< .mine
	  	$(".file_stemp").kendoUpload({
        	async: {
        		saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
				autoUpload: true
			},
           	showFileList: false,
           	upload:function(e) { 
           		
				var dataType = 'json';
				var pathSeq = '900';
				var relativePath = '/stamp';
			
				var params = "dataType=" + dataType;
				params += "&pathSeq=" + pathSeq;
				params += "&relativePath=" + relativePath;
			
           		e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
           	
           		var inputName =  $(e.sender).attr("name");
           		$('#'+inputName+"_INP").val(e.files[0].name);
           	
			},
           	success: onSuccess
		});
	  	
	  	
=======
	 $(".file_stemp").kendoUpload({
	            async: {
	            	saveUrl: _g_contextPath_+'/cmm/file/fileUploadProc.do',
	                autoUpload: true
	            },
	            showFileList: false,
	            upload:function(e) { 
					var dataType = 'json';
					var pathSeq = '900';
					var relativePath = '/stamp';
					
					var params = "dataType=" + dataType;
					params += "&pathSeq=" + pathSeq;
					params += "&relativePath=" + relativePath;
					
	            	e.sender.options.async.saveUrl = _g_contextPath_+'/cmm/file/fileUploadProc.do?'+params;
	            	
	            	var inputName =  $(e.sender).attr("name");
	            	
	            	$('#'+inputName+"_INP").val(e.files[0].name);
	            	
	            },
	            success: onSuccess
        	}); 
	 
	 function fnTypeSelect() {
		 if($("#teamYn").val() == "1") {
			 $(".comp_type").show();
			 $("#deptAcronym").hide();
		 }
		 else {
			 $(".comp_type").hide();
			 $("#deptAcronym").show();
		 }
	 }
>>>>>>> .r10696
	 
		function fnTypeSelect() {
			alert($("#teamYn").val());
			if($("#teamYn").val() == "B") {
				$(".comp_type").show();
				$("#deptAcronym").hide();
			}
			else {
				$(".comp_type").hide();
				$("#deptAcronym").show();
			}
		}
		 
		function onSuccess(e) {
			
			if (e.operation == "upload") {
				var fileId = e.response.fileId;
				
				if (fileId != null && fileId != '') {
					var inputName =  $(e.sender).attr("name");
			
					$.ajax({
						type:"post",
						url:_g_contextPath_+"/cmm/systemx/orgUploadImage.do",
						datatype:"json",
						data: {imgType:inputName,orgSeq:'${deptMap.deptSeq}',fileId : fileId},
						success:function(data){
							var dUrl = "/gw/cmm/file/fileDownloadProc.do?fileId="+fileId+"&fileSn=0";
							$('#'+inputName+"_IMG").attr("src",dUrl);
						},			
						error : function(e) {
							alert("error");	
						}
					});		
				} 
				else {
					alert(e.response);
				}
			}
		}  
		
		
		//파일업로드 버튼 custom... kendo ui 그대로 사용하지 않아 몇가지 css를 변경해야됨..
        $(".k-dropzone").find("em").html("");			// 안내문구 제거
        $(".k-upload-button").css("float","left");
        $(".k-upload-button").find("span").html("찾기"); 	// 선택 버튼 한글명
        $(".k-upload-status-total").css({"line-height":""});
        $(".k-upload-status-total").css({"float":""});
        $(".k-dropzone").css({"padding":""});
        
        fnUserInfoList();
		
		
        //setTimeout(function(){
        	var aaa = '${deptMap.deptType}';
        	
			if(aaa == "B") {
				$(".comp_type").show();
				$("#deptAcronym").hide();
			}
			else {
				$(".comp_type").hide();
				$("#deptAcronym").show();
			}
        //}, 500);
	});
    
    
    function fnUserInfoList() {
    	
    	var param = {};
    	var dept = $("#deptSeq").val();
    	
    	if(dept == "" || dept == null){
    		return;
    	}
    	
    	param.deptSeq = dept;
    	param.useYn = 'Y';
    	
    	$.ajax({
    		type : "post",
    		url : '<c:url value="/cmm/systemx/getUserInfo.do" />',
    		data : param,
    		datatype : "json",
    		success : function(data){
    			if(data != null || data != "") {
    				var resultList = data.result.list;
    				if(resultList.length > 0) {
    					fnUserInfoDraw(data.result.list);
    				}
    			}
    		}
    	
    	});
    }
    
    
    function fnUserInfoDraw(userInfo) {
    	
    	var tag = '';
    	
    	for(var i=0; i<userInfo.length; i++) {	
    		tag += '<tr>';
    		tag += '<td>' + userInfo[i].dutyCodeName + '</td>';
    		tag += '<td>' + userInfo[i].positionCodeName + '</td>';
    		tag += '<td>' + userInfo[i].empName2 + '</td>';
    		tag += '</tr>';
    	}
    	
    	$("#userInfo").html(tag);
    }        
</script>
