	/**
	 * @Class Name : resizeJqGrid.js
	 * @Description : jqGrid 리사이즈 함수
	 * @Modification Information
	 * @
	 * @  수정일                 수정자            수정내용
	 * @ ----------   --------    ---------------------------
	 * @ 2012.05.08    김석환             최초 생성
	 *
	 *  @author 포털개발팀 김석환
	 *  @since 2012.05.08
	 *  @version 1.0
	 *  @see
	 *  resizeJqGrid.js
	 *
	 */
var jqGridUtil = {};
jqGridUtil.resizeJqGrid = function(divid){

	 var min = $.jqGrid.min;    //  1024 
	// ========
	var lnbLeft =$("#lnb_left").css("display");
	if(lnbLeft ==undefined){//  frameset 사용시   ( frame page를 위해 )
		lnbLeft = $(top.document).find("#lnb_left").css("display");
	}
	if(lnbLeft=="block"){ 
		win_w1 = win_w1 +210;
	}
	
	/*cont_area(가로사이즈) - cont_pad(margin-right) = jqgrid width
	 *  
	 * */
	/*var cont_area = $(".cont_area");	
	var cont_area_width = cont_area.css("width").replace("px","");
	var cont_pad = $(".cont_pad",cont_area);
	var cont_pad_width = cont_pad.css("margin-right").replace("px","");*/
	
	
	var realWidth = 0;
	/*try{
		realWidth = parseInt(cont_area_width) - parseInt(cont_pad_width);
	}catch(e){}*/
	
	var win_w1 = $("form").width();
	if(win_w1 && parseInt(win_w1)< parseInt(min)){
		win_w1 = min;
	}	
	if(realWidth){
		win_w1 = realWidth;
	}
	// ========

	 var board_table  = $("#" + divid);//.not(".ui-subgrid");
	 var th =$("[role=columnheader]", board_table);//.not(".ui-subgrid [role=columnheader]");
	 var td = $("[role=gridcell]", board_table);//.not(".ui-subgrid [role=gridcell]");;
	


	var leftWidth = 0;//NeosUtil.getLeftMenuWidth();
	
	if($.jqGrid.addLeft==true){
		leftWidth = $.jqGrid.leftSize;
	}
	
	var width = win_w1 - leftWidth-1;

	board_table.css("width",width -1 ); 
	
	$(".ui-jqgrid", board_table).css("width",width);
	$(".ui-jqgrid-view", board_table).css("width",width);
	$(".ui-jqgrid-hdiv", board_table).css("width",width);
	//9 * 2
	$(".ui-jqgrid-htable", board_table).css("width",width );
	
	$(".ui-jqgrid-bdiv", board_table).css("width",width);
	$(".ui-jqgrid-btable", board_table).css("width",width );
	
	// test
	//$(".ui-jqgrid-bdiv", board_table).css("overflow-y","auto");
	//$(".ui-jqgrid .ui-jqgrid-bdiv").css("overflow","hidden");
	//$(".ui-jqgrid .ui-jqgrid-bdiv").css("overflow-x","hidden");
	//$(".ui-jqgrid .ui-jqgrid-bdiv").css("overflow-y","auto");

	for(var i=0; i<td.length;i++){
		var widthtemp = $.jqGrid.data[i];
		if(typeof widthtemp =="string"){
			$(td[i]).css("width",widthtemp);
			if(i==0 && $(":checkbox[role=checkbox]", $(th[i])).length){//0번째 체크박스 width 1 추가(th)
				var widthtemp2 = widthtemp;
				if(isNaN(widthtemp2)){
					try{
						var tempInt = widthtemp2.match(/\d/gi).join("");
						widthtemp2 = parseInt(tempInt) + 0 + widthtemp2.replace(tempInt,"");
					}catch(e){
						widthtemp2 = widthtemp;
					}
				}else{
					widthtemp2 = widthtemp + "px";
				}
				$(th[i]).css("width",widthtemp2);
			}else{
				$(th[i]).css("width",widthtemp);
			}
			
		}
	}
	
	jqGridUtil.resizeSubJqGrid(divid);
};

