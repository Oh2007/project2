package com.market.member;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.ArrayList;

/**
 * 자체 회원 가입/로그인 (신규)
 *  - WEB-INF/members.txt 에 한 줄에 한 명 : id [TAB] salt [TAB] hash [TAB] 이름 [TAB] 연락처
 *  - 비밀번호는 원문을 저장하지 않고 SHA-256(salt + 비밀번호) 해시값만 저장한다. (암호화 평가 항목 대응)
 */
public class MemberStore {
	private static final SecureRandom RND = new SecureRandom();

	public static boolean isValidId(String id) {
		return id != null && id.matches("[A-Za-z0-9]{4,15}");
	}

	public static boolean isValidPw(String pw) {
		return pw != null && pw.length() >= 6 && pw.length() <= 30;
	}

	/** 가입 : 성공하면 null, 실패하면 오류 문구를 돌려준다. */
	public static synchronized String register(String file, String id, String pw, String name, String phone) {
		if (!isValidId(id)) return "아이디는 영문/숫자 4~15자로 입력하세요.";
		if (!isValidPw(pw)) return "비밀번호는 6자 이상 입력하세요.";
		if (!UserInIt.isValidName(name)) return "이름을 입력하세요. (20자 이내)";
		if (!UserInIt.isValidPhone(phone)) return "연락처는 숫자와 - 만 사용해 9~13자로 입력하세요.";
		for (String[] m : load(file))
			if (m[0].equalsIgnoreCase(id)) return "이미 사용 중인 아이디입니다.";

		byte[] s = new byte[8];
		RND.nextBytes(s);
		String salt = toHex(s);
		String line = id + "\t" + salt + "\t" + hash(salt, pw) + "\t" + name.trim().replace('\t', ' ') + "\t"
				+ phone.trim();
		try (Writer w = new OutputStreamWriter(new FileOutputStream(file, true), StandardCharsets.UTF_8)) {
			w.write(line + "\n");
		} catch (IOException e) {
			return "회원 정보를 저장하지 못했습니다. (WEB-INF/members.txt 권한 확인)";
		}
		return null;
	}

	/** 로그인 : 맞으면 User, 틀리면 null */
	public static synchronized User login(String file, String id, String pw) {
		if (id == null || pw == null) return null;
		for (String[] m : load(file)) {
			if (m[0].equalsIgnoreCase(id.trim()) && m[2].equals(hash(m[1], pw))) {
				User u = new User(m[3], m[4]);
				u.setProvider("local");
				u.setKey("local:" + m[0].toLowerCase());
				return u;
			}
		}
		return null;
	}

	private static ArrayList<String[]> load(String file) {
		ArrayList<String[]> list = new ArrayList<String[]>();
		if (file == null) return list;
		File f = new File(file);
		if (!f.exists()) return list;
		try (BufferedReader r = new BufferedReader(new InputStreamReader(new FileInputStream(f), StandardCharsets.UTF_8))) {
			String line;
			while ((line = r.readLine()) != null) {
				String[] p = line.split("\t");
				if (p.length >= 5) list.add(p);
			}
		} catch (IOException e) {
			System.out.println(e);
		}
		return list;
	}

	private static String hash(String salt, String pw) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			return toHex(md.digest((salt + pw).getBytes(StandardCharsets.UTF_8)));
		} catch (Exception e) {
			throw new IllegalStateException(e);
		}
	}

	private static String toHex(byte[] b) {
		StringBuilder sb = new StringBuilder();
		for (byte x : b) sb.append(String.format("%02x", x));
		return sb.toString();
	}
}
