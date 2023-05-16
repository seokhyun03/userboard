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
	System.out.println(localName + " <-- updateLocalForm localName");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// localName이 일치하는 board테이블의 행의 수를 구하는 sql 전송
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
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 수정</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>카테고리 수정</h1>
		<form action="<%=request.getContextPath()%>/board/updateLocalAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">현재 지역명</th>
					<td>
						<%=localName%>
						<input type="hidden" name="oldLocalName" value="<%=localName%>">
					</td>
				</tr>
				<tr>
					<th class="table-dark">새로운 지역명</th>
					<td>
						<input type="text" name="localName">
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
		</form>
	</div>
</body>
</html>