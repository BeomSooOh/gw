<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">

var loginV = "${loginVO}";
var batchKey = "";

$(document).ready(function() {

    //파일첨부
    $(".find_btn").click(function() {
        $("#filed").click();
        setInterval(function() {
            $('.inp_url').attr("value", $('#filed').val())
        }, 300);
    });

    //테이블 로우 선택 
    var TR = $('.rightContents.cus_ta_ea table tr');
    var TD = $('.rightContents.cus_ta_ea table tr td');
    var iFocus = $('.rightContents.cus_ta_ea table tr td input');

    TR.click(function() {
        TR.removeClass('lineOn onSel'), $(this).addClass('lineOn onSel');
    }), TR.focusout(function() {
        TR.removeClass('lineOn onSel')
    });

    iFocus.click(function() {
        if ($(this).parents('.total').length > 0) {
            return;
        }
        iFocus.removeClass('focus'), $(this).addClass('focus');
    }), iFocus.focusout(function() {
        iFocus.removeClass('focus')
    });

    fnResizeForm();

}); //document ready end

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

//휠스크롤
function fixDataOnWheel() {
    if (event.wheelDelta < 0) {
        DataScroll.doScroll('scrollbarDown');
    } else {
        DataScroll.doScroll('scrollbarUp');
    }
    table1Scroll();
}
//각 테이블 스크롤 동기화
function table1Scroll() {
    $(".table1 .leftContents").scrollTop($(".table1 .rightContents").scrollTop());
    $(".table1 .rightHeader").scrollLeft($(".table1 .rightContents").scrollLeft());
}


function bizCarExcelValidate() {

    if ($("#filed").val() == "") {
        alert("<%=BizboxAMessage.getMessage("TX000010754 ","업로드할 엑셀파일을 선택해 주세요 ")%>");
        return;
    }
    
    var formData = new FormData();
    formData.append("excelUploadFile", filed.files[0]);
    formData.append("compSeq", "${loginVO.compSeq}");

    $("#uploadSpin").show();
        
    $.ajax({
        type: "post",
        url: '<c:url value="/cmm/ex/bizcar/pop/bizCarExcelValidate.do"/>',
        processData: false,
        contentType: false,
        data: formData,
        xhr: function () {
            myXhr = $.ajaxSettings.xhr();
            if (myXhr.upload) {
                myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                myXhr.abort;
            }
            return myXhr;
        },
        success:function(data){	    	  
    	  $("#uploadSpin").hide();
    	  //alert("엑셀 체크성공");
    	  setDataCheckTable(data.checkList);
      	},
      	error : function(e){
      		$("#uploadSpin").hide();
      		alert("엑셀 체크실패");
      	}
   	});
}

