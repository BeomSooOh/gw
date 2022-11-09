<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%
/**
 *
 * @title 부재 설정 화면
 * @author 공공사업부 포털개발팀 박기환
 * @since 2012. 7. 17.
 * @version
 * @dscription
 *
 *
 * << 개정이력(Modification Information) >>
 *  수정일                수정자        수정내용
 * -----------  -------  --------------------------------
 * 2012. 7. 17.  박기환        최초 생성
 *
 */
%>
    <%@ include file="/WEB-INF/jsp/neos/include/IncludeJstree.jsp" %>
    <script type="text/javascript" src="<c:url value='/js/neos/doc/doc.common.Approval.js' />" ></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/jquery.alphanumeric.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/sym/ccm/zip/EgovZipPopup.js' />" ></script>
    <link rel="stylesheet" type="text/css" href="<c:url value='/js/egovframework/com/cmm/jquery/plugins/treeview/jquery.treeview.css' />" ></link>
    <link rel="stylesheet" type="text/css" href="<c:url value='/js/egovframework/com/cmm/jquery/plugins/treeview/screen.css'/>" ></link>
    <script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery/plugins/treeview/jquery.treeview.js'/>" ></script>
    <script type="text/javascript" src="<c:url value='/js/neos/neos_common.js' />"></script>
    <script>
    var curSelectedTree = "" ;       
    var absenceType = "${AbsenceType}";
    var loginInfo_id = "${LoginVO.uniqId}";
    var loginInfo_organ = "${LoginVO.orgnztId}";
    var loginInfo_userNm = "${LoginVO.name}";
    //jstree search plugin 사용 여부
    var jstree_search_flag = false;

    $(document).ready(function(){

    //  Short Title Set
        shoutCutTitleChange('<spring:message code="absence.menu.title" />'/*부재설정*/);

        /*
        *   부재 설정 타입(user:사용자       admin:관리자)
        **/
        
        $("#uniqId").val(loginInfo_id);
        $("#orgnztId").val(loginInfo_organ);
        $("#userName").val(loginInfo_userNm);
        
        <c:choose>
            <c:when test = "${AbsenceType eq 'admin'}">
                $("#searchOrgUserName").hide();
                $("#organization_tree").treeview( { collapsed: false });
                main("Q_ABSENT","","", "1");
            </c:when>
            <c:when test = "${AbsenceType eq 'user'}">
                $("#orgnztId").val(loginInfo_organ);
                main("Q_ABSENT", loginInfo_id,"", "1");
                $("#tree_teg").hide();
                $("#detail_teg").attr("class", "contents");
            </c:when>
        </c:choose>
    });

    function isValid(arg) {
        switch(arg) {
            case 'SEARCH_USER':
                if (ncCom_Empty($("#searchUserName").val())) return ncCom_ErrField($("#searchUserName"),"<%=BizboxAMessage.getMessage("TX000002101","이름을 입력하세요.")%>") ;
                if ($("#searchUserName").val().length <= 1 ) return ncCom_ErrField($("#searchUserName"),"<%=BizboxAMessage.getMessage("TX000010869","2자 이상 이름을 입력하세요")%>") ;
                break;
            case 'EDIT_ABSENT':
                if (ncCom_Empty($("#absenceCode").val())) return ncCom_ErrField($("#absenceCode"),"<%=BizboxAMessage.getMessage("TX000010868","부재종류를 선택 해주세요")%>") ;
                if (ncCom_Empty($("#absenceStartDay").val())) return ncCom_ErrField($("#absenceStartDay"),"<%=BizboxAMessage.getMessage("TX000010867","부재 시작일을 넣어주세요")%>") ;
                if (ncCom_Empty($("#absenceEndDay").val())) return ncCom_ErrField($("#absenceEndDay"),"<%=BizboxAMessage.getMessage("TX000010866","부재 종료일을 넣어주세요")%>") ;

                var absenceStartTime = $("#absenceStartTime").val();
                if(absenceStartTime.length==1){
                    absenceStartTime = "0"+absenceStartTime;
                }
                var absenceStartDate = $("#absenceStartDay").val().split("-").join("")+absenceStartTime;

                var absenceEndTime = $("#absenceEndTime").val();
                if(absenceEndTime.length==1){
                    absenceEndTime = "0"+absenceEndTime;
                }
                var absenceEndDate = $("#absenceEndDay").val().split("-").join("")+absenceEndTime;

                if(absenceStartDate >= absenceEndDate) {
                    return ncCom_ErrField($("#absenceStartDay"),"<spring:message code='absence.date.alert' />") ;
                }
                
                var objCariousInfo = document.getElementsByName("chkCariousInfo") ;
                // 권한 대행자 선택 여부 validation
                if(!checkBoxSelected(objCariousInfo) ) {
                    alert("<%=BizboxAMessage.getMessage("TX000006300","선택된 권한이 없습니다.")%>");
                    return false ;
                }
                var arrInx = checkBoxSelectedIndex( objCariousInfo) ;
                
                var rowNum = arrInx.length ;
                var realInx = 0 ;
                var viUserKey = "" ;
                var uiUserKey = $("#uniqId").val();
                for(var inx =0 ; inx < rowNum ; inx++){
                    realInx = arrInx[inx];
                    viUserKey = document.getElementsByName("C_VIUSERKEY")[realInx].value ;
                    if(ncCom_Empty(viUserKey)) {
                        alert("<%=BizboxAMessage.getMessage("TX000010865","선택된 권한에 대행자가 설정되어있지 않습니다")%>");
                        return false ;
                    } 
                    if(uiUserKey ==  viUserKey) {
                        alert("<%=BizboxAMessage.getMessage("TX000010864","대행자가 부재자와 동일합니다")%>");
                        return false ;
                    }
                }
                break;
            case 'DEL_ABSENT' :
                if(!checkBoxSelected( document.getElementsByName("chkAbsentInfo")) ) {
                    alert("<%=BizboxAMessage.getMessage("TX000010863","선택된 부재자가 없습니다")%>");
                    return false ;
                }
                break;
            case 'SEL_AGENT' :
                if(!checkBoxSelected( document.getElementsByName("chkCariousInfo")) ) {
                    alert("<%=BizboxAMessage.getMessage("TX000006300","선택된 권한이 없습니다.")%>");
                    return false ;
                }
                break;
        }
        return true ;
    }
    
    function main(arg1, arg2, arg3, arg4) {
        switch(arg1) {
            case 'Q_ABSENT' : //부재자조회
                var url = "<c:url value='/cmm/system/selectAbsentList.do'/>";
                var currentPage = 1 ;
                var uiUserKey = "" ;
                var oiOrgCode = "" ;
                if (arg4 == undefined || ncCom_Empty(String(arg4)) ) {
                    currentPage = 1 ;
                }else {
                    currentPage = arg4 ;
                }
                if (arg2 == undefined || ncCom_Empty(arg2) ) {
                    uiUserKey = "" ;
                }else {
                    uiUserKey = arg2;
                }
                if (arg3 == undefined || ncCom_Empty(arg3) ) {
                    oiOrgCode = "" ;
                }else {
                    oiOrgCode = arg3;
                }
                var data = { "currentPage" : currentPage,
                             "uiUserKey" : uiUserKey,
                             "oiOrgCode" : oiOrgCode,
                             "jsonView" : "Y" };
                commonApproval.loadingStart();
                ajaxPOST(url, data, searchAbsentResultCallBack);
                break;
            case 'SEARCH_USER' : //회원 조회
                //  treeOpen();
                if(!isValid("SEARCH_USER")) return ;
                var url = "<c:url value='/edoc/eapproval/workflow/listApprovalUser.do'/>";
                var searchUserName = $("#searchUserName").val();
                var data = {searchUserName :searchUserName } ;
                ajaxPOST(url, data, addSearchUserCallBack);
                break;
            case 'INIT_TREE' :
                var url = "<c:url value='/cmm/system/memberManageView.do'/>";
                var data = {jsonView :"Y" } ;
                ajaxPOST(url, data, treeCallBack);
                break;
            case 'EDIT_ABSENT' : //부재자 설정 변경
                if(!isValid("EDIT_ABSENT")) return ;
                
                var uiUserKey = $("#uniqId").val();
                var oiOrgCode = $("#orgnztId").val();
                
                var aiStatus = $(":radio[name=absenceStatus][checked=checked]").val();
                var aiFlag = $(":radio[name=absenceFlag][checked=checked]").val();
                var aiSeqNum = $("#absenceSeqNum").val();
                var ciKeyCode = $("#absenceCode").val();
                
                
                //부재 시작일 문자열 합치기
                var absenceStartDay = $("#absenceStartDay").val() ;
                var absenceStartTime = $("#absenceStartTime").val() ;
                if(absenceStartTime.length==1){
                    absenceStartTime = "0"+absenceStartTime;
                }
                var absenceStartDate = absenceStartDay+" "+absenceStartTime+":00";
                var aiSDay = absenceStartDate;
                
                //부재 종료일 문자열 합치기
                var absenceEndDay = $("#absenceEndDay").val() ;
                var absenceEndTime = $("#absenceEndTime").val() ;

                if(absenceEndTime.length==1){
                    absenceEndTime = "0"+absenceEndTime;
                }
                var absenceEndDate = absenceEndDay+" "+absenceEndTime+":00";
                var aiEDay = absenceEndDate;
                
                var data = "uiUserKey="+uiUserKey
                           + "&oiOrgCode="+oiOrgCode
                           + "&aiStatus="+aiStatus
                           + "&aiFlag="+aiFlag
                           + "&aiSeqNum="+aiSeqNum
                           + "&ciKeyCode="+ciKeyCode
                           + "&aiMemo="+$("#absenceMemo").val()
                           + "&aiSDay="+aiSDay
                           + "&aiEDay="+aiEDay ;
                var objCariousInfo = document.getElementsByName("chkCariousInfo") ;
                
                var arrInx = checkBoxSelectedIndex( objCariousInfo) ;
                
                var rowNum = arrInx.length ;
                var realInx = 0 ;
                for(var inx =0 ; inx < rowNum ; inx++){
                    realInx = arrInx[inx];
                    //대행자를 선택한 것만 데이터를 입력
                    data += "&viOrgCode="+document.getElementsByName("C_VIORGCODE")[realInx].value
                           +"&viUserNm="+document.getElementsByName("AGENT_NM")[realInx].value
                           +"&viUserKey="+document.getElementsByName("C_VIUSERKEY")[realInx].value
                           +"&viAuthority="+document.getElementsByName("AUTHOR_CODE")[realInx].value ;
                }
                var url = "<c:url value='/cmm/system/editAbsent.do'/>";
                commonApproval.loadingStart();
                ajaxPOSTTxt(url, data, editAbsentCallBack);
                break;
            case 'DEL_ABSENT' : //부재자 삭제 
                if(!isValid("DEL_ABSENT")) return ;
                
                var objAbsentInfo = document.getElementsByName("chkAbsentInfo") ;
                
                var arrInx = checkBoxSelectedIndex( objAbsentInfo) ;
                var inx = arrInx[0] ;
                var data = {"uiUserKey" : document.getElementsByName("C_UIUSERKEY")[inx].value, 
                            "oiOrgCode" : document.getElementsByName("C_OIORGCODE")[inx].value ,               
                            "aiSeqNum" : document.getElementsByName("C_AISEQNUM")[inx].value };
                var url = "<c:url value='/cmm/system/deleteAbsentInfo.do'/>";
                commonApproval.loadingStart();
                
                if(!confirm('<%=BizboxAMessage.getMessage("TX000010862","선택한 부재정보를 삭제하시겠습니까?")%>')){
                	return;
                }
                
                ajaxPOST(url, data, deleteAbsentCallBack);
                break; 
            case 'Q_AGENT' : //대결자 조회
                var uniqId = $("#uniqId").val();
                var orgnztId = $("#orgnztId").val();
                var data = {"uiUserKey" :uniqId,
                            "oiOrgCode" :orgnztId,                
                            "aiSeqNum"  : arg2  };
                var url = "<c:url value='/cmm/system/selectAgentInfo.do'/>";
                commonApproval.loadingStart();
                ajaxPOST_(url, data, searchViCariousResultCallBack);
                break; 
            case 'INIT_ABSENT':
                var uniqId = $("#uniqId").val();
                if(uniqId.length==0){
                    alert("<spring:message code='absence.select.alert' />");
                    return;
                }
                input_clear();
                main('Q_AGENT',"");
                openAbsenceInfo();
                $('input:radio[name="absenceFlag"]:input[value="1"]').attr("checked", true);
                break;
        }
    }
    
    function chkAbsentUser(argCnt) {
        var inx = parseInt(argCnt) - 1 ;
        
        var oiOrgCode = document.getElementsByName("C_OIORGCODE")[inx].value ;
        var uiUserKey = document.getElementsByName("C_UIUSERKEY")[inx].value ;
        var aiSeqNum = document.getElementsByName("C_AISEQNUM")[inx].value ;
        var aiSDay = document.getElementsByName("C_AISDAY")[inx].value ;
        var aiEDay = document.getElementsByName("C_AIEDAY")[inx].value ;
        var aiStatus = document.getElementsByName("C_AISTATUS")[inx].value ;
        var ciKeyCode = document.getElementsByName("C_CIKEYCODE")[inx].value ;
        var aiMemo = document.getElementsByName("C_AIMEMO")[inx].value ;
        var uiUserNm = document.getElementsByName("C_UIUSERNM")[inx].value ;
        $('input:radio[name="absenceFlag"]:input[value="'+document.getElementsByName("C_AIFLAG")[inx].value+'"]').attr("checked", true);
        chngChkTable("Absent", argCnt);
        openAbsenceInfo();
        setAbsentInfo(oiOrgCode, uiUserKey, aiSeqNum, aiSDay, aiEDay, aiStatus, ciKeyCode, aiMemo, uiUserNm);
        main('Q_AGENT', aiSeqNum);
    }
    function chngChkTable(argDoc, argCount) {
        var objDoc = document.getElementsByName("chk"+argDoc+"Info") ;
        var currentInx = argCount -1 ;
        var rowNum = objDoc.length ;
        if (objDoc[currentInx].checked ) {
            for(var inx = 0 ; inx < rowNum; inx++) {
                if( inx != currentInx ) {
                    objDoc[inx].checked = false ;
                }
            }
        }else {
            objDoc[currentInx].checked = true;
              for(var inx = 0 ; inx < rowNum; inx++) {
                  if( inx != currentInx ) {
                      objDoc[inx].checked = false ;
                  }
              }
        }
    }
    
    //페이징 조회
    function goPage(pageNum) {
        <c:choose>
        <c:when test = "${AbsenceType eq 'admin'}">
            main("Q_ABSENT", "","", pageNum);
        </c:when>
        <c:when test = "${AbsenceType eq 'user'}">
            main("Q_ABSENT", loginInfo_id,"", pageNum);
        </c:when>
        </c:choose>
    }
    //반영결과callBack
    function editAbsentCallBack(data) {
        if(data.errorCode == 0 ) {
            $("#absenceSeqNum").val(data.aiSeqNum);
            <c:choose>
            <c:when test = "${AbsenceType eq 'admin'}">
                main("Q_ABSENT", "","", 1);
            </c:when>
            <c:when test = "${AbsenceType eq 'user'}">
                main("Q_ABSENT", loginInfo_id,"", "1");
            </c:when>
            </c:choose>
            main('Q_AGENT', data.aiSeqNum);
            alert("<%=BizboxAMessage.getMessage("TX000010861","입력한 부재내용을 반영했습니다")%>");
        }else {
            commonApproval.loadingEnd();
            alert(data.MSG);    
        }
    }
    //삭제결과 callBack
    function deleteAbsentCallBack(data) {
        if(data.errorCode == 0 ) {
            main('INIT_ABSENT');
            <c:choose>
            <c:when test = "${AbsenceType eq 'admin'}">
                main("Q_ABSENT", "","", 1);
            </c:when>
            <c:when test = "${AbsenceType eq 'user'}">
                main("Q_ABSENT", loginInfo_id,"", "1");
            </c:when>
            </c:choose>
            alert("<%=BizboxAMessage.getMessage("TX000010860","선택된 부재내용을 삭제했습니다")%>");
        }else {
            commonApproval.loadingEnd();
            alert(data.MSG);    
        }

    }
    //부재자 조회 결과
    function searchAbsentResultCallBack(data) {
        var listHtml = "" ;
        var list ;
        var rowNum = 0 ;
        var naviHtml = "";

        if(data == "" ||  data.list == "" || data.list == undefined ) {
            rowNum = 0 ;
        }else {
            rowNum = data.list.length;
            list = data.list ;
            curDate = data.curDate ;
            startCount = data.startCount ;
        }
        $("#idAbsentInfo").html("");

        listHtml += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" id = \"idAbsentInfoTable\" class=\"mT5 defaultTable\">";
        listHtml += "    <col width=\"25\" />";
        listHtml += "    <col width=\"80\" />";
        listHtml += "    <col width=\"100\" />";
        listHtml += "    <col width=\"90\" />";
        listHtml += "    <col width=\"\" />";
        listHtml += "    <col width=\"85\" />";
        listHtml += "    <col width=\"120\" />";
        listHtml += "    <col width=\"120\" />";
        listHtml += "    <tr>";
        listHtml += "   <th scope=\"col\"></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016239","부재상태")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000000098","부서")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016238","부재자")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016240","부재명")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016242","부재 시작일자")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016241","부재 종료일자")%></th>";
        listHtml += "    </tr>";
        
        for(var inx = 0; inx < rowNum; inx++){
            trClassName = "" ;
            if( inx % 2 == 1  ) {
                trClassName = "class = 'graybg'";
            }
            listHtml += "<tr "+trClassName+" >";
            listHtml += "   <td align=\"center\" class=\"first\"><input type=\"checkbox\"  name = \"chkAbsentInfo\" id = \"chkAbsentInfo\" onClick = \"chkAbsentUser('"+(inx+1)+"');\"  /></td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].C_AISTATUSNM+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].DEPTNAME+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].SUBPOSITIONNM+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" class=\"title\">"+list[inx].C_USERNM+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].C_CIKEYCODENM+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].C_AISDAY+"</td>";
            listHtml += "   <td onClick =\"chkAbsentUser('"+(inx+1)+"');\" align=\"center\">"+list[inx].C_AIEDAY+"</td>";
            listHtml += "</tr>";
            listHtml += "<input type = 'hidden' name = 'C_OIORGCODE' value = '"+list[inx].C_OIORGCODE+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_UIUSERKEY' value = '"+list[inx].C_UIUSERKEY+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AISEQNUM' value = '"+list[inx].C_AISEQNUM+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AISDAY' value = '"+list[inx].C_AISDAY+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AIEDAY' value = '"+list[inx].C_AIEDAY+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AISTATUS' value = '"+list[inx].C_AISTATUS+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_CIKEYCODE' value = '"+list[inx].C_CIKEYCODE+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AIMEMO' value = '"+list[inx].C_AIMEMO+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_UIUSERNM' value = '"+list[inx].C_USERNM+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_AIFLAG' value = '"+list[inx].C_AIFLAG+"'> ";
        }

        if(rowNum == 0 ) {
            listHtml += "<tr><td class=\"lt_text3\" nowrap colspan=\"8\" align=\"center\"><spring:message code='info.nodata.msg2' /></td></tr>";
        }else {
            naviHtml = data.naviHtml ;
        }
        listHtml += "</table>";

        $("#idAbsentInfo").html(listHtml);
        $("#idNavi").html(naviHtml);
        commonApproval.loadingEnd();

    }    
    //대결자조회 결과
    function searchViCariousResultCallBack(data) {
        var listHtml = "" ;
        var list ;
        var rowNum = 0 ;

        if(data == "" ||  data.list == "" || data.list == undefined ) {
            rowNum = 0 ;
        }else {
            rowNum = data.list.length;
            list = data.list ;
            curDate = data.curDate ;
            startCount = data.startCount ;
        }
        $("#idAgentInfo").html("");
        
        listHtml += "<table width=\"500px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" id = \"idAbsentInfoTable\" class=\"mT5 defaultTable\">";
        listHtml += "    <col width=\"25\" />";
        listHtml += "    <col width=\"140\" />";
        listHtml += "    <col width=\"\" />";
        listHtml += "    <col width=\"80\" />";
        listHtml += "    <col width=\"120\" />";
        listHtml += "    <tr>";
        listHtml += "   <th scope=\"col\"><input type=\"checkbox\"  name = \"chkAllCariousInfo\" id = \"chkAllCariousInfo\" onClick = \"chkAllCarious('chkAllCariousInfo','chkCariousInfo');\"  /></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000003323","권한")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016120","직위/직급")%></th>";
        listHtml += "   <th scope=\"col\"><%=BizboxAMessage.getMessage("TX000016325","대행자")%></th>";
        listHtml += "    </tr>";
        var cnt = 0 ;
        for(var inx = 0; inx < rowNum; inx++){
            trClassName = "" ;
            if( inx % 2 == 1  ) {
                trClassName = "class = 'graybg'";
            }
            cnt = inx +1 ;
            listHtml += "<tr "+trClassName+" >";
            listHtml += "   <td align=\"center\" class=\"first\"><input type=\"checkbox\"  name = \"chkCariousInfo\" id = \"chkCariousInfo\"   /></td>";
            listHtml += "   <td  class=\"title\">"+list[inx].AUTHOR_NM+"</td>";
            listHtml += "   <td  class=\"title\" id = 'idOrgnztNm"+cnt+"'>"+ncCom_EmptyReplace(list[inx].ORGNZT_NM,"")+"</td>";
            listHtml += "   <td  align=\"center\" id = 'idPositionNm"+cnt+"'>"+ncCom_EmptyReplace(list[inx].POSITION_NM,"")+"</td>";
            listHtml += "   <td  align=\"center\" id = 'idAgentNm"+cnt+"'>"+ncCom_EmptyReplace(list[inx].AGENT_NM,"")+"</td>";
            listHtml += "</tr>";
            listHtml += "<input type = 'hidden' name = 'AUTHOR_CODE' value = '"+list[inx].AUTHOR_CODE+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_VIUSERKEY' value = '"+ncCom_EmptyReplace(list[inx].C_VIUSERKEY,"")+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_VISEQNUM' value = '"+ncCom_EmptyReplace(list[inx].C_VISEQNUM,"")+"'> ";
            listHtml += "<input type = 'hidden' name = 'C_VIORGCODE' value = '"+ncCom_EmptyReplace(list[inx].C_VIORGCODE, "")+"'> ";
            listHtml += "<input type = 'hidden' name = 'AGENT_NM' value = '"+ncCom_EmptyReplace(list[inx].AGENT_NM,"")+"'> ";
        }

        if(rowNum == 0 ) {
            listHtml += "<tr><td class=\"lt_text3\" nowrap colspan=\"5\" align=\"center\"><spring:message code='common.nodata.msg' /></td></tr>";
        }else {
            
        }
        listHtml += "</table>";
        $("#idAgentInfo").html(listHtml);
        commonApproval.loadingEnd();
    }  
    //사용자조회 결과 callBack
    function addSearchUserCallBack(data) {
        
        var listHtml = "" ;
        var list ;
        var rowNum = 0 ;

        if(data == "" ||  data.list == "" || data.list == undefined ) {
            rowNum = 0 ;
        }else {
            rowNum = data.list.length;
            list = data.list ;
        }

        listHtml += " <dt class=\"clearfx\"><span><%=BizboxAMessage.getMessage("","검색결과")%><strong> "+rowNum+"<%=BizboxAMessage.getMessage("","건")%></strong></span> <a href=\"#none\" onClick =\"$('#searchOrgUserName').hide();\" ><img src=\"<c:url value='/images/btn/btn_close_s.gif'/>\" width=\"11\" height=\"11\" alt=\"닫기\" /></a></dt>" ;
        for(var inx = 0; inx < rowNum; inx++){
            listHtml += "<dd><a href=\"#none\" onClick =\"searchUserClick('"+ list[inx].ORGNZT_ID+"', '"+ list[inx].ESNTL_ID+"', '"+ list[inx].USER_NM+"');\"> ["+list[inx].ORGNZT_NM+"]"+ list[inx].USER_NM +"</a></dd>";
        }
        if(rowNum == 0 ) {
            listHtml += "<dd><%=BizboxAMessage.getMessage("","조회된 사원이 없습니다.")%></dd>";
        }
        $("#searchOrgUserName").html(listHtml);
        $("#searchOrgUserName").show();
        
    }
    
    function orgNameClick(organztID,  esntlID, userNm) {
        //search_member(esntlID, organztID);
        closeAbsenceInfo();     
        main("Q_ABSENT", esntlID, organztID);
        $("#orgnztId").val(organztID);
        $("#userName").val(userNm);
        $("#uniqId").val(esntlID);        
    }
    function searchUserClick(organztID,  esntlID, userNm) {
    	$("#"+curSelectedTree).attr("style","");
    	curSelectedTree = organztID + esntlID;
    	$("#"+curSelectedTree).attr("style","background-color: #eee;");
        orgNameClick(organztID,  esntlID, userNm);
        searchUpperTree(organztID);
    }
    function  searchUpperTree( organztID) {
        if( typeof(organztID) == "undefined" || ncCom_Empty(organztID) ) return ;
        treeOpen(organztID);
        var orgID = $("#"+organztID).attr("upperOrgID") ;
        searchUpperTree( orgID );
    }
    function  treeOpen(orgID) {
        var divName  = $("#"+orgID).children("div:eq(0)");
        var curClassName = $("#"+orgID).attr('class') ;
        $("#"+orgID).removeClass(curClassName);
        $("#"+orgID).addClass("collapsable");

        var className = divName.attr('class') ;
        divName.removeClass(className) ;
        className = " hitarea collapsable-hitarea";
        divName.addClass(className) ;
        var objUL = $("#"+orgID).children("ul:eq(0)") ;
        objUL.show();

    }
    
    function childTreeChk(upperOrgID,  orgID, contentType, deptID, deptName, userName) {
        
  	 	if(contentType== "M" || contentType== "R" || contentType== "L" ) {
            closeAbsenceInfo();     
            $("#uniqId").val(orgID);
            $("#orgnztId").val(deptID);
            $("#userName").val(userName);
            $("#absenceSeqNum").val("");
            main("Q_ABSENT", orgID, deptID);
  	 	}else if (contentType == "D")  {
  	 		$("#curOrgID").val(deptID);
  	 		$("#curOrgNm").val(deptName);
  	 	}else {
  	 		$("#curOrgID").val("");
  	 		$("#curOrgNm").val("");  	 		
  	 	}
  	 	$("#"+curSelectedTree).attr("style", "");
  	 	curSelectedTree = upperOrgID+orgID;
  	 	$("#"+curSelectedTree).attr("style", "background-color: #eee;");
    }
    

    //부재정보 적용하기
    function setAbsentInfo(oiOrgCode, uiUserKey, aiSeqNum, aiSDay, aiEDay, aiStatus, ciKeyCode, aiMemo, uiUserNm){
        
        //부재 일련번호 입력
        $("#absenceSeqNum").val(aiSeqNum);
        $("#userName").val(uiUserNm);
        // 부재 상태 입력
        $("input[name=absenceStatus]").filter("input[value="+aiStatus+"]").attr("checked", "checked");
        $("#absenceCode option[value="+ciKeyCode+"]").attr("selected", "true");

        //부재시작일자
        var absenceStartDate = aiSDay;
        $("#absenceStartDate").val(absenceStartDate);
        $("#absenceStartDay").val(absenceStartDate.substr(0,10));
        $("#absenceStartTime").val(parseInt(absenceStartDate.substr(11,2)));

        //부재종료일자
        var absenceEndDate = aiEDay;
        $("#absenceEndDate").val(absenceEndDate);
        $("#absenceEndDay").val(absenceEndDate.substr(0,10));
        $("#absenceEndTime").val(parseInt(absenceEndDate.substr(11,2)));
        
        $("#uniqId").val(uiUserKey);
        $("#orgnztId").val(oiOrgCode);
        $("#absenceMemo").val(ncCom_EmptyReplace(aiMemo,"") );
    }

    function input_clear(){
        var select_teg = $("#absence_info select");
        select_teg.each(function(){
            $(this).find("option:eq(0)").attr("selected", true);
        });
        
        var userName = $("#userName").val();
        $("#absence_info input[type=hidden]").val("");
        $("#absence_info input[type=text]").val("");
        $("#absence_info :radio[name=absenceStatus][value=1]").attr("checked", true);
        $("#absence_info :radio[name=absenceFlag][value=0]").attr("checked", true);

        $("#absenceStartTime").val("0");
        $("#absenceEndTime").val("23");
        $("#absenceSeqNum").val("");
        $("#userName").val(userName);
    }
    
    function openAbsenceInfo(){
        
        $("#absence_info").slideDown();
    }

    function closeAbsenceInfo(){
        $("#absence_info").slideUp();
    }

    /**
    *   대행자 선택
    */
    function select_agent(){

        if(!isValid("SEL_AGENT")) return ;
        var rootId = '<spring:message code="neos.organ_id" />';
        window.open('<c:url value="/cmm/system/selectMemberViewPopup.do?rootId='+rootId+'&methodName=insertAgentInfo&popupTitle=absence.agent.select" />', "selectMemberView", 'toolbar=no, scrollbar=no, width=290, height=650, resizable=no, status=no');
    }

    /**
    *   대행자 선택후 입력
    */
    function insertAgentInfo(result_value){
        var result_arr = result_value.split("##");
        var id = result_arr[0];
        $.ajax({
            type:"post",
            url:"<c:url value='/cmm/system/selectMemberInfo.do'/>",
            data:{"esntlId":id, "orgnztId": result_arr[2]},
            datatype:"json",
            success:function(data){
                var result = data.result;
                var result_data = {agentOrgnztNm:result.orgnztNm,
                                   positionNm:result.positionNm,
                                   agentNm:result.userNm,
                                   agentOrgnztId:result.orgnztId,
                                   positionCode:result.positionCode,
                                   agentUniqId:result.esntlId};
                var arrInx = checkBoxSelectedIndex( document.getElementsByName("chkCariousInfo")) ;
                var rowNum = 0 ;
                var realInx = 0 ;
                if( arrInx != undefined) {
                    rowNum = arrInx.length ;
                } 
                var cnt = 0 ;
                for(var inx=0 ;inx < rowNum ;inx++){
                    realInx = arrInx[inx];
                    cnt = realInx + 1 ;
                      
                    $("#idOrgnztNm"+cnt).html(result.orgnztNm);
                    $("#idPositionNm"+cnt).html(result.positionNm);
                    $("#idAgentNm"+cnt).html(result.userNm);
                    document.getElementsByName("C_VIUSERKEY")[realInx].value = result.esntlId;
                    document.getElementsByName("C_VIORGCODE")[realInx].value = result.orgnztId;
                    document.getElementsByName("AGENT_NM")[realInx].value = result.userNm;
                }

            }
        });
    }

  //체크박스 선택시 toggle
    function chkAllCarious(allChkName, chkName) {
        var chkDoc = document.getElementsByName(chkName);

        var allChkName = document.getElementsByName(allChkName);
        allCheckBox(chkDoc, allChkName[0].checked);
    }
    </script>
