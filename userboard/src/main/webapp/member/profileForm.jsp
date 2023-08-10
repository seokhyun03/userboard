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
	// 로그인 중인 아이디 변수에 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	// 디버깅
	System.out.println(loginMemberId + " <-- profileForm parameter loginMemberId");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 로그인 중인 Memeber 조회 결과 셋
	// 로그인 중인 Memeber와 일치하는 행을 조회하는 sql 전송
	PreparedStatement profileStmt = null;
	ResultSet profileRs = null;
	String profileSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?;";
	profileStmt = conn.prepareStatement(profileSql);
	profileStmt.setString(1, loginMemberId);
	// 위 sql 디버깅
	System.out.println(profileStmt + " <-- profileForm profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	profileRs = profileStmt.executeQuery();
	Member profile = null;
	if(profileRs.next()) {
		profile = new Member();
		profile.setMemberId(profileRs.getString("memberId"));
		profile.setMemberPw(profileRs.getString("memberPw")); 
		profile.setCreatedate(profileRs.getString("createdate"));
		profile.setUpdatedate(profileRs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원 정보</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 메인메뉴(가로) -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		<h1>회원 정보</h1>
		<form action="<%=request.getContextPath() %>/member/updatePasswordForm.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">아이디</th>
					<td><input type="text" readonly="readonly" value="<%=profile.getMemberId()%>" name="memberId"></td>
				</tr>
				<tr>
					<th class="table-dark">비밀번호</th>
					<td><input type="password" name="memberPw"></td>
				</tr>
				<tr>
					<th class="table-dark">생성날짜</th>
					<td><%=profile.getCreatedate().substring(0, 10)%></td>
				</tr>
			</table>
			<button class="btn btn-dark" type="submit">비밀번호 수정</button>
			<button class="btn btn-dark" type="submit" formaction="<%=request.getContextPath() %>/member/deleteMemberAction.jsp">회원 탈퇴</button>
		</form>
	</div>
</body>
</html>