# My Health v0.01

App healthcare with chat bot AI support. User can connect to Firebase and wearable devices (Mi Fit, Samsung, ...).

Mục tiêu: Ứng dụng Flutter dùng để quản lý sức khỏe cá nhân, thu thập dữ liệu từ thiết bị đeo, đồng bộ lên Firebase và hỗ trợ tư vấn qua chatbot AI (Gemini / API tương tự).

---

## Tình trạng hiện tại
- Ngôn ngữ chính: Dart (Flutter) và một số mã native Android bằng Kotlin để tích hợp Health Connect / wearable APIs.
- Tính năng cơ bản đã được thiết kế và nhiều module chính đã được triển khai (auth, profile, đồng bộ thiết bị đeo, chat bot, lưu trữ dữ liệu lên Firebase).

---

## Tính năng (chi tiết)
- Xác thực và quản lý người dùng
  - Đăng ký / đăng nhập qua Firebase Authentication
  - Quên mật khẩu / reset email
  - Hồ sơ người dùng (tên, ngày sinh, giới tính, thông tin y tế cơ bản)
- Hồ sơ sức khỏe và chỉ số
  - Ghi và lưu các chỉ số: bước chân, nhịp tim, cân nặng, huyết áp, v.v.
  - Lưu lịch sử chỉ số theo thời gian và hiển thị biểu đồ trend
  - Tính BMI và cảnh báo ngưỡng
- Đồng bộ thiết bị đeo (Wearable integration)
  - Kết nối với thiết bị/ nền tảng: Mi Fit, Samsung Health / Health Connect
  - Module native Android (Kotlin) + PlatformChannel để lấy dữ liệu sức khỏe
  - Yêu cầu quyền runtime (Health, Sensor, Storage nếu cần)
- Chatbot AI (Gemini / external LLM)
  - Giao diện chat, lưu lịch sử hội thoại
  - Service để gửi/nhận message tới API Gemini hoặc endpoint tương tự
- Quản lý thuốc & lịch khám (future)
  - Lưu thuốc, thiết lập nhắc uống
  - Tạo và quản lý cuộc hẹn khám, lịch nhắc
- Lưu trữ file & media (future)
  - Upload/download ảnh/ PDF kết quả xét nghiệm lên Firebase Storage
- Notifications
  - Local notifications cho nhắc thuốc / nhắc lịch
- Đồng bộ & offline (future)
  - Cache cục bộ, sync khi có mạng lên Firestore
- Cấu hình & Privacy (future)
  - Lưu cấu hình user (đơn vị, bật/tắt thông báo)
  - Hướng dẫn để cấu hình rules cho Firestore để bảo vệ dữ liệu

---

## Kiến trúc & vị trí chính trong repo
Kiểm tra các file / thư mục sau để đối chiếu chức năng:
- lib/
  - lib/main.dart
  - lib/core/ — routes, themes, constants
  - lib/features/ — modules (auth, chat, health, profile, etc.)
  - lib/models/ — các model (user, vitals, medication...)
  - lib/services/ — GeminiService, HealthConnectService, FirebaseService
- android/ — phần native (Kotlin) để tích hợp Health Connect / permission handling
- pubspec.yaml — danh sách packages
- firebase_options.dart — cấu hình Firebase do FlutterFire tạo
- .env (sử dụng flutter_dotenv) — lưu API keys nhạy cảm (không commit .env)

---

## Yêu cầu
- Flutter SDK (phiên bản tương thích với project) — kiểm tra `flutter --version`
- Android SDK (để chạy trên thực tế thiết bị Android hoặc emulator)
- Firebase project (Firestore, Auth, Storage)
- (Tùy chọn) API key cho Gemini hoặc LLM tương tự
- Command-line:
  - git, flutter, dart, firebase-tools (nếu sử dụng Firebase CLI)

---

## Cài đặt & cấu hình nhanh
1. Clone repo:
   git clone https://github.com/Flowerf19/my_health_v001.git
   cd my_health_v001

2. Cài package:
   flutter pub get

3. Cấu hình Firebase:
   - Tạo Firebase project và thêm Android/iOS apps.
   - Tải file cấu hình do FlutterFire tạo ra (google-services.json / GoogleService-Info.plist)
   - Nếu repo có `firebase_options.dart`, đảm bảo file này khớp với project của bạn.
   - (Tham khảo) Có thể chạy: flutterfire configure nếu muốn sinh firebase_options.dart mới.

4. Thiết lập biến môi trường:
   - Tạo file `.env` (không commit) với các biến ví dụ:
     GEMINI_API_KEY=your_api_key_here
     FIREBASE_API_KEY=...
   - Package gợi ý: flutter_dotenv

5. Quyền cho Android (Health Connect / sensors):
   - Kiểm tra `AndroidManifest.xml` và cập nhật quyền cần thiết (BODY_SENSORS, ACTIVITY_RECOGNITION, INTERNET,...)
   - Trên Android 12+ bạn có thể cần thiết lập quyền runtime cho Health Connect

---

## Chạy app
- Trên thiết bị/emulator Android:
  flutter run

- Build release:
  flutter build apk
  flutter build appbundle

---

## Gemini / Chatbot (gợi ý cấu hình)
- Đặt API key của bạn vào `.env` (ví dụ GEMINI_API_KEY).
- Kiểm tra `lib/services/gemini_service.dart` (hoặc file tương tự) để biết endpoint và cách gọi.
- Nếu dùng Google Gemini API, đảm bảo đã thiết lập credentials đúng và có quyền truy cập.

---

## Testing & Debug
- Kiểm tra logs:
  flutter run -v
- Nếu gặp lỗi Firebase, kiểm tra:
  - google-services.json / GoogleService-Info.plist đã đúng chưa
  - firebase_options.dart có khớp không
  - Rules trên Firestore có chặn access không

---

## Contribute
Rất hoan nghênh đóng góp:
1. Fork repo
2. Tạo nhánh feature/ten-tinh-nang
3. Commit & push
4. Tạo Pull Request mô tả rõ thay đổi và steps để test

---

## Roadmap (gợi ý)
- Hoàn thiện tích hợp Health Connect & nhiều thiết bị hơn
- Cải thiện chatbot: context-aware health advice, lưu trữ history thông minh
- Thêm đồng bộ thời gian thực, backup & restore
- Tự động phân tích trend và cảnh báo sớm

---

## Tài liệu & nơi kiểm tra mã
- Kiểm tra: `pubspec.yaml`, `lib/`, `android/src/main/kotlin/`, `firebase_options.dart`
- Nếu muốn, mình có thể đọc trực tiếp file trong repo và cập nhật phần "Tính năng đã cài" chính xác theo code (ví dụ liệt kê screens, services, endpoints, và dependencies thực tế).

---

