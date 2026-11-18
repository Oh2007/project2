package com.market.cart;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * 주문 내역 저장소 (신규) - 서버 메모리(ArrayList)에 보관한다.
 * ※ DB(JDBC) 과제 단계에서는 이 클래스의 메서드만 DB 조회/저장으로 바꾸면 된다.
 */
public class OrderStore {
	private static final ArrayList<Order> orders = new ArrayList<Order>();
	private static int seq = 0;

	public static synchronized Order add(String ownerKey, String name, String phone, String address,
			ArrayList<CartItem> items, Pricing p, String couponCode, String couponName) {
		String id = "BM" + new SimpleDateFormat("yyMMdd").format(new Date()) + String.format("%03d", ++seq);
		String date = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date());
		Order o = new Order(id, date, ownerKey, name, phone, address, items, p, couponCode, couponName);
		orders.add(0, o); // 최신 주문이 맨 위
		return o;
	}

	public static synchronized Order find(String orderId) {
		for (Order o : orders)
			if (o.getOrderId().equals(orderId)) return o;
		return null;
	}

	public static synchronized ArrayList<Order> byOwner(String ownerKey) {
		ArrayList<Order> r = new ArrayList<Order>();
		for (Order o : orders)
			if (o.getOwnerKey().equals(ownerKey)) r.add(o);
		return r;
	}

	public static synchronized ArrayList<Order> all() {
		return new ArrayList<Order>(orders);
	}

	/** 이 쿠폰을 이미 사용했는가 (주문취소한 건은 제외) - 쿠폰은 1인 1회 */
	public static synchronized boolean hasUsedCoupon(String ownerKey, String code) {
		for (Order o : orders)
			if (o.getOwnerKey().equals(ownerKey) && !o.isCanceled() && code != null && code.equals(o.getCouponCode())) return true;
		return false;
	}

	/** 총 구매금액 (취소 제외) - 회원 등급 계산용 */
	public static synchronized int totalSpent(String ownerKey) {
		int sum = 0;
		for (Order o : orders)
			if (o.getOwnerKey().equals(ownerKey) && !o.isCanceled()) sum += o.getTotal();
		return sum;
	}

	public static synchronized boolean setStatus(String orderId, String status) {
		Order o = find(orderId);
		if (o == null) return false;
		o.setStatus(status);
		return true;
	}
}
