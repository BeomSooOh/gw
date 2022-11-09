/* Bizbox Alpha 확장기능 - 회계쪽 그리드를 업무용승용차관리 전용 그리드로 수정. */
/* # 기능정의 */
/*   - 입력 그리드 (엑셀형) */

(function ($) {
    var classes = {
        mainDiv: 'cus_ta_ea scbg posi_re' /* main div class 정의 */
        , scrollCover: 'scy_head1' /* header left scroll class 정의 */
        , rightHeaderDiv: 'cus_ta_ea ovh mr17 scbg ta_bl rightHeader' /* header div class 정의 */
        , rightContentDiv: 'cus_ta_ea rowHeight scroll_fix rightContents scbg ta_bl' /* content div class 정의 */
        , rowOn: 'rowOn' /* 행선택시 반영 class 정의 */
        , colOn: 'colOn highLight'
        , spanOn: 'highLightIn'
    };

    var dateOptions = {
        altFormat: "yy-mm-dd",
        dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
        dateFormat: "yy-mm-dd",
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        showOtherMonths: true,
        selectOtherMonths: true,
        showMonthAfterYear: true,
        nextText: "Next",
        prevTex: "Prev"
    };

    var methods = {
        /* init */
        init: function (options) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 기본 옵션 기본값 정의
            var defaults = main.exSubTable('getDefaults');
            var options = $.extend(defaults, options);
            $.each(options.column, function (idx, column) {
                // 컬럼 기본값 정의
                column = $.extend(main.exSubTable('getDefaultsColumn'), column);

                // 필수값 입력 확인
                if ((column.title || '') === '') {
                    $.error('title이 정의되지 않았습니다.');
                }
                if ((column.display || '') === '') {
                    $.error('display가 정의되지 않았습니다.');
                }
                if ((column.colKey || '') === '') {
                    $.error('colKey가 정의되지 않았습니다.');
                }

                // 배열 관리 정보 별도 저장
                options.title[idx] = (column.title || '');
                options.display[idx] = (column.display || '');
                options.displayKey[idx] = (column.displayKey || '');
                options.colKey[idx] = (column.colKey || '');
                options.width[idx] = (column.width || '');
                options.reqYN[idx] = (column.reqYN || '');
                options.align[idx] = (column.align || '');
                options.classes[idx] = (column.classes || '');
                options.mask[idx] = (column.mask || '');
                options.type[idx] = (column.type || '');
                options.disabled[idx] = (column.disabled || '');
            });
            // json 데이터 배열로 변환
            $.each(options.data, function (idx, data) {
                var tempData = [];
                $.each(options.colKey, function (keyIdx, key) {
                    tempData[keyIdx] = data[key];
                });

                options.arrayData.push(tempData);
            });
            // 테이블 크기 정의
            options.rowSize = options.arrayData.length;
            options.colSize = options.colKey.length;
            options.selectIdx = [-1, -1];
            // 테이블 생성
            var createTable = function () {
                // 기존 정의된 테이블 및 이벤트 초기화
                main.contents().unbind().remove();
                // 테이블 옵션 정의
                if (!$.fn.extable.options) {
                    $.fn.extable.options = [];
                } else {
                    $.fn.extable.options[id] = [];
                }
                $.fn.extable.options[id] = options;
                // 테이블 렌더
                if (!main.exSubTable('setTabelRender')) {
                    main.contents().unbind().remove();
                    $.error('테이블 렌더 과정중 오류가 발생되었습니다.');
                    return false;
                };
                // 행추가
                $.each($.fn.extable.options[id].arrayData, function (rowIdx, items) {
                    if (!main.exSubTable('setRowRender', items, 'make')) {
                        main.contents().unbind().remove();
                        $.error('행추가 과정중 오류가 발생되었습니다.');
                        return false;
                    }
                });
                // display setting
                if (!main.exSubTable('setColDIsplay')) {
                    main.contents().unbind().remove();
                    $.error('컬럼 표현 처리 과정중 오류가 발생되었습니다.');
                    return false;
                }
            };
            createTable();
        },
        setAddRow: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // row render
            if (main.exSubTable('setRowRender', parameters, 'new')) {
                return main.exSubTable('setColDIsplay');
            } else {
                return false;
            }
        },
        setDisplay: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // row render
            return main.exSubTable('setColDIsplay');
        },
        /* options 기본 정보 조회 */
        getDefaults: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // options default
            return main.exSubTable('getDefaults');
        },
        /* options column 기본 정보 조회 */
        getDefaultsColumn: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // options column default
            return main.exSubTable('getDefaultsColumn');
        },
        /* 행 데이터 반영 */
        setRowData: function (parameters, focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            if (parameters instanceof Array) {
                // array 인 경우 처리
                parameters = main.exSubTable('getArrayToJson', parameters);
            }
            // 선택된 행 정보 반영
            var rowData = main.extable('getRowData', focusY);
            // 데이터 변경
            $.each(Object.keys(parameters), function (keyIdx, key) {
                rowData[key] = (parameters[key] || '').toString();
            });
            $.fn.extable.options[id].arrayData[focusY] = main.exSubTable('getJsonToArray', rowData);
            $.fn.extable.options[id].data[focusY] = rowData;
            return main.exSubTable('setDisplayUpdate', focusY);
        },
        /* 행 데이터 조회 */
        getRowData: function (rowIndex) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            return ($.fn.extable.options[id].data[rowIndex] || main.exSubTable('getJsonDataDefaults'));
        },
        /* 테이블 전체 데이터 조회 */
        getAllData: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            return ($.fn.extable.options[id].data || []);
        },
        /* 컬럼 재정의 */
        setDisplayChange: function (parametres) {
            // ex) ["Y", "Y", "Y", "Y"];
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            $.each(parametres, function (colIdx, dispValue) {
                $.fn.extable.options[id].display[colIdx] = dispValue;
                $.fn.extable.options[id].column[colIdx].display = dispValue;
            });
            main.exSubTable('setColDIsplay');
            return true;
        },
        /* 읽기 전용 설정 */
        /* 일기 전용 해제 */
        /* 행삭제 */
        setRemoveRow: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            return main.exSubTable('setRowPop', parameters);
        },
        /* 포커스 */
        setFocus: function (focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);

            if (focusX < 0 || focusY < 0) {
                $.error('X 또는 Y의 값이 0보다 작을 수 없습니다.');
                return false;
            }

            if ($.fn.extable.options[id].rowSize > focusY) {
                if ($.fn.extable.options[id].colSize > focusX) {
                    $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + focusX + ')').click();
                    return true;
                } else {
                    $.error('X의 값이 column의 크기보다 큽니다.');
                    return false;
                }
            } else {
                $.error('Y의 값이 row의 크기보다 큽니다.');
                return false;
            }
        },
        /* 현재 행정보 반환 */
        getSelectedRowData: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // result 정의
            var result = {};
            result.rowIndex = $.fn.extable.options[id].selectIdx[1];
            result.colIndex = $.fn.extable.options[id].selectIdx[0];
            result.data = $.fn.extable.options[id].data[result.rowIndex];
            return result;
        },
        setRemoveEditor: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // remove input
            main.exSubTable('setInpValueUpdate', $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
            main.exSubTable('removeInp', $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
            main.exSubTable('setRemoveColSelectClass');
        },
        /* 현재행의 필수값 입력 여부 확인 */
        getReqCheck: function (rowIdx) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            var positionY = (rowIdx == undefined ? $.fn.extable.options[id].selectIdx[1] : rowIdx);
            var colKey = $.fn.extable.options[id].colKey;
            var reqYN = $.fn.extable.options[id].reqYN;
            var arrayData = $.fn.extable.options[id].arrayData[positionY];
            var notInput = [];
            var result = {
				pass: false,
				key: [ ],
				title: [ ]
			};
            
            $.each(reqYN, function (reqIdx, YN) {
                if (YN.toString().toUpperCase() === 'Y' || YN.toString().toUpperCase() === '1') {
                    if ((arrayData[reqIdx] || '') === '') {
                    	if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + positionY + ') td:eq(' + reqIdx + ') input').length){
                    		if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + positionY + ') td:eq(' + reqIdx + ') input').val() == ''){
                    			notInput.push(colKey[reqIdx]);
                                result.key.push(colKey[reqIdx]);
                                result.title.push($.fn.extable.options[id].column[reqIdx].title);                    			
                    		}
                    	}
                    	else {
	                        notInput.push(colKey[reqIdx]);
	                        result.key.push(colKey[reqIdx]);
	                        result.title.push($.fn.extable.options[id].column[reqIdx].title);
                    	}
                    }
                }
            });
            
            if(result.key.length > 0){
            	result.pass = false;
            } else {
            	result.pass = true;
            }
            return result;
        },
        setRowDisable:function(positionX, positionY, disabled) {
        	// element 정의
            var id = $(this).prop('id');
            var main = $(this);
            
            for(var i=0; i <= positionY; i++){
            	if($.fn.extable.options[id].columnRow[i] === undefined){
                	$.fn.extable.options[id].columnRow[i] = [];
                }
            	
            	for(var j=0; j < $.fn.extable.options[id].colKey.length; j++){
                	if($.fn.extable.options[id].columnRow[i][j] === undefined){
                		$.fn.extable.options[id].columnRow[i][j] = $.fn.extable.options[id].disabled[j].toString();
                	}
                }
            }            
            
            $.fn.extable.options[id].columnRow[positionY][positionX] = disabled;
            //console.log($.fn.extable.options[id].columnRow);
        },
        /* 현재행의 모든 열 disabled 처리 추가 */
        setRowAllDisable:function(positionY, disabled) {
        	// element 정의
            var id = $(this).prop('id');
            var main = $(this);
            
            for(var i=0; i < $.fn.extable.options[id].colKey.length; i++){
            	$.fn.extable.options[id].columnRow[positionY][i] = disabled;
            }
        },
        setDisplayReqYN:function(parameters) {
        	 var id = $(this).prop('id');
             var main = $(this);
             
             if(parameters.length != $.fn.extable.options[id].reqYN.length){
            	 for(var i=0; i<$.fn.extable.options[id].reqYN.length; i++){
            		 parameters[i] = ((parameters[i] || '') === '' ? $.fn.extable.options[id].reqYN[i] : parameters[i]);
            	 }
             }
             
        	 $.each(parameters, function (colIdx, dispValue) {
            	 var th = '';
            	 
                 $.fn.extable.options[id].reqYN[colIdx] = dispValue;
                 $.fn.extable.options[id].column[colIdx].reqYN = dispValue;
                 $.fn.extable.options[id].rightHeaderTable.find('th:eq(' + colIdx + ')').unbind().empty();
                 if((dispValue || 'N').toUpperCase() === 'Y'){
                	 th += '<img src="../../../Images/ico/ico_check01.png" alt="">';
                 }
                 th += $.fn.extable.options[id].title[colIdx];                 
                 $.fn.extable.options[id].rightHeaderTable.find('th:eq(' + colIdx + ')').append(th);
             });
             
             //main.exSubTable('setTabelRender');
             //main.exSubTable('setColDIsplay');
             return true;
        }
    };

    var subMethods = {
        eventColCLick: function (targetCell) {
        	if(targetCell == undefined) {
        		return false;
        	}
        	
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);

            // 중복클릭 확인
            if ($.fn.extable.options[id].selectIdx[1] == targetCell.parent().index()) {
                if ($.fn.extable.options[id].selectIdx[0] == targetCell.index()) {
                	if($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]').length){
                		return false;
                	}
                }
            }
            // TODO: col click before event
            var beforeX = $.fn.extable.options[id].selectIdx[0];
            var veforeY = $.fn.extable.options[id].selectIdx[1];
            var beforeData = ($.fn.extable.options[id].selectIdx[1] > -1 ? main.exSubTable('getJsonData', $.fn.extable.options[id].selectIdx[1]) : {});
            
            var afterData = main.exSubTable('getJsonData', targetCell.parent().index());
            // after focus
            var afterX = Number(targetCell.index());
            var afterY = Number(targetCell.parent().index());

            var beforeParam = {};
            beforeParam.beforeRowIndex = $.fn.extable.options[id].selectIdx[1];
            beforeParam.beforeColIndex = $.fn.extable.options[id].selectIdx[0];
            beforeParam.afterRowIndex = afterY;
            beforeParam.afterColIndex = afterX;
            if(beforeData != undefined) {
            	beforeParam.data = beforeData;
                beforeParam.beforeData = JSON.parse(JSON.stringify(beforeData));
            }
            if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').length){
            	beforeParam.data[$.fn.extable.options[id].colKey[$.fn.extable.options[id].selectIdx[0]]] = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').val();
            }

            if (beforeParam.beforeColIndex > -1) {
                if (!(typeof $.fn.extable.options[id].clickBefore === 'function' ? $.fn.extable.options[id].clickBefore(beforeParam) : true)) {
                    return false;
                }
            }
            // TODO: col click process
            // 현재 input 값 갱신
            var beforeX = Number($.fn.extable.options[id].selectIdx[0]);
            var beforeY = Number($.fn.extable.options[id].selectIdx[1]);
