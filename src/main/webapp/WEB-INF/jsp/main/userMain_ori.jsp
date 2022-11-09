<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>

	<div class="main_wrap">
		
		<!-- 1단 -->
		<div class="con_left">			
			<div class="userinfo ptl mb8">

				<!-- 접속자 정보 -->
				<div class="user">
					<div class="user_pic">
						<div class="bg_pic"></div>
						<span class="img_pic"><img alt="" src="<c:url value='/Images/temp/temp_pic.png' />"></span>
					</div>

					<div class="mb10 name">김서현 대리</div>
					
					<div class="Scon_ts">
						<a class="selOn">더존비즈온<br/>UC개발본부 > UC개발부 > 개발3팀</a>
						<ul id="selBox">
							<li>더존비즈온<br/>UC개발본부 > UC개발부 > 개발1팀 </li>				
							<li>더존비즈온<br/>UC개발본부 > UC개발부 > 개발2팀 </li>
							<li>더존비즈온<br/>UC개발본부 > UC개발부 > 개발3팀 </li>
							<li>더존비즈온<br/>UC개발본부 > UC개발부 > 개발4팀 </li>
						</ul>
					</div>
				</div>
				
				<!-- 출근/퇴근 -->
				<div class="worktime">
					<div id="container">
						<ul class="tabs">
							<li class="active" rel="tab1">출근</li>
							<li rel="tab2">퇴근</li>
						</ul>
						<div class="tab_container">
							<div id="tab1" class="tab_content"><em>출근</em> 2015.03.31 화요일 08:31:09</div>
							<div id="tab2" class="tab_content"><em>퇴근</em> 2015.03.31 화요일 08:31:09</div>
						</div>
					</div>

				</div>
			</div>

			<!-- 공지사항 -->
			<div class="notice ptl mb8">
				<h2 class="noticebg">공지사항</h2>
				<a class="title_more" href="#n" title="더보기"><img src="<c:url value='/Images/ico/icon_Mmore.png' />" alt="더보기"/></a>
				<ul>
					<li><img src="<c:url value='/Images/ico/icon_new.png' />"" class="mr5" alt="new"/>[필독] 2015년 건강검진 안내</li>
					<li><img src="<c:url value='/Images/ico/icon_new.png' />"" class="mr5" alt="new"/>기능 업데이트 안내 기능 업데이트 안내</li>
					<li>[필독] 보안정책 적용</li>
					<li>[필독] 메신저 사용자 프로필</li>
					<li>임직원 행동강령 준수 캠페인</li>
					<li>기능 업데이트  안내</li>
					<li>[필독] 보안정책 적용</li>
					<li>기능 업데이트  안내</li>
					<li>[필독] 보안정책 적용</li>
				</ul>			
			</div>
			
			<!-- 설문조사 -->
			<div class="survey ptl">
				<h2 class="surveybg">설문조사</h2>
				<div>설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용설문조사내용</div>			
			</div>	
		</div>
		
		
		<!-- 중앙 -->
		<div class="con_center mb8">
						
			<!-- 중앙배너 -->
			<div class="cc_banner mb8">
				<a href="#n" title="자세히보기"><img src="<c:url value='/Images/temp/main_img01.png' />" alt=""/></a>
			</div>
			
			<div class="cc_left">
				<!-- 좌측배너 -->
				<div class="Mbanner mb8">
					<ul class="imagebox">
					  <li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_1.png' />" alt="" /></a></li>
					  <li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_2.png' />" alt="" /></a></li>
					  <li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_3.png' />" alt="" /></a></li>
					  <li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_4.png' />" alt="" /></a></li>	 
					</ul>
				</div>
				
				<!-- 2단 -->
				<div class="approval ptl">
					<h2 class="approvalbg">전자결재</h2>
					<a class="title_more2" href="#n" title="더보기"><img src="<c:url value='/Images/ico/icon_Mmore2.png' />" alt="더보기"/></a>
					<div class="con">
						<dl>
							<!-- <dd class="sign blue">진행</dd> -->
							<dt class="title"><a href="#"><img src="<c:url value='/Images/ico/icon_new.png' />" class="mr5" alt="new"/>[개발1팀 홍길동] 20150410 휴가신청</a></dt>
							<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
							<dd class="date">15.04.08</dd>
						</dl>
						<dl>
							<!-- <dd class="sign red">반려</dd> -->
							<dt class="title"><a href="#">[개발1팀 홍길동] 20150410 휴가신청서를 올려드립니다.</a></dt>
							<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
							<dd class="date">15.04.08</dd>
						</dl>
						<dl>
							<!-- <dd class="sign gray">종결</dd> -->
							<dt class="title"><a href="#">[개발1팀 홍길동] 20150410 휴가신청</a></dt>
							<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
							<dd class="date">15.04.08</dd>
						</dl>
						<dl>
							<!-- <dd class="sign orange">미결</dd> -->
							<dt class="title"><a href="#">[개발1팀 홍길동] 20150410 휴가신청</a></dt>
							<dd class="file"><img src="<c:url value='/Images/ico/ico_file.png' />" alt="첨부파일"></dd>
							<dd class="date">15.04.08</dd>
						</dl>
					</div>
				</div>
			</div>			
			
			<div class="cc_right">
				<!-- 우측배너 -->
				<div class="Mbanner mb8">	
					<ul class="imagebox2">
						<li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_4.png' />" alt="" /></a></li>
						<li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_3.png' />" alt="" /></a></li>
						<li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_2.png' />" alt="" /></a></li>
						<li><a href="#" title=""><img src="<c:url value='/Images/temp/temp06_1.png' />" alt="" /></a></li>	 
					</ul>
				</div>

				<!-- 3단 -->
				<div class="defer ptl">
					<h2 class="deferbg">프로젝트 보류</h2>
					<a class="title_more2" href="#n" title="더보기"><img src="<c:url value='/Images/ico/icon_Mmore2.png' />" alt="더보기"/></a>
						<ul>
							<li>
								<dl>
									<dt><em class="off">[보류]</em>조직도 관련 테이블 재정의 및 쿼리작성</dt> <!-- em태그가 있는경우 class도 같이 처리 -->
									<dd>작성자:이아라 2015. 05. 08 ~ 2015. 05. 29</dd>
								</dl>
							</li>
							<li>
								<dl>
									<dt><em></em>조직도 관련 테이블 재정의 및 쿼리작성</dt>
									<dd>작성자:이아라 2015. 05. 08 ~ 2015. 05. 29</dd>
								</dl>	
							</li>
							<li>
								<dl>
									<dt><em class="off">[보류]</em>조직도 관련 테이블 재정의 및 쿼리작성</dt>
									<dd>작성자:이아라 2015. 05. 08 ~ 2015. 05. 29</dd>
								</dl>	
							</li>
						</ul>
				</div>
			</div>
		</div>

		<!-- 4단 -->
		<div class="con_right">

			<!-- 일정 -->
			<div class="calendar ptl mb8">
				<h2 class="calendarbg">일정</h2>
				<a class="title_more" href="#n" title="더보기"><img src="<c:url value='/Images/ico/icon_Mmore.png' />" alt="더보기"/></a>
				
				<div class="schedule_cal">                    
					<div class="select_date">
						<a title="이전" class="prev" href="#n"></a>
						<span id="">2015.08</span>
						<a title="다음" class="next" href="#n"></a>
					</div>

					<div name="calanderTable">
					  <table cellspacing="0" cellpadding="0">
						<tbody>
						  <tr>
							<th class="sun">일</th>
							<th>월</th>
							<th>화</th>
							<th>수</th>
							<th>목</th>
							<th>금</th>
							<th class="sat">토</th>
						  </tr>
						  <tr>
							<td class="sun"><a name="26" title="" onclick="">26</a></td>
							<td><a name="27" title="" onclick="">27</a></td>
							<td><a name="28" title="" onclick="">28</a></td>
							<td><a name="29" title="" onclick="">29</a></td>
							<td><a name="30" title="" onclick="">30</a></td>
							<td><a name="31" title="" onclick="">31</a></td>
							<td class="sat"><a name="1" title="" onclick="">1</a></td>
						  </tr>
						  <tr>
							<td class="sun"><a name="2" title="" onclick="">2</a></td>
							<td><a name="3" title="" onclick="">3</a></td>
							<td><a name="4" title="" onclick="">4</a></td>
							<td><a name="5" title="" onclick="">5</a></td>
							<td><a name="6" title="" onclick="">6</a></td>
							<td><a name="7" title="" onclick="">7</a></td>
							<td class="sat"><a name="8" title="" onclick="">8</a></td>
						  </tr>
						  <tr>
							<td class="sun"><a name="9" title="" onclick="">9</a></td>
							<td><a name="10" title="" onclick="">10</a></td>
							<td><a name="11" title="" onclick="">11</a></td>
							<td><a name="12" title="" onclick="">12</a></td>
							<td><a name="13" title="" onclick="">13</a></td>
							<td><a name="14" title="" class="schedule" onclick="">14</a></td>
							<td class="sat"><a name="15" title="" onclick="">15</a></td>
						  </tr>
						  <tr>
							<td class="sun"><a name="16" title="" onclick="">16</a></td>
							<td><a name="17" title="" onclick="">17</a></td>
							<td><a name="18" title="" onclick="">18</a></td>
							<td><a name="19" title="" onclick="">19</a></td>
							<td><a name="20" title="" onclick="">20</a></td>
							<td><a name="21" title="" onclick="">21</a></td>
							<td class="sat"><a name="22" title="" class="schedule" onclick="">22</a></td>
						  </tr>
						  <tr>
							<td class="sun"><a name="23" title="" onclick="">23</a></td>
							<td><a name="24" title="" onclick="">24</a></td>
							<td><a name="25" title="" onclick="">25</a></td>
							<td><a name="26" title="" onclick="">26</a></td>
							<td><a name="27" title="" onclick="">27</a></td>
							<td><a name="28" title="" onclick="">28</a></td>
							<td class="sat"><a name="29" title="" onclick="">29</a></td>
						  </tr>
						  <tr>
							<td class="sun"><a name="30" title="" onclick="">30</a></td>
							<td><a name="31" title="" onclick="">31</a></td>
							<td><a name="1" title="" onclick="">1</a></td>
							<td><a name="2" title="" onclick="">2</a></td>
							<td><a name="3" title="" onclick="">3</a></td>
							<td><a name="4" title="" onclick="">4</a></td>
							<td class="sat"><a name="5" title="" onclick="">5</a></td>
						  </tr>
						</tbody>
					  </table>
					</div>                
				</div>

				<div class="today_sch">
					<h3>오늘의 일정 <em class="text_blue">8</em>건</h3>
					<ul>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
						<li><span>13:00~14:00</span> 솔루션 업체 미팅</li>
					</ul>
				</div>
			</div>
			
			<!-- 노트 -->
			<div class="note ptl mb8">
				<h2 class="notebg">노트</h2>
				<a class="title_more" href="#n" title="더보기"><img src="<c:url value='/Images/ico/icon_Mmore.png' />" alt="더보기"/></a>
				<ul>
					<li><img src="<c:url value='/Images/ico/icon_new.png' />" class="mr5" alt="new"/>[필독] 2015년 건강검진 안내</li>
					<li><img src="<c:url value='/Images/ico/icon_new.png' />" class="mr5" alt="new"/>기능 업데이트 안내 기능 업데이트 안내</li>
					<li>[필독] 보안정책 적용</li>
					<li>[필독] 메신저 사용자 프로필</li>
					<li>임직원 행동강령 준수 캠페인</li>
					<li>기능 업데이트  안내</li>
					<li>[필독] 보안정책 적용</li>
					<li>기능 업데이트  안내</li>
					<li>[필독] 보안정책 적용</li>
				</ul>
			</div>
		</div>

	</div>
	
	<!-- quick link -->
	<div class="main_quick">
		<div id="Mquick">
			<span class="als-prev"><img src="<c:url value='/Images/btn/btn_quick_prev.png' />" alt="이전" /></span>
			<div class="als-viewport">
				<ul class="als-wrapper">
					<li class="als-item"><img src="<c:url value='/Images/temp/quick01.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick02.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick03.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick04.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick05.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick06.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick07.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick08.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick09.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick10.png' />" alt="" /></li>
					<li class="als-item"><img src="<c:url value='/Images/temp/quick11.png' />" alt="" /></li>
				</ul> 
			</div>
			<span class="als-next"><img src="<c:url value='/Images/btn/btn_quick_next.png' />" alt="다음" /></span>
		</div>
	</div>