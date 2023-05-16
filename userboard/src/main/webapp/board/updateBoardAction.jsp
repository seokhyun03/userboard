<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사(로그인 유무)
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	System.out.println(request.getParameter("boardNo") + " <-- updateBoardAction parameter boardNo");
	System.out.println(request.getParameter("localName") + " <-- updateBoardAction parameter localName");
	System.out.println(request.getParameter("boardTitle") + " <-- updateBoardAction parameter boardTitle");
	System.out.println(request.getParameter("boardTitle") + " <-- updateBoardAction parameter boardContent");

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	// 요청값 유효성 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = "";
	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("지역을 선택하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(request.getParameter("boardTitle") == null
		|| request.getParameter("boardTitle").equals("")) {
		msg = URLEncoder.encode("제목을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	if(request.getParameter("boardContent") == null
		|| request.getParameter("boardContent").equals("")) {
		msg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
	}
	
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	// 디버깅
	System.out.println(boardNo + " <-- updateBoardAction parameter boardNo");
	System.out.println(localName + " <-- updateBoardAction parameter localName");
	System.out.println(boardTitle + " <-- updateBoardAction parameter boardTitle");
	System.out.println(boardContent + " <-- updateBoardAction parameter boardContent");
	
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
	PreparedStatement updateBoardStmt = null;
	String updateBoardSql = "UPDATE board SET local_name=?, board_title=?, board_content=?, updatedate=NOW() WHERE board_no =? AND member_id=?";
	updateBoardStmt = conn.prepareStatement(updateBoardSql);
	updateBoardStmt.setString(1, localName);
	updateBoardStmt.setString(2, boardTitle);
	updateBoardStmt.setString(3, boardContent);
	updateBoardStmt.setInt(4, boardNo);
	updateBoardStmt.setString(5, loginMemberId);
	// 위 sql 디버깅
	System.out.println(updateBoardStmt + " <-- updateBoardAction updateBoardStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = updateBoardStmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("게시물 수정 성공");
	}
	
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>