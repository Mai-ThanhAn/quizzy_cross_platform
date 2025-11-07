System Architecture (Kiến trúc Hệ thống)
==================================================================================================================
Tài liệu này mô tả các quyết định kỹ thuật về công nghệ, kiến trúc và luồng dữ liệu của hệ thống thi trắc nghiệm đa nền tảng.
==================================================================================================================
1. Tech Stack (Công nghệ sử dụng)
Hệ thống sử dụng mô hình BaaS (Backend-as-a-Service) để tối ưu thời gian phát triển và tập trung vào logic nghiệp vụ phía client.
Frontend (Đa nền tảng): Flutter
Ngôn ngữ: Dart
Lý do: Cho phép phát triển từ một codebase duy nhất (single codebase) cho cả Mobile và Web, giải quyết bài toán phân mảnh trải nghiệm (Problem Statement trong file introduction).
Backend (BaaS): Google Firebase
Firebase Authentication: Xử lý toàn bộ luồng xác thực (đăng nhập, đăng ký, quên mật khẩu) cho cả 3 vai trò (Student, Lecturer, Super Admin).
Firebase Firestore: Cơ sở dữ liệu NoSQL-dạng tài liệu (document-based), dùng để lưu trữ toàn bộ dữ liệu nghiệp vụ (thông tin người dùng, ngân hàng câu hỏi, lớp học, bài kiểm tra, và kết quả bài làm).
==================================================================================================================
2. Deployment Target (Mục tiêu triển khai)
Dựa trên phân tích yêu cầu (file actors), hệ thống sẽ được build ra 2 nền tảng chính từ codebase Flutter, nhắm đến các đối tượng người dùng cụ thể:
Mobile App (Android/iOS): Ưu tiên cho Sinh Viên (Student).
Mục đích: Tập trung vào trải nghiệm làm bài thi nhanh gọn, tiện lợi, nhận thông báo.
Web App: Ưu tiên cho Giảng Viên (Lecturer) và Super Admin.
Mục đích: Cung cấp không gian quản trị với màn hình lớn, thuận tiện cho việc nhập liệu (quản lý ngân hàng câu hỏi) và xem báo cáo, quản lý kết quả.
==================================================================================================================
3. Architectural Style (Kiến trúc Lớp Ứng dụng)
Kiến trúc phía client (Flutter) sẽ tuân thủ theo mô hình MVVM (Model-View-ViewModel) để đảm bảo sự phân tách rõ ràng các lớp (Separation of Concerns).
Model: Đại diện cho các cấu trúc dữ liệu (Data Models) của ứng dụng, được ánh xạ trực tiếp từ các collections trên Firestore.
Ví dụ: UserModel, QuizModel, ClassModel, ResultModel.
View: Lớp giao diện người dùng (UI), được xây dựng bằng các Widgets của Flutter. Lớp này chỉ có nhiệm vụ hiển thị dữ liệu và nhận tương tác từ người dùng.
Ví dụ: LoginScreen, QuizTakingScreen, ResultManagementScreen.
ViewModel: Cung cấp dữ liệu và logic nghiệp vụ cho View. Nó xử lý các tương tác của người dùng, quản lý trạng thái (State Management), và giao tiếp với các dịch vụ (như Firebase) để lấy hoặc đẩy dữ liệu.
==================================================================================================================
4. Data Flow (Tóm lược Luồng Dữ liệu)
Dưới đây là tóm lược luồng dữ liệu cho kịch bản cốt lõi: "Sinh viên làm bài và Giảng viên xem kết quả".
[Xác thực] Người dùng (Sinh viên/Giảng viên) mở ứng dụng. Ứng dụng liên hệ Firebase Authentication để xác thực thông tin đăng nhập.
[Tải dữ liệu]
Sinh Viên (từ Mobile) tải danh sách bài kiểm tra (Quiz) được gán cho lớp của mình từ Firebase Firestore.
Giảng Viên (từ Web) tải danh sách lớp học, ngân hàng câu hỏi từ Firestore.
[Làm bài] Khi Sinh Viên bắt đầu làm bài (kích hoạt UC-STU09), ứng dụng (ViewModel) quản lý trạng thái (state) của bài làm (bộ đếm thời gian, các câu trả lời đã chọn) ngay trên client.
[Nộp bài] Khi Sinh Viên nộp bài (hoặc hết giờ - UC-STU10), ViewModel sẽ đóng gói kết quả và ghi (Write) một tài liệu (result) mới vào Firestore.
[Xem kết quả] Giảng Viên (từ Web) thực hiện (UC-TEA18), ứng dụng sẽ tải (Read) tài liệu result mà Sinh Viên vừa ghi vào Firestore để hiển thị lên giao diện quản trị.