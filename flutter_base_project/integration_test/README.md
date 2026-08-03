# E2E Testing (`integration_test/`)

Thư mục này chứa các bài test end-to-end (e2e) của app, dùng package
chính thức [`integration_test`](https://docs.flutter.dev/testing/integration-tests)
của Flutter. Khác với `test/` (unit test / widget test chạy trong VM, mock
mọi plugin), test ở đây chạy **trên thiết bị thật hoặc simulator/emulator**,
dựng toàn bộ app thật (UI, routing, BLoC, DI) và lái nó như người dùng thật:
gõ chữ, nhấn nút, chờ điều hướng, kiểm tra màn hình hiển thị đúng.

> Vì sao tên thư mục là `integration_test` chứ không phải `e2e`? Đây là quy
> ước **bắt buộc** của tooling Flutter — package `integration_test` cùng
> `flutter drive`/native test runner (Android instrumentation, iOS XCTest,
> Firebase Test Lab...) đều mặc định tìm test ở thư mục tên này. Đổi tên sẽ
> làm mất khả năng chạy qua `flutter drive` và các CI runner chuẩn.

## Cấu trúc thư mục

```
integration_test/
├── README.md              ← file này
├── helpers/                ← hạ tầng dùng chung cho mọi test (bootstrap, reset state)
│   └── test_app.dart
├── pages/                   ← Page Object — 1 file / 1 màn hình
│   ├── login_page_object.dart
│   └── inspector_home_page_object.dart
└── flows/                   ← test case thật sự — 1 file / 1 luồng nghiệp vụ
    └── login_flow_test.dart

test_driver/
└── integration_test.dart   ← driver entrypoint cho `flutter drive` (web/CI/device farm)
```

### `helpers/` — Bootstrap & trạng thái test

Chứa các hàm dùng chung để mọi flow test không phải lặp lại code khởi tạo:

- `setUpTestDependencies()` — đăng ký DI (GetIt) một lần cho cả file test
  (gọi trong `setUpAll`). **Không** gọi `main()` thật của app — `main()` còn
  init Firebase, xin quyền push notification, lắng nghe deep link... những
  thứ cần thiết bị thật/mock riêng và có thể trồi lên dialog hệ điều hành
  làm treo test. E2E ở đây chỉ quan tâm luồng UI nên chỉ cần DI + `MyApp`.
- `resetAppState()` — xoá sạch `SharedPreferences` trước mỗi test (`setUp`)
  để app luôn khởi động ở trạng thái "chưa đăng nhập", không phụ thuộc dữ
  liệu phiên trước để lại trên cùng thiết bị/simulator (tránh test bị
  flaky vì máy đã "nhớ" lần đăng nhập trước).
- `pumpApp(tester)` — dựng `MyApp` và chờ splash (`MainAppPage`) điều hướng
  xong tới màn hình đầu tiên.

Khi thêm luồng test mới cần thêm hạ tầng dùng chung (vd. seed dữ liệu mock
khác, mock giờ hệ thống...), thêm hàm mới vào đây — không copy-paste vào
từng file `flows/`.

### `pages/` — Page Object Model

Mỗi file bọc **Finder** (cách tìm widget) và **hành vi cấp cao** của đúng
một màn hình, theo mẫu [Page Object Model](https://martinfowler.com/bliki/PageObject.html).
Ví dụ `LoginPageObject.login(...)` gói toàn bộ thao tác "điền form + nhấn
đăng nhập + chờ điều hướng" thành một lời gọi duy nhất.

Lợi ích: file trong `flows/` chỉ nói "làm gì" (nghiệp vụ), không nói "làm
như thế nào" (Key nào, thứ tự pump ra sao). Khi UI đổi (đổi `Key`, thêm
bước xác nhận...), chỉ sửa 1 chỗ trong `pages/`, không phải sửa lại từng
test case đang dùng màn hình đó.

Các Finder ở đây dựa vào `Key` gắn sẵn trên widget thật trong `lib/` (xem
mục "Test Key" bên dưới) — **không** dựa vào text hiển thị, vì text có thể
đổi theo ngôn ngữ (`app_zh.arb` / `app_vi.arb` / `app_en.arb`) hoặc nội dung
copywriting mà không phải lỗi thật của app.

### `flows/` — Test case theo luồng nghiệp vụ

Đây là nơi viết test thật. Mỗi file tương ứng một **luồng nghiệp vụ** (không
phải một widget riêng lẻ) — ví dụ `login_flow_test.dart` test luồng đăng
nhập từ splash → LoginPage → nhập liệu → InspectorHomePage.

`login_flow_test.dart` là **test case mẫu** đi kèm 2 kịch bản:

1. Đăng nhập thành công với tài khoản demo `test@example.com` /
   `password123` (seed sẵn trong `AuthRemoteDataSourceImpl` — xem
   `lib/features/auth/data/datasources/auth_remote_datasource.dart`) → vào
   được `InspectorHomePage`.
2. Đăng nhập sai mật khẩu → ở lại `LoginPage`.

Dùng file này làm khuôn khi viết flow mới: `setUpAll` đăng ký DI,
`setUp` reset state, mỗi `testWidgets` là một kịch bản, thao tác qua Page
Object thay vì gọi thẳng `find.byKey`/`tester.tap` trong file flow.

## Luồng hoạt động của một test case

```
1. setUpAll()      → setUpTestDependencies()   (đăng ký GetIt — 1 lần/file)
2. setUp()         → resetAppState()           (xoá SharedPreferences — mỗi test)
3. testWidgets(...)
   a. pumpApp(tester)                          (dựng MyApp, chờ qua splash)
   b. Tạo Page Object cho màn hình cần thao tác
   c. Gọi hành vi cấp cao (vd. loginPage.login(...))
   d. expect(...) trên Page Object của màn hình kết quả
```

Vì app dùng dữ liệu **mock có độ trễ giả lập** (`Future.delayed` trong các
`*RemoteDataSourceImpl`, mô phỏng gọi API thật), test dùng `pumpAndSettle()`
sau mỗi hành động thay vì đếm `pump()` thủ công — Flutter sẽ tự bơm frame
tới khi hết animation/Future đang chờ. Vì có loading spinner (indeterminate,
animate vô hạn khi đang hiển thị) trong lúc chờ, `pumpAndSettle()` chỉ an
toàn vì spinner đó luôn biến mất trong thời gian hữu hạn (màn hình điều
hướng đi hoặc load xong) — nếu thêm màn hình có spinner "treo mãi mãi" theo
thiết kế, cần thay bằng `pump(duration)` với thời lượng cụ thể.

## Test Key trong `lib/`

Để Page Object tìm widget ổn định (không phụ thuộc ngôn ngữ hiển thị), một
số widget trong `lib/` được gắn thêm `Key` cố định, dùng riêng cho test:

| Key | Widget | File |
|---|---|---|
| `login_page_scaffold` | `Scaffold` của LoginPage | `lib/features/auth/presentation/pages/login_page.dart` |
| `login_company_code_field` | Ô công ty | `lib/features/auth/presentation/widgets/login_form.dart` |
| `login_account_field` | Ô tài khoản | `lib/features/auth/presentation/widgets/login_form.dart` |
| `login_password_field` | Ô mật khẩu | `lib/features/auth/presentation/widgets/login_form.dart` |
| `login_submit_button` | Nút đăng nhập | `lib/features/auth/presentation/widgets/login_form.dart` |
| `inspector_home_page_scaffold` | `Scaffold` của InspectorHomePage | `lib/features/inspector_home/presentation/pages/inspector_home_page.dart` |

Khi thêm test cho màn hình mới, ưu tiên thêm `Key` tương tự vào widget gốc
(rẻ, không ảnh hưởng UI/behavior) thay vì tìm theo `find.text(...)` hay
`find.byType(...)` ở vị trí không ổn định.

## Cách chạy

### Trên thiết bị/simulator đã kết nối (mobile, desktop) — cách chính

```bash
flutter devices                      # xem device id đang có
flutter test integration_test/flows/login_flow_test.dart -d <device-id>

# chạy toàn bộ flow:
flutter test integration_test/ -d <device-id>
```

### Qua `flutter drive` — bắt buộc cho Web, khuyến nghị cho CI/device farm

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/flows/login_flow_test.dart \
  -d <device-id>
```

## Báo cáo hình ảnh/video

### Ảnh (screenshot report) — tự động, chỉ cần chạy qua `flutter drive`

Trong flow test, gọi `captureScreenshot(tester, 'tên_bước')` (định nghĩa ở
`helpers/test_app.dart`) tại các bước muốn ghi lại bằng chứng — xem
`flows/login_flow_test.dart` để có ví dụ (`01_login_page`,
`02_login_success_inspector_home`, `03_login_invalid_password_error`).

Lệnh `captureScreenshot` **chỉ được driver ghi ra file khi chạy qua
`flutter drive`** (không phải `flutter test`), vì cơ chế lấy dữ liệu ảnh về
máy host cần tiến trình driver. `test_driver/integration_test.dart` đã được
cấu hình để tự động:

1. Gom toàn bộ ảnh đã chụp trong lần chạy.
2. Ghi từng ảnh ra `integration_test/reports/<run-timestamp>/screenshots/*.png`.
3. Sinh 1 trang `integration_test/reports/<run-timestamp>/report.html` gộp
   tất cả ảnh lại thành gallery — mở trực tiếp bằng trình duyệt để xem báo
   cáo trực quan sau khi test chạy xong.

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/flows/login_flow_test.dart \
  -d <device-id>

open integration_test/reports/*/report.html   # xem report ảnh vừa sinh (macOS)
```

Thư mục `integration_test/reports/` được git-ignore (xem `.gitignore`) vì
đây là artifact sinh ra mỗi lần chạy, không phải nguồn để commit.

### Video — quay màn hình song song khi chạy `flutter drive`

Dùng script `run_e2e_with_video.sh` ở thư mục gốc project: script tự nhận
diện thiết bị là iOS Simulator (`xcrun simctl io recordVideo`) hay Android
emulator/device (`adb shell screenrecord`), quay màn hình trong lúc
`flutter drive` chạy, rồi lưu video vào cùng thư mục report với ảnh:

```bash
./run_e2e_with_video.sh <device-id> integration_test/flows/login_flow_test.dart
# → integration_test/reports/<run-timestamp>/e2e.mp4
```

Đây là quay màn hình ở tầng hệ điều hành (không phải API của
`integration_test`), nên hoạt động với bất kỳ flow nào mà không cần sửa gì
trong file test.

## Thêm flow test mới

1. Nếu màn hình chưa có Page Object → tạo file mới trong `pages/`, gắn thêm
   `Key` cần thiết vào widget gốc trong `lib/` nếu chưa có.
2. Tạo file mới trong `flows/`, đặt tên theo luồng nghiệp vụ
   (`<ten_luong>_flow_test.dart`), copy khung `setUpAll`/`setUp` từ
   `login_flow_test.dart`.
3. Viết kịch bản bằng Page Object, tránh thao tác `find`/`tap` trực tiếp
   trong file flow.
4. Muốn có bằng chứng ảnh trong report, thêm `captureScreenshot(tester, '...')`
   tại các bước quan trọng (xem mục "Báo cáo hình ảnh/video" ở trên).
