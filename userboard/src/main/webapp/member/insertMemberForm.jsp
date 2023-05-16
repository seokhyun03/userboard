<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertMemberForm</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>회원가입</h1>
		<form action="<%=request.getContextPath() %>/member/insertMemberAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<td class="table-dark">아이디</td>
					<td><input type="text" name="memberId"></td>
				</tr>
				<tr>
					<td class="table-dark">패스워드</td>
					<td><input type="password" name="memberPw"></td>
				</tr>
			</table>
			<button type="submit">회원가입</button>
		</form>
	</div>
	<div class="container">
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>