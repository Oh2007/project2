package com.market.member;

public class Admin extends Person {
	private String id = "Admin";
	private String password = "Admin1234";

	public Admin(String name, String phone) {
		super(name, phone);
	}

	public String getId() {
		return id;
	}

	public String getPassword() {
		return password;
	}

	/** 관리자 로그인 확인 (adminLogin.jsp 에서 호출) */
	public boolean checkLogin(String inputId, String inputPw) {
		return id.equals(inputId) && password.equals(inputPw);
	}
}