//            if (beforeX > -1 && beforeY > -1) {
//            행선택 오류로 인한 변경 신재호
            if ( beforeY > -1) {
                main.exSubTable('setInpValueUpdate', beforeX, beforeY);
                main.exSubTable('setRemoveInpSelectClass');
                main.exSubTable('setRemoveColSelectClass');
                main.exSubTable('setRemoveRowSelectClass');
                main.exSubTable('removeInp', beforeX, beforeY);
            }

            // add style
            main.exSubTable('setAddRowSelectClass', afterX, afterY);
            main.exSubTable('setAddColSelectClass', afterX, afterY);
            
            // append input
            var span = document.createElement('span');
            $(span).addClass(classes.spanOn);
            var input = document.createElement('input');
            $(input).attr('type', 'text');
            // if (($.fn.extable.options[id].disabled[afterX] || '') != '') {
        	if(($.fn.extable.options[id].columnRow[afterY][afterX] || '') != ''){
                $(input).attr('disabled', 'disabled');
        	}
            $(input).addClass('inpTextBox');
            // type 정의
            switch (($.fn.extable.options[id].type[afterX] || 'text').toString().toLowerCase()) {
                case 'text':
                    break;
                case 'combo':
                	if(($.fn.extable.options[id].columnRow[afterY][afterX] || '') != 'disabled'){
                		var keyCode = (event.keyCode || event.which);
                        var keyDownParameters = {};
                        keyDownParameters.rowIndex = afterY;
                        keyDownParameters.colIndex = afterX;
                        keyDownParameters.columnName = $.fn.extable.options[id].column[afterX].title;
                        keyDownParameters.keyCode = keyCode;
                        // keyDownParameters.beforeData = JSON.parse(JSON.stringify(main.extable('getRowData', afterY)));
                        keyDownParameters.beforeData = {};
                        $.each($.fn.extable.options[id].arrayData[afterY], function(idx, item){
                        	keyDownParameters.beforeData[$.fn.extable.options[id].colKey[idx]] = item;
                        });
                        keyDownParameters.data = main.extable('getRowData', afterY);
                        if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').length){
                        	beforeParam.data[$.fn.extable.options[id].colKey[$.fn.extable.options[id].selectIdx[0]]] = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').val();
                        }
                        keyDownParameters.tblId = id;
	                    /* id + AutoComplete */
	                    var comboData = $.fn.extable.options[id].column[afterX].comboData;
	                    var ul = document.createElement('ul');
	                    $(ul).addClass('inp_list');
	                    $.each(comboData.list, function (itemIdx, item) {
	                        var li = document.createElement('li');
	                        $(li).append([item[comboData.code], item[comboData.name]].join('. '));
	                        $(li).data('data', item);
	                        $(li).click(function () {
	                            $(this).parent().find('.on').removeClass('on');
	                            $(this).addClass('on');
	                            main.extable('setRowData', $('#' + id + 'AutoComplete ul li.on').data('data'), $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
	                            	
	                            // enter
	                            var len = $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]').val().length
	                            if (($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === len && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
	                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
	                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === 0)) {
	                                for (var i = ($.fn.extable.options[id].selectIdx[0] + 1) ; i < $.fn.extable.options[id].colKey.length; i++) {
	                                	
	                                	
	                                	
	                                	
	                                    if (($.fn.extable.options[id].display[i] == 'Y'
	                                        || $.fn.extable.options[id].display[i] == '1'
	                                        || $.fn.extable.options[id].display[i] == true)
	                                        && $.fn.extable.options[id].columnRow[$.fn.extable.options[id].selectIdx[1]][i] == '') {
	                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
	                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
	                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
	                                        }
	                                        return false;
	                                    }
	                                }
	                                if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
	                                	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
	                                }
	                                return false;
	                            }
	                        });
	                        $(ul).append(li);
	                    });
	
	                    $('#' + id + 'AutoComplete').contents().unbind().remove();
	                    $('#' + id + 'AutoComplete').append(ul);
	                    $('#' + id + 'AutoComplete').show();
	                    /* 다른 테이블 클릭 시 드롭다운 안없어져서 추가 - 신재호 */
	                    $('#' + id + 'AutoComplete').addClass('AutoCompleteClass');
	                    $('#' + id + 'AutoComplete').css('width', $.fn.extable.options[id].rightContentTable.find('tr:eq(' + afterY + ') td:eq(' + afterX + ')').width());
	                    $('#' + id + 'AutoComplete').css('z-index', '2');
	                    $('#' + id + 'AutoComplete').offset({
	                        top: $.fn.extable.options[id].rightContentTable.find('tr:eq(' + afterY + ') td:eq(' + afterX + ')').offset().top + 25,
	                        left: $.fn.extable.options[id].rightContentTable.find('tr:eq(' + afterY + ') td:eq(' + afterX + ')').offset().left + (afterX == 0 ? 0 : 1)
	                    });

	                    $(input).focus(function () {
	                        $('#' + id + 'AutoComplete').show();
	                    });
	                    $(input).click(function () {
	                        $('#' + id + 'AutoComplete').show();
	                    })
                	}
                    break;
                case 'datepicker':
                	if(($.fn.extable.options[id].columnRow[afterY][afterX] || '') != 'disabled'){
	                    $(input).addClass('brn inpDateBox');
	                    $(input).datepicker(dateOptions);
	                    /*달력 방향키 이벤트 추가 S*/
	                    $(input).keydown(function () {
	                    	var keyCode = (event.keyCode || event.which);
	                        console.log("달력 방향키="+keyCode);
	                        if([37, 39, 38, 40].indexOf(keyCode) === -1){ //해당 이벤트 외 제외
								return;
							}
	                        var driveVal = $.fn.extable.options[id].data[afterY].driveDate;
                    		if(driveVal != ""){ //날짜값이 있으면 셀이동이 되도록 제외 처리
                    			return;
                    		}
	                        var inst = $.datepicker._getInst(event.target);
							var isRTL = inst.dpDiv.is(".ui-datepicker-rtl");
							
	                        if (keyCode == 37) {
	                        	//왼
	                        	//console.log("왼쪽 방향키="+keyCode);
	                        	
								$.datepicker._adjustDate(event.target, (isRTL ? +1 : -1), "D");
	                        	//event.preventDefault();
	    						return false;
	    					} else if(keyCode == 38){
	    						//위
	    						//console.log("위쪽 방향키="+keyCode);
	    						$.datepicker._adjustDate(event.target, -7, "D");
	    						//event.preventDefault();
	    						return false;
	    					} else if(keyCode == 39){
	    						//오른
	    						//console.log("오른쪽 방향키="+keyCode);
								$.datepicker._adjustDate(event.target, (isRTL ? -1 : +1), "D");	    						
	    						//event.preventDefault();
	    						return false;
	    					} else if(keyCode == 40){
	    						//아래
	    						//console.log("아래쪽 방향키="+keyCode);
	    						$.datepicker._adjustDate(event.target, +7, "D");
	    						//event.preventDefault();
	    						return false;
	    					}
	                    });
	                    /*달력 방향키 이벤트 추가 E*/
                	}
                    break;
            }
            // TODO: input mask
            if (typeof $.fn.extable.options[id].displayKey[afterX] === 'function') {
                $(input).val($.fn.extable.options[id].displayKey[afterX]());
            } else if ($.fn.extable.options[id].displayKey[afterX] instanceof Array) {
                var arrValue = $.fn.extable.options[id].displayKey[afterX];
                var dispValue = '';
                $.each(arrValue, function (keyIdx, key) {
                    if ($.fn.extable.options[id].colKey.indexOf(key) >= 0) {
                        dispValue += ($.fn.extable.options[id].arrayData[afterY][$.fn.extable.options[id].colKey.indexOf(key)] || '');
                    } else {
                        dispValue += key;
                    }
                });
                $(input).val((dispValue || ''));
            } else if ($.fn.extable.options[id].disabled[afterX].match('disabled')){
                //$(input).val("ywyw");
                $(input).val($.fn.extable.options[id].arrayData[afterY][afterX]);
                
            } else {
            	$(input).val($.fn.extable.options[id].arrayData[afterY][afterX]);
            }
            // input event 정의
            $(input).blur(function(event){
	            if( typeof $.fn.extable.options[id].blurEvent === "function") {
	            	//console.log("blurEvent~~");
	            	//console.log($(this));
	            	var keyDownParameters = {};
	            	keyDownParameters.data = main.extable('getRowData', beforeY);
	            	keyDownParameters.rowIndex = $.fn.extable.options[id].selectIdx[1];
	                keyDownParameters.colIndex = $.fn.extable.options[id].selectIdx[0];
	                keyDownParameters.id = id;
	            	$.fn.extable.options[id].blurEvent(keyDownParameters);
	            }
            });
            
            $(input).keydown(function (event) {
            	var keyCode = (event.keyCode || event.which);
                var keyDownParameters = {};
                keyDownParameters.rowIndex = afterY;
                keyDownParameters.colIndex = afterX;
                keyDownParameters.columnName = $.fn.extable.options[id].column[afterX].title;
                keyDownParameters.keyCode = keyCode;
                keyDownParameters.beforeData = {};
                $.each($.fn.extable.options[id].arrayData[afterY], function(idx, item){
                	keyDownParameters.beforeData[$.fn.extable.options[id].colKey[idx]] = item;
                });
                keyDownParameters.data = main.extable('getRowData', afterY);
                if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').length){
                	beforeParam.data[$.fn.extable.options[id].colKey[$.fn.extable.options[id].selectIdx[0]]] = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').val();
                }
                keyDownParameters.tblId = id;

                if (event.shiftKey) {
                    switch (keyCode.toString()) {
                        case '38':
                            // arrow up
                            if ($.fn.extable.options[id].selectIdx[1] > 0) {
                                for (var i = ($.fn.extable.options[id].selectIdx[1] - 1) ; i >= 0; i--) {
                                    if ($.fn.extable.options[id].rightContentTable.find('tr:eq(' + i + ')').css('display') != 'none') {
                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                        }
                                        return false;
                                    }
                                }
                            }
                            break;
                        case '40':
                            // arrow down
                            if ($.fn.extable.options[id].selectIdx[1] < ($.fn.extable.options[id].rowSize - 1)) {
                                for (var i = ($.fn.extable.options[id].selectIdx[1] + 1) ; i <= ($.fn.extable.options[id].rowSize - 1) ; i++) {
                                    if ($.fn.extable.options[id].rightContentTable.find('tr:eq(' + i + ')').css('display') != 'none') {
                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                        }
                                        return false;
                                    }
                                }
                            }
                            break;
                    }
                } else {
                    switch (keyCode.toString()) {
                        case '13':
                            // enter
                            var len = $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]').val().length
                            if (($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === len && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === 0)) {
                                for (var i = ($.fn.extable.options[id].selectIdx[0] + 1) ; i < $.fn.extable.options[id].colKey.length; i++) {
                                    if (($.fn.extable.options[id].display[i] == 'Y'
                                        || $.fn.extable.options[id].display[i] == '1'
                                        || $.fn.extable.options[id].display[i] == true)
                                        && $.fn.extable.options[id].columnRow[$.fn.extable.options[id].selectIdx[1]][i] == '') {
                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                        }
                                        return false;
                                    }
                                }
                                if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                }
                                return false;
                            }
                            break;
                        case '37':
                            // arrow left
                        	/*달력 방향키 이벤트 추가 S*/
                        	var xType = $.fn.extable.options[id].type[afterX];
                        	if(xType == "datepicker"){
                        		if(keyDownParameters.data.driveDate == ""){
                        			break;
                        		}
                        	}
                        	/*달력 방향키 이벤트 추가 E*/
                            var len = $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]').val().length
                            if (($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === len && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === 0)) {
                                for (var i = ($.fn.extable.options[id].selectIdx[0] - 1) ; i > -1; i--) {
                                    if (($.fn.extable.options[id].display[i] == 'Y'
                                        || $.fn.extable.options[id].display[i] == '1'
                                        || $.fn.extable.options[id].display[i] == true)
                                        && $.fn.extable.options[id].columnRow[$.fn.extable.options[id].selectIdx[1]][i] == '') {
                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                        }
                                        break;
                                    }
                                }
                                if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                }
                                return false;
                            }
                            break;
                        case '38':
                            // arrow up
                            if ($('#' + id + 'AutoComplete ul li').length > 0) {
                                if ($('#' + id + 'AutoComplete ul li.on').length > 0) {
                                    if ($('#' + id + 'AutoComplete ul li.on').index() > 0) {
                                        var index = $('#' + id + 'AutoComplete ul li.on').index();
                                        $('#' + id + 'AutoComplete ul li.on').removeClass('on');
                                        $('#' + id + 'AutoComplete ul li:eq(' + (index - 1) + ')').addClass('on');
                                        main.extable('setRowData', $('#' + id + 'AutoComplete ul li:eq(' + (index - 1) + ')').data('data'), $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
                                    }
                                }
                                else {
                                    $('#' + id + 'AutoComplete ul li:last').addClass('on');
                                    main.extable('setRowData', $('#' + id + 'AutoComplete ul li:last').data('data'), $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
                                }
                            }
                            break;
                        case '39':
                            // arrow right
                        	/*달력 방향키 이벤트 추가 S*/
                        	var xType = $.fn.extable.options[id].type[afterX];
                        	if(xType == "datepicker"){
                        		if(keyDownParameters.data.driveDate == ""){
                        			break;
                        		}
                        	}
                        	/*달력 방향키 이벤트 추가 E*/
                            var len = $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]').val().length
                            if (($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === len && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === len)
                                || ($.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionStart === 0 && $.fn.extable.options[id].rightContentTable.find('input').not('input[type=checkbox]')[0].selectionEnd === 0)) {
                                for (var i = ($.fn.extable.options[id].selectIdx[0] + 1) ; i < $.fn.extable.options[id].colKey.length; i++) {
                                    if (($.fn.extable.options[id].display[i] == 'Y'
                                        || $.fn.extable.options[id].display[i] == '1'
                                        || $.fn.extable.options[id].display[i] == true)
                                        && $.fn.extable.options[id].columnRow[$.fn.extable.options[id].selectIdx[1]][i] == '') {
                                    	$.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + i + ')').click();
                                        if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                        	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                        }
                                        return false;
                                    }
                                }
                                if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                                	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                                }
                                return false;
                            }
                            break;
                        case '40':
                            // arrow down
                            if ($('#' + id + 'AutoComplete ul li').length > 0) {
                                if ($('#' + id + 'AutoComplete ul li.on').length > 0) {
                                    if ($('#' + id + 'AutoComplete ul li.on').index() < ($('#' + id + 'AutoComplete ul li').length - 1)) {
                                        var index = $('#' + id + 'AutoComplete ul li.on').index();
                                        $('#' + id + 'AutoComplete ul li.on').removeClass('on');
                                        $('#' + id + 'AutoComplete ul li:eq(' + (index + 1) + ')').addClass('on');
                                        main.extable('setRowData', $('#' + id + 'AutoComplete ul li:eq(' + (index + 1) + ')').data('data'), $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
                                    }
                                } else {
                                    $('#' + id + 'AutoComplete ul li:eq(0)').addClass('on');
                                    main.extable('setRowData', $('#' + id + 'AutoComplete ul li:eq(0)').data('data'), $.fn.extable.options[id].selectIdx[0], $.fn.extable.options[id].selectIdx[1]);
                                }
                            }
                            break;
                        case '113':
                            // f2
                            var editorOpen = $.fn.extable.options[id].column[$.fn.extable.options[id].selectIdx[0]].editor.open;
                            var parameters = {};
                            parameters.rowIndex = $.fn.extable.options[id].selectIdx[1];
                            parameters.colIndex = $.fn.extable.options[id].selectIdx[0];
                            parameters.data = main.extable('getRowData', $.fn.extable.options[id].selectIdx[1]);
                            if (typeof editorOpen === 'string') {
                                if (window[editorOpen]) {
                                    window[editorOpen](parameters);
                                }
                            } else if (typeof editorOpen === 'function') {
                                editorOpen(parameters);
                            }
                            if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                            	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {})
                            }
                            return false;
                    }
                }

                if(typeof $.fn.extable.options[id].column[afterX].keyDownBefore === 'function'){
                	$.fn.extable.options[id].column[afterX].keyDownBefore(keyDownParameters || {});
                }
                // }
            });
            
            
            $(input).keyup(function (event) {
            	var keyCode = (event.keyCode || event.which);
                var keyUpParameters = {};
                keyUpParameters.rowIndex = afterY;
                keyUpParameters.colIndex = afterX;
                keyUpParameters.columnName = $.fn.extable.options[id].column[afterX].title;
                keyUpParameters.keyCode = keyCode;
                keyUpParameters.beforeData = {};
                $.each($.fn.extable.options[id].arrayData[afterY], function(idx, item){
                	keyUpParameters.beforeData[$.fn.extable.options[id].colKey[idx]] = item;
                });
                keyUpParameters.data = main.extable('getRowData', afterY);
                if($.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').length){
                	beforeParam.data[$.fn.extable.options[id].colKey[$.fn.extable.options[id].selectIdx[0]]] = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + $.fn.extable.options[id].selectIdx[1] + ') td:eq(' + $.fn.extable.options[id].selectIdx[0] + ') input').val();
                }
                keyUpParameters.tblId = id;

                if(typeof $.fn.extable.options[id].column[afterX].keyUpAfter === 'function'){
                	$.fn.extable.options[id].column[afterX].keyUpAfter(keyUpParameters || {});
                }
            });
            // input 조립
            if($.fn.extable.options[id].disabled[afterX].match('disabled')){
                $.fn.extable.options[id].oldSelectIdx = [Number($.fn.extable.options[id].selectIdx[0].toString()), Number($.fn.extable.options[id].selectIdx[1].toString())];
                $.fn.extable.options[id].selectIdx = [afterX, afterY];
            }else{
            	$(span).append(input);
                $.fn.extable.options[id].rightContentTable.find('tr:eq(' + afterY + ') td:eq(' + afterX + ')').empty();
                $.fn.extable.options[id].rightContentTable.find('tr:eq(' + afterY + ') td:eq(' + afterX + ')').append(span);
                // select index update
                $.fn.extable.options[id].oldSelectIdx = [Number($.fn.extable.options[id].selectIdx[0].toString()), Number($.fn.extable.options[id].selectIdx[1].toString())];
                $.fn.extable.options[id].selectIdx = [afterX, afterY];
            }
            

            var afterParam = {};
            afterParam.beforeRowIndex = beforeY;
            afterParam.beforeColIndex = beforeX;
            afterParam.afterRowIndex = afterY;
            afterParam.afterColIndex = afterX;
            afterParam.beforeData = beforeData;
            afterParam.data = afterData;
            if (typeof $.fn.extable.options[id].clickAfter === 'function') {
        		$.fn.extable.options[id].clickAfter(afterParam);
            }
            $(input).focus().select();
        },
        setInpValueUpdate: function (focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // focus 정의된 input value 확인
            var cell = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + focusX + ')');
            var inp;
            if ($(cell).find('span input').length > 0) {
                inp = $(cell).find('span input');
            } else {
                return true;
            }
            // input value 업데이트
            $.fn.extable.options[id].arrayData[focusY][focusX] = ($(inp).val() || '');
            $.fn.extable.options[id].data[focusY][$.fn.extable.options[id].colKey[focusX]] = ($(inp).val() || '');
            return true;
        },
        removeInp: function (focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // input 삭제
            var cell = $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + focusX + ')');
            $(cell).contents().unbind().remove();
            /* 다른 테이블 클릭 시 드롭다운 안없어져서 추가 - 신재호 */
            $('.AutoCompleteClass').contents().unbind().remove().hide();
            $('#ui-datepicker-div').unbind().remove();
            // 저장된 값 표현
            var span = document.createElement('span');
            $(span).append($.fn.extable.options[id].arrayData[focusY][focusX])
            $(cell).append(span);
            $.fn.extable.options[id].selectIdx = [-1, $.fn.extable.options[id].selectIdx[1]];
            return true;
        },
        eventRowClick: function (targetRow) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 중복클릭 확인
            if ($.fn.extable.options[id].selectIdx[1] == $(this).index()) {
                return false;
            }
            // TODO: row click before event
            var beforeData = ($.fn.extable.options[id].selectIdx[1] > -1 ? main.exSubTable('getJsonData', $.fn.extable.options[id].selectIdx[1]) : {});
            var afterData = main.exSubTable('getJsonData', targetRow.index());
            if (true) {
                // TODO: row click process
                // TODO: row click after event
            } else {
                return false;
            }
        },
        setDisplayUpdate: function (focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // display col update
            var data = $.fn.extable.options[id].arrayData[focusY];
            $.each(data, function (colIdx, colValue) {
                var span = document.createElement('span');
                // TODO: displayKey 프로세스 구현
                if (typeof $.fn.extable.options[id].displayKey[colIdx] === 'function') {
                    $(span).append($.fn.extable.options[id].displayKey[colIdx]());
                } else if ($.fn.extable.options[id].displayKey[colIdx] instanceof Array) {
                    var arrValue = $.fn.extable.options[id].displayKey[colIdx];
                    var dispValue = '';
                    $.each(arrValue, function (keyIdx, key) {
                        if ($.fn.extable.options[id].colKey.indexOf(key) >= 0) {
                            dispValue += ($.fn.extable.options[id].arrayData[focusY][$.fn.extable.options[id].colKey.indexOf(key)] || '');
                        } else {
                            dispValue += key;
                        }
                    });
                    $(span).append((dispValue || ''));
                } else {
                    $(span).append((colValue || ''));
                }

                if ($.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ') span input').length > 0) {
                    if (typeof $.fn.extable.options[id].displayKey[colIdx] === 'function') {
                        $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ') span input').val($.fn.extable.options[id].displayKey[colIdx]());
                    } else if ($.fn.extable.options[id].displayKey[colIdx] instanceof Array) {
                        var arrValue = $.fn.extable.options[id].displayKey[colIdx];
                        var dispValue = '';
                        $.each(arrValue, function (keyIdx, key) {
                            if ($.fn.extable.options[id].colKey.indexOf(key) >= 0) {
                                dispValue += ($.fn.extable.options[id].arrayData[focusY][$.fn.extable.options[id].colKey.indexOf(key)] || '');
                            } else {
                                dispValue += key;
                            }
                        });
                        $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ') span input').val((dispValue || ''));
                    } else {
                        $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ') span input').val((colValue || ''));
                    }
                } else {
                    $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ')').contents().unbind().remove();
                    $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + colIdx + ')').append(span);
                }
            });
            return true;
        },
        setRemoveRowSelectClass: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // tr class 제거
            $.each(classes.rowOn.split(' '), function (idx, styleCls) {
                $.fn.extable.options[id].rightContentTable.find('.' + styleCls).removeClass(styleCls);
            });
            return true;
        },
        setAddRowSelectClass: function (focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // tr class 추가
            $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ')').addClass(classes.rowOn);
            return true;
        },
        setRemoveColSelectClass: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // td class 제거
            $.each(classes.colOn.split(' '), function (idx, styleCls) {
                $.fn.extable.options[id].rightContentTable.find('.' + styleCls).removeClass(styleCls);
            });
            return true;
        },
        setAddColSelectClass: function (focusX, focusY) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // td class 추가
            $.fn.extable.options[id].rightContentTable.find('tr:eq(' + focusY + ') td:eq(' + focusX + ')').addClass(classes.colOn);
            return true;
        },
        setRemoveInpSelectClass: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // span class 제거
            $.each(classes.spanOn.split(' '), function (idx, styleCls) {
                $.fn.extable.options[id].rightContentTable.find('.' + styleCls).removeClass(styleCls);
            });
            return true;
        },
        setColDIsplay: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // display 설정
            $.each($.fn.extable.options[id].display, function (colIdx, dispValue) {
                if (dispValue != 'Y'
                    && dispValue != '1'
                    && dispValue != true) {
                    // header th display hide
                    $.fn.extable.options[id].rightHeaderTable.find('th:eq(' + colIdx + ')').css('display', 'none');
                    // content td display hide
                    $.fn.extable.options[id].rightContentTable.find('td.col-' + colIdx).css('display', 'none');
                }
                else {
                    // header th display hide
                    $.fn.extable.options[id].rightHeaderTable.find('th:eq(' + colIdx + ')').css('display', '');
                    // content td display hide
                    $.fn.extable.options[id].rightContentTable.find('td.col-' + colIdx).css('display', '');
                }

                // 여기가 조금 이상함. col width=0 이면 처리되나?
                var rightColGroup = '';
                $.each($.fn.extable.options[id].width, function (idx, item) {
                    if ($.fn.extable.options[id].display[idx] == 'Y'
                        || $.fn.extable.options[id].display[idx] == '1'
                        || $.fn.extable.options[id].display[idx] == true) {
                        if (item != '') {
                            rightColGroup += '<col width="' + item + '" />';
                        } else {
                            rightColGroup += '<col />';
                        }
                    }
                });
                $.fn.extable.options[id].rightHeaderTable.find('colgroup').empty().append(rightColGroup);
                $.fn.extable.options[id].rightContentTable.find('colgroup').empty().append(rightColGroup);
            });
            return true;
        },
        getJsonToArray: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 타입변환
            var arrayData = [];
            $.each($.fn.extable.options[id].colKey, function (colIdx, key) {
                arrayData[colIdx] = (parameters[key] || '').toString();
            });
            // 반환처리
            return arrayData;
        },
        getArrayToJson: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 타입변환
            var jsonData = {};
            $.each($.fn.extable.options[id].colKey, function (colIdx, key) {
                jsonData[key] = (parameters[colIdx] || '').toString();
            });
            // 반환처리
            return jsonData;
        },
        setArrayDataSave: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 데이터 저장
            $.fn.extable.options[id].arrayData.push(parameters);
            return true;
        },
        setJsonDataSave: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 데이터 저장
            $.fn.extable.options[id].data.push(parameters);
            return true;
        },
        getArrayData: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 반환 정의
            if (isNaN(parameters) || parameters < 0) {
                return {};
            } else {
                return $.fn.extable.options[id].arrayData[parameters];
            }
        },
        getJsonData: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 반환 정의
            if (isNaN(parameters) || parameters < 0) {
                return {};
            } else {
                return $.fn.extable.options[id].data[parameters];
            }
        },
        setRowPop: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            if (isNaN(parameters) || parameters < 0) {
                return false;
            } else {
                // element pop
                $.fn.extable.options[id].rightContentTable.find('tr:eq(' + parameters + ')').unbind().remove();
                // data pop
                main.exSubTable('setArrayDataPop', parameters);
                main.exSubTable('setJsonDataPop', parameters);
                if(typeof $.fn.extable.options[id].oldSelectIdx != 'undefined'){
                	$.fn.extable.options[id].oldSelectIdx = [Number($.fn.extable.options[id].oldSelectIdx[0]), Number($.fn.extable.options[id].oldSelectIdx[1])];
                }
                $.fn.extable.options[id].selectIdx = [-1, -1];
                return true;
            }
        },
        setArrayDataPop: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 데이터 삭제
            parameters = (parameters || -1);
            if (parameters >= 0) {
                $.fn.extable.options[id].arrayData.splice(parameters, 1);
                return true;
            } else {
                return false;
            }
        },
        setJsonDataPop: function (parameters) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // 데이터 삭제
            parameters = (parameters || -1);
            if (parameters >= 0) {
                $.fn.extable.options[id].data.splice(parameters, 1);
                return true;
            } else {
                return false;
            }
        },
        getJsonDataDefaults: function () {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // default json 확인
            var tempJson = {};
            $.each($.fn.extable.options[id].colKey, function (colIdx, key) {
                tempJson[key] = '';
            })
            return tempJson;
        },
        setRowRender: function (parameters, type) {
            // element 정의
            var id = $(this).prop('id');
            var main = $(this);
            // type 확인
            type = (type || 'new');
            // data type 확인 ( array or json )
            if (parameters instanceof Array) {
                // array 인 경우 처리
                parameters = main.exSubTable('getArrayToJson', parameters);
            }
            // default json 확인
            var tempJson = main.exSubTable('getJsonDataDefaults');
            parameters = (parameters || {});
            parameters = $.extend(tempJson, parameters);
            // row add function 정의
            var rowAdd = function () {
                // row render
                var tr;
                tr = document.createElement('tr');
                $(tr).addClass('row-' + ($.fn.extable.options[id].rowSize));
                if (typeof $.fn.extable.options[id].row.classes === 'function') {
                    $(tr).addClass($.fn.extable.options[id].row.classes());
                }

                $.each($.fn.extable.options[id].colKey, function (colIdx, key) {
                    var td;
                    td = document.createElement('td');
                    // 기본 class 추가
                    $(td).addClass('row-' + ($.fn.extable.options[id].rowSize - 1));
                    $(td).addClass('col-' + colIdx);
                    $(td).addClass('col-' + colIdx);
                    switch (($.fn.extable.options[id].align[colIdx] || 'center').toString()) {
                        case 'center':
                        case 'cen':
                            $(td).addClass('cen');
                            break;
                        case 'left':
                        case 'le':
                            /* TODO: 정렬 다시 확인할 것 */
                            $(td).addClass('le');
                            break;
                        case 'right':
                        case 'ri':
                            $(td).addClass('ri');
                            break;
                    }
                    // 사용자 정의 class 추가
                    $(td).addClass($.fn.extable.options[id].column[colIdx].classes);
                    // 표현 텍스트 정의
                    var span = document.createElement('span');
                    // TODO: displayKey 처리
                    if (typeof $.fn.extable.options[id].displayKey[colIdx] === 'function') {
                        $(span).append($.fn.extable.options[id].displayKey[colIdx]());
                    } else if ($.fn.extable.options[id].displayKey[colIdx] instanceof Array) {
                        var arrValue = $.fn.extable.options[id].displayKey[colIdx];
                        var dispValue = '';
                        $.each(arrValue, function (keyIdx, key) {
                            if ($.fn.extable.options[id].colKey.indexOf(key) >= 0) {
                                dispValue += (parameters[key] || '');
                            } else {
                                dispValue += key;
                            }
                        });
                        $(span).append((dispValue || ''));
                    } else {
                        $(span).append((parameters[key] || ''));
                    }
                    // $(span).append(parameters[key]);
                    // TODO: td click event
                    if($.fn.extable.options[id].column[colIdx].type !== 'checkbox'){
	                    $(td, span).click(function () {
	                        main.exSubTable('eventColCLick', $(this));
	                        return false;
	                    });
                    }

                    $(td).append(span);
                    $(tr).append(td);
                });
                // TODO: tr click event
                $(tr).click(function (event) {
                	if(event.target.type !== 'checkbox'){
                		main.exSubTable('eventRowClick', $(this));
                    	return false;
                	}
                });
                // row append
                $.fn.extable.options[id].rightContentTable.append(tr);
                // data save
                if (type.toLowerCase() === 'new') {
                    main.exSubTable('setArrayDataSave', main.exSubTable('getJsonToArray', parameters));
                    main.exSubTable('setJsonDataSave', parameters);
                }
            }
            // type == new 인 경우 이벤트 호출
            if (type.toLowerCase() === 'new') {
                // TODO: row before add event call
                if (true) {
                    rowAdd();
                    // TODO: row add after event call
                } else {
                    return false;
                }
            } else {
                rowAdd();
            }

            $.fn.extable.options[id].rowSize = $.fn.extable.options[id].arrayData.length;
            main.extable('setRowDisable', 0, ($.fn.extable.options[id].rowSize - 1), $.fn.extable.options[id].disabled[0]);
            return true;
        },
        setTabelRender: function () {
            // element 정의
            var id = ($(this).prop('id') || '');
            var main = $(this);
            // main element 점검
            if (!(main[0].tagName.toString().toUpperCase() === 'DIV')) {
                $.error('div가 선택되지 않았습니다.');
                return false;
            }
            // main element class 지정
            if (!main.hasClass(classes.mainDiv)) {
                main.addClass(classes.mainDiv);
            }
            // scrollConvert 정의 및 class 지정
            var scrollCover;
            scrollCover = document.createElement('span');
            $(scrollCover).addClass(classes.scrollCover);
            // right header div 정의 및 class 지정
            var rightHeaderDiv;
            rightHeaderDiv = document.createElement('div');
            $(rightHeaderDiv).addClass(classes.rightHeaderDiv);
            // right header tabel 정의 및 class 지정
            var rightHeaderTable;
            rightHeaderTable = document.createElement('table');
            // right header colgroup 정의 및 class 지정
            var rightColGroup = '';
            $.each($.fn.extable.options[id].width, function (idx, item) {
                if (item != '') {
                    rightColGroup += '<col width="' + item + '" />';
                } else {
                    rightColGroup += '<col />';
                }
            });
            $(rightHeaderTable).append((rightColGroup = '<colgroup>' + rightColGroup + '</colgroup>'));
            // right header th 정의 및 class 지정
            var th = '';
            $.each($.fn.extable.options[id].title, function (idx, item) {
                if ($.fn.extable.options[id].reqYN[idx].toString().toUpperCase() === 'Y'
                    || $.fn.extable.options[id].reqYN[idx].toString().toUpperCase() === '1'
                    || $.fn.extable.options[id].reqYN[idx].toString().toUpperCase() === true) {
                    th += '<th><img src="../../../Images/ico/ico_check01.png" alt="" />&nbsp;' + item + '</th>';
                }
                else { th += '<th>' + item + '</th>'; }
            });
            $(rightHeaderTable).append('<tr>' + th + '</tr>');
            // right content div 정의 및 class 지정
            var rightContentDiv;
            rightContentDiv = document.createElement('div');
            $(rightContentDiv).addClass(classes.rightContentDiv);
            $(rightContentDiv).scroll(function () {
                $('#' + id + 'AutoComplete').hide();
            });
            if ($.fn.extable.options[id].height) { $(rightContentDiv).css('height', $.fn.extable.options[id].height); }
            // right content table 정의 및 class 지정
            $(rightContentDiv).attr('onscroll', 'table1Scroll()');
            var rightContentTable;
            rightContentTable = document.createElement('table');
            $(rightContentTable).append(rightColGroup);
            /* 테이블 조립 */
            $(rightHeaderDiv).append(rightHeaderTable);
            $(rightContentDiv).append(rightContentTable);
            main.append(scrollCover);
            main.append(rightHeaderDiv);
            main.append(rightContentDiv);
            main.append('<div id="' + id + 'AutoComplete" class="posi_ab" style="display:none;"></div>');
            /* id + AutoComplete */
            /* 테이블 변수 정의 */
            $.fn.extable.options[id].rightHeaderTable = $(rightHeaderTable);
            $.fn.extable.options[id].rightContentTable = $(rightContentTable);
            return true;
        },
        getDefaults: function () {
            return {
                /* 자동 생성 */
                title: [], /* 그리드에서 column을 기초로 자동 생성합니다. 타이틀 정보를 배열로 가집니다. (function or string) */
                display: [], /* 그리드에서 column을 기초로 자동 생성합니다. 화면상 표현 여부 정보를 배열로 가집니다. (function or string) */
                displayKey: [], /* 그리드에서 column을 기초로 자동 생성합니다. 나타낼 문저열 조합의 정보를 배열로 가집니다. 구분자는 "▥" 를 사용합니다. (function or string) */
                colKey: [], /* 그리드에서 column을 기초로 자동 생성합니다. json 키 값 정보를 배열로 가집니다. */
                width: [], /* 그리드에서 column을 기초로 자동 생성합니다. 너비 정보를 배열로 가집니다. (function or string) */
                reqYN: [], /* 그리드에서 column을 기초로 자동 생성합니다. 필수 입력 정보를 배열로 가집니다. (function or string) */
                align: [], /* 그리드에서 column을 기초로 자동 생성합니다. 정렬 정보를 배열로 가집니다. (function or string) */
                type: [],
                disabled: [],
                arrayData: [], /* data와 동기화 됩니다. data는 json으로, arrayData는 배열로 정보를 저장합니다. */
                classes: [], /* 그리드에서 column을 기초로 자동 생성합니다. 사용자 정의 class 정보를 배열로 가집니다. (function or string) */
                mask: [], /* 그리드에서 column을 기초로 자동 생성합니다. mask 정보를 배열로 가집니다. (function or string) */
                rowSize: 0, /* y의 크기를 자동으로 저장합니다. */
                colSize: 0, /* x의 크기를 자동으로 저장합니다. */
                selectIdx: [0, 0], /* 현재 선택된 셀의 위치(x, y)를 저장합니다. */
                leftHeaderTable: null, /* 왼쪽 헤더 테이블 */
                leftContentTable: null, /* 왼쪽 본문 테이블 */
                rightHeaderTable: null, /* 오른쪽 헤더 테이블 */
                rightContentTable: null, /* 오른쪽 본문 테이블 */
                /* 사용자 정의 */
                column: [],
                columnRow: [[]],
                row: {
                    classes: function () {
                        return '';
                    }
                },
                data: [],
                height: 27,
                level: 0,
                clickBefore: function (obj) { return true; },
                clickAfter: function (obj) { return true; },
                keyDownBefore: function (obj) { return true; }
                /* callback 정의 */
            }
        },
        getDefaultsColumn: function () {
            return {
                title: '', /* 제목 */
                display: 'Y', /* 표현 여부 (표현 : Y / 미표현 : N) */
                displayKey: '', /* 나타낼 문저열 조합의 정보, 구분자는 "▥" 를 사용 */
                colKey: '', /* json 연동 키 */
                width: '100', /* 너비 */
                reqYN: 'N', /* 필수 입력 여부 */
                align: 'center', /* 정렬 */
                type: 'text', /* 입력 포맷 (text, combo, datepicker) */
                comboData: {},
                disabled: '',
                classes: '',
                mask: '',
                editor: { open: function (obj) { /* code pop or layer pop */ }, close: function (obj) { /* code pop or layer pop callback */ } }
            }
        }
    };

    $.fn.exSubTable = function (method) {
        if (subMethods[method]) { return subMethods[method].apply(this, Array.prototype.slice.call(arguments, 1)); }
        else { $.error('! 존재하지 않는 기능입니다...'); }
    }

    $.fn.extable = function (method) {
        if (typeof method === 'object' || !method) { return methods.init.apply(this, arguments); }
        else if (methods[method]) {
        	console.log('[ #조# ' + method + ' #영욱# ]');
        	return methods[method].apply(this, Array.prototype.slice.call(arguments, 1)); 
    	} else {
			$.error('! 존재하지 않는 기능입니다...');
    	}
    };
})(jQuery)

///* 행 데이터 반영 */
//$('#tbl').extable('setRowData', { value: '' }, PositionX, PositionY);
///* 행 데이터 조회 */
//$('#tbl').extable('getRowData', PositionY);
///* 데이블 전체 데이터 조회 */
//$('#tbl').extable('getAllData');
///* 컬럼 재정의(보이고, 안보이고 정의) */
//$('#tbl').extable('setDisplayChange', ["Y", "Y", "N", "..."]);
///* 행삭제 */
//$('#tbl').extable('setRemoveRow', PositionX);
///* 포커스 */
//$('#tbl').extable('setFocus', PositionX, PositionY);
///* keyDown event */
//keyDownBefore function 정의
//  - rowIndex, colIndex, columnName, keyCode, data
///* 현재 행 정보 반환 */
//$('#tbl').extable('getSelectedRowData');
///* input 제거 */
//$('#tbl').extable('setRemoveEditor');
///* 현재행의 필수값 입력 여부 확인 */
//$('#tbl').extable('getReqCheck');
//  >> {notInput: [], pass: true} (pass === true : 모두 입력 / pass === false : 미입력 존재 - 미입력 항목은 notInput 참조)