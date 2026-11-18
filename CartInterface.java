package com.market.cart;

import com.market.bookitem.Book;

public interface CartInterface {
	boolean isCartInBook(String id);

	void insertBook(Book p);

	void removeCart(int numId);

	void deleteBook();
}
