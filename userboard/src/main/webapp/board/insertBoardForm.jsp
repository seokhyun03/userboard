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
	// 요청값 유효성 검사
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	
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
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localSql);
	// 위 sql 디버깅
	System.out.println(localStmt + " <-- home subMenuStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	localRs = localStmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()) {
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		localList.add(l);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="p-4 bg-dark text-white text-center">
		  <h1>My First Bootstrap 5 Page</h1>
		  <p>Resize this responsive page to see the effect!</p> 
	</div>
	<div>
		<!-- 메인메뉴(가로) -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
	</div>
	<br>
	<%=msg%>
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">지역</th>
					<td>
						<select name="localName">
							<option value="">지역을 선택해주세요</option>
						<%
							for(Local l : localList) {
						%>
							<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
						<%		
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<th class="table-dark">제목</th>
					<td><input type="text" name="boardTitle" value="제목을 입력해주세요"></td>
				</tr>
				<tr>
					<th class="table-dark">내용</th>
					<td><textarea name="boardContent">내용을 입력하세요</textarea></td>
				</tr>
			</table>
			<button type="submit">등록</button>
		</form>
	</div>
	<div class="mt-5 p-4 bg-dark text-white text-center">
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>