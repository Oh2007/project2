<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/*
	 * 관리자 - 새 도서 등록 (Swing 의 AdminPage 와 같은 역할)
	 * [연결되는 자바] bookitem.BookInIt (새 ID 만들기, book.txt 에 저장), bookitem.Book
	 */
	if (!isAdmin) {
		response.sendRedirect("adminLogin.jsp");
		return;
	}

	BookInIt.init(bookFile);
	String error = null;
	String fName = "", fPrice = "", fAuthor = "", fDesc = "", fCategory = "", fDate = "";

	if ("POST".equalsIgnoreCase(request.getMethod())) {
		fName = request.getParameter("name");
		fPrice = request.getParameter("price");
		fAuthor = request.getParameter("author");
		fDesc = request.getParameter("description");
		fCategory = request.getParameter("category");
		fDate = request.getParameter("releaseDate");
		if (fName == null) fName = "";
		if (fPrice == null) fPrice = "";
		if (fAuthor == null) fAuthor = "";
		if (fDesc == null) fDesc = "";
		if (fCategory == null) fCategory = "";
		if (fDate == null) fDate = "";
		fName = fName.trim(); fPrice = fPrice.trim(); fAuthor = fAuthor.trim();
		fDesc = fDesc.trim(); fCategory = fCategory.trim(); fDate = fDate.trim();

		int price = -1;
		try { price = Integer.parseInt(fPrice); } catch (NumberFormatException e) { }

		if (fName.isEmpty() || fAuthor.isEmpty() || fDesc.isEmpty() || fCategory.isEmpty() || fDate.isEmpty()) {
			error = "모든 항목을 입력하세요.";
		} else if (price <= 0) {
			error = "가격은 1 이상의 숫자로 입력하세요.";
		} else {
			Book book = new Book(BookInIt.newBookId(), fName, price, fAuthor, fDesc, fCategory, fDate.replace('-', '/'));
			if (BookInIt.addBook(bookFile, book)) {
				flash(session, "새 도서 정보가 저장되었습니다.", false);
				response.sendRedirect("admin.jsp");
				return;
			}
			error = "저장하지 못했습니다. book.txt 파일 경로/권한을 확인하세요.";
		}
	}

	ArrayList<Book> books = BookInIt.getmBookList();

	// 대시보드 통계 (신규) : cart.OrderStore 의 주문을 집계
	ArrayList<Order> orderAll = OrderStore.all();
	int revenue = 0, waiting = 0, canceled = 0;
	for (Order od : orderAll) {
		if (od.isCanceled()) { canceled++; continue; }
		revenue += od.getTotal();
		if (od.getStepIndex() < 3) waiting++;
	}
	String menu = "admin";
	String pageTitle = "관리자";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>관리자 센터</h2><p>매출/주문 현황을 확인하고 새 도서를 등록합니다.</p></div>
	<a class="btn green" href="orders.jsp"><%=ic("package")%>전체 주문 관리</a>
</div>

<div class="stats">
	<div class="stat"><div class="k">총 매출 (취소 제외)</div><div class="v t"><%=won(revenue)%></div></div>
	<div class="stat"><div class="k">전체 주문</div><div class="v"><%=orderAll.size()%>건</div></div>
	<div class="stat"><div class="k">배송 처리 필요</div><div class="v"><%=waiting%>건</div></div>
	<div class="stat"><div class="k">취소 주문</div><div class="v"><%=canceled%>건</div></div>
	<div class="stat"><div class="k">등록 도서</div><div class="v"><%=books.size()%>권</div></div>
</div>

<div class="card">
	<h3>새 도서 등록</h3>
	<% if (error != null) { %><div class="alert err"><%=h(error)%></div><% } %>
	<form method="post" action="admin.jsp">
		<div class="field"><label>도서ID</label><input type="text" value="저장할 때 자동으로 만들어집니다 (ISBN + 날짜/시간)" readonly></div>
		<div class="field"><label for="name">도서명</label><input type="text" id="name" name="name" value="<%=h(fName)%>" maxlength="100"></div>
		<div class="field"><label for="price">가 격 (원)</label><input type="number" id="price" name="price" value="<%=h(fPrice)%>" min="1"></div>
		<div class="field"><label for="author">저 자</label><input type="text" id="author" name="author" value="<%=h(fAuthor)%>" maxlength="50"></div>
		<div class="field"><label for="description">설 명</label><input type="text" id="description" name="description" value="<%=h(fDesc)%>" maxlength="200"></div>
		<div class="field"><label for="category">분 야</label><input type="text" id="category" name="category" value="<%=h(fCategory)%>" maxlength="30"></div>
		<div class="field"><label for="releaseDate">출판일</label><input type="date" id="releaseDate" name="releaseDate" value="<%=h(fDate.replace('/', '-'))%>"></div>
		<div class="btn-row">
			<a class="btn line" href="admin.jsp">취소</a>
			<button type="submit" class="btn">추가</button>
		</div>
	</form>
</div>

<h3 style="margin:28px 0 12px;color:var(--green)">등록된 도서 (<%=books.size()%>권)</h3>
<div class="table-box">
	<table class="list">
		<thead><tr><th>도서ID</th><th>도서명</th><th>분야</th><th class="r">가격</th></tr></thead>
		<tbody>
<% for (Book b : books) { %>
			<tr><td><%=h(b.getBookId())%></td><td class="title"><%=h(b.getName())%></td><td><span class="tag plain"><%=h(b.getCategory())%></span></td><td class="r price"><%=won(b.getUnitPrice())%></td></tr>
<% } %>
		</tbody>
	</table>
</div>

<%@ include file="common/footer.jsp"%>
