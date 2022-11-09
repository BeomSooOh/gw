var IE = false ;

if (window.navigator.appName.indexOf("Explorer") !=-1){
	IE = true;
}


function resizeIfr(obj, minHeight) {
	minHeight = minHeight || 10;
	try {
		var getHeightByElement = function(body) {
			var last = body.lastChild;
			try {
				while (last && last.nodeType != 1 || !last.offsetTop) last = last.previousSibling;
				return last.offsetTop+last.offsetHeight;
			} catch(e) {
				return 0;
			}

		}

		var doc = obj.contentDocument || obj.contentWindow.document;
		if (doc.location.href == 'about:blank') {
			obj.style.height = minHeight+'px';
			return;
		}

		if (/MSIE/.test(navigator.userAgent)) {
			var h = doc.body.scrollHeight;
		} else {
			var s = doc.body.appendChild(document.createElement('DIV'))
			s.style.clear = 'both';

			var h = s.offsetTop;
			s.parentNode.removeChild(s);
		}

		if (h < minHeight) h = minHeight;

		obj.style.height = h + 'px';
		if (typeof resizeIfr.check == 'undefined') resizeIfr.check = 0;
		if (typeof obj._check == 'undefined') obj._check = 0;

		setTimeout(function(){ resizeIfr(obj,minHeight) }, 200); // check 5 times for IE bug
	} catch (e) {
	console.log(e);//오류 상황 대응 부재
		//alert(e);
	}
}
function resizeIfrWithoutTimer(obj, minHeight) {
	minHeight = minHeight || 10;
	try {
		var getHeightByElement = function(body) {
			var last = body.lastChild;
			try {
				while (last && last.nodeType != 1 || !last.offsetTop) last = last.previousSibling;
				return last.offsetTop+last.offsetHeight;
			} catch(e) {
				return 0;
			}

		}

		var doc = obj.contentDocument || obj.contentWindow.document;
		if (doc.location.href == 'about:blank') {
			obj.style.height = minHeight+'px';
			return;
		}

		if (/MSIE/.test(navigator.userAgent)) {
			var h = doc.body.scrollHeight;
		} else {
			var s = doc.body.appendChild(document.createElement('DIV'))
			s.style.clear = 'both';

			var h = s.offsetTop;
			s.parentNode.removeChild(s);
		}

		if (h < minHeight) h = minHeight;

		obj.style.height = h + 'px';
		if (typeof resizeIfr.check == 'undefined') resizeIfr.check = 0;
		if (typeof obj._check == 'undefined') obj._check = 0;

	} catch (e) {
	console.log(e);//오류 상황 대응 부재
		//alert(e);
	}
}

function reSize() {
	var ParentFrame	    =	ifrm_comment.document.body;
	var ContentFrame	=	document.all["ifrm_comment"];
	ContentFrame.style.height = ParentFrame.scrollHeight + (ParentFrame.offsetHeight + ParentFrame.clientHeight) + 100;
}

function paperInit()
{
	parent.reSize();
}
