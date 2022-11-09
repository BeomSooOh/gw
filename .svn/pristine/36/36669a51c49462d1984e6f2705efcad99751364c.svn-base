/*
 * 
 */

onefficeApp.controller("ctrl_slideshow", function($scope, $timeout) {
	
	$scope.strTitleText = "";
	$scope.currentSlidePage = 1;
	$scope.totalSlideNum = 1;
	$scope.showContoller = true;
	$scope.$on("initSlideShow", function(event) {
		$scope.initPage();
	});
	
	$scope.initSlideshow = function() {
		var objSlideshow = $("#one_slideshow");
		objSlideshow.trigger("create");
		objSlideshow.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
		
		var objSection = objSlideshow.find("section");
		objSection.height("calc(100% - " + (56 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)");
		
		$scope.initPage();
		
		$scope.$parent.viewChange(5);
	};
	
	$scope.initPage = function() {
		try {
			setSwipeControll();
			$("div.dialog_layer_wrap").show();
			var objParam = {"hybrid": "hApp","bSlide":"true"};
			
//			var iFrame = $("#iFrame_Slider");
//			var openURL = oneffice.getViewModeDocPath($scope.docDataFact.checklist[0].seq, objParam);
			//iFrame.attr("src", openURL);
			$timeout(function(){  	$("#dzeditor_1").scope().fnloadView($scope.$parent.objCurrentDoc.seq, 1);    },100)
			
			$scope.strTitleText = $scope.$parent.objCurrentDoc.docData.strTitle;
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.setTotalSlideNum = function(num) {
		$scope.totalSlideNum = num;
		updateView($scope);
	}
	
	$scope.setCurrentSlideNum = function(num) {
		$scope.currentSlidePage = num;
		updateView($scope);
	};
	
	$scope.goPageMoveFunc = function(pNum) {
		
		var aaa = $("#dzeditor_1").scope();
		$("#dzeditor_1").scope().goPageMoveSlider(pNum);
//		if(iFrameSlider && iFrameSlider.contentWindow) {
//			iFrameSlider.contentWindow.postMessage({uiEvent: 'slideGo', uiEventData:pNum}, "*");
//		}
	};
	
	$scope.moveBack = function() {
		try {
			$(".left_div, .center, .right_div").show();
			$("#pageNavigator").show();
			$(".head").css('background', '#ffffff');
			$(".head").css('border-bottom', '1px solid rgba(0, 0, 0, 0.1)');
			
			$scope.cancel();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancel = function() {
		try {
			if ($scope.$parent.bOnViewStatus == true) {
				$scope.$parent.viewChange(3);
				
			} else {
				$scope.$parent.viewChange(0);
			}
			g_nActiveEditNumber = 0;
			g_objPageControl.nEditNumber = 0;
			var vmode = $("#one_viewer").scope().viewerMode;
			g_readonlyMode = vmode === 'viewerMode'?true:false;
			$("div.dialog_layer_wrap").hide();
			$("#pageSelector").off('click');
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.nextPageMove = function(){
		if(parseInt($scope.currentSlidePage)<parseInt($scope.totalSlideNum)){
    		$scope.currentSlidePage = parseInt($scope.currentSlidePage)+1
    		$scope.goPageMoveFunc($scope.currentSlidePage);
    	}
	}
	$scope.prevPageMove = function(){
		if(parseInt($scope.currentSlidePage)>1){
    		$scope.currentSlidePage = parseInt($scope.currentSlidePage)-1
    		$scope.goPageMoveFunc($scope.currentSlidePage);
    	}
	}
	var setSwipeControll = function(){
		
		$("#pageSelector").click( function() {
			$scope.showContoller = $scope.showContoller?false:true;
			if($scope.showContoller){
				$(".left_div, .center, .right_div").show();
				$("#pageNavigator").show();
				$(".head").css('background', '#ffffff');
				$(".head").css('border-bottom', '1px solid rgba(0, 0, 0, 0.1)');
			}else{
				$(".left_div, .center, .right_div").hide();
				$("#pageNavigator").hide();
				$(".head").css('background', '#888888');
				$(".head").css('border-bottom', 'none');
			}
			
//			console.log($scope.showContoller);
		} );
		
		$("#pageSelector").swipe({
			swipe: function(event, direction, distance, duration, fingerCount) {
		        switch(direction) {
		            case "left":
		            	$scope.nextPageMove();
		        		updateView($scope);
		                break;
		            case "right":
		            	$scope.prevPageMove();
		        		updateView($scope);
		                break;           
		        }        
		    }
			
		});
	}
});
