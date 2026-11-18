<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 도서 카드 1장 : 사용 전에 Book b, String cardBack(처리 후 돌아갈 주소) 를 지정한다. --%>
<% boolean wished = wishSet.contains(b.getBookId()); %>
<article class="book">
	<a class="cover" href="bookDetail.jsp?id=<%=h(b.getBookId())%>">
		<img src="images/<%=h(b.getBookId())%>.jpg" alt="<%=h(b.getName())%>" onerror="this.onerror=null;this.src='images/noimage.svg'">
		<span class="tag"><%=h(b.getCategory())%></span>
	</a>
	<form class="heart" method="post" action="cartAction.jsp">
		<input type="hidden" name="action" value="wish"><input type="hidden" name="id" value="<%=h(b.getBookId())%>"><input type="hidden" name="back" value="<%=h(cardBack)%>">
		<button type="submit" class="<%=wished ? "on" : ""%>" title="<%=wished ? "찜 해제" : "찜하기"%>"><%=ic("heart")%></button>
	</form>
	<div class="body">
		<a class="t" href="bookDetail.jsp?id=<%=h(b.getBookId())%>"><%=h(b.getName())%></a>
		<span class="a"><%=h(b.getAuthor())%></span>
		<span class="d"><%=h(b.getDescription())%></span>
		<div class="foot-row">
			<span class="price"><%=won(b.getUnitPrice())%></span>
			<form method="post" action="cartAction.jsp" style="margin:0">
				<input type="hidden" name="action" value="add"><input type="hidden" name="id" value="<%=h(b.getBookId())%>"><input type="hidden" name="back" value="<%=h(cardBack)%>">
				<button type="submit" class="btn sm"><%=ic("cart")%>담기</button>
			</form>
		</div>
	</div>
</article>
