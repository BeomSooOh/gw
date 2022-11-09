//-- 파일 - 레이아웃 템플릿
var layoutTemplate = [

	//1,1
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="3" height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="400" width="50%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//1,2
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="5" height="50"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="400" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//1,3
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td height="15"></td></tr><tr><td height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//1,4
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="3" height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="50" colspan="3"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="400" width="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',

	//2,1
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td rowspan="3" width="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td rowspan="3" width="15"></td><td height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//2,2
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td><td rowspan="3" width="15"><td rowspan="3" width="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//2,3
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td rowspan="3" width="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td rowspan="3" width="15"></td><td height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td colspan="3" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//2,4
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td><td rowspan="3" width="15"><td rowspan="3" width="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td colspan="3" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//3,1
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="5" height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="400" width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td colspan="5" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//3,2
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="5" height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="400" width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400" width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td colspan="5" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//3,3
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="5" height="80"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="400"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="400" width="15"></td><td height="400" width="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td colspan="5" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//3,4
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td colspan="5" height="50"><h1 style="text-align: center;">' + ID_RES_CONST_STRING_ENTER_SUBJECT + '</h1></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="250" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="250" width="15"></td><td height="250" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="250" width="15"></td><td><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td height="250" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="250" width="15"></td><td height="250" width="33%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="250" width="15"></td><td height="250"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="5" height="15"></td></tr><tr><td colspan="5" height="50"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//4,1
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="300"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td height="15"></td></tr><tr><td height="300"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',
	//4,2
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="300" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td width="15"></td><td height="300"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td width="15"></td><td height="300"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',




	//4,3
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="200" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="200" width="15"></td><td height="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="200" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="200" width="15"></td><td height="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="200" width="15"></td><td height="200"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',



	//4,4
	'<table width="100%" cellpadding="0" cellspacing="0"><tr><td height="150" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="150" width="15"></td><td height="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="150" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="150" width="15"></td><td height="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="150" width="49%"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="150" width="15"></td><td height="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr><tr><td colspan="3" height="15"></td></tr><tr><td height="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td><td height="150" width="15"></td><td height="150"><p>' + ID_RES_CONST_STRING_ENTER_DETAIL + '</p></td></tr></table>',

];