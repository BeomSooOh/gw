//-- 파일 - 레이아웃 템플릿
var layoutTemplate = [
	//1,1
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 50%;"><col style="width: 15px;"><col style="width: 50%;"></colgroup><tbody><tr><td colspan="3" height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td></tr></tbody></table>',
	//1,2
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 33%;"><col style="width: 15px;"><col style="width: 33%;"><col style="width: 15px;"><col style="width: 33%;"></colgroup><tbody><tr><td colspan="5" height="50"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td></tr></tbody></table>',
	//1,3
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 100%;"></colgroup><tbody><tr><td height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="50"><p><br></p></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td></tr></tbody></table>',
	//1,4
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 200px;"><col style="width: 15px;"><col style="width: 100%;"></colgroup><tbody><tr><td colspan="3" height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="50" colspan="3"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td></tr></tbody></table>',

	//2,1
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 200px;"><col style="width: 15px;"><col style="width: 100%;"></colgroup><tbody><tr><td rowspan="3"><p><br></p></td><td rowspan="3"><p><br></p></td><td height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td></tr></tbody></table>',
	//2,2
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 100%;"><col style="width: 15px;"><col style="width: 200px;"></colgroup><tbody><tr><td height="80"><h1 style="text-align: center;"><br></h1></td><td rowspan="3"><p><br></p></td><td rowspan="3"><p><br></p></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td></tr></tbody></table>',
	//2,3
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 200px;"><col style="width: 15px;"><col style="width: 100%;"></colgroup><tbody><tr><td rowspan="3"><p><br></p></td><td rowspan="3"><p><br></p></td><td height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="3" height="50"><p><br></p></td></tr></tbody></table>',
	//2,4
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 100%;"><col style="width: 15px;"><col style="width: 200px;"></colgroup><tbody><tr><td height="80"><h1 style="text-align: center;"><br></h1></td><td rowspan="3"><p><br></p></td><td rowspan="3"><p><br></p></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="3" height="50"><p><br></p></td></tr></tbody></table>',
	
	//3,1
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 150px;"><col style="width: 15px;"><col style="width: 100%;"><col style="width: 15px;"><col style="width: 150px;"></colgroup><tbody><tr><td colspan="5" height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td><p><br></p></td><td height="400"><p><br></p></td><td><p><br></p></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="5" height="50"><p><br></p></td></tr></tbody></table>',
	//3,2
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 150px;"><col style="width: 15px;"><col style="width: 150px;"><col style="width: 15px;"><col style="width: 100%;"></colgroup><tbody><tr><td colspan="5" height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td><p><br></p></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="5" height="50"><p><br></p></td></tr></tbody></table>',
	//3,3
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 100%;"><col style="width: 15px;"><col style="width: 150px;"><col style="width: 15px;"><col style="width: 150px;"></colgroup><tbody><tr><td colspan="5" height="80"><h1 style="text-align: center;"><br></h1></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="400"><p><br></p></td><td height="400"><p><br></p></td><td><p><br></p></td><td height="400"><p><br></p></td><td height="400"><p><br></p></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="5" height="50"><p><br></p></td></tr></tbody></table>',
	//3,4
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 33%;"><col style="width: 15px;"><col style="width: 33%;"><col style="width: 15px;"><col style="width: 33%;"></colgroup><tbody><tr><td colspan="5" height="50"><h1 style="text-align: center;"> <br></h1></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td><p><br></p></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td height="250"><p><br></p></td><td height="250"><p><br></p></td></tr><tr><td colspan="5" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td colspan="5" height="50"><p><br></p></td></tr></tbody></table>',
	
	//4,1
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 100%;"></colgroup><tbody><tr><td height="300"><p><br></p></td></tr><tr><td height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="300"><p><br></p></td></tr></tbody></table>',
	//4,2
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 50%;"><col style="width: 15px;"><col style="width: 50%;"></colgroup><tbody><tr><td height="300"><p><br></p></td><td><p><br></p></td><td height="300"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td><p><br></p></td><td><p><br></p></td><td height="300"><p><br></p></td></tr></tbody></table>',
	//4,3
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 50%;"><col style="width: 15px;"><col style="width: 50%;"></colgroup><tbody><tr><td height="200"><p><br></p></td><td height="200"><p><br></p></td><td height="200"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="200"><p><br></p></td><td height="200"><p><br></p></td><td height="200"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="200"><p><br></p></td><td height="200"><p><br></p></td><td height="200"><p><br></p></td></tr></tbody></table>',
	//4,4
	'<table id="layoutTable" width="100%" cellpadding="0" cellspacing="0"><colgroup><col style="width: 50%;"><col style="width: 15px;"><col style="width: 50%;"></colgroup><tbody><tr><td height="150"><p><br></p></td><td height="150"><p><br></p></td><td height="150"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="150"><p><br></p></td><td height="150"><p><br></p></td><td height="150"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="150"><p><br></p></td><td height="150"><p><br></p></td><td height="150"><p><br></p></td></tr><tr><td colspan="3" height="15"><p><span style="font-size: 6pt;"><br></span></p></td></tr><tr><td height="150"><p><br></p></td><td height="150"><p><br></p></td><td height="150"><p><br></p></td></tr></tbody></table>',
];