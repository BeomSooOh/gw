<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>

<script id="treeview-template" type="text/kendo-ui-template">
            #: item.text #
</script>
    
<script type="text/javascript">
		$(document).ready(function() {	
		
			function onSelect(e) {
				
			}

			function onCheck(e) {
				
			}

			function onChange(e) {
				
			}
			
			// 조직도
			$("#treeview").kendoTreeView({
				template: kendo.template($("#treeview-template").html()),
				checkboxes: true,
				select: onSelect,
				check: onCheck,
				dataSource: [{
					id: 1, text: "<%=BizboxAMessage.getMessage("TX000000933","그룹")%>", expanded: true, spriteCssClass: "rootfolder", items: [
						{
						id: 2, text: "<%=BizboxAMessage.getMessage("TX000010658","마케팅부")%>", expanded: true, spriteCssClass: "file", items: [
								{ id: 3, text: "<%=BizboxAMessage.getMessage("TX000010657","마케팅사업부")%>", spriteCssClass: "file" },
								{ id: 4, text: "<%=BizboxAMessage.getMessage("TX000010656","커뮤니케이션부")%>", spriteCssClass: "file" },
								{ id: 5, text: "<%=BizboxAMessage.getMessage("TX000010655","전략마케팅본부")%>", spriteCssClass: "file" }
							]
						},
						{
						id: 6, text: "<%=BizboxAMessage.getMessage("TX000010655","전략마케팅본부")%>", expanded: true, spriteCssClass: "folder", items: [
									{ id: 7, text: "<%=BizboxAMessage.getMessage("TX000010654","디자인센터")%>", spriteCssClass: "folder" ,items: [
										{ id: 8, text: "<%=BizboxAMessage.getMessage("TX000010653","디자인1팀")%>", spriteCssClass: "folder"},
										{ id: 9, text: "<%=BizboxAMessage.getMessage("TX000010652","디자인2팀")%>", spriteCssClass: "folder"}
									]
								}
							]
						},
						{
							id: 10, text: "<%=BizboxAMessage.getMessage("TX000010654","디자인센터")%>", expanded: true, spriteCssClass: "folder"
						},
						{
						id: 11, text: "<%=BizboxAMessage.getMessage("TX000010651","지식서비스부문")%>", expanded: true, spriteCssClass: "folder", items: [
									{ id: 12, text: "<%=BizboxAMessage.getMessage("TX000010650","지식서비스1팀")%>", spriteCssClass: "folder" ,items: [
									{ id: 13, text: "<%=BizboxAMessage.getMessage("TX000010649","지식서비스2팀")%>", spriteCssClass: "folder"},
									{ id: 14, text: "<%=BizboxAMessage.getMessage("TX000010648","지식서비스3팀")%>", spriteCssClass: "folder"}
									]
								}
							]
						},
						{
							id: 15, text: "TS부문", expanded: true, spriteCssClass: "folder"
						},
						{
						id: 16, text: "2014", expanded: true, spriteCssClass: "folder", items: [
									{ id: 17, text: "2014s", spriteCssClass: "folder" ,items: [
									{ id: 18, text: "10", spriteCssClass: "folder"},
									{ id: 19, text: "10", spriteCssClass: "folder"},
									{ id: 20, text: "10", spriteCssClass: "folder"},
									{ id: 21, text: "10", spriteCssClass: "folder"},
									{ id: 22, text: "10", spriteCssClass: "folder"},
									{ id: 23, text: "10", spriteCssClass: "folder"},
									{ id: 24, text: "10", spriteCssClass: "folder"},
									{ id: 25, text: "10", spriteCssClass: "folder"},
									{ id: 26, text: "10", spriteCssClass: "folder"},
									{ id: 27, text: "10", spriteCssClass: "folder"},
									{ id: 28, text: "10", spriteCssClass: "folder"},
									{ id: 29, text: "10", spriteCssClass: "folder"},
									{ id: 30, text: "10", spriteCssClass: "folder"},
									{ id: 31, text: "10", spriteCssClass: "folder"},
									{ id: 32, text: "11", spriteCssClass: "folder"}
									]
								}
							]
						},
						{
							id: 33, text: "2014ss", expanded: true, spriteCssClass: "folder"
						}
					]
				}]
			});

		//기본버튼
	    $(".controll_btn button").kendoButton();

		
		//직책 셀렉트박스
		    $("#posi_sel1").kendoComboBox({
		        dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000022293","전체")%>","..."]
		        },
		        value:"<%=BizboxAMessage.getMessage("TX000022293","전체")%>"
		    });
			
		//직급 셀렉트박스
		    $("#posi_sel2").kendoComboBox({
		        dataSource : {
					data : ["<%=BizboxAMessage.getMessage("TX000022293","전체")%>","..."]
		        },
		        value:"<%=BizboxAMessage.getMessage("TX000022293","전체")%>"
		    });//직급 셀렉트박스
		    $("#tel_company").kendoComboBox({
		        dataSource : {
					data : ["02","..."]
		        },
		        value:"02"
		    });



	});
