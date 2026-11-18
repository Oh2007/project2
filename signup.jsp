<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 회원가입 (신규) : 비밀번호는 SHA-256 + salt 로 암호화되어 WEB-INF/members.txt 에 저장된다. */
	String next = safeNext(request.getParameter("next"));
	String error = null;
	String uid = "", name = "", phone = "";

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		uid = request.getParameter("uid");
		name = request.getParameter("name");
		phone = request.getParameter("phone");
		String pw = request.getParameter("pw");
		String pw2 = request.getParameter("pw2");
		if (uid == null) uid = "";
		if (name == null) name = "";
		if (phone == null) phone = "";
		if (pw == null) pw = "";

		if (!pw.equals(pw2)) {
			error = "비밀번호 확인이 일치하지 않습니다.";
		} else {
			error = MemberStore.register(memberFile, uid.trim(), pw, name, phone);
			if (error == null) {
				User u = MemberStore.login(memberFile, uid.trim(), pw);
				doLogin(request, session, u);
				flash(session, "가입을 축하합니다! 쿠폰함에서 WELCOME10 쿠폰을 확인하세요. 🎁", false);
				response.sendRedirect(next);
				return;
			}
		}
	}

	String menu = "";
	String pageTitle = "회원가입";
%>
<%@ include file="common/header.jsp"%>

<div class="card wide">
	<h3 style="font-size:20px">회원가입</h3>
	<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>
	<form method="post" action="signup.jsp">
		<input type="hidden" name="next" value="<%=h(next)%>">
		<div class="field"><label for="uid">아이디 <span class="hint">(영문/숫자 4~15자)</span></label><input type="text" id="uid" name="uid" value="<%=h(uid)%>" maxlength="15" autofocus></div>
		<div class="field"><label for="pw">비밀번호 <span class="hint">(6자 이상)</span></label><input type="password" id="pw" name="pw" maxlength="30"></div>
		<div class="field"><label for="pw2">비밀번호 확인</label><input type="password" id="pw2" name="pw2" maxlength="30"></div>
		<div class="field"><label for="name">이 름</label><input type="text" id="name" name="name" value="<%=h(name)%>" maxlength="20"></div>
		<div class="field"><label for="phone">연락처</label><input type="tel" id="phone" name="phone" value="<%=h(phone)%>" maxlength="13" placeholder="010-1234-5678"></div>
		<div class="btn-row"><a class="btn line" href="login.jsp">취소</a><button type="submit" class="btn">가입하기</button></div>
	</form>
</div>

<%@ include file="common/footer.jsp"%>
