package com.market.cart;

/**
 * 쿠폰 1장 (신규)
 *  type : PERCENT(정률 할인) / AMOUNT(정액 할인) / SHIP(배송비 무료)
 */
public class Coupon {
	public static final String PERCENT = "PERCENT";
	public static final String AMOUNT = "AMOUNT";
	public static final String SHIP = "SHIP";

	private final String code;
	private final String name;
	private final String type;
	private final int value;
	private final int minPrice;

	public Coupon(String code, String name, String type, int value, int minPrice) {
		this.code = code;
		this.name = name;
		this.type = type;
		this.value = value;
		this.minPrice = minPrice;
	}

	public String getCode() { return code; }
	public String getName() { return name; }
	public String getType() { return type; }
	public int getValue() { return value; }
	public int getMinPrice() { return minPrice; }

	/** 이 쿠폰을 쓸 수 있는 금액인가 */
	public boolean isUsable(int subtotal) {
		return subtotal > 0 && subtotal >= minPrice;
	}

	/** 상품금액에서 깎아 주는 금액 (배송비 쿠폰은 0) */
	public int discount(int subtotal) {
		if (!isUsable(subtotal)) return 0;
		if (PERCENT.equals(type)) return subtotal * value / 100;
		if (AMOUNT.equals(type)) return Math.min(value, subtotal);
		return 0;
	}

	/** 화면에 보여 줄 혜택 문구 */
	public String benefitText() {
		if (PERCENT.equals(type)) return value + "% 할인";
		if (AMOUNT.equals(type)) return String.format("%,d원 할인", value);
		return "배송비 무료";
	}
}
