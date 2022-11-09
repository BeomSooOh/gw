<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="main.web.BizboxAMessage"%>

<%
	//String ywyw = URLDecoder.decode(request.getParameter("carNum"));
	String rowSeq1 = request.getParameter("rowSeq");
%>

<script type="text/javascript">
window.focus();

var rowSeq = "<%= rowSeq1 %>"; 
var rowY = 0; //방향키로 행이동시 선택된 행번호를 가지는 변수
$(document).ready(function() {

	fnResizeForm();
	
	//ERP 거래처 조회
	getBizCarTradeList();
	
	$('#tradeListTable').keydown(function(e){
		var key = e.keyCode ? e.keyCode : e.which; //IE & 크롬
	    var rId = e.target.parentNode.id;	    
	    var tr = document.getElementsByTagName("tr");
	    var rownum = tr.length -2; //최상단 row제외, 0부터시작 -2
	    
	    switch(key){
		    case 13: //엔터
				fnOk( );
	            break;
	        case 38: //위
	        	moveUp(rownum);
	            break;
	        case 40: //아래
	        	moveDown(rownum);
	            break;
	        default:
				$( "#tradeNm" ).focus();
	            break;
	    }
	});

	$( "#tradeNm" ).on('keydown', function (e) {
			var tr = document.getElementsByTagName("tr");
			var rownum = tr.length -2; //최상단 row제외, 0부터시작 -2
            switch (e.keyCode) {
                /* ENTER EVENT */
	            case 13:
	                fnSearch();
	                var tr = document.getElementsByTagName("tr");
					//var rownum = tr.length -2; //최상단 row제외, 0부터시작 -2
	                $('#trRow_0').focus();
					var evt = evt || window.event;
    				cancelEvent(evt);

	                //moveDown(rownum);
	                break;
	                /* LEFT ARROW EVENT */	        
	            case 38:
	             	$( this ).blur( );
	             	$( this ).focusout( );
	               	moveUp(rownum);
	                return false;
	                //console.log($("#" + locationId).find('.onSel').prev().prop('data'));
	                break;
	                /* RIGHT ARROW EVENT */	          
	                /* DOWN ARROW EVENT */
	            case 40:
	            	$( this ).blur( );
	             	$( this ).focusout( );
	               	moveDown(rownum);
	                return false;
	                break;
	
	            default:
	               // $( '#carNum' ).focus();
	                break;
            }
        });
	
	$("#tradeListTable").click( ).focus( );
	
});//document ready end

//이벤트 취소
function cancelEvent(event){
    if(event.preventDefault){
        event.preventDefault();
    }else{
        event.returnValue = false;
    }
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

function moveDown(rn){    
	document.getElementById('tradeListTable').rows[rowY].bgColor='white';
   	if (rowY>=rn){/* rowY=0; */} else {rowY++;} 
   	document.getElementById('tradeListTable').rows[rowY].bgColor='#E6F4FF';
   	setRowY(rowY);
   	
    //이동한 id값 저장
    var selval = $('#trRow_'+rowY).attr('val');
    $("#selTrade").val(selval);
	$('#trRow_'+rowY).focus();
}

function moveUp(rn){
	document.getElementById('tradeListTable').rows[rowY].bgColor='white';
   	if (rowY<=0){/* rowY=rn; */} else {rowY--;} 
   	document.getElementById('tradeListTable').rows[rowY].bgColor='#E6F4FF';
   	setRowY(rowY);
   	
    //이동한 id값 저장
    var selval = $('#trRow_'+rowY).attr('val');
	$('#trRow_'+rowY).focus();
    $("#selTrade").val(selval);
}

//현재 선택된 행 번호를 hidden에 넣어준다.
function setRowY(i) {
	rowY = i;
	return false;
}

function getBizCarTradeList(){
	var tblParam = {};
	tblParam.tradeNm = $("#tradeNm").val();
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/bizCarErpTradeSearch.do"/>',
		datatype:"json",
		data: tblParam ,
		async: false,
		contenttype: "application/json;",
		beforeSend: function() {	              
            $('html').css("cursor","wait");   // 현재 html 문서위에 있는 마우스 커서를 로딩 중 커서로 변경
        },
	    success:function(data){
	    	$('html').css("cursor","auto");
	    	var result = data.result;
	    	if(result){
	    		alert(result);
	    	}
	    	
	    	//검색어가 없을시 icube에서 가져온 전체 데이터 가져옴
	    	if ($("#tradeNm").val() == ""){
	    		var list = data.bizCarTradeList;
			}else {
				var list = data.bizCarTradeList2;
			}
			
	    	setCarTradeListTable(list);	
	    	
	    	if(list.length > 0){
	    		setRowY(0); //rowY값 초기화
	    		
	    		//처음 로딩시 첫번째 행 자동선택되도록 하는 이벤트
		    	document.getElementById('tradeListTable').rows[rowY].bgColor='#E6F4FF';
		    	var selval = $('#trRow_'+rowY).attr('val');
		        $("#selTrade").val(selval);
	    	}	
			
		}
		, error:function(data){
			$('html').css("cursor","auto");
			alert("데이터 가져오는 중 오류가 발생하였습니다.");
		}
	});
	
}

