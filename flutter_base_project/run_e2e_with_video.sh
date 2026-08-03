#!/usr/bin/env bash
#
# Chạy 1 flow e2e (integration_test/flows/*.dart) qua `flutter drive` và quay
# video màn hình song song — dùng để đính kèm bằng chứng hình ảnh + video khi
# báo cáo kết quả test, ngoài report ảnh HTML mà test_driver/integration_test.dart
# đã tự sinh ra (integration_test/reports/<run>/report.html).
#
# Yêu cầu: thiết bị đích là iOS Simulator (dùng `xcrun simctl io recordVideo`)
# hoặc Android emulator/device (dùng `adb shell screenrecord`). Cả 2 đều chỉ
# ghi được layer hệ điều hành, không cần code app hỗ trợ gì thêm.
#
# Cách dùng:
#   ./run_e2e_with_video.sh <device-id> [target-test-file]
#
# Ví dụ:
#   ./run_e2e_with_video.sh 00008120-XXXX integration_test/flows/login_flow_test.dart

set -euo pipefail

DEVICE_ID="${1:?Thiếu device id — chạy 'flutter devices' để xem danh sách}"
TARGET="${2:-integration_test/flows/login_flow_test.dart}"

RUN_STAMP="$(date +%Y%m%d-%H%M%S)"
REPORT_DIR="integration_test/reports/${RUN_STAMP}"
VIDEO_PATH="${REPORT_DIR}/e2e.mp4"
mkdir -p "${REPORT_DIR}"

echo "==> Target: ${TARGET}"
echo "==> Device: ${DEVICE_ID}"
echo "==> Video sẽ lưu tại: ${VIDEO_PATH}"

if xcrun simctl list devices | grep -q "${DEVICE_ID}"; then
  # ── iOS Simulator ──────────────────────────────────────────────────────
  xcrun simctl io "${DEVICE_ID}" recordVideo "${VIDEO_PATH}" &
  RECORDER_PID=$!
  # recordVideo cần vài trăm ms để bắt đầu ghi trước khi app khởi động
  sleep 1

  set +e
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target="${TARGET}" \
    -d "${DEVICE_ID}"
  DRIVE_EXIT=$?
  set -e

  # Dừng recordVideo bằng SIGINT để nó tự finalize file mp4 đúng cách
  kill -INT "${RECORDER_PID}" 2>/dev/null || true
  wait "${RECORDER_PID}" 2>/dev/null || true
else
  # ── Android emulator/device ────────────────────────────────────────────
  adb -s "${DEVICE_ID}" shell screenrecord /sdcard/e2e.mp4 &
  RECORDER_PID=$!
  sleep 1

  set +e
  flutter drive \
    --driver=test_driver/integration_test.dart \
    --target="${TARGET}" \
    -d "${DEVICE_ID}"
  DRIVE_EXIT=$?
  set -e

  kill -INT "${RECORDER_PID}" 2>/dev/null || true
  wait "${RECORDER_PID}" 2>/dev/null || true
  sleep 1
  adb -s "${DEVICE_ID}" pull /sdcard/e2e.mp4 "${VIDEO_PATH}"
  adb -s "${DEVICE_ID}" shell rm /sdcard/e2e.mp4
fi

echo "==> Video: ${VIDEO_PATH}"
echo "==> Report ảnh: xem thư mục integration_test/reports/ (được test_driver tự sinh, timestamp riêng)"
exit "${DRIVE_EXIT}"
