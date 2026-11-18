package com.market.cart;

import java.util.ArrayList;
import com.market.bookitem.Book;

/**
 * 장바구니 (기존 Cart 재활용)
 *
 * [Swing -> 웹 변경점]
 *  - mCartCount 가 static 이면 접속자 모두가 같은 값을 공유하게 된다. -> 일반 멤버변수로 변경
 *  - Cart 객체는 접속자(세션)마다 1개씩 만들어 session 에 보관한다. (common/init.jsp)
 *  - System.out.println 으로 찍던 printCart()/printBookList() 는 JSP 화면이 대신하므로 삭제
 *  - 신규 기능 : 수량 줄이기/늘리기, 도서ID로 삭제, 총금액 계산
 */
public class Cart implements CartInterface {

	public ArrayList<CartItem> mCartItem = new ArrayList<CartItem>();
	public int mCartCount = 0;

	public Cart() {
	}

	/** 이미 담긴 도서면 수량을 1 늘리고 true, 없으면 false */
	public boolean isCartInBook(String bookId) {
		for (int i = 0; i < mCartItem.size(); i++) {
			if (bookId.equals(mCartItem.get(i).getBookID())) {
				mCartItem.get(i).setQuantity(mCartItem.get(i).getQuantity() + 1);
				return true;
			}
		}
		return false;
	}

	public void insertBook(Book book) {
		CartItem bookitem = new CartItem(book);
		mCartItem.add(bookitem);
		mCartCount = mCartItem.size();
	}

	public void deleteBook() {
		mCartItem.clear();
		mCartCount = 0;
	}

	public void removeCart(int numId) {
		mCartItem.remove(numId);
		mCartCount = mCartItem.size();
	}

	/** 도서ID 로 항목 삭제 (신규) */
	public boolean removeBook(String bookId) {
		for (int i = 0; i < mCartItem.size(); i++) {
			if (bookId.equals(mCartItem.get(i).getBookID())) {
				removeCart(i);
				return true;
			}
		}
		return false;
	}

	/** 수량 1 늘리기 (신규) */
	public boolean increaseQuantity(String bookId) {
		return isCartInBook(bookId);
	}

	/** 수량 1 줄이기 (신규) - 1개일 때는 더 줄이지 않고 false */
	public boolean decreaseQuantity(String bookId) {
		for (int i = 0; i < mCartItem.size(); i++) {
			CartItem item = mCartItem.get(i);
			if (bookId.equals(item.getBookID())) {
				if (item.getQuantity() <= 1)
					return false;
				item.setQuantity(item.getQuantity() - 1);
				return true;
			}
		}
		return false;
	}

	/** 장바구니 총금액 (신규) */
	public int getTotalPrice() {
		int sum = 0;
		for (int i = 0; i < mCartItem.size(); i++)
			sum += mCartItem.get(i).getTotalPrice();
		return sum;
	}

	public ArrayList<CartItem> getmCartItem() {
		return mCartItem;
	}

	public void setmCartItem(ArrayList<CartItem> mCartItem) {
		this.mCartItem = mCartItem;
		this.mCartCount = mCartItem.size();
	}
}
