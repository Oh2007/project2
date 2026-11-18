<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.net.URLEncoder, java.text.SimpleDateFormat, com.market.bookitem.*, com.market.cart.*, com.market.member.*"%>
<%!
	// HTML 특수문자 변환 (입력값을 안전하게 출력)
	static String h(String s) {
		if (s == null) return "";
		return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
	}

	// 27000 -> 27,000원
	static String won(int n) {
		return String.format("%,d", n) + "원";
	}

	// 화면 위쪽에 한 번만 보여 줄 안내 메시지
	static void flash(jakarta.servlet.http.HttpSession s, String msg, boolean error) {
		s.setAttribute("flash", msg);
		if (error) s.setAttribute("flashErr", "1"); else s.removeAttribute("flashErr");
	}

	// 아이콘 (header.jsp 의 SVG 스프라이트 사용)
	static String ic(String name) {
		return "<svg class=\"ic\"><use href=\"#i-" + name + "\"/></svg>";
	}

	// 로그인 후 돌아갈 곳 : 정해진 페이지만 허용
	static String safeNext(String next) {
		if (next != null && (next.equals("cart.jsp") || next.equals("shipping.jsp") || next.equals("guestInfo.jsp")
				|| next.equals("orders.jsp") || next.equals("wishlist.jsp") || next.equals("coupons.jsp")))
			return next;
		return "index.jsp";
	}

	// 로그인 처리 공통 : 세션ID 새로 발급(세션 고정 공격 방지) 후 고객 정보 저장
	static void doLogin(jakarta.servlet.http.HttpServletRequest req, jakarta.servlet.http.HttpSession s, User u) {
		req.changeSessionId();
		s.setAttribute("loginUser", u);
	}
%>
<%
	/* ===== 모든 JSP 맨 위에서 공통으로 실행 ===== */
	request.setCharacterEncoding("UTF-8");

	// 장바구니 : 접속자(세션)마다 1개
	Cart cart = (Cart) session.getAttribute("cart");
	if (cart == null) {
		cart = new Cart();
		session.setAttribute("cart", cart);
	}

	// 로그인(고객 정보) : null 이면 로그인 전
	User loginUser = (User) session.getAttribute("loginUser");
	boolean isAdmin = session.getAttribute("isAdmin") != null;

	// 쿠폰 : 장바구니에 적용한 쿠폰 1장
	Coupon appliedCoupon = (Coupon) session.getAttribute("coupon");

	// 찜 목록 (도서ID 모음)
	@SuppressWarnings("unchecked")
	LinkedHashSet<String> wishSet = (LinkedHashSet<String>) session.getAttribute("wish");
	if (wishSet == null) {
		wishSet = new LinkedHashSet<String>();
		session.setAttribute("wish", wishSet);
	}

	// 실제 파일 경로 (톰캣에 배포된 위치)
	String bookFile = application.getRealPath("/WEB-INF/book.txt");
	String memberFile = application.getRealPath("/WEB-INF/members.txt");
%>
