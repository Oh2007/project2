<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="common/init.jsp"%>
<%
	/* 도서 상세 (신규) [연결되는 자바] bookitem.BookInIt.getBookById */
	BookInIt.init(bookFile);
	Book book = BookInIt.getBookById(request.getParameter("id"));
	if (book == null) {
		flash(session, "존재하지 않는 도서입니다.", true);
		response.sendRedirect("index.jsp");
		return;
	}
	boolean wished = wishSet.contains(book.getBookId());
	String back = "bookDetail.jsp?id=" + URLEncoder.encode(book.getBookId(), "UTF-8");
	String menu = "list";
	String pageTitle = book.getName();
%>
<%@ include file="common/header.jsp"%>

<div class="detail">
	<div class="cover"><img src="images/<%=h(book.getBookId())%>.jpg" alt="" onerror="this.onerror=null;this.src='images/noimage.svg'"></div>
	<div>
		<span class="tag plain"><%=h(book.getCategory())%></span>
		<h2><%=h(book.getName())%></h2>
		<div class="hint"><%=h(book.getAuthor())%> 지음</div>
		<span class="price"><%=won(book.getUnitPrice())%></span>
		<p><%=h(book.getDescription())%></p>
		<dl class="spec">
			<dt>도서ID</dt><dd><%=h(book.getBookId())%></dd>
			<dt>저자</dt><dd><%=h(book.getAuthor())%></dd>
			<dt>분야</dt><dd><%=h(book.getCategory())%></dd>
			<dt>출판일</dt><dd><%=h(book.getReleaseDate())%></dd>
			<dt>배송</dt><dd>3만원 이상 무료배송 (미만 3,000원)</dd>
		</dl>
		<div class="btn-row" style="justify-content:flex-start">
			<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="add"><input type="hidden" name="id" value="<%=h(book.getBookId())%>"><input type="hidden" name="back" value="<%=h(back)%>"><button class="btn" type="submit"><%=ic("cart")%>장바구니 담기</button></form>
			<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="buy"><input type="hidden" name="id" value="<%=h(book.getBookId())%>"><button class="btn green" type="submit">바로 구매</button></form>
			<form method="post" action="cartAction.jsp"><input type="hidden" name="action" value="wish"><input type="hidden" name="id" value="<%=h(book.getBookId())%>"><input type="hidden" name="back" value="<%=h(back)%>"><button class="btn line" type="submit"><%=ic("heart")%><%=wished ? "찜 해제" : "찜하기"%></button></form>
			<a class="btn line" href="index.jsp">목록으로</a>
		</div>
	</div>
</div>

<%@ include file="common/footer.jsp"%>
