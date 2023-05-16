<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 유효성 검사
	if(request.getParameter("memberId").equals("")			// 아이디나 패스워드가 공백일때 회원가입 폼으로 가라
		||request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 요청값 디버깅
	System.out.println(memberId + " <-- insertMemberAction parameter memberId");
	System.out.println(memberId + " <-- insertMemberAction parameter memberPw");
	
	// 요청값 객체에 묶어서 저장
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	// 객체 디버깅
	System.out.println(paramMember.getMemberId() + " <-- insertMemberAction paramMember memberId");
	System.out.println(paramMember.getMemberPw() + " <-- insertMemberAction paramMember memberPw");
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// sql 전송
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES (?, PASSWORD(?), NOW(), NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	// sql 디버깅
	System.out.println(stmt + " <-- insertMemberAction sql");
	// sql 실행 시 영향받는 행의 수 반환
	int row = stmt.executeUpdate();
	
	if(row == 1){ // 회원가입 성공
		System.out.println("회원가입 성공");
	} else { 	// 회원가입 실패
		// 1. row == 0 -> 아이디 중복
		// 2. row > 1 -> sql 오류? rollback
		System.out.println("회원가입 실패"); 
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp?");
%>