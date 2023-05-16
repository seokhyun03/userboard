<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 컨트롤러 계층
	//세션 유효성 검사
	String loginMemberId = "";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");

	}
	// 요청값 유효성 검사
	if (request.getParameter("boardNo") == null							// boardNo가 null이거나 공백이면
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");	// home.jsp로 가라
		return;															// 코드 종료
	}
	// 요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 요청값 디버깅
	System.out.println(boardNo + " <-- boardOne prameter boardNo");
	int currentPage = 1;
	int rowPerPage = 10;
	int startRow = 0;
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 상세정보 결과셋(모델)
	// boardNo가 일치하는 데이터를 조회하는 sql 전송
	PreparedStatement oneStmt = null;
	ResultSet oneRs = null;
	String oneSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	oneStmt = conn.prepareStatement(oneSql);
	oneStmt.setInt(1, boardNo);
	// 위 sql 디버깅
	System.out.println(oneStmt + " <-- boardOne oneStmt");
	// 쿼리 결과셋 모델
	oneRs = oneStmt.executeQuery();
	// 결과셋 Board 객체에 저장
	Board one = new Board();
	if(oneRs.next()) {
		one.setBoardNo(oneRs.getInt("boardNo"));
		one.setLocalName(oneRs.getString("localName"));
		one.setBoardTitle(oneRs.getString("boardTitle"));
		one.setBoardContent(oneRs.getString("boardContent"));
		one.setMemberId(oneRs.getString("memberId"));
		one.setCreatedate(oneRs.getString("createdate"));
		one.setUpdatedate(oneRs.getString("updatedate"));
	}
	
	// 댓글 결과셋
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, startRow);
	commentStmt.setInt(3, rowPerPage);
	// 위 sql 디버깅
	System.out.println(commentStmt + " <-- boardOne commentStmt");
	// 쿼리 결과셋 모델
	commentRs = commentStmt.executeQuery();
	// 결과셋 ArrayList<Comment>에 저장
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);
	}
	System.out.println(commentList.size() + " <-- boardOne commentList.size()");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>boardOne</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="p-4 bg-dark text-white text-center">
	  <h1>유저 게시판</h1>
	  <p>상세 페이지</p> 
	</div>
	<div>
		<!-- 메인메뉴 -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
	</div>
	<br>
	<div class="container">
		<div class="row">
			<div class="col-sm-9"><h1>상세 내용</h1></div>
			<div class="col-sm-3">
				<!-- home 내용 : 로그인 폼/ 게시글 -->
				<!-- 로그인 폼 -->
				<%
					if(session.getAttribute("loginMemberId") != null) {	// 로그인 정보가 없다면 로그인 폼 표시
				%>
						<!-- 로그인한 유저 표시 -->
					<div class="card" style="width:300px">
					  <div class="card-body">
					  	<h4 class="card-title">
						  	<img class="card-img-top" src="<%=request.getContextPath()%>/img/profile.png" alt="Card image" style="width:50px;">
						    <%=session.getAttribute("loginMemberId") %>
					    </h4>
					    <p class="card-text"><%=session.getAttribute("loginMemberId") %>님이 로그인 중입니다.</p>
					    <a href="<%=request.getContextPath()%>/member/profileForm.jsp" class="btn btn-dark">회원정보</a>
					    <a href="<%=request.getContextPath()%>/member/logoutAction.jsp" class="btn btn-dark">로그아웃</a>
					  </div>
					</div>
				<%	
					}
				%>
			</div>
		</div>
	</div>
	<br>
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/updateBoardForm.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">boardNo</th>
					<td>
						<input type="hidden" name="boardNo" value="<%=one.getBoardNo() %>">
						<%=one.getBoardNo() %>
					</td>
				</tr>
				<tr>
					<th class="table-dark">localName</th>
					<td><%=one.getLocalName() %></td>
				</tr>
				<tr>
					<th class="table-dark">boardTitle</th>
					<td><%=one.getBoardTitle() %></td>
				</tr>
				<tr>
					<th class="table-dark">boardContent</th>
					<td><%=one.getBoardContent() %></td>
				</tr>
				<tr>
					<th class="table-dark">memberId</th>
					<td><%=one.getMemberId() %></td>
				</tr>
				<tr>
					<th class="table-dark">createdate</th>
					<td><%=one.getCreatedate() %></td>
				</tr>
				<tr>
					<th class="table-dark">updatedate</th>
					<td><%=one.getUpdatedate().substring(0, 10) %></td>
				</tr>
			</table>
		<%
			if(one.getMemberId().equals(loginMemberId)) {
		%>
					<button type="submit">수정</button>
					<button type="submit" formaction="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">삭제</button>	
		<%	
			}
		%>
		</form>
		<%
			if(session.getAttribute("loginMemberId") != null) {
		%>
				<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
					<div class="row">
						<div class="col-sm-10">
							<input type="hidden" name="boardNo" value="<%=one.getBoardNo() %>">
							<table class="table table-bordered">
								<tr>
									<th class="table-dark">commentContent</th>
									<td>
										<textarea class="form-control" cols="70" name="commentContent"></textarea>
									</td>
								</tr>
							</table>
						</div>	
						<div class="col-sm-2">
							<br>
							<button type="submit">댓글입력</button>
						</div>
					</div>
				</form>
		<%	
			}
		%>
		<form>
			<table class="table table-bordered">
				<tr>
					<th class="table-dark" col="3">댓글</th>
					<th class="table-dark">수정</th>
					<th class="table-dark">삭제</th>
				</tr>
				<%
					for(Comment c : commentList){
				%>
						<tr>
							<td col="3">
								<div class="row">
									<div class="col-sm-1">
										<img src="<%=request.getContextPath()%>/img/profile.png" style="width:40px;">
									</div>
									<div class="col-sm">
										<h5><%=c.getMemberId() %></h5>
										<p><%=c.getCommentContent() %></p>
										<p class="text-muted"><small><%=c.getUpdatedate().substring(0, 10) %></small></p>
									</div>
									<div class="dropdown dropdown-menu-end col-sm-1">
										 <button type="button" class="btn btn-dark dropdown-toggle" data-bs-toggle="dropdown">
										 </button>
										 <ul class="dropdown-menu">
										   <li><a class="dropdown-item" href="#">수정</a></li>
										   <li><a class="dropdown-item" href="#">삭제</a></li>
										 </ul>
									</div>
								</div>
							</td>
				<%
						if(c.getMemberId().equals(loginMemberId)) {	
				%>
							<td><a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp"><img src="<%=request.getContextPath()%>/img/edit.png"></a></td>
							<td><img src="<%=request.getContextPath()%>/img/delete.png"></td>
				<%			
						} else {
				%>
							<td></td>
							<td></td>
				<%	
						}
				%>
						</tr>
				<%	
					}
				%>
			</table>
			<div>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=one.getBoardNo()%>&currentPage=<%=currentPage-1%>">이전</a>
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=one.getBoardNo()%>&currentPage=<%=currentPage+1%>">다음</a>
			</div>
		</form>
		<div class="container">
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>