/* 파일 - 문서 양식 템플릿
 * image: 경로 => oneffice/image/doc_form/ 에 해당 문서의 썸네일 이미지를 위치시킨 후 이미지 파일명을 기재한다.
 * onePageMode 
 *  - true : 전체가 단일페이지로 구성 : 내용이 길어져도 페이지 나뉘어지지 않음 (해당 양식 삽입 시 설정되며, 삽입전 상태와 다른경우 처리된다.)
 *  - false :  자동 페이지 나눔 처리 : 내용이 길어지면 페이지가 자동으로 나뉘어짐 (해당 양식 삽입 시 설정되며, 삽입전 상태와 다른경우 처리된다.)
 *  - null : 삽입시 현재 상태가 어떻든지 아무것도 안함(기존상태 유지)
 * paperMargin: 본문 여백 설정 : 배열 형식 [상,우,하,좌], 단위 mm 이며 숫자만 기재한다.
 *  - ex) [20,40,20,40]
 * bodyStyle : body 스타일 (body,td,p), css 스타일 그대로 배열로 담음
 *  - ex) ["font-size: 12pt", "font-family: '맑은 고딕'"]
 */
var docformTemplateCategory = 
[
	{
		category:ID_RES_STRING_FORM_GROUP_BUSS,
		data:	[
					{	
						docNo: 1,
						name: ID_RES_STRING_DAY_REPORT_TEMPLATE,
						dialog_name: ID_RES_STRING_DAY_REPORT_TEMPLATE + "1",
						html: "file_docform_day_report.js",
						image: "bizbox_report_5.png",
						onePageMode: true,
						paperMargin: [20,40,20,40],
						bodyStyle: ["font-size: 12pt"]
					},
					{
						docNo: 2,
						name: ID_RES_STRING_DAY_REPORT_TEMPLATE,
						dialog_name: ID_RES_STRING_DAY_REPORT_TEMPLATE + "2",
						html: "file_docform_day_report_1.js",
						image: "bizbox_report_9.png",
						onePageMode: true,
						paperMargin: [20,40,20,40],
						bodyStyle: ["font-size: 12pt"]
					},
					/*
					{
						docNo: 3,
						name: ID_RES_STRING_DAY_REPORT_CORONA,
						html: "file_docform_day_report_corona.js",
						image: "day_report_corona/day_report_corona_small.png",
						onePageMode: true,
						paperMargin: [20,20,20,20],
						bodyStyle: ["font-size: 12pt"]
					},
					*/
					{
						docNo: 3,
						name: ID_RES_STRING_TIME_REPORT_TEMPLATE,
						html: "file_docform_time_report.js",
						image: "bizbox_report_6.png",
						onePageMode: true,
						paperMargin: [20,40,20,40],
						bodyStyle: ["font-size: 12pt"]
					},
					{
						docNo: 4,
						name: ID_RES_STRING_WEEK_REPORT_TEMPLATE,
						html: "file_docform_week_report.js",
						image: "bizbox_report_7.png",
						onePageMode: false,
						paperMargin: [10,10,10,10],
						bodyStyle: ["font-size: 11pt", "font-family:'[더존] 본문체 30'"]
					},
					{
						docNo: 5,
						name: ID_RES_STRING_DAY_REPORT_CORONA,
						html: "file_docform_day_report_corona1.js",
						image: "/day_report_corona1/thumb.png",
						onePageMode: true,
						paperMargin: [20,20,20,20],
						bodyStyle: ["font-size: 11pt", "font-family:'[더존] 본문체 30'"],
						douzone: true    /* 그룹사에서만 보임 */
					}
				]
	},
	{
		category:ID_RES_STRING_FORM_GROUP_MEETING,
		data:	[
					{
						docNo: 1,
						name: ID_RES_STRING_MEETING_REPORT_TEMPLATE,
						html: "file_docform_meeting_report.js",
						odd_header: '<p style="text-align: right;"><img src="image/doc_form/meetinglog/1/douzone_logo.png" style="font-family: &quot;맑은 고딕&quot;; font-size: 14.6667px; text-align: right; width: 105px; height: 15px; margin: 0px;"></p><p><span></span></p><p><br></p>',
						image: "meetinglog_1.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					}
				]
	},
	{
		category:ID_RES_STRING_FORM_GROUP_REPORT,
		data:	[
					{
						docNo: 1,
						name: ID_RES_STRING_DEV_REPORT_TEMPLATE,
						html: "file_docform_dev_report.js",
						image: "report_2.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					},
					{
						docNo: 2,
						name: ID_RES_STRING_IMPROVE_FORM_TEMPLATE,
						html: "file_docform_improve_report.js",
						image: "report_3.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					},
					{
						docNo: 3,
						name: ID_RES_STRING_ISSUE_FORM_TEMPLATE,
						html: "file_docform_issue_report.js",
						image: "report_4.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					},
					{
						docNo: 4,
						name: ID_RES_STRING_CURRENT_FORM_TEMPLATE,
						html: "file_docform_current_status_report.js",
						image: "report_5.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					},
					{
						docNo: 5,
						name: ID_RES_STRING_BUS_REPORT_TEMPLATE,
						html: "file_docform_buss_report.js",
						image: "report_6.png",
						onePageMode: false,
						paperMargin: [15,20,15,20],
					},
					{
						docNo: 6,
						name: ID_RES_STRING_SERVICE_FORM_TEMPLATE,
						html: "file_docform_service_report.js",
						image: "report_7.png",
						onePageMode: false,
						paperMargin: [15,20,15,20],
					},
					{
						docNo: 7,
						name: ID_RES_STRING_ADJUST_METHOD_TEMPLATE,
						html: "file_docform_adjust_method_report.js",
						image: "report_8.png",
						onePageMode: false,
						paperMargin: [15,20,15,20],
					},
					{
						docNo: 8,
						name: ID_RES_STRING_BASIC_REPORT_TEMPLATE,
						html:"file_docform_basic_report.js",
						image: "bizbox_report_8.png",
						onePageMode: false,
						paperMargin: [15,20,15,20],
					}
				]
	},
	{
		category:ID_RES_STRING_FORM_GROUP_NORMAL,
		data:	[
					{
						docNo: 1,
						name: ID_RES_STRING_GENERAL_FORM_TEMPLATE,
						html: 'file_docform_general_report.js',
						odd_footer: '<p style="text-align: center;"><font color="#7f7f7f"><span style="font-size: 10.6667px;">'+ID_RES_CONST_STRING_FOOTER+' (본문체30, 8pt)</span></font><span class="tabSpan" style="font-size: 10.6667px; text-align: left;"></span></p>',
						image: "report_1.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					},
					{
						docNo: 2,
						name: ID_RES_STRING_EVENT_PLAN_TEMPLATE,
						html: "file_docform_event_plan_report.js",
						image: "report_9.png",
						onePageMode: false,
						paperMargin: [20,20,20,20],
					}
				]
	},
	{
		category:ID_RES_STRING_FORM_GROUP_TAX,
		data:	[
					{
						docNo: 1,
						name: ID_RES_STRING_TAX_NOTICE_TEMPLATE,
						html: "file_docform_tax_notice_report.js",
						image: "tax_1.png",
						onePageMode: false,
						paperMargin: [20,20,20,20,10,12.5],
					},
					{
						docNo: 2,
						name: ID_RES_STRING_TAX_NET_TEMPLATE,
						html: "file_docform_tax_net_report.js",
						image: "tax_2.png",
						onePageMode: false,
						paperMargin: [20,20,20,20,10,12.5],
					},
					{
						docNo: 3,
						name: ID_RES_STRING_ANALYZE_TEMPLATE,
						html: "file_docform_analyze_plan_report.js",
						image: "tax_3.png",
						onePageMode: false,
						paperMargin: [20,10,20,10,0,0],
					},
					{
						docNo: 4,
						name: ID_RES_STRING_TAX_SAVING_TEMPLATE,
						html: "file_docform_tax_saving_report.js",
						image: "tax_4.png",
						onePageMode: false,
						paperMargin: [9,10,9,10,10,12.5],
					}
				]
	},
	{
		category:"hidden_category",    //UCDOC-2039, 2020-05-25
		data:	[
					{
						docNo: 1,
						name: ID_RES_CONST_STRING_DEFAULT_ARTICLE_NAME,
						html: "file_docform_news_bizwatch.js",
						image: "",
						onePageMode: true,
						bUseHeaderFooterEditMode: false,
						bDiffFirstPage: true,
						first_header: '<div contenteditable="false" dze_not_show_outline="true"><input id="bizwatch_title" contenteditable="true" autocomplete="off" style="width:100%; height: 55px; text-align: left; font-size: 30px; font-weight: bold; line-height: 1.3em; margin-bottom: 8px;" maxlength="100" placeholder="' + ID_RES_STRING_PLACEHOLDER_NEWS_TITLE + '" value=""></div><div contenteditable="false" dze_not_show_outline="true"><textarea id="bizwatch_subtitle" contenteditable="true" style="width:100%; height: 95px; font-size: 20px; font-weight: bold; line-height: 1.3em; letter-spacing: -0.02em; margin-bottom: 4px; resize:none;" maxlength="150" placeholder="' + ID_RES_STRING_PLACEHOLDER_NEWS_SUBTITLE + '"></textarea></div><hr contenteditable="false">',
						paperMargin: [20,20,20,20,20,12.5]
					}
				]
	}
];

var docformHomeTemplate  = [
	{
		name : ID_RES_STRING_NEW_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "new_doc_template.png",
	},

	{
		name : ID_RES_STRING_DAY_REPORT_TEMPLATE,
		data : "category:0, data:0",
		thumb_src : "buss/day_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' )+".png"
	},

	{
		name : ID_RES_STRING_TIME_REPORT_TEMPLATE,
		data : "category:0, data:2",
		thumb_src : "buss/time_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name : ID_RES_STRING_WEEK_REPORT_TEMPLATE,
		data : "category:0, data:3",
		thumb_src : "buss/week_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name : ID_RES_STRING_MEETING_REPORT_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name : ID_RES_STRING_BASIC_REPORT_TEMPLATE,
		data : "category:2, data:7",
		thumb_src : "sample_report/basic_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},
	{
		name : ID_RES_STRING_DEV_REPORT_TEMPLATE,
		data : "category:2, data:0",
		thumb_src : "buss/dev_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},
	{
		name : ID_RES_STRING_BUS_REPORT_TEMPLATE,
		data : "category:2, data:4",
		thumb_src : "buss/buss_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name : ID_RES_STRING_GENERAL_FORM_TEMPLATE,
		data : "category:3, data:0",
		thumb_src : "sample_report/general_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},
	{
		name : ID_RES_STRING_SERVICE_FORM_TEMPLATE,
		data : "category:2, data:5",
		thumb_src : "sample_report/service_report_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name : ID_RES_STRING_ADJUST_METHOD_TEMPLATE,
		data : "category:2, data:6",
		thumb_src : "sample_report/adjust_method_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

	{
		name :ID_RES_STRING_EVENT_PLAN_TEMPLATE,
		data : "category:3, data:1",
		thumb_src : "sample_report/event_plan_template"+(CLOUD_CONST_LANG === 'ja' ? '_ja' : '' ) +".png"
	},

];


var docformRecentTemplate  = [
	{
		name : ID_RES_STRING_NEW_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "new_doc_template.png",
	},

	{
		name : ID_RES_STRING_DAY_REPORT_TEMPLATE,
		data : "category:0, data:0",
		thumb_src : "buss/day_report_template.png"
	},

	{
		name : ID_RES_STRING_TIME_REPORT_TEMPLATE,
		data : "category:0, data:1",
		thumb_src : "buss/time_report_template.png"
	},

	{
		name : ID_RES_STRING_WEEK_REPORT_TEMPLATE,
		data : "category:0, data:2",
		thumb_src : "buss/week_report_template.png"
	},

	{
		name : ID_RES_STRING_MEETING_REPORT_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_report_template.png"
	},

	{
		name : ID_RES_STRING_BASIC_REPORT_TEMPLATE,
		data : "category:2, data:7",
		thumb_src : "sample_report/basic_report_template.png"
	},

	{
		name : ID_RES_STRING_DEV_REPORT_TEMPLATE,
		data : "category:2, data:0",
		thumb_src : "buss/dev_report_template.png"
	},
];

var docformMyTemplate  = [
	{
		name : ID_RES_STRING_MY_TEMPLATE_1,
		data : "category:-1, data:-1",
		thumb_src : "my/my_template_1.png",
	},

	{
		name : ID_RES_STRING_MY_TEMPLATE_2,
		data : "category:-1, data:-1",
		thumb_src : "my/my_template_2.png"
	},

	{
		name : ID_RES_STRING_MY_TEMPLATE_3,
		data : "category:-1, data:-1",
		thumb_src : "my/my_template_3.png"
	},

	{
		name : ID_RES_STRING_MY_TEMPLATE_4,
		data : "category:-1, data:-1",
		thumb_src : "my/my_template_4.png"
	},

	{
		name : ID_RES_STRING_MY_TEMPLATE_5,
		data : "category:-1, data:-1",
		thumb_src : "my/my_template_5.png"
	},

];

var docformBussReportTemplate  = [
	{
		name : ID_RES_STRING_DAY_REPORT_TEMPLATE,
		data : "category:0, data:0",
		thumb_src : "buss/day_report_template.png",
	},

	{
		name : ID_RES_STRING_TIME_REPORT_TEMPLATE,
		data : "category:0, data:1",
		thumb_src : "buss/time_report_template.png"
	},

	{
		name : ID_RES_STRING_WEEK_REPORT_TEMPLATE,
		data : "category:0, data:2",
		thumb_src : "buss/week_report_template.png"
	},

	{
		name : ID_RES_STRING_DEV_REPORT_TEMPLATE,
		data : "category:2, data:0",
		thumb_src : "buss/dev_report_template.png"
	},

	{
		name : ID_RES_STRING_BUS_REPORT_TEMPLATE,
		data : "category:2, data:4",
		thumb_src : "buss/buss_report_template.png"
	},

	{
		name : ID_RES_STRING_PRODUCT_REPORT_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "buss/product_report_template.png"
	},

	{
		name : ID_RES_STRING_ISSUE_FORM_TEMPLATE,
		data : "category:2, data:3",
		thumb_src : "buss/issue_report.png"
	},

];


var docformReportTemplate  = [
	
	{
		name : ID_RES_STRING_ADJUST_METHOD_TEMPLATE,
		data : "category:2, data:6",
		thumb_src : "sample_report/adjust_method_template.png"
	},

	{
		name : ID_RES_STRING_BASIC_REPORT_TEMPLATE,
		data : "category:2, data:7",
		thumb_src : "sample_report/basic_report_template.png"
	},

	{
		name : ID_RES_STRING_GENERAL_FORM_TEMPLATE,
		data : "category:3, data:0",
		thumb_src : "sample_report/general_report_template.png"
	},

	{
		name : ID_RES_STRING_GENERAL_FORM_2_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "sample_report/project_1.png"
	},

	{
		name : ID_RES_STRING_GENERAL_FORM_3_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "sample_report/project_2.png"
	},

	{
		name : ID_RES_STRING_PROJECT_FORM_1_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "sample_report/project_4.png"
	},

	{
		name : ID_RES_STRING_PROJECT_FORM_2_TEMPLATE,
		data : "category:-1, data:-1",
		thumb_src : "sample_report/project_5.png"
	},

];


var docformMeetingTemplate  = [
	
	{
		name : ID_RES_STRING_MEETING_REPORT_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_report_template.png"
	},

	{
		name : ID_RES_STRING_MEETING_REPORT_2_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_3.png"
	},

	{
		name : ID_RES_STRING_MEETING_REPORT_3_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_4.png"
	},

	{
		name : ID_RES_STRING_MEETING_REPORT_4_TEMPLATE,
		data : "category:1, data:0",
		thumb_src : "meeting/meeting_5.png"
	},


];

/* UCDOC-2095, 육군 시연 */
if(dzeUiConfig && dzeUiConfig.bSupportArmy === true)
{
	
	(function() {

		var template = docformTemplateCategory;

		//업무보고 - 일일 보고
		var day_report = template[0].data[0];
		day_report.html = "file_docform_day_report_army.js";
		day_report.image = "day_report_template_army_small.png";

		//업무보고 - 주간 보고
		var week_report = template[0].data[2];
		week_report.html = "file_docform_week_report_army.js";
		week_report.image = "week_report_template_army_small.png";

		//회의록 - 회의록
		var meeting_log = template[1].data[0];
		meeting_log.html = "file_docform_meeting_report_army.js";
		meeting_log.image = "meeting_report_template_army_small.png";
		meeting_log.odd_header = "<p style=\"text-align: right;\"><img src=\"image/doc_form/meetinglog_army/header_img.png\" style=\"opacity: 1; width: 151.421px; height: 33.002px;\"><br></p><p><br></p>";

		//일반 양식
        template[3].data.splice(0, 0, {
        	docNo: 1,
			name: "공고문",
			html: 'file_docform_notice_army.js',
			image: "notice_army_small.png",
			onePageMode: false,
			paperMargin: [20,20,20,20],
        });

		template[3].data.splice(1, 0, {
        	docNo: 2,
			name: "보도자료",
			html: 'file_docform_press_release_army.js',
			image: "press_release_army_small.png",
			onePageMode: false,
			paperMargin: [20,20,20,20],
        });

        forEach(template[2].data, function(i, data) {    //공고문, 보도자료 앞에 넣었으므로 docNo 갱신
        	data.docNo = i + 1;
        }, this);

		//세무 양식 카테고리 제거
		template.splice(4, 1);

		//원피스 홈 카테고리
		var homeTemplate = docformHomeTemplate;

        //일일 보고
		homeTemplate[1].thumb_src = "buss/day_report_template_army.png";

		//주간 보고
		homeTemplate[3].thumb_src = "buss/week_report_template_army.png";

		//회의록
		homeTemplate[4].thumb_src = "buss/meeting_report_templat_army.png";

	})();

}