function setDataCheckTable(checkList){
	var tbody = "";	
	for(var i=0;i<checkList.length;i++){
		batchKey = checkList[i].batch_seq;
    	
    	//var check_result = fnGetResult(checkList[i].checkDpSeq, checkList[i].checkDpNameIsNone, checkList[i].checkDpSeqIsNone);
    	//var cs = check_result != "" ? "class='text_red'" : "";
    	var cs ="";
    	var ccErr = "class='text_red' title='차량코드가 없습니다.'";
    	var tErr = "class='text_red' title='시간형식이 맞지 않습니다.'";
    	var chkCN = checkList[i].car_num;
    	var chkCC = checkList[i].car_code;
    	var html = "<tr>";
    	    	
    	html += "<td> <input type='checkbox' name='inp_chk' id='inp_chk"+i+"' class='' onclick='fnCheck(this);' seq='"+checkList[i].seq+"'/> <label class='' for='inp_chk"+i+"' ></label> </td>";
    	html += "<td " + ((chkCC == "") ? ccErr : cs) + ">" + checkList[i].car_num + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(checkList[i].drive_date) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(useStr(checkList[i].use_flag)) + "</td>";
    	html += "<td " + ((timeChk(checkList[i].start_time) == false) ? tErr : cs) + ">" + timeComma(checkList[i].start_time) + "</td>";
    	html += "<td " + ((timeChk(checkList[i].end_time) == false) ? tErr : cs) + ">" + timeComma(checkList[i].end_time) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(seStr(checkList[i].start_flag)) + "</td>";
    	html += "<td class='le pl5'" + cs + ">" + nullToEmpty(checkList[i].start_addr) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(seStr(checkList[i].end_flag)) + "</td>";
    	html += "<td class='le pl5'" + cs + ">" + nullToEmpty(checkList[i].end_addr) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(checkList[i].before_km) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(checkList[i].after_km) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(checkList[i].mileage_km) + "</td>";
    	html += "<td " + cs + ">" + nullToEmpty(checkList[i].rmk_dc) + "</td>";
    	html += "<td " + cs + ">" + amtStr(checkList[i].oil_amt_type) + "</td>";
    	html += "<td class='ri pr5'" + cs + ">" + checkList[i].oil_amt + "</td>";
    	html += "<td " + cs + ">" + amtStr(checkList[i].toll_amt_type) + "</td>";
    	html += "<td class='ri pr5'" + cs + ">" + checkList[i].toll_amt + "</td>";
    	html += "<td " + cs + ">" + amtStr(checkList[i].parking_amt_type) + "</td>";
    	html += "<td class='ri pr5'" + cs + ">" + checkList[i].parking_amt + "</td>";
    	html += "<td " + cs + ">" + amtStr(checkList[i].repair_amt_type) + "</td>";
    	html += "<td class='ri pr5'" + cs + ">" + checkList[i].repair_amt + "</td>";
    	html += "<td " + cs + ">" + amtStr(checkList[i].etc_amt_type) + "</td>";
    	html += "<td class='ri pr5'" + cs + ">" + checkList[i].etc_amt + "</td>";
    	html += "</tr>";
    	
    	//html += "<td " + cs + ">" + (check_result == "" ? "정상" : "오류") + "</td>";
    	tbody += html;
    }
	
	$("#dataCheckTable tbody").html(tbody == "" ? "<tr><td colspan='12'>데이타가 없습니다.</td></tr>" : tbody);
	
	/* if($("input[type=checkbox][name=list]").length > 0){
		$("input[type=checkbox][name=all],[name=list]").prop("checked",true);	
	} */

}

function nullToEmpty(str){
	if(str==null || str=="null"){
		str = "";
	}
   return str;
}

function useStr(type){
	var str = "";
	if(type != ""){
		switch (type) {
		  case 1: str = "출근"; break;
		  case 2: str = "퇴근"; break;
		  case 3: str = "출퇴근"; break;
		  case 4: str = "업무용"; break;
		  case 5: str = "비업무용"; break;
		  default: str = ""; break;
		}
	}
	return str;
}
	
function seStr(type){
	var str = "";
	if(type != ""){
		switch (type) {
		  case 0: str = "직접입력"; break;
		  case 1: str = "회사"; break;
		  case 2: str = "자택"; break;
		  case 3: str = "거래처"; break;
		  default: str = ""; break;
		}
	}
	return str;
}

function amtStr(type){
	var str = "";
	if(type != ""){
		switch (type) {
		  case 1: str = "현금"; break;
		  case 2: str = "현금영수증"; break;
		  case 3: str = "카드(법인)"; break;
		  case 4: str = "카드(개인)"; break;
		  default: str = "없음"; break;
		}
	}
	return str;
}

function timeChk(time){
	var rtnVal = true;
   	if(time != ""){
   		if(isNaN(time) == false){ //숫자 문자 체크
   			var timeInt = time.replace(/[^0-9]/g,"");
   	       	if(timeInt.length == 4){
   	       		var hh = timeInt.substr(0,2);
   	       		var mm = timeInt.substr(2,2);
   	       		if(hh > 23 || mm > 59){
   	       			rtnVal = false;
   	       		}
   	       	}else{
	       		rtnVal = false;
   	       	}
   		}else{
   			rtnVal = false;
   		}
   		
   	}
   	return rtnVal;
}

function timeComma(time){
	var rtnTime = time;
	if(rtnTime != ""){
		var timeInt = rtnTime.replace(/[^0-9]/g,"");
		if(timeInt.length == 4){
			var hh = timeInt.substr(0,2);
			var mm = timeInt.substr(2,2);
			if(hh > 23 || mm > 59){
				
			}else{
				rtnTime = hh+":"+mm;
			}
		}
	}
	return rtnTime;
}

function progressHandlingFunction(e) {
	$("#uploadSts").html(parseInt((e.loaded / e.total) * 100));
}


function fnFormDownload() {
	this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=gwFormFile&fileSn=6";
}

