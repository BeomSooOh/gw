<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">

$(document).ready(function() {
	
	//날짜
    $(".datePicker").kendoDatePicker({
        format: "yyyy-MM-dd"
    });
	
    //$('.datePicker').each(function(){ $(this).datepicker(); });
    
    //fnInitDatePicker(); 날짜설정

	/* 즐겨찾기 목록 전체체크 박스 */
	$("#bookMarkListChkAll").click(function(e){
		 var ischeck = $(this).is(':checked');  
		 var arr = $("#bookMarkListTable").find(".bookMarkListChk");
		 if (arr.length > 0) {
			for(var i = 0; i < arr.length; i++) {
				$(arr[i]).prop("checked", ischeck); 		// 프로퍼티를 변경해야 이벤트가 정상적으로 동작
			}
		 }
	});
    
    //차량 셀 클릭시
	$('.carNumPop').click(function(e){
		//몇번째 줄인지 클릭한 row시퀀스 가져오기
		var cInfo = $(this);
		var tdId = cInfo[0].id;
		var rowSeq = tdId.replace(/inp_carNum_/gi, ""); 
		$('#callBackRow').val(rowSeq);
		
		//팝업 호출
		fnCarNumPop();
	});
    
	fnResizeForm();
	
});//document ready end

$(function() {
    //달력
    var datePickerOptions = {
        altFormat: "yy-mm-dd",
        dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
        dateFormat: "yy-mm-dd",
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        showOtherMonths: true,
        selectOtherMonths: true,
        showMonthAfterYear: true,
        nextText: "Next",
        prevTex: "Prev"

    };

    //$("#testDatepicker").kendoDatePicker(datePickerOptions);

    //테이블 로우 선택 
    var TR = $('.rightContents.cus_ta table tr');
    var TD = $('.rightContents.cus_ta table tr td');
    var iFocus = $('.rightContents.cus_ta table tr td input');
    var ROW = $('.searchTable .rightContents.cus_ta table tr');

    TR.click(function() {
        TR.removeClass('lineOn onSel'), $(this).addClass('lineOn onSel');
    }), TR.focusout(function() {
        TR.removeClass('lineOn onSel')
    });

    ROW.click(function() {
        TR.removeClass('lineOn onSel onRow'), $(this).addClass('onRow');
    }), TR.focusout(function() {
        TR.removeClass('onRow')
    });

    TD.focusin(function() {
        if ($(this).parents('.total').length > 0) {
            return;
        }
        TD.removeClass('focus'), $(this).addClass('focus');
    }), TD.focusout(function() {
        TD.removeClass('focus')
    });

    iFocus.click(function() {
        if ($(this).parents('.total').length > 0) {
            return;
        }
        iFocus.removeClass('focus'), $(this).addClass('focus');
    }), iFocus.focusout(function() {
        iFocus.removeClass('focus')
    });


});

// 조회기간 셋팅
function fnInitDatePicker() {

    // Object Date add prototype
    Date.prototype.ProcDate = function() {
        var yyyy = this.getFullYear().toString();
        var mm = (this.getMonth() + 1).toString(); //
        var dd = this.getDate().toString();
        return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' +
            (dd[1] ? dd : "0" + dd[0]);
    };

    var toD = new Date();
    //$('#datePicker').val(toD.ProcDate());
}

//팝업 사이즈 조절
function fnResizeForm() {
	$(".location_info").css("display", "none");
	$(".iframe_wrap").css("padding", "0");

	var strWidth = $('.pop_wrap').outerWidth()
			+ (window.outerWidth - window.innerWidth);
	var strHeight = $('.pop_wrap').outerHeight()
			+ (window.outerHeight - window.innerHeight);

	$('.pop_wrap').css("overflow", "auto");
	//$('.jstreeSet').css("overflow","auto");

	var isFirefox = typeof InstallTrigger !== 'undefined';
	var isIE = /*@cc_on!@*/false || !!document.documentMode;
	var isEdge = !isIE && !!window.StyleMedia;
	var isChrome = !!window.chrome && !!window.chrome.webstore;

	if (isFirefox) {

	}
	if (isIE) {
		$(".pop_foot").css("width", strWidth);
	}
	if (isEdge) {

	}
	if (isChrome) {
	}

	try {
		window.resizeTo(strWidth, strHeight);
	} catch (exception) {
		console.log('window resizing cat not run dev mode.');
	}
}

