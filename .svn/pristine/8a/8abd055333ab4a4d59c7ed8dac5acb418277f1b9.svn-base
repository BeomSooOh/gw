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
	String ywyw = URLDecoder.decode(request.getParameter("carNum"));
	String rowSeq = request.getParameter("rowSeq");
%>

<script type="text/javascript">
window.focus();

var loginV = "${loginVO}";
var ywyw2 = "<%= ywyw %>"; 
var rowSeq2 = "<%= rowSeq %>";
var rowY = 0; //방향키로 행이동시 선택된 행번호를 가지는 변수
$(document).ready(function() {
	$('#carNum').val(ywyw2);
	
	//ERP 차량 조회
	getBizCarNumList();
	
	fnResizeForm();
		 
	$( '#carNumListTable' ).keydown(function(e){
	    var key = e.keyCode ? e.keyCode : e.which; //IE & 크롬
	    var rId = e.target.parentNode.id;	    
	    var tr = document.getElementsByTagName("tr");
	    var rownum = tr.length -2; //최상단 row제외, 0부터시작 -2
	    
	    switch(key){
	        case 38: //위
	        	moveUp(rownum);
	            break;
	        case 40: //아래
	        	moveDown(rownum);
	            break;
            case 13: //엔터
	        	fnOk( );            
	            break;
	        default:
	        	$( "#carNum" ).focus();
	            break;
	    }
	});
	
	
	$( "#carNum" ).on('keydown', function (e) {
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
	                //$( '#carNum' ).focus();
	                break;
            }
        });
	
	$("#carNumListTable").click( ).focus( );
});//document ready end

//이벤트 취소
function cancelEvent(event){
    if(event.preventDefault){
        event.preventDefault();
    }else{
        event.returnValue = false;
    }
}

function moveDown(rn){    
	document.getElementById('carNumListTable').rows[rowY].bgColor='white';
   	if (rowY>=rn){/* rowY=0; */} else {rowY++;} 
   	document.getElementById('carNumListTable').rows[rowY].bgColor='#E6F4FF';
   	setRowY(rowY);
   	
    //이동한 id값 저장
    var selval = $('#trRow_'+rowY).attr('val');
    $("#selCarNum").val(selval);
     $('#trRow_'+rowY).focus();
    
}

function moveUp(rn){
	document.getElementById('carNumListTable').rows[rowY].bgColor='white';
   	if (rowY<=0){/* rowY=rn; */} else {rowY--;} 
   	document.getElementById('carNumListTable').rows[rowY].bgColor='#E6F4FF';
   	setRowY(rowY);
   	
    //이동한 id값 저장
    var selval = $('#trRow_'+rowY).attr('val');
    $('#trRow_'+rowY).focus();
    $("#selCarNum").val(selval);
}

//현재 선택된 행 번호를 hidden에 넣어준다.
function setRowY(i) {
	rowY = i;
	return false;
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

function getBizCarNumList(){
	var tblParam = {};
	tblParam.carNum = $("#carNum").val();
	
	$.ajax({
		type:"post",
		url:'<c:url value="/cmm/ex/bizcar/pop/bizCarErpSearch.do"/>',
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
	    	if ($("#carNum").val() == ""){
	    		var list = data.bizCarNumList;
			}else {
				var list = data.bizCarNumList2;
			}
			
	    	setCarNumListTable(list);	
	    	
	    	$("#selCarNum").val(""); //선택값 초기화
	    	
	    	if(list.length > 0){
	    		setRowY(0); //rowY값 초기화
	    		
	    		//처음 로딩시 첫번째 행 자동선택되도록 하는 이벤트
		    	document.getElementById('carNumListTable').rows[rowY].bgColor='#E6F4FF';
		    	var selval = $('#trRow_'+rowY).attr('val');
		        $("#selCarNum").val(selval);
	    	}	    	
			
		}
		, error:function(data){
			$('html').css("cursor","auto");
			alert("데이터 가져오는 중 오류가 발생하였습니다.");
		}
	});
	
}

function setCarNumListTable(list){
	$("#carNumListTable").html("");
	
	var InnerHtml = "";
	
	for(var i=0;i<list.length;i++){
		//var checkboxId = "inpchk_" + i;
		InnerHtml += "<tr tabindex='0' onclick='fnclick(this)' ondblclick='fnOk();' onkeypress='if( event.keyCode==13 ){fnOk();}' id='trRow_"+i+"' class='trRow' val='" + list[i].CAR_CD +"_"+ list[i].CAR_NB + "_"+list[i].CAR_NM+"'>";
		InnerHtml += "<td>" + list[i].CAR_CD + "</td><td>" + list[i].CAR_NB + "</td><td>" + list[i].CAR_NM + "</td></tr>";
	}
	if(list.length == 0)
		InnerHtml += "<tr><td colspan='3'>검색된 차량이 없습니다.</td></tr>";
		
	$("#carNumListTable").html(InnerHtml);
}

function fnSearch(){
	getBizCarNumList();
	
}

function fnclick(e){
	var table = document.getElementById("carNumListTable");
	var tr = table.getElementsByTagName("tr");
	
	var rId = e.id;
	var strArray = rId.split('_');
    var ri = Number(strArray[1]);
    for(var i=0; i<tr.length; i++)
    	document.getElementById('carNumListTable').rows[i].bgColor='white';
    document.getElementById('carNumListTable').rows[ri].bgColor='#E6F4FF';
    setRowY(ri);
    
    //클릭한 id값 저장
    var selval = $('#'+rId).attr('val');
    $("#selCarNum").val(selval);
}

function fnOk(){
	var selCarNum = $("#selCarNum").val();
	if(selCarNum == ""){
		alert("<%=BizboxAMessage.getMessage("TX000010746","선택한 항목이 없습니다")%>");
		return;
	}
	if(rowSeq2 == "" || rowSeq2 == "null"){
		//차량번호 검색시
		opener.setBizCarNum(selCarNum);
		
	}else{
		//그리드 ROW에서 차량 검색시 입력포커스와 함께 콜백
		opener.setBizCarNum2(selCarNum, rowSeq2);
	}
	self.close();
	
}

function fnclose(){
	
	self.close();
}
</script>





<div class="pop_wrap">
	<div class="pop_head">
		<h1>차량구분 도움</h1>
		<!-- <a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo02.png" alt="" /></a> -->
	</div>	
	
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt>검색어</dt>
				<dd><input type="text" name="carNum" style="width:200px" id="carNum" onkeydown="if(event.keyCode==13){javascript:fnSearch();}" autofocus/></dd>
				<dd><input type="button" value="검색" onclick="fnSearch();" /></dd>
			</dl>
		
		</div>
		<div class="com_ta2 mt10">
			<table>
				<colgroup>
					<col width="100"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
					<th>차량코드</th>
					<th>차량번호</th>
					<th>차종</th>
				</tr>
			</table>
		</div>

		<div class="com_ta2 ova_sc cursor_p bg_lightgray" style="height:333px">
			<table>
				<colgroup>
					<col width="100"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tbody id="carNumListTable">
					
				</tbody>
			</table>
		</div>		
	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" onclick="fnOk();"/>
			<input type="button" class="gray_btn" value="취소" onclick="fnclose();"/>
		</div>
	</div><!-- //pop_foot -->
	
	<input type="hidden" id="selCarNum" name="selCarNum"/>

</div>