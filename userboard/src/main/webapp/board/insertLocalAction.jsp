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

	// 요청값 유효값 검사
	if(request.getParameter("localName") == null						// 요청값 localName이 null이거나 공백이면
		|| request.getParameter("localName").equals("")) {			
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp");// insertLocalForm으로
		return;
	}
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// local 테이블에 데이터를 추가하는 sql 전송
	PreparedStatement insertLocalStmt = null;
	String insertLocalSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, NOW(), NOW());";
	insertLocalStmt = conn.prepareStatement(insertLocalSql);
	// 위 sql 디버깅
	System.out.println(insertLocalStmt + " <-- insertLocalAction insertLocalStmt");
	insertLocalStmt.setString(1, localName);
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = insertLocalStmt.executeUpdate();
	
	if(row == 1){ // 카테고리 추가 성공
		System.out.println("카테고리 추가 성공");
	} else { 	// 카테고리 추가 실패 -> 다시 카테고리 추가 폼으로
		// row == 0 -> 카테고리 명 중복
		System.out.println("카테고리 추가 실패"); 
		response.sendRedirect(request.getContextPath()+"/board/insertLocalForm.jsp");
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/selectLocal.jsp");
%>
