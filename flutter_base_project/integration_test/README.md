# E2E Testing (`integration_test/`)

Thư mục này chứa các bài test end-to-end (e2e) của app, viết bằng
[**Patrol**](https://patrol.leancode.co) trên nền package chính thức
[`integration_test`](https://docs.flutter.dev/testing/integration-tests) của
Flutter. Khác với `test/` (unit test / widget test chạy trong VM, mock mọi
plugin), test ở đây chạy **trên thiết bị thật hoặc simulator/emulator**,
dựng toàn bộ app thật (UI, routing, BLoC, DI) và lái nó như người dùng thật:
gõ chữ, nhấn nút, chờ điều hướng, kiểm tra màn hình hiển thị đúng.

> Vì sao tên thư mục là `integration_test` chứ không phải `patrol_test`
> (mặc định của Patrol)? Đây là quy ước **bắt buộc** của tooling Flutter —
> `flutter drive`/native test runner (Android instrumentation, iOS XCTest,
> Firebase Test Lab...) đều mặc định tìm test ở thư mục tên này. Project này
> ghim `test_directory: integration_test` trong `pubspec.yaml` (mục
> `patrol:`) để Patrol dùng đúng thư mục quen thuộc, không phá vỡ
> `test_driver/` và `run_e2e_with_video.sh` sẵn có.

## Vì sao dùng Patrol thay vì `testWidgets` thuần?

`integration_test` + `flutter_test` thuần đã đủ dùng cho luồng UI đơn giản,
nhưng project này có nhiều màn hình sẽ cần **automation ở tầng hệ điều
hành** mà `WidgetTester` không với tới được — ví dụ dialog xin quyền
BiometricPrompt (`local_auth`, xem `LoginBloc.biometricLogin`) hoặt dialog
xin quyền notification (`firebase_messaging`). Patrol bổ sung:

- **`PatrolFinder`** (`$(key)`, `$(Type)`, `$('text')`) — tự động chờ/thử
  lại tới khi widget xuất hiện trước khi `tap()`/`enterText()`, đỡ phải tự
  chêm `pumpAndSettle()` sau mỗi thao tác nhỏ. Vẫn tương thích thẳng với
  `expect(_, findsOneWidget)` như `Finder` thường.
- **Native automation** (`$.native`, `$.platform.mobile.*`) — bấm nút Home,
  mở app khác, xử lý dialog permission/notification của hệ điều hành. Chưa
  dùng trong `login_flow_test.dart` (mẫu hiện tại chỉ thao tác trong app),
  nhưng hạ tầng native đã được bootstrap sẵn (xem mục "Native setup" dưới)
  để flow test sau này (biometric, push notification) dùng được ngay.

Patrol **không thay thế** `integration_test`/`flutter_test` — nó là lớp bọc
thêm API lên trên, và test viết bằng `patrolTest` vẫn là 1 file test
`flutter_test` bình thường. Nhưng **chỉ chạy qua `patrol test` hoặc
`flutter drive`** — xem mục "Chạy test" bên dưới để biết vì sao
`flutter test -d <device>` không dùng được với `patrolTest`.

## Cấu trúc thư mục

```
integration_test/
├── README.md               ← file này
├── helpers/                 ← hạ tầng dùng chung cho mọi test (bootstrap, reset state)
│   └── test_app.dart
├── pages/                    ← Page Object — 1 file / 1 màn hình
│   ├── login_page_object.dart
│   └── inspector_home_page_object.dart
└── flows/                    ← test case thật sự — 1 file / 1 luồng nghiệp vụ
    └── login_flow_test.dart

test_driver/
└── integration_test.dart    ← driver entrypoint cho `flutter drive` (web/CI/device farm)

lib/testing/                 ← Key + fake data dùng chung giữa lib/ và integration_test/
├── test_keys.dart            (xem mục "Test Key" bên dưới)
└── fixtures/
    └── auth_fixtures.dart
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
- `pumpApp($)` — dựng `MyApp` và chờ splash (`MainAppPage`) điều hướng xong
  tới màn hình đầu tiên. Nhận `PatrolIntegrationTester $` (tham số duy nhất
  của `patrolTest`) thay vì `WidgetTester` thuần.
- `captureScreenshot($, name)` — chụp màn hình, xem mục "Báo cáo hình
  ảnh/video".

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

Mỗi Page Object nhận `PatrolIntegrationTester $` qua constructor và expose
Finder dạng `PatrolFinder get xxx => $(TestKeys.xxx);` — dùng
`Key` từ `lib/testing/test_keys.dart` (xem mục "Test Key" bên dưới),
**không** dựa vào text hiển thị, vì text có thể đổi theo ngôn ngữ
(`app_zh.arb` / `app_vi.arb` / `app_en.arb`) hoặc nội dung copywriting mà
không phải lỗi thật của app.

### `flows/` — Test case theo luồng nghiệp vụ

Đây là nơi viết test thật, dùng `patrolTest(name, ($) async { ... })` thay
vì `testWidgets` thuần. Mỗi file tương ứng một **luồng nghiệp vụ** (không
phải một widget riêng lẻ) — ví dụ `login_flow_test.dart` test luồng đăng
nhập từ splash → LoginPage → nhập liệu → InspectorHomePage.

`login_flow_test.dart` là **test case mẫu** đi kèm 2 kịch bản:

1. Đăng nhập thành công với tài khoản demo `AuthFixtures.demoInspectorEmail`
   / `AuthFixtures.demoInspectorPassword` (`lib/testing/fixtures/auth_fixtures.dart`
   — cùng nguồn dữ liệu mà `AuthRemoteDataSourceImpl` seed sẵn, xem
   `lib/features/auth/data/datasources/auth_remote_datasource.dart`) → vào
   được `InspectorHomePage`.
2. Đăng nhập sai mật khẩu → ở lại `LoginPage`.

Dùng file này làm khuôn khi viết flow mới: `setUpAll` đăng ký DI,
`setUp` reset state, mỗi `patrolTest` là một kịch bản, thao tác qua Page
Object thay vì gọi thẳng `find.byKey`/`$.tester.tap` trong file flow.

`patrolTest` tự gọi `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
bên trong — **không** cần tự gọi lại như khi dùng `testWidgets`.

## Luồng hoạt động của một test case

```
1. setUpAll()      → setUpTestDependencies()   (đăng ký GetIt — 1 lần/file)
2. setUp()         → resetAppState()           (xoá SharedPreferences — mỗi test)
3. patrolTest('...', ($) async {
   a. pumpApp($)                               (dựng MyApp, chờ qua splash)
   b. Tạo Page Object cho màn hình cần thao tác, truyền `$`
   c. Gọi hành vi cấp cao (vd. loginPage.login(...))
   d. expect(...) trên Page Object của màn hình kết quả
})
```

Vì app dùng dữ liệu **mock có độ trễ giả lập** (`Future.delayed` trong các
`*RemoteDataSourceImpl`, mô phỏng gọi API thật), test dùng `pumpAndSettle()`
sau mỗi hành động thay vì đếm `pump()` thủ công — Flutter sẽ tự bơm frame
tới khi hết animation/Future đang chờ. Vì có loading spinner (indeterminate,
animate vô hạn khi đang hiển thị) trong lúc chờ, `pumpAndSettle()` chỉ an
toàn vì spinner đó luôn biến mất trong thời gian hữu hạn (màn hình điều
hướng đi hoặc load xong) — nếu thêm màn hình có spinner "treo mãi mãi" theo
thiết kế, cần thay bằng `pump(duration)` với thời lượng cụ thể.

## Test Key & fake data (`lib/testing/`)

Để Page Object tìm widget ổn định (không phụ thuộc ngôn ngữ hiển thị), một
số widget trong `lib/` được gắn thêm `Key` cố định. Từ khi áp dụng Patrol,
mọi Key này được **tập trung** ở `lib/testing/test_keys.dart` (class
`TestKeys`) thay vì viết `Key('...')` rải rác trong widget — xem docblock
trong file đó để biết quy ước đặt tên và lý do. Tương tự, dữ liệu demo dùng
để test (tài khoản đăng nhập demo...) tập trung ở `lib/testing/fixtures/`,
dùng chung với mock datasource — xem `lib/testing/README.md`.

| `TestKeys` | Widget | File |
|---|---|---|
| `loginPageScaffold` | `Scaffold` của LoginPage | `lib/features/auth/presentation/pages/login_page.dart` |
| `loginCompanyCodeField` | Ô công ty | `lib/features/auth/presentation/widgets/login_form.dart` |
| `loginAccountField` | Ô tài khoản | `lib/features/auth/presentation/widgets/login_form.dart` |
| `loginPasswordField` | Ô mật khẩu | `lib/features/auth/presentation/widgets/login_form.dart` |
| `loginSubmitButton` | Nút đăng nhập | `lib/features/auth/presentation/widgets/login_form.dart` |
| `inspectorHomePageScaffold` | `Scaffold` của InspectorHomePage | `lib/features/inspector_home/presentation/pages/inspector_home_page.dart` |

Khi thêm test cho màn hình mới, ưu tiên thêm hằng số `Key` mới vào
`TestKeys` rồi gắn vào đúng widget gốc (rẻ, không ảnh hưởng UI/behavior)
thay vì tìm theo `find.text(...)`/`$('...')` (text) hay `find.byType(...)`
ở vị trí không ổn định.

## Patrol — Native setup

Trạng thái bootstrap native trong project này:

| Nền tảng | Trạng thái | Cần làm thêm |
|---|---|---|
| Android | ✅ Đã bootstrap sẵn | Không — `android/app/build.gradle.kts` đã có `testInstrumentationRunner`/`testOptions`/orchestrator, `MainActivityTest.java` đã có ở `android/app/src/androidTest/`. |
| iOS | ⚠️ Cần làm thủ công 1 lần trong Xcode | Xem hướng dẫn bên dưới — **không thể tự động hoá bằng sửa file text**, phải tạo Target mới qua Xcode GUI (hoặc chạy `patrol bootstrap`). |

### Cài `patrol_cli` (bắt buộc để chạy `patrol test`/`patrol doctor`)

```bash
flutter pub global activate patrol_cli
# đảm bảo thư mục pub global bin nằm trong PATH, xem `flutter pub global activate` output
patrol doctor   # kiểm tra môi trường đã sẵn sàng chưa
```

### Hoàn tất setup iOS (làm 1 lần, chỉ cần khi muốn chạy trên iOS)

Cách nhanh nhất — để `patrol_cli` tự làm:

```bash
patrol bootstrap
```

Nếu muốn tự tay làm trong Xcode (hoặc `patrol bootstrap` báo lỗi và cần
kiểm tra lại từng bước):

1. Mở `ios/Runner.xcworkspace` bằng Xcode.
2. **File → New → Target… → UI Testing Bundle**. Đặt Product Name là
   `RunnerUITests`, Target to be tested chọn `Runner`, Organization
   Identifier giống Runner (bundle id app: `com.shinda.inspectionapp`).
3. Xoá nội dung mặc định Xcode sinh ra trong `RunnerUITests/RunnerUITests.m`
   (hoặc `.swift`), thay bằng đúng 4 dòng sau (macro của Patrol tự sinh
   toàn bộ test case từ các file `.dart` trong `integration_test/`):

   ```objc
   @import XCTest;
   @import patrol;
   @import ObjectiveC.runtime;

   PATROL_INTEGRATION_TEST_IOS_RUNNER(RunnerUITests)
   ```

4. RunnerUITests → **Build Phases**: thêm 2 Run Script Phase mới, đặt tên
   `xcode_backend build` và `xcode_backend embed_and_thin` (nội dung script
   giống hệt phase tương ứng bên target `Runner` — Patrol dùng để nhúng
   Flutter engine vào bundle test).
5. Đảm bảo mỗi Build Configuration (Debug/Profile/Release) của
   `RunnerUITests` dùng chung Configuration Set với `Runner`.
6. RunnerUITests → **Build Settings** → tìm `User Script Sandboxing`, set
   thành **No**.
7. Đảm bảo **iOS Deployment Target** của `RunnerUITests` bằng với `Runner`.
8. Thêm target vào `ios/Podfile` (bên trong `target 'Runner' do`, cạnh
   `RunnerTests` đã có sẵn):

   ```ruby
   target 'RunnerUITests' do
     inherit! :complete
   end
   ```

   rồi chạy `cd ios && pod install`.

> Các bước 2–7 thao tác trực tiếp trên `ios/Runner.xcodeproj` — đây là lý
> do agent/script không tự làm thay được (sửa `project.pbxproj` bằng tay
> rất dễ làm hỏng project Xcode); `patrol bootstrap` hoặc thao tác tay qua
> Xcode GUI là 2 cách an toàn duy nhất.

## Cách chạy

### `patrol test` — khuyến nghị, bắt buộc nếu flow dùng native automation

```bash
flutter devices                      # xem device id đang có
patrol test -t integration_test/flows/login_flow_test.dart -d <device-id>

# chạy toàn bộ flow:
patrol test -t integration_test/flows -d <device-id>
```

### Qua `flutter drive` — không cần patrol_cli, dùng được report ảnh/video có sẵn

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/flows/login_flow_test.dart \
  -d <device-id>
```

Chỉ chạy được với flow không gọi native automation của Patrol (những API đó
cần cầu nối `PatrolAppService` mà chỉ `patrol test` mới khởi động).

> **KHÔNG dùng `flutter test integration_test/... -d <device-id>`** cho test
> viết bằng `patrolTest` (khác với hướng dẫn cũ khi còn dùng `testWidgets`
> thuần): khi chạy trên 1 device thật (không phải VM), `flutter test` tự
> chèn 1 file `listener.dart` gọi
> `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` **trước** khi
> `main()` của file test chạy; `patrolTest` bên trong lại tự khởi tạo
> `PatrolBinding` (kế thừa `LiveTestWidgetsFlutterBinding`) — khởi tạo 2 lần
> khiến test crash ngay ở bước `loading ...` với lỗi `Binding is already
> initialized to IntegrationTestWidgetsFlutterBinding` (xem
> [patrol#1666](https://github.com/leancodepl/patrol/issues/1666)). Đã kiểm
> chứng trực tiếp trên máy dev: lỗi này chỉ xảy ra với `flutter test`, không
> xảy ra với `flutter drive`/`patrol test` (2 lệnh đó chạy thẳng `main()`
> của file test, không đi qua `listener.dart`).

## Báo cáo hình ảnh/video

### Ảnh (screenshot report) — tự động, chỉ cần chạy qua `flutter drive`

Trong flow test, gọi `captureScreenshot($, 'tên_bước')` (định nghĩa ở
`helpers/test_app.dart`) tại các bước muốn ghi lại bằng chứng — xem
`flows/login_flow_test.dart` để có ví dụ (`01_login_page`,
`02_login_success_inspector_home`, `03_login_invalid_password_error`).

Lệnh `captureScreenshot` **chỉ được driver ghi ra file khi chạy qua
`flutter drive`** (không phải `flutter test`/`patrol test`), vì cơ chế lấy
dữ liệu ảnh về máy host cần tiến trình driver. `test_driver/integration_test.dart`
đã được cấu hình để tự động:

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
`integration_test`/Patrol), nên hoạt động với bất kỳ flow nào mà không cần
sửa gì trong file test.

## Thêm flow test mới

1. Nếu màn hình chưa có Page Object → tạo file mới trong `pages/`, gắn thêm
   `Key` cần thiết vào widget gốc trong `lib/features/` (khai báo hằng số
   mới trong `lib/testing/test_keys.dart` trước, xem mục "Test Key" ở
   trên) nếu chưa có.
2. Nếu flow cần dữ liệu demo mới, thêm vào `lib/testing/fixtures/` (tạo
   file `<feature>_fixtures.dart` mới theo mẫu `auth_fixtures.dart`) và
   dùng lại từ mock datasource lẫn flow test — không hardcode 2 lần.
3. Tạo file mới trong `flows/`, đặt tên theo luồng nghiệp vụ
   (`<ten_luong>_flow_test.dart`), copy khung `setUpAll`/`setUp`/`patrolTest`
   từ `login_flow_test.dart`.
4. Viết kịch bản bằng Page Object, tránh thao tác `$.tester.tap`/`find.byKey`
   trực tiếp trong file flow.
5. Muốn có bằng chứng ảnh trong report, thêm `captureScreenshot($, '...')`
   tại các bước quan trọng (xem mục "Báo cáo hình ảnh/video" ở trên).
6. Cần automation tầng hệ điều hành (dialog permission, notification, bấm
   Home...) → dùng `$.native`/`$.platform.mobile.*` (xem
   [tài liệu Patrol](https://patrol.leancode.co)) và chạy bằng `patrol test`
   thay vì `flutter test`/`flutter drive`.
