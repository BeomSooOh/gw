// JavaScript Document

/* layout */

function conHeight(){
	var winHeight = $(window).height();
	var menuListHeight = $(".lnbArea").outerHeight();
	var headerHeigt= $("#conHead").outerHeight(); //44
	$("#articleArea").css("height",winHeight-80);
	var fullHeight = $("#articleArea").height();
	$("#contents").css("height",winHeight-headerHeigt-18);
	$("#menuArea").css("height",winHeight-80)	;
	$(".treeMenu").css("height",fullHeight-menuListHeight-16)	;
}
$(document).ready(function(){	
	conHeight();
});
$(window).resize(function(){
	conHeight();
});
$(document).ready(function(){	
	$(".lnbArea .menuList li a").click(function(){
		$(".treeMenuArea").show();
		$(".menuBtn").show();
		var menuListHeight = $(".lnbArea").outerHeight();
		var fullHeight = $("#articleArea").height();
		$(".treeMenu").css("height",fullHeight-menuListHeight-16);
	});
	$(".lnbOpenBtn .btnClose").click(function(){
		$("#articleArea").animate({marginLeft:0});
		$("#menuArea").addClass("active").animate({marginLeft:-212});
		$(".lnbOpenBtn .btnOpen").show();
		return false;
	});
	
	$(".lnbOpenBtn .btnOpen").click(function(){
		$("#articleArea").animate({marginLeft:212});
		$("#menuArea").addClass("active").animate({marginLeft:0});
		$(".lnbOpenBtn .btnOpen").hide();
		return false;
	});
	$(".lnbArea .menuBtn a.close").click(function(){
		$(".lnbArea .menuBtn a.open").show();
        $(".lnbArea .menuBtn span.closetxt").hide();
        $(".lnbArea .menuBtn span.opentxt").show();
		$(".menuList").addClass("active").hide();
		var menuListHeight=$(".menuList").height();
		var treeMenuHeight = $(".treeMenu").height();
		$(".treeMenu").css("height",menuListHeight+treeMenuHeight+0);
		return false;
	});

	$(".lnbArea .menuBtn a.open").click(function(){
		$(this).hide();
		$(".menuList").removeClass("active").show();
        $(".lnbArea .menuBtn span.opentxt").hide();
        $(".lnbArea .menuBtn span.closetxt").show();
		var menuListHeight=$(".menuList").height();
		var treeMenuHeight = $(".treeMenu").height();
		$(".treeMenu").css("height",treeMenuHeight-menuListHeight-0);
		return false;
	});

	$(".menuList li a").click(function(){
		$(".menuList li a").removeClass("active");
		$(this)	.addClass("active");
	});
});

/* 월별일정 달력*/
$(document).ready(function(){
	var tableHeight = ($("#articleArea").height()-175) / 5 ;
	$(".monthSch td").css("height",tableHeight);
	$(".monthSch .today div").css("height",tableHeight-2);
	$(window).resize(function(){
		var tableHeight = ($("#articleArea").height()-175) / 5;
		$(".monthSch td").css("height",tableHeight);
		$(".monthSch .today div").css("height",tableHeight-2);
	});
	
	var tableHeight01 = ($("#articleArea").height()-220);
	$(".todaySchArea").css("height",tableHeight01);
	$(window).resize(function(){
		var tableHeight01 = ($("#articleArea").height()-220);
		$(".todaySchArea").css("height",tableHeight01);
	});
}) ;

/* 체크박스 */
$(document).ready(function(){
	$(".typeSelect li a").click(function(){
		$(this)	.toggleClass("active");
	});
});


/* 텍스트영역 */
$(document).ready(function(){
	$("textarea").focus(function(){
		$(this).css("color","#333");
	});
});


