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
	if(request.getParameter("localName") == null				// 지역명이 null이거나 공백이면
		|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");// 카테고리 목록으로
		return;
	}
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	// 디버깅
	System.out.println(localName + " <-- deleteLocalAction localName");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// local_name이 일치하면 삭제 sql 전송
	PreparedStatement boardCkStmt = null;
	ResultSet boardCklRs = null;
	String boardCkSql = "SELECT COUNT(local_name) cnt FROM board WHERE local_name = ?;";
	boardCkStmt = conn.prepareStatement(boardCkSql);
	boardCkStmt.setString(1, localName);
	// 위 sql 디버깅
	System.out.println(boardCkStmt + " <-- updateLocalForm localStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	boardCklRs = boardCkStmt.executeQuery();
	int cnt = 0;
	if(boardCklRs.next()) {
		cnt = boardCklRs.getInt("cnt");
	}
	
	if (cnt != 0) {		// 해당 카테고리의 게시물이 있으면 카테고리 목록으로 
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");// 카테고리 목록으로
		return;
	}
	
	PreparedStatement deleteLocalStmt = null;
	String deleteLocalSql = "DELETE FROM local WHERE local_name = ?;";
	deleteLocalStmt = conn.prepareStatement(deleteLocalSql);
	deleteLocalStmt.setString(1, localName);
	// 위 sql 디버깅
	System.out.println(deleteLocalStmt + " <-- deleteLocalAction localStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = deleteLocalStmt.executeUpdate();
	
	if(row == 1){ // 카테고리 삭제 성공
		System.out.println("카테고리 삭제 성공");
	} else { 	// 카테고리 삭제 실패 -> 다시 카테고리 목록으로
		// row == 0 -> 카테고리 이름이 일치하지 않음
		System.out.println("카테고리 삭제 실패"); 
		response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>