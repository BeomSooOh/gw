/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dzdisplay.js - 웹페이지에 종속적
//						
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


var dzDisplay = {

	displayWidth : null
	, displayHeight : null
	, containerBorderYN : false

	, show : function(jsonText, callback) {

		dzBox.init(jsonText);

		if( 0 == dzBox.tbSize.length ) {

//			alert("추출된 테이블 정보가 없습니다");
			doCall_callback();
			return;
		}

		if(null == this.displayWidth) {

			doCall_callback();
			return;
		}

/*
		if(dzBox.imgSize.width < this.displayWidth) {

			this.displayWidth = dzBox.imgSize.width;

		} else {

			dzBox.setDisplayWidth(this.displayWidth);
		}
*/

		// 기존에는 가로크기가 clientWidth 보다 큰 경우만 비율 조정하여 줄여서 display 시킨 것을
		// 작은 이미지도 확대하여 display 시키는 것으로 조정
		if( null == this.displayHeight ) {

			dzBox.setDisplayWidth(this.displayWidth);

		} else {

			var widthRatio = this.displayWidth / dzBox.imgSize.width;
			var heightAdjust = dzBox.imgSize.height * widthRatio;
			if( this.displayHeight < heightAdjust ) {

				var heightRatio = this.displayHeight / dzBox.imgSize.height;
				var newDisplayWidth = dzBox.imgSize.width * heightRatio;
				dzBox.setDisplayWidth( newDisplayWidth );

			} else {

				dzBox.setDisplayWidth(this.displayWidth);
			}
		}


		var tableHTML = "";
		for(var i in dzBox.tbSize) {

			var dataInfo = dzBox.dataAnalysis(i, true);

			tableHTML += "<br />";
			tableHTML += '<div>';
			tableHTML += dzBox.getTableHTMLCode(dataInfo);
			tableHTML += "</div>";
		}


		var arrDataInfo = [];
		for(var i in dzBox.tbSize) {

			var dataInfo = dzBox.dataAnalysis(i, false);
			arrDataInfo.push(dataInfo);
		}


		var imgSize = dzBox.getImgSize();


		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		var draw = SVG('drawing').size(imgSize.width, imgSize.height);
		if(this.containerBorderYN) {
			draw.rect(imgSize.width, imgSize.height).fill('none').stroke( {color: "#000", width: 1} );
		}

		var cntOuterRec = 0;

		var cntGuideLine = 0;
		var cntVtx = 0;
		var cntRect = 0;

		var totalGuideLine = 0;
		var totalVtx = 0;
		var totalRect = 0;

		var arrVtx = [];

		var outerRecGroup = draw.group();
		var lineGroup = draw.group();
		var vtxGroup = draw.group();
		var cellGroup = draw.group();
		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



		function doDraw(doType) {

			if(0 == doType) {

				for(var i in arrDataInfo) {

					draw_outerRec(arrDataInfo[i]);
				}

			} else if(1 == doType) {

				for(var i in arrDataInfo) {

					totalGuideLine += (arrDataInfo[i].line_h.length + arrDataInfo[i].line_v.length);
				}

				for(var i in arrDataInfo) {

					draw_guide_line(arrDataInfo[i]);
				}

			} else if(2 == doType) {

				show_vertex();

			} else if(3 == doType) {

				for(var i in arrDataInfo) {

					totalRect += arrDataInfo[i].rcCell.length;
				}

				for(var i in arrDataInfo) {

					draw_rect(arrDataInfo[i]);
				}
			}
		}

		function draw_outerRec(dataInfo) {

			var start_xy = dataInfo.start_xy;
			var outer_rec = dataInfo.outer_rec;

//			var aniTm1 = 900;
//			var aniTm2 = 500;
			var aniTm1 = 500;
			var aniTm2 = 300;

			var width = outer_rec[2] - outer_rec[0];
			var height = outer_rec[3] - outer_rec[1];

			var rect = draw.rect(10, 10).fill('none').stroke( {color: "#000", width: 1} ).move(start_xy[0], start_xy[1]);
			outerRecGroup.add(rect);

			rect.animate( aniTm1 ).size(width, height);
			rect.animate( aniTm2 ).stroke( {color: '#ddd'} ).afterAll(function() {
				setTimeout(draw_outerRec_done, 0);
			});
		}

		function draw_outerRec_done() {

			cntOuterRec++;

			if(cntOuterRec == arrDataInfo.length) {
				doDraw(1);
			}
		}

		function draw_guide_line(dataInfo) {

			var start_xy = dataInfo.start_xy;
			var line_h = dataInfo.line_h;
			var line_v = dataInfo.line_v;

//			var aniTm = 1000;
			var aniTm = 500;

			line_h.forEach(function(val, idx) {

				var moveVal = val[1];
				var line = draw.line(val).stroke( {color: '#000', width: 1, linecap: 'butt'} ).move(start_xy[0], start_xy[1]);
				lineGroup.add(line);

				line.animate( aniTm ).move(start_xy[0], start_xy[1]+moveVal);
				line.animate( aniTm ).stroke( {color: '#ddd'} ).afterAll(function() {
					setTimeout(draw_guide_line_done, 0);
				});
			});

			line_v.forEach(function(val, idx) {

				var moveVal = val[0];
				var line = draw.line(val).stroke( {color: '#000', width: 1, linecap: 'butt'} ).move(start_xy[0], start_xy[1]);
				lineGroup.add(line);

				line.animate( aniTm ).move(start_xy[0]+moveVal, start_xy[1]);
				line.animate( aniTm ).stroke( {color: '#ddd'} ).afterAll(function() {
					setTimeout(draw_guide_line_done, 0);
				});
			});
		}

		function draw_guide_line_done() {

			cntGuideLine++;

			if(cntGuideLine == totalGuideLine) {

				outerRecGroup.remove();
				doDraw(2);
			}
		}

		function prepare_vertex() {

			vtxGroup.style("display", "none");

			for(var i in arrDataInfo) {

				var start_xy = arrDataInfo[i].start_xy;
				var rcCell = arrDataInfo[i].rcCell;

				var vtxColor = "#f00";

				rcCell.forEach(function(val, idx) {

					var strKey = (start_xy[0]+val[0]) + "_" + (start_xy[1]+val[1]);
					if(-1 == arrVtx.indexOf(strKey)) {

						arrVtx.push(strKey);

						// left-top
						var rcLT = draw.rect(4,4).fill(vtxColor).move(start_xy[0]+val[0]-2, start_xy[1]+val[1]-2);
						vtxGroup.add(rcLT);
					}

					strKey = (start_xy[0]+val[2]) + "_" + (start_xy[1]+val[1]);
					if(-1 == arrVtx.indexOf(strKey)) {

						arrVtx.push(strKey);

						// right-top
						var rcRT = draw.rect(4,4).fill(vtxColor).move(start_xy[0]+val[2]-2, start_xy[1]+val[1]-2);
						vtxGroup.add(rcRT);
					}

					strKey = (start_xy[0]+val[2]) + "_" + (start_xy[1]+val[3]);
					if(-1 == arrVtx.indexOf(strKey)) {

						arrVtx.push(strKey);

						// right-bottom
						var rcRB = draw.rect(4,4).fill(vtxColor).move(start_xy[0]+val[2]-2, start_xy[1]+val[3]-2);
						vtxGroup.add(rcRB);
					}

					strKey = (start_xy[0]+val[0]) + "_" + (start_xy[1]+val[3]);
					if(-1 == arrVtx.indexOf(strKey)) {

						arrVtx.push(strKey);

						// left-bottom
						var rcLB = draw.rect(4,4).fill(vtxColor).move(start_xy[0]+val[0]-2, start_xy[1]+val[3]-2);
						vtxGroup.add(rcLB);
					}
				});
			}

			totalVtx = arrVtx.length;
		}

		function show_vertex() {

			if(0 != dzBox.tbSize.length) {

				if(0 != totalVtx) {

					vtxGroup.style("display", "");
					setTimeout(show_vertex_done, 1000);
					return;
				}

				setTimeout(show_vertex, 1000);
			}
		}

		function show_vertex_done() {

			vtxGroup.remove();
			lineGroup.remove();

			doDraw(3);
		}

		function draw_rect(dataInfo) {

			var start_xy = dataInfo.start_xy;
			var rcCell = dataInfo.rcCell;

//			var aniTm = 1600;
			var aniTm = 800;

			rcCell.forEach(function(val, idx) {

				var width = val[2] - val[0];
				var height = val[3] - val[1];

				var rect = draw.rect(width, height).fill('none').stroke( {color: '#000', width: 1} );
				rect.move(start_xy[0]+val[0], start_xy[1]+val[1]);
				cellGroup.add(rect);

				rect.animate( aniTm ).stroke( {color: '#fff'} ).after(function() {
					setTimeout(draw_rect_done, 0);
				});
			});
		}

		function draw_rect_done() {

			cntRect++;

			if(cntRect == totalRect) {

				document.getElementById("drawing").style.display = "none";

				display_table();
			}
		}

		function display_table() {

			document.getElementById("resultTable").innerHTML = tableHTML;

			doCall_callback();
		}

		function doCall_callback() {

			if("function" == typeof(callback)) {
				callback();
			}			
		}

		setTimeout(prepare_vertex, 0);
		doDraw(0);
	}



};
