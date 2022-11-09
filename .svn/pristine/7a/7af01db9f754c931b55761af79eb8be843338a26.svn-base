// JavaScript Document

/* layout */


function conHeight(){
	var winHeight = $(window).height()
	var menuListHeight = $(".lnbArea").outerHeight()
	var headerHeigt= $("#headArea").outerHeight();
	var bottomHeight = $("#footer").outerHeight();
	var fullHeight = $("#articleArea").height()
	var heightNum = winHeight-headerHeigt-bottomHeight
	var conHeight = headerHeigt+bottomHeight
	$("#contentsArea").css("height",heightNum)
//	$("#contents").css("height",winHeight-headerHeigt-18)
	$("#menuArea").css("height",heightNum)	
	$(".treeMenu").css("height",heightNum-menuListHeight-22)	
	$("#subContents").css("height",winHeight-conHeight-35)
}
$(document).ready(function(){	
	conHeight()
})
$(window).resize(function(){
	conHeight()
})
$(document).ready(function(){	
/*
	$(".lnbArea .menuList li a").click(function(){
		$(".treeMenuArea").show()
		$(".menuBtn").show()
		var menuListHeight = $(".lnbArea").outerHeight()
		var fullHeight = $("#contentsArea").height()
		$(".treeMenu").css("height",fullHeight-menuListHeight-22)
	})
*/	
	$(".lnbOpenBtn .btnClose").click(function(){
		$("#articleArea").animate({marginLeft:0})
		$("#menuArea").addClass("active").animate({marginLeft:-212})
		$(".lnbOpenBtn .btnOpen").show()
		return false;
	})
	
	$(".lnbOpenBtn .btnOpen").click(function(){
		$("#articleArea").animate({marginLeft:212})
		$("#menuArea").addClass("active").animate({marginLeft:0})
		$(".lnbOpenBtn .btnOpen").hide()
		return false;
	})
	$(".lnbArea .menuBtn a.close").click(function(){
		$(".lnbArea .menuBtn a.open").show()
		$(".menuList").addClass("active").hide()
		var menuListHeight=$(".menuList").outerHeight()
		var treeMenuHeight = $(".treeMenu").outerHeight()
		$(".treeMenu").css("height",menuListHeight+treeMenuHeight)
		return false;
	})

	$(".lnbArea .menuBtn a.open").click(function(){
		$(this).hide()
		$(".menuList").removeClass("active").show()
		var menuListHeight=$(".menuList").outerHeight()
		var treeMenuHeight = $(".treeMenu").outerHeight()
		$(".treeMenu").css("height",treeMenuHeight-menuListHeight-4)		
		return false;
	})

	$(".menuList li a").click(function(){
		$(".menuList li a").removeClass("active")
		$(this)	.addClass("active");
	})
})


/*$(document).ready(function(){
	var winHeight = $(window).height()
	var headHeight = $("#headArea").height()
	var snbAreaHeight = $("#snbArea").height()
	var footHeight = $("#footer").height()
	var conHeight = headHeight+footHeight
	$("#contentsArea").css("height",winHeight-conHeight)
	$(".treeMenu").css("height",winHeight-conHeight-22)
	$("#subContents").css("height",winHeight-conHeight-35)
	$(window).resize(function(){
		var winHeight = $(window).height()
		var headHeight = $("#headArea").height()
		var footHeight = $("#footer").height()
		var conHeight = headHeight+footHeight
		$("#contentsArea").css("height",winHeight-conHeight)
		$(".treeMenu").css("height",winHeight-conHeight-22)
		$("#subContents").css("height",winHeight-conHeight-35)
	})	
})*/

