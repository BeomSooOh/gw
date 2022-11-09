<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<link rel="stylesheet" type="text/css" href="/gw/css/layout_freeb.css" />
<link rel="stylesheet" type="text/css" href="/gw/css/main_freeb.css">

<script>
	$(document).ready(function(){
		//메뉴 더보기로 자동 복사
		freeb_menu();
		
		
		//더보기 클릭시
		$(document).mouseup(function (e){
			if($(e.target).attr("moreBtn")  == null){
				$(".freeb_more").removeClass("on");
				$(".freeb_more_box").addClass("close");
				$(".freeb_more_box").removeClass("open");
			}
			else{
				 if (!$(".freeb_more").hasClass("on"))
				 {
					$(".freeb_more").addClass("on");
					$(".freeb_more_box").addClass("open");
					$(".freeb_more_box").removeClass("close");
				  
				 } else {
					 
				   $(".freeb_more").removeClass("on");
					$(".freeb_more_box").addClass("close");
					$(".freeb_more_box").removeClass("open");
				 }		
				var fmiCnt = $(".freeb_more_box .more_box_in > div").size();
				var fmihei= Math.round(fmiCnt/2)*77
				 $(".freeb_more_box.open .more_box_in").css("height",fmihei);
			}
		});
		
		//더보기 박스에서 마우스가 떠났을시 닫힘
		$(".more_box_in").mouseleave(function(){ 
			$(".freeb_more").removeClass("on");
				$(".freeb_more_box").addClass("close");
				$(".freeb_more_box").removeClass("open");
		});
	});
	
	//메뉴 더보기 박스로 복사
	function freeb_menu(){ 
	 
	  var td_size = $(".freeb_m_ta table td").size();
	  var num = 8;
		if (td_size >10)
		 {
			$(".freeb_m_ta table td").eq(num).nextAll("td").hide();
			var menuCln = $(".freeb_m_ta table td").eq(num).nextAll("td").children(".fm_div").clone();
			$(".more_box_in").html(menuCln); 
			$(".freeb_m_ta table").css("marginRight","183px");
			
			$(".freeb_more").show();
		  }else{
			  $(".freeb_more").hide();
		  }
		
		$(".freeb_menu_in").show();
	}
	
</script>

<div class="freeb_menu"><!-- 메뉴 -->
	<div class="freeb_menu_in">
		<div class="freeb_m_ta">
			<table cellspacing="0" cellpadding="0" style="margin-right: 157px;">
				<tbody>
					<tr>
						<td>
							<div class="fm_div fm_ea" onclick="onclickTopMenu('EA','EAAAAB00200');">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">전자결재</div>
									<span class="cnt">6</span>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_ma" onclick="onclickTopMenu('ML','MLAAAA00400');">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">메일</div>
									<span class="cnt">2</span>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_sc" onclick="onclickTopMenu('CL','CLAAAA00100');">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">일정</div>
									<span class="cnt">3</span>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_wk">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">업무관리</div>
									<span class="cnt">2</span>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_bd" onclick="onclickTopMenu('BD','BDAAAB00100');">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">게시판</div>
									<span class="cnt">5</span>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_ds" onclick="onclickTopMenu('HR','PAMANM00100');">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">인사/근태</div>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_st" onclick="onclickTopMenu('OS','IFMMNG00100');">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">시스템설정</div>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_at" onclick="onclickTopMenu('FI','BIMERS00100');">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">회계</div>
								</div>
							</div>
						</td>
						<td>
							<div class="fm_div fm_dc" onclick="onclickTopMenu('DC','DCAAAA00100');">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">문서</div>
								</div>
							</div>
						</td>
						<td style="display: none;">
							<div class="fm_div fm_of">
								<div class="fm_div_in">
									<div class="ico cntPulse"></div>
									<div class="ico_bg"></div>
									<div class="txt">ONEFFICE</div>
									<span class="cnt">99</span>
								</div>
							</div>
						</td>
						<td style="display: none;">
							<div class="fm_div fm_mp">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">마이페이지</div>
								</div>
							</div>
						</td>
						<td style="display: none;">
							<div class="fm_div fm_et">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">확장기능</div>
								</div>
							</div>
						</td>
						<td style="display: none;">
							<div class="fm_div fm_st">
								<div class="fm_div_in">
									<div class="ico"></div>
									<div class="ico_bg"></div>
									<div class="txt">시스템설정</div>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="freeb_more" morebtn="Y">
			<div class="fm_div plus" morebtn="Y">
				<div class="fm_div_in" morebtn="Y">
					<div class="ico" morebtn="Y"></div>
					<div class="ico_bg" morebtn="Y"></div>
					<div class="txt" morebtn="Y">더보기</div>
				</div>
			</div>
		</div>
		<div class="freeb_more_box close">
			<div class="more_box_in"><div class="fm_div fm_dc">
				<div class="fm_div_in">
					<div class="ico"></div>
						<div class="ico_bg"></div>
						<div class="txt">문서</div>
					</div>
					</div>
						<div class="fm_div fm_of">
							<div class="fm_div_in">
								<div class="ico cntPulse"></div>
								<div class="ico_bg"></div>
								<div class="txt">ONEFFICE</div>
								<span class="cnt">99</span>
							</div>
						</div>
						<div class="fm_div fm_mp">
							<div class="fm_div_in">
								<div class="ico"></div>
								<div class="ico_bg"></div>
								<div class="txt">마이페이지</div>
							</div>
						</div>
						<div class="fm_div fm_et">
							<div class="fm_div_in">
								<div class="ico"></div>
								<div class="ico_bg"></div>
								<div class="txt">확장기능</div>
							</div>
						</div>
						<div class="fm_div fm_st">
							<div class="fm_div_in">
								<div class="ico"></div>
								<div class="ico_bg"></div>
								<div class="txt">시스템설정</div>
							</div>
						</div>
					</div>
			</div>
		</div><!--// gnb_menu_in -->
	</div><!--// 메뉴 -->