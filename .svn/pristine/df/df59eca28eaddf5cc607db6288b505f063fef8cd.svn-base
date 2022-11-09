/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dzbox.js
//						
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var dzBox = {

	imgSize : null
	, tbSize : []
	, tbInfo : []

	, displayWidth : null
	, applyTableWidth : null


	, indexFlagName : "cusIndex"
	, cusFlagName : "cusFlag"


	, init : function(jsonText) {
		try {

			this.imgSize = null;
			this.tbSize = [];
			this.tbInfo = [];

			this.jsonParse(jsonText);

		} catch(e) {
		console.log(e);//오류 상황 대응 부재
		}
	}

	, jsonParse : function(jsonText) {

		var jsonObj = JSON.parse(jsonText);

		this.imgSize = jsonObj.imageSize;
		if(0 == this.imgSize.width) return;
		if(0 == this.imgSize.height) return;


		var objResult = jsonObj.objResult;

		for(var i in objResult) {

			var arrTable = objResult[i].arrTable;

			// 배열[0] size 추출하면서 arrTable에서는 제거
			this.tbSize.push( arrTable.shift().size );

			var arrRec = [];
			for(var j in arrTable) {

				arrRec.push( arrTable[j].arrRec );
			}

			this.tbInfo.push( arrRec );
		}
	}

	, setDisplayWidth : function(width) {

		this.displayWidth = width;
	}

	, setApplyTableWidth : function(width) {

		this.applyTableWidth = width;
	}

	, getDisplayRatio : function() {

		return (this.displayWidth / this.imgSize.width);
	}

	, getImgSize : function() {

		if(this.displayWidth) {

			var ratio = this.getDisplayRatio();
			var imgSize = this.imgSize;
			imgSize.width = parseInt(imgSize.width * ratio);
			imgSize.height = parseInt(imgSize.height * ratio);

			return imgSize;

		} else {

			return this.imgSize;
		}
	}

	, dataAnalysis : function(idx, validateCell) {

		var tbSize = {};
		tbSize.width = this.tbSize[idx].width;
		tbSize.height = this.tbSize[idx].height;

		var arrRec = this.tbInfo[idx];
		var arrX = [];
		var arrY = [];

		for(var i in arrRec) {

			var rcInfo = arrRec[i];

			this.extractCoordinateXY(rcInfo, arrX, arrY);
		}

		this.sortArray(arrX);
		this.sortArray(arrY);
		if(0 == arrX.length) return null;
		if(0 == arrY.length) return null;

		var startX = arrX[0];
		var startY = arrY[0];
		var startXY = [startX, startY];

		// 좌표 0,0 기준으로 재정리
		for(var i in arrX) {

			arrX[i] = arrX[i] - startX;
		}
		for(var i in arrY) {

			arrY[i] = arrY[i] - startY;
		}

/*
		if(this.displayWidth) {

			var ratio = this.getDisplayRatio();

			tbSize.width = parseInt(tbSize.width * ratio);
			tbSize.height = parseInt(tbSize.height * ratio);

			for(var i in arrX) {

				arrX[i] = parseInt(arrX[i] * ratio);
			}
			for(var i in arrY) {

				arrY[i] = parseInt(arrY[i] * ratio);
			}
		}
*/

		// 좌표 0,0 기준으로 재정리
		var endX = arrX[arrX.length-1];
		var endY = arrY[arrY.length-1];


		var outerRec = [0, 0, endX, endY];

		var arrLine_H = [];
		var arrLine_V = [];

		arrX.forEach(function(val, idx) {

			arrLine_V.push( [val, 0, val, endY] );
		});
		arrY.forEach(function(val, idx) {

			arrLine_H.push( [0, val, endX, val] );
		});


		var arrCell = [];
		var arrBorder = [];
		var arrBgColor = [];

		for(var i in arrRec) {

			var rcInfo = arrRec[i];
			var x1 = rcInfo.xy_s[0] - startX;
			var y1 = rcInfo.xy_s[1] - startY;
			var x2 = rcInfo.xy_e[0] - startX;
			var y2 = rcInfo.xy_e[1] - startY;
/*
			if(this.displayWidth) {

				var ratio = this.getDisplayRatio();

				x1 = parseInt(x1 * ratio);
				y1 = parseInt(y1 * ratio);
				x2 = parseInt(x2 * ratio);
				y2 = parseInt(y2 * ratio);
			}
*/
			arrCell.push( [x1, y1, x2, y2] );

			// 순서 - left, top, right, bottom
			arrBorder.push( [rcInfo.b_l, rcInfo.b_t, rcInfo.b_r, rcInfo.b_b] );

			arrBgColor.push( rcInfo.bg_clr );
		}


		var arrSimpleFlag = null;
		if(validateCell) {

			arrSimpleFlag = this.validateModelTable(arrCell, arrX, arrY, arrBorder, arrBgColor);
		}


		if(this.displayWidth) {

			var ratio = this.getDisplayRatio();


			tbSize.width = parseInt(tbSize.width * ratio);
			tbSize.height = parseInt(tbSize.height * ratio);

			for(var i in arrX) {

				arrX[i] = parseInt(arrX[i] * ratio);
			}
			for(var i in arrY) {

				arrY[i] = parseInt(arrY[i] * ratio);
			}


			endX = arrX[arrX.length-1];
			endY = arrY[arrY.length-1];

			outerRec = [0, 0, endX, endY];

			arrLine_H = [];
			arrLine_V = [];

			arrX.forEach(function(val, idx) {

				arrLine_V.push( [val, 0, val, endY] );
			});
			arrY.forEach(function(val, idx) {

				arrLine_H.push( [0, val, endX, val] );
			});



			for(var i in arrCell) {

				var cell = arrCell[i];
				cell[ 0 ] = parseInt(cell[ 0 ] * ratio);
				cell[ 1 ] = parseInt(cell[ 1 ] * ratio);
				cell[ 2 ] = parseInt(cell[ 2 ] * ratio);
				cell[ 3 ] = parseInt(cell[ 3 ] * ratio);
			}


			startXY[0] = parseInt(startXY[0] * ratio);
			startXY[1] = parseInt(startXY[1] * ratio);
		}

		return { start_xy:startXY, outer_rec:outerRec, line_h:arrLine_H, line_v:arrLine_V, rcCell:arrCell, co_x:arrX, co_y:arrY, border:arrBorder, bg_color:arrBgColor, tb_size:tbSize, simpleFlag:arrSimpleFlag };
	}

	, extractCoordinateXY : function(rcInfo, arrX, arrY) {

		var startX = rcInfo.xy_s[0];
		var startY = rcInfo.xy_s[1];

		var endX = rcInfo.xy_e[0];
		var endY = rcInfo.xy_e[1];

		if( -1 == arrX.indexOf(startX) ) {

			arrX.push(startX);
		}

		if( -1 == arrY.indexOf(startY) ) {

			arrY.push(startY);
		}

		if( -1 == arrX.indexOf(endX) ) {

			arrX.push(endX);
		}

		if( -1 == arrY.indexOf(endY) ) {

			arrY.push(endY);
		}
	}

	, sortArray : function(arrTarget){

		function compareNumbers(a, b){
			return a - b;
		}

		arrTarget.sort(compareNumbers);
	}

	, validateModelTable : function(arrCell, arrX, arrY, arrBorder, arrBgColor) {

		var arrSimpleFlag = null;

		var i = 0;
		//while(true) {
		while( i<1000) {

			i++;

			arrSimpleFlag = this.scanSimpleFlag(arrCell, arrX, arrY);

			var posInfo = this.findEmptySimpleFlag(arrSimpleFlag);
			if(null == posInfo) break;

			var insertPos = posInfo.pos_ins + 1;
			var rowStartNo = posInfo.row_start;
			var rowEndNo = posInfo.row_end;
			var colStartNo = posInfo.col_start;
			var colEndNo = posInfo.col_end;

			var x1 = arrX[colStartNo];
			var y1 = arrY[rowStartNo];
			var x2 = arrX[colEndNo+1];
			var y2 = arrY[rowEndNo+1];

			var rc = [x1, y1, x2, y2];

			arrCell.splice(insertPos, 0, rc);

			var border = [ [0, "none", "#ffffff"], [0, "none", "#ffffff"], [0, "none", "#ffffff"], [0, "none", "#ffffff"] ];
			arrBorder.splice(insertPos, 0, border);

			var bgColor = "#ffffff";
			arrBgColor.splice(insertPos, 0, bgColor);
		}

		return arrSimpleFlag;
	}

	, scanSimpleFlag : function(arrCell, arrX, arrY) {

		var rowCount = arrY.length - 1;
		var colCount = arrX.length - 1;

		var arrSimpleFlag = this.createSimpleFlag(rowCount, colCount);

		var cellCount = 0;
		var lastDone = false;

		while(true) {

			var prevY1 = -1;
			while(true) {

				if(cellCount >= arrCell.length) {

					lastDone = true;
					break;
				}

				var x1 = arrCell[cellCount][0];
				var y1 = arrCell[cellCount][1];
				var x2 = arrCell[cellCount][2];
				var y2 = arrCell[cellCount][3];

				var idxX1 = arrX.indexOf(x1);
				var idxY1 = arrY.indexOf(y1);
				var idxX2 = arrX.indexOf(x2);
				var idxY2 = arrY.indexOf(y2);

				if(-1 == prevY1) {

					prevY1 = idxY1;

				} else {

					if(prevY1 != idxY1) break;
				}


				var rowSpan = idxY2 - idxY1;
				var colSpan = idxX2 - idxX1;

				this.setSimpleFlagPos(arrSimpleFlag, idxY1, idxX1, rowSpan, colSpan, cellCount);

				cellCount++;
			}

			if(lastDone) break;
		}

		return arrSimpleFlag;
	}

	, createSimpleFlag : function(rowCount, colCount) {

		var arrSimpleFlag = [];
		for(var i=0; i<rowCount; i++) {

			arrSimpleFlag[i] = [];
			for(var j=0; j<colCount; j++) {

				arrSimpleFlag[i][j] = -1;
			}
		}

		return arrSimpleFlag;
	}

	, setSimpleFlagPos : function(arrSimpleFlag, rowNo, colNo, diffRow, diffCol, orderNo) {

		for(var i=rowNo; i<(rowNo + diffRow); i++) {

			for(var j=colNo; j<(colNo + diffCol); j++) {

				arrSimpleFlag[i][j] = orderNo;
			}
		}
	}

	, findEmptySimpleFlag : function(arrSimpleFlag) {

		var findEmpty = false;

		var rowStartNo = -1;
		var rowEndNo = -1;
		var colStartNo = -1;
		var colEndNo = -1;

		var insertPos = -1;

		for(var i=0; i<arrSimpleFlag.length; i++) {

			for(var j=0; j<arrSimpleFlag[i].length; j++) {

				if(-1 == arrSimpleFlag[i][j]) {

					if(findEmpty) {

						if(i == rowStartNo) {
							colEndNo = j;
						} else {
							break;
						}
					} else {

						findEmpty = true;

						rowStartNo = i;
						rowEndNo = i;
						colStartNo = j;
						colEndNo = j;
					}
				} else {

					if(findEmpty) break;

					insertPos = arrSimpleFlag[i][j];
				}
			}

			if(findEmpty) break;
		}

		if(findEmpty) {

			while(true) {

				if( (rowEndNo+1) < arrSimpleFlag.length ) {

					var i = rowEndNo + 1;
					var colAllEmpty = true;

					for(var j=colStartNo; j<=colEndNo; j++) {

						if(-1 != arrSimpleFlag[i][j]) {
							colAllEmpty = false;
							break;
						}
					}

					if(colAllEmpty) {
						rowEndNo++;
					} else {
						break;
					}

				} else {

					break;
				}
			}

			return { pos_ins:insertPos, row_start:rowStartNo, row_end:rowEndNo, col_start:colStartNo, col_end:colEndNo };
		}

		return null;
	}

	, getTableHTMLCode : function(dataInfo) {

		var tbSize = dataInfo.tb_size;
		var rcCell = dataInfo.rcCell;
		var co_x = dataInfo.co_x;
		var co_y = dataInfo.co_y;
		var border = dataInfo.border;
		var bg_color = dataInfo.bg_color;
		var arrSimpleFlag = dataInfo.simpleFlag;

		var tableHTML = this.getModelTable(tbSize, co_x, co_y, rcCell, border, bg_color, arrSimpleFlag);
		if(null == tableHTML) return null;

		return tableHTML;
	}

	// 수정 : 이전 버전 원본 코드 - simpleFlag 순서대로 출력으로 수정
	, getModelTable : function(tbSize, co_x, co_y, rcCell, border, bg_color, arrSimpleFlag) {

		// width / height border값 보정치 반영하기
		var bAdjustWH = true;

		var tableHTML = '';

		if(null == this.applyTableWidth) {
			//tableHTML = '<table cellspacing="0" cellpadding="1" width="' + tbSize.width + '" height="' + tbSize.height + '" style="border-collapse:collapse;">';
			tableHTML = '<table cellspacing="0" cellpadding="1" width="' + tbSize.width + '" style="border-collapse:collapse;">';

		} else {

			//tableHTML = '<table cellspacing="0" cellpadding="1" width="' + this.applyTableWidth + '" height="' + tbSize.height + '" style="border-collapse:collapse;">';
			tableHTML = '<table cellspacing="0" cellpadding="1" width="' + this.applyTableWidth + '" style="border-collapse:collapse;">';
		}


		var arrUsedOrder = [];
		for(var i=0; i<arrSimpleFlag.length; i++) {

			var tempHTML = '';
			for(var j=0; j<arrSimpleFlag[i].length; j++) {

				var orderNo = arrSimpleFlag[i][j];
				if( -1 != arrUsedOrder.indexOf(orderNo) ) continue;

				arrUsedOrder.push(orderNo);


				var x1 = rcCell[orderNo][0];
				var y1 = rcCell[orderNo][1];
				var x2 = rcCell[orderNo][2];
				var y2 = rcCell[orderNo][3];

				var idxX1 = co_x.indexOf(x1);
				var idxY1 = co_y.indexOf(y1);
				var idxX2 = co_x.indexOf(x2);
				var idxY2 = co_y.indexOf(y2);


				// rowSpan / colSpan 구하기
				var rowSpan = idxY2 - idxY1;
				var colSpan = idxX2 - idxX1;


				// width / height 설정
				var width = co_x[idxX2] - co_x[idxX1];
				var height = co_y[idxY2] - co_y[idxY1];


				// border 설정
				var borderVal = "";
				borderVal += ( "border-left:" + border[orderNo][0][0] + "px " + border[orderNo][0][1] + " " + border[orderNo][0][2] + ";" );
				borderVal += ( "border-top:" + border[orderNo][1][0] + "px " + border[orderNo][1][1] + " " + border[orderNo][1][2] + ";" );
				borderVal += ( "border-right:" + border[orderNo][2][0] + "px " + border[orderNo][2][1] + " " + border[orderNo][2][2] + ";" );
				borderVal += ( "border-bottom:" + border[orderNo][3][0] + "px " + border[orderNo][3][1] + " " + border[orderNo][3][2] + ";" );

				if(0 == border[orderNo][0][0]) {

					borderVal += "border-left:0;";

				} else {

					//borderVal += ( "border-left:" + border[orderNo][0][0] + "px " + border[orderNo][0][1] + " " + border[orderNo][0][2] + ";" );
					if("double" == border[orderNo][0][1].trim()) {

						borderVal += "border-left:3px double #000000;";
						if(bAdjustWH) { width -= 3; }

					} else {

						borderVal += "border-left:1px " + border[orderNo][0][1] + " #000000;";
						if(bAdjustWH) { width -= 1; }
					}
				}

				if(0 == border[orderNo][1][0]) {

					borderVal += "border-top:0;";

				} else {

					//borderVal += ( "border-top:" + border[orderNo][1][0] + "px " + border[orderNo][1][1] + " " + border[orderNo][1][2] + ";" );
					if("double" == border[orderNo][1][1].trim()) {

						borderVal += "border-top:3px double #000000;";
						if(bAdjustWH) { height -= 3; }

					} else {

						borderVal += "border-top:1px " + border[orderNo][1][1] + " #000000;";
						if(bAdjustWH) { height -= 1; }
					}
				}

				if(0 == border[orderNo][2][0]) {

					borderVal += "border-right:0;";

				} else {

					//borderVal += ( "border-right:" + border[orderNo][2][0] + "px " + border[orderNo][2][1] + " " + border[orderNo][2][2] + ";" );
					if("double" == border[orderNo][2][1].trim()) {

						borderVal += "border-right:3px double #000000;";
						if(bAdjustWH) { width -= 3; }

					} else {

						borderVal += "border-right:1px " + border[orderNo][2][1] + " #000000;";
						if(bAdjustWH) { width -= 1; }
					}
				}

				if(0 == border[orderNo][3][0]) {

					borderVal += "border-bottom:0;";

				} else {

					//borderVal += ( "border-bottom:" + border[orderNo][3][0] + "px " + border[orderNo][3][1] + " " + border[orderNo][3][2] + ";" );
					if("double" == border[orderNo][3][1].trim()) {

						borderVal += "border-bottom:3px double #000000;";
						if(bAdjustWH) { height -= 3; }

					} else {

						borderVal += "border-bottom:1px " + border[orderNo][3][1] + " #000000;";
						if(bAdjustWH) { height -= 1; }
					}
				}


				// backgroundColor 설정
				var backgroundColorVal = "";
				if("#ffffff" != bg_color[orderNo]) {
					backgroundColorVal = "background-color:" + bg_color[orderNo] + ";";
				}

				tempHTML += '<td rowspan="' + rowSpan + '" colspan="' + colSpan + '" width="' + width + '" height="' + height + '" style="' + borderVal + backgroundColorVal + '">' + '</td>';
			}

			tableHTML += '<tr>';
			tableHTML += tempHTML;
			tableHTML += '</tr>';
		}

		tableHTML += '</table>';

		return tableHTML;


/*
		// ---- 이전 버전 원본 코드 ---- //

		var rowCount = co_y.length - 1;
		var colCount = co_x.length - 1;

		var cellCount = 0;
		var lastDone = false;

		var tableHTML = '<table cellspacing="0" cellpadding="1" width="' + tbSize.width + '" height="' + tbSize.height + '" style="border-collapse:collapse;">';
		var tempHTML = '';

		while(true) {

			var prevY1 = -1;
			while(true) {

				if(cellCount >= rcCell.length) {

					lastDone = true;
					break;
				}

				var x1 = rcCell[cellCount][0];
				var y1 = rcCell[cellCount][1];
				var x2 = rcCell[cellCount][2];
				var y2 = rcCell[cellCount][3];

				var idxX1 = co_x.indexOf(x1);
				var idxY1 = co_y.indexOf(y1);
				var idxX2 = co_x.indexOf(x2);
				var idxY2 = co_y.indexOf(y2);

				if(-1 == prevY1) {

					prevY1 = idxY1;
					tempHTML = '';

				} else {

					if(prevY1 != idxY1) break;
				}


				var rowSpan = idxY2 - idxY1;
				var colSpan = idxX2 - idxX1;

				var width = co_x[idxX2] - co_x[idxX1];
				var height = co_y[idxY2] - co_y[idxY1];

				var borderVal = "";
				borderVal += ( "border-left:" + border[cellCount][0][0] + "px " + border[cellCount][0][1] + " " + border[cellCount][0][2] + ";" );
				borderVal += ( "border-top:" + border[cellCount][1][0] + "px " + border[cellCount][1][1] + " " + border[cellCount][1][2] + ";" );
				borderVal += ( "border-right:" + border[cellCount][2][0] + "px " + border[cellCount][2][1] + " " + border[cellCount][2][2] + ";" );
				borderVal += ( "border-bottom:" + border[cellCount][3][0] + "px " + border[cellCount][3][1] + " " + border[cellCount][3][2] + ";" );

				var backgroundColorVal = "";
				if("#ffffff" != bg_color[cellCount]) {
					backgroundColorVal = "background-color:" + bg_color[cellCount] + ";";
				}

				tempHTML += '<td rowspan="' + rowSpan + '" colspan="' + colSpan + '" width="' + width + '" height="' + height + '" style="' + borderVal + backgroundColorVal + '">' + '</td>';

				cellCount++;
			}

			tableHTML += '<tr>';
			tableHTML += tempHTML;
			tableHTML += '</tr>';

			if(lastDone) break;
		}

		tableHTML += '</table>';

		return tableHTML;
*/
	}


/*
	, getModelTable : function(tbSize, co_x, co_y, rcCell, border, bg_color, arrSimpleFlag) {

		var rowCount = co_y.length - 1;
		var colCount = co_x.length - 1;


		var strHTML = this.makeFormCode(tbSize.width, tbSize.height, rowCount, colCount);

		var objDivElement = document.createElement("div");
		objDivElement.innerHTML = strHTML;

		var objNewTable = null;
		var strChildNodeName = objDivElement.childNodes[0].nodeName.toLowerCase();
		if("table" == strChildNodeName) {

			objNewTable = objDivElement.childNodes[0];
		}
		if(null == objNewTable) return;


		for(var i=0; i<rcCell.length; i++) {

			var x1 = rcCell[i][0];
			var y1 = rcCell[i][1];
			var x2 = rcCell[i][2];
			var y2 = rcCell[i][3];

			var idxX1 = co_x.indexOf(x1);
			var idxY1 = co_y.indexOf(y1);
			var idxX2 = co_x.indexOf(x2);
			var idxY2 = co_y.indexOf(y2);

			var nStartRow = idxY1;
			var nStartCol = idxX1;
			var nEndRow = idxY2 - 1;
			var nEndCol = idxX2 - 1;

			this.prepareTargetCellFlag(i, objNewTable, nStartRow, nStartCol, nEndRow, nEndCol);
		}


		for(var i=0; i<rcCell.length; i++) {

			var x1 = rcCell[i][0];
			var y1 = rcCell[i][1];
			var x2 = rcCell[i][2];
			var y2 = rcCell[i][3];

			var idxX1 = co_x.indexOf(x1);
			var idxY1 = co_y.indexOf(y1);
			var idxX2 = co_x.indexOf(x2);
			var idxY2 = co_y.indexOf(y2);

			var width = co_x[idxX2] - co_x[idxX1];
			var height = co_y[idxY2] - co_y[idxY1];

			this.convertTargetCellFlag(i, objNewTable);

			// 좌표 기준으로 width, height 계산되는 부분은 일단 param으로 전달하고
			// 아래 함수 내부에서 border값에 해당되는 부분 만큼 width, height 다시 계산하여 반영
			this.simpleMergeCell(i, objNewTable, width, height, border[i], bg_color[i]);
		}

		this.releaseTargetCellFlag(objNewTable);

		return objDivElement.innerHTML;
	}

	, makeFormCode : function(tableWidth, tableHeight, maxRow, maxCol) {
		try {

			var strHTML = '';
			strHTML += '<table cellspacing="0" cellpadding="1" width="' + tableWidth + '" height="' + tableHeight + '" style="border-collapse:collapse;">';

			for(var i=0; i<maxRow; i++) {

				strHTML +=	'<tr>';
				for(var j=0; j<maxCol; j++) {

					strHTML +=	'<td></td>';
				}
				strHTML +=	'</tr>';
			}

			strHTML += '</table>';
			return strHTML;

		} catch(e) {
		}
	}

	, prepareTargetCellFlag : function(nIndex, objTable, nStartRow, nStartCol, nEndRow, nEndCol) {
		try {

			for(var i=nStartRow; i<=nEndRow; i++) {

				for(var j=nStartCol; j<=nEndCol; j++) {

					var objTableCell = this.getTableCellElement(objTable, i, j);
					this.setTargetCellFlag(objTableCell, this.indexFlagName, nIndex);
				}
			}

		} catch(e) {
		}
	}

	, convertTargetCellFlag : function(nIndex, objTable){
		try {

			var bFirstCell = false;

			var nRowLength = objTable.rows.length;
			for(var i=0; i<nRowLength; i++) {

				var nCellLength = this.getTableCellsLength(objTable, i);
				for(var j=0; j<nCellLength; j++) {

					var objTableCell = this.getTableCellElement(objTable, i, j);
					var nIndexFlag = this.getTargetCellFlag(objTableCell, this.indexFlagName);
					if(null == nIndexFlag) continue;

					if(nIndex == nIndexFlag) {

						if(!bFirstCell) {

							bFirstCell = true;
							this.setTargetCellFlag(objTableCell, this.cusFlagName, 2);

						} else {

							this.setTargetCellFlag(objTableCell, this.cusFlagName, 3);
						}
					}
				}
			}

		} catch(e) {
		}
	}

	, simpleMergeCell : function(nIndex, objTable, width, height, arrBorder, backgroundColor) {
		try	{

			var nMerge_Row = -1;
			var nMerge_Col = -1;
			var nRowSpan = 0;
			var nColSpan = 0;

			var nRowLength = objTable.rows.length;

			for(var i=0; i<nRowLength; i++) {

				var bRowFirst = true;

				var nCellLength = this.getTableCellsLength(objTable, i);
				for(var j=0; j<nCellLength; j++) {

					var objTableCell = this.getTableCellElement(objTable, i, j);
					var nFlag = this.getTargetCellFlag(objTableCell, this.cusFlagName);
					if(null == nFlag) continue;


					if((2 == nFlag) || (3 == nFlag) || (4 == nFlag)) {

						if(2 == nFlag) {

							nMerge_Row = i;
							nMerge_Col = j;

							objTableCell.removeAttribute(this.cusFlagName);
						}

						if(bRowFirst && (i == (nMerge_Row + nRowSpan))) {

							bRowFirst = false;

							nRowSpan += objTableCell.rowSpan;
						}

						if(i == nMerge_Row) {

							nColSpan += objTableCell.colSpan;
						}
					}
				}
			}

			for(var i=0; i<nRowLength; i++) {

				for(var j=0; j<this.getTableCellsLength(objTable,i); j++) {

					var objTableCell = this.getTableCellElement(objTable, i, j);
					var nFlag = this.getTargetCellFlag(objTableCell, this.cusFlagName);
					if(null == nFlag) continue;

					if((3 == nFlag) || (4 == nFlag)) {

						this.getTableRowElement(objTable,i).deleteCell(j);
						j = -1;
					}
				}
			}

			var objTableCell = this.getTableCellElement(objTable, nMerge_Row, nMerge_Col);
			objTableCell.rowSpan = nRowSpan;
			objTableCell.colSpan = nColSpan;

			// param으로 전달된 width, height 값에서 border값에 해당되는 부분 만큼 다시 계산하여 반영
			//if(true) {
			if(false) {

				width = width - arrBorder[0][0] - arrBorder[2][0];
				if(width < 0) width = 0;

				height = height - arrBorder[1][0] - arrBorder[3][0];
				if(height < 0) height = 0;
			}

			objTableCell.style.width = width + "px";
			objTableCell.style.height = height + "px";


//			objTableCell.style.borderLeft = arrBorder[0][0] + "px " + arrBorder[0][1] + " " + arrBorder[0][2];
//			objTableCell.style.borderTop = arrBorder[1][0] + "px " + arrBorder[1][1] + " " + arrBorder[1][2];
//			objTableCell.style.borderRight = arrBorder[2][0] + "px " + arrBorder[2][1] + " " + arrBorder[2][2];
//			objTableCell.style.borderBottom = arrBorder[3][0] + "px " + arrBorder[3][1] + " " + arrBorder[3][2];


			if(0 == arrBorder[0][0]) {
				objTableCell.style.borderLeft = "0px";
			} else {
				objTableCell.style.borderLeft = "1px solid #000000";
			}
			if(0 == arrBorder[1][0]) {
				objTableCell.style.borderTop = "0px";
			} else {
				objTableCell.style.borderTop = "1px solid #000000";
			}
			if(0 == arrBorder[2][0]) {
				objTableCell.style.borderRight = "0px";
			} else {
				objTableCell.style.borderRight = "1px solid #000000";
			}
			if(0 == arrBorder[3][0]) {
				objTableCell.style.borderBottom = "0px";
			} else {
				objTableCell.style.borderBottom = "1px solid #000000";
			}


			if("#ffffff" != backgroundColor) {

				objTableCell.style.backgroundColor = backgroundColor;
			}
		}
		catch(e)
		{
		}
	}

	, releaseTargetCellFlag : function(objTable) {
		try {

			var nRowLength = objTable.rows.length;
			for(var i=0; i<nRowLength; i++) {

				var nCellLength = this.getTableCellsLength(objTable, i);
				for(var j=0; j<nCellLength; j++) {

					var objTableCell = this.getTableCellElement(objTable, i, j);

					// For Debugging
					//var nIndexFlag = this.getTargetCellFlag(objTableCell, this.indexFlagName);
					//objTableCell.innerHTML = nIndexFlag;

					objTableCell.removeAttribute(this.indexFlagName);
				}
			}

		} catch(e) {
		}
	}

	, getTableCellElement : function(objTable, nRow, nCol){
		try {

			if(window.attachEvent) {

				return objTable.rows(nRow).cells(nCol);

			} else {

				return objTable.rows[nRow].cells[nCol];
			}

			return null;

		} catch(e) {
		}

		return null;
	}

	, getTableCellsLength : function(objTable, nRow) {
		try	{

			if(window.attachEvent) {

				return objTable.rows(nRow).cells.length;

			} else {

				return objTable.rows[nRow].cells.length;
			}

			return null;

		} catch(e) {
		}

		return null;
	}

	, getTargetCellFlag : function(objNode, strFlagName) {
		try	{

			var nFlag = objNode.getAttribute(strFlagName);
			if(null == nFlag) return null;
			if("" == nFlag) return null;

			return parseInt(nFlag);

		} catch(e) {
		}
	}

	, setTargetCellFlag : function(objNode, strFlagName, nValue) {
		try{

			objNode.setAttribute(strFlagName, nValue);

		} catch(e) {
		}
	}

	, getTableRowElement : function(objTable, nRow) {
		try {

			if(window.attachEvent) {

				return objTable.rows(nRow);

			} else {

				return objTable.rows[nRow];
			}

			return null;

		} catch(e) {
		}

		return null;
	}
//*/

};
