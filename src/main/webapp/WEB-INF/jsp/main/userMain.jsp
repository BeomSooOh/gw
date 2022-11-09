<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<link rel="stylesheet" type="text/css" href="/gw/css/main<c:if test="${portalDiv == 'cloud'}">_freeb</c:if>.css?ver=20201021">
<script type="text/javascript" src="/gw/js/Scripts/common<c:if test="${portalDiv == 'cloud'}">_freeb</c:if>.js?ver=20201021"></script>

    <!-- mCustomScrollbar -->
    <link rel="stylesheet" type="text/css" href="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.css">
    <script type="text/javascript" src="/gw/js/mCustomScrollbar/jquery.mCustomScrollbar.js"></script>
    
    <!-- 메인 js -->
    <script type="text/javascript" src="<c:url value='/js/Scripts/jquery.alsEN-1.0.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/js/Scripts/jquery.bxslider.min.js' />"></script>    
    
    <script type="text/javascript" src="/gw/js/Scripts/common.js"></script>

	<div class="main_wrap">
		<!-- 1단 -->
		<div class="con_left mb8">
			<c:forEach var="items" items="${portletList}">
				<c:if test="${items.position == 1}">
					<div class="iframe_div" style="min-height:${items.height}px;height:${items.height}px;position:relative;">	
						<!-- 아이프레임  -->					
						<c:if test="${items.iframeYn == 'Y' || items.iframeYn == 'I'}">
							<c:if test="${fn:indexOf(items.ifUrl, 'http') > -1}">
								<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="yes" width="${items.width}" height="${items.height}"></iframe>
							</c:if>
							<c:if test="${fn:indexOf(items.ifUrl, 'http')  == -1}">
								<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="no" width="${items.width}" height="${items.height}"></iframe>
							</c:if>
						</c:if>
						
						<!-- 아이프레임 아닐때 -->
						<c:if test="${items.iframeYn == 'N'}">
						
							<!-- 통합알림 -->
							<c:if test="${items.portletTp == 'lr_alert'}">
								<div id="" class="m_mention" style="margin-bottom: 8px;">
									 <!-- 탭 -->
					                <ul class="alert_portlet_tab clear">
					                    <li class="on">
					                        <a href="#n" onclick="return false;" class="tab01_portlet">
					                        <span class="ico"></span>								
					                        <span class="txt"><%=BizboxAMessage.getMessage("TX000000893","알림",(String) request.getAttribute("langCode"))%></span>
					                        <span class="" id="alertNewIcon"></span>
					                        </a>
					                    </li>
					                    <li>
					                        <a href="#n" onclick="return false;" class="tab02_portlet">
					                        <span class="ico"></span>
					                        <span class="txt"><%=BizboxAMessage.getMessage("TX000023088","멘션",(String) request.getAttribute("langCode"))%></span>
					                        <span class="" id="mentionNewIcon"></span>
					                        </a>
					                    </li>
					                </ul>
					
					                <div class="m_mentionCon freebScrollY" style="height:${items.height-36}px">
					                    <!-- 알림전체 -->
					                    <div class="tabCon_portlet _tab01_portlet">
						                    <ul id="alertListTag">
						                    </ul>                    
					                    </div>
					
					                    <!-- 알파멘션 -->
					                    <div class="tabCon_portlet _tab02_portlet" style="display:none;">
					                    	<ul id="mentionListTag">
					                    	</ul>                        
					                    </div>	
					                </div>				
					            </div>						
							</c:if>
						
							<!-- 내정보 -->
							<c:if test="${items.portletTp == 'lr_user'}">
								<div id="myInfoPortletLeft" class="userinfo ptl" style="width:${items.width}px;height:${items.height}px;"></div>							
							</c:if>		
							
							<!-- 메일 현황 -->
							<c:if test="${items.portletTp == 'lr_em_count'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="mailbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more mailMoreClick" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>" href="javascript:fnMailMain();" >
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="emCountPortletLeft_${items.position}_${items.sort}" class="mdst">
										
									</div>
								</div>							
							</c:if>	
							
							<!-- 메일함 리스트 -->
							<c:if test="${items.portletTp == 'lr_em'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="mailrebg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>" class="title_more mailMoreClick" href="javascript:fnMailMain();">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="emailListLeft_${items.position}_${items.sort}" class="M_list_div mailreceive" style="height:${items.height-36}px;">
										
									</div>
								</div>							
							</c:if>	
							
							<!-- 결재 현황  -->
							<c:if test="${items.portletTp == 'lr_ea_count'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="docbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more approvalSignStatus" href="javascript:mainmenu.mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', '2002010000', '<%=BizboxAMessage.getMessage("TX000005556","상신함",(String) request.getAttribute("langCode"))%>', 'main');" title="더보기">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="eaCountPortletLeft" class="mdst scroll_y_on" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>	

							<!-- 결재 현황 (비영리)  -->
							<c:if test="${items.portletTp == 'lr_ea_ea_count'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="docbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more approvalSignStatus" href="javascript:onclickTopCustomMenu(100000000,'전자결재', '', 'ea', '', 'N');" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="nonEaCountPortletLeft" class="mdst scroll_y_on" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>	
														
							<!-- 결재 리스트 -->
							<c:if test="${items.portletTp == 'lr_ea'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="appbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more approvalMoreClick" href="javascript:fnEventMainMove(${items.val3 != '' ? items.val3 : items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="eaListLeft_${items.position}_${items.sort}" class="M_list_div" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>		
							
							<!-- 결재 리스트[비영리] -->
							<c:if test="${items.portletTp == 'lr_ea_ea'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="appbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more approvalMoreClick" href="javascript:fnEventMainMoveNon(${items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="nonEaListLeft_${items.position}_${items.sort}" class="M_list_div" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>	
							
							<!-- 결재양식 리스트 -->
							<c:if test="${items.portletTp == 'lr_form'}">
								<div class="M_basic ptl mb8" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="appbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img class="settingBtn approvalFormSetting" portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/ico/ico_setting01.png" alt="" />
									</a>
									<div id="eaFormListLeft_${items.position}" class="M_list_div listform" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>
							
							<!-- 결재양식 리스트 -->
							<c:if test="${items.portletTp == 'lr_ea_form'}">
								<div class="M_basic ptl mb8" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="appbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img class="settingBtn approvalFormSetting" portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/ico/ico_setting01.png" alt="" />
									</a>
									<div id="nonEaFormListLeft_${items.position}" class="M_list_div listform" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>
							
							<!-- 노트 포틀릿 -->
							<c:if test="${items.portletTp == 'lr_no'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="notelistbg">
										<span>
											<%=BizboxAMessage.getMessage("TX000010157","노트",(String) request.getAttribute("langCode"))%>
										</span>
									</h2>
									<a class="title_more noteMoreClick" href="javascript:parent.mainMove('NOTE','/Views/Common/note/noteList','')" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div id="notePortletLeft_${items.position}" class="M_list_div" style="height: ${items.height-36}px;">
												
									</div>					
								</div>							
							</c:if>			
							
							<!-- 일정캘린더 -->
							<c:if test="${items.portletTp == 'lr_so'}">
								<input type="hidden" id="HidEventDays" value="" />
								<input type="hidden" id="HidYearMonth" value="" />
								<input type="hidden" id="HidHolidays" value="" />
								
								<div class="M_basic ptl mb8" style="height:${items.height}px;">
									<h2 class="calbg"><%=BizboxAMessage.getMessage("TX000000483","일정",(String) request.getAttribute("langCode"))%></h2>
									<a class="title_more" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img class="scheduleMoreClick" onclick="javascript:onclickTopCustomMenu(300000000,'<%=BizboxAMessage.getMessage("TX000000483","일정",(String) request.getAttribute("langCode"))%>', '', '', '', 'N');" src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div class="sche_sele">
										<select id="sche_sm" onchange="fnChangeScheduleSelect();" style="width:211px;"></select>
									</div>
									<div class="sche_cal">                    
										<div style="height:40px;">
											<div class="select_date">
												<a title="<%=BizboxAMessage.getMessage("TX000003165","이전",(String) request.getAttribute("langCode"))%>" class="prev" href="javascript:calanderPrevNext(-1)"></a>
												<span id="calanderDate"></span>
												<a title="<%=BizboxAMessage.getMessage("TX000003164","다음",(String) request.getAttribute("langCode"))%>" class="next" href="javascript:calanderPrevNext(1)"></a>
											</div>	
										</div>
										<div  class="calender_ta" name="calenderTable" style="height:150px;"></div>
										<div class="calendar_div st1" style="height:162px;">
											<div id="loadingSchedule" style="display:none;position: absolute;left:50%;top:30%; margin: 0; padding: 0;"><img src="/gw/Images/ico/loading_2x.gif"></div>
											<h3 id="selectDate"></h3>
											<div class="calendar_list" style="height:${items.height-318}px;"> <!-- 세로높이 들어가는 곳 -->
												<ul id="scheduleList">
												</ul>
											</div>																		
										</div>	
									</div>
											
								</div>				
							</c:if>	
							
							<c:if test="${items.portletTp == 'lr_nb'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="speakerbg skbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more boardMoreClick" onclick="mainMove('NOTICE','/board/viewBoard.do?boardNo=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div class="M_list_div" id="boardListLeft_${items.position}_${items.sort}" style="height: ${items.height-36}px;">
											
									</div>					
								</div>								
							</c:if>	
							
							<!-- 문서 포틀릿 lr_doc -->
							<c:if test="${items.portletTp == 'lr_doc'}">
								<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
									<h2 class="speakerbg skbg">
										<span>
											<c:if test="${loginVO.langCode == 'kr' }">
												${items.portletNmKr}
											</c:if>
											<c:if test="${loginVO.langCode == 'en'}">
												${items.portletNmEn}
											</c:if>
											<c:if test="${loginVO.langCode == 'cn' }">
												${items.portletNmCn}
											</c:if>
											<c:if test="${loginVO.langCode == 'jp' }">
												${items.portletNmJp}
											</c:if>
										</span>
									</h2>
									<a class="title_more docMoreClick" onclick="mainMove('DOCUMENT','/doc/viewDocDir.do?dic_cd=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									</a>
									<div class="M_list_div" id="docListLeft_${items.position}_${items.sort}" style="height: ${items.height-36}px;">
											
									</div>					
								</div>								
							</c:if>	
							
							<c:if test="${items.portletTp == 'lr_weather' }">
							
								<div class="ptl_weather posi_re"  style="height:${items.height}px">
									<img class="settingBtn" style="position:absolute; top:10px;right:10px;"<c:catch>
									</c:catch>' portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/portal/setting.png" alt="">
								    <div style="display:none;"  id="weather1">
								    	<!-- 날씨이미지 -->
								        <div class="ptl_weather_ico"><img src="" id="imgWeather" onclick="fnOpenYahooWeather();"/></div>
								
								        <!-- 날씨정보 -->
								        <div class="ptl_weather_info" id="marginID">
								            <div class="weather_location">
								                <span class="loc_txt01" id="ltWeatherCityNm"></span>
								            </div>
								            <div class="weather_celsius">
								                <span id="ltTempC"></span>
								            </div>
								            <p class="weather_desc" id="ltCondition"></p>
								        </div>
								    </div>
								    <p align="center" id="weather0"><img src="<c:url value='/Images/UC/weather_source/loading.gif'/>" style="opacity: 0.2;" alt="" /></p>
								</div>
							</c:if>	
								
							</c:if>
							<c:if test="${items.iframeYn == 'P'}">
								<ul name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" img_url="${items.imgUrl}" val0="${items.val0}" val1="${items.val1}" val2="${items.val2}" val3="${items.val3}" val4="${items.val4}"></ul>							
							</c:if>
					</div>
				</c:if>
			</c:forEach>
		</div>
		
		<!-- 중앙 -->
 		<div class="con_center mb8">
			<div class="cc_bot">
				<c:forEach var="items" items="${portletList}">
					<c:if test="${items.position == 5}">
						<div class="iframe_div center_div2" style="min-height:${items.height}px;height:${items.height}px;">
							<c:if test="${items.iframeYn == 'Y' || items.iframeYn == 'I'}">
								<c:if test="${fn:indexOf(items.ifUrl, 'http') > -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="yes" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
								<c:if test="${fn:indexOf(items.ifUrl, 'http') == -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="no" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
							</c:if>
							
							<c:if test="${items.iframeYn == 'N'}">
								<!-- 전자결재 리스트(top) -->
								<c:if test="${items.portletTp == 'top_ea'}">
									<div id="" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMove(${items.val3 != '' ? items.val3 : items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="eaListTop_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>	

								<!-- 전자결재(비영리) 리스트(top) -->
								<c:if test="${items.portletTp == 'top_ea_ea'}">
									<div id="" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMoveNon(${items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="nonEaListTop_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>	
								
								<!-- 메일리스트(top) -->
								<c:if test="${items.portletTp == 'top_em'}">
									<div id="" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="mailrebg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more mailMoreClick" href="javascript:fnMailMain();" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="emailListTop_${items.position}_${items.sort}" class="M_list_div mailreceive" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>	
								
								<!-- top 게시판 -->
								<c:if test="${items.portletTp == 'top_nb'}">
									<div id="" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more boardMoreClick" href="#" onclick="mainMove('NOTICE','/board/viewBoard.do?boardNo=${items.val0}','${items.val0}')" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="boardListTop_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>
								
								<!-- 문서 포틀릿 top_docs -->
								<c:if test="${items.portletTp == 'top_doc'}">
									<div id="" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more docMoreClick" href="#" onclick="mainMove('DOCUMENT','/doc/viewDocDir.do?dir_cd=${items.val0}','${items.val0}')" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="docListTop_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>										
							</c:if>
							
							<c:if test="${items.iframeYn == 'P'}">
								<ul name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" img_url="${items.imgUrl}" val0="${items.val0}" val1="${items.val1}" val2="${items.val2}" val3="${items.val3}" val4="${items.val4}"></ul>							
							</c:if>
						</div>
					</c:if>
				</c:forEach>
				
				<div class="cc_bot_left">
					<c:forEach var="items" items="${portletList}">
						<c:if test="${items.position == 2}">
						
						<div class="iframe_div center_div" style="min-height:${items.height}px;height:${items.height}px;">
							<!-- 아이프레임 -->
							<c:if test="${items.iframeYn == 'Y' || items.iframeYn == 'I'}">
								<c:if test="${fn:indexOf(items.ifUrl, 'http') > -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="yes" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
								<c:if test="${fn:indexOf(items.ifUrl, 'http') == -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="no" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
							</c:if>
						
							<!-- 배너 -->
							<c:if test="${items.iframeYn == 'P'}">
								<ul name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" img_url="${items.imgUrl}" val0="${items.val0}" val1="${items.val1}" val2="${items.val2}" val3="${items.val3}" val4="${items.val4}"></ul>							
							</c:if>		
							
							<c:if test="${items.iframeYn == 'N'}">
								<!-- 메일함 리스트 -->
								<c:if test="${items.portletTp == 'cn_em'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="mailrebg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>" class="title_more mailMoreClick" href="javascript:fnMailMain();">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a>
										<div id="emailListCenter1_${items.position}_${items.sort}" class="M_list_div mailreceive" style="height: ${items.height-36};">
											
										</div>
									</div>							
								</c:if>	
								
								<!-- 전자결재 리스트 -->
								<c:if test="${items.portletTp == 'cn_ea'}">
									<div id="eaListCenter1" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMove(${items.val3 != '' ? items.val3 : items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="eaListCenter1_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>	

								<!-- 전자결재(비영리) 리스트 -->
								<c:if test="${items.portletTp == 'cn_ea_ea'}">
									<div id="eaListCenter1" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMoveNon(${items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="nonEaListCenter1_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>									
								
								<!-- 게시판 -->
								<c:if test="${items.portletTp == 'cn_nb'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg skbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more boardMoreClick" onclick="mainMove('NOTICE','/board/viewBoard.do?boardNo=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a>
										<div id="boardListCenter1_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
														
										</div>					
									</div>								
								</c:if>
								
								<!-- 문서 포틀릿 cn_doc -->
								<c:if test="${items.portletTp == 'cn_doc'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg skbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more docMoreClick" onclick="mainMove('DOCUMENT','/doc/viewDocDir.do?boardNo=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a>
										<div id="docListCenter1_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
														
										</div>					
									</div>								
								</c:if>	
									
							</c:if>				
						</div>
					</c:if>
				</c:forEach>
				</div>
				
				<div class="cc_bot_right">
					<c:forEach var="items" items="${portletList}">
					<c:if test="${items.position == 3}">
						<div class="iframe_div ml8 center_div" style="min-height:${items.height}px;height:${items.height}px;">

							<c:if test="${items.iframeYn == 'Y' || items.iframeYn == 'I'}">
								<c:if test="${fn:indexOf(items.ifUrl, 'http') > -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="yes" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
								<c:if test="${fn:indexOf(items.ifUrl, 'http') == -1}">
									<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="no" width="${items.width}" height="${items.height}"></iframe>
								</c:if>
							</c:if>
							
							<c:if test="${items.iframeYn == 'P'}">
								<ul name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" img_url="${items.imgUrl}" val0="${items.val0}" val1="${items.val1}" val2="${items.val2}" val3="${items.val3}" val4="${items.val4}"></ul>							
							</c:if>	

							<c:if test="${items.iframeYn == 'N'}">
								<!-- 메일함 리스트 -->
								<c:if test="${items.portletTp == 'cn_em'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="mailrebg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a title="더보기" class="title_more mailMoreClick" href="javascript:fnMailMain();">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="더보기">
										</a>
										<div id="emailListCenter2_${items.position}_${items.sort}" class="M_list_div mailreceive" style="height: ${items.height-36};">
											
										</div>
									</div>								
								</c:if>
								
								<!-- 전자결재 리스트 -->
								<c:if test="${items.portletTp == 'cn_ea'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMove(${items.val3 != '' ? items.val3 : items.val0});" title="더보기">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="더보기">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="eaListCenter2_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>	

								<!-- 전자결재(비영리) 리스트 -->
								<c:if test="${items.portletTp == 'cn_ea_ea'}">
									<div id="eaListCenter1" class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="appbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more approvalMoreClick" href="javascript:fnEventMainMoveNon(${items.val0});" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a><!-- 중앙일때 icon_Mmore2 -->
										<div id="nonEaListCenter2_${items.position}_${items.sort}" class="M_list_div app_list" style="height: ${items.height-36}px;">
											
										</div>
									</div>							
								</c:if>		
								
								<!-- 게시판 -->
								<c:if test="${items.portletTp == 'cn_nb'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg skbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more boardMoreClick" onclick="mainMove('NOTICE','/board/viewBoard.do?boardNo=${items.val0}','${items.val0}')" href="#" title="더보기">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="더보기">
										</a>
										<div id="boardListCenter2_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
													
										</div>					
									</div>								
								</c:if>
								
								<!-- 문서 포틀릿 cn_doc -->
								<c:if test="${items.portletTp == 'cn_doc'}">
									<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
										<h2 class="speakerbg skbg">
											<span>
												<c:if test="${loginVO.langCode == 'kr' }">
													${items.portletNmKr}
												</c:if>
												<c:if test="${loginVO.langCode == 'en'}">
													${items.portletNmEn}
												</c:if>
												<c:if test="${loginVO.langCode == 'cn' }">
													${items.portletNmCn}
												</c:if>
												<c:if test="${loginVO.langCode == 'jp' }">
													${items.portletNmJp}
												</c:if>
											</span>
										</h2>
										<a class="title_more docMoreClick" onclick="mainMove('DOCUMENT','/doc/viewDocDir.do?boardNo=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
											<img src="<c:url value='/Images/ico/icon_Mmore2.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
										</a>
										<div id="docListCenter2_${items.position}_${items.sort}" class="M_list_div board_list" style="height: ${items.height-36}px;">
														
										</div>					
									</div>								
								</c:if>	
									
							</c:if>							
						</div>
					</c:if>
					</c:forEach>
				</div>
			</div>
		</div>
 
		<!-- 4단 -->
		<div class="con_right mb8">
			<c:forEach var="items" items="${portletList}">
				<c:if test="${items.position == 4}">
					<div class="iframe_div" style="min-height:${items.height}px;height:${items.height}px;position: relative;">

					<c:if test="${items.iframeYn == 'Y' || items.iframeYn == 'I'}">
						<c:if test="${fn:indexOf(items.ifUrl, 'http') > -1 }">
							<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="yes" width="${items.width}" height="${items.height}"></iframe>
						</c:if>
						<c:if test="${fn:indexOf(items.ifUrl, 'http') == -1}">
							<iframe name="${items.portletNm}" src="${items.ifUrl}" onerror="${items.iframeErrorUrl}" frameborder="0" scrolling="no" width="${items.width}" height="${items.height}"></iframe>
						</c:if>
					</c:if>
					<c:if test="${items.iframeYn == 'P'}">
						<ul name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" img_url="${items.imgUrl}" val0="${items.val0}" val1="${items.val1}" val2="${items.val2}" val3="${items.val3}" val4="${items.val4}"></ul>							
					</c:if>						

					<c:if test="${items.iframeYn == 'N'}">
						<!-- 통합알림 -->
						<c:if test="${items.portletTp == 'lr_alert'}">
							<div id="" class="m_mention" style="margin-bottom: 8px;">
								 <!-- 탭 -->
				                <ul class="alert_portlet_tab clear">
				                    <li class="on">
				                        <a href="#n" onclick="return false;" class="tab01_portlet">
				                        <span class="ico"></span>								
				                        <span class="txt"><%=BizboxAMessage.getMessage("TX000022368","알림전체",(String) request.getAttribute("langCode"))%></span>
				                        <span class="" id="alertNewIcon"></span>
				                        </a>
				                    </li>
				                    <li>
				                        <a href="#n" onclick="return false;" class="tab02_portlet">
				                        <span class="ico"></span>
				                        <span class="txt"><%=BizboxAMessage.getMessage("TX000021504","알파멘션",(String) request.getAttribute("langCode"))%></span>
				                        <span class="" id="mentionNewIcon"></span>
				                        </a>
				                    </li>
				                </ul>
				
				                <div class="m_mentionCon freebScrollY" style="height:300px;">
				                    <!-- 알림전체 -->
				                    <div class="tabCon_portlet _tab01_portlet">
					                    <ul id="alertListTag">
					                    </ul>                    
				                    </div>
				
				                    <!-- 알파멘션 -->
				                    <div class="tabCon_portlet _tab02_portlet" style="display:none;">
				                    	<ul id="mentionListTag">
				                    	</ul>                        
				                    </div>	
				                </div>				
				            </div>						
						</c:if>
					
						<!-- 내정보 -->
						<c:if test="${items.portletTp == 'lr_user'}">
							<div id="myInfoPortletRight" class="userinfo ptl" style="width:${items.width}px;height:${items.height}px;"></div>							
						</c:if>		
						
						<!-- 메일 현황 -->
						<c:if test="${items.portletTp == 'lr_em_count'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="mailbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more mailMoreClick" href="javascript:fnMailMain();" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="emCountPortletRight_${items.position}_${items.sort}" class="mdst">
									
								</div>
							</div>							
						</c:if>	
						
						<!-- 메일함 리스트 -->
						<c:if test="${items.portletTp == 'lr_em'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="mailrebg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a title="더보기" class="title_more mailMoreClick" href="javascript:fnMailMain();">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="emailListRight_${items.position}_${items.sort}" class="M_list_div mailreceive" style="height:${items.height-36}px;">
									
								</div>
							</div>							
						</c:if>	
						
						<!-- 결재현황 -->
						<c:if test="${items.portletTp == 'lr_ea_count'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="docbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more approvalSignStatus" href="javascript:mainmenu.mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', '2002010000', '<%=BizboxAMessage.getMessage("TX000005556","상신함",(String) request.getAttribute("langCode"))%>', 'main');" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="eaCountPortletRight" class="mdst scroll_y_on" style="height:${items.height-36}px;">
									
								</div>
							</div>							
						</c:if>	

						<!-- 결재현황 (비영리) -->
						<c:if test="${items.portletTp == 'lr_ea_ea_count'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="docbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more approvalSignStatus" href="javascript:onclickTopCustomMenu(100000000,'전자결재', '', 'ea', '', 'N');" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="nonEaCountPortletRight" class="mdst scroll_y_on" style="height:${items.height-36}px;">
									
								</div>
							</div>							
						</c:if>	
															
						<!-- 전자결재 리스트 -->
						<c:if test="${items.portletTp == 'lr_ea'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="appbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more approvalMoreClick" href="javascript:fnEventMainMove(${items.val3 != null ? items.val3 : items.val0});" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="eaListRight_${items.position}_${items.sort}" class="M_list_div" style="height: ${items.height-36}px;">
											
								</div>					
							</div>							
						</c:if>

						<!-- 전자결재(비영리) 리스트 -->
						<c:if test="${items.portletTp == 'lr_ea_ea'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="appbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more approvalMoreClick" href="javascript:fnEventMainMoveNon(${items.val0});" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="nonEaListRight_${items.position}_${items.sort}" class="M_list_div" style="height: ${items.height-36}px;">
											
								</div>					
							</div>							
						</c:if>
						
						<!-- 결재양식 리스트 -->
						<c:if test="${items.portletTp == 'lr_form'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="appbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more" href="#" title="더보기">
									<img class="settingBtn approvalFormSetting" portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/ico/ico_setting01.png" alt="" />
								</a>
								<div id="eaFormListRight_${items.position}" class="M_list_div" style="height: ${items.height-36}px;">
											
								</div>					
							</div>							
						</c:if>

						<!-- 결재양식 리스트(비영리) -->
						<c:if test="${items.portletTp == 'lr_ea_form'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="appbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more" href="#" title="더보기">
									<img class="settingBtn approvalFormSetting" portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/ico/ico_setting01.png" alt="" />
								</a>
								<div id="nonEaFormListRight_${items.position}" class="M_list_div" style="height: ${items.height-36}px;">
											
								</div>					
							</div>							
						</c:if>
						
						<!-- 노트 포틀릿 -->
						<c:if test="${items.portletTp == 'lr_no'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="notelistbg">
									<span>
										<%=BizboxAMessage.getMessage("TX000010157","노트",(String) request.getAttribute("langCode"))%>
									</span>
								</h2>
								<a class="title_more noteMoreClick" href="javascript:parent.mainMove('NOTE','/Views/Common/note/noteList','')" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
								</a>
								<div id="notePortletRight_${items.position}" class="M_list_div" style="height: ${items.height-36}px;">
											
								</div>					
							</div>							
						</c:if>	
						
						<c:if test="${items.portletTp == 'lr_weather' }">
							
								<div class="ptl_weather posi_re"  style="height:${items.height}px">
									<img class="settingBtn" style="position:absolute; top:10px;right:10px;"<c:catch>
									</c:catch>' portalId="${items.portalId}" portletTp="${items.portletTp}" portletKey="${items.portletKey}" position="${items.position}" src="/gw/Images/portal/setting.png" alt="">
								    <div style="display:none;"  id="weather1">
								    	<!-- 날씨이미지 -->
								        <div class="ptl_weather_ico"><img src="" id="imgWeather" onclick="fnOpenYahooWeather();"/></div>
								
								        <!-- 날씨정보 -->
								        <div class="ptl_weather_info" id="marginID">
								            <div class="weather_location">
								                <span class="loc_txt01" id="ltWeatherCityNm"></span>
								            </div>
								            <div class="weather_celsius">
								                <span id="ltTempC"></span>
								            </div>
								            <p class="weather_desc" id="ltCondition"></p>
								        </div>
								    </div>
								    <p align="center" id="weather0"><img src="<c:url value='/Images/UC/weather_source/loading.gif'/>" style="opacity: 0.2;" alt="" /></p>
								</div>
							</c:if>	
						
						
						<c:if test="${items.portletTp == 'lr_nb'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="speakerbg skbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more boardMoreClick" onclick="mainMove('NOTICE','/board/viewBoard.do?boardNo=${items.val0}','${items.val0}')" href="#" title="더보기">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="더보기">
								</a>
								<div id="boardListRight_${items.position}_${items.sort}" class="M_list_div" style="height: ${items.height-36}px;">
												
								</div>					
							</div>							
						</c:if>	
						
						<!-- 문서 포틀릿 lr_doc -->
						<c:if test="${items.portletTp == 'lr_doc'}">
							<div class="M_basic ptl" style="width:${items.width}px;height:${items.height}px;">
								<h2 class="speakerbg skbg">
									<span>
										<c:if test="${loginVO.langCode == 'kr' }">
											${items.portletNmKr}
										</c:if>
										<c:if test="${loginVO.langCode == 'en'}">
											${items.portletNmEn}
										</c:if>
										<c:if test="${loginVO.langCode == 'cn' }">
											${items.portletNmCn}
										</c:if>
										<c:if test="${loginVO.langCode == 'jp' }">
											${items.portletNmJp}
										</c:if>
									</span>
								</h2>
								<a class="title_more docMoreClick" onclick="mainMove('DOCUMENT','/doc/viewDocDir.do?dic_cd=${items.val0}','${items.val0}')" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
									<img src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
								</a>
								<div class="M_list_div" id="docListRight_${items.position}_${items.sort}" style="height: ${items.height-36}px;">
										
								</div>					
							</div>								
						</c:if>	
						
						<c:if test="${items.portletTp == 'lr_so'}">
						<input type="hidden" id="HidEventDays" value="" />
						<input type="hidden" id="HidYearMonth" value="" />
						<input type="hidden" id="HidHolidays" value="" />
						
						<div class="M_basic ptl mb8" style="height:${items.height}px;">
							<h2 class="calbg">
								<span>
									<c:if test="${loginVO.langCode == 'kr' }">
										${items.portletNmKr}
									</c:if>
									<c:if test="${loginVO.langCode == 'en'}">
										${items.portletNmEn}
									</c:if>
									<c:if test="${loginVO.langCode == 'cn' }">
										${items.portletNmCn}
									</c:if>
									<c:if test="${loginVO.langCode == 'jp' }">
										${items.portletNmJp}
									</c:if>
								</span>
							</h2>
							<a class="title_more" href="#" title="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
								<img class="scheduleMoreClick" onclick="javascript:onclickTopCustomMenu(300000000,'<%=BizboxAMessage.getMessage("TX000000483","일정",(String) request.getAttribute("langCode"))%>', '', '', '', 'N');" src="<c:url value='/Images/ico/icon_Mmore.png'/>" alt="<%=BizboxAMessage.getMessage("TX000006348","더보기",(String) request.getAttribute("langCode"))%>">
							</a>
							<div class="sche_sele">
								<select id="sche_sm" onchange="fnChangeScheduleSelect();" style="width:211px;"></select>
							</div>
							<div class="sche_cal">                    
								<div style="height:40px;">
									<div class="select_date">
										<a title="이전" class="prev" href="javascript:calanderPrevNext(-1)"></a>
										<span id="calanderDate"></span>
										<a title="다음" class="next" href="javascript:calanderPrevNext(1)"></a>
									</div>	
								</div>
								<div  class="calender_ta" name="calenderTable" style="height:150px;"></div>
								<div class="calendar_div st1" style="height:162px;">
									<div id="loadingSchedule" style="display:none;position: absolute;left:50%;top:30%; margin: 0; padding: 0;"><img src="/gw/Images/ico/loading_2x.gif"></div>
									<h3 id="selectDate"></h3>
									<div class="calendar_list" style="height:${items.height-318}px;"> <!-- 세로높이 들어가는 곳 -->
										<ul id="scheduleList">
										</ul>
									</div>																		
								</div>	
							</div>
									
						</div>				
						</c:if>	
					</c:if>
					
					</div>	
				</c:if>
			</c:forEach>
		</div>

	</div> <!--// main_wrap -->
	<!-- quick link -->
	<c:forEach var="items" items="${portletList}">
		<c:if test="${items.position == 6 && items.linkList != ''}">
			<div class="main_quick">
				<div id="Mquick" style="padding-top:10px;">
					<span class="als-prev"><img src="<c:url value='/Images/btn/btn_quick_prev.png' />" alt="<%=BizboxAMessage.getMessage("TX000003165","이전",(String) request.getAttribute("langCode"))%>" /></span>
					<!-- class="als-viewport" -->
					<div>
						<!--  class="als-wrapper" -->
						<ul  name="bannerImg" width_set="${items.width}" height_set="${items.height}" portlet_tp="${items.portletTp}" link_list="${items.linkList}" val0="${items.val0}" val1="${items.val1}"></ul>
					</div>					
					<span class="als-next"><img src="<c:url value='/Images/btn/btn_quick_next.png' />" alt="<%=BizboxAMessage.getMessage("TX000003164","다음",(String) request.getAttribute("langCode"))%>" /></span>
				</div>
			</div>
		</c:if>
	</c:forEach>			
	
	<script type="text/javascript">

	var alMoreYn = "Y";	//전체알림 추가조회여부
	var mtMoreYn = "Y"; //멘션 추가조회여부
	var timeSp = ""; //타임스템프(알림조회기준시간)
	var mentionTimeSp = ""; //타임스템프 멘션용
	
	var comeLeaveFlage = true;
	var portletCycleTime = "${portletCycleTime}";
	
	var userMenuList = JSON.parse('${userMenuList}');
	
	var eaType = "${loginVO.eaType}";
	
	var WeatherJson = [
		{ "img": '36.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' },
		{ "img": '33.png', "kr": '구름조금', "en": 'a little cloudy', "jp": '雲が少ない', "cn": '', "gb": '少云' },
		{ "img": '28.png', "kr": '구름많음', "en": 'very cloudy', "jp": '雲が多い', "cn": '', "gb": '多云' },
		{ "img": '26.png', "kr": '흐림', "en": 'cloudy', "jp": '曇り', "cn": '', "gb": '阴' },
		{ "img": '29.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' },						//저녁 
		{ "img": '34.png', "kr": '구름조금', "en": 'a little cloudy', "jp": '雲が少ない', "cn": '', "gb": '少云' },    //저녁 
		{ "img": '29.png', "kr": '구름많음', "en": 'very cloudy', "jp": '雲が多い', "cn": '', "gb": '多云' },    	    //저녁
   		{ "img": '12.png', "kr": '비', "en": 'rain', "jp": '雨', "cn": '', "gb": '雨' },
   		{ "img": '5.png', "kr": '눈/비', "en": 'snow/rain', "jp": '雪/雨', "cn": '', "gb": '雪/雨' },
        { "img": '16.png', "kr": '눈', "en": 'snow', "jp": '雪', "cn": '', "gb": '雪' }
    ];		
	
	$(document).ready(function() {
		var slider = null;
		//fnDrawMyInfo();		 
		fnDrawMainPortal();

        $(".settingBtn").click(function(){
        	fnUserPortletSet(this);
        });
        
        
        //자동출퇴근옵션
        var toDay = getTodayDate();
		if("${empAttCheckFlag}" != "" && "${empAttCheckFlag}" == "Y"){
			if(localStorage.getItem("empAttCheckDate") == null || localStorage.getItem("empAttCheckDate") == "null"){
				localStorage.setItem("empAttCheckDate", toDay);
				fnAutoAttProc();
// 				alert("${empAttCheckMsg}");
			}else if(localStorage.getItem("empAttCheckDate") != toDay){
				localStorage.setItem("empAttCheckDate", toDay);		
// 				alert("${empAttCheckMsg}");
				fnAutoAttProc();
			}
		}
		if(portletCycleTime != ""){
			setInterval("refleshPortlet()", portletCycleTime * 1000);
		}
		
		commuteCheckPermit(function() {
			$("#inBtn").remove();
			$("#outBtn").remove();
		});
				
		setPortletMoreClickEvent();
	});	
	
	// 포틀릿 랜더시 스크립트 방지 목적
	function escapeHtml(html) {  
		var entityMap = { 
			//'&': '&amp;', 
			'<': '&lt;', 
			'>': '&gt;', 
			'"': '&quot;', 
			//"'": '&#39;', 
			'/': '&#x2F;', 
			'`': '&#x60;', 
			'=': '&#x3D;' ,
			'&#39;': "'",
			'&quot;':'"'
		};

		return html.replace(/[<>"`=\/]|(&quot;)|(&#39;)/g, function (s) { return entityMap[s]; });
		//return html.replace(/[<>"`=\/]/g, function (s) { return entityMap[s]; });
	}
	
	//스크롤 에니메이션 실행
    function TagInAm(){
    	$(".tag_date").removeClass("animated05s fadeOutLeft").addClass("animated05s fadeInLeft").show();
    };
    
    //스크롤 에니메이션 초기화
    function TagOutAm(){
    	$(".tag_date").stop().removeClass("animated05s fadeInLeft").addClass("animated05s fadeOutLeft");
    };

	function fnUserPortletSet(data) {
		var params = "";
		var gubun = $(data).attr("portletTp");
		var portletTp = $(data).attr("portletTp");
		var portalId = $(data).attr("portalId");
		var position = $(data).attr("position");
		var portletKey = $(data).attr("portletKey");
		
		params = "&portletTp=" + portletTp +"&portalId=" + portalId + "&position=" + position + "&portletKey=" + portletKey;
		if(gubun == "lr_weather") {
			var url = "portletWeatherUserSetPop.do?weatherId=" + weatherCity + params;
			//var url = "portletBoardListPop.do?menuNoList=" + menuNoList;
			openWindow2(url, "portletWeatherUserSetPop", 502, 200, 1, 1);	
		} else if(gubun == "lr_form") {
			
			if(!checkUserPortletAuth(2001010000))	return;
			
			var eaFormList = $("li[name=eaForm]");	

			formIdList = "";

			for (var i = 0; i < eaFormList.length; i++) {
				formIdList += "," + eaFormList[i].id;
			}

			if (formIdList.length > 0)
				formIdList = formIdList.substring(1);

			var url = "portletEaFormUserSetPop.do?formIdList=" + formIdList + params;
			//var url = "portletBoardListPop.do?menuNoList=" + menuNoList;
			openWindow2(url, "portletEaFormListPop", 502, 700, 1, 1);	
		} else if(gubun == "lr_ea_form") {
			
			if(!checkUserPortletAuth(101010000))	return;
			
			var nonEaFormList = $("li[name=nonEaForm]");	
			
			formIdList = "";

			for (var i = 0; i < nonEaFormList.length; i++) {
				formIdList += "," + nonEaFormList[i].id;
			}

			if (formIdList.length > 0)
				formIdList = formIdList.substring(1);

			var url = "portletNonEaFormUserSetPop.do?formIdList=" + formIdList + params;
			//var url = "portletBoardListPop.do?menuNoList=" + menuNoList;
			openWindow2(url, "portletNonEaFormListPop", 502, 700, 1, 1);
		}
	}
	

	function resizeFrame() {
		 $.each($(".M_basic"), function() {
    		var m_hei =$(this).height();
			$(this).children(".M_list_div").height(m_hei-36);
			$(this).children(".main_nocon").height(m_hei-36);

    	});
	 }
	
	//배너이미지 처리	
    $.each($("[name=bannerImg]"), function (i, t) {
    	
    	var link_list = $(t).attr("link_list");
    	
    	
    	if(link_list != ""){
    		
    		var img_list = link_list.split('▦');
    		var listType = $(t).attr("val4");
    		
    		if($(t).attr("portlet_tp") != "qu_bn"){
    			
        		if(img_list.length > 1){
        			if(listType == "list") {
        				$.each(img_list, function (seq, img_info) {
        					$(t).append(fnGetImgUrl($(t).attr("width_set"), $(t).attr("height_set"), img_info, false, false));
            			});
        				
        			} else {
        				$.each(img_list, function (seq, img_info) {
            		    	$(t).append(fnGetImgUrl($(t).attr("width_set"), $(t).attr("height_set"), img_info, true, false));
            			});
            		    
    	   				 $(t).bxSlider({
    						 pause: $(t).attr("val0") == "" ? "3000" : $(t).attr("val0"),
    						 speed: $(t).attr("val1") == "" ? "1000" : $(t).attr("val1"),
    						 mode:  $(t).attr("val2") == "" ? "fade" : $(t).attr("val2"),
    						 pager: $(t).attr("val3") == "false" ? false : true,
    						 auto: true,        					 
    						 autoHover: true,        					 
    						 controls: false        					 
    					  });	
        			}
        		}else{
        		
        			$(t).append(fnGetImgUrl($(t).attr("width_set"), $(t).attr("height_set"), img_list[0], false, false));
        			
        		}    		    
    		}else{
    		    $.each(img_list, function (seq, img_info) {
    		    	$(t).append(fnGetImgUrl($(t).attr("width_set"), $(t).attr("height_set"), img_info, true, true));
    			});
    		    
    		    var autoscroll_yn = "yes";
    		    var slider_auto = true;
    		    
    		    if(img_list.length < 6){
    		    	$(".als-prev,.als-next").hide();
    		    	autoscroll_yn = "no";
    		    	slider_auto = false;
    		    }
    		            		        		        		    
    		    slider = $(t).bxSlider({
    		    	slideWidth: 210,
    		    	slideMargin: 8,
    		    	auto: slider_auto,
    		    	pause: $(t).attr("val0") == "" ? "3000" : $(t).attr("val0"),
    		    	mode: 'horizontal',
    		    	autoDirection: $(t).attr("val1") == "right" ? "prev" : "next",
    		    	startSlides: 0,
    		    	moveSlides: 1,
    		    	maxSlides: 5,
    		    	controls: false,
    		    	pager: false
    		    });
    		   	
    		}
	
    	}else{
    		
    		if($(t).attr("portlet_tp") == "lr_tax" || $(t).attr("portlet_tp") == "cn_tax"){
				
				$(t).append("<img src='"+$(t).attr("img_url")+"' style='cursor:pointer;' alt='' onclick='fnMoveSSOLink(\",http://stax.douzone.com,N\")' />");
			}else{
				$(t).append("<img src='"+$(t).attr("img_url")+"' alt='' />");
			}
    		
    	}
	});
	
    $('.als-next').click(function(){
      slider.goToNextSlide();
      return false;
    });

    $('.als-prev').click(function(){
      slider.goToPrevSlide();
      return false;
    });
	
	function fnMoveSSOLink(info){
		var link_info = info.split(',');
		var url = link_info[1];
		
		//SSO Link
		if(link_info[2] == "Y"){
			var tblParam = {};
			tblParam.linkId = link_info[4];
			tblParam.linkTp = link_info[5];
			tblParam.linkSeq = link_info[6];
			tblParam.url = url;
			
			$.ajax({
				type:"post",
			    url: _g_contextPath_ + "/cmm/system/getMenuSSOLinkInfo.do",
			    async: false,
			    dataType: 'json',
			    data: tblParam,
			    success: function(data) { 
			    	url = data.ssoUrl;
			    },
			    error: function(xhr) { 
			      console.log('FAIL : ', xhr);
			    }
		   });		
		}
		openWindow2(url,  "_blank",  $(window).width(), $(window).height(), 1,1);
	}
	
	function fnGetImgUrl(width, height, img_info, list, qu_yn, imgUrl){
		var img_info = img_info.split('|');
		var img_result = "";
		imgUrl = (imgUrl || '');
		
		if(img_info[1] != ""){
			if((imgUrl || '') != ""){
				img_result = "<img style='cursor: pointer;' onclick=\"fnMoveSSOLink('"+img_info+"');\" width='"+width+"' height='"+height+"' src='"+imgUrl+"' alt='' />";
			}else{
				img_result = "<img style='cursor: pointer;' onclick=\"fnMoveSSOLink('"+img_info+"');\" width='"+width+"' height='"+height+"' src='/gw/cmm/file/fileDownloadProc.do?fileId="+img_info[0]+"' alt='' />";				
			}			
		}else{
			img_result = "<img width='"+width+"' height='"+height+"' src='/gw/cmm/file/fileDownloadProc.do?fileId="+img_info[0]+"' alt='' />"; 			
		}
		
		if(list){
			//class='als-item'
			img_result = (qu_yn ? "<li>" : "<li>") + img_result + "</li>";
		}
		return img_result;
	}
	
	// 내 정보 그려주기
	function fnDrawMyInfo(data, position){
		var portletData = ${portletListJson};
		var positionInfo = ${positionInfo};
		var displayPositionDuty = '${displayPositionDuty}';
		var userLangCode = '${loginVO.langCode}';
		
		//var userAttInfo = ${userAttInfo};
		//console.log(JSON.stringify(portletData));
		var tag = '';
		
		for(var i=0; i<portletData.length; i++) {
			if(portletData[i].iframeYn == "N" && portletData[i].portletTp == "lr_user") {
				tag += '<div class="user">';
				tag += '<div class="user_pic">';
				tag += '<div class="bg_pic"></div>';
				tag += '<span class="img_pic">';
				tag += '<img class="userImg" src="${profilePath}/${loginVO.uniqId}_thum.jpg?<%=System.currentTimeMillis()%>" onerror=this.src="/gw/Images/temp/pic_Noimg.png" alt="" />';
				tag += '</span>	';
				tag += '</div>';
				if(displayPositionDuty == "duty") {
					if(userLangCode != "en") {
						tag += "<div class=\"mb10 name\">${loginVO.name} <c:if test="${not empty loginVO.classNm && loginVO.classNm != null}">${loginVO.classNm}</c:if></div>";	
					} else {
						tag += "<div class=\"mb10 name\">${loginVO.name} <c:if test="${not empty loginVO.classNm && loginVO.classNm != null}"><br>${loginVO.classNm}</c:if></div>";
					}
					
				} else {
					if(userLangCode != "en") {
						tag += "<div class=\"mb10 name\">${loginVO.name} <c:if test="${not empty loginVO.positionNm && loginVO.positionNm != null}">${loginVO.positionNm}</c:if></div>";	
					} else {
						tag += "<div class=\"mb10 name\">${loginVO.name} <c:if test="${not empty loginVO.positionNm && loginVO.positionNm != null}"><br>${loginVO.positionNm}</c:if></div>";
					}
						
				}
				
				if("${optionValue}" != ""){
					tag += "<div class=\"Scon_ts\">${empPathNm}</div>";
				}
				else{
					tag += "<div class=\"Scon_ts\">${loginVO.orgnztNm}</div>";
				}				
				tag += '</div>';
				tag += '<div class="worktime">';
				tag += '<div id="container">';
				if("${userAttOptionInfo.val2}" != "Y" && "${userAttOptionInfo.val1}" != "Y"){
				
				}
				else{
					if("${empCheckWorkYn}" == "Y"){
						tag += '<ul class="tabs">';
						tag += '<li class="active en_w90" rel="tab1" onclick="fnSetAttOption(1)"><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></li>';
						tag += '<li class="en_w77" rel="tab2" onclick="fnSetAttOption(4)"><%=BizboxAMessage.getMessage("TX000000814","퇴근",(String) request.getAttribute("langCode"))%></li>';
						if("${userAttOptionInfo.val2}" != "Y"){
							tag += '<a id="attHref"></a>';
						}
						tag += '</ul>';
						if("${userAttOptionInfo.val2}" == "Y"){
							if("${userAttOptionInfo.val1}" == "Y"){
								tag += '<div class="tab_container">';
								if(userLangCode != "en") {
									tag += '<div id="tab1" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음",(String) request.getAttribute("langCode"))%></em>&nbsp;&nbsp;<a id="attHref1"> <img id="inBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_in_blue.png"></a></div>';
									tag += '<div id="tab2" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음")%></em>&nbsp;&nbsp;<a id="attHref2"> <img id="outBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png"></a></div>';	
								} else {
									tag += '<div id="tab1" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음",(String) request.getAttribute("langCode"))%></em><a id="attHref1"> <img id="inBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_in_blue.png"></a></div>';
									tag += '<div id="tab2" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음",(String) request.getAttribute("langCode"))%></em><a id="attHref2"> <img id="outBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png"></a></div>';
								}
								
								tag += '</div>';
							}
							else{
								tag += '<div class="tab_container">';
								if(userLangCode != "en") {
									tag += '<div id="tab1" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음",(String) request.getAttribute("langCode"))%></em>&nbsp;&nbsp;<a id="attHref1"></a></div>';
									tag += '<div id="tab2" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음",(String) request.getAttribute("langCode"))%></em>&nbsp;&nbsp;<a id="attHref2"></a></div>';	
								} else {
									tag += '<div id="tab1" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016113","출근시간 없음",(String) request.getAttribute("langCode"))%></em><a id="attHref1"></a></div>';
									tag += '<div id="tab2" class="tab_content"><em><%=BizboxAMessage.getMessage("TX000016097","퇴근시간 없음",(String) request.getAttribute("langCode"))%></em><a id="attHref2"></a></div>';
								}
								
								tag += '</div>';
							}
							
						}
						else{
							tag += '<div class="tab_container">';
							tag += '<div id="tab1" class="tab_content"><a id="attHref1"> <img id="inBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_in_blue.png"></a></div>';
							tag += '<div id="tab2" class="tab_content"><a id="attHref2"> <img id="outBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png"></a></div>';
							tag += '</div>';
						}
					}
				}
				tag += '</div>';
				tag += '</div>';
			}
		}
		
		if(position == "1") {
			$("#myInfoPortletLeft").html(tag);	
		} else if(position == "4") {
			$("#myInfoPortletRight").html(tag);
		}
		
		
		if("${empCheckWorkYn}" == "Y"){
		
			if("${userAttOptionInfo.val2}" != "Y"){
				if("${userAttOptionInfo.val1}" == "Y"){
					$("#attHref").attr("href","javascript:void(0);");
					$("#attHref").attr("onclick","fnAttendCheck(1)");
				}
			}
			
			if("${userAttOptionInfo.val1}" == "Y"){
				$("#attHref1").attr("href","javascript:void(0);");
				$("#attHref1").attr("onclick","fnAttendCheck(1)");
			}
			
			
			fnEventMyInfo();
		}
		
		
		for(var i=0; i<portletData.length; i++) {
			
			if(portletData[i].iframeYn == "N") {
				if(portletData[i].val0 == "all") {
					
				} else if(portletData[i].val0 == "attend") {
					$(".user").remove();
					if(position == "1") {
						$("#myInfoPortletLeft").closest(".iframe_div").attr("style", "min-height:60px;");
						$("#myInfoPortletLeft").css("height","60");
					} else if(position == "4") {
						$("#myInfoPortletRight").closest(".iframe_div").attr("style", "min-height:60px;");
						$("#myInfoPortletRight").css("height","60");
					}
				} else if(portletData[i].val0 == "profile") {
					$(".worktime").remove();
					if(position == "1") {
						$("#myInfoPortletLeft").closest(".iframe_div").attr("style", "min-height:164px;");
						$("#myInfoPortletLeft").css("height","164");	
					} else if(position == "4") {
						$("#myInfoPortletRight").closest(".iframe_div").attr("style", "min-height:164px;");
						$("#myInfoPortletRight").css("height","164");
					}
				}
			}
		}
	}

	//userAttOptionInfo.val0 = 출근 체크 사용여부
	//userAttOptionInfo.val1 = 퇴근 체크 사용여부
	//userAttOptionInfo.val2 = 출/퇴근시간 표시여부
	function fnSetAttOption(type){
		if("${userAttOptionInfo.val2}" != "Y"){
			var picFileImg = document.getElementById('attendImg');
			if(type == "1"){
// 				picFileImg.src = "${pageContext.request.contextPath}/Images/np_myinfo_in_blue.png";
				if("${userAttOptionInfo.val0}" == "Y"){
					$("#attHref").attr("href","javascript:void(0);");
					$("#attHref").attr("onclick","fnAttendCheck(1)");
				}
			}
			else if(type == "4"){			
// 				picFileImg.src = "${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png";
				if("${userAttOptionInfo.val1}" == "Y"){
					$("#attHref").attr("href","javascript:void(0);");
					$("#attHref").attr("onclick","fnAttendCheck(4)");
				}
			}
		}
		
		if("${userAttOptionInfo.val0}" == "Y"){
			if(type == "1"){
				if("${userAttOptionInfo.val0}" == "Y"){
					$("#attHref1").attr("href","javascript:void(0);");
					$("#attHref1").attr("onclick","fnAttendCheck(1)");
				}
			}
		}
		
		if("${userAttOptionInfo.val1}" == "Y"){
			if(type == "4"){
				if("${userAttOptionInfo.val1}" == "Y"){
					$("#attHref2").attr("href","javascript:void(0);");
					$("#attHref2").attr("onclick","fnAttendCheck(4)");
				}
			}
		}
		
	}
	
	
	
	//서버시간 구하기
	var xmlHttp;
	function srvTime(){

		if (window.XMLHttpRequest) {//분기하지 않으면 IE에서만 작동된다.
	
			xmlHttp = new XMLHttpRequest(); // IE 7.0 이상, 크롬, 파이어폭스 등
		
			xmlHttp.open('HEAD',window.location.href.toString(),false);
		
			xmlHttp.setRequestHeader("Content-Type", "text/html");
		
			xmlHttp.send('');
		
			return xmlHttp.getResponseHeader("Date");
		
		}else if (window.ActiveXObject) {
		
			xmlHttp = new ActiveXObject('Msxml2.XMLHTTP');
		
			xmlHttp.open('HEAD',window.location.href.toString(),false);
		
			xmlHttp.setRequestHeader("Content-Type", "text/html");
		
			xmlHttp.send('');
		
			return xmlHttp.getResponseHeader("Date");
	
		}

	}

	
	//출퇴근 체크.
	function fnAttendCheck(type){
		//중복클릭 방지.
		if(!comeLeaveFlage)
			return;
		else
			comeLeaveFlage = false;
		
		var time = "";

		if(type == "1"){
			if(!confirm("<%=BizboxAMessage.getMessage("TX000010928","출근 체크 하시겠습니까?",(String) request.getAttribute("langCode"))%>")){
				comeLeaveFlage = true;
		       return false;
			}
		}
		else if(type == "4"){
			if(!confirm("<%=BizboxAMessage.getMessage("TX000010927","퇴근 체크 하시겠습니까?",(String) request.getAttribute("langCode"))%>")){
				comeLeaveFlage = true;
				return false;
			}
		}
		

		var attendTimeInfo = null;
		var resultCode = "";
		var flag = false;
		var param = {};
		var ipAddr = "";
		var localIpAddr = "";
		param.compSeq = "${loginVO.compSeq}";
		param.empSeq = "${loginVO.uniqId}";
		
		
		var d = new Date();
		param.weekSeq = d.getDay();
		
		
		$.ajax({
            type: "post",
            url: '<c:url value="/cmm/systemx/getAttendTimeInfo.do" />',
            datatype: "json",
            async: false,
            data: param,
            success: function (data) {
            	attendTimeInfo = data.attendTimeInfo;
            	ipAddr = data.ipAddr;
            	localIpAddr = data.localIpAddr;
            	time = data.now;
            },
            error: function (e) {   //error : function(xhr, status, error) {
            	comeLeaveFlage = true;
                console.log('error-fnAttendCheck() : \n' + e);
            	//alert("error2");
            }
        });
		
		
		//근태기준시간설정 체크 
		if(type == "1" && attendTimeInfo != null){	
			if(attendTimeInfo.comePassTimeStart <= time && attendTimeInfo.commPassTimeEnd >= time){
				flag = true;				
			}
		}
		else if(type == "4" && attendTimeInfo != null){
			if(attendTimeInfo.leavePassTimeStart <= time && attendTimeInfo.leavePassTimeEnd >= time){
				flag = true;
			}
		}
		
		
		if(flag){
			if(type == "1" || type == "4"){			
			 	var tblParam = {};
			 	tblParam.gbnCode = type.toString();		        
		        
	 			$.ajax({
	 	        	type:"post",
	 	    		url:'insertComeLeaveEventApi.do',
	 	    		datatype:"json",
	 	            data: tblParam ,
	 	            async: false,
		            success: function (data) { 
		               if(data.resultCode == "SUCCESS"){
		            	   var attendDate = data.result.substring(0,4) + '.' + data.result.substring(4,6) + '.' + data.result.substring(6,8) + ' ' + data.result.substring(8,10) + ':' + data.result.substring(10,12) + ':' + data.result.substring(12,14);
		            	   if(type == "1"){
		            		   //alert("<%=BizboxAMessage.getMessage("TX000010926","출근처리 되었습니다　(출근시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + attendDate + ")");
		            		   alert(data.resultMessage);
		            		   var comeTm = "${userAttOptionInfo.val2}" == "Y" ? attendDate : '';
		            		   $("#tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></em> ' + comeTm + " " + '&nbsp;&nbsp;');
		            		   
		            	   }
		            	   else if(type == "4"){
		            		   //alert("<%=BizboxAMessage.getMessage("TX000010925","퇴근처리 되었습니다　(퇴근시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + attendDate + ")");
		            		   alert(data.resultMessage);
		            		   var leaveTm = "${userAttOptionInfo.val2}" == "Y" ? attendDate : '';
		            		   
		           		   	   $("#tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근",(String) request.getAttribute("langCode"))%></em> ' + leaveTm + " " + '<a id="attHref2"> <img id="outBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png"></a>');
            		   		   if("${userAttOptionInfo.val2}" == "Y"){
		            		   		$("#attHref2").attr("href","javascript:void(0);");
		        					$("#attHref2").attr("onclick","fnAttendCheck(4)");
		            		   }
		            	   }
		               }
		               else{
		            	   alert(data.resultMessage + "(" + data.resultCode + ")");
		               }
		               comeLeaveFlage = true;
		            },
		            error: function (e) {   //error : function(xhr, status, error) {
		                //alert("error2");
		            	comeLeaveFlage = true;
		            }
		        });
			}
		}
			
		else{
			var inTime = attendTimeInfo.comePassTimeStart.substring(0,2) + ":" + attendTimeInfo.comePassTimeStart.substring(2,4) + " ~ " + attendTimeInfo.commPassTimeEnd.substring(0,2) + ":" + attendTimeInfo.commPassTimeEnd.substring(2,4);
			var outTime = attendTimeInfo.leavePassTimeStart.substring(0,2) + ":" + attendTimeInfo.leavePassTimeStart.substring(2,4) + " ~ " + attendTimeInfo.leavePassTimeEnd.substring(0,2) + ":" + attendTimeInfo.leavePassTimeEnd.substring(2,4);			

			if(type == "1"){
				alert("<%=BizboxAMessage.getMessage("TX000010924","출근 가능시간이 아닙니다.　(출근 가능시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + inTime + ")");
			}
			if(type == "4"){
				alert("<%=BizboxAMessage.getMessage("TX000010923","퇴근 가능시간이 아닙니다.　(퇴근 가능시간",(String) request.getAttribute("langCode"))%>".replace("　","\n")+" : " + outTime + ")");
			}
			
			comeLeaveFlage = true;
		}
	}
	
	
	function leadingZeros(n, digits) {
		  var zero = '';
		  n = n.toString();

		  if (n.length < digits) {
		    for (i = 0; i < digits - n.length; i++)
		      zero += '0';
		  }
		  return zero + n;
		}

	
	// 나의 정보 이벤트
	function fnEventMyInfo() {
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function () {
			$("ul.tabs li").css("color", "#89b5d6");
			$(this).addClass("active").css("color", "#fff");
			$(".tab_content").hide();
			var activeTab = $(this).attr("rel");
			$("#" + activeTab).show();
		});
		
		
		var comeDt = '${userAttInfo.comeDt}';
		var leaveDt = '${userAttInfo.leaveDt}';
		var attNm = '${userAttInfo.attNm}';
		
		if(comeDt.length == 14){
			var comeTime = "${userAttOptionInfo.val2}" == "Y" ? comeDt.substring(0,4) + '.' + comeDt.substring(4,6) + '.' + comeDt.substring(6,8) + ' ' + comeDt.substring(8,10) + ':' + comeDt.substring(10,12) + ':' + comeDt.substring(12,14) : ''
			$("#tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></em> ' + comeTime + " " + '&nbsp;&nbsp;');	
		}
		
		if(leaveDt.length == 14){
			var leaveTime = "${userAttOptionInfo.val2}" == "Y" ? leaveDt.substring(0,4) + '.' + leaveDt.substring(4,6) + '.' + leaveDt.substring(6,8) + ' ' + leaveDt.substring(8,10) + ':' + leaveDt.substring(10,12) + ':' + leaveDt.substring(12,14) : '';
			$("#tab2").html('<em><%=BizboxAMessage.getMessage("TX000000814","퇴근",(String) request.getAttribute("langCode"))%></em> ' + leaveTime + " " + '<a id="attHref2"> <img id="outBtn" alt="" src="${pageContext.request.contextPath}/Images/np_myinfo_out_blue.png"></a>');	
		}
		
	}
	

	

	/* [start] 메일 */
	// 메일 현황
	var mail = "";
	var mailUrl = "";
	var email = "";
	var mailcnt = 0;
	var seen = 0;
	function fnDrawEmCount(data, position) {
		var gubun = "";
		var receiveMailFlag = false;
		var usageFlag = false;
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		if(data.val0 == "Y") {
			receiveMailFlag = true;
		} 
		if(data.val1 == "Y") {
			usageFlag = true;
		}
		
		$.ajax({
			type: "post",
            url: "emailCountUsage.do",
            datatype: "json",
            async: true,
            success: function (result) {
            	//console.log("메일 현황 : \n" + JSON.stringify(result));
            	mailUrl = (result.mailUrl || '');
            	var mailData = result.mailUsageCountData;
            	var allunseen = (mailData.allunseen || '0');
            	var mailUseSize = (mailData.mailboxsize || '0');
            	var mailPercent = (mailData.mailboxPercent || '0');
            	var total = (mailData.mailboxmaxsize || '0');
            	var tag = '';
            	
            	if(mailData == "{}") {
            		allunsenn = "-";
            		mailUseSize = "-";
            		mailPercent = "-";
            		total = "-";
            	}
            	
            	tag+='<ul>';
            	
            	if(receiveMailFlag) {
            		tag += '<li>';
            		tag += '<dl>';            	
            		tag += '<dt><%=BizboxAMessage.getMessage("TX000001580","받은편지함",(String) request.getAttribute("langCode"))%></dt>';
                	tag += '<dd><a class=" fwb" href="javascript:fnMailMain()"><span class="text_blue">' + allunseen + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                	tag += '</dl>';	
                	tag += '</li>';
            	}
            	
            	if(usageFlag) {
            		tag += '<li>';
                	tag += '<dl>';
                	tag += '<dt><%=BizboxAMessage.getMessage("TX000000478","사용량",(String) request.getAttribute("langCode"))%></dt></dt>';
                	tag += '<dd><span class="fwb text_blue"> ' + mailPercent +  '%</span></dd>';
                	tag += '</dl>';
                	tag += '</li>';
                	tag += '<li>';
                	tag += '<dl>';
                	tag += '<dd><span>(<span class="fwb">' + mailUseSize + '</span>/ ' + total + ')</span></dd>';
                	tag += '</dl>';
                	tag += '</li>';
            	}
            	
            	tag+='</ul>';
            	
            	$("#emCountPortlet" + gubun + "_" + position + "_" + data.sort).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("메일 현황을 가져오는데 오류가 발생했습니다.");
                console.log("error:fnDrawEmCount()" + e);
            }
		});
	}
	
	// 메일 메뉴 이동
	function fnMailMain(){
		parent.onclickTopMenu(200000000,'<%=BizboxAMessage.getMessage("TX000000262","메일",(String) request.getAttribute("langCode"))%>', mailUrl + '?ssoType=GW', 'mail');
	}	
	
	// 메일 리스트 가져오기
	function fnDrawEmailListPortlet(data, position) {	
		var gubun = "";	
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "2") {
			gubun = "Center1";
		} else if(position == "3") {
			gubun = "Center2";
		} else if(position == "4") {
			gubun = "Right";
		} else if(position == "5") {
			gubun = "Top";
		}
		
		// 받은편지함
		if(data.val0 == "0") {
			fnDrawReceiveMail(data, gubun);
		}else if(data.val0 =="1") {				// 전체편지함
			fnDrawTotalMail(data, gubun);
		}
		
		resizeFrame();
	}
	
	// 받은편지함 그려주기
	function fnDrawReceiveMail(data, gubun) {
		var tag = '';
		var params = {};
		
		params.count = data.val2;
		params.seen = data.val1;
		
		$.ajax({
			type: "post",
            datatype: "json",
            url: "portletEmailList.do",
            data: params,
            async: true,
            success: function (result) {
            	//console.log("받은 편지함 : \n" + JSON.stringify(result));
            	var tag = '';
            	var emailData = result.mailList.result.mailList;	
            	mailUrl = result.mailUrl;
            	mail = result.email;
            	seen = result.seen;
            	mailCnt = result.cnt;
            	
            	if(emailData == undefined) {
            		tag += '<div class="main_nocon">';
            		tag += '<table>';
            		tag += '<tr>';
            		tag += '<td>';
            		tag += '<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
            		tag += '<br />';
            		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000014120","메일이 존재하지 않습니다.",(String) request.getAttribute("langCode"))%></span>';
            		tag += '</td>';
            		tag += '</tr>';
            		tag += '</table>';
            		tag += '</div>';
            	} else {

            		tag+='<ul>';
            	
					for(var i=0; i<emailData.length; i++) {	
						var mailTitle = emailData[i].subject.replace("<","&lt").replace(">","&gt") == "" ? "(제목없음)" : emailData[i].subject.replace("<","&lt").replace(">","&gt");
					
                		if(data.val1 == "Y") {					// 미열람 메일만 보기
                			if(emailData[i].seen == "0") {
                				tag+='<li class="new">';
                				tag+='<dl>';
                       			tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + (gubun + "_" + data.position + "_" + data.sort + "|" + data.val0 + "|" + data.val1) + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
                        		tag+='<dd>' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
                        		tag+='<dd style="date">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
                        		tag+='</dl>';
                           		tag+='</li>';
                			}
                		} else {
                			if(emailData[i].seen == "0") {
                    			tag+='<li class="new">';
                    		} else {
                    			tag+='<li class="">';
                    		}
                    		tag+='<dl>';
                   			//tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + (gubun + "_" + data.position + "_" + data.sort + "|" + data.val0) + '\');" class=""><a href="#n">' + emailData[i].subject.replace("<","&lt").replace(">","&gt") + '</a></dt>';
                   			tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + (gubun + "_" + data.position + "_" + data.sort + "|" + data.val0 + "|" + data.val1) + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
                    		tag+='<dd>' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
                    		tag+='<dd class="date">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
                    		tag+='</dl>';
                       		tag+='</li>';
                		}
                		
                	}
					tag+='</ul>';
            	}
            	
            	$("#emailList" + gubun + "_" + data.position + "_" + data.sort).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("메일 현황을 가져오는데 오류가 발생했습니다.");
                console.log("error:fnDrawReceiveMail()" + e);
            }
		
		});
	}
	
	// 전체 편지함 그려주기
	function fnDrawTotalMail(data, gubun) {
		var tag = '';
		var pageSize = data.val2;
		var seen = data.val1;
		var param = {};
		param.pageSize = pageSize;
		param.seen = seen;
		
		$.ajax({
			type: "post",
			url: "emailTotal.do",
			data: param, 
            datatype: "json",
            async: true,
            success: function (result) {
            	var defaultTag = '';
            	defaultTag += '<div class="main_nocon">';
            	defaultTag += '	<table>';
            	defaultTag += '		<tr>';
            	defaultTag += '			<td>';
            	defaultTag += '				<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
           		defaultTag += '				<br />';
            	defaultTag += '				<span class="txt"><%=BizboxAMessage.getMessage("TX000014120","메일이 존재하지 않습니다.",(String) request.getAttribute("langCode"))%></span>';
            	defaultTag += '			</td>';
            	defaultTag += '		</tr>';
            	defaultTag += '	</table>';
            	defaultTag += '</div>';
            	
            	var emailData = null;
            	if(result.totalMailList){
            		if(result.totalMailList.Records){
            			emailData = result.totalMailList.Records;
            		}
            	}
            	
            	emailData = (emailData == null ? [] : emailData);
            	mail = (result.mail ? result.mail : '');
            	mailUrl = (result.mailUrl ? result.mailUrl : '');
            	
            	var fnGetMailInfoPop = function(popType, item){
            		var resultString = '';
            		var title_width = '';
            		var mailTitle = item.subject.replace("<","&lt").replace(">","&gt") == "" ? "(제목없음)" : item.subject.replace("<","&lt").replace(">","&gt");
            		
            		if(popType === 'Y') {
            			if(item.seen.toString() !== '0'){
            				return '';
            			}
            		}
            		            		
            		if(gubun == "Left" || gubun == "Right") {
            			title_width = "max-width:70%";
            		}else if(gubun == "Top") {
            			title_width = "max-width:90%";
            		}
            		
            		
            		
            		resultString += (item.seen.toString() === '0' ? '<li class="new">' : '<li class="">');
            		resultString += '	<dl>';
            		resultString += '		<dt onclick="mailInfoPop(' + item.muid + ',this, \'' + (gubun + "_" + data.position + "_" + data.sort + "|" + data.val0 + "|" + data.val1) + '\');" class=""><a style="' + title_width + '" href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
           			resultString += '		<dd>' + item.mail_from.replace("<","&lt").replace(">","&gt") + '</dd>';
            		resultString += '		<dd class="date">' + item.rfc822date.substring(2,10) + '</dd>';
            		resultString += '	</dl>';
            		resultString += '</li>';
            		
            		return resultString;
            	}
            	
            	if(emailData.length > 0) {
            		for(var i=0; i<emailData.length; i++) {
            			tag += fnGetMailInfoPop(data.val1, emailData[i]);
            		}
            	}
            	
            	var target = "#emailList" + [gubun, data.position, data.sort].join('_');
            	$(target).html((tag === '' ? defaultTag : '<ul>' + tag + '</ul>'));
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("메일 현황을 가져오는데 오류가 발생했습니다.");
                consoele.log("error:fnDrawTotalMail()" + e);
            }
		});
	}
		
	// 메일 팝업
	function mailInfoPop(muid, obj, position){	
		var gwDomain = window.location.host + (window.location.port == "" ? "" : (":" + window.location.port));
		openWindowPop( mailUrl + "readMailPopApi.do?gwDomain=" + gwDomain + "&email=" + mail + "&muid=" + muid + "&seen=0&userSe=USER","readMailPopApi",1020,700,1,1, position);
		//fnSavePortal(muid);
		$(obj).closest("li.new").removeClass("new");		
	}
	
	// 읽음처리
	function fnSavePortal(muid){
 		var tblParam = {};
 		tblParam.mailUrl = mailUrl;
 		tblParam.muids = muid;
 		
 		$.ajax({
        	type:"post",
    		url:'emailSetSeenFlag.do',
    		datatype:"json",
            data: tblParam ,
            async: true,
    		success: function (result) {

   		    } ,
		    error: function (result) { 
    			//alert("<%=BizboxAMessage.getMessage("TX000010954","읽음처리 실패",(String) request.getAttribute("langCode"))%>");
		    	console.log("<%=BizboxAMessage.getMessage("TX000010954","읽음처리 실패",(String) request.getAttribute("langCode"))%>");
    		}
    	});
	}
	
	
	var readMailPop;
	function openWindowPop(url,  windowName, width, height, strScroll, strResize, position ){
		windowX = Math.ceil( (window.screen.width  - width) / 2 );
		windowY = Math.ceil( (window.screen.height - height) / 2 );
		if(strResize == undefined || strResize == '') {
			strResize = 0 ;
		}
		
		readMailPop = parent.window.open(url, windowName, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", scrollbars="+ strScroll+", resizable="+ strResize);

		setTimeout("fnEmailListReload(\'" + position + "\')", 1000);
		
		try {readMailPop.focus(); } catch(e){}
		return readMailPop;
	}

	// 팝업 처리 후 작업
	function fnEmailListReload(position){
		
		if(!readMailPop.closed){
			setTimeout("fnEmailListReload(\'" + position + "\')", 500);
			return;
		}
		
 		var tblParam = {};
 		tblParam.mailUrl = mailUrl;
 		tblParam.count = mailCnt;
 		tblParam.seen = seen;
 		
 		if(position.split("|")[1] == "0") {
 			$.ajax({
 	        	type:"post",
 	    		url:'emailListReload.do',
 	    		datatype:"json",
 	            data: tblParam ,
 	            async: true,
 	    		success: function (result) {
 	    			var positionID = position.split("|")[0];	
 	    		
 	    			$("#emailList" + positionID).html("");
 	    			
 	    			var tag = '';
 	            	var emailData = result.list.result.mailList;
 	            	
 	            	tag+='<ul>';
 	            	for(var i=0; i<emailData.length; i++) {
 	            		var mailTitle = emailData[i].subject.replace("<","&lt").replace(">","&gt") == "" ? "(제목없음)" : emailData[i].subject.replace("<","&lt").replace(">","&gt");
 	            		
 	            		if(position.split("|")[2] == "Y") {					// 미열람 메일만 보기
 	            			if(emailData[i].seen == "0") {
 	            				tag+='<li class="new">';
 	            				tag+='<dl>';
 	            				tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + position + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
 	            				tag+='<dd>' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
 	            				tag+='<dd style="float:right; margin-top:-30px;">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
 	            				tag+='</dl>';
 	            				tag+='</li>';
 	            			}
 	            		} else {
	 	           			if(emailData[i].seen == "0") {
	 	               			tag+='<li class="new">';	
	 	               		} else {
	 	               			tag+='<li class="">';
	 	               		}
	 	               		
	 	               		tag+='<dl>';
	 	            		tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + position + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
	 	                 	tag+='<dd>' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
	 	                 	tag+='<dd style="float:right; margin-top:-30px;">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
	 	               		tag+='</dl>';
	 	                 	tag+='</li>';
 	            		}
 	            	}
 	            	$("#emailList" + positionID).html(tag);
 	            	$("#emailList" + positionID).append('</ul>');
 	    		} ,
 			    error: function (result) { 
 			    	
 			    	//alert("<%=BizboxAMessage.getMessage("TX000008421","목록 불러오기 실패",(String) request.getAttribute("langCode"))%>");
 			    	console.log("<%=BizboxAMessage.getMessage("TX000008421","목록 불러오기 실패",(String) request.getAttribute("langCode"))%>");
 			    }
 	    	});	
 		} else {
 			$.ajax({
 	        	type:"post",
 	    		url:'emailTotal.do',
 	    		datatype:"json",
 	            data: tblParam ,
 	            async: true,
 	    		success: function (result) {
 	    			var positionID = position.split("|")[0];	
 	    		
 	    			$("#emailList" + positionID).html("");
 	    			
 	    			var tag = '';
 	    			var emailData = result.totalMailList.Records;
 	            	mailUrl = result.mailUrl;
 	            	tag+='<ul>';
 	            	for(var i=0; i<emailData.length; i++) {
 	            		var mailTitle = emailData[i].subject.replace("<","&lt").replace(">","&gt") == "" ? "(제목없음)" : emailData[i].subject.replace("<","&lt").replace(">","&gt");	            		
 	            		
 	            		if(position.split("|")[2] == "Y") {					// 미열람 메일만 보기
 	            			if(emailData[i].seen == "0") {
 	            				tag+='<li class="new">';
 	            				tag+='<dl>';
 	            				tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + position + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
 	            				tag+='<dd>' + emailData[i].from.replace("<","&lt").replace(">","&gt") + '</dd>';
 	            				tag+='<dd style="float:right; margin-top:-30px;">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
 	            				tag+='</dl>';
 	            				tag+='</li>';
 	            			}
 	            		} else {
	 	           			if(emailData[i].seen == "0") {
	 	               			tag+='<li class="new">';	
	 	               		} else {
	 	               			tag+='<li class="">';
	 	               		}
	 	               		
	 	               		tag+='<dl>';
	 	            		tag+='<dt onclick="mailInfoPop(' + emailData[i].muid + ',this, \'' + position + '\');" class=""><a href="#n" title="' + mailTitle + '">' + mailTitle + '</a></dt>';
	 	                 	tag+='<dd>' + emailData[i].mail_from.replace("<","&lt").replace(">","&gt") + '</dd>';
	 	                 	tag+='<dd style="float:right; margin-top:-30px;">' + emailData[i].rfc822Date.substring(2,10) + '</dd>';
	 	               		tag+='</dl>';
	 	                 	tag+='</li>';
	 	            	}
 	            	}
 	            	$("#emailList" + positionID).html(tag);
 	            	$("#emailList" + positionID).append('</ul>');
 	    		} ,
 			    error: function (result) { 
 			    	
 			    	//alert("<%=BizboxAMessage.getMessage("TX000008421","목록 불러오기 실패",(String) request.getAttribute("langCode"))%>");
 			    	console.log("<%=BizboxAMessage.getMessage("TX000008421","목록 불러오기 실패",(String) request.getAttribute("langCode"))%>");
 			    }
 	    	});	
 		}
	}	
	
	
	/* [END] 메일 */
	
	
	/* [Start] 일정캘린더 */
	
	// 일정 최초 데이터 (전체일정)
	var indivi = "N";
	var share = "N";
	var special = "N";
	var optionIndivi = "N";
	var optionShare = "N";
	var optionSpecial = "N";
	
	var holidayList = "";
	
	function fnDrawSchedulePortlet(data, position) {
		var gubun = "";
		var params = {};
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		optionIndivi = data.val0;
		optionShare = data.val1;
		optionSpecial = data.val2;
		var defaultCalenderType = data.val3 == null ? "private" : data.val3;
		
		var scheSmHtml = "";
		//전체일정 
<%-- 		$("#sche_sm").append("<option value='total'><%=BizboxAMessage.getMessage("TX000010380","전체일정")%></option>"); --%>
		
		if(data.val0 !== "" || data.val1 !== "") {
			scheSmHtml += "<option value='all'><%=BizboxAMessage.getMessage("TX000010380","전체일정",(String) request.getAttribute("langCode"))%></option>";
		}
		
		// 개인일정
		if(data.val0 == "Y") {
			indivi = "Y";
			share = "N";
			special = "N";
			var selector = defaultCalenderType === "private" || defaultCalenderType === undefined ? "selected='selected'" : "";
			scheSmHtml += "<option value='indivi'" + selector + "><%=BizboxAMessage.getMessage("TX000004103","개인일정",(String) request.getAttribute("langCode"))%></option>";
		} else {
			indivi = "N";
		}
		
		// 공유일정
		if(data.val1 == "Y") {
			var selector = defaultCalenderType === "share" ? "selected='selected'" : "";
			scheSmHtml += "<option value='share'" + selector + "><%=BizboxAMessage.getMessage("TX000010163","공유일정",(String) request.getAttribute("langCode"))%></option>";
			share = "Y";
		} else {
			share = "N";
		}
		
		// 기념일
		if(data.val2 == "Y") {
			var selector = defaultCalenderType === "special" ? "selected='selected'" : "";
			scheSmHtml += "<option value='special'" + selector + "><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></option>";	
			special = "Y";
			
			/* var today = new Date();
			var year = today.getFullYear();
			var month = today.getMonth() + 1 < 10 ? "0" + (today.getMonth() + 1) : today.getMonth() + 1;
			var day = today.getDate() < 10 ? "0" + today.getDate() : today.getDate();
			
			params.startDate = year + '' + month + '' + day; */
			
		} else {
			special = "N";
		}
		
		$("#sche_sm").html(scheSmHtml);
				
		params.indivi = indivi;
		params.share = share;
		params.special = special;
		params.selectBox = $("#sche_sm").val();
		
		$.ajax({
			type: "post",
            url: "schedulePortlet.do",
            datatype: "json",
            data: params,
            async: true,
            success: function (result) {
            	
            	//console.log(JSON.stringify(result));
            	
            	var HidEventDays = result.HidEventDays;
            	var HidYearMonth = result.HidYearMonth;
            	var HidHoliDays = result.holidays;
            	
            	holidayList = result.holidayList;
            	
            	$("#HidEventDays").val(HidEventDays);
            	$("#HidYearMonth").val(HidYearMonth);
            	$("#HidHolidays").val(HidHoliDays);
            	
            	$("#calanderDate").html(HidYearMonth);
            	
            	
                //일정표시여부 체크
                if ($("#HidEventDays").val() != null) {
                    var yyyyMM = $("#HidYearMonth").val().split('.');
                    var today = new Date();
                    CalanderInit(yyyyMM[0], yyyyMM[1], $("#HidEventDays").val(), $("#HidHolidays").val(), today.getFullYear(), today.getMonth() + 1, today.getDate());
                }	
                
                var selectDate = "";
                
                selectDate = today.getFullYear() + "-" + (today.getMonth() + 1 < 10 ? "0" + (today.getMonth() + 1) : (today.getMonth() + 1)) 
                	+ "-" + (today.getDate() + 1 < 10 ? "0" + today.getDate() : today.getDate())
                
                if(!checkUserPortletAuth(301000000)){                	
                	$("#selectDate").html(selectDate + '<span class="fr mr20"><span class="text_blue">' + '0' + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></span>');
                }else{
                	$("#selectDate").html(selectDate + '<span class="fr mr20"><span class="text_blue">' + result.scheduleContents.length + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></span>');
                }
                
                calanderDateSelectBind(result);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 리스트을 가져오는데 오류가 발생했습니다.");
                console.log("error:fnDrawSchedulePortlet() " + e);
            }
		
		});
	}
	
	function fnAutoAttProc(){
		var st = srvTime();
		var d = new Date(st);
		
		var time =	
		    leadingZeros(d.getHours(), 2) + 
		    leadingZeros(d.getMinutes(), 2) +
		    leadingZeros(d.getSeconds(), 2);
		

		var attendTimeInfo = null;
		var resultCode = "";
		var flag = false;
		var param = {};
		var ipAddr = "";
		var localIpAddr = "";
		param.compSeq = "${loginVO.compSeq}";
		param.empSeq = "${loginVO.uniqId}";
		
		var d = new Date();
		param.weekSeq = d.getDay();
		
		
		$.ajax({
            type: "post",
            url: '<c:url value="/cmm/systemx/getAttendTimeInfo.do" />',
            datatype: "json",
            async: false,
            data: param,
            success: function (data) {
            	attendTimeInfo = data.attendTimeInfo;
            	ipAddr = data.ipAddr;
            	localIpAddr = data.localIpAddr;
            },
            error: function (e) {   //error : function(xhr, status, error) {
                console.log('error-fnAttendCheck() : \n' + e);
            	//alert("error2");
            }
        });
		
		
		//근태기준시간설정 체크 		
		if(attendTimeInfo.comePassTimeStart <= time && attendTimeInfo.commPassTimeEnd >= time){
			flag = true;				
		}

		if(flag){
			if(!confirm("<%=BizboxAMessage.getMessage("TX000010928","출근 체크 하시겠습니까?",(String) request.getAttribute("langCode"))%>")){	
		       return false;
			}
			
		 	var tblParam = {};
		 	tblParam.gbnCode = "1";		        
 			$.ajax({
 	        	type:"post",
 	    		url:'insertComeLeaveEventApi.do',
 	    		datatype:"json",
 	            data: tblParam ,
 	            async: false,
	            success: function (data) { 
	               if(data.resultCode == "SUCCESS"){	            	   	            	    		   
	            	   alert(data.resultMessage);	
	            	   
	            	   var attendDate = "${userAttOptionInfo.val2}" == "Y" ? data.result.substring(0,4) + '.' + data.result.substring(4,6) + '.' + data.result.substring(6,8) + ' ' + data.result.substring(8,10) + ':' + data.result.substring(10,12) + ':' + data.result.substring(12,14) : '';           	   
	            	   $("#tab1").html('<em><%=BizboxAMessage.getMessage("TX000000813","출근",(String) request.getAttribute("langCode"))%></em> ' + attendDate + " " + '&nbsp;&nbsp;');
            		   
	               }
	               else{
	            	   alert(data.resultMessage + "(" + data.resultCode + ")");
	               }
	            },
	            error: function (e) {   //error : function(xhr, status, error) {
	                //alert("error2");
	            }
	        });
			
		}
	}
		
	// 일정 그려주기
	function fnDrawScheduleContent(data) {
		var tag = '';
		
		if(!checkUserPortletAuth(301000000))	return;
		
		for(var i=0; i<holidayList.length; i++) {
			 var selectDay = $(".selon").attr("name");
			 var selectDate = selectDay.split("|");
		     var selectYear = selectDate[0];
		     var selectMonth = selectDate[1];
		     var selectDay = selectDate[2];
		     
		     selectMonth < 10 ? "0" + selectMonth : selectMonth;
			 selectDay < 10 ? "0" + selectDay : selectDay;
			   
			 var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay); 
		
			if(holidayList[i].hDay.indexOf(day.replace(/\-/g,'')) > -1) {
				tag += '<li>';
				tag += '<span class="txt text_red">' + holidayList[i].title + '</span>';
				tag += '</li>';
			}
		}

		if(data.length > 0) {
			for(var i=0; i<data.length; i++) {
				var startDateFormat = data[i].startDate;
				var endDateFormat = data[i].endDate;

				
				var sYear = startDateFormat.substring(0, 4);
				var sMonth = startDateFormat.substring(4, 6);
				var sDay = startDateFormat.substring(6, 8);
				var sHour = startDateFormat.substring(8, 10);
				var sMin = startDateFormat.substring(10, 12);
				
				var eYear = endDateFormat.substring(0, 4);
				var eMonth = endDateFormat.substring(4, 6);
				var eDay = endDateFormat.substring(6, 8);
				var eHour = endDateFormat.substring(8, 10);
				var eMin = endDateFormat.substring(10, 12);


				
	            var startDate = sMonth + "-" + sDay + " " + sHour + ":" + sMin;
	            var endDate =  eMonth + "-" + eDay + " " + eHour + ":" + eMin;
	            var specialDate = sMonth + "-" + sDay;
            	
	            if($("#sche_sm").val() == "all") {
	            	 tag += '<li>';
	  				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	  					tag += '<span class="time">' + specialDate + '</span>';
	  				} else {
	  					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
	  				}
	  				
	    				if(data[i].gbnCode == "E") {
	    					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
	    				} else if(data[i].gbnCode == "M") {
	    					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
	    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
	    					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
	    				}
	    				
	    				if(data[i].gbnCode == "w") {
	    					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	  				} else if(data[i].gbnCode == "b") {
	  					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	  				} else {
	  					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	  				}
	 				tag += '</li>';
	            } else if($("#sche_sm").val() == "indivi") {
            		tag += '<li>';
      				
            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
      					tag += '<span class="time">' + specialDate + '</span>';
      				} else {
      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
      				}
      				
       				if(data[i].gbnCode == "E") {
       					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
       				} else if(data[i].gbnCode == "M") {
       					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
       				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
       					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
       				}
        				
       				if(data[i].gbnCode == "w") {
       					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
      				} else if(data[i].gbnCode == "b") {
      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
      				} else {
      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
      				}
     				tag += '</li>';
	            } else if($("#sche_sm").val() == "share") {
	            	if(data[i].gbnCode == "M") {
	            		 tag += '<li>';
	      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	      					tag += '<span class="time">' + specialDate + '</span>';
	      				} else {
	      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
	      				}
	      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
        				}
	        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	      				} else {
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
	            	}
	            } else if($("#sche_sm").val() == "special") {
	            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	            		 tag += '<li>';
	      				if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	      					tag += '<span class="time">' + specialDate + '</span>';
	      				} else {
	      					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
	      				}
	      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
        				}
	        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	      				} else {
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + " \" href=\"javascript:void(0);\" onclick=\"fnSchedulePop(" + data[i].schSeq + ")\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
	            	}
	            }
			}	
		} else {
			if(tag == '') {
        		tag += '<li>'; 
    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음",(String) request.getAttribute("langCode"))%></span>';
    			tag += '</li>';	
        	}
		}
		
		
		$("#scheduleList").html(tag);
	}
	
	// 캘린더 그려주기(최초)
    var selectedDate = new Array;
    var MaxHeight = 0;
    function CalanderInit(year, month, days, holiDay, yyyy, MM, dd) {
		
        var html = "";

        var date0 = new Date(year + "-" + month + "-01");
        var date1 = date0;
        var date2 = new Date();

        for (var i = 0; i < 7; i++) {
            var temp0 = new Date(date0.setDate(date0.getDate() - 1));

            if (temp0.getDay() == 0) {
                date1 = temp0;
            }
        }

        date0 = new Date(year + "-" + month + "-01");
        date0 = new Date(date0.setMonth(date0.getMonth() + 1));
        date0 = new Date(date0.setDate(date0.getDate() -1));

        for (var i = 0; i < 7; i++) {
            var temp1 = new Date(date0.setDate(date0.getDate() + 1));

            if (temp1.getDay() == 6) {
                date2 = new Date(temp1.setDate(temp1.getDate() + 1));
            }
        }

        var cnt = 0;

        html += "<table cellpadding='0' cellspacing='0'>";
        html += "<tbody>";
        html += "<tr>";
        html += "<th class='sun'><%=BizboxAMessage.getMessage("TX000000437","일",(String) request.getAttribute("langCode"))%></th>";
        html += "<th><%=BizboxAMessage.getMessage("TX000005657","월",(String) request.getAttribute("langCode"))%></th>";
        html += "<th><%=BizboxAMessage.getMessage("TX000005658","화",(String) request.getAttribute("langCode"))%></th>";
        html += "<th><%=BizboxAMessage.getMessage("TX000005659","수",(String) request.getAttribute("langCode"))%></th>";
        html += "<th><%=BizboxAMessage.getMessage("TX000005660","목",(String) request.getAttribute("langCode"))%></th>";
        html += "<th><%=BizboxAMessage.getMessage("TX000005661","금",(String) request.getAttribute("langCode"))%></th>";
        html += "<th class='sat'><%=BizboxAMessage.getMessage("TX000005662","토",(String) request.getAttribute("langCode"))%></th>";
        html += "</tr>";

        while (date1 < date2) {

            var classStr = "";
            
            if(checkUserPortletAuth(301000000)){
	            if (date1.getFullYear() == yyyy && (date1.getMonth() + 1) == MM && date1.getDate() == dd) {
	                classStr = "today selon";
	
	                if (days.indexOf(getyyyyMMdd(date1)) > -1) {
	                    classStr += " schedule";
	                }
					
	            } else if (days.indexOf(getyyyyMMdd(date1)) > -1) {
	                classStr = " schedule";
	            } else if(holiDay.indexOf(getyyyyMMdd(date1)) > -1) {
	            	classStr += " special_day";
	            }
			}

            if (cnt == 0) {
                html += "<tr><td class='sun'><a href='#none' onclick='calanderDateSelect(this.name);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td>";
            } else if (cnt == 6) {
                html += "<td class='sat'><a href='#none' onclick='calanderDateSelect(this.name);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td></tr>";
            } else {
                html += "<td><a href='#none' onclick='calanderDateSelect(this.name);' name=" + date1.getFullYear() + "|" + (date1.getMonth() + 1) + "|" + date1.getDate() + " class='" + classStr + "' title=''>" + date1.getDate() + "</a></td>";
            }

            date1 = new Date(date1.setDate(date1.getDate() + 1));
            cnt++;

            if(cnt == 7){
                cnt = 0;
            }
        }

        html += "</table>";
        
        $("div[name*='calenderTable']").html(html);

        selectedDate[0] = yyyy;
        selectedDate[1] = MM;
        selectedDate[2] = dd;
    }
	
    
    // 특정 날 선택
   function calanderDateSelect(date) {
	   var selectDate = date.split("|");
	   var selectYear = selectDate[0];
	   var selectMonth = selectDate[1];
	   var selectDay = selectDate[2];
	   
	   selectMonth < 10 ? "0" + selectMonth : selectMonth;
	   selectDay < 10 ? "0" + selectDay : selectDay;
	   
	   var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay); 
	   
	   
	   $('.sche_cal table td a').removeClass('selon');
          $('a[name="' + date + '"]').addClass('selon');
	   
        if (date == "") {
            date = selectedDate[0] + "|" + selectedDate[1] + "|" + selectedDate[2]
        }

        var selectvalue = date.split('|');

        var url = "schedulePortlet.do";
	   
		var tblParam = {};
		
		tblParam.scheduleCheckDate = selectvalue[0].toString() + (selectvalue[1] < 10 ? "0" + selectvalue[1].toString() : selectvalue[1].toString()) + (selectvalue[2] < 10 ? "0" + selectvalue[2].toString() : selectvalue[2].toString());
      	tblParam.startDate= selectvalue[0].toString() + ((parseInt(selectvalue[1])-1) < 10 ? "0" + (parseInt(selectvalue[1])-1).toString() : (parseInt(selectvalue[1])-1).toString()) + (selectvalue[2] < 10 ? "0" + selectvalue[2].toString() : selectvalue[2].toString());      	
		tblParam.endDate=selectvalue[0].toString() + (selectvalue[1] < 10 ? "0" + selectvalue[1].toString() : selectvalue[1].toString()) + "31";   	    
         
      	
      	if(selectvalue[1]=="12") {
      		selectvalue[0] = parseInt(selectvalue[0])+1;
      		selectvalue[1]="0";
      	}

   		if($("#sche_sm").val() == "all") {
      		tblParam.all = "Y";
      	}
   		tblParam.indivi = indivi;
		tblParam.share = share;
   		tblParam.special = special;
   		tblParam.selectBox = $("#sche_sm").val();
        
      	$("#loadingSchedule").show();
        $.ajax({
            type: "POST"
            , url: url
            , data: tblParam
	        , async: true
            , success: function (result) {
            
            	 $("#loadingSchedule").hide();	
            	 
            	 holidayList = result.holidayList;
            
				//console.log(JSON.stringify(result));
				if(!checkUserPortletAuth(301000000)){ 
					$("#selectDate").html(day + '<span class="fr mr20"><span class="text_blue">' + '0' + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></span>');
				}else{
					$("#selectDate").html(day + '<span class="fr mr20"><span class="text_blue">' + result.scheduleContents.length + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></span>');
				}

				
				calanderDateSelectBind(result);	 
				 
               	

                selectedDate[0] = selectvalue[0];
                selectedDate[1] = selectvalue[1];
                selectedDate[2] = selectvalue[2];
            }
            , error: function (reult) {
            	$("#loadingSchedule").hide();
                //alert('선택된 날짜의 데이터를 가져오는데 실패했습니다.');
            	console.log('선택된 날짜의 데이터를 가져오는데 실패했습니다.');
            }

        });
    }
    
   function calanderPrevNext(page) {
	   var today = new Date();
	   
       var thisDate = $("#calanderDate").html().split('.');
       var nextDate = new Date(thisDate[0] + "-" + thisDate[1]);

       nextDate = new Date(nextDate.setMonth(nextDate.getMonth() + page));
       var nextMonth = nextDate.getMonth() + 1;

       if (nextMonth < 10) {
           nextMonth = "0" + nextMonth;
       }

       //CalanderRefresh(nextDate.getFullYear(), nextMonth, selectedDate[0], selectedDate[1], selectedDate[2], page);
       if(page != 0) {
    	   CalanderRefresh(nextDate.getFullYear(), nextMonth, today.getFullYear(), today.getMonth() + 1, today.getDate(), page);   
       } else {
    	   CalanderRefresh(nextDate.getFullYear(), nextMonth, 0, today.getMonth() + 1, today.getDate(), page);
       }
       

       $("#calanderDate").html(nextDate.getFullYear() + "." + nextMonth);
   }

   // 캘린더 다시 그려주기
   function CalanderRefresh(year, month, yyyy, MM, dd, page) {
	
       var html = "";

       var date0 = new Date(year + "-" + month + "-01");
       var date1 = date0;
       var date2 = new Date();
       var day = "";
       
       for (var i = 0; i < 7; i++) {
           var temp0 = new Date(date0.setDate(date0.getDate() - 1));

           if (temp0.getDay() == 0) {
               date1 = temp0;
           }
       }

       date0 = new Date(year + "-" + month + "-01");
       date0 = new Date(date0.setMonth(date0.getMonth() + 1));
       date0 = new Date(date0.setDate(date0.getDate() - 1));

       for (var i = 0; i < 7; i++) {
           var temp1 = new Date(date0.setDate(date0.getDate() + 1));

           if (temp1.getDay() == 6) {
               date2 = new Date(temp1.setDate(temp1.getDate() + 1));
           }
       }
       
       var url = "schedulePortlet.do";

       var tblParam = {};
       //tblParam.startDate = String(year) + String(month) + "01";       
       //tblParam.endDate = String(year) + String(month)+ "31"; 

       tblParam.startDate = getyyyyMMdd(date1);
       tblParam.endDate = getyyyyMMdd(date2);
       
       if (yyyy != 0) {
           tblParam.toDay = yyyy.toString() + (MM < 10 ? "0" + MM.toString() : MM.toString()) + (dd < 10 ? "0" + dd.toString() : dd.toString());
       } else {
    	   var selectDay = $(".selon").attr("name");
    	   
    	   var selectDay = $(".selon").attr("name");
	       var selectDate = selectDay.split("|");
	   	   var selectYear = selectDate[0];
	   	   var selectMonth = selectDate[1];
	   	   var selectDay = selectDate[2];
	   	    
	   	   selectMonth < 10 ? "0" + selectMonth : selectMonth;
	   	   selectDay < 10 ? "0" + selectDay : selectDay;
	   		   
	   	   day = selectYear + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + (selectDay < 10 ? "0" + selectDay : selectDay); 	
    	   tblParam.scheduleCheckDate = day;
           tblParam.toDay = day;
       }
       
       /*
       if($("#sche_sm").val() == "all"){
    	   indivi = optionIndivi;
    	   share = optionShare;
    	   special = optionSpecial;    		 
       }else if($("#sche_sm").val() == "indivi"){
    	   indivi = optionIndivi;
    	   share = "N";
    	   special = "N";
       }else if($("#sche_sm").val() == "share"){
    	   indivi = "N";
    	   share = optionShare;
    	   special = "N";
       }else if($("#sche_sm").val() == "special"){
    	   indivi = "N";
    	   share = "N";
    	   special = optionSpecial;
       }         
       */
       
       if($("#sche_sm").find("option[value=indivi]").length > 0) {
    	   indivi = "Y";
       } else {
    	   indivi = "N";
       }
       
       if($("#sche_sm").find("option[value=share]").length > 0) {
    	   share = "Y";
       } else {
    	   share = "N";
       }
       
       if($("#sche_sm").find("option[value=special]").length > 0) {
    	   special = "Y";
       } else {
    	   special = "N";
       }
       
       tblParam.indivi = indivi;
       tblParam.share = share;
       tblParam.special = special;
       tblParam.selectBox = $("#sche_sm").val();

       $("#loadingSchedule").show();
       
       $.ajax({
           type: "POST"
           , url: url
           , data: tblParam
	        , async: true
           , success: function (result) {
        	   
           	   if(page != 0) {
           			CalanderInit(year, month, result.HidEventDays, result.holidays, yyyy, MM, dd);   
           			
           			// 다음달 혹은 이전달로 변경시 1일을 고정으로 선택되도록 한다.
    				var date = year + "|" + Number(month) + "|" + "1";
    				calanderDateSelect(date);
    				
           	   } else {
           			var year1 = day.substring(0, 4);
           			var month1 = day.substring(4,6);
           			var date1 = day.substring(6,8);
           			
           		    CalanderInit(year1, month1, result.HidEventDays, result.holidays, year1, month1, date1);
           	   }
               
			   //console.log("변경 시 데이터 : \n" + JSON.stringify(result));
               if(page == "0") {
            	   calanderDateSelectBind(result);
               }
               $("#loadingSchedule").hide();
           }
           , error: function (reult) {
        	   $("#loadingSchedule").hide();
           }

       });

   }
    
    // 캘린더 셀렉박스 변경
    function fnChangeScheduleSelect() {
    	calanderPrevNext(0);
    }
    
    function calanderDateSelectBind(result) {
    	//console.log("binding : \n" + JSON.stringify(result));
    	
    	var data = result.scheduleContents;
    	
    	$("#scheduleList").html("");
        var tag = "";

        var selectDay = $(".selon").attr("name");
		var selectDate = selectDay.split("|");
	    var selectYear = selectDate[0];
	    var selectMonth = selectDate[1];
	    var selectDay = selectDate[2];
	    
	    selectMonth < 10 ? "0" + selectMonth : selectMonth;
		selectDay < 10 ? "0" + selectDay : selectDay;
		   
		var day = selectYear + "-" + (selectMonth < 10 ? "0" + selectMonth : selectMonth) + "-" + (selectDay < 10 ? "0" + selectDay : selectDay); 	
   
   		for(var i=0; i<holidayList.length; i++) {
			if(holidayList[i].hDay.indexOf(day.replace(/\-/g,'')) > -1) {
				tag += '<li>';
				tag += '<span class="txt text_red">' + holidayList[i].title + '</span>';
				tag += '</li>';
			}
		}
        
   		$("#selectDate").html(day + '<span class="fr mr20"><span class="text_blue">' + data.length + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></span>');
        if (data.length > 0) {
        	 
        	
        	for (var i = 0; i < data.length; i++) {
				var startDateFormat = data[i].startDate;
				var endDateFormat = data[i].endDate;

				
				var sYear = startDateFormat.substring(0, 4);
				var sMonth = startDateFormat.substring(4, 6);
				var sDay = startDateFormat.substring(6, 8);
				var sHour = startDateFormat.substring(8, 10);
				var sMin = startDateFormat.substring(10, 12);
				
				var eYear = endDateFormat.substring(0, 4);
				var eMonth = endDateFormat.substring(4, 6);
				var eDay = endDateFormat.substring(6, 8);
				var eHour = endDateFormat.substring(8, 10);
				var eMin = endDateFormat.substring(10, 12);
				
	            var startDate = sMonth + "-" + sDay + " " + sHour + ":" + sMin;
	            var endDate =  eMonth + "-" + eDay + " " + eHour + ":" + eMin;
	            var specialDate = sMonth + "-" + sDay;
	            
	            if($("#sche_sm").val() == "all") {
	            	tag += '<li>';
	            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
	  					tag += '<span class="time">' + specialDate + '</span>';
	  				} else {
	  					if(data[i].alldayYn && data[i].alldayYn === 'Y') {
	  						tag += '<span class="time">ALLDay</span>';
	  					} else {
	  						tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
	  					}		  					
	  				}
	  				
    				if(data[i].gbnCode == "E") {
    					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
    				} else if(data[i].gbnCode == "M") {
    					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
    				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
    					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
    				}
	    				
    				if(data[i].gbnCode == "w") {
    					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	  				} else if(data[i].gbnCode == "b") {
	  					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	  				} else {
	  					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
	  					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	  				}
	 				tag += '</li>';
	            } else if($("#sche_sm").val() == "indivi") {
	            	if(data[i].gbnCode == "E") {
	            		tag += '<li>';
	            		 
	            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
			  				tag += '<span class="time">' + specialDate + '</span>';
			  			} else {
			  				if(data[i].alldayYn && data[i].alldayYn === 'Y') {
			  					tag += '<span class="time">ALLDay</span>';
			  				} else {
			  					tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
			  				}		  					
			  			}
	      				
	        			if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
        				}
	        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	      				} else {
	      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
	            	}
	            } else if($("#sche_sm").val() == "share") {
	            	if(data[i].gbnCode == "M") {
	            		tag += '<li>';
	            		if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
				  			tag += '<span class="time">' + specialDate + '</span>';
				  		} else {
				  			if(data[i].alldayYn && data[i].alldayYn === 'Y') {
				  				tag += '<span class="time">ALLDay</span>';
				  			} else {
				  				tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
				  			}		  					
				  		}
	      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
        				}
	        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	      				} else {
	      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
	            	}
	            } else if($("#sche_sm").val() == "special") {
	            	if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
            			tag += '<li>';
            			if(data[i].gbnCode == "w" || data[i].gbnCode == "b") {
				  			tag += '<span class="time">' + specialDate + '</span>';
				  		} else {
				  			if(data[i].alldayYn && data[i].alldayYn === 'Y') {
				  				tag += '<span class="time">ALLDay</span>';
				  			} else {
				  				tag += '<span class="time">' + startDate + " ~ " + endDate + '</span>';	
				  			}		  					
				  		}
	      				
        				if(data[i].gbnCode == "E") {
        					tag += '<span class="sign green"><%=BizboxAMessage.getMessage("TX000002835","개인",(String) request.getAttribute("langCode"))%></span>';	
        				} else if(data[i].gbnCode == "M") {
        					tag += '<span class="sign blue"><%=BizboxAMessage.getMessage("TX000012110","공유",(String) request.getAttribute("langCode"))%></span>';
        				} else if(data[i].gbnCode == "b" || data[i].gbnCode == "w") {
        					tag += '<span class="sign gray"><%=BizboxAMessage.getMessage("TX000007381","기념일",(String) request.getAttribute("langCode"))%></span>';
        				}
        				
        				if(data[i].gbnCode == "w") {
        					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000003963","결혼기념일",(String) request.getAttribute("langCode"))%></span>';
	      				} else if(data[i].gbnCode == "b") {
	      					tag += '<span class="txt">' + escapeHtml(data[i].schTitle) + '<%=BizboxAMessage.getMessage("TX000001672","생일",(String) request.getAttribute("langCode"))%></span>';
	      				} else {
	      					var url = "/Views/Common/mCalendar/detail.do?seq=" + data[i].schSeq;	
	      					tag += "<a title=\"" + escapeHtml(data[i].schTitle) + "\" href=\"javascript:void(0);\" onclick=\"mainMove('SCHEDULE', '" + url + "','" + data[i].schSeq + "')\"><span class=\"txt\">" + escapeHtml(data[i].schTitle) + "</span></a>";
	      				}
	     				tag += '</li>';
	            	}
	            }
            }
        } else {
        	
        	if(tag == '') {
        		tag += '<li>';
    			tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000000776","일정없음",(String) request.getAttribute("langCode"))%></span>';
    			tag += '</li>';	
        	}
        	
        }


        $("#scheduleList").html(tag);
    }
    
    // 날짜 형식 
   	function getyyyyMMdd(date) {

        var MM = date.getMonth() + 1;
        var dd = date.getDate();

        if(MM < 10){
            MM = "0" + MM;
        }
        
        if(dd < 10){
            dd = "0" + dd;
        }
        return date.getFullYear() + MM.toString() + dd.toString();
    }	
    
    // 일정 팝업
    function fnSchedulePop(scheduleSeq) {
    	var url = "/schedule/Views/Common/mCalendar/detail?seq="+scheduleSeq;
  		openWindow2(url,  "pop", 833, 711,"yes", 1);
    }
	/* [END] 일정캘린더 */
	
	
	/* [start] 전자결재 */
	
	// 전자결재 리스트 가져오기
	function fnDrawEaListPortlet(data, position) {
		var gubun = "";	
		var writterFlag = false;
		var tblParams = {};
		var optionValue = "";
		
		
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "2") {
			gubun = "Center1";
		} else if(position == "3") {
			gubun = "Center2";
		} else if(position == "4") {
			gubun = "Right";
		} else if(position == "5") {
			gubun = "Top";
		}
		
		if(data.val2 == "Y") {
			writterFlag = false;
		} else {
			writterFlag = true;
		}
		
		if(data.val0[0] === "[") {
			var dataValue = JSON.parse(data.val0);
			dataValue.forEach(function(item){
				optionValue += item.menu_seq + ",";
			});
			tblParams.val0 = optionValue.slice(0,-1);
			
		} else {
			tblParams.val0 = data.val0;		
		}
		
		tblParams.val1 = data.val1;
		tblParams.iframe = "N";
		
		$.ajax({
			type: "post",
            url: "/eap/ea/edoc/main/EaPortletCloudList.do",
            datatype: "json",
            data: tblParams,
            async: true,
            success: function (result) {
            	//console.log("결재 : \n" + JSON.stringify(result));
            	
            	var eapPortletDocList = JSON.parse(result.EaPortletDocList);
            	var tag = '';
            	
            	if(eapPortletDocList.length == 0) {
            		tag += '<div class="main_nocon">';
            		tag += '<table>';
            		tag += '<tr>';
            		tag += '<td>';
            		tag += '<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
            		tag += '<br />';
            		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000008258","결재문서가 없습니다",(String) request.getAttribute("langCode"))%></span>';
            		tag += '</td>';
            		tag += '</tr>';
            		tag += '</table>';
            		tag += '</div>';            		
            	} else {
            		tag+='<ul>';	
            	
            		
            		if(data.portletTp == "lr_ea") {
            			for(var i=0; i<eapPortletDocList.length; i++) {
            				tag += '<li>';
            				
            				if(writterFlag){
                            	tag += '<a href="#" title="' + eapPortletDocList[i].DOC_TITLE_ORIGIN + '" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + eapPortletDocList[i].DOC_TITLE_ORIGIN + '</a>';
                            } else {
                            	tag += '<a href="#" title="' + eapPortletDocList[i].DISP_TITLE + '" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + eapPortletDocList[i].DISP_TITLE + '</a>';
                            }
            				/* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
                            if ((eapPortletDocList[i].READYN || '') == 'N') {
                                tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
                            }
            				
            				tag += '</li>';
            			}
            		} else {
            			/* [시작] */
                    	for(var i=0; i<eapPortletDocList.length; i++) {
                    		tag += '<li>';
                    		tag += '<dl>';
                    		/* [아이콘] */
                            switch(eapPortletDocList[i].RET_ITEM_CD) {
                            	//상신
                            	case '10' : tag += '<dd class="sign blue">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                            		break;
                            	//미결
                            	case '20' : tag += '<dd class="sign orange">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//기결
                            	case '30' : tag += '<dd class="sign gray">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//기결
                            	case '40' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//반려
                            	case '50' : tag += '<dd class="sign red">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//반려
                            	case '51' : tag += '<dd class="sign red">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//참조
                            	case '60' : tag += '<dd class="sign purple">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//예결
                            	case '70' : tag += '<dd class="sign yellow">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//예결
                            	case '71' : tag += '<dd class="sign yellow">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                					break;
                            	//후결
                            	case '80' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//전결
                            	case '90' : tag += '<dd class="sign bluegreen">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//수신
                            	case '100' : tag += '<dd class="sign orange">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//보류
                            	case '110' : tag += '<dd class="sign gray">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//시행
                            	case '120' : tag += '<dd class="sign blue">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;
                            	//회람
                            	case '130' : tag += '<dd class="sign purple">'+eapPortletDocList[i].RET_ITEM_NM+'</dd>'
                    				break;                	
                            	default :  '<dd class="sign gray"></dd>'
                            		break;
                            }
                    		
                    		tag += '<dt class="title2">';
                    		if ((eapPortletDocList[i].DISP_TITLE || '') != '') {
                                /* [작성부서 기안자] 문서제목 [신규아이콘] - [작성부서 기안자] 문서제목 */
                                var eaStyle = "";
                                
                                
                                
                                if(data.portletTp == "cn_ea" && (eapPortletDocList[i].READYN || '') == 'N'){
                                	eaStyle = "max-width: 146px";
                                }
                                
                                if(eapPortletDocList[i].emergencyFlag == "1") {
	                    			tag += '<img src="/eap/Images/ico/ico_emergency.png" alt="긴급아이콘" style="float:left; padding-top: 5px; padding-right: 2px;" />';
	                    		}
                                
                    			if(writterFlag){
                                	tag += '<a title="' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '" style="'+ eaStyle +'" href="#" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].DOC_TITLE_ORIGIN) + '</a>';
                                } else {
                                	tag += '<a title="' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '" href="#" style="'+ eaStyle +'" onclick="fnEventDocTitle(' + "'" + eapPortletDocList[i].DOC_ID + "', '" + eapPortletDocList[i].FORM_ID + "', '" + eapPortletDocList[i].DOC_WIDTH + "'"+ ');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].DISP_TITLE) + '</a>';
                                }
                                
                                /* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
                                if ((eapPortletDocList[i].READYN || '') == 'N') {
                                    tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
                                }
                            } else {
                                tag += '';
                            }
                    		tag += '</dt>';
                    		/* [첨부파일 아이콘] */
                            tag += '<dd class="file">';
                            if ((eapPortletDocList[i].DISP_ATTACH || '') == 'attach') {
                                tag += '<img src="' + '<c:url value="/Images/ico/ico_file.png" />' + '" alt="첨부파일">';
                            } else {
                                tag += '';
                            }
                            tag += '</dd>';

                            /* [기안일자] */
                            tag += '<dd class="date">';
                            if ((eapPortletDocList[i].REP_DT || '') != '') {
                                tag += ncCom_Replace(eapPortletDocList[i].REP_DT, ".", "-");
                            } else {
                                tag += '';
                            }
                            tag += '</dd>';

                            /* [종료] */
                            tag += '</dl>';
                            
                    		tag += '</li>';
                    	}
            		}
            		
            	}
            	
            	tag+='</ul>';
            	
            	$("#eaList" + gubun + "_" + position + "_" + data.sort).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 리스트을 가져오는데 오류가 발생했습니다.");
            	console.log("error:fnDrawEaListPortlet()" + e);
            }
		
		});
	}
	
		
	// 전자결재 팝업보기
	function fnEventDocTitle( doc_id, form_id, doc_width ) {
        //console.log('doc_id : ' + doc_id + ' / form_id : ' + form_id);
        //console.log(getContextPath() + '/ea/docpop/EAAppDocViewPop.do?doc_id=' + doc_id + '&form_id=' + form_id);

       //var doc_width = 900;
        var intWidth = doc_width;
        var intHeight = screen.height - 100;
        var agt = navigator.userAgent.toLowerCase();
        if (agt.indexOf("safari") != -1) {
            intHeight = intHeight - 70;
        }
        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;
        if (agt.indexOf("safari") != -1) {
            intTop = intTop - 30;
        }
        var url = "/eap/ea/docpop/EAAppDocViewPop.do?doc_id=" + doc_id + "&form_id=" + form_id;
        window.open(url, 'AppDoc', 'menubar=0,resizable=1,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
    }
	
	// 더보기(전자결재 메뉴 이동)
	function fnEventMainMove(menuNo) {
		
		if(typeof menuNo == "object") {
			menuNo = menuNo[0].menu_seq;
		} else {
			menuNo = String(menuNo);
			if(menuNo != "" && menuNo.split(",").length > 1)
				menuNo = menuNo.split(",")[0];
		}
		
   		mainmenu.mainToLnbMenu('2000000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/ea/eadoc/EaDocList.do', 'eap', '', 'main', '2000000000', menuNo, '<%=BizboxAMessage.getMessage("TX000010094","결재요청문서",(String) request.getAttribute("langCode"))%>', 'main');
	}
	
	// 더보기(전자결재(비영리) 메뉴 이동)
	function fnEventMainMoveNon(menuNo) {
		menuNo = String(menuNo);
		if(menuNo != "" && menuNo.split(",").length > 1)
			menuNo = menuNo.split(",")[0];		
		
		if(menuNo == "102010000") {		// 결재대기문서
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/approvalbox/standingList.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');
		} else if(menuNo == "102030000") {		// 결재완료문서 
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/approvalbox/finishList.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');
		} else if(menuNo == "102040000") {		// 결재반려문서
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/approvalbox/returnList.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');
		} else if(menuNo == "102020000") {		// 결재예정문서
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/approvalbox/standbyList.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');
		} else if(menuNo == "101030000") {		// 상신문서
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/reportstoragebox/draftDoc.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');
		} else if(menuNo == "101060000") {		// 열람문서
			mainmenu.mainToLnbMenu('100000000', '<%=BizboxAMessage.getMessage("TX000000479","전자결재",(String) request.getAttribute("langCode"))%>', '/neos/edoc/eapproval/reportstoragebox/readingList.do', 'ea', '', 'main', '100000000', menuNo, '<%=BizboxAMessage.getMessage("TX000008298","결재대기문서",(String) request.getAttribute("langCode"))%>', 'main');		
		}
   		
	}
	
	// 결재 현황
	function fnDrawEaCount(data, position) {
		var gubun = "";	
	
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		$.ajax({
			type: "post",
            url: "eapInfoCount.do",
            datatype: "json",
            async: true,
            success: function (result) {
                var eapInfoResult = result.eapInfoCount.resultCode;
               	var eapInfoCountData = result.eapInfoCount.result.boxList;
               	var tag = '';
               	
               	if(eapInfoResult == "SUCCESS") {
               		
               		var eaBox1 = "0";		// 미결함 (2002020000)
               		var eaBox2 = "0";		// 예결함 (2002030000)
               		var eaBox3 = "0";		// 수신참조함 (2002090000)
               		var eaBox4 = "0";
               		var eaBox5 = "0";		// 결재요청문서 (2002010000)
               		
               		var menuName1 = "미결함";
               		var menuName2 = "예결함";
               		var menuName3 = "수신참조함";
               		var menuName4 = "";
               		var menuName5 = "결재요청문서";
               		
               		var menuId1 = "";		// 미결함(메뉴 이름 변경 경우)
               		var menuId2 = "";		// 예결함(메뉴 이름 변경 경우)
               		var menuId3 = "";		// 수신참조함(메뉴 이름 변경 경우)
               		var menuId4 = "";		
               		var menuId5 = "";		// 결재요청문서(메뉴 이름 변경 경우)               		
               		
               		tag+='<ul>';
               		
               		for(var i=0; i<eapInfoCountData.length; i++) {
               			if(eapInfoCountData[i].menuId == "2002020000") {
               				eaBox1 = eapInfoCountData[i].alramCnt;
               				menuName1 = eapInfoCountData[i].menuName;
               				menuId1 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].menuId == "2002030000") {
               				eaBox2 = eapInfoCountData[i].alramCnt;
               				menuName2 = eapInfoCountData[i].menuName;
               				menuId2 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].menuId == "2002090000") {
               				eaBox3 = eapInfoCountData[i].alramCnt;
               				menuName3 = eapInfoCountData[i].menuName;
               				menuId3 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].menuId == "2002010000" || (groupSeq == "arario" && eapInfoCountData[i].menuId === "2019042232")) {
               				eaBox5 = eapInfoCountData[i].alramCnt;
               				menuName5 = eapInfoCountData[i].menuName;
               				menuId5 = eapInfoCountData[i].menuId;
               			}
               		}
               		/*
               		for(var i=0; i<eapInfoCountData.length; i++) {
               			if(eapInfoCountData[i].iconId == "001") {
               				eaBox1 = eapInfoCountData[i].alramCnt;
               				menuName1 = eapInfoCountData[i].menuName;
               				menuId1 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].iconId == "008") {
               				eaBox2 = eapInfoCountData[i].alramCnt;
               				menuName2 = eapInfoCountData[i].menuName;
               				menuId2 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].iconId == "006") {
               				eaBox3 = eapInfoCountData[i].alramCnt;
               				menuName3 = eapInfoCountData[i].menuName;
               				menuId3 = eapInfoCountData[i].menuId;
               			} else if(eapInfoCountData[i].iconId == "005") {
               				eaBox5 = eapInfoCountData[i].alramCnt;
               				menuName5 = eapInfoCountData[i].menuName;
               				menuId5 = eapInfoCountData[i].menuId;
               			}
               		}               		
               		
               		*/
               		if(data.val0 == "Y") {
               			tag+='<li>';
                      		tag+='<dl>';
                      		tag+='<dt>' + menuName1 + '</dt>';
                      		tag+='<dd><a href="javascript:fnEventMainMove(' + menuId1 + ');" class=" fwb"><span class="text_red">' + eaBox1 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                      		tag+='</dl>';
                      		tag+='</li>';
               		} 
               		
               		if(data.val1 == "Y") {
               			tag+='<li>';
                      		tag+='<dl>';
                      		tag+='<dt>' + menuName2 + '</dt>';
                      		tag+='<dd><a href="javascript:fnEventMainMove(' + menuId2 + ');" class=" fwb"><span class="text_red">' + eaBox2 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                      		tag+='</dl>';
                      		tag+='</li>';
               		}
               		
               		if(data.val2 == "Y") {
               			tag+='<li>';
                      		tag+='<dl>';
                      		tag+='<dt>' + menuName3 + '</dt>';
                      		tag+='<dd><a href="javascript:fnEventMainMove(' + menuId3 + ');" class=" fwb"><span class="text_blue">' + eaBox3 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                      		tag+='</dl>';
                      		tag+='</li>';
               		}
                  		
                  		if(data.val4 == "Y") {
                  			tag+='<li>';
                      		tag+='<dl>';
                      		tag+='<dt><%=BizboxAMessage.getMessage("TX000000475","진행중",(String) request.getAttribute("langCode"))%></dt>';
                      		tag+='<dd><a href="javascript:fnEventMainMove(' + menuId5 + ');" class=" fwb"><span class="text_blue">' + eaBox5 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                      		tag+='</dl>';
                      		tag+='</li>';
                  		}
                  		
               	} else {
               		//alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
               	}

            	tag+='</ul>';
            	$("#eaCountPortlet" + gubun).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
            	console.log("error:fnDrawEaCount() " + e);
            }
		});
		
	}

	// 결재 현황 (비영리)
	function fnDrawNonEaCount(data, position) {
		var gubun = "";	
	
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		$.ajax({
			type: "post",
            url: "nonEaInfoCount.do",
            datatype: "json",
            async: true,
            success: function (result) {

                var eapInfoResult = result.eapInfoCount.resultCode;
               	var eapInfoCountData = result.eapInfoCount.result.boxList;
               	var tag = '';
               	//console.log("aaaaa : " + JSON.stringify(result));
               	if(eapInfoResult == "SUCCESS") {
               		var selectBox = "";
               		if(data.val0 != "") {
               			selectBox = data.val0.split("|");
               		}
               		
               		
               		var eaBox1 = "0";		// 결재대기문서 (102010000)
               		var eaBox2 = "0";		// 결재완료문서 (102030000)
               		var eaBox3 = "0";		// 결재반려문서 (102040000)
               		var eaBox4 = "0";		// 상신문서 (101030000)
               		var eaBox5 = "0";		// 열람문서 (101060000)
               		var eaBox6 = "0";		// 결재예정문서 (102020000)
               		
               		var menuName1 = "결재대기문서";		// 결재대기문서 (102010000)
               		var menuName2 = "결재완료문서";		// 결재완료문서 (102030000)
               		var menuName3 = "결재반려문서";		// 결재반려문서 (102040000)
               		var menuName4 = "상신문서";			// 상신문서 (101030000)
               		var menuName5 = "열람문서";			// 열람문서 (101060000)
               		var menuName6 = "결재예정문서";		// 결재예정문서 (102020000)
               		
               		tag+='<ul>';
               		
               		for(var i=0; i<eapInfoCountData.length; i++) {
               			if(eapInfoCountData[i].menuId == "102010000") {
               				eaBox1 = eapInfoCountData[i].alramCnt;
               				menuName1 = eapInfoCountData[i].menuName;
               			} else if(eapInfoCountData[i].menuId == "102030000") {
               				eaBox2 = eapInfoCountData[i].docCnt;
               				menuName2 = eapInfoCountData[i].menuName;
               			} else if(eapInfoCountData[i].menuId == "102040000") {
               				eaBox3 = eapInfoCountData[i].docCnt;
               				menuName3 = eapInfoCountData[i].menuName;
               			} else if(eapInfoCountData[i].menuId == "101030000") {
               				eaBox4 = eapInfoCountData[i].alramCnt;
               				menuName4 = eapInfoCountData[i].menuName;
               			} else if(eapInfoCountData[i].menuId == "101060000") {
               				eaBox5 = eapInfoCountData[i].alramCnt;
               				menuName5 = eapInfoCountData[i].menuName;
               			} else if(eapInfoCountData[i].menuId == "102020000") {
               				eaBox6 = eapInfoCountData[i].alramCnt;
               				menuName6 = eapInfoCountData[i].menuName;
               			}
               		}
               		
               		if(selectBox[0] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName1 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000008298","결재대기문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(102010000);" class=" fwb"><span class="text_red">' + eaBox1 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		} 
               		
               		if(selectBox[1] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName2 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000010199","결재완료문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(102030000);" class=" fwb"><span class="text_red">' + eaBox2 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		}
               		
               		if(selectBox[2] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName3 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000010198","결재반려문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(102040000);" class=" fwb"><span class="text_blue">' + eaBox3 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		}
                  		
               		if(selectBox[3] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName4 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000010204","상신문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(101030000);" class=" fwb"><span class="text_blue">' + eaBox4 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		}
                		
               		if(selectBox[4] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName5 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000010201","열람문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(101060000);" class=" fwb"><span class="text_blue">' + eaBox5 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		}
                		
               		if(selectBox[5] == "Y") {
               			tag+='<li>';
                   		tag+='<dl>';
                   		tag+='<dt>' + menuName6 + '</dt>';
                   		<%-- tag+='<dt><%=BizboxAMessage.getMessage("TX000010200","결재예정문서")%></dt>'; --%>
                   		tag+='<dd><a href="javascript:fnEventMainMoveNon(102020000);" class=" fwb"><span class="text_blue">' + eaBox6 + '</span><%=BizboxAMessage.getMessage("TX000000476","건",(String) request.getAttribute("langCode"))%></a></dd>';
                   		tag+='</dl>';
                   		tag+='</li>';
               		}
               	} else {
               		//alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
               	}

            	tag+='</ul>';
            	$("#nonEaCountPortlet" + gubun).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
            	console.log("fnDrawNonEaCount() " + e);
            }
		});
		
	}	
	
		
	function fnDrawEaFormPortlet(data, position) {
		var tblParams = {};
		var gubun = '';
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		tblParams.opValue = data.val0;
		
		
		$.ajax({
			type: "post",
            url: "eaFormList.do",
            datatype: "json",
            data: tblParams,
            async: true,
            success: function (result) {
            	//console.log("결재양식 : \n" + JSON.stringify(result));
            	
            	var eaFormData = result.list;
            	var tag = '';
            	tag+='<ul>';
            	
            	if(eaFormData.length == "0") {
            		tag += "<li><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.",(String) request.getAttribute("langCode"))%></li>";	
            			
            	} else {
            		for(var i=0; i<eaFormData.length; i++) {
            			if(eaFormData[i].spriteCssClass != "folder") {
            				tag += "<li name='eaForm' id='" + eaFormData[i].formId + "'>";
                    		tag += "<a href='#' title=\"" + escapeHtml(eaFormData[i].formNm) + "\" onclick='fn_set(" + JSON.stringify(eaFormData[i]) + ")'>" + escapeHtml(eaFormData[i].formNm) + "</a>";
                    		tag += "</li>";	
            			}
            		}
            	}
            	
            	tag+='</ul>';
            	$("#eaFormList" + gubun + "_" + position).html(tag);
           	
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
            	console.log("error:fnDrawEaFormPortlet() " + e);
            }
		});   
	}
		
	function fn_set(data){
		
		var item = jQuery.parseJSON(JSON.stringify(data));
		//var item = e.sender.dataItem(e.node);
			
        var intWidth = item.docWidth;
        var intHeight = screen.height - 100;

        var url = "/eap/ea/eadocpop/EAAppDocPop.do?form_id=" + item.formId;
        var target = "AppDocW";

        if (item.interlockUrl != "") {
        	/* interlock_url dp "?" 가 포함된 경우와 포함되지 않은 경우 처리 */
     		var connector = (item.interlockUrl.indexOf("?") < 0 ? "?" : "&");
        	url = item.interlockUrl + connector + "form_id=" + item.formId + "&form_tp=" + item.formDTp + "&doc_width=" + item.docWidth;
            target = "";

            if (item.interlockWidth != "") {
                intWidth = item.interlockWidth;
            }

            if (item.interlockHeight != "") {
                intHeight = eval(item.interlockHeight);
            }
        }

        var intLeft = screen.width / 2 - intWidth / 2;
        var intTop = screen.height / 2 - intHeight / 2 - 40;

        window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,titlebar=0,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
        
	}	
	
	// 비영리 결재 양식
	function fnDrawNonEaFormPortlet(data, position) {
		var tblParams = {};
		var gubun = '';
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		tblParams.opValue = data.val0;
		
		if(tblParams.opValue == "") {
			var tag = '';
        	tag += '<ul>';
        	tag += "<li><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.",(String) request.getAttribute("langCode"))%></li>";
        	tag += '</ul>';
        	$("#nonEaFormList" + gubun + "_" + position).html(tag);
        	
        	return;
		}
		
		$.ajax({
			type: "post",
            url: "nonEaFormList.do",
            datatype: "json",
            data: tblParams,
            async: true,
            success: function (result) {
            	//console.log("결재양식 : \n" + JSON.stringify(result));
            	            	
            	var eaFormData = result.list;
            	var tag = '';
            	tag+='<ul>';
            	if(eaFormData.length == "0") {
            		tag += "<li><%=BizboxAMessage.getMessage("TX000001063","데이터가 없습니다.",(String) request.getAttribute("langCode"))%></li>";	
            			
            	} else {
            		for(var i=0; i<eaFormData.length; i++) {
            			tag += "<li name='nonEaForm' id='" + eaFormData[i].CODE + "'>";	
                		//tag += '<a onclick="fn_set(' + JSON.stringify(eaFormData[i]) + ')">' + eaFormData[i].formNm + '</a>';
                		tag += "<a href='#' title=\"" + escapeHtml(eaFormData[i].CODE_NM) + "\" onclick='formOpen_main(" + JSON.stringify(eaFormData[i]) + ")'>" + escapeHtml(eaFormData[i].CODE_NM) + "</a>";
                		tag += "</li>";	
            		}
            	}
            	
            	tag+='</ul>';
            	$("#nonEaFormList" + gubun + "_" + position).html(tag);
           	
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 양식을 가져오는데 오류가 발생했습니다.");
            	console.log("error:fnDrawNonEaFormPortlet() " + e);
            }
		});   
	}
		
	function formOpen_main (data) {
		var item = jQuery.parseJSON(JSON.stringify(data));
		var template_key = item.CODE;
		var formInfo = getFormDetailInfo(item.CODE);
		
		var C_CIKIND = formInfo.C_CIKIND;
		
		var intLeft = screen.width / 2 - intWidth / 2;
	    var intTop = screen.height / 2 - intHeight / 2 - 40;
		var intWidth  = formInfo.C_ISURLWIDTH;
		var intHeight = formInfo.C_ISURLHEIGHT;
		
		if(intWidth == "") {
			intWidth = "990";
		}
		
		if(intHeight == "") {
			intHeight = "990";
		}
		
		var target = "AppForm";
		if(formInfo.C_LNKCODE == "LNK001"){ /** 연동여부 ***/
			var obj = {
				template_key : template_key,
				c_cikind : C_CIKIND
		    };
				
		    var param = NeosUtil.makeParam(obj);
		    var dataParam = formInfo.C_URLPARAM || "";
		    var url = formInfo.C_TIREGISTPAGEURL + "?" + param + "&" + dataParam;
	        
		    if(formInfo.C_ISURLPOP == "1"){ // 팝업여부
		    	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop);
		    }else{
		    	document.location.href = url;
		    }
		}else if (formInfo.C_LNKCODE == "LNK002"){
				if (formInfo.C_TIREGISTPAGEURL != "") {
		        	/* interlock_url dp "?" 가 포함된 경우와 포함되지 않은 경우 처리 */
		     		var connector = (formInfo.C_TIREGISTPAGEURL.indexOf("?") < 0 ? "?" : "&");
		        	url = formInfo.C_TIREGISTPAGEURL + connector + "form_id=" + template_key + "&form_tp=" + formInfo.FORM_D_TP + "&doc_width=" + formInfo.C_ISURLWIDTH + "&eaType=ea";
		        	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop );
		        }else{
		    		var obj = {template_key : template_key};
		    		var param = NeosUtil.makeParam(obj);
		    		neosPopup('POP_DOCWRITE_MAIN', param) ;
		        }        
		}else{
			var obj = {template_key : template_key};
			var param = NeosUtil.makeParam(obj);
			neosPopup('POP_DOCWRITE_MAIN', param) ;
		}
		
	}
	
	function getFormDetailInfo(c_tikeycode){
		var data = {c_tikeycode : c_tikeycode};
		var result = {};
	    $.ajax({
	        type:"post",
	        url:'/ea/neos/edoc/eapproval/reportstoragebox/getFormInfo.do',
	        datatype:"json",
	        data : data,
	        async : false,
	        success:function(data){       
	        	result = data.result;
	        }   
	    });
	    return result;
	}
	
	// 비영리 전자결재 리스트
	function fnDrawNonEaListPortlet(data, position) {
		var gubun = "";	
		var writterFlag = false;
		var tblParams = {};
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "2") {
			gubun = "Center1";
		} else if(position == "3") {
			gubun = "Center2";
		} else if(position == "4") {
			gubun = "Right";
		} else if(position == "5") {
			gubun = "Top";
		}
		
		if(data.val2 == "Y") {
			writterFlag = true;
		} else {
			writterFlag = false;
		}
		
		if(data.val0[0] === "[") {
			var dataValue = JSON.parse(data.val0);
			dataValue.forEach(function(item){
				optionValue += item.menu_seq + ",";
			});
			tblParams.val0 = optionValue.slice(0,-1);
			
		} else {
			tblParams.val0 = data.val0;		
		}
		
		tblParams.val1 = data.val1;
		tblParams.iframe = "N";
		
		$.ajax({
			type: "post",
            url: "/ea/edoc/main/EaPortletCloudList.do",
            datatype: "json",
            data: tblParams,
            success: function (result) {
            	var eapPortletDocList = JSON.parse(result.EaPortletDocList);
            	var tag = '';
            	//console.log(JSON.stringify(eapPortletDocList));
            	if(eapPortletDocList.length == 0) {
            		tag += '<div class="main_nocon">';
            		tag += '<table>';
            		tag += '<tr>';
            		tag += '<td>';
            		tag += '<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
            		tag += '<br />';
            		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000008258","결재문서가 없습니다",(String) request.getAttribute("langCode"))%></span>';
            		tag += '</td>';
            		tag += '</tr>';
            		tag += '</table>';
            		tag += '</div>';            		
            	} else {
            		tag+='<ul>';	
            	
            		if(data.portletTp == "lr_ea_ea") {
            			for(var i=0; i<eapPortletDocList.length; i++) {
            				tag += '<li>';
            				
            				if(writterFlag){
                            	tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\');fnReadCheck(this);">[' + eapPortletDocList[i].empName + ']' + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';	
            				} else {
                            	tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';
            				}
            				/* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
                            if ((eapPortletDocList[i].READYN || '') == 'N') {
                                tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
                            }
            				
            				tag += '</li>';
            			}
            		} else {
            		
	            		/* [시작] */
	                	for(var i=0; i<eapPortletDocList.length; i++) {
	                		
	                		//삭제문서인 경우 미표시
	                		if(eapPortletDocList[i].docSts == "d"){
	    						continue;
	    					}

	                		tag += '<li>';
	                		tag += '<dl>';
	                	       /* [아이콘] */
	                        switch(eapPortletDocList[i].docSts) {
	                        	//미결
	                        	case '002' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결",(String) request.getAttribute("langCode"))%></dd>'
	                				break;
	                            //협조
	                            case '003' : tag += '<dd class="sign bg_orange"><%=BizboxAMessage.getMessage("TX000003976","미결",(String) request.getAttribute("langCode"))%></dd>'
	                       			break;  
                          		//기결
                          	    case '008' : tag += '<dd class="sign gray"><%=BizboxAMessage.getMessage("TX000004824","종결",(String) request.getAttribute("langCode"))%></dd>'
	                       			break;
                                //반려
                                case '007' : tag += '<dd class="sign bg_red2"><%=BizboxAMessage.getMessage("TX000002954","반려",(String) request.getAttribute("langCode"))%></dd>'
                           			break;
                                //회수
                                case '005' : tag += '<dd class="sign bg_darkgray"><%=BizboxAMessage.getMessage("TX000003999","회수",(String) request.getAttribute("langCode"))%></dd>'
                           			break;
                                //보류
                                case '004' : tag += '<dd class="sign bg_yellow2"><%=BizboxAMessage.getMessage("TX000003206","보류",(String) request.getAttribute("langCode"))%></dd>'
                                	break;
	                        	default :  '<dd class="sign gray"></dd>'
	                        		break;
	                        }
	                		
	                        /* [작성부서 기안자] 문서제목 [신규 아이콘] */
	                        tag += '<dt class="title2">';
	                        
	                        if(eapPortletDocList[i].emergencyFlag == "1") {
                    			tag += '<img src="/ea/Images/ico/ico_emergency.png" alt="긴급아이콘" style="float:left; padding-top: 5px; padding-right: 2px;" />';
                    		}
	                        
	                        if ((eapPortletDocList[i].docTitle || '') != '') {
	                            /* [작성부서 기안자] 문서제목 [신규아이콘] - [작성부서 기안자] 문서제목 */
	                        	if(writterFlag){
	                            	tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\');fnReadCheck(this);">[' + eapPortletDocList[i].empName + ']' + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';
	                        	} else {
	                        		tag += '<a href="#" title="' + escapeHtml(eapPortletDocList[i].docTitle) + '" onclick="fnEventDocTitleNon(\'' + eapPortletDocList[i].docId + '\');fnReadCheck(this);">' + escapeHtml(eapPortletDocList[i].docTitle) + '</a>';
	            				}
	                            /* [작성부서 기안자] 문서제목 [신규아이콘] -  [신규아이콘] */
	                            if ((eapPortletDocList[i].readYN || '') == 'N') {
	                                tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="new" name="newIconImage" />';
	                            }
	                        } else {
	                            tag += '';
	                        }
	                        tag += '</dt>';
	
	                        /* [첨부파일 아이콘] */
	                        tag += '<dd class="file">';
	                        if ((eapPortletDocList[i].attachCnt || '') > 0) {
	                            tag += '<img src="' + '<c:url value="/Images/ico/ico_file.png" />' + '" alt="첨부파일">';
	                        } else {
	                            tag += '';
	                        }
	                        tag += '</dd>';
	
	                        /* [기안일자] */
	                        tag += '<dd class="date">';
	                        if ((eapPortletDocList[i].repDt || '') != '') {
	                            tag += ncCom_Replace(ncCom_Date(eapPortletDocList[i].repDt.substr(0,8) , "SYMD"),".","-");
	                        } else {
	                            tag += '';
	                        }
	//                         alert(ncCom_Date(source.repDt, '.'));
	                        tag += '</dd>';
	
	                        /* [종료] */
	                        tag += '</dl>';
	                        
	                		tag += '</li>';
	                	}
                	}
            	}
            	
            	tag+='</ul>';
            	
            	$("#nonEaList" + gubun + "_" + position + "_" + data.sort).html(tag);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 리스트을 가져오는데 오류가 발생했습니다.");
            	console.log("error:fnDrawNonEaListPortlet() " + e);
            }
		
		});
	}
		
	   /* 이벤트 - 문서 타이틀 클릭 */
    function fnEventDocTitleNon( c_dikeycode ) {
    	var obj = {
    			diKeyCode : c_dikeycode
    			};
    	var param = NeosUtil.makeParam(obj);
    	
    	neosPopup("POP_ONE_DOCVIEW_MAIN", param);  
    }
	/* [END] 전자결재 */
	
	/* [start] 노트 */
	var specificDate = new Date(); 
	specificDate.setDate(specificDate.getDate() -7);
	
	function fnDrawNotePortlet(data, position) {
		var gubun = "";
		
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
	
		$.ajax({
		   type:"POST",
	       contentType: "application/json; charset=utf-8",
	       dataType: "json",
	       async: true,
	       url: '/schedule/WebNote/SearchNoteList',
	       data: JSON.stringify({"companyInfo":'', "deptSeq":'' , "empSeq":'', "langCode":'kr', "folderSeq":'', "sechText":''}),
	       success: function(result) {
	    	   
	    	   var noteData = result.result;
	    	   var tag = '';
	    	   
	    	   if(noteData.length == 0) {
	           		tag += '<div class="main_nocon">';
	        		tag += '<table>';
	        		tag += '<tr>';
	        		tag += '<td>';
	        		var url = "/Views/Common/note/noteList";	
	        		tag += "<a href=\"javascript:void(0);\" onclick=\"mainMove('NOTE', '" + url + "','')\"><%=BizboxAMessage.getMessage("TX000018942","노트등록",(String) request.getAttribute("langCode"))%></a>";
	        		tag += '<br />';
	        		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000015471","노트를 등록하세요.",(String) request.getAttribute("langCode"))%></span>';
	        		tag += '</td>';
	        		tag += '</tr>';
	        		tag += '</table>';
	        		tag += '</div>';	    		   
	    	   } else {
	    		   tag+='<ul>';
	    		   for(var i=0; i<noteData.length; i++) {
	  					tag += "<li><a title=\"" + noteData[i].noteTitle + "\" href=\"javascript:void(0);\" onclick=\"fnNotePop(" + noteData[i].noteSeq + ")\"><span class=\"txt\">" + noteData[i].noteTitle + "</span></a></li>";
	    		   }
	    		   tag+='</ul>';
	    	   }
				
				$("#notePortlet" + gubun + "_" + position).html(tag);
	       }, 
	       error:function(e) {
	    	   console.log('error:fnDrawNotePortlet() ' + e);
	       }
		});
	}
	
	// 노트 팝업
	function fnNotePop(noteSeq) {
		var url = "/schedule/Views/Common/note/noteList.do?noteSeq="+noteSeq;

  		openWindow2(url,  "pop", 1000, 711, "no", 1) ;
	}
	/* [END] 노트 */
	
	/* [start] 게시판 */
	function fnDrawBoardPortlet(data, position) {
		var tblParams = {};
		
		tblParams.boardNo = data.val0;
		tblParams.count = data.val2;
		$.ajax({
			type: "post",
			
	         url: 'boardPortlet.do',
	         datatype: "json",
	         data: tblParams,
	         async: true,
	         success: function (result) {
	        	//console.log(JSON.stringify(result));
	        	var boardParam = result.boardParams;
	        	fnDrawBoard(boardParam, data, position);
	         },
	         error: function (e) {   //error : function(xhr, status, error) {
	             //alert("error2");
	        	 console.log("error:fnDrawBoardPortlet() " + e);
	         }
		});
	}
	
    function fnDrawBoard(param, data, position) {
    	
    	var boardHeader = {};
    	var boardBody = {};
    	var boardCompany = {};
    	var gubun = '';
    	var searchEmpSeq = new Array();

    	if(position == '1') {
    	   gubun = 'Left';
    	}else if(position == '2') {
    	  gubun = 'Center1';
    	} else if(position == '3') {
    		gubun = 'Center2';
    	} else if(position == '4') {
    		gubun = 'Right';
    	} else if(position == '5') {
    		gubun = 'Top';
    	}
    	
    	boardHeader.groupSeq = param.header.groupSeq;
    	boardHeader.empSeq = param.header.empSeq;
    	boardHeader.tId = param.header.tId;
    	boardHeader.pId = param.header.pId;
    	
    	boardCompany.compSeq = param.body.companyInfo.compSeq;
    	boardCompany.bizSeq = param.body.companyInfo.bizSeq;
    	boardCompany.deptSeq = param.body.companyInfo.deptSeq;
    	
    	boardBody.companyInfo = boardCompany;
    	boardBody.langCode = param.body.langCode;
    	boardBody.loginId = param.body.loginId;
    	boardBody.boardNo = param.body.boardNo;
    	boardBody.searchEmpSeq = searchEmpSeq;
    	boardBody.searchField = param.body.searchField;
    	boardBody.searchValue = param.body.searchValue;
    	boardBody.currentPage = "1";
    	boardBody.countPerPage = parseInt(param.body.countPerPage);
    	boardBody.mobileReqDate = param.body.mobileReqDate;
    	boardBody.cat_remark = param.body.cat_remark;
    	boardBody.type = param.body.type;
    	boardBody.remark_no = param.body.remark_no;
    	boardBody.serverReq = "W";
    	
    	var total = {};
    	var url = "/edms/board/viewBoard.do";
    	
    	
    	//최근 게시글, 공지글 예외처리
    	if(data.val0 == "501030000")
    		url = "/edms/board/viewBoardNewArt.do";
    	else if(data.val0 == "501040000")
    		url = "/edms/board/viewBoardNewNotice.do";
    	
    	
    	total.header = boardHeader;
    	total.body = boardBody;
    	
    	//console.log(JSON.stringify(total));
    	
 		$.ajax({
			type: "post",
			contentType :"application/json;",
	         url: url,
	         datatype: "json",
	         data: JSON.stringify(total),
	         async: true,
	         success: function (result) {
	        	
	        	var tag = '';
	        	var boardList = JSON.parse(result)
	        	if(boardList.resultCode == "0") {
	        		var dataList = boardList.result.artList;
	        		
	        		if(dataList == undefined) {
	            		tag += '<div class="main_nocon">';
	            		tag += '<table>';
	            		tag += '<tr>';
	            		tag += '<td>';
	            		tag += '<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
	            		tag += '<br />';
	            		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000007731","등록된 글이 없습니다",(String) request.getAttribute("langCode"))%></span>';
	            		tag += '</td>';
	            		tag += '</tr>';
	            		tag += '</table>';
	            		tag += '</div>';
	        		} else {
	        			tag+='<ul>';
	        			for(var i=0; i<dataList.length; i++) {
	        				if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
	        					tag += '<li class="new" >';		
	        					
	        				} else {
	        					tag += '<li>';
	        				}
	        				
	        				if(dataList[i].replyCnt == "0") {
	        					tag += '<dl>';
	        					tag += '	<dt class="title2">';
	        					tag += "		<a title=\"" + escapeHtml(dataList[i].art_title) + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ");fnReadCheck(this);\">" + escapeHtml(dataList[i].art_title) + "</a>";	
	        					if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
	        						tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" name="newIconImage" />';
	        					}
	        					tag += '	</dt>';
	        					if(gubun !== "Left" && gubun !== "Right") {
	        						tag += '	<dd class="file">';
	        						if(dataList[i].add_file_yn == "Y"){
	        							tag += '	<img src="/gw/Images/ico/ico_file.png" alt="첨부파일">';
	        						}
	        						tag += '	</dd>';
	        						tag += '	<dd class="date">' + ncCom_Date(dataList[i].write_date.substr(0,8), "SYMD", "-") + '</dd>';		        						
	        					}
	        					tag += '</dl>';
	        				} else {
	        					tag += '<dl>';
	        					tag += '	<dt class="title2">';
	        					tag += "		<a title=\"" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnBoardPop(" + dataList[i].boardNo + ", " + dataList[i].artNo + ");fnReadCheck(this);\">" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "</a>";
	        					if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
	        						tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" name="newIconImage" />';
	        					}
	        					tag += '	</dt>';
	        					if(gubun !== "Left" && gubun !== "Right") {
	        						tag += '	<dd class="file">';
	        						if(dataList[i].add_file_yn == "Y"){
	        							tag += '	<img src="/gw/Images/ico/ico_file.png" alt="첨부파일">';
	        						}
	        						tag += '	</dd>';
	        						tag += '	<dd class="date">' + ncCom_Date(dataList[i].write_date.substr(0,8), "SYMD", "-") + '</dd>';
	        					}
	        					tag += '</dl>';
	        				}
	        				tag += '</li>';

	        			}
	        			tag+='</ul>';
	        		}
	        	} else {
	        		tag += '<ul><li>' + boardList.resultMessage + '</li></ul>';
	        	}
	        	$("#boardList" + gubun +"_" + position + "_" + data.sort).html(tag);
	         },
	         error: function (e) {   //error : function(xhr, status, error) {
	             //alert("error2");
	        	 console.log("error:fnDrawBoard()" + e);
	         }
		});
    }
 		
	// 게시판 팝업
	function fnBoardPop(catSeq, artSeq) {
		console.log(catSeq + "/" + artSeq);
		var url = "/edms/board/viewPost.do?boardNo="+catSeq+"&artNo="+artSeq;
		openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
	}
	         
	/* [END] 게시판 */
	
	/* [START] 문서 */
	/* 문서 데이터 Request 데이터 요청 */
	function fnDrawDocPortlet(data, position) {
		var tblParams = {};
		
		/*
		* docNo : 문서함 번호 
		* count : 문서 게시글 노출 갯수 
		* showAuthority : 문서 노출 권한
		*/
		tblParams.dir_cd = data.val0;
		tblParams.count = data.val2;
		tblParams.showAuthority = data.val4;
		tblParams.dir_lvl = data.val3;
		$.ajax({
			type: "post",
			url: "docPortlet.do",
			datatype: "json",
			data: tblParams,
			async: true,
			success: function(result) {
				var docParams = result.docParams;
				fnDrawDoc(docParams, data, position);
			},
			error: function(e) {
				console.log("error:fnDrawBoardPortlet() " + e);
			}
		});		
	}
	
	function fnDrawDoc(param, data, position) {
		
		var docHeader = {};
    	var docBody = {};
    	var docCompany = {};
    	var gubun = '';
    	var searchEmpSeq = new Array();
    	if(position == '1') {
    	   gubun = 'Left';
    	}else if(position == '2') {
    	  gubun = 'Center1';
    	} else if(position == '3') {
    		gubun = 'Center2';
    	} else if(position == '4') {
    		gubun = 'Right';
    	} else if(position == '5') {
    		gubun = 'Top';
    	}
    	
    	docHeader.groupSeq = param.header.groupSeq;
    	docHeader.empSeq = param.header.empSeq;
    	docHeader.tId = param.header.tId;
    	docHeader.pId = param.header.pId;
    	    	    	
    	docCompany.compSeq = param.body.companyInfo.compSeq;
    	docCompany.bizSeq = param.body.companyInfo.bizSeq;
    	docCompany.deptSeq = param.body.companyInfo.deptSeq;
    	
    	docBody.companyInfo = docCompany;
    	docBody.langCode = param.body.langCode;
    	docBody.loginId = param.body.loginId;
    	docBody.dir_cd = param.body.dir_cd;
    	docBody.dir_type = "W";
    	docBody.dir_lvl = param.body.dir_lvl;
    	docBody.searchEmpSeq = searchEmpSeq;
    	docBody.searchField = param.body.searchField;
    	docBody.searchValue = param.body.searchValue;
    	docBody.currentPage = "1";
    	docBody.countPerPage = parseInt(param.body.countPerPage);
    	docBody.mobileReqDate = param.body.mobileReqDate;
    	
    	var total = {};
    	var url = "/edms/doc/viewDocDir.do";
    	   	
    	total.header = docHeader;
    	total.body = docBody;
    	
 		$.ajax({
			type: "post",
			contentType :"application/json;",
	         url: url,
	         datatype: "json",
	         data: JSON.stringify(total),
	         async: true,
	         success: function (result) {
	        	         	 
	        	 var tag = '';
	        	 var docList = JSON.parse(result);
	        	 console.log(docList);
	        	 if(docList.result == "false") {
	        		 tag = "<ul><li><%=BizboxAMessage.getMessage("TX900000365","본 문서함에 대한 읽기 권한이 없습니다.",(String) request.getAttribute("langCode"))%></li></ul>";
	        		 $("#docList" + gubun +"_" + position + "_" + data.sort).prev().removeAttr("onclick");
	        		 console.log($("#docList" + gubun +"_" + position + "_" + data.sort).prev());
	        		 
	        	 }else if(docList.resultCode == "0") {
	        		var dataList = docList.result.artList;
	        		
	        		if(dataList == undefined) {
	            		tag += '<div class="main_nocon">';
	            		tag += '<table>';
	            		tag += '<tr>';
	            		tag += '<td>';
	            		tag += '<img src="' + '<c:url value="/Images/bg/survey_noimg.png" />' + '" alt="" />';
	            		tag += '<br />';
	            		tag += '<span class="txt"><%=BizboxAMessage.getMessage("TX000007731","등록된 글이 없습니다",(String) request.getAttribute("langCode"))%></span>';
	            		tag += '</td>';
	            		tag += '</tr>';
	            		tag += '</table>';
	            		tag += '</div>';
	        		} else {
	        			tag+='<ul>';
	        			for(var i=0; i<dataList.length; i++) {
	        				if(dataList[i].is_new_yn == "Y" && dataList[i].readYn == "N") {
	        					tag += '<li class="new" >';		
	        					tag += '<img src="' + '<c:url value="/Images/ico/icon_new.png" />' + '" alt="" name="newIconImage" />';
	        				} else {
	        					tag += '<li>';
	        				}
	        				if(dataList[i].replyCnt == "0") {
	        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + "\" href=\"javascript:void(0);\" onclick=\"fnDocPop('W', " + dataList[i].art_seq_no + ");fnReadCheck(this);\">" + escapeHtml(dataList[i].art_title) + "</a>";	
	        				} else {
	        					tag += "<a title=\"" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "\" href=\"javascript:void(0);\" onclick=\"fnDocPop('W', " + dataList[i].art_seq_no + ");fnReadCheck(this);\">" + escapeHtml(dataList[i].art_title) + " ( " + dataList[i].replyCnt + " ) " + "</a>";
	        				}
	        				
	        			}
	        			tag+='</ul>';
	        		}
	        	}
	      	        	 
	        	$("#docList" + gubun +"_" + position + "_" + data.sort).html(tag);
	        	 
	        	
	         },
	         error: function (e) {   //error : function(xhr, status, error) {
	             //alert("error2");
	        	 console.log("error:fnDrawBoard()" + e);
	         }
		});    	
	}
 		
	function fnDocPop(dir_type, art_seq_no) {
		var url = "/edms/doc/viewPost.do?artNo="+art_seq_no+"&dir_type="+dir_type;
		openWindow2(url,  "pop", 1200, 711,"yes", 1) ;
	}	
	/* [END] 문서 */
	
	/* [start] 날씨 */
	var langCode = "";
	var weatherCity = "";
	var cityNm = "";
	var sHeight = 0;
	
	function fnDrawWeatherPortlet(data, position, locationChangeFlag) {
		var gubun = "";
				
		if(position == "1") {
			gubun = "Left";
		} else if(position == "4") {
			gubun = "Right";
		}
		
		$.ajax({
			type: "post",
            url: "weather.do",
            datatype: "json",
            async:false,
            success: function (result) {
            	sHeight = result.sHeight;
            	weatherCity = result.weatherCity;
            	cityNm = result.cityName;
            	langCode = result.langCode;
            	fnResizeWeather(sHeight);
            },
            error: function (e) {   //error : function(xhr, status, error) {
                //alert("전자결재 현황을 가져오는데 오류가 발생했습니다.");
            }
		})
		
	    fnGetWeatherInfo(locationChangeFlag);
	}
		
	function fnResizeWeather(data) {
		if(data != "" && data != "0"){
			var data = ((data / 2) - 80 + 13) + "px";	
			//$("#marginID").css({'margin-top':data});
		}
	}
	
	function fnGetWeatherMultiLang(sky, pty) {
		//sky: 하늘상태(1: 맑음, 2: 구름조금, 3: 구름많음, 4: 흐림)
		//pty: 강수형태(0: 강수없음, 1: 비, 2: 비/눈, 3: 눈)		
		if(pty != 0) {
			// 소나기가 추가되어 소나기일 경우 1번인 비로 맵핑
			// 빗방울, 빗방울/눈날림, 눈날림의 겨우 기존 이미지에 맵핑
			if(pty == 4 || pty == 5){
				pty = 1;
			} else if(pty == 6) {
				pty = 2;
			} else if(pty == 7) {
				pty = 3;
			} else if(pty > 7) {
				pty = 0;
			}
			return WeatherJson[Number(pty) + 6];
		}
		
		var curHour = new Date().getHours();
		
		if(curHour < 18 || sky == "4"){
			return WeatherJson[Number(sky) - 1];
		}else{
			return WeatherJson[Number(sky) + 3];
		}		
	}
	
	function checkWeatherStorage(locationChangeFlag){	
		var data = JSON.parse(sessionStorage.getItem("bizWeather"));
		
		if(data.header == "00" && locationChangeFlag != true){
			//var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];
			var dateObj = new Date();
			var nowDate = dateObj.getDate();
			var reqDate = new Date(data.reqDate).getDate();
							
			var nowTime = dateObj.getHours().toString() + dateObj.getMinutes().toString();
		    var baseTime = null;
		    
		    /*
		    for(var i = baseTimes.length - 1; i >= 0; i--) {
		    	var baseTimeDateObj = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), baseTimes[i].substring(0, 2), baseTimes[i].substring(2, 4));
		    	//console.log(_date.getTime() - baseTimeDateObj.getTime());
		    	
		    	if(dateObj.getTime() - baseTimeDateObj.getTime() > 0) {
		    		baseTime = baseTimes[i - 1]
		    		break;
		    	}
		    }
		    */
		   
		    var nowTime = '';
		    
		    if(dateObj.getMinutes() > 30) {
		    	var nowHour = dateObj.getHours() < 10 ? "0" + dateObj.getHours().toString() : dateObj.getHours().toString();
		    	nowTime = nowHour + "30";
		    } else {
		    	var nowHour = dateObj.getHours() - 1 < 10 ? "0" + (dateObj.getHours() - 1).toString() : (dateObj.getHours() - 1).toString();
		    	nowTime = nowHour + "30";
		    }
		    		    
		 	// 기상청 API 요청 날짜와 요청 시간이 같으면 기상청 API를 요청하지 않는다.
            if(nowDate !== reqDate || data.baseTime !== nowTime) {
            	return true;                
            } else {
                return false;
            }
		    
		    // 기상청 API 요청 날짜와 요청 시간이 같으면 기상청 API를 요청하지 않는다.
		    /*
		    if(nowDate == reqDate && baseTime == data.baseTime) {
		    	return false;
		    } else {
		    	return true;
		    }
			*/
		}
		return true;
	}
	
	function fnGetWeatherDetailInfo(getItemNm, weatherArray){
		var _data;		
		weatherArray.forEach(function(item){
			if(item.category == getItemNm){
				_data = item.fcstValue;
			}
		});
		
		return _data;
	}
	
	// 날씨정보 가져오기
	function fnGetWeatherInfo(locationChangeFlag) {
		var _date;
		var baseTime;
		var requestParam;
		var resultJson;
		
		//세션 스토리지 확인
		if(sessionStorage.getItem("bizWeather") == null || checkWeatherStorage(locationChangeFlag)) {
			
			if(weatherCity == "null" || cityNm == "null"){
		    	weatherCity = "60,127"; // 기본값 서울(woeid)
		    	cityNm = "<%=BizboxAMessage.getMessage("TX000011881","서울")%>";
		    }
			
			_date = new Date();
			var baseTimes = ["0210","0510","0810","1110","1410","1710","2010","2310"];	
		    var nowTime = _date.getHours().toString() + _date.getMinutes().toString();
		    var baseTime = null;
		    
		    /*
		    for(var i = baseTimes.length - 1; i >= 0; i--) {
		    	var baseTimeDateObj = new Date(_date.getFullYear(), _date.getMonth(), _date.getDate(), baseTimes[i].substring(0, 2), baseTimes[i].substring(2, 4));
		    	//console.log(_date.getTime() - baseTimeDateObj.getTime());
		    	
		    	if(_date.getTime() - baseTimeDateObj.getTime() > 0) {
		    		baseTime = baseTimes[i - 1]
		    		break;
		    	}
		    }
		    */
		    
		    //console.log(baseTime);			
		    
		    if(_date.getMinutes() < 30) {
		    	if(_date.getHours() - 1 < 10){
		    		baseTime = "0" + (_date.getHours() - 1).toString() + "30";
		    	} else {
		    		baseTime = (_date.getHours() - 1).toString() + "30";
		    	}			    	
		    } else {
		    	if(_date.getHours() < 10) {
		    		baseTime = "0" + (_date.getHours() - 1).toString() + "30";
		    	} else {
		    		baseTime = _date.getHours().toString() + "30";	
		    	}
		    }
		    
			requestParam = {
				baseDate: new Date().toISOString().slice(0,10).replace(/-/gi,""),
				baseTime: baseTime,
				location: weatherCity
			}
						
			$.ajax({
				url: "cmm/systemx/weather/getWeather.do",
				type: "POST",
				data: requestParam,
				dataType: "json",
				success: function(_data){
					var data = _data.result.response;
					if(data.header.resultCode == "00") {
						
						var pty = [];
						var sky = [];
						var t1h = [];
						
						data.body.items.item.forEach(function(item){
							if(item.category == "PTY") {
								pty.push(item);
							} else if(item.category == "SKY") {
								sky.push(item);
							} else if(item.category == "T1H") {
								t1h.push(item);
							}
						});
						
						resultJson = {
							header: data.header.resultCode,
							headerMsg: data.header.resultMsg,
							baseDate: data.body.items.item[0].baseDate,
							baseTime: baseTime,
							fcstTime: data.body.items.item[0].fcstTime,
							pty: pty[0].fcstValue,
							sky: sky[0].fcstValue,
							t1h: t1h[0].fcstValue,
							reqDate: new Date(),
							multi: { "img": '36.png', "kr": '맑음', "en": 'sunny', "jp": '晴れ', "cn": '', "gb": '晴' }
						};
						resultJson.multi = fnGetWeatherMultiLang(resultJson.sky, resultJson.pty);
					}else{
						resultJson = {
							header: data.header.resultCode,
							headerMsg: data.header.resultMsg
						}
					}
					//console.log(resultJson)
					sessionStorage.setItem("bizWeather", JSON.stringify(resultJson));
					fnSetWeatherInfo(resultJson);
				},
				error: function(data){
					_date = new Date();
					resultJson = {
						header: "30",	
						headerMsg: '<%=BizboxAMessage.getMessage("TX000003199","접속이 원활하지 않습니다.",(String) request.getAttribute("langCode"))%>'
					};					
					fnSetWeatherInfo(resultJson);
				}
			});
			
		}else{
			fnSetWeatherInfo();
		}
		
        $("#viewLoading").hide();
	}
	
	function fnConvertWeatherNm(multi) {	    
	    switch (langCode) {
	        case 'kr':
	            return multi.kr;
	            break;
	        case 'jp':
	            return multi.jp;
	            break;
	        case 'en':
	            return multi.en;
	            break;
	        case 'cn':
	            return multi.cn;
	            break;
	        case 'gb':
	            return multi.gb;
	            break;
	        default:
	            return multi.kr;
	    }
	}


	//날씨정보 setting
	function fnSetWeatherInfo(resultJson) {
		
		if(!resultJson) {
			resultJson = JSON.parse(sessionStorage.getItem("bizWeather"));
		}
				
		var imgUrl = "<c:url value='/Images/UC/weather_source/' />";
		if (resultJson != null && resultJson.header == "00") {
	        $("#imgWeather").attr("src", imgUrl + resultJson.multi.img);
	        $("#ltTempC").text(resultJson.t1h + "℃");
	        $("#ltCondition").text(fnConvertWeatherNm(resultJson.multi));
	        $("#ltWeatherCityNm").html(cityNm);
	        
	        sessionStorage.removeItem("bizWeather");
	       	sessionStorage.setItem("bizWeather", JSON.stringify(resultJson));
	    }else{
	    	var storageBeforWeather = JSON.parse(sessionStorage.getItem("bizWeather"));
	    	
	    	// 세션스토리지에 이전 날씨 정상적인 정보가 있으면 이전 날씨 정보를 보여준다. 
	    	if((storageBeforWeather !== undefined || storageBeforWeather !== "" || storageBeforWeather !== null) && storageBeforWeather.header === "00") {
		    	$("#imgWeather").attr("src", imgUrl + storageBeforWeather.multi.img);
			    $("#ltTempC").text(storageBeforWeather.t1h + "℃");
			    $("#ltCondition").text(fnConvertWeatherNm(storageBeforWeather.multi));
			    $("#ltWeatherCityNm").html(cityNm);
	    	} else {
	    		// 세션스토리지에 이전 날씨 오류 정보가 있으면 오류 날씨 이미지를 보여준다.
	    		$("#imgWeather").attr("src", imgUrl + "25.png");
	    	}
	    	fnSetWeatherError(resultJson);
	    	$("#ltCondition").css("max-width","80px");
	    	
	    }
		$("#weather0").hide();
		$("#weather1").show();	   
	}
	
	/* 로컬스토리지에 에러 로그 저장 */
	function fnSetWeatherError(resultJson) {
		var result = resultJson;
		result["nowDate"] = new Date();
		sessionStorage.setItem("bizWeatherError", JSON.stringify(result));
	}
	
	/* [END] 날씨 */
	
	function fnDrawMainPortal() {
		var portletData = ${portletListJson};
		
		for(var i=0; i<portletData.length; i++) {
			if(portletData[i].portletTp == "lr_user") {
				fnDrawMyInfo(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_ea_count") {
				if(!checkUserPortletAuth(2000000000))	continue;		//메뉴권한이 없을 경우 처리 - 결재현황(영리)
				fnDrawEaCount(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_em_count") {
				if(!checkUserPortletAuth(200000000))	continue;		//메뉴권한이 없을 경우 처리 - 메일현황
				fnDrawEmCount(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_nb" || portletData[i].portletTp == "cn_nb" || portletData[i].portletTp == "top_nb") {
				if(!checkUserPortletAuth(501000000))	continue;		//메뉴권한이 없을 경우 처리 - 게시판
				fnDrawBoardPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_em" || portletData[i].portletTp == "cn_em" || portletData[i].portletTp == "top_em") {
				if(!checkUserPortletAuth(200000000))	continue;		//메뉴권한이 없을 경우 처리 - 받은편지함
				fnDrawEmailListPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_ea" || portletData[i].portletTp == "cn_ea" || portletData[i].portletTp == "top_ea") {
				if(!checkUserPortletAuth(2000000000))	continue;		//메뉴권한이 없을 경우 처리 - 전자결재(영리)
 				fnDrawEaListPortlet(portletData[i], portletData[i].position);
 			} else if(portletData[i].portletTp == "lr_so") {
				fnDrawSchedulePortlet(portletData[i], portletData[i].position);
 			} else if(portletData[i].portletTp == "lr_no") {
 				if(!checkUserPortletAuth(303010000))	continue;		//메뉴권한이 없을 경우 처리 - 노트
 				fnDrawNotePortlet(portletData[i], portletData[i].position);
 			} else if(portletData[i].portletTp == "lr_form") {
 				if(!checkUserPortletAuth(2001010000))	continue;		//메뉴권한이 없을 경우 처리 - 결재양식(영리)
 				fnDrawEaFormPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_weather") {
 				fnDrawWeatherPortlet(portletData[i], portletData[i].position, false);
 			} else if(portletData[i].portletTp == "lr_ea_form") {
 				if(!checkUserPortletAuth(101010000))	continue;		//메뉴권한이 없을 경우 처리 - 결재양식(비영리)
 				fnDrawNonEaFormPortlet(portletData[i], portletData[i].position);
 			} else if((portletData[i].portletTp == "cn_ea_ea" || portletData[i].portletTp == "top_ea_ea" || portletData[i].portletTp == "lr_ea_ea") && portletData[i].iframeYn == "N") {
 				if(!checkUserPortletAuth(100000000))	continue;		//메뉴권한이 없을 경우 처리 - 전자결재(비영리)
 				fnDrawNonEaListPortlet(portletData[i], portletData[i].position);
 			} else if(portletData[i].portletTp == "lr_ea_ea_count") {
 				if(!checkUserPortletAuth(100000000))	continue;		//메뉴권한이 없을 경우 처리 - 결재현황(비영리)
 				fnDrawNonEaCount(portletData[i], portletData[i].position);
 			} else if(portletData[i].portletTp == "lr_alert") {
 				fnDrawAlertPortlet();
 			} else if(portletData[i].portletTp == "lr_doc" || portletData[i].portletTp == "cn_doc" || portletData[i].portletTp == "top_doc") {
 				if(!checkUserPortletAuth(601000000))	continue;		//메뉴권한이 없을 경우 처리 - 문서
 				fnDrawDocPortlet(portletData[i], portletData[i].position);
 			}
		}
	}
	
	
	function fnDrawAlertPortlet(){
		
		if(alMoreYn == "Y" || mtMoreYn == "Y"){		
			var tblParam = {};
			tblParam.alMoreYn  = alMoreYn;
			tblParam.mtMoreYn  = mtMoreYn;
			tblParam.timeSp = timeSp;
			tblParam.mentionTimeSp  = mentionTimeSp ;
			
			$.ajax({ 
				type:"POST",
				url: '<c:url value="/getAlertList.do"/>',
				datatype:"json",	
				data: tblParam,
				success:function(data){		
					if(data.alertList != null){
						setAlertPortlet(data.alertList.result, "alertListTag");
						alMoreYn = data.alertList.result.moreYn;
						timeSp = data.alertList.result.timeStamp;
					}
					if(data.mentionList != null){
						setAlertPortlet(data.mentionList.result, "mentionListTag");
						mtMoreYn = data.mentionList.result.moreYn;
						mentionTimeSp = data.mentionList.result.timeStamp;
					}
					setAlertPortletEvent();
				}  
			});
		}
	}
	
	function setAlertPortletEvent(){
		$(".list_con").each(function(){
			var innerContents = $(this).html();	
			for(;;){
				if(innerContents.indexOf("|&gt;@") != -1 && innerContents.indexOf("@&lt;|") != -1){
					var name = innerContents.substring(innerContents.indexOf(",name=")+7, innerContents.indexOf("@&lt;|")-1);
					var empSeq = innerContents.substring(innerContents.indexOf("|&gt;@empseq=")+14, innerContents.indexOf(",name=")-1);
					if(empSeq == "${loginVO.uniqId}"){
						innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span style="color:#00b97a;">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
					}else{
						innerContents = innerContents.slice(0,innerContents.indexOf("|&gt;@")) + '<span class="mt_marking">' + name + '</span>' + innerContents.slice(innerContents.indexOf("@&lt;|")+6);
					}
				}
				else{					
					break;
				}
			}
			$(this).html(innerContents);
		});
		
		
		//알림탭
    	$(".alert_portlet_tab li").on("click",function(){
    		var mapClass = $(this).children().attr("class");
    		
    		$(".alert_portlet_tab li").removeClass('on');
	   		$(this).addClass('on');
	   		$(".tabCon_portlet").hide();
	   		$("." + "_" + mapClass).removeClass("animated1s fadeInDown").toggleClass("animated1s fadeInDown").show();
    	});
    				
		//컨텐츠를 클릭할때(컨텐츠에 타이틀도 포함)
		$(".list_con").on("click",function(){
			$(this).parent().removeClass("unread");
		});
		
		//접고 펼치기
		$(".toggle_portlet_btn").on("click",function(){
			$(this).toggleClass("down");
			$(this).parent().parent().find(".sub_portlet_detail").removeClass("animated1s fadeIn").toggleClass("animated1s fadeIn").toggle();
			
			//멘션 접고 펼치기
			if($(this).hasClass("down")){
				$(this).parent().parent().find(".mention_portlet_detail").removeClass("ellipsis").toggleClass("animated1s fadeIn");
			}else{
				$(this).parent().parent().find(".mention_portlet_detail").removeClass("animated1s fadeIn").toggleClass("ellipsis");
			}
		});
		
		// 알림 스크롤 이벤트
		$(".mention_alert_box .m_mentionCon").scroll(function(){
			$(".tag_date").css("top",$(this).scrollTop()+10);				
			TagInAm();			
		});

		//스크롤 끝나면 이벤트
		$(".mention_alert_box .m_mentionCon").scrollEnd(function(){
			TagOutAm();
			alert("123");
		},1000);
	}
	
	function setAlertPortlet(alertInfo, target){
		var today = getTodayDate();
		var checkDate = "";
		var checkCnt = 0;
		
		var alertList = alertInfo.alertList;
		var innerHtml = "";
		
		var newCnt = 0;
		
		for(var i=0; i<alertList.length; i++){
			var alertDate = alertList[i].createDate.substring(0, 8);
			var displayDate = alertDate.substring(4,6) + "." + alertDate.substring(6,8) 

			if(alertDate != checkDate){
				checkDate = alertDate;
				if(today == alertDate){
					innerHtml += '<li class="dayline today"><span><%=BizboxAMessage.getMessage("TX000003149","오늘",(String) request.getAttribute("langCode"))%></span>' + displayDate + ' ' + getWeekDay(alertDate) + '</li>';
				}else{
					innerHtml += '<li class="dayline"><span>' + displayDate + '</span>' + getWeekDay(alertDate) + '</li>';
				}
				
			}
			
			if(alertList[i].readDate == null || alertList[i].readDate == ""){
				innerHtml += '<li class="unread">';
				newCnt++;
			}else{
				innerHtml += '<li class="">';
			}
			
			if(alertList[i].eventType == "TALK" || alertList[i].eventType == "MESSAGE"){
				innerHtml += '<div class="pic_wrap">';
				innerHtml += '<div class="pic"></div>';
				innerHtml += '<div class="div_img">';					
				innerHtml += '<img src="${profilePath}/' + alertList[i].senderSeq + '_thum.jpg" onerror="this.src=\'/gw/Images/bg/mypage_noimg.png\'" >';
				innerHtml += '</div>';
				innerHtml += '</div>';				
			}else if(alertList[i].eventType == "PROJECT"){
				innerHtml += '<div class="icon sc"></div>';
			}else if(alertList[i].eventType == "MAIL"){
				innerHtml += '<div class="icon mail"></div>';
			}else if(alertList[i].eventType == "RESOURCE"){
				innerHtml += '<div class="icon sc"></div>';
			}else if(alertList[i].eventType == "REPORT"){
				innerHtml += '<div class="icon wkr"></div>';
			}else if(alertList[i].eventType == "EAPPROVAL"){
				innerHtml += '<div class="icon ea"></div>';
			}else if(alertList[i].eventType == "BOARD"){
				innerHtml += '<div class="icon bd"></div>';
			}else if(alertList[i].eventType == "EDMS"){
				innerHtml += '<div class="icon dc"></div>';
			}else if(alertList[i].eventType == "ATTEND"){
				innerHtml += '<div class="icon dc"></div>';
			}else if(alertList[i].eventType == "SCHEDULE"){
				innerHtml += '<div class="icon sc"></div>';
			}else if(alertList[i].eventType == "FAX"){
				innerHtml += '<div class="icon fax"></div>';
			}else if(alertList[i].eventSubType == "GW001"){
				innerHtml += '<div class="icon pass"></div>';
			}else if(alertList[i].eventType == "ONEFFICE"){
				innerHtml += '<div class="icon of"></div>';
			}else if(alertList[i].eventType == "CUST"){
				innerHtml += '<div class="icon" style="background: url(/upload/img/custAlertIcon/' + alertList[i].eventType + '_' + alertList[i].eventSubType + '.png)"></div>';
			}
			
			if(alertList[i].webActionType != null && alertList[i].webActionType == "C"){
				innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("","바로가기 링크를 제공하지 않습니다.",(String) request.getAttribute("langCode"))%>\');" data=\'' + alertList[i].data + '\'>';
			}else if(alertList[i].eventType != "MAIL"){			
				
				var alertData = JSON.parse(alertList[i].data); 
				if(alertList[i].eventType == "EAPPROVAL" && alertData.mobileViewYn == "N") {
					//비영리 전자결재 문서리스트 중 mobileViewYn값이 N이면 문서를 열람할 수 없다. 
					innerHtml += '<div class="list_con" onclick="alert(\'<%=BizboxAMessage.getMessage("TX900000350","바로가기 링크를 제공하지 않습니다.",(String) request.getAttribute("langCode"))%>\');" data=\'' + alertList[i].data + '\'>';						
				} else {
					innerHtml += '<div class="list_con" onclick="forwardPageByAlert(\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\',\'' + alertList[i].eventType + '\',\'' + alertList[i].eventSubType + '\',\'' + alertList[i].senderSeq + '\', this);" data=\'' + alertList[i].data + '\'>';
				}			
				
			}else{
				innerHtml += '<div class="list_con" onclick="fnMailMove(\'' + alertList[i].mailUid + '\',\'' + alertList[i].email + '\',\'' + alertList[i].url + '\',\'' + alertList[i].alertId + '\')" data=\'' + alertList[i].data + '\'>';
			}
			innerHtml += '<a href="#n" onclick="return false;" class="title" title="' + alertList[i].message.alertTitle + '">' + alertList[i].message.alertTitle + '</a>';
			innerHtml += '<dl>';
			innerHtml += getAlertContentsHtml(alertList[i], target);
			innerHtml += '</dl></div>';
			
			innerHtml += '<div class="list_fn">';
			innerHtml += '<span class="date">10:36</span>';
			if(checkEventType(alertList[i].eventType, alertList[i].eventSubType)){
				innerHtml += '<a href="#n" onclick="return false;" class="toggle_portlet_btn"></a>';
			}
			innerHtml += '</div>';
			innerHtml += '</li>';
		}
		$("#" + target).append(innerHtml);
		
		
		if(target == "alertListTag" && newCnt > 0){
			$("#alertNewIcon").addClass("new");
		}else if(target == "mentionListTag" && newCnt > 0){
			$("#mentionNewIcon").addClass("new");
		}
	}
	
	function checkEventType(eventType, eventSubType){
		if(eventType == "TALK" || eventType == "MESSAGE"){		
			return true;
		}else{
			if(eventSubType == "MA001" || eventSubType == "BO002" ||eventSubType == "BO001" ||eventSubType == "ED001" ||eventSubType == "EA101" ||eventSubType == "RP003" ||eventSubType == "RP002" ||eventSubType == "RP001" ||eventSubType == "RS001" ||eventSubType == "SC001" ||eventSubType == "PR013" ||eventSubType == "PR011" ||eventSubType == "PR001"){
				return true;
			}else{
				return false;	
			}			
		}
		
	}
	
	
	function getAlertContentsHtml(alertInfo, target){
		var data = JSON.parse(alertInfo.data);
		var eventType = alertInfo.eventType;
		var eventSubType = alertInfo.eventSubType;
		var alertId = alertInfo.alertId;
		var tag = "";
		
		
		if(eventType == "TALK" || eventType == "MESSAGE"){			
			tag += '<dd class="mention_portlet_detail ellipsis">';
		}
		else{
			tag += '<dt>' + alertInfo.message.alertContent + '</dt>';
			tag += '<dd class="sub_portlet_detail">';
		}
		
		if(eventSubType == "PR001"){
			tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.prjDays)+')' + '<br>';			
			tag += 'PM : '+isNull(data.pmEmpName)+' '+isNull(data.pmPositionName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률",(String) request.getAttribute("langCode"))%> : '+isNull(data.processRate)+ '<br>';
			tag += isNull(data.prjStatus)+ '<br>';
			tag += isNull(data.dcRmk)+ '<br>';
		}else if(eventSubType == "PR011"){
			tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명",(String) request.getAttribute("langCode"))%> : '+isNull(data.prjName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.workDays)+')'+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000000329","담당자",(String) request.getAttribute("langCode"))%> : '+isNull(data.ownerEmpName)+' '+isNull(data.ownerDutyName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률",(String) request.getAttribute("langCode"))%> : '+isNull(data.processRate)+isNull(data.workStatus)+ '<br>';
			tag += isNull(data.contents);
		}else if(eventSubType == "PR013"){
			tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명",(String) request.getAttribute("langCode"))%> : '+isNull(data.prjName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000012430","업무명",(String) request.getAttribute("langCode"))%> : '+isNull(data.workName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000015246","기간/일수",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+' ('+isNull(data.jobDays)+')'+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000000329","담당자",(String) request.getAttribute("langCode"))%> : '+isNull(data.ownerJobedEmpName)+isNull(data.ownerJobedDutyName)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000006753","진행률",(String) request.getAttribute("langCode"))%> : '+isNull(data.processRate)+isNull(data.jobStatus)+ '<br>';
			tag += isNull(data.contents);
		}else if(eventSubType == "SC001"){

			tag += '<%=BizboxAMessage.getMessage("TX000000720","참여자",(String) request.getAttribute("langCode"))%> : ';
			
			if(data.schUserList != null){
				var eList = data.schUserList;
				var schUserList = "";
				for(var k=0; k<eList.length; k++) {
					if(k > 0){
						schUserList += ', ';
					}
					schUserList += eList[k].empName + " " + eList[k].dutyName;
				}
				
				tag += schUserList+ '<br>';
			}
			else{
				tag += '<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>'+ '<br>';
			}
			
			tag += '<%=BizboxAMessage.getMessage("TX000007571","일시",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000000752","장소",(String) request.getAttribute("langCode"))%> : '+isNull(data.schPlace)+ '<br>';
			
			tag += '<%=BizboxAMessage.getMessage("TX000012112","자원",(String) request.getAttribute("langCode"))%> : ';
			if(data.resList != null){
				var rList = data.resList;
				var resList = "";
				for(var l=0; l<rList.length; l++) {
					if(l > 0){
						resList += "<br>";
					}
					resList += isNull(rList[l].resName);
				}
				
				tag += resList+ '<br>';
			}
			else{
				tag += '<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>'+ '<br>';
			}
			
			tag += isNull(data.contents);
		}else if(eventSubType == "RS001"){
			tag += '<%=BizboxAMessage.getMessage("TX000000286","사용자",(String) request.getAttribute("langCode"))%> : ';
			
			if(data.resUserList != null){
				var uList = data.resUserList;
				var userList = "";
				for(var l=0; l<uList.length; l++) {
					if(l > 0){
						userList += ", ";
					}
					userList += isNull(uList[l].empName);
				}
				
				tag += userList+ '<br>';
			}
			else{
				tag += '<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>'+ '<br>';
			}
			tag += '<%=BizboxAMessage.getMessage("TX000012157","예약기간",(String) request.getAttribute("langCode"))%> : '+isNull(data.startDate)+' ~ '+isNull(data.endDate)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000012088","자원명",(String) request.getAttribute("langCode"))%> : '+isNull(data.resName)+ '<br>';
			tag += isNull(data.contents);
		}else if(eventSubType == "RP001"){
			tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportDate)+ '<br>';
			
			tag += '<%=BizboxAMessage.getMessage("TX000006607","주요일정",(String) request.getAttribute("langCode"))%> : ';
			if(data.majorSchedules != null){
				var msList = data.majorSchedules;
				var majorSchedules = "";
				for(var k=0; k<msList.length; k++) {
					majorSchedules += msList[k].content;
				}
				
				tag += majorSchedules+ '<br>';
			}
			else{
				tag += '<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>'+ '<br>';
			}

			tag += '<%=BizboxAMessage.getMessage("TX000000672","주요업무",(String) request.getAttribute("langCode"))%> : ';
			if(data.majorWorks != null){
				var mwList = data.majorWorks;
				var majorWorks = "";
				for(var l=0; l<mwList.length; l++) {
					majorWorks += mwList[l].content;
				}
				
				tag += majorWorks+ '<br>';
			}
			else{
				tag += '<%=BizboxAMessage.getMessage("TX000001232","없음",(String) request.getAttribute("langCode"))%>'+ '<br>';
			}
		}else if(eventSubType == "RP002"){
			tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportDate)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000006610","보고사항",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportContent)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000002910","특이사항",(String) request.getAttribute("langCode"))%> : '+isNull(data.note)+ '<br>';
		}else if(eventSubType == "RP003"){
			tag += '<%=BizboxAMessage.getMessage("TX000000802","보고일자",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportDate)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000006610","보고사항",(String) request.getAttribute("langCode"))%> : '+isNull(data.reportContent)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000002910","특이사항",(String) request.getAttribute("langCode"))%> : '+isNull(data.note)+ '<br>';
		}else if(eventSubType == "EA101"){
			if(isNull(data.doc_no) != ""){
				tag += '<%=BizboxAMessage.getMessage("TX000018380","품의번호",(String) request.getAttribute("langCode"))%> : '+isNull(data.doc_no)+ '<br>';
			}
			tag += '<%=BizboxAMessage.getMessage("TX000000665","작성일자",(String) request.getAttribute("langCode"))%> : ('+isNull(data.created_dt)+')'+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000000499","기안자",(String) request.getAttribute("langCode"))%> : '+isNull(data.userName)+ '<br>';
			tag += isNull(data.contents);
		}else if(eventSubType == "ED001"){
			tag += '<%=BizboxAMessage.getMessage("TX000000663","문서번호",(String) request.getAttribute("langCode"))%> : '+isNull(data.artNm)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX900000354","작성자 : ",(String) request.getAttribute("langCode"))%>'+isNull(data.senderName);
			tag += isNull(data.empNo_v)+' '+isNull(data.posCd_v)+ '<br>';
			tag += '<%=BizboxAMessage.getMessage("TX000000756","업무분류",(String) request.getAttribute("langCode"))%> : '+isNull(data.dir_cd)+ '<br>';
		}else if(eventSubType == "BO001"){
			tag += isNull(data.content);
		}else if(eventSubType == "BO002"){
			tag += '<%=BizboxAMessage.getMessage("TX000000352","프로젝트명",(String) request.getAttribute("langCode"))%> : '+isNull(data.project_name)+ '<br>';
			tag += isNull(data.content);
		}else if(eventSubType == "MA001"){
			tag += '<%=BizboxAMessage.getMessage("TX000001641","보낸사람",(String) request.getAttribute("langCode"))%> : '+isNull(data.sendName)+'('+isNull(data.sendEmail)+')'+ '<br>';
			tag += isNull(data.content);
		}else if(eventType == "TALK" || eventType == "MESSAGE"){
			tag += alertInfo.message.alertContent;		
		}
		
		tag += '</dd>';
		
		return tag;
	}
	
	//null값 체크(''공백 반환)
	function isNull(obj){
		return (typeof obj != "undefined" && obj != null) ? obj : "";
	}
	
	
	function getWeekDay(date){
		var week = new Array('<%=BizboxAMessage.getMessage("TX000006545","일요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006546","월요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006547","화요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006548","수요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006549","목요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000006550","금요일",(String) request.getAttribute("langCode"))%>', '<%=BizboxAMessage.getMessage("TX000000821","토요일",(String) request.getAttribute("langCode"))%>'); 
		var year = date.substr(0,4);
		var month = date.substr(4,2);
		var day = date.substr(6,2);	
		
		var dateTime = year + "-" + month + "-" + day;
		
		var varDate = new Date(dateTime);  // date로 변경
		
		return week[varDate.getDay()];
	}
	
	function getTodayDate(){
		var date = new Date(); 
		var year = date.getFullYear();
		var month = new String(date.getMonth()+1);
		var day = new String(date.getDate()); 
		// 한자리수일 경우 0을 채워준다. 
		if(month.length == 1)
		  month = "0" + month; 

		if(day.length == 1)
		  day = "0" + day; 
		var toDay = year + "" + month + "" + day;
		return toDay;
	}
	
	
	function refleshPortlet(){
		$.ajax({
			type:"post",
		    url: _g_contextPath_ + "/getPortletList.do",
		    async: false,
		    dataType: 'json',
		    success: function(data) { 
		    	drawMainPortlet(data.portletList);
		    },
		    error: function(xhr) { 
		      console.log('FAIL : ', xhr);
		    }
	   });
	}
	
	
	function drawMainPortlet(data){
	
		var portletData = data;	
		for(var i=0; i<portletData.length; i++) {
			if(portletData[i].portletTp == "lr_user") {
				fnDrawMyInfo(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_ea_count") {
				fnDrawEaCount(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_em_count") {
				fnDrawEmCount(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_nb" || portletData[i].portletTp == "cn_nb" || portletData[i].portletTp == "top_nb") {
				fnDrawBoardPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_em" || portletData[i].portletTp == "cn_em" || portletData[i].portletTp == "top_em") {
				fnDrawEmailListPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_ea" || portletData[i].portletTp == "cn_ea" || portletData[i].portletTp == "top_ea") {
				fnDrawEaListPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_so") {
				fnDrawSchedulePortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_no") {
				fnDrawNotePortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_form") {
				fnDrawEaFormPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_weather") {
				fnDrawWeatherPortlet(portletData[i], portletData[i].position, false);
			} else if(portletData[i].portletTp == "lr_ea_form") {
				fnDrawNonEaFormPortlet(portletData[i], portletData[i].position);
			} else if((portletData[i].portletTp == "cn_ea_ea" || portletData[i].portletTp == "top_ea_ea" || portletData[i].portletTp == "lr_ea_ea") && portletData[i].iframeYn == "N") {
				fnDrawNonEaListPortlet(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_ea_ea_count") {
				fnDrawNonEaCount(portletData[i], portletData[i].position);
			} else if(portletData[i].portletTp == "lr_doc" || portletData[i].portletTp == "cn_doc" || portletData[i].portletTp == "top_doc") {
 				fnDrawDocPortlet(portletData[i], portletData[i].position);
 			}
		}
	}
	
	function fnReadCheck(obj){
		
		var selectedNewContent = $(obj).closest("li");
		
		if(selectedNewContent.length > 0){
			//$(selectedNewContent).removeClass("new");
			$(selectedNewContent).find("[name=newIconImage]").remove();
		}
		
	}
	
	function checkUserPortletAuth(menuNo){
		var authCheck = false;
		for(var i=0;i<userMenuList.length;i++){
			if(userMenuList[i].menuNo == menuNo){
				authCheck = true;
				break;
			}
		}		
		return authCheck;
	}
	
	
	function setPortletMoreClickEvent(){
		if(!checkUserPortletAuth("303010000")){
			$(".noteMoreClick").attr("onclick","");
			$(".noteMoreClick").attr("href","#");
		}
		
		if(!checkUserPortletAuth("301000000")){
			$(".scheduleMoreClick").attr("onclick","");
			$(".scheduleMoreClick").attr("href","#");
		}
		
		
		if(eaType == "eap"){
			if(!checkUserPortletAuth("2001010000")){
				$(".approvalFormSetting").attr("onclick","");
				$(".approvalFormSetting").attr("href","#");
			}				
			if(!checkUserPortletAuth("2000000000")){
				$(".approvalSignStatus").attr("onclick","");
				$(".approvalMoreClick").attr("onclick","");
				$(".approvalSignStatus").attr("href","#");
				$(".approvalMoreClick").attr("href","#");
			}				
		}else{
			if(!checkUserPortletAuth("101010000")){
				$(".approvalFormSetting").attr("onclick","");
				$(".approvalFormSetting").attr("href","#");
			}				
			if(!checkUserPortletAuth("100000000")){
				$(".approvalSignStatus").attr("onclick","");
				$(".approvalMoreClick").attr("onclick","");
				$(".approvalSignStatus").attr("href","#");
				$(".approvalMoreClick").attr("href","#");
			}
		}	
		
		if(!checkUserPortletAuth("200000000")){
			$(".mailMoreClick").attr("onclick","");
			$(".mailMoreClick").attr("href","#");
		}
		
		if(!checkUserPortletAuth("501000000")){
			$(".boardMoreClick").attr("onclick","");
			$(".boardMoreClick").attr("href","#");
		}
		
		if(!checkUserPortletAuth("601000000")){
			$(".docMoreClick").attr("onclick","");
			$(".docMoreClick").attr("href","#");
		}
	}
	
	function commuteCheckPermit(callback) {
		var tblParam = {};	 
		
		tblParam.accessType = "web";
		tblParam.groupSeq = "${loginVO.groupSeq}";
		tblParam.compSeq = "${loginVO.compSeq}";
		tblParam.deptSeq = "${loginVO.orgnztId}";
		tblParam.empSeq = "${loginVO.uniqId}";
					
		$.ajax({
        	type:"post",
        	contentType :"application/json;",
    		url:'/attend/external/api/gw/commuteCheckPermit',
    		dataType:"json",
            data: JSON.stringify(tblParam),
            async: false,
            success: function (data) { 
            	if(data != null && data.result != "SUCCESS" && callback) {
            		callback();
            	}
            },
            error: function (e) {
            }
        });
	}
	</script>