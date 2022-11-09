<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<style>

.capacity{text-align:center;}
.capacity .chart_list, .capacity .chartimg{width:100%; vertical-align:middle;}
.capacity .chart_list p{display:inline-block; padding:0 10px 0 0;}
.capacity .chart_list p:last-child{padding-right:0px !important;}

/*그룹웨어사용현황*/
.UseChart .bg_blue{background:#0a8afd !important;  border:none !important;}
.UseChart .bg_skyblue{background:#03aaf9 !important;}
.UseChart .bg_lightgreen{background:#00efac !important;}
.UseChart .bg_sky{background:#17c5fe !important;}
.UseChart .bg_purple{background:#9483ff !important;}
.UseChart .bg_Rpurple{background:#c376ff !important;}
.UseChart .bg_pink{background:#ff76b6 !important;}
.UseChart .bg_gray{background:#a5a5a5 !important; border:none !important;}
.UseChart .bg_yellow{background:#eac600 !important; border:none !important;}
.UseChart .bg_red{background:#db2755 !important; border:none !important;}
.UseChart .bg_darkpurple{background:#5e3ae2 !important;}
.UseChart .bg_green{background:#48bb1a !important; border:none !important;}
.UseChart .bg_darkpink{background:#d81db7 !important;}
.UseChart .bg_orange{background:#f85718 !important;}
.UseChart .bg_brown{background:#da911d !important;}

.UseChart .chart_list.approval .bg_gray{background:#999999 !important; border:none !important;}
.UseChart .chart_list.approval .bg_darkgray{background:#727272 !important;}
.UseChart .chart_list.approval .bg_red{background:#ee6362 !important;border:none !important;}
.UseChart .chart_list.approval .bg_lightgray{background:#cecece !important;}
.UseChart .chart_list.approval .bg_lightgreen{background:#71ddbf !important;}
.UseChart .chart_list.approval .bg_orange{background:#ff9b59 !important;}
.UseChart .chart_list.approval .bg_blue{background:#56a8f4 !important;}
.UseChart .chart_list.approval .bg_green{background:#29c69a !important;}

.UseChart .chart_con ul li{float:left;}
.UseChart .chart_con ul li.chart{width:75%; text-align:center; display:table;}
.UseChart .chart_con ul li.chart_list{width:25%; display:table;}
.UseChart .chart_con ul li.chart_list ul li{clear:both; padding:0 0 15px 0;}
@media screen and (-webkit-min-device-pixel-ratio:0) {.UseChart .chart_con .chart_list span{margin:3px 5px 0 0;}}
.UseChart .chart_con ul li.chart_list img{vertical-align:middle; margin-top:-3px; margin-right:5px;}
.UseChart .chart_list span{float:left;  margin:2px 5px 0 0; width:7px; height:7px; border-radius:10px;}
.UseChart .chartimg{display: table-cell; vertical-align:middle;}
.highcharts-credits{display:none;}
.highcharts-button{display:none;}

</style>

<script type="text/javascript" src="<c:url value='/js/Highcharts-6.1.0/highcharts.js' />"></script>

<script>

	$(document).ready(function() {
		renderHighChart();
		
		if("${buildType}" == "cloud"){
			$(".cloudDiv").show();
		}
	});
	
	function renderHighChart(){
		
		Highcharts.chart('highChartDiv', {
		    chart: {
		        plotBackgroundColor: null,
		        plotBorderWidth: null,
		        plotShadow: false,
		        type: 'pie'
		    },
		    title: {
		        text: '<%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%>'
		    },
		    tooltip: {
		        pointFormat: '<b>{point.percentage:.1f}%</b>'
		    },
		    plotOptions: {
		        pie: {
		            allowPointSelect: true,
		            cursor: 'pointer',
		            dataLabels: {
		                enabled: true,
		                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
		                style: {
		                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',
		                    fontSize:'13px'
		                }
		            }
		        }
		    },
		    series: [{
		        colorByPoint: true,
		        data: [
			               {name: '전자결재', y: ${volInfo.sizeEa}, color:'#db2755', sliced: false, selected: false},
			               {name: '일정', y: ${volInfo.sizeSchedule}, color:'#17c5fe', sliced: false, selected: false},
// 			               {name: '업무보고', y: ${volInfo.sizeReport}, color:'#ff76b6', sliced: false, selected: false},
			               {name: '업무관리', y: ${volInfo.sizeProject}, color:'#48bb1a', sliced: false, selected: false},
			               {name: '게시판', y: ${volInfo.sizeBoard}, color:'#da911d', sliced: false, selected: false},
			               {name: '문서', y: ${volInfo.sizeDoc}, color:'#00efac', sliced: false, selected: false},
			               {name: '쪽지', y: ${volInfo.sizeMsg}, color:'#0a8afd', sliced: false, selected: false},
			               {name: '대화', y: ${volInfo.sizeTalk}, color:'#03aaf9', sliced: false, selected: false}
		               ]
		    	}]
			});		
	}

	var itemRemovePopObj;
	
	function volumeHistoryInfoPop(){
		
		itemRemovePopObj = $("#itemRemovePop").kendoWindow({
			draggable: false,
	       	resizable: false,
	       	width: '500px',
	       	height: '500px',
	       	title: "이력확인",
	       	modal: true 
	   	});	
		
		itemRemovePopObj.data("kendoWindow").center().open();
		
 		$.ajax({
        	type:"post",
    		url:'<c:url value="/cmm/systemx/group/getVolumeHistoryInfo.do"/>',
    		datatype:"json",
    		success: function (data) {
    			
    			var innerHtml = "";
    			
    			for(var i=0;i<data.result.length;i++){
    				innerHtml += '<tr class="text_gray">';
    				innerHtml += '<td>' + data.result[i].createDate + '</td>';
    				if(data.result[i].changeVolume == 0){
    					innerHtml += '<td>' + data.result[i].totalVolume + 'GB</td>';
    				}else{
    					innerHtml += '<td>' + data.result[i].changeVolume + '(' + data.result[i].totalVolume + ')GB</td>';
    				}
    				innerHtml += '</tr>';
    			}
    			
    			$("#volumeHistoryTable").html(innerHtml);

    		},
		    error: function (result) { 
		    		alert("<%=BizboxAMessage.getMessage("TX000002003","작업이 실패했습니다.")%>"); 
		    }
		});
	}
	
</script>

	<div class="sub_contents_wrap">
		
		 <p class="tit_p cloudDiv" style="display: none;"><%=BizboxAMessage.getMessage("TX900000204","용량현황")%></p>
                     <div class="com_ta4 hover_no cloudDiv" style="display: none;">
                        <table>
                            <colgroup>
                                <col width="18%">
                                <col width="15%">
                                <col width="18%">
                                <col width="15%">
                                <col width="18%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th colspan="2"><%=BizboxAMessage.getMessage("TX900000205","계약용량")%></th>
                                    <th colspan="2"><%=BizboxAMessage.getMessage("TX900000206","사용용량")%></th>
                                    <th colspan="2"><%=BizboxAMessage.getMessage("TX900000207","잔여용량")%></th>
                                </tr>
                                <tr>
                                    <td colspan="2">        
                                        <div class="controll_btn p0 ac">
                                            <span class="vm pr5">${volInfo.allVolText}</span>
                                            <input onclick="volumeHistoryInfoPop();" type="button" class="small_btn" value="<%=BizboxAMessage.getMessage("TX900000208","이력")%>">
                                         </div>
                                    </td>
                                    <td colspan="2" class="text_blue">${volInfo.sizeAllText}</td>
                                    <td colspan="2" class="text_red">${volInfo.freeAllText}</td>
                                </tr>
                                <tr>
                                    <th><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></th>
                                    <th><%=BizboxAMessage.getMessage("TX000000262","메일")%></th>
                                    <th><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></th>
                                    <th><%=BizboxAMessage.getMessage("TX000000262","메일")%></th>
                                    <th><%=BizboxAMessage.getMessage("TX000005020","그룹웨어")%></th>
                                    <th><%=BizboxAMessage.getMessage("TX000000262","메일")%></th>
                                </tr>
                                <tr>
                                    <td>${volInfo.gwVolText}</td>
                                    <td>${volInfo.mailVolText}</td>
                                    <td>${volInfo.sizeGwText}</td>
                                    <td>${volInfo.sizeMailText}</td>
                                    <td>${volInfo.freeGwText}</td>
                                    <td>${volInfo.freeMailText}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <p class="tit_p mt30"><%=BizboxAMessage.getMessage("TX900000209","그룹웨어 기능별 사용현황")%></p>
                    <div>
                        <ul>
                            <li class="fl" style="width:35%;">
                                <div class="com_ta4 hover_no">
                                    <table>
                                        <colgroup>
                                            <col width="40%">
                                            <col>
                                        </colgroup>       
                                                                            
                                        <tbody>
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000000479","전자결재")%></th>
                                                <td>${volInfo.sizeEaText}</td>
                                            </tr>
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000000483","일정")%></th>
                                                <td>${volInfo.sizeScheduleText}</td>
                                            </tr>
<!--                                              <tr> -->
<!--                                                 <th class="ri">업무보고</th> -->
<%--                                                 <td>${volInfo.sizeReportText}</td> --%>
<!--                                             </tr> -->
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000020269","업무관리")%></th>
                                                <td>${volInfo.sizeProjectText}</td>
                                            </tr>
                                             <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000011134","게시판")%></th>
                                                <td>${volInfo.sizeBoardText}</td>
                                            </tr>
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000018123","문서")%></th>
                                                <td>${volInfo.sizeDocText}</td>
                                            </tr>
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000000260","쪽지")%></th>
                                                <td>${volInfo.sizeMsgText}</td>
                                            </tr>
                                            <tr>
                                                <th class="ri"><%=BizboxAMessage.getMessage("TX000015059","대화")%></th>
                                                <td>${volInfo.sizeTalkText}</td>
                                            </tr>                                                                                                                                    
                                        </tbody>
                                    </table>
                                </div>
                            </li>

                            <li class="fl" style="width:65%;">
                                <div class="capacity UseChart">                                       
                                     <div class="fl chartimg mt20">
                                     	<div id="highChartDiv"></div>
                                     </div>
                                </div>
                            </li>
                        </ul>
                    </div>
		
	</div>
	
	
	<div id="itemRemovePop" class="pop_wrap_dir" style="display:none;">
	
		<div class="com_ta2">
			<table id="volumeHistoryTable">
				<colgroup>
					<col width="30%">
					<col width="">
				</colgroup>
				<tr>
					<th><%=BizboxAMessage.getMessage("TX000007571","일시")%></th>
					<th><%=BizboxAMessage.getMessage("TX900000205","계약용량")%></th>
				</tr>
			</table>
		</div>	
		
	</div>	


