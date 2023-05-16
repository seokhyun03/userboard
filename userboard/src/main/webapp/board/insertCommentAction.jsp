<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 유효성 검사
	if(request.getParameter("boardNo") == null
		||request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+request.getParameter("boardNo"));
		return;
	}
	// 요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	// 요청값 디버깅
	System.out.println(boardNo + "<-- insertCommentAction boardNo"); 
	System.out.println(loginMemberId + "<-- insertCommentAction loginMemberId");
	System.out.println(commentContent + "<-- insertCommentAction commentContent");
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 코멘트입력 결과셋(모델)
	// boardNo가 일치하는 데이터를 조회하는 sql 전송
	PreparedStatement insertCommentStmt = null;
	String insertCommentSql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())";
	insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setInt(1, boardNo);
	insertCommentStmt.setString(2, commentContent);
	insertCommentStmt.setString(3, loginMemberId);
	// 쿼리 결과셋
	int row = insertCommentStmt.executeUpdate();
	if(row == 1){ // 댓글 입력 성공
		System.out.println("댓글입력 성공");
	} else { 	// 댓글 입력 실패
		// row > 1 -> sql 오류? rollback
		System.out.println("댓글입력 실패"); 
	}
	// boardOne.jsp로
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>