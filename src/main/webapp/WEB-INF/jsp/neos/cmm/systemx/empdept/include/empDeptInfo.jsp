<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@page import="main.web.BizboxAMessage"%>
<script>
	$(".mainDeptYnSel").kendoComboBox({select : onClickComboBox});
	
	$(".deptPositionCodeSel").kendoComboBox({
		dataTextField: "dpName",
        dataValueField: "dpSeq"
	});
	$(".deptDutyCodeSel").kendoComboBox({
		dataTextField: "dpName",
        dataValueField: "dpSeq"
	});

	//테이블상세 열기닫기
	$(".btn_dtl").click(function(){
 
		if (!$(this).hasClass("on"))
		{
			$(this).parent().parent().next().show();
			$(this).addClass("on");

			$onImg=$(this).find("img").attr("src").replace("down01.png","up01.png");
			$(this).find("img").attr("src",$onImg);

			selectRow = $(this).parent().parent();		// 선택된 사원 부서정보
			nextSelectRow = $(this).parent().parent().next();   // 선택된 기본정보, 그룹웨어 설정정보
			
		} else {
			$(this).parent().parent().next().hide();
			$(this).removeClass("on");

			$offImg=$(this).find("img").attr("src").replace("up01.png","down01.png");
			$(this).find("img").attr("src",$offImg);
			
			selectRow = null;		// 선택된 사원 부서정보
			nextSelectRow = null;   // 선택된 기본정보, 그룹웨어 설정정보
		}
		
	});

</script>


