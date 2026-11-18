package com.market.member;

/**
 * 고객 정보 입력값 검사 + User 객체 생성 (기존 UserInIt 재활용)
 *
 * [Swing -> 웹 변경점]
 *  기존에는 static 변수(mUser)에 고객 1명만 저장했다. 웹에서는 접속자가 여러 명이므로
 *  static 에 저장하면 안 된다. -> 여기서는 User 만 만들어 주고, 저장은 JSP 의 session 이 담당한다.
 */
public class UserInIt {

	public static User init(String name, String phone) {
		return new User(name.trim(), phone.trim());
	}

	public static boolean isValidName(String name) {
		return name != null && name.trim().length() > 0 && name.trim().length() <= 20;
	}

	/** 숫자와 - 만 허용, 9~13자 */
	public static boolean isValidPhone(String phone) {
		return phone != null && phone.trim().matches("[0-9\\-]{9,13}");
	}
}
