<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@page import="main.web.BizboxAMessage"%>

<script type="text/javascript">

$(document).ready(function() {


});//document ready end
		
function fnclose(){
	
	self.close();
}
</script>





<div class="pop_wrap_dir">
	<div class="pop_head">
		<h1>차량구분 도움</h1>
		<!-- <a href="#n" class="clo"><img src="../../../Images/btn/btn_pop_clo02.png" alt="" /></a> -->
	</div>	
	
	<div class="pop_con">
		<div class="top_box">
			<dl>
				<dt>검색어</dt>
				<dd><input type="text" style="width:200px" /></dd>
				<dd><input type="button" value="검색" /></dd>
			</dl>
		
		</div>
		<div class="com_ta2 mt10">
			<table>
				<colgroup>
                    <col width="34"/>
					<col width="100"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
                    <th>
                        <input type="checkbox" name="" id="" />
					    <label for=""></label>
                    </th>
					<th>차량코드</th>
					<th>차량번호</th>
					<th>차종</th>
				</tr>
			</table>
		</div>

		<div class="com_ta2 ova_sc cursor_p bg_lightgray" style="height:333px">
			<table>
				<colgroup>
                    <col width="34"/>
					<col width="100"/>
					<col width="130"/>
					<col width=""/>
				</colgroup>
				<tr>
                    <td>
                         <input type="checkbox" name="" id="" />
					    <label for=""></label>
                    </td>
					<td>1111</td>
					<td>01가2345</td>
					<td>k5</td>
				</tr>
			</table>
		</div>		
	</div><!--// pop_con -->
	<div class="pop_foot">
		<div class="btn_cen pt12">
			<input type="button" value="확인" />
			<input type="button" class="gray_btn" value="취소" onclick="fnclose();"/>
		</div>
	</div><!-- //pop_foot -->

</div>