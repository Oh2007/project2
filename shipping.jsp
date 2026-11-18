<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 주문(배송지 입력) - Swing 의 CartShippingPage 와 같은 역할 + 쿠폰/배송비 계산
	 * [연결되는 자바] cart.Cart / Pricing / Coupon / OrderStore(주문 저장), member.User, member.UserInIt(입력 검사)
	 */
	if (cart.getmCartItem().isEmpty()) {
		flash(session, "장바구니에 항목이 없습니다.", true);
		response.sendRedirect("index.jsp");
		return;
	}
	if (loginUser == null) {
		response.sendRedirect("login.jsp?next=shipping.jsp");
		return;
	}

	boolean hasPhone = !loginUser.getPhone().isEmpty();
	String error = null;
	boolean same = true; // 배송받을 분이 고객정보와 같은가
	String sName = loginUser.getName();
	String sPhone = loginUser.getPhone();
	String sAddress = "";

	// 쿠폰을 이미 썼다면 해제
	if (appliedCoupon != null && OrderStore.hasUsedCoupon(loginUser.getKey(), appliedCoupon.getCode())) {
		session.removeAttribute("coupon");
		appliedCoupon = null;
	}
	Pricing pr = Pricing.of(cart, appliedCoupon);

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		same = !"no".equals(request.getParameter("same"));
		sAddress = request.getParameter("address");
		if (sAddress == null) sAddress = "";
		sAddress = sAddress.trim();
		if (same) {
			sName = loginUser.getName();
			sPhone = loginUser.getPhone();
			if (!hasPhone) { // 소셜 로그인 계정은 연락처가 없으므로 입력한 값을 사용
				sPhone = request.getParameter("phone");
				if (sPhone == null) sPhone = "";
			}
		} else {
			sName = request.getParameter("name");
			sPhone = request.getParameter("phone");
			if (sName == null) sName = "";
			if (sPhone == null) sPhone = "";
		}

		if (!UserInIt.isValidName(sName)) {
			error = "고객명을 입력하세요.";
		} else if (!UserInIt.isValidPhone(sPhone)) {
			error = "연락처는 숫자와 - 만 사용해 9~13자로 입력하세요.";
		} else if (sAddress.isEmpty()) {
			error = "배송지를 입력하세요.";
		} else {
			// 주문 내역을 저장하고 장바구니/쿠폰은 비운다. (Swing: mCart.deleteBook())
			ArrayList<CartItem> copy = new ArrayList<CartItem>(cart.getmCartItem());
			boolean usedCp = appliedCoupon != null && appliedCoupon.isUsable(pr.subtotal);
			Order order = OrderStore.add(loginUser.getKey(), sName.trim(), sPhone.trim(), sAddress, copy, pr,
					usedCp ? appliedCoupon.getCode() : null, usedCp ? appliedCoupon.getName() : null);
			cart.deleteBook();
			session.removeAttribute("coupon");
			response.sendRedirect("orderBill.jsp?id=" + order.getOrderId());
			return;
		}
	}

	String menu = "order";
	String pageTitle = "주문하기";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>주문하기</h2><p>배송 정보를 확인하고 주문을 완료하세요.</p></div>
</div>

<div class="two-col">
	<div class="card">
		<h3>배송 정보</h3>
		<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>
		<% if (!hasPhone) { %><div class="alert info">소셜 로그인 계정에는 연락처가 없어요. 연락처를 입력해 주세요.</div><% } %>
		<form method="post" action="shipping.jsp">
			<div class="field">
				<label>배송받을 분은 고객정보와 같습니까?</label>
				<div class="radio-row">
					<label><input type="radio" name="same" id="same-yes" value="yes" <%=same ? "checked" : ""%>> 예</label>
					<label><input type="radio" name="same" id="same-no" value="no" <%=same ? "" : "checked"%>> 아니오</label>
				</div>
			</div>
			<div class="field"><label for="f-name">고객명</label><input type="text" id="f-name" name="name" value="<%=h(sName)%>" data-user="<%=h(loginUser.getName())%>" maxlength="20"></div>
			<div class="field"><label for="f-phone">연락처</label><input type="tel" id="f-phone" name="phone" value="<%=h(sPhone)%>" data-user="<%=h(loginUser.getPhone())%>" maxlength="13" placeholder="010-1234-5678"></div>
			<div class="field"><label for="f-address">배송지</label><input type="text" id="f-address" name="address" value="<%=h(sAddress)%>" maxlength="100" placeholder="배송받을 주소를 입력하세요"></div>
			<div class="btn-row"><a class="btn line" href="cart.jsp">장바구니로</a><button type="submit" class="btn">결제하고 주문 완료</button></div>
		</form>
	</div>

	<div class="card">
		<h3>주문 내역</h3>
		<ul class="summary">
<% for (CartItem item : cart.getmCartItem()) { %>
			<li><span><%=h(item.getItemBook().getName())%> × <%=item.getQuantity()%></span><span><%=won(item.getTotalPrice())%></span></li>
<% } %>
		</ul>
		<% if (appliedCoupon != null) { %><div class="applied"><span>🎟 <%=h(appliedCoupon.getName())%></span></div><% } %>
		<div class="sum-row"><span>상품 금액</span><span><%=won(pr.subtotal)%></span></div>
		<% if (pr.discount > 0) { %><div class="sum-row disc"><span>쿠폰 할인</span><span>- <%=won(pr.discount)%></span></div><% } %>
		<div class="sum-row"><span>배송비</span><span><%=pr.shipping == 0 ? "무료" : won(pr.shipping)%></span></div>
		<div class="sum-row total"><span>최종 결제 금액</span><span><%=won(pr.total)%></span></div>
	</div>
</div>

<script>
	// 예/아니오 선택에 따라 고객명/연락처 입력칸 전환 (Swing 의 라디오 버튼 동작)
	(function () {
		var yes = document.getElementById('same-yes'), no = document.getElementById('same-no');
		var n = document.getElementById('f-name'), p = document.getElementById('f-phone');
		function lock(isSame, clear) {
			var hasPhone = p.dataset.user !== '';
			n.readOnly = isSame;
			p.readOnly = isSame && hasPhone;
			if (isSame) { n.value = n.dataset.user; if (hasPhone) p.value = p.dataset.user; if (!hasPhone && clear) p.focus(); }
			else if (clear) { n.value = ''; p.value = ''; n.focus(); }
		}
		yes.addEventListener('change', function () { lock(true, true); });
		no.addEventListener('change', function () { lock(false, true); });
		lock(yes.checked, false);
	})();
</script>

<%@ include file="common/footer.jsp"%>
