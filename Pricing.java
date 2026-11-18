package com.market.cart;

/** 결제 금액 계산 (신규) : 상품금액 - 쿠폰할인 + 배송비 = 결제금액 */
public class Pricing {
	public static final int FREE_SHIP_LIMIT = 30000; // 이 금액 이상이면 배송비 무료
	public static final int SHIP_FEE = 3000;

	public final int subtotal;
	public final int discount;
	public final int shipping;
	public final int total;

	private Pricing(int subtotal, int discount, int shipping) {
		this.subtotal = subtotal;
		this.discount = discount;
		this.shipping = shipping;
		this.total = subtotal - discount + shipping;
	}

	public static Pricing of(Cart cart, Coupon coupon) {
		int sub = cart.getTotalPrice();
		int discount = 0;
		boolean freeShip = sub >= FREE_SHIP_LIMIT || sub == 0;
		if (coupon != null && coupon.isUsable(sub)) {
			discount = coupon.discount(sub);
			if (Coupon.SHIP.equals(coupon.getType())) freeShip = true;
		}
		return new Pricing(sub, discount, freeShip ? 0 : SHIP_FEE);
	}
}
