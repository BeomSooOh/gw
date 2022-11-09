	  var approvalSearchForm = {};
      $(function() {

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
    		            approvalSearchForm.datepickerOnSelect(dateText, id);
    		        }
    		    };
    		    
    		neosdatepicker.datepicker("c_startDate", pickerOpts);
    		neosdatepicker.datepicker("c_endDate", pickerOpts);
    		
          //날짜 밸리데이션
          $("#c_startDate, #c_endDate").bind({
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

          var c_endDate = $("#c_endDate").val();
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
              $("#c_startDate").val(dateString);
          }
      };

      //datepicker 날짜 선택이 변경 되었을 경우
      approvalSearchForm.datepickerOnSelect = function(dateText, inst) {

          var targetObj = {
              "c_startDate" : "c_endDate",
              "c_endDate" : "c_startDate"
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
              if (target == "c_startDate") {
                  date.setDate(date.getDate() - addDay);
              } else {
                  date.setDate(date.getDate() + addDay);
              }
          } else {
              if(addDayString == "freeTerm") {
                  return;
              }
              if (addDayString == "month") {
                  if (target == "c_startDate") {
                      date.setMonth(date.getMonth() - 1);
                  } else {
                      date.setMonth(date.getMonth() + 1);
                  }
              }
              else if(addDayString == "3month"){
                  if (target == "c_startDate") {
                      date.setMonth(date.getMonth() - 3);
                  } else {
                      date.setMonth(date.getMonth() + 3);
                  }
                  if (target == "c_startDate") {
                      date.setMonth(date.getMonth() - 3);
                  } else {
                      date.setMonth(date.getMonth() + 3);
                  }
                  
              }
              else if(addDayString == "6month"){
                  if (target == "c_startDate") {
                      date.setMonth(date.getMonth() - 6);
                  } else {
                      date.setMonth(date.getMonth() + 6);
                  }
                  if (target == "c_startDate") {
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

          approvalSearchForm.selectSearchTypeChange();
      };