function fnCheck(obj){
	
	var checked = $(obj)[0].checked;
	
	if($(obj).attr("name") == "inp_chkAll"){
		$("input[type=checkbox][name=inp_chk]").prop("checked",checked);
	}else{
		if($("input[type=checkbox][name=inp_chk]:not(:checked)").length == 0){
			$("input[type=checkbox][name=inp_chkAll]").prop("checked",true);
		}else{
			$("input[type=checkbox][name=inp_chkAll]").prop("checked",false);
		}
	}
}


function fnSave(){
	
	if($("input[type=checkbox][name=inp_chk]:checked").length == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}
	
	if(!confirm("<%=BizboxAMessage.getMessage("TX000004920","저장하시겠습니까?")%>")){
		return;
	}	

	var saveList = new Array();
	
    $.each($("input[type=checkbox][name=inp_chk]:checked"), function (i, t) {
    	var saveinfo = $(t).attr("seq");
    	saveList.push(saveinfo);
    });
    
	var tblParam = {};
	tblParam.batchKey = batchKey;
	tblParam.saveList = JSON.stringify(saveList);
	$.ajax({
      	type:"post",
  		url:'<c:url value="/cmm/ex/bizcar/pop/saveBizCarBatchData.do"/>',
  		datatype:"json",
		data: tblParam,
		success:function(data){
			//체크된 row(tr) 삭제
			alert("저장하였습니다.");
			$("input[type=checkbox][name=inp_chk]:checked").each(function() {
				$(this).parent().parent().remove();
			});
			window.opener.getDataList();
		},			
		error : function(e){
			alert("잘못된 형식의 데이터가 존재합니다");
		}
  	});    		
}

function fnDelete() {
	
	if($("input[type=checkbox][name=inp_chk]:checked").length == 0){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}
	
	if(!confirm("<%=BizboxAMessage.getMessage("TX000002068","삭제하시겠습니까?")%>")){
		return;
	}
	
	var delList = new Array();
	
    $.each($("input[type=checkbox][name=inp_chk]:checked"), function (i, t) {
    	var delinfo = $(t).attr("seq");
    	delList.push(delinfo);
    });
    
	var tblParam = {};
	tblParam.batchKey = batchKey;
	tblParam.delList = JSON.stringify(delList);
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/deleteBizCarBatchData.do"/>',
		datatype:"json",
		data: tblParam,
		success:function(data){
			//체크된 row(tr) 삭제
			$("input[type=checkbox][name=inp_chk]:checked").each(function() {
				$(this).parent().parent().remove();
			});
		},			
		error : function(e){
			alert("임시데이터 삭제 에러");	
		}
	});	
	
}

function fnclose() {
    //alert("바이");
	//창 닫을때 임시테이블 batchKey값이 있으면 데이터 제거후 close
	if(batchKey){
		var tblParam = {};
		tblParam.batchKey = batchKey;
		$.ajax({
			type:"post",
			url:'<c:url value="/cmm/ex/bizcar/pop/deleteBizCarBatchData.do"/>',
			datatype:"json",
			data: tblParam,
			success:function(data){
				window.close();
			},			
			error : function(e){
				alert("임시데이터 삭제 에러");	
			}
		});	
	}
	else{
		window.close();
	}
		
}

//팝업창 닫기버튼 눌렀을때 이벤트 캐치
//window.onbeforeunload = fnclose;
//window.onunload = fnclose;

</script>





