<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	// 요청값 유효성 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 1) 서브메뉴 결과셋(모델)
	// 전체, localName의 행의 수를 구하는 sql 전송
	PreparedStatement deleteBoardStmt = null;
	String deleteBoardSql = "DELETE FROM board WHERE board_no =? AND member_id=?";
	deleteBoardStmt = conn.prepareStatement(deleteBoardSql);
	deleteBoardStmt.setInt(1, boardNo);
	deleteBoardStmt.setString(2, loginMemberId);
	// 위 sql 디버깅
	System.out.println(deleteBoardStmt + " <-- updateBoardAction deleteBoardStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = deleteBoardStmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("게시물 삭제 성공");
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>