/*
 * 
 */

var insertTableMgr = {
	init: function() {
		if (g_browserCHK.androidtablet === true || g_browserCHK.iPad === true) {
			$("#one_custom_page").width("").height("");
		}
		
		var objGridContainer = $("#id_insert_table #table_grid_container");
		var nGridSize = Math.floor(objGridContainer.width() / 8);
		
		objGridContainer.find(".table_cell").width(nGridSize).height(nGridSize);
		
		this.addListener();
	},
	
	addListener: function() {
		try {
			var objGrid = $("#table_grid");
			
			var objColCount = $("#id_insert_table .col_count");
			var objRowCount = $("#id_insert_table .row_count");
			
			var objGridInfo = $("#id_insert_table .grid_info");
			
			$("#id_insert_table .col.down").click(function() {
				var nCol = parseInt(objColCount.text(), 10);
				var nRow = parseInt(objRowCount.text(), 10);
				
				if (nCol > 1) {
					var strSelectedCell = ".r1 .table_cell.c" + nCol;
					
					for (var index = 1; index < nRow; index++) {
						strSelectedCell += (", .r" + (index + 1) + " .table_cell.c" + nCol);
					}
					
					objGrid.find(strSelectedCell).removeClass("select");
					
					objColCount.text(--nCol);
					
					objGridInfo.text(nCol + " X " + nRow);
				}
			});
			
			$("#id_insert_table .col.up").click(function() {
				var nCol = parseInt(objColCount.text(), 10);
				var nRow = parseInt(objRowCount.text(), 10);
				
				if (nCol < 8) {
					nCol += 1;
					
					var strSelectedCell = ".r1 .table_cell.c" + nCol;
					
					for (var index = 1; index < nRow; index++) {
						strSelectedCell += (", .r" + (index + 1) + " .table_cell.c" + nCol);
					}
					
					objGrid.find(strSelectedCell).addClass("select");
					
					objColCount.text(nCol);
					
					objGridInfo.text(nCol + " X " + nRow);
				}
			});
			
			$("#id_insert_table .row.down").click(function() {
				var nRow = parseInt(objRowCount.text(), 10);
				var nCol = parseInt(objColCount.text(), 10);
				
				if (nRow > 1) {
					var strSelectedCell = ".r" + nRow + " .table_cell.c1";
					
					for (var index = 1; index < nCol; index++) {
						strSelectedCell += (", .r" + nRow + " .table_cell.c" + (index + 1));
					}
					
					objGrid.find(strSelectedCell).removeClass("select");
					
					objRowCount.text(--nRow);
					
					objGridInfo.text(nCol + " X " + nRow);
				}
			});
			
			$("#id_insert_table .row.up").click(function() {
				var nRow = parseInt(objRowCount.text(), 10);
				var nCol = parseInt(objColCount.text(), 10);
				
				if (nRow < 8) {
					nRow += 1;
					
					var strSelectedCell = ".r" + nRow + " .table_cell.c1";
					
					for (var index = 1; index < nCol; index++) {
						strSelectedCell += (", .r" + nRow + " .table_cell.c" + (index + 1));
					}
					
					objGrid.find(strSelectedCell).addClass("select");
					
					objRowCount.text(nRow);
					
					objGridInfo.text(nCol + " X " + nRow);
				}
			});
			
			var nStartX;
			var nStartY;
			
			objGrid.touchstart(function(event, ui) {
				nStartX = event.originalEvent.touches[0].clientX;
				nStartY = event.originalEvent.touches[0].clientY;
				
				updateGrid(event, false);
			}).touchmove(function(event, ui) {
				updateGrid(event, true);
			});
			
			function updateGrid(event, bMove) {
				try {
					var nCol = event.target.cellIndex + 1;
					var nRow = event.target.parentElement.rowIndex + 1;
					
					if (bMove === true) {
						var nDiff = event.originalEvent.touches[0].clientX - nStartX;
						nDiff = Math.round(nDiff / event.target.offsetWidth);
						nCol += nDiff;
						
						nDiff = event.originalEvent.touches[0].clientY - nStartY;
						nDiff = Math.round(nDiff / event.target.offsetHeight);
						nRow += nDiff;
						
						if (nCol < 1) {
							nCol = 1;
						} else if (nCol > 8) {
							nCol = 8;
						}
						
						if (nRow < 1) {
							nRow = 1;
						} else if (nRow > 8) {
							nRow = 8;
						}
					}
					
					var strSelectedCell = "";
					
					for (var rowIndex = 0; rowIndex < nRow; rowIndex++) {
						for (var colIndex = 0; colIndex < nCol; colIndex++) {
							if (rowIndex !== 0 || colIndex !== 0) {
								strSelectedCell += ", ";
							}
							
							strSelectedCell += (".r" + (rowIndex + 1) + " .table_cell.c" + (colIndex + 1));
						}
					}
					
					objGrid.find(".table_cell").removeClass("select");
					objGrid.find(strSelectedCell).addClass("select");
					
					objColCount.text(nCol);
					objRowCount.text(nRow);
					
					objGridInfo.text(nCol + " X " + nRow);
				} catch (e) {
					dalert(e);
				}
			}
		} catch (e) {
			dalert(e);
		}
	},
	
	confirm: function() {
		try {
			var nRow = parseInt($("#id_insert_table .row_count").text(), 10) - 1;
			var nCol = parseInt($("#id_insert_table .col_count").text(), 10) - 1;
			
			sendIFrameMessage("insertTable", {row: nRow, col: nCol}, false);
		} catch (e) {
			dalert(e);
		}
	}
};