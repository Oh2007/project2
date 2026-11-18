package com.market.member;

/**
 * 사람 (고객/관리자 공통)
 * [변경] phone 을 int -> String : 01012345678 은 int 범위를 넘고 앞자리 0 도 사라지기 때문
 */
public class Person {
	private String name;
	private String phone;
	private String address;

	public Person(String name, String phone) {
		this.name = name;
		this.phone = phone;
	}

	public Person(String name, String phone, String address) {
		this.name = name;
		this.phone = phone;
		this.address = address;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
}
