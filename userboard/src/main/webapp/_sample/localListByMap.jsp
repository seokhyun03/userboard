<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//db 접속
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
	String sql = "SELECT local_name localName, '대한민국' country, '정석현' worker FROM local LIMIT 0,1";
	stmt = conn.prepareStatement(sql);
	// sql 디버깅
	System.out.println(stmt + " <-- insertMemberAction sql");
	// 전송한 sql 실행값 반환
	rs = stmt.executeQuery();
	// VO대신 HashMap타입 사용
	HashMap<String, Object> map = null;
	if(rs.next()) {
		// 디버깅
		// System.out.println(rs.getString("localName"));
		// System.out.println(rs.getString("country"));
		// System.out.println(rs.getString("worker"));
		map = new HashMap<String, Object>();
		map.put("localName", rs.getString("localName"));	// map.put(키이름, 값);
		map.put("country", rs.getString("country"));
		map.put("worker", rs.getString("worker"));
	}
	out.println((String)map.get("localName"));
	out.println((String)map.get("country"));
	out.println((String)map.get("worker"));
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국' country, '정석현' worker FROM local";
	stmt2 = conn.prepareStatement(sql2);
	// sql 디버깅
	System.out.println(stmt2 + " <-- insertMemberAction sql");
	// 전송한 sql 실행값 반환
	rs2 = stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("country", rs2.getString("country"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(*) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	// sql 디버깅
	System.out.println(stmt3 + " <-- insertMemberAction sql");
	// 전송한 sql 실행값 반환
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName"));
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>localListByMap</title>
</head>
<body>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
				<tr>
					<td><%=(String)m.get("localName") %></td>
					<td><%=(String)m.get("country") %></td>
					<td><%=(String)m.get("worker") %></td>
				</tr>
		<%		
			}
		%>
	</table>
	<hr>
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String, Object> m : list3) {
		%>	
				<li>
					<a href="">
						<%=(String)m.get("localName") %>(<%=(int)m.get("cnt") %>)
					</a>
				</li>
		<%		
			}
		%>
	</ul>
</body>
</html>