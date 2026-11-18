package com.market.member;

/** 고객 : 기존 User + 로그인 방식(provider) / 이메일 / 고유키 추가 */
public class User extends Person {
	private String provider = "guest"; // guest(비회원) / local(자체 회원) / google
	private String email = "";
	private String key;

	public User(String name, String phone) {
		super(name, phone);
	}

	public User(String username, String phone, String address) {
		super(username, phone, address);
	}

	public String getProvider() { return provider; }
	public void setProvider(String provider) { this.provider = provider; }
	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }

	/** 주문 내역을 구분하는 고유키 (예: google:abc@gmail.com) */
	public String getKey() {
		return key != null ? key : "guest:" + getName() + ":" + getPhone();
	}
	public void setKey(String key) { this.key = key; }

	public String getProviderLabel() {
		switch (provider) {
		case "google": return "Google";
		case "local": return "BookMarket 회원";
		default: return "비회원";
		}
	}

	/** 구매금액에 따른 회원 등급 */
	public static String gradeOf(int spent) {
		if (spent >= 100000) return "GOLD";
		if (spent >= 50000) return "SILVER";
		return "BASIC";
	}
}
