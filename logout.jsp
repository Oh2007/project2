<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 로그아웃 : 세션(고객 정보 + 장바구니 + 쿠폰 + 찜 + 관리자 로그인)을 모두 지운다.
	session.invalidate();
	response.sendRedirect("index.jsp");
%>
