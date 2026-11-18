<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 찜한 도서 (신규) : 세션에 도서ID 만 보관한다. */
	BookInIt.init(bookFile);
	ArrayList<Book> books = new ArrayList<Book>();
	for (String id : wishSet) {
		Book b = BookInIt.getBookById(id);
		if (b != null) books.add(b);
	}
	String cardBack = "wishlist.jsp";
	String menu = "wish";
	String pageTitle = "찜한 도서";
%>
<%@ include file="common/header.jsp"%>

<div class="page-head">
	<div><h2>찜한 도서</h2><p>마음에 드는 책을 모아 두고 나중에 담아 보세요.</p></div>
</div>

<% if (books.isEmpty()) { %>
<div class="empty">아직 찜한 도서가 없습니다.<br><a class="btn sm" href="index.jsp">도서 둘러보기</a></div>
<% } else { %>
<div class="grid">
<% for (Book b : books) { %>
<%@ include file="common/bookCard.jsp"%>
<% } %>
</div>
<% } %>

<%@ include file="common/footer.jsp"%>
