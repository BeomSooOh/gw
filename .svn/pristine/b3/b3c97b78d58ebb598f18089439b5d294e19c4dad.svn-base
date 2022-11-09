<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<%@page import="neos.cmm.util.BizboxAProperties"%>
<%String allDownLoadLimit = BizboxAProperties.getCustomProperty("BizboxA.Cust.allDownLoadLimit");%>

<c:if test="${displayMode != 'L' || uploadMode == 'D'}">
<style>
/*첨부파일*/
.file_add_area{border:0;}
.file_add_top{text-align:left;padding:5px 0;overflow:hidden;font-size:0;}
.file_add_top span{display:inline-block;font-size:12px;line-height:22px;font-size:12px;padding-right:10px;*vertical-align:top;}
.file_add_top .file_add_dis{float:right;*float:none;color:#a0a0a0;padding-right:0;*padding-left:20px;}

.file_add_bot{overflow:auto;background:#f9f9f9;height:130px;}
.file_add_bot .file_add_bot_dis{padding:50px 0;text-align:center;font-size:0;}
.file_add_bot .file_add_bot_dis .fileplus_ico{display:inline-block;padding-left:20px;font-size:12px;height:20px;line-height:23px;color:#a0a0a0;background:url("<c:url value='/Images/ico/fileplus_ico.png'/>") no-repeat left;}

.file_add_bot .file_group2{padding:0 0 0 30px;overflow:hidden;font-size:0;}
.file_add_bot .file_group2 li{position:relative;width:89px;float:left;margin:10px 32px 0 0;}
.file_add_bot .file_group2 li .file_info{width:87px;height:87px;border:1px solid #474747;background:#ffffff;}
.file_add_bot .file_group2 li:hover .file_info{width:87px;height:87px;border:1px solid #474747;background:#f4f4f4;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align{display:table-cell;width:87px;height:87px;vertical-align:middle;position: relative;}
.file_add_bot .file_group2 li .file_info .img_align{display:table-cell;width:87px;height:87px;text-align:center;vertical-align:middle;overflow:hidden;}
.file_add_bot .file_group2 li .file_info .img_align img{width:100%;height:100%;max-width:87px;max-height:87px;cursor:pointer;}

.file_add_bot .file_group2 li .file_info .file_align .file_hwp{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_01.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_zip{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_02.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_doc{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_03.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_ppt{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_04.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_mp4{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_05.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_wav{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_06.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_wma{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_07.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_tif{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_08.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_gul{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_09.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_ai{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_10.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_psd{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_11.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_htm{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_12.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_flv{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_13.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_mpg{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_14.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_mpeg{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_15.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_asf{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_16.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_mov{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_17.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_wmv{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_18.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_pdf{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_19.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_txt{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_20.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_mp3{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_21.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_avi{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_22.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_etc{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_23.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_xls{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_24.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_img{width:46px;height:52px;margin:0 auto;*margin-top:18px;background:url("<c:url value='/Images/ico/icon_file_25.png'/>") top no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_info .file_align .file_loading{width:83px;height:87px;margin:0 auto;background:url('../Images/ico/icon_file_24.gif') 0 -3px no-repeat;}

.file_add_bot .file_group2 li .file_name_box{width:87px;}
.file_add_bot .file_group2 li .file_name_box p{display:block;overflow:hidden;padding:5px 0 0 0;line-height:18px;font-size:11px;color:#000000;font-family:"굴림",Gulim,sans-serif;margin-top: 0px;margin-bottom: 0px;height: 20px;text-overflow: ellipsis;white-space: nowrap;}
.file_add_bot .file_group2 li:hover .file_name_box p{text-decoration:underline;cursor:pointer;font-family:"굴림",Gulim,sans-serif;}
.file_add_bot .file_group2 li .file_delete{position:absolute;top:0px;right:0px;width:16px;height:16px;background:url("<c:url value='/Images/ico/btn_fileX.png'/>") 0px 0px no-repeat;cursor:pointer;}
.file_add_bot .file_group2 li .file_delete:hover{background:url("<c:url value='/Images/ico/btn_fileX.png'/>") -16px 0px no-repeat;}

.btn_txt_p38{display:inline-block;font-size:11px;color:#000000;text-align:center;padding:3px 8px;border:1px solid #b2b2b2;background:#f9f9f9;display:inline-block;font-size:11px;color:#000000;text-align:center;padding:3px 8px;border:1px solid #b2b2b2;background:#f9f9f9;text-decoration:none;}
.btn_txt_p38:hover{display:inline-block;font-size:11px;color:#000000;text-align:center;padding:3px 8px;border:1px solid #a0a0a0;background:#e5e5e5;}
.btn_txt_p38.disabled{display:inline-block;font-size:11px;color:#c8c8c8;text-align:center;padding:3px 8px;border:1px solid #d8d8d8;background:#fcfcfc;}


.tooltip_file{display:none;font-size:8.25pt; border:1px solid #BBBBBB;padding:10px;height:auto;background:white;position:absolute;z-index:10001;}
.mi135 {-ms-word-break:break-all;word-break:break-all; overflow: auto;}
.mba_form table tr.big_tr td {padding-right:0;}
.file_set {float:left;margin:8px 18.5px 0px 0;padding-bottom:8px;}
.file_set:first-child {margin-left:0;}
.file_disp{position:relative;width:87px;height:87px;vertical-align:middle;border:1px solid #474747;}
.file_disp:hover .downfile_modal{display:block}
.file_info:hover .downfile_modal{display:block}
.file_set .file_img  {text-align:center;overflow:hidden;float:left; width:87px; height:87px;cursor:pointer;}
.file_set .file_img  a {display:block;width:100%;height:100%;border:1px solid #eee;overflow: hidden;}
.file_set .file_img.wide img {margin-left: -20%; max-height:100px;}
.file_set .file_img.tall img {margin-top: -20%; width:100%;}
.file_set .file_img.square img {height:100%; width:100%;}
.file_set .file_img.load img{width:100%;height:100%;max-width:87px;max-height:87px;}
.file_set .file_img {}
.file_set .file_hwp{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_01.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_zip{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_02.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_doc{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_03.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_ppt{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_04.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_mp4{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_05.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_wav{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_06.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_wma{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_07.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_tif{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_08.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_gul{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_09.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_ai{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_10.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_psd{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_11.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_htm{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_12.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_flv{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_13.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_mpg{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_14.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_mpeg{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_15.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_asf{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_16.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_mov{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_17.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_wmv{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_18.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_pdf{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_19.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_txt{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_20.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_mp3{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_21.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_avi{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_22.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_etc{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_23.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_xls{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_24.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_img2{width: 100%;height:100%;background:#fff url("<c:url value='/Images/ico/icon_file_25.png'/>") center center no-repeat;cursor:pointer;}
.file_set .file_name {width:89px;}
.file_set .file_name p{width:89px;display:block;overflow:hidden;padding:5px 0 0 0;line-height:18px;font-size:11px;color:#000000;font-family:"굴림",Gulim,sans-serif;margin-top: 0px;margin-bottom: 0px;height: 33px;text-overflow: ellipsis;white-space: nowrap;}
.file_set .file_name p:hover {text-decoration:underline;cursor:pointer; font-family:"굴림",Gulim,sans-serif;}


.downfile_modal{display:none;width:100%;height:100%;position: absolute;top: 0;left: 0;background:url('/gw/Images/bg/timeline_60p_bg.png') repeat;}
.downfile_modal ul{padding:17px 0 0 0;}
.downfile_modal ul li{text-align:center;float: none !important;width: initial !important;margin: 0 !important;position: initial !important;}
.downfile_modal ul li a{display:inline-block;margin:2px 0;padding:3px 0;color: #ffffff;border:1px solid #ffffff;background:#666666;min-width:65px;font-size: 12px;line-height: 16px;}
.downfile_modal ul li a:hover{border:1px solid #0b6ab2;background:#0b6ab2;}


/* 게시판 쓰기 첨부파일 시작 */
.write_addfile {display:inline-block; width:100%; background:#e1eaf1;}
.write_addfile .write_addtop {width:100%;}
.write_addfile .write_addtop td {padding-top:4px; padding-bottom:4px;}
.write_addfile .write_addtop td img {vertical-align:middle;}
.write_addfile .write_addtop td.tit {padding-left:7px; color:#3e3e3e;  font-size:12px; font-weight:bold;}
.write_addfile .write_addtop .tdW{width:75px;}

.write_addfile .write_addbot {width:100%;}
.write_addfile .write_addbot .con {background:#fff; border:1px solid #c0c0c0;}
.write_addfile .write_addbot .con ul {margin-left:19px; margin-top:10px; margin-bottom:10px;}
.write_addfile .write_addbot .con ul li {padding-top:4px; padding-bottom:4px;}
.write_addfile .write_addbot .con ul li a {color:#3e3e3e;  font-size:12px;}
.write_addfile .write_addbot .con ul li a:hover {text-decoration:underline;}
.write_addfile .write_addbot .con ul li span.txt_tit {text-decoration:underline;}
.write_addfile .write_addbot .con ul li span.size {padding-left:10px; color:#818181;  font-size:11px;}
.write_addfile .write_addbot .con ul li span.del {float:right; padding-right:20px;}
.write_addfile .write_addbot .con ul li span.del a {color:#666;  font-size:11px;}
.write_addfile .write_addbot .con ul li img {vertical-align:middle; padding-right:3px;}

.write_addfile .write_addbot01 {width:100%;}
.write_addfile .write_addbot01 table{width:100%; border-right:1px solid #c0c0c0;}


.tb_addfile {margin-right:0px;}
.tb_addfile .Addfile {width:100%; border-collapse:collapse;}
.tb_addfile .Addfile tr {border:1px solid #bebebe;}
.tb_addfile .Addfile tr.line_none {border:none; height:5px;}
.tb_addfile .Addfile td {text-align:left; word-break:break-all; line-height:16px;}
.tb_addfile .Addfile td img {vertical-align:middle; margin-top:-2px;}
.tb_addfile .Addfile td.addfile_top {height:28px; *padding-top:9px; padding-left:15px; color:#404041; background-color:#f5f4f0;}
.tb_addfile .Addfile td.addfile_top span.bold {font-weight:bold; font-size:12px;}
.tb_addfile .Addfile td.addfile_top span.green_bold {font-weight:bold; font-size:12px; color:#1db24b;}
.tb_addfile .Addfile td.addfile_top span.green {font-size:12px; color:#1db24b;}
.tb_addfile .Addfile td.addfile_top span.save {float:right; margin-right:14px; *margin-top:-7px;}
.tb_addfile .Addfile td.addfile_top span.save a {font-size:11px; color:#666; padding-left:17px;}
.tb_addfile .Addfile td.addfile_top span.save img {*vertical-align:middle; *margin-top:-15px;}
.tb_addfile .Addfile td.addfile_bot {padding-left:15px;font-size:12px; color:#323232;}
.tb_addfile .Addfile td.addfile_bot img {vertical-align:middle; margin-top:1px; padding-right:10px;}
.tb_addfile .Addfile td.addfile_bot span.name_size {font-size:11px; color:#818181; padding-left:5px;}
.tb_addfile .Addfile td.right {text-align:right; padding-right:15px;}
.tb_addfile .Addfile td.right a {color:#666; font-size:11px;}

.downfile_sel_pop{background:#fff;border:1px solid #c3c3c3;padding:5px 10px;}
.downfile_sel_pop ul li{min-width:70px;padding: 3px 0;}
.downfile_sel_pop ul li a{white-space: nowrap;}

body {
 margin-left: 0px;
 margin-top: 0px;
 margin-right: 0px;
 margin-bottom: 0px;
 overflow-y: auto;
 overflow-x: hidden;
}

</style>
</c:if>

<link rel="stylesheet" type="text/css" href="/gw/css/common.css?ver=20201021">
<script type="text/javascript" src="/gw/js/Scripts/jquery-1.9.1.min.js"></script>

<script type="text/javascript" language="javascript">
	var fileTotalSize = 0;
    var mode = "${uploadMode}";
    var showPath = "${showPath}" == "" ? "0" : "${showPath}"; 
    var displayMode = "${displayMode}";
    
    if(mode == "U" && showPath == "1"){
        var agent = navigator.userAgent.toLowerCase();
        
        if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) || (agent.indexOf("edge") != -1)) {
        	showPath = "Y";
        }else{
        	showPath = "N";
        }
    }else if(mode == "D" && showPath == "1"){
    	showPath = "Y";
    }
    
    var cntFile = 0;
    var attachMode = "";
    var attachFile = [];
    var attachFileSize = 0;
    var AttFile = "";
	var groupSeq = "${groupSeq}";
	
	var DEXT5UPLOAD_STATE = false;
    var UPLOAD_COMPLITE = false;
    var APPEND_FILELIST = false;
    var UPLOAD_ID = "";
    
    var Binding_Data;
    var tempPath = "";
    var UploadCallback = "";
    var pathSeq = "${pathSeq}";
    
    //자동첨부 관련
    var deleteYN = "${deleteYN}";
    var fileNms = "${fileNms}";
    var fileKey = "${fileKey}";
    
    var selectedFileUrl = "";
    var selectedfileNm = "";
    var selectedfileId = "";
    
    //첨부파일보기설정(문서뷰어, 파일다운)
    //downloadType : -1 -> 미선택
 	//downloadType : 0 -> 문서뷰어+파일다운
 	//downloadType : 1 -> 파일다운
 	//downloadType : 2 -> 문서뷰어
    var downloadType = "${downloadType}";
   
    
    //첨부파일 용량, 갯수제한
    var availCapac = "${groupPathInfo.availCapac}";
    var totalCapac = "${groupPathInfo.totalCapac}";
    var limitFileCount = "${groupPathInfo.limitFileCount}";
    var attTotalSize = 0;
    var delFileCnt = 0;
    var checkLimitCnt = 0;
    var Bindinglist = [];
    
    //빌드타입(build, cloud)
    var buildType = "${buildType}";
    
    //전체다운로드 타켓 fileList
    var downloadAllFileList = [];
    
    //허용확장자 및 허용파일갯수
    var allowExtention = "${allowExtention}";
    var allowFileCnt = "${allowFileCnt}";
    
    if(allowFileCnt != "")
    	limitFileCount = allowFileCnt;
    
    
    
    if(availCapac == "0" || availCapac == 0)
    	availCapac = (5120 * 1024 * 1024);
    else
    	availCapac = availCapac * 1024 * 1024;
    
    if("${allowFileSize}" != ""){
    	availCapac = "${allowFileSize}" * 1024 * 1024;
    }
    
    
    if(totalCapac == "0" || totalCapac == 0)
    	totalCapac = "";
    else
    	totalCapac = totalCapac * 1024 * 1024
    if(limitFileCount == "0" || limitFileCount == 0)
    	limitFileCount = "";
    
    if(fileKey != ""){
    	tempPath = "${pathMp.absolPath}/uploadTemp/" + fileKey;
    }else{
        //임시폴더키 생성
        var rndstr = new RndStr();
        rndstr.setType('0'); //숫자
        rndstr.setStr(20);   //10자리
        tempPath = "${params.absolPath}/uploadTemp/" + rndstr.getStr();
    }
	
	var documentHegith = document.documentElement.clientHeight;
	
	if(parent.document.getElementById("uploaderView") != null){
		parent.document.getElementById("uploaderView").setAttribute("scrolling", "no");
	}
	
    $("document").ready(function () {
    	var fileHeight = documentHegith - $("#fileAddTop").height();

    	if(window.frameElement != null){
	    	$('#' + window.frameElement.id, parent.document).css("overflow","auto");
	    	$('#' + window.frameElement.id, parent.document).attr("scrolling", "yes");
    	}
		
    	<c:if test="${uploadMode == 'U'}">
        $(".file_name_box").mouseover(function (e) {
            var tooltip = "<div id='tooltipevetn' class='tooltip_file'>" + $(this).find('P').html() + "</div>";
            $("body").append(tooltip);
            $('#tooltipevetn').css('top', $(this).offset().top - 40);
            $('#tooltipevetn').css('left', $(this).offset().left);
            $(this).css('z-index', 10000);
            $('#tooltipevetn').fadeIn('500');
            $('#tooltipevetn').fadeTo('10', 1.9);
        }).mousemove(function (e) {
        	$('#tooltipevetn').show();
        }).mouseout(function (e) {
            $(this).css('z-index', 8);
            $('#tooltipevetn').remove();
        });

        //첨부 파일 추가
        var dropZone = document.getElementById('dropZone');

        if (document.addEventListener && window.File != undefined) {//addEventListener함수를 제공해주는지 여부에 따라 분기
            dropZone.addEventListener('dragover', handleDragOver, false);
            dropZone.addEventListener('drop', handleFileSelect, false);
            document.getElementById('uploadFile').addEventListener('change', handleFileSelect, false);
            
            //경로저장 모드일경우 드레그 불가
            if(showPath == "Y" || showPath == "N"){
            	$("#fileAddDrop").remove();
            }
        } else {
            if (mode == "U") {
                $("#fileAddDrop").remove();
            } else {
                $("#dropZone").remove();
            }
        }

        $('#fileUpload').click(function () { //파일첨부 클릭
            if (document.addEventListener && window.File != undefined) {
                attachMode = "click";
                $('#uploadFile').click();
            } else {
                product_line_add();
            }
        });

        </c:if>
        
        DEXT5UPLOAD_OnCreationComplete();
        
    	<c:if test="${uploadMode == 'U'}">
    	if(APPEND_FILELIST){
            $(".file_add_bot").css('height', (fileHeight - 33) + 'px');
            $(".Addfile").css('height', (fileHeight - 3) + 'px');
    	}
        </c:if>
        
    	<c:if test="${uploadMode == 'D'}">
    	if(APPEND_FILELIST){
    		$(".mi135").css('height', (fileHeight - 37) + 'px');	
    	}
    	</c:if>
    	
    	$("body").css('margin','0px');
    	
    	addAutoAttach();
    	
    	if(displayMode == 'L'){
    		if(mode == 'U')
    			$('body').css('margin-top',-20);
    		else if(mode == 'D'){
    			$('body').css('margin-top',-40);
    			$("#detailInfo").hide();
    		}
    	}
    	
    	
//     	var list = [];
//     	var data = {};
//     	data.fileId = "12329";
//     	data.fileNm = "p:\\BizBoxdForm.pdf";
//     	data.fileSize = "1048576";    	
//     	data.fileUrl = "/edms/board/downloadFile.do?boardNo=3688&fileNm=20170410142422508318.xls&fileRnm=BizBoxAlpha_OrgUploadForm.xls"
//     	data.fileSn = "0";
//     	list.push(data);
    	
//     	var data1 = {};
//     	data1.fileId = "12329";
//     	data1.fileNm = "c:\\BizBoadForm.xls";
//     	data1.fileSize = "1048576";    	
//     	data1.fileUrl = "/edms/board/downloadFile.do?boardNo=3688&fileNm=20170410142422508318.xls&fileRnm=BizBoxAlpha_OrgUploadForm.xls"
//     	data1.fileSn = "0";
    	
//     	list.push(data1);
//     	list.push(data);
//     	fnAttFileListBinding(list);
    });
    
    function getAttTotalSize(){
    	return attTotalSize/1024/1024;
    }
    
    
    //자동첨부 바인드
    function addAutoAttach(){
    	if(fileKey != ""){
    	    var autoArray = fileNms.split('|');
    	    
            $("#fileGroup").html("");
            $("#productList").html("");
    		
            if (autoArray != null && autoArray.length > 0) {
            	APPEND_FILELIST = true;
            	
                var tag = '';
                $("#fileAddDrop").hide();
                
                $.each(autoArray, function (i, t) {
                	if(t != ""){
                    	$("#fileAddDrop").hide();
                        
                        var tag = '';
                        if (t.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {
                            tag += "<li id=\"addAutoFile" + i + "li\">";
                            tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + ConvertSystemSourcetoHtml(t) + "</p>";
                            tag += "<input type=\"hidden\" name=\"addFile\" value=\"" + ConvertSystemSourcetoHtml(t) + "\"/>";
                            tag += "<div class=\"file_info\"><div class=\"file_align\">";
                            tag += "<div class='file_img'></div></div></div>";
                            tag += "<div class=\"file_name_box\"><p class=\"file_name\">" + ConvertSystemSourcetoHtml(t) + "</p></div>";
                            if(deleteYN == 'Y'){
                            	tag += "<div id=\"addAutoFile" + i + "\" onclick=\'delAutoFile(this.id, \"" + ConvertSystemSourcetoHtml(t) + "\");\' class=\"file_delete\"></div></li>";	
                            }
                        } else {
                            tag += "<li id=\"addAutoFile" + i + "li\">";
                            tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + ConvertSystemSourcetoHtml(t) + "</p>";
                            tag += "<input type=\"hidden\" name=\"addFile\" value=\"" + ConvertSystemSourcetoHtml(t) + "\"/>";
                            tag += "<div class=\"file_info\"><div class=\"file_align\">";
                            tag += "<div class='" + fncGetFileClass(t) + "'></div></div></div>";
                            tag += "<div class=\"file_name_box\"><p class=\"file_name\">" + ConvertSystemSourcetoHtml(t) + "</p></div>";
                            if(deleteYN == 'Y'){
                            	tag += "<div id=\"addAutoFile" + i + "\" onclick=\'delAutoFile(this.id, \"" + ConvertSystemSourcetoHtml(t) + "\");\' class=\"file_delete\"></div></li>";	
                            }
                        }

                        $("#fileGroup").append(tag);
                	}
                });                    
                
                $("#fileGroup").append(tag);
                fnEventSet();
            }    	    
    	}
    }
    
    function DEXT5UPLOAD_OnCreationComplete() {
        DEXT5UPLOAD_STATE = true;
        
        if(parent.fnLoadCallback != null){
        	parent.fnLoadCallback();
        }
    }    
    
    function byteConvertor(bytes) {

    	bytes = parseInt(bytes);

    	var s = ['bytes', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb'];

    	var e = Math.floor(Math.log(bytes)/Math.log(1024));

    	if(e == "-Infinity") return "0 "+s[0]; 

    	else return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];

    }
    
    function ConvertSystemSourcetoHtml(str){
	   	 str = str.replace(/</g,"&lt;");
	   	 str = str.replace(/>/g,"&gt;");
	   	 str = str.replace(/\"/g,"&quot;");
	   	 str = str.replace(/\'/g,"&#39;");
	   	 str = str.replace(/\n/g,"<br />");
	   	 return str;
  	}
   
    
    function fnDownLoadFileListBinding(fileList){
    	if(fileList == null)
    		return;
    	
    	downloadAllFileList = fileList;
        var tag = "";
        var edriveTag = "";
        var cnt = fileList.length;
        var totalSize = 0;
        var edriveCnt = 0;
        var fileCnt = 0;
        var checkLimitCnt = fileList.length;
        if(displayMode == "L"){        	
        	if (cnt > 0) {
        		$("#detailInfo").show();
        		APPEND_FILELIST = true;
        		for(var i=0;i<fileList.length;i++)	            	
    	            totalSize += parseInt(fileList[i].fileSize);
        		
        		tag += "<div id=\"\" class=\"search_downfile mt20\">";
        		tag += "<div class=\"file_down_top clear\">";
        		tag += "<div class=\"fl\">";
				        
        		tag += "<span class=\"fwb\">첨부파일</span>";
        		tag += "<span id=\"\" class=\"fwb text_blue\" style=\"margin-left:10px;\">"+ fileList.length +"</span>개 / <span id=\"\">" + byteConvertor(totalSize) + "</span>";
        		tag += "</div>";			        
       			tag += "</div>";
			
    			tag += "<div id=\"\" class=\"file_down_bot\">";
      			tag += "<ul class=\"file_group\" style=\"width:100%;\">";
        		
      			for (var j = 0; j < fileList.length; j++) {
      				var fileId = fileList[j].fileId;
	                var fileNm = ConvertSystemSourcetoHtml(fileList[j].fileNm);
	                var fileSize = byteConvertor(fileList[j].fileSize);
	                var fileThumUrl = fileList[j].fileThumUrl.replace("/NAS_File/","/");
	                var fileUrl = fileList[j].fileUrl.replace(/\'/g,"");
	                var tooltipText = (fileList[j].filePath != null && fileList[j].filePath != "") ? ConvertSystemSourcetoHtml(fileList[j].filePath) : fileNm;
	                var fileExt = getExtensionOfFilename(tooltipText).substring(1);
	                var iconFile = getIconFile(getExtensionOfFilename(tooltipText)) + ".png";
	                
	                tag += "<li class=\"clear\">";
	                tag += "<div class=\"fl\">";
	                tag += "<img src=\"/gw/Images/ico/" + iconFile + "\" alt=\"\" class=\"fl\"/>";
	                tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + fileNm + "</p>";
	                tag += "<a href=\"#n\" class=\"file_txt fl ellipsis\" title=\"\" onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'>" + fileNm + " <span id=\"\">(" + byteConvertor(parseInt(fileList[j].fileSize)) + ")</span></a>";
	                tag += "</div>";
	                tag += "<div class=\"fr\">";
	                if(downloadType != "-1"){
	                	if(downloadType == "0"){
			                tag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"D\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a>&nbsp;";
			                tag += "<span class='text_gray2'>|</span>&nbsp;";
			                tag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"V\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
	                	}else if(downloadType == "2"){	                		 
	                		 tag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
	                	}else{
	                		tag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a>";
	                	}
	                }
	                tag += "</div>";
	                tag += "</li>";
      			}      			
      			tag += "</ul></div></div>";
	            $('#detailInfo').html(tag); //기본정보 세팅	
	            fnDownEventSet();
        		
        	}else{
	        	if($("#uploaderView",parent.document)){
	        		$("#uploaderView",parent.document).hide();
	            }
	        	$("#detailInfo").hide();
	        }
        }
        else{
	        if (cnt > 0) {
	        	APPEND_FILELIST = true;
	        	
	            for(var i=0;i<fileList.length;i++)	            	
	            totalSize += parseInt(fileList[i].fileSize);
	            tag += "<table class='Addfile'>";
	            tag += "<tr id='attachFileTop'><td class='addfile_top' colspan='2' style='font-size: 11px'><img src='" + "<c:url value='/Images/ico/icon_add_file.gif' />' alt=''> <span class='bold'>" + '<%=BizboxAMessage.getMessage("TX000006498","일반첨부파일")%>' + "</span> <span class='green_bold'>" + cnt + "</span><span class='green'>" + '<%=BizboxAMessage.getMessage("TX000001633","개")%>' + "</span>&nbsp;&nbsp;" + "(" + byteConvertor(totalSize) + ")" + "<td style='text-align: right; padding-right: 15px' class='addfile_top'><input type='button' id='btnAllDown' class='btn_txt_p38' value='전체다운로드' onclick='fnDownloadAll()'/></td></td></tr>";
	            tag += "<tr class='big_tr' id='attachFileSub'><td class='addfile_bot' colspan='3'><div class='mi135'>";
	            	            
	            if("${showPath}" == "1"){
		            edriveTag += "<div id=\"\" class=\"search_downfile\">";			
		            edriveTag += "<div id=\"\" class=\"file_down_bot\">";
		            edriveTag += "<ul class=\"file_group\" style=\"width:100%;\">";
	            }
	            
	            for (var j = 0; j < fileList.length; j++) {
	                var fileId = fileList[j].fileId;
	                var fileNm = ConvertSystemSourcetoHtml(fileList[j].fileNm);
	                var fileSize = byteConvertor(fileList[j].fileSize);
	                var fileThumUrl = fileList[j].fileThumUrl.replace("/NAS_File/","/");
	                var fileUrl = fileList[j].fileUrl.replace(/\'/g,"");
	                var tooltipText = (fileList[j].filePath != null && fileList[j].filePath != "") ? ConvertSystemSourcetoHtml(fileList[j].filePath) : fileNm;
	                var fileExt = getExtensionOfFilename(tooltipText).substring(1);
	                var iconFile = getIconFile(getExtensionOfFilename(tooltipText)) + ".png";
	                var edriveFlag = checkEdrive(tooltipText);	                
	                
	                if(!edriveFlag){
	                	
	                    tag += "<div class='file_set'><div class='file_disp'>";
	                    tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + fileNm + "</p>";
	                    
	                    if(downloadType == "0"){
		                    tag += '<div class="downfile_modal" onmouseleave="fnMouseOut();" onmouseover="fnMouseIn();" id="' + fileId + '_modal">';
		                    tag += '<ul>';
				            tag += "<li><a href='#n' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"D\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>";			                    
				            tag += "<li><a href='#n' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"V\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>";
		                    tag += '</ul>';
		                    tag += '</div>';
		                    
			                //이미지 파일
			                if (fileNm.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {
			                    tag += "<div class='file_img load' onerror='fncErrorImg(this);'><img alt='' src='" + fileThumUrl + "' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'/></div></div>";
			                    //tag += "<div class='file_name' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");' style='font-family: sans-serif;'><p>" + tooltipText + "<br/>" + "(" + fileSize + ")" + "</p></div></div>";
			                } else {
			                	tag += "<div class='" + fncGetFileClass(fileNm) + "' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'></div></div>";
			                }		                    
		                    
		                    tag += "<div class='file_name' style='font-family: sans-serif;' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'><p>" + tooltipText + "<br/>" + "(" + fileSize + ")" + "</p></div></div>";
	                    }
	                    else{
	                    	tag += "<div class='" + fncGetFileClass(fileNm) + "' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'></div></div>";
		                    tag += "<div class='file_name' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");' style='font-family: sans-serif;'><p>" + tooltipText + "<br/>" + "(" + fileSize + ")" + "</p></div></div>";
	                    }	                	

		                fileCnt++;
	                }
	                else{
		                edriveTag += "<li class=\"clear\">";
		                edriveTag += "<div class=\"fl\">";
		                edriveTag += "<p style=\"display:none;\" class=\"file_name_flag\">" + fileNm + "</p>";
		                edriveTag += "<img src=\"/gw/Images/ico/" + iconFile + "\" alt=\"\" class=\"fl\"/>";
		                edriveTag += "<a href=\"#n\" class=\"file_txt fl ellipsis\" title=\"\" onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'>" + fileNm + " <span id=\"\">(" + byteConvertor(parseInt(fileList[j].fileSize)) + ")</span></a>";
		                edriveTag += "</div>";
		                edriveTag += "<div class=\"fr\">";
		                if(downloadType != "-1"){
		                	if(downloadType == "0"){
		                		edriveTag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"D\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a>&nbsp;";
		                		edriveTag += "<span class='text_gray2'>|</span>&nbsp;";
		                		edriveTag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\", \"V\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
		                	}else if(downloadType == "2"){	                		 
		                		edriveTag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
		                	}else{
		                		edriveTag += "<a href='#n' id='' class='text_blue f11' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + fileNm + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a>";
		                	}
		                }
		                edriveTag += "</div>";
		                edriveTag += "</li>";
		                edriveCnt++;
	                }
	            }
	
	            tag += "</div></td></tr></table>";
	            edriveTag += "</ul></div></div>";
	            $('#detailInfo').html(tag); //기본정보 세팅
	            if(edriveCnt > 0){
	            	$('#detailInfo2').html(edriveTag);
	            	if(fileCnt == 0){
	            		$("#attachFileSub").remove();
	            	}
	            }else{
	            	$("#detailInfo2").remove();
	            }
	            
	            fnDownEventSet();
	            
	        }else{
	        	if($("#uploaderView",parent.document)){
	        		$("#uploaderView",parent.document).hide();
	            }
	        }
        }
        
        
        if(downloadType != "0" && downloadType != "1")
        	$("#btnAllDown").hide();
        
    	var allDownLoadLimit = "<%=allDownLoadLimit%>";
    	if(allDownLoadLimit == "99"){
    		allDownLoadLimit = "30";
    	}

        if(totalSize/1024/1024 > parseInt(allDownLoadLimit)){
        	$("#btnAllDown").hide();	
        }
        
        if("${loginVO}" == null || "${loginVO}" == "null" || "${loginVO}" == "")
        	$("#btnAllDown").hide();
    }
    
    function getIconFile(fileEx){
   	
       	if(fileEx.indexOf('.') != -1){    	
       		fileEx = fileEx.split('.')[fileEx.split('.').length-1]
       	}
       	else{
       		return "ico_file";
       	}
       		
       	
           var fileClass;

           //확장자정규식
           var expBmp = /bmp/i;
           var expCsv = /csv/i;
           var expGif = /gifx/i;
           var expHwp = /hwp|hwpx/i;
           var expJpg = /jpg|jpeg/i;
           var expPdf = /pdf/i;
           var expPng = /png/i;
           var expTif = /tif/i;
           var expWord = /word/i;
           var expXls = /xls|xlsx/i;
           var expZip = /zip/i;
          

           if (expBmp.test(fileEx)) {
               fileClass = "ico_bmp";
           } else if (expCsv.test(fileEx)) {
               fileClass = "ico_csv";
           } else if (expGif.test(fileEx)) {
               fileClass = "ico_gif";
           } else if (expHwp.test(fileEx)) {
               fileClass = "ico_hwp";
           } else if (expJpg.test(fileEx)) {
               fileClass = "ico_jpg";
           } else if (expPdf.test(fileEx)) {
               fileClass = "ico_pdf";
           } else if (expPng.test(fileEx)) {
               fileClass = "ico_png";
           } else if (expTif.test(fileEx)) {
               fileClass = "ico_tif";
           } else if (expWord.test(fileEx)) {
               fileClass = "ico_word";
           } else if (expXls.test(fileEx)) {
               fileClass = "ico_xls";
           } else if (expZip.test(fileEx)) {
               fileClass = "ico_zip";
           } else {
               fileClass = "ico_file";
           }
           return fileClass;
        
    }
    
    
    function fnDownEventSet() {        
        $(".file_name").mouseover(function (e) {
            var tooltip = "<div id='tooltipevetn' class='tooltip_file' style='font-family: sans-serif;'>" + $(this).find('P').html() + "</div>";
            $("body").append(tooltip);
            $(this).css('z-index', 10000);
            $('#tooltipevetn').css('top', $(this).offset().top - 90);
            $('#tooltipevetn').css('left', $(this).offset().left);            
            $('#tooltipevetn').fadeIn('500');
            $('#tooltipevetn').fadeTo('10', 1.9);
        }).mousemove(function (e) {
            $('#tooltipevetn').show();
        }).mouseout(function (e) {
            $(this).css('z-index', 8);
            $('#tooltipevetn').remove();
        });      
    }

    function progressHandlingFunction(e) {
        if (e.lengthComputable) {
        	parent.document.getElementById("uploadStat").innerHTML = parseInt((e.loaded / e.total) * 100);
        	parent.document.getElementById("uploadStatByte").innerHTML = parseInt((e.loaded/1000)) + "/" + parseInt((e.total/1000));
        }
    }
    
    function fnSetProgress() {
        if (parent.document.getElementById("UploadProgress") != null) {
        	parent.document.getElementById('UploadProgress').style.display = 'block';  
        } else {
			var newDiv = document.createElement("div");        	
        	
            var progTag = "<div id='UploadProgress' style='position: absolute;width: 100%;background-color: red;height: 200%;z-index: 99999;top: 0;background: white;opacity: 0.8;'>";
            progTag += "<div style='padding-top: 100px;'>";
            progTag += "<div style='text-align: center;  width: 100%; height:122px;'>";
            progTag += "<p style='font-size: 20px;  font-family:initial;'>" + '<%=BizboxAMessage.getMessage("TX000016116","첨부파일 업로드중")%>' + "</p>";
	        progTag += "<p style='padding: 20px;font-size: 30px;font-family:initial;'><span id='uploadStat'>0</span>  %</p>";
	        progTag += "<p style='font-size:15px;font-family:initial;'>( <span id='uploadStatByte'>0/0</span> ) KByte</p>";
	        progTag += "<p style='padding-top: 10px;'><input id='UploadAbort' style='font-weight: 600;  width: 130px;  cursor: pointer;margin: 5px;background:#000000;color:#FFFFFF;padding:0 8px; height:30px; border-bottom:1px solid #909090;line-height:22px;' type='button' value='" + '<%=BizboxAMessage.getMessage("TX000002947","취소")%>' + "' /></p>";
            progTag += "</div>";   
            
            newDiv.innerHTML  = progTag;
            
            parent.document.getElementsByTagName("body")[0].appendChild(newDiv);
        }
    }

    function fnRemoveProgress() {
    	parent.document.getElementById('UploadProgress').style.display = 'none';
    }

    function fnAttFileUpload() {

		var	pathSeq = "0";
		var targetPathSeq = "${pathSeq}";
    	
        if (attachFile.length == 0 || UPLOAD_COMPLITE) {
            return true;
        }

        if (attachFile.length > 0) {

            var path = '<c:url value="/ajaxFileUploadProc.do" />';
            var abort = false;
            var formData = new FormData();
           
            
            for (var x = 0; x < attachFile.length; x++) {
                formData.append("file" + x, attachFile[x]);
            }
            formData.append("tempFolder", tempPath);
            formData.append("pathSeq", pathSeq);
            formData.append("groupSeq", groupSeq);     
            formData.append("targetPathSeq", targetPathSeq); 
            fnSetProgress();

            var AJAX = $.ajax({
                url: path,
                type: 'POST',
	        	timeout:600000,
                xhr: function () {
                    myXhr = $.ajaxSettings.xhr();

                    if (myXhr.upload) {
                        myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                        myXhr.abort;
                    }
                    return myXhr;
                },
                success: completeHandler = function (data) {
                    fnRemoveProgress();
					AttFile = data.attachFileNm;
					
					UPLOAD_COMPLITE = true;
					fileTotalSize += data.fileTotalSize/1024/1024;
					
					
					//콜백함수 호출
			        if (UploadCallback != "") {
			        	parent.eval(UploadCallback);
			        }
					
					
                },
                error: errorHandler = function () {

                    if (abort) {
                        alert('<%=BizboxAMessage.getMessage("TX000002483","업로드를 취소하였습니다.")%>');
                    } else {
                        alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
                    }

                    UPLOAD_COMPLITE = false;
                    AttFile = "";
                    fnRemoveProgress();
                },
                data: formData,
                cache: false,
                contentType: false,
                processData: false
            });

            parent.document.getElementById("UploadAbort").onclick = function () {
                fnRemoveProgress();
                abort = true;
                AJAX.abort();
            };
        }
        
        return false;
    }

    function fnAttFileList() {
        
        var DelFile = "";
        var DelFileKey = "";
        var DelFileSn = "";
        
        var tblParam = {};

        //삭제리스트
        $.each($("input[name*='del_product']"), function (i, t) {
        	DelFileKey += "|" + t.value.split('|')[0];
            DelFile += "|" + t.value.split('|')[1];            
            DelFileSn += "|" + t.value.split('|')[2];
        });
        
		tblParam.tempfolder = tempPath;
		
		if(fileKey != "" && fileNms != ""){
			tblParam.attachfilelist = fileNms + AttFile;
		}else{
			tblParam.attachfilelist = AttFile;
		}
				
		if(tblParam.attachfilelist != "" && tblParam.attachfilelist.substr(tblParam.attachfilelist.length - 1) == "|"){
			tblParam.attachfilelist = tblParam.attachfilelist.substr(0, tblParam.attachfilelist.length - 1);
		}
		
		console.log("AttFile > " + AttFile);
		
		//클라이언트 첨부파일 경로
		if(showPath == "Y" && tblParam.attachfilelist != ""){
			tblParam.attachpathlist = "";
			
			$.each(AttFile.split("|"), function( key, value ) {
				if(value != ""){
					var result = attachFile.filter(function(val){return val.name == value});
					
					if(result.length > 0){
						var clientPath = (result[0].filePath + "|");
						
						if(pathSeq != "100" && pathSeq != "200"){
							clientPath = clientPath.replace(/\\/g,"\\\\");
							tblParam.attachpathlist += clientPath;
						}
					}else{
						tblParam.attachpathlist += value + "|";
					}					
				}
			});
			
			tblParam.attachpathlist = fileNms + tblParam.attachpathlist;
			
			if(tblParam.attachpathlist != "" && tblParam.attachpathlist.substr(tblParam.attachpathlist.length - 1) == "|"){
				tblParam.attachpathlist = tblParam.attachpathlist.substr(0, tblParam.attachpathlist.length - 1);
			}
			
		}else{
			tblParam.attachpathlist = tblParam.attachfilelist;
		}		
        
        if(DelFile.length > 0){
        	tblParam.deletefilelist = DelFile.substring(1);
        	tblParam.deletekeylist = DelFileKey.substring(1);
        	tblParam.deletesnlist = DelFileSn.substring(1);
        } else{
        	tblParam.deletefilelist = DelFile;
        	tblParam.deletekeylist = DelFileKey;
        	tblParam.deletesnlist = DelFileSn
        }
        
        return tblParam;
    }

    function delFileAttach(id, fileId, fileNm, fileSn, fileSize) { //파일삭제
		fileNm = ConvertSystemSourcetoHtml(fileNm);
        $('.' + id).remove();
        var tag = "";
        tag += "<input id='delSeq' name='del_product' type='hidden' value=\"" + fileId + "|" + fileNm + "|" + fileSn +"\"/>";
        $('#productList').append(tag);
        
        
        if(displayMode != "L"){
	        if($(".file_info").length == 0){
	        	$("#fileAddDrop").show();
	        }
        }
        attTotalSize = parseInt(attTotalSize) - parseInt(fileSize);
        fileTotalSize -= parseInt(fileSize)/1024/1024;
        delFileCnt++;
    }

    //이미지파일에러처리
    function fncErrorImg(obj) {
        $(obj).parent().removeClass("tall wide").addClass("load");
        obj.src = "<c:url value='/Images/ico/icon_file_24.png'/>";
    }
    
    function specialCharRemove(value) {
        var pattern = /[^(가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9)]/gi;   // 특수문자 제거
        return value.replace(pattern, "").replace(/\(/gi,"bk_l").replace(/\)/gi,"bk_r");
    }
    
    function getUploadFileCnt(){
   	 	return (checkLimitCnt-delFileCnt);    	 
    }
    
    function handleFileSelect(evt) { //파일첨부 드래그앤드랍 썸네일
    	
        evt.stopPropagation();
        evt.preventDefault();
        
        var clientPath = "";
        
    	if(showPath == "Y"){
    		//Drag불가
    		if(attachMode == "drag"){
    			alert("<%=BizboxAMessage.getMessage("TX900000585","E드라이브 연동으로 파일 드레그가 불가합니다.")%>");
    		    setTimeout("fileUpload.click();" , 10); 
    			return;
    		}else{
    			//클라이언트 첨부파일 경로
    			clientPath = uploadFile.value;

				if(clientPath.indexOf("C:\\fakepath") > -1){
					alert("E드라이브 연동으로 브라우져 설정변경이 필요합니다.\r\n#. 도구 > 인터넷옵션 > 보안 > 사용자지정수준\r\n> 파일을 서버에 업로드할 때 로컬 디렉터리 경로 포함(사용)")
					return;
				}
    		}
    	}else if(showPath == "N"){
    		alert("<%=BizboxAMessage.getMessage("TX900000578","E드라이브 연동으로 파일첨부는 IE브라우져만 지원합니다.")%>");
    		return;
    	}

        if (attachMode == "click") { //파일첨부 클릭
            var files = evt.target.files;
            attachMode = "";
        } else if (attachMode == "drag") { //파일첨부 드래그
            var files = evt.dataTransfer.files; // FileList object.
            attachMode = "";
        } else {
            return;
        }
        
        
        checkLimitCnt = files.length + attachFile.length;
        
        if(Bindinglist != null)        	
        	checkLimitCnt = checkLimitCnt + Bindinglist.length;
        
        var overlabCheck = true;
        
        for (var i = 0, f; f = files[i]; i++) {

            
            if(overlabCheck){
	            //클라이언트 파일경로 세팅
	            if(showPath == "Y" && clientPath != ""){
	            	var idx = clientPath.indexOf("\\" + f.name) + f.name.length + 1;
	            	f.filePath = clientPath.substr(0,idx);
	            	clientPath = clientPath.substr(idx + 2);
	            }else{
	            	f.filePath = f.name;
	            }
	
	            if(limitFileCount != "" && limitFileCount < checkLimitCnt-delFileCnt){
	            	alert("<%=BizboxAMessage.getMessage("TX900000582","업로드 제한 파일 갯수를 초과하였습니다.\\n(설정 갯수 :")%>" + limitFileCount + "개)");
	            	overlabCheck = false;
	            }
	            
	            if(overlabCheck){
	            	if(f.name.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length > 255){
	            		alert("<%=BizboxAMessage.getMessage("TX900000588","업로드 파일명은 255바이트 이하만 가능합니다.\\n파일명 변경 후 다시 시도해 주세요.")%>");
	            		overlabCheck = false;	
	            	}
	            	
	            }	            
	            
	            if(overlabCheck){
		        	if(availCapac != "" && f.size > availCapac){
		        		alert("<%=BizboxAMessage.getMessage("TX900000577","업로드 개당 제한 용량을 초과하였습니다.\\n(설정용량:")%>" + availCapac/1024/1024 +"MB)");
		        		
		        		overlabCheck = false;
		        	}else{
		        		attTotalSize += parseInt(f.size); 
		        	}
	            }
	        	
	            if(overlabCheck){
		            if(totalCapac != "" && parseInt(totalCapac) < attTotalSize){
		            	attTotalSize -= parseInt(f.size); 
		            	alert("<%=BizboxAMessage.getMessage("TX900000577","업로드 전체용량을 초과하였습니다.\\n(설정용량:")%>" + totalCapac/1024/1024 +"MB)");
		        		overlabCheck = false;
		            }
	            }
	            
	            if(overlabCheck){
		            for (var j = 0; j < attachFile.length; j++) {
		                if (f.name == attachFile[j].name) {
		                    alert("<%=BizboxAMessage.getMessage("TX000007512","같은파일이 이미 첨부되었습니다.")%>" + "\r\n" + f.name);
		                    overlabCheck = false;
		                }
		            }
	            }
	            
	            if(overlabCheck && buildType == "cloud"){
	            	var gwVolume = "${gwVolumeInfo.gwVolume}";
	            	var totalFileSize = "${gwVolumeInfo.totalFileSize}";
	            	
	            	if((attTotalSize/1024/1024/1024) + totalFileSize > gwVolume){
	            		alert("<%=BizboxAMessage.getMessage("TX900000586","용량이 부족하여 첨부파일 업로드가 불가합니다.")%>" + "\r\n" + "<%=BizboxAMessage.getMessage("TX900000306","관리자에게 문의하세요.")%>" + " " + "<%=BizboxAMessage.getMessage("TX900000587","[잔여용량 : 0GB]")%>");
	                    overlabCheck = false;
	            	}
	            }
	            
	            
	            //업로드 제한 확장자 체크
	            if(overlabCheck){
	            	var extsn = getExtensionOfFilename(f.name);
	        		if(allowExtention != "" && allowExtention.indexOf(extsn.substring(1)) == -1){
	        			overlabCheck = false;
	        			alert("<%=BizboxAMessage.getMessage("TX900000590","업로드 가능한 확장자가 아닙니다.\\n업로드 가능 확장자:")%>" + allowExtention);
	        		}else if(extsn == -1){
	        			overlabCheck = false;
	        			alert("<%=BizboxAMessage.getMessage("TX900000589","확장자가 없는 파일은 첨부할 수 없습니다.")%>");
	        		}
	            }
	
	            if (overlabCheck) {
	            	if(displayMode == "L"){
	            		$("#fileAddDrop").hide();
		                attachFile.push(f);
		                var tag = '';
		                tag += "<li class=\"clear\" id=\"addFile" + cntFile + "li\">";
		                tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + ConvertSystemSourcetoHtml(f.name) + "</p>";
		                tag += "<img src=\"/gw/Images/ico/ico_file.png\" alt=\"\" class=\"fl\" style=\"margin-right:2px;\"/>";
		                tag += "<a href=\"#n\" class=\"file_txt fl ellipsis\" title=\"\">" + ConvertSystemSourcetoHtml(f.name) + "<span id=\"\">(185.26KB)</span></a>";
		                tag += "<a href=\"#n\" class=\"file_x_btn fl\" title=\"\"><img id=\"addFile" + cntFile + "\" fileSize=\"" + f.size + "\" src=\"/gw/Images/btn/close_btn01.png\" alt=\"\" onclick=\'delFile(this, this.id,\"" + ConvertSystemSourcetoHtml(f.name) + "\");\' /></a>";
		                tag += "</li>";
		                
		                $("#fileGroup").append(tag);
		                cntFile++;
	            	}            	
	            	else{
		            	$("#fileAddDrop").hide();
		                attachFile.push(f);
		                var tag = '';
		                if (f.name.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {
		                    tag += "<li id=\"addFile" + cntFile + "li\">";
		                    tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + ConvertSystemSourcetoHtml(f.name) + "</p>";
		                    tag += "<input type=\"hidden\" name=\"addFile\" value=\"" + ConvertSystemSourcetoHtml(f.name) + "\"/>";
		                    tag += "<div class=\"file_info\"><div class=\"img_align\">";
		                    tag += "<img id=\"" + specialCharRemove(f.name) + "\" src=\"\"></div></div>";
		                    tag += "<div class=\"file_name_box\"><p class=\"file_name\">" + ConvertSystemSourcetoHtml(f.filePath) + "</p></div>";
		                    tag += "<div id=\"addFile" + cntFile + "\" fileSize=\"" + f.size + "\" onclick=\'delFile(this, this.id,\"" + ConvertSystemSourcetoHtml(f.name) + "\");\' class=\"file_delete\"></div></li>";
		
		                } else {
		                    tag += "<li id=\"addFile" + cntFile + "li\">";
		                    tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + ConvertSystemSourcetoHtml(f.name) + "</p>";
		                    tag += "<input type=\"hidden\" name=\"addFile\" value=\"" + ConvertSystemSourcetoHtml(f.name) + "\"/>";
		                    tag += "<div class=\"file_info\"><div class=\"file_align\">";
		                    tag += "<div class='" + fncGetFileClass(f.name) + "'></div></div></div>";
		                    tag += "<div class=\"file_name_box\"><p class=\"file_name\">" + ConvertSystemSourcetoHtml(f.filePath) + "</p></div>";
		                    tag += "<div id=\"addFile" + cntFile + "\" fileSize=\"" + f.size + "\" onclick=\'delFile(this, this.id,\"" + ConvertSystemSourcetoHtml(f.name) + "\");\' class=\"file_delete\"></div></li>";
		                }
		
		                $("#fileGroup").append(tag);
		                cntFile++;
	            	}
	          	}
            }
        }

        for (var i = 0, f; f = files[i]; i++) {

            if (f.name.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {

                var reader = new FileReader();
                reader.onload = (function (theFile) {
                    return function (e) {
                        $("#" + specialCharRemove(theFile.name)).attr("src", e.target.result);
                    };
                })(f);
                reader.readAsDataURL(f);
            }
        }

        fnEventSet();
    }
    
    function getQueryVariable(fileUrl, strPara) {
        var params = {};
        fileUrl.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(str, key, value) { params[key] = value; });
        return params[strPara];
     }     
 
    //저장
    function fnDownAndSave(event, fileUrl, fileNm, fileId) {
    	var activeYn = "${activxYn}";
    	
    	if(downloadType == "-1"){
    		return;
    	}
    	
    	if(activeYn == "N" || activeYn == ""){
    		//파일다운
    		if(downloadType == "1" || downloadType == "0"){
    			fnDirectDownload(fileUrl, fileNm, fileId);
    		}
    		//문서뷰어
    		else if(downloadType == "2"){
    			var extsn = getExtensionOfFilename(fileNm);
    			
    			if(extsn == ".pdf"){
    				fnInlinePdfView(fileUrl, fileNm, fileId);
    				return;
    			}
    			
    			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
    			var checkExtsnInline = ".jpeg.bmp.gif.jpg.png";
    			if(checkExtsnInline.indexOf(extsn) != -1){
    				fnInlineView(fileUrl, fileNm, fileId);
    			}else if(checkExtsn.indexOf(extsn) != -1){
    				fnDocViewerPop(fileUrl, fileNm, fileId);
    			}else{
    				alert("<%=BizboxAMessage.getMessage("TX900000591","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자:pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
    				return;
    			}
    		}
    	}
    	else{
    		if(fileUrl.toUpperCase().indexOf('http') < 0){
    			fileUrl = window.location.protocol + "//" + location.host + fileUrl;
    		}
    		
    		goForm(fileUrl, '${loginId}', fileNm);
    	}
    }
    
    
    
  //저장
    function fnDownLoad(event, fileUrl, fileNm, fileId, type) {
    	var activeYn = "${activxYn}";
    	
    	if(downloadType == "-1"){
    		return;
    	}    	
    	
    	if(activeYn == "N" || activeYn == ""){
    		//파일다운
    		if(type == "D"){
    			fnDirectDownload(fileUrl, fileNm, fileId);
    		}
    		//문서뷰어
    		else if(type == "V"){
    			var extsn = getExtensionOfFilename(fileNm);
    			
    			if(extsn == ".pdf"){
    				fnInlinePdfView(fileUrl, fileNm, fileId);
    				return;
    			}    			
    			
    			var checkExtsn = ".hwp.hwpx.doc.docx.ppt.pptx.xls.xlsx";
    			var checkExtsnInline = ".jpeg.bmp.gif.jpg.png";
    			if(checkExtsnInline.indexOf(extsn) != -1){
    				fnInlineView(fileUrl, fileNm, fileId);
    			}else if(checkExtsn.indexOf(extsn) != -1){
    				fnDocViewerPop(fileUrl, fileNm, fileId);
    			}else{
    				alert("<%=BizboxAMessage.getMessage("TX900000575","해당 파일은 지원되지 않는 형식입니다.\\n[제공 확장자 : 이미지, pdf, hwp, hwpx, doc, docx, ppt, pptx, xls, xlsx]")%>");
    				return;
    			}
    		}
    	}
    	else{
    		if(fileUrl.toUpperCase().indexOf('http') < 0){
    			fileUrl = window.location.protocol + "//" + location.host + fileUrl;
    		}
    		
    		goForm(fileUrl, '${loginId}', fileNm);
    	}
    }
    
  
  function fnDirectDownload(fileUrl, fileNm, fileId){
	  	var fileSn = "";
  		var moduleTp = "";
  		
  		if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
	    	fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
    	}
    	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
    		fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
    	}
    	
    	//게시판 url예외처리
    	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
    		
      		//비세션일 경우 공통다운로드 경로 제공 불가(외부계정용)
      		if("${loginVO.groupSeq}" == ""){
      	  		this.location.href = fileUrl;
      	        return false;  			
      		}
    		
    		moduleTp = "board";
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
    		moduleTp = "doc";
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
    		moduleTp = "bpm";
    	}
  		
  		//그외는 gw다운로드로 통일
  		else{
  			fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
  		}
  		
  		this.location.href = "/gw/cmm/file/fileDownloadProc.do?fileId=" + fileId + "&fileSn=" + fileSn + "&moduleTp=" + moduleTp + "&pathSeq=${pathSeq}";
        return false;
  }
  
  
  
  function fnInlinePdfView(fileUrl, fileNm, fileId){
	  	var fileSn = "";
		var moduleTp = "";
		
		if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
	    	fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
	  	}
	  	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
	  		fileId = getQueryVariable(fileUrl, 'fileId');
		    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
		    	moduleTp = "gw";
				if(fileSn == "" || fileSn == null)
					fileSn = "0";
	  	}
  	
	  	//게시판 url예외처리
	  	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
	  		moduleTp = "board";
	  	}
	  	
	  	//문서 url예외처리
	  	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
	  		moduleTp = "doc";
	  	}
	  	
	  	//문서 url예외처리
	  	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
	  		moduleTp = "bpm";
	  	}
		
		//그외는 gw다운로드로 통일
		else{
			fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
		}
		var timestamp = new Date().getTime();
		var pdfUrl = location.protocol.concat("//").concat(location.host) + "/gw/cmm/file/fileDownloadProc.do?inlineView=Y&fileId=" + fileId + "&fileSn=" + fileSn + "&moduleTp=" + moduleTp + "&pathSeq=${pathSeq}";
		window.open(pdfUrl, "inlineViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
		//var inlinePdfViewerPop = window.open("", "inlinePdfViewerPop", "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
		//inlinePdfViewerPop.document.title = fileNm;
		//inlinePdfViewerPop.document.body.innerHTML = "<head><title>"+fileNm+"</title></head><object type='application/pdf' data='"+pdfUrl+"' width='100%' height='97%' style='width:100%;height:97%;' border='0' internalinstanceid='28'><param name='src' value='"+pdfUrl+"'><%=BizboxAMessage.getMessage("TX000005488","PDF문서를 보시려면 Acrobat Reader를 설치하셔야 합니다.")%></object>";
  }
  
  function fnInlineView(fileUrl, fileNm, fileId){
	  	var fileSn = "";
		var moduleTp = "";
		
		if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
	    	fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
	  	}
	  	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
	  		fileId = getQueryVariable(fileUrl, 'fileId');
		    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
		    	moduleTp = "gw";
				if(fileSn == "" || fileSn == null)
					fileSn = "0";
	  	}
  	
	  	//게시판 url예외처리
	  	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
	  		moduleTp = "board";
	  	}
	  	
	  	//문서 url예외처리
	  	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
	  		moduleTp = "doc";
	  	}
	  	
	  	//문서 url예외처리
	  	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
	  		moduleTp = "bpm";
	  	}
		
		//그외는 gw다운로드로 통일
		else{
			fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
		}
		
		var timestamp = new Date().getTime();
		window.open("/gw/cmm/file/fileDownloadProc.do?fileId=" + fileId + "&fileSn=" + fileSn + "&moduleTp=" + moduleTp + "&pathSeq=${pathSeq}&inlineView=Y", "inlineViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=yes,menubar=no");
}  
    
    function fnDocViewerPop(fileUrl, fileNm, fileId){
    	var fileSn = "";
    	var moduleTp = "";
    	
    	if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1){    	
	    	fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
    	}
    	else if(fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){
    		fileId = getQueryVariable(fileUrl, 'fileId');
	    	fileSn = getQueryVariable(fileUrl, 'fileSn');	    	
	    	moduleTp = "gw";
			if(fileSn == "" || fileSn == null)
				fileSn = "0";
    	}
    	
    	//게시판 url예외처리
    	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
    		moduleTp = "board";
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
    		moduleTp = "doc";
    	}
    	
    	//문서 url예외처리
    	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
    		moduleTp = "bpm";
    	}
    	
		fnDocViewer(fileId, fileSn, moduleTp);
    }
    
    function fnDocViewer(fileId, fileSn, moduleTp){
    	var timestamp = new Date().getTime();
     	var docViewrPopForm = document.docViewrPopForm;
     	window.open("", "docViewerPop" + timestamp, "width=1000,height=800,history=no,resizable=yes,status=no,scrollbars=no,menubar=no");
     	docViewrPopForm.target = "docViewerPop" + timestamp ;
     	docViewrPopForm.groupSeq.value = groupSeq;
     	docViewrPopForm.fileId.value = fileId;
     	docViewrPopForm.fileSn.value = fileSn;
     	docViewrPopForm.moduleTp.value = moduleTp;
     	docViewrPopForm.submit();    	
    }
    
    var PimonAXObj;
	
    function goForm(url, loginId, fileNm){
    	
    	if(loginId == null || loginId == ""){
    		alert("<%=BizboxAMessage.getMessage("TX000017930","파일 다운로드 권한이 없습니다.")%>");
    	}else{
    		try{
    			if(PimonAXObj == null)
    			PimonAXObj = PimonAX.ElevatePimonX();
    			
    			PimonAXObj.FileDownLoad(url, loginId, fileNm, '${pageContext.session.id}'); // 다운로드파일경로, UserID	
    		}catch(e){
    			if(e.number != -2147023673)
    			alert("<%=BizboxAMessage.getMessage("TX000017931","파일 다운로드는 IE브라우져에서만 가능합니다.")%>");	
    		}
    	}
	}
    
    function fnAttFileListBinding(fileList) {
    	if(fileList == null)
    		return;
    	
    	Bindinglist = fileList;
        $("#fileGroup").html("");
        $("#productList").html("");
        cntFile = 0;
        attachFile = [];		
        checkLimitCnt = fileList.length;
        if (fileList != null && fileList.length > 0) {        	
        		
        	APPEND_FILELIST = true;
        	
            var tag = '';
            $("#fileAddDrop").hide();
            
            for (var i = 0; i < fileList.length; i++) {

                var fileId = fileList[i].fileId;
                var orignlFileName = ConvertSystemSourcetoHtml(fileList[i].fileNm);
                var fileThumUrl = fileList[i].fileThumUrl.replace("/NAS_File/","/");
                var fileUrl = fileList[i].fileUrl.replace(/\'/g,"");
                var fileSn = "";
                var fileSize = 0;
                var tooltipText = (fileList[i].filePath != null && fileList[i].filePath != "") ? ConvertSystemSourcetoHtml(fileList[i].filePath) : orignlFileName;
                var fileExt = getExtensionOfFilename(tooltipText).substring(1);
                var iconFile = getIconFile(getExtensionOfFilename(tooltipText)) + ".png";
                                
                if(fileList[i].fileSn != null && fileList[i].fileSn != "")
                	fileSn = fileList[i].fileSn;
                
                if(fileList[i].fileSize != null && fileList[i].fileSize != "" ){
                	fileSize = parseInt(fileList[i].fileSize);
            		attTotalSize += parseInt(fileList[i].fileSize);
            		fileTotalSize += parseInt(fileList[i].fileSize)/1024/1024;
            	}

                if(displayMode == "L"){   
                	tag += "<li class=\"clear " + i + "\" >";
                	tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + orignlFileName + "</p>";
                	tag += "<div class=\"fl\" style=\"width:600px;'\">";
                	tag += "<img src=\"/gw/Images/ico/" + iconFile + "\" alt=\"\" class=\"fl\" />";
                	tag += "<a href=\"#n\" class=\"file_txt fl ellipsis\" title=\"\" onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");'>&nbsp;" + orignlFileName + "<span id=\"\"></span></a>";
                	tag += "<a href=\"#n\" class=\"file_x_btn fl\" title=\"\"><img id=\"" + i + "\" src=\"/gw/Images/btn/close_btn01.png\" alt=\"\" onclick=\'delFileAttach(this.id, \"" + fileId + "\", \"" + orignlFileName + "\", \"" + fileSn + "\", \"" + fileSize + "\");\' /></a>";                	
                	tag += "</div>";
                	tag += "<div class=\"fr\">";
                	if(downloadType != "-1"){
                		if(downloadType == "0"){
		                	tag += "<a href=\"#n\" id=\"\" class=\"text_blue f11\" onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\", \"D\");'><%=BizboxAMessage.getMessage("TX000022068","PC저장")%></a>&nbsp;";
		                	tag += "<span class=\"text_gray2\">|</span>&nbsp;";
		                	tag += "<a href=\"#n\" id=\"\" class=\"text_blue f11\" onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\", \"V\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
                		}else if(downloadType == "2"){	                		 
                			tag += "<a href=\"#n\" id=\"\" class=\"text_blue f11\" onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a>";
	                	}else{
	                		tag += "<a href=\"#n\" id=\"\" class=\"text_blue f11\" onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");'><%=BizboxAMessage.getMessage("TX000022068","PC저장")%></a>";
	                	}
                	}
                	tag += "</div>";
                	tag += "</li>";
                }
                
                else{                
	                if (orignlFileName.match(/[^=(\"|\')]*(jpg|gif|jpeg|png)/i)) {
	                    tag += "<li class='" + i + "'>";
	                    tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + orignlFileName + "</p>";
	                    tag += "<div class=\"file_info\"><div class=\"img_align load\">";
	                    tag += "<img onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");' src='" + fileThumUrl + "' onerror='fncErrorImg(this);'></div></div>";
	                    tag += "<div onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");' class=\"file_name_box\" style='font-family: sans-serif;'><p>" + tooltipText + "</p></div>";
	                    tag += "<div id='" + i + "' onclick=\'delFileAttach(this.id, \"" + fileId + "\", \"" + orignlFileName + "\", \"" + fileSn + "\", \"" + fileSize + "\");\' class=\"file_delete\"></div></li>";
	                } else {
	                    tag += "<li class='" + i + "'>";
	                    tag += "<p style=\"display:none;\" class=\"file_name_flag\">" + orignlFileName + "</p>";
	                    tag += "<div class=\"file_info\"><div class=\"file_align\">";
	                    
	                    
	                    if(downloadType == "0"){
	                    	tag += '<div class="downfile_modal" onmouseleave="fnMouseOut();" onmouseover="fnMouseIn();">';
		                    tag += '<ul>';
				            tag += "<li><a href='#n' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\", \"D\");'><%=BizboxAMessage.getMessage("TX000006624","PC저장")%></a></li>";			                    
				            tag += "<li><a href='#n' onclick='javascript:fnDownLoad(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\", \"V\");'><%=BizboxAMessage.getMessage("TX000022069","뷰어열기")%></a></li>";
		                    tag += '</ul>';
		                    tag += '</div>';
		                    tag += "<div class='" + fncGetFileClass(orignlFileName) + "' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");'></div></div></div>";
		                    tag += "<div class=\"file_name_box\" style='font-family: sans-serif;' onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");'><p>" + tooltipText + "</p></div>";
		                    tag += "<div id='" + i + "' onclick=\'delFileAttach(this.id, \"" + fileId + "\", \"" + orignlFileName + "\", \"" + fileSn + "\", \"" + fileSize + "\");\' class=\"file_delete\"></div></li>";
	                    }else{
		                    tag += "<div onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");' class='" + fncGetFileClass(orignlFileName) + "'></div></div></div>";
		                    tag += "<div onclick='javascript:fnDownAndSave(event, \"" + fileUrl + "\", \"" + orignlFileName + "\", \"" + fileId + "\");' class=\"file_name_box\" style='font-family: sans-serif;'><p>" + tooltipText + "</p></div>";
		                    tag += "<div id='" + i + "' onclick=\'delFileAttach(this.id, \"" + fileId + "\", \"" + orignlFileName + "\", \"" + fileSn + "\", \"" + fileSize + "\");\' class=\"file_delete\"></div></li>";
	                    }
	                }
                }
            }
            $("#fileGroup").append(tag);

            fnEventSet();
        }
    }

    function fnEventSet() {
        $(".file_name_box").mouseover(function (e) {
            var tooltip = "<div id='tooltipevetn' class='tooltip_file' style='font-family: sans-serif;'>" + $(this).find('P').html() + "</div>";
            $("body").append(tooltip);
            $(this).css('z-index', 10000);
            $('#tooltipevetn').css('top', $(this).offset().top - 80);
            $('#tooltipevetn').css('left', $(this).offset().left);            
            $('#tooltipevetn').fadeIn('500');
            $('#tooltipevetn').fadeTo('10', 1.9);
        }).mousemove(function (e) {
            $('#tooltipevetn').show();
        }).mouseout(function (e) {
            $(this).css('z-index', 8);
            $('#tooltipevetn').remove();
        });      
        
        UPLOAD_COMPLITE = false;
    }

    function handleDragOver(evt) { //파일첨부 드래그앤드랍
        attachMode = "drag";
        evt.stopPropagation();
        evt.preventDefault();
        evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
    }

    function delFile(target, id, name) { //파일삭제
        $('#uploadFile').val("");
        var attachTemp = [];

        for (i = 0; i < attachFile.length; i++) {
            if (name != attachFile[i].name) {
                attachTemp.push(attachFile[i]);
            }
        }
        
        attachFile = attachTemp;

        $('#' + id + 'li').remove();
        
        if($(".file_info").length == 0){
        	$("#fileAddDrop").show();
        }
        
        checkLimitCnt--;
        attTotalSize -= parseInt($(target).attr("fileSize")); 
    }
    
    function delAutoFile(id, name) { //자동첨부파일삭제
        $('#uploadFile').val("");
    
        fileNms = fileNms.replace(name + "|","");

        $('#' + id + 'li').remove();
        
        if($(".file_info").length == 0){
        	$("#fileAddDrop").show();
        }
    }    

    //파일클래스
    function fncGetFileClass(fileEx) {
    	
    	if(fileEx.indexOf('.') != -1){    	
    		fileEx = fileEx.split('.')[fileEx.split('.').length-1]
    	}
    	else{
    		return "file_etc";
    	}
    		
    	
        var fileClass;

        //확장자정규식
        var expHwp = /hwp|hwpx/i;
        var expZip = /zip/i;
        var expDoc = /doc|docx/i;
        var expPpt = /ppt|pptx/i;
        var expMp4 = /mp4/i;
        var expWav = /wav/i;
        var expWma = /wma/i;
        var expTif = /tif/i;
        var expGul = /gul/i;
        var expAi = /ai/i;
        var expPsd = /psd/i;
        var expHtm = /htm|html/i;
        var expFlv = /flv/i;
        var expMpg = /mpg/i;
        var expMpeg = /mpeg/i;
        var expAsf = /asf/i;
        var expMov = /mov/i;
        var expWmv = /wmv/i;
        var expPdf = /pdf/i;
        var expTxt = /txt/i;
        var expMp3 = /mp3/i;
        var expAvi = /avi/i;
        var expXls = /xls|xlsx/i;

        if (expHwp.test(fileEx)) {
            fileClass = "file_hwp";
        } else if (expZip.test(fileEx)) {
            fileClass = "file_zip";
        } else if (expDoc.test(fileEx)) {
            fileClass = "file_doc";
        } else if (expPpt.test(fileEx)) {
            fileClass = "file_ppt";
        } else if (expMp4.test(fileEx)) {
            fileClass = "file_mp4";
        } else if (expWav.test(fileEx)) {
            fileClass = "file_wav";
        } else if (expWma.test(fileEx)) {
            fileClass = "file_wma";
        } else if (expTif.test(fileEx)) {
            fileClass = "file_tif";
        } else if (expGul.test(fileEx)) {
            fileClass = "file_gul";
        } else if (expAi.test(fileEx)) {
            fileClass = "file_ai";
        } else if (expPsd.test(fileEx)) {
            fileClass = "file_psd";
        } else if (expHtm.test(fileEx)) {
            fileClass = "file_htm";
        } else if (expFlv.test(fileEx)) {
            fileClass = "file_flv";
        } else if (expMpg.test(fileEx)) {
            fileClass = "file_mpg";
        } else if (expMpeg.test(fileEx)) {
            fileClass = "file_mpeg";
        } else if (expAsf.test(fileEx)) {
            fileClass = "file_asf";
        } else if (expMov.test(fileEx)) {
            fileClass = "file_mov";
        } else if (expWmv.test(fileEx)) {
            fileClass = "file_wmv";
        } else if (expPdf.test(fileEx)) {
            fileClass = "file_pdf";
        } else if (expTxt.test(fileEx)) {
            fileClass = "file_txt";
        } else if (expAvi.test(fileEx)) {
            fileClass = "file_avi";
        } else if (expXls.test(fileEx)) {
            fileClass = "file_xls";
        } else {
            fileClass = "file_etc";
        }
        return fileClass;
    }

    function RndStr() {
        this.str = '';
        this.pattern = /^[a-zA-Z0-9]+$/;

        this.setStr = function (n) {
            if (!/^[0-9]+$/.test(n)) n = 0x10;
            this.str = '';
            for (var i = 0; i < n - 1; i++) {
                this.rndchar();
            }
        }

        this.setType = function (s) {
            switch (s) {
                case '1': this.pattern = /^[0-9]+$/; break;
                case 'A': this.pattern = /^[A-Z]+$/; break;
                case 'a': this.pattern = /^[a-z]+$/; break;
                case 'A1': this.pattern = /^[A-Z0-9]+$/; break;
                case 'a1': this.pattern = /^[a-z0-9]+$/; break;
                default: this.pattern = /^[a-zA-Z0-9]+$/;
            }
        }

        this.getStr = function () {
            return this.str;
        }

        this.rndchar = function () {
            var rnd = Math.round(Math.random() * 1000);

            if (!this.pattern.test(String.fromCharCode(rnd))) {
                this.rndchar();
            } else {
                this.str += String.fromCharCode(rnd);
            }
        }
    }
    
    function getExtensionOfFilename(filename) { 
    	var _fileLen = filename.length; 
    	var _lastDot = filename.lastIndexOf('.'); 
    	// 확장자 명만 추출한 후 소문자로 변경
    	var _fileExt = filename.substring(_lastDot, _fileLen).toLowerCase(); 
    	
    	// 확장자 없는 파일 업로드 제한
    	if(_lastDot == -1){
    		return -1;
		}
    	
    	return _fileExt; 
   	} 

    function fnMouseOut(e){
//     	$(".downfile_sel_pop").hide();
		$(this).css("display", "none");
    }
    function fnMouseIn(e){
		$(this).css("display", "");
    }
    
    
    function checkEdrive(path){
    	if(path.indexOf(":\\") != -1 || path.indexOf(":/") != -1){    		
    		if((path.charCodeAt(0) >= 112 && path.charCodeAt(0) <= 122) || (path.charCodeAt(0) >= 80 && path.charCodeAt(0) <= 90)){
    			if("${showPath}" == "1")
					return true;
    			else
    				false;
    		}
    		else
    			return false;
    	}else{
    		return false;
    	}
    }
    
    
    function getFileNmList(){
    	var fileNmList = "";
    	$(".file_name_flag").each(function(){
    		fileNmList += "|" + $(this).text();
    	});
    	
    	if(fileNmList.length > 0 ){
    		fileNmList = fileNmList.substring(1);
    	}
    	
    	return fileNmList;
    }
    
    function fnDownloadAll(){
    	//downloadAllFileList
    	if(downloadAllFileList.length > 0){
    		var fileIdList = "";
    		var fileSnList = "";
    		var moduleTp = "";
    		for(var i=0;i<downloadAllFileList.length;i++){
    			var fileUrl = downloadAllFileList[i].fileUrl;    			
    			
    			
    			var fileSn = "";
    			
    			fileIdList += "|" + downloadAllFileList[i].fileId;    			
    			
    			if(fileUrl.indexOf("gw/cmm/file/fileDownloadProc.do") != -1 || fileUrl.indexOf("ea/edoc/eapproval/workflow/EDocAttachFileDownload.do") != -1){    	
    				moduleTp += "|gw";
    				fileSn = getQueryVariable(fileUrl, 'fileSn');
    				if(fileSn == "" || fileSn == null)
    					fileSnList += "|0";
    				else
    					fileSnList += "|" + fileSn;
    	    	}    	    	 	    	
    	    	//게시판 url예외처리
    	    	else if(fileUrl.indexOf("edms/board/downloadFile.do") != -1){
    	    		moduleTp += "|board";
    	    		fileSnList += "|0";
    	    	}
    	    	
    	    	//문서 url예외처리
    	    	else if(fileUrl.indexOf("edms/doc/downloadFile.do") != -1){
    	    		moduleTp += "|doc";
    	    		fileSnList += "|0";
    	    	}
    					
    	    	//결재문서 url예외처리
    	    	else if(fileUrl.indexOf("edms/doc/downloadBpmFile.do") != -1){
    	    		moduleTp += "|bpm";
    	    		fileSnList += "|0";
    	    	}    			
    			
    		}
    		
    		var tblParam = {};
    		tblParam.fileIdList = fileIdList.substring(1);
    		tblParam.fileSnList = fileSnList.substring(1);
    		tblParam.moduleTp = moduleTp.substring(1);
    			
    		$.ajax({
    	     	type:"post",
    	 		url:'<c:url value="/ajaxAllFileDownloadProc.do" />',
    	 		datatype:"text",
    	 		data: tblParam,
    	 		success: function (data) {
    	 			
    	 			if(data.resultCode == "SUCCESS"){
    	 				window.location.href = "./ajaxAllFileDownload.do";
    	 			}else{
    	 				alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
    	 			}
    	 			
    			},
    			error: function (result) {
    				alert('<%=BizboxAMessage.getMessage("TX000002180","첨부파일 처리중 장애가 발생되었습니다. 다시 시도하여 주십시오")%>');
    	 		}
    	 	});
    	}
    }
</script> 
<c:if test="${activxYn == 'Y'}">
	<OBJECT id="PimonAX"
		  classid="clsid:D5EC7744-CA4E-42C0-BF49-3A6F2B225A32"
		  codebase="/gw/js/activeX/plugin/PimonFileCtrl.cab#version=2017.1.3.1"
		  width=0 
		  height=0 
		  align=center 
		  hspace=0 
		  vspace=0
	>
	</OBJECT>
</c:if>
<c:if test="${uploadMode == 'U'}">
<c:if test="${displayMode != 'L'}">
<!-- 업무등록 파일첨부 -->
<div class="write_addfile" id="divAttach">
<fieldset class="file_add_area">
    <!-- 첨부파일 버튼영역 -->
    <div class="file_add_top" id="fileAddTop">
        <span><%=BizboxAMessage.getMessage("TX000000521","첨부파일")%></span>
        <a href="javascript:;" id="fileUpload" class="btn_txt_p38"><%=BizboxAMessage.getMessage("TX000007481","파일찾기")%></a>
        <input id="uploadFile" name="uploadFile" multiple="multiple" type="file" style="display:none" />
    </div>

    <div id="productList"></div>
                                
    <div class="file_add_bot" id="dropZone">
        <div id="fileAddDrop" class="file_add_bot_dis" style="display:block;" >
            <span class="fileplus_ico"><%=BizboxAMessage.getMessage("TX000007511","파일을 마우스로 끌어 추가해주세요.")%></span>
        </div>
        <ul id="fileGroup" class="file_group2">
        </ul>
    </div>
</fieldset>
</div>
</c:if>

<c:if test="${displayMode == 'L'}">
<div class="div_form">
<div id="" class="write_addfile mt20 brtn">					
    <!-- 첨부파일 버튼영역 -->
    <div class="file_add_top clear">
    	<div class="mt3 fl">
	        
			<span class="fwb"><%=BizboxAMessage.getMessage("TX000000521","첨부파일")%></span>
      		</div>
        <a href="#n" id="fileUpload" class="file_upload_btn fr"><%=BizboxAMessage.getMessage("TX000007481","파일찾기")%></a>
        <input id="uploadFile" name="uploadFile" multiple="multiple" type="file" class="hidden">
    </div>
    <div id="productList"></div>
    <div id="dropZone" class="file_add_bot">       
        <ul id="fileGroup" class="file_group">
        </ul>
    </div>
</div>
</div>


</c:if>
</c:if>


<c:if test="${uploadMode == 'D'}">
<c:if test="${displayMode != 'L'}">
<div id="detailInfo" class="tb_addfile"></div>


<c:if test="${showPath == '1'}">
<div class="div_form">
<div id="detailInfo2" class="search_downfile"></div>
</c:if>
</div>
</c:if>




<c:if test="${displayMode == 'L'}">
<div class="div_form">
<div id="detailInfo" class="search_downfile mt20">
    
</div>
</div>
</c:if>

</c:if>


<form id="docViewrPopForm" name="docViewrPopForm" action="docViewerPop.do" method="post">
    <input type="hidden" name="groupSeq" />
    <input type="hidden" name="fileId" />
    <input type="hidden" name="fileSn" />
    <input type="hidden" name="moduleTp" />
</form>