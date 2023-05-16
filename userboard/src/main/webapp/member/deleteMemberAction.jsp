<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;
	}
	// 요청값 유효성 검사
	if(request.getParameter("memberId") == null						// 아이디 정보가 없으면 홈으로
		|| request.getParameter("memberId").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("memberPw") == null						// 비밀번호 정보가 없으면 회원정보 페이지로
		|| request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	
	// 요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId + " <-- deleteMemberAction prameter memberId");
	System.out.println(memberPw + " <-- deleteMemberAction prameter memberPw");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 아이디와 입력받은 비밀번호와 일치하는 데이터 삭제 결과 셋
	// 아이디와 입력받은 비밀번호와 일치하는 행을 삭제하는 sql 전송
	PreparedStatement deleteMemberStmt = null;
	PreparedStatement foreignKeyCheckStmt = null;
	String foreignKeyCheckSql = "SET foreign_key_checks = ?;";
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_pw = PASSWORD(?);";
	// 외래키 체크 해제
	foreignKeyCheckStmt = conn.prepareStatement(foreignKeyCheckSql);
	foreignKeyCheckStmt.setInt(1, 0);
	foreignKeyCheckStmt.executeUpdate();
	
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, memberId);
	deleteMemberStmt.setString(2, memberPw);
	// 위 sql 디버깅
	System.out.println(deleteMemberStmt + " <-- deleteMemberAction profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = deleteMemberStmt.executeUpdate();
	
	// 외래키 다시 체크 설정
	foreignKeyCheckStmt = conn.prepareStatement(foreignKeyCheckSql);
	foreignKeyCheckStmt.setInt(1, 1);
	foreignKeyCheckStmt.executeUpdate();
	
	if(row == 1){ // 회원 삭제 성공
		System.out.println("회원 삭제 성공");
	} else { 	// 회원 삭제 실패 -> 다시 회원정보 페이지로
		// 1. row == 0 -> 비밀번호가 다름
		// 2. row > 1 -> sql 오류? rollback
		System.out.println("회원 삭제 실패"); 
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	
	// 기존 세션을 지우고 갱신(초기화)
	// 비밀번호 변경 완료 후 로그아웃 
	session.invalidate();
	response.sendRedirect(request.getContextPath() + "/home.jsp?");
%>
