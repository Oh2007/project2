package com.market.bookitem;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * book.txt -> ArrayList<Book> 로 읽어 오는 클래스 (기존 BookInIt 재활용)
 *
 * [Swing -> 웹 변경점]
 *  1) "book.txt" 상대경로는 톰캣에서 파일을 못 찾는다.
 *     -> JSP가 application.getRealPath("/WEB-INF/book.txt") 로 만든 절대경로를 넘겨 받는다.
 *  2) 파일을 UTF-8 로 명시해서 읽고/쓴다. (한글 깨짐 방지)
 *  3) 관리자 화면(admin.jsp)에서 도서를 추가할 수 있도록 addBook() 추가
 */
public class BookInIt {
	private static ArrayList<Book> mBookList = new ArrayList<Book>();
	private static int mTotalBook = 0;
	private static final int FIELD_COUNT = 7; // 한 권당 7줄 (ISBN, 도서명, 가격, 저자, 설명, 분야, 출판일)

	/** book.txt 를 읽어 도서 목록을 새로 만든다. (JSP 에서 호출) */
	public static synchronized void init(String filePath) {
		ArrayList<Book> list = new ArrayList<Book>();
		setFileToBookList(filePath, list);
		mBookList = list;
		mTotalBook = list.size();
	}

	/** 파일 안의 도서 건수 (ISBN 으로 시작하는 줄 수) */
	public static int totalFileToBookList(String filePath) {
		int num = 0;
		for (String line : readLines(filePath)) {
			if (line.startsWith("ISBN"))
				++num;
		}
		return num;
	}

	/** 파일 내용을 Book 객체로 바꿔 booklist 에 담는다. */
	public static void setFileToBookList(String filePath, ArrayList<Book> booklist) {
		ArrayList<String> lines = readLines(filePath);
		int i = 0;
		while (i < lines.size()) {
			if (lines.get(i).startsWith("ISBN") && i + FIELD_COUNT <= lines.size()) {
				try {
					Book bookitem = new Book(lines.get(i), lines.get(i + 1), Integer.parseInt(lines.get(i + 2)),
							lines.get(i + 3), lines.get(i + 4), lines.get(i + 5), lines.get(i + 6));
					booklist.add(bookitem);
					i += FIELD_COUNT;
					continue;
				} catch (NumberFormatException e) {
					System.out.println(e); // 가격이 숫자가 아닌 데이터는 건너뜀
				}
			}
			i++;
		}
	}

	private static ArrayList<String> readLines(String filePath) {
		ArrayList<String> lines = new ArrayList<String>();
		if (filePath == null)
			return lines;
		try (BufferedReader reader = new BufferedReader(
				new InputStreamReader(new FileInputStream(filePath), StandardCharsets.UTF_8))) {
			String str;
			while ((str = reader.readLine()) != null)
				lines.add(str.trim());
		} catch (IOException e) {
			System.out.println(e);
		}
		if (!lines.isEmpty() && lines.get(0).startsWith("\uFEFF")) // BOM 제거
			lines.set(0, lines.get(0).substring(1));
		return lines;
	}

	/** 도서ID 로 도서 찾기 (없으면 null) */
	public static Book getBookById(String bookId) {
		if (bookId == null)
			return null;
		for (Book b : mBookList) {
			if (bookId.equals(b.getBookId()))
				return b;
		}
		return null;
	}

	/** 도서명 또는 저자에 keyword 가 들어 있는 도서 검색 */
	public static ArrayList<Book> search(String keyword) {
		ArrayList<Book> result = new ArrayList<Book>();
		if (keyword == null || keyword.trim().isEmpty()) {
			result.addAll(mBookList);
			return result;
		}
		String k = keyword.trim().toLowerCase();
		for (Book b : mBookList) {
			if (b.getName().toLowerCase().contains(k) || b.getAuthor().toLowerCase().contains(k))
				result.add(b);
		}
		return result;
	}

	/** 새 도서ID 만들기 : ISBN + 년월일시분초 (겹치면 -1, -2 ... 를 붙임) */
	public static synchronized String newBookId() {
		String base = "ISBN" + new SimpleDateFormat("yyMMddHHmmss").format(new Date());
		String id = base;
		int n = 1;
		while (getBookById(id) != null)
			id = base + "-" + (n++);
		return id;
	}

	/** 관리자 화면에서 도서 추가 : 목록에 추가하고 book.txt 전체를 다시 저장 */
	public static synchronized boolean addBook(String filePath, Book book) {
		if (filePath == null)
			return false;
		ArrayList<Book> list = new ArrayList<Book>(mBookList);
		list.add(book);
		try (Writer w = new OutputStreamWriter(new FileOutputStream(filePath), StandardCharsets.UTF_8)) {
			for (Book b : list) {
				w.write(clean(b.getBookId()) + "\n");
				w.write(clean(b.getName()) + "\n");
				w.write(b.getUnitPrice() + "\n");
				w.write(clean(b.getAuthor()) + "\n");
				w.write(clean(b.getDescription()) + "\n");
				w.write(clean(b.getCategory()) + "\n");
				w.write(clean(b.getReleaseDate()) + "\n");
			}
		} catch (IOException e) {
			System.out.println(e);
			return false;
		}
		mBookList = list;
		mTotalBook = list.size();
		return true;
	}

	// 줄바꿈 제거, 빈 값은 "-" 로 (한 권 = 정확히 7줄 유지)
	private static String clean(String s) {
		if (s == null)
			return "-";
		s = s.replace("\r", " ").replace("\n", " ").trim();
		return s.isEmpty() ? "-" : s;
	}

	public static ArrayList<Book> getmBookList() {
		return mBookList;
	}

	public static void setmBookList(ArrayList<Book> mBookList) {
		BookInIt.mBookList = mBookList;
	}

	public static int getmTotalBook() {
		return mTotalBook;
	}

	public static void setmTotalBook(int mTotalBook) {
		BookInIt.mTotalBook = mTotalBook;
	}
}
