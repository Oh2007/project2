<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 쿠폰함 (신규) [연결되는 자바] cart.CouponInIt / Coupon / OrderStore.hasUsedCoupon */
	String menu = "coupon";
	String pageTitle = "쿠폰함";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>쿠폰함</h2><p>쿠폰은 1인 1회 사용할 수 있어요. [장바구니에 적용]을 누르면 바로 적용됩니다.</p></div>
</div>

<div class="coupons">
<% for (Coupon cp : CouponInIt.getList()) {
	boolean used = loginUser != null && OrderStore.hasUsedCoupon(loginUser.getKey(), cp.getCode());
%>
	<div class="coupon" style="<%=used ? "opacity:.55" : ""%>">
		<div class="l">
			<div class="big"><%=h(cp.benefitText())%></div>
			<div class="nm"><%=h(cp.getName())%></div>
			<div class="hint"><%=cp.getMinPrice() > 1 ? won(cp.getMinPrice()) + " 이상 주문 시" : "금액 제한 없음"%></div>
			<span class="code"><%=h(cp.getCode())%></span>
		</div>
		<div class="r">
<% if (used) { %>
			<span class="badge cx">사용 완료</span>
<% } else { %>
			<form method="post" action="cartAction.jsp">
				<input type="hidden" name="action" value="coupon"><input type="hidden" name="code" value="<%=h(cp.getCode())%>"><input type="hidden" name="back" value="cart.jsp">
				<button class="btn sm" type="submit">장바구니에<br>적용</button>
			</form>
<% } %>
		</div>
	</div>
<% } %>
</div>

<%@ include file="common/footer.jsp"%>
