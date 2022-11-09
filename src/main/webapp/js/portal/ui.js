// JavaScript Document

/* layout */
$(document).ready(function(){
	
	//alert($(window).height()+":"+$("#header").height()+":"+$("#footer").height());
	if($("#wrapper").length > 0)
	{
		var winHeight = $(window).height()-120;
		var menuListHeight = $(".lnbArea").height();
		$(".treeMenu").css("height",(winHeight)-menuListHeight-30);	
		$("#menuArea").css("height",winHeight+22);
		
		$("#contentsArea").css("height", $(window).height()-70-29);
		$("#articleArea").css("height", $(window).height()-70-25);
	
		$(window).resize(function(){
			var winHeight = $(window).height()-120;
			var maxheight = $("#articleArea").height();
			var menuListHeight = $(".lnbArea").height();
			$(".treeMenu").css("height",(winHeight)-menuListHeight);	 //-30
			$("#menuArea").css("height",winHeight+22);
			
			//$("#_content")[0].contentWindow.iframe_resize();
			$("#contentsArea").css("height", $(window).height()-70-29);
			$("#articleArea").css("height", $(window).height()-70-25);
		});
		
		
	}

});



$(document).ready(function(){	
	$(".lnbArea .menuList li a").click(function(){
		
		$(".treeMenuArea").show()
		
		$(".menuBtn").show()
	})
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
		var menuListHeight=$(".menuList").height()
		var treeMenuHeight = $(".treeMenu").height()
		$(".treeMenu").css("height",menuListHeight+treeMenuHeight+11)
		return false;
	})

	$(".lnbArea .menuBtn a.open").click(function(){
		$(this).hide()
		$(".menuList").removeClass("active").show()
		var menuListHeight=$(".menuList").height()
		var treeMenuHeight = $(".treeMenu").height()
		$(".treeMenu").css("height",treeMenuHeight-menuListHeight-15)		
		return false;
	})

	$(".menuList li a").click(function(){
		$(".menuList li a").removeClass("active")
		$(this)	.addClass("active");
	})
})

/* 월별일정 달력*/
$(document).ready(function(){
	var tableHeight = ($("#articleArea").height()-175) / 5
	$(".monthSch td").css("height",tableHeight)
	$(".monthSch .today div").css("height",tableHeight-2)
	$(window).resize(function(){
		var tableHeight = ($("#articleArea").height()-175) / 5
		$(".monthSch td").css("height",tableHeight)
		$(".monthSch .today div").css("height",tableHeight-2)
	})
	
	var tableHeight01 = ($("#articleArea").height()-220)
	$(".todaySchArea").css("height",tableHeight01)
	$(window).resize(function(){
		var tableHeight01 = ($("#articleArea").height()-220)
		$(".todaySchArea").css("height",tableHeight01)
	})
}) 

/* 체크박스 */
$(document).ready(function(){
	$(".typeSelect li a").click(function(){
		$(this)	.toggleClass("active")
	})
})


/* 텍스트영역 */
$(document).ready(function(){
	$("textarea").focus(function(){
		$(this).css("color","#333")
	})
})


/* 메인 페이지 */
$(document).ready(function(){
/*
	var winHeight = $(window).height()-355
	$(".bbsList").css("height",winHeight)
	$(window).resize(function(){
		var winHeight = $(window).height()-355
		$(".bbsList").css("height",winHeight)
	})
*/
})
$(document).ready(function(){	
	$(".bbsList li:even").addClass("graybg")
})
$(document).ready(function(){	
	$(".globalMenu .user a.infoBtn").click(function(){
		$(".headerLayer").show();
	})
	$(".headerLayer a.btnClose").click(function(){
		$(".headerLayer").hide();
	})
	$(".schedule a.btn_register").click(function(){
		$(".schedule_register").show();
	})
	$(".schedule_register a.btnClose").click(function(){
		$(".schedule_register").hide();
	})
	
})

/* 테이블 */

$(document).ready(function(){	
	$(".defaultTable tr:even").addClass("graybg")
})