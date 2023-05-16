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
	System.out.println(request.getParameter("memberId") + " <-- updatePasswordAction prameter memberId");
	System.out.println(request.getParameter("oldMemberPw") + " <-- updatePasswordAction prameter memberPw");
	// 요청값 유효성 검사
	if(request.getParameter("memberId") == null						// 아이디 정보나 이전 비밀번호 정보가 없으면 홈으로
		|| request.getParameter("memberId").equals("")
		|| request.getParameter("oldMemberPw") == null
		|| request.getParameter("oldMemberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("memberPw") == null						// 비밀번호 정보나 비밀번호 확인정보가 없으면 회원정보 폼으로
		|| request.getParameter("memberPw").equals("")
		|| request.getParameter("memberPwCk") == null
		|| request.getParameter("memberPwCk").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	// 요청값 변수 저장
	String memberId = request.getParameter("memberId");
	String oldMemberPw = request.getParameter("oldMemberPw");
	String memberPw = request.getParameter("memberPw");
	String memberPwCk = request.getParameter("memberPwCk");
	// 요청값 디버깅
	System.out.println(memberId + " <-- updatePasswordAction prameter memberId");
	System.out.println(memberPw + " <-- updatePasswordAction prameter memberPw");
	System.out.println(memberPwCk + " <-- updatePasswordAction prameter memberPwCk");
	
	if(!memberPw.equals(memberPwCk)) {		// 새로운 비밀번호와 비밀번호 확인이 같지 않다면 비밀번호 수정 폼으로
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?memberId="+memberId+"&memberPw="+oldMemberPw);
		return;
	}
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 비밀번호 수정 결과 셋
	// 비밀번호를 수정하는 sql 전송
	PreparedStatement updatePwStmt = null;
	String updatePwSql = "UPDATE member SET member_pw = PASSWORD(?), updatedate = NOW() WHERE member_id = ? AND member_pw = PASSWORD(?);";
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt.setString(1, memberPw);
	updatePwStmt.setString(2, memberId);
	updatePwStmt.setString(3, oldMemberPw);
	// 위 sql 디버깅
	System.out.println(updatePwStmt + " <-- profileForm profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = updatePwStmt.executeUpdate();
	
	if(row == 1){ // 비밀번호 수정 성공
		System.out.println("비밀번호 수정 성공");
	} else { 	// 비밀번호 수정 실패 -> 다시 비밀번호 수정 폼으로
		// 1. row == 0 -> 아이디가 다르거나 이전 비밀번호가 다른 경우
		// 2. row > 1 -> sql 오류? rollback
		System.out.println("비밀번호 수정 실패"); 
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	
	// 기존 세션을 지우고 갱신(초기화)
	// 비밀번호 변경 완료 후 로그아웃 
	session.invalidate();
	response.sendRedirect(request.getContextPath() + "/home.jsp?");
%>
