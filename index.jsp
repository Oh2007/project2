<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* [연결되는 자바] bookitem.BookInIt (book.txt 읽기/검색), bookitem.Book (도서 1권) */
	BookInIt.init(bookFile);

	String q = request.getParameter("q");
	String cat = request.getParameter("cat");
	String sort = request.getParameter("sort");
	if (q == null) q = "";
	if (cat == null) cat = "";
	if (sort == null) sort = "";
	q = q.trim();

	ArrayList<Book> all = BookInIt.search(q);

	// 분야(카테고리) 목록
	LinkedHashSet<String> cats = new LinkedHashSet<String>();
	for (Book b : all) cats.add(b.getCategory());

	ArrayList<Book> books = new ArrayList<Book>();
	for (Book b : all)
		if (cat.isEmpty() || cat.equals(b.getCategory())) books.add(b);

	// 정렬
	if ("low".equals(sort)) {
		Collections.sort(books, (x, y) -> x.getUnitPrice() - y.getUnitPrice());
	} else if ("high".equals(sort)) {
		Collections.sort(books, (x, y) -> y.getUnitPrice() - x.getUnitPrice());
	} else if ("new".equals(sort)) {
		Collections.sort(books, (x, y) -> y.getReleaseDate().compareTo(x.getReleaseDate()));
	} else if ("name".equals(sort)) {
		Collections.sort(books, (x, y) -> x.getName().compareTo(y.getName()));
	}

	String qq = URLEncoder.encode(q, "UTF-8");
	String cardBack = "index.jsp?q=" + qq + "&cat=" + URLEncoder.encode(cat, "UTF-8") + "&sort=" + URLEncoder.encode(sort, "UTF-8");
	String menu = "list";
	String pageTitle = "도서 둘러보기";
%>
<%@ include file="common/header.jsp"%>

<% if (q.isEmpty() && cat.isEmpty()) { %>
<section class="hero">
	<h2>오늘은 어떤 책을 만나볼까요?</h2>
	<p>신규 가입 시 <b>WELCOME10</b> 쿠폰으로 10% 할인, 3만원 이상 구매하면 배송비도 무료예요.</p>
	<div class="tags"><span>📦 3만원 이상 무료배송</span><span>🎟 쿠폰 4종</span><span>❤ 찜하고 나중에 구매</span></div>
</section>
<% } %>

<div class="page-head">
	<div>
		<h2><%=q.isEmpty() ? "도서 둘러보기" : "‘" + h(q) + "’ 검색 결과"%></h2>
		<p>총 <%=books.size()%>권의 도서가 있습니다.</p>
	</div>
</div>

<div class="toolbar">
	<div class="chips">
		<a href="index.jsp?q=<%=qq%>&sort=<%=h(sort)%>" class="<%=cat.isEmpty() ? "on" : ""%>">전체</a>
<% for (String c : cats) { %>
		<a href="index.jsp?q=<%=qq%>&cat=<%=URLEncoder.encode(c, "UTF-8")%>&sort=<%=h(sort)%>" class="<%=c.equals(cat) ? "on" : ""%>"><%=h(c)%></a>
<% } %>
	</div>
	<form class="sort" method="get" action="index.jsp">
		<input type="hidden" name="q" value="<%=h(q)%>"><input type="hidden" name="cat" value="<%=h(cat)%>">
		<select name="sort" onchange="this.form.submit()">
			<option value="">기본순</option>
			<option value="new" <%="new".equals(sort) ? "selected" : ""%>>최신 출간순</option>
			<option value="low" <%="low".equals(sort) ? "selected" : ""%>>낮은 가격순</option>
			<option value="high" <%="high".equals(sort) ? "selected" : ""%>>높은 가격순</option>
			<option value="name" <%="name".equals(sort) ? "selected" : ""%>>도서명순</option>
		</select>
	</form>
</div>

<% if (books.isEmpty()) { %>
<div class="empty">검색 결과가 없습니다.<br><a class="btn line sm" href="index.jsp">전체 도서 보기</a></div>
<% } else { %>
<div class="grid">
<% for (Book b : books) { %>
<%@ include file="common/bookCard.jsp"%>
<% } %>
</div>
<% } %>

<%@ include file="common/footer.jsp"%>
