<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 장바구니/쿠폰/찜 처리 전용 (화면 없음 -> 처리 후 redirect)
	 * [연결되는 자바] cart.Cart, cart.CouponInIt/Coupon, cart.OrderStore(쿠폰 사용 여부), bookitem.BookInIt
	 * action : add(담기) buy(바로구매) inc(수량+) dec(수량-) remove(항목삭제) clear(비우기)
	 *          coupon(쿠폰적용) uncoupon(쿠폰해제) wish(찜 토글)
	 */
	if (!"POST".equalsIgnoreCase(request.getMethod())) {
		response.sendRedirect("cart.jsp");
		return;
	}

	String action = request.getParameter("action");
	String id = request.getParameter("id");
	String back = request.getParameter("back");

	// 처리 후 돌아갈 곳 : 정해진 페이지 형식만 허용 (엉뚱한 주소로 보내지 못하게)
	if (back == null || !back.matches("^(index|wishlist|bookDetail|cart|coupons)\\.jsp(\\?[A-Za-z0-9%=&_.+\\-]*)?$"))
		back = "cart.jsp";

	if ("add".equals(action) || "buy".equals(action)) {
		BookInIt.init(bookFile);
		Book book = BookInIt.getBookById(id);
		if (book == null) {
			flash(session, "존재하지 않는 도서입니다.", true);
		} else {
			boolean again = cart.isCartInBook(id); // 이미 담겨 있으면 수량 +1
			if (!again) cart.insertBook(book);
			if ("buy".equals(action)) {
				response.sendRedirect("shipping.jsp");
				return;
			}
			flash(session, again ? "'" + book.getName() + "' 이(가) 이미 담겨 있어 수량을 1 늘렸습니다."
					: "'" + book.getName() + "' 을(를) 장바구니에 담았습니다.", false);
		}
	} else if ("inc".equals(action)) {
		cart.increaseQuantity(id);
	} else if ("dec".equals(action)) {
		if (!cart.decreaseQuantity(id))
			flash(session, "수량은 1개 이상이어야 합니다. 빼려면 [삭제]를 눌러 주세요.", true);
	} else if ("remove".equals(action)) {
		if (cart.removeBook(id)) flash(session, "선택한 항목을 삭제했습니다.", false);
	} else if ("clear".equals(action)) {
		if (cart.mCartCount == 0) {
			flash(session, "장바구니에 항목이 없습니다.", true);
		} else {
			cart.deleteBook();
			session.removeAttribute("coupon");
			flash(session, "장바구니의 모든 항목을 삭제했습니다.", false);
		}
	} else if ("coupon".equals(action)) {
		Coupon cp = CouponInIt.find(request.getParameter("code"));
		int sub = cart.getTotalPrice();
		if (cp == null) {
			flash(session, "존재하지 않는 쿠폰 코드입니다.", true);
		} else if (!cp.isUsable(sub)) {
			flash(session, "'" + cp.getName() + "' 은(는) " + won(cp.getMinPrice()) + " 이상 주문 시 사용할 수 있습니다.", true);
		} else if (loginUser != null && OrderStore.hasUsedCoupon(loginUser.getKey(), cp.getCode())) {
			flash(session, "이미 사용한 쿠폰입니다. (쿠폰은 1인 1회)", true);
		} else {
			session.setAttribute("coupon", cp);
			flash(session, "쿠폰이 적용되었습니다 : " + cp.getName(), false);
		}
	} else if ("uncoupon".equals(action)) {
		session.removeAttribute("coupon");
		flash(session, "쿠폰 적용을 해제했습니다.", false);
	} else if ("wish".equals(action)) {
		if (id != null) {
			if (wishSet.contains(id)) {
				wishSet.remove(id);
				flash(session, "찜 목록에서 뺐습니다.", false);
			} else {
				wishSet.add(id);
				flash(session, "찜 목록에 담았습니다. ❤", false);
			}
		}
	}
	response.sendRedirect(back);
%>