jqGridUtil.resizeSubJqGrid = function(divid){
	
	var win_w1 = $(window).width();
	 var min = $.jqGrid.min;

	// ========
	var lnbLeft =$("#lnb_left").css("display");
	if(lnbLeft ==undefined){//  frameset 사용시   ( frame page를 위해 )
		lnbLeft = $(top.document).find("#lnb_left").css("display");
	}
	if(lnbLeft=="block"){ 
		win_w1 = win_w1 +210;
	}
	// ========
	
	 if(win_w1 && parseInt(win_w1)< parseInt(min)){
		 return false;
	 }

	 
	 var board_table  = $("#" + divid);
	 var tr = $(".ui-subgrid", board_table);
	 
	 var th =$("[role=columnheader]", tr);
	 var td = $("[role=gridcell]", tr);
	

	 var leftWidth = NeosUtil.getLeftMenuWidth ();
	var width = win_w1 - leftWidth -51;

	tr.css("width",width -1 );
	$(".ui-jqgrid", tr).css("width",width);
	$(".ui-jqgrid-view", tr).css("width",width);
	$(".ui-jqgrid-hdiv", tr).css("width",width);
	//9 * 2
	$(".ui-jqgrid-htable", tr).css("width",width );
	
	$(".ui-jqgrid-bdiv", tr).css("width",width);
	$(".ui-jqgrid-btable", tr).css("width",width );
	
	for(var i=0; i<td.length;i++){
		var widthtemp = $.jqGrid.subData[i];
		if(widthtemp){
			$(td[i], tr).css("width",widthtemp);
			$(th[i], tr).css("width",widthtemp);
		}
	}
};

//열람자보기 html
jqGridUtil.getRedingLineInfoViewBtnHtml = function(cellvalue, options, rowObject){
	return "<a href='javascript:;' onclick='readOpen(\""+cellvalue+"\")'><img src='"+_g_contextPath_ +"/images/btn/btn_view.gif' title='보기' class='fix' /></a>";
};

//결재선보기 아이콘 html
jqGridUtil.getApprovalLineInfoViewBtnHtml = function(cellvalue, options, rowObject){
		return "<a href='javascript:;' onclick='jqGridUtil.openPopApprovalLine(\""+cellvalue+"\")'><img src='"+_g_contextPath_ +"/images/btn/btn_view.gif' title='보기' class='fix' /></a>";
};

//결재선보기 아이콘 html ,결재라인이 있는경우에만 보여짐
jqGridUtil.openApprovalLineView = function(cellvalue, options, rowObject){
	
	var n =0;
	var html ="";
	
	var userkey = rowObject.c_kluserkey;
	for(var i=0; i<userkey.length; i++)	{
		if(userkey.charAt(i) !='/')			   
			continue;	
		n++;
	}
	
	if( n >= 1){
		   html = jqGridUtil.getApprovalLineInfoViewBtnHtml(cellvalue, options, rowObject);
	}
	return html;	
};

//결재선보기
jqGridUtil.openPopApprovalLine = function(c_dikeycode){
	var param = "diKeyCode="+c_dikeycode;
	neosPopup('POP_APPLINE', param);
};


//결재선보기 html
jqGridUtil.oldDocApprovalLineInfoViewBtnHtml = function(cellvalue, options, rowObject){
	return "<a href='javascript:;' onclick='jqGridUtil.openPopOldDocApprovalLine(\""+cellvalue+"\")'><img src='"+_g_contextPath_ +"/images/btn/btn_view.gif' title='보기' class='fix' /></a>";
};

jqGridUtil.openPopOldDocApprovalLine = function(cellvalue){
	var cDiuserkey = '';
	var param = "cDocnumber="+cellvalue;
	neosPopup('POP_OLD_APPLINE', param);
};


/*jqGrid option 공통 지정*/
jqGridUtil.jqGridCommonOption = function(obj, isResizable){//isResizable : jqGrid의 컬럼들 리사이즈 가능하게 하고 싶을때만 true
	var option = obj.option  || {};
	
	/*컬럼 리사이즈 막기 시작*/
	if(!isResizable){
		if(option.colModel){
			var colModel = option.colModel;
			for(var i =0; i<colModel.length;i++){
				try {
				colModel[i]["resizable"] = false;
				}catch(e ) {}
			}
		}
	}
	/*컬럼 리사이즈 막기 끝*/
	
	/*데이터가 한건도 없을경우 sort 기능 막기 시작*/
	var jsondata = option.data || [];
	if(!jsondata.length){
		if(option.colModel){
			var colModel = option.colModel;
			for(var i =0; i<colModel.length;i++){
				
				try {
				colModel[i]["sortable"] = false;
				}catch(e ) {}
			}
		}
	}
	/*데이터가 한건도 없을경우 sort 기능 막기 끝*/
	
	option.height = "auto";
	option.loadtext="Loading...";
	//공통적용사항	
	return obj;
};

