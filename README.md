# BookMarketWeb v2 (디자인 리뉴얼 + 기능 추가)

Tomcat 10.x 이상 / Jakarta Servlet 5.0~6.0 / **Java 11 이상** 기준입니다. (외부 jar 필요 없음)

## 1. 이클립스에 적용하는 방법 (기존과 동일)
1. `File > New > Dynamic Web Project` → 이름 `BookMarketWeb`, Target runtime = Tomcat 10.x, `Generate web.xml` 체크
2. 이 압축 파일의 **`src` 폴더 안 내용**을 프로젝트의 `src` 에 그대로 덮어쓰기 (web.xml 도 덮어쓰기)
3. 프로젝트 `Properties > Resource > Text file encoding` = **UTF-8** → F5
4. 서버에 프로젝트 추가 후 Start → http://localhost:8080/BookMarketWeb/index.jsp

## 2. 바뀐 디자인
| 구분 | 기존 | 변경 |
|---|---|---|
| 메뉴 | 상단 파란/회색 탭 | **왼쪽 딥그린 사이드바** + 상단 검색바 + 장바구니 아이콘/배지 |
| 도서 목록 | 표(table) | **표지 카드 그리드** (찜 하트, 분야 태그, 담기 버튼) |
| 색상 | 파랑 | 딥그린 + 크림 배경 + 테라코타 포인트 |
| 아이콘 | 이모지 | SVG 아이콘 (header.jsp 한 곳에서 관리) |
| 로그인 | 이름/연락처 입력 | **Google 아이콘 버튼** + 회원 로그인 + 비회원 주문 탭 |
| 반응형 | 없음 | 모바일에서는 사이드바가 상단 메뉴로 변경 |

색상은 `css/style.css` 맨 위 `:root { --green ... }` 변수만 바꾸면 전체 테마가 바뀝니다.

## 3. 추가된 기능
| 기능 | 화면 | 연결되는 자바 |
|---|---|---|
| 구글 로그인 아이콘 | `login.jsp`, `socialLogin.jsp` | member.GoogleAuth, member.User |
| 회원가입 + 암호화 로그인 (SHA-256 + salt) | `signup.jsp`, `login.jsp` | member.MemberStore |
| 비회원 주문 (기존 이름/연락처 방식 유지) | `login.jsp` 2번째 탭 | member.UserInIt |
| 쿠폰 4종 (정률/정액/무료배송, 최소금액, 1인 1회) | `coupons.jsp`, `cart.jsp` | cart.Coupon, CouponInIt |
| 배송비 규칙 (3만원 이상 무료) + 무료배송 진행바 | `cart.jsp`, `shipping.jsp` | cart.Pricing |
| 주문 저장 + 주문번호(BM+날짜+번호) | `shipping.jsp` | cart.Order, OrderStore |
| 주문 현황 (4단계 진행바, 주문 취소) | `orders.jsp` | cart.Order, OrderStore |
| 관리자 주문관리 (배송상태 변경) + 매출 대시보드 | `orders.jsp`, `admin.jsp` | cart.OrderStore |
| 찜한 도서 | `wishlist.jsp` | (session) |
| 도서 상세 / 바로 구매 | `bookDetail.jsp` | bookitem.BookInIt |
| 분야 필터 + 정렬 (최신/가격/이름) + 검색 | `index.jsp` | bookitem.BookInIt |
| 내 정보 : 회원 등급(BASIC/SILVER/GOLD) | `guestInfo.jsp` | member.User.gradeOf |
| 영수증 : 쿠폰/배송비 반영, 인쇄 | `orderBill.jsp` | cart.Order |

(기존 기능 유지 : 장바구니 수량 +/-, 삭제, 비우기, 도서 검색, 관리자 도서 추가)

## 4. PPT 12슬라이드(기능 관련) 화면 대응
| PPT 항목 | 새 화면 |
|---|---|
| 고객정보 관리 | 내 정보 `guestInfo.jsp` |
| 주문현황 관리 | 주문 현황 `orders.jsp` |
| 장바구니 관리 | 장바구니 `cart.jsp` |
| 쿠폰 | 쿠폰함 `coupons.jsp` + 장바구니 쿠폰 입력 |
| 영수증 | `orderBill.jsp` |

## 5. 구글 로그인 연결하기 (선택)
기본은 **데모 모드**입니다. (이메일/이름을 입력하면 구글로 로그인된 것처럼 동작 — 발표 시연용)

진짜 구글 로그인을 켜려면:
1. https://console.cloud.google.com → API 및 서비스 → 사용자 인증 정보 → **OAuth 클라이언트 ID 만들기** (유형: 웹 애플리케이션)
2. 승인된 JavaScript 원본에 `http://localhost:8080` 추가
3. 발급된 클라이언트 ID 를 `WEB-INF/web.xml` 의 `GOOGLE_CLIENT_ID` 값에 붙여넣기
4. 톰캣 재시작 → 구글 아이콘 클릭 시 실제 구글 로그인 버튼이 나타남
   (브라우저가 받은 ID 토큰을 서버가 구글 `tokeninfo` 로 확인 → `member.GoogleAuth`)


## 6. 기본 정보 / 주의사항
- 관리자 : ID `Admin` / 비밀번호 `Admin1234` → 사이드바 하단 [관리자 센터]
- 쿠폰 코드 : `WELCOME10`(10%, 1만원↑), `BOOK3000`(3천원, 2만원↑), `FREESHIP`(배송비 무료), `VIP20`(20%, 5만원↑)
- 회원 정보 : `WEB-INF/members.txt` (비밀번호는 해시로만 저장), 도서 : `WEB-INF/book.txt`
- **주문 내역은 서버 메모리에 저장**되어 톰캣 재시작 시 사라집니다. → DB(JDBC) 과제 단계에서 `cart.OrderStore` 의 메서드만 DB 조회/저장으로 바꾸면 되도록 분리해 두었습니다. (`MemberStore` 도 동일)
- 새 도서 표지 : `images/도서ID.jpg` 로 넣으면 자동 표시 (없으면 noimage)
- 메뉴 이름/로고/아이콘 변경 : `common/header.jsp` 한 곳만 수정
