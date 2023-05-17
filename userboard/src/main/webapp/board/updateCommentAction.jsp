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
	String loginMemberId = "";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
	
	}
	
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) { 
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	String boardNo = request.getParameter("boardNo");
	if(request.getParameter("commentNo") == null
		|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		return;
	}
	if(request.getParameter("commentContent") == null
		|| request.getParameter("commentContent").equals("")) { 
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		return;
	}
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 댓글 수정 쿼리
	PreparedStatement updateCommentStmt = null;
	String updateCommentSql = "UPDATE comment SET comment_content=? WHERE member_id = ? AND comment_no = ?";
	updateCommentStmt = conn.prepareStatement(updateCommentSql);
	updateCommentStmt.setString(1, commentContent);
	updateCommentStmt.setString(2, loginMemberId);
	updateCommentStmt.setInt(3, commentNo);
	// 위 sql 디버깅
	System.out.println(updateCommentStmt + " <-- updateCommentAction updateCommentStmt");
	
	int row = updateCommentStmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("댓글 수정 성공");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>