/**
 *
 * portal.js 파일
 *
 */


//	날짜, 시간관련
//	기본형식 YYYY-MM-DD HH-MI-SS
function getPortalDate(strDate, kind)
{
	var tempDate = strDate.split(' ');
	var retValue = '';
	if(kind == 'date')
	{
		retValue = tempDate[0];
	}else if(kind == 'time')
	{
		retValue = tempDate[1];
	}
	return retValue;
}
function getDateType(strDate)
{
	var arrDate = getPortalDate(strDate, 'date').split('-');
	var arrTime = getPortalDate(strDate, 'time').split(':');
	if(arrTime.length < 3)
	{
		arrTime[2] = '00';
	}
	return new Date(Number(arrDate[0]), Number(arrDate[1]) - 1, Number(arrDate[2]), Number(arrTime[0]), Number(arrTime[1]), Number(arrTime[2]));	
}
function getCalDays(date1, date2, sec)
{
	var dateType1 = 0;
	var dateType2 = 0;
	if(typeof(date1) == 'object')
	{
		dateType1 = date1.getTime();
	}else
	{
		dateType1 = getDateType(date1).getTime();
	}
	if(typeof(date2) == 'object')
	{
		dateType2 = date2.getTime();
	}else
	{
		dateType2 = getDateType(date2).getTime();
	}
	
	var postTime = 0;
	if(typeof(sec) == 'undefined')
	{
		postTime = 24 * 60 * 60;
	}else
	{
		postTime = sec;
	}

	return Math.floor((dateType2 - dateType1) / (postTime * 1000));
}



//	모달 팝업 - 배경
$(document).ready(function(){
	var popUpDivBG = document.createElement("div");
	$(popUpDivBG).attr("id", "popUpDivBG");	
	document.body.appendChild(popUpDivBG);
	$("#popUpDivBG").css("position", "absolute");
	$("#popUpDivBG").css("left", "0");
	$("#popUpDivBG").css("top", "0");
	$("#popUpDivBG").css("width", "100%");
	$("#popUpDivBG").css("height", "100%");
	$("#popUpDivBG").css("z-index", "50");
	$("#popUpDivBG").css("background-color","#000000");
	$("#popUpDivBG").css("opacity", "0.25");
	$("#popUpDivBG").css("display", "none");
});

$(window).scroll(function(){
	if($("#popUpDivBG"))
	{
		$("#popUpDivBG").css("top", $(window).scrollTop() + 'px');
	}	
});


function openPopupBG()
{
	$("#popUpDivBG").css("top", $(window).scrollTop() + 'px');
	$("#popUpDivBG").css("display", "block");
}

function closePopupBG()
{
	$("#popUpDivBG").css("display", "none");
}


//	================================================================
//	대상리스트선택 - 팝업 열기 시작
//	================================================================
var txtMemberListId = '';
function selectMemberList(txtId, kindCode, orgId)
{
	txtMemberListId = txtId;
//	새창 오픈
	var newWinName = "newWin";	
	var newWin = window.open("", newWinName, "width=530,height=525,toolbar=no,scrollbar=no,resizable=no,status=no");
	newWin.window.focus();
	var form = frmCreate("frmSelectMemberList", "POST", _g_contextPath_ + "/cmm/system/MemberSelect.do");
	form.target = newWinName;
	form = frmAppendHidden(form, "openerCode", "0");	//	0: 새창 1: 내부 iframe
	form = frmAppendHidden(form, "kindCode", kindCode);	//	0: 기관, 부서, 사용자 1:기관, 부서
	form = frmAppendHidden(form, "memberList", getSelectMemberList());
	form = frmAppendHidden(form, "gubunList", getSelectGubunList());
	form = frmAppendHidden(form, "nameList", getSelectNameList());
	form = frmAppendHidden(form, "rootCode", orgId);	
	document.body.appendChild(form);
	form.submit();
	document.body.removeChild(form);	
//	내부 iframe 오픈

}
function addSelectMemberList(tempMemberList)
{
	var strName = '';
	var strId = '';
	for(var i=0; i<tempMemberList.length; i++)
	{
		if(i > 0)
		{
			strId += ',';
			strName += ',';	
		}
		strId += tempMemberList[i].id;
		strName += tempMemberList[i].name;
	}
	$("#" + txtMemberListId).val(strId);
	$("#" + txtMemberListId + "View").val(strName);
}


function getSelectMemberList()
{   
	return $("#" + txtMemberListId+"_id").val(); 
}

function getSelectGubunList()
{   
	return $("#" + txtMemberListId+"_div").val(); 
}

function getSelectNameList()
{   
	return $("#" + txtMemberListId+"_nm").val(); 
}

//	================================================================
//	대상리스트선택 - 팝업 열기 끝
//	================================================================