<!-- 사원 부서 정보 -->
<table id="empDeptInfoTable">
	<colgroup>
		<col width="40"/> 
		<col width="100"/>
		<col width=""/>
		<col width=""/>
		<col width=""/>
		<col width=""/>
		<col width="50"/>
	</colgroup>
	<tr>
		<th>
			<input type="checkbox" name="inp_chk_all" id="inp_chk_all" class="k-checkbox">
			<label class="k-checkbox-label radioSel" for="inp_chk_all"></label>
		</th>
		<th><%=BizboxAMessage.getMessage("TX000000214","구분")%></th>
		<th><%=BizboxAMessage.getMessage("TX000000018","회사명")%></th>
		<th><%=BizboxAMessage.getMessage("TX000000068","부서명")%></th>
		<th><%=BizboxAMessage.getMessage("TX000000099","직급")%></th>
		<th><%=BizboxAMessage.getMessage("TX000000105","직책")%></th>
		<th><%=BizboxAMessage.getMessage("TX000000793","상세")%></th>
	</tr>
	<c:if test="${fn:length(deptInfoList) eq 0}">
		<tr>
			<td colspan="7" class="cen"><%=BizboxAMessage.getMessage("TX000019460","선택한 사용자가 없습니다.")%></td>
		</tr>
	</c:if>		
	<c:forEach var="list" items="${deptInfoList}" varStatus="c">
	<tr>
		<td>
			<input type="checkbox" name="inp_chk" id="inp_chk${c.count}" class="k-checkbox chkInput">
			<label class="k-checkbox-label radioSel chkLabel" for="inp_chk${c.count}"></label>
		</td>
		<td>
			<select class="mainDeptYnSel" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value="" ><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
				<option value="Y" <c:if test="${list.mainDeptYn == 'Y'}">selected="selected"</c:if> ><%=BizboxAMessage.getMessage("","주부서")%></option>
				<option value="N" <c:if test="${list.mainDeptYn == 'N'}">selected="selected"</c:if> ><%=BizboxAMessage.getMessage("","부부서")%></option>
			</select> 
			<!-- <input name="mainYn" style="width:62px;"/> -->
		</td>
		<td id="compName">${list.compName}</td>
		<td>
		<div class="dod_search">
			<input type="text" class="" id="deptName" style="width:60%" placeholder="" value="${list.deptName}" /><a href="#" class="btn_sear" onclick="openDeptListPop()"></a>
			<input type="hidden" id="groupSeq" name="groupSeq" value="${list.groupSeq}" />
			<input type="hidden" id="bizSeq" name="bizSeq" value="${list.bizSeq}" />
			<input type="hidden" id="compSeq" name="compSeq" value="${list.compSeq}" />
			<input type="hidden" id="deptSeq" name="deptSeq" value="${list.deptSeq}" />
			<input type="hidden" id="empSeq" name="empSeq" value="${list.empSeq}" />
			<input type="hidden" id="deptSeqNew" name="deptSeqNew" value="${list.deptSeq}" />
			<input type="hidden" id="mainDeptYn" name="mainDeptYn" value="${list.mainDeptYn}" />
			<input type="hidden" id="deptPositionCode" name="positionCode" value="${list.deptPositionCode}" />
			<input type="hidden" id="deptDutyCode" name="dutyCode" value="${list.deptDutyCode}" />
			<input type="hidden" id="useYn" name="useYn" value="${list.useYn}" />
		</div>
		</td>
		<td>
			<select class="deptPositionCodeSel" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value=""><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
				<c:forEach var="plist" items="${list.positionList}">
				<option value="${plist.dpSeq }" <c:if test="${list.deptPositionCode == plist.dpSeq}">selected</c:if> >${plist.dpName}</option>
				</c:forEach>
			</select>
		</td>
		<td>
			<select class="deptDutyCodeSel" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value=""><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
				<c:forEach var="dlist" items="${list.dutyList}">
				<option value="${dlist.dpSeq }" <c:if test="${list.deptDutyCode == dlist.dpSeq}">selected</c:if> >${dlist.dpName}</option>
				</c:forEach>
			</select>
		</td>
		<td><a href="javascript:;" class="btn_dtl"><img src="<c:url value='/Images/ico/ico_btn_arr_down01.png' />" alt="" /></a></td>
	</tr>
	<tr class="dtl_tr">
		<td colspan="7">
			<div class="in_detail">
				<p class="tit_p al mb10"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></p>	
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="140"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000453","전화번호 (회사)")%></th>
							<td><input type="text" id="telNum" name="telNum" style="width:228px;" value="${list.telNum}" /></td>
						</tr>
						<tr class="bdbn">
							<th><%=BizboxAMessage.getMessage("TX900000458","주소 (회사)")%></th>
							<td class="td_top">
								<input type="text" id="zipCode" name="zipCode" value="${list.zipCode}" style="float:left;width:57px;margin-right:4px;" />
								<div class="controll_btn fl" style="padding:0px;margin-right:4px;">
									<button><%=BizboxAMessage.getMessage("TX000000899","조회")%></button>
								</div>
								<input type="text" id="addr" name="addr" value="${list.addr}" style="float:left;width:75%" class="" />
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000011","상세주소")%></th>
							<td  class="td_bottom"><input type="text"  id="detailAddr" name="detailAddr" value="${list.detailAddr}" style="width:97%" /></td>
						</tr>
					</table>
				</div>

				<p class="tit_p al mt30 mb10"><%=BizboxAMessage.getMessage("TX000017923","그룹웨어 설정정보")%></p>	
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="140"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000017924","조직도 표시여부")%></th>
							<td> 
									<input type="radio" id="orgchartDisplayYn${c.count}" name="orgchartDisplayYn${c.count}" value="Y" onclick="onClickOrgDis(this)"  class="k-radio" <c:if test="${list.orgchartDisplayYn == 'Y' }">checked="checked"</c:if>>
									<label class="k-radio-label radioSel" for="orgchartDisplayYn${c.count}"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" id="orgchartDisplayYn2${c.count}" name="orgchartDisplayYn${c.count}" value="N" onclick="onClickOrgDis(this)" class="k-radio" <c:if test="${list.orgchartDisplayYn == 'N' }">checked="checked"</c:if>>
									<label class="k-radio-label radioSel" for="orgchartDisplayYn2${c.count}" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label>
									<input type="hidden" id="orgchartDisplayYn" name="orgchartDisplayYn" value="${list.orgchartDisplayYn}" />
							</td>
						</tr> 
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000017961","메신저 표시여부")%></th>
							<td>
									<input type="radio" id="messengerDisplayYn${c.count}" name="messengerDisplayYn${c.count}" value="Y" onclick="onClickMesDis(this)" class="k-radio" <c:if test="${list.messengerDisplayYn == 'Y' }">checked="checked"</c:if>>
									<label class="k-radio-label radioSel" for="messengerDisplayYn${c.count}"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label> 
									<input type="radio" id="messengerDisplayYn2${c.count}" name="messengerDisplayYn${c.count}" value="N" onclick="onClickMesDis(this)" class="k-radio" <c:if test="${list.messengerDisplayYn == 'N' }">checked="checked"</c:if>>
									<label class="k-radio-label radioSel" for="messengerDisplayYn2${c.count}" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label>
									<input type="hidden" id="messengerDisplayYn" name="messengerDisplayYn" value="${list.messengerDisplayYn}" />
							</td>
						</tr>
					</table>
				</div>
 
			
			</div>
		</td>
	</tr>
	
	</c:forEach>
</table>

