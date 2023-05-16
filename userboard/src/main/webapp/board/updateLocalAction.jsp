<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;
	}
	// 요청값 유효성 검사
	if(request.getParameter("oldLocalName") == null				// 이전 지역명이 null이거나 공백이면
		|| request.getParameter("oldLocalName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");// 카테고리 목록으로
		return;
	}
	// 요청값 변수에 저장
	String oldLocalName = request.getParameter("oldLocalName");
	// 요청값 유효성 검사
	if(request.getParameter("localName") == null				// 지역명이 null이거나 공백이면
			|| request.getParameter("localName").equals("")) {
			response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+oldLocalName);// 카테고리 수정 폼으로
			return;
	}
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	// 디버깅
	System.out.println(localName + " <-- updateLocalAction localName");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// local_name 수정 sql 전송
	PreparedStatement updateLocalStmt = null;
	String updateLocalSql = "UPDATE local SET local_name = ?, updatedate = NOW() WHERE local_name = ?;";
	updateLocalStmt = conn.prepareStatement(updateLocalSql);
	updateLocalStmt.setString(1, localName);
	updateLocalStmt.setString(2, oldLocalName);
	// 위 sql 디버깅
	System.out.println(updateLocalStmt + " <-- updateLocalAction localStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = updateLocalStmt.executeUpdate();
	
	if(row == 1){ // 카테고리 수정 성공
		System.out.println("카테고리 수정 성공");
	} else { 	// 카테고리 수정 실패 -> 다시 카테고리 수정 폼으로
		// row == 0 -> 카테고리 명 중복
		System.out.println("카테고리 수정 실패"); 
		response.sendRedirect(request.getContextPath()+"/board/updateLocalForm.jsp?localName="+oldLocalName);
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>