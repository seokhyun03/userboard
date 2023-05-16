<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<nav class="navbar bg-dark navbar-dark">
	<div class="container-fluid">
		<a class="navbar-brand" href="<%=request.getContextPath()%>/home.jsp">
	      <img src="<%=request.getContextPath()%>/img/home.png" alt="Avatar Logo" style="width:40px;"> 
	    </a>
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavbar">
	      <img src="<%=request.getContextPath()%>/img/menu.png" class="navbar-toggler-icon"> 
	    </button>
	    <div class="collapse navbar-collapse" id="collapsibleNavbar">
		    <ul class="navbar-nav">
				<!-- 
					로그인전 : 회원가입
					로그인후 : 회원정보 / 로그아웃
					로그인 정보 <-- loginMemberId
				 -->
				<%
				 	if(session.getAttribute("loginMemberId") == null) { // 로그인 전
		 		%>
		 				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
				<%	
				 	} else {	// 로그인 후
		 		%>
		 				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/profileForm.jsp">회원정보</a></li>
		 				<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
				<%		
				 	}
				%>
			</ul>
	    </div>
	</div>
</nav>