function fnDel(){
	var checkbox = $("#bookMarkListTable").find("input[name=bm_chknm]:checked");
	if (checkbox.length > 0){
		
		if (confirm("삭제 하시겠습니까?")) {
			
			//var tdArr = new Array();
		    var bmCodeArr = new Array();
		    
		    // 체크된 체크박스 값을 가져온다
		    checkbox.each(function(i) {
		    
		        var tr = checkbox.parent().parent().eq(i);
		        var td = tr.children();
		        
		        // td.eq(0)은 체크박스 이므로  td.eq(1)의 값부터 가져온다.
		        //var no = td.eq(1).text()+", ";
		        //var userid = td.eq(2).text()+", ";
		        //var name = td.eq(3).text()+", ";
		        //var email = td.eq(4).text()+", ";
		        var bmCode = td.find("input[name=bm_code]:hidden").val();
		        
		     	// 가져온 값을 배열에 담는다.
		        bmCodeArr.push(bmCode);
		        //tdArr.push(no);
		        //tdArr.push(userid);
		        //tdArr.push(name);
		        //tdArr.push(email);
		                
		    });
		    
		    var tblParam = {};
			tblParam.bmCodeArr = JSON.stringify(bmCodeArr);
			tblParam.compSeq = "${compSeq}";
			tblParam.empSeq = "${empSeq}";
			$.ajax({
		    	type:"post",
				url:'<c:url value="/cmm/ex/bizcar/pop/deleteBookMark.do"/>',
				datatype:"json",
				data: tblParam ,
				contenttype: "application/json;",
			    success:function(data){
					var result = data.result;
					if(result > 0){
						alert("삭제되었습니다.");
						//location.reload();
						
						//체크된 row(tr) 삭제
						$("input[name='bm_chknm']:checked").each(function() {
							$(this).parent().parent().remove();
						});
						
						window.opener.getDataList();
					}else {
						alert("삭제시 오류가 발생하였습니다.");
					}
				}
				, error:function(data){
					alert("삭제시 오류가 발생하였습니다.");
				}
			});
			
		}
		
	}else{
		alert("체크된 항목이 없습니다.");
	}
	
	
}

function fnAddOk(){
	var checkbox = $("#bookMarkListTable").find("input[name=bm_chknm]:checked");
	if(!checkbox.length > 0){
		alert("운행기록부에 추가할 운행기록을 선택해주세요.");
		return;
	}
	if(!confirm("저장하시겠습니까?")){
		return;
	}
	
	var rowData = new Array();
	var chkVal = "ok";
    
    // 체크된 체크박스 값을 가져온다
    checkbox.each(function(i) {
    
        // checkbox.parent() : checkbox의 부모는 <td>이다.
        // checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
        var tr = checkbox.parent().parent().eq(i);
        var td = tr.children();
        var tbData = {};
        
        //차량정보 가져오기
        var findId = td.eq(1).find("input[name=inp_carCode]");
        var carInfo = findId[0].id;
        tbData.carCode = $('#'+carInfo).val(); //차량코드
        if(tbData.carCode == ""){
        	chkVal = "fail1";
        	return;
        }
        
        findId = td.eq(1).find("input[name=inp_carNum]");
        carInfo = findId[0].id;
        tbData.carNum = $('#'+carInfo).val(); //차량번호
        
        findId = td.eq(1).find("input[name=inp_carName]");
        carInfo = findId[0].id;
        tbData.carName = $('#'+carInfo).val(); //차량종류
        
        //상세주소 가져오기
        findId = td.eq(1).find("input[name=inp_startAddrDetail]");
        carInfo = findId[0].id;
        tbData.startAddrDetail = $('#'+carInfo).val(); //출발지상세주소
        findId = td.eq(1).find("input[name=inp_endAddrDetail]");
        carInfo = findId[0].id;
        tbData.endAddrDetail = $('#'+carInfo).val(); //도착지지상세주소
        
        //운행일자 가져오기
        var findId2 = td.eq(2).find("input[name=inp_useDate]");
        var dateId = findId2[0].id;
        var useInfo = $('#'+dateId).val();
        tbData.driveDate = useInfo.replace(/-/gi, "");
        if(tbData.driveDate == ""){
        	chkVal = "fail1";
        	return;
        }else if(!chkDateStr(useInfo)){
        	chkVal = "fail2";
        	return;
        }
        // td.eq(0)은 체크박스 이므로  td.eq(3)의 값부터 가져와 객체에 담는다.
        tbData.td3 = td.eq(3).text();
        tbData.td4 = td.eq(4).text();
        tbData.td5 = td.eq(5).text();
        tbData.td6 = td.eq(6).text();
        tbData.td7 = td.eq(7).text();
        tbData.td8 = td.eq(8).text();
        tbData.td9 = td.eq(9).text();
        tbData.td10 = td.eq(10).text();
        
     	// 체크된 row의 모든 값을 배열에 담는다.
        rowData.push(tbData);
               
    });
    
    if(chkVal == "ok"){
    	saveBookMarkList(rowData);
    	//window.opener.addBookMark(rowData); 그리드에 추가
	    //window.close();
    }else if(chkVal == "fail1"){
    	alert("체크된 데이터 중 차량 또는 운행일자 정보가 없습니다.");
    }
	
}