<table id="infoSample" style="display:none">
	<tr>
		<td>
			<input type="checkbox" name="inp_chk" id="inp_chk" class="k-checkbox">
			<label class="k-checkbox-label radioSel" for="inp_chk"></label>
		</td>
		<td>
			<select class="sel1" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value="" ><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
				<option value="Y"><%=BizboxAMessage.getMessage("TX000006209","주부서")%></option>
				<option value="N"><%=BizboxAMessage.getMessage("TX000006210","부부서")%></option>
			</select> 
			<!-- <input name="mainYn" style="width:62px;"/> -->
		</td>
		<td id="compName" ></td>
		<td>
		<div class="dod_search">
			<input type="text" class="" id="deptName"  style="width:60%" placeholder="" value="" /><a href="#" class="btn_sear" onclick="openDeptListPop()"></a>
			<input type="hidden" id="groupSeq" name="groupSeq" value="" />
			<input type="hidden" id="bizSeq" name="bizSeq" value="" />
			<input type="hidden" id="compSeq" name="compSeq" value="" />
			<input type="hidden" id="empSeq" name="empSeq" value="${params.empSeq}" />
			<input type="hidden" id="deptSeq" name="deptSeq" value="" />
			<input type="hidden" id="deptSeqNew" name="deptSeqNew" value="" />
			<input type="hidden" id="useYn" name="useYn" value="Y" />
			<input type="hidden" id="deptPositionCode" name="positionCode" value="" />
			<input type="hidden" id="deptDutyCode" name="dutyCode" value="" />
			<input type="hidden" id="mainDeptYn" name="mainDeptYn" value="" />
		</div>
		</td>
		<td>
			<select class="sel2" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value=""><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
			</select>
		</td> 
		<td>
			<select class="sel3" placeholder="<%=BizboxAMessage.getMessage("TX000019777","선택")%>" style="width:80%;" onChange="onClickComboBox(this)" >
				<option value=""><%=BizboxAMessage.getMessage("TX000019777","선택")%></option>
			</select>
		</td>
		<td><a href="javascript:;" class="btn_dtl"><img src="<c:url value='/Images/ico/ico_btn_arr_down01.png' />" alt="" /></a></td>
	</tr>
	<tr class="dtl_tr">
		<td colspan="7">
			<div class="in_detail">
				<p class="tit_p al mb10"><%=BizboxAMessage.getMessage("TX000004661","기본정보")%></p>	
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="140"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX900000453","전화번호 (회사)")%></th>
							<td><input type="text" id="telNum" name="telNum" style="width:228px;" value="" /></td>
						</tr>
						<tr class="bdbn">
							<th><%=BizboxAMessage.getMessage("TX900000458","주소 (회사)")%></th>
							<td class="td_top">
								<input type="text" id="zipCode" name="zipCode" value="" style="float:left;width:57px;margin-right:4px;" />
								<div class="controll_btn fl" style="padding:0px;margin-right:4px;">
									<button><%=BizboxAMessage.getMessage("TX000000899","조회")%></button>
								</div>
								<input type="text" id="addr" name="addr" value="" style="float:left;width:461px;" class="" />
							</td>
						</tr>
						<tr>
							<th><%=BizboxAMessage.getMessage("TX000000011","상세주소")%></th>
							<td  class="td_bottom"><input type="text"  id="detailAddr" name="detailAddr" value="" style="width:578px;" /></td>
						</tr>
					</table>
				</div>

				<p class="tit_p al mt30 mb10"><%=BizboxAMessage.getMessage("TX000017923","그룹웨어 설정정보")%></p>	
				<div class="com_ta">
					<table>
						<colgroup>
							<col width="140"/>
							<col width=""/>
						</colgroup>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000017924","조직도 표시여부")%></th>
							<td> 
									<input type="radio" id="orgchartDisplayYnRadio" name="" value="Y" onclick="onClickOrgDis(this)" class="k-radio" checked>
									<label class="k-radio-label radioSel" id="orgchartDisplayYnLabel" for="orgchartDisplayYnRadio"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" id="orgchartDisplayYnRadio2" name="" value="N" onclick="onClickOrgDis(this)" class="k-radio">
									<label class="k-radio-label radioSel" id="orgchartDisplayYnLabel2" for="orgchartDisplayYnRadio2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label>
									<input type="hidden" id="orgchartDisplayYn" name="orgchartDisplayYn" value="" />
							</td>
						</tr>
						<tr>
							<th><img src="<c:url value='/Images/ico/ico_check01.png'/>" alt="" /> <%=BizboxAMessage.getMessage("TX000017961","메신저 표시여부")%></th>
							<td>
									<input type="radio" id="messengerDisplayYnRadio" name="" value="Y" onclick="onClickMesDis(this)" class="k-radio" checked>
									<label class="k-radio-label radioSel" id="messengerDisplayYnLabel" for="messengerDisplayYnRadio"><%=BizboxAMessage.getMessage("TX000003801","표시")%></label>
									<input type="radio" id="messengerDisplayYnRadio2" name="" value="N" onclick="onClickMesDis(this)" class="k-radio">
									<label class="k-radio-label radioSel" id="messengerDisplayYnLabel2" for="messengerDisplayYnRadio2" style="margin:0 0 0 10px;"><%=BizboxAMessage.getMessage("TX000006392","미표시")%></label>
									<input type="hidden" id="messengerDisplayYn" name="messengerDisplayYn" value="" />
							</td>
						</tr>
					</table>
				</div>
 
			
			</div>
		</td>
	</tr>

</table>

