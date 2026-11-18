package com.market.cart;

import java.util.ArrayList;

/** 사용할 수 있는 쿠폰 목록 (신규) - 쿠폰을 추가하려면 아래 list.add(...) 한 줄만 늘리면 된다. */
public class CouponInIt {
	private static final ArrayList<Coupon> list = new ArrayList<Coupon>();

	static {
		list.add(new Coupon("WELCOME10", "신규 가입 환영 10% 쿠폰", Coupon.PERCENT, 10, 10000));
		list.add(new Coupon("BOOK3000", "독서의 달 3,000원 할인", Coupon.AMOUNT, 3000, 20000));
		list.add(new Coupon("FREESHIP", "배송비 무료 쿠폰", Coupon.SHIP, 0, 1));
		list.add(new Coupon("VIP20", "VIP 20% 특별 할인", Coupon.PERCENT, 20, 50000));
	}

	public static ArrayList<Coupon> getList() {
		return list;
	}

	/** 쿠폰 코드로 찾기 (대소문자 구분 없음, 없으면 null) */
	public static Coupon find(String code) {
		if (code == null) return null;
		String c = code.trim();
		for (Coupon cp : list) {
			if (cp.getCode().equalsIgnoreCase(c)) return cp;
		}
		return null;
	}
}