</script>
	
<div class="pop_wrap" style="width:998px;">
	<div class="pop_head">
		<h1><%=BizboxAMessage.getMessage("TX000017921","겸직부서찾기")%></h1>
		<a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo01.png" alt="" /></a>
	</div>	
	
	<div class="pop_con">
		<div class="trans_nrw">

			<div class="tree_title">
				<h2><%=BizboxAMessage.getMessage("TX000017922","겸직부서 선택")%></h2>
			</div>

			<!-- 조직도 -->
			<div class="treeCon">									
				<div id="treeview" class="tree_icon" style="height:467px;"></div>
			</div> 	
		</div>

		<div class="trans_mid" style="width:694px; height:485px; overflow:auto;">
			<div class="btn_top2">
				<h2><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></h2>
			</div>

			<!-- 기본정보 테이블 -->
			<div class="com_ta">
				<table>
					<colgroup>
							<col width="115"/>
							<col width="232"/>
							<col width="115"/>
							<col width=""/>
					</colgroup>
					<tr>
							<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000018672","직급")%></th>
							<td><input id="posi_sel1" style="width:206px" /></td>
							<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
							<td><input id="posi_sel2" style="width:206px" /></td>
						</tr>
						<tr>
							<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000006108","겸직부서")%>1</th>
							<td colspan="3"><input type="text" value="" style="width:388px;"></td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000016136","전화번호(회사)")%></th>
							<td colspan="3">
								<input id="tel_company" style="width:80px;"/> - 
								<input type="text" size="6" maxlength="4" value=""/> - 
								<input type="text" size="6" maxlength="4" value=""/>
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000004113","주소(회사)")%></th>
							<td colspan="3" class="pd6">
								<input type="text" value="" style="width:88px;"> - <input type="text" value="" style="width:88px;">
								<div id="" class="controll_btn p0">
									<button id=""><%=BizboxAMessage.getMessage("TX000000009","우편번호")%></button>
								</div>
								
								<div class="mt5">
									<input class="mr5" type="text" value="" style="float:left; width:40%;"/>
									<input type="text" value="" style="float:left; width:55%;"/>
								</div>
							</td>
						</tr>
				</table>
			</div>
		
			<div class="btn_top2 mt12">
				<h2><%=BizboxAMessage.getMessage("TX000017923","그룹웨어 설정정보")%></h2>
			</div>
			
			<div class="com_ta">
				<table>
					<colgroup>
							<col width="115"/>
							<col width="232"/>
							<col width="115"/>
							<col width=""/>
					</colgroup>
					<tr>
						<th><img src="../../../Images/ico/ico_check01.png" alt="" /> <%=BizboxAMessage.getMessage("TX000003435","표시여부")%></th>
						<td colspan="3">
							<ul class="yb_ul">
								<li>
									<span><%=BizboxAMessage.getMessage("TX000017924","조직도 표시여부")%></span>
									<input type="radio" name="cjd_radi" id="cjd_radi1" class="k-radio" checked="checked"/>
									<label class="k-radio-label radioSel" for="cjd_radi1"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" name="cjd_radi" id="cjd_radi2" class="k-radio"/>
									<label class="k-radio-label radioSel ml10" for="cjd_radi2"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label> <br />	
								</li>
								<li>
									<span><%=BizboxAMessage.getMessage("TX000017961","메신저 표시여부")%></span>
									<input type="radio" name="msj_radi" id="msj_radi1" class="k-radio" checked="checked"/>
									<label class="k-radio-label radioSel" for="msj_radi1"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" name="msj_radi" id="msj_radi2" class="k-radio"/>
									<label class="k-radio-label radioSel ml10" for="msj_radi2"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label> <br />	
								</li>
							</ul>
						</td>
					</tr>
				</table>	
			</div>


		</div><!--// trans_mid -->

	</div><!--// pop_con -->

	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="<%=BizboxAMessage.getMessage("TX000001256","저장")%>" />
			<input type="button" class="gray_btn" value="<%=BizboxAMessage.getMessage("TX000019660","취소")%>" />
		</div>
	</div><!-- //pop_foot -->

</div><!--// pop_wrap -->