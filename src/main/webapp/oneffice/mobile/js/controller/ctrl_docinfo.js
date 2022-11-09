/*
 * 
 */

onefficeApp.controller("ctrl_docinfo", function($scope,$timeout) {
	
	$scope.docTitle = "";
	$scope.docOwner = "";
	$scope.docCreateDate = "";
	$scope.docModifiyDate = "";
	$scope.docSize = "";
	$scope.initDocinfo = function() {
    	try {
    		
    		$("div.dialog_layer_wrap").show();
    		
			var objDocinfo = $("#one_docinfo");
			
			objDocinfo.trigger("create");
			objDocinfo.addClass("ui-page ui-page-theme-a").css({background: "#fff", "z-index": 101});
			
			var objSection = objDocinfo.find("section");
			objSection.height("calc(100% - " + (56 + parseInt(objSection.css("padding-top"), 10) + parseInt(objSection.css("padding-bottom"), 10)) + "px)");
			
			$scope.$parent.viewChange(8);
			
			
			$scope.objDocInfo = $scope.$parent.objCurrentDoc;
			$scope.docTitle = $scope.objDocInfo.docData.strTitle;
			$scope.docOwner = $scope.objDocInfo.userData.strOwnerName;
			if($scope.docOwner ==="") $scope.docOwner = $("#mainContainer").scope().myInfo.name;
			$scope.docCreateDate = $scope.objDocInfo.docData.strCreatedDate;
			$scope.docModifiyDate = $scope.objDocInfo.docData.strModifiedDate;
			var _size = Number($scope.objDocInfo.docData.nContentSize);
			var _unit = _size>1000?"KB":"byte";
			_size = _size>1000?_size/1000:_size;
			
			
			$scope.docSize = _unit=="KB"?_size.toFixed(2):_size.toFixed(0);
			$scope.docSizeUnit = _unit;
			$("#one_docinfo .modal").click(function () {
				$(".action_div").removeClass("on");
				$(this).hide();
				
			});
			
    	} catch (e) {
    		dalert(e);
    	}
	};
	
	$scope.moveBack = function() {
		try {
			$scope.cancelComment();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.cancelComment = function() {
		try {
			if($scope.$parent.bOnViewStatus == true)
				$scope.$parent.viewChange(3);
			else
			$scope.$parent.viewChange(0);
			$("div.dialog_layer_wrap").hide();
		} catch (e) {
			dalert(e);
		}
	};
	
	$scope.getThumnailImg = function(){
		var resPath = "../mobile/images/ico/icon_thumb_file_oneffice.png";
		
		if ($scope.objDocInfo.docData.strThumbnail.length === 0
				|| fnObjectCheckNull(mobile_http.hybridBaseData) === true) {
			return resPath;
		}
		
		return ( mobile_http.getProtocolUrl("P018")+"?seq="+$scope.objDocInfo.docData.strThumbnail+"&pathSeq=1600&token="+mobile_http.hybridBaseData.header.token);
		//return ('http://' + mobile_http.hybridBaseData.result.compDomain + '/upload/onefficeFile/' + $scope.myInfo.id + '/' + doc.seq + '/' + doc.docData.strThumbnail);
	};
});
