<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 내 정보 (고객 정보 관리) [연결되는 자바] member.User (등급 계산 포함), cart.OrderStore */
	if (loginUser == null) {
		response.sendRedirect("login.jsp?next=guestInfo.jsp");
		return;
	}
	ArrayList<Order> mine = OrderStore.byOwner(loginUser.getKey());
	int spent = OrderStore.totalSpent(loginUser.getKey());
	String grade = User.gradeOf(spent);
	int nextGoal = "BASIC".equals(grade) ? 50000 : "SILVER".equals(grade) ? 100000 : 0;
	String nextName = "BASIC".equals(grade) ? "SILVER" : "GOLD";
	int percent = nextGoal == 0 ? 100 : Math.min(100, spent * 100 / nextGoal);
	int doing = 0;
	for (Order o : mine) if (!o.isCanceled() && o.getStepIndex() < 3) doing++;
	String phone = loginUser.getPhone().isEmpty() ? "-" : loginUser.getPhone();
	String menu = "info";
	String pageTitle = "내 정보";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>내 정보</h2><p>고객 정보와 주문 활동을 한눈에 확인하세요.</p></div>
</div>

<div class="stats">
	<div class="stat"><div class="k">회원 등급</div><div class="v"><span class="grade <%=grade%>"><%=grade%></span></div></div>
	<div class="stat"><div class="k">총 구매금액</div><div class="v t"><%=won(spent)%></div></div>
	<div class="stat"><div class="k">전체 주문</div><div class="v"><%=mine.size()%>건</div></div>
	<div class="stat"><div class="k">배송 진행 중</div><div class="v"><%=doing%>건</div></div>
</div>

<div class="two-col">
	<div class="card">
		<div class="profile">
			<img class="avatar" src="images/user.png" alt="">
			<div><h3 style="margin:0;font-size:20px"><%=h(loginUser.getName())%></h3><span class="badge"><%=h(loginUser.getProviderLabel())%> 로그인</span></div>
		</div>
		<dl class="bill-info">
			<dt>이 름</dt><dd><%=h(loginUser.getName())%></dd>
			<dt>연락처</dt><dd><%=h(phone)%></dd>
<% if (!loginUser.getEmail().isEmpty()) { %>
			<dt>이메일</dt><dd><%=h(loginUser.getEmail())%></dd>
<% } %>
			<dt>로그인 방식</dt><dd><%=h(loginUser.getProviderLabel())%></dd>
		</dl>
		<% if (nextGoal > 0) { %>
		<div class="hint"><b><%=won(nextGoal - spent)%></b> 더 구매하면 <b><%=nextName%></b> 등급이 됩니다.</div>
		<div class="progress"><i style="width:<%=percent%>%"></i></div>
		<% } else { %>
		<div class="hint" style="color:var(--ok)">최고 등급(GOLD)입니다. 감사합니다 🎉</div>
		<% } %>
	</div>
	<div class="card">
		<h3>바로가기</h3>
		<div style="display:flex;flex-direction:column;gap:10px">
			<a class="btn line" href="orders.jsp"><%=ic("package")%>주문 현황 보기</a>
			<a class="btn line" href="coupons.jsp"><%=ic("ticket")%>쿠폰함</a>
			<a class="btn line" href="wishlist.jsp"><%=ic("heart")%>찜한 도서 (<%=wishSet.size()%>)</a>
			<a class="btn danger" href="logout.jsp"><%=ic("logout")%>로그아웃</a>
		</div>
	</div>
</div>

<%@ include file="common/footer.jsp"%>