<form name = "">
<input type="hidden" name="uniqId" id="uniqId" value="">
<input type="hidden" name="orgnztId" id="orgnztId" value="">
<input type="hidden" name="currentPage" id = "currentPage" value="1">
<div id="absence_info" style="display:none; width:100% ">
       <fieldset class="mT20" >
                    <legend><%=BizboxAMessage.getMessage("TX900000438","부재 정보")%></legend>
                    <ul class="inputForm" id="absence_info_table">
                        <li><strong style="width:90px;"><%=BizboxAMessage.getMessage("TX000000978","성명")%><span class="f_red">&nbsp; </span></strong>
                            <input type="text" name="userName" id="userName" value="" style="width:80px;" disabled="disabled"> 
                        </li>
                        <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX000016239","부재상태")%><span class="f_red">*</span></strong> 
                              <span id="absenceStatusDiv" ></span>
                              <script>                                                          
                              var absenceStatus = NeosCodeUtil.getCodeRadio("COM157", "absenceStatus", 'FIRST', '');
                              $("#absenceStatusDiv").html(absenceStatus);
                               </script>   
                        </li>
                        <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX000019408","부재종류")%><span class="f_red">*</span></strong> 
                              <span id="absenceTypeDiv" ></span>
                              <script>                                                          
                              var AbsenceCode = NeosCodeUtil.getCodeSelectFirstName("COM085", "absenceCode", "", "", "", "선::택","") ;
                              $("#absenceTypeDiv").html(AbsenceCode);
                              $("#absenceCode").css("width", "150px;");
                               </script>   
                        </li>
                        <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX000002705","기간설정")%><span class="f_red">*</span></strong> 
                              <span class="fL10"><%=BizboxAMessage.getMessage("TX000017894","시작일")%> :</span>
                                                    <input type="hidden" name="absenceStartDate" id="absenceStartDate" value="">
                                                    <input type="text" name="absenceStartDay" id="absenceStartDay" value="" style="width:80px;"> 
                                                <script>
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
                                                            }
                                                        };
    
                                                        
                                                        neosdatepicker.datepicker("absenceStartDay", pickerOpts);
                                                        
                                                        $(".ui-datepicker-trigger img").attr("align", "absmiddle");                                                 
                                                </script>  
                               <select name = "absenceStartTime" id="absenceStartTime">
                                                        <c:forEach var = "x" begin = "0" end = "23">
                                                            <option value = "${x}">${x} 시</option>
                                                        </c:forEach>
                               </select> ~
                               <span class="fL10"><%=BizboxAMessage.getMessage("TX000017895","종료일")%> :</span>
                                                    <input type="hidden" name="absenceEndDate" id="absenceEndDate" value="">
                                                    <input type="text" name="absenceEndDay" id="absenceEndDay" value="" style="width:80px;">
                                                <script>
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
                                                            }
                                                        };


                                                        neosdatepicker.datepicker("absenceEndDay", pickerOpts);

                                                        $(".ui-datepicker-trigger img").attr("align", "absmiddle");
                                                </script>
                                                     <select name = "absenceEndTime" id="absenceEndTime">
                                                        <c:forEach var = "x" begin = "0" end = "23">
                                                            <option value = "${x}">${x} 시</option>
                                                        </c:forEach>
                                                    </select>
                        </li>
                        <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX900000439","자동부재 해제")%><span class="f_red">*</span></strong> 
                                                    <input id="absenceFlag1" type="radio"  value="0" name="absenceFlag">
                                                    <label for="absenceFlag1"><%=BizboxAMessage.getMessage("TX900000440","자동부재 해제 안함")%></label>
                                                    <input id="absenceFlag2" type="radio" value="1" name="absenceFlag">
                                                    <label for="absenceFlag2"><%=BizboxAMessage.getMessage("TX900000439","자동부재 해제")%></label>
                        </li>
                        <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX900000441","부재 설명")%><span class="f_red">*</span></strong> 
                              <input id="absenceMemo" type="text" value="" name="absenceMemo" style="width:500px;">
                        </li>
                       <li><strong style="width:100px;"><%=BizboxAMessage.getMessage("TX900000442","대행자 정보")%><span class="f_red">*</span></strong> <a href="javascript:select_agent();" class="btn18"><!--신규--><span><%=BizboxAMessage.getMessage("TX900000443","대행자선택")%></span></a>
                       </li>
                       <li id="idAgentInfo" class="board_table" style="margin-left:120px;">
                                            <table id="list2" style="width:500px"></table>
                        </li>
                    </ul>
                    <input type="hidden" name="absenceSeqNum" id="absenceSeqNum" value="">

            <p class="tC mT15" id="saveButton">
                 <a href="javascript:main('EDIT_ABSENT');" class="darkBtn"><span><%=BizboxAMessage.getMessage("TX000001256","저장")%></span></a> 
                 <a href="javascript:closeAbsenceInfo();" class="grayBtn"><span><%=BizboxAMessage.getMessage("TX000002947","취소")%></span></a>
            </p>
            <p class="tC mT15"  style="display:none;"  id="editButton">
                 <a href="javascript:main('EDIT_ABSENT');" class="darkBtn"><span><%=BizboxAMessage.getMessage("TX000002947","수정")%></span></a> 
                 <a href="javascript:main('DEL_ABSENT');" class="grayBtn"><span><%=BizboxAMessage.getMessage("TX000017212","폐기")%></span></a>
            </p>

        </fieldset>             
