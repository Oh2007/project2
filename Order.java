package com.market.cart;

import java.util.ArrayList;

/** 주문 1건 (신규) - 영수증/주문현황 화면에서 사용 */
public class Order {
	public static final String[] STEPS = { "주문완료", "배송준비", "배송중", "배송완료" };
	public static final String CANCELED = "주문취소";

	private final String orderId;
	private final String orderDate;
	private final String ownerKey;
	private final String customerName;
	private final String phone;
	private final String address;
	private final ArrayList<CartItem> items;
	private final int subtotal, discount, shipping, total;
	private final String couponName;
	private final String couponCode;
	private String status = STEPS[0];

	public Order(String orderId, String orderDate, String ownerKey, String customerName, String phone, String address,
			ArrayList<CartItem> items, Pricing p, String couponCode, String couponName) {
		this.orderId = orderId;
		this.orderDate = orderDate;
		this.ownerKey = ownerKey;
		this.customerName = customerName;
		this.phone = phone;
		this.address = address;
		this.items = items;
		this.subtotal = p.subtotal;
		this.discount = p.discount;
		this.shipping = p.shipping;
		this.total = p.total;
		this.couponName = couponName;
		this.couponCode = couponCode;
	}

	public String getOrderId() { return orderId; }
	public String getOrderDate() { return orderDate; }
	public String getOwnerKey() { return ownerKey; }
	public String getCustomerName() { return customerName; }
	public String getPhone() { return phone; }
	public String getAddress() { return address; }
	public ArrayList<CartItem> getItems() { return items; }
	public int getSubtotal() { return subtotal; }
	public int getDiscount() { return discount; }
	public int getShipping() { return shipping; }
	public int getTotal() { return total; }
	public String getCouponName() { return couponName; }
	public String getCouponCode() { return couponCode; }
	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public boolean isCanceled() { return CANCELED.equals(status); }

	/** 진행 단계 번호 (0~3, 취소는 -1) */
	public int getStepIndex() {
		for (int i = 0; i < STEPS.length; i++)
			if (STEPS[i].equals(status)) return i;
		return -1;
	}

	public int getItemCount() {
		int n = 0;
		for (CartItem it : items) n += it.getQuantity();
		return n;
	}
}
