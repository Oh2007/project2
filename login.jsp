<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 로그인 - 소셜 로그인(아이콘) / 자체 회원(암호화 저장) / 비회원(이름+연락처, Swing GuestWindow 와 같은 역할)
	 * [연결되는 자바] member.MemberStore (회원 확인), member.UserInIt (입력값 검사), member.User
	 */
	String next = safeNext(request.getParameter("next"));
	String error = null;
	String mode = "member";
	String uid = "", name = "", phone = "";

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		mode = "guest".equals(request.getParameter("mode")) ? "guest" : "member";
		if ("member".equals(mode)) {
			uid = request.getParameter("uid");
			if (uid == null) uid = "";
			User u = MemberStore.login(memberFile, uid, request.getParameter("pw"));
			if (u == null) {
				error = "아이디 또는 비밀번호가 맞지 않습니다.";
			} else {
				doLogin(request, session, u);
				flash(session, u.getName() + "님, 환영합니다.", false);
				response.sendRedirect(next);
				return;
			}
		} else {
			name = request.getParameter("name");
			phone = request.getParameter("phone");
			if (name == null) name = "";
			if (phone == null) phone = "";
			if (!UserInIt.isValidName(name)) {
				error = "이름을 입력하세요. (20자 이내)";
			} else if (!UserInIt.isValidPhone(phone)) {
				error = "연락처는 숫자와 - 만 사용해 9~13자로 입력하세요.";
			} else {
				User u = UserInIt.init(name, phone); // 비회원 : 기존 Swing 방식 그대로
				doLogin(request, session, u);
				flash(session, u.getName() + "님, 환영합니다.", false);
				response.sendRedirect(next);
				return;
			}
		}
	}

	String menu = "";
	String pageTitle = "로그인";
	String nextQ = URLEncoder.encode(next, "UTF-8");
%>
<%@ include file="common/header.jsp"%>

<div class="login-wrap">
	<div class="login-art">
		<h2>책 한 권의 여유,<br>BookMarket과 함께</h2>
		<p>로그인하면 더 편하게 이용할 수 있어요.</p>
		<ul>
			<li>주문 현황 · 배송 상태 실시간 확인</li>
			<li>쿠폰함 / 찜한 도서 보관</li>
			<li>구매금액에 따른 회원 등급</li>
		</ul>
	</div>
	<div class="login-form">
		<h3>로그인</h3>

		<div class="social">
			<a href="socialLogin.jsp?provider=google&next=<%=nextQ%>" title="Google로 계속하기"><img src="images/google.svg" alt="Google"></a>
		</div>
		<div class="social-labels"><span>Google</span></div>

		<div class="divider">또는</div>

		<div class="tabs2">
			<button type="button" id="t-member" class="<%="member".equals(mode) ? "on" : ""%>">회원 로그인</button>
			<button type="button" id="t-guest" class="<%="guest".equals(mode) ? "on" : ""%>">비회원 주문</button>
		</div>
		<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>

		<form method="post" action="login.jsp" id="p-member" class="pane <%="member".equals(mode) ? "on" : ""%>">
			<input type="hidden" name="mode" value="member"><input type="hidden" name="next" value="<%=h(next)%>">
			<div class="field"><label for="uid">아이디</label><input type="text" id="uid" name="uid" value="<%=h(uid)%>" maxlength="15" autofocus></div>
			<div class="field"><label for="pw">비밀번호</label><input type="password" id="pw" name="pw"></div>
			<button type="submit" class="btn block">로그인</button>
			<div class="links">아직 회원이 아니신가요? <a href="signup.jsp?next=<%=nextQ%>">회원가입</a></div>
		</form>

		<form method="post" action="login.jsp" id="p-guest" class="pane <%="guest".equals(mode) ? "on" : ""%>">
			<input type="hidden" name="mode" value="guest"><input type="hidden" name="next" value="<%=h(next)%>">
			<div class="field"><label for="name">이 름</label><input type="text" id="name" name="name" value="<%=h(name)%>" maxlength="20" placeholder="홍길동"></div>
			<div class="field"><label for="phone">연락처</label><input type="tel" id="phone" name="phone" value="<%=h(phone)%>" maxlength="13" placeholder="010-1234-5678"></div>
			<button type="submit" class="btn block"><img src="images/shop.png" alt="" style="width:18px;height:18px">쇼핑하기</button>
			<div class="links">비회원은 이름/연락처만 입력하면 바로 주문할 수 있어요.</div>
		</form>
	</div>
</div>

<script>
	(function () {
		var tm = document.getElementById('t-member'), tg = document.getElementById('t-guest');
		var pm = document.getElementById('p-member'), pg = document.getElementById('p-guest');
		function show(member) {
			tm.classList.toggle('on', member); tg.classList.toggle('on', !member);
			pm.classList.toggle('on', member); pg.classList.toggle('on', !member);
		}
		tm.onclick = function () { show(true); };
		tg.onclick = function () { show(false); };
	})();
</script>

<%@ include file="common/footer.jsp"%>