</div>

                            <div id="div_btn2" class="mB7">
                                <div class='clearfx mT20'>
                                <p class='fR' >
                                    <a class='btnArrow' href='javascript:;' onclick="main('INIT_ABSENT');" title='신규' style='margin-left:4px'><span><%=BizboxAMessage.getMessage("TX000003101","신규")%></span></a>
                                </p>
                                </div>
                            </div>
            <c:if test = "${AbsenceType eq 'admin'}">
<div class="groupArea fL"  id="tree_teg">
              <div class="userSearch"><input type="text" style="width:170px;"  name="searchUserName"  id="searchUserName"  class="kr" value=""  onKeyDown="if(event.keyCode==13) main('SEARCH_USER');" maxlength="10" /> <a href="#none" onClick ="main('SEARCH_USER');"><img src="<c:url value='/images/btn/btn_groupSearch.gif' />" alt="검색" /></a></div>
                <div class="groupTreeArea" style="overflow-y:scroll;">
                       <div  id = "organization_tree" class = "filetree" >
                        ${organTree}
                        </div>
                        <dl class="searchResult" id = "searchOrgUserName"  style="max-height:340px;">
                         </dl>
                </div>
</div>  

            </c:if>

<div class="contents_right"  id="detail_teg">
<div id = "idAbsentInfo">
</div>
 <p class="paging mT15 mB30" id= "idNavi"></p>
                            </div>

</form>