function saveBookMarkList(rowData){
	var tblParam = {};
	tblParam.rowDataList = JSON.stringify(rowData);
	$.ajax({
    	type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/saveBookMarkList.do"/>',
		datatype:"json",
		data: tblParam ,
		contenttype: "application/json;",
	    success:function(data){
			var result = data.result;
			if(result > 0){
				alert("저장하였습니다.");
				
				window.opener.getDataList();
				self.close();
			}else {
				alert("저장시 오류가 발생하였습니다.");
			}
		}
		, error:function(data){
			alert("저장시 오류가 발생하였습니다.");
		}
	});
	
}

function fnCarNumPop() {
    var carNum = "";

    var urlpop = "<c:url value='/cmm/ex/bizcar/pop/bizCarNumSearchPop.do'/>?carNum=" + encodeURI(carNum);
    openWindow2(urlpop, "fnCarNumPop", 400, 560, 0);
}

function setBizCarNum(no) {
	// 팝업 콜백. 구분자로 받아서 split 차량코드_차량번호 
	var noSplit = no.split('_'); // noSplit[0]차량코드, noSplit[1]차량번호, noSplit[2]차량종류
	
	var rowSeq = $('#callBackRow').val();
	$('#inp_carCode_'+rowSeq).val(noSplit[0]);//차량코드
	$('#inp_carNum_'+rowSeq).val(noSplit[1]);//차량번호
	$('#inp_carName_'+rowSeq).val(noSplit[2]);//차량종류
}

//조회기간 날짜 입력 자동 하이픈 추가
function auto_date_format(e, oThis){
    var num_arr = [ 
        97, 98, 99, 100, 101, 102, 103, 104, 105, 96,
        48, 49, 50, 51, 52, 53, 54, 55, 56, 57
    ]
    
    var key_code = ( e.which ) ? e.which : e.keyCode;
    if( num_arr.indexOf( Number( key_code ) ) != -1 ){
        var len = oThis.value.length;
        if( len == 4 ) oThis.value += "-";
        if( len == 7 ) oThis.value += "-";
    }
}

function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

//운행일자 데이터 형식체크
function chkDateStr(date){
	var date2 = date.replace(/[^0-9]/g,"");
	var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	var ptnChk = pattern.test(date2);
	
	if(!ptnChk){ //날짜형식 패턴 체크
		if(date2.length != 8){
			alert("날짜형식(YYYY-MM-DD)에 맞지 않습니다. 입력값: "+date);
			return false;
		}else {
			var dateArr = date.split('-');
			if(dateArr[1] != 00 || dateArr[1] > 12){
				alert("날짜형식(YYYY-MM-DD)에 맞지 않습니다. 입력값: "+date);
				return false;
			}else if(dateArr[2] != 00 || dateArr[2] > 31){
				alert("날짜형식(YYYY-MM-DD)에 맞지 않습니다. 입력값: "+date);
				return false;
			}
			
		}
	}
	return true;
}
		
function fnclose(){
	
	self.close();
}
</script>





