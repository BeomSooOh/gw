<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    /**
     * @Class Name : SearchFormDefault.jsp
     * @Description : 공통 검색 창 첫번째 버전
     * @Modification Information
     * @
     * @  수정일         수정자                   수정내용
     * @ -------    --------    ---------------------------
     * @ 2012.04.30    김석환          최초 생성
     * @ 2013.01.31    안창호           기간 설정에 전체 구간 추가 
     *  @author 포털개발팀 김석환
     *  @since 2012.04.30
     *  @version 1.0
     *  @see
     *
     */
%>

<!-- 검색조건 시작 -->
<div class="top_box" id="searchCriteria">
	<div class="top_box_in"> 
    <span class="mR10"><select name="selectTerm" id="selectTerm" title='<spring:message code="search.term" />' ${isUseDateSearch } style="width:70px;" >
                <option value="" class="optionAll"><spring:message code="search.term" /></option>
                <option value="day"><spring:message code="search.1day" /></option>
                <option value="week"><spring:message code="search.1week" /></option>
                <option value="month"><spring:message code="search.1month" /></option>
                <option value="3month">3달</option>
<!--                <option value="6month">6달</option> -->
                <!-- 구문서  조회의 경우 기간 제한이 필요 없는 부분이 있어 옵션 추가 --> 
                <c:if test="${ termgGbn  eq 'oldDoc' }">
                <!--    <option value="freeTerm"><spring:message code="search.dateSelect" />  </option> -->
                <option value="freeTerm"><spring:message code="search.freeTerm" />  </option> 
                </c:if>
        </select></span>
        
        <span id="showhide">
        	<input type="text" name="fromDate" id="fromDate" ${isUseDateSearch } size="13" maxlength="10" value="${searchParamVO.c_startDate_origin }" style="width:150px;"  /> ~
        	<input type="hidden" name="searchFromDate" id="searchFromDate" value="${searchParamVO.c_startDate_origin }"  />
            <input type="text" name="toDate" id="toDate" size="13" ${isUseDateSearch } maxlength="10" value="${searchParamVO.c_endDate_origin }" style="width:150px;"  /></span>
            <input type="hidden" name="searchToDate" id="searchToDate"  value="${searchParamVO.c_endDate_origin }"/>
        <span><select id="selectSearchType" name="selectSearchType" title='<spring:message code="search.searchtype" />'  style="width:70px;">
                <!-- option value="" class="optionAll"><spring:message code="search.searchtype" /></option-->
                <option value="c_dititle" selected="selected"><spring:message code="search.c_dititle" /></option>
                <option value="username"><spring:message code='search.username' /></option>
                <option value="c_ridocnum"><spring:message code='search.c_ridocnum' /></option>
                <option value="c_riafterreceive"><spring:message code='search.c_riafterreceive' /></option>
        </select>
          <input type="hidden" name="searchSelectSearchType" id="searchSelectSearchType"  value=""/>
        </span>
        <span><input type="text" name="keyword" id="keyword" class="k-textbox kr" value="${searchParamVO.searchText }" size="20" maxlength="12"  style="width: 180px;"/>
              <input type="hidden" name="searchKeyword" id="searchKeyword"  value=""/>
        </span>
        
        <span><select id="signtype_select" name="signtype_select" style="display: none; width:90px;" title='<spring:message code="search.term" />' >
                <!-- <option value="">결재유형</option>
                <option value="approval">결재</option>
                <option value="cooperation">협조</option> -->
                <!--        <option value="reading">열람</option>
        <option value="postpone">보류</option> -->
        </select>
        <input type="hidden" name="searchSigntype_select" id="searchSigntype_select"  value=""/>
        </span>
        <span><select id="docflag_select" name="docflag_select" style="display: none; width:90px;" title='문서형태' >
        </select>
        <input type = "hidden" name = "searchDocflag_select" id = "searchDocflag_select" value = "" >
        </span>
        <a href="javascript:;"
            onclick="approvalSearchForm.submit()">
            <input id="searchButton" type="button" value="<spring:message code='search.search' />"></a>
    </div>            
    <script type="text/javascript">
        var approvalSearchForm = {};
        $(function() {
        	var bfsdate = $("#fromDate").val();
            var vfedate = $("#toDate").val();
            
		    $("#selectSearchType").kendoComboBox();
		    
		    
            
            
/*            
            var pickerOpts = {
                showOn : 'button',
                buttonImage : NeosUtil.getCalcImg(),
                buttonImageOnly : false,
                changeMonth : true,
                changeYear : true,
                buttonText : "<spring:message code='search.dateSelect' />",
                duration : "normal",
                onSelect : function(dateText, inst) {
                    var id = $(inst).attr("id");
                    var instday = parseInt(inst.selectedDay, 10) < 10 ? "0"+inst.selectedDay:inst.selectedDay;

                    var seldate = inst.selectedYear + '-' + Number(inst.selectedMonth)+1 +'-'+instday;
                    if(id=="c_startDate"){
                                            if($("#c_endDate").val()<dateText){
                                                $("#c_startDate").val(bfsdate);
                                            alert('시작일이 종료일보다 이후일수 없습니다.');
                                            return;
                                            }
                                        }else if(id=="c_endDate"){
                                            if($("#c_startDate").val()>dateText){
                                                $("#c_endDate").val(vfedate);
                                                alert('시작일이 종료일보다 이후일수 없습니다.');
                                                return;
                                                } 
                                        }
                    approvalSearchForm.datepickerOnSelect(dateText, id);
                }
            };

   */         
        <c:choose>
            <c:when test="${empty isUseDateSearch }">
            /*날짜검색 사용할때만 달력 나와야함.*/
 //           //neosdatepicker.datepicker("c_startDate", pickerOpts);
 //           //neosdatepicker.datepicker("c_endDate", pickerOpts);
            $("#selectTerm").kendoComboBox();
            
            $("#fromDate").kendoDatePicker( {
            	format : "yyyy-MM-dd",
            	culture : "ko-KR"
            });
            $("#toDate").kendoDatePicker( {
            	format : "yyyy-MM-dd",
            	culture : "ko-KR"
            });
            </c:when>
        </c:choose>
            
            //날짜 밸리데이션
            $("#fromDate, #toDate").bind({
                focusout:function(event){
                    var textbox = $(this);
                    var isValid = approvalSearchForm.dateSelfInputKeyPress(textbox);
                    if(!isValid){
                        alert('<spring:message code="search.inValidDateMsg" />');
                        textbox.focus();
                        textbox.select();
                    }
                    else{
                        var dateText = textbox.val();
                        var id = textbox.attr("id");
                        approvalSearchForm.datepickerOnSelect(dateText, id);
                    }
                }
            });

            
            
            //기간 변경
            $("#selectTerm").bind({
                change : function() {
                    var selectTerm = $("#selectTerm").val();
                    approvalSearchForm.selectTermChange(selectTerm);
                }
            });

            //검색조건 변경
            $("#selectSearchType").bind({
                change : function() {
                    approvalSearchForm.selectSearchTypeChange();
                }
            });

            //select 초기화
            approvalSearchForm.selectInit();
            

            $(window).resize(function(){
                //approvalSearchForm.resizeTopSearch();
            });
            //approvalSearchForm.resizeTopSearch();
            
            
            $("#searchText").bind({
                keyup : function(event){
                    if(event.keyCode==13){
                        approvalSearchForm.pagingClick(1);
                    }
                }
            });
        });

        
        
        //직접 입력
        approvalSearchForm.dateSelfInputKeyPress = function(textbox){
            //var textbox = $(event.target);
            var isValid = false;
            var dateStr = textbox.val();
            isValid = approvalSearchForm.DateValidate(dateStr);
            return isValid;
        };
        approvalSearchForm.DateValidate = function(dateStr){
            var isValid = false;
            var date = new Date();
            var dateStrArr = [];
            if(dateStr){
                dateStrArr = dateStr.split("-");
            }
            
            if(dateStrArr.length!=3){
                isValid = false;
            }
            else{
                if(parseInt(dateStrArr[0], 10) && parseInt(dateStrArr[1], 10) && parseInt(dateStrArr[2], 10) 
                    && dateStrArr[0].length==4 && dateStrArr[1].length==2 && dateStrArr[2].length==2){
                    date.setFullYear(parseInt(dateStrArr[0]), parseInt(dateStrArr[1]), parseInt(dateStrArr[2]));
                    if(date){
                        isValid = true;
                    }
                }
                else{
                    isValid = false;
                }
            }
            
            return isValid;
        };
        //검색창 사이즈
        approvalSearchForm.resizeTopSearch = function(){
            var win_w1 = $(window).width();
            var min = jqGridUtil.minWidth();
            
             if(win_w1 && parseInt(win_w1)< parseInt(min)){
                 return false;
             }
             var leftWidth = NeosUtil.getLeftMenuWidth();
             var width = win_w1 - leftWidth - 14;
             //var width = $("div.cont_pad").width();
             //$(".top_search#searchCriteria").css("width", width);
        };
        
        //기간이 변경되었을 경우
        approvalSearchForm.selectTermChange = function(addDayString) {

            if (!addDayString) {
                return;
            }

            //month 일 때에만 month 에 +1 을 해주어야 한다.
            var termMap = {
                "day" : 1,
                "week" : 7,
                "month" : false,
                "3month" : false,
                "6month" : false,
                "freeTerm" : false
            };
            var addDay = termMap[addDayString] || 0;

            var c_endDate = $("#toDate").val();
            if ($.trim(c_endDate)) {

                var date = approvalSearchForm.ConvertStringToDate(c_endDate);
                if (addDay) {
                    date.setDate(date.getDate() - addDay);
                } else {
                    if (addDayString == "month") {
                        date.setMonth(date.getMonth() - 1);
                    }
                    else if(addDayString == "3month"){
                        date.setMonth(date.getMonth() - 3);
                    }
                    else if(addDayString == "6month"){
                        date.setMonth(date.getMonth() - 6);
                    }
                    
                
                }
                var dateString = approvalSearchForm.ConvertDateToString(date);
                if(addDayString == "freeTerm"){
                	$.ajax({
                		type:"get",
                		url:'<c:url value="/neos/edoc/document/olddoc/board/common/MinDate.do" />',
                		datatype:"json",
                		data: "",
                		success:function(data){
                			$("#fromDate").val(data.start);
                			$("#toDate").val(data.end);
                		}
                	});
                }else{
                	$("#fromDate").val(dateString);
                }
            }
        };

        //검색조건이 변경되었을 경우
        approvalSearchForm.selectSearchTypeChange = function(){
            var selectSearchType  = $("#selectSearchType").val();
            
            var searchText = selectSearchType;//searchTextList[selectSearchType];
    
            if(searchText){
                $("#keyword").attr("name", searchText);
                $("#keyword").attr("disabled", false);
            }
            else{
                $("#keyword").attr("name","");
                $("#keyword").attr("disabled", "disabled");
            }
        };
        
        /*검색조건 값 셋팅*/
        approvalSearchForm.SelectSearchTypeObj = {
                "c_dititle":"<spring:message code='search.c_dititle' />",
                "username":"<spring:message code='search.username' />",
                "c_ridocnum":"<spring:message code='search.c_ridocnum' />",
                "c_riafterreceive":"<spring:message code='search.c_riafterreceive' />",
                "orgdept":"발송처",
                "inner":"대내",
                "outter":"대외"
        };
        
        approvalSearchForm.SelectSearchTypeSet = function(obj){
            var selectSearchType =$("#selectSearchType");
            var text = obj.text;
            var keyArray = obj.data;
            if(keyArray && keyArray.length && typeof keyArray =="object"){
                if(text){
                    selectSearchType.html("<option value='' class='optionAll'>"+text+"</option>");
                }
                else{
                    selectSearchType.html("");
                }
                
                for(var i=0; i<keyArray.length;i++){
                    if(keyArray[i] && approvalSearchForm.SelectSearchTypeObj[keyArray[i]])
                    {
                        var option = $("<option>");
                        option.val(keyArray[i]);
                        option.text(approvalSearchForm.SelectSearchTypeObj[keyArray[i]]);
                        selectSearchType.append(option);
                    }
                }
            }
        };
        
        //datepicker 날짜 선택이 변경 되었을 경우
        approvalSearchForm.datepickerOnSelect = function(dateText, inst) {

            var targetObj = {
                "fromDate" : "fromDate",
                "toDate" : "toDate"
            };
            var target = targetObj[inst];

            if (!target) {
                return;
            }
            
            var selectTerm = $("#selectTerm").val();
            if(!selectTerm){
                return;
            }
            var addDayString = selectTerm;
            
            
            //month 일 때에만 month 에 +1 을 해주어야 한다.
            var termMap = {
                "day" : 1,
                "week" : 7,
                "month" : false,
                "3month" : false,
                "6month" :false,
                "freeTerm" :false
            };
            var addDay = termMap[addDayString] || 0;

            var date = approvalSearchForm.ConvertStringToDate(dateText);
            
            if (addDay) {
                if (target == "fromDate") {
                    date.setDate(date.getDate() - addDay);
                } else {
                    date.setDate(date.getDate() + addDay);
                }
            } else {
                if(addDayString == "freeTerm") {
                    return;
                }
                if (addDayString == "month") {
                    if (target == "fromDate") {
                        date.setMonth(date.getMonth() - 1);
                    } else {
                        date.setMonth(date.getMonth() + 1);
                    }
                }
                else if(addDayString == "3month"){
                    if (target == "fromDate") {
                        date.setMonth(date.getMonth() - 3);
                    } else {
                        date.setMonth(date.getMonth() + 3);
                    }
                    if (target == "fromDate") {
                        date.setMonth(date.getMonth() - 3);
                    } else {
                        date.setMonth(date.getMonth() + 3);
                    }
                    
                }
                else if(addDayString == "6month"){
                    if (target == "fromDate") {
                        date.setMonth(date.getMonth() - 6);
                    } else {
                        date.setMonth(date.getMonth() + 6);
                    }
                    if (target == "fromDate") {
                        date.setMonth(date.getMonth() - 6);
                    } else {
                        date.setMonth(date.getMonth() + 6);
                    }
                    
                }
                
            }
            var dateString = approvalSearchForm.ConvertDateToString(date);
            $("#" + target).val(dateString);
        };

        approvalSearchForm.ConvertStringToDate = function(dateString) {
            dateString = $.trim(dateString);
            var date = null;
            if (!dateString) {
                return new Date();
            }

            dateStringArr = dateString.split("-");
            if (dateStringArr.length < 3) {
                return new Date();
            }

            if (parseInt(dateStringArr[0], 10)
                    && parseInt(dateStringArr[1], 10)
                    && parseInt(dateStringArr[2], 10)) {
                date = new Date(parseInt(dateStringArr[0], 10), parseInt(
                        dateStringArr[1], 10) - 1, parseInt(dateStringArr[2],
                        10));
            } else {
                date = new Date();
            }
            return date;
        };

        approvalSearchForm.ConvertDateToString = function(date) {
            var newDate = new Date();
            var year = null;
            var month = null;
            var day = null;

            if (date) {

                year = date.getFullYear();
                month = date.getMonth();
                day = date.getDate();
            } else {
                year = newDate.getFullYear();
                month = newDate.getMonth();
                day = newDate.getDate();
            }

            month = month + 1;
            if (month < 10) {
                month = "0" + month;
            }
            if (day < 10) {
                day = "0" + day;
            }

            return year.toString() + "-" + month.toString() + "-"
                    + day.toString();
        };

        //select  초기화(상태유지)
        approvalSearchForm.selectInit = function() {

            //기간
            var term = "${searchParamVO.selectTerm }";
            $("#selectTerm option[value=" + term + "]").attr("selected",
                    "selected");

            //검색조건(제목, 기안자, 문서번호)
            var selectSearchType = "${searchParamVO.selectSearchType}";
            $("#selectSearchType option[value=" + selectSearchType + "]").attr(
                    "selected", "selected");

            //결재유형
            var signtype_select = "${searchParamVO.signtype_select}";
            $("#signtype_select option[value=" + signtype_select + "]").attr(
                    "selected", "selected");
            //문서형태
            var docflag_select = "${searchParamVO.docflag_select}";
            $("#docflag_select option[value=" + docflag_select + "]").attr(
                    "selected", "selected");

            approvalSearchForm.selectSearchTypeChange();
        };

        /*페이지 클릭*/
        approvalSearchForm.pagingClick = function(pageNo) {
            $("#pageIndex").val(pageNo);
            var searchForm = $("form#searchForm");
            if (searchForm.length) {
                searchForm.first().submit();
            }
        };

        /*1 : 결재유형 보이기, 2 : 결재유형 안보이기*/
        approvalSearchForm.SearchFormType = function(type) {
            var signtype_select = $("#signtype_select");
            if (type == 1) {
                signtype_select.show();
                $("#signtype_select").kendoComboBox();
            } else if (type == 2) {

            }
        };
        /*1 : 문서형태 보이기, 2 : 문서형태 안보이기*/
        approvalSearchForm.SearchFormDocFlag = function(type) {
            var docflag_select = $("#docflag_select");
            if (type == 1) {
            	docflag_select.show();
            	$("#docflag_select").kendoComboBox();
            } else if (type == 2) {

            }
        };

        /*결재유형 값 셋팅*/
        approvalSearchForm.signTypeObj = {
                "approval" : "<spring:message code='search.approval' />",
                "cooperation" : "<spring:message code='search.cooperation' />",
                "inner":"대내", 
                "outter":"대외",
                /*결재상태 값 셋팅 시작*/
                "stateReport" : "<spring:message code='search.stateReport' />",//"001",
                "stateApproval" : "<spring:message code='search.stateApproval' />",//"002",
                "stateCooperation" : "<spring:message code='search.stateCooperation' />",//"003",
                "stateHold" : "<spring:message code='search.stateHold' />",//"004",
                "stateRollback" : "<spring:message code='search.stateRollback' />",//"005",
                "stateMultipleReceive" : "<spring:message code='search.stateMultipleReceive' />",//"006",
                "stateReportReturn" : "<spring:message code='search.stateReportReturn' />",//"007",
                "stateApprovalEnd" : "<spring:message code='search.stateApprovalEnd' />",//"008",
                "stateSendRequest" : "<spring:message code='search.stateSendRequest' />",//"009"
                "unconfirmed" : "<spring:message code='search.unconfirmed' />",//1 미확인
                "confirmed" : "<spring:message code='search.confirmed' />"//"" 확인
                    /*결재상태 값 셋팅 끝*/
        };
        
        /*문서유형 값 셋팅*/
        approvalSearchForm.docFlagObj = {
                "000":"생산", 
                "001":"접수"
        };
        approvalSearchForm.SignTypeSet = function(obj) {
            var signtype_select = $("#signtype_select");
            
            var text = obj.text;
            var keyArray = obj.data;
            if(keyArray && keyArray.length && typeof keyArray =="object"){
                if(text){
                    signtype_select.html("<option value='' class='optionAll'>"+text+"</option>");
                }
                else{
                    signtype_select.html("");
                }
                for(var i=0; i<keyArray.length;i++){
                    if(keyArray[i] && approvalSearchForm.signTypeObj[keyArray[i]])
                    {
                        var option = $("<option>");
                        option.val(keyArray[i]);
                        option.text(approvalSearchForm.signTypeObj[keyArray[i]]);
                        signtype_select.append(option);
                    }
                }
            }
        };
        approvalSearchForm.DocFlagSet = function(obj) {
            var docflag_select = $("#docflag_select");
            
            var text = obj.text;
            var keyArray = obj.data;
            if(keyArray && keyArray.length && typeof keyArray =="object"){
                if(text){
                	docflag_select.html("<option value='' class='optionAll'>"+text+"</option>");
                }
                else{
                	docflag_select.html("");
                }
                for(var i=0; i<keyArray.length;i++){
                    if(keyArray[i] && approvalSearchForm.docFlagObj[keyArray[i]])
                    {
                        var option = $("<option>");
                        option.val(keyArray[i]);
                        option.text(approvalSearchForm.docFlagObj[keyArray[i]]);
                        docflag_select.append(option);
                    }
                }
                
            }
            
        };
        
        /*검색 클릭*/
        approvalSearchForm.submit = function() {
       		
	
			$("#searchFromDate").val($("#fromDate").val() );
			$("#searchToDate").val($("#toDate").val() );
			$("#searchDocflag_select").val($("#docflag_select").val() );
			$("#searchKeyword").val($("#keyword").val() );
			$("#searchSelectSearchType").val($("#selectSearchType").val() );
			$("#searchSigntype_select").val($("#signtype_select").val() );
			
            var query = {
         			page:1,
         			pageSize:10
        	};
        	dataSource.query(query);
	     };
        /*검색 클릭 (검색시 page number)*/
        approvalSearchForm.keeppaging = function() {
        	$("#pageIndex").val();
        	$("form#searchForm").submit();
        };
    </script>

<!--  검색조건 끝 -->
    </div>