function setCarTradeListTable(list){
	$("#tradeListTable").html("");
	
	var InnerHtml = "";
	
	for(var i=0;i<list.length;i++){
		//var checkboxId = "inpchk_" + i;
		InnerHtml += "<tr tabindex='0' onclick='fnclick(this)' ondblclick='fnOk();' onkeypress='if( event.keyCode==13 ){fnOk();}' id='trRow_"+i+"' val='" + list[i].TR_NM + "_"+list[i].DIV_ADDR1+"'>";
		InnerHtml += "<td class='le'>" + list[i].TR_CD + "</td><td class='le'>" + list[i].TR_NM + "</td><td>" + list[i].REG_NB + "</td><td>" + list[i].CEO_NM + "</td><td class='le'>" + list[i].DIV_ADDR1 + "</td></tr>";
	}
	if(list.length == 0)
		InnerHtml += "<tr><td colspan='5'>검색된 거래처가 없습니다.</td></tr>";
		
	$("#tradeListTable").html(InnerHtml);
}

function fnSearch(){
	getBizCarTradeList();
	
}

function fnclick(e){
	var table = document.getElementById("tradeListTable");
	var tr = table.getElementsByTagName("tr");
	var rId = e.id;
	var strArray = rId.split('_');
	var ri = Number(strArray[1]);
	for(var i=0; i<tr.length; i++)
		document.getElementById('tradeListTable').rows[i].bgColor='white';
	document.getElementById('tradeListTable').rows[ri].bgColor='#E6F4FF';
	setRowY(ri);
	
	//클릭한 id값 저장
	var selval = $('#'+rId).attr('val');
	$("#selTrade").val(selval);	
}

function fnOk(){
	//그리드 ROW에서 거래처검색시 입력포커스와 함께 콜백 함수 호출
	var selTrade = $("#selTrade").val();
	var row = rowSeq;
	opener.setBizCarTrade(selTrade, row);
	
	self.close();
	
}

function fnclose(){
	
	self.close();
}
</script>



<div class="pop_wrap resources_reservation_wrap" style="width:898px;">
	<div class="pop_head">
		<h1>거래처 검색</h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div><!-- //pop_head -->
	
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt>검색어</dt>
				<dd><input type="text" id="tradeNm" style="width:250px;" onkeydown="if(event.keyCode==13){javascript:fnSearch();}" autofocus/></dd>
				<dd><input type="button" id="searchButton" value="검색" onclick="fnSearch();" /></dd>
			</dl>
		</div>

		<div class="com_ta2 mt15">
			<table>
				<colgroup>
					<col width="100"/>
					<col width="150"/>
					<col width="150"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>거래처 코드</th>
					<th>거래처명</th>
					<th>사업자번호</th>
					<th>대표자명</th>
					<th>거래처주소</th>
				</tr>
				</table>	
		</div>

		<div class="com_ta2 ova_sc bg_lightgray" style="height:259px;">
			<table>
				<colgroup>
					<col width="100"/>
					<col width="150"/>
					<col width="150"/>
					<col width="120"/>
					<col width=""/>
				</colgroup>
				<tbody id="tradeListTable">
					
				</tbody>
			</table>
		</div>

	</div><!-- //pop_con -->
	
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" onclick="fnOk();"/>
			<input type="button"  class="gray_btn" value="취소" onclick="fnclose();"/>
		</div>
	</div><!-- //pop_foot -->
</div><!-- //pop_wrap -->

<input type="hidden" id="selTrade" name="selTrade"/>