<div class="pop_wrap" style="width:998px;">
	<div class="pop_head">
		<h1>운행기록부 업로드</h1>
		<a href="#n" class="clo" ><img src="<c:url value='/Images/btn/btn_pop_clo01.png'/>" alt="" /></a>
	</div><!-- //pop_head -->
	<div class="pop_con">
	
		<p class="tit_p fl mt5">운행기록부 업로드</p>
		<div class="com_ta mt10">
            <table>
                <colgroup>
                    <col width="184"/>
                    <col width=""/>
                </colgroup>
                <tr>
                    <th>업로드양식다운로드</th>
                    <td>
                        <div class="up_file_div">
                            <ul>
                                <li><a href="#n" onclick="fnFormDownload();"><img src="<c:url value='/Images/ico/ico_xls.png'/>" alt="" /><span>엑셀파일</span></a></li>
                            </ul>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>업로드 파일선택</th>
                    <td>
                        <div class="fl">
                            <input type="text" class="inp_url" style="width:330px;" />
                            <input type="button" value="찾아보기" class="btn_blue find_btn" />
                            <div id="uploadSpin" style="display:none;float:left;padding-right:10px;padding-top:4px;"><strong class="k-upload-status k-upload-status-total"><spna id="uploadSts">100</spna>% Uploading...<span class="k-icon k-loading"></span></strong></div>
                        </div>	
                        <input type="file" id="filed" />
                        <div class="controll_btn fl p0 ml10">
                                <button id="" class="btn_com" onclick="bizCarExcelValidate();">적용하기</button>
                        </div>
                    </td>
                </tr>
            </table>
        </div>

        <!-- 테이블 -->
        <div class="table1 posi_re mt14">
            <div class="cus_ta_ea">
                <span class="scy_head3"></span>
                <!-- RIGHT HEADER -->
                <div id="" class="cus_ta_ea ovh mr17 rightHeader ta_bl">
                    <table>
                       <colgroup>
                            <col width="34"/>
                            <col width="75"/>
                            <col width="75"/>
                            <col width="65"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="150"/>
                            <col width="70"/>
                            <col width="150"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                        </colgroup>
                        <tr>
                            <th rowspan="2">
                                <input type="checkbox" name="inp_chkAll" id="inp_chkAll" onclick="fnCheck(this);" class=""/>
                                <label class="" for="inp_chkAll" ></label>
                            </th>
                            <th rowspan="2">차량</th>
                            <th rowspan="2">운행일자</th>
                            <th rowspan="2">운행구분</th>
                            <th rowspan="2">출발시간</th>
                            <th rowspan="2">도착시간</th>
                            <th rowspan="2">출발구분</th>
                            <th rowspan="2">출발지</th>
                            <th rowspan="2">도착구분</th>
                            <th rowspan="2">도착지</th>
                            <th rowspan="2">주행전(Km)</th>
                            <th rowspan="2">주행후(Km)</th>
                            <th rowspan="2">주행(Km)</th>				
                            <th rowspan="2" style="border-right:1px solid #eaeaea !important">비고</th>
                            <th colspan="2">유류비</th>
                            <th colspan="2">통행료</th>
                            <th colspan="2">주차비</th>
                            <th colspan="2">수선비</th>
                            <th colspan="2">기타</th>
                        </tr>
                        <tr>
                            <th>결제구분</th>
                            <th>금액</th>
                            <th>결제구분</th>
                            <th>금액</th>
                            <th>결제구분</th>
                            <th>금액</th>
                            <th>결제구분</th>
                            <th>금액</th>
                            <th>결제구분</th>
                            <th>금액</th>
                        </tr>
                    </table>
                </div>

                
                <!-- RIGHT CONTENTS -->
                <div id="" class="cus_ta_ea scroll_fix rightContents scbg ta_bl" style="height:210px;" onScroll="table1Scroll()">
                   <!-- 합계 -->
                   <table id="dataCheckTable">
                        <colgroup>
                            <col width="34"/>
                            <col width="75"/>
                            <col width="75"/>
                            <col width="65"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="150"/>
                            <col width="70"/>
                            <col width="150"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="70"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="100"/>
                            <col width="95"/>
                        </colgroup>
					<tbody>
						<tr>
							<td colspan="12"><%=BizboxAMessage.getMessage("TX000015757","데이타가 없습니다.")%></td>
						</tr>				
					</tbody>
                        
                    </table>
                </div>
            </div>   
        </div>
    

		<!-- paging -->
		<!-- <div class="paging mt30">
			<span class="pre_pre"><a href="">10페이지전</a></span>
			<span class="pre"><a href="">이전</a></span>
				<ol>
					<li class="on"><a href="">1</a></li>
					<li><a href="">2</a></li>
					<li><a href="">3</a></li>
					<li><a href="">4</a></li>
					<li><a href="">5</a></li>
					<li><a href="">6</a></li>
					<li><a href="">7</a></li>
					<li><a href="">8</a></li>
					<li><a href="">9</a></li>
					<li><a href="">10</a></li>
				</ol>
			<span class="nex"><a href="">다음</a></span>
			<span class="nex_nex"><a href="">10페이지다음</a></span>
		</div> -->



				
	</div><!-- //pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" class="" value="저장" onclick="fnSave();"/>
            <input type="button" class="gray_btn" value="삭제" onclick="fnDelete();"/>
			<input type="button" class="gray_btn" value="취소" onclick="fnclose();"/>
		</div>
	</div><!-- //pop_foot -->


</div><!-- //pop_wrap -->