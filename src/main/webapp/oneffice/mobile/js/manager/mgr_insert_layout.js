/*
 * 
 */

var insertLayoutMgr = {
	objBodyScroll: null,
	
	init: function() {
		if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
			$("#one_custom_page").width("").height("");
		}
		
		$("#one_custom_page header .btn_check").addClass("disabled");
		
		$("#id_insert_layout").height("calc(100% - 56px)");
		
		var objTemplateGrid = $("#template_grid");
		
		var nItemWidth = Math.round(objTemplateGrid.width() * 0.31);
		var nItemHeight = Math.round(nItemWidth * 1.06);
		var nSpace = Math.round(objTemplateGrid.width() * 0.03);
		
		objTemplateGrid.find(".template").css({height: nItemHeight, "margin-bottom": nSpace});
		objTemplateGrid.parent("td").css({"padding-top": nSpace * 3, "padding-bottom": nSpace * 3});
		
		this.objBodyScroll = new iScroll('id_insert_layout', {"hScroll":false, "vScroll":true, "vScrollbar":false, "mousewheel":false});
		
		this.addListener();
		
//		$("#custom_content").height($("#id_insert_layout table").eq(0).height());
		
		setTimeout(function() {
			insertLayoutMgr.objBodyScroll.refresh();
		}, 300);
	},
	
	addListener: function() {
		try {
			var objTemplate = $("#template_grid .template");
			
			objTemplate.click(function() {
				if ($(this).hasClass("selected") === true) {
					return;
				}
				
				objTemplate.removeClass("selected");
				$(this).addClass("selected");
				
				$("#one_custom_page .head .btn_check").removeClass("disabled");
			});
		} catch (e) {
			dalert(e);
		}
	},
	
	confirm: function() {
		try {
			var nIndex = $("#template_grid .template.selected").attr("index") * 1;
			
			if (isNaN(nIndex) === true) {
				return false;
			}
			
			sendIFrameMessage("insertLayout", {index: nIndex}, false);
			
			return true;
		} catch (e) {
			dalert(e);
		}
	}
};