package com.market.bookitem;

// 상품(도서)의 공통 속성 - 기존 소스 그대로
public abstract class Item {
	String bookId;
	String name;
	int unitPrice;

	public Item(String bookId, String name, int unitPrice) {
		this.bookId = bookId;
		this.name = name;
		this.unitPrice = unitPrice;
	}

	abstract String getBookId();

	abstract String getName();

	abstract int getUnitPrice();

	abstract void setBookId(String bookId);

	abstract void setName(String name);

	abstract void setUnitPrice(int unitPrice);
}
