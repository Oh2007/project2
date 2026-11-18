package com.market.member;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 구글 로그인 토큰 확인 (신규)
 *  브라우저의 "Google로 로그인" 버튼이 준 ID 토큰을 구글 서버(tokeninfo)에 보내
 *  진짜 토큰인지, 우리 앱(client id)용 토큰인지 확인하고 이메일/이름을 꺼낸다.
 *  (외부 jar 필요 없음 : Java 11 의 java.net.http 사용)
 */
public class GoogleAuth {

	/** 성공하면 {이메일, 이름}, 실패하면 null */
	public static String[] verify(String idToken, String clientId) {
		if (idToken == null || idToken.isEmpty() || clientId == null || clientId.isEmpty()) return null;
		try {
			String url = "https://oauth2.googleapis.com/tokeninfo?id_token="
					+ URLEncoder.encode(idToken, StandardCharsets.UTF_8);
			HttpResponse<String> res = HttpClient.newHttpClient().send(HttpRequest.newBuilder(URI.create(url)).GET().build(),
					HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
			if (res.statusCode() != 200) return null;
			String body = res.body();
			if (!clientId.equals(value(body, "aud"))) return null; // 다른 앱용 토큰이면 거부
			String email = value(body, "email");
			if (email.isEmpty()) return null;
			String name = value(body, "name");
			if (name.isEmpty()) name = email.substring(0, email.indexOf('@') > 0 ? email.indexOf('@') : email.length());
			return new String[] { email, name };
		} catch (Exception e) {
			System.out.println(e);
			return null;
		}
	}

	private static String value(String json, String key) {
		Matcher m = Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]*)\"").matcher(json);
		return m.find() ? m.group(1) : "";
	}
}