/*jqGrid 데이터가 한건도 없을경우 */
jqGridUtil.setEmptyData = function(obj, divid){
	if(!obj || !obj.option){
		return;
	}
	var option = obj.option;

	var jsondata = option.data;
	if(!jsondata){
		return false;
	}
	
	if(!jsondata.length){
		var table = "<div style=\"border-left:1px solid #aaaaaa; border-right:1px solid #aaaaaa; border-bottom:1px solid #aaaaaa; width:100%; padding-top:20px;padding-bottom:20px; text-align:center\">데이터가 존재하지 않습니다.</div>";
		$("#" + divid).append(table);
	}
};

/*결재쪽 제목 style 지정(결재대기, 결재예정)*/
jqGridUtil.TextOverFlow2 = function (cellvalue, options, rowObject){
	var text = rowObject.c_dikeycode;
	jqGridUtil[text] =  rowObject;
	/*002 : 긴급처리문서 일경우 긴급(이미지)포함*/
	var className = rowObject.c_didocgrade=='002'?"emergencyDoc" : "";
	
	var title ='<DIV onclick="jqGridUtil.titleOnClick(\''+text+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer;'+ '" class="'+className+'" ><NOBR>';
	if(rowObject.c_didocgrade=='002'){
		title = title + '<img src="/gw/images/neos/nreport_icon.gif">';
	}
	title +=  '<span style="">' + cellvalue+'</span></NOBR> </DIV>';
	return 	title;
};
/*결재쪽 제목 style 지정*/
jqGridUtil.TextOverFlow = function (cellvalue, options, rowObject){
	var text = rowObject.c_dikeycode;
	var disecretgrade = rowObject.c_disecretgrade;
	var c_rideleteopt = rowObject.c_rideleteopt;
	var docstatus = rowObject.docstatus;
	jqGridUtil[text] =  rowObject;
	var title = '';
	if(c_rideleteopt=='d'|| docstatus=='d' ){
		title= 		'<DIV onclick="jqGridUtil.titleOnClick(\''+text+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer; text-decoration:line-through;color:red" id="'+text+'" value="d"><NOBR>'+cellvalue+'</NOBR> ';
	}else 
	    title= 		'<DIV onclick="jqGridUtil.titleOnClick(\''+text+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> ';
	
	if(disecretgrade == "009"){
		title += ' <img src="'+_g_contextPath_ +'/images/neos/ico/ico_secret.gif" title="보안문서" class="fix" />';
	}
	title += '</DIV>';
	return title;
};

/*발송현황 - 제목 발송실패 style */
jqGridUtil.TextOverFlowSendStatus = function (cellvalue, options, rowObject){
	var text = rowObject.c_dikeycode;
	var sistatus = rowObject.sistatus;
	var sistatus_Ko = rowObject.sistatus_Ko;
	jqGridUtil[text] =  rowObject;
	var title = 	'<DIV onclick="jqGridUtil.titleOnClick(\''+text+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> ';
	if(sistatus =="015" || sistatus =="010" || sistatus == "902"){
		title += '<font class=\"f_blue\">['+sistatus_Ko+']</font>';
	}else if(sistatus =="004" || sistatus >= "800"  ){
		title += '<font class=\"f_realred\">['+sistatus_Ko+']</font>';
	}else if(sistatus =="007"){
		title += '<font class=\"f_orange\">['+sistatus_Ko+']</font>';
	}
	title += '</DIV>';
	return title;
};

/* 항목명 style 지정*/
jqGridUtil.textStyle =  function(cellvalue, options, rowObject){
    if(cellvalue ==null){
        cellvalue = "";
    }
    return  '<DIV style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> </DIV>';
};

//열람문서는 hash로 받아오기땜에 따로뺌
jqGridUtil.TextOverFlow_readingList = function (cellvalue, options, rowObject){
	var text = rowObject.C_DIKEYCODE;
	jqGridUtil[text] =  rowObject;
	var disecretgrade = rowObject.C_DISECRETGRADE;
	var title= 		'<DIV onclick="jqGridUtil.titleOnClick(\''+text+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> ';
	if(disecretgrade == "009"){
		//title += '<font style=\"color:red;\">[보안]</font>';
		title += ' <img src="'+_g_contextPath_ +'/images/neos/ico/ico_secret.gif" title="보안문서" class="fix" />';
	}
	title += '</DIV>';
	return title;
	};
// 구문서의 경우 c_docnumber을 받아야함  추가 
jqGridUtil.TextOverFlow_Olddoc = function (cellvalue, options, rowObject){

	var param = String(rowObject.fullFilePath);
	var cDifilename = rowObject.cDifilename; 
	var fat = String(rowObject.fileAttCnt);
//	var lastindex = param.lastIndexOf('.');
//	var filetype = param.substring(lastindex+1, param.length);
	var cDocnumber = String(rowObject.cDocnumber);
	var param = "param="+param +"&fat="+fat+"&cDocnumber="+cDocnumber+"&cDifilename="+cDifilename;
//	jqGridUtil[text] =  rowObject;
	return 	'<DIV onclick="jqGridUtil.titleOnClick(\''+param+'\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> </DIV>';
};


