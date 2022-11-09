/**
 *
 */

NeosLumpCodeUtil = {

	/**
	 * 코드 이름 조회
	 * @param codeID 그룹코드ID
	 * @param code 코드ID
	 * @returns {String}
	 */
	getCodeName : function( codeID, code ) {
		var codeName = "" ;

		try {
            $.ajax({
                type: "POST",
                url: getContextPath()+"/cmm/system/commonCodeName.do",
                async: false,
                datatype: "text",
                data: ({ codeID: codeID, code: code }),
                success: function (data) {
                	codeName =  data.codeName;
                },
                error: function (XMLHttpRequest, textStatus) {

                }
            });
        }
        catch (e) {
console.log(e);//오류 상황 대응 부재
        }
        return codeName ;
	},

	/**
	 * 코드리스트 조회
	 * @param codeID 그룹코드ID
	 * @returns {String}
	 */
	getCodeList : function( codeID ) {
		var list = "" ;
		try {
	        $.ajax({
	            type: "POST",
	            url: getContextPath()+"/cmm/system/commonCodeList.do",
	            async: false,
	            datatype: "text",
	            data: ({ codeID: codeID }),
	            success: function (data) {
	            	list =  data.list;
	            },
	            error: function (XMLHttpRequest, textStatus) {
	            }
	        });
	    }
	    catch (e) {
console.log(e);//오류 상황 대응 부재
	    }
    	return list ;
	},

	/**
	 * 코드리스트를 조회했어 HTML 라디오 버튼을 생성
	 * @param codeID  그룹코드ID
	 * @param name  라디오버튼 이름,
	 * @param valueChecked checked할 codeID, FIRST 일경우 처음 라디오 버튼을 checked, 값이 없을경우는 chekced 안함.
	 * @param fncEvent 이벤트 이름
	 * @returns {String}
	 */
	getCodeRadio: function(codeID, name, tabNumber ,checkedValue , fncEvent  ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = false ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onClick= \""+fncEvent+"\"";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(checkedValue == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( checkedValue == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= \"radio\" class= \"mL5\" name = \""+name+"_"+tabNumber+"\" id = \""+name+(inx+1)+"_"+tabNumber+"\" value = \""+list[inx].CODE+"\" " + event+ " "  +checked+ "> <label for='"+name+(inx+1)+"_"+tabNumber+"' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}

		return html ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @param firstName
	 * @param firstValue
	 * @returns {String}
	 */
	getCodeSelectFirstName: function(codeID, name, selectedValue ,  style, fncEvent, firstName, firstValue, classValue  ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var selected = "" ;
		var event = "" ;
		var className = "" ;

		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= \""+fncEvent+"\"";
		}

		if (style != "" && style != undefined ) {
			style = "style= '"+style+"'";
		}else {
			style = "" ;
		}
		if (classValue != "" && classValue != undefined ) {
			className = "class= '"+classValue+"'";
		}else {
			className = "" ;
		}

		if( firstValue == undefined ) {
			firstValue = "" ;
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		html += "<select name = '" + name + "' id = '"+name+"'  " +className + " " +style + " "+ event+ " >";

		if(firstName != "" && firstName != undefined ) {
			html += "<option  value = '"+firstValue+"' >"+firstName+"</option>";
		}

		for(var inx = 0 ; inx < rowNum; inx++) {

			if( selectedValue == list[inx].CODE) {
				selected = "selected" ;
			}
			html += "<option  value = '"+list[inx].CODE+"' "+selected+" >" + list[inx].CODE_NM +"</option>";
			selected = "" ;
		}
		html += "</select>" ;
		return html ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @returns {String}
	 */
	getCodeSelect: function(codeID, name, selectedValue ,  style, fncEvent  ) {

		return this.getCodeSelectFirstName(codeID, name, selectedValue, style, fncEvent, "전:::체", "") ;
	},

	/**
	 * checkbox 를 생성
	 * @param codeID
	 * @param name
	 * @param valueChecked
	 * @param fncEvent
	 * @returns {String}
	 */
	getCodeCheck: function(codeID, name, tabNumber,  valueChecked , fncEvent  ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = "" ;
		var event = "" ;

		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= \""+fncEvent+"\"";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(valueChecked == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( valueChecked == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= 'checkbox' class= \"mL5\"  name = \""+name+"_"+tabNumber+"\" id = \""+name+(inx+1)+"_"+tabNumber+"\"  value = '"+list[inx].CODE+"' " + event+ " "  +checked+ "> <label for='"+name+(inx+1)+"' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}
		return html ;
	},


	/**
	 *  Add edward   공통 상세코드 등록시 코드ID 선택 박스 처리
	 * @see getCodeSelectFirstName()
	 * @param list  코드목록
	 * @param selectClCode 선택된 clCode
	 * @param name  select form name,id
	 * @param fncEvent  onclilk event name
	 *
	 */
	getCodeSelectList: function(list, name, selectClCode, fncEvent  ) {

		var html = "" ;
		var rowNum = 0 ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= \""+fncEvent+"\"";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		html += "<select name = '" + name + "' id = '"+name+"' "+ event+ " >";

		//codeDetailObj.clCodeObj = [{"rnum":2,"clCode":"APP","clCodeNm":"전자결재_공통코드","useAt":"Y"}]
		//codeDetailObj.codeIdObj = [{"rnum":1,"clCodeNm":"전자정부 프레임워크 공통서비스","codeId":"COM001","codeIdNm":"등록구분","useAt":"Y","clCode":"EFC"}]

		for(var inx = 0 ; inx < rowNum; inx++) {

			if(name=="clCode"){  // 공통 상세코드
				html += "<option  value = '"+list[inx].clCode+"'>" + list[inx].clCodeNm +"</option>";
			}else if(name=="codeId"){  //   공통 상세 코드
				if( selectClCode == list[inx].clCode) {// 선택된 clCode 만 보인다.
					html += "<option  value = '"+list[inx].codeId+"'>" + list[inx].codeIdNm+"</option>";
				}
			}else if(name=="restdeSeCode"){  // 휴일일자
				html += "<option  value = '"+list[inx].code+"'>" + list[inx].codeNm +"</option>";
			}
		}
		html += "</select>" ;

		return html ;
	}
};