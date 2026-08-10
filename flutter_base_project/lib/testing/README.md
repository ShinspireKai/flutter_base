# `lib/testing/`

Thư mục này chứa 2 loại thứ dùng **chỉ để hỗ trợ test** nhưng phải sống trong
`lib/` (không thể đặt trong `test/` hay `integration_test/`) vì bản thân
`lib/` mới là nơi định nghĩa widget và mock datasource cần dùng tới chúng:

- **`test_keys.dart`** — tập trung mọi `Key` gắn lên widget chỉ để
  `integration_test/` (Patrol) tìm ra chúng bằng `find.byKey`/`$(key)`, thay
  vì rải `Key('...')` trực tiếp trong từng widget. Xem docblock trong file
  để biết quy ước đặt tên và lý do tập trung một chỗ.

- **`fixtures/`** — dữ liệu demo/mock dùng chung giữa mock datasource (tầng
  `data/`, ví dụ `AuthRemoteDataSourceImpl`) và test — 1 nguồn sự thật duy
  nhất cho tài khoản demo, tránh hardcode trùng lặp giữa `lib/features/` và
  `integration_test/`.

## Vì sao nằm trong `lib/` chứ không phải `test/`?

`Key` phải được gắn vào cây widget thật đang chạy trong app (kể cả bản
release) để test tìm thấy — không thể "chèn" Key từ bên ngoài `lib/`. Tương
tự, dữ liệu fixture cần được cả mock datasource (chạy trong app thật) lẫn
test cùng import, nên phải nằm ở nơi cả hai phía đều `import` được — tức
`lib/`, không phải `test/` (test/integration_test không được app import
ngược lại).

Chi phí đánh đổi: các hằng số này bị đóng gói vào production build. Chấp
nhận được vì đây là hằng số nhỏ (String/Key), không phải logic hay dữ liệu
nhạy cảm.

## Khi thêm feature/test mới

1. Thêm `Key` mới vào `test_keys.dart` (nhóm theo feature, comment phân
   cách như các feature hiện có) thay vì viết `Key('...')` trực tiếp trong
   widget.
2. Nếu feature có mock datasource cần dữ liệu demo dùng lại trong test, tạo
   file mới trong `fixtures/` (ví dụ `fixtures/maintenance_fixtures.dart`)
   theo mẫu `fixtures/auth_fixtures.dart`.
3. Import từ `lib/testing/...` ở cả widget/datasource (trong `lib/features/`)
   lẫn Page Object/flow test (trong `integration_test/`) — không copy giá
   trị bằng tay sang 2 nơi.

Xem `integration_test/README.md` để biết cách các file này được dùng trong
Page Object Model + Patrol.
