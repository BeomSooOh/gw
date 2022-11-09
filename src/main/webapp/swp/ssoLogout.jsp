<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.getSession().removeAttribute("_enpass_id_");
	request.getSession().removeAttribute("_enpass_attr_");
	request.getSession().removeAttribute("_enpass_assertion_");
%>