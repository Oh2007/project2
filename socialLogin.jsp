<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 소셜 로그인 (신규) : Google
	 *  - Google : web.xml 의 GOOGLE_CLIENT_ID 를 채우면 "진짜 구글 로그인"(ID 토큰 검증, member.GoogleAuth).
	 *             비워 두면 발표/시연용 "데모 모드"(계정 선택 화면 모방)로 동작한다.
	 */
	String provider = request.getParameter("provider");
	if (!"google".equals(provider)) {
		response.sendRedirect("login.jsp");
		return;
	}
	String next = safeNext(request.getParameter("next"));
	String label = "Google";
	String gClient = application.getInitParameter("GOOGLE_CLIENT_ID");
	if (gClient == null) gClient = "";
	gClient = gClient.trim();
	boolean realGoogle = "google".equals(provider) && !gClient.isEmpty();

	String error = null;
	String email = "", name = "";

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		User u = null;
		if (realGoogle) {
			String[] info = GoogleAuth.verify(request.getParameter("credential"), gClient);
			if (info == null) {
				error = "구글 로그인 확인에 실패했습니다. 다시 시도해 주세요.";
			} else {
				u = new User(info[1], "");
				u.setEmail(info[0]);
			}
		} else {
			email = request.getParameter("email");
			name = request.getParameter("name");
			if (email == null) email = "";
			if (name == null) name = "";
			email = email.trim();
			name = name.trim();
			if (!email.matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+")) {
				error = "이메일 형식으로 입력하세요. (예: hong@gmail.com)";
			} else if (!UserInIt.isValidName(name)) {
				error = "이름을 입력하세요. (20자 이내)";
			} else {
				u = new User(name, "");
				u.setEmail(email);
			}
		}
		if (u != null) {
			u.setProvider(provider);
			u.setKey(provider + ":" + u.getEmail().toLowerCase());
			doLogin(request, session, u);
			flash(session, u.getName() + "님, " + label + " 계정으로 로그인했습니다.", false);
			response.sendRedirect(next);
			return;
		}
	}

	String menu = "";
	String pageTitle = label + " 로그인";
%>
<%@ include file="common/header.jsp"%>

<div class="card narrow">
	<div class="provider-head">
		<img src="images/<%=provider%>.svg" alt="">
		<div><h3 style="margin:0"><%=label%> 계정으로 계속하기</h3><span class="hint"><%=realGoogle ? "Google 계정으로 안전하게 로그인합니다." : ""%></span></div>
	</div>
	<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>

<% if (realGoogle) { %>
	<div id="g_id_onload" data-client_id="<%=h(gClient)%>" data-callback="onGoogle" data-auto_prompt="false"></div>
	<div class="g_id_signin" data-type="standard" data-size="large" data-text="continue_with" data-locale="ko" data-width="360"></div>
	<form id="gform" method="post" action="socialLogin.jsp">
		<input type="hidden" name="provider" value="google"><input type="hidden" name="next" value="<%=h(next)%>"><input type="hidden" name="credential" id="cred">
	</form>
	<script src="https://accounts.google.com/gsi/client" async defer></script>
	<script>function onGoogle(r) { document.getElementById('cred').value = r.credential; document.getElementById('gform').submit(); }</script>
<% } else { %>
	<form method="post" action="socialLogin.jsp">
		<input type="hidden" name="provider" value="<%=provider%>"><input type="hidden" name="next" value="<%=h(next)%>">
		<div class="field"><label for="email">이메일</label><input type="email" id="email" name="email" value="<%=h(email)%>" placeholder="hong@gmail.com" autofocus></div>
		<div class="field"><label for="name">이 름</label><input type="text" id="name" name="name" value="<%=h(name)%>" maxlength="20" placeholder="홍길동"></div>
		<button type="submit" class="btn block"><%=label%>로 로그인</button>
	</form>
<% } %>
	<div class="links"><a href="login.jsp">← 다른 방법으로 로그인</a></div>
</div>

<%@ include file="common/footer.jsp"%>
