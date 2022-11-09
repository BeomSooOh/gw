<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<link rel='stylesheet' type='text/css' href='<c:url value="/css/css.css" />' media='screen' />

<script type='text/javascript'>
//<![CDATA[

var monthCalender = (function(tgetId,json){
	var id          = null;
	var imgUrl      = null;
	var year        = null;
	var month       = null;
	var callBack    = null;
	var seperator   = '-';

	this.init = function(tgetId, args){
		id = tgetId;
		var idobj = document.getElementById(id);
		idobj.onclick = openMonthCalender;

		if( args.imgUrl!=undefined && args.imgUrl!='' && args.imgUrl!=null ){
			imgUrl  = args.imgUrl;
			var img = document.createElement('IMAGE');
			$(img).attr('src',imgUrl);
			$(img).attr('align','absmiddle');
			$(img).css('margin-left','3px');
			img.onclick = openMonthCalender;

			if( typeof(id)=='string' ){
				$('#'+id).after(img);
			}else if( typeof(id)=='object' ){
				$(id).after(img);
			}
		}

		var tobj = document.getElementById(tgetId);
		var tval = tobj.value.replace(/[\'|\"]/g,'');
		if(tval.length==8){
			year    = tval.substring(0,4);
			month   = tval.substring(4);
		}else{
			year    = this.getStrYear(args.year);
			month   = this.getStrMonth(args.month);
		}

		if( args.seperator!=undefined && args.seperator!=null ) seperator = args.seperator;
		if( args.callBack!=undefined && args.callBack!='' && args.callBack!=null ) callBack = args.callBack;

		setYear(year);
		setMonth(month);

		$('#monthCalenderDivId').hide(350);
	};
	this.getStrYear = function(pYear){
		if( pYear==undefined || pYear=='' || pYear==null ) year = (new Date().getFullYear());
		else year = Number(pYear);
		return year;
	};
	this.getStrMonth = function(pMonth){
		if( pMonth==undefined || pMonth=='' || pMonth==null ) month = (new Date().getMonth()+1);
		else month = Number(pMonth);
		if(month<10) month = '0'+month;
		return month;
	};
	var setYear = function(){
		if(year==undefined || year=='' || year==null ) year = (new Date().getFullYear());
		document.getElementById('monthCalenderYearId').value = year;
	};
	var setMonth = function(){
		if(month==undefined || month=='' || month==null ) month = this.getStrMonth();
		$("A[group='MonthCalenderGroup']").removeClass('ui-state-default ui-state-active').addClass('ui-state-default');
		$("A[group='MonthCalenderGroup'][value='"+month+"']").addClass('ui-state-default ui-state-active');
	};
	var addYear = function(){
		year = Number($('#monthCalenderYearId').val())+1;
		$('#monthCalenderYearId').val(year);
	};
	var subYear = function(){
		year = Number($('#monthCalenderYearId').val())-1;
		$('#monthCalenderYearId').val(year);
	};
	var selMonth = function(){
		$("A[group='MonthCalenderGroup']").removeClass('active');
		$("A[group='MonthCalenderGroup'][value='"+this.getAttribute('value')+"']").addClass('active');

		year    = document.getElementById('monthCalenderYearId').value.replace(/[\'|\"]/g,'');
		month   = this.getAttribute('value');
		document.getElementById(id).value = year + seperator + month;
		$('#monthCalenderDivId').hide(350);
		if(callBack!=undefined || callBack!='' || callBack!=null ){
			if(typeof(callBack)=='function'){
				callBack(id, year, month);
			}else if(typeof(callBack)=='string'){
				window[callBack](id, year, month);
			}
		}
		return;
	};

	var setSelMonEvt = function(obj){
		obj.onclick = null;
		obj.onclick = selMonth;
	};

	var setPrevYear = function(obj){
		obj.onclick = null;
		obj.onclick = subYear;
	};

	var setNextYear = function(obj){
		obj.onclick = null;
		obj.onclick = addYear;
	};

	var openMonthCalender = function(){
		setYear(year);
		setMonth(month);

		var as  = document.getElementsByTagName('A');
		for(var i=0; i<as.length; i++){
			if(as[i].getAttribute('group')=='MonthCalenderGroup') setSelMonEvt(as[i]);
		}
		setPrevYear(document.getElementById('monthCalenderYearPrevId'));
		setNextYear(document.getElementById('monthCalenderYearNextId'));

		$('#monthCalenderDivId').show(350);
		var offset = $('#'+id).offset();
		$('#monthCalenderDivId').css('top',offset.top+20).css('left',offset.left);
	};
});

//]]>
</script>
<!-- 월달력 -->
<div class='ui-datepicker ui-widget ui-widget-content_custom ui-helper-clearfix ui-corner-all ui-helper-hidden-accessible' id='monthCalenderDivId' style='position:absolute; top:0px; left:0px; display:none; z-index:9999;width:156px;'>
	<div class='ui-datepicker-header ui-widget-header ui-helper-clearfix ui-corner-all'>
		
		<a href='#' class='ui-datepicker-prev ui-corner-all' id='monthCalenderYearPrevId'><span class="ui-icon ui-icon-circle-triangle-w">이전</span></a>
		<a href='#' class='ui-datepicker-next ui-corner-all' id='monthCalenderYearNextId'><span class="ui-icon ui-icon-circle-triangle-e">뒤로</span></a>
		
		<div class="ui-datepicker-title">
		<input type="text" class='today noInput' id='monthCalenderYearId' style=' width:65px; border:0px;text-align: center;' value='' />
		</div>
	</div>
		<table width='100%' border='0' cellspacing='0' cellpadding='0' class="ui-datepicker-calendar">
			<tr>
				<td><a href='#' group='MonthCalenderGroup' value='01' class="ui-state-default">1월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='02' class="ui-state-default">2월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='03' class="ui-state-default">3월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='04' class="ui-state-default">4월</a></td>
			</tr>
			<tr>
				<td><a href='#' group='MonthCalenderGroup' value='05' class="ui-state-default">5월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='06' class="ui-state-default">6월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='07' class="ui-state-default">7월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='08' class="ui-state-default">8월</a></td>

			</tr>
			<tr>
				<td><a href='#' group='MonthCalenderGroup' value='09' class="ui-state-default">9월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='10' class="ui-state-default">10월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='11' class="ui-state-default">11월</a></td>
				<td><a href='#' group='MonthCalenderGroup' value='12' class="ui-state-default">12월</a></td>
			</tr>
		</table>
</div>
<!-- //월달력 -->