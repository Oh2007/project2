<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* [연결되는 자바] member.Admin (아이디/비밀번호 확인) */
	if (isAdmin) {
		response.sendRedirect("admin.jsp");
		return;
	}

	String error = null;
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		Admin admin = new Admin("", "");
		if (admin.checkLogin(request.getParameter("id"), request.getParameter("pw"))) {
			request.changeSessionId();
			session.setAttribute("isAdmin", Boolean.TRUE);
			flash(session, "관리자로 로그인했습니다.", false);
			response.sendRedirect("admin.jsp");
			return;
		}
		error = "관리자 정보가 일치하지 않습니다.";
	}

	String menu = "admin";
	String pageTitle = "관리자 로그인";
%>
<%@ include file="common/header.jsp"%>

<div class="card narrow">
	<h3 style="font-size:20px"><%=ic("shield")%> 관리자 로그인</h3>
	<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>
	<form method="post" action="adminLogin.jsp">
		<div class="field"><label for="id">아이디</label><input type="text" id="id" name="id" autofocus></div>
		<div class="field"><label for="pw">비밀번호</label><input type="password" id="pw" name="pw"></div>
		<div class="btn-row" style="margin-top:6px"><a class="btn line" href="index.jsp">취소</a><button type="submit" class="btn">확인</button></div>
	</form>
</div>

<%@ include file="common/footer.jsp"%>
