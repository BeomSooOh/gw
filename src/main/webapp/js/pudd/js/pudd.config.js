/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pudd.config.js
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Pudd.Config = {

	className : {

		// 공통
		PUDD						: "PUDD"

		// textbox / password / textarea
	,	Success						: "Success"
	,	Error						: "Error"
	,	Warning						: "Warning"

		// textbox
	,	PUDD_UI_inputField			: "PUDD-UI-inputField"
	,	PUDD_UI_searchField			: "PUDD-UI-searchField"

		// password
	,	PUDD_UI_passwordField		: "PUDD-UI-passwordField"

		// checkbox / radio
	,	PUDD_UI_ChkRadi				: "PUDD-UI-ChkRadi"
	,	UI_ON						: "UI-ON"
	,	UI_Disa						: "UI-Disa"

		// checkbox
	,	PUDD_UI_checkbox			: "PUDD-UI-checkbox"
	,	PUDD_UI_ONLY				: "PUDD-UI-ONLY"
	,	PUDDCheckBox				: "PUDDCheckBox"

		// radio
	,	PUDD_UI_radio				: "PUDD-UI-radio"
	,	PUDDRadio					: "PUDDRadio"

		// button
	,	PUDD_UI_Button				: "PUDD-UI-Button"
	,	PUDD_UI_iconImgButton		: "PUDD-UI-iconImgButton"
	,	PUDD_UI_iconImgtextButton	: "PUDD-UI-iconImgtextButton"
	,	PUDD_UI_iconSvgButton		: "PUDD-UI-iconSvgButton"
	,	PUDD_UI_iconSvgtextButton	: "PUDD-UI-iconSvgtextButton"

		// file
	,	PUDD_UI_fileField			: "PUDD-UI-fileField"
	,	UI_Union					: "UI-Union"

		// select
	,	PUDD_UI_selectBox			: "PUDD-UI-selectBox"

		// textarea
	,	PUDD_UI_textArea			: "PUDD-UI-textArea"

		// datepicker
	,	PUDD_UI_datePicker			: "PUDD-UI-datePicker"
	,	basic						: "basic"
	,	month						: "month"

		// calendar
	,	PUDD_UI_calendar			: "PUDD-UI-calender"

		// gridTable
	,	PUDD_UI_GridTable			: "PUDD-UI-GridTable"
	,	scrollable					: "scrollable"

		// pager
	,	PUDD_UI_pager				: "PUDD-UI-pager"
	}

,	svgSet : {

		// button
		SUCCESS			: '<svg viewBox="0 0 24 24"><path d="M12.001,0.075C5.417,0.075,0.072,5.417,0.072,12c0,6.582,5.342,11.926,11.929,11.926c6.584,0,11.927-5.342,11.927-11.926 C23.927,5.419,18.583,0.075,12.001,0.075z M9.833,18.443L9.797,18.41L9.71,18.498l-5.686-5.791L6.5,10.235l3.24,3.303l6.963-7.122 l2.473,2.47L9.833,18.443z"></path></svg>'
	,	ERROR			: '<svg viewBox="0 0 24 24"><rect x="0.001" y="0.002" fill="none"></rect><path d="M12.062,1.335l-12,19.719h23.875L12.062,1.335z M13.324,19.162h-2.523v-2.521h2.523V19.162z M10.783,14.746V8.418h2.539 v6.328H10.783z"></path></svg>'
	,	WARNING			: '<svg viewBox="0 0 24 24"><path d="M12,0.054C5.407,0.054,0.054,5.407,0.054,12c0,6.596,5.353,11.946,11.946,11.946 c6.593,0,11.946-5.351,11.946-11.946C23.946,5.407,18.593,0.054,12,0.054z M13.627,18.859h-3.446v-3.546h3.446V18.859z M13.627,13.685h-3.446V5.081h3.446V13.685z"></path></svg>'
	,	SECURE			: '<svg viewBox="0 0 24 24"><path d="M12.003,0.201L1.958,4.574v6.629c0,6.069,4.285,11.215,10.045,12.596 c5.757-1.381,10.042-6.527,10.042-12.596V4.731L12.003,0.201z M12.003,12.077h8.388c-0.591,4.507-4.234,8.833-8.388,10.09V12.091 H3.632V5.967l8.371-3.399V12.077z"></path></svg>'
	,	MAGNIFIER		: '<svg viewBox="0 0 24 24"><path d="M23.94,22.054l-5.712-5.677c3.033-3.973,2.775-9.656-0.857-13.287c-1.979-1.981-4.574-2.97-7.17-2.97 c-2.593,0-5.188,0.989-7.167,2.969c-3.958,3.958-3.958,10.376,0,14.337c1.979,1.98,4.574,2.971,7.167,2.971 c2.204,0,4.383-0.756,6.207-2.182l5.708,5.665L23.94,22.054z M4.374,16.083c-1.557-1.555-2.414-3.624-2.414-5.826 c0-2.201,0.857-4.27,2.412-5.827c1.555-1.557,3.625-2.415,5.829-2.415s4.27,0.858,5.826,2.413 c1.562,1.557,2.417,3.626,2.417,5.827c0,2.202-0.86,4.272-2.417,5.828c-1.553,1.559-3.625,2.416-5.826,2.416 C7.999,18.499,5.928,17.642,4.374,16.083z"></path></svg>'
	,	CLIP			: '<svg viewBox="0 0 24 24"><path d="M 8.818 21.525 c -1.39 0 -2.778 -0.528 -3.835 -1.586 c -2.113 -2.113 -2.115 -5.556 -0.002 -7.669 l 8.636 -8.636 c 0.75 -0.749 1.744 -1.161 2.803 -1.161 c 0.002 0 0.002 0 0.002 0 c 1.059 0 2.055 0.412 2.801 1.161 c 1.547 1.545 1.547 4.061 0 5.605 l -7.219 7.233 c -0.979 0.978 -2.566 0.978 -3.543 0 C 7.987 16 7.729 15.371 7.729 14.702 s 0.26 -1.298 0.733 -1.771 l 6.544 -6.543 l 1.131 1.131 l -6.544 6.543 c -0.171 0.172 -0.265 0.397 -0.265 0.64 c 0 0.241 0.094 0.469 0.266 0.64 c 0.352 0.352 0.926 0.352 1.277 0 l 7.221 -7.233 c 0.922 -0.922 0.922 -2.422 0 -3.344 c -0.445 -0.446 -1.039 -0.692 -1.67 -0.692 l 0 0 c -0.633 0.001 -1.227 0.247 -1.674 0.693 L 6.112 13.4 c -1.488 1.49 -1.488 3.918 0.002 5.408 c 1.49 1.489 3.918 1.489 5.408 0 l 7.948 -7.949 l 1.131 1.131 l -7.949 7.949 C 11.597 20.997 10.208 21.525 8.818 21.525 Z" /></svg>'

		// checkbox
	,	CHECK			: '<svg viewBox="0 0 24 24"><path d="M22.285,1.715V22.22H1.725V1.715H22.285 M24,0H0.01v23.935H24V0L24,0z"></path><polygon points="20.542,8.304 18.185,5.943 9.958,14.085 5.827,9.956 3.467,12.317 9.92,18.824 "></polygon></svg>'
	,	CHECK_DISABLE	: '<svg viewBox="0 0 24 24"><g><path d="M0.01,0H24v23.934H0.01V0z"></path></g><path d="M22.285,1.715V22.22H1.725V1.715H22.285 M24,0H0.01v23.934H24V0L24,0z"></path><polygon points="20.542,8.307 18.185,5.945 9.961,14.091 5.827,9.958 3.467,12.319 9.92,18.828"></polygon></svg>'
	,	DASH			: '<svg viewBox="0 0 24 24"><g><path d="M22.285,1.697v20.504H1.725V1.697H22.285 M24-0.018H0.01v23.934H24V-0.018L24-0.018z"></path></g><rect x="5.152" y="10.274" width="13.705" height="3.357"></rect></svg>'
	,	DASH_DISABLE	: '<svg viewBox="0 0 24 24"><g><g><path d="M0.022-0.018H24v23.921H0.022V-0.018z"></path></g><path d="M22.286,1.696v20.494H1.736V1.696H22.286 M24-0.018H0.022v23.921H24V-0.018L24-0.018z"></path></g><rect x="5.164" y="10.269" width="13.697" height="3.354"></rect></svg>'

		// radio
	,	RADIO			: '<svg viewBox="0 0 24 24" ><path d="M11.998,1.73c5.663,0,10.27,4.607,10.27,10.27c0,5.662-4.607,10.271-10.27,10.271 C6.336,22.271,1.732,17.662,1.732,12C1.732,6.337,6.336,1.73,11.998,1.73 M11.998,0.022C5.385,0.022,0.024,5.388,0.024,12 c0,6.615,5.361,11.979,11.974,11.979c6.617,0,11.978-5.363,11.978-11.979C23.976,5.388,18.614,0.022,11.998,0.022L11.998,0.022z"></path><circle cx="11.998" cy="12" r="5.009"></circle></svg>'
	,	RADIO_DISABLE	: '<svg viewBox="0 0 24 24" ><g><path d="M11.985-0.009c6.609,0,11.963,5.355,11.963,11.963c0,6.604-5.354,11.96-11.963,11.96 c-6.604,0-11.959-5.356-11.959-11.96C0.026,5.347,5.381-0.009,11.985-0.009z"></path></g><path d="M11.985,1.697c5.655,0,10.256,4.602,10.256,10.258c0,5.655-4.601,10.253-10.256,10.253 c-5.655,0-10.253-4.599-10.253-10.253C1.732,6.298,6.331,1.697,11.985,1.697 M11.985-0.009c-6.604,0-11.959,5.355-11.959,11.963 c0,6.604,5.355,11.96,11.959,11.96c6.609,0,11.963-5.356,11.963-11.96C23.948,5.347,18.595-0.009,11.985-0.009L11.985-0.009z"></path><circle cx="11.998" cy="12" r="5.009"></circle></svg>'

		// calendar
	,	CALENDAR		: '<svg viewBox="0 0 24 24"><path d="M13.652,10.314h-3.335v3.38h3.335V10.314z M18.75,10.314h-3.335v3.38h3.335V10.314z M13.652,15.412 h-3.335v3.38h3.335V15.412z M22.212,1.795h-1.689V0.119h-3.405v1.676H6.919V0.119H3.577v1.676H1.788 c-0.937,0-1.699,0.761-1.699,1.699V22.18c0,0.94,0.762,1.699,1.699,1.699h20.424c0.939,0,1.699-0.759,1.699-1.699V3.494 C23.911,2.556,23.151,1.795,22.212,1.795z M22.152,22.235H1.818V6.957h20.334V22.235z M8.556,15.412H5.22v3.38h3.336V15.412z M8.556,10.314H5.22v3.38h3.336V10.314z M18.75,15.412h-3.335v3.38h3.335V15.412z"></path></svg>'
	}

};