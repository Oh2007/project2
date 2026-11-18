<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 주문 현황 (신규) : 고객은 내 주문 / 관리자는 전체 주문 + 배송상태 변경
	 * [연결되는 자바] cart.Order, cart.OrderStore
	 */
	if (loginUser == null && !isAdmin) {
		response.sendRedirect("login.jsp?next=orders.jsp");
		return;
	}

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		String act = request.getParameter("action");
		String oid = request.getParameter("id");
		Order t = OrderStore.find(oid);
		if (t != null && "cancel".equals(act) && loginUser != null && loginUser.getKey().equals(t.getOwnerKey())) {
			if (Order.STEPS[0].equals(t.getStatus())) {
				t.setStatus(Order.CANCELED);
				flash(session, "주문 " + oid + " 을(를) 취소했습니다.", false);
			} else {
				flash(session, "배송이 시작된 주문은 취소할 수 없습니다.", true);
			}
		} else if (t != null && "status".equals(act) && isAdmin) {
			String st = request.getParameter("status");
			boolean okSt = Order.CANCELED.equals(st);
			for (String s : Order.STEPS) if (s.equals(st)) okSt = true;
			if (okSt) {
				t.setStatus(st);
				flash(session, "주문 " + oid + " 상태를 '" + st + "' 로 변경했습니다.", false);
			}
		}
		response.sendRedirect("orders.jsp");
		return;
	}

	ArrayList<Order> list = isAdmin ? OrderStore.all() : OrderStore.byOwner(loginUser.getKey());
	String menu = "orders";
	String pageTitle = "주문 현황";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2><%=isAdmin ? "전체 주문 관리" : "주문 현황"%></h2><p><%=isAdmin ? "고객 주문을 확인하고 배송 상태를 변경합니다." : "주문한 도서의 배송 진행 상황을 확인하세요."%></p></div>
</div>

<% if (list.isEmpty()) { %>
<div class="empty">주문 내역이 없습니다.<br><a class="btn sm" href="index.jsp">도서 둘러보기</a></div>
<% } %>

<% for (Order o : list) {
	int step = o.getStepIndex();
	String cls = o.isCanceled() ? "cx" : (step == 1 ? "s1" : step == 2 ? "s2" : step == 3 ? "s3" : "");
%>
<div class="card order-card">
	<div class="order-top">
		<div><span class="oid"><%=h(o.getOrderId())%></span> <span class="hint">· <%=h(o.getOrderDate())%><% if (isAdmin) { %> · <%=h(o.getCustomerName())%> (<%=h(o.getPhone())%>)<% } %></span></div>
		<span class="badge <%=cls%>"><%=h(o.getStatus())%></span>
	</div>
	<% if (!o.isCanceled()) { %>
	<div class="steps">
<% for (int i = 0; i < Order.STEPS.length; i++) { %>
		<div class="<%=i <= step ? "done" : ""%>"><%=Order.STEPS[i]%></div>
<% } %>
	</div>
	<% } %>
	<ul class="order-items">
<% for (CartItem it : o.getItems()) { %>
		<li><%=h(it.getItemBook().getName())%> × <%=it.getQuantity()%> <span class="hint">(<%=won(it.getTotalPrice())%>)</span></li>
<% } %>
	</ul>
	<div class="order-foot">
		<div>결제 <b class="price"><%=won(o.getTotal())%></b> <span class="hint"><%=o.getCouponName() != null ? "· 쿠폰 사용" : ""%> <%=o.getShipping() == 0 ? "· 무료배송" : ""%></span></div>
		<div style="display:flex;gap:8px;flex-wrap:wrap">
			<a class="btn line sm" href="orderBill.jsp?id=<%=h(o.getOrderId())%>">영수증</a>
<% if (isAdmin) { %>
			<form class="inline-form" method="post" action="orders.jsp">
				<input type="hidden" name="action" value="status"><input type="hidden" name="id" value="<%=h(o.getOrderId())%>">
				<select name="status">
<% for (String s : Order.STEPS) { %><option <%=s.equals(o.getStatus()) ? "selected" : ""%>><%=s%></option><% } %>
					<option <%=o.isCanceled() ? "selected" : ""%>><%=Order.CANCELED%></option>
				</select>
				<button class="btn green sm" type="submit">변경</button>
			</form>
<% } else if (Order.STEPS[0].equals(o.getStatus())) { %>
			<form class="inline-form" method="post" action="orders.jsp" onsubmit="return confirm('이 주문을 취소하겠습니까?');">
				<input type="hidden" name="action" value="cancel"><input type="hidden" name="id" value="<%=h(o.getOrderId())%>">
				<button class="btn danger sm" type="submit">주문 취소</button>
			</form>
<% } %>
		</div>
	</div>
</div>
<% } %>

<%@ include file="common/footer.jsp"%>
