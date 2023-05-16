<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석(컨트롤러 계층)
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지 당 행 개수
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	// 시작 행 번호
	int startRow = 0 + (currentPage-1) * rowPerPage;
	
	// 요청값 유효성 검사
	// localName 변수 전체로 초기화
	String localName = "전체";
	if(request.getParameter("localName") != null) {			// 요청값 localName이 null이 아니면
		localName = request.getParameter("localName");		// 요청값 저장
	}
	// 요청값 디버깅
	System.out.println(localName + " <-- home localName");
	
	// 2. 모델계층
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
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(*) FROM board GROUP BY local_name UNION ALL SELECT local_name, 0 FROM local WHERE local_name != All(SELECT local_name FROM board GROUP BY local_name);";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	// 위 sql 디버깅
	System.out.println(subMenuStmt + " <-- home subMenuStmt");
	// 전송한 sql 실행값 반환
	// 위 쿼리의 결과셋 모델
	subMenuRs = subMenuStmt.executeQuery();
	// subMenuList <-- HashMap<String, Object>의 데이터를 가진 ArrayList 모델 데이터
	// 애플리케이션에서 사용할 모델(사이즈 0)
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	// 2) 페이지 수 결과셋
	// 총 행의 수를 구하는 sql 전송
	PreparedStatement totalRowStmt = null;
	ResultSet totalRowRs = null;
	String totalRowSql = "SELECT COUNT(*) FROM board";
	if(!localName.equals("전체")) {	// localName이 전체가 아니면
		totalRowSql =  "SELECT COUNT(*) FROM board WHERE local_name=?";
		totalRowStmt = conn.prepareStatement(totalRowSql);
		totalRowStmt.setString(1, localName);
	} else {
		totalRowStmt = conn.prepareStatement(totalRowSql);
	}
	// sql 디버깅
	System.out.println(totalRowStmt + " <-- home totalRowStmt");
	totalRowRs = totalRowStmt.executeQuery();
	//총 행의 수
	int totalRow = 0;
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	// 마지막 페이지 = 총 행의 수 / 페이지 당 행의 수
	int lastPage = totalRow / rowPerPage;
	// 총 행의 수 / 페이지 당 행의 수 의 나머지가 0이 아니면 마지막 페이지 + 1
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
		
	// 3) 게시판 목록 결과셋(모델)
	// boardNo, boardTitle를 조회하는 sql 
	PreparedStatement listStmt = null;
	ResultSet listRs = null;
	String listSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY board_no DESC LIMIT ?, ?";
	if(!localName.equals("전체")) {	// localName이 전체가 아니면
		listSql =  "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY board_no DESC LIMIT ?, ?";	// localName이 일치하는 행을 조회
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, localName);
		listStmt.setInt(2, startRow);
		listStmt.setInt(3, rowPerPage);
	} else {
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, startRow);
		listStmt.setInt(2, rowPerPage);
	}
	// sql 디버깅
	System.out.println(listStmt + " <-- home listStmt");
	// sql 실행 결과
	// 위 쿼리의 결과셋 모델
	listRs = listStmt.executeQuery();
	// vo타입 Board의 데이터를 가진 ArrayList
	// 애플리케이션에서 사용할 모델(사이즈 0)
	ArrayList<Board> list = new ArrayList<Board>();
	while(listRs.next()) {
		Board b = new Board();
		b.setBoardNo(listRs.getInt("boardNo"));
		b.setLocalName(listRs.getString("localName")); 
		b.setBoardTitle(listRs.getString("boardTitle"));
		b.setCreatedate(listRs.getString("createdate")); 
		list.add(b);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>home</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div>
		<!-- 페이지 -->
		<div class="p-4 bg-dark text-white text-center">
		  <h1>유저 게시판</h1>
		  <p>Home</p> 
		</div>
		<%
		// request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
		// 위 코드를 액션태그로 변경
		%>
		<div>
			<!-- 메인메뉴 -->
			<div>
				<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
			</div>
		</div>
		<br>
		<div class="container">
			<!-- 지역 카테고리 -->
			<div class="row">
				<div class="offcanvas offcanvas-start text-bg-dark" id="local">
				  <div class="offcanvas-header">
				    <h1 class="offcanvas-title">카테고리</h1>
				    <button type="button" class="btn-close btn-close-white text-reset" data-bs-dismiss="offcanvas"></button>
				  </div>
				  <div class="offcanvas-body">
					<p class="text-end"><a href="<%=request.getContextPath()%>/board/selectLocal.jsp">카테고리 편집</a></p>
					<%
						for(HashMap<String, Object> m : subMenuList) {
					%>	
							<p class="justify-content-between">
								<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName") %>" class="text-decoration-none text-white">
									<%=(String)m.get("localName") %>
								</a>
								<span class="badge rounded-pill bg-secondary"><%=(int)m.get("cnt") %></span>
							</p>
					<%		
						}
					%>
				  </div>
				</div>
				<div class="col-sm-3">
					<button class="btn btn-light" type="button" data-bs-toggle="offcanvas" data-bs-target="#local">
					  <img src="<%=request.getContextPath()%>/img/local.png" style="width:30px;">
					</button>
				</div>
				<div class="col-sm-6"></div>
				<div class="col-sm-3">
					<!-- home 내용 : 로그인 폼/ 게시글 -->
					<!-- 로그인 폼 -->
					<%
						if(session.getAttribute("loginMemberId") == null) {	// 로그인 정보가 없다면 로그인 폼 표시
					%>
						<form action="<%=request.getContextPath() %>/member/loginAction.jsp" method="post">
							<div class="input-group col-sm-2">
							    <span class="input-group-text bg-light"><img src="<%=request.getContextPath()%>/img/id.png" style="width:30px;"></span>
							    <input type="text" class="form-control" placeholder="아이디" name="memberId">
						  	</div>
						  	<div class="input-group col-sm-2">
							    <span class="input-group-text bg-light"><img src="<%=request.getContextPath()%>/img/password.png" style="width:30px;"></span>
							    <input type="password" class="form-control" placeholder="비밀번호" name="memberPw">
						  	</div>
						  	<br>
						  	<div class="d-grid">
								<button type="submit" class="btn btn-dark btn-block">로그인</button>
							</div>
						</form>
					<%	
						} else {
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
			<form action="<%=request.getContextPath()%>/board/insertBoardForm.jsp" method="post">
				<div class="d-flex flex-row justify-content-end">
					<button type="submit" class="btn btn-dark">게시물 작성</button>
				</div>
				<br>
				<table  class="table table-bordered">
					<tr>
						<th class="table-dark">지역</th>
						<th class="table-dark">제목</th>
						<th class="table-dark">날짜</th>
					</tr>
					<%
						for(Board b : list) {
					%>
							<tr>
								<td><%=b.getLocalName() %></td>
								<td>
									<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo() %>">
										<%=b.getBoardTitle() %>
									</a>
								</td>
								<td><%=b.getCreatedate().substring(0, 10) %></td>
							</tr>
					<%	
						}
					%>
				</table>
			</form>
		</div>
		<!-- 페이징 -->
		<ul class="pagination pagination-sm justify-content-center">
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=1&localName=<%=localName%>"><img src="<%=request.getContextPath()%>/img/first.png" style="width:18px;"></a></li>
		<%
			if(currentPage > 1) {
		%>
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-1%>&localName=<%=localName%>"><img src="<%=request.getContextPath()%>/img/left.png" style="width:18px;"></a></li>
		<%		
			}
			if(currentPage > 2) {
		%>
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-2%>&localName=<%=localName%>"><%=currentPage-2%></a></li>
		<%		
			}
			if(currentPage > 1) {
		%>
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage-1%>&localName=<%=localName%>"><%=currentPage-1%></a></li>
		<%		
			}
		%>
				<li class="page-item"><a class="page-link bg-dark text-light" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage%>&localName=<%=localName%>"><%=currentPage%></a></li>
		<%
			if(currentPage < lastPage) {
		%>
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+1%>&localName=<%=localName%>"><%=currentPage+1%></a></li>
		<%		
			}
			if(currentPage < lastPage-1) {
		%>
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+2%>&localName=<%=localName%>"><%=currentPage+2%></a></li>
		<%		
			}
			if(currentPage < lastPage) {
		%>
			 	<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=currentPage+1%>&localName=<%=localName%>"><img src="<%=request.getContextPath()%>/img/right.png" style="width:18px;"></a></li>
		<%		
			}
		%> 
				<li class="page-item"><a class="page-link text-dark" href="<%=request.getContextPath()%>/home.jsp?currentPage=<%=lastPage%>&localName=<%=localName%>"><img src="<%=request.getContextPath()%>/img/last.png" style="width:18px;"></a></li>
		</ul>
		<div class="mt-5 p-4 bg-dark text-white text-center">
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>