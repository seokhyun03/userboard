<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(request.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}	
	// 요청값 유효성 검사
		
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	// 요청값 디버깅
	System.out.println(memberId + " <-- loginAction parameter memberId");
	System.out.println(memberPw + " <-- loginAction parameter memberPw");
	
	// 요청값 객체에 묶어서 저장
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	// 객체 디버깅
	System.out.println(paramMember.getMemberId() + " <-- loginAction paramMember memberId");
	System.out.println(paramMember.getMemberPw() + " <-- loginAction paramMember memberPw");
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// sql 전송
	String sql = "SELECT member_id memberId FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	// sql 디버깅
	System.out.println(stmt + " <-- loginAction sql");
	// 전송한 sql 실행값 반환
	rs = stmt.executeQuery();
	
	if(rs.next()){
		// 세션에 로그인 정보 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
	} else {
		System.out.println("로그인 실패"); 
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp?");
%>