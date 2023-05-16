<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 기존 세션을 지우고 갱신(초기화)
	session.invalidate();
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>