/* 메인 페이지 */
$(document).ready(function(){	
	var winHeight = $(window).height()-265;
	$(".bbsList").css("height",winHeight);
	$(window).resize(function(){
		var winHeight = $(window).height()-265;
		$(".bbsList").css("height",winHeight);
	});
});
$(document).ready(function(){	
	$(".bbsList li:even").addClass("graybg");
});
$(document).ready(function(){	
	$(".globalMenu .user a.infoBtn").click(function(){
		$(".headerLayer").show();
	});
	$(".headerLayer a.btnClose").click(function(){
		$(".headerLayer").hide();
	});
	$(".schedule a.btn_register").click(function(){
		$(".schedule_register").show();
	});
	$(".schedule_register a.btnClose").click(function(){
		$(".schedule_register").hide();
	});
	
});

/* 테이블 */

$(document).ready(function(){	
	$(".defaultTable tr:even").addClass("graybg");
});

/* 관인선택 */
$(document).ready(function(){	
	$(".stampSelectTable td div").hide();
	$(".stampSelectTable th a").click(function(){
		
		$(".stampSelectTable th a").find("img").attr("src", $(this).find("img").attr("src").replace("_on.gif", ".gif")); 	
		$(this).find("img").attr("src", $(this).find("img").attr("src").replace(".gif", "_on.gif")); 
		$(".stampSelectTable th").removeClass("active");
		$(this).parent().addClass("active");
		var thisTab = $(".stampSelectTable th a").index(this);
		$(".stampSelectTable td div").hide();
		$(".stampSelectTable td div").eq(thisTab).show();	
	});
});

/* 결재라인보기 */
$(document).ready(function(){	
	var signWidth = $(".signContents li").size()*173;
	$(".signContents ul").css("width",signWidth);
	$(".signContents dl a").mouseover(function(){
		$(this).parent().parent().prev().show();
	});
	$(".signContents li .photoArea").mouseleave(function(){
		$(this).find(".hideMenu").hide();
	});
});

/* 단위업무등록 */
$(document).ready(function(){	
	$(".use_yes").click(function(){
		$(".transTime").show();
		
	});
	$(".use_no").click(function(){
		$(".transTime").hide();
		
	});
	$(".check_use").click(function(){
		$(".workTable").show();
		
	});
	$(".check_notuse").click(function(){
		$(".workTable").hide();
		
	});
});


/* 푸터 */
$(document).ready(function(){	
	$(".footRightMenu a.direct").click(function(){
		$(this).next().show();
	});
	$(".linkList").mouseleave(function(){
		$(this).hide();
	});
	$(".family a.btn_family").click(function(){
		$(".familyList").show();
	});
	$(".familyList").mouseleave(function(){
		$(this).hide();
	});
});

/* 전자결재 문서검색 */


$(document).ready(function(){	
	$(".searchArea .documentSearchBtn a").click(function(){
		$(".documentSearch").toggle();
		$(".searchArea .documentSearchBtn a").toggle();
	});
	$(".documentSearch a.btnClose").click(function(){
		$(".documentSearch").hide();
		$(".searchArea .documentSearchBtn a").hide();
		$(".searchArea .documentSearchBtn a:eq(0)").show();
	});
});

$(document).ready(function(){	
	$(".detailSearchBtn a").click(function(){
		$(".detailSearch").toggle();
		$(".detailSearchBtn a").toggle();
	});
	$(".detailSearch a.btnClose").click(function(){
		$(".detailSearch").hide();
		$(".detailSearchBtn a").hide();
		$(".detailSearchBtn a:eq(0)").show();
	});
});

/* ess 달력 테이블 */
function callenderHeight(){
	var headerHeigt= $("#conHead").outerHeight(); //44
	var tableHeader= $(".scheduleHead").outerHeight();
	var infobox= $(".defaulltInfoBox").outerHeight()+50;
	var tableHeight = ($("#contents").height()-headerHeigt-tableHeader-infobox) / 5;
	$(".essCallender td").css("height",tableHeight);
	$(".essCallender td div").css("height",tableHeight);
	$(".essCallender .today div").css("height",tableHeight-2);
//	$(".essCallender td .workResult").css({height:tableHeight/3})
//	$(".essCallender td .workResult").css({line_height:30})
}

$(document).ready(function(){
	callenderHeight();
});
$(window).resize(function(){
	callenderHeight();
});


/* admin table */
$(document).ready(function(){	
	$(".table_admin02 tr:even td").addClass("bg01");
});