jqGridUtil.minWidth = function(){
	//return 1024-212-15;  // -13
	return 500;
};


jqGridUtil.titleOnClick = function(c_dikeycode){
	try{
		titleOnClick(c_dikeycode);
	}catch(e){
		alert(e.message);
		alert(c_dikeycode);
	}
};

/* 배부문서 */
jqGridUtil.TextOverFlowRecv = function (cellvalue, options, rowObject){
	var text = rowObject.c_dikeycode;
	jqGridUtil[text] =  rowObject;
	/*005 : 재지정요청 , 004: 재배부 요청 */
	var memo = rowObject.c_rsmemo;  
	var title = "";
	if(rowObject.c_rsstatus == "005"){
		title ='<a href="#" class="f_blue"  onmouseover="javascript:showMemo(\'show\', \''+memo+'\')"  onmouseout="showMemo(\'hide\',\''+memo+'\')"><img src="'+_g_contextPath_ +'/images/neos/ico/icon_look.png" title="재지정요청" class="fix" /></a>';
	}else if(rowObject.c_rsstatus == "004"){
		title ='<a href="#" class="f_blue"  onmouseover="javascript:showMemo(\'show\', \''+memo+'\')"  onmouseout="showMemo(\'hide\',\''+memo+'\')"><img src="'+_g_contextPath_ +'/images/neos/ico/icon_look.png" title="재배부요청" class="fix" /></a>';
	}else{
		title = "";
	}	
	return 	title;
};

function showMemo(arg, memo){
	if(arg == "show"){
		var html = '';
        html += '<p class="f_brown">'+memo + '</p><a href="#" style="position:absolute; right:8px; top:8px;" onclick="$(this).parent().hide();"></a>';        
        $("#memoView").html(html);
        $("#memoView").css("top",event.clientY-30);
        $("#memoView").show();              
    }else{
        $("#memoView").hide();
    }
	
}

// 접수완료, 문서폐기 font 
jqGridUtil.RecvStatusTextOverFlow = function (cellvalue, options, rowObject){
    var text = rowObject.c_dikeycode;
    jqGridUtil[text] =  rowObject;
    var memo = rowObject.c_rsmemo;
    var status = rowObject.c_rsstatus;
    //var memo = "aa";
    var title = "";
    if(status == "902" || status == "003"){
        title = '<span class="f_orange" onmouseover="javascript:showMemo(\'show\', \''+memo+'\')"  onmouseout="showMemo(\'hide\',\''+memo+'\')">' + rowObject.c_rsstatusname + '</span>';
    }else{
        title = '<span class="f_blue">' + rowObject.c_rsstatusname + '</span>';
    }
    return  title;
};

jqGridUtil.tableRowStyle = function(tableid){
	var tbid = "list";
	if(tableid){
		tbid = tableid;
	}
	$("#"+tbid+" .ui-row-ltr").each(function(index){
		if(index!=0){
			if(index%2==1){
				//$("td", this).css("background-color","#EEEEEE");
				$( this).addClass("evenListStyle");
			}
		}
	});
};

jqGridUtil.tableSubRowStyle = function(selector){
	$(selector + " .ui-row-ltr").each(function(index){
		if(index!=0){
			if(index%2==1){
				//$("td", this).css("background-color","#EEEEEE");
				$( this).addClass("evenListStyle");
			}
		}
	});
};
//Add Edward  row 링크 적용인 경우
jqGridUtil.tableRowClickStyle = function(tableid){
	var tbid = "list";
	if(tableid){
		tbid = tableid;
	}
	$("#"+tbid+" .ui-row-ltr").each(function(index){
		if(index!=0){
			if(index%2==1){
				//$("td", this).css("background-color","#EEEEEE");
				$( this).addClass("evenListStyle");
			}
		}
		$( this).addClass("rowClick");
	});
};
/*
 	ADd ksh(kim seok hwan) 특정 cell 만 스타일 주기
	jqGridUtil.tableTDStyle("list","c_diwriteday", "classname");
*/
jqGridUtil.tableTDStyle = function(tableid, td, className){
	var tbid = "list";
	if(tableid){
		tbid = tableid;
	}
	$("#"+tbid+" .ui-row-ltr" + " td[aria-describedby=list_"+td+"]").addClass(className || "");
	
};