<div class="pop_wrap" style="width:1098px;">
		<div class="pop_head">
			<h1>즐겨찾기</h1>
			<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
		</div>
		
		<div class="pop_con">
            <div class="btn_div mt0">
                <div class="right_div">
                    <div class="controll_btn p0">
                        <button id="btn_Del" onclick="fnDel();">삭제</button>
                    </div>
                </div>
            </div>

			<div class="com_ta2 mt15">
				<table>
					<colgroup>
						<col width="34"/>
						<col width="80"/>
						<col width="100"/>
						<col width="80"/>
						<col width="80"/>
						<col width="80"/>
						<col width="80"/>
						<col width="150"/>
						<col width="80"/>
						<col width="150"/>
						<col width=""/>
					</colgroup>
					<tr>
						<th>
                            <input type="checkbox" name="inp_chk" id="bookMarkListChkAll" class="">
							<label class="" for="bookMarkListChkAll"><span></span></label>
                        </th>
                        <th><img alt="" src="../../../../Images/ico/ico_check01.png"></img> 차량</th>
						<th><img alt="" src="../../../../Images/ico/ico_check01.png"></img> 운행일자</th>
						<th>운행구분</th>
						<th>출발시간</th>
						<th>도착시간</th>
						<th>출발구분</th>
						<th>출발지</th>
						<th>도착구분</th>
						<th>도착지</th>
						<th>비고</th>
					</tr>
					</table>	
			</div>

			<div class="com_ta2 ova_sc bg_lightgray" style="height:259px;">
				<table id="bookMarkListTable">
					<colgroup>
						<col width="34"/>
						<col width="80"/>
						<col width="100"/>
						<col width="80"/>
						<col width="80"/>
						<col width="80"/>
						<col width="80"/>
						<col width="150"/>
						<col width="80"/>
						<col width="150"/>
						<col width=""/>
					</colgroup>					
					<c:forEach items="${bookMarkList}" var="list" varStatus="status">
					<tr>
						<td>
							<input type="checkbox" name="bm_chknm" id="inpchk_${status.count}" class="bookMarkListChk" value="">
							<label class="" for="inpchk_${status.count}"><span></span></label>
							<input type="hidden" name="bm_code" value="${list.BOOKMARK_CODE}"/>
                        </td>
                        <td>
                        	<input type="text" id="inp_carNum_${status.count}" class="carNumPop" name="inp_carNum" style="width:100%; border:0;" readonly/>
                        	<input type="hidden" id="inp_carCode_${status.count}" name="inp_carCode" value="" />
                        	<input type="hidden" id="inp_carName_${status.count}" name="inp_carName" value="" />
                        	<input type="hidden" id="inp_startAddrDetail_${status.count}" name="inp_startAddrDetail" value="${list.START_ADDR_DETAIL}" />
                        	<input type="hidden" id="inp_endAddrDetail_${status.count}" name="inp_endAddrDetail" value="${list.END_ADDR_DETAIL}" />
                        </td>
						<td><input id="inp_useDate_${status.count}" class="datePicker" name="inp_useDate" style="width:100%; border:0;" onkeyup="auto_date_format(event, this)" onkeydown="return onlyNumber(event)" maxlength="10" /></td>
                        <c:choose>
							<c:when test="${list.USE_FLAG=='1'}">
							<td>출근</td>
							</c:when>
							<c:when test="${list.USE_FLAG=='2'}">
							<td>퇴근</td>
							</c:when>
							<c:when test="${list.USE_FLAG=='3'}">
							<td>출퇴근</td>
							</c:when>
							<c:when test="${list.USE_FLAG=='4'}">
							<td>업무용</td>
							</c:when>
							<c:when test="${list.USE_FLAG=='5'}">
							<td>비업무용</td>
							</c:when>
						</c:choose>
						<td>${list.START_TIME}</td>
						<td>${list.END_TIME}</td>
						<c:choose>
							<c:when test="${list.START_FLAG=='1'}">
							<td>회사</td>
							</c:when>
							<c:when test="${list.START_FLAG=='2'}">
							<td>자택</td>
							</c:when>
							<c:when test="${list.START_FLAG=='3'}">
							<td>거래처</td>
							</c:when>
							<c:when test="${list.START_FLAG=='4'}">
							<td>직전출발지</td>
							</c:when>
							<c:otherwise>
						    <td>직접입력</td>
							</c:otherwise>
						</c:choose>
						<td>${list.START_ADDR}</td>
						<c:choose>
							<c:when test="${list.END_FLAG=='1'}">
							<td>회사</td>
							</c:when>
							<c:when test="${list.END_FLAG=='2'}">
							<td>자택</td>
							</c:when>
							<c:when test="${list.END_FLAG=='3'}">
							<td>거래처</td>
							</c:when>
							<c:when test="${list.END_FLAG=='4'}">
							<td>직전도착지</td>
							</c:when>
							<c:otherwise>
						    <td>직접입력</td>
							</c:otherwise>
						</c:choose>
						<td>${list.END_ADDR}</td>
						<td>${list.RMK_DC}</td>
					</tr>
					</c:forEach>
					<c:if test="${empty bookMarkList}">
					<tr>
						<td colspan='11'>운행정보를 기록한 후 마지막 행 별표(☆) 버튼을 클릭하면 즐겨찾기에 추가됩니다.</td>
					</tr>
					</c:if>
				</table>
			</div>
		</div><!-- //pop_con -->
		<input type="hidden" id="callBackRow" name="callBackRow" value="" />
		
		<div class="pop_foot">
			<div class="btn_cen pt12">
				<input type="button" value="확인" onclick="fnAddOk();"/>
				<input type="button"  class="gray_btn" value="취소" onclick="fnclose();"/>
			</div>
		</div><!-- //pop_foot -->
	</div><!-- //pop_wrap -->