//	================================================================
//	선택 설정 시작
//	================================================================
/*	코드 구조
	<div class="useLayer">
		<span id="result1" onclick="javascript:displaySelectUse(this);">공개</span>
		<ul class="selectUse" style="display:none">
			<li><a href="javascript:;" onclick="javascript:selectUse(this);">공개</a></li>
			<li><a href="javascript:;" onclick="javascript:selectUse(this);">비공개</a></li>
		</ul>
	</div> 
*/
function displaySelectUse(obj)
{
	var siblings = $(obj).siblings();
	$.each(siblings, function(index, item)
	{
		if($(item).css("display") == "none")
		{
			$(item).show();
		}else
		{
			$(item).hide();	
		}					
	});
}
function selectUse(obj, cbMethod)
{
	var text = $(obj).text();
	var parent = $(obj).parent().parent();
	var siblings = $(parent).siblings();
	$.each(siblings, function(index, item)
	{		
		$(item).text(text);
		displaySelectUse(item);
	});	
	if(typeof(cbMethod) != 'undefined')
	{
		eval(cbMethod + "('" + $(obj).text() + "');");
	}
}
//	================================================================
//	선택 설정 끝
//	================================================================

function goWebMessage()
{
	var url = _g_contextPath_ + "/uss/ion/ntm/registEgovNoteManage.do";
	var newWinName = "쪽지쓰기";
	var newWin = window.open(url, newWinName, "width=510,height=430,toolbar=no,scrollbar=no,resizable=no,status=no");
	newWin.window.focus();
}


editorConfigPortal = function( config, bodyID, height ) {
	config.docType = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
	config.font_defaultLabel = 'Gulim';
	config.font_names = 'Gulim/Gulim;Dotum/Dotum;Batang/Batang;Gungsuh/Gungsuh;Arial/Arial;Tahoma/Tahoma;Verdana/Verdana';
	config.fontSize_defaultLabel = '12px';
	config.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;';
	config.language = "ko";
	config.resize_enabled = false;
	config.enterMode = CKEDITOR.ENTER_P;
	config.shiftEnterMode = CKEDITOR.ENTER_P;
	config.startupFocus = true;
	config.uiColor = '#EEEEEE';
	config.toolbarCanCollapse = false;
	config.menu_subMenuDelay = 0;
	config.toolbar = [['Bold','Italic','Underline','Strike','-','Subscript','Superscript','-','TextColor','BGColor','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','Link','Unlink','-','Find','Replace','SelectAll','RemoveFormat','-','Image','Flash','Table','SpecialChar'],'/',['Source','-','ShowBlocks','-','Font','FontSize','Undo','Redo','-','About']];
	config.bodyId =  bodyID;
	config.height = height;
	
	config.filebrowserBrowseUrl = _g_contextPath_ + '/ckfinder/ckfinder.html';
    config.filebrowserImageBrowseUrl = _g_contextPath_ + '/ckfinder/ckfinder.html?type=Images';
    config.filebrowserFlashBrowseUrl = _g_contextPath_ + '/ckfinder/ckfinder.html?type=Flash';
    config.filebrowserUploadUrl = _g_contextPath_ + '/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Files';
    config.filebrowserImageUploadUrl = _g_contextPath_ + '/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Images';
    config.filebrowserFlashUploadUrl = _g_contextPath_ + '/ckfinder/core/connector/java/connector.java?command=QuickUpload&type=Flash';
    
    config.removePlugins = 'basket';	// basket 폴더 삭제
};

Array.prototype.clear = function()
{
	while(this.length > 0)
	{
		this.pop();
	}
	this.length = 0;
	return this;
};

String.prototype.trim = function()
{
	return this.replace(/(^\s*)|(\s*$)/gi, "");
};

function frmCreate(name, method, action, target)
{
	var form = document.createElement('form');
	form.name = name;
	form.method = method;
	form.action = action;
	if(typeof(target) != 'undefined')
	{
		form.target = target;
	}
	return form;
}

function frmAppendHidden(form, name, value)
{
	var element = document.createElement('input');	
	element.type = 'hidden';
	element.name = name;
	element.value = value;
	form.appendChild(element);
	return form;
}

function getCheckedValue(val)
{
	if(val == null || val == '')
	{
		return '';
	}else
	{
		return val.trim();
	}
}

function get_number_str(num)
{
	if(num < 10)
	{
		num = '0' + num;
	}
	return num;
}

function resizeImg(img, width)
{
	if($(img).width() > width)
	{
		$(img).width(width);
	}
}


String.prototype.replaceAll = function(searchStr, replaceStr)
{
	var _this = this;
	while(_this.indexOf(searchStr) != -1)
	{
		_this = _this.replace(searchStr, replaceStr);
	}
	return _this;
};

function getFileFullName(filePath)
{
	var tempFile = filePath.replaceAll('\\', '/'); 
	return tempFile.substring(tempFile.lastIndexOf('/') + 1, tempFile.length);
}

function getFileName(filePath)
{
	var file = getFileFullName(filePath);
	var fileName;

	if(file.indexOf('.') >= 0)
	{
		fileName = file.substring(0, file.lastIndexOf('.'));
	}else
	{
		fileName = file;
	}
	return fileName;
}

function getFileExt(filePath)
{
	var file = getFileFullName(filePath);
	var fileExt;

	if(file.indexOf('.') >= 0)
	{
		fileExt = file.substring(file.lastIndexOf('.') + 1, file.length);
	}else
	{
		fileExt = '';
	}
	return fileExt;
}

function getStringBytes(num, digit)
{
	
	var retValue = "";
	if(num < 1024 * 1024)
	{
		retValue = eval(num  / 1024).toFixed(digit) + " KB";
	}else
	{
		retValue = eval(num  / (1024 * 1024)).toFixed(digit) + " MB";
	}
	return retValue;
}