/* 메인 작동 */
$(document).ready(function(){	
	$(".moneyArea h2 a.btnOpen").click(function(){
		$(".viewLayer").show();
	})
	$(".viewLayer a.btnClose").click(function(){
		$(".viewLayer").hide();
	})
	
	$(".globalMenu .user a.positionBtn").click(function(){
		$(".headerLayer").show();
	})
	
	$(".headerLayer .user a").click(function(){
		$(".headerLayer").hide();
	})
	
	$(".familyLink .linkTitle").click(function(){
		$(this).next().slideDown(80);
	})
	$(".familyLink").mouseleave(function(){
		$(".familyLink ul").slideUp(80);
	})
	
	$(".searchSelect .searchTitle").click(function(){
		$(this).next().slideDown(80);
	})
	$(".searchSelect").mouseleave(function(){
		$(".searchSelect ul").slideUp(80);
	})
	$(".searchSelect ul li").click(function(){
		var textChg = $(this).text()
		$(".searchSelect .searchTitle").text(textChg)
		$(".searchSelect ul").slideUp(80);
	})
	
	$(".searchArea dt").click(function(){
		$(".searchOption").slideDown(80);
	})
	$(".searchOption").mouseleave(function(){
		$(".searchOption").slideUp(80);
	})
	$(".searchOption li").click(function(){
//		var textChg = $(this).text()
//		$(".searchSelect .searchTitle").text(textChg)
//		$(".searchSelect ul").slideUp(80);
	})
	
})

/* 레이아웃 */
$(document).ready(function(){	

	$(".lnbOpenBtn .btnClose").click(function(){
		$("#article").animate({marginLeft:0})
		$("#menuArea").addClass("active").animate({marginLeft:-212})
		$(".lnbOpenBtn .btnOpen").show()
		return false;
	})
	
	$(".lnbOpenBtn .btnOpen").click(function(){
		$("#article").animate({marginLeft:212})
		$("#menuArea").addClass("active").animate({marginLeft:0})
		$(".lnbOpenBtn .btnOpen").hide()
		return false;
	})
	/* 버튼 이미지 오버 컨트롤 */
	$(document).ready(function(){
		$(".quickMenu li a").hover(function(){
			if($(this).hasClass("active")){return false;}
			$(this).find("img").eq(0).attr("src", $(this).find("img").attr("src").replace(".gif", "_on.gif")); 
		},function(){
			if($(this).hasClass("active")){return false;}
			$(this).find("img").eq(0).attr("src", $(this).find("img").attr("src").replace("_on.gif", ".gif")); 
		})
	})
})

$(document).ready(function(){	
	$(".defaultTable tr:even").addClass("graybg")
})

/* 관인선택 */
$(document).ready(function(){	
	$(".stampSelectTable td div").hide();
	$(".stampSelectTable th a").click(function(){
		
		$(".stampSelectTable th a").find("img").attr("src", $(this).find("img").attr("src").replace("_on.gif", ".gif")); 	
		$(this).find("img").attr("src", $(this).find("img").attr("src").replace(".gif", "_on.gif")); 
		$(".stampSelectTable th").removeClass("active")	
		$(this).parent().addClass("active")
		var thisTab = $(".stampSelectTable th a").index(this);
		$(".stampSelectTable td div").hide();
		$(".stampSelectTable td div").eq(thisTab).show();	
	})
})

/* 결재라인보기 */
$(document).ready(function(){	
	var signWidth = $(".signContents li").size()*173;
	$(".signContents ul").css("width",signWidth)
	$(".signContents dl a").mouseover(function(){
		$(this).parent().parent().prev().show()
	})
	$(".signContents li .photoArea").mouseleave(function(){
		$(this)	.find(".hideMenu").hide();
	})
})

/* 텍스트영역 */
$(document).ready(function(){
	$("textarea").focus(function(){
		$(this).css("color","#333")
	})
})

/* 텍스트영역 */
$(document).ready(function(){	
	$(".overBg input,.overBg select").focus(function(){
		$(this)	.addClass("inputBg")
	})
	$(".overBg input,.overBg select").focusout(function(){
		$(this)	.removeClass("inputBg")
	})
})