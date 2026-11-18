<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* [연결되는 자바] cart.Cart, cart.CartItem, cart.Pricing(금액 계산), cart.Coupon */
	ArrayList<CartItem> items = cart.getmCartItem();
	Pricing pr = Pricing.of(cart, appliedCoupon);
	int remain = Pricing.FREE_SHIP_LIMIT - pr.subtotal;
	int percent = Math.min(100, pr.subtotal * 100 / Pricing.FREE_SHIP_LIMIT);
	String menu = "cart";
	String pageTitle = "장바구니";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>장바구니</h2><p>수량을 바로 조절하고 쿠폰을 적용해 보세요.</p></div>
</div>

<% if (items.isEmpty()) { %>
<div class="empty">장바구니에 항목이 없습니다.<br><a class="btn sm" href="index.jsp">도서 둘러보기</a></div>
<% } else { %>
<div class="two-col cart">
	<div class="stack">
		<div class="table-box">
			<table class="list">
				<thead><tr><th class="c">표지</th><th>도서명</th><th class="r">단가</th><th class="c">수량</th><th class="r">합계</th><th class="c">삭제</th></tr></thead>
				<tbody>
<% for (CartItem item : items) {
	Book b = item.getItemBook();
	String bid = h(item.getBookID());
%>
					<tr>
						<td class="c"><img class="thumb" src="images/<%=bid%>.jpg" alt="" onerror="this.onerror=null;this.src='images/noimage.svg'"></td>
						<td class="title"><a href="bookDetail.jsp?id=<%=bid%>"><%=h(b.getName())%></a><div class="meta"><%=h(b.getAuthor())%></div></td>
						<td class="r"><%=won(b.getUnitPrice())%></td>
						<td class="c">
							<div class="qty">
								<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="dec"><input type="hidden" name="id" value="<%=bid%>"><button type="submit" title="수량 줄이기">−</button></form>
								<b><%=item.getQuantity()%></b>
								<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="inc"><input type="hidden" name="id" value="<%=bid%>"><button type="submit" title="수량 늘리기">+</button></form>
							</div>
						</td>
						<td class="r price"><%=won(item.getTotalPrice())%></td>
						<td class="c">
							<form method="post" action="cartAction.jsp" onsubmit="return confirm('이 항목을 삭제하겠습니까?');" style="margin:0">
								<input type="hidden" name="action" value="remove"><input type="hidden" name="id" value="<%=bid%>">
								<button type="submit" class="btn danger sm">삭제</button>
							</form>
						</td>
					</tr>
<% } %>
				</tbody>
			</table>
		</div>
		<div class="btn-row" style="margin:0;justify-content:space-between">
			<form method="post" action="cartAction.jsp" onsubmit="return confirm('장바구니의 모든 항목을 삭제하겠습니까?');">
				<input type="hidden" name="action" value="clear"><button type="submit" class="btn danger">장바구니 비우기</button>
			</form>
			<a class="btn line" href="index.jsp">계속 쇼핑하기</a>
		</div>
	</div>

	<aside class="card">
		<h3>결제 예상 금액</h3>

		<% if (remain > 0) { %>
		<div class="hint"><b><%=won(remain)%></b> 더 담으면 배송비 무료!</div>
		<% } else { %>
		<div class="hint" style="color:var(--ok)"><b>무료배송</b> 조건을 달성했어요 🎉</div>
		<% } %>
		<div class="progress"><i style="width:<%=percent%>%"></i></div>

		<% if (appliedCoupon != null) { %>
		<div class="applied">
			<span>🎟 <%=h(appliedCoupon.getName())%></span>
			<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="uncoupon"><button type="submit">해제</button></form>
		</div>
		<% if (!appliedCoupon.isUsable(pr.subtotal)) { %>
		<div class="alert info" style="margin:0 0 10px">최소 주문금액 <%=won(appliedCoupon.getMinPrice())%> 이상일 때 사용할 수 있어요.</div>
		<% } %>
		<% } else { %>
		<form class="coupon-form" method="post" action="cartAction.jsp">
			<input type="hidden" name="action" value="coupon">
			<input type="text" name="code" placeholder="쿠폰 코드 입력" maxlength="20">
			<button type="submit" class="btn green sm">적용</button>
		</form>
		<div class="hint" style="margin-bottom:8px"><a href="coupons.jsp" style="text-decoration:underline">쿠폰함에서 쿠폰 확인하기</a></div>
		<% } %>

		<div class="sum-row"><span>상품 금액</span><span><%=won(pr.subtotal)%></span></div>
		<% if (pr.discount > 0) { %><div class="sum-row disc"><span>쿠폰 할인</span><span>- <%=won(pr.discount)%></span></div><% } %>
		<div class="sum-row"><span>배송비</span><span><%=pr.shipping == 0 ? "무료" : won(pr.shipping)%></span></div>
		<div class="sum-row total"><span>결제 예상 금액</span><span><%=won(pr.total)%></span></div>
		<a class="btn block" style="margin-top:18px" href="shipping.jsp">주문하기</a>
	</aside>
</div>
<% } %>

<%@ include file="common/footer.jsp"%>
