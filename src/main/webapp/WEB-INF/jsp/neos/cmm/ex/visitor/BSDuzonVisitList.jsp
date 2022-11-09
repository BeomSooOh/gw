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
    //기본버튼
	$("button").kendoButton();  

	// 달력
	$("#calendar").kendoCalendar({
		value: new Date(),
		change: function(){
			var yyyy = this.value().getFullYear().toString();
			var mm = this.value().getMonth() + 1;
			var dd = this.value().getDate();
			
			if (mm < 10)
			    mm = "0" + mm;
			if (dd < 10)
			    dd = "0" + dd;
			
			//달력 날짜 선택시 해당주 데이터 조회
			fnLoadList(yyyy + mm + dd);
		}
	});
	
	//컨트롤 초기화
	fnControlInit();
});//document ready end

//컨트롤 초기화
function fnControlInit(){
	var date = new Date();
	var yyyy = date.getFullYear().toString();
	var mm = date.getMonth() + 1;
	var dd = date.getDate();
	
	if (mm < 10)
	    mm = "0" + mm;
	if (dd < 10)
	    dd = "0" + dd;
	
	var sDate = yyyy+mm+dd;
	
	//선택 날짜 해당 주의 데이터 조회
	fnLoadList(sDate);
}


//데이터 조회
function fnLoadList(obj){
	
	var year = obj.substring(0, 4).toString();;
    var month = obj.substring(4, 6).toString();;
    var day = obj.substring(6, 8).toString();;
    var week = new Array("일", "월", "화", "수", "목", "금", "토");
    var arrWeek = new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    var vn_day1 = new Date(year, month - 1, day);

    var i = vn_day1.getDay(); //기준일의 요일을 구한다.( 0:일요일, 1:월요일, 2:화요일, 3:수요일, 4:목요일, 5:금요일, 6:토요일 )
	var cnt = 0;
    var cntt = 0;
    intDayCnt1 = 1 - i;
    intDayCnt2 = 7 - i;
    
    var tblParam = {};
    tblParam.sData = "";
    
    for(var i=intDayCnt1-1;i<intDayCnt2;i++){
    	var Cal_st = new Date(vn_day1.getFullYear(), vn_day1.getMonth(), vn_day1.getDate() + i);
    	var st_day2 = DateFormat(Cal_st);
    	var txt_Day = st_day2 + " (" +week[cnt] +")";
    	$("#"+arrWeek[cnt]).html(txt_Day);
    	
    	cnt++;
    	tblParam.sData += st_day2.replace(/-/gi, '') + "|";	//해당 주의 날짜
    }
    

	$.ajax({
	    	type:"post",
			url:'<c:url value="/cmm/ex/visitor/GetVisitorWeekList.do" />',
			datatype:"text",
			data: tblParam ,
			success:function(data){
				//방문객현황 셋팅
				settingVisitList(data);
			},error : function(data){
				alert("<%=BizboxAMessage.getMessage("TX000006506","오류")%>");
			}
	    });
}

//방문객현황 셋팅
function settingVisitList(data){
	$("#Sun_div").html(data.Sun);
	$("#Mon_div").html(data.Mon);
	$("#Tue_div").html(data.Tue);
	$("#Wed_div").html(data.Wed);
	$("#Thu_div").html(data.Thu);
	$("#Fri_div").html(data.Fri);
	$("#Sat_div").html(data.Sat);
}

function DateFormat(obj) { //날짜를 YYYY-MM-DD 형식으로 변경하는 함수
    //Year
    var yy = obj.getFullYear().toString();;
    var mm = "";
    var dd = "";
    //Month
    if (String(obj.getMonth() + 1).length == 1) {
        mm = "0" + (obj.getMonth() + 1);
    }
    else {
        mm = obj.getMonth() + 1;
    }
    //Day
    if (String(obj.getDate()).length == 1) {
        dd = "0" + obj.getDate();
    }
    else {
        dd = obj.getDate();
    }
    var date = yy + "-" + mm + "-" + dd;
    return date;
}


//데이터 상세조회
function fnDetailView(r_no, up){
	
	/* 방문객 현황 - 그룹사 전용 고도화 */
	/* 일반 등록인 경우 visit_place_code == null || "" */
	/* 고도화의 경우 반드시 visit_place_code != null */
	if(up == 0) {
		var url = "visitorPopView.do?r_no="+r_no;
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "visitorPopView", "width=550,height=457,scrollbars=yes,left="+left+" top="+top);	
	   	pop.focus();
	}
	else {
		var url = "visitorPopViewNew.do?r_no="+r_no+"&type=view&readOnly=true";			
    	
	   	var left = (screen.width-958)/2;
	   	var top = (screen.height-753)/2;
	   	 
	   	var pop = window.open(url, "visitorPopViewNew", "width=550,height=457,left="+left+" top="+top);
	   	pop.focus();
	}
}

    </script>


<div class="sub_contents_wrap">
	<div class="twinbox">
		<table>
			<colgroup>
				<col style="width:270px;" />
				<col />
			</colgroup>
			<tr>
				<td class="twinbox_td">
					<!-- 리스트 -->
					<div id="calendar" style="width:100%;"></div>
				</td>
				<td class="twinbox_td">
					<!-- 옵션설정 -->
					<div class="com_ta lh18">
						<table>
							<colgroup>
								<col width="120"/>
								<col />
							</colgroup>
							<tr>
								<th id="Sun"></th>
								<td id="Sun_div">
								</td>
							</tr>
							<tr>
								<th id="Mon"></th>
								<td id="Mon_div">
								</td>
							</tr>
							<tr>
								<th id="Tue"></th>
								<td id="Tue_div">
								</td>
							</tr>
							<tr>
								<th id="Wed"></th>
								<td id="Wed_div">
								</td>
							</tr>
							<tr>
								<th id="Thu"></th>
								<td id="Thu_div">
								</td>
							</tr>
							<tr>
								<th id="Fri"></th>
								<td id="Fri_div">
								</td>
							</tr>
							<tr>
								<th id="Sat"></th>
								<td id="Sat_div">
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div><!-- //sub_contents_wrap -->