<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 사용법 : 이 파일을 include 하기 전에 String menu, String pageTitle 을 지정한다. --%>
<%
	int cartQty = 0;
	for (CartItem ci : cart.getmCartItem()) cartQty += ci.getQuantity();
	String q0 = request.getParameter("q");
	if (q0 == null || !"list".equals(menu)) q0 = "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=h(pageTitle)%> · BookMarket</title>
<link rel="icon" href="images/shop.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&family=Noto+Serif+KR:wght@600;800&display=swap">
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%-- ===== 아이콘 스프라이트 ===== --%>
<svg width="0" height="0" style="position:absolute" aria-hidden="true">
	<defs>
		<symbol id="i-book" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></symbol>
		<symbol id="i-cart" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path d="M1 1h4l2.7 13.4a2 2 0 0 0 2 1.6h9.7a2 2 0 0 0 2-1.6L23 6H6"/></symbol>
		<symbol id="i-package" viewBox="0 0 24 24"><path d="M16.5 9.4 7.5 4.2"/><path d="M21 16V8a2 2 0 0 0-1-1.7l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.7l7 4a2 2 0 0 0 2 0l7-4a2 2 0 0 0 1-1.7z"/><path d="M3.3 7 12 12l8.7-5M12 22V12"/></symbol>
		<symbol id="i-heart" viewBox="0 0 24 24"><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.7l-1-1.1a5.5 5.5 0 0 0-7.8 7.8l1 1.1L12 21.2l7.8-7.7 1-1.1a5.5 5.5 0 0 0 0-7.8z"/></symbol>
		<symbol id="i-ticket" viewBox="0 0 24 24"><path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z"/><path d="M13 5v2M13 17v2M13 11v2"/></symbol>
		<symbol id="i-user" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></symbol>
		<symbol id="i-shield" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></symbol>
		<symbol id="i-logout" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></symbol>
		<symbol id="i-login" viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/></symbol>
		<symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></symbol>
	</defs>
</svg>

<div class="app">
	<%-- ===== 왼쪽 사이드바 (메뉴) ===== --%>
	<aside class="side">
		<a class="brand" href="index.jsp">
			<span class="brand-mark"><svg class="ic"><use href="#i-book"/></svg></span>
			<span class="brand-txt">BookMarket<small>온라인 서점</small></span>
		</a>
		<nav class="nav">
			<a href="index.jsp" class="<%="list".equals(menu) ? "on" : ""%>"><%=ic("book")%>도서 둘러보기</a>
			<a href="wishlist.jsp" class="<%="wish".equals(menu) ? "on" : ""%>"><%=ic("heart")%>찜한 도서<% if (wishSet.size() > 0) { %><span class="pill"><%=wishSet.size()%></span><% } %></a>
			<a href="cart.jsp" class="<%="cart".equals(menu) ? "on" : ""%>"><%=ic("cart")%>장바구니<% if (cartQty > 0) { %><span class="pill hot"><%=cartQty%></span><% } %></a>
			<a href="shipping.jsp" class="<%="order".equals(menu) ? "on" : ""%>"><%=ic("package")%>주문하기</a>
			<a href="orders.jsp" class="<%="orders".equals(menu) ? "on" : ""%>"><%=ic("package")%>주문 현황</a>
			<a href="coupons.jsp" class="<%="coupon".equals(menu) ? "on" : ""%>"><%=ic("ticket")%>쿠폰함</a>
			<a href="guestInfo.jsp" class="<%="info".equals(menu) ? "on" : ""%>"><%=ic("user")%>내 정보</a>
		</nav>
		<div class="side-bottom">
			<a href="admin.jsp" class="<%="admin".equals(menu) ? "on" : ""%> admin-link"><%=ic("shield")%>관리자 센터</a>
			<% if (loginUser != null || isAdmin) { %>
			<a href="logout.jsp"><%=ic("logout")%>로그아웃</a>
			<% } else { %>
			<a href="login.jsp"><%=ic("login")%>로그인 / 가입</a>
			<% } %>
		</div>
	</aside>

	<div class="main">
		<%-- ===== 상단바 (검색 + 사용자 칩 + 장바구니) ===== --%>
		<header class="topbar">
			<form class="topsearch" method="get" action="index.jsp">
				<%=ic("search")%>
				<input type="text" name="q" value="<%=h(q0)%>" placeholder="도서명 또는 저자를 검색해 보세요">
			</form>
			<div class="top-right">
				<% if (loginUser != null) { %>
				<a class="chip" href="guestInfo.jsp"><span class="dot <%=h(loginUser.getProvider())%>"></span><%=h(loginUser.getName())%>님</a>
				<% } else if (isAdmin) { %>
				<a class="chip admin" href="admin.jsp">관리자</a>
				<% } else { %>
				<a class="chip" href="login.jsp">로그인</a>
				<% } %>
				<a class="cart-btn" href="cart.jsp" title="장바구니"><%=ic("cart")%><% if (cartQty > 0) { %><span class="cart-badge"><%=cartQty%></span><% } %></a>
			</div>
		</header>

		<main class="content">
<%
	// 한 번만 보여 주는 안내 메시지
	String flashMsg = (String) session.getAttribute("flash");
	if (flashMsg != null) {
		boolean flashErr = session.getAttribute("flashErr") != null;
		session.removeAttribute("flash");
		session.removeAttribute("flashErr");
%>
			<div class="alert <%=flashErr ? "err" : "ok"%>"><%=h(flashMsg)%></div>
<% } %>
