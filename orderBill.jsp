<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 영수증 : [연결되는 자바] cart.Order / OrderStore (주문번호로 조회) */
	Order o = OrderStore.find(request.getParameter("id"));
	boolean mine = o != null && (isAdmin || (loginUser != null && loginUser.getKey().equals(o.getOwnerKey())));
	if (!mine) {
		response.sendRedirect("index.jsp");
		return;
	}
	String menu = "orders";
	String pageTitle = "영수증";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>🎉 주문이 완료되었습니다</h2><p>주문번호 <b><%=h(o.getOrderId())%></b> · 아래 영수증을 확인하세요.</p></div>
</div>

<div class="card">
	<h3>배송 받을 고객 정보</h3>
	<dl class="bill-info">
		<dt>고객명</dt><dd><%=h(o.getCustomerName())%></dd>
		<dt>연락처</dt><dd><%=h(o.getPhone())%></dd>
		<dt>배송지</dt><dd><%=h(o.getAddress())%></dd>
		<dt>주문일</dt><dd><%=h(o.getOrderDate())%></dd>
		<dt>진행상태</dt><dd><span class="badge"><%=h(o.getStatus())%></span></dd>
	</dl>

	<h3>주문 도서 목록</h3>
	<div class="table-box" style="box-shadow:none">
		<table class="list">
			<thead><tr><th>도서ID</th><th>도서명</th><th class="r">단가</th><th class="c">수량</th><th class="r">합계</th></tr></thead>
			<tbody>
<% for (CartItem item : o.getItems()) { %>
				<tr>
					<td><%=h(item.getBookID())%></td>
					<td class="title"><%=h(item.getItemBook().getName())%></td>
					<td class="r"><%=won(item.getItemBook().getUnitPrice())%></td>
					<td class="c"><%=item.getQuantity()%></td>
					<td class="r"><%=won(item.getTotalPrice())%></td>
				</tr>
<% } %>
			</tbody>
		</table>
	</div>
	<div style="max-width:340px;margin:18px 0 0 auto">
		<div class="sum-row"><span>상품 금액</span><span><%=won(o.getSubtotal())%></span></div>
		<% if (o.getCouponName() != null) { %><div class="sum-row disc"><span>쿠폰 (<%=h(o.getCouponName())%>)</span><span>- <%=won(o.getDiscount())%></span></div><% } %>
		<div class="sum-row"><span>배송비</span><span><%=o.getShipping() == 0 ? "무료" : won(o.getShipping())%></span></div>
		<div class="sum-row total"><span>결제 금액</span><span><%=won(o.getTotal())%></span></div>
	</div>
</div>

<div class="btn-row">
	<button type="button" class="btn line" onclick="window.print()">🖨 영수증 인쇄</button>
	<a class="btn line" href="orders.jsp">주문 현황</a>
	<a class="btn" href="index.jsp">계속 쇼핑하기</a>
</div>

<%@ include file="common/footer.jsp"%>