/**재기안버튼 (문서함) **/
jqGridUtil.viewReDraftButton = function (cellvalue, options, rowObject){        
        var linkYN = rowObject.c_linkyn;
        var reseq = rowObject.c_rireseq;
        var diflag = rowObject.c_diflag;
        var diDocFlag = rowObject.c_didocflag;
        var kyuljaeline = rowObject.c_kluserkey.split("/");
        var diUserkey = kyuljaeline[0];
        var str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:documentUtil.ReDraftForm(\''+ rowObject.c_dikeycode+ '\' , \'' +diUserkey+ '\');" class="btn18"><span>재기안</span></a></p></div>';
        
        if(linkYN == "Y" || diDocFlag == "001" ){ //연동문서, 접수문서
            str = "";
        }
        
        if(reseq > "00" || diflag == "1") {
            str = "";
        }
       
        return str;
};

/**재기안버튼 (회수함) **/
jqGridUtil.viewReDraftButton2 = function (cellvalue, options, rowObject){        
    var cikind = rowObject.c_cikind;
    var linkYN = rowObject.c_linkyn;
    var diflag = rowObject.c_diflag;
    var diDocFlag = rowObject.c_didocflag;
    var c_tikeycode = rowObject.c_tikeycode;
    var str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:documentUtil.ReDraftForm2(\''+ rowObject.c_dikeycode+ '\');" class="btn18"><span>재기안</span></a></p></div>';
    if(linkYN == "Y" || diDocFlag == "001" )  { //연동문서, 접수문서
        str = "";
    }
/*    
    if(linkYN == "Y" && (cikind == "010" ||  cikind == "011"))  { //G20 결의서 , 품의서
        str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:documentUtil.reDraftG20Chk(\''+ rowObject.c_dikeycode+ '\',\''+ rowObject.c_tikeycode+ '\' );" class="btn18"><span>G20</span></a></p></div>';
    }
    */
    return str;
};
jqGridUtil.viewReDraftButton3 = function (linkYN, diDocFlag, diKeyCode){        
	var str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:documentUtil.ReDraftForm2(\''+ diKeyCode+ '\');" class="btn18"><span>재기안</span></a></p></div>';
	if(linkYN == "Y" || diDocFlag == "001" )  { //연동문서, 접수문서
		str = "";
	}else {
		
	}
	/*    
    if(linkYN == "Y" && (cikind == "010" ||  cikind == "011"))  { //G20 결의서 , 품의서
        str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:documentUtil.reDraftG20Chk(\''+ rowObject.c_dikeycode+ '\',\''+ rowObject.c_tikeycode+ '\' );" class="btn18"><span>G20</span></a></p></div>';
    }
	 */
	return str;
};

/*결재쪽 제목 style 지정 금투 일상감사 의견 달기 위한 부분 */
jqGridUtil.TextOverFlow3 = function (cellvalue, options, rowObject){
	
	var text = rowObject.c_dikeycode;
	jqGridUtil[text] =  rowObject;
	 var reason = rowObject.reasonYn;
	return 	'<DIV onclick="titleOnClick(\''+text+'\',  \'' + reason + '\' , \'' + rowObject.appl_seq+ '\', \'' +rowObject.reqId+ '\', \'' +rowObject.c_ridocnum+ '\')" origindata="'+cellvalue+'"   style="TEXT-OVERFLOW: ellipsis; OVERFLOW: hidden; cursor:pointer" ><NOBR>'+cellvalue+'</NOBR> </DIV>';
};


/**일상감사 의견 등록 버튼  **/
jqGridUtil.ConsultLawViewPopup = function (cellvalue, options, rowObject){        
    var reasonYn = rowObject.reasonYn;

    var str = ''; 
   
	    if(reasonYn =='N'){
	    	str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:RegReason(\''+ rowObject.c_dikeycode+ '\' , \'' +rowObject.reqId+ '\' , \'' + rowObject.appl_seq+ '\', \'' +rowObject.reasonYn+ '\', \'' +rowObject.c_ridocnum+ '\');" class="btn18"><span>의견등록</span></a></p></div>';
	    }else if(reasonYn =='Y' ) {
	    	str = '<div class="layerParent"><p> <a href="javascript:;" onclick="javascript:RegReason(\''+ rowObject.c_dikeycode+ '\' , \'' +rowObject.reqId+ '\' , \'' + rowObject.appl_seq+ '\', \'' +rowObject.reasonYn+ '\', \'' +rowObject.c_ridocnum+ '\');" class="btn18"><span>의견보기</span></a></p></div>';
	    }else if(reasonYn =='E' ) {
	    	str = '<div class="layerParent"><p> </p></div>';
	    }
    
  
    return str;
};

