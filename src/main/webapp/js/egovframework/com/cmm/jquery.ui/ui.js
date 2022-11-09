// JavaScript Document

/* layout */
$(document).ready(function(){
	var winHeight = $(window).height()-120
	var maxheight = $("#articleArea").height()
	var menuListHeight = $(".lnbArea").height()
	$("#articleArea").css("height",winHeight)
	$(".treeMenu").css("height",(winHeight-27)-menuListHeight)	
		$(window).resize(function(){
		var winHeight = $(window).height()-120
		var maxheight = $("#articleArea").height()
		var menuListHeight = $(".lnbArea").height()
		$("#articleArea").css("height",winHeight)	
		$(".treeMenu").css("height",(winHeight-27)-menuListHeight)	
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
}) 