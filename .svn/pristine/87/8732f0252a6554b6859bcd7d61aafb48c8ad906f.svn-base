/*
 * 
 */

onefficeApp.controller("ctrl_main", function($scope, docDataFact) {
	
	$scope.myInfo = {};
	$scope.docDataFact = docDataFact;
	$scope.strPageType = "";
	$scope.currentViewPage = "one_home";
	
	$scope.bViewerPageLoad = false;
	$scope.bOnViewStatus = false;
	$scope.bOnNewEditMode = false;
	
	$scope.objCurrentDoc = null;		// 열람, 편집중 또는 선택된 문서 정보
	$scope.objOpenInInfo = null;		// 외부에서 링크로 들어오는 문서 정보
	
	$scope.initMain = function() {
		try {
			
			
			var nStartX;
			
			$("#mainContainer")[0].addEventListener("touchstart", function(event) {
				if (event.touches.length > 1) {
					event.preventDefault();
				} else {
					if (g_browserCHK.iOS === true) {
						nStartX = event.touches[0].clientX;
						
						if (nStartX > 20) {
							nStartX = null;
						}
					}
				}
			}, {passive: false});
			
			$("#mainContainer")[0].addEventListener("touchend", function(event) {
				if (g_browserCHK.iOS !== true || nStartX === null) {
					return;
				}
				
				var objTarget = $(event.target);
				
				if (objTarget.parents("#id_template_doc_scroll").length > 0
						|| objTarget.parents("#one_viewer").length > 0
						|| objTarget.parents("#one_slideshow").length > 0) {
					nStartX = null;
					return;
				}
				
				if (event.changedTouches[0].clientX - nStartX > 30) {
					moveBack();
					
					nStartX = null;
				}
			}, {passive: false});
		} catch (e) {
			dalert(e);
		}
	}
	
	$scope.setEditMode = function(cmd){
		$scope.bOnNewEditMode = cmd;
	}
	
	$scope.viewChange = function(nViewType) {
		/*
		 *	nViewType	0: home,	1: security,	2: share,	3: viewer,	4: custom,	5: slideshow,	6: template
		 */
		try {
			var strId;
			var objNext;
			var activeCount = $(".ui-page-active").length;
					
			switch (nViewType) {
				case 0:
					strId = "one_home";
					break;
					
				case 1:
					strId = "one_scty";
					break;
					
				case 2:
					strId = "one_share";
					break;
					
				case 3:
					strId = "one_viewer";
					
					if ($scope.bOnViewStatus === false) {
						$scope.currentViewPage = strId;
						$scope.bOnViewStatus = true;
					}
					
					break;
					
				case 4:
					strId = "one_custom_page";
					break;
					
				case 5:
					strId = "one_slideshow";
					break;
					
				case 6:
					strId = "one_template";
					break;
					
				case 7:
					strId = "one_comment";
					break;
					
				case 8:
					strId = "one_docinfo";
					break;
					
				default:
					return;
			}
			
			updateView($scope);
			
			objNext = $("#" + strId);
			
			if (strId === "one_home") {
				objNext.css("opacity", 1).addClass("ui-page-active");
				
				$(".ui-page-active").each(function(index, item) {
					if (item.id !== strId) {
						var objCurrent = $(item);
						
						if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
							objCurrent.animate({left: ("+=" + objCurrent.width() + "px"), opacity: 0}, 300, after);
						} else {
							objCurrent.css({position: "absolute", left: "0px", opacity: 1})
									.animate({left: ("+=" + objCurrent.width() + "px"), opacity: 0}, 300, after);
						}
						
						function after() {
							$scope.currentViewPage = strId;
							
							if (item.id === "one_viewer") {
								$scope.bViewerPageLoad = false;
								$scope.bOnViewStatus = false;
							}
							
							if (item.id !== "one_docinfo") {
								objNext.scope().doRefresh();
							}
							
							updateView($scope);
						}
					}
				});
				
				var homeScope = $("#one_home").scope();
				
				if (fnObjectCheckNull(homeScope) === false) {
					homeScope.onResizeProc();	    
				}
			} else {
				if ($scope.bOnViewStatus === true && strId == "one_viewer" && activeCount > 1) {
					// doc viewer에서 다른 view를 보다가 다시 doc viewer로 돌아오는 경우
					objNext.addClass("ui-page-active");
					
					$(".ui-page-active").each(function (index, item) {
						var objCurrent = $(item);
						
						if (item.id !== strId) {
							if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
								objCurrent.animate({left: ("+=" + objCurrent.width() + "px"), opacity: 0}, 300, after);
							} else {
								objCurrent.css({position: "absolute", left: ""})
										.animate({left: ("+=" + objCurrent.width() + "px"), opacity: 0}, 300, after);
							}
							
							function after() {
								$scope.currentViewPage = strId;
								
								updateView($scope);
							}
						}
					});
				} else {
					// doc viewer에서 다른 view를 호출하는 경우
					objNext.addClass("ui-page-active");
					
					if ($scope.strPageType === "sendReport" || $scope.strPageType === "getReport") {
						setTimeout(function() {
							showView();
						}, 100);
					} else {
						showView();
					}
					
					function showView() {
						objNext.css({position: "absolute", left:("+=" + objNext.width() + "px"), opacity: 0})
								.animate({left: ("-=" + objNext.width() + "px"), opacity: 1}, 300, function() {
									objNext.css({position: "", left: ""});
									
									$(".ui-page-active").each(function(index, item) {
										if (strId === "one_viewer" && item.id === "one_home") {
											$(item).removeClass("ui-page-active");
										}
									});
									
									updateView($scope);
								});
					};
				}
			}
		} catch (e) {
			dalert(e);
		}
	};
	
	$(window).on('orientationchange', function (event) {
		try {
			if (event.type === "orientationchange") {
				this.orientation = event.orientation;
			}
			
			if (g_browserCHK.iPad === true || g_browserCHK.androidtablet === true) {
				// 태블릿에서 가상키보드 뜨는 경우 다이얼로그 사이즈 조정 필요
				var objCommentScope = $("#one_comment").scope();
				
				if (fnObjectCheckNull(objCommentScope) === false) {
					setTimeout(function() {
						objCommentScope.onResizeProc();
					}, 500);
				}
			}
		} catch (e) {
			dalert(e);
		}
	});
	
	$(window).on('resize', function (event) {
		setTimeout(function () {
			if (g_browserCHK.iPad || g_browserCHK.androidtablet) {
				$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, #one_template, #dzeditor_0, #dzeditor_1,#sliderFrame, #totalPageContainerSlider, #one_comment, #one_docinfo").width($(window).width());
				$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, .side, .side_right, #one_template , #dzeditor_0, #dzeditor_1, #viewer_section, #sliderFrame, #totalPageContainerSlider, #one_comment, #one_docinfo").height($(window).height());
			} else {
				$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, #one_template, #sliderFrame, #totalPageContainerSlider, #one_comment, #one_docinfo").width($(window).width());
				$("#mainContainer, #one_home, #one_scty, #one_share, #one_viewer, #one_custom_page, #one_slideshow, .side, .side_right, #one_template ,#viewer_section, #sliderFrame, #totalPageContainerSlider, #one_comment, #one_docinfo").height($(window).height());
			}
		}, 1);
		
		if (event.type === "resize" && g_browserCHK.galaxyfold === true) {
			g_browserCHK.galaxyfold_open = ($(window).width() > 374);
		}
		
		var homeScope = $("#one_home").scope();
		
		if (fnObjectCheckNull(homeScope) === false) {
			homeScope.onResizeProc();
		}
		
		var viewScope = $("#one_viewer").scope();
		
		if (fnObjectCheckNull(viewScope) === false) {
			viewScope.onResizeProc();
			
			var slideScope = $("#dzeditor_1").scope();
			var editorScope = $("#dzeditor_0").scope();
			
			if(fnObjectCheckNull(slideScope) === false) {
				setTimeout(function () {
					slideScope.onResizeProc();
				}, 100);
			}
			
			if(fnObjectCheckNull(editorScope) === false) {
				setTimeout(function () {
					editorScope.onResizeProc();
				}, 100);
			}
		}
		
		if (g_browserCHK.iPad === true || g_browserCHK.androidtablet === true) {
			// 태블릿에서 가상키보드 뜨는 경우 다이얼로그 사이즈 조정 필요
			var objCommentScope = $("#one_comment").scope();
			
			if (fnObjectCheckNull(objCommentScope) === false) {
				objCommentScope.onResizeProc();
			}
		}
	});
});
